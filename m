Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4775E6F048B
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 12:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243651AbjD0Kx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 06:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243614AbjD0KxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 06:53:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8985597;
        Thu, 27 Apr 2023 03:53:15 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33RAiS5D004717;
        Thu, 27 Apr 2023 10:53:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=waMiVDV3D2LxsboyukziMcKMg/Mz3ihGHrTSUGS3JT0=;
 b=eIXwiIYy9PX2TJzuwedp+7IN9Y6ctLslNweC1oVQ00WVJAYKek1C+TfHYzoMHZKJVUv+
 e73nXgp/4/1GosYMZGfSk2Cm7jFdaGq4b5oeLnPnqJ7i/iW/zShRwC0OtKhHb/KGG/QJ
 VWQT9jAMfXKoZ73gT3erMBfesLm7OCJzpS/g6pxAyI6fCsA6alQMeAMVa8BkZva0l5jo
 zN3Py+i9gamifkNluisY8pWclpFVFD2RYnMwPkiRQEdktMPYn4G7oD73ZfWx4GE3Rshx
 i1x8H7MW8VNlo2l2llWSEQw7AYWC28FIIYZyty9PH82q5RqcJWoRSviGghM8LP7EJi5k rg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7mp5e28f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 10:53:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33R4QXBJ008911;
        Thu, 27 Apr 2023 10:53:11 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47772wvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 10:53:11 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33RAr5Xp41091362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 10:53:05 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F8742004F;
        Thu, 27 Apr 2023 10:53:05 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6CC320040;
        Thu, 27 Apr 2023 10:53:04 +0000 (GMT)
Received: from osiris (unknown [9.152.212.90])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 27 Apr 2023 10:53:04 +0000 (GMT)
Date:   Thu, 27 Apr 2023 12:53:04 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, jgg@nvidia.com
Subject: Re: [PATCH v2 1/1] KVM: s390: fix race in gmap_make_secure
Message-ID: <ZEpUEF7H86E9vVfS@osiris>
References: <20230426134834.35199-1-imbrenda@linux.ibm.com>
 <20230426134834.35199-2-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426134834.35199-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uuGKR60KHL88HP5te0lWx2XwiRQhINMB
X-Proofpoint-ORIG-GUID: uuGKR60KHL88HP5te0lWx2XwiRQhINMB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_07,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=526 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 clxscore=1011 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023 at 03:48:34PM +0200, Claudio Imbrenda wrote:
> This patch fixes a potential race in gmap_make_secure and removes the
> last user of follow_page without FOLL_GET.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
> ---
>  arch/s390/kernel/uv.c | 32 +++++++++++---------------------
>  1 file changed, 11 insertions(+), 21 deletions(-)

It would be helpful if this would be a bit more descriptive. "Fix
race" is not very helpful :)

What race does this fix?
When can this happen?
What are the consequences if the race window is being hit?
