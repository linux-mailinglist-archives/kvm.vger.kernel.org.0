Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596451946CD
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 19:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgCZSvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 14:51:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727770AbgCZSvs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 14:51:48 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02QIY78k065322;
        Thu, 26 Mar 2020 14:51:47 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywbtkkj1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 14:51:47 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02QIYTr3066700;
        Thu, 26 Mar 2020 14:51:46 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywbtkkj10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 14:51:46 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02QIp1ua023992;
        Thu, 26 Mar 2020 18:51:45 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 2ywawabwhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 18:51:45 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02QIpjGH51511744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 18:51:45 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1552D112061;
        Thu, 26 Mar 2020 18:51:45 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D31A112063;
        Thu, 26 Mar 2020 18:51:44 +0000 (GMT)
Received: from [9.160.3.123] (unknown [9.160.3.123])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 26 Mar 2020 18:51:44 +0000 (GMT)
Subject: Re: [RFC PATCH v2 7/9] vfio-ccw: Wire up the CRW irq and CRW region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200206213825.11444-1-farman@linux.ibm.com>
 <20200206213825.11444-8-farman@linux.ibm.com>
 <20200214143400.175c9e5e.cohuck@redhat.com>
 <75bb9119-8692-c18e-1e7b-c7598d8ef25a@linux.ibm.com>
 <20200324173431.6ad09436.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <49d9d798-a90b-3384-ea83-9c8e7e201203@linux.ibm.com>
Date:   Thu, 26 Mar 2020 14:51:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324173431.6ad09436.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_10:2020-03-26,2020-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/24/20 12:34 PM, Cornelia Huck wrote:
> On Fri, 14 Feb 2020 11:24:39 -0500
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 2/14/20 8:34 AM, Cornelia Huck wrote:
>>> On Thu,  6 Feb 2020 22:38:23 +0100
>>> Eric Farman <farman@linux.ibm.com> wrote:
> 
>>> (...)  
>>>> +static void vfio_ccw_alloc_crw(struct vfio_ccw_private *private,
>>>> +			       struct chp_link *link,
>>>> +			       unsigned int erc)
>>>> +{
>>>> +	struct vfio_ccw_crw *vc_crw;
>>>> +	struct crw *crw;
>>>> +
>>>> +	/*
>>>> +	 * If unable to allocate a CRW, just drop the event and
>>>> +	 * carry on.  The guest will either see a later one or
>>>> +	 * learn when it issues its own store subchannel.
>>>> +	 */
>>>> +	vc_crw = kzalloc(sizeof(*vc_crw), GFP_ATOMIC);
>>>> +	if (!vc_crw)
>>>> +		return;
>>>> +
>>>> +	/*
>>>> +	 * Build in the first CRW space, but don't chain anything
>>>> +	 * into the second one even though the space exists.
>>>> +	 */
>>>> +	crw = &vc_crw->crw[0];
>>>> +
>>>> +	/*
>>>> +	 * Presume every CRW we handle is reported by a channel-path.
>>>> +	 * Maybe not future-proof, but good for what we're doing now.  
>>>
>>> You could pass in a source indication, maybe? Presumably, at least one
>>> of the callers further up the chain knows...  
>>
>> The "chain" is the vfio_ccw_chp_event() function called off the
>> .chp_event callback, and then to this point.  So I don't think there's
>> much we can get back from our callchain, other than the CHP_xxxLINE
>> event that got us here.
> 
> We might want to pass in CRW_RSC_CPATH, that would make it a bit more
> flexible. We can easily rearrange code internally later, though.
> 

This is true...  I'll rearrange it so the routine takes the rsid as
input instead of the link, as well as the rsc, so we don't have to do
that fiddling down the road.
