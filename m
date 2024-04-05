Return-Path: <kvm+bounces-13746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4D989A3C9
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 19:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D08F1C21FF5
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 17:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A437172783;
	Fri,  5 Apr 2024 17:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fn2dAkTS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA998171E73
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 17:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712339893; cv=none; b=iTwxMhX81wQMbALZcjY1ViupMIs7lJhXXV4/rfrbLtEnwsyFEYmKF4O+bzRR1psrUzDQUC4YuFNlG2vxTV05BMk3DhFwjJ7eBua6FoPwCKS4uRFXZ+iBVJlEmIi8Equayc+Jnga54s/sGdjlobPaNWfdOECwAN9ZYMdHPHoaa54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712339893; c=relaxed/simple;
	bh=OhLR3iFcGyOMlWUTvWA89GxCLTl14dKyEPs7NecTHTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EcT4fKuMhYxPlrYnnopeZ061f58KVc6DAXj2E0Rya3/v4dDVyhuyyhZY4Toc6SNEM5Ni+EDhkHPioo4fYAYx+NV2SBBhxxcAZ7YywkYCFU5TYqpIlamsPVjRsoP8+Pq89p51EdHA+hHEU5ZT4HPWEVJT8zil0q4or6gRgdzMyZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fn2dAkTS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712339890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OhLR3iFcGyOMlWUTvWA89GxCLTl14dKyEPs7NecTHTU=;
	b=Fn2dAkTSBRv4bPeH8cQwjCXp+2wxT/5/CqQ6AP5Nc8AKlH+LDxedWE2P4u6JCKq1feCsR1
	uQKWJnEoJGZazoTcd1LVqEWAKPsn1lJp8j+CRC3Mn0jBLgYj6U4h4iuupUnFDvIzJlsqGj
	dKOvaOVtwhN8I7YP8j/Bui0Z3R+3wgQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-iwbog4uuNiep3CWTGo-Pug-1; Fri, 05 Apr 2024 13:58:07 -0400
X-MC-Unique: iwbog4uuNiep3CWTGo-Pug-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-343e00c8979so593560f8f.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 10:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712339886; x=1712944686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OhLR3iFcGyOMlWUTvWA89GxCLTl14dKyEPs7NecTHTU=;
        b=DdncMVJL83xxuziZwIOnhNiEr60D7F828ZxQrEfeA+WW+5e2+T3dLTgzCVvpa5C0l5
         GfrWNN95E6SEpM8p2jJJ1sP4ECsRk/vpbievv9mQDoOU/uNoO8V9m2N+HdqDwFiZnSUw
         dZdwuXe8LX73gVdnrbiop2UPFM3YLuYtuBesuUwnDFxV5y/doBmYXdf9pHLBDS1TAbcb
         vUVQUKMi482GphMhO528Hb5VYdzRc9EERReG4KSXzh1AjpBlTIoxjVBISISjEJgx/B12
         nYU3UAyMrbhLVcOlGiL9yp9Pq+A/muzggha0X/X/5QnHNeb3vUWKpI5IjnEJhjzSvZyP
         g7tg==
X-Forwarded-Encrypted: i=1; AJvYcCVLi6au30yntlrsczBqke5JYhr3MnWbGVaRV8B6dEbe1NRcZbMGbS9R4YL/0H0IPdAu6jDlvhsKN/Z3GKi/P5uCCGUO
X-Gm-Message-State: AOJu0YwbqmN8MV+oiH0vaRswfyIQs2UVWbEjTUTZIFpbAyaaEnZ1PnPi
	ok8U0FiXfC+mnWZYun6mJ85ZhrJFli09sZxO701XjRkw2S9Swk5GXekj8muiRhrtgHVrORaQ78p
	GQij4B+poxNBQNAISBqIQSNaoL60bT1B5icyNeHKsCp4D1Cyjbxx6pHNtr/NRI27kRUAJwNwtaA
	W2qbyzgEDTRK0CGE8fBYFkaInL
X-Received: by 2002:a5d:4f0e:0:b0:343:6f88:5e5 with SMTP id c14-20020a5d4f0e000000b003436f8805e5mr1340182wru.55.1712339886048;
        Fri, 05 Apr 2024 10:58:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3CWAbZ2yvXyD8JF17AyMAjvakK2b+OL6J+dTN23cnwf6QWbAXTlTGCRG23eceVxdEZJl2migUhbs+XDvpQjo=
X-Received: by 2002:a5d:4f0e:0:b0:343:6f88:5e5 with SMTP id
 c14-20020a5d4f0e000000b003436f8805e5mr1340171wru.55.1712339885715; Fri, 05
 Apr 2024 10:58:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-14-pbonzini@redhat.com>
 <754f2fcf-fc00-4f89-a17c-a80bbec1e2ff@intel.com>
In-Reply-To: <754f2fcf-fc00-4f89-a17c-a80bbec1e2ff@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 5 Apr 2024 19:57:53 +0200
Message-ID: <CABgObfaGhH1aQyR-k_x=yrSRE3uwDpx9JJoMdiAdJCq72-O4DA@mail.gmail.com>
Subject: Re: [PATCH 13/21] KVM: x86/mmu: Pass around full 64-bit error code
 for KVM page faults
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 9:57=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> wr=
ote:
>
> On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> ...
> > The use of lower_32_bits() moves from kvm_mmu_page_fault() to
> > FNAME(page_fault), since walking is independent of the data in the
> > upper bits of the error code.
>
> Is it a must? I don't see any issue if full u64 error_code is passed to
> FNAME(page_fault) as well.

The full error code *is* passed to kvm_mmu_do_page_fault() and
FNAME(page_fault), it's only dropped when passed to FNAME(walk_addr).

Paolo


