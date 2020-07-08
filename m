Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C5D2190FB
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgGHTxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:53:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53396 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgGHTxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:53:39 -0400
Message-Id: <20200708195153.746357686@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594238017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-transfer-encoding:content-transfer-encoding;
        bh=bNyLQ2pLAkRr83wZdq7rI6euSlnFR18flvxonxI4IPc=;
        b=fhWKxJO8AJQIGkBtx+zEZWMkxgE/gBzC2xEQWs1RGdbiGYNp8jTuTPdpwriTNdrii0praZ
        v6n/lTO2qEoXA/Camh+240xiDe/KsNE6bu27ldaCBDkY+Dfa7yHNYtouca5ujyAxbnM8gn
        dpaBNkwsWsnh3n75n0iCr8OIIUGOLvz8oN2XS42rmuJ5oTb65rLqUz9DLHwwSXqK1ooQLS
        Tl4KAi48kLeWWIIqV1ntRez1wboFVHWKTlEPAubbiDtTk6sjwhPvhX4/ysTV6RB9tfQOgA
        eCjuyKIeFQbIXpLKggzIEe7Gj8njkYeRjWf9dg3Ds6DybIJIlKKP3V/rS/rB4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594238017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-transfer-encoding:content-transfer-encoding;
        bh=bNyLQ2pLAkRr83wZdq7rI6euSlnFR18flvxonxI4IPc=;
        b=+TUlVf4VktQeA7sSpjob2JKU4jDcApGvCeiZy1Ij6W47C62fLXBTy38rkYesfBN67HIqC7
        q7VvxLowuX7asaAg==
Date:   Wed, 08 Jul 2020 21:51:53 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>
Subject: [patch V2 0/7] x86/kvm: RCU/context tracking and instrumentation protections
Content-transfer-encoding: 8-bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Folks,

this is a rebased and adopted version of the original series which is
available here:

     https://lore.kernel.org/r/20200519203128.773151484@linutronix.de
 
It deals with the RCU and context tracking state and the protection against
instrumentation in sensitive places:

  - Placing the guest_enter/exit() calls at the correct place

  - Moving the sensitive VMENTER/EXIT code into the non-instrumentable code
    section.

  - Fixup the tracing code to comply with the non-instrumentation rules

  - Use native functions to access CR2 and the GS base MSR in the critical
    code pathes to prevent them from being instrumented.

Thanks,

	tglx
