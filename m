Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968A866DA2B
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 10:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbjAQJmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 04:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbjAQJlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 04:41:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAE5234C3
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 01:40:07 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30H92COh006336
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DNOQCRbNqrlAUrK5O9NDKyOpgshZ7OTs43F1dQHAFJk=;
 b=WJU4cgeIwi6xSzz9Qp3rPhapkLz1hPubMk4MZ5GTJ/NoGYv6qC8i6fCskxx0h1WFSf86
 V2F94z0Z8UrLzmxasbwSkBiUDaCc/3cksiAqIVNzNfxZjlODQKreY8DzfTcsOQUTgjdL
 9yomdb2apo9SVUVbZs22pvRHZS6yawIIGRPZuOiv7J9BTFS6oQZok4wvmlAqWl+QJT2B
 lNwxCW2Tk2Kw/9c1JSpvMqxXUIpBFwFGMPAfKKjlIvMhyNhmKWV/VUI72obGCWGQ1Ptv
 KeNWOa/Kxtb9JfumA1vnFBut9Ydu5Q0m7+HTP3mQiPyeTDy+1G4e6bFQoIfn+utLvqhe kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5peguyfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:40:06 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30H9Oid0007879
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:40:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5peguyen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 09:40:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H8xBXd006324;
        Tue, 17 Jan 2023 09:40:04 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfkmaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 09:40:04 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30H9e0Gu14483930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 09:40:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ACBE2004D;
        Tue, 17 Jan 2023 09:40:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA70D20049;
        Tue, 17 Jan 2023 09:39:59 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.42.101])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Jan 2023 09:39:59 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 9/9] lib/linux/const.h: test for
 `__ASSEMBLER__` as well
In-Reply-To: <20230116192507.0f422ee0@p-imbrenda>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
 <20230116175757.71059-10-mhartmay@linux.ibm.com>
 <20230116192507.0f422ee0@p-imbrenda>
Date:   Tue, 17 Jan 2023 10:39:58 +0100
Message-ID: <87sfg94hzl.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
Content-Type: text/plain; charset=utf-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G2zGU9M8wd1bgLubo9nZKgBOqY12ObkS
X-Proofpoint-ORIG-GUID: o3cNChF5juF1cyKOe_bP2jo7zZevBIaV
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_04,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 impostorscore=0 spamscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio Imbrenda <imbrenda@linux.ibm.com> writes:

> On Mon, 16 Jan 2023 18:57:57 +0100
> Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
>
>> The macro `__ASSEMBLER__` is defined with value 1 when preprocessing
>> assembly language using gcc. [1] For s390x, we're using the preprocessor
>> for generating our linker scripts out of assembly file and therefore we
>> need this change.
>>=20
>> [1] https://gcc.gnu.org/onlinedocs/cpp/Standard-Predefined-Macros.html
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>
> is this patch really needed? if so, why is it at the end of the
> series?

It was needed for some other patches=E2=80=A6 and for upcoming patches it is
(probably) required since otherwise we cannot use macros using the _AC
macro. So yep, it could be removed for now - and this was exactly the
reason why I put it at the end of the series.

Thanks for the feedback!

>
>> ---
>>  lib/linux/const.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/lib/linux/const.h b/lib/linux/const.h
>> index c872bfd25e13..be114dc4a553 100644
>> --- a/lib/linux/const.h
>> +++ b/lib/linux/const.h
>> @@ -12,7 +12,7 @@
>>   * leave it unchanged in asm.
>>   */
>>=20=20
>> -#ifdef __ASSEMBLY__
>> +#if defined(__ASSEMBLY__) || defined(__ASSEMBLER__)
>>  #define _AC(X,Y)	X
>>  #define _AT(T,X)	X
>>  #else
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
