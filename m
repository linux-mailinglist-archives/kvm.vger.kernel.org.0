Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AF33AD22F
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 20:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbhFRSdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 14:33:07 -0400
Received: from mail-dm6nam11on2082.outbound.protection.outlook.com ([40.107.223.82]:23136
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232417AbhFRSdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 14:33:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tz1S7fZo8lpLzzv6yZ/6DAM4pSu6xtkMdY4JGVIjRczTlRrQNpr9cAqJY4nzlzfME9MMwvSwIBAug362BqKjFVOMej9pnoO8TyoJTi5H/x/2cqb0DZAJCmRJ/SHcek/aJ3qgCAgCzOJ+mQd42cAvapVAVD3g1A/cSHIPxqptHFT3lHGfV5EHcc7j0kkF20Azb3cf8bRZjfSC/TqSMJLWqxhPMFdqrFGRSVs2GwgqqT/VVGy8n36d7S8FDFXtiD9eEzihzjvR2LHVToVkyQ0T8s1fxMsT9l2oK9fTL+YLfyCgIl33J7AuR3RzsPHag5znSkVY1uDVvBx70hSUbwQgLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OR5T+y/NAD0PGjAr0NZaI+3HHlf35de883ru/kMTFq8=;
 b=KhMvMQHr2I/A3VNSV8R+PpAZGaUHBdKMRdbXtUn0sXuIUPIWzj9FuuEnLzY0zEY9wOYhx8veC09n+B/3ivw3sU9FKVmCNyoaKTlPc5V56At9wIFgbQF30CxBAHyfI5LY9XuEb2Y3GwehBanWefWs7HVJloLqqAOmxumkzGwhar7sqFkumsq36KevNDlMQPc/3PLgZrO7IQ/0yFz8NJJ4JrictgT9qg6HuuwPT6eEknj5KKCIeC/Xl1MQyCqfO5WRY0r8lz/H607TB4jNgiyAVaSP0kCzkJUS5Jy2ZEWJZslv+zI2Ny0Dto8+zYAocFWl23Hg0rC0kgRB7MJVnJigSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OR5T+y/NAD0PGjAr0NZaI+3HHlf35de883ru/kMTFq8=;
 b=qOEg1ng0gSXoDZm6at/l/q/ubuLjxq1OAvSv8Pvb5PKv48RzbKaJ9PfxbS3zRC6qls2TpNBcidz0vsVxpbtimVoaeKA5QJbxe/xqc4V9I9xlYdMgiZBX4ShCRWIacHXTsWXsc6WCacEwLJDD5vHnIGVaIW9Jb6r+JpVFO5zbBgyBc20otfgwbARktaOQssmJKM466TO2pyl0tOjI7K2qGFI2wITjFb46JMqeh5nJVQZ+0cDvzT1ksHu8/ivDDPLYtZJPH2m/RNDatoet0k9yQqBfQ1dxzatU/OIMTcz1DnJgaryrNDw6y8eTG0Nr4RgcC/bTtVHfBLr3QhavyAZLTQ==
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Fri, 18 Jun
 2021 18:30:55 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 18:30:55 +0000
Date:   Fri, 18 Jun 2021 15:30:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210618183054.GK1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com>
 <YLhsZRc72aIMZajz@yekko>
 <YLn/SJtzuJopSO2x@myrica>
 <YL8O1pAlg1jtHudn@yekko>
 <YMI/yynDsX/aaG8T@myrica>
 <YMq6voIhXt7guI+W@yekko>
 <YMzR46luaG7hXsJi@myrica>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMzR46luaG7hXsJi@myrica>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR0102CA0057.prod.exchangelabs.com
 (2603:10b6:208:25::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR0102CA0057.prod.exchangelabs.com (2603:10b6:208:25::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24 via Frontend Transport; Fri, 18 Jun 2021 18:30:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1luJGY-008dZ4-BP; Fri, 18 Jun 2021 15:30:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07437728-a578-4cc5-322c-08d9328735b0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5208B31DD78968697358394BC20D9@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ngsFdMwFaWSUgkIn8kO94Cl8SfGyTGPN1w9Ugum8GYXtf8ALgAR62VIianBMJaylU3tKKf/km8U4Q3kBm3liJ4xL9TU8Y/LRk49yOJ5BkEg0CE/HrFmmU13YtmSHAtF91+7n2ZPdrtJAmpXQP2K3wwVyVeg6HT4YSX8E5/HmaodgB6efqpfJ2wY8xQVjRifkxuK+d+BUrjNSvq9ttPfxuYVXPO4H/cE5NK/OGrtIUKOZa/cuGOR6hfGmRubrcX2kNNiYFlfgmGvO436pZSX+3ZiN4olxuRODWybNHBnyCPYlZJQP+tVSQ/r+7pOWzfn2nn9vjWsj5lyId+Y62geAHHtIXyRxG9E8hV2rz6dexAT+EVigtKQn4rSJDM8161Y7KsppZ5IaHFRRYdpmMs5E8VgwQSSHSSm3daldndwvF8JtUioZzymhWkkA7/Rzs3X1PUGMWurLai/wfpy2nOHKBCrBBlk0+raUqF3gY/SxCT+dwGfuZULUG87BRm71rZYyp0Sh/ueul0xEnf8xlXMeiLTZ3j0eeHrk8THqJjmHE8KJflFAJLXHZ2h2tOPbvuEjBOfUpLIpXLrnOU39cWtcjOjuIUb0Lf/mKNLr7UIJlY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(26005)(2906002)(4744005)(5660300002)(33656002)(4326008)(83380400001)(66556008)(1076003)(7416002)(36756003)(66946007)(426003)(478600001)(66476007)(316002)(38100700002)(9746002)(186003)(6916009)(8676002)(9786002)(2616005)(8936002)(86362001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bwrcktxy1p4mv4iGWOVlza8pQhl1I8NRcz1JLp0Ri7A+vz3vKCvE5ExYmwkf?=
 =?us-ascii?Q?rdREx8HbT6VlIN6zJMuzqL4Rx62Sw978FvXOK1BN2Ene7pBZuCqMUteuJtvR?=
 =?us-ascii?Q?EsMdbKLQPLFmqAgQuVjN3Z70jmAVypiQKigzCpztjpYXJmd5vobrCwTMImGl?=
 =?us-ascii?Q?qoOHpGipBHUZLFbB6Z7/gBDY0ozd5/AA855LPuFt4BSkK/Vj3+rX5Aa9U/im?=
 =?us-ascii?Q?ZDyJ9StpM07dEXIuiJAF4SMOXxDo6sGnE4puqbc7v3uIzUry+jvuaA2xAIKZ?=
 =?us-ascii?Q?AIVpN9SAD4EAH+IFV3QaIVGDuP/qMTGXZpW9MNQ03t1tJ/BDHPKNYCRGc7cO?=
 =?us-ascii?Q?M6+IccURRzPmLgqKKaUifRxJqgm9nNWVNVlFl8W9HeOSdOfGovNYongzZf+n?=
 =?us-ascii?Q?ed8FVTQpGNi34nW3A2DarqyXd/70Uztksacc4q+ZzU9hmwV99/X3Cj886Uhx?=
 =?us-ascii?Q?b2C1PanCxZekD/5WLn2XRIku3mWUzHOh3CzNFtvjz9SxLIlfbYPyTHoTlQQY?=
 =?us-ascii?Q?P+xOhA2lt6IVT6Q1OsEPfHuFC4LV3h1VfyjoXGGttfItMNs5fk3zY9rzVszG?=
 =?us-ascii?Q?fqrVh6k1fk4kGtBRcp++i3J6G2/6eG/CUO+j0L2/x/pnKGR5GuEtN9trm5Ce?=
 =?us-ascii?Q?bLTbxCZIUIhDFFxv3LvUmJCycwr64uCq4S+7iHrLa0VoyqgTbnAxPXBBwG15?=
 =?us-ascii?Q?7kxLHWzwdo4n6UCVyLwkZbDhzjh8d0R7s78DGs8F45Poqv9jrIMQGq6tjoTD?=
 =?us-ascii?Q?5JtL/W009cs0T+UdpOM4Z5goy0RkvSjVu2QY5QWV/oAmeknuK/CkvmoMdVT4?=
 =?us-ascii?Q?9VBFZceFF7TXl1kljlDlXfERM4B1CVWvTS7dtIgWoISIja0IrHN6omUjKJWl?=
 =?us-ascii?Q?+VvPHXcIjW84LzUAVP2Nd7DfgsN46x49Mkho3m8q6R7oaz7lB0MlDaiK1+9G?=
 =?us-ascii?Q?4iVYQU6P+u6cTGlLBcAUNaW0Ai5dJCGKtBxYVoKyJ32OiWOqMfvuzU2FjcO0?=
 =?us-ascii?Q?ld8DFnFfyvufXblp/Y0Lw1NPjEpIrCfsFYuawXOutkrPn7k0tOcEw/HwsOBF?=
 =?us-ascii?Q?jpQ8sICu22T1fVjfHaJ2vtux1fVmDCa3GFK/q80AhtUXHv7K0aCLg9YrOhUK?=
 =?us-ascii?Q?liRAgxj4kSmugCzanvfn+PYROFOT8nVHbKeuDRlKZyrpQyF9/c35AziFiB5V?=
 =?us-ascii?Q?pmwxv1RvtNI2dSfa15JpCOnaDvCEtVEHteWTR3LC7/XfLmNBNjCfN6DfOGE8?=
 =?us-ascii?Q?ujV6hoiCdwEx4HWFD9u7V6/RguM5By4gOjM3LDMCuBg7Es81O77NlbgFa6AY?=
 =?us-ascii?Q?jGV6s1mWbH13iJg/SwIYwwI2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07437728-a578-4cc5-322c-08d9328735b0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 18:30:55.5137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpZez7GP6TBjMAQhplmzK2HutAeRmEfU5AKQIHcen60tSLS60u41jG5ZvW2F1/LE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 07:03:31PM +0200, Jean-Philippe Brucker wrote:

> configuration. The Arm SMMUs have a lot of small features that
> implementations can mix and match and that a user shouldn't have to care
> about, and there are lots of different implementations by various
> vendors.

This is really something to think about carefully in this RFC - I do
have a guess that a 'HW specific' channel is going to be useful here.

If the goal is for qemu to provide all these fiddly things and they
cannot be SW emulated, then direct access to the fiddly HW native
stuff is possibly necessary.

We've kind of seen this mistake in DRM and RDMA
historically. Attempting to generalize too early, or generalize
something that is really a one off. Better for everyone to just keep
it as a one off.

Jason
