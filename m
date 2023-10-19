Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F167CFE88
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346368AbjJSPom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346319AbjJSPok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:44:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFB5134
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:44:39 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39JFhlGS029744;
        Thu, 19 Oct 2023 15:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=gicwwa+4owEk7xF+7uUifdqgjmZqL+jJyIRMP8YyACo=;
 b=VAMxL8v6RAfatYzPmOD4bcOPhhTSqv1Fkv8m27RmPyzb9aOI84NoWI3QLa718kZXgbdq
 vnaxnsYBF5FHlpCTzyHjEyvsicYM58AoIFbHGrjJk099tMFX6EQSdBscCX6aorTlZRvp
 46AM9X7ROIUN8OJqJnDOaRTAWH7eQ/r+SjxN/gTqIXODbOOQTc5EOwNbZHagM9af1DEy
 GQ/TDS5P+LMgjlrCkne6iKvOgceqwN8Bk5OO4xjJRvF051fFdz3Ok4squCluPIBnFiZn
 sZEDky4/JK49ASxqHbmNHILMsWOiFnQTa5nrdiYTOCvtSHEdfLpAZC4DIVY6j+Dp46iU aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tu7938753-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 15:44:31 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39JFhwBu030659;
        Thu, 19 Oct 2023 15:44:06 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tu79385r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 15:44:03 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39JDXYTs027394;
        Thu, 19 Oct 2023 15:42:29 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tr5ast1dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 15:42:29 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39JFgQDY22938276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 15:42:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C01C92004D;
        Thu, 19 Oct 2023 15:42:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 350FC20040;
        Thu, 19 Oct 2023 15:42:26 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.84.173])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Oct 2023 15:42:26 +0000 (GMT)
Message-ID: <11b07b21ae41338a0ee02611b9a38980fbba562d.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 8/9] scripts: Implement multiline strings
 for extra_params
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Date:   Thu, 19 Oct 2023 17:42:25 +0200
In-Reply-To: <169771265170.80077.4366013508884229494@t14-nrb>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
         <20231011085635.1996346-9-nsg@linux.ibm.com>
         <169771265170.80077.4366013508884229494@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IUIX5J8-0lhwRiCDEC0CE6VkH6Nfp2hE
X-Proofpoint-GUID: lQDOJVNtdZsYiNr93IjYqppxlqVL7C9a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_15,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-10-19 at 12:50 +0200, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2023-10-11 10:56:31)
> > Implement a rudimentary form only.
> > extra_params can get long when passing a lot of arguments to qemu.
> > Multiline strings help with readability of the .cfg file.
> > Multiline strings begin and end with """, which must occur on separate
> > lines.
> >=20
> > For example:
> > extra_params =3D """-cpu max,ctop=3Don -smp cpus=3D1,cores=3D16,maxcpus=
=3D128 \
> > -append '-drawers 2 -books 2 -sockets 2 -cores 16' \
> > -device max-s390x-cpu,core-id=3D31,drawer-id=3D0,book-id=3D0,socket-id=
=3D0"""
> >=20
> > The command string built with extra_params is eval'ed by the runtime
> > script, so the newlines need to be escaped with \.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >=20
> >=20
> > This could certainly be done differently, suggestions welcome.
>=20
> I honestly do not have a better idea. If someone has, please bring it up!
>=20
> [...]
> > diff --git a/scripts/common.bash b/scripts/common.bash
> > index 7b983f7d..738e64af 100644
> > --- a/scripts/common.bash
> > +++ b/scripts/common.bash
> > @@ -36,6 +36,17 @@ function for_each_unittest()
> >                         kernel=3D$TEST_DIR/${BASH_REMATCH[1]}
> >                 elif [[ $line =3D~ ^smp\ *=3D\ *(.*)$ ]]; then
> >                         smp=3D${BASH_REMATCH[1]}
> > +               elif [[ $line =3D~ ^extra_params\ *=3D\ *'"""'(.*)$ ]];=
 then
> > +                       opts=3D${BASH_REMATCH[1]}$'\n'
> > +                       while read -r -u $fd; do
>=20
> I was actually unaware that read saves into REPLY by default and went
> looking for the REPLY variable to no avail. Can we make this more explici=
t
> like so:
>=20
> while read -r -u $fd LINE; do
>=20
> and replace REPLY with LINE below?

No, at least it's not so simple. man bash says:
If no names are supplied, the line read, *without the ending delimiter but =
otherwise unmodified*,
is assigned to the variable REPLY.
We don't want word splitting and white space being removed.
>=20
> > +                               opts=3D${opts%\\$'\n'}
>=20
> So we strip the \ at the end of the line, but if it's not there we preser=
ve

We strip backslash newline, yes.
This way it's up to you if you want newlines in the string or not.
A bit of future proofing.
That is the only escaping I implemented, so right now you cannot have an
actual backslash at the end of the line.
The string is later eval'ed by bash which also does escaping,
but we cannot just rely on that, because by that time the last \n has
been dropped. If you had a backslash before you'll run into trouble.

> the line break? Is there a reason to do it this way? Why do we need the \
> at all, as far as I can see """ terminates the multi line string, so what=
's
> the purpose?
>=20
> Did you test this in standalone mode?

I did not.

