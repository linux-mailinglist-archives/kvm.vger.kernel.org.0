Return-Path: <kvm+bounces-810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 205697E2AC8
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 18:14:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D037C2816A8
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B89429CF3;
	Mon,  6 Nov 2023 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RL+mXaaK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54192941E
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 17:13:53 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C93BD47;
	Mon,  6 Nov 2023 09:13:51 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6HB49V014750;
	Mon, 6 Nov 2023 17:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : to : from : message-id : date; s=pp1;
 bh=bNOLNbdUN9/83zEbvD8nEUpQ2JzjebQTj8dL38bKozQ=;
 b=RL+mXaaKv6YW9Oljv2GxqrPMR78u3h85Mj7bqS3YsMpQLC/ehJUnmphnX5FnbhyE61kU
 wUJ6zqSxZN/ch4MmOZ4SaMTTPXBUn4XK/eK6jfiUeGrwFvWmHB/M+lJIcHV+RMUBuFt6
 vtm1yUYrq3PRyzuNi/DabiQ0t8TbT2k4N4rWU2TC6WgekkfsouRznxejKhxHfk1SKMNB
 XG4ay6mTakP+qjjHgSR5MS5/y3NcYrVhFxVhEPf9ctLEtgBzfl0GiMoN+t6ZixCHpZ6i
 jljIwF7EFd4Zrqumvi3WgBEJmeTMJXyAwTG7XlkuHhRBEUwtIO2aWy2wxMjthmLbD2F8 gw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73gh9u9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 17:13:43 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6GlrI2018799;
	Mon, 6 Nov 2023 17:13:42 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73gh9u8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 17:13:42 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6FXmvF016950;
	Mon, 6 Nov 2023 17:13:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u6301jaaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 17:13:41 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6HDcVs31195494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 17:13:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D220120040;
	Mon,  6 Nov 2023 17:13:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 457A020043;
	Mon,  6 Nov 2023 17:13:38 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.68.179])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 17:13:38 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231106175316.1f05d090@p-imbrenda>
References: <20231106125352.859992-1-nrb@linux.ibm.com> <20231106125352.859992-3-nrb@linux.ibm.com> <20231106175316.1f05d090@p-imbrenda>
Cc: frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 02/10] powerpc: properly format non-kernel-doc comments
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
From: Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169929081714.70850.5803437896270751208@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 06 Nov 2023 18:13:37 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G5-Eh6ya0ILZl6gDgslXAmXmMIzCsMsh
X-Proofpoint-GUID: w4JXJtJd6EUf8248tjDRQjzGy1TBvHlQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060139

Quoting Claudio Imbrenda (2023-11-06 17:53:16)
> On Mon,  6 Nov 2023 13:50:58 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
>=20
> > These comments do not follow the kernel-doc style, hence they should not
> > start with /**.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >  powerpc/emulator.c    | 2 +-
> >  powerpc/spapr_hcall.c | 6 +++---
> >  powerpc/spapr_vpa.c   | 4 ++--
> >  3 files changed, 6 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/powerpc/emulator.c b/powerpc/emulator.c
> > index 65ae4b65e655..39dd59645368 100644
> > --- a/powerpc/emulator.c
> > +++ b/powerpc/emulator.c
> > @@ -71,7 +71,7 @@ static void test_64bit(void)
> >       report_prefix_pop();
> >  }
> > =20
> > -/**
> > +/*
> >   * Test 'Load String Word Immediate' instruction
> >   */
>=20
> this should have the name of the function first:=20
>  * test_lswi() - Test 'Load String ...=20
>=20
> (same for all the other functions here)

Since none of these comments really follow kerneldoc style and are mostly
static anyways, the idea was to convert them to non-kerneldoc style, by
changing the comment from:
/**

to:
/*

But I am just as fine to make the comments proper kerneldoc style, if we
see value in that.

