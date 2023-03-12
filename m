Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0C66B69BC
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbjCLSGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjCLSFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:05:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411DF515D6;
        Sun, 12 Mar 2023 11:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644058; x=1710180058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K6yOwacD21iVROsJclA1EtXBnJwa3Xran9dNSfuwsUc=;
  b=GqFtBKxR9NhqxvgI2ROrEokEHvrNd6xn6DUUGDUnlM1HHpuP/geDAlQ6
   3E7Xh97FR/3qXDXJqMHRyBXYPiSjYOq3YqsTgoCqIm0lxOIKYZK20cSr1
   CMM47eEVIqliFQgxSe6V5wgMWkD5cPq7sq7VCWr4HQw3zM1WS8oO7XudW
   i0pirwWkDAwy+bNp8fCZhk+HbLpLByqm6cIXdOEr2J12SyKI2nZZnf1PD
   nNm+gOg4X40nunpzdzhhes678+rJpRUJcKpEvHjo56IdHbsdNLi6kuCXS
   ds2w6ObgR1Szy9QLbhMrimLdkyrvoPnp7D9Ua00mJai4Iurr7/3CH4bQY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660090"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660090"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596823"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596823"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:15 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 097/113] KVM: TDX: Handle TDX PV report fatal error hypercall
Date:   Sun, 12 Mar 2023 10:57:01 -0700
Message-Id: <49c90761826fbc734adc467d9d8fcce63ceb5e02.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV report fatal error hypercall to exit to device model so that
it can gracefully handle it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 25332290c268..0c6386fe4684 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1234,6 +1234,13 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
+		/*
+		 * Exit to userspace device model for tear down.
+		 * Because guest TD is already panicking, returning an error to
+		 * guest TD doesn't make sense.  No argument check is done.
+		 */
+		return tdx_vp_vmcall_to_user(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

