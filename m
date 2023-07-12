Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D3C7509D0
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 15:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbjGLNmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 09:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjGLNmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 09:42:18 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728C7E69;
        Wed, 12 Jul 2023 06:42:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVfU0XSJF489jqH5pglg9KbsW28V97py1HGq/KJOhAj9Cuabs+/6TDW+QUsiLqLkXUPwUtcDCaaklaAUPqUbQrWnTK/o8LOVYM3l0n6lBb/dpYeZjwijdkxAn3CEIliIqLnpizbfdvuSa12ZY2ASmwIQyZ33xG511A6sV2dC7+VkgKlKPNwBtO/d5k4qj4DK8GTzcc5+mgDEd8qxGad1B2fOOiP5rDNxRP8sgGMlAReEiW+Nxdrfr5hFFI6LtidY6rFlE3r4kM4FonkQdLZcSWyZutwYEhXlxt7MCfAOTQz3Oa5lUB5HmakxB0OZzgWcWpxl3a+MqErWS2443BbVEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MTyB1N0HaMPFmTIvvwiuDax9X4v4QIIepvkpqyrBL8=;
 b=JSfZlQ8p106jkjzOik+9Nag4lKrhyTkarPCfc/+12Fl+hlcpVNQ3AMASnldyOF6RDTXuTAGpSCUvMjJ58EBI6kiPqHKjixIVrKgIYy9O0L7HBLntw7qPevApOGNJ/z9ssxpSbXe8XXhowYWtfX1rib2mcnveESxYuOHSHWraXHEI+s2ttj3TSvs1hfVc6AHSjVzbej7l+n8n8IemZQb4PWul7DBVNtQLMYm83BvS/loBf2ZpvItCIcVmD5bxCwZw7v4TYK/9A8EPrMZqJmjQ2gK+UoWFtAa6hd0TsCch+K5NUdpz+ZwRzF37fTBxKQLQvoe0AFSWwXxgYLRS+CGLQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MTyB1N0HaMPFmTIvvwiuDax9X4v4QIIepvkpqyrBL8=;
 b=OQ8nTcWxY2gxFH5TCOd/OGQgVonMgz9AdJc8Pt7t4P9ioVtFov6ITj+69iHHyZ2UEHWVMwqUSl/MNr9mrdkVasEEkptkrifmaHO1hZL3bctvv8j1TauIkplrmh4EAr6iX6gA0IazNkkbGhxD6eIA2LYnGW0/f2aitqfLMJkYLqL5K5Njhc80kg+Ku9zJTFw9yI+eeLbuA0ycb/JccvskJtOR9LmuOUjaUuITBXJSTCRGG7L5esCWUJ12m4lZ/m80IEOyKCpzR81kYjX4WKS6aHDGHlxFybhEDVy/BN2TdzM+PVQ1kP0nyX7Gx8CmrtwGtpMmEJyo3gtK+1wY55JR1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB8612.namprd12.prod.outlook.com (2603:10b6:303:1ec::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Wed, 12 Jul
 2023 13:42:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6565.028; Wed, 12 Jul 2023
 13:42:15 +0000
Date:   Wed, 12 Jul 2023 10:42:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v9 06/10] vfio: Mark cdev usage in vfio_device
Message-ID: <ZK6ttDQ7J+OxjLOL@nvidia.com>
References: <20230711023126.5531-1-yi.l.liu@intel.com>
 <20230711023126.5531-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711023126.5531-7-yi.l.liu@intel.com>
