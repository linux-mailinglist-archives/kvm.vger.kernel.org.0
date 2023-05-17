Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58156705BED
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 02:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjEQA2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 20:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjEQA2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 20:28:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F388940F5;
        Tue, 16 May 2023 17:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mA4Xl4Iu5B5IDcWXdxx9mOP05mUiBoHt8y8Jh4Hn/V1X3bAMOw5l/Qr4tgiXnPvnigs+Lc5CQ6TFXiz2HZLzLXcC4sdtGHG2PAm3uZbeZNyp0zK9AR1jqp7T8NLz/LTM/cZJIy9TI2wMuJaPUn4Q1r+coJwF7jnrxHJWY/ae8HAUURmvmq8EAnCz6IQeCuyQHEpYMt2Q7x4vEL2kHYC83FsKnuUGoce98gn6wQM4nY9KerrWicp0HEzDRn2xsT9Y4nw9+/N4lDuK63LV2wiOZfXnvwKPdwAl4fRxAj9JZuQl8vyVmXcOGOxQN3uwm+qg3xtGPT232E03pjCdtZQiCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1TX1WmCR2FBlHduYoJbtm3AnrqnoauD69JXt7/L1W0=;
 b=Jx4YGL+ORsa3b75Bg87s1i5ltf3+6NsHBgOsQX+czxECgfEhc88ENlBDsNcnVv26FV2oawvG/YWPLs3/KOF/scZQr+IXr1XqVZTJaWFu1svP9K8OOZJPw65BFtoF2oUysK+0lIHamuUi7ax0uzxEmJ7QyEHiDj0Q0PgQ/15bNCOhOBSwhCla0Yez4J+lJTR+jEHSTxFZfNHAviSfA+cIDrocXwizXH32FDahXIkOpfBQKZXmdEaI9iraJgB8OyqFYdk3Eg5iWfQ/6+pw5MDdQL0qR98sH76VOIH/Y8P4YM7cSmJ5Id11tPbbtD3WieNrQzqr4zs96jBBdO6+D4XnFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1TX1WmCR2FBlHduYoJbtm3AnrqnoauD69JXt7/L1W0=;
 b=fzJk2Wx26FCAYYOcXRG2VP1StFcSHH4wlrDwimWp19k/LBEzy7ccERqfADwPW/TnXcO+9eNyHf5j/0aoJSC3DlN69eCjHjhQgv+h9p8nf2ODX3VzPPbgldALOFMYk4atOOUS45jWDS83mEG4iqn/gGqduSwBiglnCVZ9UARUQRkbmAjffwwOVV3lxD5gvcMURLuOKgmG4yzTmBsX5gRuhk8eEuAigYwZI97J4wk3LqYWzrPaiNP/9Sx7mX0ru2qquWISseY2XoWqKxRNulEi8Wbo2p/jmcbHd0gR3KCC0K0Aju/DIajosi9SZGisGSStQC4Hxkhk7N9foPerWu4bBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by CY8PR12MB7490.namprd12.prod.outlook.com (2603:10b6:930:91::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 00:28:37 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2%7]) with mapi id 15.20.6387.030; Wed, 17 May 2023
 00:28:37 +0000
