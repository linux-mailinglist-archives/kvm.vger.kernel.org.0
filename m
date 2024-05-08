Return-Path: <kvm+bounces-16967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 716A28BF5E9
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A584AB245F1
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738531863E;
	Wed,  8 May 2024 06:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="moanViGr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B0D17C72
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 06:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715148398; cv=fail; b=gD4gFA7O45FEYyRRd/HEdMr4g+f+04qCwMNIqVsURlv6AOgC+MR7MfQnZs2R23jgfWP3YuuY7ASDh7yWNNh1JKKiq1LqVCkiNylWTDJSnGxu9Gym0dP+STCVGWvU2x737K5KEWG+Y3b15a/bjYoU4cDDiUyCx7rYObH5U3yPZ38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715148398; c=relaxed/simple;
	bh=Nlvfi60soOIaH+PbCz/wfvJL2Hi3kddgk4GXodfgzEY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kGuRL8nmIVDjgSCyjsWaqnu3A1MVN030eq3glgI6spZzRQO/mYg2TgLOP8iqtcZziV9O6tOawYW6Kfdk83RQHwyLHkWFzmgKz657TKMuEBlFaXNMwWbR89Ls1x5oAznjdSSbY4sCERJDetYPwi/Z+BgLERlEHI1dlWfUMMmFZIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=moanViGr; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715148397; x=1746684397;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nlvfi60soOIaH+PbCz/wfvJL2Hi3kddgk4GXodfgzEY=;
  b=moanViGreVz34DjZyJ3QXGo9dZXzxWOQsQ9YEWuqm7LN6HTZ7YgGpNWW
   6N3PhL3bTnse2Mtliwov2gJ4z2F/VRwaSa09Do2nwx5n5KhV8LrpvXKUg
   EKMtmAfi+CHOjrhmmCLTI/FuvaFgFuooq6OhiBehdhmRW7goIcRRJKCLW
   cA4XJFsv73awhZAQ4oeO2RxIp7ty6OpO5xbuCJCQoSj+/YaR5o/5E1BuJ
   Uej+2X6WhbJTU9qLIfm6iSNlHMQMa0VN2OXAZG0Llf0UEQg+TLNVtqGFR
   eo/ROC05kNvlk05XQemRE5CU/cfeuYhtMNnjCTl8vSA6cw9ib6efn3gfR
   g==;
X-CSE-ConnectionGUID: JS8rH5VDRnSUnDByNHVpoQ==
X-CSE-MsgGUID: O8x7r65iTY+LJ2EwPgyZjw==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="10855709"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="10855709"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 23:06:36 -0700
X-CSE-ConnectionGUID: P7WK8YpNRXy/rEarC2MINQ==
X-CSE-MsgGUID: U48k3OffQUyMZ7j22IMTHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="33326476"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 23:06:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 23:06:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 23:06:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 23:06:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 23:06:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kr/R1Odulb0CuLlUJdJA24RorrUXGLn+EOYQD5bwnxH9B/1HsoPiEAPktfPlzc7uzSlKwETRIIS0Wx0irfY/HiMtCKPxa25mnhFP0g+OpL1tPYdI55H9CKON1rIBB4CG9WLTWXGSPOEFx3yNSYU6IlTThfGuxM/2gJueZMIWypfi2NvjMCuBAEFvQpnzuRV1AHj4viaZZtnCKVW+Z4Bur4AB11tgb0/LRXFzAIatt6CsfhYizx007FzVwCU/gpHzTVtgecg8pN6nxON3IRcd4SAkZfWZ0IzQ3owV0VAgicXsxiphw/4LPcYkHoHp8M9mdNdXJHNfmjxFcDDkBmaGQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEhim3ZW5URjmB42EBsQXlxDoTJDaznopU0PgH1KiLg=;
 b=UJ2atwwFxFmOW26CBj//e397kH18YCQ4+ao4sSKwjzx2VsiyfWBej08UJdTj1ivCSHLuxF6/pC9nzbQXHj7yfR4xvr+ymZelykPloEsSnCoBfccBjN73MQy0KPDoomp5PvMPtpUABqvuI++xZO4DuRejF+hF1wC36bpRuWDPjmegSebVCCWTjKV0JFsyIiKNq40FKROObFxyFG2Fp/GSfK5oVIBqto4n5dVsWJm3qxqBCAsp+TrkwvOhMmFCx0Mk/fIUetG6z5OxFfJIAoUR8+ab1sCaXEuItWSnpII4HgHDXqYtGAYw3hY2vkMkfNbq1xejupwmagJWvkljEJBSlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6017.namprd11.prod.outlook.com (2603:10b6:8:5c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Wed, 8 May
 2024 06:06:32 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 06:06:31 +0000
