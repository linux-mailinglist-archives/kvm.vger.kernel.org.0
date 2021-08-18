Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9493EFEA9
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 10:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239649AbhHRIHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 04:07:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238384AbhHRIHO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 04:07:14 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I83LWN060729;
        Wed, 18 Aug 2021 04:06:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FcCMSq8pf3W5Iqg4XsxKSFffs2r5dDoQXwS4CTXM598=;
 b=jYw7n/Wyri/ttkgJvCXmKX48pk7g8xqfMHCKXpD3Wk/W2wkgBzpOnptaij3TJhDL869T
 VirSHYvdw/tW805m9Cpfvalm2o7QA0D4GcthEV8cdhWHB3owrGd2cZadQCkjWNoQ8Xqj
 M/TBT/uFQwwPTYKb3pxWCTQrRzzw66zpnDEpOPBzA/EXfkeTvKRH+AuEnMG4whZvAxA4
 AoUEEGrWTyQLG/WhmBisIgI+fEfyWYzKXxZKvjGqUPWkkT/s1uO0vkGYy071R6o0UlhU
 cJrdkc14oL31YNqwmqxQyJFTYIEenT198Bb36/QxA7wI+sl6noMEHlnfzza9O+X7ehxX gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcvrw875-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 04:06:39 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17I83fNG061868;
        Wed, 18 Aug 2021 04:06:39 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcvrw86a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 04:06:39 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17I7rJce002528;
        Wed, 18 Aug 2021 08:06:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8e5vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 08:06:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17I832Fg26411516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 08:03:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62DEBA4054;
        Wed, 18 Aug 2021 08:06:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC9C4A4067;
        Wed, 18 Aug 2021 08:06:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.174.181])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 08:06:31 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: s390: gaccess: Cleanup access to guest frames
To:     David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        kvm@vger.kernel.org, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210816150718.3063877-1-scgl@linux.ibm.com>
 <20210816150718.3063877-2-scgl@linux.ibm.com>
 <d11128bb-18f6-5210-6f42-74a89d8edcf7@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <584ca757-4eb4-491e-a4cd-7bc60fb04b61@linux.ibm.com>
Date:   Wed, 18 Aug 2021 10:06:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d11128bb-18f6-5210-6f42-74a89d8edcf7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Hv3ckAHdGy3Z7Y40Q2ixDUvM2cijvzE5
X-Proofpoint-GUID: Xxns9i2yQbfQJz6qvJyXk6eOpY9nKto4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_02:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 9:54 AM, David Hildenbrand wrote:
> On 16.08.21 17:07, Janis Schoetterl-Glausch wrote:
>> Introduce a helper function for guest frame access.
>> Rewrite the calculation of the gpa and the length of the segment
>> to be more readable.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
[...]
>> -	unsigned long _len, gpa;
>> +	unsigned long gpa;
>> +	unsigned int seg;
>>   	int rc = 0;
>>   
>>   	while (len && !rc) {
>>   		gpa = kvm_s390_real_to_abs(vcpu, gra);
>> -		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
>> -		if (mode)
>> -			rc = write_guest_abs(vcpu, gpa, data, _len);
>> -		else
>> -			rc = read_guest_abs(vcpu, gpa, data, _len);
>> -		len -= _len;
>> -		gra += _len;
>> -		data += _len;
>> +		seg = min(PAGE_SIZE - offset_in_page(gpa), len);
> 
> What does "seg" mean? I certainly know when "len" means -- which is also 
> what the function eats.

What does "_len" mean especially in contrast to "len"?

"seg" is used in the common kvm guest access functions so it's at least
consistent although I share the sentiment that it's not a great name for
the length we access inside the page.

Originally I suggested "len_in_page" if you have a better name I'd
expect we'll both be happy to discuss it :-)

> 
>> +		rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
>> +		len -= seg;
>> +		gra += seg;
>> +		data += seg;
>>   	}
>>   	return rc;
>>   }
>>
> 
> 

