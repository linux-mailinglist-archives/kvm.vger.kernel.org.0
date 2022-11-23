Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944836365F3
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbiKWQij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbiKWQie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:38:34 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FB8D2E4
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:38:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShDb58LdZvNZoNcVzXvsp3ukvn4X74yfXne+2uu5oidQ5pOKNJ5NoXM+E48R6sSczds2UwJe7Ze+rJMTVjG/CjMfbPAzNLcF8OlEFipXC2raW9QAZgC2on/TkQN5tebzGszr8dZp7q2WcAtdtDwZEpkAgCfUWSgOwScuywtHiLLIecyIrthEdaP3xWhVBF5MxqAkyiqB4nK3NRXOJDYgfP1R4ycPffToCYPzAlQwMjWFnlwsrj0k9RdVK/d32lvlqATPfZiTEUASTJxUDFdlCHFL7s9l7SircatsWQYaPn4QharsVjm8KYXWe89q8VCxgZgahFSJBWPbRoANu752Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2FFBjewlrNjNeiyGa+hPPk6EW+S2SbfoS2sV/ExrcZ0=;
 b=Ytfe72soyg0aEZVmZZzP1chhh+g7WeMS/xLfVNyTvmjeWLmrHDBtE3l62+VMfOqr9lyM+HppLIU6Em/r+qtIWYxcmaOhd66EkA2Z84UthT6/9T9WXL4N5015jhuXTPbnccdg2r+ECN1ZKMuUXydmLQSaL7pk4vfKbgRmqIAvtjpiGPGBbfbwHrujm3CmrC+s/vnZEpCIi1N2jlexl1I+n7hjsAQwrrQi10IHUyS0Lf3pWLXGA/LDW8P97OJV+LkFBJcnyd3MinrL8cGrvxCmrC+Jvc0aUPoELb9JMigzRx758l4BPsT8ayY9gI0Z6VryiWO/8hL/juw4Rg7WtNTZPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FFBjewlrNjNeiyGa+hPPk6EW+S2SbfoS2sV/ExrcZ0=;
 b=K+noT94PPbZDmkpeuYT9inPBbz5VdGpfx1Bo8Wujed9KUGx5dIrRrU773BqMcCpPEdoa3ZT7bPXZtPVnxI+YWdZWA/A2sewXVooNim3/IuQdUO0+regjLEWe+vuak7/YsJOzSm7Hyvh0GwSJtDY1pEPNGwKAsLujxe1bIeilvdEMnYWIqja5zV7glgS8gBgFtKDm6YhvVFQ95/SvfUedtW4kcGtCzUkCFSe//aJZdReZ9UVq1gxp/rCOh3mD0qQMTgTRGbh5FK8OommW4hr3k/KFKKOvbDinBEKKdwfDBzmcXi3FZff/belLg2YgXq0b1RjdBCWg3yj9pdOfuXalBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5800.namprd12.prod.outlook.com (2603:10b6:408:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 16:38:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 16:38:30 +0000
