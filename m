Return-Path: <kvm+bounces-8023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B87849D1B
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 15:32:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38210281C0D
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 14:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B9A22C1A3;
	Mon,  5 Feb 2024 14:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gvaitnRM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B340D2C690;
	Mon,  5 Feb 2024 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707143557; cv=fail; b=OHPZZzE/ZwGrM1l0dpInb3rHTFgqZ+XwrsYsn8A8oHyx4FifqCo2jQ+ai2ePIYR50HPe5IbNQX8tnT/WkId9IIJaaJ4z3xnEwyY/wIIa2Qh/rQimgDxth1+BW+Oeyp9Qqlg3hHg1j8jZgee16KzhkQ/HtiavUfwjnXXgwvOiKK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707143557; c=relaxed/simple;
	bh=5quLQar60Xz0RatPkL74/j059OLmOM/wZx3Utorvz2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jGG8aLJenbYYHLL0vuZ8QdXMUu7XLiE0Gj56nF79ZFFuUOsZ1pATVmu2bsWhrTECO9F2cgq/5FI9G1kDj8Q8bCyEKswZGT6zR7FpIMvBUbvHR+PWSNCYlHKllLDxxJFZbttB4eqKliBgP6Dd6cp6JgE/YdF/cXuBLPPNIY4Zmao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gvaitnRM; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfzMHrVj07Yg0DfLOLUqfijemr2q6imLOx6LVj9aAGKbraqfZEd/Xut9p1xX6NxnzOlE+6dMAzh766xCmTwZ3OV8rJ87Ns+xettoV6rZxi3jzS/pvn3gtOCX+MlyaOKBkzWUPUcDBs+GAcEOmegkxVaAFdVNME9w5HebV5wDrXcELNSaQnqyU5L1RD0pd5/vv14xisBa1RE7xD6r6rbN345jRuM6lSyJDWDcEFMktxGa6Xn2YR4s3W/VF6RzW/vGQzIw/0ZzjR6UJUu0wW2zHKyroZgWwj5M0Rk/w6Suu6lzaJqMImW3sjXGcqd6nQXQuxoKP0Uv//Wb8MaxEWFaWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LrqTN28+ToOFhrRDiG+vIgUCHFFSB5Tt/vSIgW+EqmI=;
 b=nmLtGvenovpiGNo1Rpz/BOaqk7A+0XhaPbR4JXsiJkEth4WfaWqG4qKAEbAG74oTt1QpGU4s772IGXxr1HNFudFEc8RwBaqAgJdS2dRKXShLrU89z/uXxdpmvjYxUgP+eIRalZ7N8Tvk7VxsFTGiS8Dj7W7yu/7a7hfSv3WUs/dZEQI8teg9mXDXrcut6kCgk/S4ij0EdDBauWMxNs2bkxeWcxzQQZeAFdaXO9xAjNDhXYvytNotyaMniruQW5n3P/aNlejkxRJN//HW8GUkbfoDqETpbj5ObkVw4kB0zX+Iv8x92NP01B0XCCOCCwCEm+X+CKw4WaGTqbsNv3GYSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrqTN28+ToOFhrRDiG+vIgUCHFFSB5Tt/vSIgW+EqmI=;
 b=gvaitnRMLpDHa2lI3HztHYSQsKuEiE7K8dygZDrrqSmVYrO25P48J1mKIZ4fBQSsvh2rypoybNPcCBfVywhponwUDnf+SO/XTlmCFhDScxPuvua7mTrIgD/A9E5OExxIwhsu0MSNxgEugrI2EKOrNYMm6/EM1NKnr7Hiztzo3/ok99IbhNQW5nMtI3Wi8OD6vdGTao3DOn3dCJ+Tn08yXB+6cRUdsCMt+RomqirGQ6PsMBMnxCfcLJ05AvZH4IwiFvEidE/wUhCo631Tq+mK9N4YrG/XPwPapsyTZn4QeMomo33IthOAHRtsT14SDZF/WiJXoevF2/lFSEqQnOcqDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17; Mon, 5 Feb
 2024 14:32:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Mon, 5 Feb 2024
 14:32:32 +0000
Date: Mon, 5 Feb 2024 10:32:31 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	Joel Granados <j.granados@samsung.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 13/16] iommu: Improve iopf_queue_remove_device()
Message-ID: <20240205143231.GB10476@nvidia.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-14-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E70CAB272B212977F0C98C472@BN9PR11MB5276.namprd11.prod.outlook.com>
 <416b19fa-bc7a-4ffd-a4c4-9440483fc039@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <416b19fa-bc7a-4ffd-a4c4-9440483fc039@linux.intel.com>
