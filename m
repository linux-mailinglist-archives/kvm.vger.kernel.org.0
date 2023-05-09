Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1146FBF1D
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 08:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbjEIGQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 02:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbjEIGQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 02:16:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE09A5D8;
        Mon,  8 May 2023 23:16:16 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34965apF011425;
        Tue, 9 May 2023 06:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=FINnFngIr9A5li2quYo/MMeJgUXiyZsHissNFC4A/Dc=;
 b=mQiqKmKYgzRD8Sxg5n+wWapC9P/MT9T8G+xii/b6Gkh30aDaSNhEpSq13VH5vq9ogv+u
 VTWu6GA6tUkGhnVdBC1iPW0h2ZQTaEpE3YpYJu88OBLZzmyccBdgScj7EJR5iioHlIKj
 61+ux+xVxEXgcjGf9WSiSFYvwQYJNv9RFD8ydlXg4I6LNVZiCItX4YEmIqJ5ZlbJDlau
 XRJX8OUjw0ftnHh1uKybbdkAaXcgeDfne2FUKl15NM5NBBcMKKEPBUcvRvnAGnZuPFcU
 gsuUMkLSL2tarHc6RLbm+IkeW4GEYCCnzFxjEaao5bvXGqGnHTvlCwab12WX/ODJYaPK DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfgdv0q5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 06:14:10 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34965tFX013528;
        Tue, 9 May 2023 06:14:09 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfgdv0q4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 06:14:08 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3493QkaD023577;
        Tue, 9 May 2023 06:14:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qf7d1r5nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 06:14:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3496E20f38207824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 06:14:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 107072004F;
        Tue,  9 May 2023 06:14:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A335620040;
        Tue,  9 May 2023 06:14:00 +0000 (GMT)
Received: from osiris (unknown [9.152.212.90])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  9 May 2023 06:14:00 +0000 (GMT)
Date:   Tue, 9 May 2023 08:13:59 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     bigeasy@linutronix.de, mark.rutland@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, longman@redhat.com, boqun.feng@gmail.com,
        pmladek@suse.com, senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH 6/9] s390/time: Provide sched_clock_noinstr()
Message-ID: <ZFnkp6dlOuJqm2II@osiris>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.786238095@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508213147.786238095@infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wfDGl-FeFqMNDJw0P2Xjgk-_X25VGp__
X-Proofpoint-ORIG-GUID: 6h-NLR-B9IcQaofOg1gSserw9vYicRYB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_03,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 clxscore=1011 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=834 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305090046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


1;115;0cOn Mon, May 08, 2023 at 11:19:57PM +0200, Peter Zijlstra wrote:
> With the intent to provide local_clock_noinstr(), a variant of
> local_clock() that's safe to be called from noinstr code (with the
> assumption that any such code will already be non-preemptible),
> prepare for things by providing a noinstr sched_clock_noinstr()
> function.
> 
> Specifically, preempt_enable_*() calls out to schedule(), which upsets
> noinstr validation efforts.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/s390/include/asm/timex.h |   13 +++++++++----
>  arch/s390/kernel/time.c       |   11 ++++++++++-
>  2 files changed, 19 insertions(+), 5 deletions(-)
...
> +static __always_inline unsigned long __get_tod_clock_monotonic(void)
> +{
> +	return get_tod_clock() - tod_clock_base.tod;
> +}
> +
>  /**
>   * get_clock_monotonic - returns current time in clock rate units
>   *
> @@ -216,7 +221,7 @@ static inline unsigned long get_tod_cloc
>  	unsigned long tod;
>  
>  	preempt_disable_notrace();
> -	tod = get_tod_clock() - tod_clock_base.tod;
> +	tod = __get_tod_clock_monotonic();
>  	preempt_enable_notrace();
>  	return tod;
>  }
...
> +unsigned long long noinstr sched_clock_noinstr(void)
> +{
> +	return tod_to_ns(__get_tod_clock_monotonic());
> +}
> +
>  /*
>   * Scheduler clock - returns current time in nanosec units.
>   */
>  unsigned long long notrace sched_clock(void)
>  {
> -	return tod_to_ns(get_tod_clock_monotonic());
> +	unsigned long long ns;
> +	preempt_disable_notrace();
> +	ns = tod_to_ns(get_tod_clock_monotonic());
> +	preempt_enable_notrace();
> +	return ns;
>  }
>  NOKPROBE_SYMBOL(sched_clock);

This disables preemption twice within sched_clock(). So this should either
call __get_tod_clock_monotonic() instead, or the function could stay as it
is, which I would prefer.
