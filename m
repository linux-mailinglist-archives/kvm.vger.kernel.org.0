Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADD26232D7
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 19:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiKISp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 13:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiKISpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 13:45:53 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433C8EB
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 10:45:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcwXgVRwOA0NXqMNPL2drmOWQMA/STjQKCQhLH6Iq/+r8LNk+B+42QEB6PcUQANgG/PcdT4nhmS3re1ojvTRGExUnNmSM0+aCGya72W1/giKpx2exdQjVaxJF0z8Lwmz4XtKD2shxns9LfIT7+v3rPsR2b5bgtQtP4IFbiVP7YlMMGQuGpwmF5iEYLj8uwU3oVL3P9aMKMUhta6QNHcUyHKFApcwKM1/FMGgVPVpeg+7+nCV9fGUVUjQvJa7Z6AxZhO7rhW35YZlTxB6u7aZ0666vVox6kjdXDCPDJP/3quPZdW2IDh6IU9pdzs4yteoexZkeQqFuIVtZHw4Xx2e4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4p6J5ubXQtCgoK7VJz8lQHISHmCu+du+qZGyTkoQhok=;
 b=AdNv72LCBlpsLE6VBTCYxRawcYBtTKHW1J6lF0Wdg6B3H9tHbv+J1ixV002ChhuCZfzhOe5SarpKVsDPVN+Gv9mQjfGC0a/zkOC7n31R+/tukHnKOlfxVEdYi/4LDNMx7HeafkhRpG9cPgbYFEKhaqP+L+NqjYSR2Gbbwxg6bGE+RKSoQJGkEEc+xXiEZVF+yr2I8rkUevJkcbVfheO7UpQ5mSUSLMC6p14R0salp1FIWxbcNdOTxTss6A8rS/vbWneqHAhbcpkE5bhULv+iVEmjqmo4ww3g4l/zWghv9bpV0yIEpl9l1q4LyvxgoaXLdssArv7wk5vXR22lA02KXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4p6J5ubXQtCgoK7VJz8lQHISHmCu+du+qZGyTkoQhok=;
 b=aM6aM6z8KrY9Qaq0L9hpwrBC5ZWsI8EainZ32HAQlt12yctDjuzuDbXeyOeHJXjkgjf40d4W9y/6mDwJZENNDSFKtdJFXTydJDIPM8+acEveB2YUVMqK9WT1+jgnH/leqjRI7aGzs/OK7kzrFY/2SUjtXRTK7+Ar2SgeJ39G5w+5ryKwIwjLrYo7krTXA9ZuBgZClZOZMWxR9TxIlcyz+VGyjZ3tK639Ea98j3bkGj1gn7ndTc2UHwWXjm3JrNPU9KWZkH2RBEIim8f32Am/lmZx76TKMlv6HBdl4kGBr/9gTddb0a71Gd/H3Cmqta0T05i8eO4W5SlCvIkLJyElZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Wed, 9 Nov
 2022 18:45:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 18:45:49 +0000
