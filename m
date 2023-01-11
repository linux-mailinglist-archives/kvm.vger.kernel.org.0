Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75576664B7
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 21:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbjAKUTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 15:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjAKUTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 15:19:41 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3AA12AC2;
        Wed, 11 Jan 2023 12:19:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ar0hcWSaJjo2rXqsB8su3TdyR2nLcN9Oa0m4WZ+0NC93URYOfKmvvBYF0PO04XtDdhs0xfNPjSdyQk7kiWdVtjU1fXxQEop3H3D92np0K/ISRZd00e0yZ0I0123vf10wpxaygg471OkLhh2hQs5pYiRWG7x4L5agKzoIbiAmo6bV3y03078pS6gLusgn/d91QZG24Z1nQJCLtFEsOQl1HZhwkBpSNLllKfw0FIEc9sxdBvEzbc0f0H0rbJeUriUymfYA7XhJf4zDz+hSfx3vWFbsZ2PxOyqiXFv4hl9h8CKJwREocRcLPp0RtpzzXgmqdZOLKVlzQ9JQVILMMTqsIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvYsyxhm7HO4GN/KSdwlZjpzz0vXoTnV/maM+IFXGmk=;
 b=lgpv3gvxmBjljMGEaQ7s0hUDFUA7umEq0KGoxJjnV6yPVfEBkGzjXbSgot6J13CWYxrbI8h6UuYo6Qwr1v5A/BzqDPCgjOPd2FugGI2VriU9LTzwKeR42IaRokhP2QH9vohSjvxPzljcaB3xK9NzKmtwDhHc0N6rv+epLXJGPwUaWSF+ELWQ75h5f/oDqUaTo3JyOveO0fd7xeCs5+RDXKTQtpT21U5qlnwk4ORhcic17fwPG5ED/tzEZUVwPXXja0Sxo9Icv4Wzu1hcI04LzffGCZHAt/XmNEjA6bvwIRa4YF6WNkowB0HhPh58MmdfW2pqOj72nIHiUbNuDuMI/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvYsyxhm7HO4GN/KSdwlZjpzz0vXoTnV/maM+IFXGmk=;
 b=BWxrp2MVnEWKVm1BRMQmYdZf6lqyk51dggLpBiua9QZ6vrPOYlhvWQACe0xDKqACw4nIaLlNozzqNDIneKwZcZO9Cu0PSMXrb9LGu8lFMGLYZgKuarOd68I4n0okOsgeZFrBdxym6J2ulx889iG4Tk9GtIJ1F+x0n4mA6ZjWsqDyIbFJq6c445lAgMSQOTyDbHyS/WG8NxEQgb35JZjz7Y9A3sPsC3OF6zsNArWa31hl+4+vM1yzAaJEKJQw5fahD9pYnQV2Nfjc9A/U+G6arbAqfL6Q2TO5TJMlKlKelPSM1oZzstJ2W1pqCN4LzLke77W/ZSiHGk3h6e2BrK2G3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7772.namprd12.prod.outlook.com (2603:10b6:8:138::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 20:19:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 11 Jan 2023
 20:19:38 +0000
Date:   Wed, 11 Jan 2023 16:19:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd v3 2/9] iommu: Add iommu_group_has_isolated_msi()
Message-ID: <Y78Z2TZajTrS1cWg@nvidia.com>
References: <2-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
 <87eds1hr2h.ffs@tglx>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eds1hr2h.ffs@tglx>
