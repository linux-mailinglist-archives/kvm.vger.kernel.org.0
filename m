Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0121A00A4
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 00:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgDFWLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 18:11:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726084AbgDFWLi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 18:11:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 036M4cZF001477;
        Mon, 6 Apr 2020 18:11:37 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3082g43q7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Apr 2020 18:11:37 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 036M4iT6002339;
        Mon, 6 Apr 2020 18:11:36 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3082g43q78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Apr 2020 18:11:36 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 036MBC94027972;
        Mon, 6 Apr 2020 22:11:36 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 306hv608eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Apr 2020 22:11:36 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 036MBZmv52625758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Apr 2020 22:11:35 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41D0B12458B;
        Mon,  6 Apr 2020 22:11:35 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8E0F12458A;
        Mon,  6 Apr 2020 22:11:34 +0000 (GMT)
Received: from [9.160.96.56] (unknown [9.160.96.56])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Apr 2020 22:11:34 +0000 (GMT)
Subject: Re: [RFC PATCH v2 7/9] vfio-ccw: Wire up the CRW irq and CRW region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200206213825.11444-1-farman@linux.ibm.com>
 <20200206213825.11444-8-farman@linux.ibm.com>
 <20200406155255.3c8f06e5.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <66655d37-b9d1-593f-fd81-339b422bb372@linux.ibm.com>
Date:   Mon, 6 Apr 2020 18:11:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200406155255.3c8f06e5.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-06_10:2020-04-06,2020-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=827 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004060162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/6/20 9:52 AM, Cornelia Huck wrote:
> On Thu,  6 Feb 2020 22:38:23 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> From: Farhan Ali <alifm@linux.ibm.com>
>>
>> Use an IRQ to notify userspace that there is a CRW
>> pending in the region, related to path-availability
>> changes on the passthrough subchannel.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>
>> Notes:
>>     v1->v2:
>>      - Remove extraneous 0x0 in crw.rsid assignment [CH]
>>      - Refactor the building/queueing of a crw into its own routine [EF]
>>     
>>     v0->v1: [EF]
>>      - Place the non-refactoring changes from the previous patch here
>>      - Clean up checkpatch (whitespace) errors
>>      - s/chp_crw/crw/
>>      - Move acquire/release of io_mutex in vfio_ccw_crw_region_read()
>>        into patch that introduces that region
>>      - Remove duplicate include from vfio_ccw_drv.c
>>      - Reorder include in vfio_ccw_private.h
>>
>>  drivers/s390/cio/vfio_ccw_chp.c     |  5 ++
>>  drivers/s390/cio/vfio_ccw_drv.c     | 73 +++++++++++++++++++++++++++++
>>  drivers/s390/cio/vfio_ccw_ops.c     |  4 ++
>>  drivers/s390/cio/vfio_ccw_private.h |  9 ++++
>>  include/uapi/linux/vfio.h           |  1 +
>>  5 files changed, 92 insertions(+)
> 
> [I may have gotten all muddled up from staring at this, but please bear
> with me...]
> 
...snip...
> 
> Aren't we missing copying in a new queued crw after userspace had done
> a read?
> 

Um, huh.  I'll doublecheck that after dinner, but it sure looks like
you're right.

(Might not get back to you tomorrow, because I don't have much time
until Wednesday.)
