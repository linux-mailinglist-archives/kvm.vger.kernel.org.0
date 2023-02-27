Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDAE6A3FB2
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 11:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjB0KuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 05:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjB0KuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 05:50:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A92CDEB
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 02:50:13 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31R8wurt003418;
        Mon, 27 Feb 2023 10:49:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=loQabxH0vlWcORAj5uxHBi3M5P3wdozhyzCWtaJeRck=;
 b=cIXXUJWkr4r7spOv3n63BAYksohZ+AzGFAxu220Cb+K7go9mfFrAM+L/SlRPw6TG+PxN
 0vKC+c7I0tu4FtmLVCIFMEWE0XYOoIVIlf6CgNN0PjYozISVs//HpomDMWIq+YMgA4TB
 RS+rklyg0uAtCaH5Hat3T5hKpLOwd5TbMcnuyT2XV2xlxubyYjrpVbg+U3RRjQJSxnT4
 oai65ZsjyLWrb8yZreSAfr6GXJv9IVjSGqutg+r9IEzqBxOXZxsf7d8TO/r3hY2ZhFje
 DAUj1VLcTzFfPnnLsW1ppSLOxUWxs4E3cH9PxAbJjTrwWBdPSLagcqYXnIs/+4dsEeeU Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nyv91f33w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 10:49:58 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31RAAVNs019842;
        Mon, 27 Feb 2023 10:49:57 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nyv91f33c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 10:49:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31Q7EF62011251;
        Mon, 27 Feb 2023 10:49:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3nybe2hc31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 10:49:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31RAnpW359441548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 10:49:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A92E32004B;
        Mon, 27 Feb 2023 10:49:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3914820065;
        Mon, 27 Feb 2023 10:49:51 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.148.35])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Feb 2023 10:49:51 +0000 (GMT)
Message-ID: <9e1cbbe11ac1429335c288e817a21f19f8f4af87.camel@linux.ibm.com>
Subject: Re: [PATCH v16 08/11] qapi/s390x/cpu topology: set-cpu-topology
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
Date:   Mon, 27 Feb 2023 11:49:51 +0100
In-Reply-To: <0a93eb0e-2552-07b7-2067-f46d542126f4@redhat.com>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
         <20230222142105.84700-9-pmorel@linux.ibm.com>
         <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
         <0a93eb0e-2552-07b7-2067-f46d542126f4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pYQPhDFn51YB9QZWwukRZm99_ShcjQjp
X-Proofpoint-GUID: n52v-nduhPK6KcvYawdLMLEcr3amnidW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-26_22,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 bulkscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302270081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-02-27 at 08:59 +0100, Thomas Huth wrote:
> On 24/02/2023 18.15, Nina Schoetterl-Glausch wrote:
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
> > > diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> > > index a52cc32f09..baa9d273cf 100644
> > > --- a/qapi/machine-target.json
> > > +++ b/qapi/machine-target.json
> > > @@ -354,3 +354,38 @@
> > >   { 'enum': 'CpuS390Polarization',
> > >     'prefix': 'S390_CPU_POLARIZATION',
> > >     'data': [ 'horizontal', 'vertical' ] }
> > > +
> > > +##
> > > +# @set-cpu-topology:
> > > +#
> > > +# @core-id: the vCPU ID to be moved
> > > +# @socket-id: optional destination socket where to move the vCPU
> > > +# @book-id: optional destination book where to move the vCPU
> > > +# @drawer-id: optional destination drawer where to move the vCPU
> > > +# @entitlement: optional entitlement
> > > +# @dedicated: optional, if the vCPU is dedicated to a real CPU
> > > +#
> > > +# Features:
> > > +# @unstable: This command may still be modified.
> > > +#
> > > +# Modifies the topology by moving the CPU inside the topology
> > > +# tree or by changing a modifier attribute of a CPU.
> > > +# Default value for optional parameter is the current value
> > > +# used by the CPU.
> > > +#
> > > +# Returns: Nothing on success, the reason on failure.
> > > +#
> > > +# Since: 8.0
> > > +##
> > > +{ 'command': 'set-cpu-topology',
> > > +  'data': {
> > > +      'core-id': 'uint16',
> > > +      '*socket-id': 'uint16',
> > > +      '*book-id': 'uint16',
> > > +      '*drawer-id': 'uint16',
> > > +      '*entitlement': 'str',
> >=20
> > How about you add a machine-common.json and define CpuS390Entitlement t=
here,
> > and then include it from both machine.json and machine-target.json?
>=20
> I'm not sure whether double inclusion works with the QAPI parser (since t=
his=20
> might code to be generated twice) ... have you tried?

I haven't, the documentation says:

> Include directives
> ------------------
>=20
> Syntax::
>=20
>     INCLUDE =3D { 'include': STRING }
>=20
> The QAPI schema definitions can be modularized using the 'include' direct=
ive::
>=20
>  { 'include': 'path/to/file.json' }
>=20
> The directive is evaluated recursively, and include paths are relative
> to the file using the directive.  Multiple includes of the same file
> are idempotent.

Which is why I thought it should work, but I guess this is a statement abou=
t
including the same file twice in another file and not about including the s=
ame
file from two files.

But then, as far as I can tell, the build system only builds qapi-schema.js=
on,
which includes all other files, so it could apply.
>=20
>=20
>   Thomas
>=20

