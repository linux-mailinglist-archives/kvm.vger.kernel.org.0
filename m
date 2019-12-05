Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FED1148EE
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 22:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbfLEVyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 16:54:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40280 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfLEVyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 16:54:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5LniK2017973;
        Thu, 5 Dec 2019 21:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=2rwH3VZdDTpkTYftVEdFiJ8CFvBNhsiYfKbZvFaWkdI=;
 b=fkg5hStgHIK+FjTevPhAHATpEOIdzYDqy+ZsGam2/YRZScx3O1URIIZ0MSYEFModCfry
 wwQyYGps5BgTjdHEbDEu6deYRmlrm76MjbgY8S4cMXN6cOZbhOLadBfGVWCEZDD4Byi5
 H8hmNwKQ/GUVvhsq1bDCfrafhGhgxZ258aNnPNMZM3aNA6bxDfNX2S2SDbtVcyBYNSOU
 +HNVgl88NGYhr+JI6gSbvR8wpO8z/+ONllDPhqyAZMyOXQbZL7osCAY64vJmMujYQe6x
 HFA/2sN/8o5hE0Pym9+81Py7+WOh/Dy6JealrUipsKAMDD5cc0w4uECS9CP1WDyMg2cI jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wkh2rqx74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Dec 2019 21:54:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5LnfEH163829;
        Thu, 5 Dec 2019 21:54:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wptpx2hyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Dec 2019 21:54:20 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB5LsJra010251;
        Thu, 5 Dec 2019 21:54:19 GMT
Received: from [192.168.14.112] (/79.183.203.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Dec 2019 13:54:18 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS
 field
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CALMp9eTyhRwqsriLGg1xoO2sOPkgnKK1hV1U3C733xCjW7+VCA@mail.gmail.com>
Date:   Thu, 5 Dec 2019 23:54:15 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2F9C5D9-F106-4B89-BEFA-B3CCC0B004DE@oracle.com>
References: <20191204214027.85958-1-jmattson@google.com>
 <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
 <CALMp9eRbiKnH15NBFk0hrh8udcqZvu6RHm0Nrfh4TikQ3xF6OA@mail.gmail.com>
 <CALMp9eTyhRwqsriLGg1xoO2sOPkgnKK1hV1U3C733xCjW7+VCA@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912050178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912050178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 5 Dec 2019, at 23:30, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Thu, Dec 5, 2019 at 5:11 AM Jim Mattson <jmattson@google.com> =
wrote:
>>=20
>> On Thu, Dec 5, 2019 at 3:46 AM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>>=20
>>> On 04/12/19 22:40, Jim Mattson wrote:
>>>> According to the SDM, a VMWRITE in VMX non-root operation with an
>>>> invalid VMCS-link pointer results in VMfailInvalid before the =
validity
>>>> of the VMCS field in the secondary source operand is checked.
>>>>=20
>>>> Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 =
if running L2")
>>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>>> Cc: Liran Alon <liran.alon@oracle.com>
>>>> ---
>>>> arch/x86/kvm/vmx/nested.c | 38 =
+++++++++++++++++++-------------------
>>>> 1 file changed, 19 insertions(+), 19 deletions(-)
>>>=20
>>> As Vitaly pointed out, the test must be split in two, like this:
>>=20
>> Right. Odd that no kvm-unit-tests noticed.
>>=20
>>> ---------------- 8< -----------------------
>>> =46rom 3b9d87060e800ffae2bd19da94ede05018066c87 Mon Sep 17 00:00:00 =
2001
>>> From: Paolo Bonzini <pbonzini@redhat.com>
>>> Date: Thu, 5 Dec 2019 12:39:07 +0100
>>> Subject: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before =
VMCS field
>>>=20
>>> According to the SDM, a VMWRITE in VMX non-root operation with an
>>> invalid VMCS-link pointer results in VMfailInvalid before the =
validity
>>> of the VMCS field in the secondary source operand is checked.
>>>=20
>>> While cleaning up handle_vmwrite, make the code of handle_vmread =
look
>>> the same, too.
>>=20
>> Okay.
>>=20
>>> Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 =
if running L2")
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> Cc: Liran Alon <liran.alon@oracle.com>
>>>=20
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index 4aea7d304beb..c080a879b95d 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -4767,14 +4767,13 @@ static int handle_vmread(struct kvm_vcpu =
*vcpu)
>>>        if (to_vmx(vcpu)->nested.current_vmptr =3D=3D -1ull)
>>>                return nested_vmx_failInvalid(vcpu);
>>>=20
>>> -       if (!is_guest_mode(vcpu))
>>> -               vmcs12 =3D get_vmcs12(vcpu);
>>> -       else {
>>> +       vmcs12 =3D get_vmcs12(vcpu);
>>> +       if (is_guest_mode(vcpu)) {
>>>                /*
>>>                 * When vmcs->vmcs_link_pointer is -1ull, any VMREAD
>>>                 * to shadowed-field sets the ALU flags for =
VMfailInvalid.
>>>                 */
>>> -               if (get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D =
-1ull)
>>> +               if (vmcs12->vmcs_link_pointer =3D=3D -1ull)
>>>                        return nested_vmx_failInvalid(vcpu);
>>>                vmcs12 =3D get_shadow_vmcs12(vcpu);
>>>        }
>>> @@ -4878,8 +4877,19 @@ static int handle_vmwrite(struct kvm_vcpu =
*vcpu)
>>>                }
>>>        }
>>>=20
>>> +       vmcs12 =3D get_vmcs12(vcpu);
>>> +       if (is_guest_mode(vcpu)) {
>>> +               /*
>>> +                * When vmcs->vmcs_link_pointer is -1ull, any =
VMWRITE
>>> +                * to shadowed-field sets the ALU flags for =
VMfailInvalid.
>>> +                */
>>> +               if (vmcs12->vmcs_link_pointer =3D=3D -1ull)
>>> +                       return nested_vmx_failInvalid(vcpu);
>>> +               vmcs12 =3D get_shadow_vmcs12(vcpu);
>>> +       }
>>>=20
>>>        field =3D kvm_register_readl(vcpu, (((vmx_instruction_info) =
>> 28) & 0xf));
>>> +
>>>        /*
>>>         * If the vCPU supports "VMWRITE to any supported field in =
the
>>>         * VMCS," then the "read-only" fields are actually =
read/write.
>>> @@ -4889,24 +4899,12 @@ static int handle_vmwrite(struct kvm_vcpu =
*vcpu)
>>>                return nested_vmx_failValid(vcpu,
>>>                        VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
>>>=20
>>> -       if (!is_guest_mode(vcpu)) {
>>> -               vmcs12 =3D get_vmcs12(vcpu);
>>> -
>>> -               /*
>>> -                * Ensure vmcs12 is up-to-date before any VMWRITE =
that dirties
>>> -                * vmcs12, else we may crush a field or consume a =
stale value.
>>> -                */
>>> -               if (!is_shadow_field_rw(field))
>>> -                       copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>>> -       } else {
>>> -               /*
>>> -                * When vmcs->vmcs_link_pointer is -1ull, any =
VMWRITE
>>> -                * to shadowed-field sets the ALU flags for =
VMfailInvalid.
>>> -                */
>>> -               if (get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D =
-1ull)
>>> -                       return nested_vmx_failInvalid(vcpu);
>>> -               vmcs12 =3D get_shadow_vmcs12(vcpu);
>>> -       }
>>> +       /*
>>> +        * Ensure vmcs12 is up-to-date before any VMWRITE that =
dirties
>>> +        * vmcs12, else we may crush a field or consume a stale =
value.
>>> +        */
>>> +       if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
>>> +               copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>>>=20
>>>        offset =3D vmcs_field_to_offset(field);
>>>        if (offset < 0)
>>>=20
>>>=20
>>> ... and also, do you have a matching kvm-unit-tests patch?
>>=20
>> I'll put one together, along with a test that shows the current
>> priority inversion between read-only and unsupported VMCS fields.
>=20
> I can't figure out how to clear IA32_VMX_MISC[bit 29] in qemu, so I'm
> going to add the test to tools/testing/selftests/kvm instead.

Please don=E2=80=99t.

I wish that we keep clear separation between kvm-unit-tests and =
self-tests.
In the sense that kvm-unit-tests tests for correct CPU behaviour =
semantics
and self-tests tests for correctness of KVM userspace API.

In the future, I wish to change kvm-unit-tests to cpu-unit-tests. As =
there is no
real connection to KVM. It=E2=80=99s a bunch of tests that can be run on =
top of any CPU
Implementation (weather vCPU by some hypervisor or bare-metal CPU) and
test for it=E2=80=99s semantics.
I have already used this to find semantic issues on Hyper-V vCPU =
implementation for example.

Regarding your question on how to disable IA32_VMX_MISC in QEMU:
Paolo have recently created a patch-series for QEMU that can be used to =
do this.
(Aimed for QEMU nVMX Live-Migration support)
See: https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg00711.html
(You should search for final patch-series version=E2=80=A6)

-Liran

