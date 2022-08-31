Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB695A8158
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 17:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiHaPgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 11:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiHaPgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 11:36:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03FDC3F4C
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 08:36:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0LjJN4FTPB+MPb0kmclYMJ7dAEBxtnWrg6Bh4UWqTeNSkOTa6cznPD6t54m0tbusR+5TJId1p69joPrbGTZgZQ9gAubtOSDR9K+yVqsA4/2IHM0VcDgpdswyjrWxFK3wLC7GI+P+NONuqfBjLrD71yRRbNI5N6cObhaKKV8XdsnreMQaDzC76SePKPWcuAnl2lK4O+9CEtvt2Mzl6IDUNQ9XJBh+YcKrEw8eCZJku0WUERC3c7RdCP79n00SkGMXyxw1Bpx9WWTrzFt1HmlPZiniim9pGNuwG5MIlyE7werPRBDs4ARF5b7c5KHi2OAfzMlCtNbzAt6XoJfZNadvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3cJ5ypmzVdpGkvMQduhYdChWX0RYofZ3YPKX+l3+2I=;
 b=d+UDGpN0CGANrBfnRsxfo9NK5dwUYkp9cz/l/gCLYo/TjdOmm2OU0rRhqayyRg7a2Xp9z1f5275zxZfxJ63G9X5k74ESaXhzFS6CrrGeh89+yeHvWXMaKG5Ucb+AuWcF7U1mgK6dU1teC0ZqMXhD0cEe2rDoau/LN3BCfMABm+MMiA4JIt8F3bIGa8YQ08pphNvR/cFx0+FoTonJhdvk22H8V2RsRQZjREKh0KRRWqL8IiDVnRTGeiwlivbb7KiVxYzCKTufWv7TQWimY+/HTPlSrjS7PrlZtQGNoS9vhq47hcy1M6b7NCMTBMExUImIC51bS2d0Iqw17c+1y24FsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3cJ5ypmzVdpGkvMQduhYdChWX0RYofZ3YPKX+l3+2I=;
 b=dYZ7tMaZmsT2K5vYibeIz+YVfhVIUn20d/doR43Ea8HOgzM0lbJ6jAfd6MjQyVCpJWbNLkTPpbQHN8yL6Hn1y0O+uLlpJbenQ0aXy8TPedNwYOixmQsbn8aOc1Xzg6WST1v+vn4nhhAumqt+uHyqLNvIl0tMxh1KbrEc07YyWwzvLOVor79sSWs1XLFS9Abxe9JHXxBr6yH+zFNgVhL8BR/ketBA7vjxF1fi+BHw+EycZmLtpwap5wzciSCvnews0gJNqN0d60JfrOy7KTDCcbt+XX+MF+JdPMdRpyFfsjSPLD5eRDRTOLclnvRES5hty8JrWXjjUDzBqwhgEbkmIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by BL1PR12MB5996.namprd12.prod.outlook.com (2603:10b6:208:39c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 15:36:04 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 15:36:04 +0000
Date:   Wed, 31 Aug 2022 12:36:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/8] vfio: Add header guards and includes to
 drivers/vfio/vfio.h
