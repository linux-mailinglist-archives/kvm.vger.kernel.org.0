Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282CC6A77D9
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 00:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCAXnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 18:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjCAXnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 18:43:12 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256D85679B;
        Wed,  1 Mar 2023 15:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677714150; x=1709250150;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+dcuSCOUvlfWlgKnuNOG5M7WjDU7LQAEWia+60P3lYo=;
  b=UfAg53aLUP/KX3uBQjFk0Nb8xVDth4xaQTBP4x1SiDyMzjhBok9aMg+E
   +wQYDPpzDRl38wZCaoyQatPkdTFYnigSw2QnkmLCWc87hs6lOI9gEiLjJ
   gVxnQKqLyLxW57WaFnHWipk8eUctbzHdBwgNxaqt1paTUcVNg9ufRjFFB
   zdTyXTv2OKXBQYt4BPjBYDKJsE130rwlfbipJvNNkNlg5+YNZmB5u/VMy
   euc53EHYo89y7SQFknBpLfc+MJuUI3ZKxSQt3+QgPDYAisNKnYLF7tes3
   PDLFtricu8H2Mhq3fDSbUUJ8pJiSzx+q6ByjusA9YUKsKSfBtWLzn/qVt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420819149"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="420819149"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 15:39:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="738827318"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="738827318"
Received: from asaha3-mobl1.amr.corp.intel.com (HELO [10.251.12.67]) ([10.251.12.67])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 15:39:21 -0800
Message-ID: <4c34773e-31e9-927f-c593-30bbe3b75fd7@intel.com>
Date:   Wed, 1 Mar 2023 15:39:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC v8 00/56] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com
References: <20230220183847.59159-1-michael.roth@amd.com>
 <f2c904f6-996a-e903-5d56-662781567578@intel.com>
 <20230302005943.00001a8e@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230302005943.00001a8e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/23 14:59, Zhi Wang wrote:
> When the userspace sets the memory attribute of a GFN range through the
> restricted memory ioctl, the sev logic (sev_update_mem_attr() in PATCH 48, to
> be precise) will try to build a large page description in the RMP table if the
> PFNs are continuous. When kernel mm breaks the the large page due to THP, KVM
> updates the NPT accordingly.

Gah, this really confused me.

It's *NOT* looking for contiguous PFNs.  It's looking for a
restrictedmem THP, which really is something different.  Restrictedmem
THPs have contiguous PFNs, but not all contiguous PFNs will result in
trying to build a large page.

Anyway, I'll reply over to the other patch.

But, either way, I'd appreciate this kind of summary in the changelogs
and probably a comment or two:

	The RMP needs to be consistent with the contents of the NPT.
	KVM updates the NPT but will neglect to update the RMP.  It is
	updated in response to faults when RMP and NPT get out of sync.

Right?

BTW, why doesn't KVM just update the RMP?  Why bother taking the fault?
