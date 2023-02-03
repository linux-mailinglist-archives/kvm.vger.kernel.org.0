Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39B568A07E
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 18:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbjBCRho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 12:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbjBCRhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 12:37:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0E8AD31B
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 09:37:11 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313HJbKq023559;
        Fri, 3 Feb 2023 17:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=kpjxDO/dTi41LOvduKvUNsHDQMJtxn8SyIun1RA7Fd8=;
 b=saEKIIUFhAyobgTw0tMcGVkkq8LBqzsUNsG+yWafXm3Z/bJttBQLTdk2DsAQSd80QjM1
 4mphRKITb0txRa8Ex+90mitUjARwvtS/jWyUEOIS5nk08Y5nwikO4gavwW6WloHFX1RI
 /oYpg2D7gtX5+Fa5IK1CLsuCsrZNyzXZhHkobBvcnwSeQ93m4VGjLEEjDIz1rZK5BgT/
 GOSL0SepOpFS3BVE/Uu4Gl2HzMRlWFDQnZ+KTjUpMhDLi2qGpf2/bi8PFt/Io4MsUg0q
 N1HQpi4fXNICnm8Bb0W5xAY3vFb0OCSYovE9XyzhiuoV7NuiJ0ws4bHZu2JriaerrRdw ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh6jrgdey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 17:36:50 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 313HRvcQ014450;
        Fri, 3 Feb 2023 17:36:50 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh6jrgdd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 17:36:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 312H2fjE012974;
        Fri, 3 Feb 2023 17:36:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ncvt7ng46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 17:36:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 313HahnG22282906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 17:36:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C8EE20043;
        Fri,  3 Feb 2023 17:36:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D8E120040;
        Fri,  3 Feb 2023 17:36:43 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.195.237])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Feb 2023 17:36:43 +0000 (GMT)
