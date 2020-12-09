Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40A72D4059
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 11:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgLIKwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 05:52:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41620 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgLIKwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 05:52:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9AnPnJ181582;
        Wed, 9 Dec 2020 10:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ymwmnil4FF4AvoExUOyi44pw7g1Jz4EZIGUWtbLM8Rw=;
 b=tgStfkAyG/2VnsEQhlT8UZ0sBBw14DH56wtEZkxrdPWmTEYfvpvFMPIF4PML7Gl48GlL
 A84yGdY8VdARV5QK8Rc4FlYGQ/feNnR7QlHbgf3sL9Ebx7B903uJA3ox0Rv0TF5w62Uq
 4thTXmpiQZMxW6iB531mWt7KRk6FImz00H7NHJjR1vx/S53GQMAsBkHmm+XT6JGxQn1F
 tsFFfH8NGlQCUDioR+jaVTHDrdd8wxHjZPDYK/Wgtdx3Qvdwf2q48Zsh3QRawkY9OwEb
 311WtUOrbpiBbPJzNt565TjR+h7M9cGzvSWOtUO29zGtRWfXn/fngWf+uuzXXJkpbTwO cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 357yqbym2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 10:51:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9AoWVe003285;
        Wed, 9 Dec 2020 10:51:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 358m402ym1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 10:51:33 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9ApOJt021114;
        Wed, 9 Dec 2020 10:51:24 GMT
Received: from [10.175.160.66] (/10.175.160.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 02:51:24 -0800
Subject: Re: [PATCH RFC 10/39] KVM: x86/xen: support upcall vector
To:     David Woodhouse <dwmw2@infradead.org>,
        Ankur Arora <ankur.a.arora@oracle.com>, karahmed@amazon.de
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-11-joao.m.martins@oracle.com>
 <71753a370cd6f9dd147427634284073b78679fa6.camel@infradead.org>
 <53baeaa7-0fed-d22c-7767-09ae885d13a0@oracle.com>
 <4ad0d157c5c7317a660cd8d65b535d3232f9249d.camel@infradead.org>
 <c43024b3-6508-3b77-870c-da81e74284a4@oracle.com>
 <052867ae1c997487d85c21e995feb5647ac6c458.camel@infradead.org>
 <6a6b5806be1fe4c0fe96c0b664710d1ce614f29d.camel@infradead.org>
 <1af00fa4-03b8-a059-d859-5cfd71ef10f4@oracle.com>
 <0eb8c2ef01b77af0d288888f200e812d374beada.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <f7dec3f1-aadc-bda5-f4dc-7185ffd9c1a6@oracle.com>
Date:   Wed, 9 Dec 2020 10:51:16 +0000
MIME-Version: 1.0
In-Reply-To: <0eb8c2ef01b77af0d288888f200e812d374beada.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090075
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1011 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/20 10:27 AM, David Woodhouse wrote:
> On Tue, 2020-12-08 at 22:35 -0800, Ankur Arora wrote:
>>> It looks like Linux doesn't use the per-vCPU upcall vector that you
>>> called 'KVM_XEN_CALLBACK_VIA_EVTCHN'. So I'm delivering interrupts via
>>> KVM_INTERRUPT as if they were ExtINT....
>>>
>>> ... except I'm not. Because the kernel really does expect that to be an
>>> ExtINT from a legacy PIC, and kvm_apic_accept_pic_intr() only returns
>>> true if LVT0 is set up for EXTINT and unmasked.
>>>
>>> I messed around with this hack and increasingly desperate variations on
>>> the theme (since this one doesn't cause the IRQ window to be opened to
>>> userspace in the first place), but couldn't get anything working:
>>
>> Increasingly desperate variations,  about sums up my process as well while
>> trying to get the upcall vector working.
> 
> :)
> 
> So this seems to work, and I think it's about as minimal as it can get.
> 
> All it does is implement a kvm_xen_has_interrupt() which checks the
> vcpu_info->evtchn_upcall_pending flag, just like Xen does.
> 
> With this, my completely userspace implementation of event channels is
> working. And of course this forms a basis for adding the minimal
> acceleration of IPI/VIRQ that we need to the kernel, too.
> 
> My only slight concern is the bit in vcpu_enter_guest() where we have
> to add the check for kvm_xen_has_interrupt(), because nothing is
> setting KVM_REQ_EVENT. I suppose I could look at having something —
> even an explicit ioctl from userspace — set that for us.... BUT...
> 
Isn't this what the first half of this patch was doing initially (minus the
irq routing) ? Looks really similar:

https://lore.kernel.org/kvm/20190220201609.28290-11-joao.m.martins@oracle.com/

Albeit, I gotta after seeing the irq routing removed it ends much simpler, if we just
replace the irq routing with a domain-wide upcall vector ;)

Albeit it wouldn't cover the Windows Xen open source drivers which use the EVTCHN method
(which is a regular LAPIC vector) [to answer your question on what uses it] For the EVTCHN
you can just inject a regular vector through lapic deliver, and guest acks it. Sadly Linux
doesn't use it,
and if it was the case we would probably get faster upcalls with APICv/AVIC.

