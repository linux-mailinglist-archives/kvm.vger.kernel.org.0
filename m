Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDCD4D668E
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 17:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345181AbiCKQkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 11:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbiCKQkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 11:40:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5740F1795C7;
        Fri, 11 Mar 2022 08:38:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnNlcyZgvgTANYMYsZzfXCtvQrEjWb84L03ydnL+SOeXnlYeNkJIhPTbG0WC1X/l8WZaigHnZzOG9UKVL4SiHiBqBUrJbcF6fYPGFw6vM+Piw1uU+NwFD8gch7WCMrLggSbzkdgFohWtyWQyByW0xKhXLyolbcRiBgumf8I3vGur9W0alhKwJRoAjwxHYQd9p48/sjWZT08QVGQMuVlNICJkRJlycUxd3LH4Ie697BlKnvrwmIzN94gPdSNXoC8chyDuabCg/2AE7PIZwN48ovr1qacYhJnCoIPDr2uw6rCA5n6dH4t4p7Wh32/4VZtCmR6Lydse1u689n8VCtl1Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zq0Q9qjaqgnE7T+m0JPR3Kt0rniFFt4wy2/AMMy9M5E=;
 b=jcms5Z0SDJ7gpH8mY3jgxXtqccg8wfE2Km7eD+NpGeT8Nck7yani2L1tbONi/8giU0ake9hd4hoL6LTMX2EFnP9wd6WrPhLGRER7dDP1BCskj7CbD8RwafbwDNCMvQ/mk+eE9ifyv9aXqMpIGXRoeDiw2tNtz6vkDuaO0I9dofHusdO9viN0KVQUgzszGcqMgcgmEPF8GYuLRrPG5NxUm7zsevfyQ2h2FGc7p00o0Nb2D89/dCqxDQrrGBqSuJRhXMelAyFuMM9e9schheCw6T02Jd7oYWTXg2I05JG95r4B99C5y/BwOnFc8lsz7vy/Afvix94UAKiy9UoonZUMNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zq0Q9qjaqgnE7T+m0JPR3Kt0rniFFt4wy2/AMMy9M5E=;
 b=OoBduXlnMXkT4Ffggte84ijjeylXJjRTUrTCtUyHjQohRmWDwEACGaz/mfYNY6N/sNYRW0qN8aBE5NuYlWaKpBXEkviF3rEEQAbLYlY8hlFliTOSvPQxkgd2dtbyn+Cq9keWeUON4pxM2sCHZDRJ9SeM6x9oP7EKyzcjh/avrK+ZJvP/F6OGkO7Z0lHebOhJ7l096wNZb0wCZywAYz34vz716tf0qM6IYSpB+7N1fjHeZ2M/W53zIBMGTFNBqV1tvCkZjFKWSo8/+bhqFbxwfxqGbTib2kphW83SuimmY7GI+wGPbw2Xxqo/DAV3BK3zEqVwdLNu/luVergb9/puRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB3713.namprd12.prod.outlook.com (2603:10b6:a03:1a6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Fri, 11 Mar
 2022 16:38:55 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.030; Fri, 11 Mar 2022
 16:38:55 +0000
Date:   Fri, 11 Mar 2022 12:17:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/5] vfio/pci: add the support for PCI D3cold state
Message-ID: <20220311161738.GE3120@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
 <20220124181726.19174-6-abhsahu@nvidia.com>
 <20220309102642.251aff25.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309102642.251aff25.alex.williamson@redhat.com>