Message-ID: <07e0547d-1ece-4848-8e59-393013b75da8@intel.com>
Date: Wed, 8 May 2024 14:10:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Baolu Lu <baolu.lu@linux.intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
 <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
 <20240506133635.GJ3341011@nvidia.com>
 <14a7b83e-0e5b-4518-a5d5-5f4d48aa6f2b@intel.com>
 <20240507151847.GQ3341011@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240507151847.GQ3341011@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::36)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM4PR11MB6017:EE_
X-MS-Office365-Filtering-Correlation-Id: 6335f309-95a2-48f4-84fc-08dc6f2501c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NCt6TW9DaFkrWExkRldQc2ZuS0FOOTd3cXdIbHR3NzFkTE9SM2h5UFY3L2pD?=
 =?utf-8?B?QW9waThMT2l6amRIdkc4YllqQVhUYUgyRzVTUVlpUnRmNjdYZmU2UXdabDB0?=
 =?utf-8?B?MjloWWNNUXR0ZjhxdGJoOU5FdStmTG9jRGgzcUR1bGZRbHdieXQyVzVBUnNx?=
 =?utf-8?B?OWlqM3ZnK081KzlWNlg1UXZTRDN1TUxEUVRTSkVLZC9uZHRJbjhoTVlnWTJE?=
 =?utf-8?B?eSsrVDNFaUE5aHdoTzdlZHhvU1NaUVVnOE5kY2xWV2FVSVdla2Exck5UYksx?=
 =?utf-8?B?VHBkYUhKRy9SdGUydDFkTFRodkFIcSszV3pmeGhUOEh1NVlwWTQxZTFNVkdE?=
 =?utf-8?B?Qnl3MjcwdExSS2M1T1BxUmtqVXNzdDdyd2Q5SDZaQi9yZkFrZTVWc1BCaHdY?=
 =?utf-8?B?OFRLRU95RjdkSjRoaisvUFVTd2IwQkZiWitxTFVFMEo4ek5KL3Y3VUFGZ1ZO?=
 =?utf-8?B?c3JJbjJGNnFpTHE4ZEJFOWFObFFZM0xRc0RxZm1wTUROUlhXL2tjclI3dU1t?=
 =?utf-8?B?VnJYYkhZaGpUcDBZRHZ1NnJFVXVlY3kwMmNvUnJhV3owUUR2ZHlYSjR6SWJ3?=
 =?utf-8?B?VXRKNFV0SCtxQXhlbGdrWVFVOFlSVWRCcnpPRGpBZHdzdXpEdnhuZ2Zxdm15?=
 =?utf-8?B?LzZtaEoxNS9CRU9Qd1l5YURyL3M1TXQ1VEJKcGFWRExMbFNjbUo3Vk4rMHRh?=
 =?utf-8?B?Y1pUZ3dmUUo0YURBUFlvdUFWUCtyM1lQN3J5RGROcFcrUllEaDlKT2grckE4?=
 =?utf-8?B?QmRnN29XRUhMNUUzRC9ZMXZXL1J0eWpuWWtOZ0FLV1Q3YUpOQ1hHeXF0QTd2?=
 =?utf-8?B?aGNBQ2xrTmJQR241Qmw4eXhqWTIxSmZ2ZFVaSHZkTUxYRXlTR3drQncxRXJ5?=
 =?utf-8?B?QWhIdVVUdHFtcGxtQytJTDJnUkVmemhVSmZhY3JGblN2eEtHYXhVV3J4ZndR?=
 =?utf-8?B?dnI2bVVobWt4dGZ3eUdvRXBtT2xKT2tBZ3ZMcStwcEU2NS9tdVlSY1RFUWZB?=
 =?utf-8?B?NitIVGJ6eHFQU2xQcUhSUGdOdDBCY2w4emYya0J2SUVSRVRkSTllQ3l2dWQ1?=
 =?utf-8?B?MVI5S0l3QTFkRGx3cUZrTTBQQUlGdHBwcGYrZHNIclFhcVdZQ2M2cTdsb0ZZ?=
 =?utf-8?B?RjZrUDRmbjZIZjVNdkJsTEtDMk1kMGdBZjdFcXVrU3BicGwrWU9lbUJzVWhH?=
 =?utf-8?B?YzJUclBpOXQyT3FQSGZHUjB5MWdLK1p4UGdWZnVwcDZuYmMvdW04K1VQcVZp?=
 =?utf-8?B?K01PUW5NWWtNdmhRUkZVWjhEVFg4dUVOV0RZR0FaUkVMOVNxUmd3VFdsS3NL?=
 =?utf-8?B?bFF1dVhqN1BwVGdYYjFLRUpzZWJJTURkNERyMmp4a2dJb0t4OUxPMmY4dzV2?=
 =?utf-8?B?bVVQU1pzRWp3L0plMDBrYno3eDU1TGhVWXRqS0Jqb1RlVUR6ZVZCZktTcGl0?=
 =?utf-8?B?ZGZkSHdsNkFoekNJS1NDMkFYQVFQRHRwL3RodndqQ1grQldBRVBCOVo1L0VQ?=
 =?utf-8?B?dWY2aWtmTFhQa0NiWmlXK1RxRG8yTDhEd29sRDNZM3dBWE9uNVpxbWdXVG10?=
 =?utf-8?B?ZFhMOHhFcnNrNlpQSzZMeGlhMjJ4VVg3Ry9NeTQxcVFRZzlpSU90bWs3RjJh?=
 =?utf-8?B?QTEyQ2MxeFJZK0RYSmtMbDVNMHVpWkNiL1E2TG9pUWNwZlplbnIzTjhTbGZa?=
 =?utf-8?B?K1J0emtxcmZsMEkxRTU3V3hjR0hTUHRHcGttMkprclM4SVpqSWJsNHpRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUN3QjExQS9MZk5LSTlhQVUxUEJQVzduSVhOL0doc3RoTm1Pb011UnpldkNL?=
 =?utf-8?B?NGZYUkJiTkFDdm1QYzEwQ21zT3FSK1B3eFpzTkM5MEF2dnd4M2NNN09Bdk12?=
 =?utf-8?B?bSsrQlJUbVpYajhDQVlzbmZJZUg2OW9jc2ExaWhEUXc3MXNoNmlxSEFmc0ZN?=
 =?utf-8?B?ZmlHcDNKOURJODB5Zm4rL05PdFFRVUQvWUpNTkcwT3FadWsxcjcxZGVVNDlp?=
 =?utf-8?B?dGlUS0RYbmgzbDlISVZyUWd4SmJKQkJ6TU9CbVFiekRrVFNzeEp0R3Z5Zk5v?=
 =?utf-8?B?OWNLSGkxSmZ5SFpadmRSOXlXSUtKY05WQitKMUtUNmFPVDAyb05rWkpqb1VE?=
 =?utf-8?B?TkhLcnZ6ZUtLUWMzNmxaTTR1aVIvMGNMRHRSdVhsUlNtdnVaYVdkTUUyZzBD?=
 =?utf-8?B?MTRDUFhCOEZYYkphOWI4Y2F5dnF6NTNqRmcxR0ZnbUpsMm9JcXNMUnJLZkhL?=
 =?utf-8?B?MWlLT0NDSzNacExXY0Z0Z1U5RWNtYUh6QjhXdURwYngyTWhTZzl5NGtNU2pp?=
 =?utf-8?B?MC82QkFuTnJxd2E2RGdFbHB6Y0lTekpjR05QaGxnUzJEM1pyZjJQcTAyT3Ix?=
 =?utf-8?B?RllKZm5jSzhxRmZnaXVweDlYdlRkK0FKUjJQZmM0a1dobng5c253aTFNNG0y?=
 =?utf-8?B?NWpaMFM1aXpYOXBjNSs0eWtZYi8xM0RHMURuRHNvbUxMeXIvU3ZpUjVKQnhL?=
 =?utf-8?B?ZGFiTlVpQU5XbjByRmxMT2FVOUpSVWgrLy9JN0RaQzJPbGVwM21MY2hWcGE1?=
 =?utf-8?B?RFhOS1lUL2lHZnExbEppMFN5Z0RtMFhQcGdRUk51L1FNcmFMSlFXUjhEbm1D?=
 =?utf-8?B?Zk05WWRQc0szdGxONWVIV1pVYi9NSjFVVitQc09GekRrc081R3JFUGhwdUpx?=
 =?utf-8?B?SW45WTZxSnNWMlIyOTlpa25HcndCWXdEYXkyYWtLN3h4eGtSMUdnTEhMU29R?=
 =?utf-8?B?ZE9ONmJZUGJMNjNrQmF4M2dIUkxVeE5Ma0xkeWhYdlZRcUZjQjZUY2dRUFdW?=
 =?utf-8?B?Wnk1SlNEaUg5NDJlZ3NjWEdCN09TUng3c2tWNWRSRlhnUHhLQXU0OGtOamhz?=
 =?utf-8?B?MG8vdFFxQ3FuVGFISzRlNStnRWdQcEFFVHg1UnB2ZG1Nd0VRaWE4M21sWkls?=
 =?utf-8?B?Y3B5a1Y3OE81L3NFR0lpQnZaa2FNbHpLUVUrWm9CTTlCWHdLVDlkdVJESDBN?=
 =?utf-8?B?LzNHY1dpSFdzd213cHJpcXBFU3BkQXBZVVNEQ1pjQ2hodzRpRHNnN2dJR0Vl?=
 =?utf-8?B?VEFCWXRoTmlqNnI4Rm90R1N0QUVBeDdyRW9qQzZFL1V1MWlyNlhVOEZVaEYy?=
 =?utf-8?B?RFYyNVlqR1hrYWJ0N0VxNVdjWnFVMjV4d2VFeGI0K0tGNjd1bjEzcFp4OXE2?=
 =?utf-8?B?ZDZRM3NYMDRSd0U0MmwvemVGMlpUaUJBTUp3R1czY0VFSm45dC9sYnF6U0o1?=
 =?utf-8?B?U1lVMFBTTDdxZjlKR3RFdlJvYURjM3JqSW01eDUvZXJjVnMrbjFTUjJUbEs2?=
 =?utf-8?B?SG82Z0VGYi8rM0R0N3Ezdmt5cnROUWk5MFBVdmoxK3paWGdpbjN1Z1pmYmNH?=
 =?utf-8?B?R0x5azJqYWI5a05nQ283WDdxaGlHQmRzSlYzbGwvSWZTTFpZMUcveithS1hM?=
 =?utf-8?B?aUpyQXYvbFdPenZtUXFtOEw2a1I5aUdMb0FBRFdyUmxiZXpUcy9Ecko1a0dW?=
 =?utf-8?B?ekZIbWZyN1p3bjhlRytQWVg2dTZ5dWFCS0ZkbjU4Y081Z3BUTVJ0cC9NT0tv?=
 =?utf-8?B?TzdIU0tOQkhWU0xaRzlWZlZKVUc2MDlRT3BnWDFxSlBPRDYxaFEwZG4xZ1BG?=
 =?utf-8?B?L29NN0hPZTVCVkFwSmlzc3M3VDVnUEhSWXY1TWQ1bU1aMTBqUDdWMVhobzdL?=
 =?utf-8?B?OTN1YkxGUXZEVVhoUWJlMldxejFqNUlVOXhCRWRvZGhhOEE0V2pHTHZkWWVJ?=
 =?utf-8?B?T0Z1QWdzOU5paFRSWk10cG1XazZwK0tOcFBsZHR2OXByNGhsMTFybitlT04x?=
 =?utf-8?B?S3NIdEFNaUQvajA0RHh3ai9lem9SbnJFQVdndkJwTVBHUTRscS9oc053dktW?=
 =?utf-8?B?Zkk0TmtzOFQwVTFZN00ya1o3VS80SzNnRnRzbmJBUGFpbm5TdDJXMU80SGlC?=
 =?utf-8?Q?XMAk8/jKvRT+Nwik+zyZy3GzC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6335f309-95a2-48f4-84fc-08dc6f2501c2
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 06:06:31.6983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KksN30ZJEzcMUxjokFk1H1o/w5Thr9zUkQcnz+r2QX/4jo6g7p897cyDaGM8Exr9frbPCcnuyd63USEKA/oeRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6017
X-OriginatorOrg: intel.com

