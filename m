Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7220F3F718A
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 11:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbhHYJRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 05:17:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47480 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbhHYJRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 05:17:45 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7DC1C22118;
        Wed, 25 Aug 2021 09:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629883018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Af1e3tXHfDmT+9DXS/it5aFxSlFxaJjERigjhxDIiFU=;
        b=afayu3X7kmeLNmWI9HNgB4XgqHLBu/38tnAdiLCX9Wvv9JUPYhhqAUI7a/198WLzrBO1pt
        MCGZ8/3foZ6/6cl72S53bhKn34JCT2VLupgzf4BlEsi0s1nYVM5CintXUCBgve41+Me+qr
        Jh5/Hxh5KZt5Sneik0OjP1jblLJRJk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629883018;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Af1e3tXHfDmT+9DXS/it5aFxSlFxaJjERigjhxDIiFU=;
        b=R1a/N7HLX60OgiBSyY2rCXzD3P3OK3BckIgrns05/Noa9UYraEMBisfjXuXabmk6KK8bEd
        5zhn9vYRNDDzXjBg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id F0B0C13887;
        Wed, 25 Aug 2021 09:16:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id QV/vOYkKJmGFAQAAGKfGzw
        (envelope-from <vbabka@suse.cz>); Wed, 25 Aug 2021 09:16:57 +0000
Message-ID: <c5a8f7e8-7146-0737-81a1-1faceb6992ab@suse.cz>
Date:   Wed, 25 Aug 2021 11:16:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Content-Language: en-US
To:     Joerg Roedel <jroedel@suse.de>, Dave Hansen <dave.hansen@intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
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
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Mike Kravetz <mike.kravetz@oracle.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-9-brijesh.singh@amd.com>
 <f6d778a0-840d-8c9c-392d-5c9ffcc0bdc6@intel.com>
 <19599ede-9fc5-25e1-dcb3-98aafd8b7e87@amd.com>
 <3f426ef8-060e-ccc9-71b9-2448f2582a30@intel.com> <YSUhg/87jZPocLDP@suse.de>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH Part2 v5 08/45] x86/fault: Add support to handle the RMP
 fault for user address
In-Reply-To: <YSUhg/87jZPocLDP@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/21 18:42, Joerg Roedel wrote:
> On Mon, Aug 23, 2021 at 07:50:22AM -0700, Dave Hansen wrote:
>> It *has* to be done in KVM, IMNHO.
>> 
>> The core kernel really doesn't know much about SEV.  It *really* doesn't
>> know when its memory is being exposed to a virtualization architecture
>> that doesn't know how to split TLBs like every single one before it.
>> 
>> This essentially *must* be done at the time that the KVM code realizes
>> that it's being asked to shove a non-splittable page mapping into the
>> SEV hardware structures.
>> 
>> The only other alternative is raising a signal from the fault handler
>> when the page can't be split.  That's a *LOT* nastier because it's so
>> much later in the process.
>> 
>> It's either that, or figure out a way to split hugetlbfs (and DAX)
>> mappings in a failsafe way.
> 
> Yes, I agree with that. KVM needs a check to disallow HugeTLB pages in
> SEV-SNP guests, at least as a temporary workaround. When HugeTLBfs
> mappings can be split into smaller pages the check can be removed.

FTR, this is Sean's reply with concerns in v4:
https://lore.kernel.org/linux-coco/YPCuTiNET%2FhJHqOY@google.com/

I think there are two main arguments there:
- it's not KVM business to decide
- guest may do all page state changes with 2mb granularity so it might be fine
with hugetlb

The latter might become true, but I think it's more probable that sooner
hugetlbfs will learn to split the mappings to base pages - I know people plan to
work on that. At that point qemu will have to recognize if the host kernel is
the new one that can do this splitting vs older one that can't. Preferably
without relying on kernel version number, as backports exist. Thus, trying to
register a hugetlbfs range that either is rejected (kernel can't split) or
passes (kernel can split) seems like a straightforward way. So I'm also in favor
of adding that, hopefuly temporary, check.

Vlastimil

> Regards,
> 
> 	Joerg
> 

