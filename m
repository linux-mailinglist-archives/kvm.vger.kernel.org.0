Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E291D90DA
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 09:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgESHVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 03:21:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgESHVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 03:21:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J7HMJ5088153;
        Tue, 19 May 2020 07:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NYMDiSRSRYoNMhQx39Ut1Yiw2fBFicwdmWSm0FHG770=;
 b=PGrkrpKOidgkv29CAuwVtUnP6sR+AzPSr2NXCHWGFdhl2NHodW8f9NbjNR6rfLahzkcM
 +IFTkDjwaumvQYEJfE86klo1BGbUCDpJbk5/bVpSWpUTb+hxEm9Rassi3cLZ50Tk9NmF
 9Eibr5Df6dU8osxo/EPQgNaBjVchBmDBh3OSyFn4e1N0F9YLqjNYf9icSocGDkXwjCRd
 FPzK+MfahwSm2U7aGpJiFZ0KJMziuZK2Oe5s+13OpYQXkdSN7hN259pChHGtCJb48v7H
 4a+jB4t2KGympqkdrybSLTl0xaSWrJjtPMTh1ksM4C790kJPuj9GLXxFUGsDIkKJjBgx /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tnbga2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 07:21:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J7D0Eh101724;
        Tue, 19 May 2020 07:18:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t33emet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 07:18:59 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04J7Ixd2012091;
        Tue, 19 May 2020 07:18:59 GMT
