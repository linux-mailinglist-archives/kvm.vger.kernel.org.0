Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CCD4866DC
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 16:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbiAFPmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 10:42:20 -0500
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:32993
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229726AbiAFPmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 10:42:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q56Qq3Ekcz2eaXp/BPQfCb6FXQDkmGTyBJIKrOo//U/oPMx6ud3x8kPUhK7GtSQs+49Q+BX5UXz35BR9XBBFCJwGKu/ygrBYRsPnFU97EIBX3h2MZxR6ymwW2E1pRTmnU4hEwnyE0bHLZbrIVmh5baJQLMTrrQ0WzvHDhI9jFpNAWGN8NrZPjLTqvWqafQe3PVvyjfDGciUqY9/VrsZz4Pm2kGYd/T7x3LXMyxLgimQWbNn7Ad7gUgRlTCNWKEASnoiFdsGTCCM6MjoreIFQUXKm6SaH2ReHR3qBo/mov/Qsg3f/Y2krzKPd0UJH4pljvJLxPNoUknrEGUnvF1ePFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aw4Tw0FgWkm4+3YiOg1VtJJ7AKnJXxYqltea4tcT7wk=;
 b=DK2tkwV9wlqO5LBs85Z/IKbMhtvBHvzeUcVkT+0sYs8Kd+Sj6nc3K8FlASM4OFncMu6P0Hcl2WMiBIUtlSDn75t1ktKE/w0zZSL7MdrjK4O8zkLDbKe2OiArDERAQmbEOuIQ+MCZgf1YdPHKw3UJjwKGPGn0l/5MA6TtBcYNCbjt3ewAg/kgKazjuE1fUbgKALoT7yEIdj0x98XCfbb2dHI/vg06TojmWOOu3qqD0XAFPP+9t9McKu5Fn36wEKkPWLp4utyMCYZgEISEIyaVXsAmxnkzlNWbm5lCCuohElViukuHcjQ9RUCbD64keL1+/Qeo5Gop9CMRu5yB7eLwXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw4Tw0FgWkm4+3YiOg1VtJJ7AKnJXxYqltea4tcT7wk=;
 b=KSVYat9QvXGclcKqegnMebM/zznLTfYBsEKeXy1PrZW9m5MNcw1IzJrXh40kLczB5Ma5B60BjRfPT65BPT+0GgVpgeLTDqNH9Ic4Ydsqd7awbzGA7BO5K1Rv+rAMXam4O+t7LLNhu1JQC0aOK8yB2nRTEc78O5QIYV5iegkTdLV0BlgRJ5L04gWiYN77pRplLMUh6S4rnAQNv5x5BPqHA5TYWrCkwXZ/0tkS11xTgiJLelZZDawQoNE/WZ1WuO7/Z6SLyWEVt75ysNCIMYuFhBam/3IJ0gkmiZfCX17W0RKsojf8KL/I2KA8JIByACXGhJa1nRXLKojcLGrJN0p/nQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 15:42:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 15:42:18 +0000
