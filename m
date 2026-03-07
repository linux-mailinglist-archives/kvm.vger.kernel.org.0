Return-Path: <kvm+bounces-73228-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id HgDQB749rGmWngEAu9opvQ
	(envelope-from <kvm+bounces-73228-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 16:01:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 63DC822C40B
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 16:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 269C93045AAC
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 15:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B339395D87;
	Sat,  7 Mar 2026 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T4rVlkPa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B14B1917F1
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772895668; cv=none; b=PKibP1KomGKR2YxlViLSPLIiMuQm7FoHpkSJ1tCAo62MQFg0nwJcCgigUWn7fgC5yawSmPdFqs6O6dsRCPdJQWYeQ06hcRff/Weu0MRZNKZN7tA2Ts1UTalfqH6WKB9fphSenGticfw0MYP+3X/LhHcw/9UxQX1OyZctpXSCTZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772895668; c=relaxed/simple;
	bh=hkSk49rh5EKbxplYl83C1O8l/b6ookl1XOWeXFSMJCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cz8czPObs+NhvTZu8JopTlHWhMNK3HGORRKgAsK1EIcoBuLet9KNLfRrJ1hoxdsAO2QhNMhd/vsF1NnaUOjaUQro5q3dCVUDd4VUdj7iA3nI5EYd4N2I+86tXCjhqRw2icNsXIthrKgpqXy5hyU/KZX8o1GLlhqta8TiNLA5Qys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T4rVlkPa; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48534b59cf3so43815e9.2
        for <kvm@vger.kernel.org>; Sat, 07 Mar 2026 07:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772895666; x=1773500466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gcg/exchlRz2hW0LJ3FgJGNryHP56rv8IoAX8A7KL5Q=;
        b=T4rVlkPaUPx41huRliu4ZlWp8qDfSXEX65K1Ui7YeevGzsoIxeGnvZ6jA22X7fxQn3
         FvB/awQjotFfwhofk1CkNTJ3OtDL9Nh2droPoo92qOItNfDoQamv4l+pBSAfYvM5tUVS
         d3I7lVk7UzxUgXVJs0rSCi4RC1SdAEjib0Gb6KNegapNq7wfvQ+3gJp5KA9yniPvrGfS
         +It9XqsjcfPqja10fBHeGrVnI2fHJo7O6OKT3mZMs86D3PY1M+ibSBCl66TXwpbHElnh
         LkaNMLLGzzWOrJqgZpHzieR2VW+moYVkE2BP4zfC+pRYzC8AZaQByfcdBN31/KUz0AAm
         /iTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772895666; x=1773500466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gcg/exchlRz2hW0LJ3FgJGNryHP56rv8IoAX8A7KL5Q=;
        b=IaYSSyqmwzxfkJPbvZDnFyhQGIR+M85eqaJzknlvEXVXppE5ZqL59y1dL8/xqcWVTg
         Ih1qThqyeQjrtSJJuuwex78XKO1lLue7jJVVZsgqOerFBejO6iIjxg3awdidsqEmhvOA
         X4vW136WZX9yWfSDWBCbs1KLgAyJBOF3AFF+l3BMsorx/CTr89656Lg4OuptnrXe38dU
         6VMnWJc5ouXjXX6p7fnPjGYTorWV+bhOwjtC0Vnc/QLTfb5nb+Sm1009k578YxiTudte
         HnZfwRTwjRwIwKeO7tI0FiJn8okSKrAHRC09rew7CGpje3FIU/zMScjhLup5lFNK5CDq
         F4jg==
X-Forwarded-Encrypted: i=1; AJvYcCUdktjhEIg2TWWl9tInCu5XKxdqkH6mxb5cmrtsX66DnImGaMEukECUu62eFZSefmFhoTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwB7FBEYTOo2hWJDIEKcXqp12JHln3Ill6AIMV05xACBEC7rWFX
	Cm/ThmfPNOB5vbvbT9AH1bbu6LZBuq/dgMaelpg/fCYfwKJ3ZQQnABqZ4KJ0jWWGRaQ=
X-Gm-Gg: ATEYQzxbZWelJBV4N5fZJpg9GKy8oZmGWgJOXE/FoYk0/f68TMdmk0rNX4IDkan9Zv/
	gEsqi16GbpeP4nSFIhaNhU/ePCMxhw6me+uQG2eNuhAgLJPMg/ga2MJNUaLHl72E2leZ/hLi592
	gjKELntP4xmN/F+YwM/xNmDr6iVQ++PlTeFSrZTCEsWEsHyj27bucsMiLYI9iB+0/nMxx956XQo
	VzgATkBvkpMVTECxMkyYpakCgyH8CtFN8tMZt718ZUbx1XuyZDZ09OAEKhNpY30g05CczAcEJA/
	G6xC08yw5pLIVCywSzIOTtafaUFwTsvXJrhUYu/5dQj+QlnIuQjm3F9wpYxt3hoJit4CPqTdc7w
	kk2o65e8JGRdMCbjRbDgjTanxsXG9yDcmTtX8dQ9YBsPc6oimQaER6O9veKoBSZ0hGu5z7zTwQQ
	K1X+Q7ahTk07leupkW029f0lW1jW2hXX01FgDTZ+BUQ1hJjHBqdf++5RYaHmMYye5CuaUw/Ic8P
	BMMqpfQUIU=
X-Received: by 2002:a05:600c:8115:b0:477:a219:cdb7 with SMTP id 5b1f17b1804b1-485268bd69fmr99358265e9.0.1772895665487;
        Sat, 07 Mar 2026 07:01:05 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851fa87e56sm190814005e9.0.2026.03.07.07.01.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 07 Mar 2026 07:01:04 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 3/4] target/i386/kvm: Remove X86CPU::hyperv_synic_kvm_only field
