Return-Path: <kvm+bounces-3322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B5998030EF
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 11:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF1D8280E15
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13BD224D6;
	Mon,  4 Dec 2023 10:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hq5sK00d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D5695;
	Mon,  4 Dec 2023 02:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701687138; x=1733223138;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KO8xa70I12jtEeV97xo30LQYEpvcbCMvFxjj4E40jBg=;
  b=hq5sK00dzwA+oRmzTzvttjN1Jz9HcYo5sX9DH+YtXC7I77G9MhBTZdI4
   n5PePQuei6cInLTdJqMmUZDvs1q/ZjppYXSBYXzKUAOf8brix6zQJ0U/0
   WLtLyfZ06FyoVCz/Q/Wb5o+tSW4etIy4U/JyOull3KIgiL+lEiaaVtj5c
   xeoOWVEWpDwPgxgukTI8I0BVLqZU/trtL3F4FwI4/UiX4bPAw/Kwm3nqa
   nBSDQbNWTfnDnjeVhbG8afGw/lwaLCRn1f4ngotO4U9K0WMl/k5+csT5w
   zlMLJuwwKGk7j7SWKHP+2ywQIyXci0TBJsRgmMGzbiOmAlHcx24BjtrJ5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="460209392"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="460209392"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 02:52:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="836546757"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="836546757"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 02:52:16 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 02:52:15 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 02:52:15 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 02:52:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJNDbkfq8xnYaEufyIlx/GO6WdLnJDdh+jEHZAJXHyTKvyW14JVWEnuu1HZYVHbnaQo7kz3WRNi+gN8l1xJz/ZUyXeKo5gQqHGQYaNbuNcF/vAeNGcF5KfGQIFowZ02UbmiX07Vzgua/J/UAWKm1RTPYf2FPi3eQ5rUrWOevbHPk0EFfT5JpBbmygKxuajUH1KHwiLciiDadVRSVfOSoppsWJNwy3tSarX0lseMl4vFPG6dBtxgvC+iCE7TfbWaS/caAkdOuIBTRod+X46PbqJ5aeOCRkHKwBbeBT/LQyY5v9RVCMRcBKQcgn3w8zg3vRRuLCcjeYENQxL6qHq9YGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yOmnq9PY/kaCKPJvIHxut2ATYtZORm4/FHX1kilS+E=;
 b=D5465xESEXe2+/ks75zhurb/DfXdqG/rHzkdkvjfLp9AiHE0fQPaO43eOl3XNm8OC+ZzmHvY0HKUB85WqvicC9o5o7+U+PzUT3eYw/udTAL/V8n+/JlOpo6h75Gy6weQ4GgzfqlQ2gR+AGlVACtd6KibLUIKaqrDYXx+dCmTuSsVMwkGIsZW4apHB/VRckcHUlyvuoiN0L65XxRixHgDprNty2UvFwJuQyRV334b2FSyLI+6163+7k8vT+2YiBNTqQbK7Ott43UL+GTj07RHO28SaD1hwe++Wk8mfQVsIPEhfQglfbTzvacvRabidpL4bQHPg9eCc/iByeTl+QjGtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO6PR11MB5635.namprd11.prod.outlook.com (2603:10b6:5:35f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 10:52:13 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 10:52:13 +0000
Message-ID: <4593a682-b33b-4284-b94c-7f7fd9351171@intel.com>
Date: Mon, 4 Dec 2023 18:54:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/12] iommu/arm-smmu-v3: Remove unrecoverable faults
 reporting
