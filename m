Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617C07CF1CA
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 09:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbjJSH4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 03:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbjJSHz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 03:55:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09290D59
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 00:55:37 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39J7bMnE005715
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 07:55:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=tLYMt84WHkTmOGrttWjoMzgr0BC5s6vafzcYGIB/kSo=;
 b=CKPeD1XH0E2rtAjY6eVmkwGI5XNOrj19mt77P2HOVmgyJRyZ9WZB7nqwfDdviGSBjrwi
 00sm0J/pQRgg/tQzGVck/q8pPKrq9mDeWaTJ+BB+JsrPpr6LbeB4FnYkEThsvWlrPc7R
 R1LmQufqLQ9RRY1VMu0fr/qKnBNnO+a02jetzyPT1V2megwgWKF1seFFbPu5kf02JLSy
 9rh4wvG14XWztOo+d4DCCY5DLthCwcZTJahW0yAUUXofIUsNV4Sl3fmBwdSpldjKWPRt
 kDoV5cR9Ed0VjEKLy7GpYQzn0P7qwVr1uMNnMNHd0rzlaYaYbSXND+4GxKR9I4Oa6Ilb yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tu07rrfx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 07:55:37 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39J7oodl022579
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 07:55:37 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tu07rrfwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 07:55:36 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39J61Aon031184;
        Thu, 19 Oct 2023 07:55:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tr7hjy211-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 07:55:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39J7tYh46619856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 07:55:34 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F15F202AD;
        Thu, 19 Oct 2023 07:55:34 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77C21202A9;
        Thu, 19 Oct 2023 07:55:33 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.38.65])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Oct 2023 07:55:33 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <880f77b3-2af1-43fb-bfa9-a80a7fc8053c@redhat.com>
References: <20230725033937.277156-1-npiggin@gmail.com> <20230725033937.277156-3-npiggin@gmail.com> <169052965551.15205.2179571087904012453@t14-nrb> <CUFF6E1RB78K.QT91UG08M495@wheely> <169564046337.31925.7932230191015216618@t14-nrb> <880f77b3-2af1-43fb-bfa9-a80a7fc8053c@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] migration: Fix test harness hang if source does not reach migration point
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Message-ID: <169770213169.68756.904215339391644985@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 19 Oct 2023 09:55:31 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dwv8Ffy50QP9mNW19VA5KdE6Ydr3lzOy
X-Proofpoint-GUID: fcMDcnYRAj86OQLk49XTuY4DbgoHLSaw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_05,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 impostorscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-10-16 20:32:47)
> On 25/09/2023 13.14, Nico Boehr wrote:
> > Quoting Nicholas Piggin (2023-07-30 12:03:36)
> >> On Fri Jul 28, 2023 at 5:34 PM AEST, Nico Boehr wrote:
> >>> Quoting Nicholas Piggin (2023-07-25 05:39:36)
> >>>> After starting the test, the harness waits polling for "migrate" in =
the
> >>>> output. If the test does not print for some reason, the harness hang=
s.
> >>>>
> >>>> Test that the pid is still alive while polling to fix this hang.
> >>>>
> >>>> While here, wait for the full string "Now migrate the VM", which I t=
hink
> >>>> makes it more obvious to read and could avoid an unfortunate collisi=
on
> >>>> with some debugging output in a test case.
> >>>>
> >>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> >>>
> >>> Thanks for attempting to fix this!
> >>>
> >>>> ---
> >>>>   scripts/arch-run.bash | 10 +++++++++-
> >>>>   1 file changed, 9 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> >>>> index 518607f4..30e535c7 100644
> >>>> --- a/scripts/arch-run.bash
> >>>> +++ b/scripts/arch-run.bash
> >>>> @@ -142,6 +142,7 @@ run_migration ()
> >>>>  =20
> >>>>          eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp1},server=
=3Don,wait=3Doff \
> >>>>                  -mon chardev=3Dmon1,mode=3Dcontrol | tee ${migout1}=
 &
> >>>> +       live_pid=3D`jobs -l %+ | grep "eval" | awk '{print$2}'`
> >>>
> >>> Pardon my ignorance, but why would $! not work here?
> >>
> >> My mastery of bash is poor, I copied the incoming_pid line. It seems
> >> to work, but if you think $! is better I can try it.
> >=20
> > Sorry, this fell off of my radar after going to summer holiday...
> >=20
> > Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>=20
>   Hi Nicholas & Nico,
>=20
> do you want me to pick up this patch as is, or do you want to respin with=
 $!=20
> instead?

Let's not discuss too much and get this fixed, I am fine with this as-is.
Thanks.
