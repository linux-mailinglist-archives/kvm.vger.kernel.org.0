Return-Path: <kvm+bounces-18762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F9A8FB1C4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 720DC1C2232D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642B0145B12;
	Tue,  4 Jun 2024 12:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vew5vZPq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F98A15E8B;
	Tue,  4 Jun 2024 12:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502709; cv=none; b=Vux4paYEDcqgM5ix0wG/l8egYgfTF2SCnxWaAvPdHf2a4KKGzby+Swl4QWzO/vPsdT95Lql+VjoWKwBpA9ljE8e8k2L0cHJFNp2b8fG6Xw3nUDOD0GSNvGe1lC31VdoQ8DXUY3ZHxcFzZ16dNMGgCMt4gjKk8TKBL7JnsgWdctM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502709; c=relaxed/simple;
	bh=6foERaRRTGV76tVWeMDC8gcZBGSnCKh89A2dMZQ1c0E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QnisVVRJMC49MIAgBPJdv/M7D63ezqHDGxytVGw51qztC0tXq6RYigQbFDI7l1VIlY93b08J3J9mwc+uM03uvkXzvrdQkdqqbU91aQI5HQ14WgsD4di1wjOw6S7TahAPWNBp6Rfs07JVduB+w0FEUoewVUZwvO8X9hkihmFX6f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Vew5vZPq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 454Bu8GZ015070;
	Tue, 4 Jun 2024 12:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=mKFnEF2+/1BCKxqKwUQMPEJz/qWMV6sq5d5LA8pi6FY=;
 b=Vew5vZPqFduMLazzwgmLVzqN6Bn/vF1aNZtL2PBQL7cj+tDGw4Y2fgaD8wMyUEF+qOlg
 ArUkNNOZVaeYHhHhygbMFcWf/YZgK/XBCPD+4dqyouKfbxqrTzUSvGv3IwcXe90Jmai1
 EFiCg31nmsgrKmgYhl9EbAQlez439RK1x5j69CTgArvyh16AiZRH3E9C49aanHuum3BR
 MFOOOAH4tHELl7cV5SvGcPQJQc2QSvVKRSnvSYBVl6yNY0/SuaQIALnAe5wgA2Mg6fLE
 pL2DWLPv/GUhtq+bznVRSpLYfB9UdOIFIxEcm4xBbPyizq6Pujogbb9ZK9PNqBMcvl0R Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj2brr23h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 12:05:07 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 454C56mu032390;
	Tue, 4 Jun 2024 12:05:06 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj2brr23f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 12:05:06 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4549jMO3026600;
	Tue, 4 Jun 2024 12:05:05 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygffmwr9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 12:05:05 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 454C4xnb43385114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Jun 2024 12:05:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 744002004B;
	Tue,  4 Jun 2024 12:04:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E752020040;
	Tue,  4 Jun 2024 12:04:58 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.63.147])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  4 Jun 2024 12:04:58 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: linux-s390@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Nicholas
 Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr
 <nrb@linux.ibm.com>, Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 3/3] Revert "s390x: Specify program
 headers with flags to avoid linker warnings"
In-Reply-To: <20240604115932.86596-4-mhartmay@linux.ibm.com>
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
 <20240604115932.86596-4-mhartmay@linux.ibm.com>
Date: Tue, 04 Jun 2024 14:04:57 +0200
Message-ID: <87y17khq1i.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XWYKR424pnLGR4hpAsvcioZ3_rhjqkc4
X-Proofpoint-GUID: d_F0sWwGfHiihRx1033Uk5b7yq1hc_V8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-04_05,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406040097

On Tue, Jun 04, 2024 at 01:59 PM +0200, Marc Hartmayer <mhartmay@linux.ibm.=
com> wrote:
> From: Super User <root@t35lp69.lnxne.boe>

Oops, author must be fixed=E2=80=A6 :/

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