> I'm not sure that condition wasn't *already* broken some cases for
> KVM_INTERRUPT anyway. In kvm_vcpu_ioctl_interrupt() we set
> vcpu->arch.pending_userspace_vector and we *do* request KVM_REQ_EVENT,
> sure.
> 
> But what if vcpu_enter_guest() processes that the first time (and
> clears KVM_REQ_EVENT), and then exits for some *other* reason with
> interrupts still disabled? Next time through vcpu_enter_guest(), even
> though kvm_cpu_has_injectable_intr() is still true, we don't enable the
> IRQ windowvmexit because KVM_REQ_EVENT got lost so we don't even call
> inject_pending_event().
> 
> So instead of just kvm_xen_has_interrupt() in my patch below, I wonder
> if we need to use kvm_cpu_has_injectable_intr() to fix the existing
> bug? Or am I missing something there and there isn't a bug after all?
> 
Given that the notion of an event channel pending is Xen specific handling, I am not sure
we can remove the kvm_xen_has_interrupt()/kvm_xen_get_interrupt() logic. Much of the
reason that I ended up checking on vmenter that checks event channels pendings..

That or the autoEOI hack Ankur and you were talking out.

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d8716ef27728..4a63f212fdfc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -902,6 +902,7 @@ struct msr_bitmap_range {
>  /* Xen emulation context */
>  struct kvm_xen {
>  	bool long_mode;
> +	u8 upcall_vector;
>  	struct kvm_host_map shinfo_map;
>  	void *shinfo;
>  };
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index 814698e5b152..24668b51b5c8 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -14,6 +14,7 @@
>  #include "irq.h"
>  #include "i8254.h"
>  #include "x86.h"
> +#include "xen.h"
>  
>  /*
>   * check if there are pending timer events
> @@ -56,6 +57,9 @@ int kvm_cpu_has_extint(struct kvm_vcpu *v)
>  	if (!lapic_in_kernel(v))
>  		return v->arch.interrupt.injected;
>  
> +	if (kvm_xen_has_interrupt(v))
> +		return 1;
> +
>  	if (!kvm_apic_accept_pic_intr(v))
>  		return 0;
>  
> @@ -110,6 +114,9 @@ static int kvm_cpu_get_extint(struct kvm_vcpu *v)
>  	if (!lapic_in_kernel(v))
>  		return v->arch.interrupt.nr;
>  
> +	if (kvm_xen_has_interrupt(v))
> +		return v->kvm->arch.xen.upcall_vector;
> +
>  	if (irqchip_split(v->kvm)) {
>  		int vector = v->arch.pending_external_vector;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ad9eea8f4f26..1711072b3616 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8891,7 +8891,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			kvm_x86_ops.msr_filter_changed(vcpu);
>  	}
>  
> -	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
> +	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
> +	    kvm_xen_has_interrupt(vcpu)) {
>  		++vcpu->stat.req_event;
>  		kvm_apic_accept_events(vcpu);
>  		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 4aa776c1ad57..116422d93d96 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -257,6 +257,22 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
>  	srcu_read_unlock(&v->kvm->srcu, idx);
>  }
>  
> +int kvm_xen_has_interrupt(struct kvm_vcpu *v)
> +{
> +       int rc = 0;
> +
> +       if (v->kvm->arch.xen.upcall_vector) {
> +               int idx = srcu_read_lock(&v->kvm->srcu);
> +               struct vcpu_info *vcpu_info = xen_vcpu_info(v);
> +
> +               if (vcpu_info && READ_ONCE(vcpu_info->evtchn_upcall_pending))
> +                       rc = 1;
> +
> +               srcu_read_unlock(&v->kvm->srcu, idx);
> +       }
> +       return rc;
> +}
> +
>  static int vcpu_attr_loc(struct kvm_vcpu *vcpu, u16 type,
>  			 struct kvm_host_map **map, void ***hva, size_t *sz)
>  {
> @@ -338,6 +354,14 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		break;
>  	}
>  
> +	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
> +		if (data->u.vector < 0x10)
> +			return -EINVAL;
> +
> +		kvm->arch.xen.upcall_vector = data->u.vector;
> +		r = 0;
> +		break;
> +
>  	default:
>  		break;
>  	}
> @@ -386,6 +410,11 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		break;
>  	}
>  
> +	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
> +		data->u.vector = kvm->arch.xen.upcall_vector;
> +		r = 0;
> +		break;
> +
>  	default:
>  		break;
>  	}
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> index ccd6002f55bc..1f599342f02c 100644
> --- a/arch/x86/kvm/xen.h
> +++ b/arch/x86/kvm/xen.h
> @@ -25,6 +25,7 @@ static inline struct kvm_vcpu *xen_vcpu_to_vcpu(struct kvm_vcpu_xen *xen_vcpu)
>  void kvm_xen_setup_pvclock_page(struct kvm_vcpu *vcpu);
>  void kvm_xen_setup_runstate_page(struct kvm_vcpu *vcpu);
>  void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu);
> +int kvm_xen_has_interrupt (struct kvm_vcpu *vcpu);
>  int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
>  int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
>  int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 1047364d1adf..113279fa9e1e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1587,6 +1587,7 @@ struct kvm_xen_hvm_attr {
>  
>  	union {
>  		__u8 long_mode;
> +		__u8 vector;
>  		struct {
>  			__u64 gfn;
>  		} shared_info;
> @@ -1604,6 +1605,7 @@ struct kvm_xen_hvm_attr {
>  #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
>  #define KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO	0x3
>  #define KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE		0x4
> +#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x5
>  
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
> 
