Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125A8672999
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjARUnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjARUn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:43:29 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2505F3B5;
        Wed, 18 Jan 2023 12:43:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8Bx480AugDPhWmkNRF4l7bBiQUEBUlTF5cEDpqIAHNM3JhdYtqwqkqOXxKPV1iXP1g+Es+Ot650dDBOXFhh8hR1PtVlxPn/TgjLRE5pcwQkZHRSfdrA2WqiDBsxrDkizJwsOQNjOs0wBedAmQL+PT1CtE0AdHSv3Yl98SerV68m62UCvYVMcO7lwut3wY3nfYHAlezDcat6/3zr0UXntSMXOVHbpC165s77DrwZHw5zpzojoCN9BllwM2FmNH4+ow8+AaOxnI/BEnnfPF2ucyXESRw/512gnKcRHaExswFz1pyelIRmzjSxwEOznuqD8aGFn4OM1b9rqmFsRTeiUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/f0E0JO/8r9Y7GtZ0f4chlUYRl/FMvCTA3mULSRnzk=;
 b=LfnJmeYNq/uBQubr2K8ZKOJc6GXBdUfnlInnsyUCpkCRBzCYKVcv8bJiyeG7nPZF/AVAsKE1vAgFuyDnGV3HiImG5DMLd2UrIrn9x0LwUSIyjPiTLRqOJRxBjBMoPdqKgWdIRgzL/TmUJ2xil7LXhEHkSp7Uq8MTJ9XFmCSFvC0x4evWe/y5JuFCckRlhdTw/DHXJXJgZOWY0ClMzSWTJdd19lSTEFt/CoXhGYlqg4pO5m9zRTf28ijQUsD5WhuVkx8AMaVLlrM8gc8kk+ibjeYkCf6yMzdzsQCDw0lvLFcp50cCahCDc4ROdDKIHXMt9tOdsSP59QuNKi0UqMWZPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/f0E0JO/8r9Y7GtZ0f4chlUYRl/FMvCTA3mULSRnzk=;
 b=aDjqiQ4rIetk1fmF+oUtEORMbiaYYDo6LHd4ZAXgzXIwwC50fKpyAGfLmCtKoy/th4MZF3HCDUvSNLQY9O8sHb2B57Ahoju/LrFdtDGZC10hFNhRF/ubNECAMkdWtjC7kYw7a5GzZUt3oj5Zsi/CL8FCdoaE8SHInAp363h/+GP5508/h3WJgRSf1YP2YkiqhHfeB/SAxNkhPCpnTWDV6Re3evwhcT0SFYE1RIBPsYIZSUkeSBbaQyPxDxsW0b/yRPrawKdiqv3sYVDRoT2fr25BrmLye4NeqbAOjcD6/F6W1KyF2jP6xr7uDSaUG8iajCgnEHoBSoL/qmWMRtLJ1Q==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by MW4PR12MB6754.namprd12.prod.outlook.com (2603:10b6:303:1eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 20:43:25 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc%6]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 20:43:25 +0000
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
Thread-Index: AQHZJ5q1werIUgMg80mzKZ0DusmlJ66koI2AgAADxDCAAAas8A==
Date:   Wed, 18 Jan 2023 20:43:25 +0000
Message-ID: <DM6PR12MB35003D9BFCEE098C76AB88BBCAC79@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20230113220114.2437-1-kechenl@nvidia.com>
        <20230113220114.2437-7-kechenl@nvidia.com>
 <20230118220307.0000256c@gmail.com>
 <DM6PR12MB35000711B782BE4801651776CAC79@DM6PR12MB3500.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB35000711B782BE4801651776CAC79@DM6PR12MB3500.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3500:EE_|MW4PR12MB6754:EE_
