Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D2A2FA3D2
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 15:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390451AbhARO5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 09:57:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405469AbhARO5L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 09:57:11 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10IEeXFR181185;
        Mon, 18 Jan 2021 09:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0TptsGujPPFUQtawRCR+ftr/f7g91K6pA4rw9cTmBjg=;
 b=lpcostEW6PJ+pulmeubfNRlqFSd6PUbNwSo/h3mK3UdzbD5+s02TKyF7Ahx5lipQwp4s
 DemSoIaw6WCi37BjirYFT4gepxx63gzUrTKnmicjmULl4lcokvUPPLVrLsmZW0psaCdF
 MQc/skPmVoWcUQtnTUZpwJQP/G9tYpBPDge3PWZkfDkyuKoPlI19o2A6d4nzsktRfSh+
 Jt2Tny7QRsKW79WxY/5N6cvi6HkgBVuJs007BBZ5Bn0tJa3beaqIOqPn6hfjm9OWELkj
 oRbPAxTneH9gd3UeIZsifxHnsTEtswwng4xL2sHgr3Wk/uBvMSR3miXAGpvZPWmPFLIe vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365ca0rcv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 09:56:30 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10IEq9Q6029636;
        Mon, 18 Jan 2021 09:56:30 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365ca0rcu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 09:56:29 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10IEradA019508;
        Mon, 18 Jan 2021 14:56:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 363qs893us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 14:56:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10IEuIwT30409178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 14:56:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4112452052;
        Mon, 18 Jan 2021 14:56:24 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.162.213])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D818B5204F;
        Mon, 18 Jan 2021 14:56:23 +0000 (GMT)
Subject: Re: [PATCH 1/1] KVM: s390: diag9c forwarding
To:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
References: <20210118131739.7272-1-borntraeger@de.ibm.com>
 <20210118131739.7272-2-borntraeger@de.ibm.com>
 <db1d2a6e-1947-321b-bdc2-019eee5780f4@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <e6622462-cbdc-2aee-6e51-4a382b73808a@linux.ibm.com>
Date:   Mon, 18 Jan 2021 15:56:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <db1d2a6e-1947-321b-bdc2-019eee5780f4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_11:2021-01-18,2021-01-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 spamscore=0 clxscore=1011 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101180085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/18/21 2:45 PM, Janosch Frank wrote:
> On 1/18/21 2:17 PM, Christian Borntraeger wrote:
>> From: Pierre Morel <pmorel@linux.ibm.com>
>>
>> When we receive intercept a DIAG_9C from the guest we verify
>> that the target real CPU associated with the virtual CPU
>> designated by the guest is running and if not we forward the
>> DIAG_9C to the target real CPU.
>>
>> To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.
>>
>> The rate is calculated as a count per second defined as a
>> new parameter of the s390 kvm module: diag9c_forwarding_hz .
>>
>> The default value is to not forward diag9c.
> 
> Before Conny starts yelling I'll do it myself:
> Documentation

yes, it comes soon.


-- 
Pierre Morel
IBM Lab Boeblingen
