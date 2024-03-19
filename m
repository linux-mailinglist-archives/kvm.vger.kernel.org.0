Return-Path: <kvm+bounces-12114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FA787FA35
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 10:00:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3A6B1F21F15
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50BF37C0B9;
	Tue, 19 Mar 2024 08:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hoh38pHS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEEB54BE2;
	Tue, 19 Mar 2024 08:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710838794; cv=none; b=HWmKQWTg45KdaB7FvustEpD0Y6nEzvOYpqVbb4nBUs6CWjQbYWCbelTDy3Mjdnjd0HMAVHWgD8x8GxTJfDF8XP7f+7qbnkV4D5QavPqY/ItrSdj9hq/0fDhPFHUYGneMMCzrDuynGcMhgsjA1q5dI0v/vCTA5TFsZ/1/lq669nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710838794; c=relaxed/simple;
	bh=zsdYz3jN/6SotqZabyYZjBZs275r8CvOSdZhCKiQW8Q=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Vgs+zO/Nc7LjODemseNa6/gTc6/HQDZEee+eMxVvlw0afDeo+wGnOyg3FioPco1Cswf6uDT/nNDk1r1RWZT+EH/xqhTarMJ9wkQ4U7ZOHIoQIpFYzdSLO0VI4ZaMgXBvWnx3+9qgZKRtseo3E4ftKZyMLbCOSx3wZyh47Si8QBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hoh38pHS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42J8UJxc019881;
	Tue, 19 Mar 2024 08:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=LUbKQi10BhRRdxGcjFBVGH4lzCf1fHSjHP8L558ZR/U=;
 b=hoh38pHSBNRV6IF4S14G4mLMwItWsnfMYQ5lOLWbBp3l5kWcgGAdlYsYsBZnfjNerXUK
 ld6eBCyKGmQppMiZAjdQr1RRsuS0oQZRT+dhlHQyOpgR1T5sZ0ROXENtGLP4bPQh1oG5
 xR2MpM5lh8yDwNQ1EPnNkvbzLxIxJIZDcQeuvT599qG+YvaxZ7VawCiiC8q2bUEHf98B
 EZX9P9GPSyzVtxmPlKGx30Y1tejWCsEU1Hb/L37PbExBZ5m8g/M/7B0+Nnxrx01T5nIn
 /Nx1sqbjiTi+nkwjSQiovjq2W0Z16uk2kAB0yORTA3V7KYrjfeSFM1iI2DsFhRfALGkP Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wy74u87er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 08:59:38 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42J8pns8029795;
	Tue, 19 Mar 2024 08:59:37 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wy74u87eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 08:59:37 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42J8c63x011543;
	Tue, 19 Mar 2024 08:59:36 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wwq8kx5nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 08:59:36 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42J8xXKJ45089124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Mar 2024 08:59:35 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C99E458067;
	Tue, 19 Mar 2024 08:59:31 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C5CA58061;
	Tue, 19 Mar 2024 08:59:31 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Mar 2024 08:59:30 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 19 Mar 2024 09:59:30 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Luis Machado <luis.machado@arm.com>, Jason Wang <jasowang@redhat.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        nd <nd@arm.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
In-Reply-To: <20240319042829-mutt-send-email-mst@kernel.org>
References: <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
 <89460.124020106474400877@us-mta-475.us.mimecast.lan>
 <20240311130446-mutt-send-email-mst@kernel.org>
 <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
 <73123.124031407552500165@us-mta-156.us.mimecast.lan>
 <20240314110649-mutt-send-email-mst@kernel.org>
 <84704.124031504335801509@us-mta-515.us.mimecast.lan>
 <20240315062839-mutt-send-email-mst@kernel.org>
 <b3fd680c675208370fc4560bb3b4d5b8@linux.ibm.com>
 <20240319042829-mutt-send-email-mst@kernel.org>
Message-ID: <4808eab5fc5c85f12fe7d923de697a78@linux.ibm.com>
X-Sender: huschle@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cHsvNv2I2RC7P1ZN_n6udKs2m42vkLbJ
X-Proofpoint-GUID: rV_1Qssz0DqjdkKHbbVWtMepfcwTjcBL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-18_12,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 mlxlogscore=843 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403190068

On 2024-03-19 09:29, Michael S. Tsirkin wrote:
> On Tue, Mar 19, 2024 at 09:21:06AM +0100, Tobias Huschle wrote:
>> On 2024-03-15 11:31, Michael S. Tsirkin wrote:
>> > On Fri, Mar 15, 2024 at 09:33:49AM +0100, Tobias Huschle wrote:
>> > > On Thu, Mar 14, 2024 at 11:09:25AM -0400, Michael S. Tsirkin wrote:
>> > > >
>> >
>> > Could you remind me pls, what is the kworker doing specifically that
>> > vhost is relying on?
>> 
>> The kworker is handling the actual data moving in memory if I'm not
>> mistaking.
> 
> I think that is the vhost process itself. Maybe you mean the
> guest thread versus the vhost thread then?

My understanding was that vhost writes data into a file descriptor which 
then triggers eventfd.

That's at least how I read the vhost code if I remember correctly.

The handler beneath (the kworker) then runs the actual instructions that 
move the data to the receiving vhost on the other end of the connection.

Again, I might be wrong here.

