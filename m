Return-Path: <kvm+bounces-3385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 940018039E2
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 17:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C66321C20B0F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A09F2D784;
	Mon,  4 Dec 2023 16:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E+xcD4+H"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EAFFD;
	Mon,  4 Dec 2023 08:15:18 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4G8IYW002645;
	Mon, 4 Dec 2023 16:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gIhamb+YTQS7+bRTda0XXQ3oydAJZG5OiZDJQU0Lp7k=;
 b=E+xcD4+HetHsxNPubUZE0D5xL7YsCnYF8fqqpl7ihyo+du5H0p4nG9JPYRuAB2C+FQZf
 H95Pc4JfAE6+PNwccpBnTY9OCGl/QmuG8JI1ERPdlm429S/lf9z2MSzuaRXOqwkeXtQZ
 f6c7Madj8hlj/Bk5R35KrgBUJZI82NbxGodBFxQyl9MmEPC0eFUiTvptR2s3TdioFGr2
 MMVBYn8r0UnyOCzxEqE1iM7lEbqFF54gYoLFHgpIRsLPSUBDafRsP/owx9dD0VE3hrHJ
 wIqSaAAxU0EUKK4/Pry1K6nnoExf26/tWq+QIHfRKpwSQ05wzfCWA3je0ah1yLIJmJyu 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usj19ga9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 16:15:16 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B4G8iDi003783;
	Mon, 4 Dec 2023 16:15:15 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usj19ga85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 16:15:15 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4EJYUb031969;
	Mon, 4 Dec 2023 16:15:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3urh4k8tb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 16:15:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B4GF97218350808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Dec 2023 16:15:09 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E63E20040;
	Mon,  4 Dec 2023 16:15:09 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 93DE520043;
	Mon,  4 Dec 2023 16:15:08 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.42.250])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  4 Dec 2023 16:15:08 +0000 (GMT)
Date: Mon, 4 Dec 2023 17:15:06 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jjherne@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, Halil Pasic
 <pasic@linux.ibm.com>,
        Reinhard Buendgen <BUENDGEN@de.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Message-ID: <20231204171506.42aa687f.pasic@linux.ibm.com>
In-Reply-To: <05cfc382-d01d-4370-b8bb-d3805e957f2e@linux.ibm.com>
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
	<b43414ef-7aa4-9e5c-a706-41861f0d346c@linux.ibm.com>
	<1f4720d7-93f1-4e38-a3ad-abaf99596e7c@linux.ibm.com>
	<05cfc382-d01d-4370-b8bb-d3805e957f2e@linux.ibm.com>
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
X-Proofpoint-GUID: xAz2SV2zrP2AZsKkNEJOoTfdsI4OnB3d
X-Proofpoint-ORIG-GUID: rqJwcRd2Q9_vHLqIb00RNjAe9i4GewGO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_15,2023-12-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312040123

On Mon, 4 Dec 2023 16:16:31 +0100
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> Am 04.12.23 um 15:53 schrieb Tony Krowiak:
> > 
> > 
> > On 11/29/23 12:12, Christian Borntraeger wrote:  
> >> Am 29.11.23 um 15:35 schrieb Tony Krowiak:  
> >>> In the current implementation, response code 01 (AP queue number not valid)
> >>> is handled as a default case along with other response codes returned from
> >>> a queue reset operation that are not handled specifically. Barring a bug,
> >>> response code 01 will occur only when a queue has been externally removed
> >>> from the host's AP configuration; nn this case, the queue must
> >>> be reset by the machine in order to avoid leaking crypto data if/when the
> >>> queue is returned to the host's configuration. The response code 01 case
> >>> will be handled specifically by logging a WARN message followed by cleaning
> >>> up the IRQ resources.
> >>>  
> >>
> >> To me it looks like this can be triggered by the LPAR admin, correct? So it
> >> is not desireable but possible.
> >> In that case I prefer to not use WARN, maybe use dev_warn or dev_err instead.
> >> WARN can be a disruptive event if panic_on_warn is set.  
> > 
> > Yes, it can be triggered by the LPAR admin. I can't use dev_warn here because we don't have a reference to any device, but I can use pr_warn if that suffices.  
> 
> Ok, please use pr_warn then.

Shouldn't we rather make this an 'info'. I mean we probably do not want
people complaining about this condition. Yes it should be a best practice
to coordinate such things with the guest, and ideally remove the resource
from the guest first. But AFAIU our stack is supposed to be able to
handle something like this. IMHO issuing a warning is excessive measure.
I know Reinhard and Tony probably disagree with the last sentence
though. 

Regards,
Halil

