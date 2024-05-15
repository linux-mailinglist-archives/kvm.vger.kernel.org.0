Return-Path: <kvm+bounces-17483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EDF48C6F47
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05BF41F2344C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D507B50283;
	Wed, 15 May 2024 23:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f0N7kRuU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475114D5A5
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 23:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715816393; cv=none; b=tDKEo5MT6nqguWEJD+qItq+rd4gYBNqW+lrjwbLMCanimC9mQmXcsNh3ya4Q8pFAKNkO0xy44CwdvXpCupddNU+xEpiUlUW6tZRGsz1AsJ9muoEjTUOMmUXuurMOs4HEk2FKKYvXDOTx7gbSjBw1LqXwNaQF09NcNW1BmnqecdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715816393; c=relaxed/simple;
	bh=3oMs/EAozxzRjmHc8oF2xhclaHJKmRWrtxRCgWJizQg=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=Fm/dWlN8YyEQmZTsYOa266DXYtrGOfMPddznQlEVaiSjckZgP/L+yi+fH2EoW4s6blix/k7Ls/XW+BQwjNQTofsp4KZ7Tec1AUm2XYVjVCAIY9H6/WM6xKQtCOrgMSo4Xm7FZYTHSMSrUvBOZjob4EIUirwVk37Q3PcEvRdXCjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f0N7kRuU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715816389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RJLZdH0XAbImcOFFuxXsaDPLDeUbL5976vCjbDbG+y8=;
	b=f0N7kRuUdxmhUJe1LBrE0s71U90iJlShpOdKrbj7sVN6LchHOzyf0pNUMeVgp1LhY+QfWw
	4zEwUTYcBnWsd7N+u+l05MglEH+eQcxq7ocKNjh8bvZPlmv1VD1D0anBRYT+YJFe57ooiv
	4b6lw9tdJz20V5xaHeRVjz6m9DuG3vI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-T7Qtta0bPQeHCFMfVdJX0Q-1; Wed, 15 May 2024 19:39:37 -0400
X-MC-Unique: T7Qtta0bPQeHCFMfVdJX0Q-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6a156a0f5baso146673186d6.1
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 16:39:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715816377; x=1716421177;
        h=content-transfer-encoding:mime-version:user-agent:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJLZdH0XAbImcOFFuxXsaDPLDeUbL5976vCjbDbG+y8=;
        b=uX0WP2FHvi07pkcTcg5rHJ4RGjPdSeeenWULOpIiAcVlYPBht42psxW4mxDoS+DpU5
         5RQLReDQFDTTHZtFmNuWkT0b92JJmcgTHBbsFpOVMIEIvoqngUeLaX0muq+1ujEaCAJl
         eA1ztNwYK10KIITpjuqSnKe6Me6dI/ylneGuB8J7mgxlIy+nG5C0l0kWKFN7QiGgiNCy
         bbHBTKL91wwvLzKINy9x8ZIjYyWIwC/7AayMIoQKRELP3su9dZ/MaOb3rqbixlkkWTSu
         dc2OJvyKhZ5I1z0dpoqLgaOat7cXjUOQgmO6Cm/GasmJmgD2HTOGCSl5zFXRspagHYtO
         0quQ==
X-Gm-Message-State: AOJu0Yy3tpbGsuYb1qB+oMfWfmZSxq7LDiPiqa93Q9RC5msavNswaiPl
	/Z52NbootBZUNIf8MwHwFnNkP/+CM9SgMMR/S/JC3D2TCMWmVzK9jlPKuTjB9+TDdt1sNVqqFYO
	v27Q5BU09gJWthiMVVqFgeQpqasR2pwZQhsMeP4B9RuA4HUo7pLvQuQFgoPMxXQCNFssKK99qdA
	dyEVYrDovAqzvXPUIRlBW1jxje2YtQyO+s4g==
X-Received: by 2002:a05:6214:4806:b0:6a0:def5:8281 with SMTP id 6a1803df08f44-6a16791bce2mr293866976d6.11.1715816376859;
        Wed, 15 May 2024 16:39:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/FreTvJOKBUWb+O8LuC80crXjtW+UtDMrlX8Ra7hY/aOTvGrew9NnD1oHwZ9Ux5JDkds8pw==
X-Received: by 2002:a05:6214:4806:b0:6a0:def5:8281 with SMTP id 6a1803df08f44-6a16791bce2mr293866696d6.11.1715816376231;
        Wed, 15 May 2024 16:39:36 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f18520dsm69616536d6.44.2024.05.15.16.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 16:39:35 -0700 (PDT)
Message-ID: <7a46456d6750ea682ba321ad09541fa81677b81a.camel@redhat.com>
Subject: access_tracking_perf_test kvm selftest doesn't work when Multi-Gen
 LRU  is in use
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Henry Huang <henry.hj@antgroup.com>,
 linux-mm@kvack.org
