Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725326C678F
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 13:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjCWMEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 08:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjCWMDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 08:03:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3B146B3;
        Thu, 23 Mar 2023 05:02:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMIWT5nie0SzGDNZnDk355OT4rnWRpyKCizoCoD3u8OslrdPx9K5Hq21H7vapdivs5nGiPXPYksOOriDKENSv5g8sM5vZiB7t+GYbXR328MveGSeF3bsfr4NNjJPZqSMG1fxwxXdHyWy6iVOa8R1aBgEpaR481StMdb+UbGoTuUnTWuBCEIvrwmCoFarxYBWUM5iPyY9/e5eAiSHLMAsE/FM+wGFKeTl03jPOscMN4Av/9Yj+SmPXFgDxDatA34OZ/7ooNcGw5n2sjsLaatUdD2JtMJEn0p4LdcZF3Gyw6M95Peu8Y7fS/ZDtbRs9SAii1jI+dxkKvTa9/Hd3LZ/rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3ZbJy++1hYz2IzOg0tzFrdGkzStVMQrIMAtvTPJgCA=;
 b=UbCefoqt67hqZqU8Fkt6b8IFvbWv7x6bArZToCMKRtY0WPWEdvqOt4KNKI0Bwehc+H9l+CL/n9nnPjOdYnZZssVz2gQaTXnWi7H60m8iPNe+IB1RLJgGGV9bHiiOYx53Iir2orugYZx+0umIvEmbDFWZlns86Vo8cwACOtqPrsnCyUgMzFzX9gvkccp8hq2yoQZ22WeFZ91LIdVk2hS6KjETSpqQdab8kwglD8bB1lwffcstxdjqmIePvufRTNCBGQTloYIDr5JuUDfvKiew28yN3gRMqH/FM2cmTFWvqiJD9IU+RVkpzqkNxGjqni3uydfIQcP6CM2A63c+9/KpRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3ZbJy++1hYz2IzOg0tzFrdGkzStVMQrIMAtvTPJgCA=;
 b=Kc7/EzW+woLngkm61hvteKbo79y3q3QdS1Y0kxOinRCSI+Zn21XWvZKJq8pmWT5KyVFYABzu2LSRxIvLnjf9q9jtID/qtMJRLULz6eZVUB1Ee+u30MWghYO8XHY2LNZX35iMFPSkumUbOVJaZemsi5LZxhkXPN7AGXiWzjQV1yksd7btOatNOOQsvuskPDb2PBk/zezmZGQi//Kd2EWJrRmT3Py4Lftzy+ft82eX4leBYtDdhTzGA4495w++KdbIEVyvTPyswRXMs30snuyVuh38NkXnXP0UR7cpI3MjRRoA1y8SzyfLLmoPld0RrBZ0qtGb62sjmYf3V7SQwK7qjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4302.namprd12.prod.outlook.com (2603:10b6:208:1de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 12:02:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 12:02:06 +0000
Date:   Thu, 23 Mar 2023 09:02:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBw/vL9JyueByMv9@nvidia.com>
References: <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <DS0PR11MB7529B8A8712F737274298381C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBrx98kqNZs3jeWO@nvidia.com>
 <DS0PR11MB7529E4C6196C8581CD39A7C7C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBsF950laMs2ldFc@nvidia.com>
 <DS0PR11MB7529E2DEEB1CBBC9413A0480C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529E2DEEB1CBBC9413A0480C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT3PR01CA0136.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4302:EE_