Date:   Tue, 16 May 2023 21:28:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com
Subject: Re: [PATCH v2 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZGQfszAGGKhCp20q@nvidia.com>
References: <20230509040734.24392-1-ankita@nvidia.com>
 <20230516150914.26ae99c3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516150914.26ae99c3.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:208:23a::23) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|CY8PR12MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e524fc-5764-41e3-a9c4-08db566da796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/ujQUDRb/YW0MLJmY1b1N5xIOaJ9JDXyl1t8D7oGiavQ4o7Bq2CG4o/Pv5Q4O2SWByJG0nLhZhaHHU0pBJmjqTBqR1L+hQU4N351cDH07vs2Iw0cpUA2vJC7+ac01wUUNdaVLVuvXH1s/BH/NQ96ZaSpqbLhIbfBHqZlYsabPX/GTA66Mzsj1Y1K+Arf3Aaekwd05RMUPW1HcYktmmn9vVibBhsEHl+s70xh+6Z58Gky19kXVM2IrmnMQf9qPkbtuLhOgsTqTmCzzpIv+2rdGNtLNR5O5i+ZNMvFoLTIeMxmdNfmHvE31hxdBj0I6GWPCh5abDxGk4I+eOf/JhZgFKbvPEDCOqASx+VktqIMbHq1eR2MxUVwKurXO/qPWbRrBEXbMuoOg+VuC6Fuyeif6xZTYJrKHdrcSQzU+326InS1GnD3ZQ5vI7QN5upLJyNREt68/lk+PHC5kmeABE18LFkYBrP+xWD5OW/wFZFfFLleR8lP/D0u2XNTrv+t4CmhJx9f1+yA/6YMmvVl79dTquGp/2S0UeNg7/C/ysjqsshn8W4GDwEI0eytHHMBJx1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199021)(6486002)(36756003)(2616005)(83380400001)(26005)(6506007)(6512007)(186003)(5660300002)(38100700002)(86362001)(41300700001)(316002)(478600001)(8676002)(8936002)(66476007)(66946007)(4326008)(6916009)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uiH0OUfLxiJyJV9TvKrKUk4VZJuRGCQyl5LMeT7K3bJuTIpWfqfcMD91yLJl?=
 =?us-ascii?Q?ULV3jnYxl4hJgP561fpH6LT2sd7EpxQ5MK9GHlm0Djz/NAOu2MRZRv8Tvqgu?=
 =?us-ascii?Q?lQRNDIE5tQHAg4otuByppLmlLM82wXYvviTWdJZVwhDlXFg1FJN2MWF6mV++?=
 =?us-ascii?Q?txFRpucCgxOVVq9yyUbn3cdm5q0ZGmHoOF1CcnM1qcpP2k6zqc4jwIVGjjlj?=
 =?us-ascii?Q?s/xWdZtm0TH+MENm9o7YIo6Wbqypo1IkmfZI3IRkrMazJJ2tKn6MRHDju4Ns?=
 =?us-ascii?Q?PEIUTh6egbRGm+3WY9lEy5skk1vkH3qqnJXzNSogaubw+zSRgUIqWR5L1ObP?=
 =?us-ascii?Q?fAozzHRCDvsnvqPSd1yp6luZoVWZw5bOLhsn5lLn9cDyBkfFX6BKHu23UpyJ?=
 =?us-ascii?Q?POeG0FEgUsgZHuvqxKUVlsXKI3iHKherkV2j07634yImFLIrBRdmjBPwdyKa?=
 =?us-ascii?Q?cNv8avLb8Muf6yxzXgxw/xI9hUVjs+nNmKekjX2wQWl8BNGoGBnbUF+NSMLq?=
 =?us-ascii?Q?rxnW48SegbAJCAbRCM6c/Hi6zA+7Nm0+8X5EMTXYyst9uFYGfpvWoT8Ea18o?=
 =?us-ascii?Q?sHFxnhUMUVXvsrxnAnou21YVUFGFDjjf83bUxofQmjG8fHbbo2LBbTFtr/O8?=
 =?us-ascii?Q?6b/Myhz1eZX2uk+MeChov3U/KZrZN/uREVYocoYRZtzPcT7mGJALX+437Veq?=
 =?us-ascii?Q?Me2Fop3HU/3aVjP+Ul1LfuxuKm28lNWF7Qaf8JkHQ57wvd788jZqXTtWY7V/?=
 =?us-ascii?Q?y6/XOyPJSOHBSVD1hMb1xAkAKuvwBwP2O1iV5+4fq7Q+baBlvRbkVStAQV+O?=
 =?us-ascii?Q?c+Sit0kPwXmIA18h90nKG4xaGLZm5ocFnk+B7imlVYNFhowIbYSR5M6wqA9M?=
 =?us-ascii?Q?jylIc0nta+EL3Hlw5rpBudqPppAmLN7Tzt6OQykqM9KGmNm7vQBeqRJ+qy3z?=
 =?us-ascii?Q?jGfNaYE6qVuh5JO7TMoUHh6n46F/EN8nMVhQp1BDo2oTbFCrr5imy8Y7I0q/?=
 =?us-ascii?Q?y3TOf/Kkupi9QdusBf7LEtBmdy7IanBajkozpcQNiItGtoPJEC1UxaYN3eCs?=
 =?us-ascii?Q?NgoncvdIJSl4JLKdESxLmNZtBxwohH+9jsPxxsAcw7rQTNJP+wjuTda5CIC0?=
 =?us-ascii?Q?slfgoeu69VliOlxZsD8QpoX24/XNe72NK6UL/ahiwdsx1v29E0BgTZVPLULH?=
 =?us-ascii?Q?NBgvNJFIZfFq6a0zL7mTko6+qbOjB9upMa+Dxry02p506yxE1d5pkjSKKLls?=
 =?us-ascii?Q?QHIzDwQ7Bk0agkvsWFb4UQiCE74AQObIPmDB49wCjKPb+SI9H4zhrKkF+Izx?=
 =?us-ascii?Q?EPcBlLivZZxAhC06oCvWIfQXq9CWPFF0lVncsmMB3tfp2pshPYdgFQ9ZAckh?=
 =?us-ascii?Q?MRN3OBpkX1JhLcRRbm+5FGHWyK1DHbaY2TzGDUtRYAm6wrGaGi5VlCJCPvb1?=
 =?us-ascii?Q?MYU4dJkLYjUrQuPEHbPKwi34HBJ8wg6xgZ8Tp16fPc8x2ho1Or2RE2/YOKIA?=
 =?us-ascii?Q?pv3Po4Z0tKgHYSSkYObsCICNTfHA/GeUHz7ZheJeRCQ0m/pmx2RLNipvz0+U?=
 =?us-ascii?Q?dANE/0I0/qxVoQ9u/Bh9p0rCak1llkuqwKTzVGdl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e524fc-5764-41e3-a9c4-08db566da796
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 00:28:36.8666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ds11jTz3Lb4/Zyx+5nA4VayuvSIxqSIhThA7psAJf4CSRtilzM47MrAUxUIwXYG2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7490
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

