Return-Path: <kvm+bounces-97-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC6627DBE02
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:35:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 199A11C20B1E
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B54A18E32;
	Mon, 30 Oct 2023 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SjddyvcF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F7B19440
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:34:58 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A879E
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:34:57 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UGEk7P023908;
	Mon, 30 Oct 2023 16:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dG6sE90S6mN47vpfv8wj9aM5tradmU3QBcpgMkU1nUw=;
 b=SjddyvcFDOjK26IB40OLp1VQBgP9X4skGzIy2JgHdkQCv/wbkPGOPspEtFfufUivkhJe
 ZaVvUTrse/hWug3dGM9TCiG11O5VPFNTUrlwOnFrDs9my6wU22kkf8A8DQ5HYd6RAjJS
 EYxil2Y929O2wY0POy1QxTFIXRznJhr7aiZ1C6lewqrZxjNCS1WEo8Gcs4wg3swc9KRz
 H8X/3ZozEgN8mrwJrHuuUCvw8fLmBiUhPeX67IQyqA+RJ/5/l2tZlHyNMLz8706+vPtd
 Zdp7s7srCjiEaFoOiN4377t2z4uVuwhXmsHbcViPIcbaqSUfEOBj0Uq0oMK13xCZbKQS mg== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2fu8rj8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:34:28 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39UEdD5i007664;
	Mon, 30 Oct 2023 16:34:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1dmnabt6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:34:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39UGYMZF24904322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 16:34:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1ED3B2004D;
	Mon, 30 Oct 2023 16:34:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 948DB20040;
	Mon, 30 Oct 2023 16:34:21 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.179.11.228])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 16:34:21 +0000 (GMT)
Message-ID: <1b714907d9a6923575530b3bb2ab0c93f2333250.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Avoid using forced target for
 generating arm64 headers
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse
 <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui
 Yu <yuzenghui@huawei.com>
Date: Mon, 30 Oct 2023 17:34:21 +0100
In-Reply-To: <20231027005439.3142015-3-oliver.upton@linux.dev>
References: <20231027005439.3142015-1-oliver.upton@linux.dev>
	 <20231027005439.3142015-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zdXkW699K-NQWtMgShi6ERL0MYXrmDXp
X-Proofpoint-ORIG-GUID: zdXkW699K-NQWtMgShi6ERL0MYXrmDXp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0
 impostorscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=679
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300129

On Fri, 2023-10-27 at 00:54 +0000, Oliver Upton wrote:
> The 'prepare' target that generates the arm64 sysreg headers had no
> prerequisites, so it wound up forcing a rebuild of all KVM selftests
> each invocation. Add a rule for the generated headers and just have
> dependents use that for a prerequisite.
>=20
> Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Fixes: 9697d84cc3b6 ("KVM: selftests: Generate sysreg-defs.h and add to i=
nclude path")
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Tested-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>



