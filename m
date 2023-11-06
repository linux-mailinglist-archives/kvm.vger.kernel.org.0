Return-Path: <kvm+bounces-822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAFC07E2FBF
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 23:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32BB0280DAB
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 22:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75FB32EB1F;
	Mon,  6 Nov 2023 22:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ptQzSEA2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ED82E648
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 22:21:03 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7815D183;
	Mon,  6 Nov 2023 14:21:02 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6MBAbJ002837;
	Mon, 6 Nov 2023 22:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mA552N5htsafit5Cwefei0xjOIrV3dSC6J30CUekmnc=;
 b=ptQzSEA2EQLxHCdT1h39b7ceIIebtU992z9oEfxHd7gm/kJsqE4oAQ9uej5WpebOR5vQ
 0YKgFkhGMPXucnnc0Um68t1TXzA5b2ZohDPz4aoZoFoj6EiBa9gByz4Yqe8EHud7fvnb
 NZG78vFhGve7Ka6Juf2zZNxM58tn7Qa1FvCddUxjIQwNNuEK/lAaY4eXjgU688SKuhMy
 chC7m130Xu59JjA+4uHytCnGkuiOETMvJKDRQ4UnaZ7uD/P6oAc/BCM44G+m+jtLPnRs
 sIi2Q21m80o+7cbvA0L547aK1pGBCYoB+laBnwyZ04ELP9J3ZwYwTvot/vKQOBlwZzO+ Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u78q3r7jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 22:21:01 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6MFHUu013517;
	Mon, 6 Nov 2023 22:21:00 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u78q3r7jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 22:21:00 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6M35C0025671;
	Mon, 6 Nov 2023 22:21:00 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u619nce82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 22:21:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6MKvbL17433250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 22:20:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 081DA2004B;
	Mon,  6 Nov 2023 22:20:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B47520040;
	Mon,  6 Nov 2023 22:20:56 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.62.82])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  6 Nov 2023 22:20:56 +0000 (GMT)
Date: Mon, 6 Nov 2023 23:20:54 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: fix sysfs status attribute for AP queue
 devices
Message-ID: <20231106232054.059b1d0a.pasic@linux.ibm.com>
In-Reply-To: <20231020204838.409521-1-akrowiak@linux.ibm.com>
References: <20231020204838.409521-1-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MtbJDBAnTwKkfBZWg5dE6U7jpycJDm1T
X-Proofpoint-ORIG-GUID: IzzDEXocsv2P6GwOTOLF0oxeBlqt1mp0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060183

On Fri, 20 Oct 2023 16:48:35 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The 'status' attribute for AP queue devices bound to the vfio_ap device
> driver displays incorrect status when the mediated device is attached to a
> guest, but the queue device is not passed through. In the current
> implementation, the status displayed is 'in_use' which is not correct; it
> should be 'assigned'. This can happen if one of the queue devices
> associated with a given adapter is not bound to the vfio_ap device driver.
> For example:
> 
> Queues listed in /sys/bus/ap/drivers/vfio_ap:
> 14.0005
> 14.0006
> 14.000d
> 16.0006
> 16.000d
> 
> Queues listed in /sys/devices/vfio_ap/matrix/$UUID/matrix
> 14.0005
> 14.0006
> 14.000d
> 16.0005
> 16.0006
> 16.000d
> 
> Queues listed in /sys/devices/vfio_ap/matrix/$UUID/guest_matrix
> 14.0005
> 14.0006
> 14.000d
> 
> The reason no queues for adapter 0x16 are listed in the guest_matrix is
> because queue 16.0005 is not bound to the vfio_ap device driver, so no
> queue associated with the adapter is passed through to the guest;
> therefore, each queue device for adapter 0x16 should display 'assigned'
> instead of 'in_use', because those queues are not in use by a guest, but
> only assigned to the mediated device.
> 
> Let's check the AP configuration for the guest to determine whether a
> queue device is passed through before displaying a status of 'in_use'.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Fixes: f139862b92cf ("s390/vfio-ap: add status attribute to AP queue device's sysfs dir")

Acked-by: Halil Pasic <pasic@linux.ibm.com>

I'm not sure if there is documentation. I assume there is
no additional documentation except for the code and the
commit messages on what those actually mean. So there
is no way to cross-check and no need to update it.

I personally don't feel like having clarity on these states. In
use does not actually mean that the guest is actually using
it: the guest can happily ignore the queue. The unassigned
is pretty clear. What "assigned" vs "in use" is supposed
to express, not so much to me.

I don't think this fix qualifies for the stable process,
but it has been a while since I've looked at the corresponding
process documentation.

> Cc: stable@vger.kernel.org

