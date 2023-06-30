Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2767444DB
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 00:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbjF3WaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 18:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjF3WaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 18:30:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4373C38;
        Fri, 30 Jun 2023 15:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688164198; x=1719700198;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kmxjEdY/oS9OgHs4b5rew7Czs0b9e7jAaSHy4XBU38o=;
  b=UAs25VDhQWJ0Hf4V6Xy4yWiJA9WGd8sCzoKC5FMuvX0QDH84x9O3ZIKC
   uHbljP4OyvNLR3gd8MV19Z9IWA6fCPNmxDsKcJnBXqHaBWr4dRdRCyPg7
   e1rw7+cjFqXGpZYPfJDCDNH+n+tRDQQMp8mXpVZBtGo24HHCJGUXZn7OD
   GRIAAYW1NMGOR37EBoE6wfszMmUPPaxFG1ZoocX1PJU3mSSfeexH0bhz2
   66UN8gjT8TqwrF/Qg8OtMGqromdfpOkNjNjXgLdXMj3eYhYpVXF8Wo+4X
   vwIg9vI6lAUJhwm62itHpMpGQ7lAk+/50mECW4P/ALtrD1ypq0XiPujVg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="428552774"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="428552774"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 15:29:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="747558521"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="747558521"
Received: from amuruge1-mobl.amr.corp.intel.com (HELO [10.252.133.96]) ([10.252.133.96])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 15:29:55 -0700
Message-ID: <522b0954-749e-33be-59a7-4ce28e8c4d5c@intel.com>
Date:   Fri, 30 Jun 2023 15:29:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 09/51] x86/sev: Add RMP entry lookup helpers
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-10-michael.roth@amd.com>
 <59d5ca67-6a31-1929-8d2f-0e3314626893@intel.com>
 <20230630215709.owobzb5cr2wtkqhd@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230630215709.owobzb5cr2wtkqhd@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/23 14:57, Michael Roth wrote:
> On Mon, Jun 12, 2023 at 09:08:58AM -0700, Dave Hansen wrote:
>> On 6/11/23 21:25, Michael Roth wrote:
>>> +/*
>>> + * The RMP entry format is not architectural. The format is defined in PPR
>>> + * Family 19h Model 01h, Rev B1 processor.
>>> + */
>>> +struct rmpentry {
>>> +	union {
>>> +		struct {
>>> +			u64	assigned	: 1,
>>> +				pagesize	: 1,
>>> +				immutable	: 1,
>>> +				rsvd1		: 9,
>>> +				gpa		: 39,
>>> +				asid		: 10,
>>> +				vmsa		: 1,
>>> +				validated	: 1,
>>> +				rsvd2		: 1;
>>> +		} info;
>>> +		u64 low;
>>> +	};
>>> +	u64 high;
>>> +} __packed;
>>
>> What's 'high' used for?  The PPR says it's reserved.  Why not call it
>> reserved?
>>
>> It _looks_ like it's only used for a debugging pr_info().  It makes the
>> struct look kinda goofy.  I'd much rather limit the goofiness to the
>> "dumping" code, like:
>>
>>      u64 *__e = (void *)e;
>>      ....
>>      pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
>>                                pfn << PAGE_SHIFT, __e[0], __e[1]);
>>
>> BTW, why does it do any good to dump all these reserved fields?
>>
> 
> The reserved bits sometimes contain information that can be useful to
> pass along to folks on the firmware side, so would definitely be helpful
> to provide the full raw contents of the RMP entry.

Ahh, OK.  Could you include a comment to that effect, please?

> So maybe something like this better captures the intended usage:
> 
>     struct rmpentry {
>         union {
>             struct {
>                 u64 assigned        : 1,
>                     pagesize        : 1,
>                     immutable       : 1,
>                     rsvd1           : 9,
>                     gpa             : 39,
>                     asid            : 10,
>                     vmsa            : 1,
>                     validated       : 1,
>                     rsvd2           : 1;
>                 u64 rsvd3;
>             } info;
>             u64 data[2];
>         };
>     } __packed;
> 
> But dropping the union and casting to u64[] locally in the debug/dumping
> routine should work fine as well.

Yeah, I'd suggest doing the nasty casting in the debug function.  That
makes it much more clear what the hardware is doing with the entries.
The hardware doesn't treat the struct as 2*u64's at all.

...
>>> +	ret = rmptable_entry(paddr, entry);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	/* Read a large RMP entry to get the correct page level used in RMP entry. */
>>> +	ret = rmptable_entry(paddr & PMD_MASK, &large_entry);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(&large_entry));
>>> +
>>> +	return 0;
>>> +}
>>
>> This is a bit weird.  Should it say something like this?
>>
>> To do an 4k RMP lookup the hardware looks at two places in the RMP:
> 
> I'd word this as:
> 
>   "To query all the relevant bit of an 4k RMP entry, the kernel must access
>    2 entries in the RMP table:"
> 
> Because it's possible hardware only looks at the 2M entry for
> hardware-based lookups, depending on where the access is coming from, or
> how the memory at the PFN range is mapped.
> 
> But otherwise it seems like an accurate description.

The wording you suggest is a bit imprecise.  For a 2M-aligned 4k page,
there is only *one* location, *one* entry.

Also, we're not doing a lookup for an RMP entry.  We're doing it for a
_pfn_ that results in an RMP entry.

How about this:

/*
 * Find the authoritative RMP entry for a PFN.  This can be either a 4k
 * RMP entry or a special large RMP entry that is authoritative for a
 * whole 2M area.
 */
...
>>> +#ifdef CONFIG_KVM_AMD_SEV
>>> +int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
>>> +#else
>>> +static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return 0; }
>>> +#endif
>>
>> Above, -ENXIO was returned when SEV-SNP was not supported.  Here, 0 is
>> returned when it is compiled out.  That inconsistent.
>>
>> Is snp_lookup_rmpentry() acceptable when SEV-SNP is in play?  I'd like
>> to see consistency between when it is compiled out and when it is
>> compiled in but unsupported on the CPU.
> 
> I really don't think anything in the kernel should be calling
> snp_lookup_rmpentry(), so I think it makes sense to adoption the -ENXIO
> convention here and in any other stubs where that applies.

Sounds good to me.  Just please make them consistent.
