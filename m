Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E8C6D6B37
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbjDDSHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbjDDSHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:07:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAE05593
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:07:17 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334H7R6t011796;
        Tue, 4 Apr 2023 18:06:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PHZYzmxPEU/IgsGf7FCB/N1deq689PHxSAKsmwK3NRU=;
 b=DKt7ChIiuXxOf4Qi+f/4P7/4lX7o38neVT9w1ZhR3vJW8FBXq91qR7YwzCLwHy8kwsJ/
 E1UBcxHjnnYyfByd5iiSGRxX2pOuIITUZqeGDMRDIk8LhewG/enFfU2fZLGXFrFquFUo
 o0y0gjj/SMTkXGzUKWg1vVVx+WvW8+Z//BUDKBlpzHV0Ocx128ww8uUwtAGraqy8dEQv
 wdtKpe+JoyInWonGPYb6D7bA6UheVaM0DU0ZwGigabNOV9pYkQozwQApZwcK6/SGw2zz
 5r7xDCgdUZMnndocAUZLeqspdzo8sMHO7vNI8jtSgPz2m3k1FICgSVjtkbZeHZFpR1gH 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prpe0cfs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:06:46 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334HUDu2010144;
        Tue, 4 Apr 2023 18:06:45 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prpe0cfr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:06:45 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342vgqk016631;
        Tue, 4 Apr 2023 18:06:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ppc86t21r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:06:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334I6euE19595888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 18:06:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE84520043;
        Tue,  4 Apr 2023 18:06:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C02EE20040;
        Tue,  4 Apr 2023 18:06:39 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.129.1])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 18:06:39 +0000 (GMT)
Message-ID: <5098eca038dfbd3e394e75d44ca061d64f9446f5.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests GIT PULL v2 11/14] s390x: Add tests for
 execute-type instructions
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        andrew.jones@linux.dev, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Date:   Tue, 04 Apr 2023 20:06:34 +0200
In-Reply-To: <168062836004.37806.6096327013940193626@t14-nrb>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
         <20230404113639.37544-12-nrb@linux.ibm.com>
         <65075e9f-0d32-fc63-0200-3a3ec0c9bf63@redhat.com>
         <06fd3ebc7770d1327be90cee10d12251cca76dd3.camel@linux.ibm.com>
         <bf0f892e-7b7d-5806-b038-8392144da644@redhat.com>
         <168062836004.37806.6096327013940193626@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hVsDAupV5_bQb_ZZSVtSSVLHo8p_jP58
X-Proofpoint-GUID: N2Tn6XUeH1FpeMy4FbWJi0Xrooxh2vxm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_08,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 phishscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304040163
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-04 at 19:12 +0200, Nico Boehr wrote:
> Quoting Thomas Huth (2023-04-04 17:05:02)
> [...]
> > > > FWIW, this is failing with Clang 15 for me:
> > > >=20
> > > > s390x/ex.c:81:4: error: expected absolute expression
> > > >                   "       .if (1b - 0b) !=3D (3b - 2b)\n"
> > > >                    ^
> > > > <inline asm>:12:6: note: instantiated into assembly here
> > > >           .if (1b - 0b) !=3D (3b - 2b)
> > >=20
> > > Seems gcc is smarter here than clang.
> >=20
> > Yeah, the assembler from clang is quite a bit behind on s390x ... in th=
e=20
> > past I was only able to compile the k-u-t with Clang when using the=20
> > "-no-integrated-as" option ... but at least in the most recent version =
it=20
> > seems to have caught up now enough to be very close to compile it with =
the=20
> > built-in assembler, so it would be great to get this problem here fixed=
=20
> > somehow, too...
>=20
> Bringing up another option: Can we maybe guard this section from Clang so=
 we still have the assertion when compiling with GCC?

I considered this, but only from the asm, where I don't think it's possible=
.
But putting #ifndef __clang__ around it works. Until you compile with gcc a=
nd assemble with clang.
Not something we need to care about IMO.
