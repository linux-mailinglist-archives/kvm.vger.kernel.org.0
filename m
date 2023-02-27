Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9166A4184
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 13:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjB0MPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 07:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0MPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 07:15:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF2926AB
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 04:15:36 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RBAolY027951;
        Mon, 27 Feb 2023 12:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8rx1H5NN6pXX7lVygfwwKIDpROCOUKo5yBse1wiRk9w=;
 b=f3qwFN0mIIlk/pqM4IruaIOMnNV1G0Y5siLqwQ972MzET3wJZHqcF9BkS5cYqHhpH4Q2
 A1NjL4lSnnQnqeSCMIAvwl68CRDcRCYUShnzBzJSbc1+sKWS5UzXQUHZ6yMGkqxiomEq
 NpYxX2hW+vrhpMPQAHu+Jo3BQvVJDVzGKHWFiv/3AJ9OJXJZ+UX1b4XWVGNSsinnyXxT
 7G2JmZc6g9bxHz0+oe6NP7+YTYQfBom5xLbzpplC57xj6z+AQ4xndIZmQ9zMPnNpZ+yR
 oCeIrQFS1emxAoP0PAmEF5RZYyKxStcLBnJ2h5Vp8wcF7YQYkHOwr14253v99xaLKD3+ vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0sg44uwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 12:15:18 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31RBxs3Z030797;
        Mon, 27 Feb 2023 12:15:17 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0sg44uvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 12:15:17 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31R8AM8s013030;
        Mon, 27 Feb 2023 12:15:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nybcq1y5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 12:15:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31RCFBxN63242670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 12:15:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D260E20043;
        Mon, 27 Feb 2023 12:15:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6667720040;
        Mon, 27 Feb 2023 12:15:11 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.148.35])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Feb 2023 12:15:11 +0000 (GMT)
Message-ID: <7504a2a236c314bcb5a2030c65b95b32d8b896bf.camel@linux.ibm.com>
Subject: Re: [PATCH v16 08/11] qapi/s390x/cpu topology: set-cpu-topology
 monitor command
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 27 Feb 2023 13:15:11 +0100
In-Reply-To: <4335eac8-ba5d-5b6c-b19f-4b10a793ba0c@linux.ibm.com>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
         <20230222142105.84700-9-pmorel@linux.ibm.com>
         <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
         <4335eac8-ba5d-5b6c-b19f-4b10a793ba0c@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Y16qkIud8obst8kIU0Q-hMnIzc5FctF3
