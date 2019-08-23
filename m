Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE4F9B054
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 15:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393525AbfHWNGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 09:06:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731379AbfHWNGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 09:06:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NCxm5m010521;
        Fri, 23 Aug 2019 13:05:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=MuPLFBBB6HlSfaFhBNJHUtH268k8NYIFg0rgKZBwcr0=;
 b=h4CBYNUtdlreVkjpLwTRNorXJL4O0Yoq6NNvwidvsBodx2bzfK6GomiOQDiJwXqyAmax
 hmeRxhtFu0yOMp/a9xXAYgPBKlt5Y/J4Btjc6h+wiCzRQtRAWu6i0oh2icz0SucF5U5C
 vo+wT677ynLULK7OgPv3FyieePLWUhweFxfaDXWYisrZ92YZ/k0WV5xpndtVivVG00m/
 JhZ+DWDou6vWe53Q23vH2rR0lw3pVgTQubQMaC11XpfSr6amHyit7VYvGttsPyDVZArk
 hGBl2/T+SgnP2obq/v57ZAqfyQqWAHNBybAoBknPabAfVIUnFPTbMemJnP2iJ1IFg600 CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ue90u4ran-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:05:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NCxw7m173397;
        Fri, 23 Aug 2019 13:05:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uhusfnvc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:05:22 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7ND5Lcl017722;
        Fri, 23 Aug 2019 13:05:22 GMT
Received: from [192.168.14.112] (/109.64.228.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 06:05:21 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND PATCH 03/13] KVM: x86: Refactor kvm_vcpu_do_singlestep()
 to remove out param
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190823010709.24879-4-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 16:05:17 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E0397025-1437-4D47-B94D-8BE9EC89BD91@oracle.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-4-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Aug 2019, at 4:06, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Return the single-step emulation result directly instead of via an out
> param.  Presumably at some point in the past kvm_vcpu_do_singlestep()
> could be called with *r=3D=3DEMULATE_USER_EXIT, but that is no longer =
the
> case, i.e. all callers are happy to overwrite their own return =
variable.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> arch/x86/kvm/x86.c | 12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c6de5bc4fa5e..fe847f8eb947 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6377,7 +6377,7 @@ static int kvm_vcpu_check_hw_bp(unsigned long =
addr, u32 type, u32 dr7,
> 	return dr6;
> }
>=20
> -static void kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu, int *r)
> +static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
> {
> 	struct kvm_run *kvm_run =3D vcpu->run;
>=20
> @@ -6386,10 +6386,10 @@ static void kvm_vcpu_do_singlestep(struct =
kvm_vcpu *vcpu, int *r)
> 		kvm_run->debug.arch.pc =3D vcpu->arch.singlestep_rip;
> 		kvm_run->debug.arch.exception =3D DB_VECTOR;
> 		kvm_run->exit_reason =3D KVM_EXIT_DEBUG;
> -		*r =3D EMULATE_USER_EXIT;
> -	} else {
> -		kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);
> +		return EMULATE_USER_EXIT;
> 	}
> +	kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);
> +	return EMULATE_DONE;
> }
>=20
> int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
> @@ -6410,7 +6410,7 @@ int kvm_skip_emulated_instruction(struct =
kvm_vcpu *vcpu)
> 	 * that sets the TF flag".
> 	 */
> 	if (unlikely(rflags & X86_EFLAGS_TF))
> -		kvm_vcpu_do_singlestep(vcpu, &r);
> +		r =3D kvm_vcpu_do_singlestep(vcpu);
> 	return r =3D=3D EMULATE_DONE;
> }
> EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
> @@ -6613,7 +6613,7 @@ int x86_emulate_instruction(struct kvm_vcpu =
*vcpu,
> 		vcpu->arch.emulate_regs_need_sync_to_vcpu =3D false;
> 		kvm_rip_write(vcpu, ctxt->eip);
> 		if (r =3D=3D EMULATE_DONE && ctxt->tf)
> -			kvm_vcpu_do_singlestep(vcpu, &r);
> +			r =3D kvm_vcpu_do_singlestep(vcpu);
> 		if (!ctxt->have_exception ||
> 		    exception_type(ctxt->exception.vector) =3D=3D =
EXCPT_TRAP)
> 			__kvm_set_rflags(vcpu, ctxt->eflags);
> --=20
> 2.22.0
>=20

Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran


