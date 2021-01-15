Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6752F7291
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 06:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732339AbhAOFrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 00:47:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:21743 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730518AbhAOFrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 00:47:46 -0500
IronPort-SDR: /1rWQ9QaU/gRue9608ApWD5cMi50+bg/LQdBZqkn9PJNYGiah5lpnMLIN/Yqr0qMBu438o68Dw
 WAJb49442BRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="158277119"
X-IronPort-AV: E=Sophos;i="5.79,348,1602572400"; 
   d="scan'208";a="158277119"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 21:46:00 -0800
IronPort-SDR: ajAZ0o7rz0TzeVNIP5DH1Rl0oIDoXqN8Cqxn5pIt/ffw0XW9RJXaNqtcIw8OP4YIToYyUv9TpE
 YnZMBlJv3l5g==
X-IronPort-AV: E=Sophos;i="5.79,348,1602572400"; 
   d="scan'208";a="382544785"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.130.147]) ([10.238.130.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 21:45:57 -0800
Subject: Re: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>, "bp@suse.de" <bp@suse.de>,
        "luto@kernel.org" <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-11-chang.seok.bae@intel.com>
 <BYAPR11MB3256BBBB24F9131D99CF7EF5A9AF0@BYAPR11MB3256.namprd11.prod.outlook.com>
 <29CB32F5-1E73-46D4-BF92-18AD05F53E8E@intel.com>
 <0361132a-c088-331b-de1f-e0de23d729ab@linux.intel.com>
 <BFF7E955-B3BB-45A2-8A01-00ED8971C8D7@intel.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <8178f22a-17bb-26c8-4a0b-4c459d5ef6bb@linux.intel.com>
Date:   Fri, 15 Jan 2021 13:45:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <BFF7E955-B3BB-45A2-8A01-00ED8971C8D7@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/15/2021 12:59 PM, Bae, Chang Seok wrote:
>> On Jan 11, 2021, at 18:52, Liu, Jing2 <jing2.liu@linux.intel.com> wrote:
>>
>> On 1/8/2021 2:40 AM, Bae, Chang Seok wrote:
>>>> On Jan 7, 2021, at 17:41, Liu, Jing2 <jing2.liu@intel.com> wrote:
>>>>
>>>> static void kvm_save_current_fpu(struct fpu *fpu)  {
>>>> +	struct fpu *src_fpu = &current->thread.fpu;
>>>> +
>>>> 	/*
>>>> 	 * If the target FPU state is not resident in the CPU registers, just
>>>> 	 * memcpy() from current, else save CPU state directly to the target.
>>>> 	 */
>>>> -	if (test_thread_flag(TIF_NEED_FPU_LOAD))
>>>> -		memcpy(&fpu->state, &current->thread.fpu.state,
>>>> +	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
>>>> +		memcpy(&fpu->state, &src_fpu->state,
>>>> 		       fpu_kernel_xstate_min_size);
> <snip>
>
>>>> -	else
>>>> +	} else {
>>>> +		if (fpu->state_mask != src_fpu->state_mask)
>>>> +			fpu->state_mask = src_fpu->state_mask;
>>>>
>>>> Though dynamic feature is not supported in kvm now, this function still need
>>>> consider more things for fpu->state_mask.
>>> Can you elaborate this? Which path might be affected by fpu->state_mask
>>> without dynamic state supported in KVM?
>>>
>>>> I suggest that we can set it before if...else (for both cases) and not change other.
>>> I tried a minimum change here.  The fpu->state_mask value does not impact the
>>> memcpy(). So, why do we need to change it for both?
>> Sure, what I'm considering is that "mask" is the first time introduced into "fpu",
>> representing the usage, so not only set it when needed, but also make it as a
>> representation, in case of anywhere using it (especially between the interval
>> of this series and kvm series in future).
> Thank you for the feedback. Sorry, I don't get any logical reason to set the
> mask always here.

Sure, I'd like to see if fx_init()->memset is the case,

though maybe no hurt so far in test.

Thanks,

Jing

>   Perhaps, KVM code can be updated like you mentioned when
> supporting the dynamic states there.
>
> Please let me know if I’m missing any functional issues.
>
> Thanks,
> Chang
