Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0BA77F5A2
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 13:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350436AbjHQLte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 07:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350542AbjHQLtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 07:49:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D234EE4F;
        Thu, 17 Aug 2023 04:49:12 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HBjsf8018502;
        Thu, 17 Aug 2023 11:49:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SvZrVlOqRvs5BYAafD/KEqqw70JFMkfSPYx+8+imxzs=;
 b=nubH/bfaUbRleGhp90HyjXsRA5IABwQyAC0karHFCbgpk08qKHtJg+C6R5l7mXWRmbDH
 bJSvff2m8uhl2Wd9Vi17dlmJLHsEiw9fAFhePZb1NQMTcA4+b3noykKRANHrwOxaUVRm
 4p/9njEeNlBGClb8i8Z3Wl0iWd1aQCOM46xPGZzOfmZT4chn53r/VsdSIAp1u5Tp3fYk
 tL8WNWq1v5tNN2qOAdQwKD93f6aN20y3lMPKTqP598wor7IzEot2+EXIUgi0/vZ3Mg0s
 DgWHfVmnrPVfAvw6VRjmM9DywRvxtWx65dzO81Ajzp1JX7eO9DVuWYrMRvxDGvJqvtY5 Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3shjy0g1ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 11:49:12 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37HBnB2S028347;
        Thu, 17 Aug 2023 11:49:11 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3shjy0g1b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 11:49:11 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37H9lRg3003456;
        Thu, 17 Aug 2023 11:49:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3semdsx848-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 11:49:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37HBn7mK21430982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 11:49:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E87E42004E;
        Thu, 17 Aug 2023 11:49:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E40020043;
        Thu, 17 Aug 2023 11:49:06 +0000 (GMT)
Received: from [9.152.224.236] (unknown [9.152.224.236])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 17 Aug 2023 11:49:06 +0000 (GMT)
Message-ID: <9863cec4-95a3-7e29-44f5-18138179cb62@linux.ibm.com>
Date:   Thu, 17 Aug 2023 13:49:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v4 3/4] KVM: s390: Add UV feature negotiation
To:     Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20230815151415.379760-1-seiden@linux.ibm.com>
 <20230815151415.379760-4-seiden@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20230815151415.379760-4-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6fpilrwlLTIP5FF7lFNHQ267H-sAakXL
X-Proofpoint-ORIG-GUID: x9kTuKYWZjKkCvE37l0SWzostEKyAjql
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_03,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308170104
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.23 17:14, Steffen Eiden wrote:
> Add a uv_feature list for pv-guests to the KVM cpu-model.
> The feature bits 'AP-interpretation for secure guests' and
> 'AP-interrupt for secure guests' are available.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

but a minor comment, see below.

> ---
>   arch/s390/include/asm/kvm_host.h |  2 +
>   arch/s390/include/uapi/asm/kvm.h | 16 +++++++
>   arch/s390/kvm/kvm-s390.c         | 73 ++++++++++++++++++++++++++++++++
>   3 files changed, 91 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 91bfecb91321..427f9528a7b6 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -817,6 +817,8 @@ struct kvm_s390_cpu_model {
>   	__u64 *fac_list;
>   	u64 cpuid;
>   	unsigned short ibc;
> +	/* subset of available UV-features for pv-guests enabled by user space */
> +	struct kvm_s390_vm_cpu_uv_feat uv_feat_guest;
>   };
> 
>   typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index a73cf01a1606..abe926d43cbe 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -159,6 +159,22 @@ struct kvm_s390_vm_cpu_subfunc {
>   	__u8 reserved[1728];
>   };
> 
> +#define KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST	6
> +#define KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST	7
> +
> +#define KVM_S390_VM_CPU_UV_FEAT_NR_BITS	64
> +struct kvm_s390_vm_cpu_uv_feat {
> +	union {
> +		struct {
> +			__u64 : 4;
> +			__u64 ap : 1;		/* bit 4 */
> +			__u64 ap_intr : 1;	/* bit 5 */
> +			__u64 : 58;
> +		};
> +		__u64 feat;
> +	};
> +};
> +
>   /* kvm attributes for crypto */
>   #define KVM_S390_VM_CRYPTO_ENABLE_AES_KW	0
>   #define KVM_S390_VM_CRYPTO_ENABLE_DEA_KW	1
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 813cc3d59c90..b3f17e014cab 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1531,6 +1531,39 @@ static int kvm_s390_set_processor_subfunc(struct kvm *kvm,
>   	return 0;
>   }
> 
> +#define KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK	\
> +(						\
> +	((struct kvm_s390_vm_cpu_uv_feat){	\
> +		.ap = 1,			\
> +		.ap_intr = 1,			\
> +	})					\
> +	.feat					\
> +)
> +
> +static int kvm_s390_set_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	struct kvm_s390_vm_cpu_uv_feat __user *ptr = (void __user *)attr->addr;
> +	unsigned long data, filter;
> +
> +	filter = uv_info.uv_feature_indications & KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;

