Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64AE671879
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 11:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjARKFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 05:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjARKDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 05:03:23 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51F1654D6
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 01:10:46 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I7psAv027497
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:10:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0blLFXXNcuQjhYEvepFSjHJjmSXYDuy4Fs4I9l818Bc=;
 b=N3zUdeBp8IKy9nYXxiRHmCoDcHvlebgYjPyq1iNqVT5ZznGGLLR2qDe/XAQ8vPeT8k0V
 PbHhakxU19qJzNWXjvIfE8Ic8sNIKaicjZN0cT/Tga1Oxj8o+x4IA2W1MGwTBKcNyVYT
 uvspRD4vvrWV7La4EOiWlIXlMjVaoZI2mroVuKPXP5spEuIfmLkhcGOVW6UdMIFJ3viX
 Byyb742oFDDCWJXmmwu566kIntU00SOSZ730A+ZWQtdLPhr4F2pXo5KCNQRhfHmcE/QC
 JM3weZR3L8gePdyM53TP/0IvO4Y9k6oWkpvhH1m4/NWrVsj/SXxSjqUYL+oQML9YRfaq 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6a2m553c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:10:45 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30I8l36l021557
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:10:45 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6a2m552n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:10:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30HMZ3pC009485;
        Wed, 18 Jan 2023 09:10:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfn16v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:10:43 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30I9AdU347055128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 09:10:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7EAD2004B;
        Wed, 18 Jan 2023 09:10:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F20120043;
        Wed, 18 Jan 2023 09:10:39 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.179.30.151])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Jan 2023 09:10:39 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 8/9] s390x: use STACK_FRAME_SIZE macro in
 linker scripts
In-Reply-To: <20230116175757.71059-9-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
 <20230116175757.71059-9-mhartmay@linux.ibm.com>
Date:   Wed, 18 Jan 2023 10:10:38 +0100
Message-ID: <87cz7cmcmp.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pXFEoMB03ggpn1GNVWMJYnGK7IRnPZZO
X-Proofpoint-ORIG-GUID: U895h8G_pGxmjtSt8-fdUsmS1zVrw-3F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_03,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc Hartmayer <mhartmay@linux.ibm.com> writes:

> Use the `STACK_FRAME_SIZE` macro instead of a hard-coded value of 160.
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  s390x/flat.lds.S            | 4 +++-
>  s390x/snippets/c/flat.lds.S | 6 ++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/s390x/flat.lds.S b/s390x/flat.lds.S
> index 952f6cd457ed..0cb7e383cc76 100644
> --- a/s390x/flat.lds.S
> +++ b/s390x/flat.lds.S
> @@ -1,3 +1,5 @@
> +#include <asm/asm-offsets.h>
> +
>  SECTIONS
>  {
>  	.lowcore : {
> @@ -44,6 +46,6 @@ SECTIONS
>  	/*
>  	 * stackptr set with initial stack frame preallocated
>  	 */
> -	stackptr =3D . - 160;
> +	stackptr =3D . - STACK_FRAME_SIZE;

One small fix: After this change the =E2=80=98$(asm-offsets)=E2=80=98 depen=
dency has to
be added to to %.lds target rule in the Makefile.

[=E2=80=A6snip]

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
