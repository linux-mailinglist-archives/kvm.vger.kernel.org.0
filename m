Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988E76D1895
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 09:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjCaHah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 03:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCaHaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 03:30:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FD9C14A
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 00:30:33 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V5eEmf021635
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 07:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=1B1CDqbqVdSYaLcyW/xeHidaWORwwNMFlbymJhIf3Gs=;
 b=BOV42jt6ugx6CP8jQv/e6L6fGt8b0kSD0VtBBbksSn9JiKPQT09GHMHMPB78mIpnDJGL
 +10KVQ4QfTc4+UXreWUvp/MHt+z2xz0sDK6p8BpRY1MqmaNFhEf71CJ8j/ba8pAS/0cf
 eCOLAcmGDlKri5v1B+fX1vJpRp9jfUuAjYYT07J55a5RqTMC7RlVa1smQmvyF0jVTRvM
 VWSwDVEZIovW/36ng90vy/zk3sBGsdJSLpQ9mLOtwwRfLov9ZJ+lvhyIx5qeGyY5+7PV
 mxaQPHT64CZARSEYEvC1+gl78Y/AzN8Pkzjvy49Uewls+jnJepWfzu5PhgnbQnVINRMp yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnp8k60kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 07:30:32 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32V7AwPI014563
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 07:30:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnp8k60jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 07:30:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32U3vZxE006447;
        Fri, 31 Mar 2023 07:30:30 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3phrk6wapq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 07:30:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32V7UQiW65274168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 07:30:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2D1020040;
        Fri, 31 Mar 2023 07:30:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1F8020063;
        Fri, 31 Mar 2023 07:30:26 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.12.80])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 07:30:26 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230307091051.13945-7-mhartmay@linux.ibm.com>
References: <20230307091051.13945-1-mhartmay@linux.ibm.com> <20230307091051.13945-7-mhartmay@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 6/7] s390x: define a macro for the stack frame size
Message-ID: <168024782639.521366.8153497247119888695@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 31 Mar 2023 09:30:26 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hd0gKLPoL8qIVAhG7jhePY7AGs4qRjuC
X-Proofpoint-GUID: jNsKU5UJq13KmgbnQkzt7K6FF6RXj9t-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_02,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310058
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc, Nina,

Quoting Marc Hartmayer (2023-03-07 10:10:50)
> Define and use a macro for the stack frame size. While at it, fix
> whitespace in the `gs_handler_asm` block.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Co-developed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

this commit breaks cross-compilation on x86 for me.

Steps to reproduce:

$ mkdir build
$ cd build
$ ../configure --arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-
$ make -j16

Error is:
In file included from /builds/Nico-Boehr/kvm-unit-tests/lib/s390x/interrupt=
.c:12:
/builds/Nico-Boehr/kvm-unit-tests/lib/s390x/asm/asm-offsets.h:8:10: fatal e=
rror: generated/asm-offsets.h: No such file or directory
    8 | #include <generated/asm-offsets.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make: *** [<builtin>: lib/s390x/interrupt.o] Error 1
make: *** Waiting for unfinished jobs....

Can you take care of this? It prevents me from sending the next pull reques=
t.
