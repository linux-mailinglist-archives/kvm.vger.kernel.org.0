Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D474179F87E
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 04:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbjINCzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 22:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbjINCzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 22:55:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE021713
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 19:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694660102; x=1726196102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WRCprGN7GG1G4bqjg2CjUBD263E5209enVg7iPsDOPw=;
  b=RT+K/BNO3rO//2AdNfhLnYzIoe2LNZ1rFRdJgkaGMM/it1ZDjjjYSXjg
   UqpcPG8KrqWt0JUfzHNLgH+Qz63GM2xnOCCbm1R4AL5sfsUlHlSqa7GPq
   Rc65lCoTJQ57GKtPhxQu4uIx6F6ldAhcRtogqmefFs1gazD6qH4Mm0/LB
   sHNM8EvRPO7z58boKAfFcTd0qWqOzU/WwZqoo+7t3Ar0yZ46rb+s8QwK6
   HU9f6Jh/6oO2hD/zRA8+myDpl37ggTGg0tA/WEtVQRbwq+Q3G0j8fwMvZ
   5J/GCPWpv4OAkFZWgzWpRhz+qGXb0GkyQ0nUoVYKNsNnZLFTM+7EkTQ0y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="442869327"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="442869327"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="694070838"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="694070838"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:55:00 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2 1/3] x86: VMX: Exclude CR4.CET from the test_vmxon_bad_cr()
Date:   Wed, 13 Sep 2023 19:50:04 -0400
Message-Id: <20230913235006.74172-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230913235006.74172-1-weijiang.yang@intel.com>
References: <20230913235006.74172-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET KVM enabling patch series introduces extra constraints on CR0.WP and
CR4.CET bits, i.e., setting CR4.CET == 1 causes fault if CR0.WP == 0. Skip
the bit testing to avoid folding it in flexible_cr4 and finally trigger
a #GP when write the CR4 with CET bit set while CR0.WP is cleared.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 12e42b06..1c27850f 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1430,7 +1430,7 @@ static int test_vmxon_bad_cr(int cr_number, unsigned long orig_cr,
 		 */
 		if ((cr_number == 0 && (bit == X86_CR0_PE || bit == X86_CR0_PG)) ||
 		    (cr_number == 4 && (bit == X86_CR4_PAE || bit == X86_CR4_SMAP ||
-					bit == X86_CR4_SMEP)))
+					bit == X86_CR4_SMEP || bit == X86_CR4_CET)))
 			continue;
 
 		if (!(bit & required1) && !(bit & disallowed1)) {
-- 
2.27.0

