Return-Path: <kvm+bounces-20604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D37A291A5BA
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 13:54:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64FABB25DA8
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A89614F9E9;
	Thu, 27 Jun 2024 11:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IbfVoKv5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254CF14F138
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 11:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719489222; cv=none; b=RIM1AEunGhmO3Foruw4TbjfYqdFXwmcsVuyjiNT50PrrYY8Km4HVkkxzj8mSmJqPfIpp1VN1eE0Qnj66SgGJd44ITNAO0qlUmvfUaFFJXKbStUvBVeGao9s9CaJSb+LwmJuyhGqN5FrPMGZwZZJCkqak9sM2pBnJVT/XbqJzTWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719489222; c=relaxed/simple;
	bh=WpnKLjyFgPP+Ets9M+udfSNPE/YG1Fx4YKF8lUJWlY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aq4FRBHAnZC4LhE6Yy0hEPc842Hu+JcYst8E9/NcFxGP11GahfEKwcJEWYzeQ45Hv/Jdfpj9sMus0/Jt5J+GhDxVDlK3adKGRCYwVVewoWfBg9WgbSCutRGWeqHBOF4PL+SsNrnoVn7QUHsxe5Cc+gCWLHjkVuS3ebEl54TNS7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IbfVoKv5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719489220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WpnKLjyFgPP+Ets9M+udfSNPE/YG1Fx4YKF8lUJWlY4=;
	b=IbfVoKv5v8OVGaYOvyDTOvSkRIxYkezon5TUapUit8B5eJVqRP67B9qcuc8a3CQHLsU+J8
	pDcZ7sr1jsUn5yHELSxHaLc2s2Zt3P5qCcvSx73+6vSBZtYo2ijXt2JChG2NGkD3GAN39G
	EfxI+X6V3CZVB5nkDS5MXz81R8zM+Qs=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-c9UY6dRbMzixakLzSqBJAw-1; Thu, 27 Jun 2024 07:53:38 -0400
X-MC-Unique: c9UY6dRbMzixakLzSqBJAw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2ecb37356edso17007031fa.2
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 04:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719489217; x=1720094017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WpnKLjyFgPP+Ets9M+udfSNPE/YG1Fx4YKF8lUJWlY4=;
        b=tNHudIWLj6BImpkTyyL7idPYt/sAGnVBXGWoC5ebhQApl/BKUfWpgYPiALQIegCeld
         +AjHEgaX/U4HXtMVat1zRozgdVyicFQ6emewZpsUS1VhMRLdZ2HGBTW6Lv37naH+9WXI
         Sz9YbMMxk+z1i6D9DZDHd4JvvorpHeoZCNAboOiqkj0XVvxmsN9Xpmh5TixBi0QdntqK
         wV9sHtxvyIVZqkAjT9Pi6s3Nk4fVIFTPNqm1QslA3+dWUhvl58LxbY9PUw16uaxr/yDw
         /9u3kP+tUagBWJZ6LRnArq39jdcA3ZuYxEKkVeLt/gQirpjXAupKoOUWIaLheKN7rdMc
         Ga3w==
X-Forwarded-Encrypted: i=1; AJvYcCXYGpzhSZKNmq2uIM95eCaGKYszYXSWzzpDvEWEw2sWAaG0lROp/pZ0ghLlKGiUfCoW4/B4xRtyXR2MhE2PlxJMn5E+
X-Gm-Message-State: AOJu0Yx+JyDoPwMBXi7pZNo71Wr55uHFR8qettVmroJl9ykYhURiRHfJ
	wENTr/RbBeDmYbCxZzOCohgFWFElqP6TXqr7eZupnXELWJBWGhCe/LLN0X0SO/DgUPEEBTSVCsq
	u5TYX6rpTptFzFuKO2GNvP97CEnAp/Twx2usGZKo8MP1uSKDGO36Yh1ClbxlKRsg4ygAjpJ25e8
	1SixY20J/2tTTgOKtt/ezEQ5hG
X-Received: by 2002:a05:6512:3e24:b0:52c:dff5:8087 with SMTP id 2adb3069b0e04-52ce185f998mr10037869e87.51.1719489217128;
        Thu, 27 Jun 2024 04:53:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVZkch36jx3t2rXBnTt/tJtT34J4upClKCoBSCjCIfxSyDf5KG5q2i5WyOx4vaWFRZaf6v+qOWumAAXaDaRXM=
X-Received: by 2002:a05:6512:3e24:b0:52c:dff5:8087 with SMTP id
 2adb3069b0e04-52ce185f998mr10037850e87.51.1719489216776; Thu, 27 Jun 2024
 04:53:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240624095902.29375-1-schlameuss@linux.ibm.com>
In-Reply-To: <20240624095902.29375-1-schlameuss@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 27 Jun 2024 13:53:24 +0200
Message-ID: <CABgObfYxZZdwe94u7OvHPUx+u4fDEJLnBEQbk1hdYs_Zy0D2hA@mail.gmail.com>
Subject: Re: [PATCH] s390/kvm: Reject memory region operations for ucontrol VMs
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 11:59=E2=80=AFAM Christoph Schlameuss
<schlameuss@linux.ibm.com> wrote:
>
> This change rejects the KVM_SET_USER_MEMORY_REGION and
> KVM_SET_USER_MEMORY_REGION2 ioctls when called on a ucontrol VM.
> This is neccessary since ucontrol VMs have kvm->arch.gmap set to 0 and
> would thus result in a null pointer dereference further in.
> Memory management needs to be performed in userspace and using the
> ioctls KVM_S390_UCAS_MAP and KVM_S390_UCAS_UNMAP.
>
> Also improve s390 specific documentation for KVM_SET_USER_MEMORY_REGION
> and KVM_SET_USER_MEMORY_REGION2.

Would be nice to have a selftest for ucontrol VMs, too... just saying :)

Paolo


