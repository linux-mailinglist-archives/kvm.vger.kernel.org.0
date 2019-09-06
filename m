Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCCAC1C2
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbfIFVA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:00:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38492 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfIFVA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:00:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86L0jBL020316;
        Fri, 6 Sep 2019 21:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=UFanPFrUxWI3fcg1sEcM1SipS0H4fAjvTSiESFKs4HY=;
 b=ae8VKynTjVGp/q3Ch0MOoSU9aXkLkGBKu7PsOV4zGWz2WJ/8Ze6UfsHc0Drmeiu0A9iT
 S2SxjRTabEqJD2yYUeDV1qvUKOaHlypQ7ojvBjy0i/2pqNcC/Y8KjU8kSl42yZvv7AGY
 tNdnkEIPG5rgCrxeODdTkHD095/IM3vwv0yNeQ0QAkcuKr2F9+IaRBcRSpCSYvn4v9xA
 ppTnb/eNug4L95YBn3gP7vK+nAuqJMn1D6lil2NhmzKn4i1BCsHp18QR7oGNro8H2FaT
 w82Joa/kbhPhBDBYWpoveuUZvD0ka3dgNDFvnZ3Y0wjTFRF2Yi1hHCcUwy+T/74N985K wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uuxwfr0u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 21:00:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86Kwfje039023;
        Fri, 6 Sep 2019 21:00:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uu1ba4mvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 21:00:49 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x86L0nCq015172;
        Fri, 6 Sep 2019 21:00:49 GMT
Received: from [192.168.14.112] (/79.182.237.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 14:00:48 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC][PATCH] KVM: nVMX: Don't leak L1 MMIO regions to L2
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CALMp9eQBZ9yZ+MMNpmuDZVAO=0VNuBwFo28MkXO901LosozM-A@mail.gmail.com>
Date:   Sat, 7 Sep 2019 00:00:45 +0300
Cc:     kvm list <kvm@vger.kernel.org>, Dan Cross <dcross@google.com>,
        Marc Orr <marcorr@google.com>, Peter Shier <pshier@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E0501B8D-8E71-443C-9039-6639D0AC0B58@oracle.com>
References: <20190906185945.230946-1-jmattson@google.com>
 <E9EFDCFC-9B30-4CC2-ADD8-ED756ECE37CC@oracle.com>
 <CALMp9eQBZ9yZ+MMNpmuDZVAO=0VNuBwFo28MkXO901LosozM-A@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060214
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 6 Sep 2019, at 23:52, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Fri, Sep 6, 2019 at 1:06 PM Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>>=20
>>=20
>>> On 6 Sep 2019, at 21:59, Jim Mattson <jmattson@google.com> wrote:
>>>=20
>>> If the "virtualize APIC accesses" VM-execution control is set in the
>>> VMCS, the APIC virtualization hardware is triggered when a page walk
>>> in VMX non-root mode terminates at a PTE wherein the address of the =
4k
>>> page frame matches the APIC-access address specified in the VMCS. On
>>> hardware, the APIC-access address may be any valid 4k-aligned =
physical
>>> address.
>>>=20
>>> KVM's nVMX implementation enforces the additional constraint that =
the
>>> APIC-access address specified in the vmcs12 must be backed by
>>> cacheable memory in L1. If not, L0 will simply clear the "virtualize
>>> APIC accesses" VM-execution control in the vmcs02.
>>>=20
>>> The problem with this approach is that the L1 guest has arranged the
>>> vmcs12 EPT tables--or shadow page tables, if the "enable EPT"
>>> VM-execution control is clear in the vmcs12--so that the L2 guest
>>> physical address(es)--or L2 guest linear address(es)--that reference
>>> the L2 APIC map to the APIC-access address specified in the
>>> vmcs12. Without the "virtualize APIC accesses" VM-execution control =
in
>>> the vmcs02, the APIC accesses in the L2 guest will directly access =
the
>>> APIC-access page in L1.
>>>=20
>>> When L0 has no mapping whatsoever for the APIC-access address in L1,
>>> the L2 VM just loses the intended APIC virtualization. However, when
>>> the L2 APIC-access address is mapped to an MMIO region in L1, the L2
>>> guest gets direct access to the L1 MMIO device. For example, if the
>>> APIC-access address specified in the vmcs12 is 0xfee00000, then L2
>>> gets direct access to L1's APIC.
>>>=20
>>> Fixing this correctly is complicated. Since this vmcs12 =
configuration
>>> is something that KVM cannot faithfully emulate, the appropriate
>>> response is to exit to userspace with
>>> KVM_INTERNAL_ERROR_EMULATION. Sadly, the kvm-unit-tests fail, so I'm
>>> posting this as an RFC.
>>>=20
>>> Note that the 'Code' line emitted by qemu in response to this error
>>> shows the guest %rip two instructions after the
>>> vmlaunch/vmresume. Hmmm.
>>>=20
>>> Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and =
vmcs12")
>>> Reported-by: Dan Cross <dcross@google.com>
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> Reviewed-by: Marc Orr <marcorr@google.com>
>>> Reviewed-by: Peter Shier <pshier@google.com>
>>> Reviewed-by: Dan Cross <dcross@google.com>
>>=20
>> The idea of the patch and the functionality of it seems correct to =
me.
>> However, I have some small code comments below.
>=20
> You're not bothered by the fact that the vmx kvm-unit-test now dies
> early? Should I just comment out the APIC-access address tests that
> are currently xfail?

