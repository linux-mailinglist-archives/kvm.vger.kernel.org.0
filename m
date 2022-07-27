Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1014581CDC
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 02:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239709AbiG0Aut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 20:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiG0Aus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 20:50:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC6828E1B;
        Tue, 26 Jul 2022 17:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658883047; x=1690419047;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FTrR6qP1iHKDHwfnfSs2iYxLlfhKdoQ6vYNhBp0Kwd8=;
  b=JdW6RVzESlckP3SIR9c/h8dWwXvOXmmt4v5a5kuDFD3JiOp3h2BkfkbS
   UNDprkWBZdcaUHqjQ0kXyN5fuyWnpdQ1511ti9GuH/x7ze4qwPzB74lZ3
   vCM7jlVMFne5hDWo08G9brtcEmRXUFa9W3cFgaXeXKBtx98TV1FbwIydd
   ChfQ962I9GmWnsNgXLLDs1KZMoYU60BoxecPVvadtHUIh1cbcQLDhFngL
   pmUjs5jFOgNTtKl/7dMuNMGYKYSsG/h9WjuPBUhLZWLJf47dyQeOv6iyZ
   JeRizk2MRUqdSGlkD2ohn6+0yvtJ8NVAZwa3hvWGmQ+ASF3aXs7Qgqn03
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="285659188"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="285659188"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 17:50:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="575747522"
Received: from cpmcinty-mobl1.ger.corp.intel.com (HELO [10.209.58.71]) ([10.209.58.71])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 17:50:44 -0700
Message-ID: <81b70f92-d869-f56d-a152-11aff4e1d785@intel.com>
Date:   Tue, 26 Jul 2022 17:50:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
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
 <978c3d37-97c9-79b9-426a-2c27db34c38a@intel.com>
 <0b20f1878d31658a9e3cd3edaf3826fe8731346e.camel@intel.com>
 <11b7e8668fde31ead768075e51f9667276ddc78a.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <11b7e8668fde31ead768075e51f9667276ddc78a.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/22 17:34, Kai Huang wrote:
>> This doesn't seem right to me.  *If* we get a known-bogus
>> hot-remove event, we need to reject it.  Remember, removal is a
>> two-step process.
> If so, we need to reject the (CMR) memory offline.  Or we just BUG()
> in the ACPI memory removal  callback?
> 
> But either way this will requires us to get the CMRs during kernel boot.

I don't get the link there between CMRs at boot and handling hotplug.

We don't need to go to extreme measures just to get a message out of the
kernel that the BIOS is bad.  If we don't have the data to do it
already, then I don't really see the nee to warn about it.

Think of a system that has TDX enabled in the BIOS, but is running an
old kernel.  It will have *ZERO* idea that hotplug doesn't work.  It'll
run blissfully along.  I don't see any reason that a kernel with TDX
support, but where TDX is disabled should actively go out and try to be
better than those old pre-TDX kernels.

Further, there's nothing to stop non-CMR memory from being added to a
system with TDX enabled in the BIOS but where the kernel is not using
it.  If we actively go out and keep good old DRAM from being added, then
we unnecessarily addle those systems.

