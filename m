Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A766D1D9B
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 12:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjCaKGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 06:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjCaKFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 06:05:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE3625565
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 02:59:59 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V9Bx2D014229
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:59:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=8XNVxtxe2xhR1Ijb2+kIfk66ifNRPYTTeMBT4LZfXm4=;
 b=qZRY23Bff2NAizgMrW0iQcsP3HQeJ6zZkqBpxJGscRyfUUdI3Mc1tT3l3TIkHizMonLk
 nV27oeYMTAN9m2w0q/pbU29yBJ0rhBA2qiR2g6rEYdOIf0NDiZrULnFVKLgon5whb6+m
 5divEUVjKrYmmwrtlCmauXQbmoPvEZcwmaeE62yxph1yDgAK6L97lVdrJ5hHf1GO0Ycx
 82lzuZtPV0BleIXCgEP22tC3IWJGGwbdaNw7YRn26mjx1RDz7esmB3Or3c/0CSoyOREN
 g7Z6XN2ykX9PkJ6JrOfPANUKuh3X8LV+8nbHznt+YBH8zGU3rMLyEYPywInNUs13X3vX Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnvny91jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:59:36 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32V9DGEa022587
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:59:36 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnvny91j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 09:59:36 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32V6sKwH031815;
        Fri, 31 Mar 2023 09:59:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3phrk6dds0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 09:59:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32V9xUmT48366310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 09:59:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EFDF20049;
        Fri, 31 Mar 2023 09:59:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9408B20040;
        Fri, 31 Mar 2023 09:59:29 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.68.115])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Mar 2023 09:59:29 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v4] s390x/Makefile: refactor CPPFLAGS
In-Reply-To: <168025540813.521366.8353031165543177822@t14-nrb>
References: <168024782639.521366.8153497247119888695@t14-nrb>
 <20230331082709.35955-1-mhartmay@linux.ibm.com>
 <168025540813.521366.8353031165543177822@t14-nrb>
Date:   Fri, 31 Mar 2023 11:59:28 +0200
Message-ID: <87wn2x5ji7.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7TuhZ6oVrnNi15t2SUpjMucD9bbv2Xt-
X-Proofpoint-GUID: ThCbwVMgKQJVDZMT9Aot9ZX6g13kvdWe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_05,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nico Boehr <nrb@linux.ibm.com> writes:

> Quoting Marc Hartmayer (2023-03-31 10:27:09)
>> This change makes it easier to reuse them. While at it, add a comment
>> why the `lib` include path is required.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  s390x/Makefile | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 71e6563bbb61..06720aace828 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -63,9 +63,14 @@ test_cases: $(tests)
>>  test_cases_binary: $(tests_binary)
>>  test_cases_pv: $(tests_pv_binary)
>>=20=20
>> +INCLUDE_PATHS =3D $(SRCDIR)/lib $(SRCDIR)/lib/s390x
>> +# Include generated header files (e.g. in case of out-of-source builds)
>> +INCLUDE_PATHS +=3D lib=20
>
> Do you mind if I fix this up during picking?

Please fix it, thanks.

>
> ERROR: trailing whitespace
> #35: FILE: s390x/Makefile:68:
> +INCLUDE_PATHS +=3D lib $
--
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
