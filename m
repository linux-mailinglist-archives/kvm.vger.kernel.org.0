Return-Path: <kvm+bounces-6009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9F6829E76
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 17:24:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D01C1F22B05
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 16:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394B24CDF8;
	Wed, 10 Jan 2024 16:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TkI/f+tO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9B14CB55;
	Wed, 10 Jan 2024 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40AEtP0A008007;
	Wed, 10 Jan 2024 16:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=deC21uqqKb/SJT3z23x6pPD8Grh+2LwgZrfw2splm3s=;
 b=TkI/f+tOiOybAbFDEFmsDx/gUObuoXk5qMYjZ/3XEQNeemwuY3XkSslAIWs1v0n7u1mD
 aeGCBaZgPZdchbLqGoftqPTxJQzytHQcsRZGR+o6U77S9ZqJMI6RhznQhrvPt5vbbKHX
 +P+zvrGRua4ugDRo8y41OGHm3FW2YncSmA9EF0lOQxxlh1rIcn6I/7aU3ppCZzj/SfuF
 mF7PORtq7WP1NWKzIZ7aY/1Bz63UMD1ah04+Evummipaqp270L5RRn6ynXsoD+4kxAdE
 9Vh9QAcWC1SejiesDmIHluCC8ak+VEG/HIkaM50zUfJf4xRxnfRmH82GkUItURxyjq9p xA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vhuu9n81k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jan 2024 16:23:34 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40AGLLVt004848;
	Wed, 10 Jan 2024 16:23:33 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vhuu9n7w7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jan 2024 16:23:33 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40ADdJSC001339;
	Wed, 10 Jan 2024 16:23:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vfkdkdy49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jan 2024 16:23:30 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40AGNTI421824128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jan 2024 16:23:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6D712004B;
	Wed, 10 Jan 2024 16:23:28 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 819B720043;
	Wed, 10 Jan 2024 16:23:28 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.28.50])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 10 Jan 2024 16:23:28 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda
 <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth
 <thuth@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x/Makefile: simplify Secure
 Execution boot image generation
In-Reply-To: <19cc133f-57a7-45cd-a7e2-a4869bb8c753@linux.ibm.com>
References: <20231121172338.146006-1-mhartmay@linux.ibm.com>
 <19cc133f-57a7-45cd-a7e2-a4869bb8c753@linux.ibm.com>
Date: Wed, 10 Jan 2024 17:23:26 +0100
Message-ID: <87edep5f9d.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GXGO9VXDztcz-tR6wV5Pw_qorusOnBvk
X-Proofpoint-ORIG-GUID: 74AuUekK1T9o9ddwtjYeYlW-Wpafvmiz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-10_08,2024-01-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401100133

On Wed, Jan 10, 2024 at 11:44 AM +0100, Janosch Frank <frankja@linux.ibm.co=
m> wrote:
> On 11/21/23 18:23, Marc Hartmayer wrote:
>> Changes:
>> + merge Makefile rules for the generation of the Secure Execution boot
>>    image
>> + fix `parmfile` dependency for the `selftest.pv.bin` target
>> + rename `genprotimg_pcf` to `GENPROTIMG_PCF` to match the coding style
>>    in the file
>> + always provide a customer communication key - not only for the
>>    confidential dump case. Makes the code little easier and doesn't hurt.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>
> Thanks, I've pushed this to devel for CI coverage
>
>

Thanks.

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

