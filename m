Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8146D690E82
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 17:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBIQkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 11:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjBIQkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 11:40:52 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727FA663C2
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 08:40:43 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319GVfBl030180;
        Thu, 9 Feb 2023 16:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dbsEsCmzF9fS6ROFbhEfgY/NWOMxGQVEOSsTBmsFrnY=;
 b=hBBSgrBAdga87uuKdI5qfuRPRIcRubLNgnGqCrCBr9DjtfNE+LBHWl1HMM+bOlK1bLUW
 ArIfcGp5NfjGAoDcQpKQIE/b6qTxI1syOuDLHu2YWgHcEeuKjJGr1wvsrbKsfPReTcPZ
 +wk/9AucYZmFdw8HL5iEBM7P0RDemma0f50WreaFcllOyihoqOHzg7EP6L2aeV/BypsX
 VtZuzniVIM/PmkJBy+Vap6aVeEh6dWTKow25iWLjd+5c25+3rgN5L0Y+5mJL0Vucu2qO
 x1OFlqNXs96LNM7bQBXzXzUm3PqgQbx/gFWK9+AA0sAhxb+bssB0zc8LjtY0HPzZK8Qt OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn4e2897r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 16:39:24 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319GWl2S000541;
        Thu, 9 Feb 2023 16:39:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn4e2896f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 16:39:24 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 319CKrOo020939;
        Thu, 9 Feb 2023 16:39:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfpfmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 16:39:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319GdII233948108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 16:39:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AED62004B;
        Thu,  9 Feb 2023 16:39:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E2AB20043;
        Thu,  9 Feb 2023 16:39:18 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.156.204])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 16:39:17 +0000 (GMT)
Message-ID: <224677259469c69c61e120a24b7fd0754fd52956.camel@linux.ibm.com>
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
Date:   Thu, 09 Feb 2023 17:39:17 +0100
In-Reply-To: <20230201132051.126868-4-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iO60dT4BFXYxll-OMTI1Bo3C8VGapX5S
X-Proofpoint-ORIG-GUID: DWeoHxMrdO3uJ8VEOkETEvXP-XOVtlFH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-09_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302090157
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> On interception of STSI(15.1.x) the System Information Block
> (SYSIB) is built from the list of pre-ordered topology entries.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  include/hw/s390x/cpu-topology.h |  22 +++
>  include/hw/s390x/sclp.h         |   1 +
>  target/s390x/cpu.h              |  72 +++++++
>  hw/s390x/cpu-topology.c         |  10 +
>  target/s390x/kvm/cpu_topology.c | 335 ++++++++++++++++++++++++++++++++
>  target/s390x/kvm/kvm.c          |   5 +-
>  target/s390x/kvm/meson.build    |   3 +-
>  7 files changed, 446 insertions(+), 2 deletions(-)
>  create mode 100644 target/s390x/kvm/cpu_topology.c
>=20
[...]
> +
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
> +    if (s390_topology.polarity =3D=3D POLARITY_VERTICAL) {
> +        /*
> +         * Vertical polarity with dedicated CPU implies
> +         * vertical high entitlement.
> +         */
> +        if (topology_id.dedicated) {
> +            topology_id.polarity |=3D POLARITY_VERTICAL_HIGH;
> +        } else {
> +            topology_id.polarity |=3D cpu->env.entitlement;
> +        }

Why |=3D instead of an assignment?
Anyway, I think you can get rid of this in the next version.
If you define the entitlement via qapi you can just put a little switch
here and convert it to the hardware definition of polarization.
(Or you just do +1, but I think the switch is easier to understand)

> +    }
> +
> +    return topology_id;
> +}
> +
[...]
