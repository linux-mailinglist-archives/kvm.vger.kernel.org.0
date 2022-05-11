Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2256852287B
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 02:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbiEKA3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 20:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKA32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 20:29:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2A8266C83;
        Tue, 10 May 2022 17:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652228966; x=1683764966;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=XquAI6R0rBp2uUzOlsSUaevTUDwAMJvvtmnGX6BxntA=;
  b=NtZs38tOKjdlJavudVDCMVDFR6nJyx+Cwp4aBZAbYK6ja2+6MEei6J7J
   5kiINl89prKOBoskl6Ud5b8WnO/WD2HHyXUJBdtmroX7uhguxWCG+n4s5
   ilC7L1UvemtTAaIBWLf0amy9J5cLBqxp+/+ixJfAHz4heNQRzxqUxNnUk
   slFjB08evY78cX6h46YrYySn6KF1YOAwH8vjJGVKURagUu3adz6eJByHW
   J0ErEFoBErl9ypEZ/wvEWUMFHBrf+0ADHE2ShURYPMRG3uC4WTMDzD6WD
   n6tuCphAiDc61zNEH1GXVbiyNJ2Z5SaZI31i9YB/8TEucRynuEDfuIQH6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="330138791"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="330138791"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 17:29:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="657899611"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.171.95]) ([10.249.171.95])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 17:29:04 -0700
Message-ID: <f9d35ba0-7c35-bb89-0b39-d44821d65047@intel.com>
Date:   Wed, 11 May 2022 08:29:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 00/16] Introduce Architectural LBR for vPMU
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <27e36c48-8062-7a02-aca2-80f32f61ae75@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <27e36c48-8062-7a02-aca2-80f32f61ae75@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/10/2022 11:55 PM, Paolo Bonzini wrote:
> On 5/6/22 05:32, Yang Weijiang wrote:
>> [0] https://software.intel.com/sites/default/files/managed/c5/15/architecture-instruction-set-extensions-programming-reference.pdf
>> [1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/
>>
>> Qemu patch:
>> https://patchwork.ozlabs.org/project/qemu-devel/cover/20220215195258.29149-1-weijiang.yang@intel.com/
>>
>> Previous version:
>> v10: https://lore.kernel.org/all/20220422075509.353942-1-weijiang.yang@intel.com/
>>
>> Changes in v11:
>> 1. Moved MSR_ARCH_LBR_DEPTH/CTL check code to a unified function.[Kan]
>> 2. Modified some commit messages per Kan's feedback.
>> 3. Rebased the patch series to 5.18-rc5.
> Thanks, this is mostly okay; the only remaining issues are Kan's
> feedback and saving/restoring on SMM enter/exit.
Thanks Paolo, I'll fix Kan's feedback and the issue you mentioned in 
next version.
>
> The QEMU patches look good too.
>
> Paolo
