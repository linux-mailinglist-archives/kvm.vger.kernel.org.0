Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C755ED26E
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 03:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiI1BGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 21:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiI1BGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 21:06:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A604AD9B7
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 18:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664327169; x=1695863169;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JCh9LK4k+nOzfu32B9UOCi7FRk87mpGfi/GAGo9EwdY=;
  b=E97KmCZrMN1NQH2fTJscESOP6whf2blalggtCyl8HeweavJ1eJ6WUlLE
   ULBen/afhUP85K/+67CpgIa344N34gZz/8iaFUeTzqHpXk8/wIRTWJxbl
   1YkwJbeiqjUBIesPo7UwLcKOFzUM43TBJd3XF0esxpmfdzVehEkAPEXYK
   Wt2sK9FgkN56GkJuo8m3RcElcD/KGQZshLIKNENu9pq1rbtDC2fhUNBqR
   QGCCQTdUMN4fjER1LICXCl18d750erZl9RATN7gXql3GnS+wELCSluZoH
   D8ZgzEzMXau7GTKG1b9N5xk6HpdlhJC7O3oL3UF5/n6VHxsWrfwQzX18q
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="281191357"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="281191357"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 18:06:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="950499845"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="950499845"
Received: from zhaoq1-mobl.ccr.corp.intel.com (HELO [10.255.29.135]) ([10.255.29.135])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 18:06:06 -0700
Message-ID: <01bc053e-2809-c585-ef75-3b9acdd09974@intel.com>
Date:   Wed, 28 Sep 2022 09:06:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH v7 1/2] i386: kvm: extend kvm_{get, put}_vcpu_events to
 support pending triple fault
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220923073333.23381-1-chenyi.qiang@intel.com>
 <20220923073333.23381-2-chenyi.qiang@intel.com>
 <c773b5aa-19b0-20de-5818-67360307abd9@redhat.com>
Content-Language: en-US
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <c773b5aa-19b0-20de-5818-67360307abd9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/27/2022 9:14 PM, Paolo Bonzini wrote:
> On 9/23/22 09:33, Chenyi Qiang wrote:
>> For the direct triple faults, i.e. hardware detected and KVM morphed
>> to VM-Exit, KVM will never lose them. But for triple faults sythesized
>> by KVM, e.g. the RSM path, if KVM exits to userspace before the request
>> is serviced, userspace could migrate the VM and lose the triple fault.
>>
>> A new flag KVM_VCPUEVENT_VALID_TRIPLE_FAULT is defined to signal that
>> the event.triple_fault_pending field contains a valid state if the
>> KVM_CAP_X86_TRIPLE_FAULT_EVENT capability is enabled.
> 
> Note that you are not transmitting the field on migration.  You need
> this on top:
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index b97d182e28..d4124973ce 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1739,7 +1739,7 @@ typedef struct CPUArchState {
>       uint8_t has_error_code;
>       uint8_t exception_has_payload;
>       uint64_t exception_payload;
> -    bool triple_fault_pending;
> +    uint8_t triple_fault_pending;
>       uint32_t ins_len;
>       uint32_t sipi_vector;
>       bool tsc_valid;
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index cecd476e98..310b125235 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -1562,6 +1562,25 @@ static const VMStateDescription vmstate_arch_lbr = {
>       }
>   };
> 
> +static bool triple_fault_needed(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +
> +    return env->triple_fault_pending;
> +}
> +
> +static const VMStateDescription vmstate_triple_fault = {
> +    .name = "cpu/triple_fault",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = triple_fault_needed,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT8(env.triple_fault_pending, X86CPU),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>   const VMStateDescription vmstate_x86_cpu = {
>       .name = "cpu",
>       .version_id = 12,
> @@ -1706,6 +1725,7 @@ const VMStateDescription vmstate_x86_cpu = {
>           &vmstate_amx_xtile,
>   #endif
>           &vmstate_arch_lbr,
> +        &vmstate_triple_fault,
>           NULL
>       }
>   };

Thanks Paolo for your review!

I'll add this in next version.

> 
