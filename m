Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635796883AA
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 17:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjBBQGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 11:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjBBQGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 11:06:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E0268AFC
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 08:06:08 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312EBGCU002095;
        Thu, 2 Feb 2023 16:05:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=D3FV9Y0GvJS2l6SYHPVWLLzH43WlotAtU617C7bwbMM=;
 b=DHFR7RonXLVLk1jtoZnDrxgx7GeijBGXIUZNkEuNa6/HC3CPPW0iv5tWonO1BSwdm/OB
 WOd1ZV7Q7pF0Vf2htPLHEbYaqTPXHCKsh7ZfSIcqRGaN1VwcFL39JNorkDnS7a6ooiHo
 tHbViAjbIlx7XQb/32+CE3e8rqhYM+dmaWzIvTN/BTcxgF458dSyYdBthz+ywfjJQrZj
 rHQR2Ir8V+BPbtHCrRiNIadmatZOYgJ2o6QjdGSqwH5n6B0LA7416lZ99du7wfguxKhA
 xcKXWdlIv0RCXSOc/bONNMCRQQ8qZaYRDu6sIZTXj0nKiC8wzZWRRQFvs+hbSufyx+5D ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngd74dswv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 16:05:53 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 312Et9P9025153;
        Thu, 2 Feb 2023 16:05:53 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngd74dsvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 16:05:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 312CugD2014744;
        Thu, 2 Feb 2023 16:05:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ncvttxcnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 16:05:50 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 312G5lAE37552520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Feb 2023 16:05:47 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0645720063;
        Thu,  2 Feb 2023 16:05:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 917AA2004F;
        Thu,  2 Feb 2023 16:05:46 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.142.89])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  2 Feb 2023 16:05:46 +0000 (GMT)
Message-ID: <9fed7aba2819a6564b785e90c2284b2a83f35431.camel@linux.ibm.com>
Subject: Re: [PATCH v15 01/11] s390x/cpu topology: adding s390 specificities
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
Date:   Thu, 02 Feb 2023 17:05:46 +0100
In-Reply-To: <20230201132051.126868-2-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xENYh6gJfcYtb0ZTXamuWLH_OTgv6mG-
X-Proofpoint-GUID: R-UAo-g1wt-0rZw87a81WjT7jXvwB5Jg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_10,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1011 priorityscore=1501
 phishscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020143
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit patch title: s390x/cpu topology: add s390 specifics to CPU topology ?

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> S390 adds two new SMP levels, drawers and books to the CPU
> topology.
> The S390 CPU have specific toplogy features like dedication
                                ^o
> and polarity to give to the guest indications on the host
> vCPUs scheduling and help the guest take the best decisions
> on the scheduling of threads on the vCPUs.
>=20
> Let us provide the SMP properties with books and drawers levels
> and S390 CPU with dedication and polarity,
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine.json               | 14 ++++++++--
>  include/hw/boards.h             | 10 ++++++-
>  include/hw/s390x/cpu-topology.h | 24 +++++++++++++++++
>  target/s390x/cpu.h              |  5 ++++
>  hw/core/machine-smp.c           | 48 ++++++++++++++++++++++++++++-----
>  hw/core/machine.c               |  4 +++
>  hw/s390x/s390-virtio-ccw.c      |  2 ++
>  softmmu/vl.c                    |  6 +++++
>  target/s390x/cpu.c              |  7 +++++
>  qemu-options.hx                 |  7 +++--
>  10 files changed, 115 insertions(+), 12 deletions(-)
>  create mode 100644 include/hw/s390x/cpu-topology.h
>=20
[...]
>=20
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topol=
ogy.h
> new file mode 100644
> index 0000000000..7a84b30a21
> --- /dev/null
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -0,0 +1,24 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (a=
t
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +#ifndef HW_S390X_CPU_TOPOLOGY_H
> +#define HW_S390X_CPU_TOPOLOGY_H
> +
> +#define S390_TOPOLOGY_CPU_IFL   0x03
> +
> +enum s390_topology_polarity {
> +    POLARITY_HORIZONTAL,
> +    POLARITY_VERTICAL,
> +    POLARITY_VERTICAL_LOW =3D 1,
> +    POLARITY_VERTICAL_MEDIUM,
> +    POLARITY_VERTICAL_HIGH,
> +    POLARITY_MAX,
> +};

Probably a good idea to keep the S390 prefix.
This works, but aliasing VERTICAL and VERTICAL_LOW is not
entirely straight forward.

Why not have two enum?
enum s390_topology_polarity {
	S390_POLARITY_HORIZONTAL,
	S390_POLARITY_VERTICAL,
};

enum s390_topology_entitlement {
	S390_ENTITLEMENT_LOW =3D 1,
	S390_ENTITLEMENT_MEDIUM,
	S390_ENTITLEMENT_HIGH,
	S390_ENTITLEMENT_MAX,
};
Maybe add an ENTITLEMENT_INVALID/NONE, if you need that, as first value.

> +#endif
>=20
[...]

