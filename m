Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2375E512389
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiD0UIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbiD0UIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:08:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D891388B0D
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651089868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qyiwndqLFW8lJocfITHVyIhR9sE91Sgya/K8+RHWWlQ=;
        b=Z6Yg/sMQC+AGcja+d2FQe81bZk1OOx39lTXH5npM9JymvgBCJ3roA8rrNOujtYMs5NIFDt
        pEkQFV3dPw4DIZ5PplwEnAGkxgMFXzoQJIoOyke9k/3pzqiuAneydfoFuoS0cm2yXbKpqj
        769IeXB7BwDPxdR10tWNXMCGfwZJHUE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-IiLHPgneOzCvaq5st3HM4Q-1; Wed, 27 Apr 2022 16:04:24 -0400
X-MC-Unique: IiLHPgneOzCvaq5st3HM4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 455C83C10AA1;
        Wed, 27 Apr 2022 20:04:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42E607C55;
        Wed, 27 Apr 2022 20:04:10 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org,
        Sean Christopherson <seanjc@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [RFC PATCH v3 09/19] KVM: x86: nSVM: add nested AVIC tracepoints
Date:   Wed, 27 Apr 2022 23:03:04 +0300
Message-Id: <20220427200314.276673-10-mlevitsk@redhat.com>
In-Reply-To: <20220427200314.276673-1-mlevitsk@redhat.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds few tracepoints that will be used
to debug/profile the nested AVIC.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/trace.h | 157 ++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c   |  13 ++++
 2 files changed, 169 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index de47625175692..f7ddba5ae06a5 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1385,7 +1385,7 @@ TRACE_EVENT(kvm_apicv_accept_irq,
 );
 
 /*
- * Tracepoint for AMD AVIC
+ * Tracepoints for AMD AVIC
  */
 TRACE_EVENT(kvm_avic_incomplete_ipi,
 	    TP_PROTO(u32 vcpu, u32 icrh, u32 icrl, u32 id, u32 index),
@@ -1479,6 +1479,161 @@ TRACE_EVENT(kvm_avic_kick_vcpu_slowpath,
 		  __entry->icrh, __entry->icrl, __entry->index)
 );
 
