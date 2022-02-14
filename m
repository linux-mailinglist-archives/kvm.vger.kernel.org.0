Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EFA4B514F
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354026AbiBNNP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:15:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353999AbiBNNP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:15:56 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC284F47E;
        Mon, 14 Feb 2022 05:15:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7YLXzF3pDxVpYZG2toC8LShOlNQyvpEfUiao9fTR2mzFgGtz88mbPcHUWTVbOX8EsZl038Nm7i45+kzJy97HymeGXXdEw5ku0kviYuaiIr0M7tWiTwXrXDrnqbarwiD3z7CBH51OfqQ1wxB32MNt2ZN98RqkXGDC/7+UJsAUEw66PWq3UkoZCRb//R9AzWZoSKKCnSloFJLumZi8nJHej1DPysglLA5c0OpwrHq6coEjTo2kEDsoQRVWWpXMqrz98cpCkHCAX/jNeys9yNvbBMP9pFd1xul4zuyzSBA7hJ9AYAJ9PS0nW6pVfBMHSabdUfjAyVK4eSTcRcJSFhZmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90pxKIVgUQDwCyLmJ/ClJ3lIRlFSzv6NYIDgpNPWbVs=;
 b=LnKpXXsG4k+ZSHkArno+4fDZEjTKJBCSs2C7IotdJFPSn43BLJagO5YW6ehi3cBa6Fjw8ZRvWXamwh//lRsPweAJvLtmzPMYMP+i0bpqSEuDiyfujOWUEkvLSsWE0+ujXqIzJ+9m6NyIi8FfiBw5agyRZqQK8c1VtN6lO8Mp03mk9OLjyuQrqr2t1S5n/9ijok7A4/RiEBV7yLJ+/r3NZ9WhLfQ1qbLPB+ksKMMy7uyQW6nTaqr19NGb3LKDM4tCuqFvQiQSxGF7uXoLK/odh5nJIgbMkiRGaoDRUrJUZUm74zKWBz3+IjwdpdAP/S+oQsfVx7A1YsRZkzdki0IcDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90pxKIVgUQDwCyLmJ/ClJ3lIRlFSzv6NYIDgpNPWbVs=;
 b=TdrXDj9vTCN0q/znMiX0SkzsYB7APPqDVM2HhaBmP7/HT7HqDq2+o+5FkgvUrISkau9o0js8bBDJaDtpA+2SBP1TmbS1J8CG1EzPKWlFN7O9MrJnZBD6SWrIg2wqxfSM9WgIKAg5QzPmfamEwq2/1j7QvrIwT2gBOYJyVeL9lmQZ7CadDMWw9DWxC/JeWVTEuGTknhoGdE1IG1BHSnkESaexCnuyp7kjEj3s0XDvPEd1xnwlKGlTCOywiZzSe8BOtVKXVFGYwMWWzFith2xipBspNtVKAPzPNc0d9dVxX88Cxkj8vgk/mlGr+illjpuSbmlmE5CQKJOXSeFgsl3dxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4817.namprd12.prod.outlook.com (2603:10b6:a03:1fe::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Mon, 14 Feb
 2022 13:15:46 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 13:15:46 +0000
Date:   Mon, 14 Feb 2022 09:15:44 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/8] iommu/amd: Use iommu_attach/detach_device()
Message-ID: <20220214131544.GX4160@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-6-baolu.lu@linux.intel.com>
 <20220106143345.GC2328285@nvidia.com>
 <Ygo8iek2CwtPp2hj@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygo8iek2CwtPp2hj@8bytes.org>
