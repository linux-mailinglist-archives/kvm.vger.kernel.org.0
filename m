Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88B15261A0
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 14:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380170AbiEMMP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 08:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbiEMMP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 08:15:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109C3297407;
        Fri, 13 May 2022 05:15:27 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DAU81E011826;
        Fri, 13 May 2022 12:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=eB9Nf5R4i5bpG1ityJGtSzLMvAfmnAEAQgFMODLMuRc=;
 b=MjHtcqM5HxnkMQenGZh/anKRcX5q/m2Ak7/3/0EZa3VepQW/ebh2Cuxmn2c3Hr39pRkV
 ybj8rl07S3KNXe8AtO8kDcZOHVzYFgeQfKU8c90FtmLo/+LxxqOVWTq7CBNSHHsRCF5M
 TtSs7FBJh9WRsbnO1xKRjkoA3jHUaYXIB7NeHUY2VpZIBOWA7v0hPivWOSCCle1f8mw2
 oGapKkGxiyKb2A/uWrvMsCObqWnEymCqe2oeIrvw7VzejJPDt8VZU+kzUWvAQ9m3vUz2
 KnpNWdv2k9WnI0bMn9fyOeRoda+CFCYovEJ+Ust8wydviG4e2JtN08rbMfOcj0hQ+FEy pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1nmtswjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 12:15:26 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DBRMkD007278;
        Fri, 13 May 2022 12:15:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1nmtswj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 12:15:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DC1Xxf021016;
        Fri, 13 May 2022 12:15:23 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd90ma6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 12:15:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DC1epr40829332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 12:01:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B03344203F;
        Fri, 13 May 2022 12:15:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73B3A42047;
        Fri, 13 May 2022 12:15:20 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.155.203.253])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 12:15:20 +0000 (GMT)
Message-ID: <2eb27198bb0e987a880a8b218eda4f9436589eaa.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add migration test for
 storage keys
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, scgl@linux.ibm.com
Date:   Fri, 13 May 2022 14:15:20 +0200
In-Reply-To: <20220512174107.0500a5e6@p-imbrenda>
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
         <20220512140107.1432019-3-nrb@linux.ibm.com>
         <20220512174107.0500a5e6@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: awwhIzvvlPAD9c2zbAGGumHZ-ADfELLo
X-Proofpoint-GUID: obD4ne76-El8isEGhEG0nt7DSyg_6Rcu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205130054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-12 at 17:41 +0200, Claudio Imbrenda wrote:
> > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > new file mode 100644
> > index 000000000000..6f3053d8ab40
[...]
> > +static void test_migration(void)
> > +{
[...]
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/* ensure access key doesn't match storage key and
> > is never zero */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0mismatching_key.str.acc =3D expected_key.str.acc < 15
> > ? expected_key.str.acc + 1 : 1;
>=20
> mismatching_key.str.acc =3D (expected_key.str.acc ^ 2) | 1;

As discussed in person: I had something like this before and thought it is
easier to understand with the tertiary operator.  So I'd prefer to leave as=
-is.

