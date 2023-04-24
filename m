Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66076ED18C
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 17:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjDXPj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 11:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjDXPjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 11:39:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8004BE5E
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 08:39:52 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33OFaQ0Z016420;
        Mon, 24 Apr 2023 15:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=O9I8meqS0Mp5j6JBt9Zvp6jBV9kGXfRjvICObIjnb7o=;
 b=Vk2MOei3KLorHGASQcG/JbJgZ21MzmM2mIY65ra8SHYn+XsWh33DeNsqvhzI3ftetJgP
 qom11+x+J1aDknS/q6hF5layfxX4IHWiVaohLxb29HRIXDrusnGNc3Nzn9S1t1kCXTZJ
 2OpEBKUSv+u3ACVADWg4p4ckBbK7lkwXiXr/3i1+XY/BMP7VFWhPBbsdZndcOu3lLocS
 P/8jfbV7/6kXsiNe01/nBBcmQt5VjnUQuSlt+8vg9XNyWlry6ibhmAWr1ooyuwf+qCbL
 kpkdDyUpkeulGALRS4+nu+9TSPOfYDshzutPJs+5Tiiw/JRWUYCGwQoh6bmy7Abj7tem cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q46m65uaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 15:39:35 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33OFcNce028505;
        Mon, 24 Apr 2023 15:38:29 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q46m65nfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 15:38:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33ODwmpW006382;
        Mon, 24 Apr 2023 15:32:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q46ug170t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 15:32:07 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33OFW1U912845752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 15:32:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 553E72004F;
        Mon, 24 Apr 2023 15:32:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEB8120043;
        Mon, 24 Apr 2023 15:32:00 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.198.247])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Apr 2023 15:32:00 +0000 (GMT)
Message-ID: <60aafc95dd0293ba8d5b4dbdc59fcda5e6c64f3e.camel@linux.ibm.com>
Subject: Re: [PATCH v19 02/21] s390x/cpu topology: add topology entries on
 CPU hotplug
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 24 Apr 2023 17:32:00 +0200
In-Reply-To: <4ddd3177-58a8-c9f0-a9a8-ee71baf0511b@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
         <20230403162905.17703-3-pmorel@linux.ibm.com>
         <66d9ba0e9904f035326aca609a767976b94547cf.camel@linux.ibm.com>
         <4ddd3177-58a8-c9f0-a9a8-ee71baf0511b@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lv_5ZNENUl8VdZAh5FQzTMggLEG8vanr
X-Proofpoint-GUID: VA-HREdkGlXkW5aoFLmaLUTzlnqIIr_r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-24_09,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304240140
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-04-21 at 12:20 +0200, Pierre Morel wrote:
> > On 4/20/23 10:59, Nina Schoetterl-Glausch wrote:
> > > > On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
> > > > > > The topology information are attributes of the CPU and are
> > > > > > specified during the CPU device creation.
> > > > > >=20
> > > > > > On hot plug we:
> > > > > > - calculate the default values for the topology for drawers,
> > > > > >    books and sockets in the case they are not specified.
> > > > > > - verify the CPU attributes
> > > > > > - check that we have still room on the desired socket
> > > > > >=20
> > > > > > The possibility to insert a CPU in a mask is dependent on the
> > > > > > number of cores allowed in a socket, a book or a drawer, the
> > > > > > checking is done during the hot plug of the CPU to have an
> > > > > > immediate answer.
> > > > > >=20
> > > > > > If the complete topology is not specified, the core is added
> > > > > > in the physical topology based on its core ID and it gets
> > > > > > defaults values for the modifier attributes.
> > > > > >=20
> > > > > > This way, starting QEMU without specifying the topology can
> > > > > > still get some advantage of the CPU topology.
> > > > > >=20
> > > > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > > > ---
> > > > > >   MAINTAINERS                        |   1 +
> > > > > >   include/hw/s390x/cpu-topology.h    |  44 +++++
> > > > > >   include/hw/s390x/s390-virtio-ccw.h |   1 +
> > > > > >   hw/s390x/cpu-topology.c            | 282 ++++++++++++++++++++=
+++++++++
> > > > > >   hw/s390x/s390-virtio-ccw.c         |  22 ++-
> > > > > >   hw/s390x/meson.build               |   1 +
> > > > > >   6 files changed, 349 insertions(+), 2 deletions(-)
> > > > > >   create mode 100644 hw/s390x/cpu-topology.c
> > > > > >   };

