Return-Path: <kvm+bounces-68011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 68609D1D9DA
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 10:40:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AB9C1301E212
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 09:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219E9389453;
	Wed, 14 Jan 2026 09:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s7xv+SAB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAEC318BBC;
	Wed, 14 Jan 2026 09:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768383592; cv=none; b=j+vQNPxZY/xfP670Oi7vcdzzjsWCCBYTS+iX+2iexua4nZUPVKIThhM6aqPcNhiYuMjtFf+mfh3hIdH3VrNvdgDFdRk0+4JOug85JDOcLSShe+8qrFiXQTy0PyKb/AzYapWZLNocPWwUNQpGkVus1d7KsOd+yQAzFr3fQ+yMlBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768383592; c=relaxed/simple;
	bh=M7TqZbhGK4Plnsloyz1oWqx5GxI48K6tYtr+LPcgF8E=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=W1C95jQZTUoZFtTvdL7kporQSEC5JP8v+qARD2mduvmN0adQ4CfnW73VlqTcl8U0j16E7D6Jk9kPLin0LZGeKm9eKNqTIU9yRRDlUPTZgz7yvUkguZPRiW2nx5feiGsgHDMAAagIxk+ikIFSrA9KNCPEBmSwl+Sz9ktX1UevG8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s7xv+SAB; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60E7Mrw1026790;
	Wed, 14 Jan 2026 09:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=M7TqZb
	hGK4Plnsloyz1oWqx5GxI48K6tYtr+LPcgF8E=; b=s7xv+SABooSs8SHvjeUBgt
	BTYETyyznEr1Bod3ECznCKswpAlf8vLmmvwEnVFVCk2E6YALOc0k0qTdI9Pvibkb
	/BfF2Au1rZ1sfzeP0jIQQYZs0GBZpqNgVmxT7S0QK7ifB2EYhxaE2yYq9CojxIJB
	3nShQqdJZBndOUw5jikCRx+FtItsBguz+FWuHygHipXRWQGNhlLNKuJlRh9zs1zH
	JZACtXOjKY0uZ1tGcPINsjPTirlo4r5VkclGUUKrSsMQXbB8UuMoYM56D64j8cev
	fIb03RzEVzKMNllSopR/REiGkPwKRuZJeg1qq7aYFDhjG4M1Hx/1JIPJFuYnWusA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkedt0a1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 09:39:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60E6jb4Y014255;
	Wed, 14 Jan 2026 09:39:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm1fy9cws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 09:39:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60E9dhvt37880070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 09:39:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52EB520049;
	Wed, 14 Jan 2026 09:39:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40FAF20040;
	Wed, 14 Jan 2026 09:39:43 +0000 (GMT)
Received: from darkmoore (unknown [9.52.198.246])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Jan 2026 09:39:43 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 14 Jan 2026 10:39:38 +0100
Message-Id: <DFO7NSPBTEGY.JHXXH5PT76WB@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
To: "Eric Farman" <farman@linux.ibm.com>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand"
 <david@kernel.org>,
        "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE when unable to get vsie_page
X-Mailer: aerc 0.21.0
References: <20251217030107.1729776-1-farman@linux.ibm.com>
In-Reply-To: <20251217030107.1729776-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA3NSBTYWx0ZWRfX7VyZuMrcUO7e
 H1S97w+4eDYif0uBWx2HtAnFdQD7saoetXi7/3BI6WuhVG/D47f8ZVVKaVQrGtbysZQI2SN6lXj
 ZT0G04/9yNUbKrSXtOqAekIL5eWiVUl6kW6vNTcI0hLiJvLD1klkzv5fE2Ia8mnqGrniI6bdsoG
 H2uaXd8ghX2mr3seEhZzRS6T8mTOVPtrP8WThOxBpFQKh6hROc6BUDmglfk4wMROZU2mtjO0c5Z
 WnvYR6QUqYKAGw9qdpOUbZjoE4XiSpDBuGxcuNgkHzTU/lvXTRvztKEsQvlkSK7Yr2MQZOILgeA
 8qM/ukEuYC9msri4Vc7/QjR7jqmSQCec5h2fRs0HSkYqlH9HNo6/YfTqc5Lu2bYQnAwwexS/sTU
 LEJK74jRT0KOCVPzOlyevF2ZGeXqvfSBYzRzytOha8SITtk1YXnH/qaA0Yot02yxOkMdd68MwWx
 S6P/hAlEMKtF58c6Grg==
X-Proofpoint-GUID: LPxdp4CtDSjh9h2o3rBA0Y6BIr7NRxxb
X-Authority-Analysis: v=2.4 cv=WLJyn3sR c=1 sm=1 tr=0 ts=69676464 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=K6PXcvzj_mSOQNv_xU4A:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: LPxdp4CtDSjh9h2o3rBA0Y6BIr7NRxxb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_02,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601140075

On Wed Dec 17, 2025 at 4:01 AM CET, Eric Farman wrote:
> SIE may exit because of pending host work, such as handling an interrupt,
> in which case VSIE rewinds the guest PSW such that it is transparently
> resumed (see Fixes tag). There is still one scenario where those conditio=
ns
> are not present, but that the VSIE processor returns with effectively rc=
=3D0,
> resulting in additional (and unnecessary) guest work to be performed.
>
> For this case, rewind the guest PSW as we do in the other non-error exits=
.
>
> Fixes: 33a729a1770b ("KVM: s390: vsie: retry SIE instruction on host inte=
rcepts")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

LGTM

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

