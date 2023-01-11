Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F3766505F
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 01:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbjAKAbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 19:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235626AbjAKAa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 19:30:57 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBFA5471A;
        Tue, 10 Jan 2023 16:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673397048; x=1704933048;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JUviILzDclP6dIdqFUr0ki8G4FQJgb1JbwWGsrEAaus=;
  b=PRArehwiyDw2aGpEAVw7qPLK6c9T2Kq2v0qf7XGN3HGE2kAVkhSTKMBW
   Ibz6RbwfPB0iMKnLd6a+MbATvtXeA5WFlmFiN0SFqC4vA0Fd1cmxTYOWb
   n/1C/iWQxE26rVF6tLQaKPtlDN/aORk7N8+ml0TDIei1TCAMmBSsLuaTG
   SQP7UaFsqvGLgXv4oizu/nKFbmIBNQ8eqMsQStjho8rpHdinwc+cdZ5Oc
   L8qL51srtNxx90GJ2gupXhl1HHZn22aiV9BeSEB0hlmRuMs4rCWM4mmRU
   8OwY/XLqz+oYynyDlQgP4hYedt4NqGgwiariD8q562YXJbtrfoLVvN8yu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="303665223"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="303665223"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 16:30:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="725719077"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="725719077"
Received: from svenka7-mobl1.amr.corp.intel.com (HELO [10.209.63.27]) ([10.209.63.27])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 16:30:47 -0800
Message-ID: <c5a08366-ddc2-a26f-fffa-c2b0ac4e45b4@intel.com>
Date:   Tue, 10 Jan 2023 16:30:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX is
 enabled
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <ee5185e1727c3cd8bd51dbf9fcec95d432100d12.1670566861.git.kai.huang@intel.com>
 <ba0fdee9-148b-b0b9-ecde-2610eff02ba1@intel.com>
 <6f959f494f0fb3dedfa963c3d6a0ce7f395b745d.camel@intel.com>
 <944ffd4b-3090-e068-a649-b9a84add8395@intel.com>
 <b84232220d03889321248ffb82739c64204cc4af.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <b84232220d03889321248ffb82739c64204cc4af.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/23 16:13, Huang, Kai wrote:
> On Tue, 2023-01-10 at 07:27 -0800, Dave Hansen wrote:
...
>> Think about it this way: kexec() is modifying persistent (across kexec)
>> state to get the system ready for the new kernel.  The caches are
>> persistent state.  Devices have persistent state.  Memory state persists
>> across kexec().  The memory integrity metadata persists.
>>
>> What persistent state does a conversion to KeyID-0 affect?  It resets
>> the integrity metadata and the memory contents.
>>
>> Kexec leaves memory contents in place and doesn't zero them, so memory
>> contents don't matter.  The integrity metadata also doesn't matter
>> because the memory will be used as KeyID-0 and that KeyID doesn't read
>> the integrity metadata.
> 
> Right.  So I guess we just need to call out the new kernel will use memory as
> KeyID-0?

Not even that.

Say the new kernel wanted to use the memory as KeyID-3.  What would it
do?  It would *ASSUME* that the memory *WASN'T* KeyID-3.  It would
convert it to KeyID-3.  That conversion would work from *any* KeyID.

So:

	KeyID-0: OK, because it has no integrity enforcement
	KeyID-1: OK, new kernel will convert the page
	KeyID-2: OK, new kernel will convert the page
	...
	KeyID-$MAX: OK, new kernel will convert the page

So, "OK" everywhere.  Nothing to do... anywhere.

Either I'm totally missing how this works, or you're desperately trying
to make this more complicated than it is.

