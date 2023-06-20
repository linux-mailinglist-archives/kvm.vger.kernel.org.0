Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553E67360FB
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 03:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjFTBGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 21:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFTBGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 21:06:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93BD9C;
        Mon, 19 Jun 2023 18:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687223193; x=1718759193;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VHof60/+vU8A0IEg7SMylUsXJOqbW8P6DsjVQClaj6M=;
  b=LGo9aCAqlCCtMp668IHW5/RXUDWilcU395bMRHfwidpx61QdhEuj5vH0
   meBBzA/X7z6hT9x14RQUIlJkjPpinxA4fLcpA3lozYBbmuAqobVjnNm1R
   7rFcePaCSCGD0dnMvWMc9m5iE7+P3XMtUjYhihyq21ap5KtfTiseMQ+u8
   KCz7sppnZ7FHhZNQKbTm1UnkqTcQ+3GfcvazsWTvW6OiVDVGk+VigQWBY
   Y1ciiwFeVyrglBEidrPMsXDIJO59GFnd82qOklScpX97AoR8i1lyQcYy+
   HhIbDvUjzepYYfme7VOk3uvcPejdTLae5DZJj56m0SeCEZGB69Pb4mKH2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="362277231"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="362277231"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 18:06:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="858376029"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="858376029"
Received: from alaird-mobl2.amr.corp.intel.com (HELO [10.212.177.39]) ([10.212.177.39])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 18:06:30 -0700
Message-ID: <4069285d-1653-4cbf-a3b3-24727697754b@intel.com>
Date:   Mon, 19 Jun 2023 18:06:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
 <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
 <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
 <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
 <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
 <5782c8c2bb3e76a802e4a81c553a21edbaee7c47.camel@intel.com>
 <be258af9-a329-6f03-fcf9-9dafad42c97f@intel.com>
 <20230619144651.kvmscndienyfr3my@box.shutemov.name>
 <63477d22-26ef-dd08-a3b0-93931b7d1d16@intel.com>
 <0be5634f390015ee6badb3f2b2154ad90eb70434.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <0be5634f390015ee6badb3f2b2154ad90eb70434.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/23 17:56, Huang, Kai wrote:
> Any comments to below?

Nothing that I haven't already said in this thread:

> Just use a normal old atomic_t or set_bit()/test_bit().  They have
> built-in memory barriers are are less likely to get botched.

I kinda made a point of literally suggesting "atomic_t or
set_bit()/test_bit()".  I even told you why: "built-in memory barriers".

Guess what READ/WRITE_ONCE() *don't* have.  Memory barriers.