X-Proofpoint-GUID: NV1b1fhoXva2ZpI1BFseMSiMu4bQVNdT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302270094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-02-27 at 11:57 +0100, Pierre Morel wrote:
> On 2/24/23 18:15, Nina Schoetterl-Glausch wrote:
> > On Wed, 2023-02-22 at 15:21 +0100, Pierre Morel wrote:
> > > The modification of the CPU attributes are done through a monitor
> > > command.
> > >=20
> > > It allows to move the core inside the topology tree to optimize
> > > the cache usage in the case the host's hypervisor previously
> > > moved the CPU.
> > >=20
> > > The same command allows to modify the CPU attributes modifiers
> > > like polarization entitlement and the dedicated attribute to notify
> > > the guest if the host admin modified scheduling or dedication of a vC=
PU.
> > >=20
> > > With this knowledge the guest has the possibility to optimize the
> > > usage of the vCPUs.
> > >=20
> > > The command has a feature unstable for the moment.
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   qapi/machine-target.json |  35 +++++++++
> > >   include/monitor/hmp.h    |   1 +
> > >   hw/s390x/cpu-topology.c  | 154 ++++++++++++++++++++++++++++++++++++=
+++
> > >   hmp-commands.hx          |  17 +++++
> > >   4 files changed, 207 insertions(+)
> > >=20
[...]
> > >=20
> > > diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> > > index ed5fc75381..3a7eb441a3 100644
> > > --- a/hw/s390x/cpu-topology.c
> > > +++ b/hw/s390x/cpu-topology.c
> > > @@ -19,6 +19,12 @@
> > >=20
[...]
> > > +
> > > +void qmp_set_cpu_topology(uint16_t core,
> > > +                         bool has_socket, uint16_t socket,
> > > +                         bool has_book, uint16_t book,
> > > +                         bool has_drawer, uint16_t drawer,
> > > +                         const char *entitlement_str,
> > > +                         bool has_dedicated, bool dedicated,
> > > +                         Error **errp)
> > > +{
> > > +    bool has_entitlement =3D false;
> > > +    int entitlement;
> > > +    ERRP_GUARD();
> > > +
> > > +    if (!s390_has_topology()) {
> > > +        error_setg(errp, "This machine doesn't support topology");
> > > +        return;
> > > +    }
> > > +
> > > +    entitlement =3D qapi_enum_parse(&CpuS390Entitlement_lookup, enti=
tlement_str,
> > > +                                  -1, errp);
> > > +    if (*errp) {
> > > +        return;
> > > +    }
> > > +    has_entitlement =3D entitlement >=3D 0;
> > Doesn't this allow setting horizontal entitlement? Which shouldn't be p=
ossible,
> > only the guest can do it.
>=20
>=20
> IMHO it does not, the polarization is set by the guest through the PTF=
=20
> instruction, but entitlement is set by the host.

Yes, so when the guests requests vertical polarization, all cpus have a
(vertical) entitlement assigned and will show up as vertical in STSI.
But now, by using the qmp command, the polarization can be reset to horizon=
tal,
even though the guest didn't ask for it.

>=20
>=20
> >=20
> > > +
> > > +    s390_change_topology(core, has_socket, socket, has_book, book,
> > > +                         has_drawer, drawer, has_entitlement, entitl=
ement,
> > > +                         has_dedicated, dedicated, errp);
> > > +}
> > > +
> > > +void hmp_set_cpu_topology(Monitor *mon, const QDict *qdict)
> > > +{
> > > +    const uint16_t core =3D qdict_get_int(qdict, "core-id");
> > > +    bool has_socket    =3D qdict_haskey(qdict, "socket-id");
> > > +    const uint16_t socket =3D qdict_get_try_int(qdict, "socket-id", =
0);
> > > +    bool has_book    =3D qdict_haskey(qdict, "book-id");
> > > +    const uint16_t book =3D qdict_get_try_int(qdict, "book-id", 0);
> > > +    bool has_drawer    =3D qdict_haskey(qdict, "drawer-id");
> > > +    const uint16_t drawer =3D qdict_get_try_int(qdict, "drawer-id", =
0);
> > The names here don't match the definition below, leading to a crash,
> > because core-id is a mandatory argument.
>=20
>=20
> right, I should have kept the original names or change both.
>=20
>=20
> >=20
> > > +    const char *entitlement =3D qdict_get_try_str(qdict, "entitlemen=
t");
> > > +    bool has_dedicated    =3D qdict_haskey(qdict, "dedicated");
> > > +    const bool dedicated =3D qdict_get_try_bool(qdict, "dedicated", =
false);
> > > +    Error *local_err =3D NULL;
> > > +
> > > +    qmp_set_cpu_topology(core, has_socket, socket, has_book, book,
> > > +                           has_drawer, drawer, entitlement,
> > > +                           has_dedicated, dedicated, &local_err);
> > > +    hmp_handle_error(mon, local_err);
> > > +}
> > > diff --git a/hmp-commands.hx b/hmp-commands.hx
> > > index fbb5daf09b..d8c37808c7 100644
> > > --- a/hmp-commands.hx
> > > +++ b/hmp-commands.hx
> > > @@ -1815,3 +1815,20 @@ SRST
> > >     Dump the FDT in dtb format to *filename*.
> > >   ERST
> > >   #endif
> > > +
> > > +#if defined(TARGET_S390X)
> > > +    {
> > > +        .name       =3D "set-cpu-topology",
> > > +        .args_type  =3D "core:l,socket:l?,book:l?,drawer:l?,entitlem=
ent:s?,dedicated:b?",
> > Can you use ":O" for the ids? It would allow for some more flexibility.
>=20
>=20
> Yes, or we can let fall the hmp interface for this series, making it=20
> simpler, and add the hmp interface later.
>=20
> I am more in favor of letting it fall for now.

Fine by me.
>=20
>=20
> Regards,
>=20
> Pierre
>=20
>=20
> >=20
> > > +        .params     =3D "core [socket] [book] [drawer] [entitlement]=
 [dedicated]",
> > > +        .help       =3D "Move CPU 'core' to 'socket/book/drawer' "
> > > +                      "optionally modifies entitlement and dedicatio=
n",
> > > +        .cmd        =3D hmp_set_cpu_topology,
> > > +    },
> > > +
> > > +SRST
> > > +``set-cpu-topology`` *core* *socket* *book* *drawer* *entitlement* *=
dedicated*
> > > +  Modify CPU topology for the CPU *core* to move on *socket* *book* =
*drawer*
> > > +  with topology attributes *entitlement* *dedicated*.
> > > +ERST
> > > +#endif

