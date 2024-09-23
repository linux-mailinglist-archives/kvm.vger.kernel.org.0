Return-Path: <kvm+bounces-27318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EABC097F0C2
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 20:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1E47282A97
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 18:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C57C1A0720;
	Mon, 23 Sep 2024 18:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y92TOGnf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A2D823C8
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 18:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727116641; cv=none; b=ZImFQXr33ljG25zIU1J0uzkfpasF2pZGyZg6GkaAHvK7QTs9R4sWxZjoeZRZUqGwAjQNrvdUSOmNu+2IKyxnoxusL+h11fq+8VwzCPnrHL7ZoqCP8eUrD5E6NZ1mGPVDsqncBsBS7MJY/lv8DU1ZZY1ZYcqX+Z2xw4Ci0cDMGS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727116641; c=relaxed/simple;
	bh=rCYtrihX4ihGeNjXGzRivL2dCDo5huMpPoj7e/TVaqs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VBkrdTbLyN0qDl5h/VeF2VhHbZQnS4X79X6Sppu7YOqHKlQxnpieYA752aNJOHqWxIr75imxrvgiqSjhuWbaDMbhT4oy8wZcj7vUbcp32nxQh1Ojkbv2C6Z/L4mYcU/w4Fw+hS6daqVW0zUbNPsu8IRbA81LIPKK/QilGDUCfL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y92TOGnf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-206f405f453so48404245ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 11:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727116640; x=1727721440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/S8Wwfazfe8XPn2DgDvOZQ7LYfAriiSs2+Z1ElWXsz0=;
        b=Y92TOGnf9V5qbP2QxmwmRCb6EtI4LbmHOtPQ8xtz8NgqHpcVGujbhS0Kxf8bnD2L2E
         kKUX3UJO1UyLGMsGXcxyfvpMVPwY6wQvDiReA14Q6fkfW9/jcu7oHjl+Dqq4iLMacusw
         aVMaGoJDgcwVSvIdEqLnqWN9dfgLnfDVCo6MyoC8jTd1fGh4twXc7/I1wqrKqeE/rI2R
         3p+T/yz3OaVSLHkzm9Gzs4GpoUJHfrp5jmMEoiPIsRytfsy/c7qkTZuzuBLel6PW/1Fk
         O+l+qvNRtQIx3CNxpw38nVBK+OsOQ++DeEGxpDy4q2g2dqA7HbGMY7g8EDuIRdLiFTEv
         GWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727116640; x=1727721440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/S8Wwfazfe8XPn2DgDvOZQ7LYfAriiSs2+Z1ElWXsz0=;
        b=B8UQd2po7joSyFOmZW3o0IXl8yJsSeTROTt5ctKuRmTcmMa0fYbBF7XrkdpCX0/yq1
         SzceabNbiYS7Ci3RCkT8+W3CYQZe338m8eVyTdrpfqcfcMEiji3HkbqE74d4aH0DhwXC
         nwCFY72Bwdcw3bFWLBO7M1drjtJcOYT5IzQDDfd00qHRSXwmLFRhyDWh28/04C0JM1L0
         hmgz9EfNEsKb7ye6Qjb0kO3q5LAg8i/+d40/LtWPzpc+G+BWH55pioO32fe9EcsD9P+m
         aXtdnk0AEuNftdYLkPoc+dR97FPbJOynTsTuhvaQCqM7v9Yts90j4bYv1KZGrFuyzhwB
         1zvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqk5YP5NVgP929Y78AfA5BYeLv1kAsncImA7w+rAOJVAi3ETlCTbzc2lkArJng18eMeGA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcyWMllI/qcLf2MykpoxHd0EgbahtnIOwhiRBAhHUd34WHllA6
	4N/LyQIbMdbQtABa/FtpEr1vraroMfd54nslhhYTFjOylG4KvD7wwiaMhstkx/mjcTLJVQU9BB4
	OvA==
X-Google-Smtp-Source: AGHT+IGAYSFuTfcgYwZi5yt7ijkpmW6T+Qrle1UNzg+3VzmewGeG3vrBFgiiN1AmLEbBc8zFvyD5CwEHs2w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c951:b0:206:8c37:bcc7 with SMTP id
 d9443c01a7336-208d839844dmr669435ad.1.1727116639464; Mon, 23 Sep 2024
 11:37:19 -0700 (PDT)
