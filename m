Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908E15AB562
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiIBPjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236633AbiIBPi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:38:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6851BE0FFE;
        Fri,  2 Sep 2022 08:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662132346; x=1693668346;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WkkhMq7jUWQDxjct1eMk17xBl5izK88Vwv+Go0eqOMw=;
  b=jRLbk8LS8vs1mCFlWkwctJj5KNT1MhDJJqPVDTvnsChb5k3aB7/17C3v
   DFkHtVaHOM4HSVbTHQrkTWM77mlRlBjk1b/Vl79wUdvtOEDUzgjy/gxUf
   CFH1OvaeXrq+6dN8Oj5scsnBQv8VpTe2OTxoQUWNDbRQG5Wh/Vz/FtPu2
   XNpZKIjguSTzBO8+a5FOjT8xmFQhXHJR3RUTp9Dgx57C1Xk+pwdmd4evG
   +zF9w194GlEn8IjlKuBz3FCm+Gwfmlg2Iqs5JQk8LxdtSXj6UjesPsxgf
   7oykpm/dGDopJhjIzm7oNqFNYNYjZkTDs8afRxQ/lcpBb6KU08BAQToSE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="296782558"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="296782558"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 08:25:45 -0700
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="642942553"
Received: from tanjeffr-mobl1.amr.corp.intel.com (HELO [10.212.156.60]) ([10.212.156.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 08:25:44 -0700
Message-ID: <5d667258-b58b-3d28-3609-e7914c99b31b@intel.com>
Date:   Fri, 2 Sep 2022 08:25:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SVM: Replace kmap_atomic() with kmap_local_page()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Zhao Liu <zhao1.liu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
References: <20220902090811.2430228-1-zhao1.liu@linux.intel.com>
 <YxId/V1qZcie9eyp@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <YxId/V1qZcie9eyp@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/22 08:15, Sean Christopherson wrote:
>>  	for (i = 0; i < npages; i++) {
>> -		page_virtual = kmap_atomic(pages[i]);
>> +		page_virtual = kmap_local_page(pages[i]);
>>  		clflush_cache_range(page_virtual, PAGE_SIZE);
> SEV is 64-bit only, any reason not to go straight to page_address()?

Yes.  page_address() is a hack.  People get away with using it, but they
really shouldn't, especially when it is used on pages you didn't
allocate yourself.

IOW:

	page = alloc_page(GFP_KERNEL);
	ptr = page_address(page);

is fine.  But:

	page = alloc_page(GFP_HIGHUSER);
	ptr = page_address(page);

even on something that's Kconfig'd 64-bit only is a no-no in my book.
The same goes for a generic-looking function like sev_clflush_pages()
where the pages come from who-knows-where.

It's incredibly useful for kernel accesses to random pages to be bounded
explicitly.  Keeping the kmap() *API* in place means it can be used for
things other than highmem mappings (like protection keys).  The kmap*()
family is a pretty thin wrapper around page_address() on 64-bit most of
the time anyway.