X-ClientProxiedBy: BL1PR13CA0214.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::9) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a0134c1-e24a-4d53-8199-08d9efbc1c55
X-MS-TrafficTypeDiagnostic: BY5PR12MB4817:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB48178F47CD73687A31AFD4F4C2339@BY5PR12MB4817.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X3HfZdlwBxEzgVMHZ7Qyx7Ob5q5+w7WauXQ2zkUCY/HrzBeMtFXcV7djOwVxLcS2KMLzVpLm9w7nzIFyVTdZNOOnTwAulQPe1YImWmSOdNloY20U5LE/vdMVDdY5I7oJm/wGgkYoEOjL5VhG+dLcEaK++Vqzv4MVknXY5Kw9NRaCTKpsYDGn8O9t/CMTlnz3hmpIazstX36HiZdYlzWpT5u1pdwcLisANlmCzlAv9rH3oGQ5v93qmQX20BIohW9BtX2NSz3tdcH+StsN7oMoAnAupeLQA0SLcwsSWN/RQjMrKO4H4byf8xJr14h2i7llgbwMfIJ3B2hi5begsr2lF7Yrj0nhibzjVOyMDy14gTm50V09UtaJzspaeLVR7tfZP6i7+IyLrB9Fvf65UucqbOWgTPtwfxBkbEvzCgftnIIBhFS3+cT5xBdgXHR5JaacfiBMQwm2SklMJscnq/Q8bvwEynvOyM8wwNx9wqvfvxnUy4A6uqriacHeSXfbPssdCpLxpnaPgssDT0eO6GPAw2tezGHYJmCY7OOAlm2y0rGpY8BkJR3mmVD79I8Y40IxEmEA+ThkQ5H0dmOJbVLR3VRbX7GbQd0lNT54MqIwWe08slucALAvzRBCaNTnfGo2ygMBiTatRg4n56Fwq+7oyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(1076003)(38100700002)(54906003)(4744005)(6916009)(33656002)(8936002)(5660300002)(316002)(186003)(26005)(6512007)(6506007)(2906002)(2616005)(508600001)(86362001)(36756003)(66476007)(66556008)(66946007)(4326008)(6486002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4nldyEaxsQRQOzOBvFiTER/N8HVFsqjNBQLPCRZ3ncINdF3yBPLG3tZOzN+V?=
 =?us-ascii?Q?GILBStBOVDXjOvP5tIa/WmTrqR0o9dfx32MVy1Zxi1j+752qyx83ohGsX1dS?=
 =?us-ascii?Q?zKKM6MxgZljX0hycGk0ZPOMwSL+EkvndGYhWPm1P5joIL7JUuhTYrRs73z5p?=
 =?us-ascii?Q?CNixjIT67S5+HhqDzKDplBkQHQXKAcbCK/1XPWcdNIi9bDVMfzlpbrd8bs7A?=
 =?us-ascii?Q?gvjqQ5XJhjElZ8uwoIhtyCO2qMzTVY56ymIPuCuWFv/ckB35/F4bZ5sHtGUn?=
 =?us-ascii?Q?kVjM+FSQnXYre5lufVYMORuiW/J3p/XMHLL+odMRh90uC3nfBJ/6tASPZ7d5?=
 =?us-ascii?Q?aKTAjZIaC0gc4NKzIgvjw3JIdrx9ofnzerW3nOmg2rs96FsEc9FHRvzJjBMC?=
 =?us-ascii?Q?mmDZHB+/fLEkj1MyTHaoyb9FLoiOXSWPYsNlj0jsJ3gFjitTvrxj0YZJLDdA?=
 =?us-ascii?Q?FLxDhKIid7MrsBI6NIC6gK50I74yywiqMid/1w79/anJjo65vBt8WP9q9eTa?=
 =?us-ascii?Q?mIqKD6uJw57eocXcJepGo+ea2azN1lYt5KDQmDBcogfFJgwO64Luu01Ox+oa?=
 =?us-ascii?Q?boBcpDYKTuleO2P2uuOz/tIz+S//LZg3NBHDK+J7sqJwtRStgd0CaI/j/i3R?=
 =?us-ascii?Q?+9ofGnTLf9K3Zuw0WFBN+AyD/eatZVmbMAtdh+HHWx6TTalVdnPH+tT+yndy?=
 =?us-ascii?Q?FSS86F6To6OhnXX6SAsH5A+fP0tunE0I+/mWoX62/JDJXE+q8/sMIgVfiKqE?=
 =?us-ascii?Q?YiqoaAgI+H8TxhjaEfF2aU40G3tGLw08Qsh2si3Ir3SDKYcddyXD4Tc8oxBY?=
 =?us-ascii?Q?pTkKX0PPUJz/2/D2xc4mYr/+71PPRmM9tMQHsJP0nkLl6iyVmij/FArr/rZF?=
 =?us-ascii?Q?zzksOrs+6/ehho5Y50GeJyCmtYKNgnkbeZW5ARdzztCTYE6QrbE76dBov+mx?=
 =?us-ascii?Q?/ULyOEsyQ7hK31O6SAwwLo7tXodByLWoRMAWXOIlMCo8O8hUEjJC0kBukxD0?=
 =?us-ascii?Q?S3Ypf30qr7ZwvUy/77Z71S1iaY4QsvSYA6lhQ0SmLCDtAD2jq9LQNNtEfqV7?=
 =?us-ascii?Q?e1WUq7a9kzZ1oH3a7yYZ6HgEuEmdxFerZyryBMPJz6VZiHqXb9U+KWDsCtb/?=
 =?us-ascii?Q?UiHpMXu8wX3QAHwvaDTqaKqW5XoAsv0JjYtHYuj1Z9d3Df+9wMHunPLFMPwB?=
 =?us-ascii?Q?m7BuIYi6qSMHJ7cJ7mI3sSf+wuEt8hB2HSuKrJR8OfIou6gPa9nnZ4QDQfXl?=
 =?us-ascii?Q?m2dLAs2yv8q1HQ1JFejdlHGs143KL9JV47ztlE1oVkqD1LdHXMuyJeyJCI2t?=
 =?us-ascii?Q?/QtyLbWAuRhPefnBkF4X7Lugxa9CUIsWOFQn4+aNq8RO2LgD+nbTc/f99NdY?=
 =?us-ascii?Q?aiNcs8x/S+DBItLQYgPFrWcpsuOD1NL5srwKr0cKV41kGgDdxJZm+Y7v2wsw?=
 =?us-ascii?Q?7Zuqq0xm/xq58Mp/2fBMvgTPQmaHXD/mnofwgrL4z6yTyaGu7l3ebmm7+ZVE?=
 =?us-ascii?Q?zWnZuo/ciNjfMUyspREP9kMDeHsUqZBcyghwrXH2jZESOJLmXOit/uKR1k9P?=
 =?us-ascii?Q?oXZwId0cP02V+yGtSHw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0134c1-e24a-4d53-8199-08d9efbc1c55
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 13:15:46.0847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hPPuF5fVQP4lsfGmbswK0IOunzvErOpGCKQtHfBUahhbj1QgvvCUJNK2urDfJ0o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4817
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 12:27:05PM +0100, Joerg Roedel wrote:
> On Thu, Jan 06, 2022 at 10:33:45AM -0400, Jason Gunthorpe wrote:
> > But I'm not sure how this can work with multi-device groups - this
> > seems to assigns a domain setup for direct map, so perhaps this only
> > works if all devices are setup for direct map?
> 
> Right, at boot all devices in this group are already setup for using a
> direct map. There are usually two devices in those groups, the GPU
> itself and the sound device for HDMI sound output.

But how does the sound device know that this has been done to it?

eg how do we know the sound device hasn't been bound to VFIO or
something at this point?

Jason
