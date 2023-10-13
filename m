Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0257C8918
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 17:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbjJMPsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 11:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbjJMPs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 11:48:28 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F05FCC
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 08:48:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvcUVm1akiOCF7WLGYZRnH9rFmJPQHjZb3QKjiJAEnZnqi4fbM2XO7As33VS0Vw2eBhkqdQBQshhCgW9IWTa4Lcv+VQXep9fHHMnLsmE95av5e9fRk74J4DzWPtShoNCq3CbgPRZyQ0QwUyek51WYFXsVouv6Ro4ahR4ApLgjJ9tccJPQkEmj8+2uhVUtssfbUyt6XMLiuWCX9esb+KQU0Tojuw/GBZBADHZfyEsziFCWtPiYshIP/ONEdQJp64B3hQXjg/JPankm59eOwwi0jWfNxxdpUr09acX67kqOzjIWHp6UybNv+fW0MUOKy9liU4o0INIJ3L5xtdnQ3+psA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7w2E7MXhNAwu0X1Boaknep2DAgcNEdTCrX/eOK/KqnQ=;
 b=k8VCHcWn/wXPCk09zQxDaF9E/9+fGBFh0jSvgG8KJjsOOTXZ6Oi9rZwOXLFq/kTAUge43rP8ODFflB0BMDAVzE0eseLKKEUCw4aRa8tUYSi3MueYH+Qiew1D8+Z9OzKfNpD9LKXOe4/fhIGtcVvvl0vZpEnQER4HEZIzZCNB0M2XOQOeMnH19Byw1Gg2Wq9XsYjfiwIoCZBzeMAgY5psvzrntO21MIWv//6D0oIg09asaeUBP6DEu8ysUEvMyRRpzMPXkKrWCUaM+nUsGGtAX9NQ9tdyCd9yNUR9AAuix91dmW+K74UhPKJdK5dpoyx/MU5H1Y8gqRbrTi2/9QExxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7w2E7MXhNAwu0X1Boaknep2DAgcNEdTCrX/eOK/KqnQ=;
 b=RKxRe/o4jRHA3q8yxI0klN/WakeunczuEwdC3viJOqs69J0QaV6sZXvatvNdfjRY5Dsc4aSf0qvR3d1KUu5v3gqvhkVIUPZztKdD5N493j8S2jE0RNmBUxAWGJN7wOCy/VHSlxOcd/HC96YSLzAJwXe+wkMXUhVD7Mvn8HIT1NBlY/p0WZNzBdTaETt9IE+i0VtkWsDJ4myL9ptEHA5oTtABndwWIs1PxytLZ4WXQY0tTMADI8HxtdsckVjxns3buYzxVt1EL/wQL4O6tan2VPt5Ank1y1G1JU/I7i8F+RDIf/VeFrGcYnjE0pkyL5EMUmm0fJgsW+G/mmAySV7S8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.46; Fri, 13 Oct 2023 15:48:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 15:48:23 +0000
