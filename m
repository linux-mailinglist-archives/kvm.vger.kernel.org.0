Return-Path: <kvm+bounces-8022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0B34849CD9
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 15:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BFF8281693
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 14:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8915524B5B;
	Mon,  5 Feb 2024 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BiRNHlK/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6717E2421C;
	Mon,  5 Feb 2024 14:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707142838; cv=none; b=hO65Sq8E6JPdSGajSZWHg34jQ19JOI18KomQ4I0AJGid5fgKoG8OXHI2n/VIWf1VGrWf5V6D9B7rb9xbhSS+zRu1RLwGWAu2poSgiA0rHh/hawOkLAlCcAXGYFaJbuD8aB6902PzVAg1JCqoWfL2UkPTlYN5YrJEmuozWJsCaqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707142838; c=relaxed/simple;
	bh=VKg4SZ+d8nDsJKhBYt3IUI+StMXktzFJPIAQBq8Yw3E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=C8XBubgT0mfk1tXK2H5o9UcHfLhPKOecipTAMQ1x9Lh7wJ1Byzk4W5MG2VmzcEWRRq5XuXqbyytzAggJTq34llA3euT+wwVvaf6Fjhhnr1aAwloMeZeZRJMpGIH8R6SxzyBj8J4IV19A54hB32XDayi1zcdJ//6WmVMd8sqb4LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BiRNHlK/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415EIMcb031493;
	Mon, 5 Feb 2024 14:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bXHIioVqh5fYg2wfi29MHPmCBpLjApCBOLSYCA188qo=;
 b=BiRNHlK/sbO74w/nyY/aZK1S2jnEQtslw2Rts/wDr/xuQZm6eKT2WrLuYzQWNnTiHlPi
 NM48sGg/nUEqHzaVttwmAo4mwf4cacGzuV+jNKjbEDD/ycF++TBsyiuVng6PFCX0IKJ6
 UYM1gtpp0SWTOpkCoAmRUz55J6bM7UXLUwVzABZKSUIZ1qEhiYRppVi4szuohvWMM7Yo
 TamCCF6xjiMcscxM+6Z6rK/3pUwwUSwIb0J6mt/CKSybkoIHDKE28hOm2dK3jYI6+Wyh
 aCQhs8DY27aojuJN5iCiuCkPah7Vlkx+ht11iHwk77qEOkBjQn7YrEG9iVihDd/pWTUy yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w31aqg1es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 14:20:19 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 415EJRFv001741;
	Mon, 5 Feb 2024 14:20:15 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w31aqg1dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 14:20:15 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 415CZVWl016215;
	Mon, 5 Feb 2024 14:20:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3w22h1rebg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 14:20:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 415EKBTj25756218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Feb 2024 14:20:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEBB420049;
	Mon,  5 Feb 2024 14:20:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD77C20040;
	Mon,  5 Feb 2024 14:20:10 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.59.40])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  5 Feb 2024 14:20:10 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        Laurent Vivier
 <lvivier@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones
 <andrew.jones@linux.dev>, Nico Boehr <nrb@linux.ibm.com>,
        Paolo Bonzini
 <pbonzini@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric
 Auger <eric.auger@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v2 1/9] (arm|powerpc|s390x): Makefile:
 Fix .aux.o generation
In-Reply-To: <20240202065740.68643-2-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
 <20240202065740.68643-2-npiggin@gmail.com>
Date: Mon, 05 Feb 2024 15:20:09 +0100
Message-ID: <871q9ryova.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E_UQLZzuAQX3Cmy0SGcM-0uS1WzSgQUT
X-Proofpoint-ORIG-GUID: 3S1Vxil0i0--MMWXxApbW9AHcufAytFG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_08,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 suspectscore=0 clxscore=1011 adultscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050108

On Fri, Feb 02, 2024 at 04:57 PM +1000, Nicholas Piggin <npiggin@gmail.com>=
 wrote:
> Using all prerequisites for the source file results in the build
> dying on the second time around with:
>
> gcc: fatal error: cannot specify =E2=80=98-o=E2=80=99 with =E2=80=98-c=E2=
=80=99, =E2=80=98-S=E2=80=99 or =E2=80=98-E=E2=80=99 with multiple files
>
> This is due to auxinfo.h becoming a prerequisite after the first
> build recorded the dependency.
>
> Use the first prerequisite for this recipe.
>
> Fixes: f2372f2d49135 ("(arm|powerpc|s390x): Makefile: add `%.aux.o` targe=
t")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arm/Makefile.common     | 2 +-

[=E2=80=A6snip]

Thanks a ton for fixing this!

Reviewed-by: Marc Hartmayer <mhartmay@linux.ibm.com>

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

