Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E267F3407
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 17:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbfKGQBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 11:01:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729871AbfKGQBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 11:01:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7Fx2nh125294;
        Thu, 7 Nov 2019 16:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=c12rUaycNzO7zYCgriemaWn5qIFSRzTDdlQlHvFHXos=;
 b=LuQR1i9OBvPBvjpBfVlpLdELDgfFY6IplMlZg/jTd8QxGL7HERIg+V88h/ajR3H+eB/M
 K5jx7YsAFRdT7YrBpvSoyF5P9svwH+JeIxPSCwSYdSCZ4T3dsXoegnh2tp6s3jnjytsn
 6gTq6bYIu1Gxx0EOEiBwwBcqQjr/IpoxldXsFKxBG5rUUy8VkQnOhQstlk+UIHmv3xPW
 zDTGHUltK2GjBoGOOG3mqJzKTQV3Y9eXp7lng+z7UE3OioYEJ0JD1CU3pBui6ZBI8wID
 k18VYcPm6sHTFhJWh73HScT74JD77dzj9aZWes7G10gSUQRYQQDyuaxFu8cgOCmrIYhH /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w17711-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 16:00:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7FwWAJ073212;
        Thu, 7 Nov 2019 16:00:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w41whgh2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 16:00:07 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA7G04HN028891;
        Thu, 7 Nov 2019 16:00:04 GMT
Received: from [10.152.34.2] (/10.152.34.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:00:04 +0000
Subject: Re: [PATCH v1 1/3] KVM: VMX: Consider PID.PIR to determine if vCPU
 has pending interrupts
To:     Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
 <20191106175602.4515-2-joao.m.martins@oracle.com>
From:   Jag Raman <jag.raman@oracle.com>
Organization: Oracle Corporation
Message-ID: <84b00baf-0fb9-919c-fabc-ae990e854257@oracle.com>
Date:   Thu, 7 Nov 2019 11:00:03 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20191106175602.4515-2-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/6/2019 12:56 PM, Joao Martins wrote:
> Commit 17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
> introduced vmx_dy_apicv_has_pending_interrupt() in order to determine
> if a vCPU have a pending posted interrupt. This routine is used by
> kvm_vcpu_on_spin() when searching for a a new runnable vCPU to schedule
> on pCPU instead of a vCPU doing busy loop.
> 
> vmx_dy_apicv_has_pending_interrupt() determines if a
> vCPU has a pending posted interrupt solely based on PID.ON. However,
> when a vCPU is preempted, vmx_vcpu_pi_put() sets PID.SN which cause
> raised posted interrupts to only set bit in PID.PIR without setting
> PID.ON (and without sending notification vector), as depicted in VT-d
> manual section 5.2.3 "Interrupt-Posting Hardware Operation".
> 
> Therefore, checking PID.ON is insufficient to determine if a vCPU has
> pending posted interrupts and instead we should also check if there is
> some bit set on PID.PIR.
> 
> Fixes: 17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>

Reviewed-by: Jagannathan Raman <jag.raman@oracle.com>

> ---
>   arch/x86/kvm/vmx/vmx.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 31ce6bc2c371..18b0bee662a5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6141,7 +6141,10 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>   
>   static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
>   {
> -	return pi_test_on(vcpu_to_pi_desc(vcpu));
> +	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> +
> +	return pi_test_on(pi_desc) ||
> +		!bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
>   }
>   
>   static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
> 
