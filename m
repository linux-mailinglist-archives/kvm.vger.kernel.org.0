Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3938D79F880
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 04:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbjINCzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 22:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbjINCzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 22:55:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD631724
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 19:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694660103; x=1726196103;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0Lu0tp+5mShhsOkO7rfZyd3il62dm8YwKEwvWFiBQzk=;
  b=NRIdEpjmfdQp4K4WhwRLbgo9D+wnBvOwzfVDYDxC1siAAc2b+3WmHYei
   XnUTeh23rMZURwSRGePpVpR9MSWKHTMI44vYGQ76UPo0IZ0H+oean3zw0
   5xALAFNORTVVlhq01Qt1mV7TcNH/qzmwo8sJsgnKypk+Z+9+JofHGFifD
   7bPEX5MP/TX4agI3KnrCbPUI3Dc7d4IEEm7g1DNhufPShlC00GEoHFUkP
   NJQ2Ib6KXayyBQHdeUcJEtWah9w/PjIH7HluX4LXh5HOAANP8k5vp9N4k
   tWzd9Pci/2jlxzTwDTm/6i30Tt4qEwr7tcUm/P7OvFL4Fw1cyFaFOhkHE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="442869330"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="442869330"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="694070835"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="694070835"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:55:00 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2 0/3] Fix test failures caused by CET KVM series
Date:   Wed, 13 Sep 2023 19:50:03 -0400
Message-Id: <20230913235006.74172-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET KVM series causes sereral test cases fail due to:
1) New introduced constraints between CR0.WP and CR4.CET bits, i.e., setting
 CR4.CET == 1 fails if CR0.WP == 0, and setting CR0.WP == 0 fails if CR4.CET
== 1
2) New introduced support of VMX_BASIC[bit56], i.e., skipping HW consistent
check for event error code if the bit is set.

Opportunistically rename related struct and variable to avoid confusion.

Yang Weijiang (3):
  x86: VMX: Exclude CR4.CET from the test_vmxon_bad_cr()
  x86: VMX: Rename union vmx_basic and related global variable
  x86:VMX: Introduce new vmx_basic MSR feature bit for vmx tests

 x86/vmx.c       | 46 +++++++++++++++++++++++-----------------------
 x86/vmx.h       |  7 ++++---
 x86/vmx_tests.c | 31 ++++++++++++++++++++++---------
 3 files changed, 49 insertions(+), 35 deletions(-)

-- 
2.27.0

