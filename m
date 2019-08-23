Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635CB9B0F9
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 15:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405566AbfHWNcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 09:32:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405549AbfHWNcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 09:32:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDSltZ064565;
        Fri, 23 Aug 2019 13:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=RQUgeQaCUti7wKoiY/fu+izuBxDS2ZO/3aCBGXlxp6o=;
 b=LS0np0P984Hf0RGmEAM46bIG/zlVrzWHUvYwsD8V4HyC4/SklegZvRy63lb6PCohnjZk
 mwHdIrnBfToad2cyq/L0K5GYDgg2lAi/ckeL5QunJgM2HwIpHJxXjkNmWW3NY55o4j2U
 kG0INTe4+Ac9sY9fkH9As5YZArwhBNsRXsnoXLQcatAOdq5ShQPTIFc4zRhWdR0fKkeu
 5iVLjZJDJjpiB9Lv63SadVfDlVvrSoecbOcy/yR0xo/ZaliwM6S6qlA2IQWPBsJDDWwV
 fjcu1tjl2xOZSudglCmd3xx96wBTK0pOzhrsPLZ2KfkSS0SwhnpzT+m/UkCvGmz83WJC zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ue9hq4nts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:30:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDSjVP047540;
        Fri, 23 Aug 2019 13:30:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uhusfpgh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:30:40 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7NDUcp1026065;
        Fri, 23 Aug 2019 13:30:38 GMT
Received: from [192.168.14.112] (/109.64.228.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 06:30:38 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND PATCH 06/13] KVM: x86: Move #GP injection for VMware into
 x86_emulate_instruction()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190823010709.24879-7-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 16:30:34 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1CD69BFC-3E9D-423C-BC9E-892728C68B83@oracle.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-7-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Aug 2019, at 4:07, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Immediately inject a #GP when VMware emulation fails and return
> EMULATE_DONE instead of propagating EMULATE_FAIL up the stack.  This
> helps pave the way for removing EMULATE_FAIL altogether.
>=20
> Rename EMULTYPE_VMWARE to EMULTYPE_VMWARE_GP to help document why a =
#GP
> is injected on emulation failure.

I would rephrase to say that this rename is in order to document that =
the x86 emulator is called to handle
VMware #GP interception. In theory, VMware could have also added weird =
behaviour
to #UD interception as-well. :P

Besides minor comments inline below:
Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> arch/x86/include/asm/kvm_host.h |  2 +-
> arch/x86/kvm/svm.c              |  9 ++-------
> arch/x86/kvm/vmx/vmx.c          |  9 ++-------
> arch/x86/kvm/x86.c              | 14 +++++++++-----
> 4 files changed, 14 insertions(+), 20 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
> index dd6bd9ed0839..d1d5b5ca1195 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1318,7 +1318,7 @@ enum emulation_result {
> #define EMULTYPE_TRAP_UD	    (1 << 1)
> #define EMULTYPE_SKIP		    (1 << 2)
> #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
> -#define EMULTYPE_VMWARE		    (1 << 5)
> +#define EMULTYPE_VMWARE_GP	    (1 << 5)
> int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int =
emulation_type);
> int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
> 					void *insn, int insn_len);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b96a119690f4..97562c2c8b7b 100644
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
> @@ -2776,12 +2775,8 @@ static int gp_interception(struct vcpu_svm =
*svm)
> 		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> 		return 1;
> 	}
> -	er =3D kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
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
> index 3ee0dd304bc7..25410c58c758 100644
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
> @@ -4514,12 +4513,8 @@ static int handle_exception_nmi(struct kvm_vcpu =
*vcpu)
> 			kvm_queue_exception_e(vcpu, GP_VECTOR, =
error_code);
> 			return 1;
> 		}
> -		er =3D kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
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
> index e0f0e14d8fac..228ca71d5b01 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6210,8 +6210,10 @@ static int handle_emulation_failure(struct =
kvm_vcpu *vcpu, int emulation_type)
> 	++vcpu->stat.insn_emulation_fail;
> 	trace_kvm_emulate_insn_failed(vcpu);
>=20
> -	if (emulation_type & EMULTYPE_VMWARE)
> -		return EMULATE_FAIL;
> +	if (emulation_type & EMULTYPE_VMWARE_GP) {
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);

I would add here a comment explaining why you can assume #GP error-code =
is 0.
i.e. Explain that=E2=80=99s because VMware #GP interception is only =
related to IN{S}, OUT{S} and RDPMC
instructions which all of them raise #GP with error-code of 0.

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

Same here.

> +		return EMULATE_DONE;
> +	}
>=20
> 	if (emulation_type & EMULTYPE_SKIP) {
> 		kvm_rip_write(vcpu, ctxt->_eip);
> --=20
> 2.22.0
>=20

