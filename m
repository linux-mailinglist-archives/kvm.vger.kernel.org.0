Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12EA68C52D
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 18:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjBFRxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 12:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBFRxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 12:53:09 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE0E125AC
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 09:53:07 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316HkTAd027959;
        Mon, 6 Feb 2023 17:52:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=I+pJ4WkLtO5FQW8kg6WQZcvUQQJie3J+oP4QT2XKuw0=;
 b=VgLCbUccsGKcz23t+fxIRr7FsO9/ok1dH2kkpbSH+6ZAbcRUY9OFHYe78OwDkgGnxOHy
 +kQOAf6/x0rFnlNEFknUhCcJO+QDyubnbWKfVwT3y/B8Q5CYY2S6o8AMl20JEUrXabwV
 saLZUr+1v1ib2qeOBZz/tgmNZZRP0OdxltAx6gCbwcEUThPE6+8F+oRrEWoxAT1Bbhk3
 lIQA7Uss2ZB0YjCHjGvjzmRXvYh8Y5SKsOq2OEWtR3IT/RZODKeSXKk4Rcr9Qf9RlG+Q
 D5CSomNXlHZ1ow9XIuMOVhs1sJT9bkSiSETbIOhGaXIgWoQh4GvqSSHfRVrrbUUjZ/1P 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk66387dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 17:52:52 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316HltBA003696;
        Mon, 6 Feb 2023 17:52:51 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk66387cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 17:52:51 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316GdVqc022560;
        Mon, 6 Feb 2023 17:52:48 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfjpcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 17:52:48 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316Hqjem38273530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 17:52:45 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07FB520043;
        Mon,  6 Feb 2023 17:52:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 946EF20040;
        Mon,  6 Feb 2023 17:52:44 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.200.84])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 17:52:44 +0000 (GMT)
Message-ID: <3215597a6916932c26fdbe1dd8daf2fc0c1c1ab5.camel@linux.ibm.com>
Subject: Re: [PATCH v15 05/11] s390x/cpu topology: resetting the
 Topology-Change-Report
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 06 Feb 2023 18:52:44 +0100
In-Reply-To: <20230201132051.126868-6-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-6-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3q0ivc2ankn86auKXwKpiw6plqxx09yG
X-Proofpoint-ORIG-GUID: E9A7GTLtY6iGdjcGRAxlSm8Af7Fyfc3-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060152
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> During a subsystem reset the Topology-Change-Report is cleared
> by the machine.
> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
> bit of the SCA in the case of a subsystem reset.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  include/hw/s390x/cpu-topology.h |  1 +
>  target/s390x/cpu.h              |  1 +
>  target/s390x/kvm/kvm_s390x.h    |  1 +
>  hw/s390x/cpu-topology.c         | 12 ++++++++++++
>  hw/s390x/s390-virtio-ccw.c      |  3 +++
>  target/s390x/cpu-sysemu.c       | 13 +++++++++++++
>  target/s390x/kvm/kvm.c          | 17 +++++++++++++++++
>  7 files changed, 48 insertions(+)
>=20
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topol=
ogy.h
> index 1ae7e7c5e3..60e0b9fbfa 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -66,5 +66,6 @@ static inline void s390_topology_set_cpu(MachineState *=
ms,
> =20
>  extern S390Topology s390_topology;
>  int s390_socket_nb(S390CPU *cpu);
> +void s390_topology_reset(void);
> =20
>  #endif
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index e1f6925856..848314d2a9 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -641,6 +641,7 @@ typedef struct SysIBTl_cpu {
>  QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) !=3D 16);
> =20
>  void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
> +void s390_cpu_topology_reset(void);

How about you call this s390_cpu_topology_reset_modified, so it's symmetric
with the function you define in the next patch. You could also drop the "cp=
u"
from the name.

Or maybe even better, you only define a function for setting the modified s=
tate,
but make it take a bool argument. This way you also get rid of some code du=
plication
and it wouldn't harm readability IMO.

> =20
>  /* MMU defines */
>  #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin       =
      */
> diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
> index f9785564d0..649dae5948 100644
> --- a/target/s390x/kvm/kvm_s390x.h
> +++ b/target/s390x/kvm/kvm_s390x.h
> @@ -47,5 +47,6 @@ void kvm_s390_crypto_reset(void);
>  void kvm_s390_restart_interrupt(S390CPU *cpu);
>  void kvm_s390_stop_interrupt(S390CPU *cpu);
>  void kvm_s390_set_diag318(CPUState *cs, uint64_t diag318_info);
> +int kvm_s390_topology_set_mtcr(uint64_t attr);
> =20
>  #endif /* KVM_S390X_H */
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index a80a1ebf22..cf63f3dd01 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -85,6 +85,18 @@ static void s390_topology_init(MachineState *ms)
>      QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>  }
> =20
> +/**
> + * s390_topology_reset:
> + *
> + * Generic reset for CPU topology, calls s390_topology_reset()
> + * s390_topology_reset() to reset the kernel Modified Topology
> + * change record.
> + */
> +void s390_topology_reset(void)
> +{

I'm wondering if you shouldn't move the reset changes you do in the next pa=
tch
into this one. I don't see what they have to do with PTF emulation.

> +    s390_cpu_topology_reset();
> +}
> +
>  /**
>   * s390_topology_cpu_default:
>   * @cpu: pointer to a S390CPU
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 9bc51a83f4..30fdfe41fa 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -122,6 +122,9 @@ static void subsystem_reset(void)
>              device_cold_reset(dev);
>          }
>      }
> +    if (s390_has_topology()) {
> +        s390_topology_reset();
> +    }
>  }
> =20
>  static int virtio_ccw_hcall_notify(const uint64_t *args)
> diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
> index 948e4bd3e0..e27864c5f5 100644
> --- a/target/s390x/cpu-sysemu.c
> +++ b/target/s390x/cpu-sysemu.c
> @@ -306,3 +306,16 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cp=
u_data arg)
>          kvm_s390_set_diag318(cs, arg.host_ulong);
>      }
>  }
> +
> +void s390_cpu_topology_reset(void)
> +{
> +    int ret;
> +
> +    if (kvm_enabled()) {
> +        ret =3D kvm_s390_topology_set_mtcr(0);
> +        if (ret) {
> +            error_report("Failed to set Modified Topology Change Report:=
 %s",
> +                         strerror(-ret));
> +        }
> +    }
> +}
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index 5ea358cbb0..bc953151ce 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -2592,6 +2592,23 @@ int kvm_s390_get_zpci_op(void)
>      return cap_zpci_op;
>  }
> =20
> +int kvm_s390_topology_set_mtcr(uint64_t attr)
> +{
> +    struct kvm_device_attr attribute =3D {
> +        .group =3D KVM_S390_VM_CPU_TOPOLOGY,
> +        .attr  =3D attr,
> +    };
> +
> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
> +        return 0;
> +    }
> +    if (!kvm_vm_check_attr(kvm_state, KVM_S390_VM_CPU_TOPOLOGY, attr)) {
> +        return -ENOTSUP;
> +    }
> +
> +    return kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);
> +}
> +
>  void kvm_arch_accel_class_init(ObjectClass *oc)
>  {
>  }

