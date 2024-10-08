Return-Path: <kvm+bounces-28129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B41E99945F8
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 12:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B8681F25852
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1615E1CF5E7;
	Tue,  8 Oct 2024 10:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iGCQ6NPv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18E81C9B77;
	Tue,  8 Oct 2024 10:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728385187; cv=none; b=FrrUNS6+UbVTmJVbc1aVhq6+9ao+kMe0At8mKWoHGgHYqoSaw+ck7M7UTPCfydJKhm8r7fxX2CXRzwOHXEgxP8YESLOPfAtncDktDPLfMsSSmu6l32+wZu2zwvdLDbfFsf1X7HVDpQ81rKqdJips5QNQ7Zw5jInQ0/XoJrpHz5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728385187; c=relaxed/simple;
	bh=zeUqvI7SPlfEDQRc680LktQNkR1koKFBn87cj8I1z5E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QLmIgnSPDNZuCHXK5+ySxTS8MBo/+hYxeUJkqI6ohreUzbw2HJLdKS4l9QwQ5dJhuHi0Fzj2zRM5wIZUCU5eYro3QE50OUPx59CPU3Qrb2cdAkPcNDAmywuXHwmqe6h+8z85ec8b4XXTNCByVPd5J3S9WWk5xE4JC0IgDl3KUKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iGCQ6NPv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4989Juau020507;
	Tue, 8 Oct 2024 10:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	4A8DJyWg8LQ+N4AyllITtSSlkQcxiPJBfcJryBouwNw=; b=iGCQ6NPvXDS1rNyW
	E6O4S/UM3bGpjThxzuzn/CT/+jJ5uwSI3upOn+Bb8jK2LW5jWYz2kFkUvN02mBrh
	uX1QuXrwtxrStlfiBwxMRs72vBeVtNcyeIWBuJYzaM89/nxj9ZtIEJuTJjdJ28Hp
	y/InN8D+QBpDvKjuA2Nk/3UI0IlGPVgBhY4pTJY4WlPASG5UMwLiZnR841fzs6Yt
	j07YJRa2I1S0N5VVNmG3jqW2bfq1liE2o0QN+1Biie09Io4NTJXXir6ii9N1y/vf
	LNLPRV+rPMj/OOFEwgZvozygUwyn/O4aVF/7Se+L+RlJF3SemQg871GrZpK6Seac
	FmZkuA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42520hggw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Oct 2024 10:59:38 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 498Awb8d021450;
	Tue, 8 Oct 2024 10:59:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42520hggw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Oct 2024 10:59:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4989FaVT011516;
	Tue, 8 Oct 2024 10:59:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423g5xkx7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Oct 2024 10:59:37 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 498AxXN542271164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Oct 2024 10:59:33 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B5BE2004D;
	Tue,  8 Oct 2024 10:59:33 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57AEC20043;
	Tue,  8 Oct 2024 10:59:32 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.179.3.110])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  8 Oct 2024 10:59:32 +0000 (GMT)
Date: Tue, 8 Oct 2024 12:59:30 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Robin Murphy
 <robin.murphy@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Halil Pasic
 <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/virtio_ccw: fix dma_parm pointer not set up
Message-ID: <20241008125930.33578456.pasic@linux.ibm.com>
In-Reply-To: <875xq3yo97.fsf@linux.ibm.com>
References: <20241007201030.204028-1-pasic@linux.ibm.com>
	<875xq3yo97.fsf@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0olIk7itJFa692_e9qiWOsWSRvlhRHRt
X-Proofpoint-ORIG-GUID: ZOgQRSixwEq07pQDdsufZ9psI2fkElxs
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-08_09,2024-10-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=647 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410080066

On Tue, 08 Oct 2024 10:47:48 +0200
"Marc Hartmayer" <mhartmay@linux.ibm.com> wrote:

> > Closes: https://bugzilla.linux.ibm.com/show_bug.cgi?id=209131  
> 
> I guess, this line can be removed as it’s internal only.

checkpatch.pl complains about the Reported-by if I do. 

It does not complain about
Closes: N/A
but if I read the process documentation correctly if the report
is not available on the web Closes should be omitted:
"""
Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
----------------------------------------------------------------------

The Reported-by tag gives credit to people who find bugs and report them and it
hopefully inspires them to help us again in the future. The tag is intended for
bugs; please do not use it to credit feature requests. The tag should be
followed by a Closes: tag pointing to the report, unless the report is not
available on the web.
"""

So I guess I have to make peace with getting checkpatch warnings when I
give credits to the reporter for reports not available on the web.

Regards,
Halil

