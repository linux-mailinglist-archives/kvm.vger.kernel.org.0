Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CDD345C2F
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 11:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhCWKt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 06:49:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6500 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhCWKtS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 06:49:18 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12NAYkWa091737;
        Tue, 23 Mar 2021 06:49:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8iL0SZvurpu1rkhylZ2IOe38SRfxYtJO98lmpA0JeVU=;
 b=AQqiBiI9sIv4jdFx6vpZcezIBvGbSfsmXRL9hPZCHvwXp0naMOQrh97p4pXOUGnPw12o
 E9viF8QtlQxtzRvDBypQgTP6AeAsVabigIjUDwYBlDZm6WvOP2f46Qf7tDlu3Y3L+DIu
 bV7qQaoWBEg8gZPjK5xK1nILR1k6Bh3YC58krWokdNlFkKJWnXpUIjvrso3fIV2z+zhf
 qfJdSBG9oxnIvA7NtERJGP9xVVVGiQ/TeYfDrZredmsknhY5Z4UVL+Usmk1xNjtKFtfI
 4QCRq7HmhHJVq2nBmcY2qe6nATjntAmfJHEzcH6Y/Y3dhqTSPPZ6e/khfT4SK0Q0PFy4 yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37dx9yey4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 06:49:17 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12NAYxCG092810;
        Tue, 23 Mar 2021 06:49:17 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37dx9yey3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 06:49:17 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12NAl8Fb006872;
        Tue, 23 Mar 2021 10:49:15 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 37d9d8spcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 10:49:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12NAmsFF24904188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 10:48:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D12352063;
        Tue, 23 Mar 2021 10:49:12 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.5.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F329952050;
        Tue, 23 Mar 2021 10:49:11 +0000 (GMT)
Subject: Re: [PATCH v2 0/2] s390/kvm: VSIE: fix prefixing and MSO for MVPG
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20210322140559.500716-1-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <9b7b3232-be98-fdd1-4c53-10c2b130ce25@de.ibm.com>
Date:   Tue, 23 Mar 2021 11:49:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322140559.500716-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_03:2021-03-22,2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 spamscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.03.21 15:05, Claudio Imbrenda wrote:
> The guest real address needs to pass through prefixing in order to yield
> the absolute address.
> 
> The absolute address needs to be offset by the MSO in order to get the
> host virtual address.
> 
> v1->v2
> * use the MSO from the shadow SIE page instead of the original one
> * reuse src and dest variabled to improve readability
> 
> Claudio Imbrenda (2):
>    s390/kvm: split kvm_s390_real_to_abs
>    s390/kvm: VSIE: fix MVPG handling for prefixing and MSO
> 
>   arch/s390/kvm/gaccess.h | 23 +++++++++++++++++------
>   arch/s390/kvm/vsie.c    |  6 +++++-
>   2 files changed, 22 insertions(+), 7 deletions(-)
> 

I picked both for internal CI and staging.
RBs or acks can still be send.
