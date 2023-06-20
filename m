Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF56737156
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 18:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbjFTQVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 12:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjFTQVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 12:21:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1FBE2;
        Tue, 20 Jun 2023 09:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687278099; x=1718814099;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JdugfFBFPuP9CneMUY34icuY2vnuoN7wjB/Ecq9vP+0=;
  b=m0itpQk1n0pnzk6ED4hMaA2fm1YY4rbk0U0R578bjxuPf2EsK1KHu3RS
   9vk0zjqdBaI3ye0M5JGDlMFBsio2aXaDDVMTs0mqCxsvXzzdYNZkdFVJ4
   amGPpmBtHnmsIt6TL2JlnjtvJXA4mGruC1sFIHgfDoxE5ttIDi2Jtcs7s
   NFlV8bwOFc1lcPrJTdHwmdhj+nqOX4YRvUbmRsGPKO+GDMb8ig8WZQRZQ
   YtOOOfZrHvDeIolunE9qDKf/r/9Nw3YYDmWN1zAR3YCXnOWp2apYV+6bh
   eiLKLezYz+vPsj0dHxeFzKY7q3b4ybNRUsVwK7MsIJnEyoJxfcf1g9Q1S
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="344650732"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="344650732"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 09:21:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="714094674"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="714094674"
Received: from rashmigh-mobl.amr.corp.intel.com (HELO [10.255.228.28]) ([10.255.228.28])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 09:21:38 -0700
Message-ID: <b96f42c7-c05b-9795-630c-940f8692aa2d@intel.com>
Date:   Tue, 20 Jun 2023 09:21:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com,
        "Raj, Ashok" <ashok.raj@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
 <723dd9da-ebd5-edb0-e9e5-2d8c14aaffe2@redhat.com>
 <f64ee1a5-d96f-d888-14a7-8b4c5e7a9a2f@intel.com>
 <216753fd-c659-711e-12d0-d12e34110efc@redhat.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <216753fd-c659-711e-12d0-d12e34110efc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/23 09:03, David Hildenbrand wrote:
> On 20.06.23 17:39, Dave Hansen wrote:
>> On 6/19/23 05:21, David Hildenbrand wrote:
>>> So, ordinary writes to TD private memory are not a problem? I thought
>>> one motivation for the unmapped-guest-memory discussion was to prevent
>>> host (userspace) writes to such memory because it would trigger a MC and
>>> eventually crash the host.
>>
>> Those are two different problems.
>>
>> Problem #1 (this patch): The host encounters poison when going about its
>> normal business accessing normal memory.  This happens when something in
>> the host accidentally clobbers some TDX memory and *then* reads it.
>> Only occurs with partial writes.
>>
>> Problem #2 (addressed with unmapping): Host *userspace* intentionally
>> and maliciously clobbers some TDX memory and then the TDX module or a
>> TDX guest can't run because the memory integrity checks (checksum or TD
>> bit) fail.  This can also take the system down because #MC's are nasty.
>>
>> Host userspace unmapping doesn't prevent problem #1 because it's the
>> kernel who screwed up with the _kernel_ mapping.
> 
> Ahh, thanks for verifying. I was hoping that problem #2 would get fixed
> in HW as well (and treated like a BUG).

No, it's really working as designed.

#1 _can_ be fixed because the hardware can just choose to let the host
run merrily along corrupting TDX data and blissfully unaware of the
carnage until TDX stumbles on the mess.  Blissful ignorance really is a
useful feature here.  It means, for instance, that if the kernel screws
up, it can still blissfully kexec(), reboot , boot a new kernel, or dump
to the console without fear of #MC.

#2 is much harder because the TDX data is destroyed and yet the TDX side
still wants to run.  The SEV folks chose page faults on write to stop
SEV from running and the TDX folks chose #MC on reads as the mechanism.

All of the nastiness on the TDX side is (IMNHO) really a consequence of
that decision to use machine checks.

(Aside: I'm not specifically crapping on the TDX CPU designers here.  I
 don't particularly like the SEV approach either.  But this mess is a
 result of the TDX design choices.  There are other messes in other
 patch series from SEV. )

> Because problem #2 also sounds like something that directly violates the
> first paragraph of this patch description "violations of
> this integrity protection are supposed to only affect TDX operations and
> are never supposed to affect the host kernel itself."
> 
> So I would expect the TDX guest to fail hard, but not other TDX guests
> (or the host kernel).

This is more fallout from the #MC design choice.

Let's use page faults as an example since our SEV friends are using
them.  *ANY* instruction that reads memory can page fault, have the
kernel fix up the fault, and continue merrily along its way.

#MC is fundamentally different.  The exceptions can be declared to be
unrecoverable.  The CPU says, "whoopsie, I managed to deliver this #MC,
but it would be too hard for me so I can't continue."  These "too hard"
scenarios are shrinking over time, but they do exist.  They're fatal.


