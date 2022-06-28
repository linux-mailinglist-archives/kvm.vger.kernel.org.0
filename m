Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC1A55E683
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346232AbiF1OYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 10:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiF1OYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 10:24:51 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421482CDC3
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 07:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=knujGBxYY2qiCBca33fYktYUxbCVItelGQwKtFgbXLQ=; b=YHXKB0h4v3vUY8bGyl/
        pSoRivup7qsSIf3SnRiTbz5rGya+lg2tL7sEMPgi0rUpAF7r7DTMN7BAL+HWIFhsANlObiJ26roMQ
        wyAz0Uq8/VMEwCtV5IFZhI7xDijw2TT4nhYEQUxTdRsJH16ydoYEed2GyUE61FiYKx7t3zAAXPc=;
Received: from [192.168.16.175] (helo=mikhalitsyn-laptop)
        by relay.virtuozzo.com with esmtp (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1o6C7U-007ayt-Se; Tue, 28 Jun 2022 16:23:13 +0200
Date:   Tue, 28 Jun 2022 17:23:42 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, babu.moger@amd.com,
        den@virtuozzo.com, ptikhomirov@virtuozzo.com,
        alexander@mihalicyn.com
Subject: [RFC] SVM: L2 hang with fresh L1 and old L0
Message-Id: <20220628172342.ffbb5b087260ef3046797492@virtuozzo.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear friends,

Recently, we (in OpenVZ) noticed an interesting issue with
L2 VM hang on RHEL 7 based hosts with SVM (AMD).

Let me describe our test configuration:
- AMD EPYC 7443P (Milan) or AMD EPYC 7261 (Rome)
- RHEL 7 based kernel on the Host Node.
... and most important:

L0 -----------> L1 --------> L2
RHEL 7       -> RHEL 7 --------> RHEL 7        *works*
RHEL 7       -> RHEL 7 --------> RHEL 8        *works*
RHEL 7       -> RHEL 7 --------> recent Fedora *works*
RHEL 7       -> RHEL 8 --------> RHEL 7        *L2 hang*
RHEL 7       -> fresh Fedora --> RHEL 7        *L2 hang*

or even more:
RHEL 7       -> RHEL 7 --------> *any tested Linux guest*  *works*
RHEL 7       -> RHEL 8 --------> *any tested Linux guest*  *L2 hang*

but at the same time:
RHEL 8       -> RHEL 8 --------> *any tested Linux guest*  *works*

It was the key observation and I've started bisecting L1 kernel to find
some hint. It was commit:
c9d40913 ("KVM: x86: enable event window in inject_pending_event")

At the same minute I've tried to revert it for CentOS 8 kernel and retry test,
and it... works! To conclude, if we have an *old* kernel on host and *sufficiently new* kernel
in L1 then L2 totaly broken (only for SVM).

I've tried to port this patch for L0 kernel and check if it will fix the issue. And yes,
it works. I wonder if it will be useful information for KVM developers and users.

My attempt to port it for RHEL 7 kernel:
https://lists.openvz.org/pipermail/devel/2022-June/079776.html

Possibly I need to port this patches for stable kernels too and send it?

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=v4.9.320&qt=grep&q=enable+event+window+in+inject_pending_event
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=v4.14.285&qt=grep&q=enable+event+window+in+inject_pending_event
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=v4.19.249&qt=grep&q=enable+event+window+in+inject_pending_event
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=v5.4.201&qt=grep&q=enable+event+window+in+inject_pending_event

So, 4.9, 4.14, 4.19 and 5.4 kernels lacks this patch.

I've not checked that yet but it looks like, for instance,

L0  -> L1   -> L2
5.4 -> 5.10 -> *any kernel version*

setup will hang for SVM.

Regards,
    Alex
