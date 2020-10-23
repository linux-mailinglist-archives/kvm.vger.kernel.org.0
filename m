Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390A2296A4C
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 09:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375694AbgJWHZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 03:25:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S374195AbgJWHZT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 03:25:19 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09N73sM2098590
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 03:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=APJ7EW6wwAeQJpdMcreMXk3JweX3naACjkjW9j2VvA4=;
 b=nZNf1YHl2dZddOo395B2RgEtEM93L0Ptzz5yGfTBSFvDIyBozQ+/N7wHGJ8ee6FIzB5P
 r78PxYNiNo8pHBLv0ldPKL5M1aNpmnfi7juKwXfX0DY5t/BFqn3rOdPWuhVfdfVQmjfK
 nWo2n8KfdbTWnL/MSRXaTnwERlbGB6MlV6juaWqiUN63MViiwGRRqTcVT3eQDNxCz71I
 OCFhg32E2RTZo4GXmC8zUBxicL54MvcpI7mZk97EqsIWDlEIEdbJ6ao+GrmAujFQHbz/
 BOaz08EtRed6Cx7kCziGougo2jiOfOf5RD4DGUZvfgguoP8ZXscRSHXhOjz9y7NXt9pg zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34bn1k09jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 03:25:17 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09N75JUM106842
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 03:25:17 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34bn1k09j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 03:25:17 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09N7IJoo028185;
        Fri, 23 Oct 2020 07:25:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 347qvhe9q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 07:25:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09N7PCGW15663572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 07:25:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13A3DA406D;
        Fri, 23 Oct 2020 07:25:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3F19A4059;
        Fri, 23 Oct 2020 07:25:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.173])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Oct 2020 07:25:11 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] s390/kvm: fix diag318 reset
To:     Collin Walling <walling@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com
References: <20201015195913.101065-1-walling@linux.ibm.com>
 <20201015195913.101065-2-walling@linux.ibm.com>
 <eb8dc053-d8e6-7ef4-e722-101ab3135266@linux.ibm.com>
 <246ad72a-a081-d25a-33fd-843edaeb9248@de.ibm.com>
 <5cb6294a-b1ff-ba09-a47b-76f39a5e844a@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <68b946a8-1679-fe36-1c0a-236000975c3a@linux.ibm.com>
Date:   Fri, 23 Oct 2020 09:25:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <5cb6294a-b1ff-ba09-a47b-76f39a5e844a@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="no86Vw24XSI600AjKVNIehnffz3QF7dHO"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-23_03:2020-10-20,2020-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--no86Vw24XSI600AjKVNIehnffz3QF7dHO
Content-Type: multipart/mixed; boundary="eo0XSNv2jCArTdndRaiRvEzlMQVJAJqUy"

--eo0XSNv2jCArTdndRaiRvEzlMQVJAJqUy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/22/20 3:43 PM, Collin Walling wrote:
> On 10/16/20 3:44 AM, Christian Borntraeger wrote:
>>
>>
>> On 16.10.20 09:34, Janosch Frank wrote:
>>> On 10/15/20 9:59 PM, Collin Walling wrote:
>>>> The DIAGNOSE 0x0318 instruction must be reset on a normal and clear
>>>> reset. However, this was missed for the clear reset case.
>>>>
>>>> Let's fix this by resetting the information during a normal reset.=20
>>>> Since clear reset is a superset of normal reset, the info will
>>>> still reset on a clear reset.
>>>
>>> The architecture really confuses me here but I think we don't want th=
is
>>> in the kernel VCPU reset handlers at all.
>>>
>>> This needs to be reset per VM *NOT* per VCPU.
>>> Hence the resets are bound to diag308 and not SIGP.
>>>
>>> I.e. we need to clear it in QEMU's VM reset handler.
>>> It's still early and I have yet to consume my first coffee, am I miss=
ing
>>> something?
>>
>> I agree with Janosch. architecture indicates that this should only be =
reset
>> for VM-wide resets, e.g. sigp orders 11 and 12 are explicitly mentione=
d
>> to NOT reset the value.
>>
>=20
> A few questions regarding how resets for diag318 should work here:
>=20
> The AR states that any copies retained by the diag318 should be set to =
0
> on a clear reset and load normal -- I thought both of those resets were=

