Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45C8493A9A
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 13:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244545AbiASMom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 07:44:42 -0500
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:30880
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354498AbiASMof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 07:44:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJyu10SsLZp/YCReAg3EU7s9txWhxlgtMPgK+XUk21w2XhAYsMog3ODgyWcbLEpTMODXU+xMtI2zBdO82JH/a0Sf6I0lH9d1dSuvlJApQYVG9Dz+r3ql2P7/MJgIseXxKxdTFtw8WIWKFjRFFoGh87n1YbYH4LUvpFDTrtY2sTS2J61b90mYgzI9rQ9239vZJU3hf3AM195MXG3+WzSTuV5ZPNsmLL35xngwHzJdFRlJNYDueKkh4OwMtHQc+MPjJh4iBBMcEtpiHZr+YxQjMmvLdMsKuI1TwjXnMmsEDeorHjn1T14raVG+lb5JPFrYpdPz/bieU9O27fsfhwrSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tSP81PSDZi3Wb8rqQUMYp+8yCOwGKBoSXTFoRz93xA=;
 b=Ivoyr1u1M/spVIEakA9dpkAUKa9nW2pykw7jCzHo9kW1wLvnfWTEHE1oPrNs25lPO3Lu2JK3avHGQJIjQuAC8h5Sgid1TYow4dBsNTduGpV3z3ZGmXJrFO/9+kVkn5fB7ji4FDSjPWWAhWlB6+NhZBhpyyQ1hh6eBZoyxhXWd48hJeehJm5n0fOCmnhOnydnfuXJAzCCe2PX/CXCUiV9/iUcC5ucTRUkH50i9NsqDU5ui1viWCJzL5m0ayxohrH6VHbHOio77BkVh9QuCgZMmMvUppT50F01iE/H7jx707YOlm/uZDv0GyJVM3QZHgeiv/cSB1EOe25Z8pFwChkHZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tSP81PSDZi3Wb8rqQUMYp+8yCOwGKBoSXTFoRz93xA=;
 b=ugs13M1NPdlRY5F3/nhDd51ZbsvZc+PWpNmxjtDhFbjw+CMEtvDwXmFOev8B5XC5ZdcIhai5NHBTCZ+Mw0rhXRFf0T8y9A9kY50yCGLrMsp9suVnX3uiOfguJAgZHOwjnUbKotSeKRqTNycQynIxDgdC0w1wJF1IxY8TFgt7hMgKEw0rjRSM+gEi6elHUqY124XV5VMNGQfBDYPSfAPStNL9NwpOw7DSvNjt3HeDQbtW//h3c229VOjudon31+pwud01bIzNSvxjmMHwFHS+T0xmCoJxllCP4V8a5pyVNlbmjUg8W3Kkuvp1Dnr3qIR3gGYKqzN0hthuE7FSnLfDog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by MWHPR1201MB0110.namprd12.prod.outlook.com (2603:10b6:301:56::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 19 Jan
 2022 12:44:33 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 12:44:33 +0000
Date:   Wed, 19 Jan 2022 08:44:32 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220119124432.GJ84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
 <20220118210048.GG84788@nvidia.com>
 <87sftkc5s4.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sftkc5s4.fsf@redhat.com>
