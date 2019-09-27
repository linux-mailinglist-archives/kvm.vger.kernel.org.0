Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2368BFC28
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 02:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfI0AJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 20:09:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59630 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfI0AJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 20:09:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8R04N8W109662;
        Fri, 27 Sep 2019 00:08:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=lETXaTrfnoYe7AySdKj47hrTKIRb4jx9j0xKM7xYN5g=;
 b=TPKht4s0rPNMFskB+itbn4zMS2mWeI5URRQSxx+D5vAF8LpYG2MsGd1DeGiughY5FWGV
 33NNVkSxk6AW84wJZbYXoam5nC+8YtaRvvlbixp/Sl0KjPkCIbZp9eqmPfxvOesDSN4S
 HeX72EXISsbULNDUdfuOBxBT50/kguqHia5GQPpEPLO8TdTXEU8fD/f555Bq3FYhVsi4
 oc/CFpEQj+REf7YD08VY9SC4tF2qWriSFeUmcJO/2GbIyXxeZMoyR0g5YIJzS61xet6i
 QzJZraV1W1FvXKXB7o32xRWx9LXHw86SnVKVRUeJeWgxmsKhlfDKmLnDzDgagBGHGKOX Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btqew25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 00:08:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QNx06X167582;
        Fri, 27 Sep 2019 00:06:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2v8yjxgw1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 00:06:09 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8R066cN017670;
        Fri, 27 Sep 2019 00:06:06 GMT
Received: from [192.168.14.112] (/79.179.213.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 17:06:06 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: nVMX: Always write vmcs02.GUEST_CR3 during
 nested VM-Enter
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190926214302.21990-2-sean.j.christopherson@intel.com>
Date:   Fri, 27 Sep 2019 03:06:02 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>
Content-Transfer-Encoding: quoted-printable
Message-Id: <68340081-0094-4A74-9B33-3431F39659AA@oracle.com>
References: <20190926214302.21990-1-sean.j.christopherson@intel.com>
 <20190926214302.21990-2-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260192
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 27 Sep 2019, at 0:43, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Write the desired L2 CR3 into vmcs02.GUEST_CR3 during nested VM-Enter
> isntead of deferring the VMWRITE until vmx_set_cr3().  If the VMWRITE
> is deferred, then KVM can consume a stale vmcs02.GUEST_CR3 when it
> refreshes vmcs12->guest_cr3 during nested_vmx_vmexit() if the emulated
> VM-Exit occurs without actually entering L2, e.g. if the nested run
> is squashed because L2 is being put into HLT.

I would rephrase to =E2=80=9CIf an emulated VMEntry is squashed because =
L1 sets vmcs12->guest_activity_state to HLT=E2=80=9D.
I think it=E2=80=99s a bit more explicit.

>=20
> In an ideal world where EPT *requires* unrestricted guest (and vice
> versa), VMX could handle CR3 similar to how it handles RSP and RIP,
> e.g. mark CR3 dirty and conditionally load it at vmx_vcpu_run().  But
> the unrestricted guest silliness complicates the dirty tracking logic
> to the point that explicitly handling vmcs02.GUEST_CR3 during nested
> VM-Enter is a simpler overall implementation.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Reto Buerki <reet@codelabs.ch>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> arch/x86/kvm/vmx/nested.c | 8 ++++++++
> arch/x86/kvm/vmx/vmx.c    | 9 ++++++---
> 2 files changed, 14 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 41abc62c9a8a..971a24134081 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2418,6 +2418,14 @@ static int prepare_vmcs02(struct kvm_vcpu =
*vcpu, struct vmcs12 *vmcs12,
> 				entry_failure_code))
> 		return -EINVAL;
>=20
> +	/*
> +	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to =
vmcs12
> +	 * on nested VM-Exit, which can occur without actually running =
L2, e.g.
> +	 * if L2 is entering HLT state, and thus without hitting =
vmx_set_cr3().
> +	 */

If I understand correctly, it=E2=80=99s not exactly if L2 is entering =
HLT state in general.
(E.g. issue doesn=E2=80=99t occur if L2 runs HLT directly which is not =
configured to be intercepted by vmcs12).
It=E2=80=99s specifically when L1 enters L2 with a HLT =
guest-activity-state. I suggest rephrasing comment.

> +	if (enable_ept)
> +		vmcs_writel(GUEST_CR3, vmcs12->guest_cr3);
> +
> 	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are =
set. */
> 	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
> 	    is_pae_paging(vcpu)) {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d4575ffb3cec..b530950a9c2b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2985,6 +2985,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned =
long cr3)
> {
> 	struct kvm *kvm =3D vcpu->kvm;
> 	unsigned long guest_cr3;
> +	bool skip_cr3 =3D false;
> 	u64 eptp;
>=20
> 	guest_cr3 =3D cr3;
> @@ -3000,15 +3001,17 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, =
unsigned long cr3)
> 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> 		}
>=20
> -		if (enable_unrestricted_guest || is_paging(vcpu) ||
> -		    is_guest_mode(vcpu))
> +		if (is_guest_mode(vcpu))
> +			skip_cr3 =3D true;
> +		else if (enable_unrestricted_guest || is_paging(vcpu))
> 			guest_cr3 =3D kvm_read_cr3(vcpu);
> 		else
> 			guest_cr3 =3D =
to_kvm_vmx(kvm)->ept_identity_map_addr;
> 		ept_load_pdptrs(vcpu);
> 	}
>=20
> -	vmcs_writel(GUEST_CR3, guest_cr3);
> +	if (!skip_cr3)

Nit: It=E2=80=99s a matter of taste, but I prefer positive conditions. =
i.e. =E2=80=9Cbool write_guest_cr3=E2=80=9D.

Anyway, code seems valid to me. Nice catch.
Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

> +		vmcs_writel(GUEST_CR3, guest_cr3);
> }
>=20
> int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> --=20
> 2.22.0
>=20

