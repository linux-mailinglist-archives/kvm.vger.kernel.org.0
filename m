Return-Path: <kvm+bounces-9172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5547285B9EA
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:07:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 874311C21AE6
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 11:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0AE65BDC;
	Tue, 20 Feb 2024 11:07:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDBB65BA3
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 11:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708427253; cv=none; b=cIH/oDHvly775EgaBfVaic5fz8kuWXIdu5XTO0ukBttizT+jiVodBk8eeYLmZwbmwiSErLExTo5AH33NW3x1U9uDdeNOryo2h2EGo/5An2GKU/kfg2oWgo31UFKIzxNHyR6SLuK6W+c2+5YiuwU2OD+Vpx+sRxqW9en0fRiKCM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708427253; c=relaxed/simple;
	bh=eWmGaeGmcf4G6nxYbfxSfi9gPpNW+bB64piUGc9lOG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UBgOd4sKGNTzh8kLGVOIYfv/DLZ9+tmYjtSR9jCn5/f+QiAlpt57ejBvTE/Vboa1GcnjmgFTjs4ANqkHfNj2xK6O2KZprXvwZDXmQo3wkvLBwMcTsU6cciZMt30JZas6wlqG1v8xvaSgn81VbjAtmouJ2+xiTZ+USyHqliOHTWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1708427239-086e230f26450e0001-HEqcsx
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx1.zhaoxin.com with ESMTP id olYjBohoW5DXAHBJ (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 20 Feb 2024 19:07:19 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 20 Feb
 2024 19:07:19 +0800
Received: from [10.28.66.62] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 20 Feb
 2024 19:07:18 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Message-ID: <3cf7eac6-0a95-46dd-81b0-0ac12735349b@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.28.66.62
Date: Tue, 20 Feb 2024 06:07:06 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
To: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<mtosatti@redhat.com>, <kvm@vger.kernel.org>, <zhao1.liu@intel.com>
X-ASG-Orig-Subj: Re: [PATCH v2] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
CC: <qemu-devel@nongnu.org>, <cobechen@zhaoxin.com>, <ewanhai@zhaoxin.com>
References: <20231127034326.257596-1-ewanhai-oc@zhaoxin.com>
 <b041fdb3-5b08-4a85-913a-ebb3c7dfbe1d@intel.com>
Content-Language: en-US
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <b041fdb3-5b08-4a85-913a-ebb3c7dfbe1d@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1708427239
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1867
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.121088
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



On 2/20/24 03:32, Xiaoyao Li wrote:
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 11b8177eff..c8f6c0b531 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -2296,6 +2296,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
>>   static int kvm_get_supported_feature_msrs(KVMState *s)
>>   {
>>       int ret = 0;
>> +    int i;
>>
>>       if (kvm_feature_msrs != NULL) {
>>           return 0;
>> @@ -2330,6 +2331,19 @@ static int 
>> kvm_get_supported_feature_msrs(KVMState *s)
>>           return ret;
>>       }
>>
>> +    /*
>> +     * Compatibility fix:
>> +     * Older Linux kernels(<5.3) include the 
>> MSR_IA32_VMX_PROCBASED_CTLS2
>
> we can be more accurate, that kernel version 4.17 to 5.2, reports
> MSR_IA32_VMX_PROCBASED_CTLS2 in KVM_GET_MSR_FEATURE_INDEX_LIST but not
> KVM_GET_MSR_INDEX_LIST.
>
Yeah, I'll add this more precise comment to the next patch.
>> +     * only in feature msr list, but not in regular msr list. This 
>> lead to
>> +     * an issue in older kernel versions where QEMU, through the 
>> regular
>> +     * MSR list check, assumes the kernel doesn't maintain this msr,
>> +     * resulting in incorrect settings by QEMU for this msr.
>> +     */
>> +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
>> +        if (kvm_feature_msrs->indices[i] == 
>> MSR_IA32_VMX_PROCBASED_CTLS2) {
>> +            has_msr_vmx_procbased_ctls2 = true;
>> +        }
>> +    }
>
> I'm wondering should we move all the initialization of has_msr_*, that
> associated with feature MSRs, to here. e.g., has_msr_arch_capabs,
> has_msr_vmx_vmfunc,...
>
I believe this is a more elegant way to fix the issue, which will be 
reflected in my next patch.



