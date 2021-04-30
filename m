Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3CD36FFD7
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 19:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhD3Rof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 13:44:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46976 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229750AbhD3Roe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Apr 2021 13:44:34 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13UHab5h073209;
        Fri, 30 Apr 2021 13:43:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mUVH6xyknU1SpzhgboC1wVZ7fZkvVN0ZyD4IPb0ZU+o=;
 b=AINzomltP5OU2aaC8iPkP1JL7I7DOmpKAhO2D6pAuKcYghwewd9wvRifeYsHKPoUIxt3
 zI55Q7djQ2/T8nxwqMNPpfYZd/wZhERTDn8Wsk1AOsllUEktRAoGWkJ8nc3pHT/BVh6Z
 jq3U0Us0HbVTQCuzy5cvWxNZFjHfShFE4fqw+PlDD1y0aQtG9cfz09DeAQc03EFW1ULR
 H+C53rX88abM2Iv+Ll8/C2SxCp6vlblimiic7WdVHzgT4ExN38g6iA+FSl29Bf9JNSVt
 A6NFdDRnTXpEu4jkcK10a9bcIOhmYetkLRfUO4046HnWfczeIfEiZKZPxL/aglRWZ4q0 kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 388perr3wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Apr 2021 13:43:45 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13UHda9V082314;
        Fri, 30 Apr 2021 13:43:45 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 388perr3w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Apr 2021 13:43:45 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13UHhhdL023320;
        Fri, 30 Apr 2021 17:43:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 384ay8kbdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Apr 2021 17:43:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13UHhfGr33489248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 17:43:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61DBE52050;
        Fri, 30 Apr 2021 17:43:41 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.4.217])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0AD685204F;
        Fri, 30 Apr 2021 17:43:41 +0000 (GMT)
Subject: Re: [PATCH] kvm: exit halt polling on need_resched() as well
To:     Venkatesh Srinivas <venkateshs@chromium.org>, kvm@vger.kernel.org,
        jmattson@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     Benjamin Segall <bsegall@google.com>
References: <20210429162233.116849-1-venkateshs@chromium.org>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ea54b776-c15a-e718-d7c9-ae8df7f24de3@de.ibm.com>
Date:   Fri, 30 Apr 2021 19:43:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210429162233.116849-1-venkateshs@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3GWA--_yM7QU3M5PFfHuUo5frUE0fmEx
X-Proofpoint-GUID: rZBdaTSLni0CYv79uXB_EGC_D3XHv5CE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-30_10:2021-04-30,2021-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 clxscore=1011 mlxlogscore=999 spamscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104300116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29.04.21 18:22, Venkatesh Srinivas wrote:
> From: Benjamin Segall <bsegall@google.com>
> 
> single_task_running() is usually more general than need_resched()
> but CFS_BANDWIDTH throttling will use resched_task() when there
> is just one task to get the task to block. This was causing
> long-need_resched warnings and was likely allowing VMs to
> overrun their quota when halt polling.
> 
> Signed-off-by: Ben Segall <bsegall@google.com>
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>

would that qualify for stable?

> ---
>   virt/kvm/kvm_main.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2799c6660cce..b9f12da6af0e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2973,7 +2973,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>   				goto out;
>   			}
>   			poll_end = cur = ktime_get();
> -		} while (single_task_running() && ktime_before(cur, stop));
> +		} while (single_task_running() && !need_resched() &&
> +			 ktime_before(cur, stop));
>   	}
> 
>   	prepare_to_rcuwait(&vcpu->wait);
> 
