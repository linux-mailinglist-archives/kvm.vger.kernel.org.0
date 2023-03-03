Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8816AA11D
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjCCV0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjCCV0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:26:22 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3EA16895
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:26:21 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 2A86437E2A80C1
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:26:20 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id zPzpdEe7gOjq for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:26:17 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 2499537E2A80BE
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:26:17 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 2499537E2A80BE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1677878777; bh=eYCFxhNirnI2z4sklWYjo6zIDKkPJOTRZljoJjItkd8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=iBo3b8ijRVG7WgY0EsliZ58bVpr2MEPDotd6M168cdf6RmjQBjgeHp2easjteY3hd
         eTP6ybjzkoI2U6RclUn7aay/Y21Zpz+BmuZjFAo2lX6XIApfnKxo1037ubWCZA9iPt
         lYNKojCJZmeFrUXM5wtdnYsOvTtYtbAamH8pVU3g=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tNCa7ytextLR for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:26:17 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 0510437E2A80B8
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:26:17 -0600 (CST)
Date:   Fri, 3 Mar 2023 15:26:16 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm <kvm@vger.kernel.org>
Message-ID: <1600427009.16280447.1677878776992.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH 1/5] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support platform
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Index: I3kfQduzkb4FwEJ3F9vhyBUsR6gs2g==
Thread-Topic: Make KVM_CAP_IRQFD_RESAMPLE support platform
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 dependent

When introduced, IRQFD resampling worked on POWER8 with XICS. However
KVM on POWER9 has never implemented it - the compatibility mode code
("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
XIVE mode does not handle INTx in KVM at all.

This moved the capability support advertising to platforms and stops
advertising it on XIVE, i.e. POWER9 and later.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
---
 arch/arm64/kvm/arm.c       | 3 +++
 arch/mips/kvm/mips.c       | 3 +++
 arch/powerpc/kvm/powerpc.c | 6 ++++++
 arch/riscv/kvm/vm.c        | 3 +++
 arch/s390/kvm/kvm-s390.c   | 3 +++
 arch/x86/kvm/x86.c         | 3 +++
 virt/kvm/kvm_main.c        | 1 -
 7 files changed, 21 insertions(+), 1 deletion(-)
