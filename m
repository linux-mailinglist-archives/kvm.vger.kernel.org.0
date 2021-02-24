Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7CE3238F0
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 09:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhBXIrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 03:47:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234516AbhBXIqj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 03:46:39 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11O8YjJM121355;
        Wed, 24 Feb 2021 03:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TxcwqJ1VYX/wleTMbwHADHldTjKwEtQqFfrjWBJx910=;
 b=UZUn16eAJEN/mW31thH55urqk7u18PZe0hWNklWSjD2XVTXslu3EqTntLUQGzdSxeyVG
 4cUTS8SriTNAq9d2Ae8lsGO3deeboUVN+PARk94TKkaW+28IKbr15VYluoy6u2MJ8is/
 K+O7wuXpJWIedSWWCyh2Zm0xWPmTorKTgDCbCGJxgzsA6EFJhTMgoi3Cn47Ehe6K2KO3
 LIUo1J0WvRnFFQf+zeShUukqYR42lXwlPbrjWe0NMlbNJSj3Wktr+vQyJMa/asFgduT7
 ucQuJFBT9oRQWqn212QtVROawwEF3EGZtoBBEGx5i6SYSoX/3La1oSd0veIAlCustBLn VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36wgu5vxpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 03:45:58 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11O8Z6RH123608;
        Wed, 24 Feb 2021 03:45:58 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36wgu5vxmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 03:45:57 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11O8gAFh006162;
        Wed, 24 Feb 2021 08:45:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 36tsph3cf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 08:45:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11O8jd4735389872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 08:45:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C23B421AA;
        Wed, 24 Feb 2021 08:45:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39E691121E8;
        Wed, 24 Feb 2021 08:16:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.202])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Feb 2021 08:16:00 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20210223191353.267981-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 0/2] s390/kvm: fix MVPG when in VSIE
Message-ID: <e35ab218-3725-86b5-cea0-c403cf39b0a6@linux.ibm.com>
Date:   Wed, 24 Feb 2021 09:15:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223191353.267981-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-24_02:2021-02-23,2021-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=922 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/21 8:13 PM, Claudio Imbrenda wrote:
> The current handling of the MVPG instruction when executed in a nested
> guest is wrong, and can lead to the nested guest hanging.
> 
> This patchset fixes the behaviour to be more architecturally correct,
> and fixes the hangs observed.

Could you please push this to devel so we get some CI coverage.

And before you do that please exchange my ACK mail address in the first
patch for the linux one.


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
> 
> Claudio Imbrenda (2):
>   s390/kvm: extend kvm_s390_shadow_fault to return entry pointer
>   s390/kvm: VSIE: correctly handle MVPG when in VSIE
> 
>  arch/s390/kvm/gaccess.c |  30 ++++++++++--
>  arch/s390/kvm/gaccess.h |   6 ++-
>  arch/s390/kvm/vsie.c    | 101 ++++++++++++++++++++++++++++++++++++----
>  3 files changed, 122 insertions(+), 15 deletions(-)
> 

