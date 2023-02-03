Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9F26899A0
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 14:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjBCNWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 08:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjBCNWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 08:22:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB80E8E497
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 05:22:29 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313DBuuC009172;
        Fri, 3 Feb 2023 13:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=J9T7BjPynvLFKdaUxAxV4ZDDKxCgg7ejoXCd/UiwuLM=;
 b=miucab7WES9noKosKw7MSQph4Lci6UAkjeu0qTpr7v12kDFbfnOyk/Kk3vsfsmQgiQUs
 ENJvbsaPGySYP4QqptzgDAo5Gos1Bfd8O80oBrV7g/pW6EuQkxcs0GS8cxxNWfkWxiK5
 Cg0b4huIjKVrb6pIxG5fYXh0bJwWbwrNJJmT92LRq3bvT8GpM+Eil2cOPTQ+5Gu8wkbW
 vXPHQtk2KYLdGopn+ItIwlJABzFsnA7dn2NPE684K6oTxDP3MzgreUinL85xM3XUK0qR
 FHZ4KxK7RvNCwS3qAPkFnki6ZC+Jd+nNzh1ROtGRx86AxBj27xfSopTbyQriodtzjj8k Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh2xe88bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 13:22:21 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 313DE6Rq014888;
        Fri, 3 Feb 2023 13:22:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh2xe88aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 13:22:20 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3136QZnF012873;
        Fri, 3 Feb 2023 13:22:18 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ncvtyff2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 13:22:18 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 313DMDRA49480070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 13:22:14 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 562F32004B;
        Fri,  3 Feb 2023 13:22:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFAE420043;
        Fri,  3 Feb 2023 13:22:12 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.195.237])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Feb 2023 13:22:12 +0000 (GMT)
Message-ID: <45bb29fcb3629a857577e50378adab1f5598644e.camel@linux.ibm.com>
Subject: Re: [PATCH v15 02/11] s390x/cpu topology: add topology entries on
 CPU hotplug
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Fri, 03 Feb 2023 14:22:12 +0100
In-Reply-To: <c2c502ca-2a1f-d29f-8931-4be7389557ee@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-3-pmorel@linux.ibm.com>
         <6345131acfb04e353ca2eba620bf27609bfeb535.camel@linux.ibm.com>
         <c2c502ca-2a1f-d29f-8931-4be7389557ee@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1HNAOCLt07j0bo2T6z5MpVfNh6E8Y1AN
