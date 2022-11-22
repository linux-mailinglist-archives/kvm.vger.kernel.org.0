Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8869E634514
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 21:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiKVUDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 15:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiKVUDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 15:03:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD637DEFC;
        Tue, 22 Nov 2022 12:03:40 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669147418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SWa/5fKbR+fcYp/HKOeGlxTtLMCqMbq1I3NIhIrAkW0=;
        b=wilo2RELa/r/tn0tqcS6/gVkFvmBJ34cbwrFjZ2LolGixYbLrHyDqJKhSFG2Bg2rPvU3BV
        GawXrqRdoFKHpoHmdLNItf4wEyZjttUv8B6lRLTOgJUHRmblMXE8kkia+f0WPOcMeoawyK
        UUyMhwwlUaEHLvvKkwS55jOvvIpGqyWofGIahgd3rt6ZQbllIdrSBogtjZg9Z58aEhhi92
        Tmd7FfQMmW0+qD97ULdEOddZlobt/jMXefnlwk5u/tLfIFpv8yFLfuBZI5Gttut+y0zqkt
        A2JAwZtaRdinFkWQKSxgrm89qHIbw25lMfKcv5GVw/Af3VfeR3raH4FsX9MFdg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669147418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SWa/5fKbR+fcYp/HKOeGlxTtLMCqMbq1I3NIhIrAkW0=;
        b=bgi7uUODLdtKRu2n4st+LFM1E9j6zqOCr9C27K9Jns4W84FUStTn+1qMBRMnYpoKNAVZg5
        a0/bhyVPpuJEi2CQ==
To:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX
 on demand
In-Reply-To: <19d93ff0-df0d-dc9d-654b-a9ca6f7be1d0@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
 <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net> <87edtvgu1l.ffs@tglx>
 <19d93ff0-df0d-dc9d-654b-a9ca6f7be1d0@intel.com>
Date:   Tue, 22 Nov 2022 21:03:37 +0100
Message-ID: <87mt8ig3ja.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22 2022 at 07:35, Dave Hansen wrote:

> On 11/22/22 02:31, Thomas Gleixner wrote:
>> Nothing in the TDX specs and docs mentions physical hotplug or a
>> requirement for invoking seamcall on the world.
>
> The TDX module source is actually out there[1] for us to look at.  It's
> in a lovely, convenient zip file, but you can read it if sufficiently
> motivated.

zip file? Version control from the last millenium?

The whole thing wants to be @github with a proper change history if
Intel wants anyone to trust this and take it serious.

/me refrains from ranting about the outrageous license choice.

> It has this lovely nugget in it:
>
> WARNING!!! Proprietary License!!  Avert your virgin eyes!!!

It's probably not the only reasons to avert the eyes.

>>     if (tdx_global_data_ptr->num_of_init_lps < tdx_global_data_ptr->num_of_lps)
>>     {
>>         TDX_ERROR("Num of initialized lps %d is smaller than total num of lps %d\n",
>>                     tdx_global_data_ptr->num_of_init_lps, tdx_global_data_ptr->num_of_lps);
>>         retval = TDX_SYS_CONFIG_NOT_PENDING;
>>         goto EXIT;
>>     }
>
> tdx_global_data_ptr->num_of_init_lps is incremented at TDH.SYS.INIT
> time.  That if() is called at TDH.SYS.CONFIG time to help bring the
> module up.
>
> So, I think you're right.  I don't see the docs that actually *explain*
> this "you must seamcall all the things" requirement.

The code actually enforces this.

At TDH.SYS.INIT which is the first operation it gets the total number
of LPs from the sysinfo table:

src/vmm_dispatcher/api_calls/tdh_sys_init.c:

    tdx_global_data_ptr->num_of_lps = sysinfo_table_ptr->mcheck_fields.tot_num_lps;

Then TDH.SYS.LP.INIT increments the count of initialized LPs.

src/vmm_dispatcher/api_calls/tdh_sys_lp_init.c:

    increment_num_of_lps(tdx_global_data_ptr)
       _lock_xadd_32b(&tdx_global_data_ptr->num_of_init_lps, 1);

Finally TDH.SYS.CONFIG checks whether _ALL_ LPs have been initialized.

src/vmm_dispatcher/api_calls/tdh_sys_config.c:

    if (tdx_global_data_ptr->num_of_init_lps < tdx_global_data_ptr->num_of_lps)

Clearly that's nowhere spelled out in the documentation, but I don't
buy the 'architecturaly required' argument not at all. It's an
implementation detail of the TDX module.

Technically there is IMO ZERO requirement to do so.

 1) The TDX module is global

 2) Seam-root and Seam-non-root operation are strictly a LP property.

    The only architectural prerequisite for using Seam on a LP is that
    obviously the encryption/decryption mechanics have been initialized
    on the package to which the LP belongs.

I can see why it might be complicated to add/remove an LP after
initialization fact, but technically it should be possible.

TDX/Seam is not that special.

But what's absolutely annoying is that the documentation lacks any
information about the choice of enforcement which has been hardcoded
into the Seam module for whatever reasons.

Maybe I overlooked it, but then it's definitely well hidden.

Thanks,

        tglx
