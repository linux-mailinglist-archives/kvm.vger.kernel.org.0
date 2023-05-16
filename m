Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CFB705509
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 19:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjEPRat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 13:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbjEPRao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 13:30:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804369EF3;
        Tue, 16 May 2023 10:30:43 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GHRg22010183;
        Tue, 16 May 2023 17:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=5R3qB2CSREH6ZSKn9wwcWRIAaSohhAzlAudf+wEIzTM=;
 b=Ay5uKKs4AbuZtfcUXrNrZE6++j9eYAfr7jqo2CAgtXP4kTbwn6iwfMS5sWFwa2DbklSx
 5nasRK95gdLcZGhwScyvmL3WKfsTDVjruM5bYTx2PLMQGr7t23+woquxUmQ2/JUZSYpD
 RjcSi125nNENd/Du4RyQP11RsrZtptTO+TlYk2psvcAAqGQGAfq8ner1jlAocjyJrhZf
 cq6n/I+FeqXMlu1ZWFLuWGPscVFEr0aSaoQUmv8NTPHgx4K/gn0uh4hezbLbSdoXMJXB
 xcxJMOGWgvbI4K97V4qB33f+39Al9rQYV3WwIYrleBJqNF6Q3tM5NqQJj6rOJO4/dCO+ cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qme8k025d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:42 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GHS0Gc012764;
        Tue, 16 May 2023 17:30:42 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qme8k024k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:42 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34GFnYCX003859;
        Tue, 16 May 2023 17:30:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qj264sfp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:40 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GHUaOf40567358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 May 2023 17:30:36 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFB9020043;
        Tue, 16 May 2023 17:30:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92D8D20040;
        Tue, 16 May 2023 17:30:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 16 May 2023 17:30:36 +0000 (GMT)
Date:   Tue, 16 May 2023 19:24:26 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 4/6] s390x: fix compile of interrupt.c
Message-ID: <20230516192426.0474754c@p-imbrenda>
In-Reply-To: <20230516130456.256205-5-nrb@linux.ibm.com>
References: <20230516130456.256205-1-nrb@linux.ibm.com>
        <20230516130456.256205-5-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ncjQBl1DLKEnJhr51pw-b-JUKuLgL2n1
X-Proofpoint-GUID: oFOJAhjE17XYMXdM4vmMezZkAhokyJkc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_09,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 adultscore=0 mlxlogscore=806 malwarescore=0
 bulkscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160145
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 May 2023 15:04:54 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> A future commit will include interrupt.h from sie.c.

can you merge this into that future commit that will require it?

>=20
> Since interrupt.h includes mem.h, but sie.c does not include facility.h,
> this will lead to the following compile error:
>=20
> In file included from lib/s390x/interrupt.c:10:
> /home/nrb/kvm-unit-tests/lib/asm/mem.h: In function =E2=80=98set_storage_=
key_mb=E2=80=99:
> /home/nrb/kvm-unit-tests/lib/asm/mem.h:42:16: error: implicit declaration=
 of function =E2=80=98test_facility=E2=80=99 [-Werror=3Dimplicit-function-d=
eclaration]
>    42 |         assert(test_facility(8));
>          |                ^~~~~~~~~~~~~
>=20
> Add the missing include in interrupt.h
>=20
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/mem.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
> index 64ef59b546a4..94d58c34f53f 100644
> --- a/lib/s390x/asm/mem.h
> +++ b/lib/s390x/asm/mem.h
> @@ -8,6 +8,7 @@
>  #ifndef _ASMS390X_MEM_H_
>  #define _ASMS390X_MEM_H_
>  #include <asm/arch_def.h>
> +#include <asm/facility.h>
> =20
>  /* create pointer while avoiding compiler warnings */
>  #define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))

