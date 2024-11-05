Return-Path: <kvm+bounces-30686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D309BC5BA
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:41:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11D94B230A4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E3501FEFAC;
	Tue,  5 Nov 2024 06:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9LaLOdX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5500C1FCC63
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788806; cv=none; b=Sd/6Mx9naIU29Tl2Pgj/kf5BwsZC/uCMXwNxb683YKbjzeN/cFqvnrfOu2CenKU4O6ceX9MEqRutmOEjspsIpEBO50teq111ViRAL17sn+vq0YDiJjtvmZ91tzCLxo5ZIkKvSdH/Sv+08ziwXEaEbG4bxgDO/uBPRNe3LdX8j/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788806; c=relaxed/simple;
	bh=P5Dpgnlq8pIkngj4xnDuBRfdAfvVDs1AjzLSgYZekNU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MLKFmiQDIRicHpTFwfiA3Idd56Y1WeNTzVthcvebnsIxMYKyH75Y7x2TPZjBNUKU3q74Psya+/mZ8VSm3xGTX/+TkbFJsbf06yjEceZdyFXYW6k8KvWAS39HT8ci4KbokRcchWkFzvrtwRlG/D1m6AIuLY+v0nQczadBy+KETMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O9LaLOdX; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788805; x=1762324805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P5Dpgnlq8pIkngj4xnDuBRfdAfvVDs1AjzLSgYZekNU=;
  b=O9LaLOdXX+os+p0sQX33rYz0KO8C28GhlBHTSZ+1DjFue2TPStiDGmwo
   PeWB9l4T91Z8QplS+UCWfPPBI8oPkb99t5ut52RtDgzMOwwa8OTdbyele
   ucBSXl0SShdYARGGeutLMU4ygC01Y22LB43J1YK8AEoGFmnuKwYaIwRdQ
   I52RGBQK0s7NRQx9Kp8NBhM5qGsZ2+629ACPoMJGePgMR7QLxkPosh2Dm
   xN6+RAszML0LGOkgRr9ak7gRAE+u1Uyx23ADamctYI17I6xSBr1seEGz3
   JNdnSJX3F/kncE+jNMPg/6YUObQuxN7mn/KiEjIIQmeoaGue0xEeqHE8t
   g==;
X-CSE-ConnectionGUID: HXMNOdPHQkauczZRrdDsCg==
X-CSE-MsgGUID: zCyF67HgQ/2HkhNKITX3LQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689886"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689886"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:40:05 -0800
X-CSE-ConnectionGUID: c9TSTQY7QYKD76jrtTi9Dw==
X-CSE-MsgGUID: zpSR5Yn5SvKva1MN49xPSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989906"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:40:01 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 52/60] i386/cpu: Expose mark_unavailable_features() for TDX
Date: Tue,  5 Nov 2024 01:24:00 -0500
Message-Id: <20241105062408.3533704-53-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose mark_unavailable_features() out of cpu.c so that it can be used
by TDX when features are masked off.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 8c507ad406e7..e728fb6b9f10 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5479,8 +5479,8 @@ static bool x86_cpu_have_filtered_features(X86CPU *cpu)
     return false;
 }
 
-static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
-                                      const char *verbose_prefix)
+void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
+                               const char *verbose_prefix)
 {
     CPUX86State *env = &cpu->env;
     FeatureWordInfo *f = &feature_word_info[w];
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 0cc88c470dfb..e70e7f5ced4b 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2444,6 +2444,8 @@ void cpu_set_apic_feature(CPUX86State *env);
 void host_cpuid(uint32_t function, uint32_t count,
                 uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx);
 bool cpu_has_x2apic_feature(CPUX86State *env);
+void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
+                               const char *verbose_prefix);
 
 static inline bool x86_has_cpuid_0x1f(X86CPU *cpu)
 {
-- 
2.34.1


