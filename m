Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2B765C171
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 15:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjACOEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 09:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbjACOEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 09:04:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B58410574
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 06:04:14 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 303BsS4Z012278;
        Tue, 3 Jan 2023 14:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Xu4HIKOZtufOiV+JjF6/yIcg+V7+3VFmyEkOMcKRM4c=;
 b=A1mBnIckBos0ihhvt8oyn73HEcAzcve9IAbr2oZHFjzm09mU8w6BKVbQMIvbVVGyqTkl
 +oRDzJSoul++j6okoVtNSqhxtDhIDdOPKQiHlWXkVo56UQeKfzr5/6kdoiSaff3jger1
 6mYyExy9mor1aDF4lZUAmYTXfKoZlnaq7efsJtofuvJvbAhfywdQ2vIRnhX1ieW7hwj0
 R74bIruxWXgHXi5Ngy8mq9iN4GoozzRZqWIxQjj3Nn2CHC9rniu1gihEppEpS7Seme/h
 1xOqOFxmcKnMqdQFrL5krrICp0BS5BCrr1iZccwMUqvZvrzfF3VEF8RNGNMWwiuqK9EO Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mvkwctmag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Jan 2023 14:04:08 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 303CrGuJ011688;
        Tue, 3 Jan 2023 14:04:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mvkwctm9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Jan 2023 14:04:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30386uqO001912;
        Tue, 3 Jan 2023 14:04:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mtcq6bwyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Jan 2023 14:04:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 303E42Pk41026016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Jan 2023 14:04:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBC752004E;
        Tue,  3 Jan 2023 14:04:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD15720049;
        Tue,  3 Jan 2023 14:04:01 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.170.222])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  3 Jan 2023 14:04:01 +0000 (GMT)
Message-ID: <afdd57003ac8dbb639907b3093049c92c40ec488.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Andrew Jones <andrew.jones@linux.dev>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, seiden@linux.ibm.com, thuth@redhat.com
Date:   Tue, 03 Jan 2023 15:04:01 +0100
In-Reply-To: <20221226184112.ezyw2imr2ezffutr@orel>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
         <167161061144.28055.8565976183630294954@t14-nrb.local>
         <167161409237.28055.17477704571322735500@t14-nrb.local>
         <20221226184112.ezyw2imr2ezffutr@orel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Bij1rIgye4skXmGyZo_gpET2OIcA-sjh
X-Proofpoint-GUID: VJQeLYaxIpiXl7qKkBPkRRCyHdjc4qRP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-03_04,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=892
 clxscore=1011 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301030122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-12-26 at 19:41 +0100, Andrew Jones wrote:
> On Wed, Dec 21, 2022 at 10:14:52AM +0100, Nico Boehr wrote:
> > Quoting Nico Boehr (2022-12-21 09:16:51)
> > > Quoting Claudio Imbrenda (2022-12-20 18:55:08)
> > > > A recent patch broke make standalone. The function find_word is not
> > > > available when running make standalone, replace it with a simple gr=
ep.
> > > >=20
> > > > Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > > > Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
> > > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > >=20
> > > I am confused why find_word would not be available in standalone, sin=
ce run() in runtime.bash uses it quite a few times.
> > >=20
> > > Not that I mind the grep, but I fear more might be broken in standalo=
ne?
>=20
> standalone tests don't currently include scripts/$ARCH/func.bash, which
> may be an issue for s390x. That could be fixed, though.
>=20
> > >=20
> > > Anyways, to get this fixed ASAP:
> > >=20
> > > Acked-by: Nico Boehr <nrb@linux.ibm.com>
> >=20
> > OK, I get it now, find_word is not available during _build time_.
>=20
> That could be changed, but it'd need to be moved to somewhere that
> mkstandalone.sh wants to source, which could be common.bash, but
> then we'd need to include common.bash in the standalone tests. So,

What is wrong with including common.bash?

> a new file for find_word() would be cleaner, but that sounds like
> overkill.
>=20
> Thanks,
> drew
>=20
> >=20
> > Please make this a:
> >=20
> > Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