Date: Mon, 23 Sep 2024 11:37:14 -0700
In-Reply-To: <20240703021043.13881-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240703020921.13855-1-yan.y.zhao@intel.com> <20240703021043.13881-1-yan.y.zhao@intel.com>
Message-ID: <ZvG1Wki4GvIyVWqB@google.com>
Subject: Re: [PATCH v2 1/4] KVM: x86/mmu: Introduce a quirk to control memslot
 zap behavior
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	isaku.yamahata@intel.com, dmatlack@google.com, sagis@google.com, 
	erdemaktas@google.com, graf@amazon.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 03, 2024, Yan Zhao wrote:
> Introduce the quirk KVM_X86_QUIRK_SLOT_ZAP_ALL to allow users to select
> KVM's behavior when a memslot is moved or deleted for KVM_X86_DEFAULT_VM
> VMs. Make sure KVM behave as if the quirk is always disabled for
> non-KVM_X86_DEFAULT_VM VMs.
 
...

> Suggested-by: Kai Huang <kai.huang@intel.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>

Bad Sean, bad.

> +/*
> + * Zapping leaf SPTEs with memslot range when a memslot is moved/deleted.
> + *
> + * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> + * case scenario we'll have unused shadow pages lying around until they
> + * are recycled due to age or when the VM is destroyed.
> + */
> +static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
> +{
> +	struct kvm_gfn_range range = {
> +		.slot = slot,
> +		.start = slot->base_gfn,
> +		.end = slot->base_gfn + slot->npages,
> +		.may_block = true,
> +	};
> +	bool flush = false;
> +
> +	write_lock(&kvm->mmu_lock);
> +
> +	if (kvm_memslots_have_rmaps(kvm))
> +		flush = kvm_handle_gfn_range(kvm, &range, kvm_zap_rmap);

This, and Paolo's merged variant, break shadow paging.  As was tried in commit
4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot"),
all shadow pages, i.e. non-leaf SPTEs, need to be zapped.  All of the accounting
for a shadow page is tied to the memslot, i.e. the shadow page holds a reference
to the memslot, for all intents and purposes.  Deleting the memslot without removing
all relevant shadow pages results in NULL pointer derefs when tearing down the VM.

Note, that commit is/was buggy, and I suspect my follow-up attempt[*] was as well.
https://lore.kernel.org/all/20190820200318.GA15808@linux.intel.com

Rather than trying to get this functional for shadow paging (which includes nested
TDP), I think we should scrap the quirk idea and simply make this the behavior for
S-EPT and nothing else.

 BUG: kernel NULL pointer dereference, address: 00000000000000b0
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 6085f43067 P4D 608c080067 PUD 608c081067 PMD 0 
 Oops: Oops: 0000 [#1] SMP NOPTI
 CPU: 79 UID: 0 PID: 187063 Comm: set_memory_regi Tainted: G        W          6.11.0-smp--24867312d167-cpl #395
 Tainted: [W]=WARN
 Hardware name: Google Astoria/astoria, BIOS 0.20240617.0-0 06/17/2024
 RIP: 0010:__kvm_mmu_prepare_zap_page+0x3a9/0x7b0 [kvm]
 Code:  <48> 8b 8e b0 00 00 00 48 8b 96 e0 00 00 00 48 c1 e9 09 48 29 c8 8b
 RSP: 0018:ff314a25b19f7c28 EFLAGS: 00010212
 Call Trace:
  <TASK>
  kvm_arch_flush_shadow_all+0x7a/0xf0 [kvm]
  kvm_mmu_notifier_release+0x6c/0xb0 [kvm]
  mmu_notifier_unregister+0x85/0x140
  kvm_put_kvm+0x263/0x410 [kvm]
  kvm_vm_release+0x21/0x30 [kvm]
  __fput+0x8d/0x2c0
  __se_sys_close+0x71/0xc0
  do_syscall_64+0x83/0x160
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