Date:   Wed, 9 Nov 2022 14:45:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        shayd@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH vfio 11/13] vfio/mlx5: Introduce multiple loads
Message-ID: <Y2v1XCmfeirvXQ0+@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-12-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106174630.25909-12-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR14CA0019.namprd14.prod.outlook.com
 (2603:10b6:208:23e::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4432:EE_
X-MS-Office365-Filtering-Correlation-Id: ce5315b1-fea0-46e8-1b5a-08dac2829ec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6NZcCSAjGHbZAqdK8wiCVyUryLcnBhYNN4CPpVs4ce67iDIlLOjG56n/nIBiIafGqOCANMY8fAEs4N2CVEkaXP1JxHNXwcZV6rkNWnrOIO4xu5wUkuAq5V+SXEHhr6S8r5fBen/AwM/sj1Tnl5cF02kAeT4zus5YPBf5Lx+6hhdgjKP72PLpV8sI/Og399xNg09cSOBi9E7nSB9emsf7B3CvOUfC1vXEsYNA6c7oPSBLzwLtBN/b5vNzKUDhhBI9nPhLWdD12I/KHOylILcqG53CyNFOBav2RX4dV36D/DtJZWRbPSEm8CGcX2TwVBcVDw6TmNqZq8k6ut6gQJmVC2EXM5HO8B/nljzOtkBNxa3UG1SX4HWfrYFBi+fPosljZpnCznta9T4wtdzfvEKknRB+H6EtkZHRVZ+pnj4YduDIzcnU17/Dubr6PvBGTNnHEWF5dkO/ZBVtspvXJJN8VnPfB7QksHYTeq2EgtnG5eWCSm1oixvZOvemvQ4VhQcX+P8Z80yMD8AxepjX4Yv1N6sM5pjdj6JWi9ljlDYkSKE6Ttoo3q1SCI3HK4lUcfhqyPKcHRL8lRGLF8RiUhIg/ek2QaciydNtLqbAiQEhoXm9Vc4XOIvXtWAjVlUCgGvzblSxZOQPutW1Nad1+Qrdx/Ar4mw4UpS0BfJhp5kS4EyUNzgytXQVSyGBsyxhvbWKQ23swr1nuL3oJVbPhuUj2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199015)(83380400001)(86362001)(38100700002)(4744005)(41300700001)(4326008)(5660300002)(6862004)(8936002)(2906002)(26005)(8676002)(6506007)(186003)(6512007)(2616005)(6486002)(6636002)(66946007)(66556008)(316002)(66476007)(478600001)(37006003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uHV29X9jrbk8Phm+pEvAvuq1o42PEBy8KdifUXr2K8iLOIpj0aewjwr7LDLk?=
 =?us-ascii?Q?fzCM56JQUl8DgAoQ44BzQnbWLtIL7iF7nPX2UCarrWBduxDdqZrgl59aURfV?=
 =?us-ascii?Q?8FBNfRMc7D2hHBX8mnu5tzBquXfqqa2m0MsA1hh5Hl1v6iFo3obW+oShokGR?=
 =?us-ascii?Q?kQQ5j0KzAGdCfnLaHLmOAYmDOK9fFVlh6kOBOzS/3x3ltsROankTpsZ2O8A3?=
 =?us-ascii?Q?45m3EtTGjlICYDroZLABuRiIYl/75KAWRci/oFg49vRYrlMClDomxk/80RNQ?=
 =?us-ascii?Q?EcW1+j0aqU51EK5D7JDMfVQgrbvZIL1p8zVvbcgLhrBI88XwYFG+Bgm6sb8Q?=
 =?us-ascii?Q?M6IJ1uvSnJ4JxFm01cwDk+kyD9xZlskECWdGCXzstM9TaAVa0bYb3mbXJC7q?=
 =?us-ascii?Q?IuSzCIkMtVQh8Sckd90oKgRRkXnL8hFhXamIsAUpAXsutNtoC4YiOovTfDoS?=
 =?us-ascii?Q?z1YP6iw+PJQTdwnUmeCbgH5AHOyUfn9RYL7crtMKYd6w37HxGrNehP2D0BGw?=
 =?us-ascii?Q?3/CebUst384btET/JxGc4M0SQdGluyQzyzPanpFE4pC+u4l2UnFQ2IIh/oWt?=
 =?us-ascii?Q?GN2A+1jZDqRZe7z/oQQRZs97n9MLWABO9dNkps4rLP/Y5L1u4wCmYN3k04BZ?=
 =?us-ascii?Q?Dxh45qBEqfTcJS2qC3qNE/P/jx5FV6I+BBMViCZkKslwLPhrPJpPeDXxjWOe?=
 =?us-ascii?Q?YwErCYFNw9UCebK2TQLGikg69yF+gZQ/xl8pUZiyL1q+XyeM7G1HJoMTyrRo?=
 =?us-ascii?Q?lle20t89DlhRfQDDQSYZEwwZubYBzoz9KWWblCA22L1syJyBuBl8KhqSgeKw?=
 =?us-ascii?Q?Q6qZNhGqf/Lf04wcRjB41g/FVd1ML6OBSiB/hNz1eP+sYiu1mSOMYkmkU5sa?=
 =?us-ascii?Q?tAxEJTQe66bo/u+zHjbwf+0bKyJDMT2xOLEUPYUB+W8ntO3N1UYwsrrBhxsn?=
 =?us-ascii?Q?YuM503SvOwDjZIJfUxpBNvyfUkFLAMAru+/JIgMh1/kiZSTmP2YTdoxFsR6o?=
 =?us-ascii?Q?r2Zw6qVZcwONAuDT2lx/1tmdkdQzRmDQ6JCOtA6KKwg7RvmPyLVBBifGmnh6?=
 =?us-ascii?Q?VrqpzBHi2JCEuPTszUsiUk6aD7rNOK4kdD//isVk8Nu8881iDTwWlLkQrM1/?=
 =?us-ascii?Q?2o5VM/cSpsHWR1hcT4Ojp7ZXtvS9Aka7IuRHwFe3P0R1QfP6U8z5aaM6anIX?=
 =?us-ascii?Q?mXkrWPYCCAMQjDU8bOGHiakLv8w9nBWxxU7WTEL041BCNp27hPfWCyfAR8bz?=
 =?us-ascii?Q?GPMMXDj1e3T3w8CdDDba6NxOGMjNivemQZrQ5EdQGmpcnRAfy7wQW1Ys9R8Y?=
 =?us-ascii?Q?u49qSkT1OwmX63q/F1N7AM8d1B6iaogDVqxrJTdBIFMX+AJ4YTzy/YRscA7J?=
 =?us-ascii?Q?zQyDShMp2mfC12dJFabgf5pySTYdP40++6hZVVkFIgptbkSot02iW7Fa5W6l?=
 =?us-ascii?Q?oU2iuID15/hU+aO7PXwRMwsC2U6HzzLzHCK4bJ8d0SNKLynR54YMN4wLrfBC?=
 =?us-ascii?Q?i+2swk8KuWShJ9Hh3BowJrQPIF/LxViMtvoHjuYkr6fWq7CmyFln+ofLDq/N?=
 =?us-ascii?Q?3k0zQOt/U25iQKsnDLw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5315b1-fea0-46e8-1b5a-08dac2829ec1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 18:45:49.6338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YT3iqiWozCmhVVpWL1fwfXpccDlZnqe0VhJDh/iHImzTFbndtyjBqoaEvOYS3juq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 06, 2022 at 07:46:28PM +0200, Yishai Hadas wrote:

> +start_over:
>  	if (migf->allocated_length < requested_length) {
> -		done = mlx5vf_add_migration_pages(
> +		ret = mlx5vf_add_migration_pages(
>  			migf,
>  			DIV_ROUND_UP(requested_length - migf->allocated_length,
>  				     PAGE_SIZE), &migf->table);
> -		if (done)
> +		if (ret)
> +			goto out_unlock;
> +	}

This really wants to be coded as a state machine, not a tangle of
gotos

> +
> +	if (VFIO_PRE_COPY_SUPP(migf->mvdev)) {
> +		if (!migf->header_read)
> +			mlx5vf_recv_sw_header(migf, pos, &buf, &len, &done);
> +		if (done < 0)
>  			goto out_unlock;

And when you make it into a FSM then we can pre-allocate the required
sg_table space based on the header instead of having to stream

Jason
