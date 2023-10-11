Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0337D7C5165
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 13:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346215AbjJKLQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 07:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbjJKLQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 07:16:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD6D10CB;
        Wed, 11 Oct 2023 04:16:17 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39BBEB1V001242;
        Wed, 11 Oct 2023 11:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=smbeoEwPtKw4AWOXXtd8pCYDPAhO0a2JRdV3W4KEKD0=;
 b=RQ6zl8Vu8cjBfrQVD6L6AKgWscxRWFznDjJKeKgLiWhPPAfxWw7F7tVRXpDVnpJ08OM5
 6wd08ON6FZuEjyDyHX85WhkaH2990Vpcc/k3flZsVwl9D8CmCZEA7U/RuZ37NCPAtmSe
 GUme3rS235f77DZgNjD2n8j3yiye5dAZlVJVClgqm7nJ5zsGP6qprZhQCAK42z1AOxSg
 f3A/QP0/q4bzFd43Wafk04kTxkQZUe3MPyVrYIZ5QJUvyV6ogXBJETOGhO28bQdtti9q
 IFjZyRnbKWkYqvoB3ro01gTille2u9+qyb51RuBUuIqUGx+iBstYZTO1+19cay73Rbc/ pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnsxp96ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:16:12 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39BAw8NP032037;
        Wed, 11 Oct 2023 11:16:12 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnsxp96ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:16:12 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39BAmD3e028201;
        Wed, 11 Oct 2023 11:16:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkj1y7rr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:16:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39BBG8sA22217390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 11:16:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F03720043;
        Wed, 11 Oct 2023 11:16:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 354D320040;
        Wed, 11 Oct 2023 11:16:08 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 11:16:08 +0000 (GMT)
Message-ID: <4440d50389c7ed2a19499798b697f62f6e6fb6f6.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/9] s390x: topology: Fix parsing loop
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico =?ISO-8859-1?Q?B=F6hr?= <nrb@linux.ibm.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 11 Oct 2023 13:16:07 +0200
In-Reply-To: <93dfd5b6-ed63-4b36-a731-423686becb9b@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
         <20231011085635.1996346-4-nsg@linux.ibm.com>
         <93dfd5b6-ed63-4b36-a731-423686becb9b@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JGjDYGBgqkrAqjrDiehysr7rv91IW7tO
X-Proofpoint-ORIG-GUID: cKEtv5OV-gsWMGmiFGWUkFKCtnEJQm_u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_08,2023-10-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310110097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-10-11 at 13:07 +0200, Janosch Frank wrote:
> On 10/11/23 10:56, Nina Schoetterl-Glausch wrote:
> > Without a comparison the loop is infinite.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
> Wait, how did this work before this change?
> Did the strcmp effectively end the loop?

Yes, it only worked because the test was passed correct arguments.
>=20
> > ---
> >   s390x/topology.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/s390x/topology.c b/s390x/topology.c
> > index e1bb6014..49d6dfeb 100644
> > --- a/s390x/topology.c
> > +++ b/s390x/topology.c
> > @@ -466,7 +466,7 @@ static void parse_topology_args(int argc, char **ar=
gv)
> >   		if (flag[0] !=3D '-')
> >   			report_abort("Argument is expected to begin with '-'");
> >   		flag++;
> > -		for (level =3D 0; ARRAY_SIZE(levels); level++) {
> > +		for (level =3D 0; level < ARRAY_SIZE(levels); level++) {
> >   			if (!strcmp(levels[level], flag))
> >   				break;
> >   		}
>=20