Message-ID: <7785ea2cb7530647fcc38321d81745ce16f8055f.camel@linux.ibm.com>
Subject: Re: [PATCH v15 03/11] target/s390x/cpu topology: handle STSI(15)
 and build the SYSIB
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Fri, 03 Feb 2023 18:36:43 +0100
In-Reply-To: <20230201132051.126868-4-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d3D216YdsY24a1F-bOoDpCbqUdi_UzfQ
X-Proofpoint-ORIG-GUID: d0bnvfYklDGT8VdSXEzGhDHPfyWttXNb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_17,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 mlxscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030157
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> > On interception of STSI(15.1.x) the System Information Block
> > (SYSIB) is built from the list of pre-ordered topology entries.
> >=20
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  include/hw/s390x/cpu-topology.h |  22 +++
> >  include/hw/s390x/sclp.h         |   1 +
> >  target/s390x/cpu.h              |  72 +++++++
> >  hw/s390x/cpu-topology.c         |  10 +
> >  target/s390x/kvm/cpu_topology.c | 335 ++++++++++++++++++++++++++++++++
> >  target/s390x/kvm/kvm.c          |   5 +-
> >  target/s390x/kvm/meson.build    |   3 +-
> >  7 files changed, 446 insertions(+), 2 deletions(-)
> >  create mode 100644 target/s390x/kvm/cpu_topology.c
> >=20
[...]
> >=20
> > diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> > index d654267a71..e1f6925856 100644
> > --- a/target/s390x/cpu.h
> > +++ b/target/s390x/cpu.h
[...]
> > +
> > +/* CPU type Topology List Entry */
> > +typedef struct SysIBTl_cpu {
> > +        uint8_t nl;
> > +        uint8_t reserved0[3];
> > +#define SYSIB_TLE_POLARITY_MASK 0x03
> > +#define SYSIB_TLE_DEDICATED     0x04
> > +        uint8_t entitlement;

I would just call this flags, since it's multiple fields.

> > +        uint8_t type;
> > +        uint16_t origin;
> > +        uint64_t mask;
> > +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_cpu;
> > +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) !=3D 16);
> >=20
> > +
> >=20
[...]
> >  /**
> > diff --git a/target/s390x/kvm/cpu_topology.c b/target/s390x/kvm/cpu_top=
ology.c
> > new file mode 100644
> > index 0000000000..aba141fb66
> > --- /dev/null
> > +++ b/target/s390x/kvm/cpu_topology.c
> >=20
[...]
> > +
> > +/*
> > + * Macro to check that the size of data after increment
> > + * will not get bigger than the size of the SysIB.
> > + */
> > +#define SYSIB_GUARD(data, x) do {       \
> > +        data +=3D x;                      \
> > +        if (data  > sizeof(SysIB)) {    \
> > +            return -ENOSPC;             \

I would go with ENOMEM here.

> > +        }                               \
> > +    } while (0)
> > +
> > +/**
> > + * stsi_set_tle:
> > + * @p: A pointer to the position of the first TLE
> > + * @level: The nested level wanted by the guest
> > + *
> > + * Loop inside the s390_topology.list until the sentinelle entry

s/sentinelle/sentinel/

> > + * is found and for each entry:
> > + *   - Check using SYSIB_GUARD() that the size of the SysIB is not
> > + *     reached.
> > + *   - Add all the container TLE needed for the level
> > + *   - Add the CPU TLE.

I'd focus more on *what* the function does instead of *how*.

Fill the SYSIB with the topology information as described in the PoP,
nesting containers as appropriate, with the maximum nesting limited by @lev=
el.

Or something similar.

> > + *
> > + * Return value:
> > + * s390_top_set_level returns the size of the SysIB_15x after being

You forgot to rename the function here, right?
How about stsi_fill_topology_sysib or stsi_topology_fill_sysib, instead?

> > + * filled with TLE on success.
> > + * It returns -ENOSPC in the case we would overrun the end of the SysI=
B.

You would have to change to ENOMEM here than also.

> > + */
> > +static int stsi_set_tle(char *p, int level)
> > +{
> > +    S390TopologyEntry *entry;
> > +    int last_drawer =3D -1;
> > +    int last_book =3D -1;
> > +    int last_socket =3D -1;
> > +    int drawer_id =3D 0;
> > +    int book_id =3D 0;
> > +    int socket_id =3D 0;
> > +    int n =3D sizeof(SysIB_151x);
> > +
> > +    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
> > +        int current_drawer =3D entry->id.drawer;
> > +        int current_book =3D entry->id.book;
> > +        int current_socket =3D entry->id.socket;

This only saves two characters, so you could just use entry->id. ...

> > +        bool drawer_change =3D last_drawer !=3D current_drawer;
> > +        bool book_change =3D drawer_change || last_book !=3D current_b=
ook;
> > +        bool socket_change =3D book_change || last_socket !=3D current=
_socket;

... but keep it if it would make this line too long.
You could also rename entry, to current or cur, if you want to emphasize th=
at.

> > +
> > +        /* If we reach the guard get out */
> > +        if (entry->id.level5) {
> > +            break;
> > +        }
> > +
> > +        if (level > 3 && drawer_change) {
> > +            SYSIB_GUARD(n, sizeof(SysIBTl_container));
> > +            p =3D fill_container(p, 3, drawer_id++);
> > +            book_id =3D 0;
> > +        }
> > +        if (level > 2 && book_change) {
> > +            SYSIB_GUARD(n, sizeof(SysIBTl_container));
> > +            p =3D fill_container(p, 2, book_id++);
> > +            socket_id =3D 0;
> > +        }
> > +        if (socket_change) {
> > +            SYSIB_GUARD(n, sizeof(SysIBTl_container));
> > +            p =3D fill_container(p, 1, socket_id++);
> > +        }
> > +
> > +        SYSIB_GUARD(n, sizeof(SysIBTl_cpu));
> > +        p =3D fill_tle_cpu(p, entry);
> > +        last_drawer =3D entry->id.drawer;
> > +        last_book =3D entry->id.book;
> > +        last_socket =3D entry->id.socket;
> > +    }
> > +
> > +    return n;
> > +}
> > +
> > +/**
> > + * setup_stsi:
> > + * sysib: pointer to a SysIB to be filled with SysIB_151x data
> > + * level: Nested level specified by the guest
> > + *
> > + * Setup the SysIB_151x header before calling stsi_set_tle with
> > + * a pointer to the first TLE entry.

Same thing here with regards to describing the what.

Setup the SYSIB for STSI 15.1, the header as well as the description
of the topology.

> > + */
> > +static int setup_stsi(SysIB_151x *sysib, int level)
> > +{
> > +    sysib->mnest =3D level;
> > +    switch (level) {
> > +    case 4:
> > +        sysib->mag[S390_TOPOLOGY_MAG4] =3D current_machine->smp.drawer=
s;
> > +        sysib->mag[S390_TOPOLOGY_MAG3] =3D current_machine->smp.books;
> > +        sysib->mag[S390_TOPOLOGY_MAG2] =3D current_machine->smp.socket=
s;
> > +        sysib->mag[S390_TOPOLOGY_MAG1] =3D current_machine->smp.cores;
> > +        break;
> > +    case 3:
> > +        sysib->mag[S390_TOPOLOGY_MAG3] =3D current_machine->smp.drawer=
s *
> > +                                         current_machine->smp.books;
> > +        sysib->mag[S390_TOPOLOGY_MAG2] =3D current_machine->smp.socket=
s;
> > +        sysib->mag[S390_TOPOLOGY_MAG1] =3D current_machine->smp.cores;
> > +        break;
> > +    case 2:
> > +        sysib->mag[S390_TOPOLOGY_MAG2] =3D current_machine->smp.drawer=
s *
> > +                                         current_machine->smp.books *
> > +                                         current_machine->smp.sockets;
> > +        sysib->mag[S390_TOPOLOGY_MAG1] =3D current_machine->smp.cores;
> > +        break;
> > +    }
> > +
> > +    return stsi_set_tle(sysib->tle, level);
> > +}
> > +
> > +/**
> > + * s390_topology_add_cpu_to_entry:
> > + * @entry: Topology entry to setup
> > + * @cpu: the S390CPU to add
> > + *
> > + * Set the core bit inside the topology mask and
> > + * increments the number of cores for the socket.
> > + */
> > +static void s390_topology_add_cpu_to_entry(S390TopologyEntry *entry,
> > +                                           S390CPU *cpu)
> > +{
> > +    set_bit(63 - (cpu->env.core_id % 64), &entry->mask);
> > +}
> > +
> > +/**
> > + * s390_topology_new_entry:
> > + * @id: s390_topology_id to add
> > + * @cpu: the S390CPU to add
> > + *
> > + * Allocate a new entry and initialize it.
> > + *
> > + * returns the newly allocated entry.
> > + */
> > +static S390TopologyEntry *s390_topology_new_entry(s390_topology_id id,
> > +                                                  S390CPU *cpu)

