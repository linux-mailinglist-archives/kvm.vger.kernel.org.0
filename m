Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E8666DEE6
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjAQNcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjAQNbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:31:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241653A58B
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:31:39 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HCBISh009667;
        Tue, 17 Jan 2023 13:31:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=pX3hRGUsw+c2U75s3EOhL0Pu5zEJkmkPQ1R35LiXsrU=;
 b=XTf9dZ/YTIq4+RjDTgJX4UCHXpBxXiEGlMTy8Vb0hnGxFshTC8D0jtrU8LSL3q8sEOmI
 rqxk/8r0SinkwtWj5aCGJCS9VWeNqGNkiMmYdmOszjWVGfDwqim2t84D60YImgp5bhtl
 duWon1eX0KgIDZ/sVMSXwIoA2os2hBcSyd2JzZs7Ar0RQ3AGTWgdl285VY+08snfYt79
 K92IFKSp2qt0jU/ANWSSEj+1JEzA4bKAs1K0tM9Vr3RtkhYGqKfZBXm63DILj23nm2Nv
 1d763Haboklj3/BGzWOhOzZjYRt4PRtZ7v7yiCiPXCsDBrpDU6tI1JMnOVWfVGQH9pJR 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5m19brc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 13:31:31 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HD6Wbl008779;
        Tue, 17 Jan 2023 13:31:30 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5m19brbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 13:31:30 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H2ifjs005026;
        Tue, 17 Jan 2023 13:31:28 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n3knfauk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 13:31:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HDVPxQ24052388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 13:31:25 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0938320043;
        Tue, 17 Jan 2023 13:31:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95E8120040;
        Tue, 17 Jan 2023 13:31:24 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.186.145])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 13:31:24 +0000 (GMT)
Message-ID: <5654d88fb7d000369c6cfdbe0213ca9d2bfe013b.camel@linux.ibm.com>
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology
 monitor command
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Date:   Tue, 17 Jan 2023 14:31:24 +0100
In-Reply-To: <cd9e0c88-c2a8-1eca-d146-3fd6639af3e7@redhat.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-9-pmorel@linux.ibm.com>
         <72baa5b42abe557cdf123889b33b845b405cc86c.camel@linux.ibm.com>
         <cd9e0c88-c2a8-1eca-d146-3fd6639af3e7@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rIVjG-mLXBNxRuYP0__qDBhyV5TZ_2Yn
X-Proofpoint-GUID: St1fF0Q8fk7OqH3jl6-sIg7I2qS5V30t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_05,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 clxscore=1015 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-01-17 at 08:30 +0100, Thomas Huth wrote:
> On 16/01/2023 22.09, Nina Schoetterl-Glausch wrote:
> > On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
> > > The modification of the CPU attributes are done through a monitor
> > > commands.
> > >=20
> > > It allows to move the core inside the topology tree to optimise
> > > the cache usage in the case the host's hypervizor previously
> > > moved the CPU.
> > >=20
> > > The same command allows to modifiy the CPU attributes modifiers
> > > like polarization entitlement and the dedicated attribute to notify
> > > the guest if the host admin modified scheduling or dedication of a vC=
PU.
> > >=20
> > > With this knowledge the guest has the possibility to optimize the
> > > usage of the vCPUs.
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> ...
> > > diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> > > index b69955a1cd..0faffe657e 100644
> > > --- a/hw/s390x/cpu-topology.c
> > > +++ b/hw/s390x/cpu-topology.c
> > > @@ -18,6 +18,10 @@
> > >   #include "target/s390x/cpu.h"
> > >   #include "hw/s390x/s390-virtio-ccw.h"
> > >   #include "hw/s390x/cpu-topology.h"
> > > +#include "qapi/qapi-commands-machine-target.h"
> > > +#include "qapi/qmp/qdict.h"
> > > +#include "monitor/hmp.h"
> > > +#include "monitor/monitor.h"
> > >  =20
> > >   /*
> > >    * s390_topology is used to keep the topology information.
> > > @@ -203,6 +207,21 @@ static void s390_topology_set_entry(S390Topology=
Entry *entry,
> > >       s390_topology.sockets[s390_socket_nb(id)]++;
> > >   }
> > >  =20
> > > +/**
> > > + * s390_topology_clear_entry:
> > > + * @entry: Topology entry to setup
> > > + * @id: topology id to use for the setup
> > > + *
> > > + * Clear the core bit inside the topology mask and
> > > + * decrements the number of cores for the socket.
> > > + */
> > > +static void s390_topology_clear_entry(S390TopologyEntry *entry,
> > > +                                      s390_topology_id id)
> > > +{
> > > +    clear_bit(63 - id.core, &entry->mask);
> >=20
> > This doesn't take the origin into account.
> >=20
> > > +    s390_topology.sockets[s390_socket_nb(id)]--;
> >=20
> > I suppose this function cannot run concurrently, so the same CPU doesn'=
t get removed twice.
>=20
> QEMU has the so-called BQL - the Big Qemu Lock. Instructions handlers are=
=20
> normally called with the lock taken, see qemu_mutex_lock_iothread() in=
=20
> target/s390x/kvm/kvm.c.

That is good to know, but is that the relevant lock here?
We don't want to concurrent qmp commands. I looked at the code and it's pre=
tty complicated.
>=20
> (if you feel unsure, you can add a "assert(qemu_mutex_iothread_locked())"=
=20
> statement, but I think it is not necessary here)
>=20
>   Thomas
>=20

