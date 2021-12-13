Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B847847238A
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 10:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbhLMJLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 04:11:22 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:45377 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhLMJLW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 04:11:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1639386682; x=1670922682;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mr1cdeFFgl1+Te7iHmSGkTUoOQlnAx7Z10Ov9sGwMsc=;
  b=wXtFWxxCQOYQZeMWVDNZSufUvEaxgkty/NnHRrIvn90TEldyIIwywd45
   Sa0UUv849FnMWnPH35dJ8mltLp+/5N/jzD7dfW7EvMF20QJaaVwSYxa3W
   owRwNokvyjc/o82yiBM6p7ag1Lffq+nDlcVw9db090ySg5pbJ95TVcylp
   E=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 13 Dec 2021 01:11:21 -0800
X-QCInternal: smtphost
Received: from nasanex01b.na.qualcomm.com ([10.46.141.250])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 01:11:20 -0800
Received: from [10.216.8.35] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 13 Dec
 2021 01:11:16 -0800
Message-ID: <571def82-92c8-e7e5-74d6-4a7cfc225977@quicinc.com>
Date:   Mon, 13 Dec 2021 14:41:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v1.1 02/11] rcu: Kill rnp->ofl_seq and use only
 rcu_state.ofl_lock for exclusion
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <rcu@vger.kernel.org>, <mimoja@mimoja.de>,
        <hewenliang4@huawei.com>, <hushiyuan@huawei.com>,
        <luolongjun@huawei.com>, <hejingxian@huawei.com>
References: <20211209150938.3518-1-dwmw2@infradead.org>
 <20211209150938.3518-3-dwmw2@infradead.org>
 <dfa110f0-8fd0-0f37-2c37-89eccac1ad08@quicinc.com>
 <5b086c9e5a92bb91e6f4c086e6d01e380a7491af.camel@infradead.org>
 <b7f2bb55-4f0e-f52d-d41c-b591aa3927f2@quicinc.com>
 <1b4f10dd64e0288443fe7dbf706d5d5560cf98f4.camel@infradead.org>
From:   Neeraj Upadhyay <quic_neeraju@quicinc.com>
In-Reply-To: <1b4f10dd64e0288443fe7dbf706d5d5560cf98f4.camel@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/13/2021 2:27 PM, David Woodhouse wrote:
> On Fri, 2021-12-10 at 09:56 +0530, Neeraj Upadhyay wrote:
>>> -	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) || READ_ONCE(rnp->ofl_seq) & 0x1)
>>> +	/*
>>> +	 * Strictly, we care here about the case where the current CPU is
>>> +	 * in rcu_cpu_starting() and thus has an excuse for rdp->grpmask
>>> +	 * not being up to date. So arch_spin_is_locked() might have a
>>
>> Minor:
>>
>> Is this comment right - "thus has an excuse for rdp->grpmask not being
>> up to date"; shouldn't it be "thus has an excuse for rnp->qsmaskinitnext
>> not being up to date"?
>>
>> Also, arch_spin_is_locked() also handles the rcu_report_dead() case,
>> where raw_spin_unlock_irqrestore_rcu_node() can have a rcu_read_lock
>> from lockdep path with CPU bits already cleared from rnp->qsmaskinitnext?
> 
> Good point; thanks. How's this:
> 
> 	/*
> 	 * Strictly, we care here about the case where the current CPU is in
> 	 * rcu_cpu_starting() or rcu_report_dead() and thus has an excuse for
> 	 * rdp->qsmaskinitnext not being up to date. So arch_spin_is_locked()
> 	 * might have a false positive if it's held by some *other* CPU, but
> 	 * that's OK because that just means a false *negative* on the
> 	 * warning.
> 	 */
> 

Looks good to me!



>>>   	if (WARN_ON_ONCE(rnp->qsmask & mask)) { /* RCU waiting on incoming CPU? */
>>> +		/* rcu_report_qs_rnp() *really* wants some flags to restore */
>>> +		unsigned long flags2;
>>
>> Minor: checkpatch flags it "Missing a blank line after declarations"
> 
> Ack. Also fixed and pushed out to my parallel-5.16 branch at
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-5.16
> > This commit is probably the only one that's strictly needed for that
> parallel bringup, but for now I've kept my rcu boost thread mutex
> patch, and added your two patches (with minor whitespace fixes). I
> think the best option is to let Paul handle them all.
> 

Thanks; the 4 RCU specific patches in that tree looks good to me.


Thanks
Neeraj

> We'll do the final step of actually *enabling* the parallel bringup on
> any given architecture only after the various fixes have made their way
> in and we've done a proper review of the remaining code paths.
> 
> 
