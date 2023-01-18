Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E88167175D
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjARJVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjARJU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:20:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096F338B5E
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 00:37:55 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I5gAjA022794
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:37:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=d0O54qbq+uVP8uslu1em6WybW7uI0SEes3v+6MNPS00=;
 b=Hp43uWIr5SNT4LChHW9tQiEHO6qJWN70AgJLZ67V8T0WLgxfJTF48kGYQjRriQiEnjTe
 KB7ehB/V3By37NQD6ppxbeUnRjaiOPSoRnWCQqtcSewZkuiHlvsFSczxZN4SRqJ87NM3
 yVUQVbUzlC8vcm+F4/lU0nABqToUTxyDPTSuFvEJATkr6AdFJgZt3p7vU4fXxhtU7nxN
 QFn8K5u3TRO6q10jbkt7qy2VX9SChf8TKTiYYsDjajPdyUut/pBB8gqCl6fozEOgGVND
 92/aivSYDT0bSs714vSHfXQVGYHVvyNsXfeUaPSsn/KdZHgOzGs/gm6Xkk8PYNyAjI5r fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6aup3g0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:37:54 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30I84r4r002836
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:37:54 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6aup3fyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 08:37:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30HMHJrY006209;
        Wed, 18 Jan 2023 08:37:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfmyu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 08:37:51 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30I8bmuq38470112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 08:37:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 348EE20049;
        Wed, 18 Jan 2023 08:37:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD44720040;
        Wed, 18 Jan 2023 08:37:47 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.179.30.151])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Jan 2023 08:37:47 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/9] s390x/Makefile: fix `*.gbin` target
 dependencies
In-Reply-To: <2a84da8c-1a02-e303-e58a-454de0de6792@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
 <20230116175757.71059-4-mhartmay@linux.ibm.com>
 <2a84da8c-1a02-e303-e58a-454de0de6792@linux.ibm.com>
Date:   Wed, 18 Jan 2023 09:37:46 +0100
Message-ID: <878ri0kzl1.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bi_hrCTjLi4tndicJmoaN-Ixs0lQGROx
X-Proofpoint-ORIG-GUID: CyHQNbUImaBf8y5Soh96AMY6XSK9qT4r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_03,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 priorityscore=1501 phishscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Janosch Frank <frankja@linux.ibm.com> writes:

> On 1/16/23 18:57, Marc Hartmayer wrote:
>> If the linker scripts change, then the .gbin binaries must be rebuilt.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>   s390x/Makefile | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 660ff06f1e7c..b6bf2ed99afd 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -135,12 +135,12 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(a=
sm-offsets)
>>   $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>>   	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>>=20=20=20
>> -$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
>> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SRCDIR)/s390x/snipp=
ets/asm/flat.lds
>
> Any reason why you didn't use the shorter:
> $(SNIPPET_DIR)/asm/flat.lds ?

No - it was just copied from the rule without thinking further :)

>
>
>>   	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $<
>>   	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data"=
 -j ".bss" --set-section-flags .bss=3Dalloc,load,contents $@ $@
>>   	truncate -s '%4096' $@
>>=20=20=20
>> -$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
>> +$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS=
) $(SRCDIR)/s390x/snippets/c/flat.lds
>>   	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $< $(sn=
ippet_lib) $(FLATLIBS)
>>   	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data"=
 -j ".bss" --set-section-flags .bss=3Dalloc,load,contents $@ $@
>>   	truncate -s '%4096' $@
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
