Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12C12C51D8
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 11:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbgKZKMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 05:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387677AbgKZKMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 05:12:06 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4CDC0613D4;
        Thu, 26 Nov 2020 02:12:05 -0800 (PST)
Received: from zn.tnic (p200300ec2f0c90002c8516e75060f16f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:9000:2c85:16e7:5060:f16f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 70C021EC04B9;
        Thu, 26 Nov 2020 11:12:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1606385524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hL6+zLINeYzaNI1ZSXF12FfLj2TjMowBa3XIKWttURI=;
        b=oh3PnwfIQCGovbg8R/dXRaAtANdtOYC+DIBshOQUKSuXB3aa6iD7Wv/nwoNMnRRzA6ORrK
        Yvk/vagqVz5AJow1cmGib/6OZnf4Q9KxjZPD20IDnaYa1Rm5GmhYDcTPu8FgqPxitaOOdS
        wQuR1bmngZDkiO0bLlQuoxBNZBTnn3s=
Date:   Thu, 26 Nov 2020 11:12:03 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com, Zhang Chen <chen.zhang@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH 03/67] x86/cpu: Move get_builtin_firmware() common
 code (from microcode only)
Message-ID: <20201126101203.GB31565@zn.tnic>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
 <46d35ce06d84c55ff02a05610ca3fb6d51ee1a71.1605232743.git.isaku.yamahata@intel.com>
 <20201125220947.GA14656@zn.tnic>
 <20201126001812.GD450871@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201126001812.GD450871@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 26, 2020 at 12:18:12AM +0000, Sean Christopherson wrote:
> The SEAM module needs to be loaded during early boot, it can't be
> deferred to a module, at least not without a lot more blood, sweat,
> and tears.

Are you also planning to support builtin seam or only thru initrd loading?

In any case, this commit message needs to state intentions not me having
to plow all the way up to patch 62.

> The SEAM Loader is an ACM that is invoked via GETSEC[EnterACCS], which
> requires all APs to be in WFS.

Yah, this is the other thing that sprang at me from looking at that
"small" patchset briefly - I'm being killed by abbreviations. Whoever is
sending the next version, pls put a proper documentation as patch 1 of
the patchset just like the CET patchset does.

> SEAM Loader also returns control to the kernel with a null IDT and
> NMIs unblocked, i.e. we're toast if there's a pending NMI. And unlike
> the run-time SEAMCALLs, boot-time SEAMCALLs do not have a strictly
> bounded runtime. Invoking configuration SEAMCALLs after the kernel is
> fully up and running could cause instability as IRQ, NMI, and SMI are
> all blocked in SEAM mode, e.g. a high priority IRQ/NMI/SMI could be
> blocked for 50+ usecs (it might be far more than 50 usecs, I haven't
> seen real numbers for all SEAMCALLs).

Yah, I sure hope people have taken an ample amount of time to think
about all the implications of this thing because it sounds wonky to me.
amluto certainly has already gone deeper and will surely comment. :)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
