Return-Path: <kvm+bounces-7746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B182D845DDF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:56:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1AD01C2668B
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D34DF6D;
	Thu,  1 Feb 2024 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pSacDwcQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500D05CAF;
	Thu,  1 Feb 2024 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706806594; cv=none; b=N1pzUkdcFvp4x9kv8i5X110iJ2riWAWDZx844XMnB0U9LVOpVmjlmJ/irpXxb/fwobaLdTI7+lt4maHidH8Nln1cCBRamK1V3z7jyR0RR6hVnh+ig4msqsGbTxT6zMxQFn22u3r9dj7ndArHeuKOlmF0OSN6ZTC/mkCebO+3Xfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706806594; c=relaxed/simple;
	bh=AB9ax/8t0wejVj9CtQ5Su7le0JSY/WoSYrFGi7uK99A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=juPbzHayqifMAtgPKzxWvVui7+9yTHwFa7YtoEz8gLa7q16xStxfW2TFv6AU8glM0FT8OCWNmtIFYjTiULjNn6HPlE672ZjL5k1ZAYfhiau7dM6YPDNnp8WzviMtl6wGtXABPr5q1XVK4kkiFVOVmc4NamPFnRb5w7KLNChlLWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pSacDwcQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411GM8Up025717;
	Thu, 1 Feb 2024 16:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=TGuZpbQaYfHv91tvzcPlYr89K1RYmI9ZNSDUiqOumAM=;
 b=pSacDwcQmPMYZaopbb26LNhil8hlAlbCMKAwX9RcGs6OdrFSW65kYLtsYtk2qKqwMn98
 YnJw+YO/tgr8Aexk7AorTBX01ivNbhHgJZAC9sdJrbZNlNm1dWlcK4S/k5JoDN0O+L/l
 UhMZ3rE1zhqJwmdtN3EjrVFvUAv8FgoW+/SVtv6E9qfRRkngqxFAcStsCgArtKI5hJP3
 uRy+CsfO3oRqSdjddAcpQyZRu3GE9rERS8rzEcWrvCkG+33pIvkqCKGsP9xvvuAk7RfU
 x+I7in2D/xYZiZ8nS1mGRP671RFNet+hjvEBneoC0+jGxaTDyS1b0eC2khufRB11p8DG wg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0e6ej1jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 16:56:29 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411GguSt028856;
	Thu, 1 Feb 2024 16:56:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0e6ej1ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 16:56:29 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411GOSVZ010884;
	Thu, 1 Feb 2024 16:56:28 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vweckwa87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 16:56:28 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411GuRpm21168574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 16:56:28 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCEA35804E;
	Thu,  1 Feb 2024 16:56:27 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2EA058060;
	Thu,  1 Feb 2024 16:56:26 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.18.22])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Feb 2024 16:56:26 +0000 (GMT)
Message-ID: <f82ab76e5f389a92afe2fa8834812feeec4df4b5.camel@linux.ibm.com>
Subject: Re: [RFC PATCH] KVM: s390: remove extra copy of access registers
 into KVM_RUN
From: Eric Farman <farman@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Thu, 01 Feb 2024 11:56:26 -0500
In-Reply-To: <20240201151432.6306-C-hca@linux.ibm.com>
References: <20240131205832.2179029-1-farman@linux.ibm.com>
	 <20240201151432.6306-C-hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UwuggBJf7R37CyNEl0meptnfVcURyw4s
X-Proofpoint-ORIG-GUID: N7IRSIF4cshaldvrI24wWBHuDaiXpxuf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_04,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=490 phishscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010132