X-Proofpoint-GUID: I5j3kZ3oRddg-Bav7ZJQWux4mKhIsqQp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_08,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 spamscore=0 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-03 at 10:21 +0100, Pierre Morel wrote:
>=20
> On 2/2/23 17:42, Nina Schoetterl-Glausch wrote:
> > On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> > > The topology information are attributes of the CPU and are
> > > specified during the CPU device creation.
> > >=20
> > > On hot plug we:
> > > - calculate the default values for the topology for drawers,
> > >    books and sockets in the case they are not specified.
> > > - verify the CPU attributes
> > > - check that we have still room on the desired socket
> > >=20
> > > The possibility to insert a CPU in a mask is dependent on the
> > > number of cores allowed in a socket, a book or a drawer, the
> > > checking is done during the hot plug of the CPU to have an
> > > immediate answer.
> > >=20
> > > If the complete topology is not specified, the core is added
> > > in the physical topology based on its core ID and it gets
> > > defaults values for the modifier attributes.
> > >=20
> > > This way, starting QEMU without specifying the topology can
> > > still get some advantage of the CPU topology.
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   include/hw/s390x/cpu-topology.h |  24 +++
> > >   hw/s390x/cpu-topology.c         | 256 +++++++++++++++++++++++++++++=
+++
> > >   hw/s390x/s390-virtio-ccw.c      |  23 ++-
> > >   hw/s390x/meson.build            |   1 +
> > >   4 files changed, 302 insertions(+), 2 deletions(-)
> > >   create mode 100644 hw/s390x/cpu-topology.c
> > >=20
[...]
> >=20
> > > +/**
> > > + * s390_set_core_in_socket:
> > > + * @cpu: the new S390CPU to insert in the topology structure
> > > + * @drawer_id: new drawer_id
> > > + * @book_id: new book_id
> > > + * @socket_id: new socket_id
> > > + * @creation: if is true the CPU is a new CPU and there is no old so=
cket
> > > + *            to handle.
> > > + *            if is false, this is a moving the CPU and old socket c=
ount
> > > + *            must be decremented.
> > > + * @errp: the error pointer
> > > + *
> > > + */
> > > +static void s390_set_core_in_socket(S390CPU *cpu, int drawer_id, int=
 book_id,
> >=20
> > Maybe name it s390_(topology_)?add_core_to_socket instead.
>=20
> OK, it is better
>=20
> >=20
> > > +                                    int socket_id, bool creation, Er=
ror **errp)
> > > +{
> > > +    int old_socket =3D s390_socket_nb(cpu);
> > > +    int new_socket;
> > > +
> > > +    if (creation) {
> > > +        new_socket =3D old_socket;
> > > +    } else {
> >=20
> > You need parentheses here.
> >=20
> > > +        new_socket =3D drawer_id * s390_topology.smp->books +
> >                         (
> > > +                     book_id * s390_topology.smp->sockets +
> >                                 )
> > > +                     socket_id;
>=20
> If you prefer I can us parentheses.

It's necessary, otherwise the multiplication of book_id and smp->sockets ta=
kes precedence.
>=20
>=20
> > > +    }
> > > +
> > > +    /* Check for space on new socket */
> > > +    if ((new_socket !=3D old_socket) &&
> > > +        (s390_topology.cores_per_socket[new_socket] >=3D
> > > +         s390_topology.smp->cores)) {
> > > +        error_setg(errp, "No more space on this socket");
> > > +        return;
> > > +    }
> > > +
> > > +    /* Update the count of cores in sockets */
> > > +    s390_topology.cores_per_socket[new_socket] +=3D 1;
> > > +    if (!creation) {
> > > +        s390_topology.cores_per_socket[old_socket] -=3D 1;
> > > +    }
> > > +}
> > >=20
[...]
> >=20
> > > diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> > > index f3cc845d3b..9bc51a83f4 100644
> > > --- a/hw/s390x/s390-virtio-ccw.c
> > > +++ b/hw/s390x/s390-virtio-ccw.c
> > > @@ -44,6 +44,7 @@
> > >   #include "hw/s390x/pv.h"
> > >   #include "migration/blocker.h"
> > >   #include "qapi/visitor.h"
> > > +#include "hw/s390x/cpu-topology.h"
> > >  =20
> > >   static Error *pv_mig_blocker;
> > >  =20
> > > @@ -310,10 +311,18 @@ static void s390_cpu_plug(HotplugHandler *hotpl=
ug_dev,
> > >   {
> > >       MachineState *ms =3D MACHINE(hotplug_dev);
> > >       S390CPU *cpu =3D S390_CPU(dev);
> > > +    ERRP_GUARD();
> > >  =20
> > >       g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
> > >       ms->possible_cpus->cpus[cpu->env.core_id].cpu =3D OBJECT(dev);
> > >  =20
> > > +    if (s390_has_topology()) {
> > > +        s390_topology_set_cpu(ms, cpu, errp);
> > > +        if (*errp) {
> > > +            return;
> > > +        }
> > > +    }
> > > +
> > >       if (dev->hotplugged) {
> > >           raise_irq_cpu_hotplug();
> > >       }
> > > @@ -551,11 +560,21 @@ static const CPUArchIdList *s390_possible_cpu_a=
rch_ids(MachineState *ms)
> > >                                     sizeof(CPUArchId) * max_cpus);
> > >       ms->possible_cpus->len =3D max_cpus;
> > >       for (i =3D 0; i < ms->possible_cpus->len; i++) {
> > > +        CpuInstanceProperties *props =3D &ms->possible_cpus->cpus[i]=
.props;
> > > +
> > >           ms->possible_cpus->cpus[i].type =3D ms->cpu_type;
> > >           ms->possible_cpus->cpus[i].vcpus_count =3D 1;
> > >           ms->possible_cpus->cpus[i].arch_id =3D i;
> > > -        ms->possible_cpus->cpus[i].props.has_core_id =3D true;
> > > -        ms->possible_cpus->cpus[i].props.core_id =3D i;
> > > +
> > > +        props->has_core_id =3D true;
> > > +        props->core_id =3D i;
> > > +        props->has_socket_id =3D true;
> > > +        props->socket_id =3D i / ms->smp.cores;
> > > +        props->has_book_id =3D true;
> > > +        props->book_id =3D i / (ms->smp.cores * ms->smp.sockets);
> > > +        props->has_drawer_id =3D true;
> > > +        props->drawer_id =3D i /
> > > +                           (ms->smp.cores * ms->smp.sockets * ms->sm=
p.books);
> >=20
> > You need to calculate the modulus like in s390_topology_cpu_default, ri=
ght?
>=20
> !!! yes of course, good catch, I forgot that.
>=20
> Since there are two uses of this calculation, what about using inlines?
> like:

Fine by me, I just have no idea what std is short for.
Since this would be used in s390_topology_cpu_default and calculates the de=
fault assignment,
I would call it s390_topology_cpu_default_socket, book, etc. or similar

>=20
> static inline int s390_std_socket(int n, CpuTopology *smp)
> {
>      return (n / smp->cores) % smp->sockets;
> }
>=20
> static inline int s390_std_book(int n, CpuTopology *smp)
> {
>      return (n / (smp->cores * smp->sockets)) % smp->books;
> }
>=20
> static inline int s390_std_drawer(int n, CpuTopology *smp)
> {
>      return (n / (smp->cores * smp->sockets * smp->books)) % smp->books;
> }
>=20
>=20
> Thanks for the comments.
>=20
> Regards,
> Pierre
>=20

