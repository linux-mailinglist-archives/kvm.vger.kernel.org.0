Return-Path: <kvm+bounces-20114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54408910A5C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ECAB282729
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CF41ABCAC;
	Thu, 20 Jun 2024 15:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MZhLnDbv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31341CAAD
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898401; cv=none; b=G3TAJ4Br3aBkgm3SoFdOQ14uO2Rlox3zlxuK+DSrZx+BnwnmMD4P2IE3Fliol63P7GJE5aBOkiF3TGkHw/gYSesxrx492w6a/T9H3FA6wradSMRMF4OUTPVrnxixLv+u5j784zlp3I2TVU3J1n/aPyembpArcQsBaRF4CZJv3Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898401; c=relaxed/simple;
	bh=uF6C7gHFKrkBYo6xSl1ge0QDwxr5Plvds6Mu7amm89o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=C4o7WeVCELB6ndhAQC6fJQcdJujW19zJOsC40Q6gzSWv74RB9XE8sDCOdmzQEjWi3i3UACcvbCn4SE3NwV+5uGO1fAJEk131gWWl382lAkAVwKo6G1eaMTBwpvhZAjvFme3XVRWKqSN3M51OaFNUGmSUCZbznZzRkn8UcnOZxaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MZhLnDbv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718898398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uF6C7gHFKrkBYo6xSl1ge0QDwxr5Plvds6Mu7amm89o=;
	b=MZhLnDbvnFwHmnc5odMTMQF6Kq+3smlr8293FPBGb9PDdUxpRZaG7nFK+lvgxYFYaeT7Cv
	ql3g/77W0nseEqN5Y9e7tU6m7tgUAkRmhSW2sODUP1i9p+Nn1HHY+r8JB8Hfgffo8SVCAz
	N7KisAT4S/6DPCcKYAAtbmJ6fv2JD1s=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-SaluxGVKNfG81gE6k_DY9g-1; Thu, 20 Jun 2024 11:46:36 -0400
X-MC-Unique: SaluxGVKNfG81gE6k_DY9g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7955b3dd7b3so123732085a.3
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:46:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718898396; x=1719503196;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uF6C7gHFKrkBYo6xSl1ge0QDwxr5Plvds6Mu7amm89o=;
        b=AgoZs2KDC8Vq//wA7Oxjs73wHv+ct9LTD/B7YF/d1eGf6DvUXrAE/RQ5yOKWAkS7Ly
         NL24JVeFY14S2EKPPm5X3yblcF5Uh+/9NgbRcB2OWuGmTxbW045Th9ubd6WII2Fa6iRU
         fMNUj4WwD7GUOBjp+3JaadZv4QKgfKM0agI0SnqyAysFzvhkVFGMx3/m4vIcp61TGcmx
         MLfJGbDwe91KAKjhJTOiUjOik45H1dppAvQl6uqkKoPJpSg/pydVFzaQweTAMtzzyxB4
         oflvERabTzDSyJgcyeUsOkkE3D1CsRbfVyHS/b0UWSF4D4wGalWZ3Ogh5IZteUT64ZbO
         q3nA==
X-Forwarded-Encrypted: i=1; AJvYcCXq/tNAuA+QXMtup0o5RDThjawwYmD/wwwngaXbz19jAPmdHbx/P7IEmr8Jmw7euzeq2HHIa0bBU/5knzLQD82ij/wi
X-Gm-Message-State: AOJu0YwPMohfPkQbBRscoFkKSnaBMqDzDokCzR/FxcO4erxCVRcw+4y+
	irXu3NYqahPSsyKcTZFDF9zpNQBFsmmJA3N7x7ZYyYi46rAJIPDVDwJmUR50uORh1Im+th0Jr1Y
	fUjOrkfHtiARR8wLElN17j+PLtrIrw71u6p4HUpRvswTQg1pQnSUfoKAScg==
X-Received: by 2002:a05:620a:2a13:b0:797:b319:c3a2 with SMTP id af79cd13be357-79bb3e61a76mr660858085a.39.1718898395870;
        Thu, 20 Jun 2024 08:46:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvF7kzHhpl3Y2VkCSeY2wlxx6zj8TRfWIMxW0CtZ9BbQCs3ltp2iuNa2jtr+W5mGIVX0RnbQ==
X-Received: by 2002:a05:620a:2a13:b0:797:b319:c3a2 with SMTP id af79cd13be357-79bb3e61a76mr660856185a.39.1718898395486;
        Thu, 20 Jun 2024 08:46:35 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-441ef4eefaesm75726391cf.21.2024.06.20.08.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:46:35 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:46:31 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v5 04/10] KVM: arm64: Add helper for writing ID regs
In-Reply-To: <20240619174036.483943-5-oliver.upton@linux.dev>
Message-ID: <2997a6e4-d60f-623e-e3bb-72e458456dbb@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <20240619174036.483943-5-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 19 Jun 2024, Oliver Upton wrote:
> Replace the remaining usage of IDREG() with a new helper for setting the
> value of a feature ID register, with the benefit of cramming in some
> extra sanity checks.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


