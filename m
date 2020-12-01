Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE7A2CA4DB
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 15:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391163AbgLAOCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 09:02:09 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55688 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387628AbgLAOCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 09:02:08 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606831286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fH6vXaLD6JyknYN6wcvlAFebplSlI6lIoEByMQneE7k=;
        b=fU4+RFcpBzVQQkeBKxd/Z/TsfI8RUL4LYY0e4bzgz3Pa1bkvofiWij5DmBKKl6FOMhDabI
        kfVpDrLL3Jpgea5HXO+V16KwjaHZMHXJokQkhT6hHhkqSS8ceRCHEUBuYB4uqYL6yHO8/a
        lmlI5DQmf/OcBfaw4Ivys0TzWPCs1Oif00okWbaXjln88J7mU5aa5OLQB0OTFiYH6d7b2M
        neJHfQEwDf3DB5ZJgNIJgqNnU+tneurZwM2mDSLzDmUYfwIctWX9qI69H6NgmsoRPbYvbG
        c4XKYpcf+lexocSv18EjARBjBL/m6Wek3pVTVqXNXJjOwJikyKLWsq1P3tI48Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606831286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fH6vXaLD6JyknYN6wcvlAFebplSlI6lIoEByMQneE7k=;
        b=B3+oM+PSmOc0/ILm8QfBvak9HqhEGOT2w6vw/hq52ePbm/hmMA6AF8BmdcrH9ECvWuV36H
        tnnUOfz5fw0lyKCQ==
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer\:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration
In-Reply-To: <20201130191643.GA18861@fuller.cnet>
References: <20201130133559.233242-1-mlevitsk@redhat.com> <20201130191643.GA18861@fuller.cnet>
Date:   Tue, 01 Dec 2020 15:01:26 +0100
Message-ID: <874kl5hbgp.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 30 2020 at 16:16, Marcelo Tosatti wrote:
> Not really. The synchronization logic tries to sync TSCs during
> BIOS boot (and CPU hotplug), because the TSC values are loaded
> sequentially, say:
>
> CPU		realtime	TSC val
> vcpu0		0 usec		0
> vcpu1		100 usec	0
> vcpu2		200 usec	0

That's nonsense, really.

> And we'd like to see all vcpus to read the same value at all times.

Providing guests with a synchronized and stable TSC on a host with a
synchronized and stable TSC is trivial.

Write the _same_ TSC offset to _all_ vcpu control structs and be done
with it. It's not rocket science.

The guest TSC read is:

    hostTSC + vcpu_offset

So if the host TSC is synchronized then the guest TSCs are synchronized
as well.

If the host TSC is not synchronized, then don't even try.

Thanks,

        tglx
