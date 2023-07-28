Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BBA7670C4
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 17:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbjG1Pip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 11:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbjG1Pin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 11:38:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157D1423B;
        Fri, 28 Jul 2023 08:38:33 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36SFX0Ho019213;
        Fri, 28 Jul 2023 15:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=aYIe8cXnwBcu9hL41BIRVXoh+9k8acahzJe1iW/9NTw=;
 b=MFNsBDrGWPxD/twdCZTjo/NRqwmewqpWNm1kid1jwnlDF52V2Dfa3CBxrmEHVAQjQFPV
 fh2b6VD2gcKa/akHx5BMNApMCr+1m+5BOYfKnvGem/dMvjNfSffNv9djkolYwwcARseD
 qdnHohD7RvF170JLzsFzWv9YMRe68p5lJ3emkpb40qP3yZTAJeI/CyrIG8uwgv/NuOLG
 7BEOxzexlXm/bniG3Sc420dZB/bbNO8tmK80CsOeX6kCRSGBSu8IIwpQAaLuvx2Klc9P
 gkqk1Y2iohG/eX0PXAwgSH/sIEPlASCkXcuxXa0va+XMdY7hSxkBITb6VKOUbU8y+Nyx kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4g4tgrfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 15:38:30 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36SFXqAW022918;
        Fri, 28 Jul 2023 15:37:37 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4g4tgpv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 15:37:36 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36SE1pIm002024;
        Fri, 28 Jul 2023 15:36:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0tenq64v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 15:36:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36SFaLdV4653606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 15:36:21 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18FB02004D;
        Fri, 28 Jul 2023 15:36:21 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AD6620040;
        Fri, 28 Jul 2023 15:36:20 +0000 (GMT)
Received: from osiris (unknown [9.171.95.61])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 28 Jul 2023 15:36:20 +0000 (GMT)
Date:   Fri, 28 Jul 2023 17:36:19 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: [PATCH v2 2/3] KVM: s390: Add UV feature negotiation
Message-ID: <20230728153619.13110-B-hca@linux.ibm.com>
References: <20230728092341.1131787-1-seiden@linux.ibm.com>
 <20230728092341.1131787-3-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728092341.1131787-3-seiden@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0xoLcFLCbhx2lDcDaVofVF8-SPQVw3Ig
