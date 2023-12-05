Return-Path: <kvm+bounces-3471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCFE804BBB
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 09:04:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CE63281771
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 08:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB23D38DF4;
	Tue,  5 Dec 2023 08:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lRfNWdXG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF526127;
	Tue,  5 Dec 2023 00:04:32 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B582q8c024915;
	Tue, 5 Dec 2023 08:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=/aAESai4uDl4/7s45na8z6I4tJIt9dFN0EddPTE9jS8=;
 b=lRfNWdXG3nedK6jjI5linSKB/HEK9fYxuy2HsogQNs0GTQ0J0S23QhP3cp9aUxsI8POi
 RIFZQLp3UrnfuZcK237mb9qecDhPR3gyAmnRd2d+k+/IY9QnapZHsPUOoZsOmfIsHm2T
 BVgcDKw5YLJALD6zeJ44CI3aLv1fzOtPY/85Z23v4XLTZfSmE7jf2p3AYCow6b7eIX3/
 Kns+okcSwjlg54BK5xsIWIwyzoR/ywtb4+Dq2doVGG4fUfiIK55R6v0IOpZ2nMxFoLwL
 +n7iX4y9hzwXGQkYw45SAwxuA0+j2KLyrw19T+XphalpceID3v0U9Hq0yTG9keo1yvu2 MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ut00m01fe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Dec 2023 08:04:29 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B584TrX030361;
	Tue, 5 Dec 2023 08:04:29 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ut00m01ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Dec 2023 08:04:29 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B57YE5c009137;
	Tue, 5 Dec 2023 08:04:28 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3urgdkw8nn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Dec 2023 08:04:28 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B584OCh3932848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Dec 2023 08:04:25 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94E105803F;
	Tue,  5 Dec 2023 08:04:24 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2864B58061;
	Tue,  5 Dec 2023 08:04:24 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Dec 2023 08:04:24 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 05 Dec 2023 09:04:23 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Halil Pasic <pasic@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Tony Krowiak
 <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jjherne@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, Reinhard Buendgen
 <BUENDGEN@de.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20231204171506.42aa687f.pasic@linux.ibm.com>
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
 <b43414ef-7aa4-9e5c-a706-41861f0d346c@linux.ibm.com>
 <1f4720d7-93f1-4e38-a3ad-abaf99596e7c@linux.ibm.com>
 <05cfc382-d01d-4370-b8bb-d3805e957f2e@linux.ibm.com>
 <20231204171506.42aa687f.pasic@linux.ibm.com>
Message-ID: <d780a15a7c073e7d437f8120a72e8d29@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M3DHbSEQEfuZvzieLvJTu5EieaUC3_58
X-Proofpoint-ORIG-GUID: ZEg1yn10AEgYly7F7nAwdI3-FSYkzfvN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-05_03,2023-12-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1011 mlxlogscore=999 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312050064

On 2023-12-04 17:15, Halil Pasic wrote:
> On Mon, 4 Dec 2023 16:16:31 +0100
> Christian Borntraeger <borntraeger@linux.ibm.com> wrote:
> 
>> Am 04.12.23 um 15:53 schrieb Tony Krowiak:
>> >
>> >
>> > On 11/29/23 12:12, Christian Borntraeger wrote:
>> >> Am 29.11.23 um 15:35 schrieb Tony Krowiak:
>> >>> In the current implementation, response code 01 (AP queue number not valid)
>> >>> is handled as a default case along with other response codes returned from
>> >>> a queue reset operation that are not handled specifically. Barring a bug,
>> >>> response code 01 will occur only when a queue has been externally removed
>> >>> from the host's AP configuration; nn this case, the queue must
>> >>> be reset by the machine in order to avoid leaking crypto data if/when the
>> >>> queue is returned to the host's configuration. The response code 01 case
>> >>> will be handled specifically by logging a WARN message followed by cleaning
>> >>> up the IRQ resources.
>> >>>
>> >>
>> >> To me it looks like this can be triggered by the LPAR admin, correct? So it
>> >> is not desireable but possible.
>> >> In that case I prefer to not use WARN, maybe use dev_warn or dev_err instead.
>> >> WARN can be a disruptive event if panic_on_warn is set.
>> >
>> > Yes, it can be triggered by the LPAR admin. I can't use dev_warn here because we don't have a reference to any device, but I can use pr_warn if that suffices.
>> 
>> Ok, please use pr_warn then.
> 
> Shouldn't we rather make this an 'info'. I mean we probably do not want
> people complaining about this condition. Yes it should be a best 
> practice
> to coordinate such things with the guest, and ideally remove the 
> resource
> from the guest first. But AFAIU our stack is supposed to be able to
> handle something like this. IMHO issuing a warning is excessive 
> measure.
> I know Reinhard and Tony probably disagree with the last sentence
> though.

Halil, Tony, the thing about about info versus warning versus error is 
our
own stuff. Keep in mind that these messages end up in the "debug 
feature"
as FFDC data. So it comes to the point which FFDC data do you/Tony want 
to
see there ? It should be enough to explain to a customer what happened
without the need to "recreate with higher debug level" if something 
serious
happened. So my private decision table is:
1) is it something serious, something exceptional, something which may 
not
    come up again if tried to recreate ? Yes -> make it visible on the 
first
    occurrence as error msg.
2) is it something you want to read when a customer hits it and you tell 
him
    to extract and examine the debug feature data ? Yes -> make it a 
warning
    and make sure your debug feature by default records warnings.
3) still serious, but may flood the debug feature. Good enough and high
    probability to reappear on a recreate ? Yes -> make it an info 
message
    and live with the risk that you may not be able to explain to a 
customer
    what happened without a recreate and higher debug level.
4) not 1-3, -> maybe a debug msg but still think about what happens when 
a
    customer enables "debug feature" with highest level. Does it squeeze 
out
    more important stuff ? Maybe make it dynamic debug with pr_debug() 
(see
    kernel docu admin-guide/dynamic-debug-howto.rst).

> 
> Regards,
> Halil

