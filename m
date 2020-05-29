Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC4B1E857A
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 19:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgE2RoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 13:44:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46978 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgE2RoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 13:44:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04THRxjl063466;
        Fri, 29 May 2020 17:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ygp+b2CwOObfl6QpIHhCnCkG/Gju2Rtfb6hrd2ha3sg=;
 b=Fq39hMHMKgxlceUPXiFEHnDLCyvZK/4tu39RupcDX4FCyl+hCoTWt7PAIVY5ibil3hQ1
 MjSl2F0Ji9dJAoJDetAbCAuPENOhZQPJhGjRG3qgJU7xPRAjfVsHESLajxGZrbAMCQaA
 bpecJ92e2E+ZIiLceGnDgVkNXAUfK4k5HK+F6VvTYL5Dr53BuEMXkybXggKc2YwUZrn2
 zqe9rg2/XC/5xqbHmW38NH0ulUM+m5OGi75Sk9M3c/hGY4+wlevbCcZNMTV5e7sN7h19
 t+NcjMUH9LZYi6XFK6zTZuL+7t119/4Nd3GMSnx2ZVSuzFYIbI+p+QjpJbmKiyAedKCn 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 318xbkbq45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 17:44:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04THTAWj157566;
        Fri, 29 May 2020 17:42:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 317ddur01p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 17:42:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04THg5gD026971;
        Fri, 29 May 2020 17:42:05 GMT
Received: from localhost.localdomain (/10.159.246.35)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 10:42:04 -0700
Subject: Re: [PATCH 06/30] KVM: SVM: always update CR3 in VMCB
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-7-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <07139fc2-39bd-5bc5-ef23-a98681013665@oracle.com>
Date:   Fri, 29 May 2020 10:41:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200529153934.11694-7-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005290133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/29/20 8:39 AM, Paolo Bonzini wrote:
> svm_load_mmu_pgd is delaying the write of GUEST_CR3 to prepare_vmcs02

Did you mean to say enter_svm_guest_mode here ?
> as
> an optimization, but this is only correct before the nested vmentry.
> If userspace is modifying CR3 with KVM_SET_SREGS after the VM has
> already been put in guest mode, the value of CR3 will not be updated.
> Remove the optimization, which almost never triggers anyway.
> This was was added in commit 689f3bf21628 ("KVM: x86: unify callbacks
> to load paging root", 2020-03-16) just to keep the two vendor-specific
> modules closer, but we'll fix VMX too.
>
> Fixes: 689f3bf21628 ("KVM: x86: unify callbacks to load paging root")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c |  6 +-----
>   arch/x86/kvm/svm/svm.c    | 16 +++++-----------
>   2 files changed, 6 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index dcac4c3510ab..8756c9f463fd 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -256,11 +256,7 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
>   	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
>   	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
> -	if (npt_enabled) {
> -		svm->vmcb->save.cr3 = nested_vmcb->save.cr3;
> -		svm->vcpu.arch.cr3 = nested_vmcb->save.cr3;
> -	} else
> -		(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
> +	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
>   
>   	/* Guest paging mode is active - reset mmu */
>   	kvm_mmu_reset_context(&svm->vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 545f63ebc720..feb96a410f2d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3447,7 +3447,6 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> -	bool update_guest_cr3 = true;
>   	unsigned long cr3;
>   
>   	cr3 = __sme_set(root);
> @@ -3456,18 +3455,13 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
>   		mark_dirty(svm->vmcb, VMCB_NPT);
>   
>   		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
> -		if (is_guest_mode(vcpu))
> -			update_guest_cr3 = false;
> -		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> -			cr3 = vcpu->arch.cr3;
> -		else /* CR3 is already up-to-date.  */
> -			update_guest_cr3 = false;
> +		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> +			return;
> +		cr3 = vcpu->arch.cr3;
>   	}
>   
> -	if (update_guest_cr3) {
> -		svm->vmcb->save.cr3 = cr3;
> -		mark_dirty(svm->vmcb, VMCB_CR);
> -	}
> +	svm->vmcb->save.cr3 = cr3;
> +	mark_dirty(svm->vmcb, VMCB_CR);
>   }
>   
>   static int is_disabled(void)