X-ClientProxiedBy: MN2PR20CA0057.namprd20.prod.outlook.com
 (2603:10b6:208:235::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7772:EE_
X-MS-Office365-Filtering-Correlation-Id: 09e5b0ee-2d1e-4ff4-1a2a-08daf41129b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xtV7SUjFdD/dV4i+fIziAnm1pY9W4L2YLcK7KzkXiuVzLgLkAievdrHaNHTiPWIWCab9drPcD7qvRMG9YIxJzG9TNpPd08XsSDxx8kVXijY4mal2mCSMvTZ3DwUSx8ZWUUEkkD7ZQdfFHrialGKK+VVqF9pOGeK3Mvd5gXcjQYAzllMb09TEq3Lm4Jf2tkKwa9P/wG25DneDeylkwoZUlujUOiF6NUosTQaiRhA4eY3lb8kM4uRs4ZN1vmxZYrVW+HJ2Esezxz6tavjLCJsD+GU3EubWXPWoDeus35xjF60GlMIP4yGnQwUP0mjqkanI+YzjP26SKraLwO3dVS3iU3rZ+CE3RXIfmrpGYDUsLuxokho/ET5YKK6+OlX6mWwvVpCRMVQ2twOzhwB/YVg64bFBxBNc6p+n8+NUSTU433S9/u/9OkmG0HYA9AXEwjoLzJnaaIWIkRm0aM99mZ2d+2actdociDDcmSKg6zHDnmw3VBl1FgQkusou90778tqeaT60QFjKBdxvfdkQQVXu0BuyQaYut/3N/Pa50D53SNVpvcEbh1C51AwahbDpXXdFHPA0TadfAmMksitfNDwH3JROZjwY2hf/9SaazWQKWdOfy0oFmHnhogJjrQenisGnn9Ej7czRCWT+5tjwSOEBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199015)(66946007)(66476007)(6916009)(66556008)(4326008)(8676002)(316002)(54906003)(2906002)(5660300002)(26005)(8936002)(41300700001)(7416002)(36756003)(83380400001)(6486002)(478600001)(6506007)(38100700002)(2616005)(6512007)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Mah3NKRDGjUbV6A7flUdcVo/2Jld9IOzfN2kwAuL922bItLHWSnmlBX/d6t?=
 =?us-ascii?Q?IS6cVG/VCWekz6mdzpNVv7Z2W/CZNI6oosWnNZ8CKCr5vmmctzID4/E35oJj?=
 =?us-ascii?Q?tBgl1bq/QgDSjRQRt2oSLllsm1kZsEAcUrK4Wtapsd8YLRkTJHQ6fMvcmO1j?=
 =?us-ascii?Q?0M3BHNoi288GhFCC0Og+/nDcRz6UtVp8ySJJ4ESAFxVB+8X1xu1KHqcDotP7?=
 =?us-ascii?Q?G8bzPQKu1lwFFCcITc2BcDwlZlI6EGElHtIJGoiKmGLg+0hmfJcyiJLop174?=
 =?us-ascii?Q?012D0oH+ZXmBKvRTn6l9iUyf2kBK0Yz4ZxbU5NxZZTN3Nx5CyoQwhpf9hB3l?=
 =?us-ascii?Q?EOFOiMiHvbuNJXVtBKM0/r3oTmWZYrIm/VfureCl+KJRdk+qao97oNo34w4I?=
 =?us-ascii?Q?55ASZHcF4DD8ggKJh/qtSKh0T+MnEc+zFeMhKUo33EHW6l4p8GzBSezC+RHd?=
 =?us-ascii?Q?teGx54mWahAEVw5gKL75UBQn6WQwH+fNNebXUbC9Guodf3EfB3RTohfu47ga?=
 =?us-ascii?Q?455M34KrITDnUSFNKM4GbntFyon52MPOaBLt9iZ40nwdN0BFS+eQvNipVNU+?=
 =?us-ascii?Q?i2RRr2lJfiPAKGXZxH4d1q5H6+f9/0pcqAcIBGJe2NVqW2aaoJf3YYPZTtt+?=
 =?us-ascii?Q?HcJwbQmHjd6DtxgsuvJ6TdxDCVhxN/XyPIwOWmHOtEI9V74P4pphOhd1t+Mj?=
 =?us-ascii?Q?xGbxG/KBcoAc40kfu11SPpSLOedzk2wnyss8p1ljjlW9M/Yp5TBxNhrSwjCs?=
 =?us-ascii?Q?uYMZOEUm7N7eiwx8vgJF7kIgscFaiff4bKa2sed7wJ9ELuvBq/F5WXQwWXeH?=
 =?us-ascii?Q?qrxypLa9UhgSUyJPCRsXk1hQoT/5TA5AbnEsOFr0wHHUckvtpK9irgZ2V5zM?=
 =?us-ascii?Q?U5J6Euvs0dTGHDLPqKvTd0haRk9Cjvn1mFmDFovNr5UMLafZ84i55ApiebBm?=
 =?us-ascii?Q?2ap/jH8yfJhBxbBB95u2Np8jQ6SurdTWiCmApipXtcmqCg4bFxi/O9n8jwMO?=
 =?us-ascii?Q?zVUovVBvDYMsTrvJXpR2ZRtlPwbQudboRT4ilOcsLfYrafvnzWKeDc5opKjk?=
 =?us-ascii?Q?XECtSToib1NlB+PfpWzKL9q59KhQABOGlMz8mKURW9TobgZeRRZm5Vv/5WI6?=
 =?us-ascii?Q?OcUKToy4WB5sxpwqBiPnwVpbG90I2Xj7MjE6gelsz3/vINYg+gyNYAQYZVc+?=
 =?us-ascii?Q?Z6CXBcWYcaIQIvKQQspCtLf0S37HDI6iruJhXOjC77WmO02M/UoeJwkG1+SO?=
 =?us-ascii?Q?y6zPkAS72I88uWen/FTLMGz3y1xeM2EIFlw7+4cjNmyNCsgbTaoQPN+mCvOn?=
 =?us-ascii?Q?BQtDRIh3jJhlQ+SuvPs2TROutO1DOGS2hbB3z2c7XLY/tmcxrLw8NBv5uBeE?=
 =?us-ascii?Q?X65Aujcy8jBqVEkwDjyr35wimBruaN3+WqyWjPBYLw1+AkcUrhXpK3wQciHe?=
 =?us-ascii?Q?NmoqAgMFZ4whvfZ34mL7sKxP9SeVxGxjMO1VXg0d5RKvUVe9QFa5UWhk7mEv?=
 =?us-ascii?Q?hcKY0O7Ngs+HmnEsip1T00GWKNsIfLbc/xwpG825+Ex5bE6oKzaVLJ1TPOW7?=
 =?us-ascii?Q?8ledWcRNvgx46lyjG6X/qSFMwQtKWwhc2iHpR2ES?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e5b0ee-2d1e-4ff4-1a2a-08daf41129b1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 20:19:38.0408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xa5n/oxnBfn18F5Kd+7E+g6QDbTcsKXh6Yj66YC2B0d7GVx7dHH8W/gAqmnuSEdt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7772
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 11, 2023 at 07:19:34PM +0100, Thomas Gleixner wrote:
> On Thu, Jan 05 2023 at 15:33, Jason Gunthorpe wrote:
> > +
> > +	mutex_lock(&group->mutex);
> > +	list_for_each_entry(group_dev, &group->devices, list)
> > +		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
> > +		       device_iommu_capable(group_dev->dev,
> > +					    IOMMU_CAP_INTR_REMAP);
> 
> Nit. This really wants brackets even if they are not required by the
> language. Why?
> 
> Brackets can be omitted for a single line statement in the loop/if path,
> but this
> 
> > +		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
> > +		       device_iommu_capable(group_dev->dev,
> > +					    IOMMU_CAP_INTR_REMAP);
> 
> is visually a multi line statement. So having brackets makes visual
> parsing of this construct way clearer:

Sure, though this is all undone by the last patch which does make it
visually a single statement:

 	list_for_each_entry(group_dev, &group->devices, list)
-		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
-		       device_iommu_capable(group_dev->dev,
-					    IOMMU_CAP_INTR_REMAP);
+		ret &= msi_device_has_isolated_msi(group_dev->dev);

> Also get rid of that extra line break. We lifted the 80 characters line
> length quite some while ago and made it 100.

Ah, there are so many different opinions on that!

I got everything else, I'll stick this in linux-next via the iommufd
tree so more bots can check it - if anyone else has remarks I can make
a v4

Thanks,
Jason
