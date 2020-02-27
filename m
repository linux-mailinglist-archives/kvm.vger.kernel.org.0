Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77270172949
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 21:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgB0UKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 15:10:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48066 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729737AbgB0UKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 15:10:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RJqje2016502;
        Thu, 27 Feb 2020 20:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vTI3356UXLO6daiFtQpiwleqiIyVF/OpFewn1CjzkJE=;
 b=YkAA0quWcullrhDKmChBzEZLwyf6280JvYe130sYSu1xX5sWFUprxvm9hkIgAzF09Pqb
 ZrLJX5xxk3P2qlCMb6YxxN2n7u8SbiMv1M86QvB94OPJithlYzHfnYX+N7JKfl0GCuFr
 zv/myyCtNEkz44gGfcDaNSAap/stuo8QV1CNiSHKiUaINp0Ua/6eJVeXEzdvzfijhccO
 OptP/eLH1fVyvZawvLDz48Nq1cF0k508ni2XiuZA8gIU/ypWsW3wvACKJhjTHRJMHwRt
 7W4adaStZfqyEM9y2r2kGYp/vHgYNQOfH6g6HGQwR0PbmF1Iwm2CY2H7cwhPQWy4AO8t 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ydct3dcse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:08:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RJm9SZ059733;
        Thu, 27 Feb 2020 20:08:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ydj4ngmvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:08:59 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01RK8vNL021906;
        Thu, 27 Feb 2020 20:08:57 GMT
Received: from localhost.localdomain (/10.159.246.46)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 12:08:57 -0800
Subject: Re: [PATCH] KVM: nVMX: Consult only the "basic" exit reason when
 routing nested exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200227174430.26371-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <ee8c5eb6-9e3d-620b-d51f-bf0534a05d43@oracle.com>
Date:   Thu, 27 Feb 2020 12:08:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200227174430.26371-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/27/20 9:44 AM, Sean Christopherson wrote:
> Consult only the basic exit reason, i.e. bits 15:0 of vmcs.EXIT_REASON,
> when determining whether a nested VM-Exit should be reflected into L1 or
> handled by KVM in L0.
>
> For better or worse, the switch statement in nested_vmx_exit_reflected()
> currently defaults to "true", i.e. reflects any nested VM-Exit without
> dedicated logic.  Because the case statements only contain the basic
> exit reason, any VM-Exit with modifier bits set will be reflected to L1,
> even if KVM intended to handle it in L0.
>
> Practically speaking, this only affects EXIT_REASON_MCE_DURING_VMENTRY,
> i.e. a #MC that occurs on nested VM-Enter would be incorrectly routed to
> L1, as "failed VM-Entry" is the only modifier that KVM can currently
> encounter.  The SMM modifiers will never be generated as KVM doesn't
> support/employ a SMI Transfer Monitor.  Ditto for "exit from enclave",
> as KVM doesn't yet support virtualizing SGX, i.e. it's impossible to
> enter an enclave in a KVM guest (L1 or L2).


It seems nested_vmx_exit_reflected() deals only with the basic exit 
reason. If it doesn't need anything beyond bits 15:0, may be 
vmx_handle_exit() can pass just the base exit reason ?

>
> Fixes: 644d711aa0e1 ("KVM: nVMX: Deciding if L0 or L1 should handle an L2 exit")
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0946122a8d3b..127065bbde2c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5554,7 +5554,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>   				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
>   				KVM_ISA_VMX);
>   
> -	switch (exit_reason) {
> +	switch ((u16)exit_reason) {
>   	case EXIT_REASON_EXCEPTION_NMI:
>   		if (is_nmi(intr_info))
>   			return false;
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
