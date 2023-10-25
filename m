Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3DB7D72BD
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 19:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjJYR6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 13:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjJYR6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 13:58:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8866513D;
        Wed, 25 Oct 2023 10:58:44 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39PHlFgI026326;
        Wed, 25 Oct 2023 17:58:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=EZoU+WfcWf69CWY5+w/626tNpruCq3cLcwxPmd8V9h8=;
 b=F5wCOBAg1FqgoAHiUVnZHd73Ut+Uon+fbemAD1r0Gwb6cNEa1R/KDefYTaVE15t03LtL
 F4FozjqHrgtkp9+T5MxFYavOXQ7iEywhsZQ1JanqIjMaBv3prMMsjH50hxRH+LtNtTfk
 LUdOOBZNXXM7jFNM7d9dryp7xBrJErqTqOMMxVaiWcC/EI5o46odCcHsN6LywLrx6uyl
 jM6oik8r47XZHTWk53VREGXqwQmSRTRTi519wZU3RbKAsYpkhEKU3SohDl014K5MbeL6
 +J8BuyGZqgf4BcObdZ+tPIIiFAlWS+yD2rxbSVISTAR6lJfgYeHcfcSitZ31R3LLF4+O Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty7qrg9r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 17:58:33 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39PHlYcD027253;
        Wed, 25 Oct 2023 17:58:32 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty7qrg9qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 17:58:32 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39PGmebP024365;
        Wed, 25 Oct 2023 17:58:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvu6k82wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 17:58:31 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39PHwSUk22676028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 17:58:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D86520040;
        Wed, 25 Oct 2023 17:58:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB3D32004B;
        Wed, 25 Oct 2023 17:58:27 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.22.157])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 25 Oct 2023 17:58:27 +0000 (GMT)
Message-ID: <9891f55d84cb16748003ff202136172ed59c26a5.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 09/10] scripts: Implement multiline
 strings for extra_params
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Date:   Wed, 25 Oct 2023 19:58:27 +0200
In-Reply-To: <9b525819-f284-43fd-8093-3856dcc6d288@redhat.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
         <20231020144900.2213398-10-nsg@linux.ibm.com>
         <9b525819-f284-43fd-8093-3856dcc6d288@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0c5ujz-pI9cdUABZQIV_bZjoQA0RHPwj
X-Proofpoint-GUID: QFKA9Z0a6wnSGjBP7SbEY0Zla8Zrg1pF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_07,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310170001 definitions=main-2310250156
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-10-25 at 19:50 +0200, Thomas Huth wrote:
> On 20/10/2023 16.48, Nina Schoetterl-Glausch wrote:
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
> >   scripts/common.bash  | 16 ++++++++++++++++
> >   scripts/runtime.bash |  4 ++--
> >   2 files changed, 18 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/scripts/common.bash b/scripts/common.bash
> > index 7b983f7d..b9413d68 100644
> > --- a/scripts/common.bash
> > +++ b/scripts/common.bash
> > @@ -36,6 +36,22 @@ function for_each_unittest()
> >   			kernel=3D$TEST_DIR/${BASH_REMATCH[1]}
> >   		elif [[ $line =3D~ ^smp\ *=3D\ *(.*)$ ]]; then
> >   			smp=3D${BASH_REMATCH[1]}
> > +		elif [[ $line =3D~ ^extra_params\ *=3D\ *'"""'(.*)$ ]]; then
> > +			opts=3D${BASH_REMATCH[1]}$'\n'
> > +			while read -r -u $fd; do
> > +				#escape backslash newline, but not double backslash
> > +				if [[ $opts =3D~ [^\\]*(\\*)$'\n'$ ]]; then
> > +					if (( ${#BASH_REMATCH[1]} % 2 =3D=3D 1 )); then
> > +						opts=3D${opts%\\$'\n'}
> > +					fi
> > +				fi
> > +				if [[ "$REPLY" =3D~ ^(.*)'"""'[:blank:]*$ ]]; then
> > +					opts+=3D${BASH_REMATCH[1]}
> > +					break
> > +				else
> > +					opts+=3D$REPLY$'\n'
> > +				fi
> > +			done
>=20
> Phew, TIL that there is something like $'\n' in bash ...
> Now with that knowledge, the regular expression make sense 8-)

Uh yeah, it's very write only, with backslash escaping, " inside ' and $'\n=
'.
>=20
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>=20
Thanks!
