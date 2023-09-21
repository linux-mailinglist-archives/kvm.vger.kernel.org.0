Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F9B7AA0ED
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjIUUuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjIUUt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:49:29 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2072.outbound.protection.outlook.com [40.107.101.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2236AC79B
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ja2d7MCZ7WxxbjmMrNUqr3tMQwERFTRPj1JZSu5iwjRiU+qulVtur3NPcoWanFxtj+9VBp8iSd7xcg1d+Yc3uoCGsawNHLy5rooxVjfPzHXnOsG9sB+mBpZSJec2IJbzGKQfV8U0O2xqCscK3UTroBsxmlAcnAW4HnotIeafPH3GzAgQuOAK/v+vdzm5Hbdia+OqeAT45qXWRuA1nCCq0qMDfyhN9K84YU5fQuUVe/vQGuxsueRseQjrcA4ZBneZNrK09hWLI3/EZu+qDAovX3c+59NA3+D6ktJ97k0jwQpW9rYqaL/NMpoOGUp3L4ihWX9Ea6vFTCclFAwPBfvUEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZa0ZDoAuHvsXJtvtwDI2aW/3UN7347RBZ5aeFL7pWw=;
 b=IuRMWInVq47rTMLmd4EBq+MiF732Ff/NusESqJdi5cm8TBpzzwOa6SDFoEADpJo6DRJgog3QXy/gRGtsmW0UtyM2H2poxNDO9cGH+jYrFRxupGvPgEWS9hAivdWefweW7hC/hrjRSZiVcIhtOXNsBFMLgfgd+WK4HAN0Jfb1yGYDGkiWKLrd9I7Sicjblsw3G4n/q+LN7IlEl9uGakJpiFamDmEP3i/vnf3meQHAvEnMEX+X2WCNJQl3dY+n+4W0FAViWTuiLPE+E8BW3ceyuRl6Aee/MhLoM4bog5ZFp3k6HFt6DeMtiJnbjm5ZSvlel0PXvl8b5ws2nbR+He/6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZa0ZDoAuHvsXJtvtwDI2aW/3UN7347RBZ5aeFL7pWw=;
 b=mIbgAY3tx2qds3YkvpcHElKfr1UCPjFsXlJ1YmUcJLQhZJAeLk18GC7p+mhyUXNolR4rqHzoD7GzGxzCgrfCRt2ahf1yMC0nSQ9J7/b+CKqw17dNfZ6TMIpEzOzTN/jivv/yYU9gVNfXQ+f7b7Bg5flcSLYyMN50fZmEbw9p/JOBaimmmLLWHfPAbJTrJq5yeYOiiEJLSWpwrGMLNAe+2fHw4aFwR4SpixFyS5eLRULSlBe0qA2fqb+iIsAkbv1UA5BFTOvS505eJfmmKMNdHwPBHDHZqvN107CLbIq9XhbW1UhVQepEJ4sZ/wuam8u/Vl8NGfug/n4L3IlIW8U0Ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7840.namprd12.prod.outlook.com (2603:10b6:510:28a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Thu, 21 Sep
 2023 20:01:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 20:01:22 +0000
Date:   Thu, 21 Sep 2023 17:01:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921200121.GA13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921135832.020d102a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921135832.020d102a.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0041.prod.exchangelabs.com (2603:10b6:208:23f::10)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f571e5f-1a02-48e4-3f2e-08dbbadd8743
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kiF1f4+ErYrN7Ip8QiunIpmN6uFzYoV4DSQVdczyOJukXf0C0evijcEdnVECg5Hrfk+sJEgMHMQGGKoSR4niW1fCPUvZ+S3H7t+vF80Ne2+FkDUgpMrBl9guY0ONh/k030IKQtiP4KgVzgx1EYhDje6a4tMFDz5kSQgmRPc1Q/f+zWnrWbACJgVumhw8YFc5CY08oZvqABlmV5OSD0ha1/BQTQ97+4qqz4Q22bc2Ne7R0wCIgOZVIpdJMXXwcln4swG9bHhiirUjedOIXH9srwd8aasMbYm3I6h0oeUDlPTtHV4mdOaLYNtfEpPbMDDJ9ektBh2AWDgutiDKHERTPjdFO6Jt3UzPli+9LikHxGz1/71ULKVa/ovoyHhpE6LJsxC9cn2UrUR7tMoe9lV7Zhcko7hagUHugme9BX24msZDyAWL7hLaxmtrbRI/44Vo2W7wmBOQhjHi7RZ838Oxf9DJaPNQ07YOPnQ18FglqRv2gqIvY1jf4g5tZ4iQ+e9H4VxzqYNfE4kBg0mN3CNVU71LqfrbZO+hAwbV2BDuDs0/4AkOgx02gdKQUSeAFl+y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(396003)(376002)(136003)(1800799009)(186009)(451199024)(36756003)(6916009)(66476007)(38100700002)(66946007)(41300700001)(66556008)(478600001)(2906002)(316002)(33656002)(4744005)(86362001)(5660300002)(8936002)(26005)(8676002)(4326008)(1076003)(107886003)(2616005)(6512007)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gekWFxQcgMFtb7nzRayx274pNRWIU0tLpnrPtfDc8+4OzOEkrrgz/Xzczulj?=
 =?us-ascii?Q?m84nYXaj7oD/WgkpfU02SkjFtxgaTXRFt7jJH3LJ+TTY1d+YVoudUViwkcg7?=
 =?us-ascii?Q?WfFxLljNPcUDbAFV2E0Z2FytReCJNagod7TQNyKtJ3Xoc8sQ4VUgBymrumcr?=
 =?us-ascii?Q?/Mc3VEqwaGRBXK/OaosmiFbRhZOz7dqEfqDsEVMeKjqtjOljAodNTSctRehJ?=
 =?us-ascii?Q?/qPrAKr74nXqStIUajixz5s7+LaJsj43u/SwUz/3XKwBQ/YRPj8fpa0ugRTr?=
 =?us-ascii?Q?QHVWlUJU2DmSYjsDPRBEMC47fMqx+b4azhlA4dMZq+NvXyVKfcpNdK0n0Rh8?=
 =?us-ascii?Q?EW9ZJqhhmveKT1xcsBP+j3sPw0SNi41qnibdH9TtEK54Px0qwCSVeU/MuJDe?=
 =?us-ascii?Q?B+MzC1jhzFxuYnPb54Rn4xiwsB3t9mOolNFHCehYWXhQcXMc6fcQ9BRpLWE0?=
 =?us-ascii?Q?R/aoWzhJe2dNno9m6ZsCCuHu2xPHrOwRQRhyZHf4zJwBtbUfGWcj4b32kypP?=
 =?us-ascii?Q?pUOVA5IfahhygShs6z6vwLNxu5YGNmiC0ruVEcm+sIixiczif/2YBUI8uQhP?=
 =?us-ascii?Q?bTCfFh/Bltyo/w5M7FiTTmeYrzDkkrdBX0g4BXbt4AP0L5DHm52pdAAwzgbt?=
 =?us-ascii?Q?aFmFVEDSnIj/vgpsbi00QHRQSS5Vvd6IaZRnVNj2DCnlARhe5KCsPWu/S8xJ?=
 =?us-ascii?Q?qmgLfEQBq6GidG15NAgrPF1C/3GLVaHeWmq4dS52Xv9G6rD9YsbFtIgVdaNE?=
 =?us-ascii?Q?29lKLVgynu8e5TXIQDrHnwGfu7jaWH0oFU2CZUrGldQokwRkpnUG/paYuq9+?=
 =?us-ascii?Q?0utkiy+SfXBL57GKfMEUpeXh/qEH2Pl3UdSDeiD9f0vhmKd91GzPH3Y6Yjdy?=
 =?us-ascii?Q?EN1hGkrLUxOghBKiMlz1wbmgbaHi0on3JpCNphEx2jHtkapFdfE5CVfr9CMY?=
 =?us-ascii?Q?y5ROF6WF3a+Tkov5MAoEanOeoiYr/tptLF4SUaaUX0jCCwHfOtRmCG8ClfVM?=
 =?us-ascii?Q?5RxKB6dOyEM9CVF0o2U0PVxPsRW+L6LMwkPsdYVpMPgabJFl+EWGFq7dHreI?=
 =?us-ascii?Q?OMIL6dzKdSLh7eRkmC1oEZPD3kvfYfHrnuaTSffQDKMrx2b1e77h31g2QBPw?=
 =?us-ascii?Q?I7g4hvhzPCHFmEoh+uQbjjHdp8ztjnO+uWi+BlQvBEps8iCPGb1pIGY7DLac?=
 =?us-ascii?Q?u3jA1/lc85s3+CXsAvl/Qr6j/Rnsg/ic/y2TAW/SNVxodSfJZMS69aW7l6rU?=
 =?us-ascii?Q?XVy2fHXLpUuLk0Vb1oFjymzg7z3jIe1lFRGf/3WZaLc1sZ5daE8V+6PQ2Neb?=
 =?us-ascii?Q?ALlXN0clwXmYh6HioE3dSAH9HpkItNVJt2qssrflr2tsuOoprcHWJ741p8i1?=
 =?us-ascii?Q?AA+WSVePqiPCmz4K3H0wCGRNaoGwI2Pf7jEsv8fWEsVPh4j+SmtSDtIhaL5E?=
 =?us-ascii?Q?hwuMbhUTfJAqoivbezVn2K2gZajUfB3Vf5oWwGlvhX1Nw8672DvPMGyvMe+y?=
 =?us-ascii?Q?6yNc9XzvplEyNZ9VSsT1KPkALXGXYuDfMqgzzKeztQWOUkcVi89/BNKjy+NC?=
 =?us-ascii?Q?2YmBN0XLa2lec67idQQbfvSCtlBI5kNT783hXHOr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f571e5f-1a02-48e4-3f2e-08dbbadd8743
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 20:01:22.3875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o3QFcEZdWF2SG7M/wIdqsXCL9WcqvPrf+mTcbkuGAa7WxsGgTiGm1bSR/ZOy7tab
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7840
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 01:58:32PM -0600, Alex Williamson wrote:

> > +static const struct pci_device_id virtiovf_pci_table[] = {
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> 
> libvirt will blindly use this driver for all devices matching this as
> we've discussed how it should make use of modules.alias.  I don't think
> this driver should be squatting on devices where it doesn't add value
> and it's not clear whether this is adding or subtracting value in all
> cases for the one NIC that it modifies.  How should libvirt choose when
> and where to use this driver?  What regressions are we going to see
> with VMs that previously saw "modern" virtio-net devices and now see a
> legacy compatible device?  Thanks,

Maybe this approach needs to use a subsystem ID match?

Jason
