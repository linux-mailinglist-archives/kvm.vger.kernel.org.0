Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E097D45A7AA
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 17:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhKWQ32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 11:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhKWQ32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 11:29:28 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BE3C061574;
        Tue, 23 Nov 2021 08:26:20 -0800 (PST)
Received: from zn.tnic (p200300ec2f14d20006ffc72651f84cb2.dip0.t-ipconnect.de [IPv6:2003:ec:2f14:d200:6ff:c726:51f8:4cb2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 614E01EC0423;
        Tue, 23 Nov 2021 17:26:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1637684778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Bavt564BU2rM1WOQe9eoYfojylE1mxii7g1TihHieiE=;
        b=rHANThsDYg+AtenNwwpzB3LiACcYb8e6zoyxmOCqJ/8+j2mFwep7JYl3IsSfyTFjLD5jQ4
        4IeKtnSUYa+6YgNd2S2Ka1/xx4E4hGxkNGghT+ALLZaFotMrVBxysVVL9eSZnVFsSuAdr3
        B0CcC2oRh3yPxvinKattnTh8ngdmwOw=
Date:   Tue, 23 Nov 2021 17:26:14 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
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
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZ0WJlv9rxpQ+GVG@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
 <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
 <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
 <d83e6668-bec4-8d1f-7f8a-085829146846@amd.com>
 <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com>
 <YZyVx38L6gf689zq@zn.tnic>
 <YZ0KgymKvLC2HcIk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YZ0KgymKvLC2HcIk@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 23, 2021 at 03:36:35PM +0000, Sean Christopherson wrote:
> Kirill posted a few RFCs that did exactly that.  It's definitely a viable approach,
> but it's a bit of a dead end,

One thing at a time...

> e.g. doesn't help solve page migration,

AFAICR, that needs a whole explicit and concerted effort with the
migration helper - that was one of the approaches, at least, guest's
explicit involvement, remote attestation and a bunch of other things...

> is limited to struct page

I'm no mm guy so maybe you can elaborate further.

> doesn't capture which KVM guest owns the memory, etc...

So I don't think we need this for the problem at hand. But from the
sound of it, it probably is a good idea to be able to map the guest
owner to the memory anyway.

> https://lore.kernel.org/kvm/20210416154106.23721-1-kirill.shutemov@linux.intel.com/

Right, there it is in the last patch.

Hmmkay, so we need some generic machinery which unmaps memory from
the host kernel's pagetables so that it doesn't do any stray/unwanted
accesses to it. I'd look in the direction of mm folks for what to do
exactly, though.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
