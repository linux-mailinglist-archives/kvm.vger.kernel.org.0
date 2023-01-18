Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2B067293E
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjARU0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjARU0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:26:18 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89495356B;
        Wed, 18 Jan 2023 12:26:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I89059P9j+eIDgmAe05/jSWz62RiHx3/Jfk1brOXfwblfFCEr38vMM+XcK8EZ6/VLHe1DQDPXMtbzHr+k3KmUm4WIHoLMzLGMkJNr9FHDaM1LDmQjX4N3oahMaw166sG5hykfRNa77OBj/UaPP7C5B1E3LTvfqxiljCgi3DEge0QoWMdqwvzP5T2Svw810kNVt5OSEJijE6K350zJFeZbHsYq6egakyTnioQF0yUDa0e1x3r26gSRkU7LJv5TvNvJJD3+pPG3n7A9aDjS4i6ELs0DmFv8Fv0sPll6mkBwjVP0Gi5opbWr125zGahFWkeJbWmCXjBVExWDJaEir4/Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KIBLoUyNDXmjcnEoTLE217NKzxnhA455UYRr9y3HyKo=;
 b=U5dkxpxpdbw9t5NznPB68FXZ8fsjWmkvv3WG6o1CHByTkMGfwgsxXkC2f93F7VInKovQf/X2qdpjk5gmQibWX45dAjG2t6GbeCLJnVqq2nTs/V6lyNKaYO9lonbV7j6zdPFAMCLrGjhSvEwGeICwhB978Cs4P4ZDhrYfhzxBKIlPyKz7z4wTPbYmZHIRfE7ExQb2xqGBga9PM8LvDURb5Kz6S+UqZDwCMxfQ9PsUwW6nsSasNuIaYAT/c8MXON1/zwQir4UrOCAM8jRIl99tTfCxFz/gDuiHZeB3ovvPfvwGB92ZuBL0C2x5aezx+Y6Op431UE0LiZ9Xxf/cjcIbUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KIBLoUyNDXmjcnEoTLE217NKzxnhA455UYRr9y3HyKo=;
 b=q1PumYjQXaINWHyKlCw/PqGqWuAaP1XFZnlVV7+KqM5bYpA6PJ7pGoEgishb6nBa7jGQIfZC01jsLNE31Bs0jUGCnhk8uZh/KHR9gsKBr0v1w1V71Wj1BPfYTYXDHIeUSdJ2pgVTeAFATIk9hF/GlyGJo589vVfS70l3KiYqijaygJsoH3tqNQYzxQ6qk6hdHKue8MOj/T/RekELgztjyl/0cjAWZyqtsCp7E/0PTGCMZYPIVNbESDnwcuC1rayYdjy5hWUGcjhHNo9qoumUjzwUOMY7j58K6q6zIrFD3WiREh53bMtle8KfVNKs+w1ctFqoXRwBxkCgZmx2HveIVw==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 20:26:13 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc%6]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 20:26:13 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "shaoqin.huang@intel.com" <shaoqin.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v5 6/6] KVM: selftests: Add tests for VM and vCPU cap
 KVM_CAP_X86_DISABLE_EXITS
Thread-Topic: [RFC PATCH v5 6/6] KVM: selftests: Add tests for VM and vCPU cap
 KVM_CAP_X86_DISABLE_EXITS
Thread-Index: AQHZJ5q1werIUgMg80mzKZ0DusmlJ66koI2AgAADxDA=
Date:   Wed, 18 Jan 2023 20:26:13 +0000
Message-ID: <DM6PR12MB35000711B782BE4801651776CAC79@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20230113220114.2437-1-kechenl@nvidia.com>
        <20230113220114.2437-7-kechenl@nvidia.com>
 <20230118220307.0000256c@gmail.com>