X-ClientProxiedBy: MN2PR06CA0006.namprd06.prod.outlook.com
 (2603:10b6:208:23d::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: 8392a240-220c-4879-af51-08dc265749d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2cmpNwAKFuEn0UF3lliEp17eA0/q0gcV6bjVnYe3O2C03KcETejrpUaC3BdwM+F85BGEoCSa5jXUhYoqyVHQw8AwKumC1b6c2Lqi+nK6RcoFnWaZbS/ji8YMa0DgwMO8pv+Cb5r07msjsttiRQ9GlhUNDT7mK9qndgUFJnQGXvub6I8VuuklpiMquoRREI0ctRdO38vqAkIz54G2uGU42KTvGr9HMBNPnRQyXzQsEsePvAS7LGebO3kyLydxjYOxoUunTquzy2ybY1lZtR/emVTfGF4+mVEEm5N621nNXI2elxYevtAWjbkenH5yi954enKvh8wg5c6Xd7JojbgR2cDRuAE3QeJhYz8vcUFRjLK7msgfDblaUmlWIdOuDdgMLsLin9ecbSHnpKWUHnb8Mpv3sXQnRH6A+8wHkvysgWSDhFKGiRTeKtHWkX/H55PnMqHSzxHsixDg2jhMi4iNM1UM6TtM//W5lXhn864zjzGNdLAHX68wyR1ep2Po+YOBU1i4Txc8OZeyk35ObSLh+81lta6BWheUgDu35mLevclyi/OoK7Rfr5JkOnMQ3oBN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(346002)(136003)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(41300700001)(66946007)(4326008)(7416002)(38100700002)(8936002)(5660300002)(66556008)(36756003)(33656002)(8676002)(2906002)(86362001)(6486002)(26005)(1076003)(478600001)(6506007)(6512007)(53546011)(2616005)(66476007)(316002)(54906003)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T9qROq3e6Dv2KH69k/FPN1u11dGlWdEC8ZtUsuAqmIjkL4bEAa/5B2jH8rQ1?=
 =?us-ascii?Q?2nx31LHCj1wSRJTylN9YWKFA+aeab/Q7XiBNKMi9HVNMWsXqve965oTA6Yfo?=
 =?us-ascii?Q?Lq6J6cuHPCZKLTms5lIzu0SI/8j8xQoavAZAJFtUpHyl+TEYs/FwYArdK0vF?=
 =?us-ascii?Q?Gw2WyqC6whxAyezX5HucTeRbGD9F9YkNfCXCWhfKzuWKgYZmWkp4BiyuPSvj?=
 =?us-ascii?Q?DGXfDK3x+asaxaJamJQ34kPGV/qQsenxDOz+2KMAYuSVmnIsiBr57sc8YhUO?=
 =?us-ascii?Q?3bnZQcttD4rjH7QFyn626orX5497YKWGsiZJuhpyk68MJauH5GYXZ22T6GeU?=
 =?us-ascii?Q?tlqs5ia4a9p5zLlVQoeHqdx4ePqt6mUqc+U86NEpiVF4GWbUHGQnDa7bqPSu?=
 =?us-ascii?Q?jsYDaOcZarKH0iFjBPKdmfSBEpBapjQZU71KW0A4I2HW9AY9nGYkfc5ZFOp/?=
 =?us-ascii?Q?LAm4TnHSdeee9ZQVthXeapmzfK0ZG409sMu7dCXgwl3Ze7ZNtIoBvxsRSHHQ?=
 =?us-ascii?Q?MVolazPzC7rWetqVXz7Hbltb3t3Etp0NeAMnTL4mPiECmEHg4fbukHjf+EDQ?=
 =?us-ascii?Q?wU/aGxDPqEozK6Ow5er3WkjBMveO+3RpLudNWNujoiTjqpRZ1T6ovJwiIzlA?=
 =?us-ascii?Q?diYe+fZJdlqWZE4k1Q4PqJJj3HhQVFRmHq7xye7KIIp9LH+oAmbO70ARpdRN?=
 =?us-ascii?Q?HeVZpPO4nZRwPNBXC5yXGUn9GCRZlzPxXJsUsqr9yrhSL/xDJgE7lSQmzHgs?=
 =?us-ascii?Q?775VZ8JZdDbgazitaoRxSVJH1vOWRxUctUKyPeqwQT+QVJ9ph+MqrjTk6YlR?=
 =?us-ascii?Q?fexb70ZEezmmNmau670brzFGzMnNvcEegrGGHUjxUd2h9LE1+zdeetng1VEH?=
 =?us-ascii?Q?fuXVG/11FP/0LlxtD7Oj1nluKfNjJNlbSVPkZA9c3bAiv8vgw6nt08VbPOyA?=
 =?us-ascii?Q?IklAo6LJvreDeZ7ub60rczyUAL+7PfkX5KM5sQOvKQLRnTGvFWsEG4RYbNFN?=
 =?us-ascii?Q?2/b9OSkQQqVHM5Z4xpFWVweSvo+5bU+kFp/m21jFjg229Iu/uesOeuHgUpJ3?=
 =?us-ascii?Q?+/g48xMK0j+XODh8MAIIZcy5KQR8YvgWZsBjYxUxLiMdsZWGaGIJTVfUA5WB?=
 =?us-ascii?Q?fazuefJ83bzM/o205rUsjuloBjdMiyYKboIBGmdvoMTp9m8CQVSDeTuwgJns?=
 =?us-ascii?Q?Gnf+vrSljS8Sqb19pi/UIIy8InJJJGzZFeDLZd9g0ljN9HwyvfJTnLuVVe56?=
 =?us-ascii?Q?3XKpXTeKuC/KP0/IEvxQfh21MeiEx8P4UaNhRhNGJM/JHDJUBtDE7kltNbLa?=
 =?us-ascii?Q?vpSNiVNhVFFNCIAGyIRPiix9NE/4EjQCnNthPyoCAbxyDs7OBJ0ak/EWp9Hz?=
 =?us-ascii?Q?HAHm19bkIisKuNBOTM8JTabPlwLyUlUqpLLvyPqHhHCeAB9bUAUlcg/Uiazr?=
 =?us-ascii?Q?i8M0ixmdlsrEc1dxsJl+4Fr8eAOPx3k7n1ZUOTT947yiwscXYVxpx2DbwXo+?=
 =?us-ascii?Q?1NKpIy34phMUwIRGCP9iGBWNdXQqX6ErccGo2XNyZ8Z4vyjPKMMSIHHWkAwu?=
 =?us-ascii?Q?KeIUB8QeYi+Pj1yYgN4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8392a240-220c-4879-af51-08dc265749d9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 14:32:32.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oB2b+tTXf3IAZLrWOz46H1oUf07xB+wn0OxtcazKSGt5GZGiwtp26DILwdjRmeAx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440

On Mon, Feb 05, 2024 at 07:55:23PM +0800, Baolu Lu wrote:
> On 2024/2/5 17:00, Tian, Kevin wrote:
> > > From: Lu Baolu <baolu.lu@linux.intel.com>
> > > Sent: Tuesday, January 30, 2024 4:09 PM
> > >    *
> > > - * Caller makes sure that no more faults are reported for this device.
> > > + * Removing a device from an iopf_queue. It's recommended to follow
> > > these
> > > + * steps when removing a device:
> > >    *
> > > - * Return: 0 on success and <0 on error.
> > > + * - Disable new PRI reception: Turn off PRI generation in the IOMMU
> > > hardware
> > > + *   and flush any hardware page request queues. This should be done
> > > before
> > > + *   calling into this helper.
> > 
> > this 1st step is already not followed by intel-iommu driver. The Page
> > Request Enable (PRE) bit is set in the context entry when a device
> > is attached to the default domain and cleared only in
> > intel_iommu_release_device().
> > 
> > but iopf_queue_remove_device() is called when IOMMU_DEV_FEAT_IOPF
> > is disabled e.g. when idxd driver is unbound from the device.
> > 
> > so the order is already violated.
> > 
> > > + * - Acknowledge all outstanding PRQs to the device: Respond to all
> > > outstanding
> > > + *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device
> > > should
> > > + *   not retry. This helper function handles this.
> > > + * - Disable PRI on the device: After calling this helper, the caller could
> > > + *   then disable PRI on the device.
> > 
> > intel_iommu_disable_iopf() disables PRI cap before calling this helper.
> 
> You are right. The individual drivers should be adjusted accordingly in
> separated patches. Here we just define the expected behaviors of the
> individual iommu driver from the core's perspective.

Yeah, I don't think the driver really works properly before this
documentation was added either :\

We also need to check that the proposed AMD patches (SVA support part
4) are working right before they are merged.

Jason

