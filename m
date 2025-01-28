Return-Path: <kvm+bounces-36754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CCFFA20853
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 11:15:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECDC218836F7
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 10:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E5319D8A7;
	Tue, 28 Jan 2025 10:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GWkZtevm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CC619CD17;
	Tue, 28 Jan 2025 10:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738059308; cv=none; b=mbwS3Q7jZCk5wlW/+ii/ajKVK+ycNItk33tSvTl9xUX/PxHsVi/Z6oS7fYDmQTuLc2U0hPZTmnewNRJb4j2KtBrwThT6hmXLgPMKCtFP2zkwo3+PrLzY4xuNXAnOce9fMZt+fOnzV1V2EoZt8QmLCeZWMpspXti/0iYDgSRfoqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738059308; c=relaxed/simple;
	bh=NvgP2SiB4/Y4OGvHxwhUdU1VXNKYqMjUW0oiWtuqrrQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GtXUmLDS/yzvJs4iadlNpD4HVKH1qnIs12Y1vgwtilRyFOdyQBxjRNFS/OA0XNglF4ZAT9Yf4UpxJ2uGsgt09ULlQPGiAFQrkiavieWg+/xU56JH5owmTVrusFITkJrLZ/8uzL/9+oFZ5xyiKCtploHWgctcEhnZOyKMpq7l6Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GWkZtevm; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50S5OFGK024429;
	Tue, 28 Jan 2025 10:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lIiP3k
	C/83V24/mp8tQckq3MOhktT/vQImL8a1ZKUSY=; b=GWkZtevm7TcwopoEWUAcwZ
	0aNg9YwjMDJdStJsiCngpdhTKQfDwMzTUw5zQu5KIGhnNcmgH6sO56EUNW+UpLJs
	rB4axAf655s7Is0cK80l0WQhzbxDpQQPO1tuJwqroSmcByYcC9oPWw5L0NqD/clK
	8WouxSv0ZL479H1uiWTC4SEM7CuoLSR7WXPqcPaoux8GrOkDC4Al2zs8hvt/5cYz
	o3mhqrL55CMIen2I1LabQtP1A7+lw1QL3vt6pBE1J7J9BPeU14M/JZNGIC6rYbee
	/s6ZuE5WJRCjaQWWlHYXX5LwjWdeP3NwE7zIbDXASDde57TkCIoB0rIRsmWVgf3Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44es27h842-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:15:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50S99vFW019348;
	Tue, 28 Jan 2025 10:15:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44db9mtqs8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 10:15:01 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50SAEvnb56754488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 10:14:58 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8EBA200CB;
	Tue, 28 Jan 2025 10:14:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E539200CA;
	Tue, 28 Jan 2025 10:14:57 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.179.13.59])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 28 Jan 2025 10:14:57 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: linux-s390@vger.kernel.org, Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr
 <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x/Makefile: Make sure the
 linker script is generated in the build directory
In-Reply-To: <20250128100639.41779-2-mhartmay@linux.ibm.com>
References: <20250128100639.41779-1-mhartmay@linux.ibm.com>
 <20250128100639.41779-2-mhartmay@linux.ibm.com>
Date: Tue, 28 Jan 2025 11:14:56 +0100
Message-ID: <8734h3s0rj.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EA9ANBa_hAru4Y_V8UVbXXc-WPgyCz2g
X-Proofpoint-GUID: EA9ANBa_hAru4Y_V8UVbXXc-WPgyCz2g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-28_03,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501280077

On Tue, Jan 28, 2025 at 11:06 AM +0100, Marc Hartmayer <mhartmay@linux.ibm.=
com> wrote:
> This change makes sure that the 'flat.lds' linker script is actually gene=
rated
> in the build directory and not source directory - this makes a difference=
 in
> case of an out-of-source build.
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  s390x/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 23342bd64f44..71bfa787fe59 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -182,8 +182,8 @@ lds-autodepend-flags =3D -MMD -MF $(dir $*).$(notdir =
$*).d -MT $@
>  	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=3D\"$(@:.aux.o=3D.elf)\"
>=20=20
>  .SECONDEXPANSION:
> -%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $=
$(snippet-hdr-obj) %.o %.aux.o
> -	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \

> +%.elf: $(FLATLIBS) $(asmlib) s390x/flat.lds $$(snippets-obj) $$(snippet-=
hdr-obj) %.o %.aux.o
> +	@$(CC) $(LDFLAGS) -o $@ -T s390x/flat.lds \

s390x/flat.lds should be replaced by $(TESTDIR)/flat.lds

>  		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) || \
>  		{ echo "Failure probably caused by missing definition of gen-se-header=
 executable"; exit 1; }
>  	@chmod a-x $@
> --=20
> 2.48.1
>
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

