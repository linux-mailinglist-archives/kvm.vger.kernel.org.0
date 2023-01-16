Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE6E66D0BA
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 22:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbjAPVKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 16:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbjAPVJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 16:09:59 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B1FEC42
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 13:09:58 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GKpM6E025518;
        Mon, 16 Jan 2023 21:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JhHluoxsphf/vJwKyXfY5HaurblVcADBx4r/ut2H2G8=;
 b=cIjc3mgisRvk2N4ppa4V0MCD/IWEIDVs0tvmsZH0pUN8pFqg+esQ5JR1VecFVCBpX4Ws
 bBgodDxrHI+PhgcjCwxw3qa2USRuqxZ2nMGUCrjdjEMSYTbGmyWc54bfJ8TmUY1Ml+BK
 oetCJHOVWpNZa2FOuzLXjgAEB/kBJcwkYhkGcDzwXOaq80j/zuYz/P2C+75Zjks94ND9
 vUgbdfNuR+u4ME2kcEMAO69xU71COqD7Ut2v8dOfQnt0JVif/Us1kJsEfNXg3ENn9bzU
 45svdgQHh41jBdylYW829+t4fvrwDfYPS6raLSab/ISejI6ATExCg5sIPzzuw5Mz6S7f 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5dym89jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 21:09:45 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GKwts3018357;
        Mon, 16 Jan 2023 21:09:45 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5dym89j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 21:09:45 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GCOQFN017351;
        Mon, 16 Jan 2023 21:09:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16jwp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 21:09:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GL9dDu43450736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 21:09:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E93620043;
        Mon, 16 Jan 2023 21:09:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1C2820040;
        Mon, 16 Jan 2023 21:09:38 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.176.184])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 21:09:38 +0000 (GMT)
