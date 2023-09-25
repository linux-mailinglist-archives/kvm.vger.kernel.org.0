Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BD27AD6D2
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 13:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjIYLOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 07:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjIYLOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 07:14:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D396CE
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 04:14:28 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38PBDGbr028663
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:14:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=kzOCTn+gjluSz/E6a7XcCl/PfMKvdkLqqumEegofkjU=;
 b=aM0HZLEUDKDg4fJ9OPEtBhzLbtgQBunGeccDk8UpK0tWSskchUemioA2B9CH3piYGgBC
 paQWhcVLUl8x2BRq929ctX31LUBrFIM3qq5Of/w2ZLef8urvu2bU57DIV2obRX5b0x6e
 6RVbUnUFBOGsm4wwAJRKpLDjCYP0fpMWKdHUgfVUvEq8guBO8NUL9fepHt1RhM7B/zVz
 esUAwY+NAaimTlZhPcO/66N46R0tDzVqigrE8BPTziG2UKwK1Sx1vNLBCMXdhKv6ivjV
 3VywgjGG7fCm/G7xY7hyLQJj5mySRZY83FnGzP76QRk8Tb/DCMHkXgiB4YOyLGUSzEd0 /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tb7uf9vtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:14:27 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38PBEQk2031730
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:14:26 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tb7uf9vtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 11:14:26 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38P9Figp011019;
        Mon, 25 Sep 2023 11:14:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tabuk1eku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 11:14:25 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38PBENZv41746838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Sep 2023 11:14:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA4562004B;
        Mon, 25 Sep 2023 11:14:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1D3D20040;
        Mon, 25 Sep 2023 11:14:23 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.70.120])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 25 Sep 2023 11:14:23 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CUFF6E1RB78K.QT91UG08M495@wheely>
References: <20230725033937.277156-1-npiggin@gmail.com> <20230725033937.277156-3-npiggin@gmail.com> <169052965551.15205.2179571087904012453@t14-nrb> <CUFF6E1RB78K.QT91UG08M495@wheely>
Subject: Re: [kvm-unit-tests PATCH 2/3] migration: Fix test harness hang if source does not reach migration point
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Message-ID: <169564046337.31925.7932230191015216618@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 25 Sep 2023 13:14:23 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vxhbHmFyUTGUQ0aswoJQapbwmKUxoVBM
X-Proofpoint-GUID: 3tjBJayBY9rjxjqzn05jnlp2yoIBWnj8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-25_08,2023-09-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309250082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nicholas Piggin (2023-07-30 12:03:36)
> On Fri Jul 28, 2023 at 5:34 PM AEST, Nico Boehr wrote:
> > Quoting Nicholas Piggin (2023-07-25 05:39:36)
> > > After starting the test, the harness waits polling for "migrate" in t=
he
> > > output. If the test does not print for some reason, the harness hangs.
> > >=20
> > > Test that the pid is still alive while polling to fix this hang.
> > >=20
> > > While here, wait for the full string "Now migrate the VM", which I th=
ink
> > > makes it more obvious to read and could avoid an unfortunate collision
> > > with some debugging output in a test case.
> > >=20
> > > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> >
> > Thanks for attempting to fix this!
> >
> > > ---
> > >  scripts/arch-run.bash | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > > index 518607f4..30e535c7 100644
> > > --- a/scripts/arch-run.bash
> > > +++ b/scripts/arch-run.bash
> > > @@ -142,6 +142,7 @@ run_migration ()
> > > =20
> > >         eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp1},server=3Do=
n,wait=3Doff \
> > >                 -mon chardev=3Dmon1,mode=3Dcontrol | tee ${migout1} &
> > > +       live_pid=3D`jobs -l %+ | grep "eval" | awk '{print$2}'`
> >
> > Pardon my ignorance, but why would $! not work here?
>=20
> My mastery of bash is poor, I copied the incoming_pid line. It seems
> to work, but if you think $! is better I can try it.

Sorry, this fell off of my radar after going to summer holiday...

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
