Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024A048A7BE
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 07:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348176AbiAKGeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 01:34:23 -0500
Received: from mail-dm3nam07on2072.outbound.protection.outlook.com ([40.107.95.72]:2880
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232940AbiAKGeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 01:34:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mr5g3j5Y8vM6z2EPb9gubL60Ik/6SRivpUpE6cqTv218iyXHxnoxToVG1w0var4kSMgsCsS3Ux77ogxsYAdcFv8OauD1MIwwkBeL8yE4SCEXhmnxLb65ggIvGhSfrpDR69R3P2JVDXUnbxSsRpuYMVyZDFeGgKMkiZEmSkdypd8hrlNCuufdyavIZI6BY3Fq1og7IliNbWaar3OfdD6CzWD/4R1aKzFaEGHv8pedipKaxnUEeAWarMb7GHDzOlshn+ykkB9kujSwfozl+fPPUQQKZGzxumzkTdSujF0J79papuVfBQ5vX2Wrq77HJD0q+VcaTToeMJrtr+VMW+hIQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQBdKds2ElfzJgOeDXh5sfBN+PFAZzCz+VugXcl97VY=;
 b=G2QgQnRb+PepOx9IGwP6OZGh7YwK5Roe7HTZ7xnB5Bj3gWDVxpF8o2IogFsQFaPObQXPfj/12YILJRF01NdEPGYbzHw1APPswrjBz2Eny/ZtoioCqvtfT8vxvTiTpij6rDFe9wKZgaO9D9JPzVwuAiuuM4nQijNcKyB+hcisgPQNxh7smt3hqDGrHVDntUeivcazRt6eT51MlrJx+QmLu39XHtGGZSd21QQlvmFBJX5WcEQIOqjv8mqT21Ec6tob9PApFDzi5qWL6GJniAlhsfBIFU34hHwT8a+wp+BFMV+uWHrfhITC/pZzdUo+qnQxpUDnc9H0VZFCyTjI1Dt/Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQBdKds2ElfzJgOeDXh5sfBN+PFAZzCz+VugXcl97VY=;
 b=CmgeDwcPmtAwr2rxMPYufVQJIHT0mrjm4oxRpuTukvpBQVnCC+VXah1QIniE6AtE73xIq5Tda6EUKHLJHu6voyOPiszHgWL/rYLkF8APoru3x3oOK6cLHELK9OK4/rleFiUwBhP09sh3kh0lxBW1ukR7XLMEglO/fNPGqiOcOcjB/gLZ+KpzYvbf3Ckx3pkxSo6tD4WhRr4AUFuPNALvZWzYCpQxD+WoZwKjsj4kEqaV+IhAqPXk7kc6DwFel/DhIwBE4UNoQHoe8eMmN9nAXw0IQl1Ks/zzJq72vDl1XuP0evPQZrbTa5nuTMgH4UzBnS6c9mk7wwhs9CMtHo+btA==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM6PR12MB3033.namprd12.prod.outlook.com (2603:10b6:5:11e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 06:34:20 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857%7]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 06:34:20 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v2 0/3] KVM: x86: add per-vCPU exits disable
 capability
Thread-Topic: [RFC PATCH v2 0/3] KVM: x86: add per-vCPU exits disable
 capability
Thread-Index: AQHX9kn5p8X1i1nQNE66E/6hsOP7s6xc4peAgACR0JA=
Date:   Tue, 11 Jan 2022 06:34:20 +0000
Message-ID: <DM6PR12MB35005789AA6383B850DFC57ECA519@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
 <20220110161344-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220110161344-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60a3c0a6-d67e-41f3-7b7a-08d9d4cc667b
