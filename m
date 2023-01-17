Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C6966E409
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 17:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbjAQQtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 11:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbjAQQtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 11:49:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AA59EF2
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 08:49:06 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HGUh66029161;
        Tue, 17 Jan 2023 16:49:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=n0YBDYKcLFNtdBHv+ttAeAwbiwIxAveDWQDeyaORJNM=;
 b=KfsVhljijER+aXgWVsYBzbxDXcj3sktN3WFe36jYwF26qHLFow8eQrJt9WSZ0KG2EUOz
 +x5Wu51VuF3/AVW+JhX8ZJP7p61lQv1O4+mEG5ZmJVw/Uh8lUhRn56wjuh0C602djLIO
 IO35PpZpaNocbMNomJEJcw3SibocyQvyWHjTyj2bja+x0Z6XDbzKHFRyv4aNKYGdf7EH
 SrhJC0CSB31yx8rcvzbYhclACs9ZWmThVRivxnnVCFJf7i7WRDEOA8FhO1751CiYpIpX
 xbYgptUZHg6tM8kdZVKeR57idhRa5Aan1XEFz5c0E8+I3HiVWYpil+zhFCrEiDZuFtx/ 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5x3samet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 16:48:59 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HFQurS027223;
        Tue, 17 Jan 2023 16:48:59 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5x3samdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 16:48:59 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30HELbIl015767;
        Tue, 17 Jan 2023 16:48:56 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n3m16k1dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 16:48:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HGmqhA23331546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 16:48:53 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD61F20043;
        Tue, 17 Jan 2023 16:48:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81D0A20040;
        Tue, 17 Jan 2023 16:48:52 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.186.145])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 16:48:52 +0000 (GMT)
Message-ID: <13ad4df8bc83f552ae1c9aad4f1a44d18963e7a8.camel@linux.ibm.com>
Subject: Re: [PATCH v14 02/11] s390x/cpu topology: add topology entries on
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
Date:   Tue, 17 Jan 2023 17:48:52 +0100
In-Reply-To: <8063592a-971a-d029-e8ac-0fb6286199d5@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-3-pmorel@linux.ibm.com>
         <666b9711b23d807525be06992fffd4d782ee80c7.camel@linux.ibm.com>
         <8063592a-971a-d029-e8ac-0fb6286199d5@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4Lri38RTcwwgef9jBrw6kpKM7BaC3Uz5
X-Proofpoint-GUID: 4Nt8pDw41bbjVlpGc5k7RO0qsErGb7k_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_08,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 mlxlogscore=999 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170133
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-01-17 at 14:55 +0100, Pierre Morel wrote:
>=20
> On 1/13/23 19:15, Nina Schoetterl-Glausch wrote:
> >=20
[...]

> > > +/**
> > > + * s390_topology_set_entry:
> > > + * @entry: Topology entry to setup
> > > + * @id: topology id to use for the setup
> > > + *
> > > + * Set the core bit inside the topology mask and
> > > + * increments the number of cores for the socket.
> > > + */
> > > +static void s390_topology_set_entry(S390TopologyEntry *entry,
> >=20
> > Not sure if I like the name, what it does is to add a cpu to the entry.
>=20
> s390_topology_add_cpu_to_entry() ?

Yeah, that's better.

[...]
>=20
> > > +/**
> > > + * s390_topology_set_cpu:
> > > + * @ms: MachineState used to initialize the topology structure on
> > > + *      first call.
> > > + * @cpu: the new S390CPU to insert in the topology structure
> > > + * @errp: the error pointer
> > > + *
> > > + * Called from CPU Hotplug to check and setup the CPU attributes
> > > + * before to insert the CPU in the topology.
> > > + */
> > > +void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **e=
rrp)
> > > +{
> > > +    Error *local_error =3D NULL;
> >=20
> > Can't you just use ERRP_GUARD ?
>=20
> I do not think it is necessary and I find it obfuscating.
> So, should I?

/*
 * Propagate error object (if any) from @local_err to @dst_errp.
[...]
 * Please use ERRP_GUARD() instead when possible.
 * Please don't error_propagate(&error_fatal, ...), use
 * error_report_err() and exit(), because that's more obvious.
 */
void error_propagate(Error **dst_errp, Error *local_err);

So I'd say yes.
>=20
> >=20
> > > +    s390_topology_id id;
> > > +
> > > +    /*
> > > +     * We do not want to initialize the topology if the cpu model
> > > +     * does not support topology consequently, we have to wait for
> >=20
> > ", consequently," I think. Could you do the initialization some where e=
lse,
> > after you know what the cpu model is? Not that I object to doing it thi=
s way.
> >=20
>=20
> I did not find a better place, it must be done after the CPU model is=20
> initialize and before the first CPU is created.
> The cpu model is initialized during the early creation of the first cpu.
>=20
> Any idea?
>=20
> Thanks.
>=20
> Regards,
> Pierre
>=20

