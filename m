Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12931A23D1
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 16:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgDHONT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 10:13:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49924 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgDHONT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 10:13:19 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jMBRr-0007Ob-HA; Wed, 08 Apr 2020 16:12:59 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id A83CE10069D; Wed,  8 Apr 2020 16:12:58 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: Re: [RFC PATCH 00/26] Runtime paravirt patching
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
Date:   Wed, 08 Apr 2020 16:12:58 +0200
Message-ID: <87k12qawwl.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ankur Arora <ankur.a.arora@oracle.com> writes:
> A KVM host (or another hypervisor) might advertise paravirtualized
> features and optimization hints (ex KVM_HINTS_REALTIME) which might
> become stale over the lifetime of the guest. For instance, the
> host might go from being undersubscribed to being oversubscribed
> (or the other way round) and it would make sense for the guest
> switch pv-ops based on that.

If your host changes his advertised behaviour then you want to fix the
host setup or find a competent admin.

> This lockorture splat that I saw on the guest while testing this is
> indicative of the problem:
>
>   [ 1136.461522] watchdog: BUG: soft lockup - CPU#8 stuck for 22s! [lock_torture_wr:12865]
>   [ 1136.461542] CPU: 8 PID: 12865 Comm: lock_torture_wr Tainted: G W L 5.4.0-rc7+ #77
>   [ 1136.461546] RIP: 0010:native_queued_spin_lock_slowpath+0x15/0x220
>
> (Caused by an oversubscribed host but using mismatched native pv_lock_ops
> on the gues.)

And this illustrates what? The fact that you used a misconfigured setup.

> This series addresses the problem by doing paravirt switching at
> runtime.

You're not addressing the problem. Your fixing the symptom, which is
wrong to begin with.

> The alternative use-case is a runtime version of apply_alternatives()
> (not posted with this patch-set) that can be used for some safe subset
> of X86_FEATUREs. This could be useful in conjunction with the ongoing
> late microcode loading work that Mihai Carabas and others have been
> working on.

This has been discussed to death before and there is no safe subset as
long as this hasn't been resolved:

  https://lore.kernel.org/lkml/alpine.DEB.2.21.1909062237580.1902@nanos.tec.linutronix.de/

Thanks,

        tglx