x-ms-traffictypediagnostic: DM6PR12MB3033:EE_
x-microsoft-antispam-prvs: <DM6PR12MB30333F548CA8CE9681CED885CA519@DM6PR12MB3033.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: En240mTlnzmC0Ocx3n+cCzopb95gIobXmHQyUqe1YvaJdL/waiU8X+nOLaQhCXsBazazveK064nHnYDb/NyewLcEtO9w3L7jC3sQjN+9Z33UfSxOijL43TL3mpmZxhPPIPTTt7l2vgEkGGaBdirZ7Zgp1yvAjcrt07qhURHsTH/RwwZbCQm/RQ2zr46q2+KTGNdolAduGC3qLzimSCMohLsRsPYJUK4E+vj2suESqdVlzk/kmeCTDXL85AkJIX6b8NnLpiEEzIRh3h8JGdaXOnge3KQouiPxQy0w/En8U1pleQs329QoYoGsQXtMMPZX8EwdOD/PYN/MTmhDJ4ogqTqxdmP2A4iVl5V5DSzjT44F3sazhhjLveAOK4u8SiIn1c3+1j7L/mTF+qKpZcat4ObKCwCZWOLdUiUKMeu1tOZePwpMg+1KcM9Ehm1451NHsiUAgXfCsU+u/EokDMwz1EpoUZgzgu4nVFBR1hcWgPlpXTPX/piWA2vjxbfL0NtmvlJX4bXkPHrLftayUk7ShvR2byVfmMman0h3IGM7hIP2EEe81z011eoTsn8wZeyW07UNVEcI3f1CpGZMZG5qqEiZgY2kzNCIZVBgfNUQEmAGyHPydXbcI4sinXL9BDmYI/+KCNG6EFmGuFIyXW10TtT63htzG+spOun7CbVYmuX6KJmupr2kVOBMdn1YGQykVIKRRt7QOYMUzacbyrnLkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(316002)(9686003)(6916009)(122000001)(66556008)(66446008)(64756008)(38070700005)(53546011)(8676002)(71200400001)(38100700002)(6506007)(66476007)(33656002)(83380400001)(2906002)(86362001)(66946007)(4326008)(8936002)(5660300002)(26005)(508600001)(7696005)(186003)(52536014)(55016003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b/sOmSVOIOKdTbOQTvilHi4UCCV2+Fc7UxfgLRZYX0EErP1vzmlnDpOKD8P9?=
 =?us-ascii?Q?FjsvjfVOjjaMd+m4GMB++TocTnfNcMGh9jPEW3yj6GH5JT0BGg4Ld/UvJaK3?=
 =?us-ascii?Q?VV1KNtXGsDqPQUUknbXb3tIlIbyvc2dwiCW+/pUV1jEe6MEFE/xI4g+kozHz?=
 =?us-ascii?Q?LJ+JI41EYmc+aH8Ehqfd7ynN8KSgCn7KAYMM8ZPrDftS0vFh+UnxskGFkcqA?=
 =?us-ascii?Q?FdPIJmJ5CsDQTeeKtzZZP8o7yJ0Lj+RtlvA2mnNcVp/lbqqDJFNpRvpoGWMX?=
 =?us-ascii?Q?P4+gJZMNfmtuA9Jvnfrwh0VxNCYGVuWeZCgJtMi0T4IF+eOWN2705h4JIA9R?=
 =?us-ascii?Q?6fmQL44bpuyg9wgcYcTPcg91JeRjlk4HKB111gRAAtvzK5sNX7j/b1YV+VvS?=
 =?us-ascii?Q?r6CIk+FyzIr0KLAYnO/ubGT3Btf4bYoUACAEdkT6iEPTnkwZ36jXL/Ot6aQO?=
 =?us-ascii?Q?0QPWyDfZKhv5SaOffjpaN8E/xG65QYgHegE/2rLkZ6LFUaJYBbpm0xVUsoNs?=
 =?us-ascii?Q?WfknruBx6tahv5AwaYgtMwQXiwn/TvwzggfkwhoQPOYDt9ahxa3cZgPtGPyX?=
 =?us-ascii?Q?hq1Ij+rFne8DcrWme0rT8yGc0OiML3AnYWDcAr1yqsgxDhVvtjwf/oHqpE4w?=
 =?us-ascii?Q?rqvzUYigPQqC3YbVqQcRkzO7FIWdVDWLgwfYw3bQceUHGXzo0foX6NoE2Wvv?=
 =?us-ascii?Q?qF7oQGlM6jPkTVu72anzAYrbVEs7eGzsAXsM7g3lTibwVKrLHuxvUopBJ70e?=
 =?us-ascii?Q?Iz5zV+OcIHu4T1NK8j93inyUEkOo7vbQL8BdstBxtNlkXyxFnT1ZLL4s9G4t?=
 =?us-ascii?Q?BvFWZF6132fJO/hNTmTXePcGB5JKt1MeIUgAbFWVSF3QwlXA5uCgx09IdKAa?=
 =?us-ascii?Q?gQEbSx+hAsv8MM7/hVadLkx8uje46kPFO9iU5ShHLuvEicQrBfPQf3/j4jWI?=
 =?us-ascii?Q?ZXugbxANEm1wwow1RBB99fZRdUG4zDELPOBLsr4puPYvkfm5tRxyqEFcO231?=
 =?us-ascii?Q?z+5J0WO1rfpR/SpbXwUDRdSf+i3rc4BEn6qsILWhxc/tBOhStde9mejKFdfh?=
 =?us-ascii?Q?6/2lP9h5nRpiTf+hpAF3fmk6o2mDeU0dTnKLWZzInwY7vMS6zNE0Jqbybpzd?=
 =?us-ascii?Q?rQLHbJNIzWz73LZ5mu2F0LCFjR0iL1+nsM4TpXDQVlmti1Z/M9oih+xMftF7?=
 =?us-ascii?Q?9tJtKZDV74GIVPHTZoJ7f/5nGtbbGFRD4rHosVw4u7Xd4WRa24Zqin6gi4ny?=
 =?us-ascii?Q?vRjFBK1FOl+2Sg71xr8s41SU06NIRO+R3UG65OBnK7K3BfkOAnI696uKs/Ru?=
 =?us-ascii?Q?2/t2nmlM35diDjIUOmAbGOhrXttn/rTjvxMQJ0egHI12p5sRjln4YV2V9uqX?=
 =?us-ascii?Q?NsoYgy/+RC86fWPH8cJIxy0EZrlCSFUbFZb+ChArPYrXfOi4LR7ZX7Bm8PWo?=
 =?us-ascii?Q?OpwyteF6ARUlHQTT50cPUggM80gPUq1WeW6xrAUY5IBAXZaGMKNMI/UZN/GE?=
 =?us-ascii?Q?3e3/lHLvzR2C2r8LOSap90QVUb1SzyTlVMeshSSoX5e7mCNCaAPGhppRd4ng?=
 =?us-ascii?Q?SysGA7Op0JmR+QUUZjjljgwghJh/KBQ5r1qLDjBw1/MWmhimN6zfYvnh2udI?=
 =?us-ascii?Q?LhdGKS53n4XvWFq3HSMWjuw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a3c0a6-d67e-41f3-7b7a-08d9d4cc667b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 06:34:20.6796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t97/XwXZ9gm33e2zEiYDWAj3/WmseYalGwOlrVpXzHhPbr6lYFDsazpATvlX+2SGOMs5zCNP1GZcJYiKa29gSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

> -----Original Message-----
> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Monday, January 10, 2022 1:18 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; seanjc@google.com;
> wanpengli@tencent.com; vkuznets@redhat.com; Somdutta Roy
> <somduttar@nvidia.com>; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v2 0/3] KVM: x86: add per-vCPU exits disable
> capability
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Tue, Dec 21, 2021 at 01:04:46AM -0800, Kechen Lu wrote:
> > Summary
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Introduce support of vCPU-scoped ioctl with
> KVM_CAP_X86_DISABLE_EXITS
> > cap for disabling exits to enable finer-grained VM exits disabling on
> > per vCPU scales instead of whole guest. This patch series enabled the
> > vCPU-scoped exits control on HLT VM-exits.
> >
> > Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > In use cases like Windows guest running heavy CPU-bound workloads,
> > disabling HLT VM-exits could mitigate host sched ctx switch overhead.
> > Simply HLT disabling on all vCPUs could bring performance benefits,
> > but if no pCPUs reserved for host threads, could happened to the
> > forced preemption as host does not know the time to do the schedule
> > for other host threads want to run. With this patch, we could only
> > disable part of vCPUs HLT exits for one guest, this still keeps
> > performance benefits, and also shows resiliency to host stressing
> > workload running at the same time.
> >
> > Performance and Testing
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > In the host stressing workload experiment with Windows guest heavy
> > CPU-bound workloads, it shows good resiliency and having the ~3%
> > performance improvement. E.g. Passmark running in a Windows guest with
> > this patch disabling HLT exits on only half of vCPUs still showing
> > 2.4% higher main score v/s baseline.
> >
> > Tested everything on AMD machines.
> >
> >
> > v1->v2 (Sean Christopherson) :
> > - Add explicit restriction for VM-scoped exits disabling to be called
> >   before vCPUs creation (patch 1)
> > - Use vCPU ioctl instead of 64bit vCPU bitmask (patch 3), and make exit=
s
> >   disable flags check purely for vCPU instead of VM (patch 2)
>=20
> This is still quite blunt and assumes a ton of configuration on the host =
exactly
> matching the workload within guest. Which seems a waste since guests
> actually have the smarts to know what's happening within them.
>=20

