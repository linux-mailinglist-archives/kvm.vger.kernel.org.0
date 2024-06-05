Return-Path: <kvm+bounces-18916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DED18FD15F
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E800B28B21A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1604AEC3;
	Wed,  5 Jun 2024 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E4ja2QlG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B6510979
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717600068; cv=none; b=QiClKPpSaxrIyD/5tg5hfFNgK2fAtYKv6N6ZBHOQ/FusEwJUY1bV41ABuCSclyUzS3XoVPOjBswEMOfNXfbqb87IrDmQVu+yHxFFxZxhx4XBFV5NdI+ad99o4PBS7KLIQ/iSOCEDtxh3qyW49vLzZ8aG9qusJBqO0hVyKnUTTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717600068; c=relaxed/simple;
	bh=tCuFgmcyBKTA6ce2TnGe5FrR0qVYckLxSpJnlqSLjMI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MAy157ZZkcGx0DuCD0jy35DB1Ac+9krZeox+uV34II/ausAxTtoaR7M3vpKcgMy2SE0etx3mYx2nHkO/xvFTksCW7K8LgtaltNTBEzOmFvy/VKq1Sym31BI7/vnuDsYdnBT/3NVx3CMx3/v2edFaOrYCDUXXU2DSRK0Tl2kq/Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E4ja2QlG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455EcJrL000689;
	Wed, 5 Jun 2024 15:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=4k/AAagxkPpWcMb4FSM7gqLjZEucpohunmS22Vi3ObI=;
 b=E4ja2QlGStyeBxtOseONe7f611bopz2qeR3+Ansg62Kr/3FWU7lfErPkjZ5yt30kmQs4
 TxPf/woOVY4WkkJ23hg+Jc2hJ65SsbakFuAkAoet4jjVXNChQDqnBbO2aGZKRJtj7yNF
 E0sVp8wQ4CTXKbqZ0HsQM3ic6DfzwFwCabwNn+CywwWqno6N+PcA681ep6f3kc06HmQR
 y6Yim00Yxxbf0tL0lMXzXuqVZPnezhZj3BlLZH0OJbU4HfEMKxvszBRuAmZZydfnM08A
 QiiLiPTjUiHI30SZbo0QqgGsxvhncn12Pn+EjNw4n/zcc/GKbwszvkwEkmyTrTHxm11c Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsxyg2ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:07:37 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455F7bVQ014883;
	Wed, 5 Jun 2024 15:07:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsxyg2vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:07:37 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455CGefv000800;
	Wed, 5 Jun 2024 15:07:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ygdyu51q2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:07:36 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455F7Wkr43581782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 15:07:34 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C321B2004D;
	Wed,  5 Jun 2024 15:07:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79B132004B;
	Wed,  5 Jun 2024 15:07:32 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.49.132])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  5 Jun 2024 15:07:32 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: Re: [RFC kvm-unit-tests PATCH] build: fix .aux.o target building
In-Reply-To: <D1S0ZSXXGJFC.2IE9N2O8K9ETJ@gmail.com>
References: <20240605081623.8765-1-npiggin@gmail.com>
 <87cyovekmh.fsf@linux.ibm.com> <D1S0ZSXXGJFC.2IE9N2O8K9ETJ@gmail.com>
Date: Wed, 05 Jun 2024 17:07:31 +0200
Message-ID: <87frtrh1ho.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0RifkHj7MCPlcjPgQ97qXSf0hjJusaeU
X-Proofpoint-ORIG-GUID: rM_zAYRYyMixhDEF2kX3NhPIWWdUJ1Ht
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050114

On Wed, Jun 05, 2024 at 08:53 PM +1000, "Nicholas Piggin" <npiggin@gmail.co=
m> wrote:
> On Wed Jun 5, 2024 at 8:42 PM AEST, Marc Hartmayer wrote:
>> On Wed, Jun 05, 2024 at 06:16 PM +1000, Nicholas Piggin <npiggin@gmail.c=
om> wrote:
>> > Here's another oddity I ran into with the build system. Try run make
>> > twice. With arm64 and ppc64, the first time it removes some intermedia=
te
>> > files and the second causes another rebuild of several files. After
>> > that it's fine. s390x seems to follow a similar pattern but does not
>> > suffer from the problem. Also, the .PRECIOUS directive is not preventi=
ng
>> > them from being deleted inthe first place. So... that probably means I
>> > haven't understood it properly and the fix may not be correct, but it
>> > does appear to DTRT... Anybody with some good Makefile knowledge might
>> > have a better idea.
>> >
>>
>> $ make clean -j &>/dev/null && make -d
>> =E2=80=A6
>> Successfully remade target file 'all'.
>> Removing intermediate files...
>> rm powerpc/emulator.aux.o powerpc/tm.aux.o powerpc/spapr_hcall.aux.o pow=
erpc/interrupts.aux.o powerpc/selftest.aux.o powerpc/smp.aux.o powerpc/self=
test-migration.aux.o powerpc/spapr_vpa.aux.o powerpc/sprs.aux.o powerpc/rta=
s.aux.o powerpc/memory-verify.aux.o
>>
>> So an easier fix would be to add %.aux.o to .PRECIOUS (but that=E2=80=99=
s probably still not clean).
>>
>> .PRECIOUS: %.o %.aux.o
>
> Ah, so %.o does not match %.aux.o. That answers that. Did you see
> why s390x is immune? Maybe it defines the target explicitly somewhere.

Not yet :/ But what was also interesting is that if I=E2=80=99m using multi=
ple
jobs I don=E2=80=99t see the issue.

make clean -j; make -j; make -j # <- the last make has nothing to do

if I=E2=80=99m using:

make clean -j; make; make -j # <- the last make has something to do=E2=80=A6
                                  that something that irritates me

>
> Is it better to define explicit targets if we want to keep them, or
> add to .PRECIOUS? Your patch would be simpler.

Normally, I would say without .PRECIOUS it=E2=80=99s cleaner, but there is
already a .PRECIOUS for %.so=E2=80=A6 So as Andrew has already written

.PRECIOUS: %.so %.aux.o

should also be fine.

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

