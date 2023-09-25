Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8907ADF4D
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 20:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbjIYSxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 14:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjIYSx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 14:53:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91937BF
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:53:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+PJqniOUHrJ3L0mHby145seLYyPZZxy4kv4NpRF6Ay0VhL5mE44975aQ/Nj+WolIoy4rAvcalkegDI4jQ3TLvdWBBmR3ztGiFPWMyP7yMrEqIo804QOIt/sFrjDFTHZX+Iifk8KmyM0ezXsvYSO49fM2q8SyP1B0DqyYEMytZnqLuqeWJk7Nr9L1m7LD1BdVyQ1aH3PWx/IHp2PQkkXwxWRdDmH5lH0IqR0bzcON88++/XdoIlKOr+NQTeCIuyXFtrBiIKBYECyprCDQB7UmNFN72RXgyuqxqWgCr1qbfdOLDVspAGdIRw+LtOT7A9CJfA+Ggmf7HfGjXd8WGofjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+z5+6neK+agwvDdvFxMf6QwRjYD4AQHz1jlx2Du3qw=;
 b=KQm8Bk5+jpUiYmLxxf0SI+rYgAbG6O2SeMdXQ6yy9S1WStpFbl5aaSPBf2rBZpB2x2cbyFBW7rHMuhCD40Ox7nO7+cQhxnVgPgAD6EY1PcqFopZ8kt9k0ZwaMf2o4eUG4Mv+kHg+dDhbKncebefiG8TpGO9vGiuq3ovM85fWURS6f1mBAOF0aeoIKvgP7eubkMCgRw2FoWhg85d5YTwxDXpLaWNTVzGZ0VxFXmNefB1OXjDaNO88rsjjxx4+ORR0JKUUum7F6VQjcA2GkMnr6GVlSJWSQ6aSUojSD0IQAZ2f2MATi/fFYzoDFyQuZ04qMilXzVvN9LF39DRdUSIzdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+z5+6neK+agwvDdvFxMf6QwRjYD4AQHz1jlx2Du3qw=;
 b=jnooahSZSUgy901ybtdEk8SGXl0sqAK2x7octTtaR2troJIkd8uWGuyJv6jPScw4XCLNIcSkBdA5Lvx5EENiyKzqeehUszWxau6nJ2YOk6r7BxgX/GYAcSM0QtV0cN27LMsaWPiz0S0GMsm2YNPrITmljFyBMTyPNd5fUEFShMWaTXBlWXpOO/oaCJSi35Lr/dIVCBuL1n2i+krApZF+6Dyz9JFGW/2gtjzy8pajXuqGdwNKwuwD5PF3jT2fBRp2tDZM575SPp1Y01u79Shn4LafTVraENUI7n4dvg92cVUE+WvZ3Pnns12xNATRyiY5RVIN7IvzY8bNHeeIwgJ3jA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7994.namprd12.prod.outlook.com (2603:10b6:8:149::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Mon, 25 Sep
 2023 18:53:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Mon, 25 Sep 2023
 18:53:19 +0000
Date:   Mon, 25 Sep 2023 15:53:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230925185318.GK13733@nvidia.com>
References: <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <CACGkMEt=dxhJP4mUUWh+x-TSxA5JQcvmhJbkLJMWdN8oXV6ojg@mail.gmail.com>
 <20230922122501.GP13733@nvidia.com>
 <20230922111342-mutt-send-email-mst@kernel.org>
 <20230922161928.GS13733@nvidia.com>
 <20230925133637-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925133637-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL1PR13CA0263.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7994:EE_
X-MS-Office365-Filtering-Correlation-Id: 809b4ef7-96f5-470d-2d85-08dbbdf8af5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QstDpfQw5dSTsG9uk2tvRjgfLZSmeLbNhwaa17iubbW8Aa1vMz8MpeDe9lQ0kRimrSBBgz9KtGoiEo2t4SYMsIB7dgDEhfUtekvqe5QE4ULABBjyKHKOlusj/+UfNOlVL+DawUmqxDwX7kVKMWkgQn6M5bomteGMxpLyH3C1hanv6HBKVdX/xulbb522cZS8M4eiZXdfEblO5r2YkN+4CgOfQsdGyobTvhH8Am8pg9MevXSZJ9+xUxgytLtSpENjSr7R5f6Sm/R2AOdXs5nraSqKWwOgpD6AE35/aEozzb3Q7/zPZoGcPbeKhw28B0aW83mJwSloTKnQWFvP3vT90qM2sfFWYUyiM02DrCXF15QHGOjY4KhatgiifO80signiloSOFhn1WHm9SN097g98RgLpXxv5u/Rhz59M3fv4weUQ4BjKb9DNCIpgtlgnZCx98HLR4LGYSLFF0MpXqPW+QsN9NzxMxtsqtkOXoTU9ZozMgJxCAt/wkb1fSQ6kFLgmimIhO0o4/VijiqXxXAC67DHAO4D0jO9Ajp1ro8J03hYP9qGhrlBEPHNUEqNrhos
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(39860400002)(136003)(366004)(230922051799003)(451199024)(186009)(1800799009)(107886003)(478600001)(6486002)(36756003)(6506007)(4326008)(8936002)(5660300002)(2616005)(8676002)(54906003)(2906002)(26005)(316002)(1076003)(6916009)(41300700001)(66556008)(66476007)(66946007)(6512007)(33656002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZaGc4RfDotfbud/+QUa7/5eAaxC4/sc2ptD18Pmwnk2NICcagxZhtAwECHLx?=
 =?us-ascii?Q?XEKOdV81O6TbFH+fLM0uWDdIbHn0N8NYsH78PaOIRt0VaMaWB1vVHd0WuD0V?=
 =?us-ascii?Q?eWWtD11o+GBwiN0wAxiwou3eHLkr8rjM78xXNlAuERwp2mblVLx82sEMbZwU?=
 =?us-ascii?Q?hR1aZ25IOdRSEUVO4mTtNi1klGBnLEAkoBxkxoU5oeDavDRLUwdZniDAAFDw?=
 =?us-ascii?Q?TZUS/kmPTKdRHypODnTkN0a5RhXeuLx4YxT5Mb7zjaQfER/kss1pW/hJGkde?=
 =?us-ascii?Q?pf9CqC/Mu95nJwHjTEsuTrm8GnfuHtDNUUHv2D8ZlqvVRa1lOSMBskcqPVQH?=
 =?us-ascii?Q?T1aslqbn8MQBqazb+lMvMQnE13OXQQJHGY4K2ByNQ+rVZzwxH2buEf4Qv/NJ?=
 =?us-ascii?Q?6oraKhXi/LW7j53WElgeEFaY4sgtB2EQO3v3zoQeip3/52BjYb8MC8qfoBtr?=
 =?us-ascii?Q?hp3rOeMPMJLMj1YtoEWveW6/+/gqpIA3vCdH5Ayw8OZriKMj4jaffUE3M12+?=
 =?us-ascii?Q?GDXcRXycLT+geolUsgzln3663Q2KkNG+E/YpzOrcjOoNnrjlFAIahHRGV34Q?=
 =?us-ascii?Q?saw8rntDSCp4VpGF6R0I0kRGOnDWm1I0hvd0dG8IF8t1/39aqYMW1aMlYist?=
 =?us-ascii?Q?jP0EFO0I33wH6lZm1zSDQmCB3Qxfe60FvzhV/hXKGK2LkcEW2u+/xf+XTElO?=
 =?us-ascii?Q?9N+C6pBUIwuzZdkC+ZSpmgn93wzl5k4Eg/Gg9uhMst1thkT3CXKilMiL3gOc?=
 =?us-ascii?Q?QAQiLtBiqwKWwM1EI2R679MYRxF47Y2tY4S2l2w1CRyTfzHRbdGOQK33wDk0?=
 =?us-ascii?Q?cuQI+Lj/WNbZc2CDAFOoOWbBqg+oCMUY/s/BM6oSIXG0qN4vyYg0gojEoQns?=
 =?us-ascii?Q?+3WRC5eR5h5yiskFKcu4LMTB31pL3gS0uItYmSSjPrgXPLqaEz52tX5iYODb?=
 =?us-ascii?Q?2H8wm3bir2Oxkex8es7C/uRIdyJaewx/nH6Bv6jlSsSqpIIYCqOl0r8kb24A?=
 =?us-ascii?Q?486jSncET2DblDWS30w6+l/B7Bv+yeJDNOrvtkpxtuIxTJqyY9ajIExzokUW?=
 =?us-ascii?Q?mMD8VPcu08pikskcgal8UXpnS6TC/y4FbJUcTGYrkeCDfJhONEoVY2aP9/tf?=
 =?us-ascii?Q?vTjchDT1iIHZ03oUBvx9Y9GV6wtiaX8lvsOZKzJRgEmfS44pheW2dzStr0HE?=
 =?us-ascii?Q?w5gw9R0d3XGbBegVrM4tjnfa4cGMiV8Fae/1mW82wHMblBrf7/ZbumBlc7WZ?=
 =?us-ascii?Q?9EZ7z+BfSSnv50m2srntjJMt8s6CXzEw0dGnxK4HJC2F3YefhmfZ480gFhrQ?=
 =?us-ascii?Q?m8Q5yWsWdjtbTH9ARmcu3Ns8ues6bYw7TreV6da4e8XSV/PAKdESJRcsSC2h?=
 =?us-ascii?Q?JMfMYeTQrIhW+e92MPoLmrVfwW9u0X1B2e15FtSsmZ9X0igJi+GTXPjWc1+S?=
 =?us-ascii?Q?utSBrT2YK05leDjUPx7egLMUxKMTYUEq2GC3TeSHJCTE/1y/rbG+QJs6LSeG?=
 =?us-ascii?Q?FaTCLTpNOLFP8lnNUKTsUlyFf6dPmdXe+oWZfK2OqsNWoMlXJKPJHwBVq93L?=
 =?us-ascii?Q?w7L878A3Gt8VDJQq6EXVwTFnmPBm3sQ1luS7xgVK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809b4ef7-96f5-470d-2d85-08dbbdf8af5b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 18:53:19.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+eL5vhy8F1H4ziHO3QrIKjio3SzySALlhg318vxNSqkQXF2kuG4Gm6N/rW+vfDZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7994
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 02:16:30PM -0400, Michael S. Tsirkin wrote:

> I do want to understand if there's a use-case that vdpa does not address
> simply because it might be worth while to extend it to do so, and a
> bunch of people working on it are at Red Hat and I might have some input
> into how that labor is allocated. But if the use-case is simply "has to
> be vfio and not vdpa" then I guess not.

If you strip away all the philisophical arguing VDPA has no way to
isolate the control and data virtqs to different IOMMU configurations
with this single PCI function.

The existing HW VDPA drivers provided device specific ways to handle
this.

Without DMA isolation you can't assign the high speed data virtq's to
the VM without mediating them as well.

> It could be that we are using mediation differently - in my world it's
> when there's some host software on the path between guest and hardware,
> and this qualifies.  

That is pretty general. As I said to Jason, if you want to use it that
way then you need to make up a new word to describe what VDPA does as
there is a clear difference in scope between this VFIO patch (relay IO
commands to the device) and VDPA (intercept all the control plane,
control virtq and bring it to a RedHat/qemu standard common behavior)
 
> There is also a question of capability. Specifically iommufd support
> is lacking in vdpa (though there are finally some RFC patches to
> address that). All this is fine, could be enough to motivate
> a work like this one.

I've answered many times, you just don't semm to like the answers or
dismiss them as not relevant to you.

Jason
