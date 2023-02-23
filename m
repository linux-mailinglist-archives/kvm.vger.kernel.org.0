Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B216A0539
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 10:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbjBWJvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 04:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbjBWJvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 04:51:03 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933224E5E0;
        Thu, 23 Feb 2023 01:51:02 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31N9BvQi014177;
        Thu, 23 Feb 2023 09:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=N/XuGgMKaCuFUtxVdJeCg7Zs1AlJN7w9T5wtYEj77Jc=;
 b=mGBioPdAuecwgCEmmO+sggEhlmlzNQ3mFB7PGsTeyV4KT9JaQW+PjPZ1yO9z9oTr0oeg
 nc13+aOonvclxCGbSGQgiRbElBj6LpoD7fHi6YHMAZwkLRWooUmxSR9mlOBmrvXR/ZAj
 uB49Fg8Dn1xitPn5Yf3BKl2hTh0xrE786YFmIMtR7mEx0xC5OTBTEPXsXN/mNEgyvppx
 PEjDaN2TaoAF/g1ahVFOKX4KcJwiN2hn71HIERAbCW7L9IoCcwphYUyPr7kQW7FxERTn
 rOk0c0I3RugxIa6daZS4LySihExMtVblNTTAiWJ3YaiPDyM/buz9FHSJuMDNoC1n+N1M hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nx59y8sy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 09:51:02 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31N9npQV012373;
        Thu, 23 Feb 2023 09:51:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nx59y8sxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 09:51:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31N7uchM016569;
        Thu, 23 Feb 2023 09:50:59 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6eh0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 09:50:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31N9otiO45154576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 09:50:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D483620043;
        Thu, 23 Feb 2023 09:50:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7129E20040;
        Thu, 23 Feb 2023 09:50:55 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.221.152])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Feb 2023 09:50:55 +0000 (GMT)
Message-ID: <e8d21eb5afde7fd9114e225692222fa8902c4e7a.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: Add tests for execute-type
 instructions
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Thu, 23 Feb 2023 10:50:55 +0100
In-Reply-To: <167713875438.6442.2406479682969262260@t14-nrb.local>
References: <20230222114742.1208584-1-nsg@linux.ibm.com>
         <167713875438.6442.2406479682969262260@t14-nrb.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e9kvbgsnPD18ymPoCadSXb9-QyXaSfI_
X-Proofpoint-GUID: xZxkXEQU3vJ4EOvsAu3VqXo4EH6z9mdb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_04,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302230083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-02-23 at 08:52 +0100, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2023-02-22 12:47:42)
> > Test the instruction address used by targets of an execute instruction.
> > When the target instruction calculates a relative address, the result i=
s
> > relative to the target instruction, not the execute instruction.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> [...]
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 97a61611..6cf8018b 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -39,6 +39,7 @@ tests +=3D $(TEST_DIR)/panic-loop-extint.elf
> >  tests +=3D $(TEST_DIR)/panic-loop-pgm.elf
> >  tests +=3D $(TEST_DIR)/migration-sck.elf
> >  tests +=3D $(TEST_DIR)/exittime.elf
> > +tests +=3D $(TEST_DIR)/ex.elf
>=20
> You didn't add your new test to unittests.cfg, is this intentional?

Nope, I just forgot.

@Thomas, I guess I should also add it to s390x-kvm in .gitlab-ci.yml,
since the test passes on KVM?

>=20
> Otherwise:
>=20
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

Thanks!