if get_user() fails the uv feature bits in "filter" are
calculated in vain

> +	if (get_user(data, &ptr->feat))
> +		return -EFAULT;

could be done here, but that's really minor to me

> +	if (!bitmap_subset(&data, &filter, KVM_S390_VM_CPU_UV_FEAT_NR_BITS))
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +	if (kvm->created_vcpus) {
> +		mutex_unlock(&kvm->lock);
> +		return -EBUSY;
> +	}
> +	kvm->arch.model.uv_feat_guest.feat = data;
> +	mutex_unlock(&kvm->lock);
> +
> +	VM_EVENT(kvm, 3, "SET: guest UV-feat: 0x%16.16lx", data);
> +
> +	return 0;
> +}
> +
>   static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>   {
>   	int ret = -ENXIO;
> @@ -1545,6 +1578,9 @@ static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>   	case KVM_S390_VM_CPU_PROCESSOR_SUBFUNC:
>   		ret = kvm_s390_set_processor_subfunc(kvm, attr);
>   		break;
> +	case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
> +		ret = kvm_s390_set_uv_feat(kvm, attr);
> +		break;
>   	}
>   	return ret;
>   }
> @@ -1777,6 +1813,33 @@ static int kvm_s390_get_machine_subfunc(struct kvm *kvm,
>   	return 0;
>   }
> 
> +static int kvm_s390_get_processor_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	struct kvm_s390_vm_cpu_uv_feat __user *dst = (void __user *)attr->addr;
> +	unsigned long feat = kvm->arch.model.uv_feat_guest.feat;
> +
> +	if (put_user(feat, &dst->feat))
> +		return -EFAULT;
> +	VM_EVENT(kvm, 3, "GET: guest UV-feat: 0x%16.16lx", feat);
> +
> +	return 0;
> +}
> +
> +static int kvm_s390_get_machine_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	struct kvm_s390_vm_cpu_uv_feat __user *dst = (void __user *)attr->addr;
> +	unsigned long feat;
> +
> +	BUILD_BUG_ON(sizeof(*dst) != sizeof(uv_info.uv_feature_indications));
> +
> +	feat = uv_info.uv_feature_indications & KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;
> +	if (put_user(feat, &dst->feat))
> +		return -EFAULT;
> +	VM_EVENT(kvm, 3, "GET: guest UV-feat: 0x%16.16lx", feat);
> +
> +	return 0;
> +}
> +
>   static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>   {
>   	int ret = -ENXIO;
> @@ -1800,6 +1863,12 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>   	case KVM_S390_VM_CPU_MACHINE_SUBFUNC:
>   		ret = kvm_s390_get_machine_subfunc(kvm, attr);
>   		break;
> +	case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
> +		ret = kvm_s390_get_processor_uv_feat(kvm, attr);
> +		break;
> +	case KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST:
> +		ret = kvm_s390_get_machine_uv_feat(kvm, attr);
> +		break;
>   	}
>   	return ret;
>   }
> @@ -1952,6 +2021,8 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>   		case KVM_S390_VM_CPU_MACHINE_FEAT:
>   		case KVM_S390_VM_CPU_MACHINE_SUBFUNC:
>   		case KVM_S390_VM_CPU_PROCESSOR_SUBFUNC:
> +		case KVM_S390_VM_CPU_MACHINE_UV_FEAT_GUEST:
> +		case KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST:
>   			ret = 0;
>   			break;
>   		default:
> @@ -3296,6 +3367,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
>   	kvm->arch.model.ibc = sclp.ibc & 0x0fff;
> 
> +	kvm->arch.model.uv_feat_guest.feat = 0;
> +
>   	kvm_s390_crypto_init(kvm);
> 
>   	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
