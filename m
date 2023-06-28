Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8CE741183
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 14:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjF1MlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 08:41:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:64865 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232374AbjF1MiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 08:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687955904; x=1719491904;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vmEK/YbRpjOHK6AGLBfzc3yNkSj1WJuJ8VXyPYLSm8g=;
  b=FwBhj4DndrJjI8CTLMHVt+dvJzzEcj7jsw8QEkojclywzntmlZni/5V6
   NpLVgCDrgup7XfHnw/qmcEyaEATeeIXcujNSvW1/WjwQeYDw6kYnkpXiz
   XySo4zHhfmH+LBtzrkepAaTcVPxuJZYr588DJQxAkTLAO/kbKmbjYEKdn
   GbdWH9oieHripGIxCDbPKXgeT0do5FrOBdsrwbwQj5GvWPOdv15a+KFMe
   pKwj7XOQxrpPRyH4FPKEDlqhIDLlhMTYBEqaklIVLhKnMRkD9FE4j40Qi
   4h7ISE3MeJJxck+1JW+uFLxSF2DFmCgjAc3KMqLlVSvZCakCtQuHgl45p
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="392555611"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="392555611"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 05:38:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="711035986"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="711035986"
Received: from rajritu-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.47.187])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 05:38:13 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 56CF41095C8; Wed, 28 Jun 2023 15:38:09 +0300 (+03)
Date:   Wed, 28 Jun 2023 15:38:09 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 21/22] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Message-ID: <20230628123809.ax7q7moxpavbibed@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <e8d62487d87409af4f0a760f36aeae56a492a79e.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8d62487d87409af4f0a760f36aeae56a492a79e.1687784645.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:51AM +1200, Kai Huang wrote:
> The first few generations of TDX hardware have an erratum.  Triggering
> it in Linux requires some kind of kernel bug involving relatively exotic
> memory writes to TDX private memory and will manifest via
> spurious-looking machine checks when reading the affected memory.
> 
> == Background ==
> 
> Virtually all kernel memory accesses operations happen in full
> cachelines.  In practice, writing a "byte" of memory usually reads a 64
> byte cacheline of memory, modifies it, then writes the whole line back.
> Those operations do not trigger this problem.
> 
> This problem is triggered by "partial" writes where a write transaction
> of less than cacheline lands at the memory controller.  The CPU does
> these via non-temporal write instructions (like MOVNTI), or through
> UC/WC memory mappings.  The issue can also be triggered away from the
> CPU by devices doing partial writes via DMA.
> 
> == Problem ==
> 
> A partial write to a TDX private memory cacheline will silently "poison"
> the line.  Subsequent reads will consume the poison and generate a
> machine check.  According to the TDX hardware spec, neither of these
> things should have happened.
> 
> To add insult to injury, the Linux machine code will present these as a
> literal "Hardware error" when they were, in fact, a software-triggered
> issue.
> 
> == Solution ==
> 
> In the end, this issue is hard to trigger.  Rather than do something
> rash (and incomplete) like unmap TDX private memory from the direct map,
> improve the machine check handler.
> 
> Currently, the #MC handler doesn't distinguish whether the memory is
> TDX private memory or not but just dump, for instance, below message:
> 
>  [...] mce: [Hardware Error]: CPU 147: Machine Check Exception: f Bank 1: bd80000000100134
>  [...] mce: [Hardware Error]: RIP 10:<ffffffffadb69870> {__tlb_remove_page_size+0x10/0xa0}
>  	...
>  [...] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
>  [...] mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>  [...] Kernel panic - not syncing: Fatal local machine check
> 
> Which says "Hardware Error" and "Data load in unrecoverable area of
> kernel".
> 
> Ideally, it's better for the log to say "software bug around TDX private
> memory" instead of "Hardware Error".  But in reality the real hardware
> memory error can happen, and sadly such software-triggered #MC cannot be
> distinguished from the real hardware error.  Also, the error message is
> used by userspace tool 'mcelog' to parse, so changing the output may
> break userspace.
> 
> So keep the "Hardware Error".  The "Data load in unrecoverable area of
> kernel" is also helpful, so keep it too.
> 
> Instead of modifying above error log, improve the error log by printing
> additional TDX related message to make the log like:
> 
>   ...
>  [...] mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>  [...] mce: [Hardware Error]: Machine Check: TDX private memory error. Possible kernel bug.
> 
> Adding this additional message requires determination of whether the
> memory page is TDX private memory.  There is no existing infrastructure
> to do that.  Add an interface to query the TDX module to fill this gap.
> 
> == Impact ==
> 
> This issue requires some kind of kernel bug to trigger.
> 
> TDX private memory should never be mapped UC/WC.  A partial write
> originating from these mappings would require *two* bugs, first mapping
> the wrong page, then writing the wrong memory.  It would also be
> detectable using traditional memory corruption techniques like
> DEBUG_PAGEALLOC.
> 
> MOVNTI (and friends) could cause this issue with something like a simple
> buffer overrun or use-after-free on the direct map.  It should also be
> detectable with normal debug techniques.
> 
> The one place where this might get nasty would be if the CPU read data
> then wrote back the same data.  That would trigger this problem but
> would not, for instance, set off mechanisms like slab redzoning because
> it doesn't actually corrupt data.
> 
> With an IOMMU at least, the DMA exposure is similar to the UC/WC issue.
> TDX private memory would first need to be incorrectly mapped into the
> I/O space and then a later DMA to that mapping would actually cause the
> poisoning event.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
