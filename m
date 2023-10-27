Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7527D9E12
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 18:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbjJ0Qgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 12:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjJ0Qg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 12:36:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C03710A;
        Fri, 27 Oct 2023 09:36:27 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39RGRnmV006484;
        Fri, 27 Oct 2023 16:36:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dBNzKf8TYsgPTt0drQJ8VtmCCbSATVBzvyfVbIMYBzE=;
 b=X3rScWNCGUl3BQjXgdYq+zg+E2iQveZXAj0fgn8I6kwfB9YFeWeS9F3IEbjb96I+IAcO
 dpND7VkxZUWV73XT/rjR/BZ7qvNBcAcrEt16Bj5mEJsdJNzNwfITLvTTOclp+M9bIagd
 xYKCMEQb+YrE2pqwboI2MUEAb55FRXYATxC0s0uCTf7m3Wsd8C+9M/TeuVameBsXcrY/
 amPlRwyTFqKmlqG/5oBzlW4CujMM+bYgd78oGCvlVGBXQ60GBt60fraaCJXA6uD1nPAl
 WfV/GzpkKVTYlTbYUDb7JKqCYtKYqqDwr+gzRcJgEskFjsJ9unUIvC6oHyy2b1SMXTRG Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0gr787va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 16:36:22 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39RGYahM029335;
        Fri, 27 Oct 2023 16:36:21 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0gr787up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 16:36:21 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39RG5oN6025448;
        Fri, 27 Oct 2023 16:36:20 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tywqrx9jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 16:36:20 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39RGaHk8787098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 16:36:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A12EF2004B;
        Fri, 27 Oct 2023 16:36:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D298520040;
        Fri, 27 Oct 2023 16:36:16 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.179.1.132])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Oct 2023 16:36:16 +0000 (GMT)
Message-ID: <0f132157ec6437326c6bd63f8be18976b19f058a.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 00/10] s390x: topology: Fixes and
 extension
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>
Date:   Fri, 27 Oct 2023 18:36:12 +0200
In-Reply-To: <169823651572.67523.10556581938548735484@t14-nrb>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
         <169823651572.67523.10556581938548735484@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ddesj4U5-InKb5xYkgmC4-BzAXmTOYoj
X-Proofpoint-ORIG-GUID: Q1Yv0u0EPaVkoPDF7ZPhCXOzJOb87oa_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_15,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310270143
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-10-25 at 14:21 +0200, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2023-10-20 16:48:50)
> > v1 -> v2:
> >  * patch 1, introducing enums (Janosch)
> >  * add comment explaining 8 alignment of stsi block length
> >  * unsigned cpu_in_masks, iteration (Nico)
> >  * fix copy paste error when checking ordering (thanks Nina)
> >  * don't escape newline when \\ at end of line in multiline string
> >  * change commit messages (thanks Janosch, thanks Nico)
> >  * pick up tags (thanks Janosch, thanks Nico)
> >=20
> > Fix a number of issues as well as rewrite and extend the topology list
> > checking.
> > Add a test case with a complex topology configuration.
> > In order to keep the unittests.cfg file readable, implement multiline
> > strings for extra_params.
>=20
> Thanks, I've pushed this to our CI for coverage.

And it found some problems.
Want me to resend the series or just fixup patches?
Preview (copy pasted):
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -294,25 +294,38 @@ static union topology_container *check_child_cpus(str=
uct sysinfo_15_1_x *info,
 {
        void *last =3D ((void *)info) + info->length;
        union topology_cpu *prev_cpu =3D NULL;
+       bool correct_ordering =3D true;
        unsigned int cpus =3D 0;
        int i;

-       for (i =3D 0; (void *)&child[i] < last && child[i].nl =3D=3D 0; i++=
) {
+       for (i =3D 0; (void *)&child[i] < last && child[i].nl =3D=3D 0; pre=
v_cpu =3D &child[i++]) {
                cpus +=3D check_cpu(&child[i], cont);
                if (prev_cpu) {
-                       report(prev_cpu->type <=3D child[i].type, "Correct =
ordering wrt type");
+                       if (prev_cpu->type > child[i].type) {
+                               report_info("Incorrect ordering wrt type fo=
r child %d", i);
+                               correct_ordering =3D false;
+                       }
                        if (prev_cpu->type < child[i].type)
                                continue;
-                       report(prev_cpu->pp >=3D child[i].pp, "Correct orde=
ring wrt polarization");
+                       if (prev_cpu->pp < child[i].pp) {
+                               report_info("Incorrect ordering wrt polariz=
ation for child %d", i);
+                               correct_ordering =3D false;
+                       }
                        if (prev_cpu->pp > child[i].pp)
                                continue;
-                       report(prev_cpu->d || !child[i].d, "Correct orderin=
g wrt dedication");
+                       if (!prev_cpu->d && child[i].d) {
+                               report_info("Incorrect ordering wrt dedicat=
ion for child %d", i);
+                               correct_ordering =3D false;
+                       }
                        if (prev_cpu->d && !child[i].d)
                                continue;
-                       report(prev_cpu->origin <=3D child[i].origin, "Corr=
ect ordering wrt origin");
+                       if (prev_cpu->origin > child[i].origin) {
+                               report_info("Incorrect ordering wrt origin =
for child %d", i);
+                               correct_ordering =3D false;
+                       }
                }
-               prev_cpu =3D &child[i];
        }
+       report(correct_ordering, "children correctly ordered");
        report(cpus <=3D expected_topo_lvl[0], "%d children <=3D max of %d"=
,
               cpus, expected_topo_lvl[0]);
        *cpus_in_masks +=3D cpus;
