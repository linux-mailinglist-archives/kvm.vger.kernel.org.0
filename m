Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839B5528D2D
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 20:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344972AbiEPSg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 14:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344966AbiEPSgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 14:36:01 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA40139E;
        Mon, 16 May 2022 11:36:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBmuFoa6OAQRXJRvkN3rCCM9fYorcVXD5TAGcftEuXJoGW8HBOjVBIyWbs5nornagIpTEVVrxOt3tFqm7PJvhzla1ZfW33GllMIuE8y7QmWIqRzwXHqUSugmYIzxTWFfmWUNq1vfFj1Q2bfzEk/Em0HVHlm2aTwa6cy3M758Js9nBgG1YIvBdfhLDEhmGgGI1jnlyRdLjMe70ECHXx2Rs9tU2USsP2RHceQAzsEdxcUZGtUggDtRzmmKWeRU8TKiCtoXbOHlfMsPdQ0OAH/2Jywo4+Gi45lTSjZVbgbFX5LuDq+GcyLOvi1f4FEzcXKEVqzoZVslnUDsYTbEK08mIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8iVmwjGyF6zhpgj5KLlxn77wF3SUe+MUC08qBN1KYM=;
 b=KV59LgvA27P1Tg7K+9ghqaBFuT/urydHUSSWVJAxXSue6ttXGHMqYTCTnLZDLEXniCJ5+ucLU4DU99yEiTEFIeaoM1MtTmvfuymRS1Oyv5fm8Mn9pZyfzj7+2qvDMK4hbadLS9HASorx7RD05lF+6E4scRgO7eYHTnXLyi8TNL2M3sImgdrJ6ckuNUhOa6oFGiJv47eRs+5ItfbCpQdD10V9AVBPqRwG4VhKYb2qopYnBA44+sDRyCVOMPhSn7hzt3DGKp34vo6JkHlJzoe/bTAlgitChjb5pC6wEdz8uMfI4YeOeZcu0HK5Qsmmufl847RbG82d50oO9yWiuaEOtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8iVmwjGyF6zhpgj5KLlxn77wF3SUe+MUC08qBN1KYM=;
 b=ddD/6sDW/gIhOa71URs1NgoPTv0RWxNFrGMKLhns9Rjrx4M+6hvTlE2REXqWUt2p0FXW0yC7Su6RUplYVi48xxQAfzQsmo5xzda/rNoJQF59Ren5B7HeP8i5wgdI9yLl4A7PcAdYOxAXwQGUkia4Q17PYgRKfenhnPca3ZfF3aMCjaH0J8py9SNBX6JLhqPxHItt6jmoAh4OLxDcYeyNjra/+8JYU4Y+0VDvdsHOq8ALWy1EcY1xgvBZExyJGM58DrLuuq0Aj0uezDsnSv3e0n+EWqrIZj8MQaachbeurxaG/z0d78E4YNfDbOmTTLW7iIsj/HpVEBH4wjJDFgGCRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3275.namprd12.prod.outlook.com (2603:10b6:5:185::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 18:35:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 18:35:59 +0000
Date:   Mon, 16 May 2022 15:35:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, linux-s390@vger.kernel.org,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 17/22] vfio-pci/zdev: add open/close device hooks
Message-ID: <20220516183558.GN1343366@nvidia.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-18-mjrosato@linux.ibm.com>
 <20220516172734.GE1343366@nvidia.com>
 <7a31ec36-ceaf-dcef-8bd0-2b4732050aed@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a31ec36-ceaf-dcef-8bd0-2b4732050aed@linux.ibm.com>
