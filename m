Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DBB3B2E3F
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 13:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhFXMAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 08:00:14 -0400
Received: from mail-dm6nam08on2072.outbound.protection.outlook.com ([40.107.102.72]:62459
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229445AbhFXMAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 08:00:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDnDn6Fqs1ltZK1mdDN/5sFSDJK87G+k5S8BKoIc13YklHItNkTWybyo0DGv6E8V5dOPywqQ/1F7cRXQ+jSN40plArXsEGXAdhI1FD+nvppItjt61sjaiSeQmUbRopzByRzwvePTIOlnf8i/7D8NwKrq9iKpe15uQhHpbe+kz3uTS4r0SV7razWWNG/6fc8jaR4luoHFtrVa0y2pAyBzuc7+6kHfD+90gwgv68HAabMj53tZBh4AcIotz5bXQUNo7PG8645NSZabzdc16ySyVxG+Jd2CPWRPI5rZjTRpskwOhXdUtfMYKGaYcJzBWGTirzAPaIBE86XN+E77+gac2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPhr5JlBLH4PgLVt3KEY8pZKbvn/OBiQ3RFlarushGE=;
 b=IqxjVZz2vCpTFxFY3PxQaXnSdbLjFzlhzTtYNDtmtlwXqSjW/d8/+AjPh70k0B7U61J1Y4IES1jKd+Afu16+JVnw3NZTTvWFLQr3hfOWlYAfeVEE5h6uOmZI4Rh+e67Ypl5icWJjDvWLqYGKwTT1YAHCEdGNjCaymiEGibYjGbHYMyuZtqXq3wlfUlGKCRzQcFHDDQFZW/wx/s7PfErQd5HdF/AFn2wxSS8gDWbXcplzSfVODfidPlSYZgYrjWwkOtA/9KH8uqPGUbZUnFj3ZXT+JAC+pOJXOjm1whPwTtacBBm4oTrULoB13QE8o1cwP/Rlew775S0K/jcTb+KkUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPhr5JlBLH4PgLVt3KEY8pZKbvn/OBiQ3RFlarushGE=;
 b=Rhhs+GHFL4sMaJudAeOKW2Umbb83niCki8hnCEBSjo9anhM4/ZMBmR3jyqbEdrZLRF5mk7KOagHbfn7BXAPPS5aBOFf9aIzj9wT5rQdIqpowb9exg04XUN43SlwiB4TKrZwkZ+jmgUMWAud68Zxv8rd7ur23Z1ugBeX2+RWlMoinvzu5OOek7TBO8rTbD37HBF+FG1XrUbh0OW9TRkToVrfEdLm7P7BGph7k2QikOzx5pezBHnfPs/F78NvIKqppQAOFER0iHgnhOu2YIhTxNumaZO2JIVxkhAjHKlfxz8wN/EAAozUlEVXq9BnlEYGXHXQol/dQt2pO43FklXVCDQ==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Thu, 24 Jun
 2021 11:57:54 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 11:57:54 +0000
Date:   Thu, 24 Jun 2021 08:57:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210624115753.GP2371267@nvidia.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <YMrXaWfAyLBnI3eP@yekko>
 <20210617230438.GZ1002214@nvidia.com>
 <YNQMC4GcV3gxjerb@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNQMC4GcV3gxjerb@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:c0::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR05CA0020.namprd05.prod.outlook.com (2603:10b6:208:c0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Thu, 24 Jun 2021 11:57:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lwNzV-00C1hy-4l; Thu, 24 Jun 2021 08:57:53 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ab36d9f-4202-4465-51a3-08d937074cae
X-MS-TrafficTypeDiagnostic: BL1PR12MB5285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB528564F69E490C9008501AB6C2079@BL1PR12MB5285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uoMLoQ+K9HqTFW+dsgbCqrl2w/o6n19+IPMGpnkdj7TsERljKNT02FPoiDZRtqa9lgfEduL5t/XhRK0SBvA5ujoEt6Nukc3vAUrlp/YiAS1g8qRX8Cur1Oax1hHQ1VZmKbDAeRForBI8f7TODxD1gm2pZT4vJq436LVXopleAtU4Obv4DZfPi/4C2Fj8j1OScB414B8ClLahNSrLN8oqemHtZr/Ce92+qwQOzbrIE8o+tqnb8XB/nBfmcAdzP9V7UZ6lZ0kEvMGMbdDP+x+8rDkZ9LdtYeBDMlaYGfMyhobkm7OU2rnOgFxW1LWvR+uEkN+vHn7nLotPxt6yxkp4ETqdHpeVrzsNy4Os6WtLihCNoTTf0lBAgHhXvlzoZF3TLpct8PuwtvSCYKIRGTwP39IWumkTbRyDZTSotJK+DDV8C2GH873cXKvMbgrtpxJW1pyQL6NsNV67++aUPQJD/E3omv3AZyHCCSrbfBr5/7Xr4zKmtHAfJ91ymCofVf5/SLXKMndcyZFSRDWy7w6dSQNXueASXoV0T6a98o+oxnMdsCZ6ecMrdBJwrbFaOdJUBHL18fPRu7Y6cVwSNtSJefBjrIfpfX8PGC47pttUfgA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(4326008)(38100700002)(316002)(54906003)(36756003)(9746002)(9786002)(186003)(478600001)(26005)(2616005)(7416002)(6916009)(426003)(2906002)(66556008)(66476007)(66946007)(86362001)(33656002)(5660300002)(1076003)(8676002)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n2f1wyRcp92j+OiaQKaiTT+YzdBaLT7Clzyucqyz+P0ObMXxsmjkKOH4yxsZ?=
 =?us-ascii?Q?ZXbtJcl18MofWWsrev45ARIdPK5LcuwQihSR1VQ+7pOlmEYaIXEmM0esNck4?=
 =?us-ascii?Q?k1+fS87/gc4EyzwMOpx0oaemGfEgq0iYzHr2ZDdrWzqe5MBhQqUsCardzmKL?=
 =?us-ascii?Q?++AAdDLlb7YVphUNfjKum7OKWTN48ehimyJo+CjwOskMfgj+bWDZ7ysV9kx6?=
 =?us-ascii?Q?PkzsOy2Cmuu44eI695W01CeJEzFVpzYDwOcyjOhPKV02VcDwKn0VjqIGuzem?=
 =?us-ascii?Q?kmpE6C33zKKZL8ClRGHDIhXSH396n/ynSMmyqQtCMrkVgo9C4J2jE+8NExCY?=
 =?us-ascii?Q?1MqfWxqaY2kGdEwiD39P86f8y36Tr51uitKmdOBu/l2mce4wA1d4c1uGP81M?=
 =?us-ascii?Q?FjEMRxTtCJFEO6N8OuJCtwzSZy34h95YJ+tDbDs/mv9r5E4p0NVQz76gvypU?=
 =?us-ascii?Q?5X353XjGx/ESWlv7J4xF4s6OAYFRIItTyDZmdrc6KW8szZLQGAXouYK+tXhy?=
 =?us-ascii?Q?ZUv+btY9smr3IOAK9w0p4xTCsF3tD2zwALz1LGlSCY7LKhbkHY+8zPjATxap?=
 =?us-ascii?Q?tdwR2K/uqJ/z9YOAB682fNJPmFAOk1GXhVTzita/NdLgRb/VwSmwcLHL7S7X?=
 =?us-ascii?Q?t2yliYwgzXjM1reYEPjFGzSnhilqrT7lZAbEhncJv+attON8fzZ4JWUahW35?=
 =?us-ascii?Q?CWWFo5W0/hjrzRRsiyMN7eTdhIugLXj1kzJp4yff16SeEqk/LyRMoU5LMAoZ?=
 =?us-ascii?Q?xkB0+lJ3NjvrdowrRkLxrX6cvBGc1o+yBjQiMgz/wwefpty2yVB7O3ljI2cl?=
 =?us-ascii?Q?kKeHspxIDZhh7XVK0oXNxtHxFSzlEfnhZV2QQdmiajCywWbKGbjRbXE/TWEE?=
 =?us-ascii?Q?jXKcbWDK59CJEwcBobZODtStotUlF6VoLlQquGo10QSKxwiq07Tb7zv4NC07?=
 =?us-ascii?Q?85f7p2seTBXi7G2kVy4xq2Ip/zyK0tc7mU6bKcpKhaimQoPm6RjBrxW9PQkm?=
 =?us-ascii?Q?XYl76wONSg2PpFWVWL9TdQdBYhtIQMLoJJ3o9xTMF3LV/z9UigQ8X+igNLnQ?=
 =?us-ascii?Q?p8dAzZdjK0kon2ILyNBvP8/PCuNCdjQP78dTAtcicXtShV2/oTZT+snqx9/H?=
 =?us-ascii?Q?IufdWC7pfXuxtBE+U3d/AjYjsikDLN9lTELo9YOhmnwpCJH1qpqdnMjXVE5+?=
 =?us-ascii?Q?BWs/mfzV6Z9BkQ3NIVWxPENZZtwQxpcwUgBgTZ57oK8+m9LPsD1gckJSCG4e?=
 =?us-ascii?Q?hs8Zz28WAh3uoHgF82eItszt9OjODtVbH4ZSG/Fsxv/xK0Esepp5fF9Rzn/0?=
 =?us-ascii?Q?jHCVYJJv3CwqyVyGgt4chMlh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab36d9f-4202-4465-51a3-08d937074cae
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 11:57:54.2508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jZ6847wtZORVr7xk3nz3NAmQu3T+QWD/7RYrHsFFHk+CWJDul+B1VaFiPS6ngQAk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021 at 02:37:31PM +1000, David Gibson wrote:
> On Thu, Jun 17, 2021 at 08:04:38PM -0300, Jason Gunthorpe wrote:
> > On Thu, Jun 17, 2021 at 03:02:33PM +1000, David Gibson wrote:
> > 
> > > In other words, do we really have use cases where we need to identify
> > > different devices IDs, even though we know they're not isolated.
> > 
> > I think when PASID is added in and all the complexity that brings, it
> > does become more important, yes.
> > 
> > At the minimum we should scope the complexity.
> > 
> > I'm not convinced it is so complicated, really it is just a single bit
> > of information toward userspace: 'all devices in this group must use
> > the same IOASID'
> 
> Um.. no?  You could have devA and devB sharing a RID, but then also
> sharing a group but not a RID with devC because of different isolation
> issues.  So you now have (at least) two levels of group structure to
> expose somehow.

Why? I don't need to micro optimize for broken systems. a/b/c can be
in the same group and the group can have the bit set. 

It is no worse than what we have today.

Jason
