Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46C973701F
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 17:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbjFTPQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 11:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjFTPQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 11:16:26 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B63B139;
        Tue, 20 Jun 2023 08:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687274153; x=1718810153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EkOKMTe987MyhE5QTRwsU/e71+NrklxUguEAgpGVtRc=;
  b=OLmPsXBE1GckGrQNmv5fodrBLaGVJIodTRBFRmql/yvXFOGkJFjszvYV
   oIqMfO7BlCcNhpicZT3r2Pf0N6jluw0P5PV9STHiHp89WaLBYlDnthLqR
   eq7Lb+or363ZeST303qnCgkkaTCgepVMJq+B8WpalH52Z4atIc/nU2pbE
   iMHpkX4kuK2mXHSZhIgT3v9UqyPhuXUFa/4thuS6gDFLDWljS0pArS4wk
   m22VbuK7YrhbRZotcLBlzCuwFOpWm0dbHsZ9v0mXBg+u+Qv9qGfwXfES/
   BOiNLeEsgBD+95TZvi9bSSocmPpdK3a7mfq2QYsDe/FWqJ5WWULLBtTgA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="425842243"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="425842243"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 08:15:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="691466429"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="691466429"
Received: from rashmigh-mobl.amr.corp.intel.com (HELO [10.255.228.28]) ([10.255.228.28])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 08:15:31 -0700
Message-ID: <a6d482b5-05d8-01a9-be63-f52ae03e0be5@intel.com>
Date:   Tue, 20 Jun 2023 08:15:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
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
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <759e3af5-6aec-7e50-c432-c5e0a0c3cf36@redhat.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <759e3af5-6aec-7e50-c432-c5e0a0c3cf36@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/23 05:52, David Hildenbrand wrote:
>> +    /*
>> +     * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
>> +     * the trap number.  Convert the trap number to the TDX error
>> +     * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
>> +     *
>> +     * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
>> +     * only accepts 32-bit immediate at most.
> 
> Not sure if that comment is really helpful here. It's a common pattern
> for large immediates, no?

It's a question of whether you write the comments for folks that read
x86 assembly all the time or not.

I think the comment is helpful.
