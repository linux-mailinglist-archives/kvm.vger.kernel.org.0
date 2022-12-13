Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E12A64B872
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbiLMPcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbiLMPbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:31:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB3913F6A
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 07:31:52 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDFPjs5025527;
        Tue, 13 Dec 2022 15:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RhFDwAG6zCpK3z1EYU3wjoVdryUYjLL58aVkl13sY2Y=;
 b=pqMnxhCUxaEooQA2L0VYFNOlmrHUgdJ5ApSrIB3S8NMKnQgOfFSKNXxZLywPSj2IjDsJ
 oJK3EkBztPQG8HmvT/g24vmJJ8TL/eSf+YpNs6IQRQLbmLvYj1f1QykAAXmKprwisq9t
 hIMnVQZWsmNtMnRkW+AzxpJzj9XsyIWa2Lv5/d9Uq86olAE4wxY9LSKnSPBnrD5Y1mF9
 lo6KpvVSIWUx33g/OgRXJFKM/tutUQmF/KPupwPrg6Rg5ae7pdV63xljgfaxn3GEwQPx
 Ki/ozVUYCGPo4x+rCr8g8wciN1EMe5OSB/p3CQ2YDvrZn8/pXr4CWRIW0wLz7LonGk9R sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev1dr6rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:31:44 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFRHjZ002584;
        Tue, 13 Dec 2022 15:31:44 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev1dr6pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:31:43 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2BD6RQu2029015;
        Tue, 13 Dec 2022 15:31:41 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mchceu650-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:31:40 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFVbqU46793144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:31:37 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4100120043;
        Tue, 13 Dec 2022 15:31:37 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26AF820049;
        Tue, 13 Dec 2022 15:31:36 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.179.4.88])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:31:36 +0000 (GMT)
Message-ID: <363b4882fdd50abfeea5b1154a0845732f8364c4.camel@linux.ibm.com>
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com
Date:   Tue, 13 Dec 2022 16:31:35 +0100
In-Reply-To: <f5bd6479-5717-2dd8-f8f2-c85ab77b7e2b@de.ibm.com>
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
         <d29c06e6-48e2-6cff-0524-297eaab0516b@kaod.org>
         <663e6861-be17-88ae-866a-e62569d6c721@linux.ibm.com>
         <e9927252-c711-6ddf-bc53-28e373eea371@de.ibm.com>
         <f5bd6479-5717-2dd8-f8f2-c85ab77b7e2b@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: m9GrXxuga4NIdQ8VgFfXhknPZyh2DiZI