Date: Sat,  7 Mar 2026 16:00:41 +0100
Message-ID: <20260307150042.78030-4-philmd@linaro.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260307150042.78030-1-philmd@linaro.org>
References: <20260307150042.78030-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63DC822C40B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73228-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.956];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linaro.org:dkim,linaro.org:email,linaro.org:mid]
X-Rspamd-Action: no action

The X86CPU::hyperv_synic_kvm_only boolean (see commit 9b4cf107b09
"hyperv: only add SynIC in compatible configurations") was only set
in the pc_compat_3_0[] array, via the 'x-hv-synic-kvm-only=on'
property. We removed all machines using that array, lets remove that
property and all the code around it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.h     |  1 -
 target/i386/cpu.c     |  2 --
 target/i386/kvm/kvm.c | 15 ++++-----------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index f2679cc5b72..2b70d56e9b0 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2335,7 +2335,6 @@ struct ArchCPU {
 
     uint32_t hyperv_spinlock_attempts;
     char *hyperv_vendor;
-    bool hyperv_synic_kvm_only;
     uint64_t hyperv_features;
     bool hyperv_passthrough;
     OnOffAuto hyperv_no_nonarch_cs;
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 01b64940b17..c77addd2c25 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -10589,8 +10589,6 @@ static const Property x86_cpu_properties[] = {
      * to the specific Windows version being used."
      */
     DEFINE_PROP_INT32("x-hv-max-vps", X86CPU, hv_max_vps, -1),
-    DEFINE_PROP_BOOL("x-hv-synic-kvm-only", X86CPU, hyperv_synic_kvm_only,
-                     false),
     DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
                      true),
     DEFINE_PROP_BOOL("x-l1-cache-per-thread", X86CPU, l1_cache_per_core, true),
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 27b1b848d6a..a29f757c168 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1278,10 +1278,7 @@ static struct kvm_cpuid2 *get_supported_hv_cpuid_legacy(CPUState *cs)
     }
 
     if (has_msr_hv_synic) {
-        unsigned int cap = cpu->hyperv_synic_kvm_only ?
-            KVM_CAP_HYPERV_SYNIC : KVM_CAP_HYPERV_SYNIC2;
-
-        if (kvm_check_extension(cs->kvm_state, cap) > 0) {
+        if (kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV_SYNIC2) > 0) {
             entry_feat->eax |= HV_SYNIC_AVAILABLE;
         }
     }
@@ -1543,7 +1540,6 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
 
     /* Additional dependencies not covered by kvm_hyperv_properties[] */
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC) &&
-        !cpu->hyperv_synic_kvm_only &&
         !hyperv_feat_enabled(cpu, HYPERV_FEAT_VPINDEX)) {
         error_setg(errp, "Hyper-V %s requires Hyper-V %s",
                    kvm_hyperv_properties[HYPERV_FEAT_SYNIC].desc,
@@ -1608,8 +1604,7 @@ static int hyperv_fill_cpuids(CPUState *cs,
     c->eax |= HV_HYPERCALL_AVAILABLE;
 
     /* SynIC and Vmbus devices require messages/signals hypercalls */
-    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC) &&
-        !cpu->hyperv_synic_kvm_only) {
+    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC)) {
         c->ebx |= HV_POST_MESSAGES | HV_SIGNAL_EVENTS;
     }
 
@@ -1752,16 +1747,14 @@ static int hyperv_init_vcpu(X86CPU *cpu)
     }
 
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC)) {
-        uint32_t synic_cap = cpu->hyperv_synic_kvm_only ?
-            KVM_CAP_HYPERV_SYNIC : KVM_CAP_HYPERV_SYNIC2;
-        ret = kvm_vcpu_enable_cap(cs, synic_cap, 0);
+        ret = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_SYNIC2, 0);
         if (ret < 0) {
             error_report("failed to turn on HyperV SynIC in KVM: %s",
                          strerror(-ret));
             return ret;
         }
 
-        if (!cpu->hyperv_synic_kvm_only && !hyperv_is_synic_enabled()) {
+        if (!hyperv_is_synic_enabled()) {
             ret = hyperv_x86_synic_add(cpu);
             if (ret < 0) {
                 error_report("failed to create HyperV SynIC: %s",
-- 
2.52.0


