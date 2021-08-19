Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678DB3F1AF5
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbhHSNyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 09:54:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240102AbhHSNyL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 09:54:11 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JDWi8t130316;
        Thu, 19 Aug 2021 09:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8/gIhEIih/qeNkjBexZHFtQNoYIGlGTHsE4rgo5m9C4=;
 b=hLibBBSzdqJiGKGO2nd13KIsy76vdbZCTQ+DuwvXvIFicndEyLDwwWwRsHyEgR75fFDt
 7g+jwcLvs9vD/a2kcvouXqnxHe4VRXZMnD5Pw8ReRaAKbo31uHoUmkpc8YZsnQJ62DSj
 Pw4LDtjrtdZRdMn9ltqWv2DEWoMJFTlczqUk3j2mPqfn1NiaxAEk3Cauvrd7j4B/OnkF
 h0lNhGq/aFo1COA8oBcWzBFGeT5g9UPsM0TA72Cl5qT8z4+AD4yWlzvwb1YqzOk3RD+f
 IkuWfs3X9YCAXnHJOwr+YH1tQRnuoECR+MCVdLJlR5oZS9zOwLt1WgsBOhVA7uEi/xnb 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agkvnreuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 09:53:35 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17JDWqwP130841;
        Thu, 19 Aug 2021 09:53:34 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agkvnrets-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 09:53:34 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17JDrWNh000366;
        Thu, 19 Aug 2021 13:53:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ae53j0cu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 13:53:32 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17JDnxQ957278870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 13:49:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AE804204D;
        Thu, 19 Aug 2021 13:53:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 106714203F;
        Thu, 19 Aug 2021 13:53:28 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.33.59])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 Aug 2021 13:53:27 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: s390: gaccess: Cleanup access to guest frames
To:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        kvm@vger.kernel.org, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210816150718.3063877-1-scgl@linux.ibm.com>
 <20210816150718.3063877-2-scgl@linux.ibm.com>
 <d11128bb-18f6-5210-6f42-74a89d8edcf7@redhat.com>
 <584ca757-4eb4-491e-a4cd-7bc60fb04b61@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <745fb5fc-175b-5920-5c56-db4ca8bc2488@linux.vnet.ibm.com>
Date:   Thu, 19 Aug 2021 15:53:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <584ca757-4eb4-491e-a4cd-7bc60fb04b61@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JO-ys9WQ9C_0KGIWb19sObABLJNsxzEl
X-Proofpoint-GUID: 4SXjLW5qvPKAUCJHqEvkASZcOROVDWhg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-19_04:2021-08-17,2021-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 10:06 AM, Janosch Frank wrote:
> On 8/18/21 9:54 AM, David Hildenbrand wrote:
>> On 16.08.21 17:07, Janis Schoetterl-Glausch wrote:
>>> Introduce a helper function for guest frame access.
>>> Rewrite the calculation of the gpa and the length of the segment
>>> to be more readable.
>>>
>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> [...]
>>> -	unsigned long _len, gpa;
>>> +	unsigned long gpa;
>>> +	unsigned int seg;
>>>   	int rc = 0;
>>>   
>>>   	while (len && !rc) {
>>>   		gpa = kvm_s390_real_to_abs(vcpu, gra);
>>> -		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
>>> -		if (mode)
>>> -			rc = write_guest_abs(vcpu, gpa, data, _len);
>>> -		else
>>> -			rc = read_guest_abs(vcpu, gpa, data, _len);
>>> -		len -= _len;
>>> -		gra += _len;
>>> -		data += _len;
>>> +		seg = min(PAGE_SIZE - offset_in_page(gpa), len);
>>
>> What does "seg" mean? I certainly know when "len" means -- which is also 
>> what the function eats.
> 
> What does "_len" mean especially in contrast to "len"?
> 
> "seg" is used in the common kvm guest access functions so it's at least
> consistent although I share the sentiment that it's not a great name for
> the length we access inside the page.
> 
> Originally I suggested "len_in_page" if you have a better name I'd
> expect we'll both be happy to discuss it :-)

fragment_len ? 
> 
>>
>>> +		rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
>>> +		len -= seg;
>>> +		gra += seg;
>>> +		data += seg;
>>>   	}
>>>   	return rc;
>>>   }
>>>
>>
>>
> 

