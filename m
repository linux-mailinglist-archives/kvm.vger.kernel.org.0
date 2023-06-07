Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B967264A0
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241519AbjFGP2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 11:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241513AbjFGP1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 11:27:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AEB1FFD;
        Wed,  7 Jun 2023 08:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686151624; x=1717687624;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o9s+xCFEIMsJhr2kn88p0xT5DlNmtrw35RZsqUG2rrU=;
  b=LshhY9PBYfvosCss8yw8CdbEtgefrB0rmy4IanW22T0Occbwnxw+5a70
   VLMh2XG/jq6AM629JBkNhJU+yfSGqz8HygygvJB9R7s+Zq5RL7KZ5esfs
   Xiy+P2vInbfXFyL/AP4I1myBZ5fakqNcBbDghs98y0FOZc6nFrh2snlz9
   Oevebxh00RTu79047ltatfT7wpMuNwTXtAtWUSKB+kp/fFBQVNnXhHzJu
   BOEZHI9RGLVVGfg3zgKg+saJ6vmtqowwyowWhljUIi5RU9ttdevlx/y0a
   C1Aqeu70PrNpogn8Ybhq07vF/4Sjn6r1AnLmtk4vv8K5Z0TTJZIIDYx4F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="422868708"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="422868708"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:25:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="822207952"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="822207952"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:25:36 -0700
Message-ID: <692d2345-914c-595c-1214-84c966f15aa6@intel.com>
Date:   Wed, 7 Jun 2023 08:25:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/23 07:27, Kai Huang wrote:
> Start to transit out the "multi-steps" to initialize the TDX module.
> 
> TDX provides increased levels of memory confidentiality and integrity.
> This requires special hardware support for features like memory
> encryption and storage of memory integrity checksums.  Not all memory
> satisfies these requirements.
> 
> As a result, TDX introduced the concept of a "Convertible Memory Region"
> (CMR).  During boot, the firmware builds a list of all of the memory
> ranges which can provide the TDX security guarantees.
> 
> CMRs tell the kernel which memory is TDX compatible.  The kernel takes
> CMRs (plus a little more metadata) and constructs "TD Memory Regions"
> (TDMRs).  TDMRs let the kernel grant TDX protections to some or all of
> the CMR areas.
> 
> The TDX module also reports necessary information to let the kernel
> build TDMRs and run TDX guests in structure 'tdsysinfo_struct'.  The
> list of CMRs, along with the TDX module information, is available to
> the kernel by querying the TDX module.
> 
> As a preparation to construct TDMRs, get the TDX module information and
> the list of CMRs.  Print out CMRs to help user to decode which memory
> regions are TDX convertible.
> 
> The 'tdsysinfo_struct' is fairly large (1024 bytes) and contains a lot
> of info about the TDX module.  Fully define the entire structure, but
> only use the fields necessary to build the TDMRs and pr_info() some
> basics about the module.  The rest of the fields will get used by KVM.
> 
> For now both 'tdsysinfo_struct' and CMRs are only used during the module
> initialization.  But because they are both relatively big, declare them
> inside the module initialization function but as static variables.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
