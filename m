Return-Path: <kvm+bounces-33285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C1D9E8F04
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 10:46:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 067DF188310F
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 09:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DA7215F69;
	Mon,  9 Dec 2024 09:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rFKOclY1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE3C83CD2;
	Mon,  9 Dec 2024 09:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733737593; cv=none; b=pWwo6fVuhEeoWlDGyhRNmLlVe95nqtPGUg0Jk/PrhWPoR5VI+i4m2/zsGDDc9cWDNFjpnQxxj5mLinzKTtl9g7IMdK3i8k/eGYmQepwPSMZV8L5odFg8Hw5OHH7X8z1xzsbZYww/vhLPVV3+6ThE3rJreUDkfNXLpCW7cPMVYdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733737593; c=relaxed/simple;
	bh=T+VJ7Y2Q01JG0Jt0X6EmRjJEUZh/GXr0TBwvjyjzoqE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=lEqJ3gdmrWJJIjlBVqQOkMuYN803vjt3E2nid8kP85MkwRFIEoqYGDebP2HIabOLmi0ngLW9QWOJpK68PdTzWdB9Hyd4MFuINYyq/POLID5+7xNHVO1uolr87GhD0HttI9OvE5Xxbhyzz8py2kYorzD2uQ93BN7I/SXRKcOvGn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rFKOclY1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B98utjL013253;
	Mon, 9 Dec 2024 09:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=T+VJ7Y
	2Q01JG0Jt0X6EmRjJEUZh/GXr0TBwvjyjzoqE=; b=rFKOclY1G/lEK70gLrk0Rd
	/OncN16A0qJK5hNdhtjYmpI+/TPDqc7sbxWu3gP3LOR4fkML7XI6OsH/aJHxatpq
	4JSsO3eMkStZV1OtrOs9zH+8KzIEnQ7+Z6voVveaW1qkGfftGMOtyr/k+m7/uUu5
	/qHPcNxR1UGMj3ndFbIqZdVyzRIJiGnhCSGXi4u86DBaCVn4RUciiYOPqBOp2L12
	UwnUt+LpfARRSyavtE7IVJ/NG3JZiGjAIpa1pSd5o40L9N6deiIg4pnHdnNjXcMA
	0uxtmUuAUCyuJ6R4wRWw9rc6K16g5jNlu78kYBiuDMLpG0Rxz+q9/WwfDGt1Z4gg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cbspyy0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 09:46:29 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B95mJsp016952;
	Mon, 9 Dec 2024 09:46:28 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d12xx5ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 09:46:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B99kOFl32768540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Dec 2024 09:46:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A60C620043;
	Mon,  9 Dec 2024 09:46:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C82D20040;
	Mon,  9 Dec 2024 09:46:24 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.80.137])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Dec 2024 09:46:24 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Dec 2024 10:46:23 +0100
Message-Id: <D672OIN9YGFG.1WUNYKHQ39WH7@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, "Janosch Frank" <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Support newer version of
 genprotimg
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linux-s390@vger.kernel.org>,
        "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.18.2
References: <20241205160011.100609-1-mhartmay@linux.ibm.com>
 <D670EQUUSVS6.1RFVHYTPER26Y@linux.ibm.com> <87o71l8ajm.fsf@linux.ibm.com>
In-Reply-To: <87o71l8ajm.fsf@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lby-RYabzLk5NKuHtIkA-Rr5e53YianU
X-Proofpoint-GUID: lby-RYabzLk5NKuHtIkA-Rr5e53YianU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=896 adultscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412090073

On Mon Dec 9, 2024 at 10:34 AM CET, Marc Hartmayer wrote:
> 2.36.0
> (https://github.com/ibm-s390-linux/s390-tools/commit/0cd063e40d12d7ca5bc5=
9a09b2ee4803653678bd)

Thanks, pushed to devel for CI coverage, this should also unbreak PV tests.

