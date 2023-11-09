Return-Path: <kvm+bounces-1308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 64B047E6510
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 09:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF95FB20C18
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC60107B4;
	Thu,  9 Nov 2023 08:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PM3ZUZmv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68E11078C
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 08:18:42 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875B92D4D;
	Thu,  9 Nov 2023 00:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699517922; x=1731053922;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4bE7723kT+Ic0niToUV8CRVVgRzqEoCk6VuuP38X3gs=;
  b=PM3ZUZmvMaizx9nM4n6gI09xIK2nnfTadsgnCUzE/4ps7cQ49l21yKZ+
   hbQxp8RFOTyCG4yrfWMBUVnSYcZgV0yB6CyhEPyiGlhMDnqFvVPN4+ayd
   5bdd/74C7f3VR5BLbICY7E1rSJWhUU9tM608MFFwJuARnVU6eQWwS/DoA
   mpTOrs/y/wuy22JSAK77TGQ3EK3XQcSVeRCDqAIy2sIAvS/QfNZkkQ1v5
   gf9D7lWn8kdQhSsvF8+YXjE97zJQd4zCKEwjVDkQGQQFGk46RtHJH1PMD
   zcZLSunXDS+VG7xjIRvk8Pzmm4G7AjKXh6GVUVjXrse3WzKF+ZSspg7SG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="388796925"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="388796925"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 00:18:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="4665315"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Nov 2023 00:18:42 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 9 Nov 2023 00:18:41 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 9 Nov 2023 00:18:41 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 9 Nov 2023 00:18:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azZl5D/LZS6iqa18BeSNwgM+RltP1Lb6DbYHw/Nj1xSk6VRLVjmlaR5gWJuYiKF9iN6YWySvLnm/q0LwFOqzFrcMZpj0dHy95fWsSch+l9f4hC0Q4yK75KB8Uw8EzxiX5fZbhVU7SKMm3CotmHM+J8vamqN7iQdMi232Hy6TyOk7atY47CjR9RqpbXrPlGh/h1Izf8ws9wbl+fXNHcBTPRWe6aaVv4i1gHbre/Q0hCRE1MoS1CTZdm5KGo25SOO9tRAdn5MumQvWlDNcEALa/txQckUfuFYkSMV++rYCQSD66jt950frgGQFbfRxYOLeGUpRD0OHUtt/ExMQbfma0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90bKbdScfIrq4BOUK55z9k29sd7x2RsOeE/+w/x4SGQ=;
 b=S6zTHb7gT+xRUwFGCu532Cir9s9aes7se0p15qqNbKSvGyoS5n9dmSyyofJQRrY57N52il2p0Hg6+yCe3SCICh44uYQK5v+BguBAuM7Nh7hDp597yZo1THIXZuleNkAE6NDBKxtOIGQdzE05iwSefZy4d5GsvdrI8/RvhdVBioKSmBTAhXhVwGdGmQXCZRxrSSd3oEYfkFUwi/VQ3W6U2xPnrch3u6HQq9hkw9CHNF5zlFA3X4SxqurObEhph6ouNOEi0Eg6/fNfQjFt95Lpfrp1M/epDchNulZlFEUpzypKztxJXS2FLqzsZH9zP91ooHWyCyQBvcEHn3/xkWCzEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7319.namprd11.prod.outlook.com (2603:10b6:208:425::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Thu, 9 Nov
 2023 08:18:38 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%4]) with mapi id 15.20.6954.024; Thu, 9 Nov 2023
 08:18:38 +0000
Message-ID: <3ce6d22c-0d52-45f9-b77c-5e7991fdd69a@intel.com>
Date: Thu, 9 Nov 2023 16:21:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/7] iommufd: Support attach/replace for SIOV virtual device
 {dev, pasid}
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
CC: "cohuck@redhat.com" <cohuck@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mjrosato@linux.ibm.com"
	<mjrosato@linux.ibm.com>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "yi.y.sun@linux.intel.com"
	<yi.y.sun@linux.intel.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "lulu@redhat.com" <lulu@redhat.com>,
	"suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Duan,
 Zhenzhong" <zhenzhong.duan@intel.com>, "Martins, Joao"
	<joao.m.martins@oracle.com>
