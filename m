Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF25640BD1
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbiLBRKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbiLBRKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:10:07 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42157E7853;
        Fri,  2 Dec 2022 09:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670001006; x=1701537006;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Bc7pDOCSVt6BMMxZ2t1mYgmI78+hnoS9G21qkQu3Alg=;
  b=TSosnfjcjzlXRKss1354fnzbOCssLC9rQ/2rrTor2+4fMh/NI02WL6Wm
   lJfIe+a17j5I8SDAsaP2NDfORBRFdnXkjSIIyPHgRioAN5PLSJzgF7Ldz
   TlGGidcaV7tyL/DgAv0PI5hi5piAAiKHA/FyfmJkB1UQQEqyzMwN5yew/
   XC5eDNEYBVKgt77EsgToMFcSQnynIYf59GLCdUNKRDoWpRVeEaPaEIR3E
   i2RfJlFo+ysbJj8D040ayg2C9FdUA8O6kSQCuDtfGodTgL4JrqDkIYSRY
   t0w/FpS0a52HghVrnmpULT1t4EVmf8QsQKggKIzORyWlxUCtYdL+8ekIK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="303602798"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="303602798"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 09:06:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675889323"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="675889323"
Received: from rsnyder-mobl.amr.corp.intel.com (HELO [10.209.68.71]) ([10.209.68.71])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 09:06:04 -0800
Message-ID: <21b43adc-37aa-bac3-0615-4703438ea4a1@intel.com>
Date:   Fri, 2 Dec 2022 09:06:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
 <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
 <8f3b1492aefc37f6bdcd8a10051af57c7deb4430.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <8f3b1492aefc37f6bdcd8a10051af57c7deb4430.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/22 03:11, Huang, Kai wrote:
> And also to address you concern that not all 892 bytes are reserved, how about
> below:
> 
>         union {
> -               struct cpuid_config     cpuid_configs[0];
> -               u8                      reserved5[892];
> +               DECLARE_FLEX_ARRAY(struct cpuid_config, cpuid_configs);
> +               u8 padding[892];
>         };
>  } __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
> 
> The goal is to make the size of 'struct tdsysinfo_struct' to be 1024B so we can
> use a static variable for it, and at the meantime, it can still have 1024B
> (enough space) for the TDH.SYS.INFO to write to.

I just don't like the open-coded sizes.

For instance, wouldn't it be great if you didn't have to know the size
of *ANYTHING* else to properly size the '892'?

Maybe we just need some helpers to hide the gunk:

#define DECLARE_PADDED_STRUCT(type, name, alignment) 	\
struct type##_padded {					\
	union {						\
		struct type name;			\
		u8 padding[alignment];			\
	}						\
} name##_padded;

#define PADDED_STRUCT(name)	(name##_padded.name)

That can get used like this:

DECLARE_PADDED_STRUCT(struct tdsysinfo_struct, tdsysinfo,
		      TDSYSINFO_STRUCT_ALIGNMENT);


	struct tdsysinfo_struct sysinfo = PADDED_STRUCT(tdsysinfo)
