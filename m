Return-Path: <kvm+bounces-38753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD72A3E20B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:16:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98EC517864A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08599228CA9;
	Thu, 20 Feb 2025 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Otg+QY53"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8647223708
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071215; cv=none; b=TdEG2UL4dKBvQLsMA/U2Jbl9OJOGaHktoZSXGYty8sh0QL3nrealPmZ0wDIhDlq7oKD9ySLHARggvIW/C/mWW8cf7fUMHgQAsVhUe1t5hss2TVezWH5U7A1sgRg4YOdDj4Iy8E3D67IMuip5tzUsVAd4crmeK5ctOMQTX6bPbdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071215; c=relaxed/simple;
	bh=aOe0kBWT/SMLYV/wZaMc0z+GF6EZcZUqsRf5Y3fJ0NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2cHcJvgxWaI110RaNyuvZPuyOQJVk5SYz9bZNIpN8Ap5+yQk6MZPhcMBJIf7Seb+7q4jrICfDb8QRPdt0uErW+uFnR0kgLWlzG9uF/18lCEx0iL0KVa9FxNiBLlrC50gI91Lurd1yLKGmkR9VZFnZb25B697PLCtxML2Nwl49w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Otg+QY53; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OK4+tjkqFGEwtmhx8CZ6Jsa93KLzas0PPqSsxfoBC1I=;
	b=Otg+QY53Hbfr9d8+EopC9yohtU+MQwaKX06khm4loDDayvpv1uR3fuf3APqbWgfBHNzGBL
	IPUxNB0T887EUzqn52YU11KIB0ckzFmpKFAHyQxqicUbo9DWSspapW2LqTjdeHplGDvAzJ
	2lu5ppFP7XpxiXSm0/eiUYCmnftPxqA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-H9-SsvULO2WCcGZVV25XkQ-1; Thu,
 20 Feb 2025 12:06:45 -0500
X-MC-Unique: H9-SsvULO2WCcGZVV25XkQ-1
X-Mimecast-MFC-AGG-ID: H9-SsvULO2WCcGZVV25XkQ_1740071203
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B79591800570;
	Thu, 20 Feb 2025 17:06:43 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8263C19412A3;
	Thu, 20 Feb 2025 17:06:42 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 25/30] KVM: TDX: Don't offline the last cpu of one package when there's TDX guest
Date: Thu, 20 Feb 2025 12:05:59 -0500
Message-ID: <20250220170604.2279312-26-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Isaku Yamahata <isaku.yamahata@intel.com>

Destroying TDX guest requires there's at least one cpu online for each
package, because reclaiming the TDX KeyID of the guest (as part of the
teardown process) requires to call some SEAMCALL (on any cpu) on all
packages.

Do not offline the last cpu of one package when there's any TDX guest
running, otherwise KVM may not be able to teardown TDX guest resulting
in leaking of TDX KeyID and other resources like TDX guest control
structure pages.

Implement the TDX version 'offline_cpu()' to prevent the cpu from going
offline if it is the last cpu on the package.

Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 43 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ec8864453787..f794cd914050 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -131,6 +131,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
  */
 static DEFINE_MUTEX(tdx_lock);
 
+static atomic_t nr_configured_hkid;
+
 /* Maximum number of retries to attempt for SEAMCALLs. */
 #define TDX_SEAMCALL_RETRIES	10000
 
@@ -138,6 +140,7 @@ static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
 	kvm_tdx->hkid = -1;
+	atomic_dec(&nr_configured_hkid);
 }
 
 static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
@@ -617,6 +620,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 	ret = -ENOMEM;
 
+	atomic_inc(&nr_configured_hkid);
+
 	tdr_page = alloc_page(GFP_KERNEL);
 	if (!tdr_page)
 		goto free_hkid;
@@ -913,6 +918,42 @@ static int tdx_online_cpu(unsigned int cpu)
 	return r;
 }
 
+static int tdx_offline_cpu(unsigned int cpu)
+{
+	int i;
+
+	/* No TD is running.  Allow any cpu to be offline. */
+	if (!atomic_read(&nr_configured_hkid))
+		return 0;
+
+	/*
+	 * In order to reclaim TDX HKID, (i.e. when deleting guest TD), need to
+	 * call TDH.PHYMEM.PAGE.WBINVD on all packages to program all memory
+	 * controller with pconfig.  If we have active TDX HKID, refuse to
+	 * offline the last online cpu.
+	 */
+	for_each_online_cpu(i) {
+		/*
+		 * Found another online cpu on the same package.
+		 * Allow to offline.
+		 */
+		if (i != cpu && topology_physical_package_id(i) ==
+				topology_physical_package_id(cpu))
+			return 0;
+	}
+
+	/*
+	 * This is the last cpu of this package.  Don't offline it.
+	 *
+	 * Because it's hard for human operator to understand the
+	 * reason, warn it.
+	 */
+#define MSG_ALLPKG_ONLINE \
+	"TDX requires all packages to have an online CPU. Delete all TDs in order to offline all CPUs of a package.\n"
+	pr_warn_ratelimited(MSG_ALLPKG_ONLINE);
+	return -EBUSY;
+}
+
 static void __do_tdx_cleanup(void)
 {
 	/*
@@ -938,7 +979,7 @@ static int __init __do_tdx_bringup(void)
 	 */
 	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
 					 "kvm/cpu/tdx:online",
-					 tdx_online_cpu, NULL);
+					 tdx_online_cpu, tdx_offline_cpu);
 	if (r < 0)
 		return r;
 
-- 
2.43.5



