Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558514F019C
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 14:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354742AbiDBMt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 08:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344635AbiDBMt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 08:49:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CD03AA69;
        Sat,  2 Apr 2022 05:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648903655; x=1680439655;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VBH8DaxfPRE0Sm3wGsVRsa5H0Vj+YGtrUbWzbb7wQHI=;
  b=bk0HoOPNIW0pRWX21x6g/RvBFo8Jbi7fND6w/Q3hU3ompAe46hij8WJQ
   g+LTAJP/jg8HTUbJ8yR/E9FFLf0bfYVDb9C2QodJFoEsbzdpVB/bzIEbX
   MPk61Dx+wwAkh3TFdvMptTcMYyyUQeYcf+QYaz08X8HB5WhlJnm99RN4Z
   PWqMzXYXbj/PkdqNXnTSvimY1Ota3F0xQRtiTx64fptCO14LVyzl/olHH
   y+xUoL8RSTaceiECob/bu6X9Rst72XZiFRwZyem6QqGH53GNQjicZLxPV
   oNQC2odw7I1SZzUcYMbuElgGkvdEhZDCQdjWQ8FVRZRabcSWAGhL9fIXx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="285237935"
X-IronPort-AV: E=Sophos;i="5.90,230,1643702400"; 
   d="scan'208";a="285237935"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2022 05:47:35 -0700
X-IronPort-AV: E=Sophos;i="5.90,230,1643702400"; 
   d="scan'208";a="548131492"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.254.208.38]) ([10.254.208.38])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2022 05:47:29 -0700
Message-ID: <23fbc97f-05e9-2609-46cc-4320ddc9df12@intel.com>
Date:   Sat, 2 Apr 2022 20:47:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 2/8] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to
 support 64-bit variation
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-3-guang.zeng@intel.com> <YkYquqLOduNlQntZ@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YkYquqLOduNlQntZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/1/2022 6:27 AM, Sean Christopherson wrote:
> On Fri, Mar 04, 2022, Zeng Guang wrote:
>> +#define BUILD_CONTROLS_SHADOW(lname, uname, bits)			\
>> +static inline								\
>> +void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)		\
>> +{									\
>> +	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		\
>> +		vmcs_write##bits(uname, val);				\
>> +		vmx->loaded_vmcs->controls_shadow.lname = val;		\
>> +	}								\
>> +}									\
>> +static inline u##bits __##lname##_controls_get(struct loaded_vmcs *vmcs)\
>> +{									\
>> +	return vmcs->controls_shadow.lname;				\
>> +}									\
>> +static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	\
>> +{									\
>> +	return __##lname##_controls_get(vmx->loaded_vmcs);		\
>> +}									\
>> +static inline								\
> Drop the newline, there's no need to split this across two lines.  Aligning the
> backslashes will mean they all poke past the 80 char soft limit, but that's totally
> ok.  The whole point of the line limit is to improve readability, and a trivial
> runover is much less painful than a split function declaration.  As a bonus, all
> the backslashes are aligned, have leading whitespace, and still land on a tab stop :-)
>
> #define BUILD_CONTROLS_SHADOW(lname, uname, bits)				\
> static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)	\
> {										\
> 	if (vmx->loaded_vmcs->controls_shadow.lname != val) {			\
> 		vmcs_write##bits(uname, val);					\
> 		vmx->loaded_vmcs->controls_shadow.lname = val;			\
> 	}									\
> }										\
> static inline u##bits __##lname##_controls_get(struct loaded_vmcs *vmcs)	\
> {										\
> 	return vmcs->controls_shadow.lname;					\
> }										\
> static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		\
> {										\
> 	return __##lname##_controls_get(vmx->loaded_vmcs);			\
> }										\
> static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
> {										\
> 	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);		\
> }										\
> static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
> {										\
> 	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);		\
> }
>
> With that fixed,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

OK. I'll revise it.

