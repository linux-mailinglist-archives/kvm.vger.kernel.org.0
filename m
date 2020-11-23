Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDAC2C1455
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 20:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbgKWTM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 14:12:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729873AbgKWTMz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Nov 2020 14:12:55 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJ34Kx134456;
        Mon, 23 Nov 2020 14:12:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fHY+zMuzc3A1muYe2I4TpPP78UvT54VW7n45WOdqBOg=;
 b=moNv/UbDV147AtDIt6ebejrJam2AuLEWa85VVA0ZrDQw5VGnSWoPwpgoKn03XGxtW9fy
 h3q2H35WvO2KhqzEd7umjZseMznXh9qrIn02Ffo8pC4Kr466kToCgki424tpF/x5Xy/k
 l9C5/QF4WC+f3wN+VeQj3KFqJhKnSgL7T3/ZHqcRaCsm7VwQpFeZNkBtiV0TZ9S4GIs2
 vR+jkUx+mcYKfUrMg/2CxALq732S61zwyOR+Sggu2WOvHhR+V/7r9MhpiZ6cTeeMy4Xv
 CNGgliMOkt5lM8r2xavL7UqQNyGJReJfDBE4KSr9zE6wl1ML0/ZABecRehWDxIXpMYAg Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34yq47ghb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 14:12:50 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ANJ4Wqp143471;
        Mon, 23 Nov 2020 14:12:50 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34yq47ghat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 14:12:50 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJCF3C001086;
        Mon, 23 Nov 2020 19:12:49 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 34xth8sjb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 19:12:49 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANJCnXu64356778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 19:12:49 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE9CE112062;
        Mon, 23 Nov 2020 19:12:48 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C96F112066;
        Mon, 23 Nov 2020 19:12:48 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.169.207])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 19:12:48 +0000 (GMT)
Subject: Re: [RFC PATCH 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20201117032139.50988-1-farman@linux.ibm.com>
 <20201117032139.50988-2-farman@linux.ibm.com>
 <20201119123026.1353cb3c.cohuck@redhat.com>
 <20201119165611.6a811d76.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <0fead493-332e-ff0a-ffea-c3b162cfe347@linux.ibm.com>
Date:   Mon, 23 Nov 2020 14:12:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201119165611.6a811d76.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 spamscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011230122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/19/20 10:56 AM, Halil Pasic wrote:
> On Thu, 19 Nov 2020 12:30:26 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>>> +static void vfio_mdev_request(void *device_data, unsigned int count)
>>> +{
>>> +	struct mdev_device *mdev = device_data;
>>> +	struct mdev_parent *parent = mdev->parent;
>>> +
>>> +	if (unlikely(!parent->ops->request))
>> Hm. Do you think that all drivers should implement a ->request()
>> callback?
> @Tony: What do you think, does vfio_ap need something like this?
>
> BTW how is this supposed to work in a setup where the one parent
> has may children (like vfio_ap or the gpu slice and dice usecases).
>
> After giving this some thought I'm under the impression, I don't
> get the full picture yet.

Eric Farman touched base with me on Friday to discuss this, but
I was on my way out the door for an appointment. He is off this
week; so, the bottom line for me is that I don't have even a
piece of the picture here and therefore don't have enough
info to speculate on whether vfio_ap needs something like this.

>
> Regards,
> Halil

