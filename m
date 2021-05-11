Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441C037AFF7
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 22:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhEKULj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 16:11:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33210 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhEKULj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 16:11:39 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BK3bKU178858;
        Tue, 11 May 2021 16:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0V8Sr4zzzw9tSrU7wswLcSDl95SzFcodFkU3Wnt624I=;
 b=KEnoeVOZL247h9bQLPXb/zO22SEZpxJzMFo0hnXaKJYSerBx2odKMoxtJiZI8CSNSiXC
 sWDO/0NGGhH/pLt/OxdHb3zIo++j9N9lZfTGr4en8kY6tyziYuh5bg/bHePJyR9OoVz4
 Kq2B1WRN/HdqicbSDy6WFlheL7nEpdOe2wcoaCvI8A/PFtfUuA/6uQOXQeqbk6+YsVBx
 DXDy1S6a+R6hi9rHOIUppufK/PmI7FPIgC4gcP5hJZyXlGLhNNm51/TDbuLLtA4noWQu
 yyF3k5hTnkZrNsedeVXGxwz6j6yvKjph+udwM2NE79PQ5muxwTMks9S83RbKqcUE7S3A ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38g0k0r7ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 16:10:31 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BK4adX181090;
        Tue, 11 May 2021 16:10:31 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38g0k0r79y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 16:10:31 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BK7EPG025067;
        Tue, 11 May 2021 20:10:30 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 38dj99ger4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 20:10:30 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BKANWW22479350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 20:10:23 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BC12136055;
        Tue, 11 May 2021 20:10:23 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94361136053;
        Tue, 11 May 2021 20:10:22 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.43.140])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 20:10:22 +0000 (GMT)
Subject: Re: [PATCH v6 1/3] vfio-ccw: Check initialized flag in cp_init()
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210511195631.3995081-1-farman@linux.ibm.com>
 <20210511195631.3995081-2-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <927149fb-ec36-ccfa-84ac-0b10ac472f84@linux.ibm.com>
Date:   Tue, 11 May 2021 16:10:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210511195631.3995081-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jPnOkXzgOsifylGROr8_jKzlqwCX0Hem
X-Proofpoint-ORIG-GUID: w3slQTrCiJMoQCBW1eAS5vhyNr-1QJJv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 clxscore=1011 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/21 3:56 PM, Eric Farman wrote:
> We have a really nice flag in the channel_program struct that
> indicates if it had been initialized by cp_init(), and use it
> as a guard in the other cp accessor routines, but not for a
> duplicate call into cp_init(). The possibility of this occurring
> is low, because that flow is protected by the private->io_mutex
> and FSM CP_PROCESSING state. But then why bother checking it
> in (for example) cp_prefetch() then?
> 
> Let's just be consistent and check for that in cp_init() too.
> 
> Fixes: 71189f263f8a3 ("vfio-ccw: make it safe to access channel programs")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/s390/cio/vfio_ccw_cp.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index b9febc581b1f..8d1b2771c1aa 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -638,6 +638,10 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>   	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
>   	int ret;
>   
> +	/* this is an error in the caller */
> +	if (cp->initialized)
> +		return -EBUSY;
> +
>   	/*
>   	 * We only support prefetching the channel program. We assume all channel
>   	 * programs executed by supported guests likewise support prefetching.
> 

