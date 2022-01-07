Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E849C487B52
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348557AbiAGRX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:23:28 -0500
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:46911
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348550AbiAGRX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 12:23:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUQy97s65hDD9v2MNtCCaX/4vYS0sZ3V5V0+6CWYkvGYmJY8a1RmiVUTJqdAjuRrWayfbG/WgSDWmYuiFIqO9eG551aTV9YOjTyNflbV6Y6iVNN85YYHfZ/e8ff+k5hOI82bMPorQdbTg0GYPF75esIEK6GotZL46ieVIRKNXeF/WtuPpCR9jFEr3XxN7ypNb6OyZh5/LonPAHsAJdmOparxJDRzYWqmhrAKwqwOd/gVZUmqCTUuXO2pzJkpLIgUcF519H4hY6dtULAfvP3pEzV6/faLzMMR3T+4QhIEwrfO2D3kEyDCTETf7MLJU+sHzudIrfS8V4jQrF7QcD1c7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nv6k3UcDja0vNIj//NyewVuiviyqurm0nZr8SceV0qQ=;
 b=Rd8xv24mC2vQUPvxrjcBhWFZBOaKThPBbbQ8oDqf2Ub6E1YY1voadVLu+vENqdrDNg4+FYhP14h7lY876qVIPSqwInyrJT0DDGNI0ag0YlcmWDzTGV8DDAmiXBKHp8bqpC7BYvWrdDhsh9ngTxS9AdsFft0dUnoAMqksu5SgFM9p55KzYRSayeFm0Qbrorxgnm+fbGJ603Qrmgdga4qiZ9ifzLvC8/cD5CrumGTsSjQVBUL6Q7Z+8BIEpzc0NdMsfr/0dz2Zt84S5i4MYm6Z0/1R40lTcMwc4ipfS42s/BN8gFuyyzlVzJuKWa3OH6KAZtlcM5JFc9M1vDKU2UDjyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nv6k3UcDja0vNIj//NyewVuiviyqurm0nZr8SceV0qQ=;
 b=pfQi+a15ka0o1XeOxxHe50yuCPqnYOfu3LwJlltqrM/o21hlOcX1hK0Vl8MXGWhtVvXfoi+4GebGPN0+ELQRhTGsdmcdsI/9iGelMFVOPAXlAZFArR0a+wlg2aPJ7fgEd7aFrshQ6l6Oegj/oBU20Q6YcAFGipo207W9ZO4hdgVfv5DpkE1thK2EfXf+r0bJQz23PvZIZ9MsR5yiR5VXMrsD4u7wMN8a/m2PsOcFO/JFxfToz4GAtkL+xWChJ94pDtHyvBV3Qr+XKMCqXTPFJXe7YzrhhdbPIP99vs3efJH4Z+tBERua1DoL3CA4DsCprE95yauToATi+6F5Uwjl6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5240.namprd12.prod.outlook.com (2603:10b6:208:319::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 17:23:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 17:23:25 +0000
Date:   Fri, 7 Jan 2022 13:23:24 -0400
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
Message-ID: <20220107172324.GV2328285@nvidia.com>
References: <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220105124533.GP2328285@nvidia.com>
 <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220106154216.GF2328285@nvidia.com>
 <BN9PR11MB5276E587A02FC231343C87F98C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220107002950.GO2328285@nvidia.com>
 <BN9PR11MB5276177829EE5ED89AAD82398C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276177829EE5ED89AAD82398C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:208:32e::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e6f54bb-a4ef-41ed-64ac-08d9d20269a5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5240:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5240B67610E8BCD12AE6DFCEC24D9@BL1PR12MB5240.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnN/rR8uib0QaoGBXd4/34AeaqFEBQzKqAwsIZFpsMSib9uspS8TkVtp/y2YFK9R5RQHoEizqEVd/sLNvrJRiGMvZnzCKk3d2667C7IN+rrFDm57o0iuwl3BKVo5U38UoudeYcqeBAwe60RO2kKtk/vyrrCc+h1E7BzukoFH44kNQ3JJI3nZ/kcn+ONu9Bh+///uWfDBvs5lntbIwf2dnd4YCiOrRfzQp9dAghKbd/oEYXZHvKEGgn5pAvt4u49duLl613PYioIWPzFmTW9Z0oU8hcK3wBlAa7AP0RbGBjRX+EUB1tSwze+b+WPMvwrsaSHOuo1nKwrPIYcruD3p15EHCFV34C6577PCdtkAZZg2gdKf8B8GNKZyzFWJj7YhzBiswnqeM0G5mh1CWGYV0qnI7y9rwuLNksrkmTRJSOArNX4CeXkpRgx4Y0umdV/TVVA+lHT5w1jwLkg/cv3dtNX8ws057+WC+0xeln4yrVeu3+MIsurTusibRhSFylY635DTv+o8b0rGOqhiFYA/Z0rnSYPL/vb0wY0KQQT3IJtJu9E0Tc+G7W6DK6N1S0e9dmK8feid7+r14P1Oa9hrY2AAst4Ben1l+S9Sm8GyhM7lmYjMt6GTRl5bpYWjOQBqShD9Bt5mKciG+V84Ut89bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(66946007)(7416002)(36756003)(8936002)(54906003)(5660300002)(66556008)(508600001)(2906002)(26005)(6512007)(8676002)(4326008)(186003)(33656002)(66476007)(1076003)(6506007)(83380400001)(316002)(6486002)(86362001)(38100700002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EATVHUYv/lIDGK2CZkowH9qgahDkKZhsKL9QCdTl0o1Qrk/nZysnVacHI7n0?=
 =?us-ascii?Q?x08f4rPLc2kJ1OeAbHUoCZz3xpUhGJRHsQlqC9ESo7D9434UYHcgvTqA10FD?=
 =?us-ascii?Q?Dt6sAndbICvbDJaAEaWtKfTyiqCRl4Pk73D/tel2i5uVXAscmg9J02xa+wqv?=
 =?us-ascii?Q?psQxhQQXt5UQJAm8RE+NEtr6kLemxhN7kg8BSZP/ktEVqsE0v7Hh+mR4wShU?=
 =?us-ascii?Q?UO5vcUx28ji6DsTxMr8NrTseXJZV4ihefEROpJ1b6gyRx2PF9jMosQdY6X+E?=
 =?us-ascii?Q?Wykma5nmkQJdIota0NfuNuGWT1mMpmPkm+8YiaHYo6KA6HN7xWkEV9P2MwrZ?=
 =?us-ascii?Q?Jj2X45YGV70IYr38plD/PX2WME/rG+B3kr5B5FMKOa1PjN9HiCkFqkr8mPJW?=
 =?us-ascii?Q?C1Rcgh7vXMB0dHCoQQTfAC21XntzBMLlScrPE6nbEkKJiBzbZ0lDrWXrLQXU?=
 =?us-ascii?Q?dVNJHs/jxonvIzP5s1I3VPDryEllnSFm95qakzhQnk8bzRlI+XPS66+Kus2D?=
 =?us-ascii?Q?+IZhDeA0L4c2Pb77cOUJT/yvFVD3Q3WxZS4WBYTxI8if6e/X0EExZs5ZK5Ll?=
 =?us-ascii?Q?32YIr7+q2sGJ/g+x0+EFD9+Y0jhU7S9yhH+bPaAMj0hDZFzPNE+UAog6XINz?=
 =?us-ascii?Q?4FeL8coAPpwPzBZsfZVOVIsb4dbltHBElMm9ck9ml336VxFZhqHdD7DvhQGO?=
 =?us-ascii?Q?ud7Eof+7M1u2dTIEA725nDhXV8GS/u6cgnlADGn3JPnaGTHK6uvokAH4fqXo?=
 =?us-ascii?Q?0AwuCMSqAe5iGwZNYwQXXYkMjYIzm8uGClxKF8h9SjnlRTSJ7RAc/eg7Ukht?=
 =?us-ascii?Q?Tl/WYucvhrVHnxdU5Psz8ZdQhpvNoRMVOGkGp4WzCEa9uFpeyGE8kY6NwoJW?=
 =?us-ascii?Q?Wo4BLzSwmcIjUoRDpadFTcRt6I/P8hge+4L/wPlFZBHXQxJGzCIbK9nvQVDS?=
 =?us-ascii?Q?WN9YkIZ5e1W4idsHQ/cPFkXGHwGWwyj58f3rddBVyjhptz9uBOi+Nsz0Yqzx?=
 =?us-ascii?Q?mOeIWyNPcc86b8sHQjUvITUjZ7WTksfU/9xMQLhTN2yY2G/UBNX+piufB5jc?=
 =?us-ascii?Q?M0UTNZst6zzOSZw3dKPj3Vj/2yd+bJN4CT481J4xk5zJG1NHCQ4EJsVFol/F?=
 =?us-ascii?Q?mqqDfe2lInvkJ11HSfyCUTEypAftne9J8er8zidgfKK0ta3troRnY+EyqqAL?=
 =?us-ascii?Q?9xtiP55JK6kSOhZYYEFNvOgb0ofQVmMfK8M/UhMDbogBz+ps1PrjOeT231Dn?=
 =?us-ascii?Q?Lv9Y8cckPlwKSQ/jpP/uixVawUaJQ9lj8CbpQwdMXHsAMWnWZsOoOwlseEp9?=
 =?us-ascii?Q?Tjw1Us1C/vUdeGEFo42s+OqjKoumUYR0GC0rEu3+YUQwPoxRwqxIavgAG+ZM?=
 =?us-ascii?Q?Ce92ZYGnJOYikQtlXnaq90s5iBBUHMue6GTeSwYNGBdoTtlvHYZt9ecFBPKv?=
 =?us-ascii?Q?JUpdPaMowejw5WoSCL/9GQd2Cy9QcI8reBPHDJIMHWMwSPTrkogVvbf/axvx?=
 =?us-ascii?Q?pLyR9WqTA5vK+CvV+arM5XrW3GSEO1HUF9Shnf3d15Uu83KizTO/yqohUrpD?=
 =?us-ascii?Q?4T71guU9t35NfxHI3SU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e6f54bb-a4ef-41ed-64ac-08d9d20269a5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 17:23:25.5099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iL5115aFGPCHEmFA5Toxws4BV9K9p2FnnPH9KMIltmxFnmpwH3AlzIUhFLYvMigq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5240
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022 at 02:01:55AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, January 7, 2022 8:30 AM
> > 
> > On Fri, Jan 07, 2022 at 12:00:13AM +0000, Tian, Kevin wrote:
> > > > Devices that are poorly designed here will have very long migration
> > > > downtime latencies and people simply won't want to use them.
> > >
> > > Different usages have different latency requirement. Do we just want
> > > people to decide whether to manage state for a device by
> > > measurement?
> > 
> > It doesn't seem unreasonable to allow userspace to set max timer for
> > NDMA for SLA purposes on devices that have unbounded NDMA times. It
> > would probably be some new optional ioctl for devices that can
> > implement it.
> 
> Yes, that's my point.
> 
> > 
> > However, this basically gives up on the idea that a VM can be migrated
> > as any migration can timeout and fail under this philosophy. I think
> > that is still very poor.
> > 
> > Optional migration really can't be sane path forward.
> > 
> 
> How is it different from the scenario where the guest generates a very
> high dirty rate so the precopy phase can never converge to a pre-defined
> threshold then abort the migration after certain timeout?

The hypervisor can halt the VCPU and put a stop to this and complete
the migration.

There is a difference between optional migration under a SLA and
mandatory migration with no SLA - I think both must be supported to be
sane.

> IMHO live migration is always a try-and-fail flavor. A previous migration
> failure doesn't prevent the orchestration stack to retry at a later point.

An operator might need to emergency migrate a VM without the
possibility for failure. For instance there is something wrong with
the base HW. SLA ignored, migration must be done.

IMHO it is completely wrong to view migration as optional, that is a
terrible standard to design HW to.

Jason
