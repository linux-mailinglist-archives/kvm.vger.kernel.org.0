Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB7A2A7E69
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 13:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgKEMQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 07:16:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34584 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725468AbgKEMQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 07:16:53 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A5C3nqZ128626;
        Thu, 5 Nov 2020 07:16:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j/XiNhQqrbOzw16s61pwytFbocUKkLlhdpIcNVtIZXM=;
 b=TnAjs5w2hI07O28rLHdia4Yv6Jxv6YM4jdzbVOmM7PhbpXlpF36rDdUTgcwvZZNHTtQ6
 1godHPoiobGisYEwI6G8aksDPaE+lmU1qbn+oGlHoSUGigyHOMRVOmDpURfO4ubGa9Y4
 cUhsmfR5SjnXwbnCasD9TIo9wzsqxuttOtmhIf6JHmzuNupoMzRqiludq3C1qEK362Ci
 0VB7I2Fl+5ProiRujU8ErrAUc8qM6MenlM0h7YXwhVyDRYChBg7Jp2mmwxgxizPow6WF
 28hYHiplA0ZupLjTWxUF5yRoCJLEMFIxTJMckyMEPz9fU1VNuRZCSs9x3jQ0k0qSYgIA 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34m5dbkm57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 07:16:51 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A5C3oJ1128739;
        Thu, 5 Nov 2020 07:16:51 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34m5dbkm4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 07:16:51 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A5CCGT7012751;
        Thu, 5 Nov 2020 12:16:49 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 34h01qtrvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 12:16:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A5CGkfG39453098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Nov 2020 12:16:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9D7A11C050;
        Thu,  5 Nov 2020 12:16:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E67911C04C;
        Thu,  5 Nov 2020 12:16:46 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.191.28])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Nov 2020 12:16:46 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] memory: allocation in low memory
To:     Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
 <1601303017-8176-2-git-send-email-pmorel@linux.ibm.com>
 <20200928173147.750e7358.cohuck@redhat.com>
 <136e1860-ddbc-edc0-7e67-fdbd8112a01e@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <f2ff3ddd-c70e-b2cc-b58f-bbcb1e4684d6@linux.ibm.com>
Date:   Thu, 5 Nov 2020 13:16:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <136e1860-ddbc-edc0-7e67-fdbd8112a01e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_07:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=932
 clxscore=1011 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/29/20 9:19 AM, Janosch Frank wrote:
> On 9/28/20 5:31 PM, Cornelia Huck wrote:
>> On Mon, 28 Sep 2020 16:23:34 +0200
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> Some architectures need allocations to be done under a
>>> specific address limit to allow DMA from I/O.
>>>
>>> We propose here a very simple page allocator to get
>>> pages allocated under this specific limit.
>>>
>>> The DMA page allocator will only use part of the available memory
>>> under the DMA address limit to let room for the standard allocator.
>>>

...snip...

> 
> Before we start any other discussion on this patch we should clear up if
> this is still necessary after Claudio's alloc revamp.
> 
> I think he added options to request special types of memory.

Isn't it possible to go on with this patch series.
It can be adapted later to the changes that will be introduced by 
Claudio when it is final.


-- 
Pierre Morel
IBM Lab Boeblingen
