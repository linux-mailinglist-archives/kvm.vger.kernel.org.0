Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7A45BF334
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 04:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiIUCCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 22:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiIUCCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 22:02:36 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DC578BF2
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 19:02:33 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oap4I-00Eq7Y-75
        for kvm@vger.kernel.org; Wed, 21 Sep 2022 04:02:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=nz0kTnJmrF/qDSK11DUbst+WRyBkRpC/jTvnozuwSVI=; b=GVzlqqqjI9b0hdSN+Jyjhf0JxF
        7C5APGXmmvmoD0P7MzR+FOSlYNMJAKoX92UgKl3ZfIakgBYHn9/TjDGe45ZZeNwuXba+oSPTNsF1g
        6022HvGh1TjSmXqndczBdqz6YM0cDitkYfUWNoExGvWEhbbEUX6K2kOxWSp9DDGNC0vYpTChhtOZD
        gSop1jBQ1G/e5Hiv9ft6iqKTi60k2t2NUJFf17PK/ponjJ02zVJBK2mBh0hfuABYwCCBHPMRjQWvP
        sDijzQUZCWmiiZugfDHNZyzk85eHlJrrqnMd2dF4J+mJ70/0rNwbiO0y/km9e/qTxoTlal0Ow5iwC
        1bDW9W/w==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oap4H-0007BR-SV; Wed, 21 Sep 2022 04:02:30 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oap3w-0006er-3l; Wed, 21 Sep 2022 04:02:08 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/8] KVM: x86: gfn_to_pfn_cache cleanups and a fix
Date:   Wed, 21 Sep 2022 04:01:32 +0200
Message-Id: <20220921020140.3240092-1-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <YySujDJN2Wm3ivi/@google.com>
References: <YySujDJN2Wm3ivi/@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here are some clean ups following Sean's suggestions and a single fix
for a race condition.

Michal Luczaj (8):
  KVM: x86: Add initializer for gfn_to_pfn_cache
  KVM: x86: Shorten gfn_to_pfn_cache function names
  KVM: x86: Remove unused argument in gpc_unmap_khva()
  KVM: x86: Store immutable gfn_to_pfn_cache properties
  KVM: x86: Clean up kvm_gpc_check()
  KVM: x86: Clean up hva_to_pfn_retry()
  KVM: x86: Clean up kvm_gpc_refresh(), kvm_gpc_unmap()
  KVM: x86: Fix NULL pointer dereference in kvm_xen_set_evtchn_fast()

 arch/x86/kvm/x86.c        | 24 ++++++------
 arch/x86/kvm/xen.c        | 78 +++++++++++++++++--------------------
 include/linux/kvm_host.h  | 64 ++++++++++++++++---------------
 include/linux/kvm_types.h |  2 +
 virt/kvm/pfncache.c       | 81 +++++++++++++++++++++------------------
 5 files changed, 128 insertions(+), 121 deletions(-)

-- 
2.37.3

