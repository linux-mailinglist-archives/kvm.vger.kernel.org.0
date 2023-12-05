Return-Path: <kvm+bounces-3586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA478057EB
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DA861C2118D
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A5567E60;
	Tue,  5 Dec 2023 14:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TghoPofQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E383CCA;
	Tue,  5 Dec 2023 06:53:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAiQzYkXqi75ydL4OEksUrYE9VoFziGx75ZLuYKtEcmoZlLSgioANLABCRJLUqyI+kWvHU2hnioT0bcj0DtGeDHRmMU+ClF4jnTom4qbiS1KGCn6koBaH2m4I1G7K2coc2CSpeLtSjgtW5VS7VI+AVlZC4ycF6HbDtYPsWZgRPU9Oo5IH0SaKGzSjBdq9nXCmM5Pmma2w36jquNRPx/K5EgRYdi2fOHrkMSGvl7JjbuV1Mf+2Wxru9USFQsvUNIKXKxdZg48265QLUj50RTDeMlvjUwDblyF+RQFagR8yZSdJOlo9DKbgdFDJ67qqNYqgB3cEm5QRcc5lOHnFznDNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6M12LzFvjYNqN970jKbJPz0br8udIuZ1P4iRz+kbslk=;
 b=gQlE3Ffiqqvk5AZgMJhPSzmR1gJlYstbBj8uK394PmFHqFCFmcHuabY+WXV2IJM3Va1sgfwM1z/24SGSZZzeJJ772zAJFrw6fjCEeJH8phuNNFWwD2RV7RaU2QSW5kfkbycRIDHK5VJaO3f5ni1MPfii0/mz0GhesRMcTVIjsRqs1wsX+QdDHbHktIV+P1LyuILOGebzDH38XlRje3Oj1RXFQxmYYdwOHXuFZYyqJDSCI2r3QYE/TvElz9nMoZ10gxqn9dGvNBAfF2kfnAuLYMsjazQZhbsVRJ7bqAbRdMWjvj2Os7KfviToA2LqopXl/vMC1Ok3I+tJE9pNNQAMGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6M12LzFvjYNqN970jKbJPz0br8udIuZ1P4iRz+kbslk=;
 b=TghoPofQLc7n+2DGa/zl4vDFr1S6v06Si9/4jwScgPhkofTlAtV/3SiXttO6MD2pusmo1nnzqKvSQVVpIU4ayu3hbpF6DUFmoN2aE+pa9SBFhamw/iKL4AJIo36Y4inwUeuVEDm38f7TXMAYb4Rns7jaAKx5gfqejPXdYm87COZXeDXHq6pIF6zATivV/NjTZIi3/TGS86LwGtvqH5X6ugo9X6hICg2xrl9T+ThhKuKpZOc0aj21X/vfy3YUC5SFkU6zwefxjQtFc/I8M7IeJ+ImdU5oxLhSJ3UD5eL35Kq8TabKRJ5C5MSipgNaNw0ImrJq0s/59hy+Q6byQq/fhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7608.namprd12.prod.outlook.com (2603:10b6:8:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 14:53:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 14:53:05 +0000
Date: Tue, 5 Dec 2023 10:53:04 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
	pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 12/42] iommufd: Introduce allocation data info and
 flag for KVM managed HWPT
