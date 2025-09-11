Return-Path: <kvm+bounces-57288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1CE0B52BE9
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 10:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D24D3B32AD
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 08:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777A02E36E9;
	Thu, 11 Sep 2025 08:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G3TREMQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2449927F006;
	Thu, 11 Sep 2025 08:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757579892; cv=none; b=QFeckJNgOomZ3RBgRKyvROd76kzzHDrr0syOu5BVGZVxLO1ximCRKpMjArIYV7WBUf8mF3Eg7GcsALEK4X0VQ8/YrluOsecAdHJRMjUigoVNMMzSycXp9H7TxRTYSoqgRCUe5xWHmWpnl25dM51/5cGvgVra40+rbGF6hNHeljo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757579892; c=relaxed/simple;
	bh=Mr79UWFOM9OOhJaVjUVp0mDo2CalKlW7SJpHH/0Xd00=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=BhLW0jHDWEj5OQAz7ydmXxsQ0TqXU0Cvw6JHM3a8oPIg6bR/H4mW20/xdoNMLAFzrv6WvjYG/jOr6y7ezjjzfxyPHWRGOF3hutMUzqgLvbad7ub5ww1x0YcmtlvOPsPH2wX1R/py2++03kkJsuClAoijwnXKmn3//DVcFdM3u4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G3TREMQ4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B4Yvab031928;
	Thu, 11 Sep 2025 08:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Mr79UW
	FOM9OOhJaVjUVp0mDo2CalKlW7SJpHH/0Xd00=; b=G3TREMQ4qOETMMwMs6Cl5K
	r15DfkCU1HtxbtL1w8mv9G33vfRU8kd8/TqGzmYIsb0akipFQeytEzyRqdlqAZUx
	IZS6ZDg4L1eAWNoZPWSugTR6Opnjfk8kKGOq3e5DmFh+yWCGqrF5SnYgzgQEoeVE
	ikOa6nf//5kJZItsZ1g9NgQWDKqKPJ0X7wDEmXS8ZEZi3AOIZFlYuYrVJYk8Gbs7
	LmGUhknX4PvCGcqAEzURzXeTLM8g2ntX3tROc8dVljY4v4XzBnr0ZkQ46Lf4/Xn0
	5w5g9X/+d82g6WMB5D9rKBaR+JR71ROW6svjqUy7ilJA8nJPw9mhOTM6Yko63Yhg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bct2tm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 08:38:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58B50GE8020492;
	Thu, 11 Sep 2025 08:38:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp151bg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 08:38:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58B8c3XL49414532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:38:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 520072004B;
	Thu, 11 Sep 2025 08:38:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE84220040;
	Thu, 11 Sep 2025 08:38:02 +0000 (GMT)
Received: from t14-nrb (unknown [9.111.58.3])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 08:38:02 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Sep 2025 10:38:02 +0200
Message-Id: <DCPU2JK4AERP.6UMVMBAGJSCY@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <borntraeger@de.ibm.com>,
        <frankja@linux.ibm.com>, <nsg@linux.ibm.com>, <seiden@linux.ibm.com>,
        <schlameuss@linux.ibm.com>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <david@redhat.com>,
        <gerald.schaefer@linux.ibm.com>
Subject: Re: [PATCH v2 03/20] KVM: s390: Add gmap_helper_set_unused()
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-4-imbrenda@linux.ibm.com>
In-Reply-To: <20250910180746.125776-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX9eiJqfYVwXN3
 7C63COfO56is7R+5SGoXY1ZfCYbcctKhEsElr+QMh6phIVpqL/mCIYyXogyljZoKVrIHgVGnK3u
 veHBkmunoLnMCHzTkBWyNsqfMbiD/Y2ym9R6T7tPtOSzJQqCgVmTHlsjSQZBULRZmYJad1pDs4B
 G+vr58qqETHzuwGC0d8HgEqtQck+uR/pqHasS6Ko+Pf1MFYS06lNRo4aXHpTMXP41c4HjVpKplR
 RMzfeOjxoBGJCSxTW3d8jlGREaHIG7KkzXgGHZJwms7yX1WkWDdXy9gGzGFVCnCwpb6mOuOQrTV
 l0vwZ43pyV635EHa4bAmSCohSLlWhYb/GNClJLI2HFrP7j6RvcGyjtSlV+4tbrPz5LJUYCX/shJ
 5yyihadV
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c28a70 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=WEpOJczLzZDRNqIK8FsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: r01cRzGd5DCmwe8UDFj4BggK3ysPDNP3
X-Proofpoint-ORIG-GUID: r01cRzGd5DCmwe8UDFj4BggK3ysPDNP3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

On Wed Sep 10, 2025 at 8:07 PM CEST, Claudio Imbrenda wrote:
> Add gmap_helper_set_unused() to mark userspace ptes as unused.
>
> Core mm code will use that information to discard unused pages instead
> of attempting to swap them.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>

I observed 21965 calls to gmap_helper_set_unused() where we were successful=
ly
traversing the page tables to the PTE; of these 21868 made it to the part w=
here
_PAGE_UNUSED is set. So _rarely_ we seem to be unable to take the lock (or =
the
PMD changed under us), but in the majority of cases we make it, so this see=
ms
fine to me.

