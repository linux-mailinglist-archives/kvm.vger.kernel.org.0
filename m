Return-Path: <kvm+bounces-53885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F82EB19E7E
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 11:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56EF53AAB93
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 09:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7012459DA;
	Mon,  4 Aug 2025 09:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dbvR1xL1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12B324887E
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 09:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754298376; cv=none; b=FSBuN82ZyoEJLKaYJ9Ibvt7uRwUmC4ThHJgKisc6RKcDqHOaXx9F6PDJd2SBifXFML6lvYbtKHIHl8YnEv+H/DnUJ9rT+NCTDALK5aZuIoftKWNkVTgBSbuVrCjhx9G7++zoty9TVMvw0Gn0gOyr6TvhExbcj3tY0TVM0l8HdL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754298376; c=relaxed/simple;
	bh=FC2gKnlK0tlH4AVIjMhG/aH0ST923yLbY61/gTdaWtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PNIuFRkkfGYInmkuAFTpgnVi7haN3v1t2yWauiGO9osW9IJGbBwkl9oeDrF2hv1bpf+wBZcD/iOB6IWERlpRxEYdSIG0bDUv0PIiauwV0R1apnfyahIfmHMsRfoXqycwy6DV04rTmRBqzA1M8AotlOE4fonpgG4SDdh7It7fr84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dbvR1xL1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754298373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FC2gKnlK0tlH4AVIjMhG/aH0ST923yLbY61/gTdaWtU=;
	b=dbvR1xL1qHmdU/YpM0Lsy7XEJd+ZGuGK7D7OOf5JOYgMoITM2+/tgMwUlDlsunMFRef7+L
	AawHKsVO8aXh8I3kxR9DZxIIcwOFy6ONu0oEkCorGFPpbnwoZelE34nHiWVQb0PcQAK4XK
	Yd5Jq9iCjMre2I+ImXJen2aSiMa4gcU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-RahmBSDfO2yFwRRSulkFVA-1; Mon, 04 Aug 2025 05:06:10 -0400
X-MC-Unique: RahmBSDfO2yFwRRSulkFVA-1
X-Mimecast-MFC-AGG-ID: RahmBSDfO2yFwRRSulkFVA_1754298369
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b421b03d498so2129700a12.3
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 02:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754298369; x=1754903169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FC2gKnlK0tlH4AVIjMhG/aH0ST923yLbY61/gTdaWtU=;
        b=BrNcxlBkISPZTPXq+WyqSYl+o5AYEj76TDSXOHz6CQczgump87zVCemyUQ4Fc9Uykj
         iqBmUVA6mh2zvc+5Wc/O4yEKstvVJaedwgdT8GaVMZq0Pz9fjK+lP3C4HNluO8ly0nek
         XNNtKpcG9+I8sh8G9BLCM5Jz6/HCWx6JrhD2K37o8OSbvy4g+8htYs5Ox1QCdvvFrKcS
         +hsRp7Dp07yD6vB18RhmK1SYRIdm1NL6SoRtAsKzi2PomWAe2uwEX/sGXpFtv/XsW6rK
         1nThginyscwTNu65BYMzqjQt4JSU/5nzihKSW0MQk2FmkZ/TyAXbSXhsoHGdXe0l6Zbd
         TuxQ==
X-Gm-Message-State: AOJu0YyPhRNuHA4f0AMiBh/dOWU/RS5WfQuZN6C9+hxwOMk8hqeCG3VC
	kZIa+8v7D93vI0qZiDUvrDHtfLgzTOc+om8eiCaTXDygXvwT7DW1I2a00RHV7jrN7r6vClTZO2h
	3UkY6VqQbpW1OEXsMYIYMAvuDXTozJ6Oyr/MAEcFwb+YA7I7WE3iGOrRke4Wd1cEtPPxrHt4x8b
	qXUtZoDfPyMeiF+X1F1lgAD/6yBQl9
X-Gm-Gg: ASbGncvQe8hQfg/pRYOiXbzUOkNwm35gOSOekd23ykll8B3ifGoXhbblUtZnX3ykOTC
	O94KzZT1Nw+OmJVLpiDmS5tTAaya8v0WqC4GPW3rIUl5RHrzTlzRhQkuKcm8SW9l/wfG/1HGFxj
	umeC03PbU+6l4XxByGSaHOtA==
X-Received: by 2002:a17:902:f552:b0:23f:f983:5ca1 with SMTP id d9443c01a7336-24246f5dfb2mr132550195ad.12.1754298369525;
        Mon, 04 Aug 2025 02:06:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEcYXd+G3MrEs13nVvxY8yeK+0iPt6uzM6BT+j7IwyIkqouuxJCmX+aT/C268Bf+EzVOioFJTajAeAVP8Oj2U=
X-Received: by 2002:a17:902:f552:b0:23f:f983:5ca1 with SMTP id
 d9443c01a7336-24246f5dfb2mr132549655ad.12.1754298369069; Mon, 04 Aug 2025
 02:06:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729073916.80647-1-jasowang@redhat.com>
In-Reply-To: <20250729073916.80647-1-jasowang@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 4 Aug 2025 17:05:57 +0800
X-Gm-Features: Ac12FXy2PpNcxx7Wuo6WWD9onNx5D2Zc4zo6EJWLkWuf_3KiHYfBpugk7fN5otM
Message-ID: <CACGkMEuNx_7Q_Jq+xcE83fwbFa2uVZkrqr0Nx=1pxcZuFkO91w@mail.gmail.com>
Subject: Re: [PATCH] vhost: initialize vq->nheads properly
To: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sgarzare@redhat.com, 
	will@kernel.org, JAEHOON KIM <jhkim@linux.ibm.com>, Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Michael:

On Tue, Jul 29, 2025 at 3:39=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> Commit 7918bb2d19c9 ("vhost: basic in order support") introduces
> vq->nheads to store the number of batched used buffers per used elem
> but it forgets to initialize the vq->nheads to NULL in
> vhost_dev_init() this will cause kfree() that would try to free it
> without be allocated if SET_OWNER is not called.
>
> Reported-by: JAEHOON KIM <jhkim@linux.ibm.com>
> Reported-by: Breno Leitao <leitao@debian.org>
> Fixes: 7918bb2d19c9 ("vhost: basic in order support")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I didn't see this in your pull request.

Thanks


