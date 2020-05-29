Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2D01E7621
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 08:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgE2GqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 02:46:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2GqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 02:46:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04T6bhdb074279;
        Fri, 29 May 2020 06:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=p+AdWDoye0Lkk2hx4NzfpuM0jEhv+I7hNuZ0UcNlRoQ=;
 b=Kj1fnl0pjrgLIp2ebh1+0luDgmeIeWze8MYd97cayMXMTO/ad9wUwIJPUVIcGLqfis6Z
 /vZ1juGL9yV0BlZa01CA1n8HiT+GkWJXVFrsbHdmcNECrT/V49IMfq9X2C9U56Kl18Hi
 uWgXMjcNbgMblr985NOdrw9lspOO53xZRcMpuRyw1xZi5EQir2Pual+A5KcyuK3oeFMK
 TXy+RIithyzs2V2wnzhaG18GUTPT1IOs1JSsTy7z7m0B5sLSOdLGyQXU4glblRG89QTb
 6kAbU2XBEMGnRciPEs2+jRA8JU2Mcloj5P8o5KkeKPs4oiZuvcl871HIqjqHS63ye6J+ ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 316u8r8qtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 06:46:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04T6hhDv065369;
        Fri, 29 May 2020 06:46:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31a9ktsvkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 06:46:10 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04T6k9kn030853;
        Fri, 29 May 2020 06:46:09 GMT
Received: from localhost.localdomain (/10.159.253.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 May 2020 23:46:09 -0700
Subject: Re: [PATCH 05/28] KVM: nSVM: correctly inject INIT vmexits
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
 <20200526172308.111575-6-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a5331d80-b6ee-b111-c91b-a8723fd3da9b@oracle.com>
Date:   Thu, 28 May 2020 23:46:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200526172308.111575-6-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9635 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9635 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005290051
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/26/20 10:22 AM, Paolo Bonzini wrote:
> The usual drill at this point, except there is no code to remove because this
> case was not handled at all.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index bbf991cfe24b..166b88fc9509 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -25,6 +25,7 @@
>   #include "trace.h"
>   #include "mmu.h"
>   #include "x86.h"
> +#include "lapic.h"
>   #include "svm.h"
>   
>   static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
> @@ -788,11 +789,37 @@ static void nested_svm_intr(struct vcpu_svm *svm)
>   	nested_svm_vmexit(svm);
>   }
>   
> +static inline bool nested_exit_on_init(struct vcpu_svm *svm)
> +{
> +	return (svm->nested.intercept & (1ULL << INTERCEPT_INIT));
> +}
> +
> +static void nested_svm_init(struct vcpu_svm *svm)

Should this be named nested_svm_inject_init_vmexit in accordance with 
nested_svm_inject_exception_vmexit that you did in patch# 3 ?

> +{
> +	svm->vmcb->control.exit_code   = SVM_EXIT_INIT;
> +	svm->vmcb->control.exit_info_1 = 0;
> +	svm->vmcb->control.exit_info_2 = 0;
> +
> +	nested_svm_vmexit(svm);
> +}
> +
> +
>   static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	bool block_nested_events =
>   		kvm_event_needs_reinjection(vcpu) || svm->nested.nested_run_pending;
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +
> +	if (lapic_in_kernel(vcpu) &&
> +	    test_bit(KVM_APIC_INIT, &apic->pending_events)) {
> +		if (block_nested_events)
> +			return -EBUSY;
> +		if (!nested_exit_on_init(svm))
> +			return 0;
> +		nested_svm_init(svm);
> +		return 0;
> +	}
>   
>   	if (vcpu->arch.exception.pending) {
>   		if (block_nested_events)
