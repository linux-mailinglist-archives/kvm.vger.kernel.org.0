Return-Path: <kvm+bounces-35732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E656A14B36
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 09:31:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51099168DB7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 08:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF79C1F754C;
	Fri, 17 Jan 2025 08:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XbWncO60"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DC81F8684;
	Fri, 17 Jan 2025 08:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737102645; cv=none; b=uFVjtTOqq7NFQ8m5VP1bouf8utAt2gJbVkyBhmJfWvlUfCbj36T6gHpvSYCvnwqQZqNyuMfdxbPaI1hPlshb1Bm1NlAYM/OXhEkqK5L/XSbViajO88gSGjmbpWp31ZY5vVQGbVpfl+wJw38sUTwMQtFjNO7HlQUjmbFagJFBMgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737102645; c=relaxed/simple;
	bh=8YyTt+c7gAnyI6EMMISoSkfsmpSuFMY8pPblhh8B5F0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=EblDKsWvYPC6V9oDlgDoHAx6kB1D2P8NOMMgDUdO2mnnEIpasYdD1eYvuvEDlKVj/r4xWEcYUsnc14vFXHEso9xja6e+lmzQM8/TBOrBZzhT9jFChwTsZd8LxMMiV5szOUftEDS9sOVUjTlR1FtZRlsBP83WNmxSjkGwztSUO10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XbWncO60; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GNaOj9018796;
	Fri, 17 Jan 2025 08:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=lQKSVeFxAh/wvraoLdrv6oIeb+tCVmaXQEAdjvfk7FI=; b=XbWncO60Pp4D
	d4eNRjA6HyZj6rmTqsG4ecYjX4trtCnsZwBRsmju93dh0+tSSqF5BdWRToBUWfe3
	fJ/RgeM5ZsFcHl2G0kyy2dUIqSdz61vmMV/wsxF1IOPgjCkyuCdq1YJhSMzT1LXD
	SPVPV2FhIBysB6Ho0TmezigyvFYo8CVPdQH1S7TgF+ouAdnBNgiPXW166QzWFjEJ
	ikabn0EzoTKZrXdmslrF7caENWws0Q1283zs6dMwTkyeN1NMRFMSBgGOQItBM4P8
	I2+qVCCyhSgpLWUuUC+EEl3ZvUwY7ZinBrFqpezRlc9bdpdLOOSX43cCWr8qt5Ha
	oD3EAn8USw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb1u59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 08:30:41 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50H6CBPH007519;
	Fri, 17 Jan 2025 08:30:40 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443ynj1f7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 08:30:40 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50H8UdRb18809452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 08:30:39 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9458D5804E;
	Fri, 17 Jan 2025 08:30:39 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABC3D58062;
	Fri, 17 Jan 2025 08:30:38 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 08:30:38 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 17 Jan 2025 09:30:38 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hca@linux.ibm.com,
        borntraeger@de.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        pasic@linux.ibm.com, jjherne@linux.ibm.com, alex.williamson@redhat.com
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <d1b36877-14ea-4110-84c1-941defc8d3a2@linux.ibm.com>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <45d553cd050334029a6d768dc6639433@linux.ibm.com>
 <d1b36877-14ea-4110-84c1-941defc8d3a2@linux.ibm.com>
Message-ID: <105ff0df576ac86c1cd2edd4e1a6478c@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CFcz3-cpfwUtJXnZxvLZmlY27nUWMuLo
X-Proofpoint-GUID: CFcz3-cpfwUtJXnZxvLZmlY27nUWMuLo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_03,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170067

On 2025-01-16 17:46, Anthony Krowiak wrote:
>> 
>> Rorie, this is to inform listeners on the host of the guest.
>> The guest itself already sees this "inside" with uevents triggered
>> by the AP bus code.
>> 
>> Do you have a consumer for these events?
> 
> There is a series of QEMU patches that register a notification handler 
> for this
> event. When that handler gets called, it generates and queues a CRW to 
> the guest
> indicating there is event information pending which will cause the AP 
> bus driver
> to get notified of the AP configuration change via its ap_bus_cfg_chg
> notifier call.
> 
> The QEMU series can be seen at:
> https://lore.kernel.org/qemu-devel/7171c479-5cb4-4748-ba37-da4cf2fac35b@linux.ibm.com/T/
> 
> 
> Kind regards,
> A Krowiak

Ok, so this way the AP bus of the guest finally get's it's config change 
callback invoked :-)

