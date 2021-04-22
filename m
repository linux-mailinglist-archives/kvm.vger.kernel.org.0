Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82CF368289
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 16:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbhDVOkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 10:40:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236510AbhDVOkB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 10:40:01 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MEYqt7046890;
        Thu, 22 Apr 2021 10:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=bWvD20q4YhRTe5N3/qrevWFZh7UJjKlLEbSTpGJIUuA=;
 b=oz1DJdrpI9VGdl3dHhwBMAtDPNwPTYJug1TMeShuh0waSzuJ0B3e9WXPG0wkXzDQcyOv
 vcfiPY/hfKZcK3BCl7KPZm7Noqrb52qjF9bqiCaISD288958IlnRuGOMHA0tSqOtfOcu
 Rmlz/tM32MkJqsLuXJDFMGspLvVkgyUjAjbX0PIFOg7JATNUxerSyIa3KA7pDYvll15q
 yordJfQnVBP50+t2/wGoCComPnMzw7QmJKgAKdP66oQBKMky52qnoLGpXehQDbcAWISJ
 SCaXwX0p5/RgPFHlAlMzl1/fAzpA3WcnH0EHGePaaw6AAJZP2F0Zb8V7FUqWlyGh9lH+ Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 383aqvrtnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 10:38:30 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13MEZhWN051717;
        Thu, 22 Apr 2021 10:38:30 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 383aqvrtmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 10:38:30 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13MEMmLL032429;
        Thu, 22 Apr 2021 14:38:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 37yqa89m08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 14:38:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13MEcPFJ20709722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 14:38:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E72EB52059;
        Thu, 22 Apr 2021 14:38:24 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 807F552052;
        Thu, 22 Apr 2021 14:38:24 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, gor@linux.ibm.com
Subject: Re: [PATCH v3 9/9] KVM: Move instrumentation-safe annotations for
 enter/exit to x86 code
References: <20210415222106.1643837-1-seanjc@google.com>
        <20210415222106.1643837-10-seanjc@google.com>
        <0c74158d-279a-5afa-0778-822c77ac8dc2@de.ibm.com>
Date:   Thu, 22 Apr 2021 16:38:24 +0200
In-Reply-To: <0c74158d-279a-5afa-0778-822c77ac8dc2@de.ibm.com> (Christian
        Borntraeger's message of "Wed, 21 Apr 2021 10:09:11 +0200")
Message-ID: <yt9d4kfypeov.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S77gfyvLqOXBp7fwBctyyEw_3Fzv7DwJ
X-Proofpoint-ORIG-GUID: C7nzDPw_32BELsJPSSQ7R73hhq1Ii59_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_06:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 clxscore=1011 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> On 16.04.21 00:21, Sean Christopherson wrote:
>> Drop the instrumentation_{begin,end}() annonations from the common KVM
>> guest enter/exit helpers, and massage the x86 code as needed to preserve
>> the necessary annotations.  x86 is the only architecture whose transition
>> flow is tagged as noinstr, and more specifically, it is the only
>> architecture for which instrumentation_{begin,end}() can be non-empty.
>> No other architecture supports CONFIG_STACK_VALIDATION=y, and s390
>> is the
>> only other architecture that support CONFIG_DEBUG_ENTRY=y.  For
>> instrumentation annontations to be meaningful, both aformentioned configs
>> must be enabled.
>> Letting x86 deal with the annotations avoids unnecessary nops by
>> squashing back-to-back instrumention-safe sequences.
>
> We have considered implementing objtool for s390. Not sure where we
> stand and if we will do this or not. Sven/Heiko?

We are planning to support objtool on s390. Vasily is working on it -
maybe he has some thoughts about this.
