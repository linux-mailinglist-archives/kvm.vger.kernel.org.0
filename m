Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FF4494430
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357730AbiATAT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:19:27 -0500
Received: from mail-bn1nam07on2050.outbound.protection.outlook.com ([40.107.212.50]:8934
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345061AbiATAT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:19:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FroVAtV9bAIW74eWzegTnx+t2/FbpsGGtZEq3/ocCnxYj/4XF9TcaZnFT9iSraRGikAMeHw3lmm0ooMT7ZpX7yeZrTrRqKUkoPH1K2VXRywP5anpoiAcSq4D4YLW/GVekRMYcGLSmSAzWDgM8hRzYj3OvlUx1vXcTax1nFeqf2k7yZl1oXLqYrps0NH/mq4YOXDi6VF/Qy4A5HUM//Zhw2uY8WNxRON/vxjGqUaegkB18uRy9AK5kLY0YqBVGFBT4TqwvUhVXE76kYAIUfVI23qnodLSQ13SI/soBj+Wd/bdmCO0WQFK4CX48+DibaXw8cC+gDg8XVKcpn/xQzZkiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1ov0QIWc96sl+XR878kE0SFBLLOfj71iYamDXXjtzg=;
 b=EZlWXWMWHpUjaK+YjLS4UIkOSpln74bqQ/0cG5kgSXPmrlalq6za2b4gdC34so9aexAnpZvG4O90aTDMAc5Khqk5iASvmRf21Mgc23WAa/2ILIqIpZJot4pGLWim03W7w1hUcnsvG1ypSeGy9rZklhZmRSk2KCjY7W1mSf3ggZz9R/PsNISSK+YJkD/gJUn+XloAUbEvVdCmekiPXM7Vplxh4ICjV6Wp+EgyiKEFxJLkQHGTeM0L3C9FiYFX2xLkgHk1+aWIZDHi+do88FMDRGZ4hm1jitViRqnAVX+Z95jHRrc4oCj7P1ZymM+cbQDmqPW8tXZhaTuBXvSmcGlBjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1ov0QIWc96sl+XR878kE0SFBLLOfj71iYamDXXjtzg=;
 b=LH6w+JQfAdq6hge1rGwx1EcuMywlfxnWIB+vEaOdih1MUxfdKFhCrJD82/WuRVanEhp7sd9D7tmq2A/uCR1OJXM/ukgi0/WO7xiMKzZq9BUR5JOcPT66Pwom+wJDFiLEFn15f1Tm7M4W6NLam6iqpdsEgHdJSL3Iw+og+wux+q6YZbuNgQBfM4c/CQKDon1cxqVZ8fzqUVLBAgnyyLef6mNbjLGU20F1RT5ZS0Knt76MRUpqAFlljRUnpKRCnDzx0lnF7vXAFhcNR1sG6HT90j4RhLxBVXDysJQ4TCnWjhung5PyNEH5c+HBTmT6iQDiT5OhYyG6XybIQWPiuj/Xog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Thu, 20 Jan
 2022 00:19:24 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 00:19:24 +0000
Date:   Wed, 19 Jan 2022 20:19:23 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220120001923.GR84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
 <20220118210048.GG84788@nvidia.com>
 <20220119083222.4dc529a4.alex.williamson@redhat.com>
 <20220119154028.GO84788@nvidia.com>
 <20220119090614.5f67a9e7.alex.williamson@redhat.com>
 <20220119163821.GP84788@nvidia.com>
 <20220119100217.4aee7451.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119100217.4aee7451.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR18CA0019.namprd18.prod.outlook.com
 (2603:10b6:208:23c::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fbce014-f3d9-45a6-2a4f-08d9dbaa8326
X-MS-TrafficTypeDiagnostic: CY4PR12MB1352:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1352C016C1EF749941224EA3C25A9@CY4PR12MB1352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yb6KDeCjh0FAd74haveHOrX/GR8mQzKs0DxQOLjuV+1Oe57vx818mO73TxElL2a7yueXq1XmpS3JwTopxcg7cpEeasVaDWbCcT+9Ir3MpPM/8i7xiLnnQPbSkKx27nPnpLEUUBF37O0RHerMFcv4OFRDFTPFJxK8ZRoPgQOrdOCyObFcdjtRTWcxIPbsZEQySehgqSC0d0v+DSSeZsNvuyokPSpjZ3r35caQczmB+s/BEcHSXlIG7zGpyex9PxNz/rufrjVxLw0noBpE9yxAmZwKeWdEymKc8/wASLtIguXgfQPv8YR5Mr5PMTjDcrqKgM3JNjHWBLfAHfdNTzuq1XK3hZZpRHiTydnXhzjoqp2HqQfUHVZNQeIghHjIqBSRHQZKMYNL4EdBcLqjlqr7dPKM16ytwLBPItV85VTtC6GHIUf2ClaPfABJBvE1av596RNZX76xLg4G0kxqVD6T/UFMg199PqDekAXSiz+sXxwqVsEuXseIXn68vL8cLcodzmzX5L7XY4k8Z4NfuB46Mh4MECH87cWcGuPGGm7bZCulOSMZYKpUM1gVimQ1ogNKqItvh/4F5ZvlnHLxOueRV1p5fhgZu0B8YsP/C78i5RSx9LTFBzwx72TOKhuwkUOLFcdyyUS5N4fN1rsNeFxlEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(15650500001)(316002)(5660300002)(33656002)(54906003)(66946007)(66476007)(4326008)(6486002)(508600001)(6512007)(1076003)(2616005)(8676002)(6916009)(6506007)(86362001)(107886003)(66556008)(38100700002)(2906002)(36756003)(186003)(26005)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1BU5HXmjFC2te4ELO4OEcwGGLy1AWEWdUk4qxzZZLSsyDL4cggqA+p5HbqlV?=
 =?us-ascii?Q?a5jbTHwTwEocLLPbV1M/bM+KUOB+vGoj/UN7Wb5tDjSVlhvJEgZ/4EIIsDIS?=
 =?us-ascii?Q?0E3PKKSuhjca5rZaH0iPeDV82t+WU1hqW7ibEqic/74RhoupykH2TGhwmiTc?=
 =?us-ascii?Q?N9nsJQnF1rV48DMwodmvDmvefmYLJfg9snN0P6kAvLPaUEOsuTjltMw0ZMGJ?=
 =?us-ascii?Q?Dm+zoXbb0ll1dR+mKAAnpSwsIS/m4VN0qfXSFupVb3h12+WEczvWRhwyGKaG?=
 =?us-ascii?Q?dpYITA00OP2ctlYhOhwMEcpBuuOYJBl8zqN+vjWeC6D4Cd1bxJc42l2eKLaQ?=
 =?us-ascii?Q?7yZvnaWsUBZQro/bUz5ayUnDY78EAK5Nx4DRmpyDoZR++AcDJLPIXuTFaKFf?=
 =?us-ascii?Q?6y63ygCnwTrxjjT9LO3NI/sKJUVgFDNGNLRY9QAmT7ezTHjxI6bt9s3NOOxn?=
 =?us-ascii?Q?Qxgvva1cN6ba84zDhdcoGR2PWqMLqwjx7B8pdXw+ePu6+oer+a4LxlzO1EcJ?=
 =?us-ascii?Q?jM5+ZZW9E9WX82opD1eJivpEOTvnLNW6S78V+nA7oGqQLAjI7aM46bxOZP/H?=
 =?us-ascii?Q?u2Q9cowcWgy0qKvgIY9+bVH5m9KEWYqTyDd64uu7aBvsQWFOAns747vXR9zA?=
 =?us-ascii?Q?+hKDkGKe00vlDgWJWR9r6dsAk6cWg46RVoeo1udk7QciNrQ16obaS1pPwQTu?=
 =?us-ascii?Q?iHttbFaW02o6vv8mTX7W9v/S2z9TB/SQJ++Ij+WMiz1O2xM7aHeB+/cPAHyT?=
 =?us-ascii?Q?0xZtbF+gLWBcDXfoBgcZXLJtizfbjmDmYkIDfUINH2fPGC9DnW9MhIThLH7b?=
 =?us-ascii?Q?6v4Zk+6VALTcDx7cjAnoNR4SBITk9jHvEs0VmLu4Eq/7rz/DusaC/6/Nql0p?=
 =?us-ascii?Q?W4NKxGkEP8QIRxCQhYztC7t9erjMI021090nHgnme0XrJAzbnY9j0Un2Q+aL?=
 =?us-ascii?Q?AICEpG8OrfJFvbj1CyXw3RNYOkSR9wU6zwCEeaZK1m/7YReoiJTPV3WUJBp7?=
 =?us-ascii?Q?Bdrnbi/MCyY00Z3ZZdzdVQ2tYxVlgiRnz1YiKx9M2WgPuXSJG349dgluznRW?=
 =?us-ascii?Q?ZYxLJ0YwOpi4jDsNYclvNxkm8IAXe5z8CL0pXj9VzmeRebOdjLN0y39wvRuo?=
 =?us-ascii?Q?F4sQHZX2AwgSh4/f+MMo9Z6jw42TcI1DMm482hRl0IhtljmSvqxwlHf8/wEI?=
 =?us-ascii?Q?sa8yIvYoKQbM1j3rK6SaGBf4NWEv+1Ti4joWYtUsq6ZRQ1SJu3VaKB/ghFdO?=
 =?us-ascii?Q?0oyBoL+RaFqoLwNh4DVrRCJVw8u2QubZNtnz3PYdHblha/sTZqXamYqCWPwZ?=
 =?us-ascii?Q?3UOyRjnbvq7xxg505uKIM0aRDlhjCBRiaCsVYNYHnuuwnYxRq3h9yIN2fVfY?=
 =?us-ascii?Q?rzCsOjS3edMbVnj88Q5F/SqgRAltUX3CVoRcxYkGcfBoAV2AB4+yYarp698o?=
 =?us-ascii?Q?8SI2sLIt9l5i6Os253kaIf3IbjzxcnfrfTX9g6jQBRDwsDacKgMA0JAtsMTI?=
 =?us-ascii?Q?oqpdaqDwO0B+2mzZDcJCY7uyqqImSmHNowbg3UO9fpRY/fkYw/3oyBcO0h1C?=
 =?us-ascii?Q?4C5HiLHOqXTx2L+nVhY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbce014-f3d9-45a6-2a4f-08d9dbaa8326
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 00:19:24.3062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aa7uZOEprDs4ChSuS8pfd3BO/b7X0KLJIU8JADSIxPV1aNPGllodhgcyQMZpGRha
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1352
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 10:02:17AM -0700, Alex Williamson wrote:

> > If you insist, but I'd like a good reason because I know it is going
> > to hurt a bunch of people out there. ie can you point at something
> > that is actually practically incompatible?
> 
> I'm equally as mystified who is going to break by bumping the sub-type.
> QEMU support is experimental and does not properly handle multiple
> devices.  I'm only aware of one proprietary driver that includes
> migration code, but afaik it's not supported due to the status of QEMU.

I do not think "not supported" is accurate

> If a hypervisor vendor has chosen to run with experimental QEMU
> support, it's on them to handle long term support and a transition plan
> and I think that's also easier to do when it's clear whether the device
> is exposing the original migration uAPI or the updated FSM model with
> p2p states and an arc-supported ioctl.  Thanks,

I'm not sure I agree with you on this, but I don't want to get into
qemu politics.

So, OK, I drafted a new series that just replaces the whole v1
protocol. If we are agreed on breaking everything then I'd like to
clean the other troublesome bits too, already we have some future
topics on our radar that will benefit from doing this.

The net result is a fairly stunning removal of ~300 lines of ugly
kernel driver code, which is significant considering the whole mlx5
project is only about 1000 lines.

The general gist is to stop abusing a migration region as a system
call interface and instead define two new migration specific ioctls
(set_state and arc_supported). Data transfer flows over a dedicated FD
created for each transfer session with a clear lifecycle instead of
through the region. qemu will discover the new protocol by issuing the
arc_supported ioctl. (or if we prefer the other shed colour, using the
VFIO_DEVICE_FEATURE ioctl instead of arc_supported)

Aside from being a more unixy interface, an FD can be used with
poll/io_uring/splice/etc and opens up better avenues to optimize for
operating migrations of multiple devices in parallel. It kills a wack
of goofy tricky driver code too.

If you know some reason to be set on the using a region for this then
please share, otherwise we'll look at the qemu work required to update
to this and if it is managable we'll send a RFC.

Thanks,
Jason
