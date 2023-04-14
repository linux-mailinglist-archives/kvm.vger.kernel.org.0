Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8766E20A9
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 12:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjDNKZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 06:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjDNKZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 06:25:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7C24ED0;
        Fri, 14 Apr 2023 03:25:04 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33E9glWP002389;
        Fri, 14 Apr 2023 10:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YZHH+LycTKQiv1s2TYnlj5xi8kX9z5FuIFrCUBnZ8Kk=;
 b=Sibm0E02dqUp/acsJuKYkCe5zKjDzE7r/ZrIy+fwo+A111DO8h9C0W/xwaUy2zk8pvRb
 +4T/mxR3AjrmeBgqmagpWDacT7ommaFlegpcX7sLn1VHukfQMpLkhRbY/wFg/0naSIns
 PW2naRSp8NB9YqI9Klk8b6Dcb1sH/FlhSKYT3BTozdaljeRMV3WOemHmkQe1B2O7a96e
 ZHJJ30zVYV4vgo4G9h7i4Dgd0ESLn5IOlY6R3A6Qs9lPe7pPnkBp8lElFTR456Cq5B13
 LIiuxOHxsfiAp7DR+IG9X+Pf12LonIy4bJayyaU3Pf68ygdIzpTXL9PMehecG/0YOI/c ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxuxbs956-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 10:25:03 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33EA1I1c013060;
        Fri, 14 Apr 2023 10:25:03 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxuxbs94g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 10:25:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33EA2bif022165;
        Fri, 14 Apr 2023 10:25:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pu0hdkmm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 10:25:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33EAOvIp38797932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 10:24:58 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D630220073;
        Fri, 14 Apr 2023 10:24:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A27E220071;
        Fri, 14 Apr 2023 10:24:57 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.196.80])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Apr 2023 10:24:57 +0000 (GMT)
Message-ID: <27714b8fdeb24b44b07bdd08056458345ff0c61b.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add a test for SIE without
 MSO/MSL
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Fri, 14 Apr 2023 12:24:57 +0200
In-Reply-To: <168146700513.42330.5991739646507426126@t14-nrb>
References: <20230327082118.2177-1-nrb@linux.ibm.com>
         <20230327082118.2177-5-nrb@linux.ibm.com>
         <cfd83c1d7a74e969e6e3c922bbe5650f8e9adadd.camel@linux.ibm.com>
         <168137900094.42330.6464555141616427645@t14-nrb>
         <5b2e0a52c79122038cda60661c225e9d108e60ef.camel@linux.ibm.com>
         <168146700513.42330.5991739646507426126@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JzpO_msEyWAPvQ5zk34eYGRcQu5MntJB
X-Proofpoint-GUID: 9NMRQddgzes1AQsFljAPuhvjcvmZDUFr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_03,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-04-14 at 12:10 +0200, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2023-04-13 18:33:50)
> [...]
> > With a small linker script change the snippet could know it's own lengt=
h.
> > Then you could map just the required number of pages and don't need to =
keep those numbers in sync.
>=20
> Maybe it's because my knowledge about linker scripts is really limited or=
 I
> don't get it, but I fail to see the advantage of the additional complexit=
y.
>=20
> My assumption would be that the number of pages mapped for the guest memo=
ry will
> never really change. Keeping a define in sync seems more pragmatic than g=
oing
> through linker script magic.

I think just

+       . =3D ALIGN(4K);
+       esnippet =3D .;
        /* End data */

at the bottom of the snippet linker script would suffice.
Then you could use esnippet as an extern symbol in the C code.
But yeah, might not be worth it unless it would help with other snippets to=
o.
