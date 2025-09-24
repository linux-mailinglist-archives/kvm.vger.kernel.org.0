Return-Path: <kvm+bounces-58603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF79B97F3B
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 02:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 475804A8291
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 00:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0271EE7C6;
	Wed, 24 Sep 2025 00:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dz6GdD59"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FD31DCB09
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 00:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758675267; cv=none; b=sO7DZVCDraxpTNLyY+L64gfbIl7GYImamjR4OC83nr2r1d7+sERVzZW3vfnPqe9Lt8moHtIyoQWbqSNpRfJ0F0peyTB7ceE+VbCsEVEasMlaFegQJuka9Z/8eKlCcGehk8FjE9lOP+HlcC6j79r0naetPBSfcLbPXQmLMof/LN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758675267; c=relaxed/simple;
	bh=v4t0XEY19ig96vtXWrbtL/pFwHwKfnwuWWleF5TfQQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AzwyfQdD1gExvxKEw3AX0Iae/3jgHKDa7T+ZnR08nKxV3cBwKJKqjCzTF7Sz74a6fO8MSBFPtIhobulXliRmw/Bt+NXFWiEk3NvDTID7p6ejAEVLg8dVLsRl+Se3FD8tEqtZtvit7uBG7mG6CyTHj7OLSwqmp8ocN2HdZv/EjDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dz6GdD59; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758675265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v4t0XEY19ig96vtXWrbtL/pFwHwKfnwuWWleF5TfQQQ=;
	b=dz6GdD59qD3tr5sDbSnau6vZT4emJ+tuI/F1JcaxJDP5nCbaKYQl+ziKjfsTY17l1wO6Fa
	lfPq2p6cmmJDYzLAXmrmSw1/hiJX0d+fVLgvn7VkJN8zRRbMuHu/Yxjf+XhtbyD8IELD73
	mmfwARlAXdwg2vMgthTGskP8f6FQ+Ps=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-c56wprTKNGWxAFa4kRPUtg-1; Tue, 23 Sep 2025 20:54:22 -0400
X-MC-Unique: c56wprTKNGWxAFa4kRPUtg-1
X-Mimecast-MFC-AGG-ID: c56wprTKNGWxAFa4kRPUtg_1758675261
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-32eb18b5500so9893564a91.2
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 17:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758675261; x=1759280061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v4t0XEY19ig96vtXWrbtL/pFwHwKfnwuWWleF5TfQQQ=;
        b=IG2KtQFHtx+7Eqksi6MSI47lLxmIgJB44Mj3wStohwAzAf4io0zlIm7DAGra4IuYku
         0tjW0ubD0nQv4T5UuK3HURKSYqpnF4qg6xW4VQ6jRSjCvXs/wvff39shUZ2Gx2TjLk6b
         iN3cQPOqCDR9WuTvtgCE7Mm3F8yuKGRKPBPNplif65lyvne13dZEYBxK22UPC6h2Xx1k
         unbg3K9XIWd5ugDJTo7/3oPZ6AMKg48v1aQkEr8BV3sPwEh3fBSyIqHQoOYjqOMlUnmD
         fKopplB2nJ62NfVWHecu8FWrRIiQG7IYa8qb3vhgE23LHMRq1C3StxJ20Uvi+9Khxqo6
         zo5w==
X-Forwarded-Encrypted: i=1; AJvYcCVFrlLPfDekNZNXRxpv9xxAw/hvXAzQrcj11yFK4mm6bAbjwLvCJZqMZnYEiq6wEleMQ4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5b/IaUwbxXw3gOQjNl0397PoTuBep334SYVID40eOzFuBxwv7
	iMSCuvNfe/SbtEqYSxBdnE9JWUD7yGohiN6kpYaRwgIyzhZ0PEOdgqtM1tiweyIX3xifWRXLUJd
	wEKAlHezOANdiNlfzJv1pwOSlQ9Az8PFlXaNcfTQbDGYfZ36dOZvkIr9GFz/Ei5xnNh0AREidwC
	j0awxDlwA/SXpNLA3RQO2tbvjTy+fP
X-Gm-Gg: ASbGncs8X/qV61DS4DAZzIVwAXP9AHl3xk1U6msxBbRI9spKEv0P6NAp1VGbDmOKWvo
	EwZJUK6aj0CBtgiMstq7Dv2Mp1lJjWpjEgFLJnKN4zZjrALhc5ce1xllajuxzTGnvaDmPPk0BiA
	AJrMQJVkgi54kxWsYc5A==
X-Received: by 2002:a17:90b:1343:b0:32d:f352:f75c with SMTP id 98e67ed59e1d1-332a9535640mr5034838a91.13.1758675261404;
        Tue, 23 Sep 2025 17:54:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEfQasazQYrAqwbi0RG98kEq9UrRRqH3IBMDr3ithyqZtr8231pYip07BOxHuYxpr8+ga/tswXckGmozrzyuk=
X-Received: by 2002:a17:90b:1343:b0:32d:f352:f75c with SMTP id
 98e67ed59e1d1-332a9535640mr5034815a91.13.1758675260992; Tue, 23 Sep 2025
 17:54:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758664002.git.mst@redhat.com>
In-Reply-To: <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758664002.git.mst@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 24 Sep 2025 08:54:09 +0800
X-Gm-Features: AS18NWDvb7ormS481il9vCXSYhrezOtK7Oc0syIfP-2dUJUzReMkhidld3UC0C0
Message-ID: <CACGkMEtU9YSuJhuHCk=RZ2wyPbb+zYp05jdGp1rtpJx8iRDpXg@mail.gmail.com>
Subject: Re: [PATCH] vhost: vringh: Fix copy_to_iter return value check
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, zhang jiao <zhangjiao2@cmss.chinamobile.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 5:48=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> The return value of copy_to_iter can't be negative, check whether the
> copied length is equal to the requested length instead of checking for
> negative values.
>
> Cc: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> Link: https://lore.kernel.org/all/20250910091739.2999-1-zhangjiao2@cmss.c=
hinamobile.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


