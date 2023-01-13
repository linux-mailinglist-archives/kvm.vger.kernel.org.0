Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342B86697E4
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 14:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbjAMNBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 08:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjAMNAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 08:00:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2144E87906;
        Fri, 13 Jan 2023 04:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=C0qkmIIYhEbiaW9/bOLbh+d/v5T/bpSDifdQxL7LFD8=; b=jX9nDGqf5PZ/nbe/w10V/E4iWF
        m0IGq/C+6Aow/l3c0NQi/iYOqr9QT18u/TzIJpjIPiXobaOVk5GJjQIIVsA5G6vBxSQUSZqXC5mWU
        gT+sTwOXvUmyMn9CEMnxNJlygno+m7C8tmzXsSEUgzcPcWbp+RBD+leGGqUoPJih7dSpredPYdY2N
        T04xhwPbrUYYmLyzzEmkOlbURgT1anPGPDe2c3eolRztUT+RfVUOzXUIsM/2mnXGNTj1/Y4HhBPr8
        LXHUSY5w4DGmpZsd5quhb8rK2axOoNSyMYicRy8oRflEwXnn1MUEoyFpgwNDNm7qG8gGXu/0/KFjG
        7MqhlK7A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGJRy-0065y2-TV; Fri, 13 Jan 2023 12:46:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGJRl-0002jg-El; Fri, 13 Jan 2023 12:46:13 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/3] KVM: Make use of SRCU deadlock detection support
Date:   Fri, 13 Jan 2023 12:46:03 +0000
Message-Id: <20230113124606.10221-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230113065955.815667-1-boqun.feng@gmail.com>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Thu, 2023-01-12 at 22:59 -0800, Boqun Feng wrote:
> This is actually a leftover of the recursive read deadlock detection
> patchset:
> 
>         https://lore.kernel.org/lkml/20180411135647.21496-1-boqun.feng@gmail.com/
> 
> I resolve comments then and add more test cases, and hopefully this can
> fulfill the request from KVM:
> 
>         https://lore.kernel.org/lkml/a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org/
> 
> ;-)

It definitely seems to work; thank you! I can revert some of the recent 
fixes from the KVM tree, apply your patches, and then I can trigger the 
lockdep warnings. To make it reliably trigger, we need to artificially
call synchronize_srcu(&kvm->srcu) under kvm->lock on KVM init, because
the circumstances under which that happens are a bit esoteric and don't
always happen otherwise, so lockdep wouldn't notice.

> The patch #3 is now WIP for two reasons:
> 
> *       It may conflicts with Paul's patchset on removing CONFIG_SRCU
> 
> *       I haven't found a proper way to "reinit" srcu_struct when
>         lockdep selftest runs: cleanup_srcu_struct() needs workqueue
>         however the tests can run before there is one.

Understood. I think the KVM series which follows can stand alone and go 
via the KVM tree separately. As and when your series gets merged, it'll 
serve to protect against regressions.

Thanks again!

David Woodhouse (3):
      KVM: Show lockdep the kvm->mutex vs. kvm->srcu ordering rule
      KVM: selftests: Use enum for test numbers in xen_shinfo_test
      KVM: selftests: Add EVTCHNOP_send slow path test to xen_shinfo_test

 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 165 ++++++++++++++-------
 virt/kvm/kvm_main.c                                |  10 ++
 2 files changed, 124 insertions(+), 51 deletions(-)


