Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471676FC559
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 13:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbjEILtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 07:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbjEILsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 07:48:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA6240E9;
        Tue,  9 May 2023 04:48:52 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349BLZ1h003431;
        Tue, 9 May 2023 11:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=abgW1YEGMMroDfs43qGdGM8zVDZwGtBhnb1xXC6tnc0=;
 b=T7p9x2dnZzBToWVJMep3eN5zlcMfXeUEMtROYZ/wxzokpshr4EzA2Wnj6DgX6rY5VqVI
 vRmOSDwj6AR+rocuORBpZB+pIfxGThb4sSpa3PowMKJSWLc7vg4m35YtYuWyzfktV0nz
 QemVHATldyBY+nqw/TV+W3Du3FzNh4MZbkqSls1ApFvXQ8OQEOBvDr2gYDEw8xJxhM7k
 4nILBxEN7Y/iDjRCxB6hlKCyHFwR3riL+Gr94XZl7kRgmoEa6kNSCGMdbyDk6J9QKDOY
 tpVPhKeNg6DIeaVky4TrRGlrJeRpgIvXTc1FuHwUPjMujVq8HHu+hFKRCCfZ9QVdLOnF Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfjvs4cu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:48:51 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349BkUPB008395;
        Tue, 9 May 2023 11:48:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfjvs4ct2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:48:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 348NPvRE025309;
        Tue, 9 May 2023 11:48:48 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qf7nh0dmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:48:47 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349BmisN22348424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 11:48:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CAE22004D;
        Tue,  9 May 2023 11:48:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C51C620040;
        Tue,  9 May 2023 11:48:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 11:48:43 +0000 (GMT)
Date:   Tue, 9 May 2023 13:48:39 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 3/3] KVM: s390: add tracepoint in gmap notifier
Message-ID: <20230509134839.2e243224@p-imbrenda>
In-Reply-To: <20230509111202.333714-4-nrb@linux.ibm.com>
References: <20230509111202.333714-1-nrb@linux.ibm.com>
        <20230509111202.333714-4-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FSpun0hCZGfR5RXt2DONjV4NFYxzfEpR
X-Proofpoint-ORIG-GUID: QTWiBuqvAn85Kb7JXkO3I67g4xBQ1L3C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_07,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305090092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 May 2023 13:12:02 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The gmap notifier is called whenever something in the gmap structures

this is a little bit too oversimplified; the gmap notifier is only
called for ptes (or pmds for hugetlbfs) that have the notifier bit set
(used for prefix or vsie)

> changes. To diagnose performance issues, it can be useful to see what
> causes certain changes in the gmap.
> 
> Hence, add a tracepoint in the gmap notifier.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

apart for the above nit, looks quite straightforward

> ---
>  arch/s390/kvm/kvm-s390.c   |  2 ++
>  arch/s390/kvm/trace-s390.h | 23 +++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b012645a5a7c..f66953bdabe4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3981,6 +3981,8 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
>  	unsigned long prefix;
>  	unsigned long i;
>  
> +	trace_kvm_s390_gmap_notifier(start, end, gmap_is_shadow(gmap));
> +
>  	if (gmap_is_shadow(gmap))
>  		return;
>  	if (start >= 1UL << 31)
> diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
> index 6f0209d45164..5dabd0b64d6e 100644
> --- a/arch/s390/kvm/trace-s390.h
> +++ b/arch/s390/kvm/trace-s390.h
> @@ -333,6 +333,29 @@ TRACE_EVENT(kvm_s390_airq_suppressed,
>  		      __entry->id, __entry->isc)
>  	);
>  
> +/*
> + * Trace point for gmap notifier calls.
> + */
> +TRACE_EVENT(kvm_s390_gmap_notifier,
> +		TP_PROTO(unsigned long start, unsigned long end, unsigned int shadow),
> +		TP_ARGS(start, end, shadow),
> +
> +		TP_STRUCT__entry(
> +			__field(unsigned long, start)
> +			__field(unsigned long, end)
> +			__field(unsigned int, shadow)
> +			),
> +
> +		TP_fast_assign(
> +			__entry->start = start;
> +			__entry->end = end;
> +			__entry->shadow = shadow;
> +			),
> +
> +		TP_printk("gmap notified (start:0x%lx end:0x%lx shadow:%d)",
> +			__entry->start, __entry->end, __entry->shadow)
> +	);
> +
>  
>  #endif /* _TRACE_KVMS390_H */
>  

