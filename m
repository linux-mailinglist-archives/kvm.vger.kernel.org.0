Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A9A2D032A
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 12:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgLFLFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 06:05:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727240AbgLFLFH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 06:05:07 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B6B1paB190212;
        Sun, 6 Dec 2020 06:04:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rN8fHcG/T0Qpa/YTQcACtLKYRpVBLj9zTPB1mLnAvro=;
 b=XtFvm9gTFs3ok/vO9ePN4zr3DXroIV3q1WFwpRO2zgU/TUQkKPIqjr+Zg6C5vgEj34wr
 FqNQ0BJTXkBhOJnE8i18D7J7K9bniXz2uxK4XY5mxLv8eon/piGmmholGSv0YsvjVkih
 DSHx/Nct61gYI86w2+1dBeo3qsWKcbvwqkumrB88v/UQX4Wr4VflbXHIRYAokD8YhGbk
 0t5yRkgz4sOovGCaeqPEGKNiRWeiGfQASv7m7UWimnHvIyzaXESIxmUI5f+OE6XKaV2w
 0jkJEgh+vBaJCquwounbxznJY8AIbVHBERcYxx0CWdGnvOvYS3ykIQw/ZJ2zZ/CadcL6 Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 358vvx11sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Dec 2020 06:04:13 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B6B1vps190545;
        Sun, 6 Dec 2020 06:04:13 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 358vvx11rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Dec 2020 06:04:12 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B6B3Vxk000572;
        Sun, 6 Dec 2020 11:04:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8hjp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Dec 2020 11:04:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B6B2s5R62325104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Dec 2020 11:02:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C2FAAE045;
        Sun,  6 Dec 2020 11:02:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB3B9AE055;
        Sun,  6 Dec 2020 11:02:48 +0000 (GMT)
Received: from [9.160.44.3] (unknown [9.160.44.3])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  6 Dec 2020 11:02:48 +0000 (GMT)
Subject: Re: [PATCH v2 3/9] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <9b9f786817ed2aaf77d44f257e468df800b999d0.1606782580.git.ashish.kalra@amd.com>
From:   Dov Murik <dovmurik@linux.vnet.ibm.com>
Message-ID: <b10e6d9e-74cc-a096-fdb1-983cbd128f7e@linux.vnet.ibm.com>
Date:   Sun, 6 Dec 2020 13:02:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <9b9f786817ed2aaf77d44f257e468df800b999d0.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-06_06:2020-12-04,2020-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 suspectscore=2 mlxlogscore=999 spamscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/12/2020 2:47, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The ioctl can be used to retrieve page encryption bitmap for a given
> gfn range.
> 
> Return the correct bitmap as per the number of pages being requested
> by the user. Ensure that we only copy bmap->num_pages bytes in the
> userspace buffer, if bmap->num_pages is not byte aligned we read
> the trailing bits from the userspace and copy those bits as is.

I think you meant to say "Ensure that we only copy bmap->num_pages 
*bits* in the userspace buffer".  But maybe I'm missed something.


> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   Documentation/virt/kvm/api.rst  | 27 +++++++++++++
>   arch/x86/include/asm/kvm_host.h |  2 +
>   arch/x86/kvm/svm/sev.c          | 70 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c          |  1 +
>   arch/x86/kvm/svm/svm.h          |  1 +
>   arch/x86/kvm/x86.c              | 12 ++++++
>   include/uapi/linux/kvm.h        | 12 ++++++
>   7 files changed, 125 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 70254eaa5229..ae410f4332ab 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4671,6 +4671,33 @@ This ioctl resets VCPU registers and control structures according to
>   the clear cpu reset definition in the POP. However, the cpu is not put
>   into ESA mode. This reset is a superset of the initial reset.
> 
> +4.125 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
> +---------------------------------------
> +
> +:Capability: basic
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_page_enc_bitmap (in/out)
> +:Returns: 0 on success, -1 on error
> +
> +/* for KVM_GET_PAGE_ENC_BITMAP */
> +struct kvm_page_enc_bitmap {
> +	__u64 start_gfn;
> +	__u64 num_pages;
> +	union {
> +		void __user *enc_bitmap; /* one bit per page */
> +		__u64 padding2;
> +	};
> +};
> +
> +The encrypted VMs have the concept of private and shared pages. The private
> +pages are encrypted with the guest-specific key, while the shared pages may
> +be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
> +be used to get the bitmap indicating whether the guest page is private
> +or shared. The bitmap can be used during the guest migration. If the page
> +is private then the userspace need to use SEV migration commands to transmit
> +the page.
> +
> 
>   4.125 KVM_S390_PV_COMMAND
>   -------------------------
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d035dc983a7a..8c2e40199ecb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1284,6 +1284,8 @@ struct kvm_x86_ops {
>   	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
>   	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
>   				  unsigned long sz, unsigned long mode);
> +	int (*get_page_enc_bitmap)(struct kvm *kvm,
> +				struct kvm_page_enc_bitmap *bmap);
>   };
> 
>   struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6b8bc1297f9c..a6586dd29767 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1014,6 +1014,76 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>   	return 0;
>   }
> 
> +int svm_get_page_enc_bitmap(struct kvm *kvm,
> +				   struct kvm_page_enc_bitmap *bmap)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	unsigned long gfn_start, gfn_end;
> +	unsigned long sz, i, sz_bytes;
> +	unsigned long *bitmap;
> +	int ret, n;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	gfn_start = bmap->start_gfn;
> +	gfn_end = gfn_start + bmap->num_pages;
> +
> +	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / BITS_PER_BYTE;
> +	bitmap = kmalloc(sz, GFP_KERNEL);

