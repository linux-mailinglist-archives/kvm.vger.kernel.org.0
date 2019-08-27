Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5559F5CC
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 00:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfH0WFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 18:05:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39736 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfH0WFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 18:05:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7RM3wdI081971;
        Tue, 27 Aug 2019 22:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=C1DvjJcOlwTkvrYi789M/FVZ6QfJfKpylKnh1CXBCMs=;
 b=iq1GBoj5HNQ+Oep2arFhK8Prm5HWYexdXg/ASevKUnAsM53WZpeT8PAq9LyXjBix/1sO
 0tTnXJgC14scR4bsYTnn/VEBcl4X84cQNGUB6o9q6aSvkF8nE5X1Ex4VrTgA5nK9yD1s
 BuNzEIQam43A/kllrW9sU2xWRlM35RBKwEwgmoWEvUUVMxS5Lnu2Lfb4fiVq/woWMJrI
 qTsZ6gcjRkn9sYjXqdp+JsXwx9VGJCuvL0jcPxnSKhRHivOykwvyAjdKrhz/6ZDWPk/j
 6k95ARV+6CD4LHyBU19Aa0E8nHy35P3C7ysliw3gBsgTYKBsacs9seMxJUGdpcCvB9lr 2g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uncu6g21f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 22:04:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7RM3Mp7157450;
        Tue, 27 Aug 2019 22:04:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2umhu99rq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 22:04:10 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7RM3a7J010038;
        Tue, 27 Aug 2019 22:03:38 GMT
Received: from [192.168.14.112] (/79.180.242.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Aug 2019 15:03:36 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2 05/14] KVM: x86: Move #GP injection for VMware into
 x86_emulate_instruction()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190827214040.18710-6-sean.j.christopherson@intel.com>
Date:   Wed, 28 Aug 2019 01:03:31 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E80FCB06-83D1-41D5-B22D-58A72B4DC5DF@oracle.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
 <20190827214040.18710-6-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908270207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270207
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 28 Aug 2019, at 0:40, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Immediately inject a #GP when VMware emulation fails and return
> EMULATE_DONE instead of propagating EMULATE_FAIL up the stack.  This
> helps pave the way for removing EMULATE_FAIL altogether.
>=20
> Rename EMULTYPE_VMWARE to EMULTYPE_VMWARE_GP to document that the x86
> emulator is called to handle VMware #GP interception, e.g. why a #GP
> is injected on emulation failure for EMULTYPE_VMWARE_GP.
>=20
> Drop EMULTYPE_NO_UD_ON_FAIL as a standalone type.  The "no #UD on =
fail"
> is used only in the VMWare case and is obsoleted by having the =
emulator
> itself reinject #GP.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

> ---
> arch/x86/include/asm/kvm_host.h |  3 +--
> arch/x86/kvm/svm.c              | 10 ++--------
> arch/x86/kvm/vmx/vmx.c          | 10 ++--------
> arch/x86/kvm/x86.c              | 14 +++++++++-----
> 4 files changed, 14 insertions(+), 23 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
> index 44a5ce57a905..d1d5b5ca1195 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1318,8 +1318,7 @@ enum emulation_result {
> #define EMULTYPE_TRAP_UD	    (1 << 1)
> #define EMULTYPE_SKIP		    (1 << 2)
> #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
> -#define EMULTYPE_NO_UD_ON_FAIL	    (1 << 4)
> -#define EMULTYPE_VMWARE		    (1 << 5)
> +#define EMULTYPE_VMWARE_GP	    (1 << 5)
> int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int =
emulation_type);
> int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
> 					void *insn, int insn_len);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 7242142573d6..c4b72db48bc5 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2768,7 +2768,6 @@ static int gp_interception(struct vcpu_svm *svm)
> {
> 	struct kvm_vcpu *vcpu =3D &svm->vcpu;
> 	u32 error_code =3D svm->vmcb->control.exit_info_1;
> -	int er;
>=20
> 	WARN_ON_ONCE(!enable_vmware_backdoor);
>=20
> @@ -2780,13 +2779,8 @@ static int gp_interception(struct vcpu_svm =
*svm)
> 		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> 		return 1;
> 	}
> -	er =3D kvm_emulate_instruction(vcpu,
> -		EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
> -	if (er =3D=3D EMULATE_USER_EXIT)
> -		return 0;
> -	else if (er !=3D EMULATE_DONE)
> -		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> -	return 1;
> +	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP) !=3D
> +						EMULATE_USER_EXIT;
> }
>=20
> static bool is_erratum_383(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8a65e1122376..c6ba452296e3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4492,7 +4492,6 @@ static int handle_exception_nmi(struct kvm_vcpu =
*vcpu)
> 	u32 intr_info, ex_no, error_code;
> 	unsigned long cr2, rip, dr6;
> 	u32 vect_info;
> -	enum emulation_result er;
>=20
> 	vect_info =3D vmx->idt_vectoring_info;
> 	intr_info =3D vmx->exit_intr_info;
> @@ -4519,13 +4518,8 @@ static int handle_exception_nmi(struct kvm_vcpu =
*vcpu)
> 			kvm_queue_exception_e(vcpu, GP_VECTOR, =
error_code);
> 			return 1;
> 		}
> -		er =3D kvm_emulate_instruction(vcpu,
> -			EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
> -		if (er =3D=3D EMULATE_USER_EXIT)
> -			return 0;
> -		else if (er !=3D EMULATE_DONE)
> -			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> -		return 1;
> +		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP) =
!=3D
> +							=
EMULATE_USER_EXIT;
> 	}
>=20
> 	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe847f8eb947..228ca71d5b01 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6210,8 +6210,10 @@ static int handle_emulation_failure(struct =
kvm_vcpu *vcpu, int emulation_type)
> 	++vcpu->stat.insn_emulation_fail;
> 	trace_kvm_emulate_insn_failed(vcpu);
>=20
> -	if (emulation_type & EMULTYPE_NO_UD_ON_FAIL)
> -		return EMULATE_FAIL;
> +	if (emulation_type & EMULTYPE_VMWARE_GP) {
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +		return EMULATE_DONE;
> +	}
>=20
> 	kvm_queue_exception(vcpu, UD_VECTOR);
>=20
> @@ -6543,9 +6545,11 @@ int x86_emulate_instruction(struct kvm_vcpu =
*vcpu,
> 		}
> 	}
>=20
> -	if ((emulation_type & EMULTYPE_VMWARE) &&
> -	    !is_vmware_backdoor_opcode(ctxt))
> -		return EMULATE_FAIL;
> +	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
> +	    !is_vmware_backdoor_opcode(ctxt)) {
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +		return EMULATE_DONE;
> +	}
>=20
> 	if (emulation_type & EMULTYPE_SKIP) {
> 		kvm_rip_write(vcpu, ctxt->_eip);
> --=20
> 2.22.0
>=20

