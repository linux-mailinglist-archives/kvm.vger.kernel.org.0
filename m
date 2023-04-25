Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A8A6EE26F
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 15:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbjDYNDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 09:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbjDYNDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 09:03:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE9110C;
        Tue, 25 Apr 2023 06:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpLQ0d14cuP4foAbutAFEfftV67vRD7IU3GYP9yOKRMfgHXvkA10S4CnalEMaafQCdSMRRpcCNs0dy1HVOUQBlnvvrk12ZWwUUFu8P+5sjLzElsXENZRii5TvFtzBKtELhaWSKa62hHckq29eFHCN/ycvswPS4n+V1HUbdoEPJcmKM/NmZwkSvwy2EGXiMklNiq34hkMWbiYeWmWPqVngZuQtihhhqTu0xGgLGo0R94iaVER4pI0mI2kA89eAh9A/bKq3ju+be9pnGhIR+foTpIvFV3P0edkcX5ANRLfhCq0jn30S4xA75z3FLQQnyDh/wiESVlnjRDnPT220Vlp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqN/c8qoKoVrYr0eAPpkMr53SqLFhiemvx6KM155BPU=;
 b=MwgOdgK3HrYEvU5ZYjy1g7bjeSrAAjC8RfckR39CNI47MvsOg1y9ZBMwkXgr1CKSdMCyiFlADcowmF+u+uuX4lmG8dfhiyUj8e30cg3cVmVJZKsa3MrXk9egvvqSjoiPYsPpcviIdgL7Hqz0Mr0tggMFaNo2MyiW7+LXQ19nrGasYH66qF1QYa/r31s9afZsdXzuiedro9YvqAxlF/Pvt1/DpQMCXuErKKHblqBM9kj1NHnVJJfjBN/xPr1qCs871xr4vVJ4RAF7xZQKcEEgYRMV1Q0GVu8sgaqf811bJePnlsiNOeOfudYfuDP5oj2Cew/4+Mt1383ejSKSJJT8SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqN/c8qoKoVrYr0eAPpkMr53SqLFhiemvx6KM155BPU=;
 b=EJVHfj6vG7gJ+8ntXO1juIY76pjpglICXdk0+TrA01f43zBoUfY8NfwFho0ea1KELf89vIY22FSnhpfOz90jWXUNTFk9MmGB0NUZYQgbXpb/pR+tkQK4IzHPpeP2OO5V/m0t4E+JNxhBArF4aizYa+ZGc0Hw+bn/PiaIe31MWThqr+7UC+/BMiCuY09o7eyDmnWGWPK5oMf/vJgk40Zxu+0LG9k///GlRIDwKMCzL227JBaYiAvK9wzgUZoxMiHON/H31k0Ltw6bHFAUg2CUIjxurZsyXo98j2w4450vTQ73ZB3TQB3sUO0GYtDDFas3bChAllKCbHBMXYFbelMzYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM8PR12MB5399.namprd12.prod.outlook.com (2603:10b6:8:34::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.33; Tue, 25 Apr 2023 13:03:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 13:03:48 +0000
Date:   Tue, 25 Apr 2023 10:03:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper device
Message-ID: <ZEfPsm+SVRC/P5T2@ziepe.ca>
References: <20230419222836.24714-1-ankita@nvidia.com>
 <20230420171720.418a3c0d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420171720.418a3c0d.alex.williamson@redhat.com>
