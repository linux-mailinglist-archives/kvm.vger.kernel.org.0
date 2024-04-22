Return-Path: <kvm+bounces-15510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E98748ACE83
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5EA12816E0
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C260A14F9F1;
	Mon, 22 Apr 2024 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jvGQs/S3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DC313E8B2
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713793217; cv=none; b=Gkn/sscifU1CwP96FdB6/LgAvfirp9VGKzXfaUHcZ6V2LhzO8ZVrg+d0Tqz0KMFM987BxWgFbg9UlIOTiwU6sw3jQNgUo4T56ZSlnECiPuGDEsywttvr881rATy3pmBxLJVSFl5ChaUuQi4pAh7WE5tSV5QFSd2FqZwr/xIMmXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713793217; c=relaxed/simple;
	bh=DbIzjFpX9A+w0ykhgrEwCO6vyzE/0e9nqVrCO85ZXt8=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Cc:To:Subject:
	 From:Message-ID:Date; b=PBC5DANWJJDw2FDf0rBhzqAMUlqvVMo53GQJT6B2DpFym1HD7dWg6pBdgGQMw+R1HTRcYV95kOtju/pjsRCdyTbeZggngqLFtjeiQOqxDrvMSEOG+Bf1AcZhcnv7qjKHlhipikF9UPTxjwyI2XMLSNmCf12Jgd2vQGXixXfGRfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jvGQs/S3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43MC3dJM009176
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 13:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=DbIzjFpX9A+w0ykhgrEwCO6vyzE/0e9nqVrCO85ZXt8=;
 b=jvGQs/S3Ptj1J3RZQtnglbaMgjAAl32mY4boGIjLpX7XTLJrauJp1YeLI4VwKoLuMIQZ
 ojajrwzjHOqzVhN/pJGGjcoi7SmRrjicC78IRcUfXb9a1FOg8+ckKT/DJIs811j9pitR
 0G/qvU17PHjgwSyj1XKk0aVNykyfD5t02XN+bsLjn0zBw/zWv6VaALRzVm3A3/IDdd5d
 QsgHNOepbjZTw9UKdgEEXAv9bDO22XEuu8HjEsI+p3g9wRFBplYlhmKCoFCgEvF1OkU6
 wPjxMCg8rfczm/WMoim4cWBz/qp384woe22CWzU4p1LAWuHfdG5p99vqtNSsIWdZJLCr wg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnqhx87g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 13:40:13 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43MDeDHw021782
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 13:40:13 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnqhx87fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 13:40:13 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43MAXWLF015277;
	Mon, 22 Apr 2024 13:40:12 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmshkysgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 13:40:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43MDe6N050921894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Apr 2024 13:40:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0926B2004F;
	Mon, 22 Apr 2024 13:40:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E43792004D;
	Mon, 22 Apr 2024 13:40:05 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.95.74])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Apr 2024 13:40:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240418110140.62406-1-imbrenda@linux.ibm.com>
References: <20240418110140.62406-1-imbrenda@linux.ibm.com>
Cc: david@redhat.com, thuth@redhat.com, kvm@vger.kernel.org
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, frankja@linux.ibm.com
Subject: Re: [PATCH v1 1/1] lib: s390: fix guest length in uv_create_guest()
From: Nico Boehr <nrb@linux.ibm.com>
Message-ID: <171379320547.42592.12274461485771463935@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 22 Apr 2024 15:40:05 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bqPDBHUn-xa2ew_Q12twIXaNMpqkXstl
X-Proofpoint-ORIG-GUID: s1uswceN5XM3EmuSZwZ_kHox0EkrrxpC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-22_09,2024-04-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxlogscore=712 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404220060

Quoting Claudio Imbrenda (2024-04-18 13:01:40)
> The current code creates secure guests with significantly more memory
> than expected, but since none of that memory is ever touched,
> everything still works.
>=20
> Fix the issue by specifying the actual guest length.
>=20
> The MSL does not contain the length of the guest, but the address of
> the last 1M block of guest memory. In order to get the length, MSO
> needs to be subtracted, and 1M needs to be added.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Pushed to CI and queued, thanks.

