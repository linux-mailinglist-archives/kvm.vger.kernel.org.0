Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4431360F748
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 14:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbiJ0MbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 08:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbiJ0Ma7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 08:30:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC2E48CAC;
        Thu, 27 Oct 2022 05:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666873858; x=1698409858;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J/jDCmg2q7bhm09TkkUUe1KdpjACywa3pCPoHGip/fs=;
  b=V1BL38SH9cvADCEzGGjZ/lafIR1WmC8Kf4HgKeRM3mqhuX0c5CHwlRQj
   VPZgQ07cQ8mhvOVAcpOi2r7lX5QRXNiX9lHKIzBWmXWhGcZs/8q5Rr/s0
   RTmD/8O4Sy7pLqvJ5uOEmiHZ4NGdhBWkyt4qaF5LL/XZRFzw5U9EF7pAT
   924HTglJGUOtDW5QxobPs+NV2Cd6IALUdtYagFS/GSspwTfZ7f+TyIX2S
   V6yfVc0sPfpvEwFXOoxvADoXRmD0kzk9cV0Gsp61UZESRNmXOom14E9jf
   h2TqgfPh5zF4GZi4hcv1AyWAuJtA4r5VG9gkLgJ+FEIxHWolo6K5IevuL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="372421538"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="372421538"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:30:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="774974858"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="774974858"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.251.5.115]) ([10.251.5.115])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:30:56 -0700
Message-ID: <d114ae48-8ba5-a639-f220-b60f2cac67d2@linux.intel.com>
Date:   Thu, 27 Oct 2022 05:30:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v6 19/21] x86/virt/tdx: Initialize all TDMRs
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
 <c78e41604f5c5274da3d5a9a01632abfad0926a5.1666824663.git.kai.huang@intel.com>
Content-Language: en-US
From:   Andi Kleen <ak@linux.intel.com>
In-Reply-To: <c78e41604f5c5274da3d5a9a01632abfad0926a5.1666824663.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> +		next = out.rdx;
> +		/* Allow scheduling when needed */
> +		if (need_resched())
> +			cond_resched();

cond_resched already includes the need_resched check. That is why it is 
called cond_


