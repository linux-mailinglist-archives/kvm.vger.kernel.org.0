Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BAF6B6481
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjCLJ6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjCLJ6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CF8570A3
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615051; x=1710151051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OH66o636hh5SQOMPyQQ4NXdufA147SrxvzDD9VHkJdI=;
  b=nxpqyIznciuBn7UI1/8BSWgO3zBvE8bZlvDBWJD0ATVBeOpgIIvrd3gq
   FLK9Y/q1s4+6UDUdRRA5HTf70LI0ckPKRjeLJbTtbhKS9JnJAVjHFMXzx
   LHgDtlF/DUggBy7HJdZfiX4UkIEtpbCs2vs2Q5zwnlzBDvlz7CUy9dDcY
   9uzh/gFmAgL4rPJgs0c5JHgLawT2mp+3k4IpsYejWfIU6DfU4YKILEtVM
   QzR3h2pwwyRY4zD/1c2AucxY2ntWGTzm3rg+UoPZjIP110soIBzPeXYm+
   nv0fM3eDy5alYtktmzCfq/++3YL6VOAw9Zwq4xv32qrYTCzL6rwpbh91R
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998096"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998096"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677650"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677650"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:11 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Haiwei Li <haiwei.li@intel.com>
Subject: [RFC PATCH part-5 03/22] pkvm: x86: Do guest address translation per page granularity
Date:   Mon, 13 Mar 2023 02:02:44 +0800
Message-Id: <20230312180303.1778492-4-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <haiwei.li@intel.com>

Guest memory operations like read_gva/write_gva/read_gpa/write_gpa only
support doing address translation for current page. It's not correct if
such operation access data over current page.

Fix above issue for these functions by doing address translation per page
granularity.

Signed-off-by: Haiwei Li <haiwei.li@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/memory.c | 65 ++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.c b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
index e99fa72cedac..a42669ccf89c 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
@@ -110,27 +110,47 @@ int gva2gpa(struct kvm_vcpu *vcpu, gva_t gva, gpa_t *gpa,
 	return check_translation(vcpu, _gpa, prot, access, exception);
 }
 
-/* only support host VM now */
-static int copy_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
-		unsigned int bytes, struct x86_exception *exception, bool from_guest)
+static inline int __copy_gpa(struct kvm_vcpu *vcpu, void *addr, gpa_t gpa,
+			     unsigned int size, unsigned int pg_size,
+			     bool from_guest)
 {
-	u32 access = VMX_AR_DPL(vmcs_read32(GUEST_SS_AR_BYTES)) == 3 ? PFERR_USER_MASK : 0;
-	gpa_t gpa;
+	unsigned int len, offset_in_pg;
 	void *hva;
-	int ret;
 
-	/*FIXME: need check the gva per page granularity */
-	ret = gva2gpa(vcpu, gva, &gpa, access, exception);
-	if (ret)
-		return ret;
+	offset_in_pg = (unsigned int)gpa & (pg_size - 1);
+	len = (size > (pg_size - offset_in_pg)) ? (pg_size - offset_in_pg) : size;
 
 	hva = host_gpa2hva(gpa);
 	if (from_guest)
-		memcpy(addr, hva, bytes);
+		memcpy(addr, hva, len);
 	else
-		memcpy(hva, addr, bytes);
+		memcpy(hva, addr, len);
 
-	return bytes;
+	return len;
+}
+
+/* only support host VM now */
+static int copy_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
+		unsigned int bytes, struct x86_exception *exception, bool from_guest)
+{
+	u32 access = VMX_AR_DPL(vmcs_read32(GUEST_SS_AR_BYTES)) == 3 ? PFERR_USER_MASK : 0;
+	gpa_t gpa;
+	unsigned int len;
+	int ret = 0;
+
+	while ((bytes > 0) && (ret == 0)) {
+		ret = gva2gpa(vcpu, gva, &gpa, access, exception);
+		if (ret >= 0) {
+			len = __copy_gpa(vcpu, addr, gpa, bytes, PAGE_SIZE, from_guest);
+			if (len == 0)
+				return -EINVAL;
+			gva += len;
+			addr += len;
+			bytes -= len;
+		}
+	}
+
+	return ret;
 }
 
 int read_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
@@ -149,15 +169,18 @@ int write_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
 static int copy_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr,
 		unsigned int bytes, bool from_guest)
 {
-	void *hva;
-
-	hva = host_gpa2hva(gpa);
-	if (from_guest)
-		memcpy(addr, hva, bytes);
-	else
-		memcpy(hva, addr, bytes);
+	unsigned int len;
+
+	while (bytes > 0) {
+		len = __copy_gpa(vcpu, addr, gpa, bytes, PAGE_SIZE, from_guest);
+		if (len == 0)
+			return -EINVAL;
+		gpa += len;
+		addr += len;
+		bytes -= len;
+	}
 
-	return bytes;
+	return 0;
 }
 
 int read_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr, unsigned int bytes)
-- 
2.25.1

