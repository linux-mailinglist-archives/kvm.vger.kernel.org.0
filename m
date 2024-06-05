Return-Path: <kvm+bounces-18854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C128FC551
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:04:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A524C1F24512
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 08:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5952E18F2C4;
	Wed,  5 Jun 2024 08:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IxLxnyLC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7530D1922FC;
	Wed,  5 Jun 2024 08:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717574651; cv=none; b=FOmM6ch9g7aQtcEb4b1BcTSBhIHnVDyb9yjtPUVuvwUj8ZqkOAArE+GIOzBU3TN0pRRJZukGjN3L9Bo35V8RMeTeunKnVaw7JxRFs1+NF6dmdsO+uRmb1c7CF3dZfGs0tmmlEoKIRP5zmHhnZ69iO0VQveHX5P0kgOOxqjAOxOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717574651; c=relaxed/simple;
	bh=WKQnc3QTe0PxphsvXKC79sDS7wi3IedNFAMTiPs5h0c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Lx1f5gYg1FkqW2WzQoY7ADF3S3n3ngqVO3MaWvnvSuqXiAV7PpkgaoVPjHXaTZ21FDzdjptdekDd8ClyBHk1SfTvtSquhFpqylsN5buhVeF5wZ6jngwYa3xw3Z/zrp+Br6jIX4HhDxK9vGc+ySiyw1i7RvHDJwpJ2O0JUwLsnws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IxLxnyLC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4557ol44019906;
	Wed, 5 Jun 2024 08:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=Lktxp1xHnwpzLetO0Bqvbde0xJLvKLX2c4YkPCMknos=;
 b=IxLxnyLCh+eeegt+nH9oyhu3ZMVxyzQfL8qIM6dooKDuwCi2XZKWHC040kjFpFK1y1ED
 m/5Bkjar2RIBwaUGCzmpW+DTxSeyQUfBbwEGgLDRmoq9RYbCEMJJtuNr35Sx5oLWOIFz
 W3TrlLg7kJTd3SY91vu9v2p0A/rEi5zNsmX40faOSy6nsQJgGOZLYkIBrP85Rcd9q5O3
 a1C57G2+HD/B7MQ9dKYvQhX5Olq2XpqKpCnaKJrrJaSG5/pq9y6twhTQaqzFxegNmf2g
 98n5jqaW3wbyNuiO5NAdMi9jGIzlbzdo2g2NXNOjK7Ee2kbJe/oVS0qZHAYOo04dt+0D RA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjjm5g97m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 08:04:08 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4558476u010748;
	Wed, 5 Jun 2024 08:04:07 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjjm5g97j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 08:04:07 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455828SJ026652;
	Wed, 5 Jun 2024 08:04:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yggp32hfg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 08:04:06 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4558402a22282692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 08:04:03 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E19EF2004B;
	Wed,  5 Jun 2024 08:04:00 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6918920040;
	Wed,  5 Jun 2024 08:04:00 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.49.245])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  5 Jun 2024 08:04:00 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org,
        Thomas
 Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr
 <nrb@linux.ibm.com>, Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] s390x: small Makefile improvements
In-Reply-To: <D1RP1BC65XW5.NC0D2AFAL0TD@gmail.com>
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
 <D1RP1BC65XW5.NC0D2AFAL0TD@gmail.com>
Date: Wed, 05 Jun 2024 10:03:59 +0200
Message-ID: <87jzj3eryo.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UZ6VEKp1wLGlkQ3dbfSa_qSUy9Pi-i3C
X-Proofpoint-GUID: VC39B002tDEYLwsmX__CWuK-v7zZ1J-v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-05_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=731
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050059

On Wed, Jun 05, 2024 at 11:30 AM +1000, "Nicholas Piggin" <npiggin@gmail.co=
m> wrote:
> On Tue Jun 4, 2024 at 9:59 PM AEST, Marc Hartmayer wrote:
>> The first patch is useful anyway, the third could be dropped to be consi=
stent
>> with the other architectures.
>
> Interesting. Is this the reason for the warning on all the other
> archs?

Could be, but the .eh_frame and .eh_frame_hdr sections are sometimes
required, e.g for __builtin_return_address(n),=E2=80=A6. Another fix would =
be to
specify the sections in the linker scripts explicitly - but I=E2=80=99ve to=
 ask
whether this has other side effects=E2=80=A6

> Maybe they should all use the same options and all remove the explicit
> PHDR specification?
>
> Thanks,
> Nick
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

