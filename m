Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC5E111C0F
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 23:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfLCWjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 17:39:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbfLCWju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3MYHvC121211;
        Tue, 3 Dec 2019 22:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=tSVDaXG1z3o19ClL4i8OhDXRKg0w6kltU7z2gg3zfbU=;
 b=sCFYC8i+TLx6JYTzCrX9BjRnwyf9dkseF21RM2exx8DBReEjnMn0G7d4ozDpT41sPple
 LqLsPMrL0tyGx1GnsHQy6EGyS3qH/fYuEZLvVg8q37FbWQqekjk0L7a4dNcimIW75XHb
 zOsMBOMtCr+VcONwVF1hbrHelTV+RoQDUdF4Lfp+WPa9RBeDGo0qw4ccaYrxtXaoSaly
 E+y5PSwcmoKWUKlnEiF5rsovTKZudy9Cnwdnw6WA/I/fKLTrh3DYC3goDOCiDGCsEhV4
 7gC3LIdvTeFwS/IY6iIOKxEY82wBOxKKuzH+D/9mndHyvhjFpDOZvJ7MPQpRJqUnWG/h 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wkgcqatmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 22:39:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3MY8lB188831;
        Tue, 3 Dec 2019 22:39:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wnb81trh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 22:39:46 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB3MdjLx018064;
        Tue, 3 Dec 2019 22:39:45 GMT
Received: from [192.168.14.112] (/109.66.202.5)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 14:39:44 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] kvm: vmx: Stop wasting a page for guest_msrs
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191203210825.26827-1-jmattson@google.com>
Date:   Wed, 4 Dec 2019 00:39:42 +0200
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F7E1E7A1-47E0-4F2F-AED6-31B2B9A49F59@oracle.com>
References: <20191203210825.26827-1-jmattson@google.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 3 Dec 2019, at 23:08, Jim Mattson <jmattson@google.com> wrote:
>=20
> We will never need more guest_msrs than there are indices in
> vmx_msr_index. Thus, at present, the guest_msrs array will not exceed
> 168 bytes.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>

Weird that this wasn=E2=80=99t always like this :)
Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

> ---
> arch/x86/kvm/vmx/vmx.c | 14 ++------------
> arch/x86/kvm/vmx/vmx.h |  8 +++++++-
> 2 files changed, 9 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1b9ab4166397d..0b3c7524456f1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -443,7 +443,7 @@ static unsigned long host_idt_base;
>  * support this emulation, IA32_STAR must always be included in
>  * vmx_msr_index[], even in i386 builds.
>  */
> -const u32 vmx_msr_index[] =3D {
> +const u32 vmx_msr_index[NR_GUEST_MSRS] =3D {
> #ifdef CONFIG_X86_64
> 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
> #endif
> @@ -6666,7 +6666,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
> 	free_vpid(vmx->vpid);
> 	nested_vmx_free_vcpu(vcpu);
> 	free_loaded_vmcs(vmx->loaded_vmcs);
> -	kfree(vmx->guest_msrs);
> 	kvm_vcpu_uninit(vcpu);
> 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
> 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
> @@ -6723,13 +6722,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct =
kvm *kvm, unsigned int id)
> 			goto uninit_vcpu;
> 	}
>=20
> -	vmx->guest_msrs =3D kmalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
> -	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) * =
sizeof(vmx->guest_msrs[0])
> -		     > PAGE_SIZE);
> -
> -	if (!vmx->guest_msrs)
> -		goto free_pml;
> -
> 	for (i =3D 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
> 		u32 index =3D vmx_msr_index[i];
> 		u32 data_low, data_high;
> @@ -6760,7 +6752,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct =
kvm *kvm, unsigned int id)
>=20
> 	err =3D alloc_loaded_vmcs(&vmx->vmcs01);
> 	if (err < 0)
> -		goto free_msrs;
> +		goto free_pml;
>=20
> 	msr_bitmap =3D vmx->vmcs01.msr_bitmap;
> 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, =
MSR_TYPE_R);
> @@ -6822,8 +6814,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct =
kvm *kvm, unsigned int id)
>=20
> free_vmcs:
> 	free_loaded_vmcs(vmx->loaded_vmcs);
> -free_msrs:
> -	kfree(vmx->guest_msrs);
> free_pml:
> 	vmx_destroy_pml_buffer(vmx);
> uninit_vcpu:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 7c1b978b2df44..08bc24fa59909 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -22,6 +22,12 @@ extern u32 get_umwait_control_msr(void);
>=20
> #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
>=20
> +#ifdef CONFIG_X86_64
> +#define NR_GUEST_MSRS	7
> +#else
> +#define NR_GUEST_MSRS	4
> +#endif
> +
> #define NR_LOADSTORE_MSRS 8
>=20
> struct vmx_msrs {
> @@ -206,7 +212,7 @@ struct vcpu_vmx {
> 	u32                   idt_vectoring_info;
> 	ulong                 rflags;
>=20
> -	struct shared_msr_entry *guest_msrs;
> +	struct shared_msr_entry guest_msrs[NR_GUEST_MSRS];
> 	int                   nmsrs;
> 	int                   save_nmsrs;
> 	bool                  guest_msrs_ready;
> --=20
> 2.24.0.393.g34dc348eaf-goog
>=20