Message-ID: <20231205145304.GE2787277@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092113.14141-1-yan.y.zhao@intel.com>
 <20231204182928.GL1493156@nvidia.com>
 <ZW7MU4L9vybiDqZt@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW7MU4L9vybiDqZt@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: BL1PR13CA0102.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ad542f-1421-4843-5aa4-08dbf5a1e348
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WIZJICya50JG7bbldotqZO7rjh5XPj1eJWjbsukYdvUqqLDgmoLXKMZOL+hClo1NkcV5SeLR0sXjqDF1UT0Wt5C3xLQ2GT33MYDMW1YxvKwZR+X53JW/rQp4nHxSjXB/npBQLdNfSNoOAK3AQx53AMof4QNp4P40hJW3yFBj8GaEOFElq2xceyqNDvtofAAMX+Na718rxvgefEnG6uvuCyRkheTWIXES9E0xSDnH/KoPkb/SlA/CDVBd8kU9eBEsJIWgAcWZRXXm9ZGzTyigRpLNbocI//fPm4GHGq1oSOlG4KeFpOZTJ2kqMvODZDBiruEwSnzmFjEaGUW2Ixou4ID5xlvmfgN2iiYtfSpd9FcKhdxHLdx0HRL/IxHXSIW118Y6ufNyQAIVrY/7paYujqMd9hKoII3Ut5PSqZdlqkBE4wnSg3sJ2Z1wuZ6SE3dEpVdw1TTF4CDj61YwxZ+38FOqSD/Ct3y6Prcv/p36azfmF2j6KEin6PRa5MDLGeUgv/O3mn57B7FwTbQXyr78lWl6jUc7vRiFNASRNDawB4djeDVZLjHHF20JDQnZg+zb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(136003)(366004)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(1076003)(2616005)(41300700001)(6512007)(36756003)(86362001)(26005)(6486002)(316002)(6916009)(66476007)(66556008)(66946007)(4326008)(8676002)(8936002)(6506007)(478600001)(38100700002)(33656002)(7416002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PiUifFe2oiAGfW1vMqbGX6alOd8AAMW2ZxjwS81Gt0KtN8OadDYPLPtOHuKB?=
 =?us-ascii?Q?H4zX1J+63eSpydiLoi+CzdPr/jiH43tpn92imuKvUYKjqsKRDTmJpzGTk8FH?=
 =?us-ascii?Q?0UERwU8hnyB+lrT0K7y3jI9jQ/6dqgHCHmCh31DBvd57uEtngrcB4CdnRciy?=
 =?us-ascii?Q?W/Uoo5ekc7qPM63dz7bg71XtazD/Bd3GIJFZQZjWf9eDEV0o0VJ2dfwequ79?=
 =?us-ascii?Q?wGTnmYR/eClIZPBGrWCzYkIYuDGUShxx/Gg4auQd0lbLtrDc5YOyARzOj8TU?=
 =?us-ascii?Q?XpgV0X3iweEuvNKpEpn8MMw3ghlIi+On8OTmXyyCJfafvHndpwLkPcq71dI+?=
 =?us-ascii?Q?S/0cvBgRbrPyRTHupRXUK+AksfiEsXBvbs0c0DVE0OUnwI41Q/FARH8RNJe8?=
 =?us-ascii?Q?0wic6lTi/ug9sFNdNiTVNcx3RxYNNQzueHPBUx8yQrSlJWi0ShSl5kILaKSa?=
 =?us-ascii?Q?enDxjrsGID8B8kpGaK06OKySLdpZpbyzJLi5iHuRg7GMGocdgsdMFzjq5nXc?=
 =?us-ascii?Q?1lxzkByVI1anucXRrtjuBELblE0h7dBQBYoJWVfqtSeJcSPVFW2dhk7+iJ1g?=
 =?us-ascii?Q?bDzq4ZK3wl8HK2YVX9f2yPkDoseJAh0zkZE/VlySyQE7dzpHqivBZcNEcseS?=
 =?us-ascii?Q?afwjKxl6Y3GpTev2UMVrS0DXOJwJKHioE6r6L18PWFblLLpEwq9ihEBnCqib?=
 =?us-ascii?Q?mP1Axy4t9gCH/LqMj4CHRcuNglgNZi8xvvPyyFRm+f1Livwd2JzJ/o/FmqF1?=
 =?us-ascii?Q?c4hy/1oTfPrFYnJKZqYJD492+eTs342b6TCpYQj0iNqQwieU7AZ+KpGwpSmt?=
 =?us-ascii?Q?3AYatEreBRLeBs6sbWvv8AOizc+ig3bxHcG1OBrMSLw1TernX3tu5z2Ct+z+?=
 =?us-ascii?Q?UXOYEXpKB1utyX2y4xpR1eIALvkp5cLLqAm5+QdDvFqouYfoLgQgz+ySKd8H?=
 =?us-ascii?Q?eG6/Kfy8YNO2Scm2XT/d0Z/iUsXh2JmjBN/JsBBzUaV8kXFNSE7dlKTe9klw?=
 =?us-ascii?Q?Q3+O9jw5H3D5zPE+Szggcjyk5C9n2w4HIwmi7QTLlF9Zy08SHjhkhjMSyW0l?=
 =?us-ascii?Q?pl84Hq6eE5l5qyJfInr9HGm8xSP37+kT/BJjL8KO5qtYo1BcBWcDRf/wqug8?=
 =?us-ascii?Q?IR3cVvCp6S/Emk9oCjbfkM3ZqLhMScwa6IEw595NjcskpcINvOc3UEuKImkv?=
 =?us-ascii?Q?jQDMb2LwwlBL2P1mj6Yw1Z/MIvhVbHKE+ZK025+ITUt4judNVeO5DDXvGpf7?=
 =?us-ascii?Q?VHRb4+RaBNprRaQipez3PKru+Vk/8b1+4KrHGvzffO/yNBIrpqrZ+7Rb6lTa?=
 =?us-ascii?Q?rZUHfGXSpFNEXHcGoOiQK2XZpDpIqxr49ydA0UA3yUSjfP440DN3jwnMAzqb?=
 =?us-ascii?Q?Q82RKnxFE8+PFabjLrFUWNHST0WLG1e+kGsREEotvgL/idZpa42UpTH8m08h?=
 =?us-ascii?Q?3wMByw2AffQCfDYkLBVk7OQkC0kLiSuWVteg/T/iyeliXcUKRqrSFSxF0SDt?=
 =?us-ascii?Q?Aw52Gow1Y15/P9USmjWmgTqt40TOXNckI8+0V0F/Z4nrY7KCi+a3TVn4BOVO?=
 =?us-ascii?Q?A2kCtQvueDupsuAy6/UFZzEGdzdUXfO6ijEFz7VP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ad542f-1421-4843-5aa4-08dbf5a1e348
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 14:53:05.5808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DwMLqLLf/Cfe26Sm5Qfrhm638WaLAxszKotEp8BdQueeKg5Ezoni0VqvfB7rnCrv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7608