In-Reply-To: <20230118220307.0000256c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3500:EE_|SN7PR12MB6689:EE_
x-ms-office365-filtering-correlation-id: 79c42931-2032-4128-e812-08daf9923e7b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sE2qV1lc86qaYBd8YtfKKXtQ3gZrvMNd5dHCRzFn31P793BVjw97VtKsl0C11MWEa9q3c2nXxzTUzgqeLPVe0/P6naQvKWn02F+dgGi5M/SF8KTShDoFExUo4rX1tJy5fmmvGGykkzq19Wqf7FTkYOrzpP8RG05Jq8BebHYVKzgm28fsmjSc6oewAKjF+mKLDzM4Z1zxUWa818IEw9WkK66A0wBbY6V9kCqbKjhuYJx4k+mqmEWuDw9K/FNxFUhm45gSAHTyh8lzc3ElMK/SKfXsnokDT1sxbIU/owu6ZXDeHBNwR4phoBafoGbVlo6b2A1P507wgyZeEio3ogJAlzpX1IJICI3pGJ6xnxVAtAWmNM2WaFwXEHxjfW85uH6r3lcCbXtrqV+wVfbgl+Qe5vUQf+gs4R0xQYAeOtKSU63h0abRCEOz9/N7yl/1BhjxMbz1ICZz9r7MOVBLLGwff6+jNGHHvaZ5932hgx89FudxVcYYFHSMtkHicx85wOteZu4sJp+VSbuURP+LkicOZ3jJ7+t0zTE5O+s/xhIi+8AYpTaE/HsaB4zH0ik4a2zDFgSAeOZiAX5nZ74oC1Qf3qKo6P5rL28xoqI/m+thqwFXqBhoM05rOPfCeBmqfLQLde0cJSJIazIfU1KN439/kvxZcHA8rgZIgGR2OaSKWKBHFmYiSzXnB5nMuxDPEsABV/4gZCg9KG3JTb+DZjXkgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199015)(83380400001)(38100700002)(64756008)(122000001)(33656002)(38070700005)(8936002)(86362001)(30864003)(8676002)(52536014)(2906002)(55016003)(5660300002)(66476007)(4326008)(6916009)(76116006)(66446008)(66946007)(66556008)(41300700001)(9686003)(6506007)(186003)(53546011)(26005)(54906003)(478600001)(316002)(71200400001)(7696005)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b445uCXfy/M1OUtR/K4i3595kVRkTCGaApvcfIKp+QPIR9Sb7pTHs6jcG++5?=
 =?us-ascii?Q?i0g7W79WL5uuVFlv7iMMK7/i9SbsoD2HDOGWHyqpWjF0DRnuQNTmY0NqHE9x?=
 =?us-ascii?Q?5cQoRaBElKJscLJmR+vcjqz3FHP4vBHhZ1jRpYNPsSElXqKU4/6nGVGnFHwb?=
 =?us-ascii?Q?QQt3fVg+Twd1TVYPo0sDcG0jPz/pVhV9iIHrQlQ/vbayuXrGDlATQuS4Zp4J?=
 =?us-ascii?Q?0d2WWbD5CeTkd7wyf650mkNDm2Oj3ewwflBlSN9QrEqBfrn65Bke5aLqu7zA?=
 =?us-ascii?Q?gYSG+cPPzq6a8Mk1saPytV8/eWDZ4Subhyh92hd0lyc8uwDW/LclwQpy3Flw?=
 =?us-ascii?Q?G2W2xG1XCngcV86rMmygeIkxx/iJ78NrcH1/Zm+cRf1ayvU/W0QRg483m1Oh?=
 =?us-ascii?Q?tqD97aMg3ZK+FTud2qKB2GYz2CxOkufqbqY4FqE+vQn/I5/IbxWOw7UhLMXM?=
 =?us-ascii?Q?zLDjO2rg1GcrraXK7N5IhAhMAORaTsKwpA08OPyKRBv51mTXJKsm3vu53Vml?=
 =?us-ascii?Q?sgUOiv2aniOlQGPoSBbzXJWrl27/Nwfv6uQvKAV8bMpnHkdALY/vSs0fyutC?=
 =?us-ascii?Q?GojzgTH3sT3xuqish+gvsc74mLPG+PHZ4nf6Ctdkj5Mlwwpm65/OxdqKC3NK?=
 =?us-ascii?Q?vn4r+Uc5ofd6i4K0POA+mmfQRNfx/racFIO8fkoWSkE8ipcQLB07jSztUsyl?=
 =?us-ascii?Q?/dtUsfNbh8oqTfB5CwSN2DX9znHKcS3Vmsz0z7naaopVwX3gVVYN9WyjF7Kj?=
 =?us-ascii?Q?DEL76zQA1GJj+AOhTtgat7LrpoF7yiiDrgFxeDZkzIngzatRjORBDJFfEI53?=
 =?us-ascii?Q?y+t0nU5SbS8NbJ89xyRanoSfcCa4BTNArb+jpnfZfZo7XwH6nK97NXwBWE2s?=
 =?us-ascii?Q?+4AUBE9KijonkfXahlpdH4S7EJ/P1UyCQWVa91WZj5KttnDsoI7iNkEOVdBo?=
 =?us-ascii?Q?iQ4gTyevjGJW/yRMSTx8rvKsTmU4aSUCW8OyzFkS1ozF8u2h/VRxVInjuiYP?=
 =?us-ascii?Q?Pa1lie7mJmuNF0KMH3Fjvlp85KKSpoMIhOAT9rmiyWDEtwvJoUaZpe3jww/1?=
 =?us-ascii?Q?ULo7K13hqF5HwllQA/ejT9EsJgPaTPssUpfQgYX6N3cL7M2heV6RWgdnx2Jx?=
 =?us-ascii?Q?sBL2/ueprUTYkny9aY+QPNN6cfeW6kLgvZmBGTiTh0wzUOj2tvty2MHh0Fcz?=
 =?us-ascii?Q?Lq4EToD6xCfnHcIFV7HS47wtSYQFFDd4G2lOXymkgRo3uHIxhzl6ECD0vsp2?=
 =?us-ascii?Q?wwGkCABBB3BTqgk9OSdydEPr3vbvLbasxVbcY4qFa//UZx3puyXFfTXp6+x2?=
 =?us-ascii?Q?kO6PRCVqXMTn7UsdbsHZvHouLTwWn385kpeWByF7R48/qUDjbV87Y133n8Er?=
 =?us-ascii?Q?F3ZOWzJFpYaaYdEzwWqscXnLyyfUFOiGV3Ftzac2rrn5mJYmuZeFn1QWJdLV?=
 =?us-ascii?Q?R3ScCLnbRT48Cs/Z/JBpqPUD7uQHtGXksIKLtcTcnFPFb9XpokGMOVNah+/G?=
 =?us-ascii?Q?MAGaqvWN2Z7vLJQWjRFZzJToMzQNxUXtGCt7w4jnsMaz1fbnU2tcrVgAvNie?=
 =?us-ascii?Q?as0OJvwXTsfPCp9amCMaUwGYW0ZmjB868yg8GAqM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79c42931-2032-4128-e812-08daf9923e7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 20:26:13.4883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qgk1KRYlVJrYWJeXb3OQl3jPmPLLdz7TkTU0cn5zHHSM6CSHCQ/F24or6UtXh3kA5HbVYCZGmGPC4Y/Jh4+JwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhi,