[...]

> > > > > >   struct S390CcwMachineClass {
> > > > > > diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> > > > > > new file mode 100644
> > > > > > index 0000000000..96da67bd7e
> > > > > > --- /dev/null
> > > > > > +++ b/hw/s390x/cpu-topology.c
> > > > [...]
> > > >=20
> > > > > > +/**
> > > > > > + * s390_topology_cpu_default:
> > > > > > + * @cpu: pointer to a S390CPU
> > > > > > + * @errp: Error pointer
> > > > > > + *
> > > > > > + * Setup the default topology if no attributes are already set=
.
> > > > > > + * Passing a CPU with some, but not all, attributes set is con=
sidered
> > > > > > + * an error.
> > > > > > + *
> > > > > > + * The function calculates the (drawer_id, book_id, socket_id)
> > > > > > + * topology by filling the cores starting from the first socke=
t
> > > > > > + * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->so=
ckets).
> > > > > > + *
> > > > > > + * CPU type and dedication have defaults values set in the
> > > > > > + * s390x_cpu_properties, entitlement must be adjust depending =
on the
> > > > > > + * dedication.
> > > > > > + */
> > > > > > +static void s390_topology_cpu_default(S390CPU *cpu, Error **er=
rp)
> > > > > > +{
> > > > > > +    CpuTopology *smp =3D s390_topology.smp;
> > > > > > +    CPUS390XState *env =3D &cpu->env;
> > > > > > +
> > > > > > +    /* All geometry topology attributes must be set or all uns=
et */
> > > > > > +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer=
_id < 0) &&
> > > > > > +        (env->socket_id >=3D 0 || env->book_id >=3D 0 || env->=
drawer_id >=3D 0)) {
> > > > > > +        error_setg(errp,
> > > > > > +                   "Please define all or none of the topology =
geometry attributes");
> > > > > > +        return;
> > > > > > +    }
> > > > > > +
> > > > > > +    /* Check if one of the geometry topology is unset */
> > > > > > +    if (env->socket_id < 0) {
> > > > > > +        /* Calculate default geometry topology attributes */
> > > > > > +        env->socket_id =3D s390_std_socket(env->core_id, smp);
> > > > > > +        env->book_id =3D s390_std_book(env->core_id, smp);
> > > > > > +        env->drawer_id =3D s390_std_drawer(env->core_id, smp);
> > > > > > +    }
> > > > > > +
> > > > > > +    /*
> > > > > > +     * Even the user can specify the entitlement as horizontal=
 on the
> > > > > > +     * command line, qemu will only use env->entitlement durin=
g vertical
> > > > > > +     * polarization.
> > > > > > +     * Medium entitlement is chosen as the default entitlement=
 when the CPU
> > > > > > +     * is not dedicated.
> > > > > > +     * A dedicated CPU always receives a high entitlement.
> > > > > > +     */
> > > > > > +    if (env->entitlement >=3D S390_CPU_ENTITLEMENT__MAX ||
> > > > > > +        env->entitlement =3D=3D S390_CPU_ENTITLEMENT_HORIZONTA=
L) {
> > > > > > +        if (env->dedicated) {
> > > > > > +            env->entitlement =3D S390_CPU_ENTITLEMENT_HIGH;
> > > > > > +        } else {
> > > > > > +            env->entitlement =3D S390_CPU_ENTITLEMENT_MEDIUM;
> > > > > > +        }
> > > > > > +    }
> > > > As you know, in my opinion there should be not possibility for the =
user
> > > > to set the entitlement to horizontal and dedicated && !=3D HIGH sho=
uld be
> > > > rejected as an error.
> > > > If you do this, you can delete this.
> >=20
> > In the next version with entitlement being an enum it is right.
> >=20
> > However, deleting this means that the default value for entitlement=20
> > depends on dedication.
> >=20
> > If we have only low, medium, high and default for entitlement is medium=
.
> >=20
> > If the user specifies the dedication true without specifying entitlemen=
t=20
> > we could force entitlement to high.
> >=20
> > But we can not distinguish this from the user specifying dedication tru=
e=20
> > with a medium entitlement, which is wrong.
> >=20
> > So three solution:
> >=20
> > 1) We ignore what the user say if dedication is specified as true
> >=20
> > 2) We specify that both dedication and entitlement must be specified if=
=20
> > dedication is true
> >=20
> > 3) We set an impossible default to distinguish default from medium=20
> > entitlement
> >=20
> >=20
> > For me the solution 3 is the best one, it is more flexible for the user=
.
> >=20
> > Solution 1 is obviously bad.
> >=20
> > Solution 2 forces the user to specify entitlement high and only high if=
=20
> > it specifies dedication true.
> >=20
> > AFAIU, you prefer the solution 2, forcing user to specify both=20
> > dedication and entitlement to suppress a default value in the enum.
> > Why is it bad to have a default value in the enum that we do not use to=
=20
> > specify that the value must be calculated?

