Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B9F704D01
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 13:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbjEPLvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 07:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbjEPLu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 07:50:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB233A86;
        Tue, 16 May 2023 04:50:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTtcwm09jPdHg25XFqtytVJ+tMCUzfRaLgzTqm3j+6oJX0La3m/z2pw6TtLGH0f6USYXxm68VK2fVZq2GRZO0Fgmkp7g2P7YJKXCW56dUxmpgvGlObTFOoTjeVjYQYhutkuYtqHkj3icXqPKTpEqqIJvovPL1KEFG1o6Q7F9RlARzS3cq3qeo2td/6d1BRStXzSL/sOGPJ6IbPTYrG1XCKnNwr9EBVG/7OWkcqEC+0gwKeRa8thVRxiRAXv+xCoSdDmkai6yHOXj871YlGA375QGcT1cYZdR9tK2wa6/LmmGLCJEbxZPnCSgMfjRS3d90TusRzAcE1xu5/Ib9nNf0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WG699DmJH6SeTcAYeXpzTiXEBWAB523hzq7lW5L8hR8=;
 b=nRTYkVuf19wVT3dGZ/vRT/lLTOaSeo6mUNGTAUXK8RFJKdA0p/5Kx6egNyWmzPaBu1HeEbj9qS2JTw1ng+8i/yTFM8CRJdXSgJh87KiaJb/hLm8yPcAIZM5Ea8YunNmLg/LwlM7am3pIxN9KiVcPI91ahvQwDlOI/JBly1Re7MEc1OI4CCxCiIkZv5lVoTBXB/wglNNgLtfh5NrT7uW4JfCWNlvXreo4QcO2xx+JJHb2OibI/08wRbLxSkutukPMbInW3iDqmDCk4vFtLs8cLb+k9wCY+UzdTSM3DgLjRlr+mZmWtJUIUPE+/V4sfiWbCHCxgx+rwh1mVcv6WDvcNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WG699DmJH6SeTcAYeXpzTiXEBWAB523hzq7lW5L8hR8=;
 b=XO32xE3G6hAbwqEVxiSRaNraRKTNO4mZBLFbmswWiAJqzl5zq6c8OoHy2pyO+FlcsRwvIAENDgt2Hr9T5p7DWij25A5L9tsXxTNXfPWYT2fHO3CedMSALNvQLaqBVtHf4aT0Vw7w9Liz06aBQQc0b5EO3huZIzN3Txc4x4u9VlOd8Ga0h2yozWH1SEq3rbxPElgBqjzvZs804oDs2srNCnIKEOXMFe369GlD3QuHBkbzaQI1DPQAuskLUzvsuJLQnLjZ15iq9ODuAqfI5XnzVmXlo3sInOLd7FLGgUIhkpcCNrwAOtoD0fgdJt3aRXC715Lr83V3AuvowIAZWRP1SQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4876.namprd12.prod.outlook.com (2603:10b6:610:67::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 11:50:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 11:50:09 +0000
Date:   Tue, 16 May 2023 08:50:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kevin.tian@intel.com
Subject: Re: [PATCH] vfio/type1: check pfn valid before converting to struct
 page
Message-ID: <ZGNt735oC1n73rfp@nvidia.com>
References: <20230516093007.15234-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516093007.15234-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: BL1P222CA0018.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4876:EE_
X-MS-Office365-Filtering-Correlation-Id: 22fe8713-be9c-4f0b-e2de-08db5603b2da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJ7jw4A5G+QhA/Gj6inmAg7htjFS+dKGAh7S9KPOanFEuckAQ1xDGYT7G+OaDv+H+rjBjAgeLOV7/X3FTqEme6bpnteH4omHsdDO0L1EqFmy+ZvtcLW4uAcf9sy2HPGRiF1OY9hsLyPfIYchYiZdo2jmQ6ZOhCYA+VpOaASqES3p6+YLooTPEBHpQ7+WyCPPK43hwA/NisrhECb11lZHd6OrvFJ3utxY0Ax/DO9avfn4CUYGVEqNvb+wROegABjg68FW5dNqJUZshocB5tbfwBDBEvsRXGoPDQcsBc1YR3dwfPJLGqJNFXMpEScCT75qmlfsW1LJSz2+HiXBA4rYGnSEvoXaonRHr8m5PV23XsqjzaekkcMkVuh7QooLLy+r8X1DhMucLOqfjUVClHSRMkA3Z7xESMFWBP+4bHTJ5Ad1nLbOUNhiGs7Vo18Bdri+q5q73iuFWkPWNiEUm0x82lr9qEMpiobc7GvXQeCP9/+fF0Ei+ykQfNvhnNMRVNhB7UeZSHPQI9J9iy5WB45Lpeke8KGXLanQ2wbkajL8RLqGJWB1J82tyt2xLSBYBhfb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199021)(478600001)(66476007)(66556008)(66946007)(6486002)(36756003)(86362001)(316002)(4326008)(6916009)(186003)(2616005)(38100700002)(6506007)(5660300002)(41300700001)(6512007)(2906002)(4744005)(8676002)(8936002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y0vDG4rYTtgjOZCqng3CfC/fl1wmPwnIdERqsz8hR4UJQJk4oFoXENMRox++?=
 =?us-ascii?Q?HaheY0Eu9PphoFADMfiz5Q/ioYqDBWS2Ib0sWTD5sGTDw5O8GEWU4TCV5D1X?=
 =?us-ascii?Q?IytKd+fie7xh7evlW9ZzraEnx5MeNWKcJ3cYsJKQiZUocvknXRD6KwjUpgrK?=
 =?us-ascii?Q?LPomNQJYluIpayk6rXl5mkDNVD0FW3qyZIqOlp9KU63jMYs2WtfdZZjRCEGp?=
 =?us-ascii?Q?RqLHW+kuz7VCf43MpxRObh47MEd2QwKg/QctBTfIhtNNLBi5Yg3PzVYKeWZ8?=
 =?us-ascii?Q?UZMI/FN4PjEjYDfJDg9/cQ4JhSgMUhJr0k/BJiRvjSjhQ/DaWDyOJxyQ3F+L?=
 =?us-ascii?Q?trSH29KyJfeqP5I5eQiIm2EVpoGXmmDJzMm0ZHPRB6ic9p0wDiRMUYMBW7Ga?=
 =?us-ascii?Q?HZXY7eNIdMcw3OLjyXxvPbE83vs3f2qW8DVn5ePIb/OfaufFKW6CT8tDs44u?=
 =?us-ascii?Q?5vgZMUoy2I44++espy1Uh6qqZisgc3sMj96k4sV+lNO3kfxm4LRrhNiXogNK?=
 =?us-ascii?Q?5sJ3yXtSRzIT7paLw7MPXs++rRkoF6heGuP7AtmJz7EOKBvjFlPkeDBwxOrg?=
 =?us-ascii?Q?pmbyNFgDHqQEg0F5QK8xwayNyxO34G/qMvduVQY2YfSYgbmAMdJ/DsFgMheM?=
 =?us-ascii?Q?Ztc92PLtBosq+gLwu0o7HQsOsBJnk83F0GyDKDE3tfmiVVGIXiMSMzIa3V/p?=
 =?us-ascii?Q?xAmDDVbmzSWzs2OP8REBb3A6Ih6cOShG9rep+jPjMcU5DYgAUXs41XfrNNaQ?=
 =?us-ascii?Q?rk/9Nr9rRAN+MYOEOP54Ia0eg8Si4sTVe/IvZC6CTCiEZvOYbKOHFqsncY43?=
 =?us-ascii?Q?fU50prU1bf03X6s1C552TBe33xez06jMsnqC1iliS8hwziy99wH5nVcta6tC?=
 =?us-ascii?Q?39jk0RpyG2EOH++Il4xwBi0tUT+140VY+KzmV9EbuaRvPUCZolBhtuKiDiTj?=
 =?us-ascii?Q?1+uRe9IgYu2q0rdxU7oGsPA+QE38pAH0YmtzS6U71qxsF/T7bXPMzndrLD+0?=
 =?us-ascii?Q?R7GfEGebOk0aSV0VCydEzjJwdn9Fs7shcR5kyR/d/sjEXz2Heywjn805M4qp?=
 =?us-ascii?Q?iU+hydQF2YluTZV/QeKvCD8g+x6aS5IR3xVzz7g1OYyuhxEolBVg9wl90eLP?=
 =?us-ascii?Q?ly7suvmYZI5XvdPlFaEldo+55Zt3mhXA8QmJDxQHNkMFVhmch78VZ2rTQZSn?=
 =?us-ascii?Q?5uzY40cop3b4nIFr6DCMfa1Qy/cVMyZv4HsxuYhaCUqq0/dBW4wQYl5mlAkM?=
 =?us-ascii?Q?PaKjy2IBVT6yKDy9ur+QfAeC2cED9+f8DDYhjjavxukaJcbY/7W2UBwZhSZc?=
 =?us-ascii?Q?dbgvV+dHFuuwFVoPfqOvCDZt40FmFNuvMiu/U4hKvESYOrBuEumROSeEwL1w?=
 =?us-ascii?Q?arOBuNd1kghlRYi/DjwO4IXdjTPFbOOKV7g979AW6v2DconcqM2FsO4pyuC6?=
 =?us-ascii?Q?0X6ZMmjkVmE9vC3KnYZ0Xq5YeFAyLcIfTpkTKgDjjMyu6gCXaFp4lyvEigjA?=
 =?us-ascii?Q?ipksv2nX9zJzEnvWGXIHcBYP4bzUSPfIBHdm0ZpHHHMKCAfsNsYrkOF/+X6N?=
 =?us-ascii?Q?MtsCuBm5EPxnf2YPR7aYIVZ8cWoxI9iLoKanaqGo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fe8713-be9c-4f0b-e2de-08db5603b2da
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 11:50:09.0306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4jRF/DSeltnr/eQczzxs6SMcllO2KZj9sHrosUVM/bM58r7PN2C4Sq471S5nN7l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4876
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023 at 05:30:07PM +0800, Yan Zhao wrote:
> vfio_pin_page_external() can return a phys_pfn for vma with VM_PFNMAP,
> e.g. for MMIO PFNs.
> 
> It's necessary to check if it's a valid pfn before calling pfn_to_page().
> 
> Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