X-Proofpoint-ORIG-GUID: l_RzcLpRHK8B2XvyGIrorDXMjQ_kQz8z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307280142
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 11:23:40AM +0200, Steffen Eiden wrote:
> Add a uv_feature list for pv-guests to the kvm cpu-model.
> The feature bits 'AP-interpretation for secure guests' and
> 'AP-interrupt for secure guests' are available.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  2 ++
>  arch/s390/include/uapi/asm/kvm.h | 25 +++++++++++++
>  arch/s390/kvm/kvm-s390.c         | 60 ++++++++++++++++++++++++++++++++
>  3 files changed, 87 insertions(+)
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
> index a73cf01a1606..b7f4bf5687c7 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -159,6 +159,31 @@ struct kvm_s390_vm_cpu_subfunc {
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
> +			__u64 res6 : 58;

Using unnamed bitfields makes life easier.

> +#define KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK  \
> +	(((struct kvm_s390_vm_cpu_uv_feat){ \
> +		  .ap = 1,                  \
> +		  .ap_intr = 1,             \
> +	  })                                \
> +		 .feat)
> +
> +#define KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT ((struct kvm_s390_vm_cpu_uv_feat){})

Why are these two define uapi? Looks to me like both should be kernel
internal. Or why should user space know about them?

Also I think KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT is really odd
compared to all other code we have. Defining it to just 0 and assiging
to .feat instead of assigning a structure is the "usual way".

> +static int kvm_s390_set_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	struct kvm_s390_vm_cpu_uv_feat data = {};
> +	unsigned long filter = uv_info.uv_feature_indications & KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;
> +
> +	if (copy_from_user(&data, (void __user *)attr->addr, sizeof(data)))
> +		return -EFAULT;
> +	if (!bitmap_subset((unsigned long *)&data, &filter, KVM_S390_VM_CPU_UV_FEAT_NR_BITS))
> +		return -EINVAL;

Casting a structure to an unsinged long pointer is also quite odd. I'd
would use get_user() & friends, and avoid all the casts. Patch below is
something I would do, also in order to reduce line lengths and breaks at
some places.. Feel free to ignore the whole patch, or take parts or all of
it (patch is on top of your complete series, and of course untested).

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index b7f4bf5687c7..c1b84c1a297d 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -166,23 +166,25 @@ struct kvm_s390_vm_cpu_subfunc {
 struct kvm_s390_vm_cpu_uv_feat {
 	union {
 		struct {
-			__u64 res0 : 4;
+			__u64 : 4;
 			__u64 ap : 1;		/* bit 4 */
 			__u64 ap_intr : 1;	/* bit 5 */
-			__u64 res6 : 58;
+			__u64 : 58;
 		};
 		__u64 feat;
 	};
 };
 
-#define KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK  \
-	(((struct kvm_s390_vm_cpu_uv_feat){ \
-		  .ap = 1,                  \
-		  .ap_intr = 1,             \
-	  })                                \
-		 .feat)
+#define KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK	\
+(						\
+	((struct kvm_s390_vm_cpu_uv_feat){	\
+		.ap = 1,			\
+		.ap_intr = 1,			\
+	})					\
+	.feat					\
+)
 
-#define KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT ((struct kvm_s390_vm_cpu_uv_feat){})
+#define KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT	0
 
 /* kvm attributes for crypto */
 #define KVM_S390_VM_CRYPTO_ENABLE_AES_KW	0
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f383c48f965a..bbf4de3e27b3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1533,12 +1533,13 @@ static int kvm_s390_set_processor_subfunc(struct kvm *kvm,
 
 static int kvm_s390_set_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
 {
-	struct kvm_s390_vm_cpu_uv_feat data = {};
-	unsigned long filter = uv_info.uv_feature_indications & KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;
+	struct kvm_s390_vm_cpu_uv_feat __user *ptr = (void __user *)attr->addr;
+	unsigned long data, filter;
 
-	if (copy_from_user(&data, (void __user *)attr->addr, sizeof(data)))
+	filter = uv_info.uv_feature_indications & KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;
+	if (get_user(data, &ptr->feat))
 		return -EFAULT;
-	if (!bitmap_subset((unsigned long *)&data, &filter, KVM_S390_VM_CPU_UV_FEAT_NR_BITS))
+	if (!bitmap_subset(&data, &filter, KVM_S390_VM_CPU_UV_FEAT_NR_BITS))
 		return -EINVAL;
 
 	mutex_lock(&kvm->lock);
@@ -1546,10 +1547,10 @@ static int kvm_s390_set_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
 		mutex_unlock(&kvm->lock);
 		return -EBUSY;
 	}
-	kvm->arch.model.uv_feat_guest = data;
+	kvm->arch.model.uv_feat_guest.feat = data;
 	mutex_unlock(&kvm->lock);
 
-	VM_EVENT(kvm, 3, "SET: guest uv feat: 0x%16.16llx", data.feat);
+	VM_EVENT(kvm, 3, "SET: guest uv feat: 0x%16.16lx", data);
 
 	return 0;
 }
@@ -1805,24 +1806,27 @@ static int kvm_s390_get_machine_subfunc(struct kvm *kvm,
 
 static int kvm_s390_get_processor_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
 {
-	struct kvm_s390_vm_cpu_uv_feat *src = &kvm->arch.model.uv_feat_guest;
+	struct kvm_s390_vm_cpu_uv_feat __user *dst = (void __user *)attr->addr;
+	unsigned long feat = kvm->arch.model.uv_feat_guest.feat;
 
-	if (copy_to_user((void __user *)attr->addr, src, sizeof(*src)))
+	if (put_user(feat, &dst->feat))
 		return -EFAULT;
-	VM_EVENT(kvm, 3, "GET: guest  uv feat: 0x%16.16llx", kvm->arch.model.uv_feat_guest.feat);
+	VM_EVENT(kvm, 3, "GET: guest  uv feat: 0x%16.16lx", feat);
 
 	return 0;
 }
 
 static int kvm_s390_get_machine_uv_feat(struct kvm *kvm, struct kvm_device_attr *attr)
 {
-	struct kvm_s390_vm_cpu_uv_feat data = { .feat = uv_info.uv_feature_indications &
-							KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK };
+	struct kvm_s390_vm_cpu_uv_feat __user *dst = (void __user *)attr->addr;
+	unsigned long feat;
 
-	BUILD_BUG_ON(sizeof(data) != sizeof(uv_info.uv_feature_indications));
-	if (copy_to_user((void __user *)attr->addr, &data, sizeof(struct kvm_s390_vm_cpu_uv_feat)))
+	BUILD_BUG_ON(sizeof(*dst) != sizeof(uv_info.uv_feature_indications));
+
+	feat = uv_info.uv_feature_indications & KVM_S390_VM_CPU_UV_FEAT_GUEST_MASK;
+	if (put_user(feat, &dst->feat))
 		return -EFAULT;
-	VM_EVENT(kvm, 3, "GET: guest  uv feat: 0x%16.16llx", data.feat);
+	VM_EVENT(kvm, 3, "GET: guest  uv feat: 0x%16.16lx", feat);
 
 	return 0;
 }
@@ -3354,7 +3358,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
 	kvm->arch.model.ibc = sclp.ibc & 0x0fff;
 
-	kvm->arch.model.uv_feat_guest = KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT;
+	kvm->arch.model.uv_feat_guest.feat = KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT;
 
 	kvm_s390_crypto_init(kvm);
 
