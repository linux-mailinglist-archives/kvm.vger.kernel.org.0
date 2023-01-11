Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DFF66662F
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 23:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbjAKW30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 17:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbjAKW3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 17:29:23 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15495C76;
        Wed, 11 Jan 2023 14:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673476163; x=1705012163;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wmrOyLdnGpvX3W7qEBvMT2iinuJ0QOJuxzYc3KHYFLA=;
  b=S9fV4E5NHq7Qar5w8VqETovvmb06euDCRL7M2MEmk+pTDp86aOM/SVgZ
   IUtywjq1and9q2b3NnFJ3/x0Wf52BaMdVqEB0v/+ZqyAcQyGMmp5ZEvf5
   hXUOmXCgm7DLQS94/fbOG2uN7i2jp9XOdJ+glsMqMuAdXUT1KPblO748+
   QmVLujn4tbAOxe2J8Ohldkh8K8JV5xoiYGAzZoCwtSU8hL1cZ7m5YPN6n
   TtWICvH+OvhXsW82HeVD5RMktOedmMEc26cUvHj2oJwmwsiqERsDDKFet
   Sm82NFyzRYsYg1afJTbKCauzJZgmwb3ZMkdNemBdCL6U8k3EKS2ypzvOx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="303925138"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="303925138"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:29:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659542845"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="659542845"
Received: from pchoi7-mobl1.amr.corp.intel.com (HELO [10.212.194.225]) ([10.212.194.225])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:29:21 -0800
Message-ID: <74de50ac-6b10-a268-06f0-70a498e8b42d@intel.com>
Date:   Wed, 11 Jan 2023 14:29:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v6 6/7] x86/cpu: Support AMD Automatic IBRS
Content-Language: en-US
To:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230110224643.452273-1-kim.phillips@amd.com>
 <20230110224643.452273-8-kim.phillips@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230110224643.452273-8-kim.phillips@amd.com>
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

On 1/10/23 14:46, Kim Phillips wrote:
> The AMD Zen4 core supports a new feature called Automatic IBRS.
> 
> It is a "set-and-forget" feature that means that, like
> Intel's Enhanced IBRS, h/w manages its IBRS mitigation
> resources automatically across CPL transitions.

This looks a *LOT* better than what was here before.  Sharing the eibrs
boot options looks great.  Thanks,

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
