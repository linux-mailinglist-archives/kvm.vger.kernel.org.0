Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109BA5536F
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 17:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbfFYPbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 11:31:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52092 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730156AbfFYPbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 11:31:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PFIjiV008061;
        Tue, 25 Jun 2019 15:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=OU1G3MSDEEdD+MiCNvHr3s9/YdsR0SoCOUXUTAfKHxs=;
 b=wmzVLjkx0mJS5Knu3O5tJfLE7WZddUPN0lfugYKM0i5cqHp4j/JAL/5NfhOQuYsBgRlC
 38i8WtD4ZdHhleykAj6RFGZkuwPUSbdeOimOy+5w/XXFSPmHAmXcYAz85FyChgOtIA0T
 lAzUsUFe5OZmpbRLHT8B2bEbXLOnB7cpACxcol5oTL4ICFI7EgRbFTqVLe0vsCoAHfWC
 JutOJSdY7nZb5M2iCUjPas/+W0ZcH0k4ahzlprYs9TN+spaHE4N7ifL31WkrjvDL7nnn
 HqSo5fKsEG8bWXvvN9ZwzMwrq25DX/0TI0n3kDVLxKWWZwposH3Q7BVOnhUBlfAvh0WC XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brt561w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 15:30:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PFRqjo100637;
        Tue, 25 Jun 2019 15:28:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t99f3xfg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 15:28:19 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5PFSEOg018655;
        Tue, 25 Jun 2019 15:28:15 GMT
Received: from [10.154.154.244] (/10.154.154.244)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 08:28:14 -0700
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even if
 host does not
To:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     x86@kernel.org, kvm@vger.kernel.org
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
From:   Mark Kanda <mark.kanda@oracle.com>
Organization: Oracle Corporation
Message-ID: <98466af8-79d2-227e-f0be-06caed801c25@oracle.com>
Date:   Tue, 25 Jun 2019 10:28:12 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=888
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=927 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/10/2019 12:20 PM, Alejandro Jimenez wrote:
> The bits set in x86_spec_ctrl_mask are used to calculate the
> guest's value of SPEC_CTRL that is written to the MSR before
> VMENTRY, and control which mitigations the guest can enable.
> In the case of SSBD, unless the host has enabled SSBD always
> on mode (by passing "spec_store_bypass_disable=on" in the
> kernel parameters), the SSBD bit is not set in the mask and
> the guest can not properly enable the SSBD always on
> mitigation mode.
> 
> This is confirmed by running the SSBD PoC on a guest using
> the SSBD always on mitigation mode (booted with kernel
> parameter "spec_store_bypass_disable=on"), and verifying
> that the guest is vulnerable unless the host is also using
> SSBD always on mode. In addition, the guest OS incorrectly
> reports the SSB vulnerability as mitigated.
> 
> Always set the SSBD bit in x86_spec_ctrl_mask when the host
> CPU supports it, allowing the guest to use SSBD whether or
> not the host has chosen to enable the mitigation in any of
> its modes.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

Reviewed-by: Mark Kanda <mark.kanda@oracle.com>

> Cc: stable@vger.kernel.org
> ---
>   arch/x86/kernel/cpu/bugs.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 03b4cc0..66ca906 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -836,6 +836,16 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
>   	}
>   
>   	/*
> +	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
> +	 * bit in the mask to allow guests to use the mitigation even in the
> +	 * case where the host does not enable it.
> +	 */
> +	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
> +	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
> +		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
> +	}
> +
> +	/*
>   	 * We have three CPU feature flags that are in play here:
>   	 *  - X86_BUG_SPEC_STORE_BYPASS - CPU is susceptible.
>   	 *  - X86_FEATURE_SSBD - CPU is able to turn off speculative store bypass
> @@ -852,7 +862,6 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
>   			x86_amd_ssb_disable();
>   		} else {
>   			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
> -			x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
>   			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
>   		}
>   	}
> 
