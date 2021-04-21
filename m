Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1A13666C3
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 10:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhDUIKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 04:10:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230516AbhDUIKk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 04:10:40 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L84nHU018022;
        Wed, 21 Apr 2021 04:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mwMz8kH8eb7LB6iRuFzo9APuB5In4r3taMfrok+THW4=;
 b=Rknlww4miNeAZKdajbWbLyPpE+ftxaPA3pFA6A4vAZnZsIvI9wZ5maxLoixx5GgB9BLT
 qMHUd9p6os8/Zuiht7jAmBLekRlotOG8qjaFFSG4Su9Hci09+DK8U3w2ZZ98Cinjl3CN
 EEz/jcgD1dA8PLuzq7d/e9z51bB3vnuNqEvxjv170xkZQwEmF/Ry5wiLw13141aIh04L
 UsXe1yVWj9h7KlikXqJInk8ACDkPuujp1ntyEREeKUjIduXKHR4+uUDThtD1Uo8sSr0a
 GbZGxV0RhyvM55vCTHtsl2OwX7YUne7/9U1HwVe0SOwpg3nf+mw48H7IN7iK9MXekFIP FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382e86bfys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 04:09:19 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13L876rJ032050;
        Wed, 21 Apr 2021 04:09:19 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382e86bfxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 04:09:18 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13L895b8006545;
        Wed, 21 Apr 2021 08:09:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 37yqa8j59m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 08:09:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13L89DC126739028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 08:09:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0ECA11C058;
        Wed, 21 Apr 2021 08:09:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A17011C04C;
        Wed, 21 Apr 2021 08:09:13 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.39.90])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Apr 2021 08:09:13 +0000 (GMT)
Subject: Re: [PATCH v3 9/9] KVM: Move instrumentation-safe annotations for
 enter/exit to x86 code
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-10-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <0c74158d-279a-5afa-0778-822c77ac8dc2@de.ibm.com>
Date:   Wed, 21 Apr 2021 10:09:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210415222106.1643837-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O0Gbqj7PsH1bpmljgRZ33Sx1MRyz_OsV
X-Proofpoint-GUID: QYIWjy8vpv4N55O6Q4tlpQ0Nqt1_mssd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16.04.21 00:21, Sean Christopherson wrote:
> Drop the instrumentation_{begin,end}() annonations from the common KVM
> guest enter/exit helpers, and massage the x86 code as needed to preserve
> the necessary annotations.  x86 is the only architecture whose transition
> flow is tagged as noinstr, and more specifically, it is the only
> architecture for which instrumentation_{begin,end}() can be non-empty.
> 
> No other architecture supports CONFIG_STACK_VALIDATION=y, and s390 is the
> only other architecture that support CONFIG_DEBUG_ENTRY=y.  For
> instrumentation annontations to be meaningful, both aformentioned configs
> must be enabled.
> 
> Letting x86 deal with the annotations avoids unnecessary nops by
> squashing back-to-back instrumention-safe sequences.

We have considered implementing objtool for s390. Not sure where we
stand and if we will do this or not. Sven/Heiko?

So maybe drop this patch until every other arch agrees that there are
no plans to implement this.