Received: from localhost.localdomain (/10.159.253.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 00:18:58 -0700
Subject: Re: [PATCH 1/2] KVM: nVMX: Fix VMX preemption timer migration
To:     Makarand Sonare <makarandsonare@google.com>, kvm@vger.kernel.org,
        pshier@google.com, jmattson@google.com
References: <20200518201600.255669-1-makarandsonare@google.com>
 <20200518201600.255669-2-makarandsonare@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <7e7bcffa-7a97-1662-b2bb-05f9429e819a@oracle.com>
Date:   Tue, 19 May 2020 00:18:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200518201600.255669-2-makarandsonare@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190064
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190064
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/18/20 1:15 PM, Makarand Sonare wrote:
> From: Peter Shier <pshier@google.com>
>
> Add new field to hold preemption timer expiration deadline
> appended to struct kvm_vmx_nested_state_data. This is to prevent
> the first VM-Enter after migration from incorrectly restarting the timer
> with the full timer value instead of partially decayed timer value.
> KVM_SET_NESTED_STATE restarts timer using migrated state regardless
> of whether L1 sets VM_EXIT_SAVE_VMX_PREEMPTION_TIMER.
>
> Fixes: cf8b84f48a593 ("kvm: nVMX: Prepare for checkpointing L2 state")
>
> Signed-off-by: Peter Shier <pshier@google.com>
> Signed-off-by: Makarand Sonare <makarandsonare@google.com>
> Change-Id: I6446aba5a547afa667f0ef4620b1b76115bf3753
> ---
>   Documentation/virt/kvm/api.rst        |  4 ++
>   arch/x86/include/uapi/asm/kvm.h       |  2 +
>   arch/x86/kvm/vmx/nested.c             | 61 ++++++++++++++++++++++++---
>   arch/x86/kvm/vmx/vmx.h                |  1 +
>   arch/x86/kvm/x86.c                    |  3 +-
>   include/uapi/linux/kvm.h              |  1 +
>   tools/arch/x86/include/uapi/asm/kvm.h |  2 +
>   7 files changed, 67 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d871dacb984e9..b410815772970 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4326,6 +4326,9 @@ Errors:
>     #define KVM_STATE_NESTED_RUN_PENDING		0x00000002
>     #define KVM_STATE_NESTED_EVMCS		0x00000004
>   
> +  /* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
> +  #define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
> +
>     #define KVM_STATE_NESTED_FORMAT_VMX		0
>     #define KVM_STATE_NESTED_FORMAT_SVM		1
>   
> @@ -4346,6 +4349,7 @@ Errors:
>     struct kvm_vmx_nested_state_data {
>   	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>   	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> +	__u64 preemption_timer_deadline;
>     };
>   
>   This ioctl copies the vcpu's nested virtualization state from the kernel to
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 3f3f780c8c650..20d5832bab215 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -391,6 +391,7 @@ struct kvm_sync_regs {
>   #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
>   #define KVM_STATE_NESTED_EVMCS		0x00000004
>   #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
> +#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
>   
>   #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
>   #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
> @@ -400,6 +401,7 @@ struct kvm_sync_regs {
>   struct kvm_vmx_nested_state_data {
>   	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>   	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> +	__u64 preemption_timer_deadline;
>   };
>   
>   struct kvm_vmx_nested_state_hdr {
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 51ebb60e1533a..badb82a39ac04 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2092,9 +2092,9 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
>   	return HRTIMER_NORESTART;
>   }
>   
> -static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
> +static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
> +					u64 preemption_timeout)
>   {
> -	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   
>   	/*
> @@ -3353,8 +3353,24 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>   	 * the timer.
>   	 */
>   	vmx->nested.preemption_timer_expired = false;
> -	if (nested_cpu_has_preemption_timer(vmcs12))
> -		vmx_start_preemption_timer(vcpu);
> +	if (nested_cpu_has_preemption_timer(vmcs12)) {
> +		u64 timer_value;
> +		u64 l1_tsc_value = kvm_read_l1_tsc(vcpu, rdtsc());
> +
> +		if (from_vmentry) {
> +			timer_value = vmcs12->vmx_preemption_timer_value;
> +			vmx->nested.preemption_timer_deadline = timer_value +
> +				(l1_tsc_value >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE);
> +		} else {
> +			if ((l1_tsc_value >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE) >
> +			    vmx->nested.preemption_timer_deadline)
> +				timer_value = 0;
> +			else
> +				timer_value = vmx->nested.preemption_timer_deadline -
> +					(l1_tsc_value >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE);

A couple of code optimizations can be done here:

1. The inside if-else can be simplified by initializing 'timer_value' at 
the place where you have defined it:

     } else {
+            if (!((l1_tsc_value >> 
VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE) >
+                vmx->nested.preemption_timer_deadline))
+                    timer_value = vmx->nested.preemption_timer_deadline -
+                        (l1_tsc_value >> 
VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE);

+  }


2. You can apply the right-shift operation on 'l1_tsc_value' right where 
you have defined it:

u64 l1_tsc_value = kvm_read_l1_tsc(vcpu, rdtsc()) >> 
VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE

> +		}
> +		vmx_start_preemption_timer(vcpu, timer_value);
> +	}
>   
>   	/*
>   	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
> @@ -3962,9 +3978,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>   		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
>   
>   	if (nested_cpu_has_preemption_timer(vmcs12) &&
> -	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> +	    !vmx->nested.nested_run_pending) {
> +		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
>   			vmcs12->vmx_preemption_timer_value =
>   				vmx_get_preemption_timer_value(vcpu);
> +	}
>   
>   	/*
>   	 * In some cases (usually, nested EPT), L2 is allowed to change its
> @@ -5939,6 +5957,13 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>   
>   			if (vmx->nested.mtf_pending)
>   				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
> +
> +			if (nested_cpu_has_preemption_timer(vmcs12)) {
> +				kvm_state.flags |=
> +					KVM_STATE_NESTED_PREEMPTION_TIMER;
> +				kvm_state.size = offsetof(struct kvm_nested_state, data.vmx) +


'size' is reset here instead of accumulating all previous sizes. Is that 
what is intended ?

> +						 offsetofend(struct kvm_vmx_nested_state_data, preemption_timer_deadline);
> +			}
>   		}
>   	}
>   
> @@ -5970,6 +5995,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>   
>   	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
>   	BUILD_BUG_ON(sizeof(user_vmx_nested_state->shadow_vmcs12) < VMCS12_SIZE);
> +	BUILD_BUG_ON(sizeof(user_vmx_nested_state->preemption_timer_deadline)
> +		    != sizeof(vmx->nested.preemption_timer_deadline));
> +
>   
>   	/*
>   	 * Copy over the full allocated size of vmcs12 rather than just the size
> @@ -5985,6 +6013,12 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>   			return -EFAULT;
>   	}
>   
> +	if (kvm_state.flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
> +		if (put_user(vmx->nested.preemption_timer_deadline,
> +			     &user_vmx_nested_state->preemption_timer_deadline))
> +			return -EFAULT;
> +	}
> +
>   out:
>   	return kvm_state.size;
>   }
> @@ -6056,7 +6090,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   	 */
>   	if (is_smm(vcpu) ?
>   		(kvm_state->flags &
> -		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
> +		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING |
> +		  KVM_STATE_NESTED_PREEMPTION_TIMER))
>   		: kvm_state->hdr.vmx.smm.flags)
>   		return -EINVAL;
>   
> @@ -6146,6 +6181,20 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   			goto error_guest_mode;
>   	}
>   
> +	if (kvm_state->flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
> +
> +		if (kvm_state->size <
> +		    offsetof(struct kvm_nested_state, data.vmx) +
> +		    offsetofend(struct kvm_vmx_nested_state_data, preemption_timer_deadline))
> +			goto error_guest_mode;
> +
> +		if (get_user(vmx->nested.preemption_timer_deadline,
> +			     &user_vmx_nested_state->preemption_timer_deadline)) {
> +			ret = -EFAULT;
> +			goto error_guest_mode;
> +		}
> +	}
> +
>   	if (nested_vmx_check_controls(vcpu, vmcs12) ||
>   	    nested_vmx_check_host_state(vcpu, vmcs12) ||
>   	    nested_vmx_check_guest_state(vcpu, vmcs12, &ignored))
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 298ddef79d009..db697400755fb 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -169,6 +169,7 @@ struct nested_vmx {
>   	u16 posted_intr_nv;
>   
>   	struct hrtimer preemption_timer;
> +	u64 preemption_timer_deadline;
>   	bool preemption_timer_expired;
>   
>   	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 471fccf7f8501..ba9e62ffbb4cd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3418,6 +3418,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_MSR_PLATFORM_INFO:
>   	case KVM_CAP_EXCEPTION_PAYLOAD:
>   	case KVM_CAP_SET_GUEST_DEBUG:
> +	case KVM_CAP_NESTED_STATE_PREEMPTION_TIMER:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SYNC_REGS:
> @@ -4626,7 +4627,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   
>   		if (kvm_state.flags &
>   		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
> -		      | KVM_STATE_NESTED_EVMCS))
> +		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_PREEMPTION_TIMER))
>   			break;
>   
>   		/* nested_run_pending implies guest_mode.  */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ac9eba0289d1b..0868dce12a715 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1018,6 +1018,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_S390_PROTECTED 180
>   #define KVM_CAP_PPC_SECURE_GUEST 181
>   #define KVM_CAP_HALT_POLL 182
> +#define KVM_CAP_NESTED_STATE_PREEMPTION_TIMER 183
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 3f3f780c8c650..60701178b9cc1 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -391,6 +391,8 @@ struct kvm_sync_regs {
>   #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
>   #define KVM_STATE_NESTED_EVMCS		0x00000004
>   #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
> +/* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
> +#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
>   
>   #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
>   #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