X-MS-Office365-Filtering-Correlation-Id: 88a84e1c-c801-4f55-f73c-08db2b966c00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lAZCS0JrsH6DJFDZPZA8OY2vBMe5T8MEGrYoNAxUyjavhZbZnlRFcVGFXPi6B0uMHrXEfjy7WxGK5zUlbexByIlCaYTtYxGq8ye3/un+RocrSrL9eN9ekbfrcg97OK0XQUB+82C3Rs86m849U8rphfRk0YovNgdlCWoxutZ8UdOH6OA3hKtrWvnZ4exWfhK1S770TIM1AO6FIsdQe/9iWa6qT7FI1Rfn+yfE1WAI8vAnXOVRgvKlIJTSUxCoG1XuM887W1oMSj45BRMRlNhkjQh9b6s2lbZN4jzd9k+OrwWuEnHOGs8DmfM2O5h4hF7gbZZXx6l7M6M/dycMAnNILgaYVu8AKHOakDPsZgtznvb4iqddcl9YhyM+U5pOVvsarpw6cYF3x3GE721Ij4dBiGFKk1Y+WTGby+nJKGh2AGhDsJDPFnGGwDKEtIB7q2nxMX5QsCEdTdkQiydJPj95zEgutUZdKN9ppbfIocvmEP5qwyl5GwQLHh/4vN8jyj1Fw3Zz0ulGsdSFLKtXu2/Kl/Pvr/2uBt+5sdbmumP+O0rbRKkl4pF4UFONKRb8sxOv+vQ1qqXXNy/GME+l09rq/UD4uDKDUyxZxgC5K/4hQ4R3jIqZYn+VgE3Z7SLuqOYxfsQl1Eito2kFtdWGd6dF4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199018)(8676002)(7416002)(5660300002)(316002)(8936002)(478600001)(66946007)(54906003)(66476007)(66556008)(6486002)(2906002)(41300700001)(6916009)(4326008)(6506007)(6512007)(26005)(186003)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6baHyPcxETnRdBO9pdL/vMYFzQEMvZlAubtkxH9EYw2x/qb4BNVG/eHgOqx?=
 =?us-ascii?Q?Jvv2425MkNK8sLhWOpth/LGPTSllVIpvri5JMfb7SgfZaD7TXxKLC/Ekd1kw?=
 =?us-ascii?Q?EdbRxbBlVORAKUQmi6VQ/btU/uZLE8hiWtj6wgnuebr8XfBrq9UFaBZ2Spb0?=
 =?us-ascii?Q?2hpgF5KCHCoBCbZ2YsfBt+39sEAxl+nfrYVp2EOf7x7HWjiBQu101UxaVZvY?=
 =?us-ascii?Q?5bGimyMLpPV2RwEYq7B8BUYtomm+p04lvQcLy1K4zvBRHoJHLzvXDNiP6a5x?=
 =?us-ascii?Q?n0UOc4EBy3jp2UWZwlZJEk49BHcD6INAVsFfb9qzf11F+xAuUGA3Kvvpw0JZ?=
 =?us-ascii?Q?AsbMbDc+IZEx8mkK4c5ip1zB9kFO7TY1Q/qLF6FzxggP5hetBcyKxyyPkFNa?=
 =?us-ascii?Q?WXTvYtrudUEe7t3raoY43oMErJ/1lPVMn3u7Fd+ow0p8eN6tzB7ZWXTSY86E?=
 =?us-ascii?Q?wXt5DLGL7oXICoMNPeb5L9OMMurfQZLk5P9TRRV76KE6FTP4oS9kChWkLkoz?=
 =?us-ascii?Q?Pfk+EjRjmN/cPV19BgWY0HW3sIrAHODHPVxH9/N0gMUZwU1P0cFNUUkkXhRJ?=
 =?us-ascii?Q?yZFbrcYfRfE51KI8rEYKvH9ZxBCY4y5WydzDOHvvgZyC+haOPsCA8ruOPSFC?=
 =?us-ascii?Q?ULNXD0RpDcF+0KyLUcB9BPTpXs61r8j1okEQaNWmD7hiCxxGdMP4xDTT+FAg?=
 =?us-ascii?Q?lrPvptgHvqh9bWwGv8lYRu5zVfezgC8IbH0LIPKPvHd/eyanIqS351RrAdB5?=
 =?us-ascii?Q?pT/5OnNN+D/ENF76tvvV3Z3FsH23vBx5ALgvLj/YNEXrkrPHXUJPP/rvXOpU?=
 =?us-ascii?Q?cxRqaxETK1x0pB0P3hOUDVbPBquxBywDN3bV90m2TplPVMslj7CbB0EvCI8R?=
 =?us-ascii?Q?CJpqdPUxks9c8dW3IQbtWJaohG/1C5uVKss1DOaJsoETUD2L+UuWTDYUl7GL?=
 =?us-ascii?Q?r8i+FfsMqJ5gE0wVOZqWhsbB9dqVXMCQvYDmz95zn67w8yVjsKrheeFg9CZH?=
 =?us-ascii?Q?DOhIBWUj2TjFMT6JBqTaNDGnUKrG7mS8hVoaGDZ522Rd1sNwKyJ8nRwoVtdd?=
 =?us-ascii?Q?s+/hXYxWfRI9LWvJGCknodMDVp+ozn5B8MPR/fIcEOU4sJpsMwVi61ziYwPB?=
 =?us-ascii?Q?p1knWqWCyt+pAB5l4JZ1hsu+No9ebAoB72jGeRatdEOpEW8yecoUbAMTTggN?=
 =?us-ascii?Q?PdEqcQ7VIKkKi8AI9WiHOChwK/SNTgDxqgm3yghETb4BGZa86Q58rfin0Wuo?=
 =?us-ascii?Q?EtvZ1Z74+bp/1b5xX+1GRYFa3EPcCxdOxWk5hdaFt8H+QWDz//NFSXn2Q8pz?=
 =?us-ascii?Q?zqh0YXte5cbmDzNM1vp0uy6eK6Knzcc09mgERdzj2H7hRjMMt6t9Ett4lZgz?=
 =?us-ascii?Q?penq4zroGUNAydofYxAmoo3JxKo4z6onQA5aWTaE2vYyw1mlaA/K8GXqRXbS?=
 =?us-ascii?Q?GQMZHNTA5dBgetp2taU/0w2SnwyaAYKd+YaEWecqYE4V8gvXRMNIEZVCmFR6?=
 =?us-ascii?Q?b/6Yry2pH0PX7f5bOuyTFUCxQAkFByxWMyhRRDRqLqHCPaIq7piQ3U5j+Yqb?=
 =?us-ascii?Q?SEfDS64Aj2xsVX0MjkHvZASL/PhVwZaDbD6Ixgr4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a84e1c-c801-4f55-f73c-08db2b966c00
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 12:02:06.2335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R3pUuSh/rfPwdvJqoy4GYAHJ+xgKyBplzSADsDqXaGj96aG5FVXYXJBGQB9rANmE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4302
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 03:15:20AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, March 22, 2023 9:43 PM
> > 
> > On Wed, Mar 22, 2023 at 01:33:09PM +0000, Liu, Yi L wrote:
> > 
> > > Thanks. So this new _INFO only reports a limited scope instead of
> > > the full list of affected devices. Also, it is not static scope since device
> > > may be opened just after the _INFO returns.
> > 
> > Yes, it would be simplest for qemu to do the query after it gains a
> > new dev_id and then it can add the new dev_id with the correct reset
> > group.
> 
> I see. QEMU can decide. For now, it seems like QEMU doesn't store
> such the info return by the existing _INFO ioctl. It is used in the hot
> reset helper and freed before it returns. Though, I'm not sure whether
> QEMU will store the dev_id info returned by the new _INFO. Perhaps
> Alex can give some guidance.

That seems a bit confusing, qemu should take the reset group
information and encode it so that the guest can know it as well.

If all it does is blindly invoke the hot_reset with the right
parameters then what was the point of all this discussion?
 
> btw.  Another question about this new _INFO ioctl. If there are affected
> devices that have not been bound to vfio driver yet, should this new _INFO
> ioctl fail all the same with EPERM? 

Yeah, it should EPERM the same as the normal hot reset if it can't
marshal the device list.

Jason
