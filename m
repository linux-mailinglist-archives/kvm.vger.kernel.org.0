Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFE24EA18F
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 22:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344985AbiC1Ubo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 16:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344555AbiC1Ubm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 16:31:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18B6BC26;
        Mon, 28 Mar 2022 13:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648499401; x=1680035401;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KDJhS+gF41QpT4r+vh7URXlkO3BK6Mbi7mjFtJyx8Rs=;
  b=NDZS3v1EDr2pMKAr23h1xA/Wo60BR2lQjBoYuLDMERVyLssyOKPffD2l
   Skb4zfj3fBctyqdt/ZUwulc5/naiREyodMAC3wM6fZjlVjhY/YSJBKzbA
   iFO7TmNzsv69UGEKe2lfdp7p9teaq5x0cPlilmbWW+jCGkiQ7LDI40S25
   W/jLJXfWP+Rsnx20SF3NZzg3XDsfDenSyADztMkDvUav0NzeWCHWP9DJq
   0+UbVBjZCs8aPR4tWpwdGeev2rXj7xpTJrWsz0ucO5CNPAM+jx6hwfnSV
   tmGq2YwcBjBXy/u5dwWUPXPAKwKBbylKd1gCd/ZE/VLrcHG8hm+SZolAK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="345533272"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="345533272"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 13:30:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="832181780"
Received: from weiweihx-mobl.amr.corp.intel.com (HELO [10.255.229.113]) ([10.255.229.113])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 13:30:00 -0700
Message-ID: <60bf1aa7-b004-0ea7-7efc-37b4a1ea2461@intel.com>
Date:   Mon, 28 Mar 2022 13:30:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com
References: <cover.1647167475.git.kai.huang@intel.com>
 <98c1010509aa412e7f05b12187cacf40451d5246.1647167475.git.kai.huang@intel.com>
 <20220324174301.GA1212881@ls.amr.corp.intel.com>
 <f211441a6d23321e22517684159e2c28c8492b86.camel@intel.com>
 <20220328202225.GA1525925@ls.amr.corp.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220328202225.GA1525925@ls.amr.corp.intel.com>
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

On 3/28/22 13:22, Isaku Yamahata wrote:
>>>> +	/*
>>>> +	 * Also a sane BIOS should never generate invalid CMR(s) between
>>>> +	 * two valid CMRs.  Sanity check this and simply return error in
>>>> +	 * this case.
>>>> +	 */
>>>> +	for (j = i; j < cmr_num; j++)
>>>> +		if (cmr_valid(&cmr_array[j])) {
>>>> +			pr_err("Firmware bug: invalid CMR(s) among valid CMRs.\n");
>>>> +			return -EFAULT;
>>>> +		}
>>> This check doesn't make sense because above i-for loop has break.
>> The break in above i-for loop will hit at the first invalid CMR entry.  Yes "j =
>> i" will make double check on this invalid CMR entry, but it should have no
>> problem.  Or we can change to "j = i + 1" to skip the first invalid CMR entry.
>>
>> Does this make sense?
> It makes sense. Somehow I missed j = i. I scratch my review.

You can also take it as something you might want to refactor, add
comments, or work on better variable names.  If it confused one person,
it will confuse more in the future.
