Return-Path: <kvm+bounces-20820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A1891EF4D
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 08:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EB27286CB7
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 06:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B852982D68;
	Tue,  2 Jul 2024 06:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VxhhmaLn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EB317C72;
	Tue,  2 Jul 2024 06:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902670; cv=none; b=GYoQA9+gut7AV3h1V9lB7zOtIevy9Hv2rI4UtpMW6fVRn8rnuh/nXz6I1M/BLFD0wrBvGMvfRXuvXq8fQv9FESgVg7WEF4c6jqLcNGTBhUM/a6DSIn/UVMeN9OQA6A3/Ue3deKxIAYNPhZadjRkEzoPyvX+/MgqAoXx/7ew3a+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902670; c=relaxed/simple;
	bh=Vs3moVTrC91eRmtdg0gG5OFDSZri10zE1qO8Xn2GjQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJY7/WPmC4++wOd0jliAv0SPcUqxuGicqrpo9mGmIzafdK/4ZBrWA8RDsj+Yu/MePIrhe+oR2/Hmrbim6tAQbsO/wA8bMoU3aFfIcfcydjNZ2rNDOIEHNk+gQyW3zUdBhtpcYh7w3CC7JuGQlD1VteRqbxooETBoNhL6+73vW7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VxhhmaLn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4626RZE6012333;
	Tue, 2 Jul 2024 06:44:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=qbr9oD0mOlGVNIfon4hAHCP/nZC
	Ow7FZlN7LDjeegVc=; b=VxhhmaLneQJ4/Tj1zYg1h36F/gYasSsh1JDeppmkQIB
	YBcgaUMZtZWg3hkJMIdZp+VGVQhw2j41G5zPxPgX/+EuMsy9nYW43Y1CTDGicCLE
	pYyqLH5pYHwrZp4zeGiI9+Lb8ctnDWv+fCinCf7xxLgA5gYMJve/GOaSn+pkMA4J
	KftkgMIFC8ptXD2tqtvv7PGJOADThleI/jJcI/soVD/p+N6+orCeK1SdCtClEtUm
	AJ0NlUSs/n4nb2nA2zUpj7UQWmx9M3e6Cbeox/D2/JLLiIOOpEeC16F9bDYE1251
	alCfj/OWdfJ+q34FH/tW3P4MaQNNJHq1nr06VPhh4mQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 404bvc02hg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jul 2024 06:44:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46250W5o024071;
	Tue, 2 Jul 2024 06:44:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 402ya3ay8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jul 2024 06:44:24 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4626iIr951839384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jul 2024 06:44:20 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C91A2004D;
	Tue,  2 Jul 2024 06:44:18 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3A8420043;
	Tue,  2 Jul 2024 06:44:17 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.44.227])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  2 Jul 2024 06:44:17 +0000 (GMT)
Date: Tue, 2 Jul 2024 08:44:16 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] s390/vfio_ccw: Fix target addresses of TIC CCWs
Message-ID: <ZoOhwC+7vN4qR0NR@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240628163738.3643513-1-farman@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240628163738.3643513-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m4DxUT7lydZ5rjWvc6ayBKWl25y4tXdO
X-Proofpoint-ORIG-GUID: m4DxUT7lydZ5rjWvc6ayBKWl25y4tXdO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-02_02,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxscore=0 impostorscore=0 mlxlogscore=837 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407020046

On Fri, Jun 28, 2024 at 06:37:38PM +0200, Eric Farman wrote:
> The processing of a Transfer-In-Channel (TIC) CCW requires locating
> the target of the CCW in the channel program, and updating the
> address to reflect what will actually be sent to hardware.
> 
> An error exists where the 64-bit virtual address is truncated to
> 32-bits (variable "cda") when performing this math. Since s390
> addresses of that size are 31-bits, this leaves that additional
> bit enabled such that the resulting I/O triggers a channel
> program check. This shows up occasionally when booting a KVM
> guest from a passthrough DASD device:
> 
>   ..snip...
...
>  drivers/s390/cio/vfio_ccw_cp.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Applied, thanks!