Date:   Fri, 13 Oct 2023 12:48:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231013154821.GX3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923012511.10379-3-joao.m.martins@oracle.com>
X-ClientProxiedBy: BL0PR02CA0080.namprd02.prod.outlook.com
 (2603:10b6:208:51::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dd306ec-cb87-482b-f43c-08dbcc03d4b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bAlATJlayBnGwS7hrKVvyg7l+GdnkG31poTC3XVMm2JEAsapP4tb72N6+EDtsFBjWDio8qWV8u3vuYgwhR5mnKDMRNUYypafI9b+y3vGcu31lG8bWecAOGACkwXjQdxDx+vcXJoS/SS2iM7vcvuOkGgUj1IwFhLiFH2mY/X/AU1T4NEbC9Dms4cV//oNC4y1caTamc0ViQnsizzQxLJrv+j2O8QFm3JcrDAObE4g/u0bP1X14463/YhgVMQZwxWfGusCzbtODj15noC+PlfgtNFgFM9OKQ0P/8xNvv5M6j/5Yqd+Hr+nt3VI1pyJUU0Dmmtz89Oa1dGkfwQVPgP0Ji4yDiBS3ufwhz4zrsDgFuEkZiN8uXHUca1NGyzxjFk8RiGKpN7vF4d1Zu+JiPFpKUfTPQvG6lSJD+dilBLbFMD3uSwskf8HcdrAwy4rY+zvJmSS4564lzY0XYW/NUXXiZaokFfY44vigdRpHW2ZdOp98Jz8+ga8xkE5q8KUq/EjPwCycgdN26pAfECVigWyhQInDgK4mYNLbm8QDUl1/df83zEOv4fA3ctEXjq4bIEv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(376002)(346002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(54906003)(66946007)(6916009)(66556008)(66476007)(316002)(6486002)(478600001)(2906002)(86362001)(4744005)(7416002)(41300700001)(4326008)(8676002)(8936002)(5660300002)(1076003)(2616005)(33656002)(26005)(38100700002)(6506007)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n3WOJ5SQodXacLuTVcA8NSJdSF2RhteORNrXY5TOksUzML9UvvK0apb0kSgl?=
 =?us-ascii?Q?cYjNLD+oxEikHUoOy5V9+YRlMb5iwZJ5osyH9daGwLPvi99+JQzIB7yLI2Ls?=
 =?us-ascii?Q?DuN7ycA+/5VdDLd2O+CnHb1OiA8bQirLqV7zQeDRdT11pK2oshgvQMgjfF27?=
 =?us-ascii?Q?GXyZkr1qoc9L/pCTl1YIu3Ih33YpJyBjKOPtf1O3TXprNTOX8sOo5WgClXsR?=
 =?us-ascii?Q?vj6iCZwpjhkKBWGw7PBFW0x7myQdICeBAk8qDd47OVcji7+SjV+d3zWloqgx?=
 =?us-ascii?Q?ZzYNXW5HJkBJMfdPeMvngGxcrLPr4V0yFBDA/BD8Odd2N2ltKbPzn5jTBfty?=
 =?us-ascii?Q?PnV+VqnBuerw5S3AYwRSR3LnmVvHk51QPduihXeBC32wpqLCelY/URJDjtnI?=
 =?us-ascii?Q?MpyQwUnOzdftTHkj8TYm8LDXwx/uuVoQFidnP6mZAWPqDrNg1yrF73/IPvxx?=
 =?us-ascii?Q?taoSKz1bkWbGNAFb+1bZZ45lwt/vE/8Ryw3Mi9ZTWI0neU/8I6ODxiybOJBR?=
 =?us-ascii?Q?2/4ESyosnzZzZ/rJkF7rjeIQwKtHbsL3ydrh0pSmMR4/nG0AvQMgDeqoqycQ?=
 =?us-ascii?Q?wRV1uFQwG2zT4p1Dht4kqoTl8oCfN0kUYVlNz3urBJww5pxtp0HbyC+CH+jv?=
 =?us-ascii?Q?ynW0TO69j3UGDYmIu6RMsTI81NS/iEKlJeQvOxyrl6f4Wg37cRmU9XdSGIko?=
 =?us-ascii?Q?J7ujR0ZRmT/cYm42ff98O+dNsKPwhyPZLnZ564tfki6Dg3FEmAWtM8YIxbJx?=
 =?us-ascii?Q?BGeFO9irDOSlffHdtALYdY7r9kOuyvjyNMKdXBbiFB0qCfN2728SVlksFDY0?=
 =?us-ascii?Q?dL2ECp/gcwNVoD3X1G5uB3gSzA0NlJl+RuRDjjRDmtBghQBF61KigN9tQ6p8?=
 =?us-ascii?Q?k8hoW3ComgBb91PNG+fAujnKZFE246Gi1SZ3YAM8P1B1gBnBMnax4lcrbYxO?=
 =?us-ascii?Q?ByVm1Wn6OYcNCfUDAqcc9AkBrYYdDqAb1YfltbcyBynaV+9TQXXd3Yim/e9U?=
 =?us-ascii?Q?k76F506t7/m5Xzm9VLvZ65ld+nhK3wVio6f6rk8HCKVPZezM8U4hbmxi7XK8?=
 =?us-ascii?Q?CF4Fhycv/srQZIbyKJFAukKHCp47q3zrTRl7C8Gz2wjaj0QoM6zqgP+CfaOF?=
 =?us-ascii?Q?PtWJba2gbWSoha3Wpwt02jutObB6loD7MifhhKgZlfvPiG4ArVMixZTa8B0P?=
 =?us-ascii?Q?XN3kztpSP66B9ygp6ugY111Xf1LkrP5t6irsfNOa5K2n1FIzwppOw1h4ERup?=
 =?us-ascii?Q?+MiFeGLON5IK5qIJqAwHl1MMdZOCs+3xBL/KoXJgTS3LUAEhXtgwMMVdBIVh?=
 =?us-ascii?Q?UeGw77MIHpxyci33vHuW5unu/nxWXTZY8J+S8B7ag4eKXGl6UNhnmiFsenpE?=
 =?us-ascii?Q?p98fa9K463DxorbYH02EsBRXLSyzgjUK2/KoxHLxkcSPp02CbIk6pkTjHfXt?=
 =?us-ascii?Q?XMxb7s2CbUMD0zUw4O9GbGLGhVOxbTgDSVRv0Cbe3pf58nOwjpzSYUbKEkhW?=
 =?us-ascii?Q?vCv52u/V7GbXLzsje/Nn0Mf3ZBEEZX/GmcpjgNuz/AKqF9KfybebQPXBzfL/?=
 =?us-ascii?Q?hyK56Ri6qoJGBTQqyhcNRQd1oNgqSO03Z0gmgf5t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd306ec-cb87-482b-f43c-08dbcc03d4b8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 15:48:23.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IFU/1fSYCO92tghOLuw6UCZ1HpIc/MxbROuxhOKWF1iEH/js3Fb8BKtQugBMEqbr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023 at 02:24:54AM +0100, Joao Martins wrote:
> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
> can't exactly host it given that VFIO dirty tracking can be used without
> IOMMUFD.

Hum, this seems strange. Why not just make those VFIO drivers depends
on iommufd? That seems harmless to me.

However, I think the real issue is that iommu drivers need to use this
API too for their part?

IMHO would I would like to get to is a part of iommufd that used by
iommu drivers (and thus built-in) and the current part that is
modular.

Basically, I think you should put this in the iommufd directory. Make
the vfio side kconfig depend on iommufd at this point

Later when the iommu drivers need it make some
CONFIG_IOMMUFD_DRIVER_SUPPORT to build another module (that will be
built in) and make the drivers that need it select it so it becomes
built in.

Jason