X-ClientProxiedBy: BL0PR1501CA0006.namprd15.prod.outlook.com
 (2603:10b6:207:17::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2de7f4b-365e-454e-69ff-08d9db497192
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0110:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0110F5B4329B3485BCF68D16C2599@MWHPR1201MB0110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ymzDAOD7JVeOD3aAWIrmQMQ6UmcvjRFL5yL/+5A+vKfG7EX0B7YoUnUn/0Qj8gUBk1OjYuu/In+yIWHpTxE5aVREvRuiiodrVKfNg0TD524dGmOIjDfqbAr3AiUXumcB/v3F75m1svUp2Uqa0t7y/bmrlwoGwiH6C0FkQ/sg42N1+eA82OHDBCzFF1DG177deukIJJv4pD9r5IINuKIPcKN2e4LldqzfQ1sFj0AKR631f0TonVkEtqCG2r8eu8vzi7bN+vXHaWyWn8JQPAzjVumYj0hY2TEDHRBsGWVcO4dwE4MAlFp7x5mxpckN6aZ99roPksmmJzjFbDsLzbUXNBx4R9HytY/26OJxuZC4Ha5pWA0Qbzk4VpTvbqsICSkq1HWp3TV1oG7PAmxK3krfCpnDMbejDqfUsg4Cdt9ycQl1xVrlAPMTaG1E+vCZvYfblDXNLOC9Ix1wi6a4TW5YO7680+0mtmIirwg504TMJKa+m0v22k9W7+3c+YEWaCmvbNwWDIkmqcFbitKugCneA9gDo6VbnslhjnHWyGYyErmDZHEtw8mf2sDzEfHVUYxf7ZSMbNQNmQltIgmL1BJNYggwCv3Gz/BoczzsEdhaVvnvDoMFlrf7XRhm7jM4e9BFYAmu/adD1l98Ffmex1G83Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(54906003)(6506007)(4326008)(5660300002)(83380400001)(107886003)(316002)(2906002)(38100700002)(33656002)(8936002)(86362001)(66946007)(66556008)(6486002)(66476007)(36756003)(508600001)(6512007)(26005)(2616005)(186003)(8676002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IS+bRIfQqzRITPVtm3clzr0qlcf+Iz62zmZt8nfDWttEXhdJi0ZGCoXY55dB?=
 =?us-ascii?Q?ZhEF8hdLL9yqRACz9bjD4suJZq5K3urnf3g3whL+ztnHacPCUTzvjBonE/Er?=
 =?us-ascii?Q?NNo0hkRmvx5rV1AbqLtiquzVhk0I+GyeRdsPl1UkDMW6/J7RsMCEw/XAgvFv?=
 =?us-ascii?Q?bYjrBV7oxXyxDkkaMnY2z9vQnhhbxI8Oi2UP7ezlAsBnuCyONwrIwNC6P+9B?=
 =?us-ascii?Q?SSbx+Yuli4bqBV/65wLsU0BAJXF35OjyjXi79yT1u0PVies05lHcl7+yV9//?=
 =?us-ascii?Q?hdpAv+pVNPy7xfyO6sQCXXQM4POp7GLGz08vq747rtR2IPrQxAHOVYuU3oFr?=
 =?us-ascii?Q?rcTP4At/qYFAar5OBj2hT6kYcrtUqDRmQ7iWtJq1aEOkknehhkXEZeTyNDWM?=
 =?us-ascii?Q?dt3NhT2GuyluPWLBa5HZzTjYVIANPPWgOCrKW0lliAW+8aKZ/I39QpLb6Ccc?=
 =?us-ascii?Q?WHjEeyq3m0Ft0xwkchk7px6LDfv9dSKcm2dqi0WWArIw8nmwWLLs8l3AcrFW?=
 =?us-ascii?Q?hEXcQbeTh1czJejBYcu3L2KjUyYSILP8klNPH0SBTrwx2i9NuEk2CtpSVonK?=
 =?us-ascii?Q?pQohx7Pf4AaJbRLURBWbr+ohRUUXZjQxbsykEH89T8kvvWkhYouBoCmszS0v?=
 =?us-ascii?Q?1wwpOGr2sdxxvcrji5FZlBwwcDB/7QzH0ml9rpll9vAs3MKVoozW1lAK6Dlf?=
 =?us-ascii?Q?NoRaKgC1WV3PWozZgJC+iCzGNukwyznMPQ4PXho9gjysblmlr27Ts1+6825J?=
 =?us-ascii?Q?nwQrs1lv2jX9Oi8komZjBAtCuDMzUDIGvEJOkGYmgcfadNryJ8tIOnY1Atxw?=
 =?us-ascii?Q?JEITREPzLpIuX1gmJpN5Bfxwr+lLRVgN3CxmfVaokYmOrI0h9YyJ7rrhq2VN?=
 =?us-ascii?Q?vMu3JyP6iliADsBatjkmLpaoI5RxMH3E8q5oWNSi5vkoZdmbhz3UyCZMUxd+?=
 =?us-ascii?Q?u10Jzduea/t3XKDPxtY3muoXrFnTROsWv6a0o6fd0TRAFQgaCO/UY8kcsM2D?=
 =?us-ascii?Q?Us28XzU6uIjJGSLFdMQAkBUlaQ735fo9CXqXxDaOxwmwo0479T77vGpD8pYl?=
 =?us-ascii?Q?Yx9cmLWmeqoxLHgjfbnb9zh4fq1RQZ8LVf+yehhA+6T2BaujCWGBvaKvD2Zf?=
 =?us-ascii?Q?lxCfpICrzVoC6Hyzi7MPUWfbHCSHN1jUaJdL8EH9kj9zpapEHsfNGy0fZWry?=
 =?us-ascii?Q?vCzM6HuC9qWwKU0cGSXmTUqOZJS4XCOddWsYHl/Ak2u6HGyMlImNWhkbEMo8?=
 =?us-ascii?Q?8X410IyxpCHdzpikaQdy+rbYJQooNzFgRV0uaq+7OHZJIish111+W/DgOKf/?=
 =?us-ascii?Q?8nbCCBis7pTJPgdpOWFbJIaNrPjq/d2yjtjDKU/sVpg9Iiwvq1jaWOuhIbn1?=
 =?us-ascii?Q?/J8VG6OB007WUjYOSNafe0zppgI5fbJErVZiZ0KDB3ZesN8evYn0KXcxNdhp?=
 =?us-ascii?Q?GiKDqr456mQ64EpSRSGBNvdJKrwSDM70hwASL8fFX4Nxq7Me2J3PMqp/MDmW?=
 =?us-ascii?Q?3HuwRj4ql8mNnC256psqEwudPjsv9+oAa3I6MEnFrxOytrFh4RVtrhy2aAlr?=
 =?us-ascii?Q?GC4LkYWE7W/Vl9HyV5U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2de7f4b-365e-454e-69ff-08d9db497192
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 12:44:33.5259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atH3KvApjlmO4lD13sv248Vk+S3f8B9xtskJPdvUFswZ81id69eshZF+J4RZxcdJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 12:40:43PM +0100, Cornelia Huck wrote:
> On Tue, Jan 18 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jan 18, 2022 at 12:55:22PM -0700, Alex Williamson wrote:
> >> At some point later hns support is ready, it supports the migration
> >> region, but migration fails with all existing userspace written to the
> >> below spec.  I can't imagine that a device advertising migration, but it
> >> being essentially guaranteed to fail is a viable condition and we can't
> >> retroactively add this proposed ioctl to existing userspace binaries.
> >> I think our recourse here would be to rev the migration sub-type again
> >> so that userspace that doesn't know about devices that lack P2P won't
> >> enable migration support.
> >
> > Global versions are rarely a good idea. What happens if we have three
> > optional things, what do you set the version to in order to get
> > maximum compatibility?
> >
> > For the scenario you describe it is much better for qemu to call
> > VFIO_DEVICE_MIG_ARC_SUPPORTED on every single transition it intends to
> > use when it first opens the device. If any fail then it can deem the
> > device as having some future ABI and refuse to use it with migration.
> 
> Userspace having to discover piecemeal what is and what isn't supported
> does not sound like a very good idea. It should be able to figure that
> out in one go.

Why? Are you worried about performance?

> >> So I think this ends up being a poor example of how to extend the uAPI.
> >> An opt-out for part of the base specification is hard, it's much easier
> >> to opt-in P2P as a feature.
> >
> > I'm not sure I understand this 'base specification'. 
> >
> > My remark was how we took current qemu as an ABI added P2P to the
> > specification and defined it in a way that is naturally backwards
> > compatible and is still well specified.
> 
> I agree with Alex that this approach, while clever, is not a good way to
> extend the uapi.

Again, why? It is fully backwards and forwards compatable, what
exactly is not a good idea here?
 
> What about leaving the existing migration region alone (in order to not
> break whatever exists out there) and add a v2 migration region that
> defines a base specification (the mandatory part that everyone must
> support) and a capability mechanism to allow for extensions like
> P2P?

No, that is a huge mess, now we have to support multiple regions in
every driver, and we still don't have any clean way forward if we want
to make more changes.

Replacing everything is a *failure* from a uABI compatability
perspective, those kinds of suggestions are completely out of sync
with how Linux Kenerl approaches this.

> The base specification should really only contain what everybody can and
> will need to implement; if we know that mlx5 will need more, we simply
> need to define those additional features right from the start.

Again, why? And what is a "base specification" anyhow?
 
Jason
