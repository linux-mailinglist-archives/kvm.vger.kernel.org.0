Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB0562310D
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 18:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiKIRHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 12:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiKIRG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 12:06:59 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590E6F75
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 09:06:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOGz9pKQZsNNcUfDEiv0ARKPW1hetrMeKVXQx1butRDuTfj3jXUhGXuNasvYZfa7KisyL5V/GnvJj0O6a6nRAf+47JJr5koAg6+VS+BV4u92yvtPrOfbQJ9KW8dw5EESHHD6r8zhUxdSaP7FT5xm70UQVcPtN0dmuScwR4XkXn3yUO3S+Qb/EZk2z8m6NafYwlMMCgXELOrSkK7d1VaNCFccy68LnvCJ5/xC0TEgjfBaiwA6jgzhfJbVRbUsTlm4z8AxRcWi4ltbgfNmLl5ABw3adhRH4ilMsRXqk//y2n8ZRaAtM+CN0bcXMLyUrbLY8NAmSxjuSgZYGt1XULTwsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXVUVmjqguLhjMBl91yKAZhGoCjOXlHm+A8OPJfd/+4=;
 b=i5wtZEQ7IMuTOxgCGBdyAYxoqNMH7es+kDCBXjVfDgBpNFlELBvgzTaa99yBDPSiIFB3oQtglvM8o9tkbOllyEvX608RHe5iao9Hw+ch2FtW2HiWUF3JolkFuoEgvfyhdVGHxvGwM2/ebtk1dteTryXjwDjamEP38odkTwRbwAM7gWKwtxtgxcSH1rVBljJh43BQyrhQ5ZtuLMpKay7fDTZWqYUHlOz3T0bQZ1WCY4HzPu6WM+W/2cPr5PlJsSa2IHi4ay4G6v/Ia6UY4/IDjB+k4H8IwiGJUmhpOLP9/KkRwtnVjDAiREoN0nWIYZIWN26oh6AV0QpSAs2wqRiqfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXVUVmjqguLhjMBl91yKAZhGoCjOXlHm+A8OPJfd/+4=;
 b=fDuEHmVLP4kae6Wdz1BBZ2wJngt2m7ne+YBhu/IPJmin9sBvN+z3icDlnEI80tIiQg9aYCuxHnSrJGZzwNrpImWoPskob98gUrCjwPLD7/FuwdzkDwZ549UT+XulceRHnThQAabkI7K8hqJvmuMrzCvXLzbPjXVL+TcphEcaU63vwHRrKL0Ekf45XEOpyIy6GSF6sXfTyDKzgP4RgQPHJSRDR/gQwtiPy0D+G2+ipMUn8GRgyyqh9cDuiKoZ/31vRzTeXXT3bAr6xKm9WO/sFaPUWq+AS8i7OZG8ol019wTTiOK9DtqMXixMPvwB3ICqSn2Vr2h1JLu4mEHRbyd0MQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6827.namprd12.prod.outlook.com (2603:10b6:303:20b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Wed, 9 Nov
 2022 17:06:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 17:06:56 +0000
Date:   Wed, 9 Nov 2022 13:06:55 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        shayd@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH vfio 02/13] vfio/mlx5: Fix a typo in
 mlx5vf_cmd_load_vhca_state()