X-ClientProxiedBy: YQBPR0101CA0285.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8752a2f8-476f-4d9d-d221-08da037da20b
X-MS-TrafficTypeDiagnostic: BY5PR12MB3713:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3713392EFBB468A88117B97AC20C9@BY5PR12MB3713.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RuXHpzUl9xgtGBor+27L/jgXCUPlndJ7FscGfu+uUONG4WDf5hXODme+YEmsUOXULi0f15368uPlg3ZOL4xKD8LhOdSa/DeNVlNX7Toih4pkk5i+aJ4kUVHnmQDkhYsb3JxM7DGN33DSTIvDscYbU88rnZm3ZBpZz2M/NH6pyGHl9BZZenYDJCFO/dbReQbfK0iU4GxGympeUizZSmfqcYTpvQrHmBTcqpo982RHcXtiEhzjpbvM5a1pnjoEIAc1AWH/I4pI/0qx1zmqdVKhs5huNwOas5B+glqXK4Z/bxVy0Czv5HehDcT0nnsmgyvhI2us95VVkl+SDIzQo+sKXgbwvK/FoONy9IFpkvp3dVvaF9jV1zXs/Crbe/lXOVSfUQ4P8LWX/ET27cuAQ55qmlm5YeSBCacYqdes0eYafEAmD1P3f0K2pa0vfP9nqh/PVtxNqfd17hmQ+RDGpmkATOr3yVfUK/TM/NNSK0qFws8eASDTtqxSIF+3YFwvCrNNIKel21OBf/DemyLCJvd5oDHuTY5wG1YyhZKWRBC9g5bjTRPpyZb+svDNr2VEDP2O1fZ6CgHcDmXmh/LomdDYnkmQLG2Swu8Ca1ty+gD12gDmSQPqItnu3eu4g13CaDpWH2NcDgtX/ag8KzdAP9gdTxa8A3JgAF7mDrIgPBYvoX395WU9bVURumiu8UKgTKEe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(2616005)(8936002)(6486002)(186003)(26005)(508600001)(6506007)(36756003)(6666004)(6512007)(8676002)(6916009)(4326008)(66556008)(66476007)(66946007)(5660300002)(33656002)(316002)(54906003)(2906002)(38100700002)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sQ3RHCV7zF/iItUXUf7Zsx1tV72V8RV7JmvQETRGOWO7d5LnPXPiorBgeuqM?=
 =?us-ascii?Q?TGF66SevF2uBcuxeDVBoU9Qdreh6Rhk4cJSNpOilyMzG5H9tQLnDEDKwZkuM?=
 =?us-ascii?Q?uBZG1CxWUdcBk3yAsYF6UZ1izzmdbXfSDnfpIHfxEWEd5MX7Yt/StW6yjL9d?=
 =?us-ascii?Q?eiBVgmA2+mtk+5OcLV1ACyAazFVrj65fRAH8nMJeJxcBB1PQ6xJIhYEcReOg?=
 =?us-ascii?Q?hLHRI7TnN8hNjCYFA9B3nofKpgkyBrbmBLguXQDY/gwa8YM5XCGGAmqeKb2K?=
 =?us-ascii?Q?AIQuVyqih8Lg3awP7Z/bglxUPYlrDpK0C+yZbqQtTaM2P12fWqts9amvC5YR?=
 =?us-ascii?Q?FL/TxExmEyCtKup8snAid0ywRqOvBFYB6xLS62ceniCf073MKKUbczMJH8Pa?=
 =?us-ascii?Q?GyEJ06MFFIWkVCd3OPnKH7NUmeUqcJzDrOb+T+aGdTWJbqlEYnVYH1liJqPB?=
 =?us-ascii?Q?RKTaft/TQbEmR8uFF44DaG1blJ6G3BMUdYXxrd4AaZ6KTuC7L0KqK+z30HOW?=
 =?us-ascii?Q?7NlGzugfHhq3mvD2vJTBU8sezaqpitL4X8OWoqN+PJcVNR7I6HnkuM5tI4bd?=
 =?us-ascii?Q?Ss5BzzX1XI2tMYdCtMGGcykPvAzxflDcq9Vb8+OiT51ewJfqo5Ylz83h/7+Z?=
 =?us-ascii?Q?fL5f8eboCi1SzBhSoaDIDPX86D4fEk1bxeqZVnD1ZiX/R10b514yol23whTT?=
 =?us-ascii?Q?j+dDqJLMf4wf94E03SsNikqF2ocVG3+Vn6/cNq91iWSttG2vS5aHizVaB2HT?=
 =?us-ascii?Q?NCUfAEqOGpcs42BM927OOCS8L9arp3DBWf3G0F/m+H70vSyPL1wRCLAAKCSg?=
 =?us-ascii?Q?W6kJ6RLQQxBquC4vjil51fpKSQ/fQJsYFG0MxnE6IuJFakDWh5Oenk+Bi0pa?=
 =?us-ascii?Q?9iGWzruE/Pgs/6038EX5m/77dAxH6+hRHspB5zdZs+ZMLje2bskJ8rmScJPi?=
 =?us-ascii?Q?5/Nkj3LiJznScL+Vs9NQjvA6fUAf8G6Aih4/iiTJTeBNuifh9bGdnKQfkZGX?=
 =?us-ascii?Q?mFm+LmnMLn4ym77YntQFucRlR3nSYvj20hft3WzuoACBA4ZQ2wkSZ0f4lup5?=
 =?us-ascii?Q?cWpxVka9RT+v2n336goObHO3vE/k7RkMJv2GVUHzmXhtNd9eqlX+Sk5sOOLE?=
 =?us-ascii?Q?2v8465zwlTVRPaTX46hoPJ566YXZC86n9yQpIecbCbh6YDGOXNrtxcY8EXLP?=
 =?us-ascii?Q?Fr/5f58AmdE8b7JDc9oT98TsCy6J+cGCJcDT0YLdFDhACjQbF3Yp99IX8ZUp?=
 =?us-ascii?Q?MpX5SATiK5XYkzExqRWce8wO1RBq1zZ7k9esMVmRCC/XoXz3es9OFra7JFgA?=
 =?us-ascii?Q?ilcwxv/y2PMVZ7+r+ena40GWx6oUrpzZAfnrcj3pq5YtRb3As7TMZm9tX0XJ?=
 =?us-ascii?Q?lICsHxJiT057mjuAPsPS/gL2Xr55A4fpxdDMa2TaBL9T6aTqc6L3Nt4tLKTW?=
 =?us-ascii?Q?3exEp2ouDFjsdnnpYTGA3F8v3Z1yATTYxpu79JmNBzthG/e5Ahd9Nmnumh4w?=
 =?us-ascii?Q?YiuTfjZLF2u/iFXnyqQTO/xhCDbvvKqAyKv3yyeQCSVurEofPujzj9rFFp3I?=
 =?us-ascii?Q?hnJlELP3eaW1GmE/uyk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8752a2f8-476f-4d9d-d221-08da037da20b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 16:38:55.2700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdRHww0AXtKqXD+2dU5AAV83UkOoHE7gxiZiKSsk3cYUQAo0kxIKEQEkBD1URSWM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3713
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 09, 2022 at 10:26:42AM -0700, Alex Williamson wrote:

> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index c8695baf3b54..4ac3338c8fc7 100644
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -153,7 +153,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >  	ret = vfio_pci_core_register_device(vdev);
> >  	if (ret)
> >  		goto out_free;
> > -	dev_set_drvdata(&pdev->dev, vdev);
> 
> Relocating the setting of drvdata should be proposed separately rather
> than buried in this patch.  The driver owns drvdata, the driver is the
> only consumer of drvdata, so pushing this into the core to impose a
> standard for drvdata across all vfio-pci variants doesn't seem like a
> good idea to me.

I've been wanting to do this for another reason - there is a few
places in the core vfio-pci that converts a struct device to a
vfio_device the slow way when the drvdata is the right way to do it.

So either have the core code set it or require drivers to set it to the
vfio_pci_core_device pointer seems necessary.

But yes, it should be a seperated patch

Jason
