Return-Path: <kvm+bounces-3734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 015E180765B
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:17:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 774881F20F50
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD5B65EC8;
	Wed,  6 Dec 2023 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h8+jvW9f"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BDBD3;
	Wed,  6 Dec 2023 09:17:38 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B6Gobej005795;
	Wed, 6 Dec 2023 17:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TuD823XscZsfxPwMTeL+xSPd2hR3A8VvEP1hgp+thd4=;
 b=h8+jvW9f48LtM2Gj6lRnIT775QRpHYk0V+JeE1s6Cn4WPAdKWARNLcjPfLbDNF0Xzz3E
 VMJGe4s/XNfi10l5JSIDOldz72qEBcIfZeaXrHu/iBVEiX25rHXct54SWgF1SFR/ZI6N
 nMxUqx37ySBTVRH6NNcY1+V4o7vcnhHqzQU1NUnYJ0jKONclTARy8ljKZlz+e9Oz2vaf
 1h9WVQjVtKPoiHEVNmwnYIElON0gSwJcIGb7yVmNHHjQ8t2SajD0RcrbCWMs8Nvcd4Tf
 OTmrNi1JbiKQSSI//PissqA4x+S5XW/gyE5Qamy/ewS9UaqQ4Yh2la7jYJhQGnNJebl9 sg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3utv6r1umw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Dec 2023 17:17:36 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B6HBZuP018160;
	Wed, 6 Dec 2023 17:17:35 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3utv6r1uma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Dec 2023 17:17:35 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B6G7guN027096;
	Wed, 6 Dec 2023 17:17:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3utav2wtxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Dec 2023 17:17:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B6HHTm79896632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 Dec 2023 17:17:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5781120043;
	Wed,  6 Dec 2023 17:17:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1E7A20040;
	Wed,  6 Dec 2023 17:17:28 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.155.209.75])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  6 Dec 2023 17:17:28 +0000 (GMT)
Date: Wed, 6 Dec 2023 18:17:27 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Tony Krowiak
 <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jjherne@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, Reinhard Buendgen
 <BUENDGEN@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Message-ID: <20231206181727.376c3d67.pasic@linux.ibm.com>
In-Reply-To: <d780a15a7c073e7d437f8120a72e8d29@linux.ibm.com>
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
	<b43414ef-7aa4-9e5c-a706-41861f0d346c@linux.ibm.com>
	<1f4720d7-93f1-4e38-a3ad-abaf99596e7c@linux.ibm.com>
	<05cfc382-d01d-4370-b8bb-d3805e957f2e@linux.ibm.com>
	<20231204171506.42aa687f.pasic@linux.ibm.com>
	<d780a15a7c073e7d437f8120a72e8d29@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: yXcsIFIvJEknM7sR-QqjBu7T3tpcRrZK
X-Proofpoint-GUID: usnzt_QVGwn7s8AFfRzXlXJotrMoU-sF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_15,2023-12-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312060140

On Tue, 05 Dec 2023 09:04:23 +0100
Harald Freudenberger <freude@linux.ibm.com> wrote:

> On 2023-12-04 17:15, Halil Pasic wrote:
> > On Mon, 4 Dec 2023 16:16:31 +0100
> > Christian Borntraeger <borntraeger@linux.ibm.com> wrote:
> >   
> >> Am 04.12.23 um 15:53 schrieb Tony Krowiak:  
> >> >
> >> >
> >> > On 11/29/23 12:12, Christian Borntraeger wrote:  
> >> >> Am 29.11.23 um 15:35 schrieb Tony Krowiak:  
> >> >>> In the current implementation, response code 01 (AP queue number not valid)
> >> >>> is handled as a default case along with other response codes returned from
> >> >>> a queue reset operation that are not handled specifically. Barring a bug,
> >> >>> response code 01 will occur only when a queue has been externally removed
> >> >>> from the host's AP configuration; nn this case, the queue must
> >> >>> be reset by the machine in order to avoid leaking crypto data if/when the
> >> >>> queue is returned to the host's configuration. The response code 01 case
> >> >>> will be handled specifically by logging a WARN message followed by cleaning
> >> >>> up the IRQ resources.
> >> >>>  
> >> >>
> >> >> To me it looks like this can be triggered by the LPAR admin, correct? So it
> >> >> is not desireable but possible.
> >> >> In that case I prefer to not use WARN, maybe use dev_warn or dev_err instead.
> >> >> WARN can be a disruptive event if panic_on_warn is set.  
> >> >
> >> > Yes, it can be triggered by the LPAR admin. I can't use dev_warn here because we don't have a reference to any device, but I can use pr_warn if that suffices.  
> >> 
> >> Ok, please use pr_warn then.  
> > 
> > Shouldn't we rather make this an 'info'. I mean we probably do not want
> > people complaining about this condition. Yes it should be a best 
> > practice
> > to coordinate such things with the guest, and ideally remove the 
> > resource
> > from the guest first. But AFAIU our stack is supposed to be able to
> > handle something like this. IMHO issuing a warning is excessive 
> > measure.
> > I know Reinhard and Tony probably disagree with the last sentence
> > though.  
> 
> Halil, Tony, the thing about about info versus warning versus error is 
> our
> own stuff. Keep in mind that these messages end up in the "debug 
> feature"
> as FFDC data. So it comes to the point which FFDC data do you/Tony want 
> to
> see there ? It should be enough to explain to a customer what happened
> without the need to "recreate with higher debug level" if something 
> serious
> happened. So my private decision table is:
> 1) is it something serious, something exceptional, something which may 
> not
>     come up again if tried to recreate ? Yes -> make it visible on the 
> first
>     occurrence as error msg.
> 2) is it something you want to read when a customer hits it and you tell 
> him
>     to extract and examine the debug feature data ? Yes -> make it a 
> warning
>     and make sure your debug feature by default records warnings.
> 3) still serious, but may flood the debug feature. Good enough and high
>     probability to reappear on a recreate ? Yes -> make it an info 
> message
>     and live with the risk that you may not be able to explain to a 
> customer
>     what happened without a recreate and higher debug level.
> 4) not 1-3, -> maybe a debug msg but still think about what happens when 
> a
>     customer enables "debug feature" with highest level. Does it squeeze 
> out
>     more important stuff ? Maybe make it dynamic debug with pr_debug() 
> (see
>     kernel docu admin-guide/dynamic-debug-howto.rst).

AFAIU the default log level of the S390 Debug Feature is 3 that is
error. So warnings do not help us there by default. And if we are 
already asking the reporter to crank up the loglevel of the debug
feature, we can as the reporter to crank it up to 5, assumed there
is not too much stuff that log level 5 in that area... How much
info stuff do we have for the 'ap' debug facility (I hope
that is the facility used by vfio_ap)? 

I think log levels are supposed to be primarily about severity, and
and I'm not sure that a queue becoming unavailable in G1 without
fist re-configuring the G2 so that it no more has access to the
given queue is not really a warning severity thing. IMHO if we
really do want people complaining about this should they ever see it,
yes it should be a warning. If not then probably not.

Regards,
Halil