Thanks for testing the patch series. Comments below.

> -----Original Message-----
> From: Zhi Wang <zhi.wang.linux@gmail.com>
> Sent: Wednesday, January 18, 2023 12:03 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; seanjc@google.com; pbonzini@redhat.com;
> chao.gao@intel.com; shaoqin.huang@intel.com; vkuznets@redhat.com;
> linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v5 6/6] KVM: selftests: Add tests for VM and vCPU
> cap KVM_CAP_X86_DISABLE_EXITS
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Fri, 13 Jan 2023 22:01:14 +0000
> Kechen Lu <kechenl@nvidia.com> wrote:
>=20
> I think I figure out why this test case doesn't work:
>=20
> The 2nd case always hangs because:
>=20
> 1) Unlike the 1st case in which a halter and an IPI sender will be create=
d,
> there is only halter thread created in the 2nd case.
> 2) The halter enables KVM_X86_DISABLE_EXITS_HLT. Thus, HLT will not cause
> VMEXIT
> 3) The halter stuck in the halter_waiting_guest_code(). data->hlt_count i=
s
> always 1 and data->wake_count is always 0.
> 4) In the main thread, you have test_vm_disable_exits_cap() ->
>                          while (data->hlt_count < COUNT_HLT_EXITS);
>=20
> As data->hlt_count will never increase in the vcpu_thread, the main threa=
d
> always stuck in the while loop.
>=20
> Can you explain more about your thoughts of designing this test case?

For this test case, we want to test for the VM-scoped KVM_CAP_X86_DISABLE_E=
XITS cap flags setting.=20
So if we set KVM_X86_DISABLE_EXITS_HLT, there would be no halt vmexits, and=
 what expect
is the HLT instructions looping executed within guest halter vCPU thread, a=
nd not stuck here, no IPIs
required to wake it up.

