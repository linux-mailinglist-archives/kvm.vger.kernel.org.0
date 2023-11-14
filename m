Return-Path: <kvm+bounces-1691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B42D7EB4BA
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 17:24:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 546D72812D2
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A8F52AF0B;
	Tue, 14 Nov 2023 16:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jMHQkv4u"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33E42AEFD
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 16:24:45 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4745F10C;
	Tue, 14 Nov 2023 08:24:43 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEGMQhD017526;
	Tue, 14 Nov 2023 16:24:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : from : cc : message-id : date; s=pp1;
 bh=RafjzkIIR2dOWUyijObiXeUAlzKgyu3jNkBV4Sb/UTU=;
 b=jMHQkv4u1L9ZpQU63bPNe9EqH1XdselEdgOPCm4Vzlc+MzKo/MmlmbBMgT3JjXtA6Tgu
 Je7MXpdh8/tiB7MQs+UwZ6GHYC6qMFfwFtpljjMZh+a6psVducI0iB7DJXQbZps589T/
 cUnN5HkqfqN/gcPhl2yK+1IcDRxu8O4UN1cLQR3eg/Ld7q+YSf2Rze96IW48aHpYJLpp
 92hesa3XQhVzWMc1NaW98zD8X/4o+u1T1AzUja/OkChmiMFLdrHP4aYzXKz1HhEF05HW
 abr+JSu7OB1mpUGRI6QUFlUGiFNxCMjeC6trKxoF27M3OTzhft+kfcsdElTa6Qwc3InW rA== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uccby81x1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Nov 2023 16:24:42 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEGJANI023997;
	Tue, 14 Nov 2023 16:24:41 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uakxssddr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Nov 2023 16:24:40 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AEGOcbl18416330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Nov 2023 16:24:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E3FB20043;
	Tue, 14 Nov 2023 16:24:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A40CA20040;
	Tue, 14 Nov 2023 16:24:37 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.71.65])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Nov 2023 16:24:37 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231109123624.37314-1-imbrenda@linux.ibm.com>
References: <20231109123624.37314-1-imbrenda@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 1/1] KVM: s390/mm: Properly reset no-dat
From: Nico Boehr <nrb@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, nsg@linux.ibm.com, borntraeger@de.ibm.com,
        hca@linux.ibm.com, gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com
Message-ID: <169997907623.92635.8143439570561321958@t14-nrb>
User-Agent: alot/0.8.1
Date: Tue, 14 Nov 2023 17:24:36 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JX2NxPfArrkfeQA_1EnMKK7Ov4ehileT
X-Proofpoint-GUID: JX2NxPfArrkfeQA_1EnMKK7Ov4ehileT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_16,2023-11-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=628 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140125

Quoting Claudio Imbrenda (2023-11-09 13:36:24)
> When the CMMA state needs to be reset, the no-dat bit also needs to be
> reset. Failure to do so could cause issues in the guest, since the
> guest expects the bit to be cleared after a reset.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Please Cc stable and add my:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

