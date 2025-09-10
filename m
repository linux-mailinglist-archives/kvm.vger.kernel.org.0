Return-Path: <kvm+bounces-57244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8CCCB520C8
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 21:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 590851C27AC1
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F8E2D73A6;
	Wed, 10 Sep 2025 19:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RfNgrym+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189D72D7386
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757531987; cv=none; b=rd8aXqSmCSbmRYzvj/v779kTusz7lcSzomqsxedPpONZhwCWeFbzTFbJYLNZIyJ53pf2zOWN83jD7PWdXSfKa/ksdspbZo/HG1J41iyJ2GZ/DKHbggTQOMHSnyUtiklJ5bXxBIHQN48NWKDdD36sOQHCOkkDuiBmal5InwLKFr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757531987; c=relaxed/simple;
	bh=qWueF42qwhO9/d4nulib23wqx9pkPXKoj4m8Enmbuag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HzbbMa6+JBC2B5KuI1rc2FmY+MGP2OQIoLcu0RqCzW3TrgBN2l77P6FnfHfZzdAjFY8gjOr+06vo7e7+icZ2FQE+2h2MuU8en1rwCeHLoOtLOSCD7kq8XzxVk5hszFNIN8skkkT3cAEq1VvYjVDz2wbkLBSfgnCgB+690/rBlY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RfNgrym+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-772248bb841so12001605b3a.2
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 12:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757531985; x=1758136785; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VN/rggrH4digs9qBWZB1KbUoy16EnGUVMJIJH5xmr7E=;
        b=RfNgrym+tYbAWnYqtJTcZU17SPyOHkyDR4Q5WilKy+MgLEmjCxARjXZRNEeDw+nTOf
         XiRqj5L1LiJ6rHiYlXRxQfeo8paRSrLdnZWx848T7JO1535Dct1jL/7p6+jX+XpFmbxt
         pGgHzWt1iMMUOq/j5hSyN689xrDHYz/vMzvnnEhJZ7Dsu82dCCiVrGidifWSBC25Vr+O
         TBqUqz36L1+1uP9nRnWVP34biDAZdDmV27rEoWKOpRc1jNArTsL6X4FgriH3ZMDTuS1E
         pZnl3LOgiLhyIqFIOf+7OaSnvnVCvcPEVM7JS4LBoU/mvKWpgvgwJCR349lplWoE2/q9
         /WvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757531985; x=1758136785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VN/rggrH4digs9qBWZB1KbUoy16EnGUVMJIJH5xmr7E=;
        b=KD2u7GkuOAxVzpdPYf/57h6hEnEB4yd62PfwQeN1AWfBxSDx1njXmNu/p1YWuzDQPo
         yzjasIYC7lfxZGdx+OQthYn/gfgvd2vfVNi3dTsB9vO4muD1MAeeYbINZPm3le0YQ9UA
         ui3zsNGTe1f3ycjSaNMhNcrw96WyhI+Szm0+rCKwKHdK2YUA5/VJixTAfdQaWK9zr7Pk
         w/bx+Bq+c2rKjkA430CqWp5egyoHg1Q1UHLkUjCi63oPg59kiVwQOQnG4mHP1d/01jzr
         0nQsynVo2rpH/j2hCgUwrt6fv7xHk5JWfdwG9t8NOzF408Te4lzuK69XC1IMzOnYf3vN
         1z2A==
X-Gm-Message-State: AOJu0YziHHEOn+SBkXaYfYSt2oPYRpZ255bUxM4KUjAxBlnAj8OOgoj9
	c/5rhm2Epcr0aeykUmXadD1mUeRH6CzhLlSGEt6ZzBIb+c84xSDeNYFwic5Q3H79ItAmV9HlHdy
	UHPz57g==
X-Google-Smtp-Source: AGHT+IHX7UynOVRpi3If/F9N5K/tO9bGneP/KTRE0HxApIqGpBDwKgUOwjvsvvWc3ktK/GVAM4OFjpZif2s=
X-Received: from pfqr14.prod.google.com ([2002:aa7:9ece:0:b0:772:750f:4e23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d9c:b0:245:fdeb:d264
 with SMTP id adf61e73a8af0-2533e576707mr26771465637.12.1757531985441; Wed, 10
 Sep 2025 12:19:45 -0700 (PDT)
Date: Wed, 10 Sep 2025 12:19:43 -0700
In-Reply-To: <ad3dfe758bdd63256a32d9c626b8fbcb2390f26e.1755897933.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755897933.git.thomas.lendacky@amd.com> <ad3dfe758bdd63256a32d9c626b8fbcb2390f26e.1755897933.git.thomas.lendacky@amd.com>
Message-ID: <aMHPT4AbJrGRNv05@google.com>
Subject: Re: [RFC PATCH 1/4] KVM: SEV: Publish supported SEV-SNP policy bits
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 22, 2025, Tom Lendacky wrote:
> Define the set of policy bits that KVM currently knows as not requiring
> any implementation support within KVM. Provide this value to userspace
> via the KVM_GET_DEVICE_ATTR ioctl.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/svm/sev.c          | 11 ++++++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 0f15d683817d..90e9c4551fa6 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -468,6 +468,7 @@ struct kvm_sync_regs {
>  /* vendor-specific groups and attributes for system fd */
>  #define KVM_X86_GRP_SEV			1
>  #  define KVM_X86_SEV_VMSA_FEATURES	0
> +#  define KVM_X86_SNP_POLICY_BITS	1
>  
>  struct kvm_vmx_nested_state_data {
>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2fbdebf79fbb..7e6ce092628a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -78,6 +78,8 @@ static u64 sev_supported_vmsa_features;
>  					 SNP_POLICY_MASK_DEBUG		| \
>  					 SNP_POLICY_MASK_SINGLE_SOCKET)
>  
> +static u64 snp_supported_policy_bits;

This can be __ro_after_init.  Hmm, off topic, but I bet we can give most of the
variables confifugred by sev_hardware_setup() the same treatment.  And really
off topic, I have a patch somewhere to convert a bunch of KVM variables from
__read_mostly to __ro_after_init...

