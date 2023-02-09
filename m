Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAF26908C0
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 13:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBIM2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 07:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjBIM2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 07:28:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F307786AD
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 04:28:39 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319BoYXm001049;
        Thu, 9 Feb 2023 12:28:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=u0fnO6UXmrW6o1hmKCl4YNj1jR5rtGs680h9SMIRnB8=;
 b=KLmauad+IbafwhThMjjoAKfrlOHQq0dX1T3RzWTzbOEHe1gxAL9/KbpnfTppKcLcAk0/
 VMGGNWmX5FPx6wTLmE+zBjnWC3Acm4nAx9CxZZxm17viWPzk2eVWP2MtSas+VXH/QdCP
 AfJYYmSmePRYCk8tJmQKxXKcuY0h02CW1VoLhssIR/Rn4bB0C2a5ym7I49bp4uh4xy3o
 MrpKC1zS+8rurVpoj0Dq8DqIFUtIcWK00b1tieQgf6oiIHvTAFTSHYb6ccO++8o8Ac/i
 mtkd5GnBX/UgJbwMpNoXeCyXG6HK8BP8NpKQQCMZ93oeUsdEOGeNGgzvBlFlj6v/e8xe Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn0ahgweu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 12:28:26 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319BsPkD013979;
        Thu, 9 Feb 2023 12:28:25 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn0ahgwdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 12:28:25 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3192pXZo014014;
        Thu, 9 Feb 2023 12:28:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3nhf06vcjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 12:28:22 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319CSJvk47776100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 12:28:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5AE720040;
        Thu,  9 Feb 2023 12:28:18 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 831FC2004B;
        Thu,  9 Feb 2023 12:28:18 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.135.170])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 12:28:18 +0000 (GMT)
Message-ID: <32389178edcf67ac08904906df9a12aa64f24928.camel@linux.ibm.com>
Subject: Re: [PATCH v15 10/11] qapi/s390x/cpu topology: CPU_POLARITY_CHANGE
 qapi event
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Thu, 09 Feb 2023 13:28:18 +0100
In-Reply-To: <87y1p8q7v6.fsf@pond.sub.org>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-11-pmorel@linux.ibm.com>
         <5b26ee514ccbbfaf5670cbf0cb006d8e706fe5ae.camel@linux.ibm.com>
         <87y1p8q7v6.fsf@pond.sub.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LOhjIW0jyaxvC6whH550XofMazowKNVZ
X-Proofpoint-ORIG-GUID: ZnXCxP6PjPVdfxV2Xt3TWEd8wKw4P5J7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 mlxscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302090115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-08 at 20:23 +0100, Markus Armbruster wrote:
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:
>=20
> > On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> > > When the guest asks to change the polarity this change
> > > is forwarded to the admin using QAPI.
> > > The admin is supposed to take according decisions concerning
> > > CPU provisioning.
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >  qapi/machine-target.json | 30 ++++++++++++++++++++++++++++++
> > >  hw/s390x/cpu-topology.c  |  2 ++
> > >  2 files changed, 32 insertions(+)
> > >=20
> > > diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> > > index 58df0f5061..5883c3b020 100644
> > > --- a/qapi/machine-target.json
> > > +++ b/qapi/machine-target.json
> > > @@ -371,3 +371,33 @@
> > >    },
> > >    'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> > >  }
> > > +
> > > +##
> > > +# @CPU_POLARITY_CHANGE:
> > > +#
> > > +# Emitted when the guest asks to change the polarity.
> > > +#
> > > +# @polarity: polarity specified by the guest
> > > +#
> > > +# The guest can tell the host (via the PTF instruction) whether the
> > > +# CPUs should be provisioned using horizontal or vertical polarity.
> > > +#
> > > +# On horizontal polarity the host is expected to provision all vCPUs
> > > +# equally.
> > > +# On vertical polarity the host can provision each vCPU differently.
> > > +# The guest will get information on the details of the provisioning
> > > +# the next time it uses the STSI(15) instruction.
> > > +#
> > > +# Since: 8.0
> > > +#
> > > +# Example:
> > > +#
> > > +# <- { "event": "CPU_POLARITY_CHANGE",
> > > +#      "data": { "polarity": 0 },
> > > +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 =
} }
> > > +#
> > > +##
> > > +{ 'event': 'CPU_POLARITY_CHANGE',
> > > +  'data': { 'polarity': 'int' },
> > > +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM'] }
> >=20
> > I wonder if you should depend on CONFIG_KVM or not. If tcg gets topolog=
y
> > support it will use the same event and right now it would just never be=
 emitted.
> > On the other hand it's more conservative this way.
>=20
> TCG vs. KVM should be as transparent as we can make it.
>=20
> If only KVM can get into the state where the event is emitted, say
> because the state is only possible with features only KVM supports, then
> making the event conditional on KVM makes sense.  Of course, when
> another accelerator acquires these features, we need to emit the event
> there as well, which will involve adjusting the condition.

That's the case here, KVM supports the feature, TCG doesn't, although there=
 is no
reason it couldn't in the future.

>=20
> > I also wonder if you should add 'feature' : [ 'unstable' ].
> > On the upside, it would mark the event as unstable, but I don't know wh=
at the
> > consequences are exactly.
>=20
> docs/devel/qapi-code-gen.rst:
>=20
>     Special features
>     ~~~~~~~~~~~~~~~~
>=20
>     Feature "deprecated" marks a command, event, enum value, or struct
>     member as deprecated.  It is not supported elsewhere so far.
>     Interfaces so marked may be withdrawn in future releases in accordanc=
e
>     with QEMU's deprecation policy.
>=20
>     Feature "unstable" marks a command, event, enum value, or struct
>     member as unstable.  It is not supported elsewhere so far.  Interface=
s
>     so marked may be withdrawn or changed incompatibly in future releases=
.

Yeah, I saw that, but wasn't aware of -compat, thanks.

>=20
> See also -compat parameters unstable-input, unstable-output, both
> intended for "testing the future".
>=20
> > Also I guess one can remove qemu events without breaking backwards comp=
atibility,
> > since they just won't be emitted? Unless I guess you specify that a eve=
nt must
> > occur under certain situations and the client waits on it?
>=20
> Events are part of the interface just like command returns are.  Not
> emitting an event in a situation where it was emitted before can easily
> break things.  Only when the situation is no longer possible, the event
> can be removed safely.

@Pierre, seems it would be a good idea to mark all changes to qmp unstable,=
 not just
set-cpu-topology, can just remove it later after all.

>=20
> Questions?
>=20
> [...]
>=20

