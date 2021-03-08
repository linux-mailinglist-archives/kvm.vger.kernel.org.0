Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92884331200
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 16:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhCHPTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 10:19:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231756AbhCHPT0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 10:19:26 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128FC0XR171263;
        Mon, 8 Mar 2021 10:19:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hte6hk8PD7WnzUoO8qiIzVLFHjUYsCUTCvQqJESPp9I=;
 b=odPpwaQYyl4fd7JTUGzYm7Kxqyr94CU7RsGt36FuUyeOh3JLA+KOpu7sPJcPbL/1gCj9
 iSLE55uavv4C0bChy64t2jYYOX35bAPJopt4nOu7bNaaIyVLpamEDi/b8IVti9yUzPjx
 jzArNeg3BtAcF6oCgjUTRm6ecZi3ctVTmYY8bgtRcSM+LO1yUVAQ+YnaoRKs0mDk1DoT
 ngckD/CGllJrnhicOTiMPIsJ5+FIovn10kNYRgjYxfKr+HKEsX5Wx7U86OK+GsvmxKUE
 47SQsN+83UCaVezweCIBEV+kyveIeo5HXdhaGP7q4eKsKb+GvOn2rUXn3/L7H8tsXGEV 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375p0v8ug8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:19:26 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128FEvWZ184975;
        Mon, 8 Mar 2021 10:19:26 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375p0v8uf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:19:26 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128FCLw1029228;
        Mon, 8 Mar 2021 15:19:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3741c89xk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 15:19:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128FJ5nr26542498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 15:19:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB0B34C04A;
        Mon,  8 Mar 2021 15:19:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61FF84C064;
        Mon,  8 Mar 2021 15:19:19 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.67.70])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 15:19:19 +0000 (GMT)
Subject: Re: [PATCH v5 0/3] s390/kvm: fix MVPG when in VSIE
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20210302174443.514363-1-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <e548903d-ed72-d84f-8010-1bb765696ffe@de.ibm.com>
Date:   Mon, 8 Mar 2021 16:19:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210302174443.514363-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_11:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=816 clxscore=1015
 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.03.21 18:44, Claudio Imbrenda wrote:
> The current handling of the MVPG instruction when executed in a nested
> guest is wrong, and can lead to the nested guest hanging.
> 
> This patchset fixes the behaviour to be more architecturally correct,
> and fixes the hangs observed.
> 
> v4->v5
> * split kvm_s390_logical_to_effective so it can be reused for vSIE
> * fix existing comments and add some more comments
> * use the new split _kvm_s390_logical_to_effective in vsie_handle_mvpg
> 
> v3->v4
> * added PEI_ prefix to DAT_PROT and NOT_PTE macros
> * added small comment to explain what they are about
> 
> v2->v3
> * improved some comments
> * improved some variable and parameter names for increased readability
> * fixed missing handling of page faults in the MVPG handler
> * small readability improvements
> 
> v1->v2
> * complete rewrite


queued (with small fixups) for kvms390. Still not sure if this will land in master or next.
Opinions?
> 
> Claudio Imbrenda (3):
>    s390/kvm: split kvm_s390_logical_to_effective
>    s390/kvm: extend kvm_s390_shadow_fault to return entry pointer
>    s390/kvm: VSIE: correctly handle MVPG when in VSIE
> 
>   arch/s390/kvm/gaccess.c |  30 ++++++++++--
>   arch/s390/kvm/gaccess.h |  35 ++++++++++---
>   arch/s390/kvm/vsie.c    | 106 ++++++++++++++++++++++++++++++++++++----
>   3 files changed, 151 insertions(+), 20 deletions(-)
> 
