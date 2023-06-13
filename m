Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169C572E5A8
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242903AbjFMOZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242902AbjFMOZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:25:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B6718E;
        Tue, 13 Jun 2023 07:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686666352; x=1718202352;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9ZOjzvXeHOv0lTk6ZQqq4BOSuyG4jJy6UYMgU4D+dhY=;
  b=and3HBd4RTsl+AxqrlUD0zWd1WUFv6zYbpyrlMoYjiEkkoRP+938lyWA
   iCfbXgRKqtnb5OuzlwSTURjpvldgQ7urf3yEFjkMyz1zvkb3VrU3J/6Sp
   BsHt3fnngNSkQ3wy8p8QBz1qJp7lSq90TbK9GpSyRpAnQwkVWpNidGMj6
   XUJC3Sh7lo7F7F2xs3Jn9OHh8WSulHlCfQ9T4uteaXyie5QAcy9M34y6G
   uOjuXpZGZlRpoN4TjVIhFT9iVcic7z+clyx3VpMbvjicwjmjEwmqSqFKU
   XbiW/2wZu1+hwzhmrsM9ihBmaZcLNbQxlLcPRxl5gChbjjoi/h5YGKBXs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="421940629"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="421940629"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:25:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="705817951"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="705817951"
Received: from clin147-mobl.amr.corp.intel.com (HELO [10.212.134.227]) ([10.212.134.227])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:25:51 -0700
Message-ID: <6fb1ec2f-8713-8191-fd31-751b1a663b0b@intel.com>
Date:   Tue, 13 Jun 2023 07:25:50 -0700
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
 <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/12/23 17:51, Huang, Kai wrote:
> If we introduce a helper to mark a page as TDX private page, 

Let me get this right: you have working, functional code for a
highly-unlikely scenario (kernel bugs or even more rare hardware
errors).  But, you want to optimize this super-rare case?  It's not fast
enough?

Is there any other motivation here that I'm missing?

