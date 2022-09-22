Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6395E5BCC
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 09:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiIVHE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 03:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiIVHEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 03:04:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4996C747;
        Thu, 22 Sep 2022 00:04:51 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M70LpE022619;
        Thu, 22 Sep 2022 07:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=J11KBVYOAYFfHLHaZSYPDXg2sZUKPDvphCzithPDioU=;
 b=AU7fpZk7QF+Dme8A2r6l0h8o1bm3owRdNkWdaHoZCQto2scPTbpVTCWuja9+7PhWWhYJ
 zxWJHBgCrVr7YVmsARGp7bTWma1a8zpp2FlC6THpd49dPEchG5vO2lFOtuuTmuL1NN1Y
 P1iloWNubut9Uo6wJyCaENo+HqncvamcXK5NDK3RIkFa4c+IRBvN2n/OCbS5WupAMJeA
 cbp5HPpH8BkG06aSxDfdacXcW8BWDpEPjPADh4nkYXns/UZX1a+o/CZTPourpNGlys/F
 S3hygo3YnshkJbEtG76oBTtIoDNSY4sV97nNIfM6diln2FiWxyfSn8LBl3XIU4DnF6Yk nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jrjx7g6kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 07:04:45 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28M71FYe029507;
        Thu, 22 Sep 2022 07:04:45 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jrjx7g6h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 07:04:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28M6p492009150;
        Thu, 22 Sep 2022 07:04:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3jn5v8mmk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 07:04:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28M70aJe46268738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 07:00:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14BDDA405F;
        Thu, 22 Sep 2022 07:04:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0FD6A4054;
        Thu, 22 Sep 2022 07:04:38 +0000 (GMT)
Received: from [9.171.83.123] (unknown [9.171.83.123])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 22 Sep 2022 07:04:38 +0000 (GMT)
Message-ID: <27ff7009-ee8a-facc-681c-d229cec84b91@linux.ibm.com>
Date:   Thu, 22 Sep 2022 09:04:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 0/5] KVM: selftests: Fix "fix hypercall test" build errors
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <20220908233134.3523339-1-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220908233134.3523339-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EkxLcYb9TJUuUiWPK4TVb9KIG_9hUNma
X-Proofpoint-GUID: 3y5nEO8idQoxYmpXQ3XpnOX2O2TIFZeZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 bulkscore=0 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220046
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 09.09.22 um 01:31 schrieb Sean Christopherson:
> After a toolchain upgrade (I think), the x86 fix_hypercall_test started
> throwing warnings due to -Werror=array-bounds rightly complaining that
> the test is generating an out-of-bounds array access.
> 
> The "obvious" fix is to replace the memcpy() with a memcmp() and compare
> only the exact size of the hypercall instruction.  That worked, until I
> fiddled with the code a bit more and suddenly the test started jumping into
> the weeds due to gcc generating a call to the external memcmp() through the
> PLT, which isn't supported in the selftests.
> 
> To fix that mess, which has been a pitfall for quite some time, provide
> implementations of memcmp(), memcpy(), and memset() to effectively override
> the compiler built-ins.  My thought is to start with the helpers that are
> most likely to be used in guest code, and then add more as needed.
> 
> Tested on x86 and ARM, compile tested on RISC-V and s390.  Full testing on
> RISC-V and s390 would be welcome, the seemingly benign addition of memxxx()
> helpers managed to break ARM due to gcc generating an infinite loop for
> memset() (see patch 1 for details).

Seems to run fine on s390.
