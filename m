Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20888636E81
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 00:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiKWXkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 18:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiKWXkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 18:40:42 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF84D5382;
        Wed, 23 Nov 2022 15:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669246841; x=1700782841;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mcBURe4LzeYETeIQLGl6OG0wtQiOP6b+ev/9eJ+l754=;
  b=c2kEbEV7Arvh4yMfn2L1py6/FWkQiReOOvaHbW0ARaveKRZSXkEZQOJN
   8IlwHxVJD3+jHlq6QObj2EfFWPSc9yo/ZkvFpICQvztFrc31OubBB+v+T
   nngz/WfSkahC4m0aYCj86S8klSGSuLRDiI1vMulym+zKFwu+/iV7rd4oT
   8gRfBaSoNZLZu39bTP9RzBN26nj8yUZF1KWjDxeQ8n0jaYLYXU8k/hd2k
   i66O/qFhOmHNheJDLA13uszQU0qvol+DeBCIwDI1hastYdmyEE3Rqqj6C
   2OKeiVImOq2TfMRRRFdmzY9HQ/V4NTqxAxv86NibrcmZWjkiDWOznNpnA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="312879479"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="312879479"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:40:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="766893492"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="766893492"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:40:39 -0800
Message-ID: <9c36d878-db83-5c0e-90f3-8f19dd25801c@intel.com>
Date:   Wed, 23 Nov 2022 15:40:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 15/20] x86/virt/tdx: Reserve TDX module global KeyID
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <fec007c0193e5f0509450de78052346da1045b23.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <fec007c0193e5f0509450de78052346da1045b23.1668988357.git.kai.huang@intel.com>
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

On 11/20/22 16:26, Kai Huang wrote:
> @@ -1053,6 +1056,12 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_free_tdmrs;
>  
> +	/*
> +	 * Reserve the first TDX KeyID as global KeyID to protect
> +	 * TDX module metadata.
> +	 */
> +	tdx_global_keyid = tdx_keyid_start;

This doesn't "reserve" squat.

You could argue that it "picks", "chooses", or "designates" the
'tdx_global_keyid', but where is the "reservation"?