X-ClientProxiedBy: MN2PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:208:c0::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 235b7883-4e06-44ed-f263-08da376aec14
X-MS-TrafficTypeDiagnostic: DM6PR12MB3275:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB32754A40164CD889EA5160D8C2CF9@DM6PR12MB3275.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/o4rNwvGe0jp0MCzMmcry3Kw/nkxqYSKKpQUVmP4MVpNPjiZGnLtRCBAy0LyrQEG/z/wM+kkIrs+zS+JrWOgxynu7vFXH8hO3DUCYeIbwl9MjH5EM3CJ2DqxMKsu6Mo6Sv6BUH/d8iGoEC+UIEd7mTBTyutDTaRiX+AsQJ3hjoKIyCCnsuFYcgQdUZ9f0hsYoaoJxxTQlqIfC5JKSec9GNfWKvy5ZjnZU4Vu1aA0Cp4Zmrs16lTwynunXutOs0Q73G2tz3RkapwZ0zbrlXtfPV9T7H4JjS7jAjOTxfutvFa8/cH5A8qYZEBiqK3GqZSF30eUFiqna/uhFSCGGOBKWYX2tb5aYWOjE96OwDYpcBkFaNiGK2nDiK7rngdDdO6Xegz3Yjm29p77DWn/ZI4GFB7ipLG/4E2NymI19fjgwGCEqoluzyo7lVbEqPhhvOhJHMFrwz3YqQsowtqD6cqcct4PdwQ3H4rsDPt0+5T2WkQ+wQxC5jXdD1rdfjLd5m4IUGOEkmxl6wEL1wHFM9o6rzzTW3rtn9WjKY9Oy/l9W3A41N5nVcvWA7H+rJC761YW9AqxDR8J1K664/mET2E89i/NWHIVenAYPRRNgw3XPo0UWhSbRaWMo59l2nAzC78rZV/2SR36wL+DW/TnXiBVSVuLKmJqlxtgkvKXr1/a9OVsnWd8YpABOfs7dw6SSAoqoDifosVNVtX2yc+XpS6jFROMJpQpqwAAzfos66IP9Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(83380400001)(36756003)(186003)(7416002)(86362001)(5660300002)(2616005)(1076003)(966005)(38100700002)(33656002)(508600001)(26005)(6506007)(6512007)(8936002)(66476007)(8676002)(4326008)(316002)(66556008)(66946007)(6486002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pKl0JzoeP7NQ9Ks5YKtslzPhbPnmqGQiP/Zt0ptrT0xGDV8tjkQLlSMHH8hA?=
 =?us-ascii?Q?bV/mfNT4vM5pJIN2L/g5WD5Z2NIl2aQ1Av13y17GhWxHcmj+k1q3eMNwcWJQ?=
 =?us-ascii?Q?QuKUP2PmfEoLgBQGcl+jioAgBOIvTBI7V54JIgp1aKWOiL5GK+QlaruRpGLf?=
 =?us-ascii?Q?O50aPGR8ai5rXRj7wp789N0zsBRi2L73SeZZry6byVr++sOTDPnfSgryMtS/?=
 =?us-ascii?Q?FHTGyHB1eth8xL8BB5YIQN7QI/HP9DMk+rH6Ney0E/usifCeZiWIaYinxMg8?=
 =?us-ascii?Q?P1sJWf65ZrasfcSC9pc2Sl0lQYaWsffrpLRQQqdOIUTFLqsZ5AepEMJXfgZ0?=
 =?us-ascii?Q?u7uUB9x6e8XNCAR/1glHzFgt3D/aZt7GVEypvJJ1hLM04v1bG7M1zpJ6GgZm?=
 =?us-ascii?Q?keHcWG2sX2s0KfDp5ArvbrccAJFDS9wWIYXGWYux9TX94RcpADB3bP/1+x2n?=
 =?us-ascii?Q?q7dDn179j7PybR3yawzaygk/VmaBoP1Q65IwBK1F8qo6pTGLhVfwqHX3Ky8s?=
 =?us-ascii?Q?GmpTWmhB9XZDBR6lNzReqaA9WQPFGg1gF8ts6GKQDnGyk3OTCW1rh4UAKmmR?=
 =?us-ascii?Q?RzqbzegGCAaI65HK9TXCJTMKth9M4Iu8k8K5cb5T43qs8qCiVNmK9JZldE5l?=
 =?us-ascii?Q?lU3Y0ZuTu0pWKCsCriMYJMnN9oKkG9Hz3IAgBmXwXd+0WwDW11+gjDBPORBN?=
 =?us-ascii?Q?joIhDZ4uw+YEtR7v7nXSNitD0qtj0plbxnqMnh7tZg6zFHwoAIJL6iRI7JdB?=
 =?us-ascii?Q?RD6j4NkaWkH8eo5u6LSeM5RudvXPg4pjzFZ1C6m+GsOXZo+MwT3Yuju9qbFF?=
 =?us-ascii?Q?CvXl/S2hDRUHgSIixa6i65Vddd7IFF0Jk9GAZIdAlT4ARsSvpDTuumCoPj2M?=
 =?us-ascii?Q?2Z5+9ulLh+UewP9+DRMl7638Y0/WSf2HkJYKjfhOKr/HTm1aldZB2lEhSTYt?=
 =?us-ascii?Q?7vPgV70o6209VnKaF7PmcqnopAxvy+oIqXl1LfAS6tr4ItaejQga4h3IXuFk?=
 =?us-ascii?Q?loDAowI08BungmwtaosyLQWGhN63HzOGhqPB720nH0+jt+3SlEF/RL+OKsbG?=
 =?us-ascii?Q?m34uyFD13/ilCfA/WkXSXo/Vl6Dytq+9j1m0UEw+DsJ5d1W7k8X8eBe6xd3J?=
 =?us-ascii?Q?72PMk3GgdvrzB+wIZWt4VBPEKRqXYIccA7uyahrAecvRkoKI59UQJAhZI8ut?=
 =?us-ascii?Q?qAnV4GWSDlQ+ZiZowj0R//ZlwVrEFaEuomB6M1RwVM6OU8lh2Zho+qo/otAF?=
 =?us-ascii?Q?cPJPaK4SgpT8jYVQzhha85lY3rkjaBomOwJr7PVJKd3a0QCbf/ayb5In1zOV?=
 =?us-ascii?Q?GSkYMHho6FJua1blUrxFR0WpNDAdVORwigaTlnw4Ks8gIuknTR9Cs8BzOw91?=
 =?us-ascii?Q?mnrwtgLq0Mz7IT7tYRjBcu3XV5Ek2nCmDI5nrgkFEVoemfnw6ZFZF+G1LvbC?=
 =?us-ascii?Q?G1ZSOzk+K+G0KvbKwKOzmn0Vd62vRMi4tbORneJOvujEuU4NHfhORfXVfsSW?=
 =?us-ascii?Q?7lQZ/c1oZTkGid+zWS7f7lHaCJpW/aPsiM1FLMJhhqLGnLxGJ1lPa7klotdP?=
 =?us-ascii?Q?oAb5rmFxZvnKTwo3OimhKAaWvbxauyk3hnSLrTINZFffJ6+gnewp2ixpgaju?=
 =?us-ascii?Q?gy0rer7B9BnFC81A4JN4uDeytjdPFHRcFpMygfV8/+ZaITl2CKbeN8/rQ9Ho?=
 =?us-ascii?Q?D908FpKwc1BUdj/5VEuchHlVOCRQc0/jJy0Z73+GbDcUnwBGptsMAiguCdJy?=
 =?us-ascii?Q?iBuarBciFQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 235b7883-4e06-44ed-f263-08da376aec14
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 18:35:59.5546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57XHv/Kb2WaM09eoyGik7ssfRuhi6c8eQHPFtweM8LK4I1QwIL8xuA+hAhuzYtz1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3275
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 02:30:46PM -0400, Matthew Rosato wrote:

> Conceptually I think this would work for QEMU anyway (it always sets the kvm
> before we open the device).  I tried to test the idea quickly but couldn't
> get the following to apply on vfio-next or your vfio_group_locking -- but I
> understand what you're trying to do so I'll re-work and try it out.

I created it on 8c9350e9bf43de1ebab3cc8a80703671e6495ab4 which is the
vfio_group_locking.. I can send you a github if it helps
https://github.com/jgunthorpe/linux/commits/vfio_group_lockin

> @Alex can you think of any usecase/reason why we would need to be able to
> set the KVM sometime after the device was opened?  Doing something like
> below would break that, as this introduces the assumption that the group is
> associated with the KVM before the device is opened (and if it's not, the
> device open fails).

Keep in mind that GVT already hard requires this ordering to even
allow open_device to work - so it already sets a floor for what
userspace can do..

Jason
