Return-Path: <kvm+bounces-36971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01529A23B6C
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 10:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6788B1642C3
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 09:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C8D18E361;
	Fri, 31 Jan 2025 09:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OtqGO/lu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05E814B092;
	Fri, 31 Jan 2025 09:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738315755; cv=none; b=ZZyZ76nfFh2GnjOvHOAclXzyiMAk9jpJTepMcbO5tinZ3jKps9HYGuNYkjwyFMQJs1ZLbz+nrGaBe0dr1W77G1JtcPcrOOU5iwyAoowFoY3vUcO/BosM6tyKaBn9LdruaENCP9BUWUm6mTmOkOkrEySZ9bXiXUWEOeMje9jVWuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738315755; c=relaxed/simple;
	bh=2LNpTxA/c1QIlT16ftecwrfCYXfdLdPTEiu1//4VDRY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=A2U/Pg0M/5yqDUkzOoVENYQAdgneF3MEHY6q4uhPHqEoxhEF4gCWRAKUGqTqG5hj9Rg4nATR9iE2o0Pd+QdEUxMd6Mua8HiAv97bxaBusatAKpwPPsoqZZ+OaQXCinP7nIlho7mwyGZxr1tc4nRUoGyRIB9SKJ3gpQATQcjs8Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OtqGO/lu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2OAPC030285;
	Fri, 31 Jan 2025 09:29:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3pKjeQ
	9AeMNKYkqMQYVPf8hAofyQmKU50svmNZNQkg4=; b=OtqGO/lu+N1igp2uAOduKT
	SwV2WSxUPo1xBph7qW5zD/bbLnFFu+ZYna4pEn6HVtNxrOuaGqraVkLDNWStItPJ
	7Mnofn21Tq/LoLcRasbUsEkSXo560gt5MtCVot4PcAEF4OhpeB5umf+CQ7beY0Ny
	B3wMGHPg7OwX2lX6DEmtMAzYrmWk0RPJlUmWdA8gcoLp0mdodlz0BOId+iQwBGXz
	aGJhwAhLWeC7XrMbs24Y6FOhaXqW+rbjd3M5NTUmzDcTqdtMK0CwnYfC93FBaQQH
	zfkHuVSri0LK04Kh4BZnuIorhO9fNy094c56O1CTItUHGJHt/tpcHwzMliTLVEsA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gfn5atxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 09:29:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8Si4b016048;
	Fri, 31 Jan 2025 09:28:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gfauavgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 09:28:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50V9Sqbp42140100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 09:28:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE6452010D;
	Fri, 31 Jan 2025 09:28:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 869452010A;
	Fri, 31 Jan 2025 09:28:52 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.179.26.180])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 31 Jan 2025 09:28:52 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org,
        Thomas Huth
 <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x/Makefile: Make sure the
 linker script is generated in the build directory
In-Reply-To: <D7G5BPWE5YKX.36U48WGFMOSAQ@linux.ibm.com>
References: <20250128100639.41779-1-mhartmay@linux.ibm.com>
 <20250128100639.41779-2-mhartmay@linux.ibm.com>
 <8734h3s0rj.fsf@linux.ibm.com> <D7G5BPWE5YKX.36U48WGFMOSAQ@linux.ibm.com>
Date: Fri, 31 Jan 2025 10:28:51 +0100
Message-ID: <87a5b7z60c.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8LaS24CgFt6GQPHkM83lZmWP-7DULuEd
X-Proofpoint-GUID: 8LaS24CgFt6GQPHkM83lZmWP-7DULuEd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_03,2025-01-30_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2501310071

On Fri, Jan 31, 2025 at 10:20 AM +0100, "Nico Boehr" <nrb@linux.ibm.com> wr=
ote:
> On Tue Jan 28, 2025 at 11:14 AM CET, Marc Hartmayer wrote:
>> On Tue, Jan 28, 2025 at 11:06 AM +0100, Marc Hartmayer <mhartmay@linux.i=
bm.com> wrote:
>> > This change makes sure that the 'flat.lds' linker script is actually g=
enerated
>> > in the build directory and not source directory - this makes a differe=
nce in
>> > case of an out-of-source build.
>> >
>> > Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> > ---
>> >  s390x/Makefile | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/s390x/Makefile b/s390x/Makefile
>> > index 23342bd64f44..71bfa787fe59 100644
>> > --- a/s390x/Makefile
>> > +++ b/s390x/Makefile
>> > @@ -182,8 +182,8 @@ lds-autodepend-flags =3D -MMD -MF $(dir $*).$(notd=
ir $*).d -MT $@
>> >  	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=3D\"$(@:.aux.o=3D.elf)\"
>> >=20=20
>> >  .SECONDEXPANSION:
>> > -%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj=
) $$(snippet-hdr-obj) %.o %.aux.o
>> > -	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
>>
>> > +%.elf: $(FLATLIBS) $(asmlib) s390x/flat.lds $$(snippets-obj) $$(snipp=
et-hdr-obj) %.o %.aux.o
>> > +	@$(CC) $(LDFLAGS) -o $@ -T s390x/flat.lds \
>>
>> s390x/flat.lds should be replaced by $(TESTDIR)/flat.lds
>
> fwiw, s/TESTDIR/TEST_DIR/
>
> Otherwise, yes, will fix it up when picking. Thanks!

Thanks.

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

