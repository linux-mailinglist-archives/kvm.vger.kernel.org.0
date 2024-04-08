Return-Path: <kvm+bounces-13891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D15F489C493
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7263C1F229D6
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C2D80043;
	Mon,  8 Apr 2024 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pDv/hZxx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35B4768EA
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584034; cv=none; b=WHLStgX8JSbJ2dJ7LeoBuQVz32VoaF9AhTzB0aC/QZsqgFVRtHvAIiDn5HxUshFfsEOHIDC6pQXwXXHM6wZFyHclFqafON5XM7h9XjlNawYf+CeL6+jTT2JATzHOip1OBpjscIya7PNtyyurllJFkaG33myocN9rwaLlmYTtbkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584034; c=relaxed/simple;
	bh=S3lFhUIHkzxarAhTvIpddkDGzSkzDtL/Ez2JWzsO99s=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Cc:To:Subject:
	 From:Message-ID:Date; b=n7yIiCtpfqIyeXU5LH+O28EVnX4L/IEJYc+zPhjHBBLOk0CRXun9AOn4BtnR57KErzaDWFJxCejwGSz508R3gSWQX4SDyUcc20UEyD52tCIjOHtJwWsMbWfom9wwAO3yrxR9ORjS1mv44rFnM0EEpWqK5Ggz1eXuHFNMoe1IIUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pDv/hZxx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438DaUN5019955;
	Mon, 8 Apr 2024 13:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=k+Pe9jMMnkw267axt148DjpypWHuwvjCZh47D4kaBhA=;
 b=pDv/hZxxVs/1ALtxqyqaPATzJuYcZ2pFxajyCgs6HyihRsg5K+8AEe5EpDuo0I8bOK8E
 L6wQIUM66JUfp/o6SpjxYeTRaY9q4RxTXhB5Tn12wjDAg//tOQMCXzlYtYaL6A95dbq6
 vl8W9kA29xRaENnqnHac+ve3lptHDN8MMcBGT9lW+A7bXeSWpqbr5oc1TLnLSzTceYNx
 zkbUfJKTiZyF6DnTpK2+gsP/agsjxbrJ66rkLvBBVdE//oIHHNlRvbLX+JeNl/5bNPZY
 TLv1uimYeFbnyzo1Tu19r+z5W4IrqmWztgCSPqvh1NgfhSeDDBwGoKFRvkrEFYHoEbt7 Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xchg0r171-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 13:47:07 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438Dl7DY004367;
	Mon, 8 Apr 2024 13:47:07 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xchg0r16x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 13:47:07 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 438CH42h029889;
	Mon, 8 Apr 2024 13:47:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xbj7m088e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 13:47:06 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 438Dl2Ek52232558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Apr 2024 13:47:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F8BA2004D;
	Mon,  8 Apr 2024 13:47:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 720DB2004F;
	Mon,  8 Apr 2024 13:47:02 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.72.190])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Apr 2024 13:47:02 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CALzav=fGUnYHiEc40Ym2Yh-H6wMRdw6biYj4+e1vZ0xmBDAnsg@mail.gmail.com>
References: <20240307194255.1367442-1-dmatlack@google.com> <ZepBlYLPSuhISTTc@google.com> <ZepNYLTPghJPYCtA@google.com> <CALzav=cSzbZXhasD7iAtB4u0xO-iQ+vMPiDeXXz5mYMfjOfwaw@mail.gmail.com> <ZfG41PbWqXXf6CF-@google.com> <CALzav=fGUnYHiEc40Ym2Yh-H6wMRdw6biYj4+e1vZ0xmBDAnsg@mail.gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>,
        Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org
To: David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on x86_64
From: Nico Boehr <nrb@linux.ibm.com>
Message-ID: <171258402203.38901.9542700853299444599@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 08 Apr 2024 15:47:02 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jWWoYTQAtluAnrImE2kqnm7dXW5sLGUf
X-Proofpoint-ORIG-GUID: YLVozTuJWoq8lvLK6omElEEVd049Eb2m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_11,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=681
 priorityscore=1501 mlxscore=0 suspectscore=0 clxscore=1011 spamscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080104

Quoting David Matlack (2024-03-14 22:11:57)
[...]
> >   7. Use the PT_AT_4GIB knob in s390's CMMA test?  I suspect it does me=
mslot
> >      shenanigans purely so that a low gfn (4096 in the test) is guarant=
eed to
> >      be available.
>=20
> +Nico
>=20
> Hm, if this test _needs_ to use GFN 4096, then maybe the framework can
> give tests two regions 0..KVM_FRAMEWORK_GPA and TEST_GPA..MAX.
>=20
> If the test just needs any GFN then it can use TEST_GPA instead of
> 4096 << page_shift.

Sorry for the late reply, this got burried at the bottom of my inbox :(

The test creates two memslots with a gap in between to be able to test that
gaps in memslots are correctly skipped by the CMMA-related ioctls.

The test doesn't need GFN 4096. It should not matter where TEST_GPA is, as
long as there's a gap after the main memslot.

Feel free to include me on a follow-up, then I can test and look at this.