X-ClientProxiedBy: YQBPR0101CA0213.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM8PR12MB5399:EE_
X-MS-Office365-Filtering-Correlation-Id: 6948c441-1f1c-4fb3-b095-08db458d825d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KUithROf5TNLYg8ZxbnywuAMvbVsgf31Zxo5JMKW9YD3K1J3f5svZVsaRRMquONezHKpmGBiUzsKZsk1bwHC+zBBhWidX9vENClpfQMs+JMonPepESuPVl7PLUGfsZzswP8GvsmHA4Vs0PxL659+meeRyXiKhJG4+z4PyLKp5MO+RsQ90Zl5vOk7aFnleZ1H85xZgsPcL/Yyuf0sT6yXBb3eh9fRgYkNQab6qUliWDJFuSqwTYz3eWi4cM2ApECIkmgv1aweH8dfDu0GUwb8lQpyFCiudIzepwp5Kjnncgm5Ivit41rG5/QtwqHDaH939cUuF+wRS5HlakGmlfUW4+AtC1pR1Dp0SkI37nPJB6yPx6UZTUv2Vjb5aJZMZ0WT5MkH7TJ0N6qVsbNed/XLn9xejYjZves4cc9GKy3LYOVmCf4QdDhWHCZgpZe1j3xrQlP8lr7a6tmCGFRdxR1i28nd095JcpR57mP91iajH87aexl9/tAl4xC+TmVt0UxKcTQChzXWul8GWLLcBK4FGNdbohRpcqAyJyuRdu15bPU/n6McU836JYPYpqbfW1Ki
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(478600001)(86362001)(36756003)(186003)(6486002)(26005)(9686003)(6512007)(6506007)(4326008)(6916009)(66556008)(316002)(66476007)(66946007)(83380400001)(2906002)(4744005)(38100700002)(8676002)(41300700001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?88LeXQXF9WgNFWNFL7pVaVo9Du2lgzvlUqjAPfOojTn2TP3oIwfCpJjVe//5?=
 =?us-ascii?Q?Z+pvZR5injY8hMkFa/Jo/ALBwapoLf2016JV9d5fzck6i6Fes/euPjjhQXIG?=
 =?us-ascii?Q?m8Rm6qe2fI/uVarCJKmx3lZF9dkSEzB4hOu0Fq7O8QhBLrD0RNV68ln6mmIp?=
 =?us-ascii?Q?e0ZI4E+xx6+hRJ1ZALBnOppdgON64IHYv2Es0z++IQyLSZwecurEruioggks?=
 =?us-ascii?Q?cFzO4w0AQ1i5OCc0lh70NubjJOERNT+I8+uFJBIT7hhyLdaVHjWmnvAzR2Ft?=
 =?us-ascii?Q?WKsiZtLdqmSlDangzXQzRw/flP45M9mleuflM++vW5G4VnQRbdgKfWE73eFv?=
 =?us-ascii?Q?uqCTsMLUSs2b42AonNOXok3gkZuHvPFIJZzFu7QLL9kbJp6mZLou0KgO1T7Q?=
 =?us-ascii?Q?c08qpemr4ANXr4m+/f7Whcj2JkFhm31XNGKtalHhL6YoyJ3I28vZ2zzKMoVB?=
 =?us-ascii?Q?jJVADsQhOCrDT+9UTor0zrEsPc6ca6LXWL9FjFSBBb8jwHHQlYR4k9yIFcd6?=
 =?us-ascii?Q?q0AZuJTt8sZoDpFVeYgny5THlFMc9MuGLCZEDfuF4S7RZ0Xo9ofHoNo3iTAi?=
 =?us-ascii?Q?QV/nxmEaDR4L7DRcdf98o6ePuGz/eRlXI8omRqrltW9yeI03F4f+ReOebScg?=
 =?us-ascii?Q?jBS14D5auMJIqFKaGpap8TUayosEEL5y0qF6OaTJ/JG9Sb+H7CVRrQCDSb3P?=
 =?us-ascii?Q?RlNdQAyV8rCXCwAGAExoV7h1fRJLOKd/XkmFJoXcyPUvCw1bgUEAhFBVrHOe?=
 =?us-ascii?Q?5EdrmYizuUAH/1bkr3beggbiUzlN6Ux4gdOslXWrikmwlwNNT+Rm7f8ZgsMF?=
 =?us-ascii?Q?3EXAA5T2g5rxHmuBQ8GIfmbYspToJM7spnb4AEvVdGshCUhE4+mmyD6utFaf?=
 =?us-ascii?Q?ZZcw7l7iKlkUYOuduWuYh+7CeBsbffyKyGA9XNyh5bWEQLqZ+T4WaS2Y9iGk?=
 =?us-ascii?Q?S+OB9rogKSgRa9pa+oLkPkYdJ8+voHrUTtjRw9sgHA6P0RHduoYkCctqOJb9?=
 =?us-ascii?Q?BHv6gAVZWwuZXeP3CwI5MQrcuYugEDpJ8LLt1R1wgcNqGeI1SoCd6wn/WWMd?=
 =?us-ascii?Q?bXV1asSLJx/NV6WK8ocmu4MJbGS9mqexXhI03Fp0p6hPTddOlGfIa3OsgmYE?=
 =?us-ascii?Q?qYFsCK85U2AjLoZtX2uT5MUCcXQjveqcXr+zsT81wbKW0+YG9GcDS8LIY9iT?=
 =?us-ascii?Q?+ymQDp6JN+x7MPQO8+r5mfyt6CgM+ouvACmvDaYpW1QA6JZ5KIxTAukLtcA+?=
 =?us-ascii?Q?BUUlOcqPe5bhyFll15Mepby+OQTRO1OyvFWm/LJcUO50Xu8aGBWGuoBUN0Z8?=
 =?us-ascii?Q?zOE3wMJmnct3XIo7eUrVdfDnfMGp9gB8g8/5w/jNrF33CafdLhJY3SJVCIP6?=
 =?us-ascii?Q?1xMntJpiBOggpnKmnN1xRSF+7lNyPxOgWvuBZ0BB06MbfUI57RS4AZO3OKJ2?=
 =?us-ascii?Q?32bzV0pCxCFvcq8r9GPIQuewUmywnVE7hLVb3+dVXoNmQqIfib2X6ixNszuM?=
 =?us-ascii?Q?3ttwA1uku7Fazies+xqvk2RULbrBju0+qqtK/mu16coHwsBX16jkhqKu19L2?=
 =?us-ascii?Q?X4FlTSBhrClRGzXgYO0+qQi+BWnDG+Y6Z8h5DuDC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6948c441-1f1c-4fb3-b095-08db458d825d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 13:03:48.4572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggd8dhXwt6CKhJycEr6IQLDyv01HLI0cH1xMrFp7qjVkDZq2gHAXI53y1vXEMoFy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 05:17:20PM -0600, Alex Williamson wrote:

> > +	/*
> > +	 * Perform a PFN map to the memory. The device BAR1 is backed by the
> > +	 * GPU memory now. Check that the mapping does not overflow out of
> > +	 * the GPU memory size.
> > +	 */
> > +	ret = remap_pfn_range(vma, vma->vm_start, start_pfn + pgoff,
> > +			      min(req_len, nvdev->mem_prop.mem_length - pgoff),
> > +			      vma->vm_page_prot);
> 
> What's the behavior of this "BAR" relative to things like
> PCI_COMMAND_MEMORY or reset?  If the user generates a secondary bus
> reset on the parent bridge in one thread, while accessing the device in
> another thread, isn't that susceptible to platform error handling just
> like any other PCI device?  

This space works more like RAM and it is made cachable as well which
changes how errors are managed compared to PCI.

It doesn't generate any unhandled failures, so we don't need the zap
protection here.

Jason
