Return-Path: <kvm+bounces-47292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 112F8ABFA50
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B1BF9E67D6
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBBC221F10;
	Wed, 21 May 2025 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KAHkfWdQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890511EB18D;
	Wed, 21 May 2025 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842416; cv=none; b=RbcpGhQmShYkfgGTr2NH9P5F3uNAV9ngWDhRs09Cx+iUB8dxSPLHK+jnWyF18At0aS3PsfEv9JJwzeZO08OWv2RC92Y5UYQjOqXAo3lmW8Rm7MNYYDKkW0NygCSC7tJq/Cg82Foc+rO72WS0IyJXgvqRi0FHIhd4Q0lus4dZTdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842416; c=relaxed/simple;
	bh=xs6MyiJsl4816VLbkiYJIjZ52nVBNYDg6IflP+yXM5o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ozyabUKB9ceBH35oSMyqlLIgBFFobE5D496v196aZWNE6ky5jWR0naXCttl6PY+MiDfc4SEIWnrgviCB0bivTOLxMkng7ACibcZAFkoZcFdVDTE602THaTHqSQm7S6Np2Gjo7PFEHgU/nF/axysWeUVc6I/fgvKMn+mRnzA9hzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KAHkfWdQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LDnJmq006706;
	Wed, 21 May 2025 15:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Wx1Lgm
	ZxF+Xwm4tlerhs5YqUIvIJlk0ChbGGpQkmSYs=; b=KAHkfWdQZKB4cbteFbtz8V
	Ex11MQzhuBFamyqER/nkOQ/MauwI77DW+qYZ99McBOsljKu1a+be6TXhWp9NtFpV
	E29jRXfNEWkrwWqsw0qzLMFY+filt+GqOO5tqvpa8mhF6qxHZ3v/L1WwyEqNI2t7
	epxbY/Pyh7KVpU3yh0OHQ3lYUK6XJYwqLQ/xMR72duwd/jiphwZiLGMEqgqAOULC
	9mkikP/HC7oaLVc71+wocKIotZVUZj9ciu4dvV5qSywMEjFtcgc2S5/4SB9nN0mu
	q6oDGFDvgkNZsX7Gjq2DA/fHFD2TQsIEwAaVb0Tz6seNflsUtORmrVrLpVvnKouQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sg230m3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:46:50 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54LDu4Oj015444;
	Wed, 21 May 2025 15:46:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnncv3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:46:49 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54LFkkhn19136806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 15:46:46 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F366A20043;
	Wed, 21 May 2025 15:46:45 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E1B620040;
	Wed, 21 May 2025 15:46:45 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.80])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 May 2025 15:46:45 +0000 (GMT)
