Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1DA643FEB
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 10:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiLFJds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 04:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiLFJdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 04:33:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12876DF5F
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 01:33:45 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B68k5nf006900;
        Tue, 6 Dec 2022 09:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=jqasbCqysTgmE/qqzibdIl/14lHqQXJU3v8JrNere2k=;
 b=kZdB/AGAaXmtzPcbELAKVpVVlWLnIINV+KiSX5H1FGUQMde1PvRAz06JNOg3VVyd2UB8
 K4gIIltStqoNhTnepPhNCSXzSAae3TS6Q8TBE9K2FUh/p+/PXJUDX2ld4h6k2Ar0rZNk
 DTOl2ZMQAUkj4fGOoGmONuwwhUQ1B5uqu3Y2jIG+KXZj9VQiGkk4g6xQyXkgO7pwrXP0
 kG1CL9XAjEXEzD/ExAUSjaE1hqDajaCsurYL1G7zVobjBPAwRmrKsuqWrMyBr8vJ6ubr
 ORxrfTFkBRfrHrxKaobNHF5y1s9qu29DqdlfIY7tbd/RgHugg/cFXU10VaimzZangqoH JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma2h1s3jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 09:33:30 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B68k4ub006869;
        Tue, 6 Dec 2022 09:33:30 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma2h1s3cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 09:33:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5K5AqV011955;
        Tue, 6 Dec 2022 09:32:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3m9mb20uyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 09:32:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com ([9.149.105.59])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B69VvAn24379754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 09:31:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BAEAA404D;
        Tue,  6 Dec 2022 09:31:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82AE7A4040;
        Tue,  6 Dec 2022 09:31:56 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.52.73])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 09:31:56 +0000 (GMT)
Message-ID: <92e30cf1f091329b2076195e9c159be16c13f7f9.camel@linux.ibm.com>
Subject: Re: [PATCH v12 1/7] s390x/cpu topology: Creating CPU topology device
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Tue, 06 Dec 2022 10:31:56 +0100
In-Reply-To: <20221129174206.84882-2-pmorel@linux.ibm.com>
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
         <20221129174206.84882-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X2CA-Xk3U3woDtaKxD4AOeq_Peek9Pol
X-Proofpoint-ORIG-GUID: 5n3AOFkQUVslJ7hz9WpMi5Vd_umUTAeO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_05,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212060078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
> We will need a Topology device to transfer the topology
> during migration and to implement machine reset.
>=20
> The device creation is fenced by s390_has_topology().
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  include/hw/s390x/cpu-topology.h    | 44 +++++++++++++++
>  include/hw/s390x/s390-virtio-ccw.h |  1 +
>  hw/s390x/cpu-topology.c            | 87 ++++++++++++++++++++++++++++++
>  hw/s390x/s390-virtio-ccw.c         | 25 +++++++++
>  hw/s390x/meson.build               |  1 +
>  5 files changed, 158 insertions(+)
>  create mode 100644 include/hw/s390x/cpu-topology.h
>  create mode 100644 hw/s390x/cpu-topology.c
>=20
[...]

> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-v=
irtio-ccw.h
> index 9bba21a916..47ce0aa6fa 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>      bool dea_key_wrap;
>      bool pv;
>      uint8_t loadparm[8];
> +    DeviceState *topology;

Why is this a DeviceState, not S390Topology?
It *has* to be a S390Topology, right? Since you cast it to one in patch 2.

>  };
> =20
>  struct S390CcwMachineClass {
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..bbf97cd66a
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
>=20
[...]
> =20
> +static DeviceState *s390_init_topology(MachineState *machine, Error **er=
rp)
> +{
> +    DeviceState *dev;
> +
> +    dev =3D qdev_new(TYPE_S390_CPU_TOPOLOGY);
> +
> +    object_property_add_child(&machine->parent_obj,
> +                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));

Why set this property, and why on the machine parent?

> +    object_property_set_int(OBJECT(dev), "num-cores",
> +                            machine->smp.cores * machine->smp.threads, e=
rrp);
> +    object_property_set_int(OBJECT(dev), "num-sockets",
> +                            machine->smp.sockets, errp);
> +
> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);

I must admit that I haven't fully grokked qemu's memory management yet.
Is the topology devices now owned by the sysbus?
If so, is it fine to have a pointer to it S390CcwMachineState?
> +
> +    return dev;
> +}
> +
[...]