Here is what I got for this test case running in an AMD machine.
-------------------------------------
Halter vCPU thread started
vCPU thread running vCPU 0
Halter vCPU had 0 HLT exits
Guest records 10 HLTs executed
-------------------------------------

BR,
Kechen

>=20
> > Add selftests for KVM cap KVM_CAP_X86_DISABLE_EXITS overriding flags
> > in VM and vCPU scope both works as expected.
> >
> > Suggested-by: Chao Gao <chao.gao@intel.com>
> > Suggested-by: Shaoqin Huang <shaoqin.huang@intel.com>
> > Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/x86_64/disable_exits_test.c | 457
> > ++++++++++++++++++
> >  2 files changed, 458 insertions(+)
> >  create mode 100644
> > tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile
> > b/tools/testing/selftests/kvm/Makefile
> > index 1750f91dd936..eeeba35e2536 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -114,6 +114,7 @@ TEST_GEN_PROGS_x86_64 +=3D
> x86_64/sev_migrate_tests
> >  TEST_GEN_PROGS_x86_64 +=3D x86_64/amx_test
> >  TEST_GEN_PROGS_x86_64 +=3D x86_64/max_vcpuid_cap_test
> >  TEST_GEN_PROGS_x86_64 +=3D x86_64/triple_fault_event_test
> > +TEST_GEN_PROGS_x86_64 +=3D x86_64/disable_exits_test
> >  TEST_GEN_PROGS_x86_64 +=3D access_tracking_perf_test
> >  TEST_GEN_PROGS_x86_64 +=3D demand_paging_test
> >  TEST_GEN_PROGS_x86_64 +=3D dirty_log_test diff --git
> > a/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> > b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> > new file mode 100644
> > index 000000000000..dceba3bcef5f
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> > @@ -0,0 +1,457 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Test per-VM and per-vCPU disable exits cap
> > + * 1) Per-VM scope
> > + * 2) Per-vCPU scope
> > + *
> > + */
> > +
> > +#define _GNU_SOURCE /* for program_invocation_short_name */
> #include
> > +<pthread.h> #include <inttypes.h> #include <string.h> #include
> > +<time.h> #include <sys/ioctl.h>
> > +
> > +#include "test_util.h"
> > +#include "kvm_util.h"
> > +#include "svm_util.h"
> > +#include "vmx.h"
> > +#include "processor.h"
> > +#include "asm/kvm.h"
> > +#include "linux/kvm.h"
> > +
> > +/* Arbitary chosen IPI vector value from sender to halter vCPU */
> > +#define IPI_VECTOR    0xa5
> > +/* Number of HLTs halter vCPU thread executes */
> > +#define COUNT_HLT_EXITS       10
> > +
> > +struct guest_stats {
> > +     uint32_t halter_apic_id;
> > +     volatile uint64_t hlt_count;
> > +     volatile uint64_t wake_count;
> > +};
> > +
> > +static u64 read_vcpu_stats_halt_exits(struct kvm_vcpu *vcpu) {
> > +     int i;
> > +     struct kvm_stats_header header;
> > +     u64 *stats_data;
> > +     u64 ret =3D 0;
> > +     struct kvm_stats_desc *stats_desc;
> > +     struct kvm_stats_desc *pdesc;
> > +     int stats_fd =3D vcpu_get_stats_fd(vcpu);
> > +
> > +     read_stats_header(stats_fd, &header);
> > +     if (header.num_desc =3D=3D 0) {
> > +             fprintf(stderr,
> > +                     "Cannot read halt exits since no KVM stats define=
d\n");
> > +             return ret;
> > +     }
> > +
> > +     stats_desc =3D read_stats_descriptors(stats_fd, &header);
> > +     for (i =3D 0; i < header.num_desc; ++i) {
> > +             pdesc =3D get_stats_descriptor(stats_desc, i, &header);
> > +             if (!strncmp(pdesc->name, "halt_exits", 10)) {
> > +                     stats_data =3D malloc(pdesc->size * sizeof(*stats=
_data));
> > +                     read_stat_data(stats_fd, &header, pdesc, stats_da=
ta,
> > +                             pdesc->size);
> > +                     ret =3D *stats_data;
> > +                     free(stats_data);
> > +                     break;
> > +             }
> > +     }
> > +     free(stats_desc);
> > +     return ret;
> > +}
> > +
> > +/* HLT multiple times in one vCPU */
> > +static void halter_guest_code(struct guest_stats *data) {
> > +     xapic_enable();
> > +     data->halter_apic_id =3D
> > +GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
> > +
> > +     for (;;) {
> > +             data->hlt_count++;
> > +             asm volatile("sti; hlt; cli");
> > +             data->wake_count++;
> > +     }
> > +}
> > +
> > +static void halter_waiting_guest_code(struct guest_stats *data) {
> > +     uint64_t tsc_start =3D rdtsc();
> > +
> > +     xapic_enable();
> > +     data->halter_apic_id =3D
> > + GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
> > +
> > +     for (;;) {
> > +             data->hlt_count++;
> > +             asm volatile("sti; hlt; cli");
> > +             data->wake_count++;
> > +             /* Wait for ~0.5sec for each HLT execution */
> > +             tsc_start =3D rdtsc();
> > +             while (rdtsc() - tsc_start < 2000000000);
> > +     }
> > +}
> > +
> > +/* Runs on halter vCPU when IPI arrives */ static void
> > +guest_ipi_handler(struct ex_regs *regs) {
> > +     xapic_write_reg(APIC_EOI, 11);
> > +}
> > +
> > +/* Sender vCPU waits for ~1sec to assume HLT executed */ static void
> > +sender_wait_loop(struct guest_stats *data, uint64_t old_hlt_count,
> > +             uint64_t old_wake_count) {
> > +     uint64_t tsc_start =3D rdtsc();
> > +     while (rdtsc() - tsc_start < 4000000000);
> > +     GUEST_ASSERT((data->wake_count !=3D old_wake_count) &&
> > +                     (data->hlt_count !=3D old_hlt_count)); }
> > +
> > +/* Sender vCPU loops sending IPI to halter vCPU every ~1sec */ static
> > +void sender_guest_code(struct guest_stats *data) {
> > +     uint32_t icr_val;
> > +     uint32_t icr2_val;
> > +     uint64_t old_hlt_count =3D 0;
> > +     uint64_t old_wake_count =3D 0;
> > +
> > +     xapic_enable();
> > +     /* Init interrupt command register for sending IPIs */
> > +     icr_val =3D (APIC_DEST_PHYSICAL | APIC_DM_FIXED | IPI_VECTOR);
> > +     icr2_val =3D SET_APIC_DEST_FIELD(data->halter_apic_id);
> > +
> > +     for (;;) {
> > +             /*
> > +              * Send IPI to halted vCPU
> > +              * First IPI sends here as already waited before sender v=
CPU
> > +              * thread creation
> > +              */
> > +             xapic_write_reg(APIC_ICR2, icr2_val);
> > +             xapic_write_reg(APIC_ICR, icr_val);
> > +             sender_wait_loop(data, old_hlt_count, old_wake_count);
> > +             GUEST_ASSERT((data->wake_count !=3D old_wake_count) &&
> > +                     (data->hlt_count !=3D old_hlt_count));
> > +             old_wake_count =3D data->wake_count;
> > +             old_hlt_count =3D data->hlt_count;
> > +     }
> > +}
> > +
> > +static void *vcpu_thread(void *arg)
> > +{
> > +     struct kvm_vcpu *vcpu =3D (struct kvm_vcpu *)arg;
> > +     int old;
> > +     int r;
> > +
> > +     r =3D pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS,
> &old);
> > +     TEST_ASSERT(r =3D=3D 0,
> > +             "pthread_setcanceltype failed on vcpu_id=3D%u with errno=
=3D%d",
> > +             vcpu->id, r);
> > +     fprintf(stderr, "vCPU thread running vCPU %u\n", vcpu->id);
> > +     vcpu_run(vcpu);
> > +     return NULL;
> > +}
> > +
> > +static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu
> > +*vcpu) {
> > +     void *retval;
> > +     int r;
> > +
> > +     r =3D pthread_cancel(thread);
> > +     TEST_ASSERT(r =3D=3D 0,
> > +             "pthread_cancel on vcpu_id=3D%d failed with errno=3D%d",
> > +             vcpu->id, r);
> > +
> > +     r =3D pthread_join(thread, &retval);
> > +     TEST_ASSERT(r =3D=3D 0,
> > +             "pthread_join on vcpu_id=3D%d failed with errno=3D%d",
> > +             vcpu->id, r);
> > +}
> > +
> > +/*
> > + * Test case 1:
> > + * Normal VM running with one vCPU keeps executing HLTs,
> > + * another vCPU sending IPIs to wake it up, should expect
> > + * all HLTs exiting to host
> > + */
> > +static void test_vm_without_disable_exits_cap(void)
> > +{
> > +     int r;
> > +     int wait_secs;
> > +     const int first_halter_wait =3D 10;
> > +     uint64_t kvm_halt_exits;
> > +     struct kvm_vm *vm;
> > +     struct kvm_vcpu *halter_vcpu;
> > +     struct kvm_vcpu *sender_vcpu;
> > +     struct guest_stats *data;
> > +     vm_vaddr_t guest_stats_page_vaddr;
> > +     pthread_t threads[2];
> > +
> > +     /* Create VM */
> > +     vm =3D vm_create(2);
> > +
> > +     /* Add vCPU with loops halting */
> > +     halter_vcpu =3D vm_vcpu_add(vm, 0, halter_guest_code);
> > +
> > +     vm_init_descriptor_tables(vm);
> > +     vcpu_init_descriptor_tables(halter_vcpu);
> > +     vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
> > +     virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> > +
> > +     /* Add vCPU with IPIs waking up halter vCPU */
> > +     sender_vcpu =3D vm_vcpu_add(vm, 1, sender_guest_code);
> > +
> > +     guest_stats_page_vaddr =3D vm_vaddr_alloc_page(vm);
> > +     data =3D addr_gva2hva(vm, guest_stats_page_vaddr);
> > +     memset(data, 0, sizeof(*data));
> > +
> > +     vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
> > +     vcpu_args_set(sender_vcpu, 1, guest_stats_page_vaddr);
> > +
> > +     /* Start halter vCPU thread and wait for it to execute first HLT.=
 */
> > +     r =3D pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu)=
;
> > +     TEST_ASSERT(r =3D=3D 0,
> > +             "pthread_create halter failed errno=3D%d", errno);
> > +     fprintf(stderr, "Halter vCPU thread started\n");
> > +
> > +     wait_secs =3D 0;
> > +     while ((wait_secs < first_halter_wait) && !data->hlt_count) {
> > +             sleep(1);
> > +             wait_secs++;
> > +     }
> > +     TEST_ASSERT(data->hlt_count,
> > +             "Halter vCPU did not execute first HLT within %d seconds"=
,
> > +             first_halter_wait);
> > +     fprintf(stderr,
> > +             "Halter vCPU thread reported its first HLT executed "
> > +             "after %d seconds.\n",
> > +             wait_secs);
> > +
> > +     /*
> > +      * After guest halter vCPU executed first HLT, start the sender
> > +      * vCPU thread to wakeup halter vCPU
> > +      */
> > +     r =3D pthread_create(&threads[1], NULL, vcpu_thread, sender_vcpu)=
;
> > +     TEST_ASSERT(r =3D=3D 0, "pthread_create sender failed errno=3D%d"=
,
> > + errno);
> > +
> > +     while (data->hlt_count < COUNT_HLT_EXITS);
> > +
> > +     cancel_join_vcpu_thread(threads[0], halter_vcpu);
> > +     cancel_join_vcpu_thread(threads[1], sender_vcpu);
> > +
> > +     kvm_halt_exits =3D read_vcpu_stats_halt_exits(halter_vcpu);
> > +     TEST_ASSERT(kvm_halt_exits =3D=3D data->hlt_count,
> > +             "Halter vCPU had unmatched %lu halt exits - %lu HLTs "
> > +             "executed, when not disabling VM halt exits\n",
> > +             kvm_halt_exits, data->hlt_count);
> > +     fprintf(stderr, "Halter vCPU had %lu halt exits\n",
> > +             kvm_halt_exits);
> > +     fprintf(stderr, "Guest records %lu HLTs executed, "
> > +             "waked %lu times\n",
> > +             data->hlt_count, data->wake_count);
> > +
> > +     kvm_vm_free(vm);
> > +}
> > +
> > +/*
> > + * Test case 2:
> > + * VM scoped exits disabling, HLT instructions
> > + * stay inside guest without exits
> > + */
> > +static void test_vm_disable_exits_cap(void) {
> > +     int r;
> > +     uint64_t kvm_halt_exits;
> > +     struct kvm_vm *vm;
> > +     struct kvm_vcpu *halter_vcpu;
> > +     struct guest_stats *data;
> > +     vm_vaddr_t guest_stats_page_vaddr;
> > +     pthread_t halter_thread;
> > +
> > +     /* Create VM */
> > +     vm =3D vm_create(1);
> > +
> > +     /*
> > +      * Before adding any vCPUs, enable the KVM_X86_DISABLE_EXITS cap
> > +      * with flag KVM_X86_DISABLE_EXITS_HLT
> > +      */
> > +     vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
> > +             KVM_X86_DISABLE_EXITS_HLT);
> > +
> > +     /* Add vCPU with loops halting */
> > +     halter_vcpu =3D vm_vcpu_add(vm, 0, halter_waiting_guest_code);
> > +
> > +     vm_init_descriptor_tables(vm);
> > +     vcpu_init_descriptor_tables(halter_vcpu);
> > +     vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
> > +     virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> > +
> > +     guest_stats_page_vaddr =3D vm_vaddr_alloc_page(vm);
> > +     data =3D addr_gva2hva(vm, guest_stats_page_vaddr);
> > +     memset(data, 0, sizeof(*data));
> > +     vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
> > +
> > +     /* Start halter vCPU thread and execute HLTs immediately */
> > +     r =3D pthread_create(&halter_thread, NULL, vcpu_thread, halter_vc=
pu);
> > +     TEST_ASSERT(r =3D=3D 0,
> > +             "pthread_create halter failed errno=3D%d", errno);
> > +     fprintf(stderr, "Halter vCPU thread started\n");
> > +
> > +     while (data->hlt_count < COUNT_HLT_EXITS);
> > +
> > +     cancel_join_vcpu_thread(halter_thread, halter_vcpu);
> > +
> > +     kvm_halt_exits =3D read_vcpu_stats_halt_exits(halter_vcpu);
> > +     TEST_ASSERT(kvm_halt_exits =3D=3D 0,
> > +             "Halter vCPU had unexpected halt exits occuring after "
> > +             "disabling VM-scoped halt exits cap\n");
> > +     fprintf(stderr, "Halter vCPU had %lu HLT exits\n",
> > +             kvm_halt_exits);
> > +     fprintf(stderr, "Guest records %lu HLTs executed\n",
> > +             data->hlt_count);
> > +
> > +     kvm_vm_free(vm);
> > +}
> > +
> > +/*
> > + * Test case 3:
> > + * VM overrides exits disable flags after vCPU created,
> > + * which is not allowed
> > + */
> > +static void test_vm_disable_exits_cap_with_vcpu_created(void)
> > +{
> > +     int r;
> > +     struct kvm_vm *vm;
> > +     struct kvm_enable_cap cap =3D {
> > +             .cap =3D KVM_CAP_X86_DISABLE_EXITS,
> > +             .args[0] =3D KVM_X86_DISABLE_EXITS_HLT |
> KVM_X86_DISABLE_EXITS_OVERRIDE,
> > +     };
> > +
> > +     /* Create VM */
> > +     vm =3D vm_create(1);
> > +     /* Add vCPU with loops halting */
> > +     vm_vcpu_add(vm, 0, halter_waiting_guest_code);
> > +
> > +     /*
> > +      * After creating vCPU, the current VM-scoped ABI should
> > +      * discard the cap enable of KVM_CAP_X86_DISABLE_EXITS
> > +      * and return non-zero. Since vm_enabled_cap() not able
> > +      * to assert the return value, so use the __vm_ioctl()
> > +      */
> > +     r =3D __vm_ioctl(vm, KVM_ENABLE_CAP, &cap);
> > +
> > +     TEST_ASSERT(r !=3D 0,
> > +             "Setting VM-scoped KVM_CAP_X86_DISABLE_EXITS after "
> > +             "vCPUs created is not allowed, but it succeeds here\n");
> > +}
> > +
> > +/*
> > + * Test case 4:
> > + * vCPU scoped halt exits disabling and enabling tests,
> > + * verify overides are working after vCPU created  */ static void
> > +test_vcpu_toggling_disable_exits_cap(void)
> > +{
> > +     int r;
> > +     uint64_t kvm_halt_exits;
> > +     struct kvm_vm *vm;
> > +     struct kvm_vcpu *halter_vcpu;
> > +     struct kvm_vcpu *sender_vcpu;
> > +     struct guest_stats *data;
> > +     vm_vaddr_t guest_stats_page_vaddr;
> > +     pthread_t threads[2];
> > +
> > +     /* Create VM */
> > +     vm =3D vm_create(2);
> > +
> > +     /* Add vCPU with loops halting */
> > +     halter_vcpu =3D vm_vcpu_add(vm, 0, halter_waiting_guest_code);
> > +     /* Set KVM_CAP_X86_DISABLE_EXITS_HLT for halter vCPU */
> > +     vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
> > +             KVM_X86_DISABLE_EXITS_HLT |
> > + KVM_X86_DISABLE_EXITS_OVERRIDE);
> > +
> > +     vm_init_descriptor_tables(vm);
> > +     vcpu_init_descriptor_tables(halter_vcpu);
> > +     vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
> > +
> > +     virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> > +
> > +     /* Add vCPU with IPIs waking up halter vCPU */
> > +     sender_vcpu =3D vm_vcpu_add(vm, 1, sender_guest_code);
> > +
> > +     guest_stats_page_vaddr =3D vm_vaddr_alloc_page(vm);
> > +     data =3D addr_gva2hva(vm, guest_stats_page_vaddr);
> > +     memset(data, 0, sizeof(*data));
> > +
> > +     vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
> > +     vcpu_args_set(sender_vcpu, 1, guest_stats_page_vaddr);
> > +
> > +     r =3D pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu)=
;
> > +     TEST_ASSERT(r =3D=3D 0,
> > +             "pthread_create halter failed errno=3D%d", errno);
> > +     fprintf(stderr, "Halter vCPU thread started with halt exits"
> > +             "disabled\n");
> > +
> > +     /*
> > +      * For the first phase of the running, halt exits
> > +      * are disabled, halter vCPU executes HLT instruction
> > +      * but never exits to host
> > +      */
> > +     while (data->hlt_count < (COUNT_HLT_EXITS / 2));
> > +
> > +     cancel_join_vcpu_thread(threads[0], halter_vcpu);
> > +     /*
> > +      * Override and clean KVM_CAP_X86_DISABLE_EXITS flags
> > +      * for halter vCPU. Expect to see halt exits occurs then.
> > +      */
> > +     vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
> > +             KVM_X86_DISABLE_EXITS_OVERRIDE);
> > +
> > +     r =3D pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu)=
;
> > +     TEST_ASSERT(r =3D=3D 0,
> > +             "pthread_create halter failed errno=3D%d", errno);
> > +     fprintf(stderr, "Halter vCPU thread restarted and cleared "
> > +             "halt exits flag\n");
> > +
> > +     sleep(1);
> > +     /*
> > +      * Second phase of the test, after guest halter vCPU
> > +      * reenabled halt exits, start the sender
> > +      * vCPU thread to wakeup halter vCPU
> > +      */
> > +     r =3D pthread_create(&threads[1], NULL, vcpu_thread, sender_vcpu)=
;
> > +     TEST_ASSERT(r =3D=3D 0, "pthread_create sender failed errno=3D%d"=
,
> > + errno);
> > +
> > +     while (data->hlt_count < COUNT_HLT_EXITS);
> > +
> > +     cancel_join_vcpu_thread(threads[0], halter_vcpu);
> > +     cancel_join_vcpu_thread(threads[1], sender_vcpu);
> > +
> > +     kvm_halt_exits =3D read_vcpu_stats_halt_exits(halter_vcpu);
> > +     TEST_ASSERT(kvm_halt_exits =3D=3D (COUNT_HLT_EXITS / 2),
> > +             "Halter vCPU had unexpected %lu halt exits, "
> > +             "there should be %d halt exits while "
> > +             "not disabling VM halt exits\n",
> > +             kvm_halt_exits, COUNT_HLT_EXITS / 2);
> > +     fprintf(stderr, "Halter vCPU had %lu halt exits\n",
> > +             kvm_halt_exits);
> > +     fprintf(stderr, "Guest records %lu HLTs executed, "
> > +             "waked %lu times\n",
> > +             data->hlt_count, data->wake_count);
> > +
> > +     kvm_vm_free(vm);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     fprintf(stderr, "VM-scoped tests start\n");
> > +     test_vm_without_disable_exits_cap();
> > +     test_vm_disable_exits_cap();
> > +     test_vm_disable_exits_cap_with_vcpu_created();
> > +     fprintf(stderr, "vCPU-scoped test starts\n");
> > +     test_vcpu_toggling_disable_exits_cap();
> > +     return 0;
> > +}

