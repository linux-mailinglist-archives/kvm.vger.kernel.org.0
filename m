Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841FD765708
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 17:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbjG0PK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 11:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbjG0PK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 11:10:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA36FD;
        Thu, 27 Jul 2023 08:10:25 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36RF3bT2011115;
        Thu, 27 Jul 2023 15:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jYolTo5yzhUDm4bH36rF7ixNA0wJ58vXdRhnf1d7LFQ=;
 b=p9enl8WXIn9Gfi/Feikvcn6Mm5cSLu5F1DD3VKIETqKPJC20fSv3g3uPVE1RpK52kqsE
 4qFXWkIkaDQ39XccOA3T+XwLmdPGsF9Bw6NZZxSnem9/HffQ3EHs3GYbkb6tmUUpCUOH
 l+wolXl6ofvyNBXrYIhdNYLHr6tqWnRuTYfNWVl+MWMQYhWgCki8IUFaF7eNpkLGWekx
 utzWRWwB9g9RriSS04HHRKzsqRWnsZ+0Wos/p8NXOjwotM5wI9La/IWZl2bpRvT3siIs
 3cX3g9KAVYe37HXMbpp0EMYIH6ye7968+HjJe9quahsZowxW0Ces3rd3so7hie9vlI1U mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3tw1rjae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:10:23 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36RF4DN7014300;
        Thu, 27 Jul 2023 15:08:39 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3tw1rd67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:08:39 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36REXUfH002379;
        Thu, 27 Jul 2023 15:07:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0unjx2mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:07:34 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36RF7V3i18678350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 15:07:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF5A420040;
        Thu, 27 Jul 2023 15:07:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 845F12004B;
        Thu, 27 Jul 2023 15:07:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jul 2023 15:07:31 +0000 (GMT)
Date:   Thu, 27 Jul 2023 17:02:23 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: [PATCH 2/3] KVM: s390: Add UV feature negotiation
Message-ID: <20230727170223.387c9cf6@p-imbrenda>
In-Reply-To: <20230727122053.774473-3-seiden@linux.ibm.com>
References: <20230727122053.774473-1-seiden@linux.ibm.com>
        <20230727122053.774473-3-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Qp5wO5ICRaUKx-8UkOufRRhXUiUZCbFr
X-Proofpoint-GUID: R8xUXexyzwsrcU3CSVDKPnDU8XnJhPij
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_07,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jul 2023 14:20:52 +0200
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Add a uv_feature list for pv-guests to the kvm cpu-model.
> The feature bits 'AP-interpretation for secure guests' and
> 'AP-interrupt for secure guests' are available.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  2 +
>  arch/s390/include/uapi/asm/kvm.h | 24 +++++++++++
>  arch/s390/kvm/kvm-s390.c         | 70 ++++++++++++++++++++++++++++++++
>  3 files changed, 96 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 2bbc3d54959d..7ae57ac352b2 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -817,6 +817,8 @@ struct kvm_s390_cpu_model {
>  	__u64 *fac_list;
>  	u64 cpuid;
>  	unsigned short ibc;
> +	/* subset of available uv features for pv-guests enabled by user space */
> +	struct kvm_s390_vm_cpu_uv_feat uv_feat_guest;
>  };
>  
>  typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index a73cf01a1606..7ea7e4fbd37e 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -159,6 +159,30 @@ struct kvm_s390_vm_cpu_subfunc {
>  	__u8 reserved[1728];
>  };
>  
> +#define KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST	6
> +#define KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST	7
> +
> +#define KVM_S390_VM_CPU_UV_FEAT_NR_BITS	64
> +struct kvm_s390_vm_cpu_uv_feat {
> +	union {
> +		struct {
> +			__u64 res0 : 4;
> +			__u64 ap : 1;		/* bit 4 */
> +			__u64 ap_intr : 1;	/* bit 5 */

I would put padding here for completeness, and maybe a static assert
for the size of struct kvm_s390_vm_cpu_uv_feat

> +		};
> +		__u64 feat;
> +	};
> +};
> +
> +#define KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK \
> +(((struct kvm_s390_vm_cpu_uv_feat) {	\
> +	.ap = 1,		\
> +	.ap_intr = 1,		\
> +}).feat)

please indent the body of the macro, and add tabs on the right so that
the \ are aligned

> +
> +#define KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT \
> +((struct kvm_s390_vm_cpu_uv_feat) { })

please indent the body of the macro

