Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A572F261767
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 19:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbgIHRdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 13:33:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5766 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731222AbgIHQPU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 12:15:20 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088BXKps112074;
        Tue, 8 Sep 2020 07:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=DhUcjCjKZ+JoKhxGWVEKJHua++DVEN5l3Ri/BKl7EgY=;
 b=FlesbxdeuOxLTPksIEym1ib8Gnr1+Zs7T96huKTun/j6RdrzVhA0+ISWUhXCMtS262D8
 HGh960yGzrmBnycx+HiKGz85+Tu7i5o3q0biiPDtNxRE5LO5hBdSeL6SqN7rrE6ojfn6
 jPN0bNGzLeygbueBT/QSKAcDNjaeeq27Ipjc4VG0ezy5epT2vPmkpYy8cgPGgfXHSFez
 RU+f80b9DiL0RnWXbB5YkX2pZQCEUOQZfb7Ky2a0V6/ToEj+B6bl5fFmhr0zVHKjlGFO
 e08lmZ6zVh8tmjzimVyzW1SYAg8P0mFtsEJOYmkrVGuFYrEBJrBGTchZh3K4dJ8it54c aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33e6q1nndy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 07:56:31 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 088BYrk9118993;
        Tue, 8 Sep 2020 07:56:31 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33e6q1nncp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 07:56:30 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 088BpmjT018399;
        Tue, 8 Sep 2020 11:56:28 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 33cm5hhnd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 11:56:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 088BuPVH30343492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 11:56:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99910A4053;
        Tue,  8 Sep 2020 11:56:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 446EAA4040;
        Tue,  8 Sep 2020 11:56:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.36.147])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Sep 2020 11:56:25 +0000 (GMT)
Subject: Re: [PATCH v3] KVM: s390: Introduce storage key removal facility
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20200908100249.23150-1-frankja@linux.ibm.com>
 <c926c50b-f161-03b0-18f5-ac3f01b7f9d9@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <743c6c99-3eb6-e508-0a07-0efb1ff8c201@linux.ibm.com>
Date:   Tue, 8 Sep 2020 13:56:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c926c50b-f161-03b0-18f5-ac3f01b7f9d9@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7b9jHCYOW2Rt9MlQChg19rPM5G8q76K3X"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_06:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7b9jHCYOW2Rt9MlQChg19rPM5G8q76K3X
Content-Type: multipart/mixed; boundary="jWbmSptpRdxaBISBQiQsZycONMNOqCYhB"

--jWbmSptpRdxaBISBQiQsZycONMNOqCYhB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/8/20 12:16 PM, David Hildenbrand wrote:
> On 08.09.20 12:02, Janosch Frank wrote:
>> The storage key removal facility makes skey related instructions
>> result in special operation program exceptions. It is based on the
>> Keyless Subset Facility.
>>
>> The usual suspects are iske, sske, rrbe and their respective
>> variants. lpsw(e), pfmf and tprot can also specify a key and essa with=

>> an ORC of 4 will consult the change bit, hence they all result in
>> exceptions.
>>
>> Unfortunately storage keys were so essential to the architecture, that=

>> there is no facility bit that we could deactivate. That's why the
>> removal facility (bit 169) was introduced which makes it necessary,
>> that, if active, the skey related facilities 10, 14, 66, 145 and 149
>> are zero. Managing this requirement and migratability has to be done
>> in userspace, as KVM does not check the facilities it receives to be
>> able to easily implement userspace emulation.
>>
>> Removing storage key support allows us to circumvent complicated
>> emulation code and makes huge page support tremendously easier.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>
>> v3:
>> 	* Put kss handling into own function
>> 	* Removed some unneeded catch statements and converted others to ifs
>>
>> v2:
>> 	* Removed the likely
>> 	* Updated and re-shuffeled the comments which had the wrong informati=
on
>>
>> ---
>>  arch/s390/kvm/intercept.c | 34 +++++++++++++++++++++++++++++++++-
>>  arch/s390/kvm/kvm-s390.c  |  5 +++++
>>  arch/s390/kvm/priv.c      | 26 +++++++++++++++++++++++---
>>  3 files changed, 61 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>> index e7a7c499a73f..9c699c3fcf84 100644
>> --- a/arch/s390/kvm/intercept.c
>> +++ b/arch/s390/kvm/intercept.c
>> @@ -33,6 +33,7 @@ u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
>>  	case ICPT_OPEREXC:
>>  	case ICPT_PARTEXEC:
>>  	case ICPT_IOINST:
>> +	case ICPT_KSS:
>>  		/* instruction only stored for these icptcodes */
>>  		ilen =3D insn_length(vcpu->arch.sie_block->ipa >> 8);
>>  		/* Use the length of the EXECUTE instruction if necessary */
>> @@ -531,6 +532,37 @@ static int handle_pv_notification(struct kvm_vcpu=
 *vcpu)
