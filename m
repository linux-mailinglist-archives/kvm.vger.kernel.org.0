Return-Path: <kvm+bounces-36024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7E2A16F3D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65C4F1881B79
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 15:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 791F51E633C;
	Mon, 20 Jan 2025 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eOg6oS/H"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF981E32D7;
	Mon, 20 Jan 2025 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737386978; cv=none; b=CtOSsxpBSNPkLUmdJk+a22N+2NCB+Alzgd3j0h75PJdBcOXGy+IGMl65msY0JH4R0LkcVbhBYPtle/vqKH2zoCAdec/zWj6rrBk8/5xMgFiKGQE1lNa6YMzYE5b0zt6xXbt8H6H20vMvmvCSPchanzt3Ki9UepD1mScgwsG08EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737386978; c=relaxed/simple;
	bh=zhtA95t7ZUgvRh9t5zqL+Nn03oYFMERMwGNbYx8N1pk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CyvoHy3bJ8uDOZ2fGvDxhkaTE/AGjSMJrgFh0bsINnFlC4XF9FdTBBFjtTLQlC/3661z34MvLG6MIA3HKO8psmC11pMJ0Ik6r6QF0/DOvcR/iC3qJnN7aO6V+j7UeHLthPbhcXDM+P26vwD8kIqB9t7SaW6gesnH5DWkAcMBUWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eOg6oS/H; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50KF1Y5p004619;
	Mon, 20 Jan 2025 15:29:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RhS3Mu
	mNtxKeOLBMddrYapexv+0k7rlrc4rpxkqEUac=; b=eOg6oS/HTmp/j/fnwAhKiU
	oNNGcwXC869UIxWoTRhBqhpto3YjRBVB7/o6rYz73pp9iBLV922LUbxCbXWzEnsQ
	iulsVreEwZ/Kw7Tz7AdAm61tqZAq0eAoQFSG69+M4E3iCr8GCOvRAV3DZqfCeX8x
	3HABBGO5AS6T68Qzz/atrr19Qqg+GWPH3DPPXNhTnYiarK0gHhMlAFhttlli1bA1
	RUESWgA18D4fk2BDNnqhD3CSLZL+Y6OoGh/eiW2qDajRLPGwLcL8QFc0xGxMJsoP
	pZsF8hzjwPf2Ev/0+R+I+EB2OtN2vC19ogIL6GeNauNOxRUo48GBZpeHHzsQOYYw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 449rry8492-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:29:33 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50KFTWL3032382;
	Mon, 20 Jan 2025 15:29:32 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 449rry848y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:29:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50KDaJNI021080;
	Mon, 20 Jan 2025 15:29:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb16k12-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:29:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50KFTR7T34996946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jan 2025 15:29:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB2B32004D;
	Mon, 20 Jan 2025 15:29:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DEAC20043;
	Mon, 20 Jan 2025 15:29:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jan 2025 15:29:27 +0000 (GMT)
Date: Mon, 20 Jan 2025 16:29:25 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, schlameuss@linux.ibm.com, david@redhat.com,
        willy@infradead.org, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seanjc@google.com
Subject: Re: [PATCH v3 11/15] KVM: s390: stop using lists to keep track of
 used dat tables
Message-ID: <20250120162925.609cf6a2@p-imbrenda>
In-Reply-To: <20250120151018.49918-B-seiden@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
	<20250117190938.93793-12-imbrenda@linux.ibm.com>
	<20250120151018.49918-B-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Eui_E9SMIr-uKERKHYw6VVWzmoVLdae_
X-Proofpoint-ORIG-GUID: kT6jSBrmuTKwKmrnTkLBafhHEET7TZDc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_03,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 bulkscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=885 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200125

On Mon, 20 Jan 2025 16:10:18 +0100
Steffen Eiden <seiden@linux.ibm.com> wrote:

> On Fri, Jan 17, 2025 at 08:09:34PM +0100, Claudio Imbrenda wrote:
> > Until now, every dat table allocated to map a guest was put in a
> > linked list. The page->lru field of struct page was used to keep track
> > of which pages were being used, and when the gmap is torn down, the
> > list was walked and all pages freed.
> >=20
> > This patch gets rid of the usage of page->lru. Page tables are now
> > freed by recursively walking the dat table tree.
> >=20
> > Since s390_unlist_old_asce() becomes useless now, remove it.
> >=20
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com> =20
>=20
> Acked-by: Steffen Eiden <seiden@linux.ibm.com>
>=20
> Nit:
>=20
> You missed one `ptde=D1=95ec->pt_list` reference at
>=20
> arch/s390/mm/pgalloc.c
> 	unsigned long *page_table_alloc(struct mm_struct *mm)
> 		INIT_LIST_HEAD(&ptdesc->pt_list);

yep, removed now, thanks

>=20
>=20
>=20
> Steffen
>=20


