Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E072F68F687
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 19:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjBHSEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 13:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjBHSEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 13:04:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D16116336
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 10:04:02 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318HHkBr007085;
        Wed, 8 Feb 2023 17:35:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3e+TvheiF+fdtK1QK2+Uo224EadXn+FIV8P/yMJYbVw=;
 b=ZZGDs9ZS0T+UK/dETyVwYHtmyj62pRFmRU7iBV/A2M2fGusrXkdL23yrtnhP/pTD3IEi
 pvemlsVeA/uMCdbUCFmGNS4dqMMOnu1+pbncDcU+L9ID5bT9Xh4A+RlHproyojHGemMI
 454KJWdJx7UNvn0TGJ7Wi0rKoUR+QjQ3mTxYlJ5PG+kShpXLHPuQgA9MHd6Ve7Df/fxp
 vYjh9yEvCZagnwlDZIQpZx/ZGn8evMXuPlgahcEAvz3FvaxbBKaH85V6ugfOCyAQDWdA
 jKB2VMyIX1eppVjQ/ADKL+tA0XwTewTrggy5xd2kGFDoVOJaBh4DFGUax0V+pkw6f9j4 TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmfx08vxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 17:35:47 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 318HIUg1009785;
        Wed, 8 Feb 2023 17:35:47 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmfx08vvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 17:35:47 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318ET4ZI005567;
        Wed, 8 Feb 2023 17:35:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3nhf06kpeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 17:35:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 318HZe2B26149376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Feb 2023 17:35:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 507682004D;
        Wed,  8 Feb 2023 17:35:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA55820040;
        Wed,  8 Feb 2023 17:35:39 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.183.35])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Feb 2023 17:35:39 +0000 (GMT)
Message-ID: <5b26ee514ccbbfaf5670cbf0cb006d8e706fe5ae.camel@linux.ibm.com>
Subject: Re: [PATCH v15 10/11] qapi/s390x/cpu topology: CPU_POLARITY_CHANGE
 qapi event
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Wed, 08 Feb 2023 18:35:39 +0100
In-Reply-To: <20230201132051.126868-11-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-11-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8x_Ui5fLsP_nVMUSEeIrgX6LwcJ66i7d
X-Proofpoint-GUID: mlGdi0OwGWc_PMjcBfskW7CmJF8Vumd5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080153
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> When the guest asks to change the polarity this change
> is forwarded to the admin using QAPI.
> The admin is supposed to take according decisions concerning
> CPU provisioning.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine-target.json | 30 ++++++++++++++++++++++++++++++
>  hw/s390x/cpu-topology.c  |  2 ++
>  2 files changed, 32 insertions(+)
>=20
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 58df0f5061..5883c3b020 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -371,3 +371,33 @@
>    },
>    'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>  }
> +
> +##
> +# @CPU_POLARITY_CHANGE:
> +#
> +# Emitted when the guest asks to change the polarity.
> +#
> +# @polarity: polarity specified by the guest
> +#
> +# The guest can tell the host (via the PTF instruction) whether the
> +# CPUs should be provisioned using horizontal or vertical polarity.
> +#
> +# On horizontal polarity the host is expected to provision all vCPUs
> +# equally.
> +# On vertical polarity the host can provision each vCPU differently.
> +# The guest will get information on the details of the provisioning
> +# the next time it uses the STSI(15) instruction.
> +#
> +# Since: 8.0
> +#
> +# Example:
> +#
> +# <- { "event": "CPU_POLARITY_CHANGE",
> +#      "data": { "polarity": 0 },
> +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
> +#
> +##
> +{ 'event': 'CPU_POLARITY_CHANGE',
> +  'data': { 'polarity': 'int' },
> +   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM'] }

I wonder if you should depend on CONFIG_KVM or not. If tcg gets topology
support it will use the same event and right now it would just never be emi=
tted.
On the other hand it's more conservative this way.

I also wonder if you should add 'feature' : [ 'unstable' ].
On the upside, it would mark the event as unstable, but I don't know what t=
he
consequences are exactly.
Also I guess one can remove qemu events without breaking backwards compatib=
ility,
since they just won't be emitted? Unless I guess you specify that a event m=
ust
occur under certain situations and the client waits on it?

Patch looks good.

> +}
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index 6c50050991..2f8e1b60cf 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -19,6 +19,7 @@
>  #include "hw/s390x/s390-virtio-ccw.h"
>  #include "hw/s390x/cpu-topology.h"
>  #include "qapi/qapi-commands-machine-target.h"
> +#include "qapi/qapi-events-machine-target.h"
>  #include "qapi/qmp/qdict.h"
>  #include "monitor/hmp.h"
>  #include "monitor/monitor.h"
> @@ -163,6 +164,7 @@ void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintpt=
r_t ra)
>              s390_topology.polarity =3D fc;
>              s390_cpu_topology_set_modified();
>              s390_topology_set_cpus_polarity(fc);
> +            qapi_event_send_cpu_polarity_change(fc);
>              setcc(cpu, 0);
>          }
>          break;