Message-ID: <Y2veLwbN6qjnZHhp@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-3-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106174630.25909-3-yishaih@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:208:32d::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb52ad1-bbe4-4c81-3124-08dac274ce92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nC72lNX/KkOWfpqECUndvi0HDQL64eiWzsXbqngPG+a9sAolAUQuBDfyNetjx7b52Ba9yg/iYe/kKnh7QInN3jmN3JqJkhCw5twIDxKH0oN2rYJP86takjun5igEDRhdfesZMtl0U12060ZvwNpCgFgeVtIMwNVMfjhGhtQfmiBo6UTJcmYbJ4oFS59tfVHQzd60vb+ElvwIalrT4whbgTFQUQTxfciH17anlKs5Pouvwmd22NMJwN+jwERNRgraIqQB6UnoaEy8ACSVyjBqSSRoHqji1or7s4aHvZhW94jN1TJIYRr3VaiITsOPkRLdpfqxjv3c2xbSHjwTcs9/KrzXMetNppxhnyGtZEyrzIG4P4IE5iu/0wAtGwkqLOLGOY9pebuPaCtlDGZ4lXlEdNYn5xmLkrUQ0Ecf5rCh8tLAbACW/WwXsYg4c/Pcazo2LySA69MRdcwagym/Z8gOkSbj8kBBRbGK/10B5F46IgfNJh6vfXn/M9qmBFnjdY8B089x/Vk3AOGJVUWpOq3QE3qr0Lw69pO3qJF+x2S8I1DNMBD7ysuPDF/r+Akxgq/jVxNGAWGo8G2jpwgQnX2KXp9gzEKsgzHKF3HOGrs5sM7MrhFTQlIMWSsZPkwZ49MZBS9MncUdM0qLxbqwHlSspTnZBGNdnPxflJEr3/iXnYf4ZWnBVFTv0x8GG8+V82FqGaxCXhA1Mc9xrU3msQgH6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199015)(36756003)(86362001)(5660300002)(2906002)(6862004)(38100700002)(8936002)(6486002)(6506007)(37006003)(66946007)(6636002)(8676002)(4326008)(4744005)(66556008)(316002)(41300700001)(6512007)(186003)(66476007)(26005)(83380400001)(2616005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WP1/K0awJ16aRJCsgAcndPtAE0d6Cabf0xM1Jl6jz8ackQCNf9ZD7wvmiuFM?=
 =?us-ascii?Q?EUWTjksSRnm+dyo+G1pgwZ/gO6vht/kMylqsqDcFEd74Yie8asiunjbFbXbt?=
 =?us-ascii?Q?MtNyjaJtL2AECLA47H4Y9ZUeHhsFvN6qryT9VQDUu4e2H8VsOV+wCsPpPu8A?=
 =?us-ascii?Q?a3mol4Taym/MMfzPoBdryxra6qdmop4WYB0O2KT2C7tGQ7136C21D9Nz28iz?=
 =?us-ascii?Q?eqkyRnL1Ah8J4ejhibSszwiDiMmyn2xOL2TRwNiiagnVNEMovL14X6l7SgXr?=
 =?us-ascii?Q?hjJK8cM/E7dgE9qu+IoNczTwDueJOxPYfzCmlakBChY9d9OCeMuAH13GObGY?=
 =?us-ascii?Q?oSCzICgr5d5dokE+4sJ1/P/fAEqdS6JltqErKwP8p5i2MqA9MW0t2mlSmeI8?=
 =?us-ascii?Q?6XuHKkjsIR+teeDqBCOCw3uMCZgGLcUyenSU8ePoksctjZUQkukBIoi1r2Kx?=
 =?us-ascii?Q?MKyiU3o2V/lei2WjwkaTPSeGcOPWbWy57zLBROZLWlVcXFAyR3Ii5rpCVsQy?=
 =?us-ascii?Q?VXabTNNyZmCJ6FsKc8vYCLEax6Ow1eH+pWz0cR0kQc2lHGstfg+mYVYwG5XY?=
 =?us-ascii?Q?VAoBy8WsQo7t6ycB9I46la0mNGFeL/kAv6Z1DdPy/vBMY8OFlWmaPcRhRxNL?=
 =?us-ascii?Q?uKY6jB3ULSfIAuFvk+pC9xgrVA2CaXyTV8vYlyeYoocd26wFrdMcPMKOnBWd?=
 =?us-ascii?Q?tAhtUlpIpNCriF5JvYCCgJkltDbZYb7+QnDlIFLS6Sx7Jf4LHetTgVQhgNXM?=
 =?us-ascii?Q?RQzZuZiT/MVTrzB0Al8yMpn3mjTzpdGzud01XAi8aV3HGYKTmT6R7MwUxrd5?=
 =?us-ascii?Q?z4jYk+f6BHen9SO9HY/MzvalDdxSKE7eEkRgfbPnuWfBKmbaC0vc1RnHDCXg?=
 =?us-ascii?Q?zVm7lz+bqpx1jYuyE3fCIUAm7zRrOjQcwd3TVfqkMEzCswwKBQnYe0NgaEWE?=
 =?us-ascii?Q?TLt13ZeT1+7VxR7+VkKHpcDlAN8E3+sbAEvBZnT30S8B9WvUr6PwIayO6DLC?=
 =?us-ascii?Q?SLT0hgq7O9/PIYkPmiAsO+/rv1mGdeWUGPGoiO88ux0jbwOpMtPekW3R59YH?=
 =?us-ascii?Q?mpcJFvJQ76+DBzxrlH8YRQ+Mfoy8ZEwtUTLFj9BicraXXgzrSFyImmSBxJVH?=
 =?us-ascii?Q?rWXhdqsQzOMI8yKjpoqxpE8UVf5HMmTMmlLaRzFC6EFlig0pLUhkGTsbsWYf?=
 =?us-ascii?Q?Ed+N26wKMNEliS+OH4cB11N6s+rCJkx/q14s5Wjd5w7VJxJ6y+nyG5muNxRZ?=
 =?us-ascii?Q?bONHINv4ByIyoXeDhbof56LwzmJQ5LkQz+VBxdGDEFgHHqHJEo48eBnuXXDJ?=
 =?us-ascii?Q?W0BFDTqGudrGsx4VfcRtGxSfxa/+lRv6FMY5sSIxM9d184AGVb15oKHvuuA9?=
 =?us-ascii?Q?eTfzc3HpdGXep0eU6m0/G/w8aCni/I0opCK1/SL9Tmraw2nc3iLbbXDj8Bkj?=
 =?us-ascii?Q?nOA0D+CkzexeEiOR/eLGXKufi+i1Z4D3aJ07zbnLxHx2lswEBCjZE/cOy8WB?=
 =?us-ascii?Q?uKeZB54E+Iw5Po2jsJKUG2PkEFGBrlDoEEkkdsI9YI5RCWiPAJCTchSzt/Na?=
 =?us-ascii?Q?KO1uKc6U0BH5OTOVWNc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb52ad1-bbe4-4c81-3124-08dac274ce92
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 17:06:56.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: azcPOCMsp45pSltg4VQ7LPrC4Of3t0rNaX8kFUzJKZ2Crw4jbohA21HbNQhmXgyo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6827
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 06, 2022 at 07:46:19PM +0200, Yishai Hadas wrote:
> Fix a typo in mlx5vf_cmd_load_vhca_state() to use the 'load' memory
> layout.
> 
> As in/out sizes are equal for save and load commands there wasn't any
> functional issue.
> 
> Fixes: f1d98f346ee3 ("vfio/mlx5: Expose migration commands over mlx5 device")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
