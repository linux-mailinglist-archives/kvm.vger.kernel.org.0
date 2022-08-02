Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DF558778C
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiHBHKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiHBHKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:10:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC0122BE3
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:10:43 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2725hpBW000384
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=SyR1XupQtXZx+xvej3X2VyXFptI5CUb2WVnnqQ+F87w=;
 b=qM/trQKlKkroDToDh6PLK+07aX08vC7fi86KdMWmlaiO6QI1Q52lyS9GHFcMHZsW5BTl
 zaCnsPWXDIHpUTLjrsSqJYAczvD14bwRnLtR30NwJk4zObFOR6scumWrIA9OEaBiuD1L
 9Ath1UdpGXFl60HjTqVvc9TKxwASPHvHWmZ9x6/Da1qLBxqpBW/Cdu+x63NwYTLPCiv4
 fbwbOFv1s7sUdDuguCqI1cWpuRsnDKdz9I/COv11taUQqCIH+5OpDkIB6ECfvfca4ZoV
 OOuBntmvxAC0W4rTe6rt9RaA6T1K2kh4byx2GvgT1IstVcKBOf0DGNi4RZprdCLVtgwk 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpx1ftd9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 07:10:42 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2726UxAu017913
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:10:42 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpx1ftd7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:10:42 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27277pQ6026736;
        Tue, 2 Aug 2022 07:10:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3hmuwhs8f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:10:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2727AZf231523234
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 07:10:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 833774C044;
        Tue,  2 Aug 2022 07:10:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65F364C040;
        Tue,  2 Aug 2022 07:10:35 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.89.124])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Aug 2022 07:10:35 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220729082633.277240-2-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com> <20220729082633.277240-2-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: snippets: asm: Add a macro to write an exception PSW
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165942423514.253051.2592124003163681093@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 02 Aug 2022 09:10:35 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Aqu-c_j0NzQl7ozZ0AWmduUqQ-BYGqGf
X-Proofpoint-ORIG-GUID: UkrI9WSyAjZkrvSfNPbP2-kwR0Ww_YXS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_03,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208020033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-07-29 10:26:28)
[...]
> diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets/as=
m/snippet-pv-diag-500.S
> index 8dd66bd9..f4d75388 100644
> --- a/s390x/snippets/asm/snippet-pv-diag-500.S
> +++ b/s390x/snippets/asm/snippet-pv-diag-500.S
> @@ -8,6 +8,7 @@
>   *  Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <asm/asm-offsets.h>
> +#include "macros.S"
>  .section .text
> =20
>  /* Clean and pre-load registers that are used for diag 500 */
> @@ -21,10 +22,7 @@ lghi %r3, 3
>  lghi   %r4, 4
> =20
>  /* Let's jump to the next label on a PGM */
> -xgr    %r5, %r5
> -stg    %r5, GEN_LC_PGM_NEW_PSW

So previously the PSW mask was zero and hence we had 24-bit addressing, no?=
 Now, we have bits 31 and 32 one and hence 64 bit addressing.

I guess 24-bit addressing is not appropriate here (or at least doesn't matt=
er too much), so I guess this is intended, isn't it?
