Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED0F4C47EC
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241887AbiBYOxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241418AbiBYOxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:53:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0828B16BCF3;
        Fri, 25 Feb 2022 06:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=xaxOXBtujuW9uyicNAfeVnfUux3BVVJlbMbJqV3HFAc=; b=VuHHYHAfi9B30spmmkXXDYbDng
        HOphZQvUkoXrx/0CQz8Utb4GII53ds/vaahlt7yV5hdMkTxusmuwgsCaY+Ob2icYLXwUeD9cGoqSp
        eElxk2Emy+9zI1pNCWJjtVXfIM6ti9yUSoiFprfe1lhBwNVjSSgHF7FgPwUfAgO+WUXukyoTV2dUc
        LcvY5PHG/dKlAGsruFyKDAzrEyDfvO4CKAOLIIfVUCPGzz6oAXe389vAOqjYeavzNdhmpq82gRDP8
        8THoNyPR+cyMmb5YwchU/pHl/7n+3H6hdbluEKISw6SBb9Vxipaf8+EWt514Y/q8NCfsfBvqIls2u
        pn3Oqk2A==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNbxy-005rrz-IU; Fri, 25 Feb 2022 14:53:06 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNbxx-0009Pb-QK; Fri, 25 Feb 2022 14:53:05 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Anton Romanov <romanton@google.com>
Subject: [PATCH 0/3] KVM: Reduce TSC scaling race condition mess
Date:   Fri, 25 Feb 2022 14:53:01 +0000
Message-Id: <20220225145304.36166-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As Sean says, we punt on a proper fix... but at least now I can create a
bunch of vCPUs with a scaled TSC and their TSC synchronization isn't 
*utterly* hosed, so the test case I posted last night is actually passing.

It would still be nice for the original test case to work, where each
vCPU thread creates its own vCPU, then sets the scale and the current
TSC value. But this resolves most sane use cases.

David Woodhouse (2):
      KVM: x86: Accept KVM_[GS]ET_TSC_KHZ as a VM ioctl.
      KVM: x86: Test case for TSC scaling and offset sync

Sean Christopherson (1):
      KVM: x86: Don't snapshot "max" TSC if host TSC is constant

 Documentation/virt/kvm/api.rst                        |  11 +++--
 arch/x86/include/asm/kvm_host.h                       |   2 +
 arch/x86/kvm/x86.c                                    |  54 ++++++++++++++++------
 include/uapi/linux/kvm.h                              |   4 +-
 tools/testing/selftests/kvm/Makefile                  |   1 +
 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 171 insertions(+), 20 deletions(-)