Maybe use bitmap_alloc which accepts size in bits (and corresponding 
bitmap_free)?


> +	if (!bitmap)
> +		return -ENOMEM;
> +
> +	/* by default all pages are marked encrypted */
> +	memset(bitmap, 0xff, sz);

Maybe use bitmap_fill to clarify the intent?


> +
> +	mutex_lock(&kvm->lock);
> +	if (sev->page_enc_bmap) {
> +		i = gfn_start;
> +		for_each_clear_bit_from(i, sev->page_enc_bmap,
> +				      min(sev->page_enc_bmap_size, gfn_end))
> +			clear_bit(i - gfn_start, bitmap);
> +	}
> +	mutex_unlock(&kvm->lock);
> +
> +	ret = -EFAULT;
> +
> +	n = bmap->num_pages % BITS_PER_BYTE;
> +	sz_bytes = ALIGN(bmap->num_pages, BITS_PER_BYTE) / BITS_PER_BYTE;

Maybe clearer:

	sz_bytes = BITS_TO_BYTES(bmap->num_pages);



> +
> +	/*
> +	 * Return the correct bitmap as per the number of pages being
> +	 * requested by the user. Ensure that we only copy bmap->num_pages
> +	 * bytes in the userspace buffer, if bmap->num_pages is not byte
> +	 * aligned we read the trailing bits from the userspace and copy
> +	 * those bits as is.
> +	 */

(see my comment on the commit message above.)


> +
> +	if (n) {
> +		unsigned char *bitmap_kernel = (unsigned char *)bitmap;
> +		unsigned char bitmap_user;
> +		unsigned long offset, mask;
> +
> +		offset = bmap->num_pages / BITS_PER_BYTE;
> +		if (copy_from_user(&bitmap_user, bmap->enc_bitmap + offset,
> +				sizeof(unsigned char)))
> +			goto out;
> +
> +		mask = GENMASK(n - 1, 0);
> +		bitmap_user &= ~mask;
> +		bitmap_kernel[offset] &= mask;
> +		bitmap_kernel[offset] |= bitmap_user;
> +	}
> +
> +	if (copy_to_user(bmap->enc_bitmap, bitmap, sz_bytes))
> +		goto out;
> +
> +	ret = 0;
> +out:
> +	kfree(bitmap);
> +	return ret;
> +}
> +
>   int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7122ea5f7c47..bff89cab3ed0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4314,6 +4314,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.msr_filter_changed = svm_msr_filter_changed,
> 
>   	.page_enc_status_hc = svm_page_enc_status_hc,
> +	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
>   };
> 
>   static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0103a23ca174..4ce73f1034b9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -413,6 +413,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm);
>   void sync_nested_vmcb_control(struct vcpu_svm *svm);
>   int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>                              unsigned long npages, unsigned long enc);
> +int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
> 
>   extern struct kvm_x86_nested_ops svm_nested_ops;
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3afc78f18f69..d3cb95a4dd55 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5695,6 +5695,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   	case KVM_X86_SET_MSR_FILTER:
>   		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
>   		break;
> +	case KVM_GET_PAGE_ENC_BITMAP: {
> +		struct kvm_page_enc_bitmap bitmap;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> +			goto out;
> +
> +		r = -ENOTTY;
> +		if (kvm_x86_ops.get_page_enc_bitmap)
> +			r = kvm_x86_ops.get_page_enc_bitmap(kvm, &bitmap);
> +		break;
> +	}
>   	default:
>   		r = -ENOTTY;
>   	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 886802b8ffba..d0b9171bdb03 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -532,6 +532,16 @@ struct kvm_dirty_log {
>   	};
>   };
> 
> +/* for KVM_GET_PAGE_ENC_BITMAP */
> +struct kvm_page_enc_bitmap {
> +	__u64 start_gfn;
> +	__u64 num_pages;
> +	union {
> +		void __user *enc_bitmap; /* one bit per page */
> +		__u64 padding2;
> +	};
> +};
> +
>   /* for KVM_CLEAR_DIRTY_LOG */
>   struct kvm_clear_dirty_log {
>   	__u32 slot;
> @@ -1563,6 +1573,8 @@ struct kvm_pv_cmd {
>   /* Available with KVM_CAP_DIRTY_LOG_RING */
>   #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
> 
> +#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)

I see that kvm/next already defines ioctls numbered 0xc6 and 0xc7. 
Wouldn't these new ioctls (KVM_GET_PAGE_ENC_BITMAP, 
KVM_SET_PAGE_ENC_BITMAP) collide?


> +
>   /* Secure Encrypted Virtualization command */
>   enum sev_cmd_id {
>   	/* Guest initialization commands */
> 

-Dov