Message-ID: <Yw9/4h3mlN4LuBz8@nvidia.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <1-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB52764F22F96E12177D50C8068C789@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <BN9PR11MB52764F22F96E12177D50C8068C789@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P222CA0025.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::30) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a599b55-2c9f-4929-51ca-08da8b668391
X-MS-TrafficTypeDiagnostic: BL1PR12MB5996:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tjxpyxWEBGywCK9RFWdMu8CGUKCx7RQlb9pvt4owJfRnABf2iUO8CN4AsDVPgZZyh6pDsz9BKYS0igZuamt7CAw5ydSEddJ0mAcHQZ4VFOCdDjvD/tIuwZtLMyNc+5jIzGFDMdpmfAqUJUtH8+N6YzdbLJ1qbDUj9cm0xTN00qQxX06nbAsKyt5ZpKT4zd0VZ76MSfQTpCpkm/CJEDH02YAe6r15GZTUtnb1dD9NPMz8mN5TX7Xw20hfj3CcrZSth49LDNFx8z5TnJKAawRDX3GB8xCCjN24ISBCnKrs7zqE2m8q0FfCeydx70GMV1KsQDgfvOdsNU3TOT+bk3QDx776vX1PDyN2paTIYGX5xAb83Rk3IT7BRWAVv7yS/vaLnjEQaNZza+ZW7KTnSvMPLXTOoL/tFrPCYObARzqW5lQAbiiyNhPmq3/Ul/ITGxfDldb5ItpMbGANcwsxDsyt8F7SFaBkYjIklLtM1RLCrLd8szn47a3V12lnHiBP7YgobBhEkfrRdQfMviD3YChV5gm6N2RiJkusKeBb9xM+bNzo6mnnstFo2r8R3JnZDblzlqTMbpSaZLsx7KpQdZXvUBikM2k50HMGGPWeXj04X4aqpuvoQk97IrssdT4YLEP/vlE3cAelVc9SBGr+UaydTVt5/e9492+B4+ExzlTzhgSme5ofOiljFD3avhjz0ZKMfZFLL2PasSjRdGF53KmE5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(478600001)(8936002)(26005)(41300700001)(36756003)(38100700002)(6486002)(8676002)(66476007)(86362001)(66556008)(66946007)(4326008)(2906002)(5660300002)(186003)(6506007)(6512007)(83380400001)(316002)(2616005)(6916009)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x9AxQmsTBQt4IEBKIbKcpCVUkIIrihSnXrEadNmJs7Gz/nrSYZ0luaDIOHS3?=
 =?us-ascii?Q?U/N9uG6D8N3mDXr/WDIU25ua11+xpa2nSTEraLfZdUoNhWU9vubXPwrpQB0z?=
 =?us-ascii?Q?g3Yd1fviaFwrIV4L5CyQYZaTE/dtcCXEWtp/Farax20xGPWCWTL757hhMWki?=
 =?us-ascii?Q?9GJdi2H0H9uxrXAWq3xLyS3pbVTzFa3vCxaEhUncoHXBwiP2WAW+PgMioR3C?=
 =?us-ascii?Q?euyuZ/Fv8ZuSqwf3k5sI/IAa06U7cMU7OZk7bu1XnFfjw1C8nctFQssU+ePA?=
 =?us-ascii?Q?3Od8T1lMJa7bp7hshNIaC5qubk3SfhXpvhZKPL+7BtQvOk5ipKhI8Da6g5HO?=
 =?us-ascii?Q?oIqN7nZCxTbP8rcWvzztyAKEehln+mtTsv3zBDPjsinIN3+AJ4HC7unk3Kci?=
 =?us-ascii?Q?jguizOARif/WBYz2luNahtx0qp/HM3B1ALPUHUzq3rR515oXOnShO7Qcmvyy?=
 =?us-ascii?Q?aDFFWWaYYc9rKJnlGQmjqC25+/FYB5jaPCg4/VZCW9fvJCMZaDxvNDs/1x+y?=
 =?us-ascii?Q?uNNaTXQJgU8x5AQ1GqojhceQIRXaOH2s6uiflBlG0Ey68BCRiLLEj/KPI9Rx?=
 =?us-ascii?Q?H/lZsJAKZK19Jr07CnOSyju9LTNHHTyj3ID71y2QMBmKZ6AYnSq4tEy5t1Ll?=
 =?us-ascii?Q?p/9hk7JRcFpMNbddJngjbw4deoSvRH/pj4bJ4TasDhHpK/XJJGqTQsddF0oU?=
 =?us-ascii?Q?KWzG4Zs0Y80/wYUTpNjeGLeKt0nd56P9cNs8X0kdd1iNyhzJjPMpprIyVcXO?=
 =?us-ascii?Q?9tozBWhly3jdmBFzxmqb09NHAkRUjk1Wq0X4H8ocVeCGkxdD1fBJG84k9GhD?=
 =?us-ascii?Q?ASOCRoPDlha8y5Mpe4FE9rNmBaSOlZcDZFf26Yvj1xsxDLuHtuQtOrUNTUoW?=
 =?us-ascii?Q?BeMiG7I4qggLc+k29lJM9eWuSSdbbauiD4m/5BEsxPEojsjQqQDpktKVZtXH?=
 =?us-ascii?Q?ghBS2m/lYGWvXfJUKH43kCqEPKWI8IqrATnL/1OaY7Y1ajtMKAGTLHJrxV+b?=
 =?us-ascii?Q?ppQD/IQI6xVtw2jqMB2wIqgmBezs8KjPgpSjLJkU/iJSfxVm+2jm2JYg41sg?=
 =?us-ascii?Q?QLp/k2n0ZpAKgUM33Rvsxff/DgnM397Hv8UdFsfQTcnLsbCSQKVzfeaeVPtR?=
 =?us-ascii?Q?xdI4oie5kXroFTtc1ZTvOKpX6olpNXEH+gA8cC/hOwfs72DqSNZFFRnwTEnv?=
 =?us-ascii?Q?3f2lFRWkkfMc4C9iXqYdNEBVUBGbhOIIcAPufAKohNSokH76EtcTc2EQAX4z?=
 =?us-ascii?Q?raVhZUTwp5C0NPFjswuaKGg2EYYChE0WzQG/L0ghRwYCQwhtHKD6w5yIBulO?=
 =?us-ascii?Q?DvOMdO1AsBewh+BZea7puqTNZ7DfgbVh4xCdqNQtxSlMvniGszFBl6CYRdff?=
 =?us-ascii?Q?PwMU3+IhvMWH1XoXyd1Cp5XhCSCF+MnSUCHTgsiUuv/cmxRxPi9f4L0pcrGY?=
 =?us-ascii?Q?D0WJed5vrP3GYe42y3F5ZnfYP5as1BQDemgxfvZrOY57vGyj7hE3UQoIoCvp?=
 =?us-ascii?Q?xHyl5EWdn6IFMn4P0XUZgUDzMYIajmjyipVGywtZuOcbAzdJH0lbUK8kpjJP?=
 =?us-ascii?Q?if8jRysUVyPNwITRHZX+RHfH2zbA1K8GGiaGxSwh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a599b55-2c9f-4929-51ca-08da8b668391
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 15:36:03.9578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h07ZJYijb+MsgIkhBpVILUXvtpFt/4pliwSy6gkojg2j+jVbU8ZmLhChh4sdTMqB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5996
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 08:42:17AM +0000, Tian, Kevin wrote:

> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 503bea6c843d56..093784f1dea7a9 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -3,6 +3,14 @@
> >   * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> >   *     Author: Alex Williamson <alex.williamson@redhat.com>
> >   */
> > +#ifndef __VFIO_VFIO_H__
> > +#define __VFIO_VFIO_H__
> > +
> > +#include <linux/device.h>
> > +#include <linux/cdev.h>
> > +#include <linux/module.h>
>=20
> Curious what is the criteria for which header inclusions should be
> placed here. If it is for everything required by the definitions in
> this file then the list is not complete, e.g. <linux/iommu.h> is
> obviously missing.

It isn't missing:

$ clang-14 -Wp,-MMD,drivers/vfio/.vfio_main.o.d -nostdinc -I../arch/x86/inc=
lude -I./arch/x86/include/generated -I../include -I./include -I../arch/x86/=
include/uapi -I./arch/x86/include/generated/uapi -I../include/uapi -I./incl=
ude/generated/uapi -include ../include/linux/compiler-version.h -include ..=
/include/linux/kconfig.h -include ../include/linux/compiler_types.h -D__KER=
NEL__ -Qunused-arguments -fmacro-prefix-map=3D../=3D -Wall -Wundef -Werror=
=3Dstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -fshor=
t-wchar -fno-PIE -Werror=3Dimplicit-function-declaration -Werror=3Dimplicit=
-int -Werror=3Dreturn-type -Wno-format-security -std=3Dgnu11 --target=3Dx86=
_64-linux-gnu -fintegrated-as -Werror=3Dunknown-warning-option -Werror=3Dig=
nored-optimization-argument -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx=
 -fcf-protection=3Dnone -m64 -falign-loops=3D1 -mno-80387 -mno-fp-ret-in-38=
7 -mstack-alignment=3D8 -mskip-rax-setup -mtune=3Dgeneric -mno-red-zone -mc=
model=3Dkernel -Wno-sign-compare -fno-asynchronous-unwind-tables -fno-delet=
e-null-pointer-checks -Wno-frame-address -Wno-address-of-packed-member -O2 =
-Wframe-larger-than=3D2048 -fno-stack-protector -Wimplicit-fallthrough -Wno=
-gnu -Wno-unused-but-set-variable -Wno-unused-const-variable -fomit-frame-p=
ointer -fno-stack-clash-protection -Wdeclaration-after-statement -Wvla -Wno=
-pointer-sign -Wcast-function-type -fno-strict-overflow -fno-stack-check -W=
error=3Ddate-time -Werror=3Dincompatible-pointer-types -Wno-initializer-ove=
rrides -Wno-format -Wno-sign-compare -Wno-pointer-to-enum-cast -Wno-tautolo=
gical-constant-out-of-range-compare -Wno-unaligned-access -I ../drivers/vfi=
o -I ./drivers/vfio  -DMODULE  -DKBUILD_BASENAME=3D'"vfio_main"' -DKBUILD_M=
ODNAME=3D'"vfio"' -D__KBUILD_MODNAME=3Dkmod_vfio -c -o /tmp/jnk.o ../driver=
s/vfio/vfio.h
[no error]

The criteria I like to use is if the header is able to compile
stand-alone.

> btw while they are moved here the inclusions in vfio_main.c are
> not removed in patch8.

?  I'm not sure I understand this

Jason
