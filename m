Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8AAA56664
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 12:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfFZKNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 06:13:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41278 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfFZKNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 06:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IEd8NPH/Ien/DbwAb2Kxr57A5BcbWTAKe/DrLHbjp14=; b=NeFOx4g+OFBtrkQG23rBcnrLa
        wfcMBDmOM5ITFU8Rko8ySC+qouVEs4JzAfkqbR615wKs1efECqwHdawkcqb1OBCfiV3wFuhRjQl4o
        rSFQ49VXh4lPLrN/nomgzgXLiBTqmtJDUueTVatuK6n+C/FK4N85Bjst7ccASekIYxnVB79uvIf18
        loAFzQ0sV7BonRTb9VYB3hrVyvbQ1ocn0ZJzZqD+TVT4ufjPSYmHBJLdPFEvsnOZ1sUhvhWERZO2P
        yWc62o45nQz0JTnZQ3psxtJkvSsJYjtDnfNrkx3khDNY6FsClQ13zM6Fuzhxk9v0W92Q6VcjOMFZZ
        18Q1PP8HQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hg4vb-00062r-N2; Wed, 26 Jun 2019 10:13:23 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 03470209CEDA8; Wed, 26 Jun 2019 12:13:20 +0200 (CEST)
Date:   Wed, 26 Jun 2019 12:13:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KarimAllah <karahmed@amazon.de>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: cputime takes cstate into consideration
Message-ID: <20190626101320.GX3402@hirez.programming.kicks-ass.net>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 26, 2019 at 05:43:55PM +0800, Wanpeng Li wrote:
> Hi all,
> 
> After exposing mwait/monitor into kvm guest, the guest can make
> physical cpu enter deeper cstate through mwait instruction, however,
> the top command on host still observe 100% cpu utilization since qemu
> process is running even though guest who has the power management
> capability executes mwait. Actually we can observe the physical cpu
> has already enter deeper cstate by powertop on host. Could we take
> cstate into consideration when accounting cputime etc?

Either we account runtime on the CPU itself, in which case it will not
be in a C state due to actually running an interrupt that does
accounting, or we do it remote (NOHZ_FULL case) and there is no way to
know what C state, if any, that CPU is in.


