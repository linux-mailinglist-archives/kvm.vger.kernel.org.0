Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D389145E144
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240782AbhKYUGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242716AbhKYUEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:04:47 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB30C0613F4;
        Thu, 25 Nov 2021 12:00:40 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637870438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vyj4zrdlQYEceaVOafU1FSry85RnhzwkSreDVk7TpTo=;
        b=fsp5+4ECdZi5Rmed/xTXMjOxVcUr5/xbcBYpPw6xe1sRRDvpPyC6xv54JXjttQCNOY/G0X
        1U9rBLBbsHtO256hAbj9fTKHvqM1NApYt83GznnF/dkQ85jzxIXo3vycEC3ey5vKFwzVTH
        LCktto2X8tlWwLVYRWGtL+D8bSvEBSn0D+n2VmJTjF4Xz7KhKjk2AQV2fSFqwXuEghLmok
        5ir+W8E9foAj3L3iS5hP6rRUP2Kfl6G+NVsW8JXmkimSCSKkRIR/2yEiCz6yJsElPa+rOM
        lrCEPoJXbQHNkAkor2Jhu4lnX8N1UyqPdp0XNq7swzERBeQKhuKKgJWBYTbjSA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637870438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vyj4zrdlQYEceaVOafU1FSry85RnhzwkSreDVk7TpTo=;
        b=K0xPG8pa0GOI3KNlpDq2A6RJw+y7rffDs91XR/ITPYbdpnhwr/0FClZEu7MTzlq9Wxm7FN
        4e3kE94eDT8WYSDA==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH v3 31/59] KVM: x86: Add infrastructure for stolen
 GPA bits
In-Reply-To: <89046548aa74778658c6e66d219e157e71e439ab.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <89046548aa74778658c6e66d219e157e71e439ab.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:00:37 +0100
Message-ID: <871r34j996.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> Add support in KVM's MMU for aliasing multiple GPAs (from a hardware
> perspective) to a single GPA (from a memslot perspective). GPA alising
> will be used to repurpose GPA bits as attribute bits, e.g. to expose an
> execute-only permission bit to the guest. To keep the implementation
> simple (relatively speaking), GPA aliasing is only supported via TDP.
>
> Today KVM assumes two things that are broken by GPA aliasing.
>   1. GPAs coming from hardware can be simply shifted to get the GFNs.
>   2. GPA bits 51:MAXPHYADDR are reserved to zero.
>
> With GPA aliasing, translating a GPA to GFN requires masking off the
> repurposed bit, and a repurposed bit may reside in 51:MAXPHYADDR.
>
> To support GPA aliasing, introduce the concept of per-VM GPA stolen bits,
> that is, bits stolen from the GPA to act as new virtualized attribute
> bits. A bit in the mask will cause the MMU code to create aliases of the
> GPA. It can also be used to find the GFN out of a GPA coming from a tdp
> fault.
>
> To handle case (1) from above, retain any stolen bits when passing a GPA
> in KVM's MMU code, but strip them when converting to a GFN so that the
> GFN contains only the "real" GFN, i.e. never has repurposed bits set.
>
> GFNs (without stolen bits) continue to be used to:
> 	-Specify physical memory by userspace via memslots
> 	-Map GPAs to TDP PTEs via RMAP
> 	-Specify dirty tracking and write protection
> 	-Look up MTRR types
> 	-Inject async page faults
>
> Since there are now multiple aliases for the same aliased GPA, when
> userspace memory backing the memslots is paged out, both aliases need to be
> modified. Fortunately this happens automatically. Since rmap supports
> multiple mappings for the same GFN for PTE shadowing based paging, by
> adding/removing each alias PTE with its GFN, kvm_handle_hva() based
> operations will be applied to both aliases.
>
> In the case of the rmap being removed in the future, the needed
> information could be recovered by iterating over the stolen bits and
> walking the TDP page tables.
>
> For TLB flushes that are address based, make sure to flush both aliases
> in the stolen bits case.
>
> Only support stolen bits in 64 bit guest paging modes (long, PAE).
> Features that use this infrastructure should restrict the stolen bits to
> exclude the other paging modes. Don't support stolen bits for shadow EPT.

This is a real reasonable and informative changelog. Thanks to Rick for
writing this up!

Thanks,

        tglx
