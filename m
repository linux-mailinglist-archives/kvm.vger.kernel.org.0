Return-Path: <kvm+bounces-33284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4B49E8ED3
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 10:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1C6E281A32
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 09:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9D2215F44;
	Mon,  9 Dec 2024 09:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n5yPzpC+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAEA215043;
	Mon,  9 Dec 2024 09:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733736872; cv=none; b=ZWgaf9SJUx+M7kfwRqLiejXZBW0GoSnUt7+YpM1hH2GV+FRlxU614UUB8/NQ3fhZ42aye/3l16cfItvMDRCs6igFDUhMaWc9P758mQ3nt0p7fQdDL2fsEKJzw6jlLUd2MUwzXwlfw/sRMxk73mtTfdw4+MzUBo9/sJkV1oa4Lhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733736872; c=relaxed/simple;
	bh=du+zs5IoN7lKoslBWybgDe7G/5Hgi2uwQdZSPIyrz/A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LlNQunupXfnx39VivTM02B5R7YdDnsnbVx662yLSoWm+qVmqzjVUUx8Pz8qaxKy/97A0Vd3Zy62eSeIZNpqHnEbrQXdMW4WH2SOz+HU4OkzxorJo0nU28KCB1gvs76sofcDWX9cM196V0iONghUIObEKgRSBs3Ao14ZhMykz4Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n5yPzpC+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B8MQOln006738;
	Mon, 9 Dec 2024 09:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kBO8VW
	Pob+iIAhq1R83wOiojUAeWw7PoWjUWQCv537s=; b=n5yPzpC+pKRTy06Wcuo+hk
	ZZHfE1mZ3lHTtVzIasWpby5tnAgRg61KOC+pxzfr3G5bSqyo2aUp3zVFUAb6UPp2
	QOpWx5ynDfF9OR3mpwJdJJw7cer4cHs+4icrcODpkwbCDLeqQPi0yWE81CX63l03
	Xo2ZSAPO132Ij0kL3Mn5DtoGvRa0Y+MiF5ny/V0lx+mq8kDkrwkCotZU1zGTfYNK
	LUqzkLR1rYltWwCVzs9J1dA14a0lMoKaT8GlBBUyWB4WEaN+kyXn168iUcsxSAAA
	HWTo8SD1znOy6wxRcixUYQCsMRNbTIJddTnmnP13GUP8htc+fkH59flkeKedVbdA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce38gfax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 09:34:28 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B982TeZ017381;
	Mon, 9 Dec 2024 09:34:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d3d1dkgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 09:34:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B99YNtR55443810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Dec 2024 09:34:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D460520043;
	Mon,  9 Dec 2024 09:34:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82F1C20040;
	Mon,  9 Dec 2024 09:34:23 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.24.151])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  9 Dec 2024 09:34:23 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org,
        Thomas Huth
 <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Support newer version of genprotimg
In-Reply-To: <D670EQUUSVS6.1RFVHYTPER26Y@linux.ibm.com>
References: <20241205160011.100609-1-mhartmay@linux.ibm.com>
 <D670EQUUSVS6.1RFVHYTPER26Y@linux.ibm.com>
Date: Mon, 09 Dec 2024 10:34:21 +0100
Message-ID: <87o71l8ajm.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7eKZlVrtaEa6i9XiiB6UlH0wCYvU7-kc
X-Proofpoint-ORIG-GUID: 7eKZlVrtaEa6i9XiiB6UlH0wCYvU7-kc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412090073

On Mon, Dec 09, 2024 at 08:59 AM +0100, "Nico Boehr" <nrb@linux.ibm.com> wr=
ote:
> On Thu Dec 5, 2024 at 5:00 PM CET, Marc Hartmayer wrote:
> [...]
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 23342bd64f44..3da3bebb6775 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -197,17 +197,26 @@ $(comm-key):
>>  %.bin: %.elf
>>  	$(OBJCOPY) -O binary  $< $@
>>=20=20
>> +define test_genprotimg_opt
>> +$(shell $(GENPROTIMG) --help | grep -q -- "$1" && echo yes || echo no)
>> +endef
>> +
>> +GENPROTIMG_DEFAULT_ARGS :=3D --no-verify
>> +ifneq ($(HOST_KEY_DOCUMENT),)
>>  # The genprotimg arguments for the cck changed over time so we need to
>>  # figure out which argument to use in order to set the cck
>> -ifneq ($(HOST_KEY_DOCUMENT),)
>> -GENPROTIMG_HAS_COMM_KEY =3D $(shell $(GENPROTIMG) --help | grep -q -- -=
-comm-key && echo yes)
>> -ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
>> +ifeq ($(call test_genprotimg_opt,--comm-key),yes)
>>  	GENPROTIMG_COMM_OPTION :=3D --comm-key
>>  else
>>  	GENPROTIMG_COMM_OPTION :=3D --x-comm-key
>>  endif
>> -else
>> -GENPROTIMG_HAS_COMM_KEY =3D
>> +# Newer version of the genprotimg command checks if the given image/ker=
nel is a
>
> After having my first cup of coffee, one question: at which version
> did this behaviour change?

2.36.0
(https://github.com/ibm-s390-linux/s390-tools/commit/0cd063e40d12d7ca5bc59a=
09b2ee4803653678bd)

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