x-ms-office365-filtering-correlation-id: 5d32a403-d880-461d-8eaf-08daf994a5a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 85NR7K7Y+bgpidcK5KoXKczIqZcimNoDLqdBx1hIL0ZeT1E7txkq64GwNnHoe/uaFRk7x6lf5paC+dzJFh7sV7uyipRbmjINHhUvRjnbbIlwGF1fRmraSZSXPv8CY7au5Oi2Q6PJMntsYwrijE1E6TbBEoVQpRN4jvaJm3ZS4P4zxrxuOfcifXX4w8iz3esZ4O98/u5D548QdwwFhY8gWlghacYDWMazzZQMjIoKI8CWPuph/ffzlC4ltLMCBYvPsyph1/Y4pyiHk3oOXtrF2qzjGerO5ZBRv8qqDV7hmPNx6d1hewm/J2HB6gELsPs0huvxhBYXQRXDMdw5h4ZRQ6rSRM5MwaZiOFb6TPMBvxZA54Blx/1CSLgIOBIqi2dr0Jd+30nCEUaYPSIeBaOFDIts5PLjKuD0rNwe505ASyp2Lyd0DW91kX/mYlE+85ybDb2OOZrfxf191OqsIt31xA6IqS4QoIpy6CqzuF569S70eQ7c9LqvZgIjTrctOGCOkL4Wyi51mgpI1o4e/+AlRLU9k0PpHf0ATI64QEfbibBUhZu3j0ewy6JYPN3+xbn5o3G5SuTZzy3UXGZTtK9lPEsDMJhtSPxBzvAAUNjjl41Vv/29Z8AbNRG9g9lOKOPGRXPbtkVnr7SJKz+oO72CawHhsj+b1oKFvKxp0oFyA1Qpn+XU5xny51eBikWYb0db1ggcYYJ25XDrArTdCMb70g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199015)(38100700002)(55016003)(122000001)(83380400001)(33656002)(66946007)(86362001)(64756008)(38070700005)(478600001)(8936002)(4326008)(2906002)(5660300002)(8676002)(66446008)(76116006)(6916009)(66556008)(66476007)(52536014)(30864003)(41300700001)(53546011)(186003)(26005)(9686003)(2940100002)(6506007)(316002)(7696005)(54906003)(71200400001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?24QIZ+At1B0PEmitaxRewp7m2sZfEh2sgOyh9XV4e8V3NsdjNfViMEoH8BAT?=
 =?us-ascii?Q?3REr3rbsN0++UtXzMgDlblOiByKMwN5UAHpXrObHGyXbjxpt/5c2qymTfQ1y?=
 =?us-ascii?Q?qe10pCQfqRxTm2PokaHPvaixhHihkS4CFOWILJqTG5ZWhbrsFYwntOU+xb8X?=
 =?us-ascii?Q?xmy9zC/uOI41b0FR+0NB1FQiS3OoqDtHhXuQlX+VWFGXyGiOP8DKNbZP5qz4?=
 =?us-ascii?Q?KwTu2nzLQpDWqrglIVDlPTtDsoyji04s2Ba018C+kM9dk4Mm/f2KlxcewB1R?=
 =?us-ascii?Q?UYdYlcmvejeQqZkLdB9HX4WltwKhSgqFQEk6FqbP9X/uOCiMVArixH90EbgR?=
 =?us-ascii?Q?eM3WC46FHuYGRc0QhL0dZloxNndsPwFl9a+cxqkACUFRgUyiSbIHI+0ad3xI?=
 =?us-ascii?Q?olcI63bhy/R3w5U8Mk+00C5E8J/mBDxmvD/+Bs/5u0DzlF9R7XRuJz0nt+2Y?=
 =?us-ascii?Q?oOCvgqS0YRESB8yhaB2v4qnrArzLqaPo4smIIn1ZSNr2frQNr/uTHh00nmN/?=
 =?us-ascii?Q?NV1pa3sRe2gbAnJJTybQSG2gaJ4vJNpfzpNXgPt9VeM+v1U9gLyVfD9kBsfg?=
 =?us-ascii?Q?8KFCbW58uiYZwUO/b2UuQFKQX0SCZIf+DKPQxCbUZVVTuTQWjICfG8QOjMEH?=
 =?us-ascii?Q?Ab6+P7lCywZx3G+aiiBkYDYaVIMGKz6XAUhxE+p9T6VPCnsxTi6CQ/zxOmRQ?=
 =?us-ascii?Q?DDKCRvPJnGDYfnMNN3zK0dbrB8KyF3zZYp+nwYzlrMLk/Ft3rNFJnn2QiFl2?=
 =?us-ascii?Q?02qMxxWkUTv4FpT5SK213/hB4dni7R9laHpOGPengaaEar6/ib97MbT3Dj4Y?=
 =?us-ascii?Q?PtqDqvNoIruvCfjJY4OFrb4aoNaPdOh2m2ctMZ8L48E8xI1MqsusD1yXRwFG?=
 =?us-ascii?Q?LVRTfFye51LMICufGvii3aPnD1Da3aBEPBrjfZyENulPNMJoHaG5I+4myUFz?=
 =?us-ascii?Q?0mqh/yho/J65ubk4lvk2S6i+b9bCqhjTiWoWatyrQgQ9Ee4P1IcKSCpf9ih6?=
 =?us-ascii?Q?UKWpg9ArcasSvsodFrWXuLLZWkgfTO8W+rS36mwIricg99ikICBWwBplVBIg?=
 =?us-ascii?Q?oElMi8GR6IBy0aAhvSY9HfAuUImNN8/0rfoFsqu5UF9HH89P1Vx7D3zwELsp?=
 =?us-ascii?Q?u88F3bfuuKpQtDfHLUZPawWPmw/RczEbbgCQw6omQgr2aRb/uCJ7Q5NA8sS1?=
 =?us-ascii?Q?g+WgVcHW8QLa3d63JJzZaP0m3wKHLfJ/3CNnOe2iKe2FYA4Wf8kge9c+ex+g?=
 =?us-ascii?Q?hRzihPBh0OC5rdqN4rY08gLKy7LBm9BcLNTRgjeEny8O70SYSA6do9Pf1Ovs?=
 =?us-ascii?Q?aM5mlhaf6Ul60xYELUWmt4O80hveAeDFOke99FUL58ljX7XHrkGCkyOlZHO/?=
 =?us-ascii?Q?GXBFr7qbpPNBI+FCbTfeR77n0jgN0qrwY70FXSkZSxojHqVtcERR0XGR/my8?=
 =?us-ascii?Q?zQXgmIK7YAhd1uOZsfoVA/KymwofqhHXNWMBEJX/9cHhDRToYtlpgmBo9g2h?=
 =?us-ascii?Q?TLER2XJHwlXQZRf1lHNSuBelSgMqGWFmA3X9kX587ZYQlV1Ka63ik+O51Hze?=
 =?us-ascii?Q?BvlLCBnusLY3nVzPoFdtAnp3WbBv3qY8mzjc2OBp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d32a403-d880-461d-8eaf-08daf994a5a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 20:43:25.5353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WRyRzv83AALtPjpBcVL+lXrzwzZgBRQMV2U4HvljRXFGdtRnQgNVAdLI1zLXydWjJ4cRTJ/1hP9sU0XRM2jgiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6754
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

My apologies, I think messed up on the test case 2 and 4 design here.
The test passed on my setup is probably because of my BIOS setting.

I will refactor this selftest.
Thanks!

BR,
Kechen

> -----Original Message-----
> From: Kechen Lu
> Sent: Wednesday, January 18, 2023 12:26 PM
> To: Zhi Wang <zhi.wang.linux@gmail.com>
> Cc: kvm@vger.kernel.org; seanjc@google.com; pbonzini@redhat.com;
> chao.gao@intel.com; shaoqin.huang@intel.com; vkuznets@redhat.com;
> linux-kernel@vger.kernel.org
> Subject: RE: [RFC PATCH v5 6/6] KVM: selftests: Add tests for VM and vCPU
> cap KVM_CAP_X86_DISABLE_EXITS
>=20
> Hi Zhi,
>=20
> Thanks for testing the patch series. Comments below.
>=20
> > -----Original Message-----
> > From: Zhi Wang <zhi.wang.linux@gmail.com>
> > Sent: Wednesday, January 18, 2023 12:03 PM
> > To: Kechen Lu <kechenl@nvidia.com>
> > Cc: kvm@vger.kernel.org; seanjc@google.com; pbonzini@redhat.com;
> > chao.gao@intel.com; shaoqin.huang@intel.com; vkuznets@redhat.com;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [RFC PATCH v5 6/6] KVM: selftests: Add tests for VM and
> > vCPU cap KVM_CAP_X86_DISABLE_EXITS
> >
> > External email: Use caution opening links or attachments
> >
> >
> > On Fri, 13 Jan 2023 22:01:14 +0000
> > Kechen Lu <kechenl@nvidia.com> wrote:
> >
> > I think I figure out why this test case doesn't work:
> >
> > The 2nd case always hangs because:
> >
> > 1) Unlike the 1st case in which a halter and an IPI sender will be
> > created, there is only halter thread created in the 2nd case.
> > 2) The halter enables KVM_X86_DISABLE_EXITS_HLT. Thus, HLT will not
> > cause VMEXIT
> > 3) The halter stuck in the halter_waiting_guest_code().
> > data->hlt_count is always 1 and data->wake_count is always 0.
> > 4) In the main thread, you have test_vm_disable_exits_cap() ->
> >                          while (data->hlt_count < COUNT_HLT_EXITS);
> >
> > As data->hlt_count will never increase in the vcpu_thread, the main
> > thread always stuck in the while loop.
> >
> > Can you explain more about your thoughts of designing this test case?
>=20
> For this test case, we want to test for the VM-scoped
> KVM_CAP_X86_DISABLE_EXITS cap flags setting.
> So if we set KVM_X86_DISABLE_EXITS_HLT, there would be no halt vmexits,
> and what expect is the HLT instructions looping executed within guest hal=
ter
> vCPU thread, and not stuck here, no IPIs required to wake it up.
>=20
> Here is what I got for this test case running in an AMD machine.
> -------------------------------------
> Halter vCPU thread started
> vCPU thread running vCPU 0
> Halter vCPU had 0 HLT exits
> Guest records 10 HLTs executed
> -------------------------------------
>=20
> BR,
> Kechen
>=20
> >
> > > Add selftests for KVM cap KVM_CAP_X86_DISABLE_EXITS overriding
> flags
> > > in VM and vCPU scope both works as expected.
> > >
> > > Suggested-by: Chao Gao <chao.gao@intel.com>
> > > Suggested-by: Shaoqin Huang <shaoqin.huang@intel.com>
> > > Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> > > ---
> > >  tools/testing/selftests/kvm/Makefile          |   1 +
> > >  .../selftests/kvm/x86_64/disable_exits_test.c | 457
> > > ++++++++++++++++++
> > >  2 files changed, 458 insertions(+)
> > >  create mode 100644
> > > tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> > >
> > > diff --git a/tools/testing/selftests/kvm/Makefile
> > > b/tools/testing/selftests/kvm/Makefile
> > > index 1750f91dd936..eeeba35e2536 100644
> > > --- a/tools/testing/selftests/kvm/Makefile
> > > +++ b/tools/testing/selftests/kvm/Makefile
> > > @@ -114,6 +114,7 @@ TEST_GEN_PROGS_x86_64 +=3D
> > x86_64/sev_migrate_tests
> > >  TEST_GEN_PROGS_x86_64 +=3D x86_64/amx_test
> > >  TEST_GEN_PROGS_x86_64 +=3D x86_64/max_vcpuid_cap_test
> > >  TEST_GEN_PROGS_x86_64 +=3D x86_64/triple_fault_event_test
> > > +TEST_GEN_PROGS_x86_64 +=3D x86_64/disable_exits_test
> > >  TEST_GEN_PROGS_x86_64 +=3D access_tracking_perf_test
> > >  TEST_GEN_PROGS_x86_64 +=3D demand_paging_test
> > >  TEST_GEN_PROGS_x86_64 +=3D dirty_log_test diff --git
> > > a/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> > > b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> > > new file mode 100644
> > > index 000000000000..dceba3bcef5f
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> > > @@ -0,0 +1,457 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Test per-VM and per-vCPU disable exits cap
> > > + * 1) Per-VM scope
> > > + * 2) Per-vCPU scope
> > > + *
> > > + */
> > > +
> > > +#define _GNU_SOURCE /* for program_invocation_short_name */
> > #include
> > > +<pthread.h> #include <inttypes.h> #include <string.h> #include
> > > +<time.h> #include <sys/ioctl.h>
> > > +
> > > +#include "test_util.h"
> > > +#include "kvm_util.h"
> > > +#include "svm_util.h"
> > > +#include "vmx.h"
> > > +#include "processor.h"
> > > +#include "asm/kvm.h"
> > > +#include "linux/kvm.h"
> > > +
> > > +/* Arbitary chosen IPI vector value from sender to halter vCPU */
> > > +#define IPI_VECTOR    0xa5
> > > +/* Number of HLTs halter vCPU thread executes */
> > > +#define COUNT_HLT_EXITS       10
> > > +
> > > +struct guest_stats {
> > > +     uint32_t halter_apic_id;
> > > +     volatile uint64_t hlt_count;
> > > +     volatile uint64_t wake_count;
> > > +};
> > > +
> > > +static u64 read_vcpu_stats_halt_exits(struct kvm_vcpu *vcpu) {
> > > +     int i;
> > > +     struct kvm_stats_header header;
> > > +     u64 *stats_data;
> > > +     u64 ret =3D 0;
> > > +     struct kvm_stats_desc *stats_desc;
> > > +     struct kvm_stats_desc *pdesc;
> > > +     int stats_fd =3D vcpu_get_stats_fd(vcpu);
> > > +
> > > +     read_stats_header(stats_fd, &header);
> > > +     if (header.num_desc =3D=3D 0) {
> > > +             fprintf(stderr,
> > > +                     "Cannot read halt exits since no KVM stats defi=
ned\n");
> > > +             return ret;
> > > +     }
> > > +
> > > +     stats_desc =3D read_stats_descriptors(stats_fd, &header);
> > > +     for (i =3D 0; i < header.num_desc; ++i) {
> > > +             pdesc =3D get_stats_descriptor(stats_desc, i, &header);
> > > +             if (!strncmp(pdesc->name, "halt_exits", 10)) {
> > > +                     stats_data =3D malloc(pdesc->size * sizeof(*sta=
ts_data));
> > > +                     read_stat_data(stats_fd, &header, pdesc, stats_=
data,
> > > +                             pdesc->size);
> > > +                     ret =3D *stats_data;
> > > +                     free(stats_data);
> > > +                     break;
> > > +             }
> > > +     }
> > > +     free(stats_desc);
> > > +     return ret;
> > > +}
> > > +
> > > +/* HLT multiple times in one vCPU */ static void
> > > +halter_guest_code(struct guest_stats *data) {
> > > +     xapic_enable();
> > > +     data->halter_apic_id =3D
> > > +GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
> > > +
> > > +     for (;;) {
> > > +             data->hlt_count++;
> > > +             asm volatile("sti; hlt; cli");
> > > +             data->wake_count++;
> > > +     }
> > > +}
> > > +
> > > +static void halter_waiting_guest_code(struct guest_stats *data) {
> > > +     uint64_t tsc_start =3D rdtsc();
> > > +
> > > +     xapic_enable();
> > > +     data->halter_apic_id =3D
> > > + GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
> > > +
> > > +     for (;;) {
> > > +             data->hlt_count++;
> > > +             asm volatile("sti; hlt; cli");
> > > +             data->wake_count++;
> > > +             /* Wait for ~0.5sec for each HLT execution */
> > > +             tsc_start =3D rdtsc();
> > > +             while (rdtsc() - tsc_start < 2000000000);
> > > +     }
> > > +}
> > > +
> > > +/* Runs on halter vCPU when IPI arrives */ static void
> > > +guest_ipi_handler(struct ex_regs *regs) {
> > > +     xapic_write_reg(APIC_EOI, 11); }
> > > +
> > > +/* Sender vCPU waits for ~1sec to assume HLT executed */ static
> > > +void sender_wait_loop(struct guest_stats *data, uint64_t
> old_hlt_count,
> > > +             uint64_t old_wake_count) {
> > > +     uint64_t tsc_start =3D rdtsc();
> > > +     while (rdtsc() - tsc_start < 4000000000);
> > > +     GUEST_ASSERT((data->wake_count !=3D old_wake_count) &&
> > > +                     (data->hlt_count !=3D old_hlt_count)); }
> > > +
> > > +/* Sender vCPU loops sending IPI to halter vCPU every ~1sec */
> > > +static void sender_guest_code(struct guest_stats *data) {
> > > +     uint32_t icr_val;
> > > +     uint32_t icr2_val;
> > > +     uint64_t old_hlt_count =3D 0;
> > > +     uint64_t old_wake_count =3D 0;
> > > +
> > > +     xapic_enable();
> > > +     /* Init interrupt command register for sending IPIs */
> > > +     icr_val =3D (APIC_DEST_PHYSICAL | APIC_DM_FIXED | IPI_VECTOR);
> > > +     icr2_val =3D SET_APIC_DEST_FIELD(data->halter_apic_id);
> > > +
> > > +     for (;;) {
> > > +             /*
> > > +              * Send IPI to halted vCPU
> > > +              * First IPI sends here as already waited before sender=
 vCPU
> > > +              * thread creation
> > > +              */
> > > +             xapic_write_reg(APIC_ICR2, icr2_val);
> > > +             xapic_write_reg(APIC_ICR, icr_val);
> > > +             sender_wait_loop(data, old_hlt_count, old_wake_count);
> > > +             GUEST_ASSERT((data->wake_count !=3D old_wake_count) &&
> > > +                     (data->hlt_count !=3D old_hlt_count));
> > > +             old_wake_count =3D data->wake_count;
> > > +             old_hlt_count =3D data->hlt_count;
> > > +     }
> > > +}
> > > +
> > > +static void *vcpu_thread(void *arg) {
> > > +     struct kvm_vcpu *vcpu =3D (struct kvm_vcpu *)arg;
> > > +     int old;
> > > +     int r;
> > > +
> > > +     r =3D pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS,
> > &old);
> > > +     TEST_ASSERT(r =3D=3D 0,
> > > +             "pthread_setcanceltype failed on vcpu_id=3D%u with errn=
o=3D%d",
> > > +             vcpu->id, r);
> > > +     fprintf(stderr, "vCPU thread running vCPU %u\n", vcpu->id);
> > > +     vcpu_run(vcpu);
> > > +     return NULL;
> > > +}
> > > +
> > > +static void cancel_join_vcpu_thread(pthread_t thread, struct
> > > +kvm_vcpu
> > > +*vcpu) {
> > > +     void *retval;
> > > +     int r;
> > > +
> > > +     r =3D pthread_cancel(thread);
> > > +     TEST_ASSERT(r =3D=3D 0,
> > > +             "pthread_cancel on vcpu_id=3D%d failed with errno=3D%d"=
,
> > > +             vcpu->id, r);
> > > +
> > > +     r =3D pthread_join(thread, &retval);
> > > +     TEST_ASSERT(r =3D=3D 0,
> > > +             "pthread_join on vcpu_id=3D%d failed with errno=3D%d",
> > > +             vcpu->id, r);
> > > +}
> > > +
> > > +/*
> > > + * Test case 1:
> > > + * Normal VM running with one vCPU keeps executing HLTs,
> > > + * another vCPU sending IPIs to wake it up, should expect
> > > + * all HLTs exiting to host
> > > + */
> > > +static void test_vm_without_disable_exits_cap(void)
> > > +{
> > > +     int r;
> > > +     int wait_secs;
> > > +     const int first_halter_wait =3D 10;
> > > +     uint64_t kvm_halt_exits;
> > > +     struct kvm_vm *vm;
> > > +     struct kvm_vcpu *halter_vcpu;
> > > +     struct kvm_vcpu *sender_vcpu;
> > > +     struct guest_stats *data;
> > > +     vm_vaddr_t guest_stats_page_vaddr;
> > > +     pthread_t threads[2];
> > > +
> > > +     /* Create VM */
> > > +     vm =3D vm_create(2);
> > > +
> > > +     /* Add vCPU with loops halting */
> > > +     halter_vcpu =3D vm_vcpu_add(vm, 0, halter_guest_code);
> > > +
> > > +     vm_init_descriptor_tables(vm);
> > > +     vcpu_init_descriptor_tables(halter_vcpu);
> > > +     vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler)=
;
> > > +     virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> > > +
> > > +     /* Add vCPU with IPIs waking up halter vCPU */
> > > +     sender_vcpu =3D vm_vcpu_add(vm, 1, sender_guest_code);
> > > +
> > > +     guest_stats_page_vaddr =3D vm_vaddr_alloc_page(vm);
> > > +     data =3D addr_gva2hva(vm, guest_stats_page_vaddr);
> > > +     memset(data, 0, sizeof(*data));
> > > +
> > > +     vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
> > > +     vcpu_args_set(sender_vcpu, 1, guest_stats_page_vaddr);
> > > +
> > > +     /* Start halter vCPU thread and wait for it to execute first HL=
T. */
> > > +     r =3D pthread_create(&threads[0], NULL, vcpu_thread, halter_vcp=
u);
> > > +     TEST_ASSERT(r =3D=3D 0,
> > > +             "pthread_create halter failed errno=3D%d", errno);
> > > +     fprintf(stderr, "Halter vCPU thread started\n");
> > > +
> > > +     wait_secs =3D 0;
> > > +     while ((wait_secs < first_halter_wait) && !data->hlt_count) {
> > > +             sleep(1);
> > > +             wait_secs++;
> > > +     }
> > > +     TEST_ASSERT(data->hlt_count,
> > > +             "Halter vCPU did not execute first HLT within %d second=
s",
> > > +             first_halter_wait);
> > > +     fprintf(stderr,
> > > +             "Halter vCPU thread reported its first HLT executed "
> > > +             "after %d seconds.\n",
> > > +             wait_secs);
> > > +
> > > +     /*
> > > +      * After guest halter vCPU executed first HLT, start the sender
> > > +      * vCPU thread to wakeup halter vCPU
> > > +      */
> > > +     r =3D pthread_create(&threads[1], NULL, vcpu_thread, sender_vcp=
u);
> > > +     TEST_ASSERT(r =3D=3D 0, "pthread_create sender failed errno=3D%=
d",
> > > + errno);
> > > +
> > > +     while (data->hlt_count < COUNT_HLT_EXITS);
> > > +
> > > +     cancel_join_vcpu_thread(threads[0], halter_vcpu);
> > > +     cancel_join_vcpu_thread(threads[1], sender_vcpu);
> > > +
> > > +     kvm_halt_exits =3D read_vcpu_stats_halt_exits(halter_vcpu);
> > > +     TEST_ASSERT(kvm_halt_exits =3D=3D data->hlt_count,
> > > +             "Halter vCPU had unmatched %lu halt exits - %lu HLTs "
> > > +             "executed, when not disabling VM halt exits\n",
> > > +             kvm_halt_exits, data->hlt_count);
> > > +     fprintf(stderr, "Halter vCPU had %lu halt exits\n",
> > > +             kvm_halt_exits);
> > > +     fprintf(stderr, "Guest records %lu HLTs executed, "
> > > +             "waked %lu times\n",
> > > +             data->hlt_count, data->wake_count);
> > > +
> > > +     kvm_vm_free(vm);
> > > +}
> > > +
> > > +/*
> > > + * Test case 2:
> > > + * VM scoped exits disabling, HLT instructions
> > > + * stay inside guest without exits
> > > + */
> > > +static void test_vm_disable_exits_cap(void) {
> > > +     int r;
> > > +     uint64_t kvm_halt_exits;
> > > +     struct kvm_vm *vm;
> > > +     struct kvm_vcpu *halter_vcpu;
> > > +     struct guest_stats *data;
> > > +     vm_vaddr_t guest_stats_page_vaddr;
> > > +     pthread_t halter_thread;
> > > +
> > > +     /* Create VM */
> > > +     vm =3D vm_create(1);
> > > +
> > > +     /*
> > > +      * Before adding any vCPUs, enable the KVM_X86_DISABLE_EXITS
> cap
> > > +      * with flag KVM_X86_DISABLE_EXITS_HLT
> > > +      */
> > > +     vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
> > > +             KVM_X86_DISABLE_EXITS_HLT);
> > > +
> > > +     /* Add vCPU with loops halting */
> > > +     halter_vcpu =3D vm_vcpu_add(vm, 0, halter_waiting_guest_code);
> > > +
> > > +     vm_init_descriptor_tables(vm);
> > > +     vcpu_init_descriptor_tables(halter_vcpu);
> > > +     vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler)=
;
> > > +     virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> > > +
> > > +     guest_stats_page_vaddr =3D vm_vaddr_alloc_page(vm);
> > > +     data =3D addr_gva2hva(vm, guest_stats_page_vaddr);
> > > +     memset(data, 0, sizeof(*data));
> > > +     vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
> > > +
> > > +     /* Start halter vCPU thread and execute HLTs immediately */
> > > +     r =3D pthread_create(&halter_thread, NULL, vcpu_thread,
> halter_vcpu);
> > > +     TEST_ASSERT(r =3D=3D 0,
> > > +             "pthread_create halter failed errno=3D%d", errno);
> > > +     fprintf(stderr, "Halter vCPU thread started\n");
> > > +
> > > +     while (data->hlt_count < COUNT_HLT_EXITS);
> > > +
> > > +     cancel_join_vcpu_thread(halter_thread, halter_vcpu);
> > > +
> > > +     kvm_halt_exits =3D read_vcpu_stats_halt_exits(halter_vcpu);
> > > +     TEST_ASSERT(kvm_halt_exits =3D=3D 0,
> > > +             "Halter vCPU had unexpected halt exits occuring after "
> > > +             "disabling VM-scoped halt exits cap\n");
> > > +     fprintf(stderr, "Halter vCPU had %lu HLT exits\n",
> > > +             kvm_halt_exits);
> > > +     fprintf(stderr, "Guest records %lu HLTs executed\n",
> > > +             data->hlt_count);
> > > +
> > > +     kvm_vm_free(vm);
> > > +}
> > > +
> > > +/*
> > > + * Test case 3:
> > > + * VM overrides exits disable flags after vCPU created,
> > > + * which is not allowed
> > > + */
> > > +static void test_vm_disable_exits_cap_with_vcpu_created(void)
> > > +{
> > > +     int r;
> > > +     struct kvm_vm *vm;
> > > +     struct kvm_enable_cap cap =3D {
> > > +             .cap =3D KVM_CAP_X86_DISABLE_EXITS,
> > > +             .args[0] =3D KVM_X86_DISABLE_EXITS_HLT |
> > KVM_X86_DISABLE_EXITS_OVERRIDE,
> > > +     };
> > > +
> > > +     /* Create VM */
> > > +     vm =3D vm_create(1);
> > > +     /* Add vCPU with loops halting */
> > > +     vm_vcpu_add(vm, 0, halter_waiting_guest_code);
> > > +
> > > +     /*
> > > +      * After creating vCPU, the current VM-scoped ABI should
> > > +      * discard the cap enable of KVM_CAP_X86_DISABLE_EXITS
> > > +      * and return non-zero. Since vm_enabled_cap() not able
> > > +      * to assert the return value, so use the __vm_ioctl()
> > > +      */
> > > +     r =3D __vm_ioctl(vm, KVM_ENABLE_CAP, &cap);
> > > +
> > > +     TEST_ASSERT(r !=3D 0,
> > > +             "Setting VM-scoped KVM_CAP_X86_DISABLE_EXITS after "
> > > +             "vCPUs created is not allowed, but it succeeds
> > > +here\n"); }
> > > +
> > > +/*
> > > + * Test case 4:
> > > + * vCPU scoped halt exits disabling and enabling tests,
> > > + * verify overides are working after vCPU created  */ static void
> > > +test_vcpu_toggling_disable_exits_cap(void)
> > > +{
> > > +     int r;
> > > +     uint64_t kvm_halt_exits;
> > > +     struct kvm_vm *vm;
> > > +     struct kvm_vcpu *halter_vcpu;
> > > +     struct kvm_vcpu *sender_vcpu;
> > > +     struct guest_stats *data;
> > > +     vm_vaddr_t guest_stats_page_vaddr;
> > > +     pthread_t threads[2];
> > > +
> > > +     /* Create VM */
> > > +     vm =3D vm_create(2);
> > > +
> > > +     /* Add vCPU with loops halting */
> > > +     halter_vcpu =3D vm_vcpu_add(vm, 0, halter_waiting_guest_code);
> > > +     /* Set KVM_CAP_X86_DISABLE_EXITS_HLT for halter vCPU */
> > > +     vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
> > > +             KVM_X86_DISABLE_EXITS_HLT |
> > > + KVM_X86_DISABLE_EXITS_OVERRIDE);
> > > +
> > > +     vm_init_descriptor_tables(vm);
> > > +     vcpu_init_descriptor_tables(halter_vcpu);
> > > +     vm_install_exception_handler(vm, IPI_VECTOR,
> > > + guest_ipi_handler);
> > > +
> > > +     virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> > > +
> > > +     /* Add vCPU with IPIs waking up halter vCPU */
> > > +     sender_vcpu =3D vm_vcpu_add(vm, 1, sender_guest_code);
> > > +
> > > +     guest_stats_page_vaddr =3D vm_vaddr_alloc_page(vm);
> > > +     data =3D addr_gva2hva(vm, guest_stats_page_vaddr);
> > > +     memset(data, 0, sizeof(*data));
> > > +
> > > +     vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
> > > +     vcpu_args_set(sender_vcpu, 1, guest_stats_page_vaddr);
> > > +
> > > +     r =3D pthread_create(&threads[0], NULL, vcpu_thread, halter_vcp=
u);
> > > +     TEST_ASSERT(r =3D=3D 0,
> > > +             "pthread_create halter failed errno=3D%d", errno);
> > > +     fprintf(stderr, "Halter vCPU thread started with halt exits"
> > > +             "disabled\n");
> > > +
> > > +     /*
> > > +      * For the first phase of the running, halt exits
> > > +      * are disabled, halter vCPU executes HLT instruction
> > > +      * but never exits to host
> > > +      */
> > > +     while (data->hlt_count < (COUNT_HLT_EXITS / 2));
> > > +
> > > +     cancel_join_vcpu_thread(threads[0], halter_vcpu);
> > > +     /*
> > > +      * Override and clean KVM_CAP_X86_DISABLE_EXITS flags
> > > +      * for halter vCPU. Expect to see halt exits occurs then.
> > > +      */
> > > +     vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
> > > +             KVM_X86_DISABLE_EXITS_OVERRIDE);
> > > +
> > > +     r =3D pthread_create(&threads[0], NULL, vcpu_thread, halter_vcp=
u);
> > > +     TEST_ASSERT(r =3D=3D 0,
> > > +             "pthread_create halter failed errno=3D%d", errno);
> > > +     fprintf(stderr, "Halter vCPU thread restarted and cleared "
> > > +             "halt exits flag\n");
> > > +
> > > +     sleep(1);
> > > +     /*
> > > +      * Second phase of the test, after guest halter vCPU
> > > +      * reenabled halt exits, start the sender
> > > +      * vCPU thread to wakeup halter vCPU
> > > +      */
> > > +     r =3D pthread_create(&threads[1], NULL, vcpu_thread, sender_vcp=
u);
> > > +     TEST_ASSERT(r =3D=3D 0, "pthread_create sender failed errno=3D%=
d",
> > > + errno);
> > > +
> > > +     while (data->hlt_count < COUNT_HLT_EXITS);
> > > +
> > > +     cancel_join_vcpu_thread(threads[0], halter_vcpu);
> > > +     cancel_join_vcpu_thread(threads[1], sender_vcpu);
> > > +
> > > +     kvm_halt_exits =3D read_vcpu_stats_halt_exits(halter_vcpu);
> > > +     TEST_ASSERT(kvm_halt_exits =3D=3D (COUNT_HLT_EXITS / 2),
> > > +             "Halter vCPU had unexpected %lu halt exits, "
> > > +             "there should be %d halt exits while "
> > > +             "not disabling VM halt exits\n",
> > > +             kvm_halt_exits, COUNT_HLT_EXITS / 2);
> > > +     fprintf(stderr, "Halter vCPU had %lu halt exits\n",
> > > +             kvm_halt_exits);
> > > +     fprintf(stderr, "Guest records %lu HLTs executed, "
> > > +             "waked %lu times\n",
> > > +             data->hlt_count, data->wake_count);
> > > +
> > > +     kvm_vm_free(vm);
> > > +}
> > > +
> > > +int main(int argc, char *argv[])
> > > +{
> > > +     fprintf(stderr, "VM-scoped tests start\n");
> > > +     test_vm_without_disable_exits_cap();
> > > +     test_vm_disable_exits_cap();
> > > +     test_vm_disable_exits_cap_with_vcpu_created();
> > > +     fprintf(stderr, "vCPU-scoped test starts\n");
> > > +     test_vcpu_toggling_disable_exits_cap();
> > > +     return 0;
> > > +}

