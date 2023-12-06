Return-Path: <kvm+bounces-3708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7DB8073D0
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85140281FB9
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C79945968;
	Wed,  6 Dec 2023 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nscj9pEH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D139C;
	Wed,  6 Dec 2023 07:38:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAokY4l41VZRgDr968TA5D42QKzb8CRL1jhTZ9p+lTzFGN/o5zAjtmU+DDm3xN9/tqEDAtVp+tBaOM8LSTyxWuG+Wu3jLfY7tv56QhK7V3eXmcmtkj4SEvBBw/wUY7myoaz71kazy4hm97oKi1s52a/QY+Yk7d1Ry2/bgeuiaRR8scR1jqxWlZPghDMHVTBjQn0vSF/UhwBzuDqPDMH/mSXF9OVJlkV6FJcFL5wcZGeB6Z8pY8SAaMlP4UYRRUPbQXRpve/lodyQStjwVrE7bIudxNcefCfmCwmcxrRLRz3MKqDLUZroo5hcS2pnaKqemOM8QiGkTxqszA/jvd/QQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ENTAnW6Vnq/r2xFW1aroqscCPTf8UT4lD2uAoZy4FFw=;
 b=cfBHvYZ95c3G7+81oJov8edRAEgzh4hT1kOu1UYvvYTV/ZaWmDdvCN4cMh8n43eKWEdpiW23C2SYPuVMMgnm2ww8i69im94ja7XvDsJJxo6rUHu/X8eP0hm/tQbDmyi24U/qRXtpn7RBjlT0sOXWR6mQ0nFiI69cFzQ2a0D5Q5/wCXx/417xPYBM0xMIKWebN6xOvSUCTuX0pihqJvUL2ABP9Igsqp6kzC1pFmAPYt2xL7iMW6yT9LdIizL00ele0/PDVQYWSHdmSNhMpai8AWXfxjIZA7dyhPpWV5E2BdQajRXRKTk6vVhv5kWXuyrmRnl6ahahL/SGPZOxgdBmjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENTAnW6Vnq/r2xFW1aroqscCPTf8UT4lD2uAoZy4FFw=;
 b=nscj9pEHRlUmXO4DkATXuGg2OuSOpCkaKWnB68Qb82YRK6suTgYlp/881sXCcw1aDRIIaRrnu0CU54rotmpaZdY/RrwwcMXaa8iLg9VioF1tJA1SnI4gyQ9QhqXBDHm2glRzi6HM0ao/Ih8BmCtIl7i2oPu/GqFesYm3Lb0Qcgxzwb+JkfgPSIlTrFbUfygHUhhDzwTqu32U7AvxAPiGkT+/E4AlIlTxXwGT+iCbOD9g5jqAQ2UsbBU3mdAY0oeYomekZR0D5wVvnAbqxr3zw6DLg2QWhW1x9OLiCbweEqZBdoTevaI6byk8+S7GFNumJeShbzMVDqXUI4Nf26Scsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5980.namprd12.prod.outlook.com (2603:10b6:208:37f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 15:38:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 15:38:11 +0000
Date: Wed, 6 Dec 2023 11:38:09 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231206153809.GS2692119@nvidia.com>
References: <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <ZW949Tl3VmQfPk0L@arm.com>
 <20231205194822.GL2692119@nvidia.com>
 <ZXCJ3pVbKuHJ3LTz@arm.com>
 <20231206150556.GQ2692119@nvidia.com>
 <ZXCQrTbf6q0BIhSw@lpieralisi>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXCQrTbf6q0BIhSw@lpieralisi>
X-ClientProxiedBy: BL1PR13CA0417.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e0269d6-9c44-45df-ac23-08dbf67159db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iDOnXAwpqddZLot1dWOzy+487PRaQjISHFfmhM6ex2XbRWK7h98yeNHils8oSDPXR0j6gg94IEdA5hCf+aZyBb72K7qMlGS61OjyOlEr8rwXY6tWS2OyyL8P0P94NUJEwyp1tkqakJTcyxZvF3pNQQITFucCqTN1gnwZEZzrGZixW9OmlqNPp9wXJ8PPFACGope6bJEIOPj3bvRq3dEWjq+LgxtYJrtWgVTwkkc+UWUlQgI+ZWWIozA/4lk/5H1zMGBtjyTXTmMd60jj0Z2n5Bu9APr57PDIWwrByzhAJp1fFyoiBIacEzkR8+T3jOYwMKoUlAxDHjjGB6jaNRQDAoeDI8lExhXOjcFEAN08lUGTsOsNgYSxlM0X3ZWyaXrM49bgj/WGacwKKHU2JkJusD7IbNnMYGKCOJkelZ8l0LC/JbWA7NaVFsyOgPuOY7hwwVJ1/SUTfz4EpokExVl2mXP9tdNB2uwVYLYTlmErZvV0NEgb85Xie1/nqPJFcpAqvsAmINwHARCFKbHAFM0nbMEqO4a1dMLj0eoRx6RtCmvW4zT9W+uiSD50DZrxZC8z
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(366004)(39860400002)(376002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(6486002)(478600001)(5660300002)(54906003)(66476007)(66556008)(316002)(6916009)(66946007)(8936002)(4326008)(8676002)(6506007)(86362001)(83380400001)(36756003)(38100700002)(41300700001)(33656002)(2616005)(1076003)(7416002)(2906002)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JORLi2ffC8OvRHrCOQsfR48giCBrxTh1nAXoh8q3ZyTRf5k4hDVnF/G0+/A9?=
 =?us-ascii?Q?HAvSkw6viNhy7XYISxzrSang2DG/tP+2zFy9bncxngzTrPB5WE7hDK6GKQ5i?=
 =?us-ascii?Q?UbJeXi4APCexxy8K3uQnKKpRRuCDSn8UUKFyEFxVn+Hatn5WCf3RiDJyaYXh?=
 =?us-ascii?Q?eeM5Q04FwTA35LQl+GlYbfBBYiqzkp77Jpv4Hnh91nP56yVmb+oyCjSrR+An?=
 =?us-ascii?Q?4Aw92wI9tD1XmZYiq1EtnVD6k52HiY3ZJFY+5/E/eTDS2m2x8v9a8w2buwGu?=
 =?us-ascii?Q?EXhZOqPkLK/+HPxLLskiX7X0S616B4ONaqxSUEQrU5eWmn7yfhHFgKDLsOt4?=
 =?us-ascii?Q?/Vp5qtqLuey4qf29zsyM5jDy4hZmJDbdbuUZxWovQ6SKGGC/CqCtRkcrdWFs?=
 =?us-ascii?Q?fduiAXKJVja2aiuzCB2PxhSIoH9dxQy3/MN2el4dUlqMB2WNfsliX8DBou6f?=
 =?us-ascii?Q?u/i/HNpXGksI03JdcJ2lYRwbk7ZcT7t5h11mcIwCBfnx8kTplPdM3il7vndC?=
 =?us-ascii?Q?paHNh7Ekj5qVGxLYcSibJL8ZlEK4GpDTdbvbzSFnTc12rdLq2OKOwYgEYm6o?=
 =?us-ascii?Q?tBldmo0BC+zVpjBbLLmySXkaCQbFmnkTmb50h63jP3yoOTr9tKRX3cmpVJxV?=
 =?us-ascii?Q?9DAXLkBlAQXhGnW2vXAGB5PxXI42rlOuqU0H5tpXplebCuWxHryhaMp15Vln?=
 =?us-ascii?Q?4x1wNYao8hMgZs+yBmRWV309S7D7oSfbhM4wSYWEWZxVgz3jW3f1hk4z4XgO?=
 =?us-ascii?Q?K4FUodSdDwP1+E1vYYpqa8AcMbdySGKJh4/gSFP/Fv8ft0+9PhuIh3Bqh1ud?=
 =?us-ascii?Q?OWtItS9pFvAHeT/KC83K/57pu+zyfgJxn6xeK3H/uCcBHwWKhrtgSkqAuA+5?=
 =?us-ascii?Q?ch4e0Pcwx41H4PLV5XqTA7oNrPpnYYWzrG6cSp6Kgj+ZtQbpcLe3KQjVhP3k?=
 =?us-ascii?Q?K7ks+/yjL3sjNuwqiBFYMT+xuSaBIPlSHqdG1DXaE3P2qvwlGcfRAWBLcurF?=
 =?us-ascii?Q?sa2MO5o7NC/lC33xqT678ImCa0L3zlrKI2Y+ynKTykwjW6FUb0/9AaG2s0Ux?=
 =?us-ascii?Q?aZ0nDWf2LKol0HFOeHMRPekHIYI++r1r1zj2Z3bPxS8YSYhuY+RCwrNUbGv1?=
 =?us-ascii?Q?kaHicVoqoQY1QcDzgyf5nsxL1Cx15h1EQYd0jbarfBOSrcoBF+20WBQM1xFE?=
 =?us-ascii?Q?07/l4BVf8h8ldqscWImlSxARuM/SNdPdgWehroQEh8tqbEPHcFH98fCQvpDD?=
 =?us-ascii?Q?yFXueTMiD5q619XC5Ccvyv2FBEPPagkE+e/eEO3hsUhf6G1SODziJ//mwWHd?=
 =?us-ascii?Q?UuY0KrgJxyBRuUL6sRxiSQS+ryv6pziz/Ro8jYiyfru6tAD0z5uU+pQH0t1V?=
 =?us-ascii?Q?FQ3ZEbUkAOZNq7Zm/QR5+mNpa5FBQ9jsXQPeTD39obOBbfSatnW+pjuSbd4s?=
 =?us-ascii?Q?SeW2RQ3NNZ5FUgaXXRkzHs7t0S3PvNtf3t+kv9aH1iplaiznNy0m0wiro+zc?=
 =?us-ascii?Q?REbtpwgusQBjrwKNGk8tTVHTBPRYI1A52RIZLy3bVeX/xvMDXt0KNo+5k7nH?=
 =?us-ascii?Q?biCeO0f6+vhaJajFHr5tqEvrLjkoSr2AXwIPbX8y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0269d6-9c44-45df-ac23-08dbf67159db
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 15:38:10.4246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Gfi/qvtE5jYIiXmCtzMfLFxaDxHTpVOmSKDAn+7jGPPQg0l0wW0SAbPVTUyJ4kh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5980

On Wed, Dec 06, 2023 at 04:18:05PM +0100, Lorenzo Pieralisi wrote:
> On Wed, Dec 06, 2023 at 11:05:56AM -0400, Jason Gunthorpe wrote:
> > On Wed, Dec 06, 2023 at 02:49:02PM +0000, Catalin Marinas wrote:
> > > On Tue, Dec 05, 2023 at 03:48:22PM -0400, Jason Gunthorpe wrote:
> > > > On Tue, Dec 05, 2023 at 07:24:37PM +0000, Catalin Marinas wrote:
> > > > > On Tue, Dec 05, 2023 at 12:43:18PM -0400, Jason Gunthorpe wrote:
> > > > > > What if we change vfio-pci to use pgprot_device() like it already
> > > > > > really should and say the pgprot_noncached() is enforced as
> > > > > > DEVICE_nGnRnE and pgprot_device() may be DEVICE_nGnRE or NORMAL_NC?
> > > > > > Would that be acceptable?
> > > > > 
> > > > > pgprot_device() needs to stay as Device, otherwise you'd get speculative
> > > > > reads with potential side-effects.
> > > > 
> > > > I do not mean to change pgprot_device() I mean to detect the
> > > > difference via pgprot_device() vs pgprot_noncached(). They put a
> > > > different value in the PTE that we can sense. It is very hacky.
> > > 
> > > Ah, ok, it does look hacky though (as is the alternative of coming up
> > > with a new specific pgprot_*() that KVM can treat differently).
> > > 
> > > BTW, on those Mellanox devices that require different attributes within
> > > a BAR, do they have a problem with speculative reads causing
> > > side-effects? 
> > 
> > Yes. We definitely have had that problem in the past on older
> > devices. VFIO must map the BAR using pgprot_device/noncached() into
> > the VMM, no other choice is functionally OK.
> 
> Were those BARs tagged as prefetchable or non-prefetchable ? I assume the
> latter but please let me know if I am guessing wrong.

I don't know it was quite old HW. Probably.

Just because a BAR is not marked as prefetchable doesn't mean that the
device can't use NORMAL_NC on subsets of it.

Jason

