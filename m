Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4812CFDC7
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 19:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgLESnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 13:43:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40122 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgLESnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 13:43:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B5IUrJ6159079;
        Sat, 5 Dec 2020 18:42:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=B/9ylrvdjeiF4FbWCShAndEikcDVYIepIWkVUJJwLic=;
 b=OZXHot2Ria8NFbU+cwnSh1/7wCBcxC8L6BCnzhjBlx/Gv18bCCP9uDkqC6ju/IJ6tNtC
 VMQPZ5vbDpvZjBDWYzXEQynmiGxRq4QKAysa1gtfnkG3FZlhsczrmA2XPQ8vE3HF53UA
 MU/RJB8ayL42O+vPB5bhn6/Z0LWcHIHq1n+8LMD+k9gof9abG+1vyBWW83uLv0zVdFCJ
 blcGOo5qDZCkBeXhNfA3MxAWzTDGBASktAhzywXJBUIOO6+/g6bwbOXxIEtxx1Svg/rF
 kca/SGm7qBe+XtPtVc4fjS8jgXKgAwqtvpVNPNvbWyk3vLhjmgJ1zijhg4HLvwKgbbNG Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3581mqh8pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 05 Dec 2020 18:42:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B5IUUWk105120;
        Sat, 5 Dec 2020 18:42:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3581hgyust-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Dec 2020 18:42:58 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B5IgusB032492;
        Sat, 5 Dec 2020 18:42:56 GMT
Received: from [10.175.203.58] (/10.175.203.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 05 Dec 2020 10:42:56 -0800
Subject: Re: [PATCH 03/15] KVM: x86/xen: intercept xen hypercalls if enabled
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20201204011848.2967588-1-dwmw2@infradead.org>
 <20201204011848.2967588-4-dwmw2@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <e62dd528-2bee-9e8b-c395-256e6980307e@oracle.com>
Date:   Sat, 5 Dec 2020 18:42:53 +0000
MIME-Version: 1.0
In-Reply-To: <20201204011848.2967588-4-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 spamscore=0 suspectscore=1 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012050124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012050124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 1:18 AM, David Woodhouse wrote:
> @@ -3742,6 +3716,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
>  		r = 1;
>  		break;
> +	case KVM_CAP_XEN_HVM:
> +		r = 1 | KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
> +		break;

Maybe:

	r = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
		KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;

>  	case KVM_CAP_SYNC_REGS:
>  		r = KVM_SYNC_X86_VALID_FIELDS;
>  		break;
> @@ -5603,7 +5580,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		if (copy_from_user(&xhc, argp, sizeof(xhc)))
>  			goto out;
>  		r = -EINVAL;
> -		if (xhc.flags)
> +		if (xhc.flags & ~KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL)
> +			goto out;
> +		/*
> +		 * With hypercall interception the kernel generates its own
> +		 * hypercall page so it must not be provided.
> +		 */
> +		if ((xhc.flags & KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) &&
> +		    (xhc.blob_addr_32 || xhc.blob_addr_64 ||
> +		     xhc.blob_size_32 || xhc.blob_size_64))
>  			goto out;

I suppose it makes sense restricting to INTERCEPT_HCALL to make sure that the kernel only
forwards the hcall if it is control off what it put there in the hypercall page (i.e.
vmmcall/vmcall). hcall userspace exiting without INTERCEPT_HCALL would break ABI over how
this ioctl was used before the new flag... In case kvm_xen_hypercall_enabled() would
return true with KVM_XEN_HVM_CONFIG_HYPERCALL_MSR, as now it needs to handle a new
userspace exit.

If we're are being pedantic, the Xen hypercall MSR is a utility more than a necessity as
the OS can always do without the hcall msr IIUC. But it is defacto used by enlightened Xen
guests included FreeBSD.

If we were to lift the restriction in the conditional above to forward hcall without
INTERCEPT_HCALL flag then kvm_xen_hypercall_enabled() would return true with
CONFIG_HYPERCALL_MSR and CONFIG_INTERCEPT_HCALL. And on wrmsr time, we would only look at
whether we had a blob_size* passed in when handling the msr and initializing the hcall
page. The only added gain is that guests which do vmcalls without an hypercall page would
still be handled.

But I am not sure it's worth the trouble. I feel its good the way this is now, given that
this is new behaviour of forward vmmcall/vmcall to userspace.

> +#endif /* __ARCH_X86_KVM_XEN_H__ */> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..00221fe56994 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -216,6 +216,20 @@ struct kvm_hyperv_exit {
>  	} u;
>  };
>  
> +struct kvm_xen_exit {
> +#define KVM_EXIT_XEN_HCALL          1
> +	__u32 type;
> +	union {
> +		struct {
> +			__u32 longmode;
> +			__u32 cpl;
> +			__u64 input;
> +			__u64 result;
> +			__u64 params[6];
> +		} hcall;
> +	} u;
> +};
> +
>  #define KVM_S390_GET_SKEYS_NONE   1
>  #define KVM_S390_SKEYS_MAX        1048576
>  
> @@ -250,6 +264,7 @@ struct kvm_hyperv_exit {
>  #define KVM_EXIT_ARM_NISV         28
>  #define KVM_EXIT_X86_RDMSR        29
>  #define KVM_EXIT_X86_WRMSR        30
> +#define KVM_EXIT_XEN              31
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -426,6 +441,8 @@ struct kvm_run {
>  			__u32 index; /* kernel -> user */
>  			__u64 data; /* kernel <-> user */
>  		} msr;
> +		/* KVM_EXIT_XEN */
> +		struct kvm_xen_exit xen;
>  		/* Fix the size of the union. */
>  		char padding[256];
>  	};
> @@ -1126,6 +1143,8 @@ struct kvm_x86_mce {
>  #endif
>  
>  #ifdef KVM_CAP_XEN_HVM
> +#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
> +

And adding:

#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)

Of course, this is a nit for readability only, but it aligns with what you write
in the docs update you do in the last patch.
