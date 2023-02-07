Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0255568D569
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 12:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjBGL2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 06:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjBGL2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 06:28:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89899196A9
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 03:28:17 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3179itfC007494;
        Tue, 7 Feb 2023 11:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=C+NTGBOON520x55mRkXDqiScYQ49mrLWZBpUOX295Fc=;
 b=AvCM2LMO7rbaV1GTfPmh0Rjq2gAwmqrkk5h1KrAi/srJJVI7F2xjMr+ASk9e9gok3UUn
 D2h0m+Fyi0znXFI5PI5lkjWbEblvX2S/mHZ9LLiYm/K3W4h4OgZc2ozW+unALRsPWaCu
 GmxKa0dZ64cByJx+/p7WAcuwOF4vR4qHIbD0d13IupwcTBPQTdlmaMa3BvDV8nqXUhIe
 EQQYnhcQUzS0VI6F4WirL5VNV8XUI9Vf3Qwk1gcuYoRJOhRX7ljJ2Z/Z1YO34kI9myOi
 RMpmyXKHObAjP/7HyOYX8Wlo0eUdPu+tTRP9TB71P7suRB4SHZUdqrhHG3XQYgvS3efB AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkm9n2jkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 11:28:04 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3179lelU019288;
        Tue, 7 Feb 2023 11:28:04 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkm9n2jjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 11:28:04 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316HZFjd004215;
        Tue, 7 Feb 2023 11:28:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3nhf06jgh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 11:28:01 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 317BRuie52756958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Feb 2023 11:27:56 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAB312004F;
        Tue,  7 Feb 2023 11:27:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CC192004B;
        Tue,  7 Feb 2023 11:27:56 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.169.160])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Feb 2023 11:27:56 +0000 (GMT)
Message-ID: <b3c206df9dc08c094c0c717b0cb6457d29ed9925.camel@linux.ibm.com>
Subject: Re: [PATCH v15 06/11] s390x/cpu topology: interception of PTF
 instruction
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Tue, 07 Feb 2023 12:27:56 +0100
In-Reply-To: <f5c6b04a-0faa-ba36-9019-468662b9fbb2@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-7-pmorel@linux.ibm.com>
         <5c15ccde659a9849ab3529e08f5e1278508406c8.camel@linux.ibm.com>
         <f5c6b04a-0faa-ba36-9019-468662b9fbb2@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iU7AHCYSsynreF4yv_H_-GHgKQLFEMe6
X-Proofpoint-GUID: _x5NPmbcBr0-gUD28iQoV1Z73--1LLiM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_03,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-02-07 at 10:59 +0100, Pierre Morel wrote:
>=20
> On 2/6/23 19:34, Nina Schoetterl-Glausch wrote:
> > On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> > > When the host supports the CPU topology facility, the PTF
> > > instruction with function code 2 is interpreted by the SIE,
> > > provided that the userland hypervizor activates the interpretation
> > > by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
> > >=20
> > > The PTF instructions with function code 0 and 1 are intercepted
> > > and must be emulated by the userland hypervizor.
> > >=20
> > > During RESET all CPU of the configuration are placed in
> > > horizontal polarity.
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   include/hw/s390x/s390-virtio-ccw.h |   6 ++
> > >   target/s390x/cpu.h                 |   1 +
> > >   hw/s390x/cpu-topology.c            | 103 ++++++++++++++++++++++++++=
+++
> > >   target/s390x/cpu-sysemu.c          |  14 ++++
> > >   target/s390x/kvm/kvm.c             |  11 +++
> > >   5 files changed, 135 insertions(+)
> > >=20
> > [...]
> >=20
> > > diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> > > index cf63f3dd01..1028bf4476 100644
> > > --- a/hw/s390x/cpu-topology.c
> > > +++ b/hw/s390x/cpu-topology.c
> > > @@ -85,16 +85,104 @@ static void s390_topology_init(MachineState *ms)
> > >       QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
> > >   }
> > >  =20
> > > +/**
> > > + * s390_topology_set_cpus_polarity:
> > > + * @polarity: polarity requested by the caller
> > > + *
> > > + * Set all CPU entitlement according to polarity and
> > > + * dedication.
> > > + * Default vertical entitlement is POLARITY_VERTICAL_MEDIUM as
> > > + * it does not require host modification of the CPU provisioning
> > > + * until the host decide to modify individual CPU provisioning
> > > + * using QAPI interface.
> > > + * However a dedicated vCPU will have a POLARITY_VERTICAL_HIGH
> > > + * entitlement.
> > > + */
> > > +static void s390_topology_set_cpus_polarity(int polarity)
> >=20
> > Since you set the entitlement field I'd prefer _set_cpus_entitlement or=
 similar.