> +
>  /* kvm attributes for crypto */
>  #define KVM_S390_VM_CRYPTO_ENABLE_AES_KW	0
>  #define KVM_S390_VM_CRYPTO_ENABLE_DEA_KW	1
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 339e3190f6dc..50c8b85b89ac 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1531,6 +1531,32 @@ static int kvm_s390_set_processor_subfunc(struct kvm *kvm,
>  	return 0;
>  }
>  
> +static int kvm_s390_set_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	struct kvm_s390_vm_cpu_uv_feat data = {};
> +	unsigned long filter =
> +		uv_info.uv_feature_indications &

I think this can go in the previous line?

> +		(unsigned long)KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;

the cast is not necessary

without the cast the whole thing can fit in one line

> +
> +	if (copy_from_user(&data, (void __user *)attr->addr, sizeof(data)))
> +		return -EFAULT;
> +	if (!bitmap_subset((unsigned long *)&data, &filter,
> +			   KVM_S390_VM_CPU_UV_FEAT_NR_BITS))

this also fits in one line :)

> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +	if (kvm->created_vcpus) {
> +		mutex_unlock(&kvm->lock);
> +		return -EBUSY;
> +	}
> +	kvm->arch.model.uv_feat_guest = data;
> +	mutex_unlock(&kvm->lock);
> +
> +	VM_EVENT(kvm, 3, "SET: guest uv feat: 0x%16.16llx", data.feat);
> +
> +	return 0;
> +}
> +
>  static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>  {
>  	int ret = -ENXIO;
> @@ -1545,6 +1571,9 @@ static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>  	case KVM_S390_VM_CPU_PROCESSOR_SUBFUNC:
>  		ret = kvm_s390_set_processor_subfunc(kvm, attr);
>  		break;
> +	case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
> +		ret = kvm_s390_set_uv_feat(kvm, attr);
> +		break;
>  	}
>  	return ret;
>  }
> @@ -1777,6 +1806,37 @@ static int kvm_s390_get_machine_subfunc(struct kvm *kvm,
>  	return 0;
>  }
>  
> +static int kvm_s390_get_processor_uv_feat(struct kvm *kvm,
> +					  struct kvm_device_attr *attr)
> +{
> +	struct kvm_s390_vm_cpu_uv_feat *src = &kvm->arch.model.uv_feat_guest;
> +
> +	if (copy_to_user((void __user *)attr->addr, src, sizeof(*src)))
> +		return -EFAULT;
> +	VM_EVENT(kvm, 3, "GET: guest  uv feat: 0x%16.16llx",
> +		 kvm->arch.model.uv_feat_guest.feat);

this can actually fit in one line

> +
> +	return 0;
> +}
> +
> +static int kvm_s390_get_machine_uv_feat(struct kvm *kvm,
> +					struct kvm_device_attr *attr)
> +{
> +	struct kvm_s390_vm_cpu_uv_feat data = {
> +		.feat = uv_info.uv_feature_indications &
> +			KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK

this can fit in one line

> +	};
> +
> +	BUILD_BUG_ON(sizeof(struct kvm_s390_vm_cpu_uv_feat) !=
> +		     sizeof(uv_info.uv_feature_indications));
> +	if (copy_to_user((void __user *)attr->addr, &data,
> +			 sizeof(struct kvm_s390_vm_cpu_uv_feat)))

why not sizeof(data) ?

(also, it can fit in one line)

> +		return -EFAULT;
> +	VM_EVENT(kvm, 3, "GET: guest  uv feat: 0x%16.16llx", data.feat);
> +
> +	return 0;
> +}
> +
>  static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>  {
>  	int ret = -ENXIO;
> @@ -1800,6 +1860,12 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>  	case KVM_S390_VM_CPU_MACHINE_SUBFUNC:
>  		ret = kvm_s390_get_machine_subfunc(kvm, attr);
>  		break;
> +	case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
> +		ret = kvm_s390_get_processor_uv_feat(kvm, attr);
> +		break;
> +	case KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST:
> +		ret = kvm_s390_get_machine_uv_feat(kvm, attr);
> +		break;
>  	}
>  	return ret;
>  }
> @@ -1952,6 +2018,8 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>  		case KVM_S390_VM_CPU_MACHINE_FEAT:
>  		case KVM_S390_VM_CPU_MACHINE_SUBFUNC:
>  		case KVM_S390_VM_CPU_PROCESSOR_SUBFUNC:
> +		case KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST:
> +		case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
>  			ret = 0;
>  			break;
>  		default:
> @@ -3292,6 +3360,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
>  	kvm->arch.model.ibc = sclp.ibc & 0x0fff;
>  
> +	kvm->arch.model.uv_feat_guest = KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT;
> +
>  	kvm_s390_crypto_init(kvm);
>  
>  	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {

