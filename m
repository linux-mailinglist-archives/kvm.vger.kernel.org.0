Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546EF5FAF0
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfGDPfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 11:35:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39028 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfGDPfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 11:35:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x64FYKYl076730;
        Thu, 4 Jul 2019 15:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=hGR7YFPXzIc+qrlVGBLWd28DGtpEfZpFnh2JmNxsOWA=;
 b=AA/T/0VMzOJE6uo2qR7GBd627ZTIK7kyjCLXwD6pxXYkAX3JjkT9o0J/7JwslDBUcvcq
 cJ3bdUrusXQU+zxi9FJX1beyCPZDZJBg8sNcglTjn5gQHV7YvqkmqTh52oRLbtcxl3ui
 VCeiE+RIy2g7nhtGS/dr6dCacwVMrxkCGcOuI7SFpk6J9R+dDCeryoan4gr/KmLiSDoF
 BazSwebl6MLDxxxnvLej9U+VkDLW0jSX2re7KVd+x1PXsXMFGqrJu5UbJdHQMorb5gqM
 7UHO2UXVNEe0005gf0N/4+YrD3xAL/lSsDV3qWc/33fCDTQKtkHOWa8cskLVvI4ecsWV 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2te61efd2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 15:35:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x64FX8E9192678;
        Thu, 4 Jul 2019 15:35:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2th5qm3pcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 15:35:00 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x64FYx6Y026908;
        Thu, 4 Jul 2019 15:34:59 GMT
Received: from [10.30.3.14] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Jul 2019 08:34:59 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] target/i386: kvm: Fix when nested state is needed for
 migration
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <c5e7fd4d-3554-4df9-1e92-49e4ec02d653@redhat.com>
Date:   Thu, 4 Jul 2019 18:34:55 +0300
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Karl Heubaum <karl.heubaum@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <24787A1B-1CD5-40C3-8CB2-FB16039EC5E6@oracle.com>
References: <20190624230514.53326-1-liran.alon@oracle.com>
 <6499083f-c159-1c3e-0339-87aa5b13c2c0@redhat.com>
 <432511A2-C6B4-4B03-87A5-176D886C0BF2@oracle.com>
 <c5e7fd4d-3554-4df9-1e92-49e4ec02d653@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907040197
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907040197
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 4 Jul 2019, at 18:29, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 04/07/19 16:31, Liran Alon wrote:
>>=20
>>=20
>>> On 2 Jul 2019, at 19:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>=20
>>> On 25/06/19 01:05, Liran Alon wrote:
>>>> When vCPU is in VMX operation and enters SMM mode,
>>>> it temporarily exits VMX operation but KVM maintained nested-state
>>>> still stores the VMXON region physical address, i.e. even when the
>>>> vCPU is in SMM mode then (nested_state->hdr.vmx.vmxon_pa !=3D =
-1ull).
>>>>=20
>>>> Therefore, there is no need to explicitly check for
>>>> KVM_STATE_NESTED_SMM_VMXON to determine if it is necessary
>>>> to save nested-state as part of migration stream.
>>>>=20
>>>> In addition, destination must enable eVMCS if it is enabled on
>>>> source as specified by the KVM_STATE_NESTED_EVMCS flag, even if
>>>> the VMXON region is not set. Thus, change the code to require =
saving
>>>> nested-state as part of migration stream in case it is set.
>>>>=20
>>>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>>>> ---
>>>> target/i386/machine.c | 2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>=20
>>>> diff --git a/target/i386/machine.c b/target/i386/machine.c
>>>> index 851b249d1a39..e7d72faf9e24 100644
>>>> --- a/target/i386/machine.c
>>>> +++ b/target/i386/machine.c
>>>> @@ -999,7 +999,7 @@ static bool vmx_nested_state_needed(void =
*opaque)
>>>>=20
>>>>    return ((nested_state->format =3D=3D =
KVM_STATE_NESTED_FORMAT_VMX) &&
>>>>            ((nested_state->hdr.vmx.vmxon_pa !=3D -1ull) ||
>>>> -             (nested_state->hdr.vmx.smm.flags & =
KVM_STATE_NESTED_SMM_VMXON)));
>>>> +             (nested_state->flags & KVM_STATE_NESTED_EVMCS)));
>>>> }
>>>>=20
>>>> static const VMStateDescription vmstate_vmx_nested_state =3D {
>>>>=20
>>>=20
>>> Queued, thanks.
>>>=20
>>> Paolo
>>=20
>> Actually Paolo after I have created KVM patch
>> ("KVM: nVMX: Change KVM_STATE_NESTED_EVMCS to signal vmcs12 is copied =
from eVMCS=E2=80=9D)
>> I think I realised that KVM_STATE_NESTED_EVMCS is actually not a =
requirement for nested-state to be sent.
>> I suggest to replace this commit with another one that just change =
vmx_nested_state_needed() to return true
>> In case format is FORMAT_VMX and vmxon_pa !=3D -1ull and that=E2=80=99s=
 it.
>>=20
>> As anyway, QEMU provisioned on destination side is going to enable =
the relevant eVMCS capability.
>> I=E2=80=99m going to send another series that refines QEMU =
nested-migration a bit more so I will do it along the way.
>> But I think this patch should be un-queued. Sorry for realizing this =
later but at least it=E2=80=99s before it was merged to master :)
>=20
> Replaced with
>=20
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 851b249d1a..704ba6de46 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -997,9 +997,8 @@ static bool vmx_nested_state_needed(void *opaque)
> {
>     struct kvm_nested_state *nested_state =3D opaque;
>=20
> -    return ((nested_state->format =3D=3D KVM_STATE_NESTED_FORMAT_VMX) =
&&
> -            ((nested_state->hdr.vmx.vmxon_pa !=3D -1ull) ||
> -             (nested_state->hdr.vmx.smm.flags & =
KVM_STATE_NESTED_SMM_VMXON)));
> +    return (nested_state->format =3D=3D KVM_STATE_NESTED_FORMAT_VMX =
&&
> +            nested_state->hdr.vmx.vmxon_pa !=3D -1ull);
> }
>=20
> static const VMStateDescription vmstate_vmx_nested_state =3D {
>=20
> and dropped the last paragraph of the commit message.
>=20
> Paolo
>=20

Yep that=E2=80=99s what I wanted to do.
Thanks. I have some more patches pending anyway but unrelated to this. =
This now seems good to me.

-Liran


