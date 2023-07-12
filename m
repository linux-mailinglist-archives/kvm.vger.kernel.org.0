Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2689975119A
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 22:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjGLUA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 16:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjGLUA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 16:00:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB77B1FED
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 13:00:19 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CJnl9X007291;
        Wed, 12 Jul 2023 20:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KK+PTdac+UFw5bmygdVAAJyc9LNNlbgI1x+tJ7aEXPI=;
 b=tfYTv8fnjsoePigO1u/SYd/utXsUgfmsir+B0h7Ao/00KPxu3fuS9jNwgDGied//cjjI
 5NSewI12s60uA62DdwCR8jCwJveAE6yGllnuFaRFTw5JHV4Uwa0DpU50LCgB2/spr+8G
 n82fdmI755uH2OvzE5x+o1XtbKMnMw2toqL2yIMRq1rObVmIQcgLEQD2FSrtHDGDm+Ku
 SQvsEAbYPrW3oj/ZlVEWKjrVw6jCewGCMrufT84AheG2g7hySlVmNHEwQ/6v7RswQFbC
 VklpkDuXeDRc74gTJROxFRhD3ydrfpwnAlE8Ec0kXtx6kp1pTlFPn0acVDyLlb0zQYSE EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rt2nwr6w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 20:00:11 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CJo3Cc008613;
        Wed, 12 Jul 2023 20:00:11 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rt2nwr6up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 20:00:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C4dLaN017376;
        Wed, 12 Jul 2023 20:00:08 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye5avbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 20:00:08 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CK035345547986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 20:00:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 366532004D;
        Wed, 12 Jul 2023 20:00:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D711820040;
        Wed, 12 Jul 2023 20:00:02 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jul 2023 20:00:02 +0000 (GMT)
Message-ID: <5dc552e7e4fc65b867cf26c65afb42fa9ee13752.camel@linux.ibm.com>
Subject: Re: [PATCH v21 14/20] tests/avocado: s390x cpu topology core
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Wed, 12 Jul 2023 22:00:02 +0200
In-Reply-To: <20230630091752.67190-15-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
         <20230630091752.67190-15-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aYaXZGRld0eOUWHCZikqvnBjQMDsbcBy
X-Proofpoint-ORIG-GUID: ZsOvllFaBLzM-YbRyR4kHQtbslZUwVz1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_14,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120174
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-06-30 at 11:17 +0200, Pierre Morel wrote:
> Introduction of the s390x cpu topology core functions and
> basic tests.
>=20
> We test the corelation between the command line and

corRelation

> the QMP results in query-cpus-fast for various CPU topology.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---

[...]

> diff --git a/tests/avocado/s390_topology.py
> b/tests/avocado/s390_topology.py
> new file mode 100644
> index 0000000000..1758ec1f13
> --- /dev/null
> +++ b/tests/avocado/s390_topology.py
> @@ -0,0 +1,196 @@

[...]

> +class S390CPUTopology(QemuSystemTest):
> +=C2=A0=C2=A0=C2=A0 """
> +=C2=A0=C2=A0=C2=A0 S390x CPU topology consist of 4 topology layers, from=
 bottom to

consistS

> top,
> +=C2=A0=C2=A0=C2=A0 the cores, sockets, books and drawers and 2 modifiers
> attributes,
> +=C2=A0=C2=A0=C2=A0 the entitlement and the dedication.
> +=C2=A0=C2=A0=C2=A0 See: docs/system/s390x/cpu-topology.rst.
> +
> +=C2=A0=C2=A0=C2=A0 S390x CPU topology is setup in different ways:
> +=C2=A0=C2=A0=C2=A0 - implicitely from the '-smp' argument by completing =
each
> topology
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 level one after the other begining with d=
rawer 0, book 0 and
> socket 0.
> +=C2=A0=C2=A0=C2=A0 - explicitely from the '-device' argument on the QEMU=
 command
> line
> +=C2=A0=C2=A0=C2=A0 - explicitely by hotplug of a new CPU using QMP or HM=
P
> +=C2=A0=C2=A0=C2=A0 - it is modified by using QMP 'set-cpu-topology'
> +
> +=C2=A0=C2=A0=C2=A0 The S390x modifier attribute entitlement depends on t=
he machine
> +=C2=A0=C2=A0=C2=A0 polarization, which can be horizontal or vertical.
> +=C2=A0=C2=A0=C2=A0 The polarization is changed on a request from the gue=
st.
> +=C2=A0=C2=A0=C2=A0 """

[...]