>>  	return handle_instruction(vcpu);
>>  }
>> =20
>> +static int handle_kss(struct kvm_vcpu *vcpu)
>> +{
>> +	if (!test_kvm_facility(vcpu->kvm, 169))
>> +		return kvm_s390_skey_check_enable(vcpu);
>> +
>> +	/*
>> +	 * Storage key removal facility emulation.
>> +	 *
>> +	 * KSS is the same priority as an instruction
>> +	 * interception. Hence we need handling here
>> +	 * and in the instruction emulation code.
>> +	 *
>> +	 * KSS is nullifying (no psw forward), SKRF
>> +	 * issues suppressing SPECIAL OPS, so we need
>> +	 * to forward by hand.
>> +	 */
>> +	if  (vcpu->arch.sie_block->ipa =3D=3D 0) {
>> +		/*
>> +		 * Interception caused by a key in a
>> +		 * exception new PSW mask. The guest
>> +		 * PSW has already been updated to the
>> +		 * non-valid PSW so we only need to
>> +		 * inject a PGM.
>> +		 */
>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> +	}
>> +
>> +	kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
>> +	return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>> +}
>> +
>>  int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>>  {
>>  	int rc, per_rc =3D 0;
>> @@ -565,7 +597,7 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu=
)
>>  		rc =3D handle_partial_execution(vcpu);
>>  		break;
>>  	case ICPT_KSS:
>> -		rc =3D kvm_s390_skey_check_enable(vcpu);
>> +		rc =3D handle_kss(vcpu);
>>  		break;
>>  	case ICPT_MCHKREQ:
>>  	case ICPT_INT_ENABLE:
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 6b74b92c1a58..85647f19311d 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2692,6 +2692,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned =
long type)
>>  	/* we emulate STHYI in kvm */
>>  	set_kvm_facility(kvm->arch.model.fac_mask, 74);
>>  	set_kvm_facility(kvm->arch.model.fac_list, 74);
>> +	/* we emulate the storage key removal facility only with kss */
>> +	if (sclp.has_kss) {
>> +		set_kvm_facility(kvm->arch.model.fac_mask, 169);
>> +		set_kvm_facility(kvm->arch.model.fac_list, 169);
>> +	}
>>  	if (MACHINE_HAS_TLB_GUEST) {
>>  		set_kvm_facility(kvm->arch.model.fac_mask, 147);
>>  		set_kvm_facility(kvm->arch.model.fac_list, 147);
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index cd74989ce0b0..5e3583b8b5e3 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -207,6 +207,13 @@ int kvm_s390_skey_check_enable(struct kvm_vcpu *v=
cpu)
>>  	int rc;
>> =20
>>  	trace_kvm_s390_skey_related_inst(vcpu);
>> +
>> +	if (test_kvm_facility(vcpu->kvm, 169)) {
>> +		rc =3D kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>> +		if (!rc)
>> +			return -EOPNOTSUPP;
>> +	}
>> +
>>  	/* Already enabled? */
>>  	if (vcpu->arch.skey_enabled)
>>  		return 0;
>> @@ -257,7 +264,7 @@ static int handle_iske(struct kvm_vcpu *vcpu)
>> =20
>>  	rc =3D try_handle_skey(vcpu);
>>  	if (rc)
>> -		return rc !=3D -EAGAIN ? rc : 0;
>> +		return (rc !=3D -EAGAIN || rc !=3D -EOPNOTSUPP) ? rc : 0;
>=20
> If rc =3D=3D -EAGAIN you used to return 0.
>=20
> Now, "-EAGAIN !=3D -EAGAIN || -EAGAIN !=3D -EOPNOTSUPP"
>=20
> evaluates to "false || true =3D=3D true"
>=20
> so you would return rc =3D=3D -EAGAIN - is that what you really want?
>=20
> (I've been on vacation for two weeks, my mind might not be fully back :=
D )

As you can clearly tell, I'm waiting for my vacation to finally arrive.

>=20
>> =20
>>  	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
>> =20
>> @@ -304,7 +311,7 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
>> =20
>>  	rc =3D try_handle_skey(vcpu);
>>  	if (rc)
>> -		return rc !=3D -EAGAIN ? rc : 0;
>> +		return (rc !=3D -EAGAIN || rc !=3D -EOPNOTSUPP) ? rc : 0;
>> =20
>>  	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
>> =20
>> @@ -355,7 +362,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
>> =20
>>  	rc =3D try_handle_skey(vcpu);
>>  	if (rc)
>> -		return rc !=3D -EAGAIN ? rc : 0;
>> +		return (rc !=3D -EAGAIN || rc !=3D -EOPNOTSUPP) ? rc : 0;
>> =20
>>  	if (!test_kvm_facility(vcpu->kvm, 8))
>>  		m3 &=3D ~SSKE_MB;
>> @@ -745,6 +752,8 @@ int kvm_s390_handle_lpsw(struct kvm_vcpu *vcpu)
>>  		return kvm_s390_inject_prog_cond(vcpu, rc);
>>  	if (!(new_psw.mask & PSW32_MASK_BASE))
>>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> +	if (new_psw.mask & PSW32_MASK_KEY && test_kvm_facility(vcpu->kvm, 16=
9))
>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>=20
> You don't use parentheses around & here ...
>=20
>>  	gpsw->mask =3D (new_psw.mask & ~PSW32_MASK_BASE) << 32;
>>  	gpsw->mask |=3D new_psw.addr & PSW32_ADDR_AMODE;
>>  	gpsw->addr =3D new_psw.addr & ~PSW32_ADDR_AMODE;
>> @@ -771,6 +780,8 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
>>  	rc =3D read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
>>  	if (rc)
>>  		return kvm_s390_inject_prog_cond(vcpu, rc);
>> +	if ((new_psw.mask & PSW_MASK_KEY) && test_kvm_facility(vcpu->kvm, 16=
9))
>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>>  	vcpu->arch.sie_block->gpsw =3D new_psw;
>>  	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
>>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> @@ -1025,6 +1036,10 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
>>  	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>> =20
>> +	if (vcpu->run->s.regs.gprs[reg1] & PFMF_SK &&
>=20
> ... and here ...
>=20
>> +	    test_kvm_facility(vcpu->kvm, 169))
>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>> +
>>  	if (vcpu->run->s.regs.gprs[reg1] & PFMF_RESERVED)
>>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> =20
>> @@ -1203,6 +1218,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
>>  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>  	/* Check for invalid operation request code */
>>  	orc =3D (vcpu->arch.sie_block->ipb & 0xf0000000) >> 28;
>> +	if (orc =3D=3D ESSA_SET_POT_VOLATILE && test_kvm_facility(vcpu->kvm,=
 169))
>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>>  	/* ORCs 0-6 are always valid */
>>  	if (orc > (test_kvm_facility(vcpu->kvm, 147) ? ESSA_SET_STABLE_NODAT=

>>  						: ESSA_SET_STABLE_IF_RESIDENT))
>> @@ -1451,6 +1468,9 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
>> =20
>>  	kvm_s390_get_base_disp_sse(vcpu, &address1, &address2, &ar, NULL);
>> =20
>> +	if ((address2 & 0xf0) && test_kvm_facility(vcpu->kvm, 169))
>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>> +
>=20
> ... but you do here

I'll add some

>=20
>>  	/* we only handle the Linux memory detection case:
>>  	 * access key =3D=3D 0
>>  	 * everything else goes to userspace. */
>>
>=20
>=20
> Do we have to are about vsie? If the g2 CPU does not have storage keys,=

> also g3 should not. I can spot KSS handling in vsie code - is that
> sufficient?

You mean the two lines that take care of the cpuflags?
That's KSS passthrough and fallback to ICTLs if there is no KSS.

That's an interesting problem.
That would mean we would need to force KSS instead of doing a
passthrough for the G3 if SKRF is enabled in G2. The intercept priority
problem will make this even more awkward.

I'll need to think about this for a bit and speak to the CPU
architecture people to clear this up. This could take a bit of time
because of various vacations.


--jWbmSptpRdxaBISBQiQsZycONMNOqCYhB--

--7b9jHCYOW2Rt9MlQChg19rPM5G8q76K3X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl9XcWgACgkQ41TmuOI4
ufhbDRAA1paty8ttI4nsFe04zmJxoSdj477A537GwWYkwn6tsAmdYjXADu+Itpv2
IYzbEOK024oFdOgS24Y+oKU0nuX9Aoj7CgEhOGOWFyQVi3FjyFD1oxIIZN/B1jom
e7Q422iKf/NgjBs55Ilw2GyS+A6SfjT4PG3gBHIVWaAyEZAL2084YFPy49xipeWB
P/qt4YKu3R2DGx6SE+bj+mJrUqfksSIQFYlTxqZc7zSxTq+oNRVoDIZ0yauavbih
G0VHvaa4KFpdpvlOMoTpZwJ2wLpdf+WgZAG5rcBAo2Inikh1JM7baDbgNpLXHUlP
J6hLWs5R0TVVFIQUuavsR6ImxUlz74lU6uRYS6zAxKGeGZ8PgtpIOFqne3f3X9tN
2wKZYnjNIQghzQM7HCMF7Vz2BWUnrUZ3BU/983OZtTE82XBCXXOP6/gAwhQS3Le/
HEuWE9H9t5LH8G523YvmwrWreJDZYKSY25815flDi9IYkcfBWs9J12H6SQKD+OnC
Fo/qHqCY0auBVvju4jxSQdS3dwIaGpvCbvSRTOmAtYTsjGoAg4oFPpQHz+XLcIoT
nBcy+BPSK5O6kJOFqA3Ylz7mS+7EOEjkrLY4Eo30hb05IGHplP9+4xg608aZznpC
UuUwc1sQjqoavemvn1Ob1Ovfp5yMDZBLrNp4uCI96xcN3KIS2as=
=dVzO
-----END PGP SIGNATURE-----

--7b9jHCYOW2Rt9MlQChg19rPM5G8q76K3X--

