Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BFC41EE1A
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 15:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353866AbhJANEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 09:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353738AbhJANEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 09:04:45 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7691C061775;
        Fri,  1 Oct 2021 06:03:01 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0e8e00c9205f48360a92d6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8e00:c920:5f48:360a:92d6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4DFB81EC05BF;
        Fri,  1 Oct 2021 15:03:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633093380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Pww6+dMpzZfasK3x5P00rVcRmv+YdyobAl7XmL8o1hQ=;
        b=UPoCccmafl2kj4ZfjkRANSs2qzDvdnHfjG51lKFvLOwkF4ENeK9ENX3ewAMPoJY36xSu1g
        s+vucdZRWDPD9eq8FW57/jUSDnwGFsRUHn9t6CMr+f71s76rhviCESLb4QpZWHhAnhg015
        UUFkcN2vhdLDHQriiIKjCj6JDq5eIQI=
Date:   Fri, 1 Oct 2021 15:03:01 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Marc Orr <marcorr@google.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
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
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 32/45] KVM: x86: Define RMP page fault error
 bits for #NPF
Message-ID: <YVcHBQA602iCOo+J@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-33-brijesh.singh@amd.com>
 <CAA03e5G-UX761uBAFLS3e1NuYZOh2v8b=UkrX+rZUviegyWVGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAA03e5G-UX761uBAFLS3e1NuYZOh2v8b=UkrX+rZUviegyWVGQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 04:41:54PM -0700, Marc Orr wrote:
> On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
> >
> > When SEV-SNP is enabled globally, the hardware places restrictions on all
> > memory accesses based on the RMP entry, whether the hypervisor or a VM,
> > performs the accesses. When hardware encounters an RMP access violation
> > during a guest access, it will cause a #VMEXIT(NPF).
> >
> > See APM2 section 16.36.10 for more details.
> 
> nit: Section # should be 15.36.10 (rather than 16.36.10). Also, is it
> better to put section headings, rather than numbers in the commit logs
> and comments? Someone mentioned to me that the section numbering in
> APM and SDM can move around over time, but the section titles tend to
> be more stable. I'm not sure how true this is, so feel free to
> disregard this comment.

No, that comment is correct, please make it unambiguous so that if
someone's looking later, someone can find the section even in future
docs. (I'm hoping they don't change headings, that is...).

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
