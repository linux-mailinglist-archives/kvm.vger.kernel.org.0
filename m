Return-Path: <kvm+bounces-17871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF968CB653
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 01:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE2461F21DF5
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 23:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E38B149E1A;
	Tue, 21 May 2024 23:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e5XdSiOO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FF836134
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 23:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716334198; cv=none; b=Mby1jt9vMQNp+lljtpDMJB8xGDXb6qcSstZEeJ1ogVltk2sd6Az/iG4JefTu3zcXJXgsMtpzwwJHVINrN3cfRkHoigT+jtY6fmuUzHlSRdHIdbFmpIf3AGw6S01I3SKA6EqTcMx7E+2jxSHoMzB+nf4JZDNTGV7RtpV59DEcSbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716334198; c=relaxed/simple;
	bh=icORQk2+PbaJYEtENjA4tTy2RhkUjyDmCrWKszO1tTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kxM7oXFLo28atG6/DF/bqx9MiR7AOWS8cOu/ggUdiNVd31YPbrrltT4i8mNGjuryAn4f3lLh9OcuctnrF90rrYjguulKApIKoyr8LbvgFh1w6WCfR0e2QA9DmpxImZm6nPV3nKMYXjYwBVqzYlkhKqsGhJdoBmDA6R6Vp5rMBy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e5XdSiOO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61be325413eso5029217b3.1
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 16:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716334196; x=1716938996; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+BzI0I7st4rXq5MwmbAV5Tzi38yIZZhUt1WvSYOgULQ=;
        b=e5XdSiOOyUTSz4lrE1t7uEP1r4FBJzLAms5e+hXlhVhMK9/lM3nrhvaE+qQq3HBALp
         f9dlNqy15ZKrwBn7tGFHnAVHCW3VYQ0UD4IjnsDC20jhiiuijzeD2mji7JIqzT8RJXr/
         GRk6xMmJO31fOBUra6+S0azI2TF38V2xw3r/UoDC8B5yQUqSEzRF7lkelzS689xNqalP
         eiQvPKOtaHe49n3jCchxfeSiOYj7SLT7dCl54m8KBI/a6Wwmj12j1rSDMsFhuw9cRyi2
         dkvVish8ai9wUwEAEKKNd4JubImHrfRWuw6wZnvo71YzsO3TlUl6WoL4DYJVG5p4Bap3
         Fdeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716334196; x=1716938996;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+BzI0I7st4rXq5MwmbAV5Tzi38yIZZhUt1WvSYOgULQ=;
        b=nMvSMoOQD9puEdj8g6Th1HlLPmzZaewADelEYx3B6/sKVdlArEOvUUcMyjlvO+ddJ+
         Vj1J0wf4YJl5xt19qHovEJx9WnMFmX+ouHtcnMbPNk4RRQnmIeMJS/k9llp081WFAXeW
         v/GuWv1E6FW8g2WIva7Z/XbfjkNEbv4CF+E707Gpi93Z/st6fAeZp9tGet6/IQHnJTOz
         +6UW++LTyPmo5PqJsPmhRwQGRsm25O2qQlLovCx2gv5Qc831xycfuSCMHqW409DEEcpu
         +0rJCBVOMBTdU73aWk7o0IeLihL8CbDoGeTJ3sy7DXeI/WQyKgq1nKjeAHJwQV84WDEK
         Z4Mg==
X-Gm-Message-State: AOJu0YwJoDHqGCZ0s6fiMX/rFBSQpXE9go0mnKPQ+ynIR8f7fSotanb+
	7wIAFiwW+zGDMoQTnBGHODrUjpYkQoN5/tjvT7fWRVg79322h0AKDNg+VAQUxNK/mO1IgNG0XgS
	uUw==
X-Google-Smtp-Source: AGHT+IFdSbE18dHmXUZm+Ed94A9LAnG/1FtV6QIW3gxa+x5R7ywczK/so7v774Y5MGmKju/Uxz5TPDu07oo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:49c3:0:b0:618:5009:cb71 with SMTP id
 00721157ae682-627e4892a8amr1387677b3.5.1716334195799; Tue, 21 May 2024
 16:29:55 -0700 (PDT)