On 2024/5/7 23:18, Jason Gunthorpe wrote:
> On Tue, May 07, 2024 at 10:28:34AM +0800, Yi Liu wrote:
>>>> We still need something to do before we can safely remove this check.
>>>> All the domain allocation interfaces should eventually have the device
>>>> pointer as the input, and all domain attributions could be initialized
>>>> during domain allocation. In the attach paths, it should return -EINVAL
>>>> directly if the domain is not compatible with the iommu for the device.
>>>
>>> Yes, and this is already true for PASID.
>>
>> I'm not quite get why it is already true for PASID. I think Baolu's remark
>> is general to domains attached to either RID or PASID.
>>
>>> I feel we could reasonably insist that domanis used with PASID are
>>> allocated with a non-NULL dev.
>>
>> Any special reason for this disclaim?
> 
> If it makes the driver easier, why not?

yep.

> PASID is special since PASID is barely used, we could insist that
> new PASID users also use the new domian_alloc API.

Ok. I have one doubt on how to make it in iommufd core. Shall the iommufd
core call ops->domain_alloc_paging() directly or still call
ops->domain_alloc_user() while ops->domain_alloc_user() flows into the
paging domain allocation with non-null dev?

> 
>> I agree implementing alloc_domain_paging() is the final solution to avoid
>> such dynamic modifications to domain's caps. If it's really needed for
>> PASID series now, I can add it in next version. :)
> 
> Well, if it is needed. If you can do this some other way that is
> reasonable then sure

At first, I'd like to keep this agaw check here and remove it after
implementing the ops->domain_alloc_paging() and retire domain_alloc op
in intel iommu driver side. I have such thoughts as the RID and PASID
attach path have the same concern w.r.t. agaw and other caps :)

-- 
Regards,
Yi Liu

