Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5345C4481B3
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 15:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239493AbhKHO3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 09:29:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239426AbhKHO3v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 09:29:51 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CpDMC005635;
        Mon, 8 Nov 2021 14:27:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bDbtg5qQphznl45uaMMX50x80y7pk9gZCNnsS0BP8D0=;
 b=H6ITCy3iZdWvTzSQ2Cjkt3NZSnj63TlaGPk6pPEJGdTnvKG6MFp08MFO0xIp17Oq+7Hn
 AdT0O4EPRBYvGWri3JWXgKgnIVMQsVqMejiMfnEaLYlVKAShRmJHs8rsXuvoLdPN4/bO
 K0A6O6mVo36YCxl5LVTrfv6/iDD11S/91JC4aP+jXE0+Y+R0gWyYe+iw8OyHLGPHstop
 DGjaMJ7r2QJh0Q81Mb1GOA2VlrUpFjs/KlfJDbdCnGTivrSmXNFmjujT+lOCFwKlzYfo
 o+OrNopfqboAXm3VaomgrzAhPvkVVUOYQOQaNrpziAwnKnTWNmQZ+fgP3kyKtInjrZ9m PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6a94ev56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 14:27:05 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8ER4uI007506;
        Mon, 8 Nov 2021 14:27:04 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6a94ev4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 14:27:04 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8EOpem002557;
        Mon, 8 Nov 2021 14:27:03 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 3c5hbadc7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 14:27:03 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8ER1I720644246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 14:27:01 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67897C605A;
        Mon,  8 Nov 2021 14:27:01 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2417C605F;
        Mon,  8 Nov 2021 14:26:58 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.160.167.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 14:26:58 +0000 (GMT)
Subject: Re: [PATCH v17 14/15] s390/ap: notify drivers on config changed and
 scan complete callbacks
To:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-15-akrowiak@linux.ibm.com>
 <11b72236-34fe-4d65-0da1-033050c75a87@linux.ibm.com>
 <77a4b43b-940e-0321-9ebf-3249a8d8513a@linux.ibm.com>
 <bb676730-a1b1-3bbe-116e-7d20ab6e8a58@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <4684a228-3f40-12a1-deb8-eb669533854b@linux.ibm.com>
Date:   Mon, 8 Nov 2021 09:26:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bb676730-a1b1-3bbe-116e-7d20ab6e8a58@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -H4zgK0pXeBh2RMElAvS5x4Tl497_z_n
X-Proofpoint-GUID: j0ZbuKnMxqRVA0ko-0D3XrLlsk85hNiX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_05,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/5/21 4:23 AM, Harald Freudenberger wrote:
> On 04.11.21 16:50, Tony Krowiak wrote:
>>
>> On 11/4/21 8:06 AM, Harald Freudenberger wrote:
>>> Tony as this is v17, if you may do jet another loop, I would pick the ap parts of your patch series and
>>> apply them to the devel branch as separate patches.
>> Are you suggesting I do this now, or when this is finally ready to go upstream?
>>
>>
> I am suggesting picking all the ap related stuff into one patch and commit it to the devel branch now (well in the next days).
> So the ap stuff is then prepared for your patches and it gives your patch series some relief.

Will do.


