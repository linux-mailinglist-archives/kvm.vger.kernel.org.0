Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A1262C7AF
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 19:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbiKPScK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 13:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiKPScJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 13:32:09 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E504B992;
        Wed, 16 Nov 2022 10:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668623528; x=1700159528;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9R89P7Fn5UnS6fXNsmjWkdjOCqGyO+Ikj7R423cX13o=;
  b=d3X+XG4VE1lUFFAupa2GatYvywpF3Y4ACePAF+g6/A3nUwYvuZoVybbo
   4XyR7sUQehsg4RzHoiZgRYrgOIQZa4r8WEISk2UuWAqTVVRmGCe8MaEeI
   7DpLp9Yb7OXE0VeDimiyh87FvTRHLbLHEDtWnxhwFuybuFhsS6KeFaPHi
   ZQ7lWsaogcdQ/3xsv6HLdf24wmBjmE5vsj8A66pnASSYcR1O8LOyhohLW
   HBvwRZ8ojGjV4oI6HWD8a6u3sFAnYaAUAn02cEXDBmpQOJTl+njq4VyWr
   Wke0MnOiWgGLf6XbMrTYL830I/W5lKYKYarYo8M4ovF2eo+vJC9PiUP2y
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="292333588"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="292333588"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 10:32:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="670601611"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="670601611"
Received: from aagbadea-mobl.amr.corp.intel.com (HELO [10.252.138.56]) ([10.252.138.56])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 10:32:06 -0800
Message-ID: <0ab63cf5-7587-0347-22bf-0987704a5153@intel.com>
Date:   Wed, 16 Nov 2022 10:32:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>,
        "Kalra, Ashish" <ashish.kalra@amd.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic> <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic> <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
 <9d9f1afe-c981-4df9-f012-89c4cb783cc3@amd.com>
 <973c6f79-38ad-aa30-bfec-c2a1c7db5d70@suse.cz>
 <8692e736-7518-d6d2-ae83-720e42e7a059@amd.com>
 <41b8c83e-2a1a-1dda-945e-99329ca8e7e9@suse.cz>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <41b8c83e-2a1a-1dda-945e-99329ca8e7e9@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/22 02:25, Vlastimil Babka wrote:
>> Referring back to your thoughts about putting these pages on some leaked
>> pages list, do any such leaked pages list exist currently ?
> Not AFAIK, you could just create a list_head somewhere appropriate (some snp
> state structure?) and put the pages there, maybe with a counter exposed in
> debugs. The point would be mostly that if something goes so wrong it would
> be leaking substantial amounts of memory, we can at least recognize the
> cause (but I suppose the dmesg will be also full of messages) and e.g. find
> the pages in a crash dump.

It might also be worth looking through the places that check
PageHWPoison() and making sure that none of them are poking into the
page contents.

It's also the kind of thing that adding some CONFIG_DEBUG_VM checks
might help with.  For instance, nobody should ever be kmap*()'ing a
private page.  The same might even go for pin_user_pages().
