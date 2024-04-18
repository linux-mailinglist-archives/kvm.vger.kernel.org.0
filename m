Return-Path: <kvm+bounces-15041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32DFF8A900D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E34002820E5
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3272259C;
	Thu, 18 Apr 2024 00:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZxTH9qSh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A02628
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 00:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713400327; cv=none; b=M6Niy3zbgyMcMFGG3yK0wJHKMPez/fuhLjgplnl+vNR/9SzcRxrPv6iyEG7pNpF++FRz1FmS4nFSPkEgdckgMB/S0RA2bPJJvdB/ESyoNk6IgnFCJaFptxTQBz5HK4XjhbjaQzrGVEfKDvBWw5DKikIO28pXy5zKm1uk2g4sPE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713400327; c=relaxed/simple;
	bh=f+jD+epNtwhtMfCuuI3QOEZOmFv228ffTSWKY8h6LwI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=MmEdm9r29ixM131ox22FQzD2uIaD5zl8rtcgs1+h1J14aCEgrCPu0DApyaJ+BSC/2b4yPTj7YKTGfH7t9RCuXXju2vtrCyth2jUrwsodFlD8G2z3tQ2NySETEj/NX2tyr18UskNwji7ONOn0PvhjbwoCbPwQeC/GplcZTDUNjGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZxTH9qSh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713400324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ftopLKdLaUkjZZc9zSGZOxukCL07Uh+MIUdVJv2mP3o=;
	b=ZxTH9qSh61IayLQqgPXLOq5yTlBXnIWLniEznecVRP3M0XYtIBhmxsMc0lRauhhjm99j0u
	2x6gwP4sEsk40Wc9eo+S6Ldk4YUnQf3HLNVYxfnSi49C4OD0a5QClqe+FFyHNsjq8tl1xv
	kr6R4KfUdLMRw3XECpocQuGlJAPdICc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-i04mg5GPNaOwsyzLmnxRWw-1; Wed, 17 Apr 2024 20:32:02 -0400
X-MC-Unique: i04mg5GPNaOwsyzLmnxRWw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a524b774e39so33463866b.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 17:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713400321; x=1714005121;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ftopLKdLaUkjZZc9zSGZOxukCL07Uh+MIUdVJv2mP3o=;
        b=k0NDepJ0TesHG9wXq3WGQswn4dWrD0UlKrdmvtJipWBjLaE1YP8Ik5AwW0LjBaEXJS
         iOROayG7hBS9RuFduOoOq5SCYjIT8oKZCdWi1ne6nP/hhzvElUmKbQnpzGzYTBWuBvBZ
         K4tmOTd7jbbhiFGQzF29SjOIBVmrvzB7QMzBI/05lll8eoUrsy2bK3Gsx0xt0oSiQ7jg
         JBzLr+rqsUz3jJAf96qCbC9rGAqKtW2nPp1RepRB3dhyp4G+fwaNQayq7snLmYjre8I9
         mq/5r4k5fDZ9LggcluqOG6Cif3dI5oRuYPDmUtL+3a+24JuMDqJ7qtSlhC05pM9nMmqO
         mW6A==
X-Forwarded-Encrypted: i=1; AJvYcCUw1jgyV/WrGc/hgWK8Gb4hwYknkChj9IBqjhzVo8kMCrPbIySrrH2weD9dAAt0Om/4ItN46wbGz01QnkMgHH9U7HCE
X-Gm-Message-State: AOJu0Ywpkroh9AGnIK4J3QWQi/Msv9jrryF4vnyM/Wd2KBiI85oYfk4M
	HjcYzuyyfTpvtnJeYxgiNL8x5JWPqiFVeKa8LjwDyaA/pVFva72rwJ+rGlYb492qb+mzXaA3oT8
	O1F/swF4gz3z0ODNe1Z7rir/hXh4/AfeKTwy6TTtiGt9qTPfR/A==
X-Received: by 2002:a17:906:3b13:b0:a55:6c07:1569 with SMTP id g19-20020a1709063b1300b00a556c071569mr438370ejf.0.1713400321400;
        Wed, 17 Apr 2024 17:32:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBqfbDFDBWFJ6N1bRlG2XjxigTMRmDUvyE9ut6OhjAP8LRg6YwgQo0tTxbzkwWZ8uQ7VLH8A==
X-Received: by 2002:a17:906:3b13:b0:a55:6c07:1569 with SMTP id g19-20020a1709063b1300b00a556c071569mr438355ejf.0.1713400321075;
        Wed, 17 Apr 2024 17:32:01 -0700 (PDT)
Received: from [127.0.0.1] ([176.206.84.58])
        by smtp.gmail.com with ESMTPSA id k14-20020a170906128e00b00a525609ae30sm179635ejb.169.2024.04.17.17.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 17:32:00 -0700 (PDT)
Date: Thu, 18 Apr 2024 02:31:58 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com" <seanjc@google.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 0/7] KVM: Guest Memory Pre-Population API
User-Agent: K-9 Mail for Android
In-Reply-To: <65cdc0edae65ae78856fbeef90e77f21e729cf06.camel@intel.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com> <65cdc0edae65ae78856fbeef90e77f21e729cf06.camel@intel.com>
Message-ID: <8245609C-0086-4DF6-8D17-509165F4D87A@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Il 18 aprile 2024 02:01:03 CEST, "Edgecombe, Rick P" <rick=2Ep=2Eedgecombe=
@intel=2Ecom> ha scritto:
>On Wed, 2024-04-17 at 11:34 -0400, Paolo Bonzini wrote:
>>=20
>> Compared to Isaku's v2, I have reduced the scope as much as possible:
>>=20
>> - no vendor-specific hooks
>
>The TDX patches build on this, with the vendor callback looking like:
>
>"
>int tdx_pre_mmu_map_page(struct kvm_vcpu *vcpu,
>			 struct kvm_map_memory *mapping,
>			 u64 *error_code)
>{
>	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(vcpu->kvm);
>	struct kvm *kvm =3D vcpu->kvm;
>
>	if (!to_tdx(vcpu)->initialized)
>		return -EINVAL;
>
>	/* Shared-EPT case */
>	if (!(kvm_is_private_gpa(kvm, mapping->base_address)))
>		return 0;
>
>	/* Once TD is finalized, the initial guest memory is fixed=2E */
>	if (is_td_finalized(kvm_tdx))
>		return -EINVAL;

This is wrong, KVM_MAP_MEMORY should be idempotent=2E But anyway, you can =
post what you have on to of kvm-coco-queue (i=2Ee=2E, adding the hook in yo=
ur patches) and we will sort it out a piece at a time=2E

Paolo

>
>	*error_code =3D TDX_SEPT_PFERR;
>	return 0;
>}
>"
>
>kvm_is_private_gpa() check is already handled in this series=2E
>
>The initialized and finalized checks are nice guard rails for userspace, =
but
>shouldn't be strictly required=2E
>
>The TDX_SEPT_PFERR is (PFERR_WRITE_MASK | PFERR_PRIVATE_ACCESS)=2E The
>PFERR_WRITE_MASK doesn't seem to be required=2E Isaku, what was the inten=
tion?
>
>But, I think maybe we should add a hook back in the TDX series for the gu=
ard
>rails=2E

Paolo


