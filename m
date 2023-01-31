Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06B068283F
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjAaJIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbjAaJIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:08:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EF14B75C
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:04:41 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30V8dsMi010207
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OWO3CvXk2h+uJkitEEkbeBraUimQboHkYfxIKwmQ5K8=;
 b=o1QS5axNViwZdhk0lLWTTtLNibE78YVARzNvdUh+S4d5e72q0V0cEI4DvOOFmnZ1hh2E
 zYvHRB8Ng5VmkIk3EqdcTM0ye4eBQKl02GWLbYz0ESk4ryRVTLbHLoZLFJLuk1MyyPB+
 ofE3Mp0M1Rmk8ysxXyv8y7T5SlPM3bQGvlxc04FWr1IhIlaNUoQ39gElmbA2i24SMdU3
 j2LfIiqlHgeGLq8Jbzr37e4lOfiqKLzd+hjoKiEXf1AlnACt3ZeFcznfVvABUPqoaXjZ
 uUaDSzLaAG67hHmqjG9EAiIGPbIH0iT/9Zx4XCEnfFF0vY4lgxjUHzIh3i82WFMWbHHU eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3new9kkpxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:53:25 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30V8lQot008015
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:53:24 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3new9kkpwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 08:53:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30UKfZn1026900;
        Tue, 31 Jan 2023 08:53:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ncvs7k91p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 08:53:21 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30V8rIFM23986500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 08:53:18 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6980820043;
        Tue, 31 Jan 2023 08:53:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEE8120040;
        Tue, 31 Jan 2023 08:53:17 +0000 (GMT)
Received: from [9.171.57.28] (unknown [9.171.57.28])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 31 Jan 2023 08:53:17 +0000 (GMT)
Message-ID: <282aa2b2-0873-f27e-bfee-f3374a77162b@linux.ibm.com>
Date:   Tue, 31 Jan 2023 09:53:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x/Makefile: refactor CPPFLAGS
Content-Language: en-US
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
 <20230119114045.34553-5-mhartmay@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230119114045.34553-5-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SV3DP0IHAiIV8Fcsk8M16a31Alwh3Fol
X-Proofpoint-GUID: 7h4XNhxhazI3WOU5h1AkI3KEDCnWHIDw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_03,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310075
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/23 12:40, Marc Hartmayer wrote:
> This change makes it easier to reuse them. While at it, remove `lib`
> include path since it seems to be unused.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/Makefile | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 71e6563bbb61..8719f0c837cf 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -63,9 +63,12 @@ test_cases: $(tests)
>   test_cases_binary: $(tests_binary)
>   test_cases_pv: $(tests_pv_binary)
>   
> +INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x
> +CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
> +
>   CFLAGS += -std=gnu99
>   CFLAGS += -ffreestanding
> -CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/s390x -I lib
> +CFLAGS += $(CPPFLAGS)
>   CFLAGS += -O2
>   CFLAGS += -march=zEC12
>   CFLAGS += -mbackchain

