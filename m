Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534E95AB52D
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbiIBPae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiIBPaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:30:07 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE09D346B;
        Fri,  2 Sep 2022 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662131371; x=1693667371;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6wbQJaovjWSecMUq+Mtuf5ZeCJqt9CRGZgfkgAn0Lnw=;
  b=nhwHj75nKiGKgmHeG6Q9w+oSVZboCnnlfDxR/mfZWncea8Tm6PaZJ9NT
   k6ZdZbITw1Onz36JDokmJ8frVC5CjoZaAAA1oLmU5tUqJYoLS7hhCZOBy
   klfjZ2iuLSG8qdEcF9r3R3xY/skt1uIrfWRc4qO4o8G8ovE/hEbDTp1y9
   TWEPMHLijuT1DbxVa1BWA2J7Qm6LBFIZ1zgLzRE2MY/oj5XNvTRx89vQe
   GKb874XjcT6VKRbsNTsW7hq9i5PdrDmpaMhkKipPwb5lH9l56qt7PMD9t
   lMf42XSzpBHflsacW81VV4jUl/LIXO7rMtbwnEGx0CrGPY3hFRT9gkula
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="357715435"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="357715435"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 08:09:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="642937673"
Received: from tanjeffr-mobl1.amr.corp.intel.com (HELO [10.212.156.60]) ([10.212.156.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 08:09:30 -0700
Message-ID: <e08c8c46-2aa8-3cb4-dce6-61d64c6835cb@intel.com>
Date:   Fri, 2 Sep 2022 08:09:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SVM: Replace kmap_atomic() with kmap_local_page()
Content-Language: en-US
To:     Zhao Liu <zhao1.liu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
References: <20220902090811.2430228-1-zhao1.liu@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220902090811.2430228-1-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/22 02:08, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> The use of kmap_atomic() is being deprecated in favor of
> kmap_local_page()[1].
> 
> In arch/x86/kvm/svm/sev.c, the function sev_clflush_pages() doesn't
> need to disable pagefaults and preemption in kmap_atomic(). It can
> simply use kmap_local_page() / kunmap_local() that can instead do the
> mapping / unmapping regardless of the context.
> 
> With kmap_local_page(), the mapping is per thread, CPU local and not
> globally visible. Therefore, sev_clflush_pages() is a function where
> the use of kmap_local_page() in place of kmap_atomic() is correctly
> suited.

This changelog is a little on the weak side.  You could literally take
any arbitrary call-site and file for kmap_atomic() and slap that
changelog on it.  For instance:

	In drivers/target/target_core_sbc.c, the function
	sbc_dif_copy_prot() doesn't need to disable pagefaults and
	preemption in kmap_atomic(). It can simply use kmap_local_page()
	/ kunmap_local() that can instead do the mapping / unmapping
	regardless of the context.

	With kmap_local_page(), the mapping is per thread, CPU local and
	not globally visible. Therefore, sbc_dif_copy_prot() is a
	function where the use of kmap_local_page() in place of
	kmap_atomic() is correctly suited.

That's all valid English and there's nothing incorrect in it.  But, it
doesn't indicate that any actual analysis was performed.  It's utterly
generic.  It could literally have been generated by a pretty trivial script.

It would be great to add at least a small, call-site-specific human
touch to these changelogs.

In this case, saying something about how global the cache flush is would
be a great addition.