This is used only once, right?
I think I'd go ahead and inline it into s390_topology_insert, since I had
to go back and check if new_entry calls add_cpu when reading s390_topology_=
insert.

> > +{
> > +    S390TopologyEntry *entry;
> > +
> > +    entry =3D g_malloc0(sizeof(S390TopologyEntry));
> > +    entry->id.id =3D id.id;
> > +    s390_topology_add_cpu_to_entry(entry, cpu);
> > +
> > +    return entry;
> > +}
> > +
> > +/**
> > + * s390_topology_from_cpu:
> > + * @cpu: The S390CPU
> > + *
> > + * Initialize the topology id from the CPU environment.
> > + */
> > +static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
> > +{
> > +    s390_topology_id topology_id =3D {0};
> > +
> > +    topology_id.drawer =3D cpu->env.drawer_id;
> > +    topology_id.book =3D cpu->env.book_id;
> > +    topology_id.socket =3D cpu->env.socket_id;
> > +    topology_id.origin =3D cpu->env.core_id / 64;
> > +    topology_id.type =3D S390_TOPOLOGY_CPU_IFL;
> > +    topology_id.dedicated =3D cpu->env.dedicated;
> > +
> > +    if (s390_topology.polarity =3D=3D POLARITY_VERTICAL) {
> > +        /*
> > +         * Vertical polarity with dedicated CPU implies
> > +         * vertical high entitlement.
> > +         */
> > +        if (topology_id.dedicated) {
> > +            topology_id.polarity |=3D POLARITY_VERTICAL_HIGH;
> > +        } else {
> > +            topology_id.polarity |=3D cpu->env.entitlement;
> > +        }
> > +    }
> > +
> > +    return topology_id;
> > +}
> > +
> > +/**
> > + * s390_topology_insert:
> > + * @cpu: s390CPU insert.
> > + *
> > + * Parse the topology list to find if the entry already
> > + * exist and add the core in it.
> > + * If it does not exist, allocate a new entry and insert
> > + * it in the queue from lower id to greater id.
> > + */
> > +static void s390_topology_insert(S390CPU *cpu)
> > +{
> > +    s390_topology_id id =3D s390_topology_from_cpu(cpu);
> > +    S390TopologyEntry *entry =3D NULL;
> > +    S390TopologyEntry *tmp =3D NULL;
> > +
> > +    QTAILQ_FOREACH(tmp, &s390_topology.list, next) {
> > +        if (id.id =3D=3D tmp->id.id) {
> > +            s390_topology_add_cpu_to_entry(tmp, cpu);
> > +            return;
> > +        } else if (id.id < tmp->id.id) {
> > +            entry =3D s390_topology_new_entry(id, cpu);
> > +            QTAILQ_INSERT_BEFORE(tmp, entry, next);
> > +            return;
> > +        }
> > +    }
> > +}
> > +
> > +/**
> > + * s390_order_tle:
> > + *
> > + * Loop over all CPU and insert it at the right place
> > + * inside the TLE entry list.
> > + */

