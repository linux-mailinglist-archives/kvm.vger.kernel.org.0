Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2E030FFFF
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 23:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhBDWUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 17:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhBDWUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 17:20:44 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A62DC061786
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 14:20:03 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id v130so3971947qkb.14
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 14:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=KvoSdl2IGTXpNbnzVeVqYoPXiayejL6/O8HcDgSJPQs=;
        b=QQuqeELScODx8FzQT+U3Z6u+RHODjdDOpzLl/rNM4LXrg3OUYBewdCfKBAPvVOCRtm
         ZXrdqiKt8T0pEt+qDXRvE2zu/xu43ry4g9NCcnXGun8Oxr7I5c6rtUbogGzQ7h8XJNJn
         h79Bee+m29q0F1dZP0B2j+WbuV2tFats2yJPfk3YM7FmrxUK6X19fZejSwTOYSepZM/6
         ReGHkTGEGfrR+sZ7t8Dmef28F6PX0vjuKtj/Y6a35gVTS/XS1trI8EzbbEKTGM+wGk5W
         5wyi0McQcoNjsSlugux40ECyBfqDTzLJ/0luxYqMDMpu2nb8TjOWYOyBUHK02u03xSJF
         P8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=KvoSdl2IGTXpNbnzVeVqYoPXiayejL6/O8HcDgSJPQs=;
        b=cJGrg+uwJcV4hN5hWZ0Ijc/InPNLG8ogjxUDyo7c7hksO8PF5pCYx2Q/dcC6CegyKU
         aeL1MhVBEJCZjjBfm8zfM5guKCFHlN/te262srr6TYmXGBi3cxasu36QD0ciWwfnaion
         MaysSPuYyINM4WMWeeS7XCG4WmzyyUWeLIIBMJqWHj6d0lGpvLusJiJ2fIU9EBNVk1E3
         NuXoCn5cUyIfXQu4rqQZlLNtDQ4FAZbevZqGdymcHKrXYVheCO+Zuby1awAsBXlIHDBX
         P58Irb3sMcUd9NVtHUV1ih9nfOi4HK05H1qVQr91vRZCOv1JS/j7xRfxvWVpQ5VBqWVH
         WdUg==
X-Gm-Message-State: AOAM532ff0P/o8PvWosYPkrKtkTEMrUHfZvbJBYVtqregrX2RH3HVGr+
        DRxK0GZrZOFOqxauVtRRkDNQuhICMje2
X-Google-Smtp-Source: ABdhPJzGD2dSZVKlaJ7FHplNsMTSb9RY3cXOdx+eTH1EWtgCEv6PQj05i+xT+mhL//W9FVABrHKwwsGTjdgk
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:a055:62a0:d194:7e40])
 (user=bgardon job=sendgmr) by 2002:a0c:eda6:: with SMTP id
 h6mr1688146qvr.19.1612477202220; Thu, 04 Feb 2021 14:20:02 -0800 (PST)
Date:   Thu,  4 Feb 2021 14:19:59 -0800
Message-Id: <20210204221959.232582-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH] KVM: VMX: Optimize flushing the PML buffer
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_flush_pml_buffer repeatedly calls kvm_vcpu_mark_page_dirty, which
SRCU-derefrences kvm->memslots. In order to give the compiler more
freedom to optimize the function, SRCU-dereference the pointer
kvm->memslots only once.

Reviewed-by: Makarand Sonare <makarandsonare@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

---

Tested by running the dirty_log_perf_test selftest on a dual socket Intel
Skylake machine:
./dirty_log_perf_test -v 4 -b 30G -i 5

The test was run 5 times with and without this patch and the dirty
memory time for iterations 2-5 was averaged across the 5 runs.
Iteration 1 was discarded for this analysis because it is still dominated
by the time spent populating memory.

The average time for each run demonstrated a strange bimodal distribution,
with clusters around 2 seconds and 2.5 seconds. This may have been a
result of vCPU migration between NUMA nodes.

In any case, the get dirty times with this patch averaged to 2.07
seconds, a 7% savings from the 2.22 second everage without this patch.

While these savings may be partly a result of the patched runs having
one more 2 second clustered run, the patched runs in the higer cluster
were also 7-8% shorter than those in the unpatched case.

Below is the raw data for anyone interested in visualizing the results
with a graph:
Iteration	Baseline	Patched
2		2.038562907	2.045226614
3		2.037363248	2.045033709
4		2.037176331	1.999783966
5		1.999891981	2.007849104
2		2.569526298	2.001252504
3		2.579110209	2.008541897
4		2.585883731	2.005317983
5		2.588692727	2.007100987
2		2.01191437	2.006953735
3		2.012972236	2.04540153
4		1.968836017	2.005035246
5		1.967915154	2.003859551
2		2.037533296	1.991275846
3		2.501480125	2.391886691
4		2.454382587	2.391904789
5		2.461046772	2.398767963
2		2.036991484	2.011331436
3		2.002954418	2.002635687
4		2.053342717	2.006769959
5		2.522539759	2.006470059
Average		2.223405818	2.069119963

 arch/x86/kvm/vmx/vmx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cc60b1fc3ee7..46c54802dfdb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5692,6 +5692,7 @@ static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
 static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_memslots *memslots;
 	u64 *pml_buf;
 	u16 pml_idx;
 
@@ -5707,13 +5708,18 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 	else
 		pml_idx++;
 
+	memslots = kvm_vcpu_memslots(vcpu);
+
 	pml_buf = page_address(vmx->pml_pg);
 	for (; pml_idx < PML_ENTITY_NUM; pml_idx++) {
+		struct kvm_memory_slot *memslot;
 		u64 gpa;
 
 		gpa = pml_buf[pml_idx];
 		WARN_ON(gpa & (PAGE_SIZE - 1));
-		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
+
+		memslot = __gfn_to_memslot(memslots, gpa >> PAGE_SHIFT);
+		mark_page_dirty_in_slot(vcpu->kvm, memslot, gpa >> PAGE_SHIFT);
 	}
 
 	/* reset PML index */
-- 
2.30.0.365.g02bc693789-goog

