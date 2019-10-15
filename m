Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52CC9D77D9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 16:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732391AbfJOOAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 10:00:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52077 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732387AbfJOOAR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Oct 2019 10:00:17 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9FDrkIJ075092
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 10:00:16 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vnfd8g88n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 10:00:15 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <maier@linux.ibm.com>;
        Tue, 15 Oct 2019 15:00:13 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 15 Oct 2019 15:00:11 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9FE0A2U55640224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 14:00:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C1B511C074;
        Tue, 15 Oct 2019 14:00:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8CA311C066;
        Tue, 15 Oct 2019 14:00:09 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.99.188])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Oct 2019 14:00:09 +0000 (GMT)
Subject: Re: [RFC PATCH 2/4] vfio-ccw: Trace the FSM jumptable
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191014180855.19400-1-farman@linux.ibm.com>
 <20191014180855.19400-3-farman@linux.ibm.com>
 <96431f2f-774c-0be2-54ef-ebcaa4ae7298@linux.ibm.com>
 <20191015155339.0d714c75.cohuck@redhat.com>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Tue, 15 Oct 2019 16:00:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015155339.0d714c75.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19101514-4275-0000-0000-000003724A97
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101514-4276-0000-0000-000038855D1F
Message-Id: <4d9b1e87-18be-24f3-5f4d-796442b882a5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-15_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910150126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/15/19 3:53 PM, Cornelia Huck wrote:
> On Tue, 15 Oct 2019 12:01:12 +0200
> Steffen Maier <maier@linux.ibm.com> wrote:
> 
>> On 10/14/19 8:08 PM, Eric Farman wrote:
>>> It would be nice if we could track the sequence of events within
>>> vfio-ccw, based on the state of the device/FSM and our calling
>>> sequence within it.  So let's add a simple trace here so we can
>>> watch the states change as things go, and allow it to be folded
>>> into the rest of the other cio traces.
>>>
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>    drivers/s390/cio/vfio_ccw_private.h |  1 +
>>>    drivers/s390/cio/vfio_ccw_trace.c   |  1 +
>>>    drivers/s390/cio/vfio_ccw_trace.h   | 26 ++++++++++++++++++++++++++
>>>    3 files changed, 28 insertions(+)
> 
> (...)
> 
>>> diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
>>> index 2a2937a40124..24a8152acfdf 100644
>>> --- a/drivers/s390/cio/vfio_ccw_trace.h
>>> +++ b/drivers/s390/cio/vfio_ccw_trace.h
>>> @@ -17,6 +17,32 @@
>>>
>>>    #include <linux/tracepoint.h>
>>>
>>> +TRACE_EVENT(vfio_ccw_fsm_event,
>>> +	TP_PROTO(struct subchannel_id schid, int state, int event),
>>> +	TP_ARGS(schid, state, event),
>>> +
>>> +	TP_STRUCT__entry(
>>> +		__field(u8, cssid)
>>> +		__field(u8, ssid)
>>> +		__field(u16, schno)
>>> +		__field(int, state)
>>> +		__field(int, event)
>>> +	),
>>> +
>>> +	TP_fast_assign(
>>> +		__entry->cssid = schid.cssid;
>>> +		__entry->ssid = schid.ssid;
>>> +		__entry->schno = schid.sch_no;
>>> +		__entry->state = state;
>>> +		__entry->event = event;
>>> +	),
>>> +
>>> +	TP_printk("schid=%x.%x.%04x state=%x event=%x",
>>
>> /sys/kernel/debug/tracing/events](0)# grep -R '%[^%]*x'
>>
>> Many existing TPs often seem to format hex output with a 0x prefix (either
>> explicit with 0x%x or implicit with %#x). Since some of your other TPs also
>> output decimal integer values, I wonder if a distinction would help
>> unexperienced TP readers.
> 
> I generally agree. However, we explicitly don't want to do that for
> schid formatting (as it should match the bus id). For event, it might
> become relevant should we want to introduce a high number of new events
> in the future (currently, there's a grand total of four events.)

Yeah, thanks for clarifying. I meant just state and event, not schid.

> 
>>
>>> +		__entry->cssid, __entry->ssid, __entry->schno,
>>> +		__entry->state,
>>> +		__entry->event)
>>> +);
>>> +
>>>    TRACE_EVENT(vfio_ccw_io_fctl,
>>>    	TP_PROTO(int fctl, struct subchannel_id schid, int errno, char *errstr),
>>>    	TP_ARGS(fctl, schid, errno, errstr),
>>>    
>>
>>
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

