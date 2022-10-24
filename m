Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7A160A21E
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiJXLj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiJXLi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:38:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C496D877;
        Mon, 24 Oct 2022 04:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611494; x=1698147494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V5CMqFlWnS5AeCB0CE61Ephj3ol/+ZP60Gy/5sHQJ6E=;
  b=FWgR9JmZdq3Jga8/AXjnwgFwNWgipP9yWdJnBRqqDmLizCdgaMOWNGIJ
   fuKbFlT77/El+F83NAwRR5JvcfY0LMjyFUFIv1yPTioU4eYCa+tTyxENk
   KphQaczZSDbkN4ElsXn5DTzmpggUob7YDB7+Ds8ux6PTrTGHhp8QkHnHh
   y1NY56PdiCdTkM/WBTfUKCBQ365G72ffgs+Bk6YWd5JH8o+qOnaEssY0p
   WRn/Blmw2Jqkk5rvZpRoV8CLbwdXdP5dY990fSSsONh+jdz9OfD7wvBv+
   Mv4+E5/sU3vL5bMChBAiRxwN67a6gR3B5sq0LotOLSmp+AiRtxfsXDCvp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="369462511"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="369462511"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:35:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773785085"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773785085"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:35:32 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 18/18] KVM: selftests/kvm_create_max_vcpus: check KVM_MAX_VCPUS
Date:   Mon, 24 Oct 2022 19:34:45 +0800
Message-Id: <20221024113445.1022147-19-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221024113445.1022147-1-wei.w.wang@intel.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the KVM side max vcpu number is larger than the one supported by the
userspace selftests, adjust the max number.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index 31b3cb24b9a7..bbdb371e21ed 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -50,6 +50,13 @@ int main(int argc, char *argv[])
 
 	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
 	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
+	pr_info("selftests KVM_MAX_VCPUS: %d\n", KVM_MAX_VCPUS);
+
+	if (kvm_max_vcpu_id > KVM_MAX_VCPUS)
+		kvm_max_vcpu_id = KVM_MAX_VCPUS;
+
+	if (kvm_max_vcpus > KVM_MAX_VCPUS)
+		kvm_max_vcpus = KVM_MAX_VCPUS;
 
 	/*
 	 * Check that we're allowed to open nr_fds_wanted file descriptors and
-- 
2.27.0

