Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514877D3623
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 14:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjJWMKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 08:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjJWMKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 08:10:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60218EE
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 05:10:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cy+iFIitr8iO69v6IMhGZOKsXXZRCVvNh2IdSwTXLmg83bUS797U7BGJVvA0FWV2f79KSO0Zx+3y1zOVakn4tzE7B8EW7hpdFj3EggsYScyk5qRAZilRHlujNgklSLP9MND/61KD2vyxjgW+Yhc5XW6jOcE95DNgOgf+P+V/c1TKGNJOnlc7vdwIAuRAV2TixH8vjBvg/xGC/z+mu7kWaw51N6gVUI/cEQpNx8Y14AjnJ7G5Hi+DS4hGV4bvAefiGH9D9KYGlbxcxyUJcfrcL8AjZRuJDw9pccCZLUMHClXJ2PlxjfA6zruz2YK0dUbjrPUaQ0IdjmbYvltXSRW4dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NV5SiF9n8xDRh6akhYKZyGBe8OHlvCQqa4XBxRar5Zg=;
 b=Q3eQWl17DBDpvCbGB6mQMRykrnrKBo5FTQ3x1/0/OC6h/ouBEDfUkscmVW7ujMsCzo5WTW/2AWmBTFkyv4W9MNaJlkBRboRU45LT5fuQtY8W+TwDPvoMFuwWH7XReSRr1QE6u9ErJtiuhqtVEOyfMdfPWYfCNmggB2fuEUS85krOkhQbdmhfQQgOdDCgo3re6Xf0aUfuuUPa2Bu1VpBVrXxkdH0y2MwCTcciEK8FwpkxuOEnkppKVjOyTtON4tk9MlpyeRrQY5wys65RmJMRy9/TUSqLKFjHSiVfP8Y1r94GZQBcWp8pqnuwHe0tlxtFwnKO2C6e6zBlGKbwImclwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NV5SiF9n8xDRh6akhYKZyGBe8OHlvCQqa4XBxRar5Zg=;
 b=XvcfAlNst+vd8UWR4dfBN5vsq2ZuoiY0pZejqup58NTvv/MbZt4bOIvvbh1OKO/c8wH5CrSsFjTV/nSkChmkYvlLf+yBlV6jctBcKzAjRFc5a8lEX8hMWyaCXn12WWMXrLbDevXV5p7QOtqGaCkXjOPY0Pdxp/yoU8agtedHNVgikeQkVwxwUEhBRrFTYUqX1LeWGQ0FxN/5Fflyg750TvWNKhFZviFbuSFDrJkKd9YG2s0AnCubVBexdX0gxPEUCulBtUlx8RjEuuKmQ6w+5+Qm89mjKIi9Xcd7fU2Qu1uDl99Y0jj/3QtcqvJd2peOjFJ4Jw1/eK99QDLcdwJ6TA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB8194.namprd12.prod.outlook.com (2603:10b6:930:76::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Mon, 23 Oct
 2023 12:10:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 12:10:15 +0000
Date:   Mon, 23 Oct 2023 09:10:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Message-ID: <20231023121013.GQ3952@nvidia.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-8-joao.m.martins@oracle.com>
 <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
 <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB8194:EE_
X-MS-Office365-Filtering-Correlation-Id: 2add24c4-5ea1-471d-3c75-08dbd3c103d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOGQr3vC0/srJXtJNyEFqcCGxajmWIhT6nfHLD3jBLWskpw6ZG3jyxBktPVaY0hgznGTVVY3Thd3WkOJywZuf+0MpTl41jNyLdIKDhxpAnMmzs7f9Q2kMHLW2rCJYQXt/HCg3UavO8Fy/9ZON2Z1eXu9sMYVK+ybVmhEBqS4sgRTmjA6TMWutrKEi7oWiB1ISkr85Sr7yzqgocbUMPjZJw7UqX7AhG7q0s4h05BDd/aqHh3GTlGhNA9Q75ERC9LvzRekFgI5tX2PvUVJ88vDrrezTMYuCuERidI03HPw2q4llV6qGAvEYRty1qmFcHnt6qupGtG4b0/hORGRcUMUXU+ec8xyg5e94phN2FUTX+om6gtZM7q0KCkDBgSfc+ywoBPxd7W1IHC8wo2ta3Z6iq5M0gUBdC5xG3CyVhTru7uUpABbUniDbgKkhz+ypAVt5Vb4hi9vnX7OIfPvU5Qka9ZnZ82W/TuQcLwxSlDEPox95kdQagdNdt7HkykQsu/XWIF3ULQRdDXWaQjo9oKeh08+AJ1NxCOwYENyALeTLONVxQb1qcU0M1PM2EztEixAfsJj7MfsOkrIzXjr8Q+nP32JEXzWBC1goOQb6QoN3Nw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(376002)(346002)(136003)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(2906002)(38100700002)(316002)(6916009)(66946007)(54906003)(66556008)(2616005)(66476007)(1076003)(6506007)(478600001)(6486002)(6512007)(83380400001)(36756003)(4326008)(41300700001)(7416002)(5660300002)(86362001)(33656002)(8676002)(8936002)(26005)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jegQK8DoMoDfo1RVkTso0bgMmkCVXnlJucsgglHL854QMuLTmBlyt0jYpdxT?=
 =?us-ascii?Q?roIqd0dMKJJvMUOdDcIIjZDbyjA6GzYSUTdEMBnbcp4zxDKSxmtrkTSDBDFu?=
 =?us-ascii?Q?d9HyRn63Dwy2ZEkpiKwVatkbnHsYq91ALKoJ3vIPmjBR7Nh+4QlnJg2bHGB2?=
 =?us-ascii?Q?rwcrUCkTbVh/Yk6fuxChU3ahcf/juz6vKzEcp7rTOsIYJiwLFwFSLUm0Hhiy?=
 =?us-ascii?Q?Dr7UgdOsoVHk2qp5KN8NwdvozaFeEGtjwmNU59+4jEsW93x9BT7Ymq6XMvgV?=
 =?us-ascii?Q?4sAiDxB2Lg5IwYzk+7OHW+4dg1NE8/AJRJnHcT7z+CrPCubmpSPdv3VlNlMR?=
 =?us-ascii?Q?8jOWZSwg1Be7Ou765Cz1dk+yP3Z1FrWxbyx4jUgyXZqKSCw6Rg0HBlTWd8zh?=
 =?us-ascii?Q?bMp4zkTeyrPDoS2m/GvSlSavLYOrnspKcCCPak2pvlvmdFHEN6hMqa6I1i4L?=
 =?us-ascii?Q?kKuOPB7GyqqquVAZ+LVIMIC1Lf6xkfzhl+VcbmJ/MaCmzdCOJJF6mAQOP1/E?=
 =?us-ascii?Q?BFKmF+pHo2qx+t+OPhD4pY3+pS8FdA/jYzCpngqGuWs+gPmvN4gIvE0EmX/w?=
 =?us-ascii?Q?50Rsehan5uinxDHnER3+4LowiPm95zHM7uMLpu8z8K/DjhcOOJwwqQthWJhH?=
 =?us-ascii?Q?MbHKLb9DmYI1/KZ8n0x/g2zKZhadE1Q+jXqCN64AYeDqBRZ7vKWLONlCste+?=
 =?us-ascii?Q?zSi3pIYsjdzIU8iLVwecxqflIUgBRkWG0ADZGBq9iauRCR9XXn59173JzSac?=
 =?us-ascii?Q?afwiCh9eZCbQOBgYaVBeYgSuFcVzodgAxe89Dm4gh0nYX9SPQlZhRba8IgyG?=
 =?us-ascii?Q?8DQYAHWMtvYAIK6qPeXtpxCF2FH12Wi9LUgeez2K1CsqrJiF1dH22lf9YCwH?=
 =?us-ascii?Q?vempPP3WTqfewdw7I4zjskBGe3z4cWDxmD6VkWShiOM1uL+KnUmC09dWV+bg?=
 =?us-ascii?Q?EP30I159O8fnP+IZZNnvdIROhItsS+Trdz+5rsJdHiJ0mZ1xvWspyp+I/wkj?=
 =?us-ascii?Q?IRLrKfY/w8JdK6BUkYxBy+6zQBCldpnA6T0r5Uy6PEq8tIJ3M9XiVyRvhwya?=
 =?us-ascii?Q?ETsS0/iNaCwgE+jdJSS1e7jnq6NWaD8vyRpVAYDoc5JuX1iL+yGvATOHf7CM?=
 =?us-ascii?Q?hxouSL6G3dQ6SiQcFBlKHCZGVUWtTrvleLJg6upiIeTe9tZU5SJY3zysHSw9?=
 =?us-ascii?Q?Z414fRg/BX7z18ODdsLYmTsG1yzK42Jfbj9Oc8ZQkkbh1F9aE27MY0iA1cTl?=
 =?us-ascii?Q?DdW11/6gY3JaijwdbbPaRIVL5oDj06bFnD9H8cAUF9npiIIq4eU1DVAEr/o1?=
 =?us-ascii?Q?+sX6pKjwvwCm0uvICe/5y783O1hypxuB+GisDLu6tXaEjhvzZoOuPcwCHVGt?=
 =?us-ascii?Q?43m7GQEELZaKdIpCAW3E1eD9kYp/sz5EtWWNSubU+1hS/DyidWS4Wtw7fhkI?=
 =?us-ascii?Q?GQFAF0kf7aSkcItW0mDezhqQoO5k0t/vU/48h1b4JjF7NH16PBrEvB2vDaWS?=
 =?us-ascii?Q?pdFCfF7KbH3VXvDD1JsJmY9Q8nvO5nDoZBWHLSkb+e4qqAC9f7pyP4FLcwO0?=
 =?us-ascii?Q?mf4jdRZ8IyusVksTj5o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2add24c4-5ea1-471d-3c75-08dbd3c103d1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 12:10:15.0369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDVXhURQ8tzzEVeIjE8SPKfaO3YyTzy9C5jjhlglhAIi3snMfv87dVx1nzUbvGD0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8194
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 10:28:13AM +0100, Joao Martins wrote:
> > so it's probably
> > best to add a range check plus type cast, rather than an
> > expensive div_u64() here.
> 
> OK

Just keep it simple, we don't need to optimize for 32 bit. div_u64
will make the compiler happy.

> >> +struct iommu_hwpt_get_dirty_bitmap {
> >> +	__u32 size;
> >> +	__u32 hwpt_id;
> >> +	__u32 flags;
> >> +	__u32 __reserved;
> >> +	__aligned_u64 iova;
> >> +	__aligned_u64 length;
> >> +	__aligned_u64 page_size;
> >> +	__aligned_u64 *data;
> >> +};
> >> +#define IOMMU_HWPT_GET_DIRTY_BITMAP _IO(IOMMUFD_TYPE, \
> >> +					IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP)
> >> +
> > 
> > This is a flawed definition for an ioctl data structure. While
> > it appears that you have tried hard to follow the recommendations
> > in Documentation/driver-api/ioctl.rst, you accidentally added
> > a pointer here, which breaks compat mode handling because of
> > the uninitialized padding after the 32-bit 'data' pointer.
> > 
> Right

oops how did we all miss that extra character :|

Jason
