Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775049B14E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 15:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393446AbfHWNub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 09:50:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36312 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390206AbfHWNub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 09:50:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDnAQT052965;
        Fri, 23 Aug 2019 13:49:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=LA/PoYwDLm2vX7EZM0Tp8cSsJ2q2Ds/oGfzloowmGcE=;
 b=UbL6dbmegFGQ5ZeMIdlS29RCLgtGiGT/fHIO48uwSzI6t2icaOYBcsR/XwwM0kD++i1F
 PMDPkt62cwNW3GT4RPoJXQex8XOO4vhdd0pGd7AMAPKMXZaMLMvxsc6lI733LKTyGgyL
 ifligl7sTvRpDpa/A57Y4ET4FoLUAuKV2/Dl0DM22o0SbkKX4vODHyjRVRK6yesJcthv
 73UxjRk8nyNeV8t2+Pjgd0Kxt3ghKDo77EA4e2gUYoFg7CFYuY+FoTU+1d9b/R2/VHh2
 gLSl9V5PPJc8UF2i9ZnKfaCJVqB4b5QS0Nt2sAXLRkw/mBGdlzq37CrybxO9hB5xKaMt nA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ue90u4ymv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:49:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDmWHV004279;
        Fri, 23 Aug 2019 13:49:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ujca84ddg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:49:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7NDmJKu004895;
        Fri, 23 Aug 2019 13:48:19 GMT
Received: from [192.168.14.112] (/109.64.228.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 06:48:19 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND PATCH 08/13] KVM: x86: Move #UD injection for failed
 emulation into emulation code
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190823010709.24879-9-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 16:48:16 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AB4F0E37-1E13-4735-BE9F-6C80D13D016D@oracle.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-9-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230143
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Aug 2019, at 4:07, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Immediately inject a #UD and return EMULATE done if emulation fails =
when
> handling an intercepted #UD.  This helps pave the way for removing
> EMULATE_FAIL altogether.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I suggest squashing this commit which previous one.

-Liran

> ---
> arch/x86/kvm/x86.c | 14 +++++---------
> 1 file changed, 5 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1f9e36b2d58..bff3320aa78e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5328,7 +5328,6 @@ EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
> int handle_ud(struct kvm_vcpu *vcpu)
> {
> 	int emul_type =3D EMULTYPE_TRAP_UD;
> -	enum emulation_result er;
> 	char sig[5]; /* ud2; .ascii "kvm" */
> 	struct x86_exception e;
>=20
> @@ -5340,12 +5339,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
> 		emul_type =3D EMULTYPE_TRAP_UD_FORCED;
> 	}
>=20
> -	er =3D kvm_emulate_instruction(vcpu, emul_type);
> -	if (er =3D=3D EMULATE_USER_EXIT)
> -		return 0;
> -	if (er !=3D EMULATE_DONE)
> -		kvm_queue_exception(vcpu, UD_VECTOR);
> -	return 1;
> +	return kvm_emulate_instruction(vcpu, emul_type) !=3D =
EMULATE_USER_EXIT;
> }
> EXPORT_SYMBOL_GPL(handle_ud);
>=20
> @@ -6533,8 +6527,10 @@ int x86_emulate_instruction(struct kvm_vcpu =
*vcpu,
> 		++vcpu->stat.insn_emulation;
> 		if (r !=3D EMULATION_OK)  {
> 			if ((emulation_type & EMULTYPE_TRAP_UD) ||
> -			    (emulation_type & EMULTYPE_TRAP_UD_FORCED))
> -				return EMULATE_FAIL;
> +			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) =
{
> +				kvm_queue_exception(vcpu, UD_VECTOR);
> +				return EMULATE_DONE;
> +			}
> 			if (reexecute_instruction(vcpu, cr2, =
write_fault_to_spt,
> 						emulation_type))
> 				return EMULATE_DONE;
> --=20
> 2.22.0
>=20

