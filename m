Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B9872181
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 23:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392079AbfGWV24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 17:28:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbfGWV2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 17:28:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6NLO9Ur031514;
        Tue, 23 Jul 2019 21:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=jXLXRJ/Y6JfH9vX4QoNP0NAjE2AgrDuly2eL+QibNhM=;
 b=VqyK1OKp7TR230/YHVBc0GtEfo9JHhY1dZLbJ6VYPvkgkjnID5sJgWr5e+PClmv+dNau
 xAJm6kFOUOaQwPnYrkrhWIKCG3qT0fYVS0C05oHn8V5dVB7+rZ6YdR3fGU8USIFnA/NX
 O0a0IV1s2w3ljnfv04vltT0hfIVYfakFjPTAfJv5PhuOchItpFaAqWlCCHQkAnvZEJHv
 B1BpbDZGw8TRRYT7e9M0HkhQRwjxN7I3JL2LPclkc93O/itlqfKkjoywx1s73P0RKeV7
 7wnhYM++zelSqD+3lkA6cCm30B0dtgUq2uU6HwFA+/4yJjNaAdY1VgeoG77AGyGeJflJ OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tx61bsbub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 21:28:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6NLRpRf082842;
        Tue, 23 Jul 2019 21:28:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tx60xekek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 21:28:23 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6NLSJDo024157;
        Tue, 23 Jul 2019 21:28:19 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 14:28:19 -0700
Subject: Re: [PATCH] KVM: x86: init x2apic_enabled() once
To:     luferry@163.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190723130608.26528-1-luferry@163.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a86b536b-71ad-1112-9968-54136a9229d9@oracle.com>
Date:   Tue, 23 Jul 2019 14:28:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190723130608.26528-1-luferry@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907230216
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907230216
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/23/2019 06:06 AM, luferry@163.com wrote:
> From: luferry <luferry@163.com>
>
> x2apic_eanbled() costs about 200 cycles
> when guest trigger halt pretty high, pi ops in hotpath
>
> Signed-off-by: luferry <luferry@163.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d98eac371c0a..e17dbf011e47 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -186,6 +186,8 @@ static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
>   static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
>   static DEFINE_MUTEX(vmx_l1d_flush_mutex);
>   
> +static int __read_mostly host_x2apic_enabled;
> +
>   /* Storage for pre module init parameter parsing */
>   static enum vmx_l1d_flush_state __read_mostly vmentry_l1d_flush_param = VMENTER_L1D_FLUSH_AUTO;
>   
> @@ -1204,7 +1206,7 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>   
>   		dest = cpu_physical_id(cpu);
>   
> -		if (x2apic_enabled())
> +		if (host_x2apic_enabled)
>   			new.ndst = dest;
>   		else
>   			new.ndst = (dest << 8) & 0xFF00;
> @@ -7151,7 +7153,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>   
>   		dest = cpu_physical_id(vcpu->cpu);
>   
> -		if (x2apic_enabled())
> +		if (host_x2apic_enabled)
>   			new.ndst = dest;
>   		else
>   			new.ndst = (dest << 8) & 0xFF00;
> @@ -7221,7 +7223,7 @@ static int pi_pre_block(struct kvm_vcpu *vcpu)
>   		 */
>   		dest = cpu_physical_id(vcpu->pre_pcpu);
>   
> -		if (x2apic_enabled())
> +		if (host_x2apic_enabled)
>   			new.ndst = dest;
>   		else
>   			new.ndst = (dest << 8) & 0xFF00;
> @@ -7804,6 +7806,8 @@ static int __init vmx_init(void)
>   	}
>   #endif
>   
> +	host_x2apic_enabled = x2apic_enabled();
> +
>   	r = kvm_init(&vmx_x86_ops, sizeof(struct vcpu_vmx),
>   		     __alignof__(struct vcpu_vmx), THIS_MODULE);
>   	if (r)

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
