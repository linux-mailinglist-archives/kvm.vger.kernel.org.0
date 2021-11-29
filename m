Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1784D461A8D
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 16:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbhK2PDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 10:03:53 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47710 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345432AbhK2PBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 10:01:53 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 589521FD38;
        Mon, 29 Nov 2021 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1638197914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t4Ma3afwC7KZw9L0yhc6vlBZ0A17MFGlznwnQnwnFg=;
        b=FgA1wOJzo4HWeOGYsqs1Zn9+9sqilkSru5Aiywz0Oon3jZv67bxJPpasmLSyZ2l1Vlv5s1
        dKibSpK7WF9Cc9w3jIRANiQHhN7ATD7KcS/Npo2/pKhM2fMxVyfEC9fG0ALxvnG/1DvJqH
        +/JkHW8nIC7fvLwz+blvFMdSbsreDUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1638197914;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t4Ma3afwC7KZw9L0yhc6vlBZ0A17MFGlznwnQnwnFg=;
        b=TH1LAL3X3oY2ggbvSxH/DMeiro4vt3B0XxLrZZ/ByD6KFnMZGaRFU+xA8YGi19PJzN7t/B
        MZhaDO3lvRW1xaCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CAAEA13B2B;
        Mon, 29 Nov 2021 14:58:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uevfMJnqpGH6EQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 29 Nov 2021 14:58:33 +0000
Message-ID: <7e368c50-ff94-d87e-e93f-bae044659152@suse.cz>
Date:   Mon, 29 Nov 2021 15:58:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Peter Gonda <pgonda@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
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
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
 <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
 <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
 <d83e6668-bec4-8d1f-7f8a-085829146846@amd.com>
 <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com> <YZ5iWJuxjSCmZL5l@suse.de>
 <bd31abd4-c8a2-bdda-ea74-1c24b29beda7@intel.com> <YZ9gAMHdEo6nQ6a0@suse.de>
 <9503ac53-1323-eade-2863-df11a5f36b6a@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
In-Reply-To: <9503ac53-1323-eade-2863-df11a5f36b6a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 15:44, Brijesh Singh wrote:
> 
> 
> On 11/25/21 4:05 AM, Joerg Roedel wrote:
>> On Wed, Nov 24, 2021 at 09:48:14AM -0800, Dave Hansen wrote:
>>> That covers things like copy_from_user().  It does not account for
>>> things where kernel mappings are used, like where a
>>> get_user_pages()/kmap() is in play.
>>
>> The kmap case is guarded by KVM code, which locks the page first so that
>> the guest can't change the page state, then checks the page state, and
>> if it is shared does the kmap and the access.
> 
> 
> The KVM use-case is well covered in the series, but I believe Dave is
> highlighting what if the access happens outside of the KVM driver (such as a
> ptrace() or others).

AFAIU ptrace() is a scenario where the userspace mapping is being gup-ped,
not a kernel page being kmap()ed?

> One possible approach to fix this is to enlighten the kmap/unmap().
> Basically, move the per page locking mechanism used by the KVM in the
> arch-specific code and have kmap/kunmap() call the arch hooks. The arch
> hooks will do this:
> 
> Before the map, check whether the page is added as a shared in the RMP
> table. If not shared, then error.
> Acquire a per-page map_lock.
> Release the per-page map_lock on the kunmap().
> 
> The current patch set provides helpers to change the page from private to
> shared. Enhance the helpers to check for the per-page map_lock, if the
> map_lock is held then do not allow changing the page from shared to private.

That could work for the kmap() context.
What to do for the userspace context (host userspace)?
- shared->private transition - page has to be unmapped from all userspace,
elevated refcount (gup() in progress) can block this unmap until it goes
away - could be doable
- still, what to do if host userspace then tries to access the unmapped
page? SIGSEGV instead of SIGBUS and it can recover?



> Thoughts ?
> 
>>
>> This should turn an RMP fault in the kernel which is not covered in the
>> uaccess exception table into a fatal error.
>>
>> Regards,
>>

