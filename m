Return-Path: <kvm+bounces-8112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1046D84BB9D
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 353F61C24072
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 17:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C096FAF;
	Tue,  6 Feb 2024 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Yg2vUtp+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBF58F61;
	Tue,  6 Feb 2024 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707239227; cv=none; b=XgyblJHSRoU7oduGRMJtikguZLydkkbP3EIFysim9EZmM/5nAfUZqNgrqzq8O84YqoxmaWR+VxXhzJBqXsd1TnttyN/hRfaTvF8z7osNiGXu7bFcwbFUjA3WBoT7FLvlyzs0oF1wbdawjQN+T/6FHt95z/PCoMSyq/F7EAUon4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707239227; c=relaxed/simple;
	bh=e9I7yxTk4EenZMNZtmxp4IEHqEX5dcbETrSelLjJYbU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YMtFs3wd2TKRtdFfF/negX1WW/15+csbeKP+nep35cqCJ93+kpeL2CKy2CD9ZHVpLuchafQraAE26HdOU3pjTMrGBqLy3tldRqxJWt0ugaECWSMLV6n65+6xD//DhBvHnnwECeMdK4MKGYVuM1e23iqnUE22//g1xFcGQ09godw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Yg2vUtp+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 416GrJ83011255;
	Tue, 6 Feb 2024 17:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=XACviP5l9u565lkp/k5MToie0mpAeRjNuB4FYovFReY=;
 b=Yg2vUtp+yu3wTV2rJEalE1WvyzFS89fHcRDBpdcPUPi6IXjrlJaQyyDMzaCP5LSI0CtO
 ul5yXaUuwsFu/YkYJXP057mk1v1o1qgypbBMEG0NtoA8b6neINshhp+2hHSh11kCQyrG
 KGjO5HGQ3Qa4UolIEoDkA36VNVfDKY0VJMd6X3kBTBtTQzB9g3AuNG4hHsWpc00KEtEt
 5XhqtmC+ShYjrYyd0yqLa44lDbmdaB3YI+e6Q70MXi+AhTbhXBk8VD9p8Q20+X6VXo5d
 Dbg9I523954PSGjPVC5LKDzrYuSVxnT4qbeH8jEoAfrfemjkW26Y1tf0vEXMGdzdFtcE vg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w3rp80q3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 17:07:04 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 416Groc3014373;
	Tue, 6 Feb 2024 17:07:04 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w3rp80q39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 17:07:03 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 416FYaD8014837;
	Tue, 6 Feb 2024 17:07:03 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w20tnrchm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 17:07:03 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 416H72jC35324510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Feb 2024 17:07:02 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F33A58052;
	Tue,  6 Feb 2024 17:07:02 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A54E858067;
	Tue,  6 Feb 2024 17:07:01 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.18.22])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 Feb 2024 17:07:01 +0000 (GMT)
Message-ID: <9636b91f008edd897aec43e79f83229cafafb752.camel@linux.ibm.com>
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
Date: Tue, 06 Feb 2024 12:07:01 -0500
In-Reply-To: <20240206154708.26070-C-hca@linux.ibm.com>
References: <20240131205832.2179029-1-farman@linux.ibm.com>
	 <20240201151432.6306-C-hca@linux.ibm.com>
	 <f82ab76e5f389a92afe2fa8834812feeec4df4b5.camel@linux.ibm.com>
	 <20240206154708.26070-C-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: FM07rr4tCi09TZPuYY3rPT4W4lp8ZX2C
X-Proofpoint-GUID: k64WBqnVXZDDUSry7AEby3qPZpDWH6dd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-06_10,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=348 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402060120

On Tue, 2024-02-06 at 16:47 +0100, Heiko Carstens wrote:
> On Thu, Feb 01, 2024 at 11:56:26AM -0500, Eric Farman wrote:
> > On Thu, 2024-02-01 at 16:14 +0100, Heiko Carstens wrote:
> > > On Wed, Jan 31, 2024 at 09:58:32PM +0100, Eric Farman wrote:
> > > What's the code path that can lead to this scenario?
> >=20
> > When processing a KVM_RUN ioctl, the kernel is going to swap the
> > host/guest access registers in sync_regs, enter SIE, and then swap
> > them
> > back in store_regs when it has to exit to userspace. So then on the
> > QEMU side it might look something like this:
> >=20
> > kvm_arch_handle_exit
> > =C2=A0 handle_intercept
> > =C2=A0=C2=A0=C2=A0 handle_instruction
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 handle_b2
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ioinst_handle_stsch
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s390_cpu_virt_me=
m_rw(ar=3D0xe, is_write=3Dtrue)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_=
s390_mem_op
> >=20
> > Where the interesting registers at that point are:
> >=20
> > acr0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x3ff=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 1023
> > acr1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x33bf=
f8c0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 868219072
> > ...
> > acr14=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0
> >=20
> > Note ACR0/1 are already buggered up from an earlier pass.
> >=20
> > The above carries us through the kernel this way:
> >=20
> > kvm_arch_vcpu_ioctl(KVM_S390_MEM_OP)
> > =C2=A0 kvm_s390_vcpu_memsida_op
> > =C2=A0=C2=A0=C2=A0 kvm_s390_vcpu_mem_op
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 write_guest_with_key
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 access_guest_with_key
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 get_vcpu_asce
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ar_t=
ranslate
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 save_access_regs(kvm_run)
>=20
> ...
>=20
> > Well regardless of this patch, I think it's using the contents of
> > the
> > host registers today, isn't it? save_access_regs() does a STAM to
> > put
> > the current registers into some bit of memory, so ar_translation()
> > can
> > do regular logic against it. The above just changes WHERE that bit
> > of
> > memory lives from something shared with another ioctl to something
> > local to ar_translation().=20
>=20
> This seems to be true; but there are also other code paths which can
> reach ar_translation() where the access register contents actually do
> belong to the guest (e.g. intercept handling).

Right, the trouble is that both scenarios end up here. Storing the
access registers here in the intercept path "doesn't hurt" because
it'll be done again when we clean up after the SIE exit (store_regs()),
and the original patch keeps the behavior the same for the memop case
without disrupting the kvm_run space. I agree this behavior doesn't
seem right.

>=20
> > My original change just removed the save_access_regs() call
> > entirely
> > and read the contents of the kvm_run struct since they were last
> > saved
> > (see below). This "feels" better to me, and works for the scenario
> > I
> > bumped into too. Maybe this is more appropriate?
> >=20
> > ---8<---
> >=20
> > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > index 5bfcc50c1a68..c5ed3b0b665a 100644
> > --- a/arch/s390/kvm/gaccess.c
> > +++ b/arch/s390/kvm/gaccess.c
> > @@ -391,7 +391,6 @@ static int ar_translation(struct kvm_vcpu
> > *vcpu,
> > union asce *asce, u8 ar,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ar >=3D NUM_ACRS)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 save_access_regs(vcpu->run->s.reg=
s.acrs);
>=20
> I guess this and your previous patch are both not correct.

Yay? :)

>  There is
> different handling required depending on if current access register
> contents belong to the host or guest (both seems to be possible),
> when
> the function is entered.
>=20
> But anyway, I'll leave that up to Janosch and Claudio, just had a
> quick
> look at your patch :)
>=20

Thanks for the quick look. Will wait for Janosch and Claudio to get a
couple cycles.

