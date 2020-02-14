Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D106215E45B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 17:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393649AbgBNQfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 11:35:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405960AbgBNQYn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 11:24:43 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EGNYLI018992;
        Fri, 14 Feb 2020 11:24:42 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j87xwa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 11:24:42 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EGNbjH019260;
        Fri, 14 Feb 2020 11:24:42 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j87xw9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 11:24:42 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EGMISb012454;
        Fri, 14 Feb 2020 16:24:40 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 2y5bbyqqtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 16:24:40 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EGOeLA51773768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 16:24:40 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51897B2065;
        Fri, 14 Feb 2020 16:24:40 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0489B2064;
        Fri, 14 Feb 2020 16:24:39 +0000 (GMT)
Received: from [9.160.20.216] (unknown [9.160.20.216])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 16:24:39 +0000 (GMT)
Subject: Re: [RFC PATCH v2 7/9] vfio-ccw: Wire up the CRW irq and CRW region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200206213825.11444-1-farman@linux.ibm.com>
 <20200206213825.11444-8-farman@linux.ibm.com>
 <20200214143400.175c9e5e.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <75bb9119-8692-c18e-1e7b-c7598d8ef25a@linux.ibm.com>
Date:   Fri, 14 Feb 2020 11:24:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214143400.175c9e5e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_05:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 spamscore=0 mlxlogscore=837 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/14/20 8:34 AM, Cornelia Huck wrote:
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
>>
> (...)
>> +static void vfio_ccw_alloc_crw(struct vfio_ccw_private *private,
>> +			       struct chp_link *link,
>> +			       unsigned int erc)
>> +{
>> +	struct vfio_ccw_crw *vc_crw;
>> +	struct crw *crw;
>> +
>> +	/*
>> +	 * If unable to allocate a CRW, just drop the event and
>> +	 * carry on.  The guest will either see a later one or
>> +	 * learn when it issues its own store subchannel.
>> +	 */
>> +	vc_crw = kzalloc(sizeof(*vc_crw), GFP_ATOMIC);
>> +	if (!vc_crw)
>> +		return;
>> +
>> +	/*
>> +	 * Build in the first CRW space, but don't chain anything
>> +	 * into the second one even though the space exists.
>> +	 */
>> +	crw = &vc_crw->crw[0];
>> +
>> +	/*
>> +	 * Presume every CRW we handle is reported by a channel-path.
>> +	 * Maybe not future-proof, but good for what we're doing now.
> 
> You could pass in a source indication, maybe? Presumably, at least one
> of the callers further up the chain knows...

The "chain" is the vfio_ccw_chp_event() function called off the
.chp_event callback, and then to this point.  So I don't think there's
much we can get back from our callchain, other than the CHP_xxxLINE
event that got us here.

> 
>> +	 *
>> +	 * FIXME Sort of a lie, since we're converting a CRW
>> +	 * reported by a channel-path into one issued to each
>> +	 * subchannel, but still saying it's coming from the path.
> 
> It's still channel-path related, though :)
> 
> The important point is probably is that userspace needs to be aware
> that the same channel-path related event is reported on all affected
> subchannels, and they therefore need some appropriate handling on their
> side.

This is true.  And the fact that the RSC and RSID fields will be in
agreement is helpful.  But yes, the fact that userspace should expect
the possibility of more than one CRW per channel path is the thing I'm
still not enjoying.  Mostly because of the race between queueing
additional ones, and unqueuing them on the other side.  So probably not
much that can be done here but awareness.

> 
>> +	 */
>> +	crw->rsc = CRW_RSC_CPATH;
>> +	crw->rsid = (link->chpid.cssid << 8) | link->chpid.id;
>> +	crw->erc = erc;
>> +
>> +	list_add_tail(&vc_crw->next, &private->crw);
>> +	queue_work(vfio_ccw_work_q, &private->crw_work);
>> +}
>> +
>>  static int vfio_ccw_chp_event(struct subchannel *sch,
>>  			      struct chp_link *link, int event)
>>  {
> (...)
> 
