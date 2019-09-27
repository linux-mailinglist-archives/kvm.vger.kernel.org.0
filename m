Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17678C07E7
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 16:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfI0OsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 10:48:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37638 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfI0OsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 10:48:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8REiBCh062756;
        Fri, 27 Sep 2019 14:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=rirQTgBKGE1ekWXu3Mkq2hELbwiU1mwNMNUzPWc1UXw=;
 b=ZCBUAF5aIcqvoiMkLlDKHW3hSnXZpcOntvuLQDgN3epytO0leHXnFavTU6n5ctFnlcmy
 Pdwp9XnsVCsreTAM7onYKyrWckMvnV58C0vc5v6fiAEOiIs/LBdkE8b+/ODAh90UnaQW
 xg03uhIuhi8Ig1R1oo/Jzaicv+FclRvlaHlkmC1WONq+e3zEvI7leIJSe9HpuplE9GcC
 216ZdW6UIoRBqv9oFfN/ktLc2UaR/00r18FKz7j4mA3uY2DBgCT9uyqGL4sYtzvEdvy7
 CWzge2Ua/ZSrA7/iGgTbxj1pX5U4o6oOCGKE2bJSshITAgGxG7KpPxzJLzLtzktNeIxX rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgrjq9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 14:47:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8REiFGe075813;
        Fri, 27 Sep 2019 14:44:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v9m3f1617-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 14:44:59 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8REivb3012302;
        Fri, 27 Sep 2019 14:44:58 GMT
Received: from [192.168.14.112] (/79.179.213.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Sep 2019 07:44:57 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: nVMX: Always write vmcs02.GUEST_CR3 during
 nested VM-Enter
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190927142725.GC24889@linux.intel.com>
Date:   Fri, 27 Sep 2019 17:44:53 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EF5C03E7-E3C2-4372-955C-06FB416EB164@oracle.com>
References: <20190926214302.21990-1-sean.j.christopherson@intel.com>
 <20190926214302.21990-2-sean.j.christopherson@intel.com>
 <68340081-0094-4A74-9B33-3431F39659AA@oracle.com>
 <20190927142725.GC24889@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9393 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909270138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9393 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909270138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 27 Sep 2019, at 17:27, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Fri, Sep 27, 2019 at 03:06:02AM +0300, Liran Alon wrote:
>>=20
>>=20
>>> On 27 Sep 2019, at 0:43, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>>=20
>>> Write the desired L2 CR3 into vmcs02.GUEST_CR3 during nested =
VM-Enter
>>> isntead of deferring the VMWRITE until vmx_set_cr3().  If the =
VMWRITE
>>> is deferred, then KVM can consume a stale vmcs02.GUEST_CR3 when it
>>> refreshes vmcs12->guest_cr3 during nested_vmx_vmexit() if the =
emulated
>>> VM-Exit occurs without actually entering L2, e.g. if the nested run
>>> is squashed because L2 is being put into HLT.
>>=20
>> I would rephrase to =E2=80=9CIf an emulated VMEntry is squashed =
because L1 sets
>> vmcs12->guest_activity_state to HLT=E2=80=9D.  I think it=E2=80=99s a =
bit more explicit.
>>=20
>>>=20
>>> In an ideal world where EPT *requires* unrestricted guest (and vice
>>> versa), VMX could handle CR3 similar to how it handles RSP and RIP,
>>> e.g. mark CR3 dirty and conditionally load it at vmx_vcpu_run().  =
But
>>> the unrestricted guest silliness complicates the dirty tracking =
logic
>>> to the point that explicitly handling vmcs02.GUEST_CR3 during nested
>>> VM-Enter is a simpler overall implementation.
>>>=20
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Reto Buerki <reet@codelabs.ch>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>> arch/x86/kvm/vmx/nested.c | 8 ++++++++
>>> arch/x86/kvm/vmx/vmx.c    | 9 ++++++---
>>> 2 files changed, 14 insertions(+), 3 deletions(-)
>>>=20
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index 41abc62c9a8a..971a24134081 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -2418,6 +2418,14 @@ static int prepare_vmcs02(struct kvm_vcpu =
*vcpu, struct vmcs12 *vmcs12,
>>> 				entry_failure_code))
>>> 		return -EINVAL;
>>>=20
>>> +	/*
>>> +	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to =
vmcs12
>>> +	 * on nested VM-Exit, which can occur without actually running =
L2, e.g.
>>> +	 * if L2 is entering HLT state, and thus without hitting =
vmx_set_cr3().
>>> +	 */
>>=20
>> If I understand correctly, it=E2=80=99s not exactly if L2 is entering =
HLT state in
>> general.  (E.g. issue doesn=E2=80=99t occur if L2 runs HLT directly =
which is not
>> configured to be intercepted by vmcs12).  It=E2=80=99s specifically =
when L1 enters L2
>> with a HLT guest-activity-state. I suggest rephrasing comment.
>=20
> I deliberately worded the comment so that it remains valid if there =
are
> more conditions in the future that cause KVM to skip running L2.  What =
if
> I split the difference and make the changelog more explicit, but leave =
the
> comment as is?

I think what is confusing in comment is that it seems to also refer to =
the case
where L2 directly enters HLT state without L1 intercept. Which isn=E2=80=99=
t related.
So I would explicitly mention it=E2=80=99s when L1 enters L2 but don=E2=80=
=99t physically enter guest
with vmcs02 because L2 is in HLT state.

-Liran

>=20
>>> +	if (enable_ept)
>>> +		vmcs_writel(GUEST_CR3, vmcs12->guest_cr3);
>>> +
>>> 	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are =
set. */
>>> 	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
>>> 	    is_pae_paging(vcpu)) {
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index d4575ffb3cec..b530950a9c2b 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -2985,6 +2985,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, =
unsigned long cr3)
>>> {
>>> 	struct kvm *kvm =3D vcpu->kvm;
>>> 	unsigned long guest_cr3;
>>> +	bool skip_cr3 =3D false;
>>> 	u64 eptp;
>>>=20
>>> 	guest_cr3 =3D cr3;
>>> @@ -3000,15 +3001,17 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, =
unsigned long cr3)
>>> 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>>> 		}
>>>=20
>>> -		if (enable_unrestricted_guest || is_paging(vcpu) ||
>>> -		    is_guest_mode(vcpu))
>>> +		if (is_guest_mode(vcpu))
>>> +			skip_cr3 =3D true;
>>> +		else if (enable_unrestricted_guest || is_paging(vcpu))
>>> 			guest_cr3 =3D kvm_read_cr3(vcpu);
>>> 		else
>>> 			guest_cr3 =3D =
to_kvm_vmx(kvm)->ept_identity_map_addr;
>>> 		ept_load_pdptrs(vcpu);
>>> 	}
>>>=20
>>> -	vmcs_writel(GUEST_CR3, guest_cr3);
>>> +	if (!skip_cr3)
>>=20
>> Nit: It=E2=80=99s a matter of taste, but I prefer positive =
conditions. i.e. =E2=80=9Cbool
>> write_guest_cr3=E2=80=9D.
>>=20
>> Anyway, code seems valid to me. Nice catch.
>> Reviewed-by: Liran Alon <liran.alon@oracle.com>
>>=20
>> -Liran
>>=20
>>> +		vmcs_writel(GUEST_CR3, guest_cr3);
>>> }
>>>=20
>>> int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>> --=20
>>> 2.22.0
>>>=20
>>=20

