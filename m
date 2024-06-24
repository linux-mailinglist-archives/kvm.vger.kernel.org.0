Return-Path: <kvm+bounces-20387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B85BC914790
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 12:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7422C285E1D
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 10:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB5061369BE;
	Mon, 24 Jun 2024 10:36:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7218125D6
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 10:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.110.167.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719225402; cv=none; b=aeKbprp+OkH9yX6Jz7//cTN6JoLnO3uWurYTpTn9ko6jMcUjfdblVlGmZsyETByp9DS9kfS0VI8RbKpt3kTyBI4Cr0SR79mc9sD4RcWvB2iq2/x0Sz/rW98TdPmJl79JUWbfwab2Nfwo1AUQcemnVga4fJ1RV57QGwafsnBbtyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719225402; c=relaxed/simple;
	bh=tTUAoQJINFZUHAgTrXklFwCvGAYatodAk8ivp4ixXok=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=uiidvIlnBtzQsrU1rIWV3B+CVe99AgUyjQk8Pfc7sqftpDJTnKkjD9bqis2xXfSbBNhfR/qM6pOhWitgeoF3nh1ARpMvilVKlB29qHZiZ849+rxDwNahSWjKbdDQt0ASDx1tdyPWtATZcaDJ0d3i1PTvimbeT0YsL2D1eTftqFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=203.110.167.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1719224459-1eb14e2e60b9290001-HEqcsx
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx2.zhaoxin.com with ESMTP id 84MmLcTc9kLKvesU (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 24 Jun 2024 18:20:59 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Jun
 2024 18:20:59 +0800
Received: from [10.28.66.62] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Jun
 2024 18:20:58 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Message-ID: <8d816541-2546-42a8-b6db-bd9d50729b36@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.28.66.62
Date: Mon, 24 Jun 2024 06:20:58 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
X-ASG-Orig-Subj: Re: [PATCH v3] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
To: <mtosatti@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>, <ewanhai@zhaoxin.com>,
	<cobechen@zhaoxin.com>, <zhao1.liu@intel.com>
References: <20240624095806.214525-1-ewanhai-oc@zhaoxin.com>
Content-Language: en-US
In-Reply-To: <20240624095806.214525-1-ewanhai-oc@zhaoxin.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1719224459
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 3148
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.126687
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Sorry for my oversight, I am adding the maintainers who were
missed in the previous email.

On 6/24/24 05:58, EwanHai wrote:
> Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
> execution controls") implemented a workaround for hosts that have
> specific CPUID features but do not support the corresponding VMX
> controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
>
> In detail, commit 4a910e1 introduced a flag `has_msr_vmx_procbased_clts2`.
> If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
> use KVM's settings, avoiding any modifications to this MSR.
>
> However, this commit (4a910e1) didn't account for cases in older Linux
> kernels(4.17~5.2) where `MSR_IA32_VMX_PROCBASED_CTLS2` is in
> `kvm_feature_msrs`-obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
> but not in `kvm_msr_list`-obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
> As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
> on `kvm_msr_list` alone, even though KVM does maintain the value of
> this MSR.
>
> This patch supplements the above logic, ensuring that
> `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
> lists, thus maintaining compatibility with older kernels.
>
> Signed-off-by: EwanHai <ewanhai-oc@zhaoxin.com>
> ---
> Changes in v3:
> - Use a more precise version range in the comment, specifically "4.17~5.2"
> instead of "<5.3".
>
> Changes in v2:
> - Adjusted some punctuation in the commit message as per suggestions.
> - Added comments to the newly added code to indicate that it is a compatibility fix.
>
> v1 link:
> https://lore.kernel.org/all/20230925071453.14908-1-ewanhai-oc@zhaoxin.com/
>
> v2 link:
> https://lore.kernel.org/all/20231127034326.257596-1-ewanhai-oc@zhaoxin.com/
> ---
>   target/i386/kvm/kvm.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 7ad8072748..a7c6c5b2d0 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2386,6 +2386,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
>   static int kvm_get_supported_feature_msrs(KVMState *s)
>   {
>       int ret = 0;
> +    int i;
>   
>       if (kvm_feature_msrs != NULL) {
>           return 0;
> @@ -2420,6 +2421,20 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
>           return ret;
>       }
>   
> +   /*
> +    * Compatibility fix:
> +    * Older Linux kernels (4.17~5.2) report MSR_IA32_VMX_PROCBASED_CTLS2
> +    * in KVM_GET_MSR_FEATURE_INDEX_LIST but not in KVM_GET_MSR_INDEX_LIST.
> +    * This leads to an issue in older kernel versions where QEMU,
> +    * through the KVM_GET_MSR_INDEX_LIST check, assumes the kernel
> +    * doesn't maintain MSR_IA32_VMX_PROCBASED_CTLS2, resulting in
> +    * incorrect settings by QEMU for this MSR.
> +    */
> +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
> +        if (kvm_feature_msrs->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS2) {
> +            has_msr_vmx_procbased_ctls2 = true;
> +        }
> +    }
>       return 0;
>   }
>   


