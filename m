Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D256E5C95
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 10:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjDRIxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 04:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjDRIxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 04:53:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07026EAB
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:53:31 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33I7vmFq007878;
        Tue, 18 Apr 2023 08:53:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=QRuowwPnc0tWLI3bWvznj0z6pdogpau2wkHhoNCOmQQ=;
 b=iwxMumS+rPMiZoTGFJcxhCmxf5aA+tDjdMZG/fGus/DLpCHlffytU4p9dKWtU060CPd2
 YmZWXMh0hHPyWOaPImiXio+jOPXy2A5KQwq1cK88otDgifb/lAKIIVFqKpcGcURhiuwm
 IQz25LNKNNe7f4YKolAgPLVhWGelVGZ6DOs7kuGgIimrM4entoGdXbwCJ/Ltb9lrXK94
 EibJtQSvnJU0U1PMEqP94uBamWQZTitYlmhRoMmwNnSaXdoqgNh7shkeN20X5y2RXx2k
 ScmlD6HXMMx1KJNngePzqXsK6rcYL3R4ndLHrSyieth+2cfm48Evxzu9878nGNDId75s Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1n9rngs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 08:53:15 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33I89fX5013432;
        Tue, 18 Apr 2023 08:53:15 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1n9rngrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 08:53:15 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33HNg0nE028116;
        Tue, 18 Apr 2023 08:53:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pykj69vny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 08:53:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33I8r9NS28443328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 08:53:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A6EB2004B;
        Tue, 18 Apr 2023 08:53:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B15C420043;
        Tue, 18 Apr 2023 08:53:08 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.195.217])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Apr 2023 08:53:08 +0000 (GMT)
Message-ID: <e96e60dade206cb970b55bfc9d2a77643bd14d98.camel@linux.ibm.com>
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Tue, 18 Apr 2023 10:53:08 +0200
In-Reply-To: <20230403162905.17703-2-pmorel@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
         <20230403162905.17703-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: op5CJ2HuMaL_2hZ5TvoBm9lHl8RgFOqL
X-Proofpoint-GUID: J4mgjdMVKBLHmjAPru5_8sO8x76_OQBG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_04,2023-04-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304180074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
> S390 adds two new SMP levels, drawers and books to the CPU
> topology.
> The S390 CPU have specific topology features like dedication
> and entitlement to give to the guest indications on the host
> vCPUs scheduling and help the guest take the best decisions
> on the scheduling of threads on the vCPUs.
>=20
> Let us provide the SMP properties with books and drawers levels
> and S390 CPU with dedication and entitlement,
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  MAINTAINERS                     |  5 ++++
>  qapi/machine-common.json        | 22 ++++++++++++++
>  qapi/machine-target.json        | 12 ++++++++
>  qapi/machine.json               | 17 +++++++++--
>  include/hw/boards.h             | 10 ++++++-
>  include/hw/s390x/cpu-topology.h | 15 ++++++++++

Is hw/s390x the right path for cpu-topology?
I haven't understood the difference between hw/s390x and target/s390x
but target/s390x feels more correct, I could be mistaken though.

>  target/s390x/cpu.h              |  5 ++++
>  hw/core/machine-smp.c           | 53 ++++++++++++++++++++++++++++-----
>  hw/core/machine.c               |  4 +++
>  hw/s390x/s390-virtio-ccw.c      |  2 ++
>  softmmu/vl.c                    |  6 ++++
>  target/s390x/cpu.c              |  7 +++++
>  qapi/meson.build                |  1 +
>  qemu-options.hx                 |  7 +++--
>  14 files changed, 152 insertions(+), 14 deletions(-)
>  create mode 100644 qapi/machine-common.json
>  create mode 100644 include/hw/s390x/cpu-topology.h
>=20
[...]

> diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> new file mode 100644
> index 0000000000..73ea38d976
> --- /dev/null
> +++ b/qapi/machine-common.json
> @@ -0,0 +1,22 @@
> +# -*- Mode: Python -*-
> +# vim: filetype=3Dpython
> +#
> +# This work is licensed under the terms of the GNU GPL, version 2 or lat=
er.
> +# See the COPYING file in the top-level directory.
> +
> +##
> +# =3D Machines S390 data types
> +##
> +
> +##
> +# @CpuS390Entitlement:
> +#
> +# An enumeration of cpu entitlements that can be assumed by a virtual
> +# S390 CPU
> +#
> +# Since: 8.1
> +##
> +{ 'enum': 'CpuS390Entitlement',
> +  'prefix': 'S390_CPU_ENTITLEMENT',
> +  'data': [ 'horizontal', 'low', 'medium', 'high' ] }

You can get rid of the horizontal value now that the entitlement is ignored=
 if the
polarization is vertical.

[...]

> diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
> index b10a8541ff..57165fa3a0 100644
> --- a/target/s390x/cpu.c
> +++ b/target/s390x/cpu.c
> @@ -37,6 +37,7 @@
>  #ifndef CONFIG_USER_ONLY
>  #include "sysemu/reset.h"
>  #endif
> +#include "hw/s390x/cpu-topology.h"
> =20
>  #define CR0_RESET       0xE0UL
>  #define CR14_RESET      0xC2000000UL;
> @@ -259,6 +260,12 @@ static gchar *s390_gdb_arch_name(CPUState *cs)
>  static Property s390x_cpu_properties[] =3D {
>  #if !defined(CONFIG_USER_ONLY)
>      DEFINE_PROP_UINT32("core-id", S390CPU, env.core_id, 0),
> +    DEFINE_PROP_INT32("socket-id", S390CPU, env.socket_id, -1),
> +    DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
> +    DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
> +    DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false),
> +    DEFINE_PROP_UINT8("entitlement", S390CPU, env.entitlement,
> +                      S390_CPU_ENTITLEMENT__MAX),

I would define an entitlement PropertyInfo in qdev-properties-system.[ch],
then one can use e.g.

-device z14-s390x-cpu,core-id=3D11,entitlement=3Dhigh

on the command line and cpu hotplug.

I think setting the default entitlement to medium here should be fine.

[...]


