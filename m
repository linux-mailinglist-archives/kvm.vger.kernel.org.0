Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A464D3120
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 15:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbiCIOj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 09:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiCIOjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 09:39:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E571127D64
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 06:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=YmUKfUY0KXlFeGv0zXdttBCjvw8njW5rIqWdbXOkVyA=; b=BinXYwPrzMSRoM65o+gFMrDJuY
        QAIjNdgN7U1N781B9osJYs/NNJkZSs08Q4qT36Y45Ptg2lmrJ7TBdZjfxImKPjTxHFDVn0HpmPoHy
        u9hjYns9yYZWzs6bBB8mFQ8NcUBatvO/0IxGWGPTw7rajPNKeGA/m8n5+hsda+XVDL+RtGmVIVeqi
        mqUVxGiDgEVuo+xICb+zf/r66g12UBw3sNWkpzjMWdHl+L7dK+eDB96QyRMuzUx05uprm7j7AJX9x
        rBv+VxdqnXNIvsB5qRtpqH2y4C+zYkK0PLPK7eli50uIKMYa9/KDftLe7Lb/oKn3TIXfc73kLQ8OQ
        I8zrsVyw==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRxSX-00HCee-Vl; Wed, 09 Mar 2022 14:38:38 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRxSX-00143e-44; Wed, 09 Mar 2022 14:38:37 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH 0/2] KVM: Xen PV timer fixups
Date:   Wed,  9 Mar 2022 14:38:33 +0000
Message-Id: <20220309143835.253911-1-dwmw2@infradead.org>
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

For squashing into the relevant commits already in kvm/queue, as discussed.

Note that I've switched the immediate timer delivery to just call the
xen_timer_callback() function, because I couldn't see *why* just setting
the ->arch.xen.timer_pending flag actually worked, without also setting
KVM_REQ_UNBLOCK. I suspect that the timer was only actually getting set
after the vCPU exited for some *other* reason. This should be better.

I'll follow up separately with a patch to remove __kvm_migrate_apic_timer
because it seems to be utterly pointless now.

David Woodhouse (2):
      KVM: x86/xen: PV oneshot timer fixes
      KVM: x86/xen: Update self test for Xen PV timers

 arch/x86/kvm/irq.c                                 |  1 -
 arch/x86/kvm/xen.c                                 | 37 +++++++++-------------
 arch/x86/kvm/xen.h                                 |  1 -
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 35 ++++++++++++++++++--
 4 files changed, 47 insertions(+), 27 deletions(-)



