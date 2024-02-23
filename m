Return-Path: <kvm+bounces-9477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF46A860940
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 04:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B771B23BE3
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 03:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 101A6C8DD;
	Fri, 23 Feb 2024 03:13:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33684B67F
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 03:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.110.167.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708657997; cv=none; b=kkbXjopXVdShFgD6alC8IMytGbrOWykjicwmjHJzuNb90y8mv2Bv/t/tM8Kwnd+ed2pw1oshynrTJvXV9jDII5Z54IWMBtJytYUazAfBcM8UFMLdm29IJXbtWA5rKMnDJ+1eQky+a0ey5cKBAZx3GdLDqM9Bsj6KJ4Qn9fumTi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708657997; c=relaxed/simple;
	bh=xy1NIOleVVNZ5IfskXEX5ke9LM0Im+JhdEoL9vJuU7A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=WFduvWzbEilNwefgC/8ayL3rD0b7NGh0D/KJNCuUmjr54hmbUyJMOC8Vf8+L3+rpfCvgo4tEIwctmk5JsuNtl43zvBiLm+I0WM8B9W3lRJxWAq4iI3mKMtJuoueDV81pjR3xBOYG4bC83UiAuXXFI+KXg1EvHGxvMyHo812ViaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=203.110.167.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1708657989-1eb14e0c7e46ae0001-HEqcsx
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx2.zhaoxin.com with ESMTP id G3D2oEORI4UkFBrN (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 23 Feb 2024 11:13:09 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 23 Feb
 2024 11:13:09 +0800
Received: from [10.28.66.62] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 23 Feb
 2024 11:13:08 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Message-ID: <c6e96802-4f68-4ba2-aa24-0a68ca412024@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.28.66.62
Date: Thu, 22 Feb 2024 22:13:07 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
X-ASG-Orig-Subj: Re: [PATCH v2] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
To: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<mtosatti@redhat.com>, <kvm@vger.kernel.org>, <zhao1.liu@intel.com>
CC: <qemu-devel@nongnu.org>, <cobechen@zhaoxin.com>, <ewanhai@zhaoxin.com>
References: <20231127034326.257596-1-ewanhai-oc@zhaoxin.com>
 <b041fdb3-5b08-4a85-913a-ebb3c7dfbe1d@intel.com>
 <3cf7eac6-0a95-46dd-81b0-0ac12735349b@zhaoxin.com>
Content-Language: en-US
In-Reply-To: <3cf7eac6-0a95-46dd-81b0-0ac12735349b@zhaoxin.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1708657989
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 3157
X-Barracuda-BRTS-Status: 0
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.121203
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



On 2/20/24 06:07, Ewan Hai wrote:
> On 2/20/24 03:32, Xiaoyao Li wrote:
>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>> index 11b8177eff..c8f6c0b531 100644
>>> --- a/target/i386/kvm/kvm.c
>>> +++ b/target/i386/kvm/kvm.c
>>> @@ -2296,6 +2296,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
>>>   static int kvm_get_supported_feature_msrs(KVMState *s)
>>>   {
>>>       int ret = 0;
>>> +    int i;
>>>
>>>       if (kvm_feature_msrs != NULL) {
>>>           return 0;
>>> @@ -2330,6 +2331,19 @@ static int 
>>> kvm_get_supported_feature_msrs(KVMState *s)
>>>           return ret;
>>>       }
>>>
>>> +    /*
>>> +     * Compatibility fix:
>>> +     * Older Linux kernels(<5.3) include the 
>>> MSR_IA32_VMX_PROCBASED_CTLS2
>>
>> we can be more accurate, that kernel version 4.17 to 5.2, reports
>> MSR_IA32_VMX_PROCBASED_CTLS2 in KVM_GET_MSR_FEATURE_INDEX_LIST but not
>> KVM_GET_MSR_INDEX_LIST.
>>
> Yeah, I'll add this more precise comment to the next patch.
>>> +     * only in feature msr list, but not in regular msr list. This 
>>> lead to
>>> +     * an issue in older kernel versions where QEMU, through the 
>>> regular
>>> +     * MSR list check, assumes the kernel doesn't maintain this msr,
>>> +     * resulting in incorrect settings by QEMU for this msr.
>>> +     */
>>> +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
>>> +        if (kvm_feature_msrs->indices[i] == 
>>> MSR_IA32_VMX_PROCBASED_CTLS2) {
>>> +            has_msr_vmx_procbased_ctls2 = true;
>>> +        }
>>> +    }
>>
>> I'm wondering should we move all the initialization of has_msr_*, that
>> associated with feature MSRs, to here. e.g., has_msr_arch_capabs,
>> has_msr_vmx_vmfunc,...
>>
> I believe this is a more elegant way to fix the issue, which will be 
> reflected in my next patch.
When attempting to move the detection logic for feature MSRs (currently
including VMX_VMFUNC, UCODE_REV, ARCH_CAPABILITIES,
PROCBASED_CTLS2) from kvm_get_supported_msrs to
kvm_get_supported_feature_msrs in the current QEMU,
I encountered an "error: failed to set MSR 0x491 to 0x***" on kernel 
4.19.67.
This issue is due to commit 27c42a1bb ("KVM: nVMX: Enable VMFUNC for
the L1 hypervisor", 2017-08-03) exposing VMFUNC to the QEMU guest
without corresponding VMFUNC MSR modification code, leading to an error
when QEMU proactively tries to set the VMFUNC MSR. This bug affects kernels
from 4.14 to 5.2, with a fix introduced in 5.3 by Paolo (e8a70bd4e ("KVM:
nVMX: allow setting the VMFUNC controls MSR", 2019-07-02)).

Therefore, even if we were to move all feature MSRs to
kvm_get_supported_feature_msrs,VMX_VMFUNC could not be moved due to
the need to maintain compatibility with different kernel versions. This
exception makes our move less elegant. Hence, I am wondering whether we
need to move all feature MSRs to kvm_get_supported_feature_msrs. Perhaps
we just need to simply move PROCBASED_CTLS2 to fix the "failed set 0x48b 
..."
type of bugs, and add a comment about it?