Date: Wed, 15 May 2024 19:39:35 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hi,

I would like to share a long rabbit hole dive I did some time ago on why access_tracking_perf_test test sometimes 
fails and why it fails on only some RHEL9 machines.

When it fails you see an error like this:

Populating memory : 0.693662489s
Writing to populated memory : 0.022868074s
Reading from populated memory : 0.009497503s
Mark memory idle : 2.206361533s
Writing to idle memory : 0.282340559s
==== Test Assertion Failure ====
access_tracking_perf_test.c:188: this_cpu_has(X86_FEATURE_HYPERVISOR)
pid=78914 tid=78918 errno=4 - Interrupted system call
1 0x0000000000402e99: mark_vcpu_memory_idle at access_tracking_perf_test.c:188
2 (inlined by) vcpu_thread_main at access_tracking_perf_test.c:240
3 0x000000000040745d: vcpu_thread_main at memstress.c:283
4 0x00007f68e66a1911: ?? ??:0
5 0x00007f68e663f44f: ?? ??:0
vCPU0: Too many pages still idle (123013 out of 262144)


access_tracking_perf_test uses '/sys/kernel/mm/page_idle/bitmap' interface to: 

	- runs a guest once which writes to its memory pages and thus allocates and dirties them.

	- clear A/D bits of the primary and secondary translation of guest pages
	   (note that it clears the bits in the actual PTEs only)

	- set so called 'idle' page flags bit on these pages

	  (this bit is only used for page_idle private usage, it is not used in generic mm code, because
	   generic mm code only tracks dirty and not accessed page status)

	- runs again the guest which dirties those memory pages again.

	- uses the same 'page_idle' interface to check that most (90%) of the guest pages are now accessed again.

	  in terms of page_idle code, it will tell that page is not idle (=accessed) if either:
		- idle bit of it is clear
		- A/D bits are set in primary or secondary PTEs that map this page 
		  (in this case it will also clear the idle bit,
		   so that subsequent queries won't need to check the PTEs again)
	  

The problem is that sometimes the secondary translations (that is SPTEs) are destroyed/flushed by KVM 
which causes KVM to mark guest pages which were mapped through these SPTEs as accessed:


KVM calls kvm_set_pfn_accessed and this call eventually leads to folio_mark_accessed().

This function used to clear the idle bit of the page.
(but note that it would not set accessed bits in the primary translation of this page!)

But now when MGLRU is enabled it doesn't do this anymore:

void folio_mark_accessed(struct folio *folio)
{
	if (lru_gen_enabled()) {
		folio_inc_refs(folio);
		return;
	}

	....

	if (folio_test_idle(folio))
		folio_clear_idle(folio);
}
EXPORT_SYMBOL(folio_mark_accessed);


Thus when the page_idle code checks the page, it sees no A/D bits in primary translation,
no A/D bits in secondary translation (because it doesn't exist), and idle bit set,
so it considers the page idle, that is not accessed.

There is a patch series that seems to fix this, but it seems that it wasn't accepted upstream,
I don't know what is the current status of this work.

https://patchew.org/linux/951fb7edab535cf522def4f5f2613947ed7b7d28.1701853894.git.henry.hj@antgroup.com/


Now the question is, what do you think we should do to fix it? 
Should we at least disable page_idle interface when MGLRU is enabled?


Best regards,
	Maxim Levitsky


PS:

Small note on why we started seeing this failure on RHEL 9 and only on some machines: 

	- RHEL9 has MGLRU enabled, RHEL8 doesn't.

	- machine needs to have more than one NUMA node because NUMA balancing 
	  (enabled by default) tries apparently to write protect the primary PTEs 
	  of (all?) processes every few seconds, and that causes KVM to flush the secondary PTEs:
	  (at least with new tdp mmu)

access_tracking-3448    [091] ....1..  1380.244666: handle_changed_spte <-tdp_mmu_set_spte
 access_tracking-3448    [091] ....1..  1380.244667: <stack trace>
 => cdc_driver_init
 => handle_changed_spte
 => tdp_mmu_set_spte
 => tdp_mmu_zap_leafs
 => kvm_tdp_mmu_unmap_gfn_range
 => kvm_unmap_gfn_range
 => kvm_mmu_notifier_invalidate_range_start
 => __mmu_notifier_invalidate_range_start
 => change_p4d_range
 => change_protection
 => change_prot_numa
 => task_numa_work
 => task_work_run
 => exit_to_user_mode_prepare
 => syscall_exit_to_user_mode
 => do_syscall_64
 => entry_SYSCALL_64_after_hwframe

It's a separate question, if the NUMA balancing should do this, or if NUMA balancing should be enabled by default,
because there are other reasons that can force KVM to invalidate the secondary mappings and trigger this issue.







