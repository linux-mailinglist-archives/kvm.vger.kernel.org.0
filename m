Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4545068F744
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 19:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjBHSla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 13:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjBHSlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 13:41:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7653E2725
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 10:41:17 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318HSgRc003826;
        Wed, 8 Feb 2023 18:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zD/jVmvRFVSK3cqs4J7KfaDgF1ly3z6JESPcbbTc64k=;
 b=qITC8tMEcpabTSUI+cS3gDiHTpsgQBsyAOH0C5zJqOfV+WbLOSZd9W0ov8zK7OEoJUuJ
 F0zAbyW+84Qg0FwJKcf5CdqwyXsv9hcTRuLcSighm+gPlL2Mc1FiVuIPOTBqs9lorOFq
 ZA22ohdBIVHqXUIT9ASu5RmAo15pNppNlXK4XKoqHyiZKNyrsRjlOJVo8+DIop1DAeXW
 4et2A2LmhXiqGeE21VEclD9o1qYVA4Y/qgJ3DMli/WfYFBcbNrvXgJWDpFBOTTrI2x3v
 HDPCJrvv2voUnbi41tscq4yL3p08j3ElIsdcFUSz8i4Zb3iB1R1hIh9KSE+8G6IgqeEA xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmg5tac5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 18:41:03 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 318I735f005716;
        Wed, 8 Feb 2023 18:41:03 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmg5tac31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 18:41:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3185boHx001883;
        Wed, 8 Feb 2023 18:41:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06n7ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 18:41:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 318Ieu4k47907150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Feb 2023 18:40:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 711BC20043;
        Wed,  8 Feb 2023 18:40:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04C3920040;
        Wed,  8 Feb 2023 18:40:56 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.183.35])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Feb 2023 18:40:55 +0000 (GMT)
Message-ID: <5775d58faf9505e561c81baa3807f01a1e0621b4.camel@linux.ibm.com>
Subject: Re: [PATCH v15 08/11] qapi/s390x/cpu topology: x-set-cpu-topology
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
Date:   Wed, 08 Feb 2023 19:40:55 +0100
In-Reply-To: <20230201132051.126868-9-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MOwkDGlapOGCwE8AMdju5tAoNa87nBPD
X-Proofpoint-GUID: 1V7LA3Du5uZYBtG85sM1QGUr4-dV2ELf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_09,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080161
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> The modification of the CPU attributes are done through a monitor
> command.
>=20
> It allows to move the core inside the topology tree to optimise
> the cache usage in the case the host's hypervisor previously
> moved the CPU.
>=20
> The same command allows to modify the CPU attributes modifiers
> like polarization entitlement and the dedicated attribute to notify
> the guest if the host admin modified scheduling or dedication of a vCPU.
>=20
> With this knowledge the guest has the possibility to optimize the
> usage of the vCPUs.
>=20
> The command is made experimental for the moment.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine-target.json | 29 +++++++++++++
>  include/monitor/hmp.h    |  1 +
>  hw/s390x/cpu-topology.c  | 88 ++++++++++++++++++++++++++++++++++++++++
>  hmp-commands.hx          | 16 ++++++++
>  4 files changed, 134 insertions(+)
>=20
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 2e267fa458..58df0f5061 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -342,3 +342,32 @@
>                     'TARGET_S390X',
>                     'TARGET_MIPS',
>                     'TARGET_LOONGARCH64' ] } }
> +
> +##
> +# @x-set-cpu-topology:
> +#
> +# @core: the vCPU ID to be moved
> +# @socket: the destination socket where to move the vCPU
> +# @book: the destination book where to move the vCPU
> +# @drawer: the destination drawer where to move the vCPU

I wonder if it wouldn't be more convenient for the caller if everything is =
optional.

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
> +{ 'command': 'x-set-cpu-topology',
> +  'data': {
> +      'core': 'int',
> +      'socket': 'int',
> +      'book': 'int',
> +      'drawer': 'int',

Did you consider naming those core-id, etc.? It would be consistent with
query-cpus-fast/CpuInstanceProperties. Also all your variables end with _id=
.
I don't care really just wanted to point it out.

> +      '*polarity': 'int',
> +      '*dedicated': 'bool'
> +  },
> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> +}

So apparently this is the old way of doing an experimental api.

> Names beginning with ``x-`` used to signify "experimental".  This
> convention has been replaced by special feature "unstable".

> Feature "unstable" marks a command, event, enum value, or struct
> member as unstable.  It is not supported elsewhere so far.  Interfaces
> so marked may be withdrawn or changed incompatibly in future releases.

> diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
> index 1b3bdcb446..12827479cf 100644
> --- a/include/monitor/hmp.h
> +++ b/include/monitor/hmp.h
> @@ -151,5 +151,6 @@ void hmp_human_readable_text_helper(Monitor *mon,
>                                      HumanReadableText *(*qmp_handler)(Er=
ror **));
>  void hmp_info_stats(Monitor *mon, const QDict *qdict);
>  void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
> +void hmp_x_set_cpu_topology(Monitor *mon, const QDict *qdict);
> =20
>  #endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index c33378577b..6c50050991 100644
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
> @@ -379,3 +383,87 @@ void s390_topology_set_cpu(MachineState *ms, S390CPU=
 *cpu, Error **errp)
>      /* topology tree is reflected in props */
>      s390_update_cpu_props(ms, cpu);
>  }
> +
> +/*
> + * qmp and hmp implementations
> + */
> +
> +static void s390_change_topology(int64_t core_id, int64_t socket_id,
> +                                 int64_t book_id, int64_t drawer_id,
> +                                 int64_t polarity, bool dedicated,
> +                                 Error **errp)
> +{
> +    MachineState *ms =3D current_machine;
> +    S390CPU *cpu;
> +    ERRP_GUARD();
> +
> +    cpu =3D (S390CPU *)ms->possible_cpus->cpus[core_id].cpu;
> +    if (!cpu) {
> +        error_setg(errp, "Core-id %ld does not exist!", core_id);
> +        return;
> +    }
> +
> +    /* Verify the new topology */
> +    s390_topology_check(cpu, errp);
> +    if (*errp) {
> +        return;
> +    }
> +
> +    /* Move the CPU into its new socket */
> +    s390_set_core_in_socket(cpu, drawer_id, book_id, socket_id, true, er=
rp);

The cpu isn't being created, so that should be false instead of true, right=
?

> +
> +    /* All checks done, report topology in environment */
> +    cpu->env.drawer_id =3D drawer_id;
> +    cpu->env.book_id =3D book_id;
> +    cpu->env.socket_id =3D socket_id;
> +    cpu->env.dedicated =3D dedicated;
> +    cpu->env.entitlement =3D polarity;
> +
> +    /* topology tree is reflected in props */
> +    s390_update_cpu_props(ms, cpu);
> +
> +    /* Advertise the topology change */
> +    s390_cpu_topology_set_modified();
> +}
> +
> +void qmp_x_set_cpu_topology(int64_t core, int64_t socket,
> +                         int64_t book, int64_t drawer,
> +                         bool has_polarity, int64_t polarity,
> +                         bool has_dedicated, bool dedicated,
> +                         Error **errp)
> +{
> +    ERRP_GUARD();
> +
> +    if (!s390_has_topology()) {
> +        error_setg(errp, "This machine doesn't support topology");
> +        return;
> +    }
> +    if (!has_polarity) {
> +        polarity =3D POLARITY_VERTICAL_MEDIUM;
> +    }
> +    if (!has_dedicated) {
> +        dedicated =3D false;
> +    }
> +    s390_change_topology(core, socket, book, drawer, polarity, dedicated=
, errp);
> +}
> +
> +void hmp_x_set_cpu_topology(Monitor *mon, const QDict *qdict)
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
> +    qmp_x_set_cpu_topology(core, socket, book, drawer,
> +                           has_polarity, polarity,
> +                           has_dedicated, dedicated,
> +                           &local_err);
> +    if (hmp_handle_error(mon, local_err)) {
> +        return;
> +    }

What is the if for? The function ends anyway.

> +}
> diff --git a/hmp-commands.hx b/hmp-commands.hx
> index 673e39a697..bb3c908356 100644
> --- a/hmp-commands.hx
> +++ b/hmp-commands.hx
> @@ -1815,3 +1815,19 @@ SRST
>    Dump the FDT in dtb format to *filename*.
>  ERST
>  #endif
> +
> +#if defined(TARGET_S390X) && defined(CONFIG_KVM)
> +    {
> +        .name       =3D "x-set-cpu-topology",
> +        .args_type  =3D "core:l,socket:l,book:l,drawer:l,polarity:l?,ded=
icated:b?",
> +        .params     =3D "core socket book drawer [polarity] [dedicated]"=
,
> +        .help       =3D "Move CPU 'core' to 'socket/book/drawer' "
> +                      "optionaly modifies polarity and dedication",
> +        .cmd        =3D hmp_x_set_cpu_topology,
> +    },
> +
> +SRST
> +``x-set-cpu-topology`` *core* *socket* *book* *drawer* *polarity* *dedic=
ated*
> +  Moves the CPU  *core* to *socket* *book* *drawer* with *polarity* *ded=
icated*.
> +ERST
> +#endif

