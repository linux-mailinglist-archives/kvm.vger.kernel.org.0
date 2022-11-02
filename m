Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADAF615732
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 03:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiKBCBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 22:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKBCBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 22:01:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DD217E3C
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 19:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667354504; x=1698890504;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vkyYbqaGgT5Xnt4eTCsxAg6Tkm1iI8W4kMybmjDfcAk=;
  b=cVt+21AhAslRSjYflRv1Dh4Uu7duASDxnvCDYkdJOum5WR4SWZTIGsB6
   +jBKUynvPyta7tXmCjDK9+y97zJO8zjy27jOJ5t9SdORYIG/NutuTJpkr
   xTK1xOVNBusABzGnb/lK8bzFjZxFSrAXPru0VccTkTCIpw9yTCNfemJKT
   Tx9PvMUpFT5B381ZkMKLP0zRJaPFVKFRjI6S02TevoTPKsiwL0C/keyVp
   oCPf91ktkzYKVrzy5mzPmuMJ51RoiF+b2Osch89TdCwyyMieReGoWhYrJ
   T5D4jR+mTiD/vMb9rcfYaqeoBl2pNHat2XNoLbAPPcN2VhXCBuXwVlsVZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="289676974"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="289676974"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 19:01:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="667405985"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="667405985"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 01 Nov 2022 19:01:42 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, gshan@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC 0/1] KVM: selftests: rseq_test: use vdso_getcpu() instead of syscall()
Date:   Wed,  2 Nov 2022 10:01:27 +0800
Message-Id: <20221102020128.3030511-1-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently, our QA often meet the test assert failure in KVM selftest rseq_test.
e.g.
==== Test Assertion Failure ====
  rseq_test.c:273: i > (NR_TASK_MIGRATIONS / 2)
  pid=391366 tid=391366 errno=4 - Interrupted system call
     1	0x00000000004027dd: main at rseq_test.c:272
     2	0x00007f7fc383ad84: ?? ??:0
     3	0x000000000040286d: _start at ??:?
  Only performed 32083 KVM_RUNs, task stalled too much?

Though this is not a bug [1], passing this assert means the race condition
can be more hit, which is the original purpose of this test case design.

[1] https://lore.kernel.org/kvm/YvwYxeE4vc%2FSrbil@google.com/

Robert Hoo (1):
  KVM: selftests: rseq_test: use vdso_getcpu() instead of syscall()

 tools/testing/selftests/kvm/rseq_test.c | 32 ++++++++++++++++++-------
 1 file changed, 24 insertions(+), 8 deletions(-)

-- 
2.31.1