On Thu, 2024-02-01 at 16:14 +0100, Heiko Carstens wrote:
> On Wed, Jan 31, 2024 at 09:58:32PM +0100, Eric Farman wrote:
> > The routine ar_translation() is called by get_vcpu_asce(), which is
> > called from a handful of places, such as an interception that is
> > being handled during KVM_RUN processing. In that case, the access
> > registers of the vcpu had been saved to a host_acrs struct and then
> > the guest access registers loaded from the KVM_RUN struct prior to
> > entering SIE. Saving them back to KVM_RUN at this point doesn't do
> > any harm, since it will be done again at the end of the KVM_RUN
> > loop when the host access registers are restored.
> >=20
> > But that's not the only path into this code. The MEM_OP ioctl can
> > be used while specifying an access register, and will arrive here.
> >=20
> > Linux itself doesn't use the access registers for much, but it does
> > squirrel the thread local storage variable into ACRs 0 and 1 in
> > copy_thread() [1]. This means that the MEM_OP ioctl may copy
> > non-zero access registers (the upper- and lower-halves of the TLS
> > pointer) to the KVM_RUN struct, which will end up getting
> > propogated
> > to the guest once KVM_RUN ioctls occur. Since these are almost
> > certainly invalid as far as an ALET goes, an ALET Specification
> > Exception would be triggered if it were attempted to be used.
>=20
> What's the code path that can lead to this scenario?

When processing a KVM_RUN ioctl, the kernel is going to swap the
host/guest access registers in sync_regs, enter SIE, and then swap them
back in store_regs when it has to exit to userspace. So then on the
QEMU side it might look something like this:

kvm_arch_handle_exit
  handle_intercept
    handle_instruction
      handle_b2
        ioinst_handle_stsch
          s390_cpu_virt_mem_rw(ar=3D0xe, is_write=3Dtrue)
            kvm_s390_mem_op

Where the interesting registers at that point are:

acr0           0x3ff               1023
acr1           0x33bff8c0          868219072
...
acr14          0x0                 0

Note ACR0/1 are already buggered up from an earlier pass.

The above carries us through the kernel this way:

kvm_arch_vcpu_ioctl(KVM_S390_MEM_OP)
  kvm_s390_vcpu_memsida_op
    kvm_s390_vcpu_mem_op
      write_guest_with_key
        access_guest_with_key
          get_vcpu_asce
            ar_translate
              save_access_regs(kvm_run)

>=20
> > =C2=A0arch/s390/kvm/gaccess.c | 5 +++--
> > =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > index 5bfcc50c1a68..9205496195a4 100644
> > --- a/arch/s390/kvm/gaccess.c
> > +++ b/arch/s390/kvm/gaccess.c
> > @@ -380,6 +380,7 @@ void ipte_unlock(struct kvm *kvm)
> > =C2=A0static int ar_translation(struct kvm_vcpu *vcpu, union asce *asce=
,
> > u8 ar,
> > =C2=A0			=C2=A0 enum gacc_mode mode)
> > =C2=A0{
> > +	int acrs[NUM_ACRS];
> > =C2=A0	union alet alet;
> > =C2=A0	struct ale ale;
> > =C2=A0	struct aste aste;
> > @@ -391,8 +392,8 @@ static int ar_translation(struct kvm_vcpu
> > *vcpu, union asce *asce, u8 ar,
> > =C2=A0	if (ar >=3D NUM_ACRS)
> > =C2=A0		return -EINVAL;
> > =C2=A0
> > -	save_access_regs(vcpu->run->s.regs.acrs);
> > -	alet.val =3D vcpu->run->s.regs.acrs[ar];
> > +	save_access_regs(acrs);
> > +	alet.val =3D acrs[ar];
>=20
> If the above is like you said, then this code would use the host
> access register contents for ar translation of the guest?
>=20
> Or maybe I'm simply misunderstanding what you write.

Well regardless of this patch, I think it's using the contents of the
host registers today, isn't it? save_access_regs() does a STAM to put
the current registers into some bit of memory, so ar_translation() can
do regular logic against it. The above just changes WHERE that bit of
memory lives from something shared with another ioctl to something
local to ar_translation().=20

My original change just removed the save_access_regs() call entirely
and read the contents of the kvm_run struct since they were last saved
(see below). This "feels" better to me, and works for the scenario I
bumped into too. Maybe this is more appropriate?

---8<---

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 5bfcc50c1a68..c5ed3b0b665a 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -391,7 +391,6 @@ static int ar_translation(struct kvm_vcpu *vcpu,
union asce *asce, u8 ar,
        if (ar >=3D NUM_ACRS)
                return -EINVAL;
=20
-       save_access_regs(vcpu->run->s.regs.acrs);
        alet.val =3D vcpu->run->s.regs.acrs[ar];
=20
        if (ar =3D=3D 0 || alet.val =3D=3D 0) {


