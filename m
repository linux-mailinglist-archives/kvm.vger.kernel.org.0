Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E606F396
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 16:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfGUODx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 10:03:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfGUODx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 10:03:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6LE3ZaF005450;
        Sun, 21 Jul 2019 14:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=S9Ntij4tsEql4c3ZmuRZjVOlwBVq97lFQTFMZCPWEnQ=;
 b=VcCxcu43WTfsresQI0VAx/3uyojGxyy+JWmNfRmW0L1DeIcMuOwkOa9q3T2KmRF/QoM3
 YveGlYe0/cAVGT2Gu4bJcnkwGUeALeYle29xl+u9A4fLqPjtKXFvTEfVvYXSyYTc98zD
 BSVsg2lHqvm1Nry6Bl4R1iuA0DdSs5rru83ut2fpixTpqrX8OBMe4hgTuS6lANM5d4Qk
 VwC+sh3HHQ0N91YuLJlF20j2Q1Vl39hWaY/yWDSW4RNXxaSnL2J0m8f5Nzj44+iTdswi
 MRYNsAgl6c6s/UuKni1LuNszmuj+PK06ei/wcoQaqjDabyLIc+tgJqetIvGQpyTp61L4 Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tutct2w23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 14:03:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6LE3P0q020484;
        Sun, 21 Jul 2019 14:03:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tur2te0a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 14:03:35 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6LE3XTi027544;
        Sun, 21 Jul 2019 14:03:33 GMT
Received: from [192.168.14.112] (/79.181.226.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 21 Jul 2019 14:03:33 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when
 leaving nested
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <c464c26b-30d5-b897-4128-8df65a3f80ff@web.de>
Date:   Sun, 21 Jul 2019 17:03:30 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <76FC3DE7-144C-49F6-8814-6AF7935C8969@oracle.com>
References: <ee67b5c3-d660-179a-07fa-2bebdc940d4f@web.de>
 <A65A74C6-0F2D-4751-97CA-43CFC3A3CA63@oracle.com>
 <c464c26b-30d5-b897-4128-8df65a3f80ff@web.de>
To:     Jan Kiszka <jan.kiszka@web.de>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9325 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907210171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9325 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907210171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 21 Jul 2019, at 17:00, Jan Kiszka <jan.kiszka@web.de> wrote:
>=20
> On 21.07.19 13:57, Liran Alon wrote:
>>=20
>>=20
>>> On 21 Jul 2019, at 14:52, Jan Kiszka <jan.kiszka@web.de> wrote:
>>>=20
>>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>>=20
>>> Letting this pend may cause nested_get_vmcs12_pages to run against =
an
>>> invalid state, corrupting the effective vmcs of L1.
>>>=20
>>> This was triggerable in QEMU after a guest corruption in L2, =
followed by
>>> a L1 reset.
>>>=20
>>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>>=20
>> Good catch.
>> Reviewed-by: Liran Alon <liran.alon@oracle.com>
>>=20
>> This would have been more easily diagnosed in case free_nested() =
would NULL cached_vmcs12 and cached_shadow_vmcs12
>> after kfree() and add to get_vmcs12() & get_shadow_vmcs12() a =
relevant BUG_ON() call.
>=20
> The NULL'ifying makes sense, patch follows. But the helpers are too =
often called
> unconditionally, thus cause false positives when adding the BUG_ON.

How would having a BUG_ON(!cached_vmcs12) on get_vmcs12() will cause =
false positive?
I don=E2=80=99t see any legit case it is called and return NULL.

-Liran

>=20
> Jan
>=20
>>=20
>> I would submit such a patch separately.
>>=20
>> -Liran
>>=20
>>> ---
>>>=20
>>> And another gremlin. I'm afraid there is at least one more because
>>> vmport access from L2 is still failing in QEMU. This is just another
>>> fallout from that. At least the host seems stable now.
>>>=20
>>> arch/x86/kvm/vmx/nested.c | 2 ++
>>> 1 file changed, 2 insertions(+)
>>>=20
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index 0f1378789bd0..4cdab4b4eff1 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -220,6 +220,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
>>> 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
>>> 		return;
>>>=20
>>> +	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
>>> +
>>> 	vmx->nested.vmxon =3D false;
>>> 	vmx->nested.smm.vmxon =3D false;
>>> 	free_vpid(vmx->nested.vpid02);
>>> --
>>> 2.16.4

