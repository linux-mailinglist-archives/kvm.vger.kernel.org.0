Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3F064B6A7
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 14:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbiLMN6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 08:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiLMN6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 08:58:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3559CF587
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 05:58:02 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDCtJv5010385;
        Tue, 13 Dec 2022 13:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zaAAxFdQejFxChBFOY0mwuKpP6WjCKguYpjJhshLpoE=;
 b=qqPFWg7PyYY+y43uAaX9TncB1Ple7+H77gyb8c0+oKZ8Xb5YNxm7FxmJYuWnuSD/GDsA
 KWloKWymiPt1cq0Fxw5f4E/xGDnR3Q5g5EQQCCS55vsSgtFuoNWeY2r0My1Po6ET1fOd
 dy7whCqZjNH3wyQFrSk4x1szX1oGWtJrqNlOzYnbl92TsMEsZVu5tWGfyt9pTQg4nzAS
 Wk8VHN0z2oHQWRKYh02bs2/ptl4Pqbl6MO3JP+OHHho28HRR3bQPOVSqkUjXxYVwEkln
 az1Dpt7yrO5kdhzwJ3Ssh4cr1O4wNvMclvyqe4f7VQ+G/wT3fDT08alK9tgOUKc9PAZX zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mejre4ejp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:57:55 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDDvtuq002021;
        Tue, 13 Dec 2022 13:57:55 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mejre4ehh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:57:55 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD4edlv004495;
        Tue, 13 Dec 2022 13:57:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3mchr6331r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:57:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDDvnOY45875572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 13:57:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09CBD2004B;
        Tue, 13 Dec 2022 13:57:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAF8F2004F;
        Tue, 13 Dec 2022 13:57:47 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.179.4.88])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 13:57:47 +0000 (GMT)
Message-ID: <00a4750ac9874d5bb41221468f4bd01136f446c9.camel@linux.ibm.com>
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Date:   Tue, 13 Dec 2022 14:57:47 +0100
In-Reply-To: <b36eef2e-92ed-a0ea-0728-4a5ea5bf25d9@de.ibm.com>
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
         <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
         <60f006f4-d29e-320a-d656-600b2fd4a11a@linux.ibm.com>
         <864cc127-2dbd-3792-8851-937ef4689503@redhat.com>
         <90514038-f10c-33e7-3600-e3131138a44d@linux.ibm.com>
         <73238c6c-a9dc-9d18-8ffb-92c8a41922d3@redhat.com>
         <b36eef2e-92ed-a0ea-0728-4a5ea5bf25d9@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: by_lh2N_lbjS3SNWG2jRGCpcjwzZGjgt
X-Proofpoint-ORIG-GUID: AUDff07nq0w3ZRlfNIMKOA16oOVYWy9F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-13 at 14:41 +0100, Christian Borntraeger wrote:
>=20
> Am 12.12.22 um 11:17 schrieb Thomas Huth:
> > On 12/12/2022 11.10, Pierre Morel wrote:
> > >=20
> > >=20
> > > On 12/12/22 10:07, Thomas Huth wrote:
> > > > On 12/12/2022 09.51, Pierre Morel wrote:
> > > > >=20
> > > > >=20
> > > > > On 12/9/22 14:32, Thomas Huth wrote:
> > > > > > On 08/12/2022 10.44, Pierre Morel wrote:
> > > > > > > Hi,
> > > > > > >=20
> > > > > > > Implementation discussions
> > > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > > > > > >=20
> > > > > > > CPU models
> > > > > > > ----------
> > > > > > >=20
> > > > > > > Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the =
CPU model
> > > > > > > for old QEMU we could not activate it as usual from KVM but n=
eeded
> > > > > > > a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> > > > > > > Checking and enabling this capability enables
> > > > > > > S390_FEAT_CONFIGURATION_TOPOLOGY.
> > > > > > >=20
> > > > > > > Migration
> > > > > > > ---------
> > > > > > >=20
> > > > > > > Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the s=
ource
> > > > > > > host the STFL(11) is provided to the guest.
> > > > > > > Since the feature is already in the CPU model of older QEMU,
> > > > > > > a migration from a new QEMU enabling the topology to an old Q=
EMU
> > > > > > > will keep STFL(11) enabled making the guest get an exception =
for
> > > > > > > illegal operation as soon as it uses the PTF instruction.
> > > > > >=20
> > > > > > I now thought that it is not possible to enable "ctop" on older=
 QEMUs since the don't enable the KVM capability? ... or is it still someho=
w possible? What did I miss?
> > > > > >=20
> > > > > > =C2=A0=C2=A0Thomas
> > > > >=20
> > > > > Enabling ctop with ctop=3Don on old QEMU is not possible, this is=
 right.
> > > > > But, if STFL(11) is enable in the source KVM by a new QEMU, I can=
 see that even with -ctop=3Doff the STFL(11) is migrated to the destination=
.
>=20
> This does not make sense. the cpu model and stfle values are not migrated=
. This is re-created during startup depending on the command line parameter=
s of -cpu.
> Thats why source and host have the same command lines for -cpu. And STFLE=
.11 must not be set on the SOURCE of ctop is off.
>=20
What about linux? I didn't look to thoroughly at it, but it caches the stfl=
e bits, doesn't it?
So if the migration succeeds, even tho it should not, it will look to the g=
uest like the facility is enabled.
>=20
> > > >=20
> > > > Is this with the "host" CPU model or another one? And did you expli=
citly specify "ctop=3Doff" at the command line, or are you just using the d=
efault setting by not specifying it?
> > >=20
> > > With explicit cpumodel and using ctop=3Doff like in
> > >=20
> > > sudo /usr/local/bin/qemu-system-s390x_master \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -m 512M \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -enable-kvm -smp 4,sockets=3D4,cores=
=3D2,maxcpus=3D8 \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -cpu z14,ctop=3Doff \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -machine s390-ccw-virtio-7.2,accel=3Dk=
vm \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> >=20
> > Ok ... that sounds like a bug somewhere in your patches or in the kerne=
l code ... the guest should never see STFL bit 11 if ctop=3Doff, should it?
>=20
> Correct. If ctop=3Doff then QEMU should disable STFLE.11 for the CPU mode=
l.