Date:   Thu, 6 Jan 2022 11:42:16 -0400
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
Message-ID: <20220106154216.GF2328285@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220105124533.GP2328285@nvidia.com>
 <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT3PR01CA0089.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c38111f6-b764-45c6-c880-08d9d12b1f2e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5189:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5189B3174538B1B396619964C24C9@BL1PR12MB5189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DvDRfmM/lCo8oh+A+AD8ePXcr4tID0DHUBb0jJSxkLErKT2/1UB76xPNExNWpX/0Lx9/XrP+llijus18DARxEtXMPDzW9UIBkWqR8cPqLkEHqD1nSOm76ht25WxA4nrl8cWzegO8HmI6jlg03blLUkf4Cug3Xb7dM1IMR5XxkcD+DbF3iUy4qmptbtLyEbiC4PTYjUjs3ap9QK390de5zYjkA28WYoVtwFLcBML/E9xOf9RDy6fGSsWGqpL4r3ureJS+wZ6nRzlfkRRpD1C/Qy3PjRU5Dyi3mhyO535NzLlPROLrM99zMFyncb5YjXS6jucjO2wOIHt9fdbpo3qUKRb7ReZ89voA1R5PtgjShFtUW0YqGsjvoyQr9/cUING5oRiDgkMRxe0ICuXvEHePoeTF7SiyUtyAAQGxTc++mukHc6yzlS/1O5pJT7M+EOekc4+U3CPcGGuq4pYL8P6cSTJdZF3r4m6WJBQk2cy+78s4hhEuFv0i/sMs7HShvkx/JFY4OKu63/l20OH/yp+pm5w4jEZ+SfzmPWQl7IXmSJYkknf75Bv8XClpiKQk57YjMaZmbZJRPvmw4YQ4n7q0g2kkXJ5N4+xqInzvAAkRgk4SaQuXvexc1YohELHS+QcA4KcBVNnsxuR5TO4CpslCSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6916009)(38100700002)(6506007)(7416002)(508600001)(8936002)(2616005)(6486002)(66476007)(66946007)(66556008)(26005)(6512007)(186003)(86362001)(4326008)(15650500001)(8676002)(33656002)(2906002)(36756003)(1076003)(5660300002)(54906003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l5wRCC4FxjbXx88eSbSLCKD1ClYXoEGs40Hk6EvL/ELmaRgrvQ/KpVY0M+1r?=
 =?us-ascii?Q?QEGZ3BR2CtNoDKTA0rK89k9CmlsjRtCDl1Jm2R8k9GdZn356AiFgx7rH5hSK?=
 =?us-ascii?Q?EjcFHTLGvjk7/KY5mskZG+m/2UPRT9Be0l0uodh9dmLo+reuqGfhGxTDr5YQ?=
 =?us-ascii?Q?hgbsAkOteKZ0jKzTLPldgn/wSXCQNa08IQf3YvbN2T1ENaELrXchHvcZ5nYf?=
 =?us-ascii?Q?XoeY+rTSB/4WQJ5DAzhs5owm6w12pdx0TyYsFS+4chdLV+HonsMP5RVdXICn?=
 =?us-ascii?Q?44QJlPd4TyCCRLRCN8LPFOaJfHWwe47Yjur4XnwWv3Nl6INFOBTbPqmwSaCH?=
 =?us-ascii?Q?TqFB0QshDSiTh4BHViPaO3VwJIU0Ffq5ZMycXF0a0pI0Xv48pxToHPUxcgJp?=
 =?us-ascii?Q?UtRHgqIzLQy2T9FBStGkCLOkCyCQG2/Uzpb6moIIebMH1Mi6Etd4+njAGym4?=
 =?us-ascii?Q?o8Fx8c8VPCf6SiDjBrApTjyyXYNfiRpzqkxndRUb8GKSQ7ZMHAesgA9tGOYW?=
 =?us-ascii?Q?4mSBmr+7XojouwBTpX5R/gif4mQBd3e1119aISkblWkF/g6kHIvxB2OaG5yy?=
 =?us-ascii?Q?Ai89kvNPgzP7X6+St/cxOWzMvH4NKkPrm6YaMS6b2DhtRol8joX5vBxyZax4?=
 =?us-ascii?Q?cMyTc5C975VSi8/E1DIpCzLvNS51mdt1RZQwcs+kmO7ANuBIrBzXHPHD1Lbg?=
 =?us-ascii?Q?AFOJu7VuFSaSumUxEp9Fl3ORU9wL5nLMDA7dBz9okTaSmejHDykYl30UkiIL?=
 =?us-ascii?Q?YgcJMv42e003hho1aJvnA39xV3awvgS6scIJd0y3wZ5TEFrd2hcG6SHTqdq2?=
 =?us-ascii?Q?06mV7XERqYIAGNGuJMOdneG2MwV4YIcaK4YsoiIU0pPro1YbFF5GzKkDPLkl?=
 =?us-ascii?Q?CY82cHHmDaG4HMP4TcBv6pt+FQlV1XVZPXgoeqKzSFb+7+pI7nj1LyPL6crm?=
 =?us-ascii?Q?Ahqgbqj1K7sFRm/91O0wx5YlSkACPOPCpIuMxxT8WfDiyZQzf6uiwXepGomy?=
 =?us-ascii?Q?uYTAWPPWGHucnSLL9Ed8Yrqc6p6pLufxaRymw8UZNrxtdbRxcvK+YaaVQGkE?=
 =?us-ascii?Q?WhgLAKwui52HG8LMqe7/+yjP0TiTRub5YzUJyZFDfcbByez2gLm886TuUoyM?=
 =?us-ascii?Q?qkq/dQUKjx1pgB1nES8ORwJ3G21rz8zwrDzcjULnNbdYvt1g/CV1NkAVykdQ?=
 =?us-ascii?Q?ilsGUM3E4WFh9g5zs+srdy1sFaIeRI5GA9SVeTQJwQZ4aEPGkehd1QUnNR9D?=
 =?us-ascii?Q?dwXJXJvHsJRdkIkrXWwwrXuG8ZqgDC4BWO48VrurOtyUZFO8zzvdI62URUNu?=
 =?us-ascii?Q?F+7PaUJSjC/+Hy+bf6OZVHHt30quCk2IhM3pT5f0KwjoXcA5dNCw1mgPMH8C?=
 =?us-ascii?Q?sUVIc0iQAaMmM4kftPorQYtL4txRw/RjhtQKbZv9af6AAw2Sg0twLcXOYOhm?=
 =?us-ascii?Q?/R3QMI5LSeZLFiGlnFtGlv6/jyl7Cg6T5d1IVhQUhp8GK+GW8Jnmsp5drklH?=
 =?us-ascii?Q?Pef0480va33YkjWqg60TVWMaj6kMBS3KWkjOtd0dEbDPzApHJrIoPlIfl9Wo?=
 =?us-ascii?Q?/hhKUj/XDCVavIc9YcI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38111f6-b764-45c6-c880-08d9d12b1f2e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 15:42:18.7687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AS7Y/mz6RQF6Ju0GONPdTKHbfJ4IAWKshC0AjhiwoUGPmfY1M1ig7DKKF4pAWerS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 06:32:57AM +0000, Tian, Kevin wrote:

> Putting PRI aside the time to drain in-fly requests is undefined. It depends
> on how many pending requests to be waited for before completing the
> draining command on the device. This is IP specific (e.g. whether supports
> preemption) and also guest specific (e.g. whether it's actively submitting
> workload).

You are assuming a model where NDMA has to be implemented by pushing a
command, but I would say that is very poor IP design.

A device is fully in self-control of its own DMA and it should simply
stop it quickly when doing NDMA.

Devices that are poorly designed here will have very long migration
downtime latencies and people simply won't want to use them.
 
> > > Whether the said DOS is a real concern and how severe it is are usage
> > > specific things. Why would we want to hardcode such restriction on
> > > an uAPI? Just give the choice to the admin (as long as this restriction is
> > > clearly communicated to userspace clearly)...
> > 
> > IMHO it is not just DOS, PRI can become dependent on IO which requires
> > DMA to complete.
> > 
> > You could quickly get yourself into a deadlock situation where the
> > hypervisor has disabled DMA activities of other devices and the vPRI
> > simply cannot be completed.
> 
> How is it related to PRI which is only about address translation?

In something like SVA PRI can request a page which is not present and
the OS has to do DMA to load the page back from storage to make it
present and respond to the translation request.

The DMA is not related to the device doing the PRI in the first place,
but if the hypervisor has blocked the DMA already for some other
reason (perhaps that device is also doing PRI) then it all will
deadlock.

> Instead, above is a general p2p problem for any draining operation. 

Nothing to do with p2p.

Jason
