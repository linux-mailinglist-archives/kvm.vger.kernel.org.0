Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D330F57BBC8
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 18:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiGTQsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 12:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiGTQsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 12:48:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4123B979;
        Wed, 20 Jul 2022 09:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658335685; x=1689871685;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=omc5oS98vhIDr7XiFeSScYRFbJm8zfX3R/MQhi89FHU=;
  b=Uvq0XsbQbFQTH5a0Bogbv7l7RXch9NBP0p8u4ue9r+63vdsA+Orc0QJ7
   V73+syx4nc5Y6Pqs7TC3e2vHCxhlTsH6AI/L2uqIrKZT5dryweEdnsx5p
   rwGPJ/WSabkjAhR3rXpSPRY8OIYWXH+aZUbgQxcT0zs86vY491x+OXW2l
   tOBczwMpCqcsyTdzzL1aaRux2rGOxUJh3XJUw6q00yNRnALB6wMnSTvc8
   1YAJVQQJPCypmnIRlB4M4Eu6q8eNUzjd7H2dDvLAvifXv2awckpzeqr9T
   ndheAFb6XGQhBKDAz+NOswF3zAdOjR6OnVmJbPVX0erzxBK+BtOzZBd0M
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="267228988"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="267228988"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 09:48:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="573379999"
Received: from dgovor-mobl1.amr.corp.intel.com (HELO [10.209.89.58]) ([10.209.89.58])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 09:48:02 -0700
Message-ID: <978c3d37-97c9-79b9-426a-2c27db34c38a@intel.com>
Date:   Wed, 20 Jul 2022 09:48:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 07/22] x86/virt/tdx: Implement SEAMCALL function
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
 <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
 <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
 <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
 <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
 <ea03e55499f556388c0a5f9ed565e72e213c276f.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ea03e55499f556388c0a5f9ed565e72e213c276f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/22 03:18, Kai Huang wrote:
> Try to close on how to handle memory hotplug.  After discussion, below will be
> architectural behaviour of TDX in terms of ACPI memory hotplug:
> 
> 1) During platform boot, CMRs must be physically present. MCHECK verifies all
> CMRs are physically present and are actually TDX convertible memory.

I doubt this is strictly true.  This makes it sound like MCHECK is doing
*ACTUAL* verification that the memory is, in practice, convertible.
That would mean actually writing to it, which would take a long time for
a large system.

Does it *ACTUALLY* verify this?

Also, it's very odd to say that "CMRs must be physically present".  A
CMR itself is a logical construct.  The physical memory *backing* a CMR
is, something else entirely.

> 2) CMRs are static after platform boots and don't change at runtime.  TDX
> architecture doesn't support hot-add or hot-removal of CMR memory.
> 3) TDX architecture doesn't forbid non-CMR memory hotplug.
> 
> Also, although TDX doesn't trust BIOS in terms of security, a non-buggy BIOS
> should prevent CMR memory from being hot-removed.  If kernel ever receives such
> event, it's a BIOS bug, or even worse, the BIOS is compromised and under attack.
> 
> As a result, the kernel should also never receive event of hot-add CMR memory. 
> It is very much likely TDX is under attack (physical attack) in such case, i.e.
> someone is trying to physically replace any CMR memory.
> 
> In terms of how to handle ACPI memory hotplug, my thinking is -- ideally, if the
> kernel can get the CMRs during kernel boot when detecting whether TDX is enabled
> by BIOS, we can do below:
> 
> - For memory hot-removal, if the removed memory falls into any CMR, then kernel
> can speak loudly it is a BIOS bug.  But when this happens, the hot-removal has
> been handled by BIOS thus kernel cannot actually prevent, so kernel can either
> BUG(), or just print error message.  If the removed memory doesn't fall into
> CMR, we do nothing.

Hold on a sec.  Hot-removal is a two-step process.  The kernel *MUST*
know in advance that the removal is going to occur.  It follows that up
with evacuating the memory, giving the "all clear", then the actual
physical removal can occur.

I'm not sure what you're getting at with the "kernel cannot actually
prevent" bit.  No sane system actively destroys perfect good memory
content and tells the kernel about it after the fact.

> - For memory hot-add, if the new memory falls into any CMR, then kernel should
> speak loudly it is a BIOS bug, or even say "TDX is under attack" as this is only
> possible when CMR memory has been previously hot-removed.

I don't think this is strictly true.  It's totally possible to get a
hot-add *event* for memory which is in a CMR.  It would be another BIOS
bug, of course, but hot-remove is not a prerequisite purely for an event.

> And kernel should
> reject the new memory for security reason.  If the new memory doesn't fall into
> any CMR, then we (also) just reject the new memory, as we want to guarantee all
> memory in page allocator are TDX pages.  But this is basically due to kernel
> policy but not due to TDX architecture.

Agreed.

> BUT, since as the first step, we cannot get the CMR during kernel boot (as it
> requires additional code to put CPU into VMX operation), I think for now we can
> handle ACPI memory hotplug in below way:
> 
> - For memory hot-removal, we do nothing.

This doesn't seem right to me.  *If* we get a known-bogus hot-remove
event, we need to reject it.  Remember, removal is a two-step process.

> - For memory hot-add, we simply reject the new memory when TDX is enabled by
> BIOS.  This not only prevents the potential "physical attack of replacing any
> CMR memory",

I don't think there's *any* meaningful attack mitigation here.  Even if
someone managed to replace the physical address space that backed some
private memory, the integrity checksums won't match.  Memory integrity
mitigates physical replacement, not software.

> but also makes sure no non-CMR memory will be added to page
> allocator during runtime via ACPI memory hot-add.

Agreed.  This one _is_ important and since it supports an existing
policy, it makes sense to enforce this in the kernel.

> We can improve this in next stage when we can get CMRs during kernel boot.
> 
> For the concern that on a TDX BIOS enabled system, people may not want to use
> TDX at all but just use it as normal system, as I replied to Dan regarding to
> the driver-managed memory hotplug, we can provide a kernel commandline, i.e.
> use_tdx={on|off}, to allow user to *choose* between TDX and memory hotplug. 
> When use_tdx=off, we continue to allow memory hotplug and driver-managed hotplug
> as normal but refuse to initialize TDX module.

That doesn't sound like a good resolution to me.

It conflates pure "software" hotplug operations like transitioning
memory ownership from the core mm to a driver (like device DAX).

TDX should not have *ANY* impact on purely software operations.  Period.
