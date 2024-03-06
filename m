Return-Path: <kvm+bounces-11131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 831B087373B
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 390671F2819B
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 13:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A3B12F5B8;
	Wed,  6 Mar 2024 13:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bA87rrJF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDC85DF1D;
	Wed,  6 Mar 2024 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709730193; cv=none; b=QEPUga2kD8oRCwe2sfd/UaxfyZqA4SihyM8xgKzZgrGMd379rRfNVRt6WTgYfZ++bsbvynf4xUNhRSgZ7xCUD1l8xUguIBkmNtkANX7cVDYXF5mg600SONznnjssgStEvUm/UeNnOY3qT3VPgxQTCbEa7tRm4s6l8j8MmfYhnYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709730193; c=relaxed/simple;
	bh=X4f+nHbY+KWHcJyZFpAvpfWk8iBxvZA2ImjzK8Fkw90=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Cc:From:To:
	 Subject:Message-ID:Date; b=t4W5DbDvODijm6lMLJyzmyZ6RbBTu6T+pZMd2Oc15tdenmbqXB7Wd7n5LERfr+4r2qp/n0NTj6LeCev0JC2fnObda4/XM+vDEuR3GNqEQ6E5J0htmS/hlnBk5hyykdAtwBncMCS/9J5K8PFsdeWdgtIOiDGX35v7M7lzWmp3vlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bA87rrJF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 426CvCEW002163;
	Wed, 6 Mar 2024 13:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=epYAY0aCBZHSQwisZuPiBagok/eJKd0aaiHX/0wsqIA=;
 b=bA87rrJFh3j2YL/KESYC/t2Y/OW2lMWuR6jKbMOhAvsE8s0jmEfbInsOBQqKc9UxRQf4
 I9CZ2ZXkTUtzNTGC27Y8QDjHrnLybRPs3FjJruI0hGdBxpejDGJmdW3El+o8Y8/EEwEM
 V7RsM2lc4ScYW74Pfw2vRx4+trML84lFW0a600OpS1CWoz9YoPWCNme7bkkb9NuGqWDF
 9Sw1XhkYDqLTd4kMwkgyydVdFrLmeomaGBBfI5pLyNmmlOHuaKuD1nd1P/KJdIllZYJx
 ynHbLvocwQxOmZpYJfwZWOJLQzXiwAErv0gjIoWBcXjZ0gLSB2PGwQaNS2Dh4JovJz99 JA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wprxk88jy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Mar 2024 13:03:10 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 426CwfxN009451;
	Wed, 6 Mar 2024 13:03:10 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wprxk88j9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Mar 2024 13:03:09 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 426C85RA024160;
	Wed, 6 Mar 2024 13:03:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wpjwsa12j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Mar 2024 13:03:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 426D33Va28639524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 Mar 2024 13:03:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0D9B20043;
	Wed,  6 Mar 2024 13:03:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C410620067;
	Wed,  6 Mar 2024 13:03:02 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.18.155])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  6 Mar 2024 13:03:02 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87il20lf9b.fsf@linux.ibm.com>
References: <20240305141214.707046-1-nrb@linux.ibm.com> <87il20lf9b.fsf@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
From: Nico Boehr <nrb@linux.ibm.com>
To: Marc Hartmayer <mhartmay@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, npiggin@gmail.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1] arch-run: Wait for incoming socket being removed
Message-ID: <170973018238.31923.4497119683216363940@t14-nrb>
User-Agent: alot/0.8.1
Date: Wed, 06 Mar 2024 14:03:02 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q5Wa2q4LnFO-CHU1njj2TE4BkgTfsoAd
X-Proofpoint-ORIG-GUID: laf9N9HeYmfP8K62KCrChPKWtty1DVBG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-06_08,2024-03-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=875 bulkscore=0 phishscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403060104

Quoting Marc Hartmayer (2024-03-05 19:12:16)
[...]
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 2214d940cf7d..413f3eda8cb8 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -237,12 +237,8 @@ do_migration ()
> >       echo > ${dst_infifo}
> >       rm ${dst_infifo}
> > =20
> > -     # Ensure the incoming socket is removed, ready for next destinati=
on
> > -     if [ -S ${dst_incoming} ] ; then
> > -             echo "ERROR: Incoming migration socket not removed after =
migration." >& 2
> > -             qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
> > -             return 2
> > -     fi
> > +     # Wait for the incoming socket being removed, ready for next dest=
ination
> > +     while [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
>=20
> But now, you have removed the erroring out path completely. Maybe wait
> max. 3s and then bail out?

Well, I was considering that, but:
- I'm not a huge fan of fine-grained timeouts. Fine-tuning a gazillion
  timeouts is not a fun task, I think you know what I'm talking about :)
- a number of other places that can potentially get stuck also don't have
  proper timeouts (like waiting for the QMP socket or the migration
  socket), so for a proper solution we'd need to touch a lot of other
  places...

What I think we really want is a migration timeout. That isn't quite simple
since we can't easily pull $(timeout_cmd) before $(panic_cmd) and
$(migration_cmd) in run-scripts...

My suggestion: let's fix this issue and work on the timeout as a seperate
fix.