+TRACE_EVENT(kvm_avic_physid_table_alloc,
+	    TP_PROTO(u64 gpa),
+	    TP_ARGS(gpa),
+
+	TP_STRUCT__entry(
+		__field(u64, gpa)
+	),
+
+	TP_fast_assign(
+		__entry->gpa = gpa;
+	),
+
+	TP_printk("table at gpa 0x%llx",
+		  __entry->gpa)
+);
+
+
+TRACE_EVENT(kvm_avic_physid_table_free,
+	    TP_PROTO(u64 gpa),
+	    TP_ARGS(gpa),
+
+	TP_STRUCT__entry(
+		__field(u64, gpa)
+	),
+
+	TP_fast_assign(
+		__entry->gpa = gpa;
+	),
+
+	TP_printk("table at gpa 0x%llx",
+		  __entry->gpa)
+);
+
+TRACE_EVENT(kvm_avic_physid_table_reload,
+	    TP_PROTO(u64 gpa, int nentries, int new_nentires),
+	    TP_ARGS(gpa, nentries, new_nentires),
+
+	TP_STRUCT__entry(
+		__field(u64, gpa)
+		__field(int, nentries)
+		__field(int, new_nentires)
+	),
+
+	TP_fast_assign(
+		__entry->gpa = gpa;
+		__entry->nentries = nentries;
+		__entry->new_nentires = new_nentires;
+	),
+
+	TP_printk("table at gpa 0x%llx, nentires %d -> %d",
+		  __entry->gpa, __entry->nentries, __entry->new_nentires)
+);
+
+TRACE_EVENT(kvm_avic_physid_table_write,
+	    TP_PROTO(u64 gpa, int bytes),
+	    TP_ARGS(gpa, bytes),
+
+	TP_STRUCT__entry(
+		__field(u64, gpa)
+		__field(int, bytes)
+	),
+
+	TP_fast_assign(
+		__entry->gpa = gpa;
+		__entry->bytes = bytes;
+	),
+
+	TP_printk("gpa 0x%llx, write of %d bytes",
+		  __entry->gpa, __entry->bytes)
+);
+
+TRACE_EVENT(kvm_avic_physid_update_vcpu_host,
+	    TP_PROTO(int vcpu_id, int cpu_id, int n),
+	    TP_ARGS(vcpu_id, cpu_id, n),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(int, cpu_id)
+		__field(int, n)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+		__entry->cpu_id = cpu_id;
+		__entry->n = n;
+	),
+
+	TP_printk("l1 vcpu %d -> l0 cpu %d (%d entries)",
+		  __entry->vcpu_id, __entry->cpu_id, __entry->n)
+);
+
+TRACE_EVENT(kvm_avic_physid_update_vcpu_guest,
+	    TP_PROTO(int vcpu_id, int cpu_id),
+	    TP_ARGS(vcpu_id, cpu_id),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(int, cpu_id)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+		__entry->cpu_id = cpu_id;
+	),
+
+	TP_printk("l1 vcpu %d -> l0 cpu %d",
+		  __entry->vcpu_id, __entry->cpu_id)
+);
+
+TRACE_EVENT(kvm_avic_nested_doorbell,
+	    TP_PROTO(int source_l1_apicid, int target_l1_apicid, bool target_nested,
+			    bool target_running),
+	    TP_ARGS(source_l1_apicid, target_l1_apicid, target_nested,
+			    target_running),
+
+	TP_STRUCT__entry(
+		__field(int, source_l1_apicid)
+		__field(int, target_l1_apicid)
+		__field(bool, target_nested)
+		__field(bool, target_running)
+	),
+
+	TP_fast_assign(
+		__entry->source_l1_apicid = source_l1_apicid;
+		__entry->target_l1_apicid = target_l1_apicid;
+		__entry->target_nested = target_nested;
+		__entry->target_running = target_running;
+	),
+
+	TP_printk("source %d target %d (nested: %d, running %d)",
+		  __entry->source_l1_apicid, __entry->target_l1_apicid,
+		  __entry->target_nested, __entry->target_running)
+);
+
+TRACE_EVENT(kvm_avic_nested_kick_vcpu,
+	    TP_PROTO(int source_l1_apic_id, int target_l2_apic_id, int target_l1_apic_id),
+	    TP_ARGS(source_l1_apic_id, target_l2_apic_id, target_l1_apic_id),
+
+	TP_STRUCT__entry(
+		__field(int, source_l1_apic_id)
+		__field(int, target_l2_apic_id)
+		__field(int, target_l1_apic_id)
+	),
+
+	TP_fast_assign(
+		__entry->source_l1_apic_id = source_l1_apic_id;
+		__entry->target_l2_apic_id = target_l2_apic_id;
+		__entry->target_l1_apic_id = target_l1_apic_id;
+	),
+
+	TP_printk("source l1 apic id: %d target l2 apic id: %d target l1 apic_id: %d",
+		  __entry->source_l1_apic_id, __entry->target_l2_apic_id,
+		  __entry->target_l1_apic_id)
+);
+
 TRACE_EVENT(kvm_hv_timer_state,
 		TP_PROTO(unsigned int vcpu_id, unsigned int hv_timer_in_use),
 		TP_ARGS(vcpu_id, hv_timer_in_use),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 951d0a78ccdae..d2f73ce87a1e3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13063,10 +13063,23 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_kick_vcpu_slowpath);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_physid_table_alloc);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_physid_table_free);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_physid_table_reload);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_physid_table_write);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_physid_update_vcpu_host);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_physid_update_vcpu_guest);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_nested_doorbell);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_nested_kick_vcpu);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.26.3