Message-ID: <bfec98c2f53cc71603445b0339f53111cbf86e9e.camel@linux.ibm.com>
Subject: Re: [PATCH v1 4/5] KVM: s390: refactor and split some gmap helpers
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Date: Wed, 21 May 2025 17:46:46 +0200
In-Reply-To: <20250521174137.5b2baaf6@p-imbrenda>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
		<20250514163855.124471-5-imbrenda@linux.ibm.com>
		<277aa125e8edaf55e82ca66a15b26eee6ba3320b.camel@linux.ibm.com>
		<20250521171930.2edaaa8a@p-imbrenda>
		<d495d17902955839b0d7d092334b47efbdcb55a1.camel@linux.ibm.com>
	 <20250521174137.5b2baaf6@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 (3.56.1-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Hq-FJRa7WzcXG0d_ztc0OJq8XzVcwHOx
X-Authority-Analysis: v=2.4 cv=RPmzH5i+ c=1 sm=1 tr=0 ts=682df56a cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=TZB5Y_STSF-BKAUI658A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDE1MyBTYWx0ZWRfX2h2c5+cRJedL Btxuig7rXmaT4u4xFJsmDoQZsnvLG2JRPPiwN4wj85jOWRnEVYnGgYQOle6D9dspSwxihNiDiru hBy3ESEcCJ9fR19MwT5fl1JoOy/RjWeScK5GSs2RSnWgykrPV12/jWA55wbEkqvvQDv2D5cWNOE
 zSE41r0GpqUNYZ+278mp4SriXauIS5ljvGr4tKaGGnHCkOgOkrl+kRzNm/dUMtzsZ+LLuWZ+4DV o4vBxGSnG6w73pTaQ0RtI69jPnmBjj+E/hASyrzD4fdrsy4az9P6hIYwiNcLRPYP7EYqVZKRour xZ4gIiEdkNCeUpqvLg7dgw9KmX2QC1xcdeMnk7aPR/e0zlUrNFRNAOYZS+RcbJe2MRmx1H7EE9e
 exykHny+ksWE7iCnEmwCcj9+mEr84d+0B8KZsfd0ed5Ln/kvMfe+fL0fJZ7vVMhW3VvcyCbX
X-Proofpoint-GUID: Hq-FJRa7WzcXG0d_ztc0OJq8XzVcwHOx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_05,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505210153

On Wed, 2025-05-21 at 17:41 +0200, Claudio Imbrenda wrote:
> On Wed, 21 May 2025 17:30:00 +0200
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > On Wed, 2025-05-21 at 17:19 +0200, Claudio Imbrenda wrote:
> > > On Wed, 21 May 2025 16:55:18 +0200
> > > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> > >  =20
> > > > On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote: =20
> > > > > Refactor some gmap functions; move the implementation into a sepa=
rate
> > > > > file with only helper functions. The new helper functions work on=
 vm
> > > > > addresses, leaving all gmap logic in the gmap functions, which mo=
stly
> > > > > become just wrappers.
> > > > >=20
> > > > > The whole gmap handling is going to be moved inside KVM soon, but=
 the
> > > > > helper functions need to touch core mm functions, and thus need t=
o
> > > > > stay in the core of kernel.
> > > > >=20
> > > > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > > > ---
> > > > >  MAINTAINERS                          |   2 +
> > > > >  arch/s390/include/asm/gmap_helpers.h |  18 ++
> > > > >  arch/s390/kvm/diag.c                 |  11 +-
> > > > >  arch/s390/kvm/kvm-s390.c             |   3 +-
> > > > >  arch/s390/mm/Makefile                |   2 +
> > > > >  arch/s390/mm/gmap.c                  |  46 ++---
> > > > >  arch/s390/mm/gmap_helpers.c          | 266 +++++++++++++++++++++=
++++++
> > > > >  7 files changed, 307 insertions(+), 41 deletions(-)
> > > > >  create mode 100644 arch/s390/include/asm/gmap_helpers.h
> > > > >  create mode 100644 arch/s390/mm/gmap_helpers.c
> > > > >    =20
> > [...]
> >=20
> > > > > +void __gmap_helper_zap_one(struct mm_struct *mm, unsigned long v=
maddr)   =20
> > > >=20
> > > > __gmap_helper_zap_mapping_pte ? =20
> > >=20
> > > but I'm not taking a pte as parameter =20
> >=20
> > The pte being zapped is the one mapping vmaddr, right?
>=20
> I don't know, _pte kinda sounds to me as the function would be taking a
> pte as parameter

__gmap_helper_zap_pte_mapping_addr ?

IMO __gmap_helper_zap_one is rather vague. Zap one? Which one?

[...]

> > >=20
> > > > The stuff below is from arch/s390/mm/gmap.c right?
> > > > Are you going to delete it from there? =20
> > >=20
> > > not in this series, but the next series will remove mm/gmap.c altoget=
her =20
> >=20
> > Can't you do it with this one?
>=20
> if you mean removing mm/gmap.c, no. I would need to push the whole gmap
> rewrite series, which is not ready yet.
>=20
> if you mean removing the redundant functions... I guess I could

The latter. I think that would be cleaner.
>=20
> >=20
> >=20
> > [...]

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294

