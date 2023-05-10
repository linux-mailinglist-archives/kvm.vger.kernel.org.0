Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC1E6FDD74
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 14:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbjEJMIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 08:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236747AbjEJMId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 08:08:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572747D96
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 05:08:30 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34AC6fDx003770;
        Wed, 10 May 2023 12:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=WfyfxoMaFp8OiIM9ewpaW0o3VuCH0qb5RNNlXOIXgz4=;
 b=G1EWBNZ1PHV9/KraGsDShA52HlYvLPBH3RSnZcn7nTVzOP0+T7dw4jMiBSDBj7fkYzFu
 OIyos9OJaA6YZDenEqXS9K+EGg0/n24pq4hw/2TB9niWc2v3BonhJeADL64oh2jZkS4v
 GCvwLkaV3Sgdqef50ndorKqZUtXGf+2UNrjANjGj4ZN7YNUYP7wg7Zc/PIWM/Hu6+dDa
 v3fCcBpb3ufXY0Wz5JYvVpOHlg6cVw5JAvNN8nXT44g8bIBxy2j/C80c1zGWZF8gVoYe
 GQi5ovssSpkownwjfsmg3wryY3NFQifs5b/Bo8ww0imTDT2u8ihMUpZ3poDshxYP6Ehr UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qgamdgm2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:08:12 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34AC85vu014484;
        Wed, 10 May 2023 12:08:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qgamdgm14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:08:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A4UPMa015960;
        Wed, 10 May 2023 12:04:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qf7nh121x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:04:26 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34AC4Lae18678378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 12:04:21 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E50CD2004B;
        Wed, 10 May 2023 12:04:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F8482004E;
        Wed, 10 May 2023 12:04:20 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 12:04:20 +0000 (GMT)
Message-ID: <2fa507c7894c6085d6306b1bda23c392d151a680.camel@linux.ibm.com>
Subject: Re: [PATCH v20 12/21] qapi/s390x/cpu topology:
 query-cpu-polarization qmp command
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Wed, 10 May 2023 14:04:20 +0200
In-Reply-To: <20230425161456.21031-13-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
         <20230425161456.21031-13-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XUUeyGVUdUNtn3WJ3EtVK-4API-Hkrq2
X-Proofpoint-ORIG-GUID: q7Q4a8BXFnjIAPRo2c9a71VVeXzrR04v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 impostorscore=0 adultscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305100095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
> The query-cpu-polarization qmp command returns the current
> CPU polarization of the machine.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine-target.json | 30 ++++++++++++++++++++++++++++++
>  hw/s390x/cpu-topology.c  | 14 ++++++++++++++
>  2 files changed, 44 insertions(+)
>=20
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index ffde2e9cbd..8eb05755cd 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -4,6 +4,7 @@
>  # This work is licensed under the terms of the GNU GPL, version 2 or lat=
er.
>  # See the COPYING file in the top-level directory.
> =20
> +{ 'include': 'common.json' }

Why do you need this?

>  { 'include': 'machine-common.json' }
> =20
>  ##
> @@ -424,3 +425,32 @@
>    'features': [ 'unstable' ],
>    'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>  }
> +
> +##
> +# @CpuPolarizationInfo:
> +#
> +# The result of a cpu polarization
> +#
> +# @polarization: the CPU polarization
> +#
> +# Since: 2.8

2.8?

> +##
> +{ 'struct': 'CpuPolarizationInfo',
> +  'data': { 'polarization': 'CpuS390Polarization' },
> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> +}
> +
> +##
> +# @query-cpu-polarization:
> +#
> +# Features:
> +# @unstable: This command may still be modified.
> +#
> +# Returns: the machine polarization
> +#
> +# Since: 8.1
> +##
> +{ 'command': 'query-cpu-polarization', 'returns': 'CpuPolarizationInfo',

Do you need the struct or could you use CpuS390Polarization directly here?
The struct allows for more flexibility in the future, I can't imagine a rea=
son
why it'd be necessary, but I'm not opposed.


> +  'features': [ 'unstable' ],
> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> +}
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index e8b140d623..d440e8a3c6 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -18,6 +18,7 @@
>  #include "hw/s390x/cpu-topology.h"
>  #include "qapi/qapi-commands-machine-target.h"
>  #include "qapi/qapi-events-machine-target.h"
> +#include "qapi/type-helpers.h"

What do you need this include for?

> =20
>  /*
>   * s390_topology is used to keep the topology information.
> @@ -468,3 +469,16 @@ void qmp_set_cpu_topology(uint16_t core,
>                           has_drawer, drawer, has_entitlement, entitlemen=
t,
>                           has_dedicated, dedicated, errp);
>  }
> +
> +CpuPolarizationInfo *qmp_query_cpu_polarization(Error **errp)
> +{
> +    CpuPolarizationInfo *info =3D g_new0(CpuPolarizationInfo, 1);
> +
> +    if (s390_topology.vertical_polarization) {
> +        info->polarization =3D S390_CPU_POLARIZATION_VERTICAL;
> +    } else {
> +        info->polarization =3D S390_CPU_POLARIZATION_HORIZONTAL;
> +    }
> +
> +    return info;
> +}

