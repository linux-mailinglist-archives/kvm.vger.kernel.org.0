Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE75A1B521B
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 03:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDWBrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 21:47:48 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:7901 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbgDWBrr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 21:47:47 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2020 21:47:47 EDT
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 22 Apr 2020 18:32:40 -0700
Received: from [10.62.16.246] (unknown [10.62.16.246])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 8A28AB1660;
        Wed, 22 Apr 2020 21:32:42 -0400 (EDT)
Reply-To: <ganb@vmware.com>
Subject: Re: Re: [PATCH 40/70] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
To:     Joerg Roedel <jroedel@suse.de>, Mike Stunes <mstunes@vmware.com>
CC:     Joerg Roedel <joro@8bytes.org>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-41-joro@8bytes.org>
 <A7DF63B4-6589-4386-9302-6B7F8BE0D9BA@vmware.com>
 <20200415155302.GD21899@suse.de>
From:   Bo Gan <ganb@vmware.com>
Message-ID: <1a164e55-19dd-a20b-6837-9f425cfac100@vmware.com>
Date:   Wed, 22 Apr 2020 18:33:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200415155302.GD21899@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Received-SPF: None (EX13-EDG-OU-001.vmware.com: ganb@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/15/20 8:53 AM, Joerg Roedel wrote:
> Hi Mike,
> 
> On Tue, Apr 14, 2020 at 07:03:44PM +0000, Mike Stunes wrote:
>> set_memory_decrypted needs to check the return value. I see it
>> consistently return ENOMEM. I've traced that back to split_large_page
>> in arch/x86/mm/pat/set_memory.c.
> 
> I agree that the return code needs to be checked. But I wonder why this
> happens. The split_large_page() function returns -ENOMEM when
> alloc_pages() fails. Do you boot the guest with minal RAM assigned?
> 
> Regards,
> 
> 	Joerg
> 

I just want to add some context around this. The call path that lead to 
the failure is like the following:

	__alloc_pages_slowpath
	__alloc_pages_nodemask
	alloc_pages_current
	alloc_pages
	split_large_page
	__change_page_attr
	__change_page_attr_set_clr
	__set_memory_enc_dec
	set_memory_decrypted
	sev_es_init_ghcbs
	trap_init   -> before mm_init (in init/main.c)
	start_kernel
	x86_64_start_reservations
	x86_64_start_kernel
	secondary_startup_64

At this time, mem_init hasn't been called yet (which would be called by 
mm_init). Thus, the free pages are still owned by memblock. It's in 
mem_init (x86/mm/init_64.c) that memblock_free_all gets called and free 
pages are released.

During testing, I've also noticed that debug_pagealloc=1 will make the 
issue disappear. That's because with debug_pagealloc=1, 
probe_page_size_mask in x86/mm/init.c will not allow large pages 
(2M/1G). Therefore, no split_large_page would happen. Similarly, if CPU 
doesn't have X86_FEATURE_PSE, there won't be large pages either.

Any thoughts? Maybe split_large_page should get pages from memblock at 
early boot?

Bo
