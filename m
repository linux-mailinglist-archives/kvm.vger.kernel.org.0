Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA89566D6
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 12:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfFZKdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 06:33:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46716 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfFZKdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 06:33:40 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hg5F5-0003yZ-6N; Wed, 26 Jun 2019 12:33:31 +0200
Date:   Wed, 26 Jun 2019 12:33:30 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Wanpeng Li <kernellwp@gmail.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KarimAllah <karahmed@amazon.de>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: cputime takes cstate into consideration
In-Reply-To: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Jun 2019, Wanpeng Li wrote:
> After exposing mwait/monitor into kvm guest, the guest can make
> physical cpu enter deeper cstate through mwait instruction, however,
> the top command on host still observe 100% cpu utilization since qemu
> process is running even though guest who has the power management
> capability executes mwait. Actually we can observe the physical cpu
> has already enter deeper cstate by powertop on host. Could we take
> cstate into consideration when accounting cputime etc?

If MWAIT can be used inside the guest then the host cannot distinguish
between execution and stuck in mwait.

It'd need to poll the power monitoring MSRs on every occasion where the
accounting happens.

This completely falls apart when you have zero exit guest. (think
NOHZ_FULL). Then you'd have to bring the guest out with an IPI to access
the per CPU MSRs.

I assume a lot of people will be happy about all that :)

Thanks,

	tglx