Suggestion:

s390_topology_fill_list_sorted

Fill the S390Topology list with entries according to the order specified
by the PoP.

> > +static void s390_order_tle(void)
> > +{
> > +    CPUState *cs;
> > +
> > +    CPU_FOREACH(cs) {
> > +        s390_topology_insert(S390_CPU(cs));
> > +    }
> > +}
> > +
> > +/**
> > + * s390_free_tle:
> > + *
> > + * Loop over all TLE entries and free them.
> > + * Keep the sentinelle which is the only one with level5 !=3D 0

s/sentinelle/sentinel/

> > + */

Suggestion:
s390_topology_empty_list

Clear all entries in the S390Topology list except the sentinel.

> > +static void s390_free_tle(void)
> > +{
> > +    S390TopologyEntry *entry =3D NULL;
> > +    S390TopologyEntry *tmp =3D NULL;
> > +
> > +    QTAILQ_FOREACH_SAFE(entry, &s390_topology.list, next, tmp) {
> > +        if (!entry->id.level5) {
> > +            QTAILQ_REMOVE(&s390_topology.list, entry, next);
> > +            g_free(entry);
> > +        }
> > +    }
> > +}
> > +
> > +/**
> > + * insert_stsi_15_1_x:
> > + * cpu: the CPU doing the call for which we set CC
> > + * sel2: the selector 2, containing the nested level
> > + * addr: Guest logical address of the guest SysIB
> > + * ar: the access register number
> > + *
> > + * Reserve a zeroed SysIB, let setup_stsi to fill it and
> > + * copy the SysIB to the guest memory.
> > + *
> > + * In case of overflow set CC(3) and no copy is done.

Suggestion:

Emulate STSI 15.1.x, that is, perform all necessary checks and fill the SYS=
IB.
In case the topology description is too long to fit into the SYSIB,
set CC=3D3 and abort without writing the SYSIB.
=20
> > + */
> > +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar=
)
> > +{
> > +    SysIB sysib =3D {0};
> > +    int len;
> > +
> > +    if (!s390_has_topology() || sel2 < 2 || sel2 > SCLP_READ_SCP_INFO_=
MNEST) {
> > +        setcc(cpu, 3);
> > +        return;
> > +    }
> > +
> > +    s390_order_tle();
> > +
> > +    len =3D setup_stsi(&sysib.sysib_151x, sel2);
> > +
> > +    if (len < 0) {

I stumbled a bit over this, maybe rename len to r.

> > +        setcc(cpu, 3);
> > +        return;
> > +    }
> > +
> > +    sysib.sysib_151x.length =3D cpu_to_be16(len);
> > +    s390_cpu_virt_mem_write(cpu, addr, ar, &sysib, len);
> > +    setcc(cpu, 0);
> > +
> > +    s390_free_tle();
> > +}
> > diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> > index 3ac7ec9acf..5ea358cbb0 100644
> > --- a/target/s390x/kvm/kvm.c
> > +++ b/target/s390x/kvm/kvm.c
> > @@ -1919,9 +1919,12 @@ static int handle_stsi(S390CPU *cpu)
> >          if (run->s390_stsi.sel1 !=3D 2 || run->s390_stsi.sel2 !=3D 2) =
{
> >              return 0;
> >          }
> > -        /* Only sysib 3.2.2 needs post-handling for now. */
> >          insert_stsi_3_2_2(cpu, run->s390_stsi.addr, run->s390_stsi.ar)=
;
> >          return 0;
> > +    case 15:
> > +        insert_stsi_15_1_x(cpu, run->s390_stsi.sel2, run->s390_stsi.ad=
dr,
> > +                           run->s390_stsi.ar);
> > +        return 0;
> >      default:
> >          return 0;
> >      }
> > diff --git a/target/s390x/kvm/meson.build b/target/s390x/kvm/meson.buil=
d
> > index aef52b6686..5daa5c6033 100644
> > --- a/target/s390x/kvm/meson.build
> > +++ b/target/s390x/kvm/meson.build
> > @@ -1,6 +1,7 @@
> > =20
> >  s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
> > -  'kvm.c'
> > +  'kvm.c',
> > +  'cpu_topology.c'
> >  ), if_false: files(
> >    'stubs.c'
> >  ))


