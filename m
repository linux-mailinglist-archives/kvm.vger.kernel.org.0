Return-Path: <kvm+bounces-4031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80FD280C595
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 11:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AA2A28176A
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 10:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E529822092;
	Mon, 11 Dec 2023 10:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oHe1yCB3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE3EBD;
	Mon, 11 Dec 2023 02:04:50 -0800 (PST)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BB8ZbvM016523;
	Mon, 11 Dec 2023 10:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bn9m6ZHBOEK4aU3igY1lQ1CdMDbIryMawx9SyqHE66I=;
 b=oHe1yCB31T5UnQ2TVjabMHAUg6WSCMqcuCWAZhInrwTjM9SJF2RfLDAfnKeDIIlMUTOa
 zTxg0oZShCe6aKkDHs842OkavKTqCd5I2yEGHZqVFe4PnoT5RwmzsYk+j92fgbOAGvsK
 whZm8MuhSXq93TQjrEVE3YfTeadB4xy3R9APX+PBb87xZrWa065IxdWQG+RO9fAKnfp/
 GA3EIjTI+4dyvy/eNtgLmCZv9OkZJPNDEzOCeFNhhL/rgZXq6pmgp3JtoGS/OApU/9Cu
 k81yoZcoU7mQY7TAglqqOtNASAGpND3NHUVLK/p/MhdNeBF8FTzOlV1FEMGHnjy1ZluJ Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uvtckdsn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Dec 2023 10:04:49 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BB8oWMg024676;
	Mon, 11 Dec 2023 10:04:49 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uvtckdsmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Dec 2023 10:04:49 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BB93HCP004139;
	Mon, 11 Dec 2023 10:04:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw4sk06q5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Dec 2023 10:04:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BBA4glQ11993628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Dec 2023 10:04:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E067420063;
	Mon, 11 Dec 2023 10:04:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4F3E20067;
	Mon, 11 Dec 2023 10:04:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 Dec 2023 10:04:42 +0000 (GMT)
Date: Mon, 11 Dec 2023 11:04:40 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: [GIT PULL v1 0/2] KVM: s390: two small but important fixes
Message-ID: <20231211110440.3e4e8346@p-imbrenda>
In-Reply-To: <CABgObfYVfNsfjy36iBeq7qiV_m3smRKCyOSWQRV2E0OMH1bqAA@mail.gmail.com>
References: <20231115125111.28217-1-imbrenda@linux.ibm.com>
	<CABgObfYt3VH-zPwT1whA0N7uE2ioq9GznTt-QhnES8B5tX76jQ@mail.gmail.com>
	<CABgObfYVfNsfjy36iBeq7qiV_m3smRKCyOSWQRV2E0OMH1bqAA@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DrLjTXKdKomyw_z-kYeAKZKBqG2kkePm
X-Proofpoint-GUID: Q2MkdVnMeB_A4Rcp0-hj5Ek_Eo7tQoFR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-11_04,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=794 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312110082

On Fri, 8 Dec 2023 22:02:43 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Fri, Dec 8, 2023 at 7:13=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
> > >       KVM: s390/mm: Properly reset no-dat =20
>=20
> A small question on this one, would it make sense to clear _all_
> gmap-related bits, including _PGSTE_GPS_ZERO?

That's a good question, I'll have to think about it.

In general, though, not resetting it will not cause issues in the guest.