Content-Language: en-US
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-3-baolu.lu@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231115030226.16700-3-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO6PR11MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fc9b0d7-ed9f-49e6-ee41-08dbf4b712ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EVCe3c1mFWjr5WOFx3DzvW9hDMsz8jEzpSAlorg8VVC1jB9UPCT5M8I9FI9xRiL5KXu8PDhcytwDPP9ytK65330SaOIHZJTsT01pHysUN4s2M057GqaVIKycBSVveeOB/zZYZr5gof4Ya9B2XtfpIovSKNj5e/40Iq/HKENIGU3k6Vo0+UlH1rycL8Q13xVgto/8Hi21XaSi2JCEauWm/GbtgnQcv3xFJKZlcdY7NykL8AGaBx8wdjFhbPmdGMO/hB4qPzc1+ZU3meM6ThEPnSXcFv5I8Il/f94MXNw1geEX/ebgwwb2loGab92gpqvQW7VdvkIY/dDvXC0uTYwneeAyJNz+IAN7RIYv+SHhq3HD3C3RBtTIlTsFGj742G9tufkEXgQL00ArTLHI8LIYiTRzAVK1aK1LoQ6F+AVDUROpIuGE0SN3eRr5bM5xnfc6IisacxFPpEO4rh0Z3g5XEEQI1YeP6OS7FIC9ok/P1bIlVfmWwVey55bfvkpybat3iSJ+XUefQ5tTVUL6KLpyA6Wu5n81zQXrxbfnXQI8XyVUvOdHCM4eANrVUtZ9N3U5B8kX1ufI/tT13gjjm4Tplz/8iWibAHLDTjd9jqdkt4L3GC6+WMhLyPTCPEUVAfPqTIaVyh8qK55AT2bPSaesQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(366004)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(31696002)(5660300002)(7416002)(86362001)(4326008)(8676002)(8936002)(2906002)(41300700001)(36756003)(2616005)(6512007)(6506007)(82960400001)(53546011)(83380400001)(6486002)(478600001)(26005)(6666004)(38100700002)(31686004)(110136005)(316002)(54906003)(66476007)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2hvZnZiVEtPNDNYQ2pFQkpidFlxVEFoUmJ0SmdJQ3BBQ0FZc25DSFBHSklJ?=
 =?utf-8?B?VDhYZjVySlNLc2VDYzVkd1dIT1A5UDArc2ppK1Z5WitraC9hZnRSSW1XUnh3?=
 =?utf-8?B?OFNPSzVxR1ZqYWNqMHVJK1p2OVJCL1Q3SHBSaTNlVmg5K2R1QWE3MGxhNVJN?=
 =?utf-8?B?MGZaL3ZpY2ZReHcrY0dKQjdPbmJmYTFFYWdGb3ZweDRlUXFqZ25zdjlyQ2xy?=
 =?utf-8?B?QTNvRkxtNWpVSVJDREl4N2V5d0YvaGprSzhVQlNoaE5ndmtrRnI0enhNWFJo?=
 =?utf-8?B?SGRhcHRpOVhSUnRscG05R1BLbzRIVHF2WXFDL2RKa2krOXA4SVpreS9oM1Jy?=
 =?utf-8?B?ZDlVamRWQXN4cWpnOEZ4aGJPWUdqSmhYZ0l0M2ppeGJDdDZ5K1hLTFo4OGha?=
 =?utf-8?B?eTJPWFVrUGh3Z0hnNVhaQmJMOVIzbFZ5M2FXb0hQSnNjai82aHEyc1pqK1dt?=
 =?utf-8?B?bmV0c3Jod3lUSE96eGd0WmtNOWFoTjI0MGluWXhWWjdINEZVa0ZiUHF4R29F?=
 =?utf-8?B?SncvQ2FJNDJNTmR3QWtEM3YzTVZIZnNmU3dRTFFLZkg5cmdtMkNMQ284RFZj?=
 =?utf-8?B?dkQzdFVOY2xzVmN5VmlmOW9GR3RpV2tKa3BzYzA2ZCtJQjh4VE12ZGJKZUxv?=
 =?utf-8?B?NmxOYUVHYldpRDFPOXJhRlZxcGJ2eDIraEZ6RjZTdnhDT2RiRlNnaEJjSFVy?=
 =?utf-8?B?QW5CRWtUM3JveHJFaDdaRWx2V0tmdjFzc0ZnakZhUWJYR3ZQempmdkVXZm1L?=
 =?utf-8?B?ajVqd2JKYjZsaC81eEcvdXF3cmFlRmhuQ1pCTWNDS3B4aDRBdzUvMlUrUTMr?=
 =?utf-8?B?TkhBaGtzUmxjK25sQXQzSndVMVhHYllOMkp1Ym96QStnT252SE9Yclo1RDN3?=
 =?utf-8?B?Ky83RlBUdjVkSzdZbUd5K0xUZWJJemJWNlhDMmFJQmc1SUZvWVFjNjAyLzNM?=
 =?utf-8?B?UVFCN3NRMUdDbDh1aXNYRXM4YlJHQlRTMUdWTEZBc3Q4bGdiMTdiSDNHaUNy?=
 =?utf-8?B?MjVlLzVFVEtUcDlneEcvV243dWRRNzFmS3U4QllhaC8xYTVscjFJSVhjeSsr?=
 =?utf-8?B?dlFHaE9LOEZQaERaNThlOTRocFd0Ry85QWtoTU51SldrY3hxVDduTnRCdHRo?=
 =?utf-8?B?cU1VNXNWNjVoNEphSzBKanVVQTVZVDZqQkoza0Y4elhaL3pudlJnSEYyUEZj?=
 =?utf-8?B?akVXSlUwb3NUYUs0Wk5RcFJtYlQrMVpDaHZXN2JkSlB3QVRXcWQ1Yms0VVZF?=
 =?utf-8?B?WTdGS0dwOGhvY3IwTk5hcWd3RDR3N1N4Y1VLNDdiaUlsRW5nb2dYTS9Hdkdm?=
 =?utf-8?B?ZVFYaHlERGZvNDhXMHQxcjRoazZEUVRaWjd3eVVxMlhIR083YXZkbm5ydFJB?=
 =?utf-8?B?eStZUHdUcDlNMDdFQmhrSjk0cEFmdm5EbDR3QWpKNk5sQXErTXhLSlQ4RDk4?=
 =?utf-8?B?MFZETStWME5zZWhJaWEzSW9oUTJrM0VVdHl5eHpDb1pOL011alFuaXowOTZm?=
 =?utf-8?B?djlTKzZyTEdXQkJOTVNjNVN5Tm8zc0tVWmtrSWFlRzdvQzhWS3FWL3p4WmJL?=
 =?utf-8?B?bnVFNkp1c3d5MGhJRTJDSlUwR2drdXM0OTNuMDdESGNZSXpTM1dRb3pNTGYy?=
 =?utf-8?B?azNQeHpMQXhCK1pVbk4rakk1TlFhYTR6RFBSMDZsM2d4OHFHRTlFZGFobVRw?=
 =?utf-8?B?NnBrdy8vQ0psc0hHZHVRdFUza3pKQXBVVitGbWs2eUl3Zmc4QjZhaTNBcEV1?=
 =?utf-8?B?S01kRFpwcVdYRW9hWktXbW1JUXhHWXc3UHdoWkVEc21IcDZlc240bDM1bk5E?=
 =?utf-8?B?UlcrU21LMWZxMjlDeVZGVlljTHZTamFPTXVORkpWSmxUTXJ6cDZYSXJaYUMw?=
 =?utf-8?B?ODVGYUlwRkFFRDVDRkpDaHdVL3lMM3FVQWZEVmZHQU12dnZIODJQZWZyR3Mv?=
 =?utf-8?B?SUpIaEozUzdKY0xGb2lhTGJYRlUwbUNnTC9ReWtod01hNFNpOFZPT1F3WXhv?=
 =?utf-8?B?ZjgrUWI2WW9ZWTd2V3FqNktydEtFMDJmeFFCRGxveDV5aHkxdUp5M1NDanRO?=
 =?utf-8?B?SDBVOEE0WVZiOWRBSHRpa2NJTGxUbk5uL0hvV0FvNVdXaXVSNjhtNUdnaXRt?=
 =?utf-8?Q?LTanhCMoR7vBDroTi2pSkrvNS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc9b0d7-ed9f-49e6-ee41-08dbf4b712ca
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 10:52:13.7606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ziZdqT14g3EspTAp6MebXLJbxCuRHxHsdnJM4s5bC3uC/xXqb8Rz0CrAWO635EbuRFpIk/AgUV8eh1opozvPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5635
X-OriginatorOrg: intel.com



