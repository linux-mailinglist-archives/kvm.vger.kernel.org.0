Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753A8689E71
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 16:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbjBCPj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 10:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBCPjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 10:39:23 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8B635B3
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 07:39:22 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313F5Mwp012795;
        Fri, 3 Feb 2023 15:39:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=yf9hi4try+M0gI+gA/XXpA/+lC76ObWN98F126R030A=;
 b=ZkbvsseUwBTQwSDQHfN3zCbtCQOom6ZfjP8GcXmRmXxB/zKh9Axu+Y/iz1ycD09FivYd
 UPpowKMrY+SMnQdqMZOO/cKeT1CnDCYwOqKINLQ8XJyubr1Xoe+9SrNgNnU0Y69cEOR9
 OzV4twY7JGGlG5XTo+EY5ng0reV7WYgI/Z2kXqLAsyhHKWkXLWCYVud4d+UZajE1Simb
 Re5QRsdDAfnjDAZluzkNiav1tIL80UzDrEVElDJu8AAtea4JrU9AQ59ujJg3OJ+Mj31X
 O9EcT7G2gI9Nqdf9o3g0WGHtrUc+9DZOZ9OV2ucpSVPUFbX/eN3xtniv69tz/TmTzvSG Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh29rvm7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 15:39:01 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 313DkDGf030326;
        Fri, 3 Feb 2023 15:39:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh29rvm6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 15:39:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31363pxI026867;
        Fri, 3 Feb 2023 15:38:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ncvs7qm0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 15:38:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 313FctDh51249536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 15:38:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B4E72004B;
        Fri,  3 Feb 2023 15:38:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C984E20040;
        Fri,  3 Feb 2023 15:38:54 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.195.237])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Feb 2023 15:38:54 +0000 (GMT)
Message-ID: <65fd62450cb6bc61908fe68425a5a56affadc794.camel@linux.ibm.com>
Subject: Re: [PATCH v15 02/11] s390x/cpu topology: add topology entries on
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
Date:   Fri, 03 Feb 2023 16:38:54 +0100
In-Reply-To: <5ad1cc6a-5d2d-57fc-f082-ec6f843c877e@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-3-pmorel@linux.ibm.com>
         <6345131acfb04e353ca2eba620bf27609bfeb535.camel@linux.ibm.com>
         <c2c502ca-2a1f-d29f-8931-4be7389557ee@linux.ibm.com>
         <45bb29fcb3629a857577e50378adab1f5598644e.camel@linux.ibm.com>
         <5ad1cc6a-5d2d-57fc-f082-ec6f843c877e@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Fvz5BUO2_couob5oepDthtQSMEEvF0W7
X-Proofpoint-ORIG-GUID: W-cl41jmQDY_s_iyCR-4glFx-hVCytxA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_15,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030139
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-03 at 15:40 +0100, Pierre Morel wrote:
>=20
> On 2/3/23 14:22, Nina Schoetterl-Glausch wrote:
> > On Fri, 2023-02-03 at 10:21 +0100, Pierre Morel wrote:
> > >=20
> > > On 2/2/23 17:42, Nina Schoetterl-Glausch wrote:
> > > > On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> > > > > The topology information are attributes of the CPU and are
> > > > > specified during the CPU device creation.
> > > > >=20
> > > > > On hot plug we:
> > > > > - calculate the default values for the topology for drawers,
> > > > >     books and sockets in the case they are not specified.
> > > > > - verify the CPU attributes
> > > > > - check that we have still room on the desired socket
> > > > >=20
> > > > > The possibility to insert a CPU in a mask is dependent on the
> > > > > number of cores allowed in a socket, a book or a drawer, the
> > > > > checking is done during the hot plug of the CPU to have an
> > > > > immediate answer.
> > > > >=20
> > > > > If the complete topology is not specified, the core is added
> > > > > in the physical topology based on its core ID and it gets
> > > > > defaults values for the modifier attributes.
> > > > >=20
> > > > > This way, starting QEMU without specifying the topology can
> > > > > still get some advantage of the CPU topology.
> > > > >=20
> > > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > > ---
> > > > >    include/hw/s390x/cpu-topology.h |  24 +++
> > > > >    hw/s390x/cpu-topology.c         | 256 ++++++++++++++++++++++++=
++++++++
> > > > >    hw/s390x/s390-virtio-ccw.c      |  23 ++-
> > > > >    hw/s390x/meson.build            |   1 +
> > > > >    4 files changed, 302 insertions(+), 2 deletions(-)
> > > > >    create mode 100644 hw/s390x/cpu-topology.c
> > > > >=20
> > [...]
> > > >=20
> > > > > +/**
> > > > > + * s390_set_core_in_socket:
> > > > > + * @cpu: the new S390CPU to insert in the topology structure
> > > > > + * @drawer_id: new drawer_id
> > > > > + * @book_id: new book_id
> > > > > + * @socket_id: new socket_id
> > > > > + * @creation: if is true the CPU is a new CPU and there is no ol=
d socket
> > > > > + *            to handle.
> > > > > + *            if is false, this is a moving the CPU and old sock=
et count
> > > > > + *            must be decremented.
> > > > > + * @errp: the error pointer
> > > > > + *
> > > > > + */
> > > > > +static void s390_set_core_in_socket(S390CPU *cpu, int drawer_id,=
 int book_id,
> > > >=20
> > > > Maybe name it s390_(topology_)?add_core_to_socket instead.
> > >=20
> > > OK, it is better
> > >=20
> > > >=20
> > > > > +                                    int socket_id, bool creation=
, Error **errp)
> > > > > +{
> > > > > +    int old_socket =3D s390_socket_nb(cpu);
> > > > > +    int new_socket;
> > > > > +
> > > > > +    if (creation) {
> > > > > +        new_socket =3D old_socket;
> > > > > +    } else {
> > > >=20
> > > > You need parentheses here.
> > > >=20
> > > > > +        new_socket =3D drawer_id * s390_topology.smp->books +
> > > >                          (
> > > > > +                     book_id * s390_topology.smp->sockets +
> > > >                                  )
> > > > > +                     socket_id;
> > >=20
> > > If you prefer I can us parentheses.
> >=20
> > It's necessary, otherwise the multiplication of book_id and smp->socket=
s takes precedence.
> > >=20
> > >=20
>=20
> Right, I did not understand where you want the parenthesis.
> I think you mean:
>=20
>          new_socket =3D (drawer_id * s390_topology.smp->books + book_id) =
*
>                       s390_topology.smp->sockets + socket_id;

Yes, exactly. I see how it was ambiguous.
>=20
> thanks,
>=20
> Regards,
> Pierre
>=20