Date: Tue, 21 May 2024 16:29:54 -0700
In-Reply-To: <7a46456d6750ea682ba321ad09541fa81677b81a.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <7a46456d6750ea682ba321ad09541fa81677b81a.camel@redhat.com>
Message-ID: <Zk0uckIeAsb5ex4i@google.com>
Subject: Re: access_tracking_perf_test kvm selftest doesn't work when
 Multi-Gen LRU  is in use
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Henry Huang <henry.hj@antgroup.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Wed, May 15, 2024, Maxim Levitsky wrote:
> Small note on why we started seeing this failure on RHEL 9 and only on some machines: 
> 
> 	- RHEL9 has MGLRU enabled, RHEL8 doesn't.

For a stopgap in KVM selftests, or possibly even a long term solution in case the
decision is that page_idle will simply have different behavior for MGLRU, couldn't
we tweak the test to not assert if MGRLU is enabled?

E.g. refactor get_module_param_integer() and/or get_module_param() to add
get_sysfs_value_integer() or so, and then do this?

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f56..1e759df36098 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -123,6 +123,11 @@ static void mark_page_idle(int page_idle_fd, uint64_t pfn)
                    "Set page_idle bits for PFN 0x%" PRIx64, pfn);
 }
 
+static bool is_lru_gen_enabled(void)
+{
+       return !!get_sysfs_value_integer("/sys/kernel/mm/lru_gen/enabled");
+}
+
 static void mark_vcpu_memory_idle(struct kvm_vm *vm,
                                  struct memstress_vcpu_args *vcpu_args)
 {
@@ -185,7 +190,8 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
         */
        if (still_idle >= pages / 10) {
 #ifdef __x86_64__
-               TEST_ASSERT(this_cpu_has(X86_FEATURE_HYPERVISOR),
+               TEST_ASSERT(this_cpu_has(X86_FEATURE_HYPERVISOR) ||
+                           is_lru_gen_enabled(),
                            "vCPU%d: Too many pages still idle (%lu out of %lu)",
                            vcpu_idx, still_idle, pages);
 #endif

> 	- machine needs to have more than one NUMA node because NUMA balancing 
> 	  (enabled by default) tries apparently to write protect the primary PTEs 
> 	  of (all?) processes every few seconds, and that causes KVM to flush the secondary PTEs:
> 	  (at least with new tdp mmu)
> 
> access_tracking-3448    [091] ....1..  1380.244666: handle_changed_spte <-tdp_mmu_set_spte
>  access_tracking-3448    [091] ....1..  1380.244667: <stack trace>
>  => cdc_driver_init
>  => handle_changed_spte
>  => tdp_mmu_set_spte
>  => tdp_mmu_zap_leafs
>  => kvm_tdp_mmu_unmap_gfn_range
>  => kvm_unmap_gfn_range
>  => kvm_mmu_notifier_invalidate_range_start
>  => __mmu_notifier_invalidate_range_start
>  => change_p4d_range
>  => change_protection
>  => change_prot_numa
>  => task_numa_work
>  => task_work_run
>  => exit_to_user_mode_prepare
>  => syscall_exit_to_user_mode
>  => do_syscall_64
>  => entry_SYSCALL_64_after_hwframe
> 
> It's a separate question, if the NUMA balancing should do this, or if NUMA
> balancing should be enabled by default,

FWIW, IMO, enabling NUMA balancing on a system whose primary purpose is to run VMs
is bad idea.  NUMA balancing operates under the assumption that a !PRESENT #PF is
relatively cheap.  When secondary MMUs are involved, that is simply not the case,
e.g. to honor the mmu_notifer event, KVM zaps _and_ does a remote TLB flush.  Even
if we reworked KVM and/or the mmu_notifiers so that KVM didn't need to do such a
heavy operation, the cost of page fault VM-Exit is significantly higher than the
cost of a host #PF.

> because there are other reasons that can force KVM to invalidate the
> secondary mappings and trigger this issue.

Ya.

