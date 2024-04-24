Return-Path: <kvm+bounces-15808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 522648B0BE1
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 16:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A2EA289A13
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 14:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3874415DBBA;
	Wed, 24 Apr 2024 14:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o0KuacF3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD2415B550
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 14:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713967484; cv=fail; b=g+3jRZ7YetBsxB893BVVGlTgtXk7FSu6YYdQ+FjDVFYuUYGEcU9OdxZHpJED8ati+CKPe4fb0n4srGbm3Df0xUkJJho+m6FWzC9hpEAe5xbrL5UJuZ8Btfwjv9bSYjSO8gLagtuqBDnGa+Ssn8M14G/W5KlLcVM9MrYYG7637lA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713967484; c=relaxed/simple;
	bh=UcYGC9w1E7f5vR7Af/cHfCDoSoiqSCtgcxVY7xR6fjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VLKWDvtFnfgjZF96KafEiWHMMtQO2sokpikL844SxTHXa+i5tiSsHsYmw8aLR4fe1UGOzqN28GFL7HVG4DQgBIF9Cuclv2Eokf9VOWIRVwOdGM39hUz2YJCc7CFZwTwhCUxGrGLP+PVFb3+siwTO6XzNbMyfW9cYBmTiW5VAETk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o0KuacF3; arc=fail smtp.client-ip=40.107.92.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C53NMiK3YI60/rxOmGc1i/Dc+MVz2hBwgvCrVyA1zs9ZIIwN9kifDqRnW6zSvnxMmOdJp/W0qTqS1TnIfIos3ruGyvhB/Mkx26MDUOH5i7wcTf3/r6bNiy1lVqA4hTfquPQHZlhoL10p/i/nG9R9ZYIHYmCG0NyF9WI1+MQv/74h3HTcX1jUYKEqFBu2SuOQlSs7p6SW3mweKyVqRsy05P+9Yc1Rx43KB9A7ywTIf9ycnGu/+zfc1w15gA69CbDa5epy7JCotbFrbJ+jdbUJfF9gxlPBZxsQFfZnZf8nlKNcRi0OFOLJBYhRLregaHSGqBn5XfqegVwpJnOSL5SUpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jv3sQhT4QuwvwAG6M4VeWHaJzGa1tNGJyuFq0ti5ZN8=;
 b=NTYlDKO8lR3i9wyUAnmW8RC+PX/t/iR6CVvnarNtfUEb+8OzOvMDEhakbsFXBoe31o2bQEbzelrlRz5wKqp9Xqk9IHi/iKzYn8jRU7KHTySgfDDu1znfhw+DhnxW4klv6JGrXEPR0i6Ahq03yqwqVCwq0q9qX43clFCfkXxgbMX75xf6DxeP11DpwRLV7/Dj0IRWEFJGgA6I7Mfq68LnCv0Y4PfblzGmtVPGV+kItpo4Zm1koZxmTbu9tozjqhfh3/BBGSycIwdHQExV/+3tdR1xkYXt94V6UuerfmLlEAt/DEybXM8rBWB10mCFYK/QTe7kAI4GozsHxvKwHaOCCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jv3sQhT4QuwvwAG6M4VeWHaJzGa1tNGJyuFq0ti5ZN8=;
 b=o0KuacF3U4wCM3u9DwWgc/0GByMqjxEpvswT+vc5uZAB1KOyZRB2hEN/UmZDFsRV2vkF0URHQ1N98k4erCp5wPJpTeHWiNZ7UthnPRokwoZCeodVU5V4KpyNk8R0dCRWmArg+wrI/1ti4yEAsUeggDl9JD94MaLYcssq0y+itOHu9VAmVyQIrc3/9VO5YqSKe6IjVKa9tRJa/ZTKgoiWexmuMrhTf3N5XAB+htEsgAw5mFja+UkUGz7shYlI4DScG7SxZ+wXx9tQ5EH9vEpD6dBz6cAQM3W29QjVkZUf0TpQUEwuJrwdzn9lRTsy0d/sDZxQRKOzz4JnSuDAT/gMLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB9103.namprd12.prod.outlook.com (2603:10b6:510:2f5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 14:04:38 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 14:04:38 +0000
Date: Wed, 24 Apr 2024 11:04:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240424140436.GM941030@nvidia.com>
References: <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <BN9PR11MB5276555B3294D5A0892043E98C102@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276555B3294D5A0892043E98C102@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA0PR11CA0176.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB9103:EE_
X-MS-Office365-Filtering-Correlation-Id: c76436f7-9f99-4c3f-e591-08dc64677a98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k+Ps6Ek4ZrT6a7r6SzUASLNzOoG2PTzc7DbUzG6WV5DFpVvqiefplQTq7PdP?=
 =?us-ascii?Q?t5/RRhjCM4DKxF5o5u6g1pSKgaOE+ruMMHjOGIKW5cY9/8mKknWMduNNmkIu?=
 =?us-ascii?Q?5W2Aa4FwAq5auPhNRUfRTPJrjMJeCI/hmiC5vvbBiWVzk5ju8HvZnSnwjuon?=
 =?us-ascii?Q?rxn3+JwbBfEMZT1Y8a3LCBUwd1vnT6JKXJ7Mg/yjHhDllniGPaQoSZOEttz0?=
 =?us-ascii?Q?MuZZMoWzr+BcgURdwNtDHlMXjMOTvmIfU1Qhr2M3IFCA3rQ1k1dMau+NcSiA?=
 =?us-ascii?Q?A4kxvFvZzZ7+VIu36G+gdyDgtbVlcZ7ZvpvqXmAttps2YS0IYctbhvUqJpg3?=
 =?us-ascii?Q?MkjKxF+xWZoMIrkMChE7he6lUtVkuYRYWKLZTLgWuIMxDobaMoxbKOYH6XX3?=
 =?us-ascii?Q?Ucp1YXz7LvWwHbNzQR+RVj9GshaP6UdjlHE/FTLq6l2ZvaR46KvPbSdygDv8?=
 =?us-ascii?Q?+MBMghWsMwL0xnVKIvLu2B7bJTjY6+Jxp1zzKTsUiLsReYoixsKYxLD2hCHY?=
 =?us-ascii?Q?NK6N5GB42kHKswSPDctPau2j3rU4ulV7V7QkF35D4KS4LWilzRp6i+U7bV23?=
 =?us-ascii?Q?jZZ2C8gByDWkOzB46UXCsMdp8QaH7IJVNVzNHW2wDuBcSpvwjS1yN3f4KYmU?=
 =?us-ascii?Q?mYi1n+vOJhG7DYm3UVamKhkyY+EXMaosibaRTqUmUoZqtxjGTsks8JKhAdVy?=
 =?us-ascii?Q?usniP7fa8axUjb3Oqeoo3HB2WKTx2zOyvDMLyzTfcFNW6M3GZjBAVBoYUlqU?=
 =?us-ascii?Q?hKujMUZBu6FXG/7qmzrb11MOGwOwQ/ikHa4RXXXn3wMHBS2QXkRGeP6JOosg?=
 =?us-ascii?Q?YAHAzeTH7C6r//fGwB/cLWd+pgjKOiN4DZhOPdnsNWFAuX1uJpLDzG1r7qGv?=
 =?us-ascii?Q?3Cm6W+KbcxADJ7Ja7z+mKbQPYM9FmGlxLsWH1RjuYOr44PbivIYDOjZrfAlM?=
 =?us-ascii?Q?hFobIPWCEChbfbpLcu1UWD/ruF/KUaxUQ/wLJv6gdaIvvQPr/SeDieF/tKLP?=
 =?us-ascii?Q?RXFCKfdXCnHs6bC5/bRP7veDLm0LwFGvKvh3pGqar8ODF+vjISBBobn1QxXh?=
 =?us-ascii?Q?tZ9bf9+/ttIMc8QdnfvSAR6mgdTXo/lqnmyj7afNqCuqrD6rKocAnQmrp3Hu?=
 =?us-ascii?Q?T1j6vQbHxzLRSgqbcbcThf8eGs4Pa0qP07D8Ux7LKA42GMzpOtQbygf8y94O?=
 =?us-ascii?Q?UKc0O/pjG/0Pupd14ht0U9IIwY8Vabh6KZPqdXs0m9+w0k0rCYeoWuv0cgNP?=
 =?us-ascii?Q?gJ9vwe84Xb8Ja9K8h9N5aTlPWi/0CvOTgDJvEsR3gA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eVcVSeC5RBRwh5cwDYgxewRuzXALFWeGWaGfEK5brfZcx6rYinmJH0JbtzZ5?=
 =?us-ascii?Q?p1YQ6/zVIHXwl7hhddUO0Bl/6bZ2yYN++m7TbLjXeJC7pN9+e3G+kOch8Drb?=
 =?us-ascii?Q?LyjGYfdb1CAc60LB5GVMtSYpdVCi1pvgLQafN7CA4Fq5klRpwUnyt+uKNS0O?=
 =?us-ascii?Q?LNraYOz8V1Z09THYPdESIMLB6gH1++vducrQjAK24KeRyZERa07gifLA+7Wu?=
 =?us-ascii?Q?bDmk4+7qbDhGXPjgPgkFQHdMSyUI+gJVS4Px0KjLBipMQDAvnG6yaZsRorCw?=
 =?us-ascii?Q?Fip+VQqbUwLfhB4oWhEhJIBNWGt20gMLhq3GxqR58PpzCfTQfbA0bMCeGkmi?=
 =?us-ascii?Q?1KZLPkc8fAUzG9fzbyohqCt6loaWhVbWOQW2T2HK6BYKC8zX87INjWTuDreY?=
 =?us-ascii?Q?T8cwCE8z4epFgqvqgQUyCSJVG3JfYha0pRdT7FumxdBzFzmwJeoV+l7QCfL7?=
 =?us-ascii?Q?f3ZLxxPp6gChzpKDVZU31f96+Jodw+y5NSwmHeF86ShAA19C9AaCOBUKfBsw?=
 =?us-ascii?Q?PtvvkF8bJIxRD2EdLSEV5XqR8JsC4pdq1s553xV7z8/ssoJOZUc75ZsOiZfW?=
 =?us-ascii?Q?5J+LR5Sv/9EZGMQusqiEXoxs3RxCXfdL7fwlaS0FFzPUxK3LUERbCvqyNkup?=
 =?us-ascii?Q?2t2Q+rgh/fE34NtXc0nRgmsKPISlFClA0tizcISSwxXeaE2e8R4fOtPHJljq?=
 =?us-ascii?Q?YRPjdN//vXroWnVQrfcC+LNbFY8W55ZbUM6wBc6bkGbeWfW5pUXxvJ4QJqF5?=
 =?us-ascii?Q?b/ymJYtehtpevCnTPSzNWjXYjwOjeL7aAESIkkKttDu+Qe9HLfxy3PNYEvfg?=
 =?us-ascii?Q?0UtLjcUlqM/lc5T6gIWZUpbv9NkZ92MrCTvV/vNMQYLRvc2lwVMqJFHv77Hq?=
 =?us-ascii?Q?MclCDAXWSWZi0pYjPxP/W/jnM8+V52WBJF8llpfhMpFA+t+6ZmfGa455RHnC?=
 =?us-ascii?Q?z4KSv/1MOqNY4X0xvcPbxFwS+UODMZU56cTftGPYztzMlffhbSEJzrjskVoD?=
 =?us-ascii?Q?XSmkElf7WxId5fJPpeYsfupl3khxKsiGTnEtUFnNse581X2n1ogLe3DwTryl?=
 =?us-ascii?Q?dqbaRD5TIieNlHWPH9n8A4wqdRS//9JyYMVWxQ2HMHuZqoq45xH4NWhTdFDG?=
 =?us-ascii?Q?uRouZrwdQgtwsYXuRNVdXZ6q9lyY/YGYMzEByYTtLN5QEuK6sN/5fATBuiMl?=
 =?us-ascii?Q?Mpw2AbYTq5tDvi708N5NjZ5XsJIH6b1AbI/CwET+ImfAienjLs5YOnXSDXsx?=
 =?us-ascii?Q?Ja4UeqibJmBvWuVn8GhKluWyzB5QBBqDR8rnVVwNlxJTQrr9wjqd1XJ0oUNs?=
 =?us-ascii?Q?h4iYcPkeU8kEEXyYo2LrXm5Z1IcrJh+DBXtmt9SbeNgbTOLyJgpT5Jy4REsp?=
 =?us-ascii?Q?Zeb8POZtNSNY/ibL1jUIj7L6PW0D4udIlgvcicWrVtxK4weYjhWh7A9N4JK+?=
 =?us-ascii?Q?u7nORptSouGCLIUSJjlV9g7sVpyNzabCvf1AiyGztOY/dywyJ3E9numvaj+u?=
 =?us-ascii?Q?fV0M0g0/dATGXxfdtRmgmmD/TFw/dWTd6L8EWugPw1tfVCpPq8B4Lq0lw2Qi?=
 =?us-ascii?Q?hb9qQ6Yg6jAIO+cBF0WohJt3iya4WsDXVFvWVTag?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c76436f7-9f99-4c3f-e591-08dc64677a98
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 14:04:38.2071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KY2/TMrA40AtUyrHDQfj4HxUs1z8dQpGZLrjG3ApkDVK4sJK2Yjn1yjkIEcoCJDX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9103

On Wed, Apr 24, 2024 at 02:57:38AM +0000, Tian, Kevin wrote:
> Now those shared capabilities are enabled/disabled when the PF is
> attached to/detached from a domain, w/o counting the shared usage
> from VFs.

Urh..

This looks broken in the kernel right now?

If you attach a SVA PASID to a VF then the iommu driver will call 
pci_enable_pri(vf) which will always fail:

	/*
	 * VFs must not implement the PRI Capability.  If their PF
	 * implements PRI, it is shared by the VFs, so if the PF PRI is
	 * enabled, it is also enabled for the VF.
	 */
	if (pdev->is_virtfn) {
		if (pci_physfn(pdev)->pri_enabled)
			return 0;
		return -EINVAL;
	}

More to fix :(

Jason

