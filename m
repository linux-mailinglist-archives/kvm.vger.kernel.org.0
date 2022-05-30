Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6004538523
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 17:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbiE3PmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 11:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240606AbiE3PmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 11:42:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C0320FC52;
        Mon, 30 May 2022 07:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653922155; x=1685458155;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xcOydMoGrTfPeiG4u/paPT/YoYgwMhUeig4F7gxUuY8=;
  b=FaeC9TU5m0T/THcYrKB83tAtu4e4BsAoVcupO0N7oA99fEh0eSEpkmhu
   hXv7XYAwsusuL2uvzaLWWpr7qajI+XLzR0TuHb6Ofe/ax8jQtYthpSQWN
   3AOYMcFEKxqVYobTOkayQYJpPxugCyHQ4krQZa5353Cuyg1aHGEGXyD46
   xOKql8LzQHZqR1t8b/33kQcJgD0NWa8b29sBDhr5+vCDFrEfQBQbSvhAH
   JHZoRzxiepALimJZz5N2VnWIDrUZtE0dgDa+J+gipx3EamxjLr8Mstcnf
   0hyo2GQPr4uug2NAO9fBnUsOPQ83VoEQ6WGw2JlLmU65WcYAwsI7WwLbE
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="361394724"
X-IronPort-AV: E=Sophos;i="5.91,263,1647327600"; 
   d="scan'208";a="361394724"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 07:49:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,263,1647327600"; 
   d="scan'208";a="903585639"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 07:49:01 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH] KVM: x86: Bypass cpuid check for empty arch-lbr leaf
Date:   Mon, 30 May 2022 10:48:29 -0400
Message-Id: <20220530144829.39714-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On arch-lbr capable platforms, cpuid(0x1c,0) returns meaningful
arch-lbr supported values, in this case, eax[7:0] = lbr depth mask.
Whereas on legacy platforms(non-arch-lbr), cpuid(0x1c,0) returns
with eax/ebx/ecx/edx zeroed out.

On legacy platforms, during selftests app startup, it first gets
supported cpuids by KVM_GET_SUPPORTED_CPUID then sets the returned
data with KVM_SET_CPUID2, this leads to empty cpuid leaf(0x1c,0)
written to KVM and makes the check fail, app finally ends up with
below error message when run selftest:

 KVM_SET_CPUID2 failed, rc: -1 errno: 22

So check the validity of the leaf(0x1c,0) before validate lbr
depth value.

QEMU filters out empty CPUID leaves before calls KVM_SET_CPUID2,
so this is not a problem.

Fixes: 4b73207592: ("KVM: x86/cpuid: Advertise Arch LBR feature in CPUID")
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9c107b5cc88f..c2eab1a73aab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -103,13 +103,14 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 	}
 	best = cpuid_entry2_find(entries, nent, 0x1c, 0);
-	if (best) {
+	if (best && best->eax) {
 		unsigned int eax, ebx, ecx, edx;
 
 		/* Reject user-space CPUID if depth is different from host's.*/
 		cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
 
-		if ((best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
+		if ((eax & 0xff) &&
+		    (best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
 			return -EINVAL;
 	}
 
-- 
2.27.0

