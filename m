Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62476F58F7
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 15:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjECNVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 09:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjECNVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 09:21:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C815FE8
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 06:21:49 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343DEBQR012265;
        Wed, 3 May 2023 13:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Fhs4BJdhEEKnJwBGpaQP5atlBQmszCVyWUcOFzxz6VQ=;
 b=HcCRaixescAXD7RxAOc9Mr5N2NEF2d0yyf8edOHh/+x3pnAKL0+XBKvGD0x8Fe1N9HCA
 FckCTC2Oyr1GqVtNOHrQWtEdnwZmSMOvGZCINR5oW6Ct862Jp0e/FJ2TWHqTtGtHqYf7
 skYskmsFPVnQxbFge5nGJIdLC+nbKUSM6J5HhkAUf8Q70AafLnXk68k0a2qdpIdLrHVt
 CD61TFyJ55qKzjzZEBfzh0+kjm/A6tVWuDHK9kABh1VgTuzx2gfTjIjZA4mXkjuSz1sF
 0VDlw9qH1PAED28t0xnYyXKPYIfx9xAF3bGk5B4XzvmuaLu5025bdhoFZ10tHmySIfLZ 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbrap0bt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 13:21:26 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 343DKoPS018661;
        Wed, 3 May 2023 13:21:25 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbrap0br4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 13:21:25 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3433qbo4016351;
        Wed, 3 May 2023 13:01:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6su1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 13:01:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 343D18bo28508850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 13:01:08 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F13F20043;
        Wed,  3 May 2023 13:01:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49EB820040;
        Wed,  3 May 2023 13:01:07 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.79.14])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  3 May 2023 13:01:07 +0000 (GMT)
Message-ID: <b442a9c506efa66b18b566e859966614e82e2273.camel@linux.ibm.com>
Subject: Re: [PATCH v20 03/21] target/s390x/cpu topology: handle STSI(15)
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
Date:   Wed, 03 May 2023 15:01:06 +0200
In-Reply-To: <d1949e44-a4c1-4f7a-6a81-c909ecb610fa@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
         <20230425161456.21031-4-pmorel@linux.ibm.com>
         <5f4fa29eaec7269350403b2d1b2b051e6aa59a39.camel@linux.ibm.com>
         <d1949e44-a4c1-4f7a-6a81-c909ecb610fa@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yntoHMvAhkJUztNoV9l2ykep4dv5-CXI
X-Proofpoint-ORIG-GUID: Y3O-EPTtM3rCXRrgt1TabhCC_93K_Fpg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_08,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-05-03 at 10:43 +0200, Pierre Morel wrote:
> On 5/2/23 19:22, Nina Schoetterl-Glausch wrote:
> > On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
> > > On interception of STSI(15.1.x) the System Information Block
> > > (SYSIB) is built from the list of pre-ordered topology entries.
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   MAINTAINERS                     |   1 +
> > >   include/hw/s390x/cpu-topology.h |  24 +++
> > >   include/hw/s390x/sclp.h         |   1 +
> > >   target/s390x/cpu.h              |  72 ++++++++
> > >   hw/s390x/cpu-topology.c         |  13 +-
> > >   target/s390x/kvm/cpu_topology.c | 308 +++++++++++++++++++++++++++++=
+++
> > >   target/s390x/kvm/kvm.c          |   5 +-
> > >   target/s390x/kvm/meson.build    |   3 +-
> > >   8 files changed, 424 insertions(+), 3 deletions(-)
> > >   create mode 100644 target/s390x/kvm/cpu_topology.c
> > >=20
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index bb7b34d0d8..de9052f753 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -1659,6 +1659,7 @@ M: Pierre Morel <pmorel@linux.ibm.com>
> > >   S: Supported
> > >   F: include/hw/s390x/cpu-topology.h
> > >   F: hw/s390x/cpu-topology.c
> > > +F: target/s390x/kvm/cpu_topology.c
> > >  =20
> > >   X86 Machines
> > >   ------------
> > > diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-t=
opology.h
> > > index af36f634e0..87bfeb631e 100644
> > > --- a/include/hw/s390x/cpu-topology.h
> > > +++ b/include/hw/s390x/cpu-topology.h
> > > @@ -15,9 +15,33 @@
> > >=20
> > [...]
> >=20
> > > +typedef struct S390TopologyEntry {
> > > +    QTAILQ_ENTRY(S390TopologyEntry) next;
> > > +    s390_topology_id id;
> > > +    uint64_t mask;
> > > +} S390TopologyEntry;
> > > +
> > >   typedef struct S390Topology {
> > >       uint8_t *cores_per_socket;
> > > +    QTAILQ_HEAD(, S390TopologyEntry) list;
> > Since you recompute the list on every STSI, you no longer need this in =
here.
> > You can create it in insert_stsi_15_1_x.
>=20
> Sure but why should we do that?
>=20
> It does not change functionality or performance and I do not find it=20
> makes the code clearer.
> On the other hand it changes the implementation and the initialization=
=20
> of the list with the sentinel becomes tricky.

IMO, it's a local calculation, so it should be local.
It makes the question "how is this list calculated" when reading the code e=
asier,
because, instead of having to check where a global is accessed you just hav=
e to look
at the call stack.

You can just move

+    entry =3D g_malloc0(sizeof(S390TopologyEntry));
+    entry->id.sentinel =3D 0xff;
+    QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);

to s390_topology_fill_list_sorted. And completely free the list in s390_top=
ology_empty_list.
>=20
[...]
>=20