Yes, I'd prefer solution 2. I don't like adapting the internal state where =
only
the three values make sense for the user interface.
It also keeps things simple and requires less code.
I also don't think it's a bad thing for the user, as it's not a thing done =
manually often.
I'm also not a fan of a value being implicitly being changed even though it=
 doesn't look
like it from the command.

However, what I really don't like is the additional state and naming it "ho=
rizontal",
not so much the adjustment if dedication is switched to true without an ent=
itlement given.
For the monitor command there is no problem, you currently have:

+static void s390_change_topology(uint16_t core_id,
+ bool has_socket_id, uint16_t socket_id,
+ bool has_book_id, uint16_t book_id,
+ bool has_drawer_id, uint16_t drawer_id,
+ bool has_entitlement, uint16_t entitlement,
+ bool has_dedicated, bool dedicated,
+ Error **errp)
+{

[...]

+ /*
+ * Even user can specify the entitlement as horizontal on the command line=
,
+ * qemu will only use entitlement during vertical polarization.
+ * Medium entitlement is chosen as the default entitlement when the CPU
+ * is not dedicated.
+ * A dedicated CPU always receives a high entitlement.
+ */
+ if (!has_entitlement || (entitlement =3D=3D S390_CPU_ENTITLEMENT_HORIZONT=
AL)) {
+ if (dedicated) {
+ entitlement =3D S390_CPU_ENTITLEMENT_HIGH;
+ } else {
+ entitlement =3D S390_CPU_ENTITLEMENT_MEDIUM;
+ }
+ }

So you can just set it if (!has_entitlement).
There is also ways to set the value for cpus defined on the command line, e=
.g.:

diff --git a/include/hw/qdev-properties-system.h b/include/hw/qdev-properti=
es-system.h
index 0ac327ae60..41a605c5a7 100644
--- a/include/hw/qdev-properties-system.h
+++ b/include/hw/qdev-properties-system.h
@@ -22,6 +22,7 @@ extern const PropertyInfo qdev_prop_audiodev;
 extern const PropertyInfo qdev_prop_off_auto_pcibar;
 extern const PropertyInfo qdev_prop_pcie_link_speed;
 extern const PropertyInfo qdev_prop_pcie_link_width;
+extern const PropertyInfo qdev_prop_cpus390entitlement;
=20
 #define DEFINE_PROP_PCI_DEVFN(_n, _s, _f, _d)                   \
     DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_pci_devfn, int32_t)
