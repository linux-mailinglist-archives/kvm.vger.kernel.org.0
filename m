Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A6F72C650
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 15:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbjFLNrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 09:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235749AbjFLNrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 09:47:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0C810D3;
        Mon, 12 Jun 2023 06:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686577629; x=1718113629;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tEEMAOv5y1FNh96KVITEe1drEbJjSixD47uAg1phk68=;
  b=eqr6dqHSLAp8AWvuJlx/L8H2pldfqPjY+ZqU8f8VvJ+ve9Z7Ov4gNNIV
   v8lG43Fi5IG9BxVjOR9Y71LtiDRawLy5AG2i7YnzkWqRZ4i/6IZjdUmLJ
   wQ2hNKmZl7aq32x26fpH5ZjeINVe545/wvTNga19TtcxBaBKeBREdbpAI
   cYHSoCGpG06FXgoglwT5eESJqlwmmAPCcwZDsWQ2s3odDIVonHzYxfBkk
   QX7H9lFvkRt7o13/99aSzy449XVRK0uOc/G/GsQBG7EpJJY9MxJ3K06/k
   TtEgqTAEl4fl2zpHd2dfy/IpQtpgTqPLWxbSmBcHvUXSOIwIOvVYYGLIz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="358035649"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="358035649"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 06:47:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="705388478"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="705388478"
Received: from spmantha-mobl1.amr.corp.intel.com (HELO [10.209.43.2]) ([10.209.43.2])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 06:47:08 -0700
Message-ID: <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
Date:   Mon, 12 Jun 2023 06:47:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
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

On 6/12/23 03:27, Huang, Kai wrote:
> So I think a __mb() after setting tdmr->pamt_4k_base should be good enough, as
> it guarantees when setting to any pamt_*_size happens, the valid pamt_4k_base
> will be seen by other cpus.
> 
> Does it make sense?

Just use a normal old atomic_t or set_bit()/test_bit().  They have
built-in memory barriers are are less likely to get botched.
