Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C08633FE5
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 16:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiKVPOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 10:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiKVPOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 10:14:20 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBA2248F0;
        Tue, 22 Nov 2022 07:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669130060; x=1700666060;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r2krHQGmMwXskHlRA/gzgQj5fk0U4oZy2ymf007Yg90=;
  b=Om3ssplW7cuvyeHGz7LLUt/fEAbe2FNPK9nC8cZwsSlwaEwrVeC8aSZc
   +SZnGkMHcJ0RRdpsZXZoXCjHhJfDfy7u9c0Ti/EXBRGaDTX5gG3GHy2Pf
   6LfUu1XjvivRQhqkiU9RSp7YA8huLtkNcQqi5uJZQevsVyzuApNRMiDCH
   ctsVRaCL04Koj9X3H328yOF8Fx7PPWzvVp0xc2pCD1NdrXsbXW3j7zMJp
   J2o0MEhAoY/rt+HaemD5wDbcugyI+/ajCKC9xbBg1SwwKHqdJj7VXpKNR
   GZHy6GVn2JpP8PFlEX/5dj/LniKuOCIx2GehDZWLpBMkjYzJB7gtdM0hD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="375979955"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="375979955"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 07:14:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="886568675"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="886568675"
Received: from lcano-mobl1.amr.corp.intel.com (HELO [10.255.231.75]) ([10.255.231.75])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 07:14:15 -0800
Message-ID: <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
Date:   Tue, 22 Nov 2022 07:14:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
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

On 11/22/22 01:13, Peter Zijlstra wrote:
> On Mon, Nov 21, 2022 at 01:26:28PM +1300, Kai Huang wrote:
>> +/*
>> + * Call the SEAMCALL on all online CPUs concurrently.  Caller to check
>> + * @sc->err to determine whether any SEAMCALL failed on any cpu.
>> + */
>> +static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
>> +{
>> +	on_each_cpu(seamcall_smp_call_function, sc, true);
>> +}
> 
> Suppose the user has NOHZ_FULL configured, and is already running
> userspace that will terminate on interrupt (this is desired feature for
> NOHZ_FULL), guess how happy they'll be if someone, on another parition,
> manages to tickle this TDX gunk?

Yeah, they'll be none too happy.

But, what do we do?

There are technical solutions like detecting if NOHZ_FULL is in play and
refusing to initialize TDX.  There are also non-technical solutions like
telling folks in the documentation that they better modprobe kvm early
if they want to do TDX, or their NOHZ_FULL apps will pay.

We could also force the TDX module to be loaded early in boot before
NOHZ_FULL is in play, but that would waste memory on TDX metadata even
if TDX is never used.

How do NOHZ_FULL folks deal with late microcode updates, for example?
Those are roughly equally disruptive to all CPUs.
