Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B746BED1F
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 16:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCQPiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 11:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjCQPiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 11:38:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26171C9241;
        Fri, 17 Mar 2023 08:37:11 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HFKPPp026371;
        Fri, 17 Mar 2023 15:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=a7ntQJbQPgOXMde984PVzuSXXsFFIyQM34l6dBw4vVQ=;
 b=WWLTP32JqPgj6sZfwUOBcEcOqULIsWJeb14sbJYgbWZgphielDkmTrk4b0GIeQKXyDLo
 bQpMwaCMYknIuj1NqzGpunETwuHZST/J5Iyydh0QN/A0t1WFo1e9BQlAgod9Sh1WPguR
 7VJBsQdJZrlC/wz3U2eHfwU+4EgP64iJqFADpib/ClGwob8uAlP13B/3009qjzzDnPGg
 mroQ6G9zxJRlVRgJQcQkXQx5U02cwHqD/+TsyZWqdM37Fxpbyr11UijOSdumexwTNgWy
 /AD8XSn4dtrkBZTgwk6UPVPNbpe50Q7d0+726+E2EOTWllSsf5Q3TbGiIagfay99Yp1V 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pctrvgdua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 15:37:03 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32HFL3LI026765;
        Fri, 17 Mar 2023 15:37:02 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pctrvgdsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 15:37:02 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32HEV1oq029586;
        Fri, 17 Mar 2023 15:37:00 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3pbs5ssydf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 15:37:00 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HFavYB25559638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 15:36:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 167D62004B;
        Fri, 17 Mar 2023 15:36:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C4482004D;
        Fri, 17 Mar 2023 15:36:56 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.92.234])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 17 Mar 2023 15:36:56 +0000 (GMT)
Date:   Fri, 17 Mar 2023 16:36:54 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x/spec_ex: Add test of
 EXECUTE with odd target address
Message-ID: <20230317163654.211830c0@p-imbrenda>
In-Reply-To: <8deaddfe-dc69-ec3c-4c8c-a76ee17e6513@redhat.com>
References: <20230315155445.1688249-1-nsg@linux.ibm.com>
        <20230315155445.1688249-4-nsg@linux.ibm.com>
        <86aa2246-07ff-8fb9-ad97-3b68e8b8f109@redhat.com>
        <8deaddfe-dc69-ec3c-4c8c-a76ee17e6513@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QvWd8gBWadeFXVb1N7AxST5BJEgR72-D
X-Proofpoint-GUID: GrIWu-o-o3tgsj3-d-jDxxUO_HLJwg6F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_10,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 adultscore=0 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Mar 2023 15:11:35 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 17/03/2023 15.09, Thomas Huth wrote:
> > On 15/03/2023 16.54, Nina Schoetterl-Glausch wrote: =20
> >> The EXECUTE instruction executes the instruction at the given target
> >> address. This address must be halfword aligned, otherwise a
> >> specification exception occurs.
> >> Add a test for this.
> >>
> >> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> >> ---
> >> =C2=A0 s390x/spec_ex.c | 25 +++++++++++++++++++++++++
> >> =C2=A0 1 file changed, 25 insertions(+)
> >>
> >> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> >> index 83b8c58e..5fa05dba 100644
> >> --- a/s390x/spec_ex.c
> >> +++ b/s390x/spec_ex.c
> >> @@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> >> =C2=A0 }
> >> +static int odd_ex_target(void)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 uint64_t pre_target_addr;
> >> +=C2=A0=C2=A0=C2=A0 int to =3D 0, from =3D 0x0dd;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 asm volatile ( ".pushsection .text.ex_odd\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 .balig=
n=C2=A0=C2=A0=C2=A0 2\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "pre_odd_ex_target:\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 . =3D =
. + 1\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 lr=C2=
=A0=C2=A0=C2=A0 %[to],%[from]\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 .popse=
ction\n"
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 larl=
=C2=A0=C2=A0=C2=A0 %[pre_target_addr],pre_odd_ex_target\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 ex=C2=
=A0=C2=A0=C2=A0 0,1(%[pre_target_addr])\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : [pre_target_addr] "=3D&a=
" (pre_target_addr),
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [to] "+d" (to)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : [from] "d" (from)
> >> +=C2=A0=C2=A0=C2=A0 );
> >> +
> >> +=C2=A0=C2=A0=C2=A0 assert((pre_target_addr + 1) & 1);
> >> +=C2=A0=C2=A0=C2=A0 report(to !=3D from, "did not perform ex with odd =
target");
> >> +=C2=A0=C2=A0=C2=A0 return 0;
> >> +} =20
> >=20
> > Can this be triggered with KVM, or is this just a test for TCG? =20
>=20
> With "triggered" I mean: Can this cause an interception in KVM?

AFAIK no, but KVM and TCG are not the only things we might want to test.

we are aware of the TCG tests, and we would like to also keep the KVM
unit tests.

>=20
>   Thomas
>=20

