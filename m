Return-Path: <kvm+bounces-49678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF8DADC306
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98580171A61
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 07:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E4828C84A;
	Tue, 17 Jun 2025 07:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QcaClBhF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D2219047F
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 07:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750144613; cv=none; b=BcGLZEzHZo4gcoupeSZn+e47pzey2W2qZaTzI2EV3QebssfGLta/FBQsSb/1OQEBXA3THG/ejEdBRXDLxdzhwZJZtp32y9MIv5sDJvGz5APEFfF84KAzg2dfeqDqmz1K1P0JFGx3Fqha0q8g2fRhHuCBCbl5kTzpFTB9fE/FkGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750144613; c=relaxed/simple;
	bh=3IQYlv7LMykQ+N0DvD3Sy+dxLttmi+LIhyuIlXREmaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=haDCCRzYstkko9el5YGO5SJqqYDDFf3mVb7lXT+6XLxYmX6pLy9JxTCThRHhAhiwvOimpvFgCBXlSSJrVHV2W0JV0/6FmIA3ha1j4cPOnOz+xtFv8gGiKwsKEwoKbKsIH1Na3fcpezcQB5eTHMMwLj859hKjL7Y4dqgBq2D3C8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QcaClBhF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H31JdI009585;
	Tue, 17 Jun 2025 07:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=3IQYlv7LMykQ+N0DvD3Sy+dxLttmi+
	LIhyuIlXREmaI=; b=QcaClBhFWqQytd9668+ce6ZI6GHVnALSGQ9DTFAdveS3kc
	kgTTMIvmoEexyTXVJp/Qj5jYEW/+7bYaqgaV4yBaTGBCb5c4Wc+U+ehMKFNvgPiF
	sXjjn06nIKvj0w4NJISQJtOciHMx4ArSH1M6XGPtU+p4xo72HAU7FCh9Rw96m+dR
	jW8RcIy74WfH/ml/vaKCY6MR0b03vfvllBkfvP11h7mcgqkofRxejNUzXt1QxVtg
	V6O65rH7GAgQ2lN+JpdV+FDGy/pBZFfgGHq0mYFhd9wDcnrliZ1VFSXlsczXqkl3
	b8VzRoDurJsL46aaYu8g9jZBF0GJ4sNlwb7bOGMA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790r1x6hr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 07:16:42 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55H7FYgb009553;
	Tue, 17 Jun 2025 07:16:41 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790r1x6hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 07:16:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55H44IQ3027458;
	Tue, 17 Jun 2025 07:16:41 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 479ksytar5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 07:16:41 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55H7GbxX50462998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 07:16:37 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24EB720043;
	Tue, 17 Jun 2025 07:16:37 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C08820040;
	Tue, 17 Jun 2025 07:16:35 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.204.206.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Jun 2025 07:16:35 +0000 (GMT)
Date: Tue, 17 Jun 2025 12:46:33 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: npiggin@gmail.com, danielhb413@gmail.com, harshpb@linux.ibm.com,
        pbonzini@redhat.com
Cc: qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        vaibhav@linux.ibm.com
Subject: Re: [PATCH v2] hw/ppc/spapr_hcall: Return host mitigation
 characteristics in KVM mode
Message-ID: <iqyt4ygn7g4hfcs7yaz4x45jqkcoe2qodf4fsiwrlyx23yegig@aunuigdhtx4c>
References: <20250417111907.258723-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417111907.258723-1-gautam@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NKMkqihTPb1b3itTg9CLjj24dX3sW887
X-Proofpoint-ORIG-GUID: ASFoobqkqlTGUo7QYp20-1GF5UuiLhhe
X-Authority-Analysis: v=2.4 cv=AqTu3P9P c=1 sm=1 tr=0 ts=6851165a cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=b97EAFsRugTIa9utK9UA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDA1NCBTYWx0ZWRfX5Xc1SxsABDkw Nv3OEe0gwN6mBXrHl5Kin+68V8v1V/nW8daEJRf/0NPcTD/m3c6kp+AlQVVejcUiDIdsB7C7ZB1 oy92WBU2RGR9zqNXucvb2mq83n3ACoPZpoNndsd9CI4L64j4fP0qmxJ38PNs9bPcqhSrspjvC7w
 w64SbSwnb1aFC/AKtZ9oDtDTMiB5tINK36Dd2hBEjpOISNXXEvRw5aqGpyGn1V71SeLZqtb5B+F pfprWRNfjhk4U8gqvyg/Z2qyukvevkeXsElS610L9qaHntufrTyeeOvMzHDWLY5lQMCTZa0xRH/ 49MZDy+6hUQsvDiv6VkHQ+AgCRShREzS37TMdiDabdiAhpC1xhQHqusvZwxz7A7qY66BaWLy1VK
 pruvpqU2rK4WuGLmutxjUIpNW4hwhiDzue7zCGRO7hj0b6rSXH4vFRRd2z/f8ZTVCj0Edp4F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_02,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=663 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506170054

Hi Nick,

Any comments on this? Can this go in if it looks ok?

Thanks,
Gautam