@@ -73,5 +74,8 @@ extern const PropertyInfo qdev_prop_pcie_link_width;
 #define DEFINE_PROP_UUID_NODEFAULT(_name, _state, _field) \
     DEFINE_PROP(_name, _state, _field, qdev_prop_uuid, QemuUUID)
=20
+#define DEFINE_PROP_CPUS390ENTITLEMENT(_n, _s, _f) \
+    DEFINE_PROP(_n, _s, _f, qdev_prop_cpus390entitlement, int)
+
=20
 #endif
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 54541d2230..01308e0b94 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -135,7 +135,7 @@ struct CPUArchState {
     int32_t book_id;
     int32_t drawer_id;
     bool dedicated;
-    uint8_t entitlement;        /* Used only for vertical polarization */
+    int entitlement;        /* Used only for vertical polarization */
     uint64_t cpuid;
 #endif
=20
diff --git a/hw/core/qdev-properties-system.c b/hw/core/qdev-properties-sys=
tem.c
index d42493f630..db5c3d4fe6 100644
--- a/hw/core/qdev-properties-system.c
+++ b/hw/core/qdev-properties-system.c
@@ -1143,3 +1143,14 @@ const PropertyInfo qdev_prop_uuid =3D {
     .set   =3D set_uuid,
     .set_default_value =3D set_default_uuid_auto,
 };
+
+/* --- s390x cpu topology entitlement --- */
+
+QEMU_BUILD_BUG_ON(sizeof(CpuS390Entitlement) !=3D sizeof(int));
+
+const PropertyInfo qdev_prop_cpus390entitlement =3D {
+    .name =3D "CpuS390Entitlement",
+    .enum_table =3D &CpuS390Entitlement_lookup,
+    .get   =3D qdev_propinfo_get_enum,
+    .set   =3D qdev_propinfo_set_enum,
+};
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index b8a292340c..1b3f5c61ae 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -199,8 +199,7 @@ static void s390_topology_cpu_default(S390CPU *cpu, Err=
or **errp)
      * is not dedicated.
      * A dedicated CPU always receives a high entitlement.
      */
-    if (env->entitlement >=3D S390_CPU_ENTITLEMENT__MAX ||
-        env->entitlement =3D=3D S390_CPU_ENTITLEMENT_HORIZONTAL) {
+    if (env->entitlement < 0) {
         if (env->dedicated) {
             env->entitlement =3D S390_CPU_ENTITLEMENT_HIGH;
         } else {
diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
index 57165fa3a0..dea50a3e06 100644
--- a/target/s390x/cpu.c
+++ b/target/s390x/cpu.c
@@ -31,6 +31,7 @@
 #include "qapi/qapi-types-machine.h"
 #include "sysemu/hw_accel.h"
 #include "hw/qdev-properties.h"
+#include "hw/qdev-properties-system.h"
 #include "fpu/softfloat-helpers.h"
 #include "disas/capstone.h"
 #include "sysemu/tcg.h"
@@ -248,6 +249,7 @@ static void s390_cpu_initfn(Object *obj)
     cs->exception_index =3D EXCP_HLT;
=20
 #if !defined(CONFIG_USER_ONLY)
+    cpu->env.entitlement =3D -1;
     s390_cpu_init_sysemu(obj);
 #endif
 }
@@ -264,8 +266,7 @@ static Property s390x_cpu_properties[] =3D {
     DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
     DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
     DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false),
-    DEFINE_PROP_UINT8("entitlement", S390CPU, env.entitlement,
-                      S390_CPU_ENTITLEMENT__MAX),
+    DEFINE_PROP_CPUS390ENTITLEMENT("entitlement", S390CPU, env.entitlement=
),
 #endif
     DEFINE_PROP_END_OF_LIST()
 };

There are other ways to achieve the same, you could also=20
implement get, set and set_default_value so that there is an additional
"auto"/"uninitialized" value that is not in the enum.
If you insist on having an additional state in the enum, name it "auto".



