Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49D0149997
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2020 08:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgAZHvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jan 2020 02:51:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45394 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgAZHvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jan 2020 02:51:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00Q7mnF6099899;
        Sun, 26 Jan 2020 07:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oDml1uqTHIUm5SykuO+ycE2S6MqTc82Kc2mVWCQaWXY=;
 b=YVVeM8bOSCuwfz7fHDzIVmRRB0smCw3U/Aj8d+rnZPkaJANiUJEy2QNvorqAblvuuFnD
 BcyQ0PHtwJBiwHIFSut/6lN5V6YNXL4tDvelyOR/rRhgUMYH9VhbUwza+1BL4qdJDvso
 eVq/1/AfjHMElbPL+f1Zs+cpDaxEPkwXG4U2q+roXP5rsximLaqhreuBRZXP3MNYBeIj
 2ZhwaFM6oufFzOzhtjy8UOcAUtjWBcHZ1twu6fvgP/fZ3upRONV2wltn1+IpFR8Za5KY
 uGCRb9FzDZAdIfNQX3oTj/hd9cSnfC8SQ6yM+9VVHwcmnH86kuxArEvno5MksRqNPU77 DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xrdmq30rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 07:49:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00Q7mIZr046429;
        Sun, 26 Jan 2020 07:49:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xry6gy7vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 07:49:50 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00Q7nfS0008137;
        Sun, 26 Jan 2020 07:49:42 GMT
Received: from localhost.localdomain (/10.159.134.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jan 2020 23:49:41 -0800
Subject: Re: [PATCH] KVM: x86: Take a u64 when checking for a valid dr7 value
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
References: <20200124230722.8964-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <58ac5290-6baf-6669-ad71-c2c3a2270329@oracle.com>
Date:   Sat, 25 Jan 2020 23:49:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200124230722.8964-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9511 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=887
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9511 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=940 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260069
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/24/20 3:07 PM, Sean Christopherson wrote:
> Take a u64 instead of an unsigned long in kvm_dr7_valid() to fix a build
> warning on i386 due to right-shifting a 32-bit value by 32 when checking
> for bits being set in dr7[63:32].
>
> Alternatively, the warning could be resolved by rewriting the check to
> use an i386-friendly method, but taking a u64 fixes another oddity on
> 32-bit KVM.  Beause KVM implements natural width VMCS fields as u64s to
> avoid layout issues between 32-bit and 64-bit, a devious guest can stuff
> vmcs12->guest_dr7 with a 64-bit value even when both the guest and host
> are 32-bit kernels.  KVM eventually drops vmcs12->guest_dr7[63:32] when
> propagating vmcs12->guest_dr7 to vmcs02, but ideally KVM would not rely
> on that behavior for correctness.
>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Fixes: ecb697d10f70 ("KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/x86.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2d2ff855773b..3624665acee4 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -357,7 +357,7 @@ static inline bool kvm_pat_valid(u64 data)
>   	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
>   }
>   
> -static inline bool kvm_dr7_valid(unsigned long data)
> +static inline bool kvm_dr7_valid(u64 data)
>   {
>   	/* Bits [63:32] are reserved */
>   	return !(data >> 32);
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
