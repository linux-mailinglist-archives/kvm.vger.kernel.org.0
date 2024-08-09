Return-Path: <kvm+bounces-23705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FAD594D3D7
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:45:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 346951C20E7B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22439198E7A;
	Fri,  9 Aug 2024 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ags7VAjT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA5E18C08
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723218315; cv=none; b=rDQH1dzLsouKYfhQyMnRLXy7FsowMPlUt3MceF4pQ5otOYi3XwZDC3nTwoVyK2yOT/BNhgCHYgfi0OcDBz6eWcxdC+hiL/X00AoZc2jUMJah3DCKdtryBxYUt0LJ6W2t8W4mDfUOi60kF8oTpy+BRknmK0/MFxxO4ZtnkAJBB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723218315; c=relaxed/simple;
	bh=4xKAdAddRSzH31ADhKLaPGKj1tnhAdZ+HE6xwKWHgfw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pAoReWobpfCLKdN8nBw2CJzID8Xwj8Y8/8qx3ZZaUsc3Nl11o4gCXiyqCn6/mNxauN7Han5og2qZnkAS5AcUFBee/ESwZ5RRuwtfJVPPQGfU+D1v2TKU2c60Qx3XC/kpMaxtJkr3LNHJ+OrAvXbLB12/XHiRNIjSrlIhU/U3upw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ags7VAjT; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-690d5456d8aso52603317b3.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 08:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723218313; x=1723823113; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ufzxNYpm833F4D+it9EVre+p13feWMXlScCKKRbhPtg=;
        b=Ags7VAjTEKTy69FBDkWR/XJ5jldPb/DhIGL4gTq7FIeNqV0WdSc28yWvkCj8XOANxF
         1jviKApndwtFJNKzB/hgm9dX3I+3WiWBTREUUHqnAgQazJWQ4YnpZE7U8Kj1ceOuNus5
         WjusSSsDTsAvG7kwQXam1lCgkj9o3bRbdrvkiFkHNNsX/p0oZkulGvXw5TC/QiSJ4pP0
         eRRgiYDxt65JJd0NTTJlWGFG1xjqD1ZDYzz0SNb9FoDrE994jSA+KFGCLe4ryVwg4yUt
         UR8HuqTOUBLSvuV6IDSU0cyXRzM2MRtWtkG1j1nEosOtFmKtKWUb9LIqSD2n2jljhQ3H
         JTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723218313; x=1723823113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ufzxNYpm833F4D+it9EVre+p13feWMXlScCKKRbhPtg=;
        b=VAGTwVjEe143/Fpce9kxwJUQDTl1iAqdQiuK+W91auACYmu7WN0MwzmM4D6JSw6yVF
         Yuo0QAXjxEhLjwS4uo7BIrpejZEivLjdbYMGET5Z3i307v2NUrMtU8yM6hQCmcwS4yq/
         kEmpC2apgBFBE+WdhBluTwEy2xm4CGjOYiVScCoT7dgEerx8cJlShFwBgdgXRQCws9vr
         WDmp++SFTCFX0+NGRcQYMItPo/wnoQP/wE429//jN9+mMsbpEhC/WvzwdOZWw4ZbTp1C
         j6wYUrdE+AXBAmfuSe/kyCXcYDGlTuZ1gaDkt3lgNA2q8eKPsA1yqmPYwHdbitnjLrs9
         EgAA==
X-Forwarded-Encrypted: i=1; AJvYcCUPZ/Onl6cnL8bb/Ipb5lGL0AUIb/kTDOKNhjSzZTEw0MaEh6yg9mJEVefPxGxxovY4cnVjlUEy6FAllPyHn5gUz9K1
X-Gm-Message-State: AOJu0Yz8CWT0vtaURBQih9cH9cb8YKPln3OGCPqb/pqAgozUXjKkGNrU
	rbS6v8J8vaUss9vNK+uEPCvF+1PV0b/OYHwiBxqrL3qzA+P060O1aq2CyXbVaf5/Dk9WunR25S8
	QpA==
