Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C2755CA2D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240785AbiF0U7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 16:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiF0U7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 16:59:36 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290845FD5;
        Mon, 27 Jun 2022 13:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656363575; x=1687899575;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Qlh2pWlwHqBy4thP9knrY3EK29U5a83tGaMLEWAlvBo=;
  b=PTRCsYMFkf0MBbsG6QK1IcSOcg0iK0AYE0g60CcsyJwIM5a7TuRjZU2D
   m7sI24Q61lKqEL8kX4wuDEC2KwloyxMGs28AfBKaJ0Frewu2+30zKvwdD
   /xCYlbqVXj46zwd8ZIhrjIWu7yLkqRiNwi19nu3nfifDe/Js3+uzHl+QW
   YLKd24Xbbs6vctqVYOfka8/Ki4mcV5tnOrxfJTxwi/PlQl0QG7f4H8WG1
   Uf5KjmcLeTJK1h7G/b6ypEa8uOvMpWTUDnoP4yqogjDDkMXuwWxTOlBZU
   5OOZOvn/+F7MrVnVknETgj2HpO+XmZFJcQ1m0wZa9yJS2i/rua2kn5CpT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282295696"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282295696"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 13:59:34 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="732476412"
Received: from jsagoe-mobl1.amr.corp.intel.com (HELO [10.209.12.66]) ([10.209.12.66])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 13:59:33 -0700
Message-ID: <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
Date:   Mon, 27 Jun 2022 13:58:35 -0700
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/26/22 22:23, Kai Huang wrote:
> On Fri, 2022-06-24 at 11:38 -0700, Dave Hansen wrote:
>> On 6/22/22 04:16, Kai Huang wrote:
>>> SEAMCALL instruction causes #GP when SEAMRR isn't enabled, and #UD when
>>> CPU is not in VMX operation.  The TDX_MODULE_CALL macro doesn't handle
>>> SEAMCALL exceptions.  Leave to the caller to guarantee those conditions
>>> before calling __seamcall().
>>
>> I was trying to make the argument earlier that you don't need *ANY*
>> detection for TDX, other than the ability to make a SEAMCALL.
>> Basically, patch 01/22 could go away.
...
>> So what does patch 01/22 buy us?  One EXTABLE entry?
> 
> There are below pros if we can detect whether TDX is enabled by BIOS during boot
> before initializing the TDX Module:
> 
> 1) There are requirements from customers to report whether platform supports TDX
> and the TDX keyID numbers before initializing the TDX module so the userspace
> cloud software can use this information to do something.  Sorry I cannot find
> the lore link now.

<sigh>

Never listen to customers literally.  It'll just lead you down the wrong
path.  They told you, "we need $FOO in dmesg" and you ran with it
without understanding why.  The fact that you even *need* to find the
lore link is because you didn't bother to realize what they really needed.

dmesg is not ABI.  It's for humans.  If you need data out of the kernel,
do it with a *REAL* ABI.  Not dmesg.

> 2) As you can see, it can be used to handle ACPI CPU/memory hotplug and driver
> managed memory hotplug.  Kexec() support patch also can use it.
> 
> Particularly, in concept, ACPI CPU/memory hotplug is only related to whether TDX
> is enabled by BIOS, but not whether TDX module is loaded, or the result of
> initializing the TDX module.  So I think we should have some code to detect TDX
> during boot.

This is *EXACTLY* why our colleagues at Intel needs to tell us about
what the OS and firmware should do when TDX is in varying states of decay.

Does the mere presence of the TDX module prevent hotplug?  Or, if a
system has the TDX module loaded but no intent to ever use TDX, why
can't it just use hotplug like a normal system which is not addled with
the TDX albatross around its neck?

> Also, it seems adding EXTABLE to TDX_MODULE_CALL doesn't have significantly less
> code comparing to detecting TDX during boot:

It depends on a bunch of things.  It might only be a line or two of
assembly.

If you actually went and tried it, you might be able to convince me it's
a bad idea.
