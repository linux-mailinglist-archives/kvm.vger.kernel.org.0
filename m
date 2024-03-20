Return-Path: <kvm+bounces-12273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C5A44880EA5
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:33:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E7D01F23261
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458E823A8;
	Wed, 20 Mar 2024 09:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DxoopooN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE08E39FFF
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710927194; cv=none; b=mtcDj4Ho/x9hF6a8Ow6eg2pBTonsI+4Q3mgBVswIkqiNNC3vr2SX2A3m0G9LZwLtUyTgbnmewTxY9vR062s+1WzuLDOYnihsa3mXg6ddsZhy1+BmqVH5wMgFQSJizoe4c4jZckZNT4CunaYT0cAllHs3UxlGf9sfH7meVJF4Voc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710927194; c=relaxed/simple;
	bh=ClcXod7tTNptpAj4/4D4FAPqwR0rK6l6UdgnnphRUgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O3pt+PSIGCcB7HqrPiY96HazRSkErOUbGPDNLquDVE+8Ii1lwgqtvITvYxUSnoHmrLZjmjRsNzRPUKj7M0M5TTY1PFDbJ1DpVyl4G6CeKG29M4BNo/zC4n6IeClrti6/VTpv5Vutl87u/Uzs4mvgbglmc2fWCK4i8vQO1IN11yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DxoopooN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710927191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=th52bfC6LCFFNLFEwwaZwkFyfyLJ9ZK4d36Pw1IlIDU=;
	b=DxoopooNsEP1xJxFspnjDZ1AaDOalmmVVXl0UL91mBCJk54KI6fMOL9x7F1XRdQdBTEo+3
	16T6KVpbDdYtYl1wk0IEkxOfCA3iIoQAj18pCx1PbmfHlbvNW6WvcIdNSx3HH/AJ+drOi8
	Eac9Gy0W7E2ZTyFRSkbsx1a2JjAUCU4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675--bWDhBL5MxOxtehE5kfDdA-1; Wed, 20 Mar 2024 05:33:08 -0400
X-MC-Unique: -bWDhBL5MxOxtehE5kfDdA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a4698fc37dfso298655566b.2
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 02:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710927187; x=1711531987;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=th52bfC6LCFFNLFEwwaZwkFyfyLJ9ZK4d36Pw1IlIDU=;
        b=mu1PbBFQz0dASdrV5rSNV+44mmgM1zymxteHI3w6BLztdU5a9q380nV4OtPuG1Fg5q
         NYc3QRXsKH8GU8KYdW9QKmBaF13Nf6aaE6j8kNNhX8Nswib0/0c60ILaAWFg7cuKSovh
         ByLV+aCL0QC+L40+5lpuYPxcoxgLlh20IUDZ6MIRbBIkhcr8xusZ7IgSwAVz2U+lM7+U
         bFBfW2FbCpr/UgqjPHUonfrHHRswZQz9n0cbup+mVq4oEPfZOzr/xSswiWnUB9OcPbtT
         gMGQmpoWtP09Us3iqYfKCPnq12Hg9yv88aBwA/sRfrvmPgHLB/J2clzzHl2sVA49OXOm
         C9Yg==
X-Gm-Message-State: AOJu0Yyh7W7krcEvac0Nox7nb8EI0mvKkBH/gzq3c/I/mliHkHtTd0n3
	vljCwJ4BVlSoulLK7fkH3C7aqfC+C9pzU4kWEHM0DN620GrdRFQCB1Mwrp2gs3+3QG/SeKgf+Lu
	CrzrGK/8J/OR7aK9R7LA3Y0gh5gtZHKGT6EIW+8J3LyvR60jgDg==
X-Received: by 2002:a17:906:2acf:b0:a46:efe6:40b with SMTP id m15-20020a1709062acf00b00a46efe6040bmr1151065eje.24.1710927187724;
        Wed, 20 Mar 2024 02:33:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsyBkSiUii2DxnglBCUyZ7+j2fZ4op1TOtiUIDlLIm2EyyBwLSs22FP+e7Ip18OluO+/aIHQ==
X-Received: by 2002:a17:906:2acf:b0:a46:efe6:40b with SMTP id m15-20020a1709062acf00b00a46efe6040bmr1151048eje.24.1710927187312;
        Wed, 20 Mar 2024 02:33:07 -0700 (PDT)
Received: from [192.168.10.118] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id wt1-20020a170906ee8100b00a46bef6f920sm3294036ejb.102.2024.03.20.02.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 02:33:06 -0700 (PDT)
Message-ID: <8c0ac9cc-b180-48ca-9843-1866e873ce7d@redhat.com>
Date: Wed, 20 Mar 2024 10:33:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 24/49] target/i386: Add handling for KVM_X86_SNP_VM VM
 type
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-25-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240320083945.991426-25-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:39, Michael Roth wrote:
> An SNP VM requires VM type KVM_X86_SNP_VM to be passed to
> kvm_ioctl(KVM_CREATE_VM). Add it to the list of supported VM types, and
> return it appropriately via X86ConfidentialGuestClass->kvm_type().
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   target/i386/kvm/kvm.c |  1 +
>   target/i386/sev.c     | 10 ++++++++--
>   2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index e109648f26..59e9048e61 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -164,6 +164,7 @@ static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
>   
>   static const char *vm_type_name[] = {
>       [KVM_X86_DEFAULT_VM] = "default",
> +    [KVM_X86_SNP_VM] = "snp"
>   };
>   
>   bool kvm_is_vm_type_supported(int type)
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 2eb13ba639..61af312a11 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -853,14 +853,20 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
>   static int sev_kvm_type(X86ConfidentialGuest *cg)
>   {
>       SevCommonState *sev_common = SEV_COMMON(cg);
> -    SevGuestState *sev_guest = SEV_GUEST(sev_common);
>       int kvm_type;
>   
>       if (sev_common->kvm_type != -1) {
>           goto out;
>       }
>   
> -    kvm_type = (sev_guest->policy & SEV_POLICY_ES) ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
> +    if (sev_snp_enabled()) {
> +        kvm_type = KVM_X86_SNP_VM;
> +    } else if (sev_es_enabled()) {
> +        kvm_type = KVM_X86_SEV_ES_VM;
> +    } else {
> +        kvm_type = KVM_X86_SEV_VM;
> +    }

I don't really like this, the kvm_type method can be implemented 
separately in sev-guest and sev-snp-guest.

This is for two reasons:

1) it makes sev_kvm_type self-contained, instead of poking in 
current_machine via sev_*_enabled()

2) sev-snp-guest can just return KVM_X86_SNP_VM, relying on the "vm type 
supported" checks from common target/i386/kvm/kvm.c code.  Instead, 
sev-guest has to check kvm_is_vm_type_supported() in order to support 
the legacy ioctls (and that is why my patches didn't add the SEV/SEV-ES 
types to vm_type_name[], too).

Thanks,

Paolo

> +
>       if (kvm_is_vm_type_supported(kvm_type)) {
>           sev_common->kvm_type = kvm_type;
>       } else {


