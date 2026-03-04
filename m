Return-Path: <kvm+bounces-72727-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SOn2JyJ6qGl0uwAAu9opvQ
	(envelope-from <kvm+bounces-72727-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:29:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE752065AA
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:29:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12A5931B06A3
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75FFF3D75C9;
	Wed,  4 Mar 2026 18:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AA1iyBy+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B363D567A
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648125; cv=none; b=XsV1ss8nvm1myd52jiuUpW0p12XLeYdMk+Sa3CfRsYPfnEy3q0Yd7U+CPWPVXhi8WsZlfut5o+C0Pykyn9wqzUXihEA0U7xrHoXYJHmkG0Lg++cXfXsGweA+JM90G00q63qeMBWbLDSwyMsEBXdMtpJydIy2NLPB6Njtij+NBTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648125; c=relaxed/simple;
	bh=KbgY7aSfXZn9AVFQetDGs5LlZkWw6p0DhvLVbmUtSCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ns/wH0gqsZp2XDzVRh21X6UPZHpSpET6Md4pRkI5D1Gl21zKYAqYp8PxmGF2SkFJcJjRjvpPVCh+JPxZpFpNT+ucz3movuTZc4KzK2/hYqyYEATf96XsvwZYaVoQxf0bmQ1z5alQRSFtyTZHqC+XqUpwdQz1OTGff9gZWXV+9Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AA1iyBy+; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648123; x=1804184123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KbgY7aSfXZn9AVFQetDGs5LlZkWw6p0DhvLVbmUtSCc=;
  b=AA1iyBy++jzVP2fZPJhz6P5FR8u0iRDRg+5YIP+pfXV6Y2YRMh9e8Odv
   xEcD0hIqypiz/0H9UnsX6PU3izXA6mAQVu/MPCmg6TUC6RCG1p6yKeJDs
   aiSRz3VOaFCZfw4YaLnwlqklyksAmiLIEAB1XcPsgTC9oIe0v1K4iOY3X
   KEoh7HfuSFscq1TNPScyi4hscusPFSrfSeqGAYdyZ7G6AewI1dkco3MJk
   rUzNaur0Nx1EvF0vfUJkKECU5kuFgq5ka2zE7mEDJCFTv/1/ecXzN9cUj
   F6ptmsUQHRBqZFgnGMtLr5B3yhk1PubByYJNRlgdGtobQwJrf9ncAfxXS
   A==;
X-CSE-ConnectionGUID: uja/uEKoTfSltS9gD11mEg==
X-CSE-MsgGUID: 3uyXkCrQTLiywnRII9T0VA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909372"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909372"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:22 -0800
X-CSE-ConnectionGUID: RUNNrqBJSSeoDpsv2DkdAg==
X-CSE-MsgGUID: XX4oF/bOSXKVEXGO7L2Mpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542840"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:21 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH V3 09/13] target/i386: Clean up LBR format handling
Date: Wed,  4 Mar 2026 10:07:08 -0800
Message-ID: <20260304180713.360471-10-zide.chen@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260304180713.360471-1-zide.chen@intel.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0DE752065AA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72727-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

Since the lbr-fmt property is masked with PERF_CAP_LBR_FMT in
DEFINE_PROP_UINT64_CHECKMASK(), there is no need to explicitly validate
user-requested lbr-fmt values.

The PMU feature is only supported when running under KVM, so initialize
cpu->lbr_fmt in kvm_cpu_instance_init().  Use -1 as the default lbr-fmt,
rather than initializing it with ~PERF_CAP_LBR_FMT, which is misleading
as it suggests a semantic relationship that does not exist.

Rename requested_lbr_fmt to a more generic guest_fmt.  When lbr-fmt is
not specified and cpu->migratable is false, the guest lbr_fmt value is
not user-requested.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V2: New patch.
---
 target/i386/cpu.c         | 18 ++++++------------
 target/i386/kvm/kvm-cpu.c |  2 ++
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 89691fba45e1..da2e67ca1faf 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9776,7 +9776,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     X86CPUClass *xcc = X86_CPU_GET_CLASS(dev);
     CPUX86State *env = &cpu->env;
     Error *local_err = NULL;
-    unsigned requested_lbr_fmt;
+    unsigned guest_fmt;
 
     if (!kvm_enabled())
         cpu->enable_pmu = false;
@@ -9816,11 +9816,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
      * Override env->features[FEAT_PERF_CAPABILITIES].LBR_FMT
      * with user-provided setting.
      */
-    if (cpu->lbr_fmt != ~PERF_CAP_LBR_FMT) {
-        if ((cpu->lbr_fmt & PERF_CAP_LBR_FMT) != cpu->lbr_fmt) {
-            error_setg(errp, "invalid lbr-fmt");
-            return;
-        }
+    if (cpu->lbr_fmt != -1) {
         env->features[FEAT_PERF_CAPABILITIES] &= ~PERF_CAP_LBR_FMT;
         env->features[FEAT_PERF_CAPABILITIES] |= cpu->lbr_fmt;
     }
@@ -9829,9 +9825,8 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
      * vPMU LBR is supported when 1) KVM is enabled 2) Option pmu=on and
      * 3)vPMU LBR format matches that of host setting.
      */
-    requested_lbr_fmt =
-        env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_LBR_FMT;
-    if (requested_lbr_fmt && kvm_enabled()) {
+    guest_fmt = env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_LBR_FMT;
+    if (guest_fmt) {
         uint64_t host_perf_cap =
             x86_cpu_get_supported_feature_word(NULL, FEAT_PERF_CAPABILITIES);
         unsigned host_lbr_fmt = host_perf_cap & PERF_CAP_LBR_FMT;
@@ -9840,10 +9835,10 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
             error_setg(errp, "vPMU: LBR is unsupported without pmu=on");
             return;
         }
-        if (requested_lbr_fmt != host_lbr_fmt) {
+        if (guest_fmt != host_lbr_fmt) {
             error_setg(errp, "vPMU: the lbr-fmt value (0x%x) does not match "
                         "the host value (0x%x).",
-                        requested_lbr_fmt, host_lbr_fmt);
+                        guest_fmt, host_lbr_fmt);
             return;
         }
     }
@@ -10264,7 +10259,6 @@ static void x86_cpu_initfn(Object *obj)
     object_property_add_alias(obj, "sse4_2", obj, "sse4.2");
 
     object_property_add_alias(obj, "hv-apicv", obj, "hv-avic");
-    cpu->lbr_fmt = ~PERF_CAP_LBR_FMT;
     object_property_add_alias(obj, "lbr_fmt", obj, "lbr-fmt");
 
     if (xcc->model) {
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index c34d9f15c7e8..1d0047d037c7 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -230,6 +230,8 @@ static void kvm_cpu_instance_init(CPUState *cs)
         kvm_cpu_max_instance_init(cpu);
     }
 
+    cpu->lbr_fmt = -1;
+
     kvm_cpu_xsave_init();
 }
 
-- 
2.53.0


