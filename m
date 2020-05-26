Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D91E20AC
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 13:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbgEZLIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 07:08:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388712AbgEZLIL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 07:08:11 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QB1E9j017064;
        Tue, 26 May 2020 07:08:10 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 316wyrqwtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 07:08:10 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04QB1IG8017535;
        Tue, 26 May 2020 07:08:09 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 316wyrqwt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 07:08:09 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04QB62fh026238;
        Tue, 26 May 2020 11:08:09 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 316uf98n80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 11:08:09 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04QB88QL48693674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 11:08:08 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1685B2071;
        Tue, 26 May 2020 11:08:08 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33BB9B2064;
        Tue, 26 May 2020 11:08:08 +0000 (GMT)
Received: from [9.65.228.55] (unknown [9.65.228.55])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 May 2020 11:08:08 +0000 (GMT)
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200513142934.28788-1-farman@linux.ibm.com>
 <20200526115541.4a11accc.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <a52368d3-8cec-7b99-1587-25e055228b62@linux.ibm.com>
Date:   Tue, 26 May 2020 07:08:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200526115541.4a11accc.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-26_01:2020-05-26,2020-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=960
 impostorscore=0 phishscore=0 adultscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 bulkscore=0 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/26/20 5:55 AM, Cornelia Huck wrote:
> On Wed, 13 May 2020 16:29:30 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> There was some suggestion earlier about locking the FSM, but I'm not
>> seeing any problems with that. Rather, what I'm noticing is that the
>> flow between a synchronous START and asynchronous HALT/CLEAR have
>> different impacts on the FSM state. Consider:
>>
>>     CPU 1                           CPU 2
>>
>>     SSCH (set state=CP_PENDING)
>>     INTERRUPT (set state=IDLE)
>>     CSCH (no change in state)
>>                                     SSCH (set state=CP_PENDING)
>>     INTERRUPT (set state=IDLE)
>>                                     INTERRUPT (set state=IDLE)
> 
> A different question (not related to how we want to fix this): How
> easily can you trigger this bug? Is this during normal testing with a
> bit of I/O stress, or do you have a special test case?
> 

I have hit this with "normal testing with a bit of I/O stress" but it's
been maddeningly slow to repro (invariably when I'm not running with any
detailed traces enabled). So I expedite the process with the channel
path handling code, and this script running on the host:

while True:
    tempChpid = random.choice(chpids)
    tempFunction = random.choice(["-c", "-v"])

    doChzdev(tempFunction, "0", tempChpid)
    doSleep()

    doChzdev(tempFunction, "1", tempChpid)
    doSleep()