>=20
> OK if you prefer.
>=20
> >=20
> > > +{
> > > +    CPUState *cs;
> > > +
> > > +    CPU_FOREACH(cs) {
> > > +        if (polarity =3D=3D POLARITY_HORIZONTAL) {
> > > +            S390_CPU(cs)->env.entitlement =3D 0;
> > > +        } else if (S390_CPU(cs)->env.dedicated) {
> > > +            S390_CPU(cs)->env.entitlement =3D POLARITY_VERTICAL_HIGH=
;
> > > +        } else {
> > > +            S390_CPU(cs)->env.entitlement =3D POLARITY_VERTICAL_MEDI=
UM;
> > > +        }
> > > +    }
> > > +}
> > > +
> > [...]
> > >  =20
> > >   /**
> > > @@ -137,6 +225,21 @@ static void s390_topology_cpu_default(S390CPU *c=
pu, Error **errp)
> > >                             (smp->books * smp->sockets * smp->cores))=
 %
> > >                            smp->drawers;
> > >       }
> >=20
> > Why are the changes below in this patch?
>=20
> Because before thos patch we have only horizontal polarization.

Not really since you only enable topology in the next patch.
>=20
> >=20
> > > +
> > > +    /*
> > > +     * Machine polarity is set inside the global s390_topology struc=
ture.
> > > +     * In the case the polarity is set as horizontal set the entitle=
ment
>=20
> Sorry here an error in the comment should be :
> "In the case the polarity is NOT set as horizontal..."
>=20
> > > +     * to POLARITY_VERTICAL_MEDIUM which is the better equivalent wh=
en
> > > +     * machine polarity is set to vertical or POLARITY_VERTICAL_HIGH=
 if
> > > +     * the vCPU is dedicated.
> > > +     */
> > > +    if (s390_topology.polarity && !env->entitlement) {
> >=20
> > It'd be more readable if you compared against enum values by name.
>=20
> Right, I will change this to
>=20
>      if (s390_topology.polarity !=3D S390_POLARITY_HORIZONTAL &&
>          env->entitlement =3D=3D S390_ENTITLEMENT_UNSET) {
>=20
> >=20
> > I don't see why you check s390_topology.polarity. If it is horizontal
> > then the value of the entitlement doesn't matter at all, so you can set=
 it
> > to whatever.
>=20
> Right, that is why it is done only for vertical polarization (sorry for=
=20
> the wrong comment)

I'm saying you don't need to check it at all. You adjust the values for
vertical polarization, but you could just always do that since the values
don't matter at all if the polarization is horizontal.
>=20
> > All you want to do is enforce dedicated -> VERTICAL_HIGH, right?
> > So why don't you just add
> >=20
> > +    if (cpu->env.dedicated && cpu->env.entitlement !=3D POLARITY_VERTI=
CAL_HIGH) {
> > +        error_setg(errp, "A dedicated cpu implies high entitlement");
> > +        return;
> > +    } >
> > to s390_topology_check?
>=20
> Here it is to set the default in the case the values are not provided.

If no values are provided, they default to dedication=3Dfalse and entitleme=
nt=3Dmedium,
as defined by patch 1, which are fine and don't need to be adjusted.

>=20
> But where you are right is that I should add a verification to the check=
=20
> function.
>=20
> >=20
> > > +        if (env->dedicated) {
> > > +            env->entitlement =3D POLARITY_VERTICAL_HIGH;
> > > +        } else {
> > > +            env->entitlement =3D POLARITY_VERTICAL_MEDIUM;
> > > +        }
> >=20
> > If it is horizontal, then setting the entitlement is pointless as it wi=
ll be
> > reset to medium on PTF.
>=20
> That is why the polarity is tested (sorry for the bad comment)

I said this because I'm fine with setting it pointlessly.

> > So the current polarization is vertical and a cpu is being hotplugged,
> > but setting the entitlement of the cpu being added is also pointless, b=
ecause
> > it's determined by the dedication. That seems weird.
>=20
> No it is not determined by the dedication, if there is no dedication the=
=20
> 3 vertical values are possible.

You set it to either high or medium based on the dedication. And for horizo=
ntal
polarization it obviously doesn't matter.

As far as I understand you don't need this because the default values are f=
ine.
You should add the check that if a dedicated cpu is hotplugged, then the en=
titlement
must be high, to patch 2 and that's it, no additional changes necessary.
>=20
>=20
> Regards,
> Pierre
>=20
> >=20
> > > +    }
> > >   }
> > >  =20
> >=20
> > [...]
>=20

