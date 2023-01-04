Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2595865CC3F
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 04:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbjADD6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 22:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjADD6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 22:58:44 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7AE15725;
        Tue,  3 Jan 2023 19:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672804723; x=1704340723;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gqVwrNz+IXngJzcUQgNb7Bi5jWHHCfdbbMv4DE6dUwY=;
  b=drZFgwg6uEFtjxRnXJthl0OOfRJhGUMcWP3+sa7V6oBBwNohe8Hn/14b
   DbaRD3K8SBE4zX/kwwGxLfIpKZVm8Lp/jbdrsdqpCuguL6HGHDN19ON3+
   l+2SZDut9Zbre45epUHIoj2g/bt/1Vs+QxElY+Pgwkga6x1o3P+CZXgGX
   DcC4Qc/qZEv0nda/3XyrHFpEQUdy5T1u1ydkE9nrxfWafsnmpD3xuWxJ8
   exbJOJxtYqZ2JR2pzShwdYfxUfQr2eYY6fR9c3vcM/Q4BeNYNr5eKZm/C
   FAKQ98fXFDyzj9G3I2YPeHJr1bli/+MUH1WtNck6mtDNcUd1bNbk9U68T
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="305328619"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="305328619"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 19:58:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="605052443"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="605052443"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.214.111]) ([10.254.214.111])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 19:58:40 -0800
Message-ID: <6351a1fd-ba60-7e9b-64b3-63b96e16607f@intel.com>
Date:   Wed, 4 Jan 2023 11:58:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/30/2022 2:22 PM, isaku.yamahata@intel.com wrote:> +static void
vt_hardware_unsetup(void)
> +{
> +	tdx_hardware_unsetup();
> +	vmx_hardware_unsetup();
> +}
> +
>  static int vt_vm_init(struct kvm *kvm)
>  {
>  	if (is_td(kvm))
> -		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
> +		return tdx_vm_init(kvm);
>  
>  	return vmx_vm_init(kvm);
>  }
>  
> +static void vt_flush_shadow_all_private(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return tdx_mmu_release_hkid(kvm);
> +}

nit: there is no need to use the "return" keyword.

> +
> +static void vt_vm_destroy(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return;
> +
> +	vmx_vm_destroy(kvm);
> +}
> +
> +static void vt_vm_free(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return tdx_vm_free(kvm);
> +}

ditto.
