Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D162DD72B2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 12:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfJOKBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 06:01:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726834AbfJOKBT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Oct 2019 06:01:19 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9F9lqIg054714
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 06:01:19 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vkaftphx2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 06:01:18 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <maier@linux.ibm.com>;
        Tue, 15 Oct 2019 11:01:15 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 15 Oct 2019 11:01:14 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9FA1CdM43843812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 10:01:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CA0B52050;
        Tue, 15 Oct 2019 10:01:12 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.99.188])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 62D955204F;
        Tue, 15 Oct 2019 10:01:12 +0000 (GMT)
Subject: Re: [RFC PATCH 2/4] vfio-ccw: Trace the FSM jumptable
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191014180855.19400-1-farman@linux.ibm.com>
 <20191014180855.19400-3-farman@linux.ibm.com>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Tue, 15 Oct 2019 12:01:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014180855.19400-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19101510-0016-0000-0000-000002B83110
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101510-0017-0000-0000-000033194ECB
Message-Id: <96431f2f-774c-0be2-54ef-ebcaa4ae7298@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-15_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910150091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/14/19 8:08 PM, Eric Farman wrote:
> It would be nice if we could track the sequence of events within
> vfio-ccw, based on the state of the device/FSM and our calling
> sequence within it.  So let's add a simple trace here so we can
> watch the states change as things go, and allow it to be folded
> into the rest of the other cio traces.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_private.h |  1 +
>   drivers/s390/cio/vfio_ccw_trace.c   |  1 +
>   drivers/s390/cio/vfio_ccw_trace.h   | 26 ++++++++++++++++++++++++++
>   3 files changed, 28 insertions(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index bbe9babf767b..9b9bb4982972 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -135,6 +135,7 @@ extern fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS];
>   static inline void vfio_ccw_fsm_event(struct vfio_ccw_private *private,
>   				     int event)
>   {
> +	trace_vfio_ccw_fsm_event(private->sch->schid, private->state, event);
>   	vfio_ccw_jumptable[private->state][event](private, event);
>   }
> 
> diff --git a/drivers/s390/cio/vfio_ccw_trace.c b/drivers/s390/cio/vfio_ccw_trace.c
> index d5cc943c6864..b37bc68e7f18 100644
> --- a/drivers/s390/cio/vfio_ccw_trace.c
> +++ b/drivers/s390/cio/vfio_ccw_trace.c
> @@ -9,4 +9,5 @@
>   #define CREATE_TRACE_POINTS
>   #include "vfio_ccw_trace.h"
> 
> +EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
>   EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_io_fctl);
> diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
> index 2a2937a40124..24a8152acfdf 100644
> --- a/drivers/s390/cio/vfio_ccw_trace.h
> +++ b/drivers/s390/cio/vfio_ccw_trace.h
> @@ -17,6 +17,32 @@
> 
>   #include <linux/tracepoint.h>
> 
> +TRACE_EVENT(vfio_ccw_fsm_event,
> +	TP_PROTO(struct subchannel_id schid, int state, int event),
> +	TP_ARGS(schid, state, event),
> +
> +	TP_STRUCT__entry(
> +		__field(u8, cssid)
> +		__field(u8, ssid)
> +		__field(u16, schno)
> +		__field(int, state)
> +		__field(int, event)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cssid = schid.cssid;
> +		__entry->ssid = schid.ssid;
> +		__entry->schno = schid.sch_no;
> +		__entry->state = state;
> +		__entry->event = event;
> +	),
> +
> +	TP_printk("schid=%x.%x.%04x state=%x event=%x",

/sys/kernel/debug/tracing/events](0)# grep -R '%[^%]*x'

Many existing TPs often seem to format hex output with a 0x prefix (either 
explicit with 0x%x or implicit with %#x). Since some of your other TPs also 
output decimal integer values, I wonder if a distinction would help 
unexperienced TP readers.

> +		__entry->cssid, __entry->ssid, __entry->schno,
> +		__entry->state,
> +		__entry->event)
> +);
> +
>   TRACE_EVENT(vfio_ccw_io_fctl,
>   	TP_PROTO(int fctl, struct subchannel_id schid, int errno, char *errstr),
>   	TP_ARGS(fctl, schid, errno, errstr),
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

