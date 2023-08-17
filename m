Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24B177F3E1
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 11:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349801AbjHQJvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 05:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349922AbjHQJvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 05:51:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31FA30C0;
        Thu, 17 Aug 2023 02:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692265891; x=1723801891;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x41+p5iSR+Db0tQz1saTh0dkmfqKgPB877FnWMCiyzo=;
  b=Ya9jp9Wpd8+XqpOFiD1zqw0g8WY9GtxqRJJ43NNrUzsdyYL9S6jj1gKF
   VK9JOsWOOABG6jQ4vmYaDJd68Enb5Xmg5FcnG/Ql0zTDanu4ZneM0m/Iw
   lI1Y9iHlcLIKYpKQYvNLfUi2boypApdPtnrv3zNwI3aDsEM+oezc0NOTQ
   Iy9fRXa6K0EE5O4fcgBlozxKU2Np5bofy8M8znzmHxc9pdcPtiU9We++P
   KZKETWXaE/ei8PzTXr023ffgZQP4KwhfZ+oPUYUkRCtczrEpUKQxVV08J
   1dwsQdxSSyby5hty9uHvRJhJMQ5Xk9xEufW4CObToOV0AW7iESQFy00kc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="357729797"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="357729797"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 02:51:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="981089463"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="981089463"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 02:51:29 -0700
Message-ID: <e4785596-f55c-edfb-89db-9d3ec12c4429@linux.intel.com>
Date:   Thu, 17 Aug 2023 17:51:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 7/9] KVM: VMX: Implement and wire get_untagged_addr()
 for LAM
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-8-binbin.wu@linux.intel.com>
 <ZN1HT61WM0Pmxqmr@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZN1HT61WM0Pmxqmr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/17/2023 6:01 AM, Sean Christopherson wrote:
> On Wed, Jul 19, 2023, Binbin Wu wrote:
>> +	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_ULL(63));
> Almost forgot.  Please add a comment explaning how LAM untags the address,
> specifically the whole bit 63 preservation.  The logic is actually straightforward,
> but the above looks way more complex than it actually is.  This?
>
> 	/*
> 	 * Untag the address by sign-extending the LAM bit, but NOT to bit 63.
> 	 * Bit 63 is retained from the raw virtual address so that untagging
> 	 * doesn't change a user access to a supervisor access, and vice versa.
> 	 */
OK.

Besides it, I find I forgot adding the comments for the function. I will 
add it back if you don't object.

+/*
+ * Only called in 64-bit mode.
+ *
+ * LAM has a modified canonical check when applicable:
+ * LAM_S48                : [ 1 ][ metadata ][ 1 ]
+ *                            63               47
+ * LAM_U48                : [ 0 ][ metadata ][ 0 ]
+ *                            63               47
+ * LAM_S57                : [ 1 ][ metadata ][ 1 ]
+ *                            63               56
+ * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
+ *                            63               56
+ * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
+ *                            63               56..47
+ *
+ * Note that KVM masks the metadata in addresses, performs the (original)
+ * canonicality checking and then walks page table. This is slightly
+ * different from hardware behavior but achieves the same effect.
+ * Specifically, if LAM is enabled, the processor performs a modified
+ * canonicality checking where the metadata are ignored instead of
+ * masked. After the modified canonicality checking, the processor masks
+ * the metadata before passing addresses for paging translation.
+ */