> implicitly called by diag308 as well?
>=20
> Should the register used to store diag318 info not be set to 0 *by KVM*=

> then? Should the values be set *by QEMU* and a subsequent sync_regs wil=
l
> ensure things are sane on the KVM side?

Just a FYI for the non-IBMers reading in:

I have spoken to the author of the architecture and cleared up our way
forward.

* We need to clear on diag 308 subcodes 0,1,3,4
* SIGP does not alter diag318 data in any way
* We need to set the cpnc on all VCPUs of the VM


>=20
>>>
>>>>
>>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>>> ---
>>>>  arch/s390/kvm/kvm-s390.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 6b74b92c1a58..b0cf8367e261 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -3516,6 +3516,7 @@ static void kvm_arch_vcpu_ioctl_normal_reset(s=
truct kvm_vcpu *vcpu)
>>>>  	vcpu->arch.sie_block->gpsw.mask &=3D ~PSW_MASK_RI;
>>>>  	vcpu->arch.pfault_token =3D KVM_S390_PFAULT_TOKEN_INVALID;
>>>>  	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb)=
);
>>>> +	vcpu->run->s.regs.diag318 =3D 0;
>>>> =20
>>>>  	kvm_clear_async_pf_completion_queue(vcpu);
>>>>  	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
>>>> @@ -3582,7 +3583,6 @@ static void kvm_arch_vcpu_ioctl_clear_reset(st=
ruct kvm_vcpu *vcpu)
>>>> =20
>>>>  	regs->etoken =3D 0;
>>>>  	regs->etoken_extension =3D 0;
>>>> -	regs->diag318 =3D 0;
>>>>  }
>>>> =20
>>>>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_=
regs *regs)
>>>>
>>>
>>>
>=20
>=20



--eo0XSNv2jCArTdndRaiRvEzlMQVJAJqUy--

--no86Vw24XSI600AjKVNIehnffz3QF7dHO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl+ShVcACgkQ41TmuOI4
ufg8xxAA1eneYwT+nPz0a6vggzz/zSqq6mWjrPF2rhI0M0AvHt341rOG9lKhTrOa
zn/opWOHpfa9c/w8LYISxxKnpqIm1vsEtd//Lp0l67gUZnP0dtiv04ahQWllsMk9
qSbachssIXbJn2hMd2cxNpVPA/k3it4r/kBbxZqkm+6r4wotGm+mnrnFsBI0IfrH
xsanr6AGkpjMLJDI3vRCJr4gk7Nv44fJjMqCwOMbn2AOLoJAATPstCp5E4mVNXRc
qHru4asszlcvqhBsX/Qw0TDUKHoTYm9kMKF2b8hYOvp4TYJ6oLxUru5MgrANqcDK
p8KviKwZ2ZMfLKTrWapo8ZPjQJlLu+R8rzZvfR2ivKNrVSFpzfgqLbSQD4YAxLpG
gVXE8iOgesDxo3E47AzW+AYkNG+feRUPJYLNesJX+RQlU5hmLmzXjSFirD3P21JP
4dmKWSo7wgmeiBnYidZVaFjgIHGCnHvwH3oGOVRrelWGEY7RIOqdgkJd4YBvuqou
RO0aj96yAwI63RrJAw+OdTMAEhayfyrJSILErZnMnZ+vUac65+sSA/K2OFzqC/uh
XADt5jG9GX3DmJVyXH9c3VmA74kOOWLLOjAq3UrwaP8v9kNRRmREbu5umTX44/m1
sbFd1CZbXaEa3GCRml/nUlhaNQ29V/JvMCkrun/sER/EKuxPhUQ=
=rMoR
-----END PGP SIGNATURE-----

--no86Vw24XSI600AjKVNIehnffz3QF7dHO--