References: <20231009085123.463179-1-yi.l.liu@intel.com>
 <20231009085123.463179-5-yi.l.liu@intel.com>
 <BN9PR11MB5276EE3482E71D50B3296FAC8CCDA@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276EE3482E71D50B3296FAC8CCDA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d67de69-c130-451f-c604-08dbe0fc79cc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PM0AgxLykyaTqgYLsL04ngDpHf/wifGVvwXUhE2gTI17snA0fHfBKyA+F5U7rpFaFbj7r1XeSap05VC9tUKl5ZkIUtXaXYigZBRUKbpQhoDCTpEQCfKsexEEHWn/xsWnvR0dYtKNr6B555hXJr1Okr3gk/RfZ8FHWDyXh7heGAQEOXXDbD/KTQvduJRuIN/mB1Kbj0GkI4q5VUcD8vaAhZDU31dMkEPNZe1slNrGIZEKSHrglcOhLD4QZ7zxO7monx2EUAHpUgNWlcLgHSJ14ltqH2lzcRqDngf9UfMxRQ8XGWPCTsfMCdmOqd4KbOWN/Wi0yUdvwp/hrIVSGrG0bw7EsqZ6oRPaWkFh8UOwq8t5m9cp/Xs3f/PYf7XOOeU4mLy7cufHZTJnjOmRSNOD+aUAkzrhwN0QnQleVtEBJezIT1HJfBo0TRa3TtzjttaqDNESNIL3oV5bud6IwvVvp/N8mQp/s4t0KLjEg1TuY/ns5cLeK/jlylM0gD2Iqd9BmlDz3s6EwjYyfYaO8tHBQ4n9vPzw1XFdFG8au0LBiaZ/Cw3owYToVxfYLl4q1eJAkrDhoWUsBFU03Pka97tlzaLVHlFCBJ0HCv0N9d8PtV3SbhjFeyLMOGG0PVnonqwpjQCnoCAhYn1AYDWxk2Dujw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(366004)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6506007)(53546011)(2616005)(41300700001)(26005)(6666004)(6512007)(8676002)(8936002)(4326008)(2906002)(7416002)(6486002)(5660300002)(316002)(110136005)(478600001)(66946007)(66476007)(66556008)(54906003)(36756003)(38100700002)(86362001)(82960400001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVhjMzB2anpzdGdwYlpDNmxYcERIeXNFK0ZmeGFkbi9nbkw5T09sYWFOL0c4?=
 =?utf-8?B?dmdodEk1Z3R3RW9KbDJ5b3oySlh5cmNwU2hZa3JHeERZaUhaZ3F4T1YvdGFh?=
 =?utf-8?B?dFpoaCs5ZVVEbFJYMERjRGVQYUhLR0I1VzBUMWlXcVpRZFZjUFlFNWhrbnVj?=
 =?utf-8?B?RUtCWHUrc3lHV1pFdVlmaEpTL0FWRXRIdWZ5d1Uxb1NXYmNNS3ltRHdod1NR?=
 =?utf-8?B?V2FhVk1Tb1VNbExaVVVPTVlMK29QSllLMWVXQlZ0QldpYndZWTQwQTVueDZK?=
 =?utf-8?B?RHVSQnNlT2FUZzh3c0g3VkwzbVlQYWRoa2l1Z3hOS0lkZmVLVUNUMGZFeVll?=
 =?utf-8?B?WkVZWmlzMzJzeTJpZWo0c3dPK3E2UlRib3lHWnAzd1BLbnVMakYyclNIbmFw?=
 =?utf-8?B?QkJESHpveFhQSDdETjNubU9TMlNGMkxRWnRCNlo2dXZUcVNIZjdNd3Rkd01N?=
 =?utf-8?B?Slpid2ExRkVNejNmb01DUzJzSitBWmlWZEFsSnpRQU1USkdyZyt0UUNpbTVY?=
 =?utf-8?B?SUdMa29vekl5djF2TkI5L3VCV0Znd3JqeWtnVDNFMmdHSmU0MzlGZE9CSUw0?=
 =?utf-8?B?YkE5K2NXLzFlMlFhZ1h0YmRUck9YTHJxdkZFeVRoNjU0N216cHpMRXBlMTB4?=
 =?utf-8?B?WHVDaHcrb1B1cUllYjFQdU9YY3d6aGtVKzFya3BReXk3UGpWV2RQdmRZY0xR?=
 =?utf-8?B?NGNLSnpWTi9Hcjd2M1VKTFdBd00venZhVGxFeGtRMkUrMVdSZm9ZRVVCb1dB?=
 =?utf-8?B?R1dPOFFRMHVkcVlUSlB3SXlCNTNzLzVLa0Fnenh5Z1lqd0hqZEpSdjZNaEVO?=
 =?utf-8?B?RmFXQ0VxbHZrMWp1RUdGeHZyV2MwL01FeWJxMFVoclUwTVl5N0U5YmRLVCtW?=
 =?utf-8?B?UFdqU3NSUXNVelVwLzVva2tSZHkxeFVOYjR0SjJKQktHTVFzYmwwM1RnNjll?=
 =?utf-8?B?VHVwNTlnNmR4cWhaSGFuNEdDclI4NWVwSHU1TUFnQWU4azhTMURMVUFrZkF2?=
 =?utf-8?B?QkJKZG9tV3hvQnlzbFk0a25GMEowQlo0ZDFSWTVMdVBCTm5VSFlMMzBWMXNx?=
 =?utf-8?B?UFhucUZKUkx4YnlIM3dheUVtUFI4ZXpCOWVrb1p4Zi9Qczd4OGFreG9WbXU2?=
 =?utf-8?B?QkF0czNrblllN3NFd0dVNmp0WFF6MTlsVHVIeXNYTVpSMFg0Zy9GMk1DbXpB?=
 =?utf-8?B?cGRzR0lTTW9kdEZBQnZjQWdvaVJwQlhFTTNkSWlBNkQ5RG9RTWFaWVhMbW5w?=
 =?utf-8?B?dTJ6UlQ0U05ySUNjZE8zK0MyeGhFVll3enp1M3pWQVh1MzVwbWlFdlFnV2Nj?=
 =?utf-8?B?OG1xOXNSS1RtOUhIazZ3a0VuZGVpMEFFUXhwSC9XZkdZcmxsMjJFb1I0Rmkz?=
 =?utf-8?B?Nzd2KzVjZGdMc0N3SUlVQ0FtSU4zV2ltd1ZBYm44MmRLN09WS0RFZGJwNjI5?=
 =?utf-8?B?MEhZdk4xc1J1TmZlNkladHVNRHV4c1ExV1FjYWVFZmxVb0lYdERDa2Z6a0dU?=
 =?utf-8?B?Tlp3cHg3cVdzUWNYVDdkYjI3bE15Vm5VMVlOcTE4SzEyRjZLOVZyekh3cXB0?=
 =?utf-8?B?eGdtaEpvZmNURy9hSXlIWElZUU8yajdKVUJmQUVxVE9IMys4d0hncXhZY3Ni?=
 =?utf-8?B?aUdsYVgxUWY2UHhOb0F6ZnphdmNmK1Rsc1hUWkdmWkRtdUNKWmo3QnpKWU5I?=
 =?utf-8?B?S2k0WmZqWmxaSFpMaHllTy8yTDVaT2xFbEhRR2pwcWJxT0hPZ0k5b1hlNUN1?=
 =?utf-8?B?Smhkd2dxKzRrNStvdG02QW04T1hlRksvMVlaYnkvWmxISzlpV3pFeGdtZTVh?=
 =?utf-8?B?Y1FmOVFnZFVnbmFva1huaDhzSmw4RlpUeE9Lb1pyVEVabEFqbThkT1ZhV1kz?=
 =?utf-8?B?SFZYSzYxazFlc3dNZWU4a0l3ZU42aGs1VzNIckFRLzdnbzkxUjZMVnJFNmdi?=
 =?utf-8?B?R1ZDSzVEZmZ1VGN6djdybitFaG9tajFsaTdQZzVObkl4a0VEZDdWajRrYlZ3?=
 =?utf-8?B?V2pTbk9qckQ0YmYwSkhpdW96OHJrVUlrc3RibW5kbVpGYjMwck9HRVhzcW9U?=
 =?utf-8?B?T1BNTExxYzRWNit5UjI3OUY2SENkWjkyQWlYNUNKRHhwaHhYeFpWdWhlSHJD?=
 =?utf-8?Q?1XbkBUzIsDxD4rKpaq+QsRyr4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d67de69-c130-451f-c604-08dbe0fc79cc
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2023 08:18:38.6321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qJV8RP0/qd/WDgNqoTDmRTz6I9uLL2Rl65n/6tehaJ9wmrl56xagxb1zddf89mneuX+pxxDnUPKOqVYCABjdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7319
X-OriginatorOrg: intel.com

On 2023/10/10 16:24, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, October 9, 2023 4:51 PM
>>
>> From: Kevin Tian <kevin.tian@intel.com>
>>
>> SIOV devices allows driver to tag different PASIDs for the virtual devices
>> within it. Such driver should call iommufd_device_bind_pasid() to connect
>> the pasid of the device to iommufd, and then driver is able to attach the
>> virtual device to IOAS/HWPT with the iommufd_device_attach() API.
>>
>> Unlike physical devices, for SIOV virtual devices, iommufd_device_attach()
>> eventually uses the idev->default_pasid when the virtual device is attached
> 
> s/default_pasid/rid_pasid/? or just call it idev->pasid. 'default' adds slight
> confusion instead...

then let's use rid_pasid as it is used as vRID for virtual device.

>> to an IOAS/HWPT. Also, there is no need to do immediate_attach per iommu
>> domain allocation in the attach/replace path if any iommu domain allocation
>> happens since the attach/replace is eventually pasid attach/replace.
> 
> immediate_attach rationale belongs to earlier pasid attach series when
> iommufd_device_pasid_attach() was introduced. Not here.
> 

sure, will drop it.

-- 
Regards,
Yi Liu

