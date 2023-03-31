Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085316D1940
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 10:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjCaIDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 04:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbjCaIDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 04:03:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329D210273
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 01:03:24 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V6eMjo001798
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:03:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=S9ufKjLfJku3ZJr1b5oe6VKo8F2Gx07dq16R1z+lts4=;
 b=argE5FHenEg2M7I+DJbFYJCLzaSploeQDnX6VnSEL1JhfShWGYoUidpBk/4diFxc8fGq
 ht02Ia51/40lW7Yb4FzDZKON4FwzmEYY29JNJGivh68Zk5DAF5aIZRDsH0zEoZdlSAJL
 9oXxdR8c2pKqWXkGHZLjGm4Xj+feO1AuKskq2uJyyfY5U1BzWAduTp6IBReQ3T4gugpp
 zU9y9/dnSVXjnd9A29xWnRvYMzRGxlxc0XzZzTCdf0yfoRQ7gvu4t5A2/kEX1+NpVX4k
 yj2o7cLH+ZXF/fi+2/ZvM99rJvys3HPMGGLsayzduARxbJ2ltcWe82hP71XMVuLV0G/R uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnssajhmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:03:23 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32V7IRc4014072
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:03:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnssajhfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 08:03:22 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UM4LS9019418;
        Fri, 31 Mar 2023 08:03:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6pk4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 08:03:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32V83AHv23396858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 08:03:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF60820040;
        Fri, 31 Mar 2023 08:03:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 263D920043;
        Fri, 31 Mar 2023 08:03:10 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.68.115])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Mar 2023 08:03:10 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/7] s390x: define a macro for the
 stack frame size
In-Reply-To: <168024782639.521366.8153497247119888695@t14-nrb>
References: <20230307091051.13945-1-mhartmay@linux.ibm.com>
 <20230307091051.13945-7-mhartmay@linux.ibm.com>
 <168024782639.521366.8153497247119888695@t14-nrb>
Date:   Fri, 31 Mar 2023 10:03:08 +0200
Message-ID: <87h6u1ny9v.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C15gpyCCGAZByH5-2xQY9tN7EcdIgAH6
X-Proofpoint-GUID: Nq3Q3RnFJK-uRNf8OSw8uLnHb-RHpa0z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_04,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1011 phishscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310061
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nico Boehr <nrb@linux.ibm.com> writes:

> Hi Marc, Nina,
>
> Quoting Marc Hartmayer (2023-03-07 10:10:50)
>> Define and use a macro for the stack frame size. While at it, fix
>> whitespace in the `gs_handler_asm` block.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> Co-developed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>
> this commit breaks cross-compilation on x86 for me.
>
> Steps to reproduce:
>
> $ mkdir build
> $ cd build
> $ ../configure --arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-
> $ make -j16
>
> Error is:
> In file included from /builds/Nico-Boehr/kvm-unit-tests/lib/s390x/interru=
pt.c:12:
> /builds/Nico-Boehr/kvm-unit-tests/lib/s390x/asm/asm-offsets.h:8:10: fatal=
 error: generated/asm-offsets.h: No such file or directory
>     8 | #include <generated/asm-offsets.h>
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> make: *** [<builtin>: lib/s390x/interrupt.o] Error 1
> make: *** Waiting for unfinished jobs....
>
> Can you take care of this? It prevents me from sending the next pull
> request.

Thanks for reporting this. Commit 6ef5785d30e8 ("s390x/Makefile:
refactor CPPFLAGS") broke it. I will be sending a fix for this soon.

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