Date:   Wed, 23 Nov 2022 12:38:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Lixiao" <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "He, Yu" <yu.he@intel.com>
Subject: Re: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Message-ID: <Y35MhFBXyV4yzmF6@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117131451.7d884cdc.alex.williamson@redhat.com>
 <Y3embh+09Fqu26wJ@nvidia.com>
 <20221118133646.7c6421e7.alex.williamson@redhat.com>
 <Y3wtAPTqKJLxBRBg@nvidia.com>
 <20221122103456.7a97ac9b.alex.williamson@redhat.com>
 <Y30JxWOvo1oa2Y3y@nvidia.com>
 <BN9PR11MB5276B441E6C1412CFE5BBA978C0C9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276B441E6C1412CFE5BBA978C0C9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:208:237::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5800:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f147f0b-7db9-4f14-760b-08dacd7127a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q33tZ/QsFGBefOKJuWyIfQ9egnnq+i57JBbI34TuFTsMMgJXIYGsxoIJfvoho5HSeFgfNA3NblEaknfPiz/4zEvUAaSHrv3F24//cpW9UC6pX/itA19MDxpyPbKGI1C3j45J5V2YSApQTNvkpbZWzrhQ9/MF0mdckjhau32ijUNZ75vhpr+MEBrQSY8lPo8wEte3eN5FN2Xjzhp4U6nTAz3lIHDSGYljsAs5Dc8gHybNstUY1Z5/tv77sGlw2Vv5z2VljpwQuSbOwNpLJo5ep1GjYpU+WOLNM68xGQL/0kQIHVrJ/lazK+VPm3RV1+DIlhYbKT1XTftu+2/5SzBjpkQheuQiiQQgVjTYdfAktmNN746CHOP8c0zXgxDjZk8wzLziJrJAxLAc566JuJ6eMi2eECcLWaeighRX8rclHqURWH88kXtCbRNsqK7SpsVMvQqOpiF+kk+rH2Okit1wwAneBdQCPajZhOJG9U51Ff1zN1cxeC2en/JxYx2w2IOOK1xY5q7N/yd23LNlZMmuEZk1CVikbpHmI1lhysY6qKv8361ucReUDrEo9csmq8afZsbmaAwgToeOziK8gY3FimvtziScG36i7Yod5rDt4iMNPa4b65ALbvkllE4UEZpeCLIs0eM045x4yhusLmvy1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(2906002)(186003)(2616005)(478600001)(66556008)(6506007)(6512007)(66946007)(66476007)(26005)(5660300002)(316002)(38100700002)(4326008)(8676002)(36756003)(6916009)(8936002)(7416002)(83380400001)(6486002)(41300700001)(86362001)(4744005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/aUR36psMsphiHcar8s/J1aUxt8qWpmq1Fl24XsBVFKSOPxdVFBCTa9AMLDg?=
 =?us-ascii?Q?kIiyRBdy3+UMWFIPo+AYEONNA6JvSB9UT3/+SbR3bXuh4SkRZyJf7gMe/EQQ?=
 =?us-ascii?Q?TVl8m8mDtZkUoaXWbQwtoncSdzzte2VxyPmmvAdVfTjHTnGaRB82dFcLbInx?=
 =?us-ascii?Q?CE4NLif6FjV6oAGKW263b9KZDdwQtNGFE6BW/xB3CSulzLvGJGx/SX+jSdgm?=
 =?us-ascii?Q?54MIivU+QoMt42ApEDqNXeqOy06bvKhXjGoTS2eXGHxBBk0Vg+mgbxhxyDI+?=
 =?us-ascii?Q?R/jv2Hh0HrNb04cEi7BvSYCm1cRxCMBYyqedyCP+QeiErbXqH0yBA3nyEctM?=
 =?us-ascii?Q?ZcxKSzm6jdEVs8eQoHOUotQ6XFMx90ld9DW1uDvh0YcdekgGBwFv0TGwTFUu?=
 =?us-ascii?Q?cYPJ9G9wUvC8wqszwm/tfhlaFLRW/yxfz4drCLerN7owC6xDamCLCjjzU7+M?=
 =?us-ascii?Q?c8xoP2AdxWkx+/hUkyOpGWTjhMuvDUMwT1wuHsD6QB1eaQYZpDCPy/p/3aTu?=
 =?us-ascii?Q?npaRrDP84FxeCKM+vTaV+GvR+1RA/xs9PBIBHznIqCkLxWevoIr6hsv2Ggd5?=
 =?us-ascii?Q?ArBPMFC4o+qYPu7rpNLlq8zf4m9F7LLHrX04P88Y9eDinHlKAL6xj5ZR5RLn?=
 =?us-ascii?Q?Hly0e6fMQwDFP3hOb24PJCCMYD328ZnR1xMD3X5+zXeb55DmRkNrAwyqBZ2F?=
 =?us-ascii?Q?37lHJEG9lf/vbgo1fMB/7FIpLJD+9lWad+Skg91LHi86/R4brMbT7+k++wXF?=
 =?us-ascii?Q?VSUhJ8L4bWYA4h6bhhCljxu4fKMIzryFuaAJYB6QeTU6TNP47wLeH1E2hMIC?=
 =?us-ascii?Q?SUN8ATsUsHThatz3ciEDWfCSLTyICgfZMFEYLkbnCBq+R1W0zrf49Bssup8Q?=
 =?us-ascii?Q?KrgltU3MqsEvUEDxXJ/7PUGnm30W5y2+KtU/8lJM7LMPqau/ycziI9z+zSCU?=
 =?us-ascii?Q?2creWfiVPNNiYXgVV70u+jc5wkg0PNvvJxD61NmyePiwf7v9vBo2c0isXo4y?=
 =?us-ascii?Q?8FWDWesWpz/FnJMeeQCnVq2qI3OhSa7qqLgSkkSISKbK+LIX9+WBiu0kbZig?=
 =?us-ascii?Q?SXW5DxoOKaTD0PiYOWfs1rVG31ipqUeXI+lurPC+9WLlo8RS42T8IKwxz2Un?=
 =?us-ascii?Q?slqA0jljdJtRnU/B/X3MDFEqt2pexLBpMzKsC2xpkmqtkkDE6Su6fAWuEk/h?=
 =?us-ascii?Q?fiQSSrsNbNsqd9CerPKZWACPSdBxHPSFobSagKdDl6I2xYoXqKbU7kcnzDRc?=
 =?us-ascii?Q?yCOvHnhCuCbLepoDBU6/KriN7q9JeihwlFbecJ3tf+lVE856pRe8DJA5vZd1?=
 =?us-ascii?Q?fe+3cPImxm2izd+/7Bs6/CO1CYyU4UPiQ1ufY/eOVw/rUlkfmigrl9k60IvV?=
 =?us-ascii?Q?T9vITlG2xMqWkYOQRRG13ZmMaNJ2HhQHJk+iSktfXZwxHMLy3AV5PiwaBuw5?=
 =?us-ascii?Q?fDSnaifdZm0RWY1DVz02sKj0dhwhrLkyZthBKPlhqebntXCMKCAx7E+1sEa8?=
 =?us-ascii?Q?AFY9FBAZyog/dOQaJs7bs4HJFIXSwr+7lCC/ESVqwkEdZo88Y1p7CxzZBzvh?=
 =?us-ascii?Q?ZveZN9D0Keutxi5yrGY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f147f0b-7db9-4f14-760b-08dacd7127a6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 16:38:30.7659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8yujlGCH+ndqmevvF1tcPFXBAsxs1L/zbRhJOg/HndRfSGFfuBugqGCdAEB8Omp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5800
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 01:21:30AM +0000, Tian, Kevin wrote:

> I'm not sure the value of entering this mixed world. I could envision
> dpdk starting to add cdev/iommufd support when it wants to use
> new features (pasid, iopf, etc.) which are available only via iommufd
> native api. Before that point it just stays with full vfio legacy.

I think the value is for the distro that would benefit from getting
apps validated and running on iommufd with the least effort invested.

So I'd like to see all the vfio apps we can convert to the new device
interface and iommufd just to be converted, even if they don't make
use of new features.

It gives a consistent experiance and support knowledge base if
everything uses one interface.

Jason
