Return-Path: <kvm+bounces-18850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F07E58FC499
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 09:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 864501F221BE
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 07:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFFA14AD1A;
	Wed,  5 Jun 2024 07:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UmkJ9PZs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70526138C;
	Wed,  5 Jun 2024 07:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717572742; cv=none; b=i8MJGsqDJfBSl3q6iP5eYghQFpdQF9lrgfOrJuxS2tIO4veTqs1QcgaeHq93BHoXHy46MM0xGKppUGvv7HFonsmefsrllhwKAMOusxgo8WFDatQ0dATEnRfGDVYPAkMHyprMLOgVN2mVhUMyQKDSnw+a1lZxerYTMsCtf5O3EwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717572742; c=relaxed/simple;
	bh=jxiMqK/qoSpG7BoFuO7Uq645iV9+VIvBfydEXV+kbh8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=D2VspmoVm7edymuqD5Oz9Waa6A8OD1ixwwkCy3+XGnA3Bvj4CSzwxG0knWfk8Ob+tZw5Og8gqG6B3Iwy1iCpXbQc4Vq0tiTQSVJVfv7yWLQLO70s9/Zk5wesVVvIR6Xtigo4urLUZRL2SyZ+mdn9lOA8iDc9vvvkEJlVze1P4H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UmkJ9PZs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4557KgZa031215;
	Wed, 5 Jun 2024 07:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=yaPFcbWJ5avj4dovrxFDY+m3nOHUcg+2PK5N5iWoeY0=;
 b=UmkJ9PZsR3a8kGaWzBqPV1Vt78FV0PW8tlUnhmWTgnlr3pYYtgzOfv4L5cfk1Ja4ZTzD
 Pn37BTgxMDPTY81Z96l7YxTlHUVvKpD3DKkNBUEN/+kPe2WAClDLxYHHyTnowQpqEocl
 UtgHleMF/1f63xU5L6eIXkxqrtuOTWNuIDMbw/Rv72qjqDPheJ6IZDcOqSVPOzw4rBKj
 wVmtg1cCIHefrnoo7FDgq/yGX6Hb8UGGN0mxpaSCVi5cNcJ7fBiAH/QL3AeRp20uAEf+
 LpPDRPjfNxFWu27/fjd/NgA99y/Ss68sdbcwru54UXOD7QW+45aFPd1QONIv0BJW/0TG Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjjm5g69f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 07:32:18 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4557WHEN021901;
	Wed, 5 Jun 2024 07:32:17 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjjm5g69e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 07:32:17 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45550ccp026550;
	Wed, 5 Jun 2024 07:32:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yggp32d55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 07:32:16 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4557WB5350135526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 07:32:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C4E92004D;
	Wed,  5 Jun 2024 07:32:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D3BB20040;
	Wed,  5 Jun 2024 07:32:11 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.49.245])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  5 Jun 2024 07:32:10 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org,
        Thomas
 Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr
 <nrb@linux.ibm.com>, Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x/Makefile: snippets: Add
 separate target for the ELF snippets
In-Reply-To: <D1ROTQ8S7W3G.3V7M7B6AMQWOR@gmail.com>
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
 <20240604115932.86596-2-mhartmay@linux.ibm.com>
 <D1ROTQ8S7W3G.3V7M7B6AMQWOR@gmail.com>
Date: Wed, 05 Jun 2024 09:32:09 +0200
Message-ID: <87msnzetfq.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Wy3Kvo6EJ-tJr9R2NeGeHV1seNrC4oNS
X-Proofpoint-GUID: 4rKtzRlyWxlHYXnprUF14i13wCGeagJd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-05_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050055

On Wed, Jun 05, 2024 at 11:21 AM +1000, "Nicholas Piggin" <npiggin@gmail.co=
m> wrote:
> On Tue Jun 4, 2024 at 9:59 PM AEST, Marc Hartmayer wrote:
>> It's unusual to create multiple files in one target rule, and it's even =
more
>> unusual to create an ELF file with a `.gbin` file extension first, and t=
hen
>> overwrite it in the next step. It might even lead to errors as the input=
 file
>> path is also used as the output file path - but this depends on the objc=
opy
>> implementation. Therefore, create an extra target for the ELF files and =
list it
>> as a prerequisite for the *.gbin targets.
>
> I had some pain trying to figure out another ("pretty printing") patch
> that changed some s390x/Makefile because of this. As far as I can tell
> it looks good.

Hehe yes. Thomas sent me the following error message:

/usr/bin/s390x-linux-gnu-ld: warning: s390x/snippets/c/mvpg-snippet.gbin
has a LOAD segment with RWX permissions

=E2=80=A6and at first this was totally confusing until I=E2=80=99ve looked =
at the code=E2=80=A6 :)

>
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks.

[=E2=80=A6snip]

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