X-Proofpoint-GUID: bE04mkgGNWP923Q0muRBpEhYQLUpvBBm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-13 at 16:12 +0100, Christian Borntraeger wrote:
>=20
> Am 13.12.22 um 14:50 schrieb Christian Borntraeger:
> >=20
> >=20
> > Am 12.12.22 um 11:01 schrieb Pierre Morel:
> > >=20
> > >=20
> > > On 12/9/22 15:45, C=C3=A9dric Le Goater wrote:
> > > > On 12/8/22 10:44, Pierre Morel wrote:
> > > > > Hi,
> > > > >=20
> > > > > Implementation discussions
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > > >=20
> > > > > CPU models
> > > > > ----------
> > > > >=20
> > > > > Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU =
model
> > > > > for old QEMU we could not activate it as usual from KVM but neede=
d
> > > > > a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> > > > > Checking and enabling this capability enables
> > > > > S390_FEAT_CONFIGURATION_TOPOLOGY.
> > > > >=20
> > > > > Migration
> > > > > ---------
> > > > >=20
> > > > > Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the sourc=
e
> > > > > host the STFL(11) is provided to the guest.
> > > > > Since the feature is already in the CPU model of older QEMU,
> > > > > a migration from a new QEMU enabling the topology to an old QEMU
> > > > > will keep STFL(11) enabled making the guest get an exception for
> > > > > illegal operation as soon as it uses the PTF instruction.
> > > > >=20
> > > > > A VMState keeping track of the S390_FEAT_CONFIGURATION_TOPOLOGY
> > > > > allows to forbid the migration in such a case.
> > > > >=20
> > > > > Note that the VMState will be used to hold information on the
> > > > > topology once we implement topology change for a running guest.
> > > > >=20
> > > > > Topology
> > > > > --------
> > > > >=20
> > > > > Until we introduce bookss and drawers, polarization and dedicatio=
n
> > > > > the topology is kept very simple and is specified uniquely by
> > > > > the core_id of the vCPU which is also the vCPU address.
> > > > >=20
> > > > > Testing
> > > > > =3D=3D=3D=3D=3D=3D=3D
> > > > >=20
> > > > > To use the QEMU patches, you will need Linux V6-rc1 or newer,
> > > > > or use the following Linux mainline patches:
> > > > >=20
> > > > > f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-=
Report
> > > > > 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology fun=
ction
> > > > > 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and S=
IIF fac..
> > > > >=20
> > > > > Currently this code is for KVM only, I have no idea if it is inte=
resting
> > > > > to provide a TCG patch. If ever it will be done in another series=
.
> > > > >=20
> > > > > Documentation
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > >=20
> > > > > To have a better understanding of the S390x CPU Topology and its
> > > > > implementation in QEMU you can have a look at the documentation i=
n the
> > > > > last patch of this series.
> > > > >=20
> > > > > The admin will want to match the host and the guest topology, tak=
ing
> > > > > into account that the guest does not recognize multithreading.
> > > > > Consequently, two vCPU assigned to threads of the same real CPU s=
hould
> > > > > preferably be assigned to the same socket of the guest machine.
> > > > >=20
> > > > > Future developments
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > >=20
> > > > > Two series are actively prepared:
> > > > > - Adding drawers, book, polarization and dedication to the vCPU.
> > > > > - changing the topology with a running guest
> > > >=20
> > > > Since we have time before the next QEMU 8.0 release, could you plea=
se
> > > > send the whole patchset ? Having the full picture would help in tak=
ing
> > > > decisions for downstream also.
> > > >=20
> > > > I am still uncertain about the usefulness of S390Topology object be=
cause,
> > > > as for now, the state can be computed on the fly, the reset can be
> > > > handled at the machine level directly under s390_machine_reset() an=
d so
> > > > could migration if the machine had a vmstate (not the case today bu=
t
> > > > quite easy to add). So before merging anything that could be diffic=
ult
> > > > to maintain and/or backport, I would prefer to see it all !
> > > >=20
> > >=20
> > > The goal of dedicating an object for topology was to ease the mainten=
ance and portability by using the QEMU object framework.
> > >=20
> > > If on contrary it is a problem for maintenance or backport we surely =
better not use it.
> > >=20
> > > Any other opinion?
> >=20
> > I agree with Cedric. There is no point in a topology object.
> > The state is calculated on the fly depending on the command line. This
> > would change if we ever implement the PTF horizontal/vertical state. Bu=
t this
> > can then be another CPU state.
> >=20
> > So I think we could go forward with this patch as a simple patch set th=
at allows to
> > sets a static topology. This makes sense on its own, e.g. if you plan t=
o pin your
> > vCPUs to given host CPUs.
> >=20
> > Dynamic changes do come with CPU hotplug, not sure what libvirt does wi=
th new CPUs
> > in that case during migration. I assume those are re-generated on the t=
arget with
> > whatever topology was created on the source. So I guess this will just =
work, but
> > it would be good if we could test that.
> >=20
> > A more fine-grained topology (drawer, book) could be added later or upf=
ront. It
> > does require common code and libvirt enhancements, though.
>=20
> Now I have discussed with Pierre and there IS a state that we want to mig=
rate.
> The topology change state is a guest wide bit that might be still set whe=
n
> topology is changed->bit is set
> guest is not yet started
> migration
>=20
> 2 options:
> 1. a vmstate with that bit and migrate the state
> 2. always set the topology change bit after migration

2. is the default behavior if you do nothing. VCPU creation on the target s=
ets
the change bit to 1.
So 1. is only to prevent spurious topology change indication.

