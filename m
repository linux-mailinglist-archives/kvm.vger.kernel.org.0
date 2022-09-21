Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A905BF41B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiIUDI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiIUDIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:08:04 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCC77E02B
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663729664; x=1695265664;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IDL8vZTnp35Mro2Bd4eUR+qgMw9RrBkY3Hr4UHQU88A=;
  b=YQl0Uvn+a76N/hmGz94sxGnnDXjDs+wstJAr0tE9ReJdOF3/NgtQ4r1S
   bJB4U0Sh/zlOPy0TSnD1sg9whLnBr4pWK/WHaCy4j/gQNEiINCvTfV/xf
   6+cewVxuD05Nv8vCLsH0uQic8k0EGHDFNcStGQmlK6edCWS2I2CdJjVcJ
   45fBGtaZ3LdWEaB05yu/awPk1/2h4NCrhwujKzgYFRn6PQb58gYXpITay
   sKRXk5oo7pcGB8yT91tBy11pM4cdCnDXYpyZg0ikydlAcgDSXWCW1aM74
   dyIeLQ83acpHtX7jpJbKkmc2TvwZ/NN/igqVMQfA+fSvyRUQCfSQKtA10
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="297480143"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="297480143"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 20:07:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="708258326"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.0.135]) ([10.238.0.135])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 20:07:42 -0700
Message-ID: <38a4d1c0-25e6-0836-c2bc-5ae580c95715@intel.com>
Date:   Wed, 21 Sep 2022 11:07:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH v6 2/2] i386: Add notify VM exit support
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20220915092839.5518-1-chenyi.qiang@intel.com>
 <20220915092839.5518-3-chenyi.qiang@intel.com> <YyTxL7kstA20tB5a@xz-m1.local>
 <5beb9f1c-a419-94f7-a1b9-4aeb281baa41@intel.com>
 <YyiQeD9QmJ9/eS9F@xz-m1.local>
 <ee855874-bb8b-3f43-cffe-425700b26918@intel.com>
 <YynHXI+Vtrf9J/Ae@xz-m1.local>
Content-Language: en-US
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YynHXI+Vtrf9J/Ae@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/20/2022 9:59 PM, Peter Xu wrote:
> On Tue, Sep 20, 2022 at 01:55:20PM +0800, Chenyi Qiang wrote:
>>>> @@ -5213,6 +5213,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run
>>>> *run)
>>>>            break;
>>>>        case KVM_EXIT_NOTIFY:
>>>>            ret = 0;
>>>> +        warn_report_once("KVM: notify window was exceeded in guest");
>>>
>>> Is there more informative way to dump this?  If it's 99% that the guest was
>>> doing something weird and needs attention, maybe worthwhile to point that
>>> out directly to the admin?
>>>
>>
>> Do you mean to use other method to dump the info? i.e. printing a message is
>> not so clear. Or the output message ("KVM: notify window was exceeded in
>> guest") is not obvious and we need other wording.
> 
> I meant something like:
> 
>    KVM received notify exit.  It means there can be possible misbehaves in
>    the guest, please have a look.

Get your point. Then I can print this message behind as well.

Thanks.

> 
> Or something similar.  What I'm worried is the admin may not understand
> what's "notify window" and that message got simply ignored.
> 
> Though I am not even sure whether that's accurate in the wordings.
> 
>>
>>>>            if (run->notify.flags & KVM_NOTIFY_CONTEXT_INVALID) {
>>>>                warn_report("KVM: invalid context due to notify vmexit");
>>>>                if (has_triple_fault_event) {
>>>
>>> Adding a warning looks good to me, with that (or in any better form of
>>> wording):
>>>
>> If no objection, I'll follow Xiaoyao's suggestion to form the wording like:
> 
> No objection here.  Thanks.
> 
