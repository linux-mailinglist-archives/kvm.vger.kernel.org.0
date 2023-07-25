Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EBB761D8B
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbjGYPmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjGYPl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:41:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205641FFA
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:41:55 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PFcaRg001229;
        Tue, 25 Jul 2023 15:41:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=SYugxa24YS5tqnly6R8YrBLh6YTv4chjpuUIICdlNEw=;
 b=SiS1v10ILx5E9kZxUHbnUfhXLpdTT59kqbcT3lTTV1AOGI3gcuDt7d1Dk5I5iMt61hge
 OHq4xXdEp05t556LTMPh34bciBv5wYZ5G9yXNtkUFkptEiq+3EABHCtiVnd92oyNNmhT
 +nVawawnLKUFut6gYmZjLuBOcXat1lksw68bctUWMQm6FMLiGQNwVDQyEC6RFm3q2AxW
 MRI8z44Ht7eppxo9QoVbxTxmmmsJ7D3Rz+KY/dxafCfZVI28b6A/uOUm02ButjqGl7bZ
 sMqfJK05oRdl4BBVKYgqGWAaCT6ByxE5kNBH6mUcjm7XXyXJlN+WDRybxmhEgsyErBoK jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2batk4an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 15:41:47 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36PFceAp001401;
        Tue, 25 Jul 2023 15:41:46 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2batk48s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 15:41:46 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36PEmAxp014403;
        Tue, 25 Jul 2023 15:41:45 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0stxwd08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 15:41:44 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36PFfeFG23855698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 15:41:40 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1CBB20040;
        Tue, 25 Jul 2023 15:41:40 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FC722004B;
        Tue, 25 Jul 2023 15:41:40 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jul 2023 15:41:40 +0000 (GMT)
Message-ID: <667c700b3739f1dada06bcf70b91952d9dd5352b.camel@linux.ibm.com>
Subject: Re: [PATCH v21 03/20] target/s390x/cpu topology: handle STSI(15)
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
Date:   Tue, 25 Jul 2023 17:41:40 +0200
In-Reply-To: <20230630091752.67190-4-pmorel@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
         <20230630091752.67190-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QQoGxnNC6aZuwdhBJ18nskTfbyps5L0p
X-Proofpoint-GUID: _nK0M2r7qv_V7a3gim-lcRoa7RJPQKdL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_08,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307250137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-06-30 at 11:17 +0200, Pierre Morel wrote:
> On interception of STSI(15.1.x) the System Information Block
> (SYSIB) is built from the list of pre-ordered topology entries.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  MAINTAINERS                      |   1 +
>  qapi/machine-target.json         |  14 ++
>  include/hw/s390x/cpu-topology.h  |  25 +++
>  include/hw/s390x/sclp.h          |   1 +
>  target/s390x/cpu.h               |  76 ++++++++
>  hw/s390x/cpu-topology.c          |   4 +-
>  target/s390x/kvm/kvm.c           |   5 +-
>  target/s390x/kvm/stsi-topology.c | 310 +++++++++++++++++++++++++++++++
>  target/s390x/kvm/meson.build     |   3 +-
>  9 files changed, 436 insertions(+), 3 deletions(-)
>  create mode 100644 target/s390x/kvm/stsi-topology.c

[...]

>  typedef struct S390Topology {
>      uint8_t *cores_per_socket;
> +    bool polarization;

You don't use this as a bool and since it's no longer called
vertical_polarization, it's not longer entirely clear what the value
means so I think this should be a CpuS390Polarization.
That also makes the assignment in patch 12 clearer since it assigns the
same type.

[...]

>  S390Topology s390_topology =3D {
>      /* will be initialized after the cpu model is realized */
>      .cores_per_socket =3D NULL,
> +    .polarization =3D S390_CPU_POLARIZATION_HORIZONTAL,
>  };

[...]

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
> +    if (s390_topology.polarization =3D=3D S390_CPU_POLARIZATION_VERTICAL=
) {
> +        topology_id.entitlement =3D cpu->env.entitlement;
> +    }
> +
> +    return topology_id;
> +}

[...]