On Tue, May 16, 2023 at 03:09:14PM -0600, Alex Williamson wrote:

> > +# SPDX-License-Identifier: GPL-2.0-only
> > +config NVGPU_VFIO_PCI
> > +	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
> > +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> > +	select VFIO_PCI_CORE
> 
> I think this should be a 'depends on' as well, that's what we have for
> the other vfio-pci variant drivers.

It should be removed completely, AFAICT:

config VFIO_PCI
        tristate "Generic VFIO support for any PCI device"
        select VFIO_PCI_CORE

Ensures it is turned on

if VFIO_PCI
source "drivers/vfio/pci/mlx5/Kconfig"
endif

Autoamtically injects a 'depends on VFIO_PCI' to all the enclosed
kconfig statements (and puts them nicely in the menu)

So we have everything needed already

SELECT is the correct action since it doesn't have a config text.

> Is our test for vm_end < vm_start in vfio-pci-core just paranoia?  I
> don't see an equivalent here.

Yes, mm core will not invoke the op with something incorrect.
 
> Can we also get a comment in the code outlining the various reasons
> that this "BAR" doesn't need the disabled access protections that
> vfio-pci-core implements?  For example outlining the behavior relative
> to BAR access while the memory enable bit is disabled, the bus being in
> reset, or the device being in a low-power state.

The HW has some "isolation" feature that kicks in and safely
disconnects the GPU from the CPU.

A lot of work has been done to make things like VFIO and KVM safe
against machine checks/etc under basically all circumstances.

Jason
