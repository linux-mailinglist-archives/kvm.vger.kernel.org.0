Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C884A459CA8
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 08:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhKWHVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 02:21:41 -0500
Received: from mail.skyhub.de ([5.9.137.197]:47558 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhKWHVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 02:21:40 -0500
Received: from zn.tnic (p200300ec2f0afc00fb97e1ddac48f93a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:fc00:fb97:e1dd:ac48:f93a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 74C2F1EC0503;
        Tue, 23 Nov 2021 08:18:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1637651911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KqJTOgCp6HK0xHGH7GIW9dclHLRFLBvb7WQynOhv4Zo=;
        b=J8LWB4M2a2e8olPCNC2yFwCVo2FyCyLjyNvF0yIltKhimu2h8lvvuDckvz0d43x38j5PXn
        Fcci+px1bFHWiwV3UVCCecTqW5fzZ77yo4D9lYtDWn8TBi4ahZCKf/BZ6p4Jtvcn/2hdjS
        OxWBvL/fpLbqF+YML+r3YW6GrqG9+To=
Date:   Tue, 23 Nov 2021 08:18:31 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
Message-ID: <YZyVx38L6gf689zq@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
 <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
 <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
 <d83e6668-bec4-8d1f-7f8a-085829146846@amd.com>
 <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 02:51:35PM -0800, Dave Hansen wrote:
> By "supporting", do you mean doing something functional?  I don't really
> care if ptrace() to guest private memory returns -EINVAL or whatever.
> The most important thing is not crashing the host.
> 
> Also, as Sean mentioned, this isn't really about ptrace() itself.  It's
> really about ensuring that no kernel or devices accesses to guest
> private memory can induce bad behavior.

I keep repeating this suggestion of mine that we should treat
guest-private pages as hw-poisoned pages which have experienced a
uncorrectable error in the past.

mm already knows how to stay away from those.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
