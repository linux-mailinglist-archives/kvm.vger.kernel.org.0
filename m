Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D5463EBB
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 20:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239700AbhK3ToB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 14:44:01 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:34796 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239704AbhK3Tnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 14:43:32 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 903A8212BA;
        Tue, 30 Nov 2021 19:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1638301206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l63rcUE2OHW5ypUlliWqEBsLyZQmG3Hbq8IWsXXTz4A=;
        b=12aMtx60u9KBtb604fOld+ki3eVdJ1v+mNTfhocasVNh6L//Rl9NMhqUd4LvoT8jYWgERP
        nDP9hH9+Mw2T+dxZYAs72VFiJw1hYu8et+1Wb0ANyEzPPNlPeoA+CajjJbC364Nk3LnHuw
        Fw8oLPqRPqEXZPQcNVflvDFhZnz339I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1638301206;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l63rcUE2OHW5ypUlliWqEBsLyZQmG3Hbq8IWsXXTz4A=;
        b=AsYbhWHpnSL6tKhtvFTF+/vcz7c8P+xPT7pr2B/izPpdBA008dOLaGWkJDiCsEoMVgb7NQ
        zA1obA72fekhGAAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0E43313D6B;
        Tue, 30 Nov 2021 19:40:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GMaQAhZ+pmEGSAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 30 Nov 2021 19:40:06 +0000
Message-ID: <f3d2787a-1232-e488-3585-a7dac76fe63a@suse.cz>
Date:   Tue, 30 Nov 2021 20:40:05 +0100
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
 <7e368c50-ff94-d87e-e93f-bae044659152@suse.cz>
 <bf96f5d1-1cc3-1d0c-fd70-ade00cb46671@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
In-Reply-To: <bf96f5d1-1cc3-1d0c-fd70-ade00cb46671@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 17:13, Brijesh Singh wrote:
>>
>> That could work for the kmap() context.
>> What to do for the userspace context (host userspace)?
>> - shared->private transition - page has to be unmapped from all userspace,
>> elevated refcount (gup() in progress) can block this unmap until it goes
>> away - could be doable
> 
> An unmap of the page from all the userspace process during the page state
> transition will be great. If we can somehow store the state information in
> the 'struct page' then it can be later used to make better decision. I am
> not sure that relying on the elevated refcount is the correct approach. e.g
> in the case of encrypted guests, the HV may pin the page to prevent it from
> migration.
> 
> Thoughts on how you want to approach unmaping the page from userspace page
> table?

After giving it more thought and rereading the threads here it seems I
thought it would be easier than it really is, and it would have to be
something at least like Kirill's hwpoison based approach.

>> - still, what to do if host userspace then tries to access the unmapped
>> page? SIGSEGV instead of SIGBUS and it can recover?
>>
> 
> Yes, SIGSEGV makes sense to me.

OTOH the newer fd-based proposal also IIUC takes care of this part better -
the host userspace controls the guest's shared->private conversion requests
so it can't be tricked to access a page that's changed under it.

>>
>>
>>> Thoughts ?
>>>
>>>>
>>>> This should turn an RMP fault in the kernel which is not covered in the
>>>> uaccess exception table into a fatal error.
>>>>
>>>> Regards,
>>>>
>>

