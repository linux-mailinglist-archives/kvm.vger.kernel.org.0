Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38DA66D043
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 21:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjAPUfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 15:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjAPUfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 15:35:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDF72A9B6
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 12:35:22 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GJKrkF019473;
        Mon, 16 Jan 2023 20:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=gF6Sh1dAlsOhnwHnVae9g8OIy+BjLb3Cx8UD6Jem0yA=;
 b=hDOUdxLZusXZfiT9bxMMRApl/cke6VP1/W7sse+zg7VQDesTU2EVKabtLZN5XawcjbQX
 4VTncCzhDHTROB3AQvBJMHrWf3oQOlv88EcaM4Ec2SPX8GG5fCMSdIH0wDKdD6wnaBGM
 mYfza55Jk/3dkR100lo98A7z/7DXbZRYDBxY9Gil/Rn3XftgnsjZa0w1bUnHi9yJ+kFm
 S00DkKHaA8HuYyBDwCP339wKZYDYlC3VQn1bh2z8nSz/w5yGf2rW5TNi21dYfaZakU3S
 KgN18kzNtrcyJXFhu4J1JFk1w9YZ07w5ooxxnWDQ2iZYfPOhGdI5CO6qE5J733XVfSce NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5chfhcug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 20:35:06 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GKA7Im010741;
        Mon, 16 Jan 2023 20:35:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5chfhcsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 20:35:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GG0QYb023688;
        Mon, 16 Jan 2023 20:35:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16jvqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 20:35:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GKYxVP43647300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 20:34:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A130520043;
        Mon, 16 Jan 2023 20:34:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BC3920049;
        Mon, 16 Jan 2023 20:34:59 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.176.184])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 20:34:59 +0000 (GMT)
Message-ID: <10ddaef9e2e8cdd19b86c42096a7296ece137dc0.camel@linux.ibm.com>
Subject: Re: [PATCH v14 01/11] s390x/cpu topology: adding s390 specificities
 to CPU topology
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 16 Jan 2023 21:34:59 +0100
In-Reply-To: <31bc88bc-d0c2-f172-939a-c7a42adb466d@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-2-pmorel@linux.ibm.com>
         <87039aeec020afbd28be77ad5f8d022126aba7bf.camel@linux.ibm.com>
         <31bc88bc-d0c2-f172-939a-c7a42adb466d@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 32OEWqAH4YcD6tEAfBIx7rx9DwntVxxU
X-Proofpoint-GUID: bWheofuu0HHXmcwjPizJfaxBhXQxOHZ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_16,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301160151
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-01-16 at 18:28 +0100, Pierre Morel wrote:
>=20
> On 1/13/23 17:58, Nina Schoetterl-Glausch wrote:
> > On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
> > > S390 adds two new SMP levels, drawers and books to the CPU
> > > topology.
> > > The S390 CPU have specific toplogy features like dedication
> > > and polarity to give to the guest indications on the host
> > > vCPUs scheduling and help the guest take the best decisions
> > > on the scheduling of threads on the vCPUs.
> > >=20
> > > Let us provide the SMP properties with books and drawers levels
> > > and S390 CPU with dedication and polarity,
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   qapi/machine.json               | 14 ++++++++--
> > >   include/hw/boards.h             | 10 ++++++-
> > >   include/hw/s390x/cpu-topology.h | 23 ++++++++++++++++
> > >   target/s390x/cpu.h              |  6 +++++
> > >   hw/core/machine-smp.c           | 48 ++++++++++++++++++++++++++++--=
---
> > >   hw/core/machine.c               |  4 +++
> > >   hw/s390x/s390-virtio-ccw.c      |  2 ++
> > >   softmmu/vl.c                    |  6 +++++
> > >   target/s390x/cpu.c              | 10 +++++++
> > >   qemu-options.hx                 |  6 +++--
> > >   10 files changed, 117 insertions(+), 12 deletions(-)
> > >   create mode 100644 include/hw/s390x/cpu-topology.h
> > >=20
> > [...]
> >=20
> > > diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> > > index 7d6d01325b..39ea63a416 100644
> > > --- a/target/s390x/cpu.h
> > > +++ b/target/s390x/cpu.h
> > > @@ -131,6 +131,12 @@ struct CPUArchState {
> > >  =20
> > >   #if !defined(CONFIG_USER_ONLY)
> > >       uint32_t core_id; /* PoP "CPU address", same as cpu_index */
> > > +    int32_t socket_id;
> > > +    int32_t book_id;
> > > +    int32_t drawer_id;
> > > +    int32_t dedicated;
> > > +    int32_t polarity;
> >=20
> > If I understood the architecture correctly, the polarity is a property =
of the configuration,
> > not the cpus. So this should be vertical_entitlement, and there should =
be a machine (?) property
> > specifying if the polarity is horizontal or vertical.
>=20
> You are right, considering PTF only, the documentation says PTF([01])=20
> does the following:
>=20
> "... a process is initiated to place all CPUs in the configuration into=
=20
> the polarization specified by the function code, ..."
>=20
> So on one side the polarization property is explicitly set on the CPU,=
=20
> and on the other side all CPU are supposed to be in the same=20
> polarization state.

I'm worried about STSI showing both horizontal and vertical CPUs at the sam=
e time.
I don't know if this is allowed.
If it is not, you need a way to switch between those atomically, which is h=
arder
if every CPU has this property.
>=20
> So yes we can make the horizontal/vertical a machine property.
> However, we do not need to set this tunable as the documentation says=20
> that the machine always start with horizontal polarization.
>=20
> On the other hand the documentation mixes a lot vertical with different=
=20
> entitlement and horizontal polarization, for TLE order and slacks so I=
=20
> prefer to keep the complete description of the polarization as CPU=20
> properties in case we miss something.
>=20
> PTF([01]) are no performance bottle neck and the number of CPU is likely=
=20
> to be small, even a maximum of 248 is possible KVM warns above 16 CPU so=
=20
> the loop for setting all CPU inside PTF interception is not very=20
> problematic I think.

Yeah, I'm not worried about that.
>=20
> Doing like you say should simplify PTF interception (no loop) but=20
> complicates (some more if/else) TLE handling and QMP information display=
=20
> on CPU.
> So I will have a look at the implications and answer again on this.
>=20
> Thanks,
>=20
> Regards,
> Pierre
>=20

