Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621A26C496A
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 12:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCVLoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 07:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjCVLoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 07:44:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC685ADDA
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 04:44:08 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32MBR1W7019015;
        Wed, 22 Mar 2023 11:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YrOHePvv/2e2oTSHfeFSVyvPGuCQ3rEPkjRIq8fT9xg=;
 b=h1t+I87jubfuhaiKQLyCl1RBxwDpsQuisjoz3WKG44Z83aYapKZfnTexbVOhlszu35KW
 b1cyZHfhXqYKlA+TssMkXTrLhzHRfIBD38dsHunx7R+28ppZHcFrkEQymvUShSE/VQNP
 0aA2SkTY7IdW5MSWOlc/EQyr4YDGNqs5s6S/9XSGP4LHNTBgpCkHstnfcwj0zDf6jL1J
 BH1dO1boGf/Ucg1sQ3lkN4Zx+E7MRFMlWqJZ4EdLfIrBZfVPQ+vLBiCMnkqeqW/r8wka
 JoAKmyhvzcOpNA0URDzqOJhaUkTAgjeUDCm8CiF5tDnZY3poiet+WmhItD0I3PHkH4F0 aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg0tg8bss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 11:44:05 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32MBVTKF005154;
        Wed, 22 Mar 2023 11:44:04 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg0tg8bsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 11:44:04 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32MAAD9A025032;
        Wed, 22 Mar 2023 11:44:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6cw0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 11:44:02 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32MBhxFR3015380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 11:43:59 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36D952004B;
        Wed, 22 Mar 2023 11:43:59 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB62120043;
        Wed, 22 Mar 2023 11:43:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Mar 2023 11:43:58 +0000 (GMT)
Date:   Wed, 22 Mar 2023 12:43:57 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, david@redhat.com,
        borntraeger@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: Add Nico as s390x
 Maintainer and make Thomas reviewer
Message-ID: <20230322124357.1fb49349@p-imbrenda>
In-Reply-To: <20230322113400.1123378-1-frankja@linux.ibm.com>
References: <20230322113400.1123378-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DZtgneDyqVhYBkhOs2r1eEiboC-8NplS
X-Proofpoint-ORIG-GUID: o1lKlCaj1d9ElHfog1WmAHBq505jjwAy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_08,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0
 spamscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303220082
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Mar 2023 11:34:00 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The circle of life continues as we bring in Nico as a s390x
> maintainer. Thomas moves from the maintainer position to reviewer but
> he's a general maintainer of the project anyway.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 649de509..bd1761db 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -85,11 +85,12 @@ F: lib/powerpc/
>  F: lib/ppc64/
> =20
>  S390X
> -M: Thomas Huth <thuth@redhat.com>
>  M: Janosch Frank <frankja@linux.ibm.com>
>  M: Claudio Imbrenda <imbrenda@linux.ibm.com>
> +M: Nico B=C3=B6hr <nrb@linux.ibm.com>
>  S: Supported
>  R: David Hildenbrand <david@redhat.com>
> +R: Thomas Huth <thuth@redhat.com>
>  L: kvm@vger.kernel.org
>  L: linux-s390@vger.kernel.org
>  F: s390x/

