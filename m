Return-Path: <kvm+bounces-41796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3E28A6D9F6
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 13:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C75361889FA7
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 12:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1CA25EF85;
	Mon, 24 Mar 2025 12:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="emVMVq6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28A825E81F;
	Mon, 24 Mar 2025 12:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742818646; cv=none; b=HR/R65oi+sbCl9O2GWipRz7s5tyC+LcGawUwK54J2mUYVHe+VDRRSv9RnEN64/wdxf7WRCTOSeLVei4yZIdMx1z0rHK2jTe8Rb4azw7B7l+3jIzdLldXnlhGP4qdm2WnEX2QtdNbCy9Ut9VXFnfBeWNRd7VK1oOg1LfoHQ9I77E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742818646; c=relaxed/simple;
	bh=ntVLPB558jkDqC6dAc3SwXIASugn2A1XtzkJc5zU8MQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JurpTDpNi6Er0bXGCIQfkW2YI63zIYw4ejv+lWaJXJ9heZvkTvbKdD1bN7xJP97vl1O4hZLtjlKkxBWKqRjr6uyfaOXQSEjztiafoBa0fJHL9Im6KH070F0qkkfHrdwTfSetJM6hqvE7YVZjhPRPENDncUuKgwPRAasttYv7Dw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=emVMVq6Z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52O9uEVw010776;
	Mon, 24 Mar 2025 12:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ntVLPB558jkDqC6dAc3SwXIASugn2A
	1XtzkJc5zU8MQ=; b=emVMVq6ZKJVFE11W3h3r6kl+aArjRUzrVMKgYre5SlYZbD
	gesBBqKbCECszumzqzLz8+nQbYbLWKyju/JdwcD5Pwcth9BVrZ44kSM5oyEwJuRK
	i5UlocRBijSfAJkmcwXLjsEsT4h7+z0NmIPKiOex71jTciZG7x+vCCj+V5HtVhGw
	IPsoBQ1QaPqrDWfbiuci5OuDPW3nPO3PVrn8wOAJ5qFcrWcNKdK4K7u0mGghef+d
	xqNyV3q3UnHBAMviEo6SbA1cvJbR+KBkLpFNan520GJ8u7f00QzGKHdEy7shsdhL
	NPXU12r2gXlbwD7VcBYWy+c+Im0Ug6XTfzj5U6Bw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45jsfpbc7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 12:17:12 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 52OCHBcq021741;
	Mon, 24 Mar 2025 12:17:12 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45jsfpbc78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 12:17:11 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52O89tSE020639;
	Mon, 24 Mar 2025 12:17:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45j8hnp4hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 12:17:11 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52OCH7Sc20250938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Mar 2025 12:17:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5178920043;
	Mon, 24 Mar 2025 12:17:07 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3966A20040;
	Mon, 24 Mar 2025 12:17:05 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.204.206.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 24 Mar 2025 12:17:05 +0000 (GMT)
Date: Mon, 24 Mar 2025 17:47:01 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, kconsul@linux.ibm.com, amachhiw@linux.ibm.com,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 0/6] kvm powerpc/book3s-hv: Expose Hostwide counters
 as perf-events
Message-ID: <hap6g4knk2uery5axusfrqi5pbe6nlpohs6tvbdkcyegvov47y@x5eaysm2er4f>
References: <20250317100834.451452-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317100834.451452-1-vaibhav@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PCxRnUfJxcDLFEHzcqIICkyFCwuHQ83Q
X-Proofpoint-GUID: Kn_dDUiodvBLm1dE6Rq2GnogDazR4uYy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-24_04,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=502 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503240087


Tested on both KVM on LPAR and KVM for bare metal.

For the series:
Tested-by: Gautam Menghani <gautam@linux.ibm.com>