On Tue, Dec 05, 2023 at 03:08:03PM +0800, Yan Zhao wrote:
> On Mon, Dec 04, 2023 at 02:29:28PM -0400, Jason Gunthorpe wrote:
> > On Sat, Dec 02, 2023 at 05:21:13PM +0800, Yan Zhao wrote:
> > 
> > > @@ -413,11 +422,13 @@ struct iommu_hwpt_arm_smmuv3 {
> > >   * @IOMMU_HWPT_DATA_NONE: no data
> > >   * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
> > >   * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
> > > + * @IOMMU_HWPT_DATA_KVM: KVM managed stage-2 page table
> > >   */
> > >  enum iommu_hwpt_data_type {
> > >  	IOMMU_HWPT_DATA_NONE,
> > >  	IOMMU_HWPT_DATA_VTD_S1,
> > >  	IOMMU_HWPT_DATA_ARM_SMMUV3,
> > > +	IOMMU_HWPT_DATA_KVM,
> > >  };
> > 
> > Definately no, the HWPT_DATA is for the *driver* - it should not be
> > "kvm".
> > 
> > Add the kvm fd to the main structure
> >
> Do you mean add a "int kvm_fd" to "struct iommu_hwpt_alloc" ?
> struct iommu_hwpt_alloc {
>         __u32 size;
>         __u32 flags;
>         __u32 dev_id;
>         __u32 pt_id;
>         __u32 out_hwpt_id;
>         __u32 __reserved;
>         __u32 data_type;
>         __u32 data_len;
>         __aligned_u64 data_uptr;
> };
> 
> Then always create the HWPT as IOMMUFD_OBJ_HWPT_KVM as long as kvm_fd > 0 ?

Yes, but 0 is a valid FD so you need to add a flag 'kvm_fd valid'

Jason