Yes. That=E2=80=99s at least my opinion...

>=20
>>> ---
>>> arch/x86/include/asm/kvm_host.h |  2 +-
>>> arch/x86/kvm/vmx/nested.c       | 55 =
++++++++++++++++++++++-----------
>>> arch/x86/kvm/x86.c              |  9 ++++--
>>> 3 files changed, 45 insertions(+), 21 deletions(-)
>>>=20
>>> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
>>> index 74e88e5edd9cf..e95acf8c82b47 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1191,7 +1191,7 @@ struct kvm_x86_ops {
>>>      int (*set_nested_state)(struct kvm_vcpu *vcpu,
>>>                              struct kvm_nested_state __user =
*user_kvm_nested_state,
>>>                              struct kvm_nested_state *kvm_state);
>>> -     void (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
>>> +     int (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
>>>=20
>>>      int (*smi_allowed)(struct kvm_vcpu *vcpu);
>>>      int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index ced9fba32598d..bdf5a11816fa4 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -2871,7 +2871,7 @@ static int nested_vmx_check_vmentry_hw(struct =
kvm_vcpu *vcpu)
>>> static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu =
*vcpu,
>>>                                               struct vmcs12 =
*vmcs12);
>>>=20
>>> -static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>>> +static int nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>>> {
>>>      struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
>>>      struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>> @@ -2891,19 +2891,31 @@ static void nested_get_vmcs12_pages(struct =
kvm_vcpu *vcpu)
>>>                      vmx->nested.apic_access_page =3D NULL;
>>>              }
>>>              page =3D kvm_vcpu_gpa_to_page(vcpu, =
vmcs12->apic_access_addr);
>>> -             /*
>>> -              * If translation failed, no matter: This feature asks
>>> -              * to exit when accessing the given address, and if it
>>> -              * can never be accessed, this feature won't do
>>> -              * anything anyway.
>>> -              */
>>>              if (!is_error_page(page)) {
>>>                      vmx->nested.apic_access_page =3D page;
>>>                      hpa =3D =
page_to_phys(vmx->nested.apic_access_page);
>>>                      vmcs_write64(APIC_ACCESS_ADDR, hpa);
>>>              } else {
>>> -                     secondary_exec_controls_clearbit(vmx,
>>> -                             =
SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
>>> +                     /*
>>> +                      * Since there is no backing page, we can't
>>> +                      * just rely on the usual L1 GPA -> HPA
>>> +                      * translation mechanism to do the right
>>> +                      * thing. We'd have to assign an appropriate
>>> +                      * HPA for the L1 APIC-access address, and
>>> +                      * then we'd have to modify the MMU to ensure
>>> +                      * that the L1 APIC-access address is mapped
>>> +                      * to the assigned HPA if and only if an L2 VM
>>> +                      * with that APIC-access address and the
>>> +                      * "virtualize APIC accesses" VM-execution
>>> +                      * control set in the vmcs12 is running. For
>>> +                      * now, just admit defeat.
>>> +                      */
>>> +                     pr_warn_ratelimited("Unsupported vmcs12 =
APIC-access address\n");
>>> +                     vcpu->run->exit_reason =3D =
KVM_EXIT_INTERNAL_ERROR;
>>> +                     vcpu->run->internal.suberror =3D
>>> +                             KVM_INTERNAL_ERROR_EMULATION;
>>> +                     vcpu->run->internal.ndata =3D 0;
>>=20
>> I think it is wise to pass here vmcs12->apic_access_addr value to =
userspace.
>> In addition, also print it in pr_warn_ratelimited() call.
>> To aid debugging.
>=20
> SGTM
>=20
>>> +                     return -ENOTSUPP;
>>>              }
>>>      }
>>>=20
>>> @@ -2948,6 +2960,7 @@ static void nested_get_vmcs12_pages(struct =
kvm_vcpu *vcpu)
>>>              exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
>>>      else
>>>              exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
>>> +     return 0;
>>> }
>>>=20
>>> /*
>>> @@ -2986,11 +2999,12 @@ static void load_vmcs12_host_state(struct =
kvm_vcpu *vcpu,
>>> /*
>>> * If from_vmentry is false, this is being called from state restore =
(either RSM
>>> * or KVM_SET_NESTED_STATE).  Otherwise it's called from =
vmlaunch/vmresume.
>>> -+ *
>>> -+ * Returns:
>>> -+ *   0 - success, i.e. proceed with actual VMEnter
>>> -+ *   1 - consistency check VMExit
>>> -+ *  -1 - consistency check VMFail
>>> + *
>>> + * Returns:
>>> + * < 0 - error
>>> + *   0 - success, i.e. proceed with actual VMEnter
>>> + *   1 - consistency check VMExit
>>> + *   2 - consistency check VMFail
>>=20
>> Whenever we start having non-trivial return values, I believe adding =
an enum
>> is in place. It makes code easier to read and less confusing.
>=20
> Yeah. This is ugly, but look what I had to work with!

I don=E2=80=99t blame you ;)
This code change just focused me on this.

>=20
>>> */
>>> int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool =
from_vmentry)
>>> {
>>> @@ -2999,6 +3013,7 @@ int nested_vmx_enter_non_root_mode(struct =
kvm_vcpu *vcpu, bool from_vmentry)
>>>      bool evaluate_pending_interrupts;
>>>      u32 exit_reason =3D EXIT_REASON_INVALID_STATE;
>>>      u32 exit_qual;
>>> +     int r;
>>>=20
>>>      evaluate_pending_interrupts =3D exec_controls_get(vmx) &
>>>              (CPU_BASED_VIRTUAL_INTR_PENDING | =
CPU_BASED_VIRTUAL_NMI_PENDING);
>>> @@ -3035,11 +3050,13 @@ int nested_vmx_enter_non_root_mode(struct =
kvm_vcpu *vcpu, bool from_vmentry)
>>>      prepare_vmcs02_early(vmx, vmcs12);
>>>=20
>>>      if (from_vmentry) {
>>> -             nested_get_vmcs12_pages(vcpu);
>>> +             r =3D nested_get_vmcs12_pages(vcpu);
>>> +             if (unlikely(r))
>>=20
>> It makes sense to also mark !is_error_page(page) as likely() in =
nested_get_vmcs12_pages().
>=20
> The use of static branch prediction hints in kvm seems pretty ad hoc

I agree...

> to me, but I'll go ahead and add one to the referenced code path.
>=20
>>> +                     return r;
>>>=20
>>>              if (nested_vmx_check_vmentry_hw(vcpu)) {
>>>                      vmx_switch_vmcs(vcpu, &vmx->vmcs01);
>>> -                     return -1;
>>> +                     return 2;
>>>              }
>>>=20
>>>              if (nested_vmx_check_guest_state(vcpu, vmcs12, =
&exit_qual))
>>> @@ -3200,9 +3217,11 @@ static int nested_vmx_run(struct kvm_vcpu =
*vcpu, bool launch)
>>>      vmx->nested.nested_run_pending =3D 1;
>>>      ret =3D nested_vmx_enter_non_root_mode(vcpu, true);
>>>      vmx->nested.nested_run_pending =3D !ret;
>>> -     if (ret > 0)
>>> +     if (ret < 0)
>>> +             return 0;
>>> +     if (ret =3D=3D 1)
>>>              return 1;
>>> -     else if (ret)
>>> +     if (ret)
>>=20
>> All these checks for of "ret" are not really readable.
>> They also implicitly define any ret value which is >1 as consistency =
check VMFail instead of just ret=3D=3D2.
>=20
> Previously, any value less than 0 was consistency check VMFail instead
> of just ret=3D=3D-1. :-)

Yep...

>=20
>> I prefer to have something like:
>>=20
>> switch (ret) {
>>    case VMEXIT_ON_INVALID_STATE:
>>        return 1;
>>    case VMFAIL_ON_INVALID_STATE:
>>        return nested_vmx_failValid(vcpu, =
VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>>    default:
>>        /* Return to userspace on error */
>>        if (ret < 0)
>>            return 0;
>> }
>=20
> You and me both. On the other hand, I also dislike code churn. It
> complicates release engineering.

I don=E2=80=99t think it really complicates anything in this case.

>=20
>> In addition, can you remind me why we call nested_vmx_failValid() at =
nested_vmx_run()
>> instead of inside nested_vmx_enter_non_root_mode() when =
nested_vmx_check_vmentry_hw() fails?
>=20
> I assume this is because of the call to
> nested_vmx_enter_non_root_mode() from vmx_pre_leave_smm(), but we do
> have that from_vmentry argument that I despise, so we may as well use
> it.

Oh I see. This is also true for the call from vmx_set_nested_state().
But I agree it seems nicer to just use the from_vmentry parameter
to clean this code up a bit.

-Liran

>=20
>> Then code could have indeed simply be:
>> if (ret < 0)
>>    return 0;
>> if (ret)
>>    return 1;
>> =E2=80=A6.
>>=20
>> Which is easy to understand.
>> i.e. First case return to userspace on error, second report error to =
guest and rest continue as usual
>> now assuming vCPU is non-root mode.
>>=20
>> -Liran
>>=20
>>>              return nested_vmx_failValid(vcpu,
>>>                      VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>>>=20
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 290c3c3efb877..5ddbf16c8b108 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -7803,8 +7803,13 @@ static int vcpu_enter_guest(struct kvm_vcpu =
*vcpu)
>>>      bool req_immediate_exit =3D false;
>>>=20
>>>      if (kvm_request_pending(vcpu)) {
>>> -             if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu))
>>> -                     kvm_x86_ops->get_vmcs12_pages(vcpu);
>>> +             if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) =
{
>>> +                     r =3D kvm_x86_ops->get_vmcs12_pages(vcpu);
>>> +                     if (unlikely(r)) {
>>> +                             r =3D 0;
>>> +                             goto out;
>>> +                     }
>>> +             }
>>>              if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
>>>                      kvm_mmu_unload(vcpu);
>>>              if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
>>> --
>>> 2.23.0.187.g17f5b7556c-goog
>>>=20
>>=20

