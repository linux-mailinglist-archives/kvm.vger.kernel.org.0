Return-Path: <kvm+bounces-781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4EE07E2921
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:51:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E2142815B7
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3075728E25;
	Mon,  6 Nov 2023 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Pgr4DJor"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC5E1EB22
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 15:51:32 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B9410CC;
	Mon,  6 Nov 2023 07:51:30 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Fex1h028635;
	Mon, 6 Nov 2023 15:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=gmk6cqmM4Eayik0Z0A8soydrg46f++E8kacPrAmqEX0=;
 b=Pgr4DJorXgnBci6lw04v56GGX/r0rC8s3XTzOApRGbC0Nz6Q/NuCeb/I7FcqP7VKggqS
 WqIibl9hEHMnBPlraurPP6VGzU+nmy4jJJkdTYuj5qGLKA+ftPwGcmhLkz6lN+FA9xog
 j1ideJ7OiixDiPansfs2jKESFcXNkie57aiaQaP4GTHJBMeVRxoLtPW1xTogISqg88hQ
 ehjM6ityY9lPVs/Qge7rUQDmY0k1VCXTKQx15Z5OVcYduLHSMTCyDfLvuX/EPnk57ZsS
 tUVyJxVK2at0Ym7sreanC9S8Ae9TfwDOeJ7HCF66oR7ircquC2ggGlJDpEMZnCew0KWs zA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u71sgjyv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 15:51:29 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6FfNXo032354;
	Mon, 6 Nov 2023 15:51:29 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u71sgjymq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 15:51:29 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6FOpv7017004;
	Mon, 6 Nov 2023 15:51:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u6301ht3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 15:51:08 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6Fp6wK43123286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 15:51:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2571C2004B;
	Mon,  6 Nov 2023 15:51:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 038BC20049;
	Mon,  6 Nov 2023 15:51:06 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.68.179])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 15:51:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <f774a230-26b4-4742-8557-f504aa9344be@linux.ibm.com>
References: <20231103092954.238491-1-nrb@linux.ibm.com> <20231103092954.238491-8-nrb@linux.ibm.com> <f774a230-26b4-4742-8557-f504aa9344be@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v7 7/8] s390x: add a test for SIE without MSO/MSL
From: Nico Boehr <nrb@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Message-ID: <169928586562.23816.12377210934787398767@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 06 Nov 2023 16:51:05 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: deOxPGM1Dt9whNGrRgTU0B4m34izI_h5
X-Proofpoint-GUID: EyFXksrZc-JSb29BWeZPZyvLS8ccOdNK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060128

Quoting Janosch Frank (2023-11-03 15:16:36)
[...]
> > +static void setup_guest(void)
> > +{
> > +     extern const char SNIPPET_NAME_START(c, sie_dat)[];
> > +     extern const char SNIPPET_NAME_END(c, sie_dat)[];
> > +     uint64_t guest_max_addr;
> > +
> > +     setup_vm();
> > +     snippet_setup_guest(&vm, false);
> > +
> > +     /* allocate a region-1 table */
> > +     guest_root =3D pgd_alloc_one();
> > +
> > +     /* map guest memory 1:1 */
>=20
> 0:guest_max_addr

Sorry, I don't get what you mean.

