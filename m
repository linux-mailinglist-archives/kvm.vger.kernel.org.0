Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1096F4915
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 19:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbjEBRWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 13:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjEBRWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 13:22:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4979AE43
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 10:22:33 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342HLTfL011588;
        Tue, 2 May 2023 17:22:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0Vp9RhcuRtqSZ7grQzXnBkV9Fwe82wsnWbzsb/SU6nk=;
 b=M+JNCsoGkDlXKxjWRDbcIl56u3Bb6E2Fabo6p+d6ZLxoCUz6FPM1sSW8YrDcvCEL/FuV
 RqIjVb/zGMkmMVcfEtl5q1n2tgSqUZ0qvO1Cp524TFzUONdds8gnLqA0EkVBB+T2Qwly
 KyVJ2T4uXyoAdR8uiBkg/3bnG2nLgoysoNZWnTjN4WgndR+oiruKTmi4XuYsgLrWCVx8
 5B/GsU4aZJFaZ5OF/yeUH+uN+9Q1TDsFbhzwKD4GKN90F+/9CpaFKFAM23FbgeTnPAXK
 z+yTbfFxjg26Vu75Lvs/tFwXPf49nsbmjp5lG1c3p1FF25uxG+C/vsQhgafoyd8kvfaG Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb6qv0bbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 17:22:25 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342HE1Qh008234;
        Tue, 2 May 2023 17:22:25 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb6qv0baa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 17:22:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3424iEtg021182;
        Tue, 2 May 2023 17:22:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q8tgg1r51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 17:22:22 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342HMGTo30867856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 17:22:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B526720043;
        Tue,  2 May 2023 17:22:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 776CE20040;
        Tue,  2 May 2023 17:22:15 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.2.121])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 17:22:15 +0000 (GMT)
Message-ID: <5f4fa29eaec7269350403b2d1b2b051e6aa59a39.camel@linux.ibm.com>
Subject: Re: [PATCH v20 03/21] target/s390x/cpu topology: handle STSI(15)
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
Date:   Tue, 02 May 2023 19:22:15 +0200
In-Reply-To: <20230425161456.21031-4-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
         <20230425161456.21031-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _CNOp6IbdHxRBq2u0uGyvpHrFjJqLlYW
X-Proofpoint-ORIG-GUID: hAV8-OrR6W8Efiz8qINWpsnHx1ycu-pD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_10,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 priorityscore=1501 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
> On interception of STSI(15.1.x) the System Information Block
> (SYSIB) is built from the list of pre-ordered topology entries.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  MAINTAINERS                     |   1 +
>  include/hw/s390x/cpu-topology.h |  24 +++
>  include/hw/s390x/sclp.h         |   1 +
>  target/s390x/cpu.h              |  72 ++++++++
>  hw/s390x/cpu-topology.c         |  13 +-
>  target/s390x/kvm/cpu_topology.c | 308 ++++++++++++++++++++++++++++++++
>  target/s390x/kvm/kvm.c          |   5 +-
>  target/s390x/kvm/meson.build    |   3 +-
>  8 files changed, 424 insertions(+), 3 deletions(-)
>  create mode 100644 target/s390x/kvm/cpu_topology.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bb7b34d0d8..de9052f753 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1659,6 +1659,7 @@ M: Pierre Morel <pmorel@linux.ibm.com>
>  S: Supported
>  F: include/hw/s390x/cpu-topology.h
>  F: hw/s390x/cpu-topology.c
> +F: target/s390x/kvm/cpu_topology.c
> =20
>  X86 Machines
>  ------------
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topol=
ogy.h
> index af36f634e0..87bfeb631e 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -15,9 +15,33 @@
>=20
[...]

> +typedef struct S390TopologyEntry {
> +    QTAILQ_ENTRY(S390TopologyEntry) next;
> +    s390_topology_id id;
> +    uint64_t mask;
> +} S390TopologyEntry;
> +
>  typedef struct S390Topology {
>      uint8_t *cores_per_socket;
> +    QTAILQ_HEAD(, S390TopologyEntry) list;

Since you recompute the list on every STSI, you no longer need this in here=
.
You can create it in insert_stsi_15_1_x.

>      CpuTopology *smp;
> +    bool vertical_polarization;
>  } S390Topology;

[...]

> +/*
> + * Macro to check that the size of data after increment
> + * will not get bigger than the size of the SysIB.
> + */
> +#define SYSIB_GUARD(data, x) do {       \
> +        data +=3D x;                      \
> +        if (data  > sizeof(SysIB)) {    \
                    ^ two spaces

> +            return 0;                   \
> +        }                               \
> +    } while (0)
> +

[...]

> +/**
> + * s390_topology_from_cpu:
> + * @cpu: The S390CPU
> + *
> + * Initialize the topology id from the CPU environment.
> + */
> +static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
> +{
> +    s390_topology_id topology_id =3D {0};
> +
> +    topology_id.drawer =3D cpu->env.drawer_id;
> +    topology_id.book =3D cpu->env.book_id;
> +    topology_id.socket =3D cpu->env.socket_id;
> +    topology_id.origin =3D cpu->env.core_id / 64;
> +    topology_id.type =3D S390_TOPOLOGY_CPU_IFL;
> +    topology_id.dedicated =3D cpu->env.dedicated;
> +
> +    if (s390_topology.vertical_polarization) {
> +        /*
> +         * Vertical polarization with dedicated CPU implies
> +         * vertical high entitlement.
> +         */

This has already been adjusted or rejected when the entitlement was set.

> +        if (topology_id.dedicated) {
> +            topology_id.entitlement =3D S390_CPU_ENTITLEMENT_HIGH;
> +        } else {
> +            topology_id.entitlement =3D cpu->env.entitlement;

You only need this assignment.
> +        }
> +    }
> +
> +    return topology_id;

[...]

