Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4317A2537
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 19:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbjIORzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 13:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbjIORzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 13:55:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACAD1FF5;
        Fri, 15 Sep 2023 10:55:10 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38FHhGUG015625;
        Fri, 15 Sep 2023 17:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6w9nbkaMwyGCC2VPdZHSANF4Nh5aKQT7FvVJ+0Nvv+w=;
 b=OSVD3k2VgQgtqvwaT1YiXfTRs6OEL9uqoCiwlmn4j81yCKqKQT7RJIw6O1ufn+3Xn1P6
 kixv9Y5n5jXFFJ/LV/GMd27ty4/phjKs1VU9ohWalFZ7tadWxkpuqnTavvzfZerM0U2d
 tleS35sZtOzvN3ehJE64oqYJG1uqhsyHzuX8GJpRrgRbjwCT1f+Mj2Q6+19FrrN2TqtY
 BNxxZXSL1mV9x6rVU4/r4Y0Xmvc2ewSuFqBzA+7Tsp7ZLLwUOROL5epf/coov1Ir8dQI
 xTQ1QscOPTyF6zCZUKvWVXIoYU0/HNcxL0OfRoHBjen9Mcb25qcesYvzj5AYCZeemHm4 KQ== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t4ukd8wqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Sep 2023 17:54:56 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38FG6LcW002401;
        Fri, 15 Sep 2023 17:54:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t158kwnsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Sep 2023 17:54:54 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38FHsqPF24445610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 17:54:52 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BF7C2004D;
        Fri, 15 Sep 2023 17:54:52 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB3EE20043;
        Fri, 15 Sep 2023 17:54:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 15 Sep 2023 17:54:51 +0000 (GMT)
Date:   Fri, 15 Sep 2023 19:54:50 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] Use arch_make_folio_accessible() everywhere
Message-ID: <20230915195450.1fd35f48@p-imbrenda>
In-Reply-To: <20230915172829.2632994-1-willy@infradead.org>
References: <20230915172829.2632994-1-willy@infradead.org>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -qdZCiIKDqTehVkEeLmO5vr7qd8z_a9Y
X-Proofpoint-GUID: -qdZCiIKDqTehVkEeLmO5vr7qd8z_a9Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-15_14,2023-09-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=936 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309150157
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Sep 2023 18:28:25 +0100
"Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> We introduced arch_make_folio_accessible() a couple of years
> ago, and it's in use in the page writeback path.  GUP still uses
> arch_make_page_accessible(), which means that we can succeed in making
> a single page of a folio accessible, then fail to make the rest of the
> folio accessible when it comes time to do writeback and it's too late
> to do anything about it.  I'm not sure how much of a real problem this is.
> 
> Switching everything around to arch_make_folio_accessible() also lets
> us switch the page flag to be per-folio instead of per-page, which is
> a good step towards dynamically allocated folios.
> 
> Build-tested only.
> 
> Matthew Wilcox (Oracle) (3):
>   mm: Use arch_make_folio_accessible() in gup_pte_range()
>   mm: Convert follow_page_pte() to use a folio
>   s390: Convert arch_make_page_accessible() to
>     arch_make_folio_accessible()
> 
>  arch/s390/include/asm/page.h |  5 ++--
>  arch/s390/kernel/uv.c        | 46 +++++++++++++++++++++++-------------
>  arch/s390/mm/fault.c         | 15 ++++++------
>  include/linux/mm.h           | 20 ++--------------
>  mm/gup.c                     | 22 +++++++++--------
>  5 files changed, 54 insertions(+), 54 deletions(-)
> 

if I understand correctly, this will as a matter of fact move the
security property from pages to folios.

this means that trying to access a page will (try to) make the whole
folio accessible, even though that might be counterproductive.... 

and there is no way to simply split a folio

I don't like this

there are also other reasons, but I don't have time to go into the
details on a Friday evening (will elaborate more on Monday)
