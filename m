Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A0E23C272
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 02:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgHEAHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 20:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgHEAHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 20:07:21 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2050B207FC;
        Wed,  5 Aug 2020 00:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596586041;
        bh=G6Ls60G1p7/lK3fk6e/sRTemDHPjcC/lg/3ueIN/YOo=;
        h=Date:From:To:Cc:Subject:Reply-To:From;
        b=lja33rx8I5UmhP4/1Hrm49YKFZxIIFRpSU1p1KvntOxIosDBguHOhHBfiPGOLpREG
         P035C8NLXrtaTlW0Ojsj2yktv2P3LyKJTOio392VOskjqH6iLZ0MuKAMlE2jjfW5Ie
         Z6x4BVyTfLJBXg8cFaWRAcs+IIib0LcgYPKY0d6U=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id EAEFD35230FA; Tue,  4 Aug 2020 17:07:20 -0700 (PDT)
Date:   Tue, 4 Aug 2020 17:07:20 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
Subject: Guest OS migration and lost IPIs
Message-ID: <20200805000720.GA7516@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello, Paolo!

We are seeing occasional odd hangs, but only in cases where guest OSes
are being migrated.  Migrating more often makes the hangs happen more
frequently.

Added debug showed that the hung CPU is stuck trying to send an IPI (e.g.,
smp_call_function_single()).  The hung CPU thinks that it has sent the
IPI, but the destination CPU has interrupts enabled (-not- disabled,
enabled, as in ready, willing, and able to take interrupts).  In fact,
the destination CPU usually is going about its business as if nothing
was wrong, which makes me suspect that the IPI got lost somewhere along
the way.

I bumbled a bit through the qemu and KVM source, and didn't find anything
synchronizing IPIs and migrations, though given that I know pretty much
nothing about either qemu or KVM, this doesn't count for much.

The guest OS is running v5.2, so reasonably recent.  It is using
QEMU Guest Agent 2.12.0.  The host is also running v5.2 and providing
qemu-system-x86_64 version 2.11.0.

Is this a known problem?  Is there some debugging options I should enable?
Any other patch I should apply?

							Thanx, Paul