X-Google-Smtp-Source: AGHT+IGmKxWqzG8EPgakjna8JtWGPg62vJdK+0Bc2Qodmrlh2F+IyIYu6Pp5IsmyEemyLyeZWsSJxb5C0rY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2f04:b0:65c:1db1:9235 with SMTP id
 00721157ae682-69ebf29b861mr647807b3.0.1723218312835; Fri, 09 Aug 2024
 08:45:12 -0700 (PDT)
Date: Fri, 9 Aug 2024 08:45:11 -0700
In-Reply-To: <98c1f8e2-3b24-49c4-b5fc-506e4283248d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710220540.188239-1-pratikrajesh.sampat@amd.com>
 <20240710220540.188239-4-pratikrajesh.sampat@amd.com> <8870ca39-f5a9-8d33-3372-77a6693ad739@amd.com>
 <98c1f8e2-3b24-49c4-b5fc-506e4283248d@amd.com>
Message-ID: <ZrY5h746smS4j5ak@google.com>
Subject: Re: [RFC 3/5] selftests: KVM: SEV IOCTL test
From: Sean Christopherson <seanjc@google.com>
To: Pratik Rajesh Sampat <pratikrajesh.sampat@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org, shuah@kernel.org, 
	michael.roth@amd.com, pbonzini@redhat.com, pgonda@google.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 11, 2024, Pratik Rajesh Sampat wrote:
> >> +static void sev_guest_status_assert(struct kvm_vm *vm, uint32_t type)
> >> +{
> >> +	struct kvm_sev_guest_status status;
> >> +	bool cond;
> >> +	int ret;
> >> +
> >> +	ret = __vm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &status);
> >> +	cond = type == KVM_X86_SEV_VM ? !ret : ret;
> >> +	TEST_ASSERT(cond,
> >> +		    "KVM_SEV_GUEST_STATUS should fail, invalid VM Type.");
> >> +}
> >> +
> >> +static void test_sev_launch(void *guest_code, uint32_t type, uint64_t policy)
> >> +{
> >> +	struct kvm_vcpu *vcpu;
> >> +	struct kvm_vm *vm;
> >> +	struct ucall uc;
> >> +	bool cond;
> >> +	int ret;
> >> +
> > 
> > Maybe a block comment here indicating what you're actually doing would
> > be good, because I'm a bit confused.
> > 
> > A policy value of 0 is valid for SEV, so you expect each call to
> > succeed, right? And, actually, for SEV-ES the launch start will succeed,
> > too, but the launch update will fail because LAUNCH_UPDATE_VMSA is not
> > valid for SEV, but then the launch measure should succeed. Is that
> > right? What about the other calls?
> > 
> 
> Sure, I can do that.
> Yes for SEV, the policy value of 0 succeeds for everything except when
> we try to run and we see a KVM_EXIT_IO.
> 
> For SEV-ES, with the policy value of 0 - we don't see launch_start
> succeed. It fails with EIO in this case. Post that all the calls for
> SEV-ES also fail subsequent to that. I guess the core idea behind this
> test is to ensure that once the first bad case of launch_start fails, we
> should see a cascading list of failures.
>
> >> +	vm = vm_sev_create_with_one_vcpu(type, guest_code, &vcpu);
> >> +	ret = sev_vm_launch_start(vm, 0);
> >> +	cond = type == KVM_X86_SEV_VM ? !ret : ret;
> >> +	TEST_ASSERT(cond,

Don't bury the result in a local boolean.  It's confusing, and _worse_ for debug
as it makes it impossible to see what actually failed (the assert message will
simply print "cond", which is useless).


> >> +		    "KVM_SEV_LAUNCH_START should fail, invalid policy.");

This is a blatant lie, because the KVM_X86_SEV_VM case apparently expects success.
Similar to Tom's comments about explaing what this code is doing, these assert
messages need to explain what the actually expected result it, provide a hint as
to _why_ that result is expected, and print the result.  As is, this will be
unnecessarily difficult to debug if/when it fails.