Message-ID: <72baa5b42abe557cdf123889b33b845b405cc86c.camel@linux.ibm.com>
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology:  change-topology
 monitor command
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 16 Jan 2023 22:09:38 +0100
In-Reply-To: <20230105145313.168489-9-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uzE-Sa1BKixOCnjVQhOTWRHUQD9lT4Bd
X-Proofpoint-GUID: 5VDqwYc09Lih5xphpL1Ru60AXxVCgUIm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_16,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 malwarescore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160155
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
> The modification of the CPU attributes are done through a monitor
> commands.
>=20
> It allows to move the core inside the topology tree to optimise
> the cache usage in the case the host's hypervizor previously
> moved the CPU.
>=20
> The same command allows to modifiy the CPU attributes modifiers
> like polarization entitlement and the dedicated attribute to notify
> the guest if the host admin modified scheduling or dedication of a vCPU.
>=20
> With this knowledge the guest has the possibility to optimize the
> usage of the vCPUs.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine-target.json |  29 ++++++++
>  include/monitor/hmp.h    |   1 +
>  hw/s390x/cpu-topology.c  | 141 +++++++++++++++++++++++++++++++++++++++
>  hmp-commands.hx          |  16 +++++
>  4 files changed, 187 insertions(+)
>=20
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 2e267fa458..75b0aa254d 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -342,3 +342,32 @@
>                     'TARGET_S390X',
>                     'TARGET_MIPS',
>                     'TARGET_LOONGARCH64' ] } }
> +
> +##
> +# @change-topology:
> +#
> +# @core: the vCPU ID to be moved
> +# @socket: the destination socket where to move the vCPU
> +# @book: the destination book where to move the vCPU
> +# @drawer: the destination drawer where to move the vCPU
> +# @polarity: optional polarity, default is last polarity set by the gues=
t
> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
> +#
> +# Modifies the topology by moving the CPU inside the topology
> +# tree or by changing a modifier attribute of a CPU.
> +#
> +# Returns: Nothing on success, the reason on failure.
> +#
> +# Since: <next qemu stable release, eg. 1.0>
> +##
> +{ 'command': 'change-topology',
> +  'data': {
> +      'core': 'int',
> +      'socket': 'int',
> +      'book': 'int',
> +      'drawer': 'int',
> +      '*polarity': 'int',
> +      '*dedicated': 'bool'
> +  },
> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> +}
> diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
> index 27f86399f7..15c36bf549 100644
> --- a/include/monitor/hmp.h
> +++ b/include/monitor/hmp.h
> @@ -144,5 +144,6 @@ void hmp_human_readable_text_helper(Monitor *mon,
>                                      HumanReadableText *(*qmp_handler)(Er=
ror **));
>  void hmp_info_stats(Monitor *mon, const QDict *qdict);
>  void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
> +void hmp_change_topology(Monitor *mon, const QDict *qdict);
> =20
>  #endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index b69955a1cd..0faffe657e 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -18,6 +18,10 @@
>  #include "target/s390x/cpu.h"
>  #include "hw/s390x/s390-virtio-ccw.h"
>  #include "hw/s390x/cpu-topology.h"
> +#include "qapi/qapi-commands-machine-target.h"
> +#include "qapi/qmp/qdict.h"
> +#include "monitor/hmp.h"
> +#include "monitor/monitor.h"
> =20
>  /*
>   * s390_topology is used to keep the topology information.
> @@ -203,6 +207,21 @@ static void s390_topology_set_entry(S390TopologyEntr=
y *entry,
>      s390_topology.sockets[s390_socket_nb(id)]++;
>  }
> =20
> +/**
> + * s390_topology_clear_entry:
> + * @entry: Topology entry to setup
> + * @id: topology id to use for the setup
> + *
> + * Clear the core bit inside the topology mask and
> + * decrements the number of cores for the socket.
> + */
> +static void s390_topology_clear_entry(S390TopologyEntry *entry,
> +                                      s390_topology_id id)
> +{
> +    clear_bit(63 - id.core, &entry->mask);

This doesn't take the origin into account.

> +    s390_topology.sockets[s390_socket_nb(id)]--;

I suppose this function cannot run concurrently, so the same CPU doesn't ge=
t removed twice.

> +}
> +
>  /**
>   * s390_topology_new_entry:
>   * @id: s390_topology_id to add
> @@ -383,3 +402,125 @@ void s390_topology_set_cpu(MachineState *ms, S390CP=
U *cpu, Error **errp)
> =20
>      s390_topology_insert(id);
>  }
> +
> +/*
> + * qmp and hmp implementations
> + */
> +
> +static S390TopologyEntry *s390_topology_core_to_entry(int core)
> +{
> +    S390TopologyEntry *entry;
> +
> +    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
> +        if (entry->mask & (1UL << (63 - core))) {

origin here also.

> +            return entry;
> +        }
> +    }
> +    return NULL;

This should not return NULL unless the core id is invalid.
Might be better to validate that somewhere else.