X-ClientProxiedBy: YT4PR01CA0209.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB8612:EE_
X-MS-Office365-Filtering-Correlation-Id: e6879fe1-5406-4b7f-c47a-08db82ddcd45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H+BMoi02uclVwKCWWDaJphvnTXdlRtMqVrwIerJzG7fIaaljyN9DgIMGbAGmWZvGvjYYFVAFLPz3cHzZLOkWZHfo94zJRen6lopXvrU+cyp6WmEfg5KRpMSS2LUCjkXy81n6PwnMy4KdGa7CMNbEAw5ved0+FXa9xSjBkEfM5kuj6CuBlZnnopntGjiv42w+Jg8oS8arHpT1SAQY6NPcgMr6gdL0FwYqtgkbuPNKqpx2UMNHI7BVfWpdkJlPlpXIZ3Az2OZ+A6b8s1aQvDy7GpM0tIf9sW9CYyVdqP91tAkwF1+cE5YiboAX/lDFVD5cgVdV5uCMLagiwhgV90I7Y29LCCzoyFA3clEhFMZjPXwqouaw6HnsH1lJlnIrGGiyteu7704F0PzIeqFdQZSXFv8coS0iBnTlxuxHTEg8IDNpUANBPwktEHOBg/vlC3S2Uq71IfnYgLIEp9WQ5cJBJBy+8TOiwC2NiDnO9YKULxOwZNGpA8k4zGxinEd4/SRWNE81wDSStTMWXkeUW1RsjQsQQlnitxVhP9/aoOB62Fw4H9fODGmDQBzILAwNmsi+nK1KZy9Yff8IVSRb7GQ5qZBZ+VuBw/lWhmjrlsihk8g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199021)(5660300002)(66476007)(4744005)(41300700001)(8936002)(66946007)(66556008)(8676002)(7416002)(2906002)(478600001)(6486002)(6666004)(6512007)(26005)(186003)(6506007)(4326008)(316002)(6916009)(38100700002)(2616005)(36756003)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B62gvgM9814ma6OX7kpoexoKvwDj5PrKOfJlTXpehfeRpfXiOiZL92Ru1GoK?=
 =?us-ascii?Q?It2A9pT3q9mqpFfF/2co/o65E1Yo6A8SD9/3MTwKZp1ITmCPCktiYOXB7fU5?=
 =?us-ascii?Q?pI93g8IahUMfBrfUHiUmoOlfSAFEe0IJ/Ejq38sI/+3xNXtM7Ugrw/bZMroq?=
 =?us-ascii?Q?8mZDjY/kItXQIVaJRcwzWvFtT7hfJHETEXRp1I7SCm/ooO3rT8rxApquwBbR?=
 =?us-ascii?Q?wyvX+7FtzEAuA1bYcV6ZoDfORAkqcTcd1IAZL4qladi9PJr9Kg0KuAw6W0HK?=
 =?us-ascii?Q?w4n5L8nXYmim1/YzMw5Q6hq8gL8/1fmwIsPiedXwjKsLK4+iS8O2qA158s6i?=
 =?us-ascii?Q?HtgJxdwgj+D7LZZ2JFL0AUjf0sisTHCRNkRvIXNlupZeO5Bizg6oFQCz+Op8?=
 =?us-ascii?Q?bxZIHzzfk5OV6QY0L1vNCuNprOwTtSelcwj/9rLceFFC4oyKh90Tke90C1P+?=
 =?us-ascii?Q?Vojo7SZIWzpB7D2guEzTPgKiw5b5+lM8pjyc/vSpWwGrj+/yBk3ffMT1dl5R?=
 =?us-ascii?Q?av77vf6JRNbNgY+mdaRubTPy6K7sq/6UJWq4Oo9ynkuanOMrfZk0aU2kb9Ba?=
 =?us-ascii?Q?MRxboAoAXYK/7xzKp8fGMsJX8ue4HIvLP7VeTd9JMVrYcU5IIPwm1wvgAWtx?=
 =?us-ascii?Q?LPuHCk2BQuz26mmRuEXSpWzHlkRiQG6IsM7Q314Bgp12TTK3NLYaae6tXHA1?=
 =?us-ascii?Q?Ute7i8oSAyDyCvm/u8VBYN8gBIT09sBYk5omlAi+JWpriNJkkxLteij4NHVk?=
 =?us-ascii?Q?BJGlDYGSWt7ZIWRrFaYYWPgcqPOwkQqG7H0S9KXX7vNK8i7wj93fUSVEdovg?=
 =?us-ascii?Q?EnsIGpStdI/QPA4ZjfTxpnKFABWFLYNYZcw6Ano9kHssVkkDBPJyJXsc83Od?=
 =?us-ascii?Q?UMYiWN7uRSPfGufHEH+qVwDCJUJA8UaF53MYTnHUSM2lM2GvQLS7rupR5jO1?=
 =?us-ascii?Q?rHOd3WBEpLbTaZERWuPqe4jWFAsl0KARP0Ry1Z/+kMmAuVb/x/7dnP3GQfT3?=
 =?us-ascii?Q?VbCGlABlKJ8Drp3oHj5evOKbjC6lSLjkbzWbHqic4WsTKTcCjC5svN0/AB7n?=
 =?us-ascii?Q?79Qdk8cVpHNap6Veo6oz610ovxfojsC6T+/6O9GsaQE8YhhASqK1OxLL2Oul?=
 =?us-ascii?Q?se0HyejDGAHZKkEGuE3KSjxoEk4qr1jfmlRrvHGHOP+j0UqnO8eI48gvZrzg?=
 =?us-ascii?Q?eplAHFEW0PnYmuqpxf8/P+IHL449X6demljSVVXmDrDEy2eN4k1mnIg6Broe?=
 =?us-ascii?Q?4qAeGVjyl5dCKfpqL/rvFNUZhSucY4bRU0RQKaNf6xB4bwXGixi1v/VtxgdP?=
 =?us-ascii?Q?vLMzWDEspUP7QXTdNxzMD6LkSULNDu5RM7EHRuOJs6G2D5f7AceD0MiGhLwu?=
 =?us-ascii?Q?wAjW+HM9cyjDou1dRbNDYSJ3aoIrY4Egjx6scfD/se2VMwkdknO5bU4OFdFp?=
 =?us-ascii?Q?25eA+O0r5RLWTnlCrpUCCc0yxgAzkHo/JO2J+3DjoYfkjIohvIGyXmm2qKS+?=
 =?us-ascii?Q?TuG1H5hTDL+GxzgO33OJrMMocAnrFmOq4N9Wjx4Kpf7yfiofXh0GYjFTI66D?=
 =?us-ascii?Q?7pX+bCC6x8KUkDYNMueWB3zNQgS40PAJCgLEFf+4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6879fe1-5406-4b7f-c47a-08db82ddcd45
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2023 13:42:14.9452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qDlkw/bDrtYvfDZyzVnwjlYQdWY9ex5WAmzYLoCs+BHeQEjCiJ5Ah6aTqg5cM5LH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB8612
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 07:31:22PM -0700, Yi Liu wrote:
> This can be used to differentiate whether to report group_id or devid in
> the revised VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. At this moment, no
> cdev path yet, so the vfio_device_cdev_opened() helper always returns false.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  include/linux/vfio.h | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
