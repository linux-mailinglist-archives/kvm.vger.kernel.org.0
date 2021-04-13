Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2804035D901
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 09:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbhDMHhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 03:37:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237250AbhDMHg7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 03:36:59 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D7XTRS145130;
        Tue, 13 Apr 2021 03:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3jYkpuMDYV3WFilrrqiQJ+dv4nTYyKdryQ7ymrXvczs=;
 b=XBk1nv3i7CIXiKq+u5/ld0QhpfG40bnT9f5v1U6T6+aVMvrS9rucp2sWRysmWm6J1Dfo
 G2aYmFhls2cK8Ep320CgBbgNtpsE18sMoUFEEURkaJjD8xU2JiKrR9maMgamo0usUQTI
 bvcrbzg9nfO/06iGVCXMM+cN+u8OR3YzwHA2A6Sq+rEcXhds0pK8dGpSkfHqTD4BHq3+
 S6i9oBmwZHANWi2O45ODLmTkIkXr2+KFHqI5NVkE77qu1zXeAA6Ke8sD/zleAfi8WMvJ
 Mns7inkXUugboHvPV4lqqhgHQRWuwMBQwYwynnPWhTrzGRSbyvChOiaOJcvbvLkQRDLk 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vtvy6n5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 03:35:31 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13D7YCQh147715;
        Tue, 13 Apr 2021 03:35:31 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vtvy6n4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 03:35:31 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D7Vx9R013096;
        Tue, 13 Apr 2021 07:35:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 37u3n8tfmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 07:35:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D7ZRvY34865448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 07:35:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 494524C040;
        Tue, 13 Apr 2021 07:35:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04C944C04A;
        Tue, 13 Apr 2021 07:35:26 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.28.118])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 07:35:25 +0000 (GMT)
Subject: Re: [PATCH v2 1/3] context_tracking: Split guest_enter/exit_irqoff
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
 <1618298169-3831-2-git-send-email-wanpengli@tencent.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <81112cec-72fa-dd8c-21c8-b24f51021f43@de.ibm.com>
Date:   Tue, 13 Apr 2021 09:35:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1618298169-3831-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yGaFh8iIuiyKlrUDgycLJ3QNmEh4ncT0
X-Proofpoint-GUID: sWi3MjxlgqBGXEBL6ZVOYzNtHJCJFF0e
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=996
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104130052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.04.21 09:16, Wanpeng Li wrote:
[...]

> @@ -145,6 +155,13 @@ static __always_inline void guest_exit_irqoff(void)
>   }
> 
>   #else
> +static __always_inline void context_guest_enter_irqoff(void)
> +{
> +	instrumentation_begin();
> +	rcu_virt_note_context_switch(smp_processor_id());
> +	instrumentation_end();
> +}
> +
>   static __always_inline void guest_enter_irqoff(void)
>   {
>   	/*
> @@ -155,10 +172,13 @@ static __always_inline void guest_enter_irqoff(void)
>   	instrumentation_begin();
>   	vtime_account_kernel(current);
>   	current->flags |= PF_VCPU;
> -	rcu_virt_note_context_switch(smp_processor_id());
>   	instrumentation_end();
> +
> +	context_guest_enter_irqoff();

So we now do instrumentation_begin 2 times?