> +}
> +
> +static void s390_change_topology(Error **errp, int64_t core, int64_t soc=
ket,
> +                                 int64_t book, int64_t drawer,
> +                                 int64_t polarity, bool dedicated)
> +{
> +    S390TopologyEntry *entry;
> +    s390_topology_id new_id;
> +    s390_topology_id old_id;
> +    Error *local_error =3D NULL;

I think you could use ERRP_GUARD here also.
> +
> +    /* Get the old entry */
> +    entry =3D s390_topology_core_to_entry(core);
> +    if (!entry) {
> +        error_setg(errp, "No core %ld", core);
> +        return;
> +    }
> +
> +    /* Compute old topology id */
> +    old_id =3D entry->id;
> +    old_id.core =3D core;
> +
> +    /* Compute new topology id */
> +    new_id =3D entry->id;
> +    new_id.core =3D core;
> +    new_id.socket =3D socket;
> +    new_id.book =3D book;
> +    new_id.drawer =3D drawer;
> +    new_id.p =3D polarity;
> +    new_id.d =3D dedicated;
> +    new_id.type =3D S390_TOPOLOGY_CPU_IFL;
> +
> +    /* Same topology entry, nothing to do */
> +    if (entry->id.id =3D=3D new_id.id) {
> +        return;
> +    }
> +
> +    /* Check for space on the socket if ids are different */
> +    if ((s390_socket_nb(old_id) !=3D s390_socket_nb(new_id)) &&
> +        (s390_topology.sockets[s390_socket_nb(new_id)] >=3D
> +         s390_topology.smp->sockets)) {
> +        error_setg(errp, "No more space on this socket");
> +        return;
> +    }
> +
> +    /* Verify the new topology */
> +    s390_topology_check(&local_error, new_id);
> +    if (local_error) {
> +        error_propagate(errp, local_error);
> +        return;
> +    }
> +
> +    /* Clear the old topology */
> +    s390_topology_clear_entry(entry, old_id);
> +
> +    /* Insert the new topology */
> +    s390_topology_insert(new_id);
> +
> +    /* Remove unused entry */
> +    if (!entry->mask) {
> +        QTAILQ_REMOVE(&s390_topology.list, entry, next);
> +        g_free(entry);
> +    }
> +
> +    /* Advertise the topology change */
> +    s390_cpu_topology_set();
> +}
> +
> +void qmp_change_topology(int64_t core, int64_t socket,
> +                         int64_t book, int64_t drawer,
> +                         bool has_polarity, int64_t polarity,
> +                         bool has_dedicated, bool dedicated,
> +                         Error **errp)
> +{
> +    Error *local_err =3D NULL;
> +
> +    if (!s390_has_topology()) {
> +        error_setg(&local_err, "This machine doesn't support topology");
> +        return;
> +    }

Do you really want to ignore has_polarity and has_dedicated here?
What happens in this case?

> +    s390_change_topology(&local_err, core, socket, book, drawer,
> +                         polarity, dedicated);
> +    if (local_err) {
> +        error_propagate(errp, local_err);
> +    }
> +}
> +
> +void hmp_change_topology(Monitor *mon, const QDict *qdict)
> +{
> +    const int64_t core =3D qdict_get_int(qdict, "core");
> +    const int64_t socket =3D qdict_get_int(qdict, "socket");
> +    const int64_t book =3D qdict_get_int(qdict, "book");
> +    const int64_t drawer =3D qdict_get_int(qdict, "drawer");
> +    bool has_polarity    =3D qdict_haskey(qdict, "polarity");
> +    const int64_t polarity =3D qdict_get_try_int(qdict, "polarity", 0);
> +    bool has_dedicated    =3D qdict_haskey(qdict, "dedicated");
> +    const bool dedicated =3D qdict_get_try_bool(qdict, "dedicated", fals=
e);
> +    Error *local_err =3D NULL;
> +
> +    qmp_change_topology(core, socket, book, drawer,
> +                        has_polarity, polarity,
> +                        has_dedicated, dedicated,
> +                        &local_err);
> +    if (hmp_handle_error(mon, local_err)) {
> +        return;
> +    }
> +}
> diff --git a/hmp-commands.hx b/hmp-commands.hx
> index 673e39a697..a617cfed0d 100644
> --- a/hmp-commands.hx
> +++ b/hmp-commands.hx
> @@ -1815,3 +1815,19 @@ SRST
>    Dump the FDT in dtb format to *filename*.
>  ERST
>  #endif
> +
> +#if defined(TARGET_S390X) && defined(CONFIG_KVM)
> +    {
> +        .name       =3D "change-topology",
> +        .args_type  =3D "core:l,socket:l,book:l,drawer:l,polarity:l?,ded=
icated:b?",
> +        .params     =3D "core socket book drawer [polarity] [dedicated]"=
,
> +        .help       =3D "Move CPU 'core' to 'socket/book/drawer' "
> +                      "optionaly modifies polarity and dedication",
> +        .cmd        =3D hmp_change_topology,
> +    },
> +
> +SRST
> +``change-topology`` *core* *socket* *book* *drawer* *polarity* *dedicate=
d*
> +  Moves the CPU  *core* to *socket* *book* *drawer* with *polarity* *ded=
icated*.
> +ERST
> +#endif

