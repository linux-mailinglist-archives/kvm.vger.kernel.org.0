Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C143DF045
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 16:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbhHCO1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 10:27:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32478 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234328AbhHCO1h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 10:27:37 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173EQj0A044739;
        Tue, 3 Aug 2021 10:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f9HC1eXiOBEtngmOyC73D3WjGHKK7tuZ03fStO7djeM=;
 b=gkZFSYRChPioiiMxiWyW5NImaw8S/kTMuXRhkA1/e1p2/oxtxqMmZN5kAF5lAqj/e+1s
 VbziCqWmjLUm1Htr1AlY8x7DAnDLriSlNou8TnDhYIpDzI/iBHBsh+bBSjQiz0mgRN3F
 EjkJDsSBT0Jpd8q1S+B1eQXCBZJDrdLXBB4MEeO4ufj/R3W56oeE44wTtjVsG44olvcX
 6wC/KGiGqkMeNTG+5//sU3NBx26JAXzCFKHLIbr4twB42VTxjtgpcw9WDDBeG2tak26o
 UZGbCLNwIpycLqq+pi9kDXXOYejSLUBc/o1bGzWX74deWZ7PnfnBmgd4A2mzG9cCceHe nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7341sh5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 10:27:18 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 173EQlWc044937;
        Tue, 3 Aug 2021 10:27:17 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7341sh34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 10:27:17 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 173EDxvP000789;
        Tue, 3 Aug 2021 14:27:14 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3a4wshxh5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 14:27:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 173ERAOu29098332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 14:27:10 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73CA152051;
        Tue,  3 Aug 2021 14:27:10 +0000 (GMT)
Received: from oc6887364776.ibm.com (unknown [9.145.164.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D07BB52057;
        Tue,  3 Aug 2021 14:27:09 +0000 (GMT)
Subject: Re: s390 common I/O layer locking
To:     Christoph Hellwig <hch@lst.de>, Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428190949.4360afb7.cohuck@redhat.com>
 <20210428172008.GV1370958@nvidia.com>
 <20210429135855.443b7a1b.cohuck@redhat.com>
 <20210429181347.GA3414759@nvidia.com>
 <20210430143140.378904bf.cohuck@redhat.com>
 <20210430171908.GD1370958@nvidia.com>
 <20210503125440.0acd7c1f.cohuck@redhat.com>
 <292442e8-3b1a-56c4-b974-05e8b358ba64@linux.ibm.com>
 <20210724132400.GA19006@lst.de>
From:   Vineeth Vijayan <vneethv@linux.ibm.com>
Message-ID: <7d751173-09b2-f49e-13ac-a72129f36f74@linux.ibm.com>
Date:   Tue, 3 Aug 2021 16:27:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210724132400.GA19006@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k7jBW8jVtIOfO3ItdW1paqp1qcdMK2DP
X-Proofpoint-GUID: u5s3cC-qmHn_37YAEbGxJ4ZQVbDt9kAP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_03:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=929
 malwarescore=0 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/24/21 3:24 PM, Christoph Hellwig wrote:
> On Tue, May 04, 2021 at 05:10:42PM +0200, Vineeth Vijayan wrote:
...snip...
>> I just had a quick glance on the CIO layer drivers. And at first 
>> look, you
>> are right.
>> It looks likewe need modifications in the event callbacks (referring css
>> here)
>> Let me go thoughthis thoroughly and update.
> Did this go anywhere?
Hello Christoph,

Thank you for this reminder. Also, my apologies for the slow reply; This 
was one of those item which really needed this reminder :-)

Coming to the point, The event-callbacks  are under sch->lock, which i 
think is the right thing to do. But i also agree on your feedback about 
the sch->driver accesses in the css_evaluate_known_subchannel() call. My 
first impression was to add them under device_lock(). As Conny 
mentioned, most of the drivers on the css-bus remained-stable during the 
lifetime of the devices, and we never got this racy scenario.  And then 
having this change with device_lock(), as you mentioned,this code-base 
would need significant change in the sch_event callbacks. I am not sure 
if there is a straight forward solution for this locking-issue scenario.

Currently, i am trying to see the "minimal" change i can work on on the 
event-callbacks and the css_evaluate_known_subchannel() call, to make 
sure that, this racy condition can never occur.

Conny,

Please do let me know if you think i am missing something here. I would 
like to concentrate more on the sch->driver() access scenario first and 
would like to see how it can have minimal impact on the event-callbacks. 
especially io_subchannel_sch_event.


Vineeth
