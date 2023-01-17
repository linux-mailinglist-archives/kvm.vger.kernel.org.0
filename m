Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9795B66DB11
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 11:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbjAQK3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 05:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236066AbjAQK3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 05:29:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F2832E5A
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:28:20 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30H9DrJi024002
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 10:28:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=AtA7oNB2VJmPOaaiv08qu8gM/SAC1CvPmkw0Yl6GM6c=;
 b=AY1fsvcJtkfJwh+ZnlyoXIZB8CVpRx2sSKuuBApWc891zpyhZqTwjfA5KSbfkGDoF8H+
 j6o9nyjDL/aXVZobg6jjMJaqnolRj9XRv04J8utY1J0ChOXk0o1wm0BRtZISRemxh6c/
 ulH4PjeBD/uXbvClqTsbJ0u0o22w3ykZgMwkM1dhrmg00wV2VvaareIz2kaM/GB9TYUN
 uDL2D3fIFqPst/ke6fXTuFnDq4CI2VtquEXdhyPTTmy+zwL7wBeubu8AQI8DwEaESARL
 vmLW/5koVXOYZqIPIacvYqNakwbLvnXfUPiN2tWpV2RfT81MHvOHNi19K0Oswbv6GkCt 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5kcarh5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 10:28:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HAQnNu024734
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 10:28:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5kcarh55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 10:28:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H88Foe005139;
        Tue, 17 Jan 2023 10:28:17 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16kp3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 10:28:16 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HASDbA51773852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 10:28:13 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 018B720065;
        Tue, 17 Jan 2023 10:28:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9B2720073;
        Tue, 17 Jan 2023 10:28:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 10:28:12 +0000 (GMT)
Date:   Tue, 17 Jan 2023 11:28:10 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 9/9] lib/linux/const.h: test for
 `__ASSEMBLER__` as well
Message-ID: <20230117112810.2dfafabf@p-imbrenda>
In-Reply-To: <87sfg94hzl.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
        <20230116175757.71059-10-mhartmay@linux.ibm.com>
        <20230116192507.0f422ee0@p-imbrenda>
        <87sfg94hzl.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DDuvbqfQmvYOEOMX3pcMJes0tfg9qTNL
X-Proofpoint-GUID: DYLu_veUs_pJoxIAXCchyOyExzhUKGqE
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_04,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301170085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Jan 2023 10:39:58 +0100
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> Claudio Imbrenda <imbrenda@linux.ibm.com> writes:
>=20
> > On Mon, 16 Jan 2023 18:57:57 +0100
> > Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
> >=20=20
> >> The macro `__ASSEMBLER__` is defined with value 1 when preprocessing
> >> assembly language using gcc. [1] For s390x, we're using the preprocess=
or
> >> for generating our linker scripts out of assembly file and therefore we
> >> need this change.
> >>=20
> >> [1] https://gcc.gnu.org/onlinedocs/cpp/Standard-Predefined-Macros.html
> >>=20
> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>=20=20
> >
> > is this patch really needed? if so, why is it at the end of the
> > series?=20=20
>=20
> It was needed for some other patches=E2=80=A6 and for upcoming patches it=
 is
> (probably) required since otherwise we cannot use macros using the _AC
> macro. So yep, it could be removed for now - and this was exactly the
> reason why I put it at the end of the series.
>=20
> Thanks for the feedback!

I don't see a problem adding this even if it's not used right now, but
in that case I want to know why you want to add it now :)

Just explain clearly in the patch description that this will be useful
in the future and why :)

>=20
> >=20=20
> >> ---
> >>  lib/linux/const.h | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>=20
> >> diff --git a/lib/linux/const.h b/lib/linux/const.h
> >> index c872bfd25e13..be114dc4a553 100644
> >> --- a/lib/linux/const.h
> >> +++ b/lib/linux/const.h
> >> @@ -12,7 +12,7 @@
> >>   * leave it unchanged in asm.
> >>   */
> >>=20=20
> >> -#ifdef __ASSEMBLY__
> >> +#if defined(__ASSEMBLY__) || defined(__ASSEMBLER__)
> >>  #define _AC(X,Y)	X
> >>  #define _AT(T,X)	X
> >>  #else=20=20
> >=20=20