For now we use fixed configuration on the host for our guests, it still=20
gives promising performance benefits on most workloads in our use case. But=
=20
yeah, it's not adaptive and flexible for workloads in guest.

> If you are going to allow guest to halt a vCPU, how about working on
> exposing mwait to guest cleanly instead?
> The idea is to expose this in ACPI - linux guests ignore ACPI and go by C=
PUID
> but windows guests follow ACPI. Linux can be patched ;)
>=20
> What we would have is a mirror of host ACPI states, such that lower state=
s
> invoke HLT and exit, higher power states invoke mwait and wait within gue=
st.
>=20
> The nice thing with this approach is that it's already supported by the h=
ost
> kernel, so it's just a question of coding up ACPI.
>=20

This idea looks really interesting! If we could achieve idling longer time(=
deeper power
State) causing HLT and exit, shorter time idle(higher power state) mwait in=
 guest,=20
through ACPI config, that's indeed a more adaptive and cleaner approach. Bu=
t especially
for Windows guest, its idle process execution and idle/sleep state switchin=
g logic seems
not well documented, need to figure out impacts on idle process and os PM b=
ehaviors=20
with the change.

But much thanks for this suggestion, I will try to explore it a bit,
and will get updates posted.=20

Thanks!

Best Regards,
Kechen

>=20
>=20
> >
> > Best Regards,
> > Kechen
> >
> > Kechen Lu (3):
> >   KVM: x86: only allow exits disable before vCPUs created
> >   KVM: x86: move ()_in_guest checking to vCPU scope
> >   KVM: x86: add vCPU ioctl for HLT exits disable capability
> >
> >  Documentation/virt/kvm/api.rst     |  4 +++-
> >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >  arch/x86/include/asm/kvm_host.h    |  7 +++++++
> >  arch/x86/kvm/cpuid.c               |  2 +-
> >  arch/x86/kvm/lapic.c               |  2 +-
> >  arch/x86/kvm/svm/svm.c             | 20 +++++++++++++++-----
> >  arch/x86/kvm/vmx/vmx.c             | 26 ++++++++++++++++++--------
> >  arch/x86/kvm/x86.c                 | 24 +++++++++++++++++++++++-
> >  arch/x86/kvm/x86.h                 | 16 ++++++++--------
> >  9 files changed, 77 insertions(+), 25 deletions(-)
> >
> > --
> > 2.30.2