On 2023/11/15 11:02, Lu Baolu wrote:
> No device driver registers fault handler to handle the reported
> unrecoveraable faults. Remove it to avoid dead code.

I noticed only ARM code is removed. So intel iommu driver does not have
code that tries to report unrecoveraable faults?

> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 46 ++++++---------------
>   1 file changed, 13 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 7445454c2af2..505400538a2e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1463,7 +1463,6 @@ arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
>   static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
>   {
>   	int ret;
> -	u32 reason;
>   	u32 perm = 0;
>   	struct arm_smmu_master *master;
>   	bool ssid_valid = evt[0] & EVTQ_0_SSV;
> @@ -1473,16 +1472,9 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
>   
>   	switch (FIELD_GET(EVTQ_0_ID, evt[0])) {
>   	case EVT_ID_TRANSLATION_FAULT:
> -		reason = IOMMU_FAULT_REASON_PTE_FETCH;
> -		break;
>   	case EVT_ID_ADDR_SIZE_FAULT:
> -		reason = IOMMU_FAULT_REASON_OOR_ADDRESS;
> -		break;
>   	case EVT_ID_ACCESS_FAULT:
> -		reason = IOMMU_FAULT_REASON_ACCESS;
> -		break;
>   	case EVT_ID_PERMISSION_FAULT:
> -		reason = IOMMU_FAULT_REASON_PERMISSION;
>   		break;
>   	default:
>   		return -EOPNOTSUPP;
> @@ -1492,6 +1484,9 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
>   	if (evt[1] & EVTQ_1_S2)
>   		return -EFAULT;
>   
> +	if (!(evt[1] & EVTQ_1_STALL))
> +		return -EOPNOTSUPP;
> +
>   	if (evt[1] & EVTQ_1_RnW)
>   		perm |= IOMMU_FAULT_PERM_READ;
>   	else
> @@ -1503,32 +1498,17 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
>   	if (evt[1] & EVTQ_1_PnU)
>   		perm |= IOMMU_FAULT_PERM_PRIV;
>   
> -	if (evt[1] & EVTQ_1_STALL) {
> -		flt->type = IOMMU_FAULT_PAGE_REQ;
> -		flt->prm = (struct iommu_fault_page_request) {
> -			.flags = IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE,
> -			.grpid = FIELD_GET(EVTQ_1_STAG, evt[1]),
> -			.perm = perm,
> -			.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]),
> -		};
> +	flt->type = IOMMU_FAULT_PAGE_REQ;
> +	flt->prm = (struct iommu_fault_page_request) {
> +		.flags = IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE,
> +		.grpid = FIELD_GET(EVTQ_1_STAG, evt[1]),
> +		.perm = perm,
> +		.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]),
> +	};
>   
> -		if (ssid_valid) {
> -			flt->prm.flags |= IOMMU_FAULT_PAGE_REQUEST_PASID_VALID;
> -			flt->prm.pasid = FIELD_GET(EVTQ_0_SSID, evt[0]);
> -		}
> -	} else {
> -		flt->type = IOMMU_FAULT_DMA_UNRECOV;
> -		flt->event = (struct iommu_fault_unrecoverable) {
> -			.reason = reason,
> -			.flags = IOMMU_FAULT_UNRECOV_ADDR_VALID,
> -			.perm = perm,
> -			.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]),
> -		};
> -
> -		if (ssid_valid) {
> -			flt->event.flags |= IOMMU_FAULT_UNRECOV_PASID_VALID;
> -			flt->event.pasid = FIELD_GET(EVTQ_0_SSID, evt[0]);
> -		}
> +	if (ssid_valid) {
> +		flt->prm.flags |= IOMMU_FAULT_PAGE_REQUEST_PASID_VALID;
> +		flt->prm.pasid = FIELD_GET(EVTQ_0_SSID, evt[0]);
>   	}
>   
>   	mutex_lock(&smmu->streams_mutex);

-- 
Regards,
Yi Liu

