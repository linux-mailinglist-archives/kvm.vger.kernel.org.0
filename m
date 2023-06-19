Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA5673602E
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 01:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjFSXl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 19:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFSXlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 19:41:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D6CF9;
        Mon, 19 Jun 2023 16:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687218084; x=1718754084;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=21XuNSMWno9LWgAZY4Y02nVhebZ1AAnjQNfqusT2Fjo=;
  b=dOPSXTR+h4p5iERAcINIYSuAA3EwGwmTwkeNPYwtQxt1tIEAkDT17KGs
   cEaSc5lqqRZnjhOxybSzjrfcTL/A2R7xw77VQaJi+YQ4xmhvIlLxn49QJ
   f1TByVgAYw+J51i6H/6MbRY1EoApt9G6uuvLDWEiT3PCVbe8tZCNUcTZ/
   7py4XAcSHUFEFNhh+t7PGPA87eXX11Q0BObUlBK93fit3DFPG2xqDagBO
   cKDnGaCVDiqbiIf72zZ8p6VJW8sXL1JEj8FrgLSfq6bjbg86aZbsNacw8
   sUjjM1vj28FiobS0OzP+uwz4PyEebGUjvdF5/oVWxNnscBL7IqYishnzp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="359733063"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="359733063"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 16:41:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="838010303"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="838010303"
Received: from alaird-mobl2.amr.corp.intel.com (HELO [10.212.177.39]) ([10.212.177.39])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 16:41:13 -0700
Message-ID: <63477d22-26ef-dd08-a3b0-93931b7d1d16@intel.com>
Date:   Mon, 19 Jun 2023 16:41:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Content-Language: en-US
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230619144651.kvmscndienyfr3my@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/23 07:46, kirill.shutemov@linux.intel.com wrote:
>>>
>>> Using atomic_set() requires changing tdmr->pamt_4k_base to atomic_t, which is a
>>> little bit silly or overkill IMHO.  Looking at the code, it seems
>>> arch_atomic_set() simply uses __WRITE_ONCE():
>> How about _adding_ a variable that protects tdmr->pamt_4k_base?
>> Wouldn't that be more straightforward than mucking around with existing
>> types?
> What's wrong with simple global spinlock that protects all tdmr->pamt_*?
> It is much easier to follow than a custom serialization scheme.

Quick, what prevents a:

	spin_lock() => #MC => spin_lock()

deadlock?

Plain old test/sets don't deadlock ever.
