Return-Path: <kvm+bounces-1794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1057EBDF9
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 585D628139A
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0DE3BE4B;
	Wed, 15 Nov 2023 07:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U5rJCUfr"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF9BA29
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:23:58 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C79E9
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700033036; x=1731569036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XNTiE6ZqujS4EetrrerE0o29oEenkiGYukDBImCgacA=;
  b=U5rJCUfrmN3YOI32fV6HbQN5h0bINmD0Ur4jv/OhWl9MRhHEMoBfOnNA
   BnFnA9ADqrKvWt2GLfLI7IBVEGfAJN0a4SWxgomCSwfxU7CygXhfxEUhf
   zEKDPlihRQp1q5PMWNd7ndMMvy6lne1xWmwkdC5GIIIub0VvvOU4EC1ni
   ZzMk3skcCkEq67dI8GL3w5umW1tU3Xwy9hlpeIcR1UWCl1ujFuW7LjyWG
   PB9F1UrLjTe31+AmkvFtHOitishcR8Ud3Jq5jPhvvAae+lJh9r0w/oR2g
   eSsuTmaZZ3Jm3VQoXkXl1yS5KZ5LbwHfRm56A15Xmp6Ij+u0G0ooiAqzn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623698"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623698"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:23:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800444"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800444"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:23:49 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 66/70] i386/tdx: Don't synchronize guest tsc for TDs
Date: Wed, 15 Nov 2023 02:15:15 -0500
Message-Id: <20231115071519.2864957-67-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TSC of TDs is not accessible and KVM doesn't allow access of
MSR_IA32_TSC for TDs. To avoid the assert() in kvm_get_tsc, make
kvm_synchronize_all_tsc() noop for TDs,

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a74a0d8e0891..773e0b042ae9 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -279,7 +279,7 @@ void kvm_synchronize_all_tsc(void)
 {
     CPUState *cpu;
 
-    if (kvm_enabled()) {
+    if (kvm_enabled() && !is_tdx_vm()) {
         CPU_FOREACH(cpu) {
             run_on_cpu(cpu, do_kvm_synchronize_tsc, RUN_ON_CPU_NULL);
         }
-- 
2.34.1


