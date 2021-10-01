Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF1C41EB61
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 13:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353672AbhJALH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 07:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353454AbhJALH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 07:07:59 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27484C061775;
        Fri,  1 Oct 2021 04:06:15 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0e8e0006425ffdb1062ac0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8e00:642:5ffd:b106:2ac0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7CBB61EC0419;
        Fri,  1 Oct 2021 13:06:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633086372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JCBAeXE9Fm2/4A8nfF4qlTElC4omNaQJNghTb8YDddM=;
        b=kTtfe1X/X1Cm8CiF7sqgmxJbnYSVBHwhUxmVIQWx22i7VqsRKC6EEWMxmDVCD+9RF7VzG5
        QJBTrSVvQeE27As7XeJBpiyoxWoEGP1nFgkKyx5GnB9alDDmJT1lAjv2TqZFpTt2XpnmBK
        KSzCimg6oBTl41PghKnK15OZssLqRMo=
Date:   Fri, 1 Oct 2021 13:06:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 06/45] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Message-ID: <YVbroJ5RGWa5kZ6J@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-7-brijesh.singh@amd.com>
 <YVR5cOQOJxy12DcR@zn.tnic>
 <60d6a70d-22ab-9e17-b243-7f5669b4b70d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60d6a70d-22ab-9e17-b243-7f5669b4b70d@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 09:19:52AM -0700, Brijesh Singh wrote:
> . The thought process is if in the future 
> set_direct_map_default_noflush() is improved to restore the large
> mapping then it will all work transparently.

That's only scratching the surface of the *why* this is done so please
explain why this dance is being done in a comment above the code so that
it is clear.

It is not really obvious why that hiding from the direct map is being
done.

Good reason from that memfd_secret mail are:

"* Prevent cross-process secret userspace memory exposures. Once the secret
memory is allocated, the user can't accidentally pass it into the kernel to
be transmitted somewhere. The secreremem pages cannot be accessed via the
direct map and they are disallowed in GUP."

and in general hiding RMP pages from the direct map is a nice additional
protection.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
