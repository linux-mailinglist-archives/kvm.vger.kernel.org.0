Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6866E4845CF
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 17:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiADQKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 11:10:03 -0500
Received: from mail-dm6nam10on2043.outbound.protection.outlook.com ([40.107.93.43]:2755
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229884AbiADQKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 11:10:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByBgX0z9IYQLRdjLWWj8mer57UUmQDGV5JYn6MH82wrYd8X2ssOpm3lzx6+yGYQhRqWwrJ0+d1SiTZxdXl+YLj9HpgTtNoJSNkz65XZRdCmJe7gzAQP4qLcJVvSnQhK5Ex/N1KNBH0CfRa3QlAvEVZi9MNb+g4ePiaGAdcoBZ1+snVC2IPMkdnRn+8dm7qse0MBqhxdb3s1ouKrZqRUGIPyHq/MezaIi5jxfKOL/mQnY+dLFEbRgBxvyRiuGmf8iVzfGmyI5kSSsf4b7v9moaBoT3HyRnqzkC0piRK1jYnRChWKdO6LaoLY1ekFMD2vFN4TdnC19tdgkwCij/iJSMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFs7DiHkt5I8RLtiNEFFL57C0E/Uaq8KMvokT2oTcKA=;
 b=naDZsOKa5gpl7iFwqAt+scgvyN0HkhAt8i+acnTKQsBNmxf4jJTgRs+ONQaR/ia9bKarCETLgIRhDn3qBy4/+pRtnlSOJzMsuaf+Fxyg/xsCJiOP1WOL8kxaG/YPPXgcbgXOyJ2qm/lXnGitkCdDtwtnAvYTvCk2havBkYSt9zz5D5Ufw0M2iJjQ7eKA5Chjr8HxBRiAsuEkrppNSOsw5MnglWsyQ8E1pEHPkiaJuP3LxnHhgS56pa8zzSzjAbThzlGW0io0Iwthd7Cgk84nhJEl4wBznHmx8L/Cj3qcpl5/C5B5gZyixta86HiuMqZ163MyrTCV4K3bU8YrVnLbBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFs7DiHkt5I8RLtiNEFFL57C0E/Uaq8KMvokT2oTcKA=;
 b=MnUVEbrprVmsGCXL5XUvx1hDGk6AjXMLPMYjxcAFEN9VY6m45EbpFq4Xtta8C4M8LliN4iPBV4yIFpemwkZJ/Sp+jmaHZTUFI5g4Pw+lFVL93f5YXXJj5yuO8sru4ZZDuoo3oUrGPnvsefxkcgjvBNlfA6YRbsxf0/rDaNqoxkAtJD4oTvlzRQcm8XiDHPQvy8FF/PEbFiPxsasc6Cv/9Xumf/63wfmQUs3TSp2ehyObJPajSIk6RAVLW0wb8nZ9WoOFDF/wfytM6b9XmFyYm5+wgXuWfQ6b474MFMf4hA6xs/X11OUKRPMb+yFwRYJeS+gNCoyrYgOR5339eehysg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5389.namprd12.prod.outlook.com (2603:10b6:5:39a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Tue, 4 Jan 2022 16:10:00 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d%4]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 16:10:00 +0000
Date:   Tue, 4 Jan 2022 12:09:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220104160959.GJ2328285@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:610:b0::7) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad9a7708-9cda-414d-25ee-08d9cf9ca8ee
X-MS-TrafficTypeDiagnostic: DM4PR12MB5389:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB53897FC8505B68C96CD5C66CC24A9@DM4PR12MB5389.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JfPRbooxborpzL38hqquEf+dYTkemx3Oo7ryP+wmkK+N47wUpVxs2yr7ELfRCqpYSt+YkskmqbenMWE8EAyzY5yMrW8OrDDpU4op9FXCxQoehi+/9CraYqG6P3tOCjDEssOclMiORjmgjNC6VDJfHxE2nJ2GDJ4088OM82hcGm1iuxfSt4ObGrj2yd+OjdfeYMpCwbmd7Hvyk1f0Qk98iOQMWqkr56zp+1eXfO0tIH8QCsaiozkFki5kholMo2j6SpjqE/ZuyLx4H4+qN5oOarTjf2FAtS7HNwHSTTIhZo6rmHfBfWG2JwmZPHX+rEWb1g8/zCAB+N4OMszZPxuiU3nwLSKE+hmqMbYk9IoatA48sx9ZGLQ88uKZamxy8RrVZb3Usww3oVeaFKY6NB3m8pYLPyAljVrH+hq2KN6WlHrnjtXXBrHraxrErNzaPdDuoIXeVJ3EmZzvC56I4iHsZiYAjSHE2jr3JRFrXDZvC6Kg/QXSRI04nJSbVjBCQfNMyPkgIA5i87mKdnJyX3kycBdmg25MRZ6oFA1PaybETevEO2E034pe3jbdMXuASpcWWjdf5K+wM4n70vPLSGxFmzND49iYDTZLyM3bzcEOMJ6Zu7XE068NtLqmE0V9chS1F+4NylfhljyQcBmIBJkPEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(15650500001)(66946007)(2906002)(316002)(6486002)(66476007)(26005)(38100700002)(186003)(1076003)(6916009)(54906003)(36756003)(6506007)(33656002)(86362001)(5660300002)(2616005)(4744005)(83380400001)(508600001)(4326008)(7416002)(8676002)(8936002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PvZn1M8/EZ86qhNovOg6MQsEuRU5WN7kMXZM549edUAmftk4SFUZwSzXd5O3?=
 =?us-ascii?Q?YbejgK9pkIVZkmlNTtRNSp/ddUBBj7TFbG6pHx+4IwNS+ICrILOihFQ/oG+N?=
 =?us-ascii?Q?rWS1U+t+DMGwUTPFSeoqqoyFCssZMPoZgKM/laevI9PHT6s9990UY8CejoWd?=
 =?us-ascii?Q?+fWCOPXZAFi12JFzuJYYJi0P93P0h9uKdqrPlZejsPOyyD2dhUmW6zHs8ygt?=
 =?us-ascii?Q?/NK9aeQ8ZGKZrnL5/43EZ5lId8fz4I5HNCZQ+PX+RFjCyT+OQo9S6pWjRpm7?=
 =?us-ascii?Q?R5bItNTAXmXlQeG1NqwCPdYEfolL3WpdocoIUTGdAgw5u5Ju7iN7XOFX9t2Q?=
 =?us-ascii?Q?8kLWwwBVxd1y4V32FIyEI+fr9ie8QrlLVsq3iMQ3jrA2OT/LOj2QnIIvHX0s?=
 =?us-ascii?Q?6Owyo2no9FQTTNUVXf8LuuTaAPik3Qzaq7pJ/Oqwg8CKTA86Ymw44aeyGCEZ?=
 =?us-ascii?Q?6f2nZX9F3cyj+P0hBxmZLFrwfX5gEI/aVBNVlwE6/MGlihlSa/lJTkyWs+am?=
 =?us-ascii?Q?lbnoym+sAwFz/+GW3V2apbFWkhqn79ylZTllqKV8qKUvsCRmibmttkHGT4Xy?=
 =?us-ascii?Q?MIOJkyN8sx8S8ULkTZI07YJ9BH8cR5afafzU+sXbMs1BSQ3xW/YPtAvEHHID?=
 =?us-ascii?Q?qbBfek9atMIvmWAyV87dfM4JW6w8z95mF/lHOiQnDAG6Zxt0lXd2y+wo49Nv?=
 =?us-ascii?Q?pBX7pMYrHznPgA8nWJceejmcX5tcUXtBOtFFpIN+EB04Bd3kaQOrof/JBVC6?=
 =?us-ascii?Q?1Egq4RDLbpddBLCcW+T6wzLHx8x0BKJxyklQJvNK4IrrXlddv6FzagWU5ugf?=
 =?us-ascii?Q?PpcnDeT9POi9rGkgT5e6jhVB2YMtu01uLoIJvYwJPkTFF+7j0UYTyOtekDf/?=
 =?us-ascii?Q?YDSb5WuKF9Uwjx4zQ855POl68b//9kGGC3DWCSJ/FzcbXp0Ec8LGdRUX5mWd?=
 =?us-ascii?Q?FgrI8H1IC2oTKDCtzxB0U2USqmKN/IVbAAequkcQqk+bml1cZ5mfymfWli2r?=
 =?us-ascii?Q?Wsei3hrtadCqv712GIMnsD3gRNunh5PPKbXGVC5WzksibVL67/BBgzataJaP?=
 =?us-ascii?Q?KiI8kdjl1jJkCAlEPE+Hl55mUInd0F5gDBrcuxjVsU9Bm+QfR37DkJEfI8Zm?=
 =?us-ascii?Q?I9UTI0JZZpjTQAWQYtmc/kJN1qZSRTm1hy0bYc72X1y+oW8yHMM+tBSFDS4O?=
 =?us-ascii?Q?9G3r9MgK2VkUc1jNSZuXFVvtkB9bLO9r2pwf3GqUgVPSZ92fcCQcLXcWkSkc?=
 =?us-ascii?Q?+5ZL1caLPJJdNpT6lgrbs4LkXq3Y6L7WLGBC9DEP3bLaQ7vYalwsxFBmwbyB?=
 =?us-ascii?Q?Cmr70lf3jPKg3nLCwC/TApZ/iJAX6s4CFkfU7kgGEcB3ee7XZLZ4Urj+QXFm?=
 =?us-ascii?Q?IRl5XXcu5gEuVN+14pzLeSiMsQqLvfOYcC9eZ5//7JFr9UBXWdo/bVFrV3VD?=
 =?us-ascii?Q?17iVQp/M8WIaX481qJ2zurS+BFhnQVMusUXUujj8GQeONvq9fiZUBqh1bChI?=
 =?us-ascii?Q?uVmyckrF1+Ng6BJ7Qke2WfqdVEd3TqtcIOMlNkEE/xfTQaiRuhNzXlL4ZBW0?=
 =?us-ascii?Q?zCLoeZ+LBjQ7rgOk7OA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9a7708-9cda-414d-25ee-08d9cf9ca8ee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 16:10:00.8162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcfRN5MeWjlTeMGrEq5QDNHo3xfNOgUw2RQHnFoR931XjKQ4YqU1SH5RULBpTPIN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5389
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 03:49:07AM +0000, Tian, Kevin wrote:
 
> btw can you elaborate the DOS concern? The device is assigned
> to an user application, which has one thread (migration thread)
> blocked on another thread (vcpu thread) when transiting the
> device to NDMA state. What service outside of this application
> is denied here?

The problem is the VM controls when the vPRI is responded and
migration cannot proceed until this is done.

So the basic DOS is for a hostile VM to trigger a vPRI and then never
answer it. Even trivially done from userspace with a vSVA and
userfaultfd, for instance.

This will block the hypervisor from ever migrating the VM in a very
poor way - it will just hang in the middle of a migration request.

Regardless of the complaints of the IP designers, this is a very poor
direction.

Progress in the hypervisor should never be contingent on a guest VM.

Jason
