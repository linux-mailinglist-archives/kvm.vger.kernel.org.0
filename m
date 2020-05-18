Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988C21D8A54
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 23:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgERV6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 17:58:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726250AbgERV6n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 17:58:43 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04ILVHJ5036778;
        Mon, 18 May 2020 17:58:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312c63rah9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 17:58:41 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04ILwfXq135324;
        Mon, 18 May 2020 17:58:41 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312c63rah2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 17:58:41 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04ILdLwb016502;
        Mon, 18 May 2020 21:58:40 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 313whabc8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 21:58:40 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04ILveaU51708216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 21:57:40 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B613AE060;
        Mon, 18 May 2020 21:57:40 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A27DAE05C;
        Mon, 18 May 2020 21:57:39 +0000 (GMT)
Received: from [9.160.58.3] (unknown [9.160.58.3])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 18 May 2020 21:57:39 +0000 (GMT)
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200513142934.28788-1-farman@linux.ibm.com>
 <20200518180903.7cb21dd8.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <33909b2e-2939-9345-175b-960697d05b4e@linux.ibm.com>
Date:   Mon, 18 May 2020 17:57:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200518180903.7cb21dd8.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=2 mlxlogscore=716 cotscore=-2147483648
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/18/20 12:09 PM, Cornelia Huck wrote:
> On Wed, 13 May 2020 16:29:30 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> Hi Conny,
>>
>> Back in January, I suggested a small patch [1] to try to clean up
>> the handling of HSCH/CSCH interrupts, especially as it relates to
>> concurrent SSCH interrupts. Here is a new attempt to address this.
>>
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
> 
> This is the transition I do not understand. When we get a request via
> the I/O area, we go to CP_PROCESSING and start doing translations.
> However, we only transition to CP_PENDING if we actually do a SSCH with
> cc 0 -- which shouldn't be possible in the flow you outline... unless
> it really is something that can be taken care of with locking (state
> machine transitioning due to an interrupt without locking, so we go to
> IDLE without other parts noticing.)

I'm only going by what the (existing and my temporary) tea leaves in
s390dbf are telling us. :)

> 
>>     INTERRUPT (set state=IDLE)

Part of the problem is that this is actually comprised of these elements:

if (irb_is_final && state == CP_PENDING)
	cp_free()

lock io_mutex
copy irb to io_region
unlock io_mutex

if (irb_is_final)
	state = IDLE

The CP_PENDING check will protect us if a SSCH is still being built at
the time we execute this code. But if we got to CP_PENDING first
(between fsm_irq() stacking to the workqueue and us unstacking
vfio_ccw_sch_io_todo()), we would free an unrelated operation. (This was
the scenario in the first version of my fix back in January.)

We can't add a CP_PENDING check after the io_mutex barrier, because if a
second SSCH is being processed, we will hang on the lock acquisition and
will DEFINITELY be in CP_PENDING state when we come back. But by that
point, we will have skipped freeing the (now active) CP but are back in
an IDLE state.


>>                                     INTERRUPT (set state=IDLE)
> 
> But taking a step back (and ignoring your series and the discussion,
> sorry about that):

No apologies necessary.

> 
> We need to do something (creating a local translation of the guest's
> channel program) that does not have any relation to the process in the
> architecture at all, but is only something that needs to be done
> because of what vfio-ccw is trying to do (issuing a channel program on
> behalf of another entity.) Trying to sort that out by poking at actl
> and fctl bits does not seem like the best way; especially as keeping
> the bits up-to-date via STSCH is an exercise in futility.

I am coming to strongly agree with this sentiment.

> 
> What about the following (and yes, I had suggested something vaguely in
> that direction before):
> 
> - Detach the cp from the subchannel (or better, remove the 1:1
>   relationship). By that I mean building the cp as a separately
>   allocated structure (maybe embedding a kref, but that might not be
>   needed), and appending it to a list after SSCH with cc=0. Discard it
>   if cc!=0.
> - Remove the CP_PENDING state. The state is either IDLE after any
>   successful SSCH/HSCH/CSCH, or a new state in that case. But no
>   special state for SSCH.
> - A successful CSCH removes the first queued request, if any.
> - A final interrupt removes the first queued request, if any.
> 
> Thoughts?
> 

I'm cautiously optimistic, for exactly the reason I mention above. If we
always expect to be in IDLE state once an interrupt arrives, we can just
rely on determining if the interrupt is in relation to an actual
operation we're waiting on. I'll give this a try and report back.
