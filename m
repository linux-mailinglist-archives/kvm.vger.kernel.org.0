Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A878B7CE167
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 17:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344708AbjJRPnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 11:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbjJRPnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 11:43:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3A0111
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 08:43:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUJLl/5loNMaQ9M7JcwfTpxNyk6E43V08+JWXpns3zI9uRt/tBIXxcK0KytbM1da9G45NSLNfv2AphTZFvdMGOxWAVsoPa1bVn70mx/f36vyaL/h/MkyR/UUf89GewHP0U+JIl9ESEUCSyDIuCpP+Hzmo4fONQCKO/a0mmQ5u3RF6vAJbM5p98GQVKxwOnfUhkfZPbIF2OOExhNYYhgBN224m3gIIxLBbBSN9zrxHeBve6J83gUvcVn/iva5sjDEnBq3iDCvbpHEPoG42ENA4nVF7e4ViSi7l5f2a/Rc47VjyFpiQrGXF/JlzceNPi7tdMphH7pXgYB4i8htH/Ey4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=202i6dFqCLVhbUJcb3wC7j7ioNO3BVwxOTBwESWGP/8=;
 b=PMomiVMlKInHmTDR3TOmllQQyE7IvvdD+aJTOIaeHt+IcqjmsNgzeCGaSsektegLIymXCh8WlnaBD4SD/1CqEQRwGxBxPuaM1y1E8nRibVBWxnvKia+K4wLwYngvV5/Co4C/am7IVah0eKL3epdXZJAebvtEKcudojTShXYnDKvHwHvcB9l5n0IMKoI5lfIW4RK+iK3jJo3t7Y3O9QJawJxpi3l/nQrfhti+0RcGxB9EteI2Fo98HVOP92m5R1w/iWynwuZQBbii8UpkLsd9Aj7nK6pfrRkS2hHJh67EXHM7MnCz70Wq+ZR+iI1NRZoZt628sPGa8fNRs++B6RltqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=202i6dFqCLVhbUJcb3wC7j7ioNO3BVwxOTBwESWGP/8=;
 b=q+QV+9XDujohZShYknxG/I34rDsOPLay86vcTvu/5qmCaZEexjtAiZRJLbuwErsy9t8A9StdRTq8DhWlOpuEisLzp8DjJtvk7OZYVBOsnWMrHoKDr83umvZMoSZJ2CvB1NwE15hgJg05DFSu9jbdixK0d36w2utkv7YamiELR7/l4n+ERhqVTLOMAHlxBUSWb4PEFYb+BKdqXjbkSirYgG0WRvjhvFQcxAihH7awsrajDVq6riQg3GdDMrlwMMhRoAh+hBE+urmOlZNTsDIr1PF8N8OYbvKZMFir8UpZXvYSO+C3a/+O1R+Fx8tISzQ2qiQj30i7Up2vaSpAWFZzpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB6118.namprd12.prod.outlook.com (2603:10b6:8:9a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6886.40; Wed, 18 Oct 2023 15:43:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 15:43:09 +0000
Date:   Wed, 18 Oct 2023 12:43:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231018154305.GW3952@nvidia.com>
References: <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <5ecbeadb-2b95-4832-989d-fddef9718dbb@oracle.com>
 <20231018120339.GR3952@nvidia.com>
 <c8cde19b-60e0-4750-8bdb-8a97be26468e@oracle.com>
 <20231018142309.GV3952@nvidia.com>
 <aea127a1-3bf6-410a-8ec9-bf131ed1f4e6@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aea127a1-3bf6-410a-8ec9-bf131ed1f4e6@oracle.com>
X-ClientProxiedBy: BYAPR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::43) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB6118:EE_
X-MS-Office365-Filtering-Correlation-Id: 5196a9b4-4b42-4c68-f4c4-08dbcff0ed5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mZE5hXYSCaSsARmukWPDL9MJhYKZ8JMc0KMi2PU6EpmxnFaH+W/2aIpOl/cF37frC2tVTOgCe1pVaOyejzfs0E2k1nRDnRxYf9LQrxHeXSGcP5OeBLFMW6vz9n8/TQdJ9JDgZNZ1BrzOB/d6P8y8kuAoGEE/93nB5WpThND/sAux92MMX7kemi5IAwPjvPT+odNqSGCBRuIImbMEv/6zE1F/0pH4eOGYOf1WLz7tWfARk9WQJ2kSZrJP/5Fx9GYThQvBoY894ONm5fz5BrKzdEG7tm2yqncRcuCg2F/hVuCLb8KMZnxowNAbuT/RCurpiOJTR7JeDNFtC/B76f5llVdzxCaxZ4w5iuz/7y5ktfoXjT8iIfSL1d/wOh2sGfNxcMau9INNn2tIC85wqiyTAqtpwK/O5YuWAwXpnnqRSkQi0e1xScQAen6AFReSnqavh/5PbicnKNZp4kDunqvBZUAX0xCAZJUzsA6DOiF1d4M2dehLBPvNCuITiVtJAAqLlYBbyQoirzkBg2cKHmvsGqPP470sn4JuQrc4v6jvdCV2CjruGVE77pI3A0yzq17p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(376002)(136003)(346002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(33656002)(86362001)(41300700001)(8936002)(5660300002)(4326008)(8676002)(2906002)(7416002)(36756003)(478600001)(6486002)(1076003)(2616005)(26005)(6506007)(6512007)(6666004)(83380400001)(54906003)(66476007)(66556008)(66946007)(316002)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mhT0Fh0LE8V223Rn2MIPFUp9S1rGwckuMHEgikqLb/AHcdLtez0UhbPMBDfB?=
 =?us-ascii?Q?gRt7ZCeYen83BqchI6JbB7GHt0EEkdfekphEt8e3NExfJ3M5yPexxo3xR7d8?=
 =?us-ascii?Q?DJGQWt+RATTQQ59P0zB87WISabi69KQ80Klu3oj6qlK0hDumKQl271mBcUI3?=
 =?us-ascii?Q?sZHjozOFsQesGcQtJ8Kvlojf57lWOj2kY6lT8AypzD9YmQYUdEj9eZ/DCpEZ?=
 =?us-ascii?Q?oIOm3cti08YnokLzJgzO6djKnvde7rdEH5H7zUYlpPfeL+rCAAlEGq7088KO?=
 =?us-ascii?Q?Lqb1/qz2LHixFc5DCo//7Xi11sgoMyMrPp6Jyiw2ENcMyhkNi3at2rXAf4vd?=
 =?us-ascii?Q?ufqTsJuR27aGUJm+SbTkio1tOs17NQ+ggSC2rFz2SVytwXHfQ2V9pauB3BrP?=
 =?us-ascii?Q?oRwUds2arvx3iptdtAhbqaqWUsiOZNfO6PjHkQsiLu46kTodBW0Pp3ocKRWz?=
 =?us-ascii?Q?waBOvy/b6n4MYyUPGttAke6coTiEQ6v4c3yNf1WnJmgzn38bLo4Kw+Dan05t?=
 =?us-ascii?Q?F7qYa3D/jbbpa1OTgP9VvZ0yZxD4sxjIIa6+QbgECrrS9bwHfBzSPUiQRKLN?=
 =?us-ascii?Q?y9Kmm8z2RfItVOVkg8+Jq6GvjTS3HarbgmLUa8inKHlSyUer4oYxYmkjLfCO?=
 =?us-ascii?Q?Yoo2UmYbnQyfJ/uz8uEKUXCDBWENXfzTZLeGJmBoG62YCqPJlQz13IPf32hm?=
 =?us-ascii?Q?7pcVZdymNbG0z6Ygd+xSI1M0QYt+BpliTyjTTkMXVSzTzIbjvk94fea/EFyg?=
 =?us-ascii?Q?OnuRwHXB+73T/gh9AqThPwZiAXLLlgTO3nepYzaFXvRTzNEMC9aaXBSJ788n?=
 =?us-ascii?Q?+MCvqW7UtF1fpcQtO8g1Z9Vxs3kDCpmMUJSAiZSBBv4EniqDdOx8QDiYD34N?=
 =?us-ascii?Q?DwznGD/MOFnlWD2Z7DV618nPousIcNdKvLoMw1gL3IA+PwjjbLI/ldn/thzt?=
 =?us-ascii?Q?Gok/ZLaSE7ypoqxy3kXVtf1R5EefSMPFQuq7vks5aFrtXRhMPROOVsu79PEz?=
 =?us-ascii?Q?EWYZ4/VJswqxehGpuLZKhzSA7GOt4vvhPwbZwd8kN2nONqBFWZkVqNDRuaib?=
 =?us-ascii?Q?6EPimH5ovtyUJm9xaNSGWlFyftjOZ11rvvdZmLogei09OlHST1C4tpFiwwzs?=
 =?us-ascii?Q?ti9mmLXaNfnTIjaEzOXSEmSTC/XCcTyGqaCcq+PeFpWpTOiVyuIpXyN7AgMS?=
 =?us-ascii?Q?ByDm2gOEHw8enh5LQl2EXg7d0yMPJB7I4Axxq9b1fMHMChQPGvV7ClfQFBBu?=
 =?us-ascii?Q?K8TKmKTYiC7FGk4jKriURrZgXYyNTOspRjKgwSIKm1kpL4fdambH04ic3We8?=
 =?us-ascii?Q?8Ya9nB1aw3tPJjLcWhoRkK/6GG0CWTwra+kf7x/OFb51iqA3/ljzFT1gm8MQ?=
 =?us-ascii?Q?DU98gojTMYHNAPKx29gg58kVVrMGGmYK4jneQ1A0PTon0q/Cmnv2gea33KTH?=
 =?us-ascii?Q?L157KOKv2/W/5CQnfOt0SoVL2tX6Z4+T7L4vZ0K649/mjtDarOyv4kQ+SALT?=
 =?us-ascii?Q?jcJcU4EKIj4WVUQSpncD5iH7ahZ0CAkp8Oi94RL2u+jPVsBOjSridHhVdrVt?=
 =?us-ascii?Q?zM23eym0KIdIxjvTnHv7hKYL4dH6mliXdZ4qHB/9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5196a9b4-4b42-4c68-f4c4-08dbcff0ed5b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 15:43:08.9002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1z09m80C5xQp+lJCXv/mrGrWxRmMUnih362zOugigsd7Uu82bU7u39iSqhgJSM2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6118
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 04:34:17PM +0100, Joao Martins wrote:
> These two lead to a recursive dependency:
> 
> drivers/vfio/Kconfig:2:error: recursive dependency detected!
> drivers/vfio/Kconfig:2: symbol VFIO depends on IOMMUFD_DRIVER
> drivers/iommu/iommufd/Kconfig:14:       symbol IOMMUFD_DRIVER is selected by
> MLX5_VFIO_PCI
> drivers/vfio/pci/mlx5/Kconfig:2:        symbol MLX5_VFIO_PCI depends on VFIO
> For a resolution refer to Documentation/kbuild/kconfig-language.rst
> subsection "Kconfig recursive dependency limitations"
> 
> Due to the end drivers being the ones actually selecting IOMMUFD_DRIVER. But
> well, if we remove those, then no VF dirty tracking either.

Oh I'm surprised by this

> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 1db519cce815..2abd1c598b65 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -7,7 +7,7 @@ menuconfig VFIO
>         select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
>         select VFIO_DEVICE_CDEV if !VFIO_GROUP
>         select VFIO_CONTAINER if IOMMUFD=n
> -       select IOMMUFD_DRIVER
> +       select IOMMUFD_DRIVER if VFIO_PCI_CORE

I think you are better to stick with the bool non-modular in this
case

Jason
