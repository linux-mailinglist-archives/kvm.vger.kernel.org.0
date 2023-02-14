Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02941696B60
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 18:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjBNRXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 12:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbjBNRXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 12:23:53 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF842C648;
        Tue, 14 Feb 2023 09:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676395423; x=1707931423;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BvnSupCLokKbvMF3qV9pvBDIftfya/8td2qfw3msbX8=;
  b=UVC1PMH/VFHOm9eLeIXCn8SgwHFqVBou8kiazA5XpjgZsahafWK/nu4o
   q3skbd9IYqIUdJ0y88chiGHX1vXZA2z6ysk1dCPMo34PATkh8Q6bPMeHC
   hNt9un8gItXg3r1d+rDKMgUOS3F1/v5H2v9tVJgwX1pzQ16I6cnbQJWLF
   ey1m+/gPXXE7Fqj1KgpQ00hmFnMbSWCqXwKfX7oFaFdRsSRDsatMjLGzl
   PX3dMFvTd94VpXvzfPVTZPZAkPkp0ZIulIg4pFp+vtLkD8RR/ULZTGY1f
   2Mh2ccCewsT5+u9E3w9jNUIR0VP6nPfmTxbgDGE4FMUZu8rJ1f8UDcpzg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="393616408"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="393616408"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:23:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="914819406"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="914819406"
Received: from jklechel-mobl1.amr.corp.intel.com (HELO [10.212.244.208]) ([10.212.244.208])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:23:41 -0800
Message-ID: <a44246e1-72de-4c9a-c602-dfc2f7df129b@intel.com>
Date:   Tue, 14 Feb 2023 09:23:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 04/18] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, david@redhat.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1676286526.git.kai.huang@intel.com>
 <eb565156d84e35a846a886025513a712f2ac2f83.1676286526.git.kai.huang@intel.com>
 <Y+uCtZ7itiNsbR4j@hirez.programming.kicks-ass.net>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y+uCtZ7itiNsbR4j@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/23 04:46, Peter Zijlstra wrote:
> On Tue, Feb 14, 2023 at 12:59:11AM +1300, Kai Huang wrote:
>> Use a state machine protected by mutex to make sure the initialization
>> will only be done once, as tdx_enable() can be called multiple times
>> (i.e. KVM module can be reloaded) and be called concurrently by other
>> kernel components in the future.
> I still object to doing tdx_enable() at kvm module load.
> 
> kvm.ko gets loaded unconditionally on boot, even if I then never use
> kvm.
> 
> This stuff needs to be done when an actual VM is created, not before.

The actually implementation of this is hidden over in the KVM side of
this.  But, tdx_enable() and all of this jazz should not be called on
kvm.ko load.  It'll happen when the KVM tries to start the first TDX VM.

I think what Kai was thinking of was *this* sequence:

 1. insmod kvm.ko
 2. Start a TDX guest, tdx_enable() gets run
 3. rmmod kvm
 4. insmod kvm.ko (again)
 5. Start another TDX guest, run tdx_enable() (again)

The rmmod/insmod pair is what triggers the second call of tdx_enable().
