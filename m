Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA0B6630D2
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 20:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbjAITyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 14:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbjAITyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 14:54:33 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF231026;
        Mon,  9 Jan 2023 11:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673294072; x=1704830072;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EYmGw8cKylJ3oVUnXbyNAs21ToQ2EjfNHKl2V8Wq3dg=;
  b=jSaEx1vRnhKKV0TNzowvfZCN0aZl9/xRHta0gZwnoFQBD6/6w2IZEMA7
   Sy+gtpZegW8D+E2evDM+zDiHDI4jX4uPM520P8dW/aSjeREQoc4alpyAs
   Ir05pkJg6XLKVzve0PF1YApOg+ckw/x07Axfyfo+EWjvvYfdNTLn0wMxg
   zzVqXsbTQ5t55PMBE+/iDzyvRyRAmVpXMuH8rjF9LZIgRV2eA5jqZKeO9
   MfdwIsiVRHSjSXh5R+k1cZ7u89GkiT79YE11Uv7QQ+GamrSixyH8yypXl
   ySCz8s/IhqQyN0q2VAplGifUP4qgGowR6eaajKxarXaxTVNxalkREhWSJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="387414657"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="387414657"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 11:54:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="725289770"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="725289770"
Received: from swapnadi-mobl2.amr.corp.intel.com (HELO [10.209.29.117]) ([10.209.29.117])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 11:54:31 -0800
Message-ID: <8d1b8738-03d2-b5a6-fd63-a6513db4c86b@intel.com>
Date:   Mon, 9 Jan 2023 11:54:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 05/16] x86/virt/tdx: Implement functions to make
 SEAMCALL
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <d74565e3f71b6e5e5183f3b736222ec42b6e0b81.1670566861.git.kai.huang@intel.com>
 <61b9cc00-d514-df77-0a31-88ec35d73456@intel.com>
 <e6296f511bb4fae4696ec19d5777103044f3aad9.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <e6296f511bb4fae4696ec19d5777103044f3aad9.camel@intel.com>
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

On 1/9/23 02:30, Huang, Kai wrote:
>> I don't know that you really _need_ to split this up, but I'm just
>> pointing out that mashing three different logical things together makes
>> it hard to write a coherent Subject.  But, I've seen worse.
> Agreed.
> 
> To me seems "Add SEAMCALL infrastructure" is good enough, but I can split up if
> you want me to.

Everything else being equal, I'd rather have them split up.  But, I'm
frankly not looking forward to the additional work on my part to review
and rework three more patches and changelogs.
