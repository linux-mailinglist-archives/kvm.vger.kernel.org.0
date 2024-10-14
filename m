Return-Path: <kvm+bounces-28816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3668899D9B5
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 00:19:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7951D2832C7
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 22:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB669159596;
	Mon, 14 Oct 2024 22:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jtZ8UA56"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5D5154C0F
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 22:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728944339; cv=none; b=Vppc6rYhEVPyUXLpIE1O3S3bDND5Qu7usPymMXEtExvc9qaoL37VYNrdFtds43uMiQz/s6i4t5jJ9mKr7oolLkV2oiXSlUvHdrA/dRCZFuXPj/usUySqSouiizQxpLMgUdzpIn894M+b1zoET7ZGClIS5oi1I77GhVD3aDNzFw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728944339; c=relaxed/simple;
	bh=yB3I8uiuIfodLQQg70tjfVrEE4L5/9aX3fHruOdlsDE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S7Qy5xlaJQ/VLupTaS6GNE4QQaehH5qmBkUb6skzBQE8lkC73pk0pPi9bgyL/uBkf/u3CVqZTIAKOvbfoXrBhmezikR/tiGWqGHfKDU97vUOSpsq4gNsfVU/m33RjSY25jIMlDwAQIaRBTbCnx4nn4QAZnE+t2eSAECLLoq6JPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jtZ8UA56; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e38562155bso15123167b3.1
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 15:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728944336; x=1729549136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TY1Bpkrr53yL83DAOoYM0CZgNHKv6sxwoJKshYPV+pQ=;
        b=jtZ8UA56LYCq1zl3D0FTWT/JxEWYjpCNRNA+vpxMPpbG/Xal10G60URayiLuVYbPYZ
         gOPj/Cn4vhMsSTsNiE233V7Q3lNAYcjFY/V3D4dVGrvpnYV5Q79779ZnoeWSpe37MdLV
         ZstXtTJH6A0hMQEeqp8UrzL2QH+0srJeBGt4QQzDM0xxrb9LlvXPbtD89dZsGpXx9KDt
         1TiBzJMPeAWiTw/w6uwriZFe1c2yrvjfDTErvPjvsDCVWql9Y34+KL9lfYfXQ7w1EGiL
         CcXwd5OklvQA3Qp2ewWIXpRbSNnxabNhPoengmllurLBz8/wNbNlxHFUA3IlZSJoRABs
         F2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728944336; x=1729549136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TY1Bpkrr53yL83DAOoYM0CZgNHKv6sxwoJKshYPV+pQ=;
        b=ENBKyH/Aqlt9f74OQrK3YmIIivoTvZstl1SJB4dyiqu3AqTCspPKs8CmJSizg3BtGR
         dnXIS3cePZE/x1PTWPI8ONxQPjkKfvzieYjMS0UGjCn3L+eaqnFiSacd3R6JP6XcxyV2
         wHioWGMIyUdyM+TjUpDVap+wzA9J1PKKYHZQ4hJCFkCSlIQxuIp9Ym/yt+1DwPHUx0l7
         piNjjqV67V7CWOsJJoZH7AIlFM02awylrLUauzWxcE2EWp8VSgnejaJrF3cu0kKlspLd
         Ott2UwExZOo7paEppi0hs8kkgfLfOOmUx3VNbHeSPK1TwtuxdGDypYlcl0iQAdfHLMth
         L4zw==
X-Gm-Message-State: AOJu0Yzp8Z4vOSjjFpiK+s/aVh3KXkd6cvhEbsHnRWxtHZJn3Gi4CFX/
	llzQaJFREkbUVsu2IvnVMm5zPGhzZMdByFn7QMBYHKOo3O2AxtI0EGe0Sg55gl9rfxSFWs2pOIK
	Fcg==
X-Google-Smtp-Source: AGHT+IGmKxrngJUuCWLjHKOARMaUFTzc06SCFOqpWBfOT7Q1F3B7SJdXCtSJeIXIUx44V54dolQvTBOidIU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c09:b0:6e2:6f2:efc with SMTP id
 00721157ae682-6e347c52d2emr3662017b3.5.1728944336631; Mon, 14 Oct 2024
 15:18:56 -0700 (PDT)
Date: Mon, 14 Oct 2024 15:18:55 -0700
In-Reply-To: <20240905124107.6954-2-pratikrajesh.sampat@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240905124107.6954-1-pratikrajesh.sampat@amd.com> <20240905124107.6954-2-pratikrajesh.sampat@amd.com>
Message-ID: <Zw2Yz3mOMYggOPKK@google.com>
Subject: Re: [PATCH v3 1/9] KVM: selftests: Decouple SEV ioctls from asserts
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pgonda@google.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 05, 2024, Pratik R. Sampat wrote:
> +static inline int __sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
> +					   uint64_t hva, uint64_t size)
>  {
>  	struct kvm_sev_launch_update_data update_data = {
> -		.uaddr = (unsigned long)addr_gpa2hva(vm, gpa),
> +		.uaddr = hva,
>  		.len = size,
>  	};
>  
> -	vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &update_data);
> +	return __vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &update_data);
> +}
> +
> +static inline void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
> +					  uint64_t hva, uint64_t size)
> +{
> +	int ret = __sev_launch_update_data(vm, gpa, hva, size);
> +
> +	TEST_ASSERT_VM_VCPU_IOCTL(!ret, KVM_SEV_LAUNCH_UPDATE_DATA, ret, vm);
>  }
>  
>  #endif /* SELFTEST_KVM_SEV_H */
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> index e9535ee20b7f..125a72246e09 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/sev.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> @@ -14,15 +14,16 @@
>   * and find the first range, but that's correct because the condition
>   * expression would cause us to quit the loop.
>   */
> -static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)
> +static int encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)

This is all kinds of wrong.  encrypt_region() should never fail.  And by allowing
it to fail, any unexpected failure becomes harder to debug.  It's also a lie,
because sev_register_encrypted_memory() isn't allowed to fail, and I would bet
that most readers would expect _that_ call to fail given the name.

The granularity is also poor, and the complete lack of idempotency is going to
be problematic.  E.g. only the first region is actually tested, and if someone
tries to do negative testing on multiple regions, sev_register_encrypted_memory()
will fail due to trying to re-encrypt a region.

__sev_vm_launch_update() has similar issues.  encrypt_region() is allowed to
fail, but its call to KVM_SEV_LAUNCH_UPDATE_VMSA is not.

And peeking ahead, passing an @assert parameter to __test_snp_launch_start() (or
any helper) is a non-starter.  Readers should not have to dive into a helper's
implementation to understand that this

  __test_snp_launch_start(type, policy, 0, true);

is a happy path and this

  ret = __test_snp_launch_start(type, policy, BIT(i), false);

is a sad path.

And re-creating the VM every time is absurdly wasteful.  While performance isn't
a priority for selftests, there's no reason to make everything as slow as possible.

Even just passing the page type to encrypt_region() is confusing.  When the test
is actually going to run the guest, applying ZERO and CPUID types to _all_ pages
is completely nonsensical.

In general, I think trying to reuse the happy path's infrastructure is going to
do more harm than good.  This is what I was trying to get at in my feedback for
the previous version.

For negative tests, I would honestly say development them "from scratch", i.e.
deliberately don't reuse the existing SEV-MEM/ES infrastructure.  It'll require
more copy+paste to get rolling, but I suspect that the end result will be less
churn and far easier to read.

