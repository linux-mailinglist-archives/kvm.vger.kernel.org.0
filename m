Return-Path: <kvm+bounces-792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D507E29E7
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C37752814E9
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01FD250EB;
	Mon,  6 Nov 2023 16:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rsvVA7mq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C609D29420
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:36:21 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6088D45;
	Mon,  6 Nov 2023 08:36:16 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6FQ5fr028237;
	Mon, 6 Nov 2023 16:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=Sbzuf+OnQHH5tUggamHsayPTTzuNU772E4ajzp1pews=;
 b=rsvVA7mqB4PnHnLYgH3ksbzHthBjhkbIfZL6QKS8GeTlRN9yC6cs5VZU32NzoqwaaUD1
 rtJMxMe8ga/2/k6o8Npsy3oHbaAN1JA2WvTczykStHuvuUBzOg3vpnxGNC4i0PDEKwIF
 vOGP3v5cC4jNmujtl9CvIsQgjYS4qYXTSt3hjYTOzqyXHxztGXe60g6JoR0tAzqHpgAo
 iQOANnbwGw24XHpySfm0pnGqx8wMIkkGgpr1lG5GY8hm649iSx5fLUJD5DI+wgZ6Y8OO
 CZ5p6GR5prPfOBM2ZIYpnW5e822l616FsbSIQnDxw9XDoBOnZsGXmctYzXDf9ULsxsRj TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u722pkrc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:36:16 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6GCC8n020415;
	Mon, 6 Nov 2023 16:36:15 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u722pkrbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:36:15 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6EBuCf025608;
	Mon, 6 Nov 2023 16:36:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u619nammp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:36:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6GaBkN4915758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 16:36:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1937120043;
	Mon,  6 Nov 2023 16:36:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBAFA20040;
	Mon,  6 Nov 2023 16:36:10 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.68.179])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 16:36:10 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <908915d7-d782-4358-9937-bcdba8db0450@linux.ibm.com>
References: <20231103092954.238491-1-nrb@linux.ibm.com> <20231103092954.238491-6-nrb@linux.ibm.com> <908915d7-d782-4358-9937-bcdba8db0450@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v7 5/8] s390x: lib: sie: don't reenter SIE on pgm int
From: Nico Boehr <nrb@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Message-ID: <169928857055.23816.6698035070741775404@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 06 Nov 2023 17:36:10 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RU93mczkM8tltSUMEz5Wnz2LUFs2koks
X-Proofpoint-GUID: Uw5yRVyJ89Ap5qKu5pLgs3ecm28W3izW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 malwarescore=0 adultscore=0
 lowpriorityscore=0 spamscore=1 phishscore=0 priorityscore=1501 bulkscore=0
 mlxscore=1 impostorscore=0 clxscore=1015 suspectscore=0 mlxlogscore=216
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060134

Quoting Janosch Frank (2023-11-03 14:53:17)
> On 11/3/23 10:29, Nico Boehr wrote:
> > At the moment, when a PGM int occurs while in SIE, we will just reenter
> > SIE after the interrupt handler was called.
> >=20
> > This is because sie() has a loop which checks icptcode and re-enters SIE
> > if it is zero.
> >=20
> > However, this behaviour is quite undesirable for SIE tests, since it
> > doesn't give the host the chance to assert on the PGM int. Instead, we
> > will just re-enter SIE, on nullifing conditions even causing the
> > exception again.
> >=20
> > In sie(), check whether a pgm int code is set in lowcore. If it has,
> > exit the loop so the test can react to the interrupt. Add a new function
> > read_pgm_int_code() to obtain the interrupt code.
> >=20
> > Note that this introduces a slight oddity with sie and pgm int in
> > certain cases: If a PGM int occurs between a expect_pgm_int() and sie(),
> > we will now never enter SIE until the pgm_int_code is cleared by e.g.
> > clear_pgm_int().
>=20
> Is there any use in NOT having an assert(!read_pgm_int_code()) before=20
> entering the loop?

I added it, nothing breaks, so probably none. Thanks.

