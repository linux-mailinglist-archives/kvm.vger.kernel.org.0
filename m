Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571C2376474
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 13:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhEGL3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 07:29:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:43976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233369AbhEGL3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 07:29:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 287B9B14A;
        Fri,  7 May 2021 11:28:30 +0000 (UTC)
Subject: Re: [PATCH Part2 RFC v2 08/37] x86/sev: Split the physmap when adding
 the page in RMP table
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Brijesh Singh <brijesh.singh@amd.com>
Cc:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-9-brijesh.singh@amd.com>
 <CALCETrXsUW3S_9ZUPXT5HEv_ki2VxEUQMe-uzerG1xnbcgYNtw@mail.gmail.com>
 <c1e9573e-9be4-ee85-9363-73b9c60db315@intel.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <5c07ff2c-efb4-5f7b-0ad6-d52d985e5c46@suse.cz>
Date:   Fri, 7 May 2021 13:28:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <c1e9573e-9be4-ee85-9363-73b9c60db315@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/21 5:41 PM, Dave Hansen wrote:
> On 5/3/21 8:15 AM, Andy Lutomirski wrote:
>> How much performance do we get back if we add a requirement that only
>> 2M pages (hugetlbfs, etc) may be used for private guest memory?
> 
> Are you generally asking about the performance overhead of using 4k
> pages instead of 2M for the direct map?  We looked at that recently and
> pulled together some data:

IIUC using 2M for private guest memory wouldn't be itself sufficient, as the
guest would also have to share pages with host with 2MB granularity, and that
might be too restrictive?

>> https://lore.kernel.org/lkml/213b4567-46ce-f116-9cdf-bbd0c884eb3c@linux.intel.com/
> 

