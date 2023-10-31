Return-Path: <kvm+bounces-158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DBD97DC7FB
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF17EB20FD2
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD4B111AE;
	Tue, 31 Oct 2023 08:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T10/ns1C"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D22D27A
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:15:25 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6581FC
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 01:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698740123; x=1730276123;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QHZKEIED0y0inVmgwncvQ1a+zGOs+VT+rEXHIXhfm1k=;
  b=T10/ns1Czuz/DzRXiZ0Ny7WOixmXbAkVaipXergqK9SDs1VL1L2lYsgF
   U33IHu5vQwQIJToPuTxlRnYvgbC0eNML8H2GozNdggvzei/TNwc05A7Zt
   33l3BeGakHdE9Qvpk0MRxDNK5ZyQ9qGqp0NRTvBQhJAITb4fGUyKhKwsz
   FjHg665ohDcEaozZjLosyazgimYtnHfyjR5mQTT6YaG4fuNvHBYYyBuGF
   CMeHdGxaXevx0OmmH1qa6mRmT8FAZrWuKB6W2qxFcYFeyylVrAOn6EtOP
   hvj9GvMaAzJZekP3RVtj2xVCNyCUyNDfDmINNKx40SpWJ8cJ1MLYTujGc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="1083887"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="1083887"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 01:15:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="710349454"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="710349454"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 01:15:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 01:15:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 01:15:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 01:15:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SytiLh95yh+nJaPesZcVEGb1Hitkw01FY6aLFIbnMff6LQ66xmQljwZFRsPeSfJjHfIV+P2ly88ajsTtSHRiu11MrIxI7LdukAz7Ed8igohZKEhQqwVS/bM2IQQmawZYl8s+FFgARKptL4SMB/abJguW4D24ZrAnhpg+tNOSad3kRv2VPHMlFXT9lCF9qOzcys4ijvCQezg4q2WgShQ8Nae4eQtc8ZT/CfbESkbPQtbj8b/cg/54S+rWGu+LGE77Eww44vSd8fDUBdU8u6VRekeezw6y1wKmdVUk2hSxK0p2iD9YZ/PLgBAXY+CfAKOU0kMtOwDbT6U9QlCh+ZwlOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdguIpY+6KW+KvIIICHQPBCH3ke5G4JTiuKQZUkILIM=;
 b=a9EoU7UtyXG2plVaRd3vZQ847xtQp6B6WvZTTtq/NylecqJJEI7vjDEqQcxRNGC/npL7YPcvQersE9JuFNYi9RooZY73oS9Sb25dfwcZlRl7wNLiLwXCRus7XSkFLQu1ZQnijWwaNWvcFEbxSXK5JE+ViPDeuLhTH7B8vmL3U5C/9WFei3HSBzt1j4pC0LShuU2COBjfVllvz/MX2UkTjxaoKeQy434P0p6idpYhh6NbuQZ3ITY0owQ2TNbTgz6CZ9lHuJ84CKUGU+gbqvvpzEqQSYk61JeBNde7Vr1f25+xImGuxKAfpRm9F2i8MRyjmn3DOtaV0jVs3c57awsL2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Tue, 31 Oct
 2023 08:15:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%4]) with mapi id 15.20.6933.024; Tue, 31 Oct 2023
 08:15:16 +0000
Message-ID: <4a5ab8d6-1138-4f4f-bb61-9ec0309d46e6@intel.com>
Date: Tue, 31 Oct 2023 16:17:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To: Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
	<mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-10-yishaih@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231029155952.67686-10-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::36) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MN0PR11MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: ce6f91a4-349b-4ba9-641c-08dbd9e98371
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mt3jRs89nlbZmU7oa8RiVVBjVv2RayIkK3WPfHyNKkpapcllkKDyAKuZU0sgusQ572Nq+6DkzIjlm+5ShQTlA0oK17O4K67Z1RBcHStYO+/Prc9G4O3ae2Yk0OZffHFgoMKc9Par/eN1L62HzC7YsDYzZhnREtyGFVu8Y9Bs7/KZ2L5+9wUjg6tIJuR6vkOaMkaBzeAefgiqe/UhYd4enXiFMR5qlAdqj2To3W4SVnb6sbobjA3njM4C2SjbOEaYVvaUlkiokL1NoQI+Wz5++DfJ/1pWTUMROh4FaAJgnanw0a878sU1gEr2fPKHmr3JmAb5Clea+jRhcAHCWjb0ax+SkJgtvxWb9owkffbdpu9iZn2fqch39zv8WS7YF0J4gJM5wgbHatBKU+E6/HS5lWipTXSk4VqcX6d9mhx77lNezDUgnKfg7V7n+tBRwrAxuC5Vlco0oZbtwi7H4eBmfvVuZR30NESkDfyOKtttybTNVLWEQeHyM85GYT8TfA5oQ4b82hY0/biNKQ6pTN78ksFETeDia/jNC3y7CjIuipwejmbvVaDZiQc6GwX3E75Xodkt7TPo23yh6gcKp5Pm1WzxITyFNSVjtwjp4KUAYvOqiPbCfKKq3JX47vA0d2i9lAwEYEea2K9fRWmZf6dCZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(376002)(396003)(136003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(31686004)(66556008)(41300700001)(5660300002)(66476007)(66946007)(316002)(8676002)(4326008)(8936002)(7416002)(30864003)(82960400001)(83380400001)(478600001)(2906002)(6486002)(31696002)(26005)(36756003)(53546011)(6506007)(6512007)(86362001)(2616005)(966005)(38100700002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUxVaUxnVjEyMlcwUGY2Q3cwN0hwbU8zZUpjNzA0RmNkc2sxd0pTaEFCVjZT?=
 =?utf-8?B?cmlUSitzN3p2ZEVDam81Q0wySjN3UVlzUmZEYWNxUDgzZzRxV1RDNnRQd1I5?=
 =?utf-8?B?cVgwaUVWYVFIRHY3MEZObU9kaDFGcUpKMkhXOW9kMkJUSG8vWEJjRnBzdU8v?=
 =?utf-8?B?dVJaS0thalp3dHZBZFpJN1FtY1RIN3BpMk1zdXNTSkxTenk4UVRCUWN4TTVw?=
 =?utf-8?B?L2hoczBnZzNVNHV1OVFhdGZvZ2hDRXE4dmcxTEZ4dnE0dTJvSzV5dmVBUXdX?=
 =?utf-8?B?a0dJZEVUdkl3bEN5aWovWmVTdE95MGUyMlhOelFWQjNrbi9sQWk3bzMvVERv?=
 =?utf-8?B?SVBZWmg2c2RHc0FzUGNtT09sNEFCY2lBUGcvcjJvamRCMmpocXJBUEE3NnJx?=
 =?utf-8?B?NWNzUVVxRllUWUVwZnFPdDVVK1hyNW91RDZQMHBPdWdaekdPZ2l1KzhpaFdv?=
 =?utf-8?B?M2Fmb2FQRytiaEcrWjlKd29Ud1YzSmVJNUVuTk9ZTXp5RmhVanphd3Yrc0N0?=
 =?utf-8?B?Vm00MVpUSnE3UUwva2FCUXlGbG1ZTVpXbGg5UVhCb0xPRXlVNXlkVVN1TFJV?=
 =?utf-8?B?Z094UjNKMittZkRnSXQrcDU0QmhrUXFBOEIzcnAwR0xUZHhRL1VXelpueEV4?=
 =?utf-8?B?TjlQOXZZWXo0WDExT3p3dFR0Nmg1WXM4UG9nd1BaTHUySlBUdXFWSlF4cG40?=
 =?utf-8?B?cllKc0lwdUQ2N2V4MjRCa25PbEVwOEhTTnRNWnlOVTFMTEpnWEwzYWpiZFJJ?=
 =?utf-8?B?cUlYWlFKSHVOM1V0R1RWb0hGcU1LNzE0cStEamxOVk1aNkxXUGhaMVZYQ3dK?=
 =?utf-8?B?eXg1ejhweFdENmdXK3JyOGYvbXk4OTRIUWhaTnYzclVoYnJudm5zaXg3RmQv?=
 =?utf-8?B?OEtMeGc3Y29qRFMybE9FdGpkQWZCY2dYbFRVWENraXJBNFhZRXRWQkVKSnBD?=
 =?utf-8?B?dkI1V09hQ1R6NC9yNVNERlRsQTVaeHBPZlZvSFlQQU0zVEZwcmFKMXNWTkkr?=
 =?utf-8?B?azhrcW1ZUFVoQ1N5akhVQkVmeEt3VGY0N0VSckU3VHUrMnVBZ09IbjhXUmVt?=
 =?utf-8?B?OXZEa01DcjRNK1RkYkVkOG9WQmhTVEFCcVpDbnBWYWhpZmVRZGcrYVZoRUVT?=
 =?utf-8?B?TkJIM0h2TUlYK3JKUmVlalFQZlVpZXlNTkVwUGFaV0QxTWxOVU1jTHVxSWdY?=
 =?utf-8?B?a1RHSlFhQkpjNHdhSE1LMUF4Ky9QcTFVUlN2WFc1ME9jQmFSY0l0ZEJYYm1h?=
 =?utf-8?B?aVJtenpIVWZkN2UwNTRPUFdrRW9kMnNrbFJvWFFzZ1M3dWVrZnExUmNRT29Q?=
 =?utf-8?B?ZzQxNVkwTXY1b1pNd3FYQ0Y0V3VTRGVldUFIeENtb0YzRjUxc1RPclVYNDVl?=
 =?utf-8?B?c3NyWmVURTdmMmcwV3hZWEF4VWIxSGwwRGM4TERjTWFJZzRla1h6dkJtTTll?=
 =?utf-8?B?QysramdZZzl0bUFvTXFtVlBNaisyRDFYd2pQOVdnY0xYd3JNS3dURWc3ZWlH?=
 =?utf-8?B?cS90Z0ZIVWZOZU0vZmJ6VVREbGlLZTEzRW9qbmRWR2lmR01MZU1yekFGU0hY?=
 =?utf-8?B?TUVTZ2dCdWsvcWdkR0ZSVHp6K05Fbi9FUWVOL1d2N0xKbDBWK3JNbjZMYXNG?=
 =?utf-8?B?c21VMTFFdUsyblkvRXo3RU9wWDVZbllSZm1UbnRkRkkvUDAvOTdaaG0zT0Vk?=
 =?utf-8?B?cytRQVJVRHhXN1NxY2ZPdmdRUWN0a0dOL1Zpd3NyRHNiY0wvRVZWMll6YXM3?=
 =?utf-8?B?aU1vMUdWOW9pVjBqZWRvVTlsTGl5c01palJwTG1MdDYzbkRQaFBLSDdpRTZh?=
 =?utf-8?B?ci85T0Rka2FiaUZ0M2lJTDVOY1gyNVZ0b0VOS294S050azR3L1I4WEhNM2NR?=
 =?utf-8?B?aGowTC94d1FqaWxiU09VSVl1d2l4MlZLZ2hHQlBsK1NoL0dSN1FNQWpDbHcv?=
 =?utf-8?B?eDhDamhVTHQ1VEdiaThDeEJxbzI2RFplb215c0JMVmZ4R2cySDFCMHRrRk9q?=
 =?utf-8?B?QmVzOUt0R3l5Zi9mam9hNmE4KzlLbE5WSXp2c0FwV1VvSW95aSttNkNQQjN3?=
 =?utf-8?B?SmgyRlFTbkdvNVZYTWdJNUxZVFhjUlRKNkxZZ3ZHMFZZYjhnSWNVSFpLNWlk?=
 =?utf-8?Q?ygIRdHxWcqw5SLkpu/NKQB9Bq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6f91a4-349b-4ba9-641c-08dbd9e98371
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 08:15:16.2477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9snLzMV7H+vWmcNS2MQ7vMu1EN1SZy6ljqTHdpnZcuVmk2YDKO8WH2n9Ol1KtNwCDvjW38jh7YPCDco/ATSHkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6088
X-OriginatorOrg: intel.com

On 2023/10/29 23:59, Yishai Hadas wrote:
> Introduce a vfio driver over virtio devices to support the legacy
> interface functionality for VFs.
> 
> Background, from the virtio spec [1].
> --------------------------------------------------------------------
> In some systems, there is a need to support a virtio legacy driver with
> a device that does not directly support the legacy interface. In such
> scenarios, a group owner device can provide the legacy interface
> functionality for the group member devices. The driver of the owner
> device can then access the legacy interface of a member device on behalf
> of the legacy member device driver.
> 
> For example, with the SR-IOV group type, group members (VFs) can not
> present the legacy interface in an I/O BAR in BAR0 as expected by the
> legacy pci driver. If the legacy driver is running inside a virtual
> machine, the hypervisor executing the virtual machine can present a
> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
> legacy driver accesses to this I/O BAR and forwards them to the group
> owner device (PF) using group administration commands.
> --------------------------------------------------------------------

a dumb question. Is it common between all virtio devices that the legay
interface is in BAR0?

> 
> Specifically, this driver adds support for a virtio-net VF to be exposed
> as a transitional device to a guest driver and allows the legacy IO BAR
> functionality on top.
> 
> This allows a VM which uses a legacy virtio-net driver in the guest to
> work transparently over a VF which its driver in the host is that new
> driver.
> 
> The driver can be extended easily to support some other types of virtio
> devices (e.g virtio-blk), by adding in a few places the specific type
> properties as was done for virtio-net.
> 
> For now, only the virtio-net use case was tested and as such we introduce
> the support only for such a device.
> 
> Practically,
> Upon probing a VF for a virtio-net device, in case its PF supports
> legacy access over the virtio admin commands and the VF doesn't have BAR
> 0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
> transitional device with I/O BAR in BAR 0.
> 
> The existence of the simulated I/O bar is reported later on by
> overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
> exposes itself as a transitional device by overwriting some properties
> upon reading its config space.
> 
> Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
> guest may use it via read/write calls according to the virtio
> specification.
> 
> Any read/write towards the control parts of the BAR will be captured by
> the new driver and will be translated into admin commands towards the
> device.
> 
> Any data path read/write access (i.e. virtio driver notifications) will
> be forwarded to the physical BAR which its properties were supplied by
> the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
> probing/init flow.
> 
> With that code in place a legacy driver in the guest has the look and
> feel as if having a transitional device with legacy support for both its
> control and data path flows.
> 
> [1]
> https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>   MAINTAINERS                      |   7 +
>   drivers/vfio/pci/Kconfig         |   2 +
>   drivers/vfio/pci/Makefile        |   2 +
>   drivers/vfio/pci/virtio/Kconfig  |  16 +
>   drivers/vfio/pci/virtio/Makefile |   4 +
>   drivers/vfio/pci/virtio/main.c   | 551 +++++++++++++++++++++++++++++++
>   6 files changed, 582 insertions(+)
>   create mode 100644 drivers/vfio/pci/virtio/Kconfig
>   create mode 100644 drivers/vfio/pci/virtio/Makefile
>   create mode 100644 drivers/vfio/pci/virtio/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dd5de540ec0b..f59f84a6992d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22622,6 +22622,13 @@ L:	kvm@vger.kernel.org
>   S:	Maintained
>   F:	drivers/vfio/pci/mlx5/
>   
> +VFIO VIRTIO PCI DRIVER
> +M:	Yishai Hadas <yishaih@nvidia.com>
> +L:	kvm@vger.kernel.org
> +L:	virtualization@lists.linux-foundation.org
> +S:	Maintained
> +F:	drivers/vfio/pci/virtio
> +
>   VFIO PCI DEVICE SPECIFIC DRIVERS
>   R:	Jason Gunthorpe <jgg@nvidia.com>
>   R:	Yishai Hadas <yishaih@nvidia.com>
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 8125e5f37832..18c397df566d 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>   
>   source "drivers/vfio/pci/pds/Kconfig"
>   
> +source "drivers/vfio/pci/virtio/Kconfig"
> +
>   endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 45167be462d8..046139a4eca5 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>   obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>   
>   obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> +
> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
> new file mode 100644
> index 000000000000..3a6707639220
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/Kconfig
> @@ -0,0 +1,16 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config VIRTIO_VFIO_PCI
> +        tristate "VFIO support for VIRTIO NET PCI devices"
> +        depends on VIRTIO_PCI
> +        select VFIO_PCI_CORE
> +        help
> +          This provides support for exposing VIRTIO NET VF devices which support
> +          legacy IO access, using the VFIO framework that can work with a legacy
> +          virtio driver in the guest.
> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
> +          not indicate I/O Space.
> +          As of that this driver emulated I/O BAR in software to let a VF be
> +          seen as a transitional device in the guest and let it work with
> +          a legacy driver.
> +
> +          If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
> new file mode 100644
> index 000000000000..2039b39fb723
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
> +virtio-vfio-pci-y := main.o
> +
> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
> new file mode 100644
> index 000000000000..0f7d2f442f6c
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/main.c
> @@ -0,0 +1,551 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/pci.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/virtio_pci.h>
> +#include <linux/virtio_net.h>
> +#include <linux/virtio_pci_admin.h>
> +
> +struct virtiovf_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	u8 bar0_virtual_buf_size;
> +	u8 *bar0_virtual_buf;
> +	/* synchronize access to the virtual buf */
> +	struct mutex bar_mutex;
> +	void __iomem *notify_addr;
> +	u64 notify_offset;
> +	__le32 pci_base_addr_0;
> +	__le16 pci_cmd;
> +	u8 notify_bar;
> +};
> +
> +static int
> +virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
> +			     loff_t pos, char __user *buf,
> +			     size_t count, bool read)
> +{
> +	bool msix_enabled =
> +		(virtvdev->core_device.irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> +	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
> +	bool common;
> +	int ret;
> +
> +	common = pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled);
> +	mutex_lock(&virtvdev->bar_mutex);
> +	if (read) {
> +		if (common)
> +			ret = virtio_pci_admin_legacy_common_io_read(pdev, pos,
> +					count, bar0_buf + pos);
> +		else
> +			ret = virtio_pci_admin_legacy_device_io_read(pdev, pos,
> +					count, bar0_buf + pos);
> +		if (ret)
> +			goto out;
> +		if (copy_to_user(buf, bar0_buf + pos, count))
> +			ret = -EFAULT;
> +	} else {
> +		if (copy_from_user(bar0_buf + pos, buf, count)) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		if (common)
> +			ret = virtio_pci_admin_legacy_common_io_write(pdev, pos,
> +					count, bar0_buf + pos);
> +		else
> +			ret = virtio_pci_admin_legacy_device_io_write(pdev, pos,
> +					count, bar0_buf + pos);
> +	}
> +out:
> +	mutex_unlock(&virtvdev->bar_mutex);
> +	return ret;
> +}
> +
> +static int
> +translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
> +			    loff_t pos, char __user *buf,
> +			    size_t count, bool read)
> +{
> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
> +	u16 queue_notify;
> +	int ret;
> +
> +	if (pos + count > virtvdev->bar0_virtual_buf_size)
> +		return -EINVAL;
> +
> +	switch (pos) {
> +	case VIRTIO_PCI_QUEUE_NOTIFY:
> +		if (count != sizeof(queue_notify))
> +			return -EINVAL;
> +		if (read) {
> +			ret = vfio_pci_ioread16(core_device, true, &queue_notify,
> +						virtvdev->notify_addr);
> +			if (ret)
> +				return ret;
> +			if (copy_to_user(buf, &queue_notify,
> +					 sizeof(queue_notify)))
> +				return -EFAULT;
> +		} else {
> +			if (copy_from_user(&queue_notify, buf, count))
> +				return -EFAULT;
> +			ret = vfio_pci_iowrite16(core_device, true, queue_notify,
> +						 virtvdev->notify_addr);
> +		}
> +		break;
> +	default:
> +		ret = virtiovf_issue_legacy_rw_cmd(virtvdev, pos, buf, count,
> +						   read);
> +	}
> +
> +	return ret ? ret : count;
> +}
> +
> +static bool range_intersect_range(loff_t range1_start, size_t count1,
> +				  loff_t range2_start, size_t count2,
> +				  loff_t *start_offset,
> +				  size_t *intersect_count,
> +				  size_t *register_offset)
> +{
> +	if (range1_start <= range2_start &&
> +	    range1_start + count1 > range2_start) {
> +		*start_offset = range2_start - range1_start;
> +		*intersect_count = min_t(size_t, count2,
> +					 range1_start + count1 - range2_start);
> +		*register_offset = 0;
> +		return true;
> +	}
> +
> +	if (range1_start > range2_start &&
> +	    range1_start < range2_start + count2) {
> +		*start_offset = 0;
> +		*intersect_count = min_t(size_t, count1,
> +					 range2_start + count2 - range1_start);
> +		*register_offset = range1_start - range2_start;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
> +					char __user *buf, size_t count,
> +					loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	size_t register_offset;
> +	loff_t copy_offset;
> +	size_t copy_count;
> +	__le32 val32;
> +	__le16 val16;
> +	u8 val8;
> +	int ret;
> +
> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
> +	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
> +				   copy_count))
> +			return -EFAULT;
> +		val16 |= cpu_to_le16(PCI_COMMAND_IO);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
> +				 copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		/* Transional needs to have revision 0 */
> +		val8 = 0;
> +		if (copy_to_user(buf + copy_offset, &val8, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		u8 log_bar_size = ilog2(roundup_pow_of_two(virtvdev->bar0_virtual_buf_size));
> +		u32 mask_size = ~((BIT(log_bar_size) - 1));
> +		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
> +
> +		val32 = cpu_to_le32((pci_base_addr_0 & mask_size) | PCI_BASE_ADDRESS_SPACE_IO);
> +		if (copy_to_user(buf + copy_offset, (void *)&val32 + register_offset, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		/*
> +		 * Transitional devices use the PCI subsystem device id as
> +		 * virtio device id, same as legacy driver always did.
> +		 */
> +		val16 = cpu_to_le16(VIRTIO_ID_NET);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
> +				 copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID, sizeof(val16),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
> +				 copy_count))
> +			return -EFAULT;
> +	}
> +
> +	return count;
> +}
> +
> +static ssize_t
> +virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
> +		       size_t count, loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
> +		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
> +
> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
> +		return vfio_pci_core_read(core_vdev, buf, count, ppos);
> +
> +	ret = pm_runtime_resume_and_get(&pdev->dev);
> +	if (ret) {
> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
> +				     ret);
> +		return -EIO;
> +	}
> +
> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
> +	pm_runtime_put(&pdev->dev);
> +	return ret;
> +}
> +
> +static ssize_t
> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
> +		size_t register_offset;
> +		loff_t copy_offset;
> +		size_t copy_count;
> +
> +		if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
> +					  &copy_offset, &copy_count,
> +					  &register_offset)) {
> +			if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
> +					   buf + copy_offset,
> +					   copy_count))
> +				return -EFAULT;
> +		}
> +
> +		if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
> +					  sizeof(virtvdev->pci_base_addr_0),
> +					  &copy_offset, &copy_count,
> +					  &register_offset)) {
> +			if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
> +					   buf + copy_offset,
> +					   copy_count))
> +				return -EFAULT;
> +		}
> +	}
> +
> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
> +		return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +
> +	ret = pm_runtime_resume_and_get(&pdev->dev);
> +	if (ret) {
> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
> +		return -EIO;
> +	}
> +
> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
> +	pm_runtime_put(&pdev->dev);
> +	return ret;
> +}
> +
> +static int
> +virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
> +				   unsigned int cmd, unsigned long arg)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	void __user *uarg = (void __user *)arg;
> +	struct vfio_region_info info = {};
> +
> +	if (copy_from_user(&info, uarg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	switch (info.index) {
> +	case VFIO_PCI_BAR0_REGION_INDEX:
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		info.size = virtvdev->bar0_virtual_buf_size;
> +		info.flags = VFIO_REGION_INFO_FLAG_READ |
> +			     VFIO_REGION_INFO_FLAG_WRITE;
> +		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
> +	default:
> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +	}
> +}
> +
> +static long
> +virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> +			     unsigned long arg)
> +{
> +	switch (cmd) {
> +	case VFIO_DEVICE_GET_REGION_INFO:
> +		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
> +	default:
> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +	}
> +}
> +
> +static int
> +virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
> +{
> +	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
> +	int ret;
> +
> +	/*
> +	 * Setup the BAR where the 'notify' exists to be used by vfio as well
> +	 * This will let us mmap it only once and use it when needed.
> +	 */
> +	ret = vfio_pci_core_setup_barmap(core_device,
> +					 virtvdev->notify_bar);
> +	if (ret)
> +		return ret;
> +
> +	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
> +			virtvdev->notify_offset;
> +	return 0;
> +}
> +
> +static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	if (virtvdev->bar0_virtual_buf) {
> +		/*
> +		 * Upon close_device() the vfio_pci_core_disable() is called
> +		 * and will close all the previous mmaps, so it seems that the
> +		 * valid life cycle for the 'notify' addr is per open/close.
> +		 */
> +		ret = virtiovf_set_notify_addr(virtvdev);
> +		if (ret) {
> +			vfio_pci_core_disable(vdev);
> +			return ret;
> +		}
> +	}
> +
> +	vfio_pci_core_finish_enable(vdev);
> +	return 0;
> +}
> +
> +static int virtiovf_get_device_config_size(unsigned short device)
> +{
> +	/* Network card */
> +	return offsetofend(struct virtio_net_config, status);
> +}
> +
> +static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
> +{
> +	u64 offset;
> +	int ret;
> +	u8 bar;
> +
> +	ret = virtio_pci_admin_legacy_io_notify_info(virtvdev->core_device.pdev,
> +				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
> +				&bar, &offset);
> +	if (ret)
> +		return ret;
> +
> +	virtvdev->notify_bar = bar;
> +	virtvdev->notify_offset = offset;
> +	return 0;
> +}
> +
> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev;
> +	int ret;
> +
> +	ret = vfio_pci_core_init_dev(core_vdev);
> +	if (ret)
> +		return ret;
> +
> +	pdev = virtvdev->core_device.pdev;
> +	ret = virtiovf_read_notify_info(virtvdev);
> +	if (ret)
> +		return ret;
> +
> +	/* Being ready with a buffer that supports MSIX */
> +	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
> +				virtiovf_get_device_config_size(pdev->device);
> +	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
> +					     GFP_KERNEL);
> +	if (!virtvdev->bar0_virtual_buf)
> +		return -ENOMEM;
> +	mutex_init(&virtvdev->bar_mutex);
> +	return 0;
> +}
> +
> +static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +
> +	kfree(virtvdev->bar0_virtual_buf);
> +	vfio_pci_core_release_dev(core_vdev);
> +}
> +
> +static const struct vfio_device_ops virtiovf_acc_vfio_pci_tran_ops = {
> +	.name = "virtio-vfio-pci-trans",
> +	.init = virtiovf_pci_init_device,
> +	.release = virtiovf_pci_core_release_dev,
> +	.open_device = virtiovf_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = virtiovf_vfio_pci_core_ioctl,
> +	.read = virtiovf_pci_core_read,
> +	.write = virtiovf_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
> +	.name = "virtio-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = virtiovf_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.device_feature = vfio_pci_core_ioctl_feature,
> +	.read = vfio_pci_core_read,
> +	.write = vfio_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +static bool virtiovf_bar0_exists(struct pci_dev *pdev)
> +{
> +	struct resource *res = pdev->resource;
> +
> +	return res->flags ? true : false;
> +}
> +
> +static int virtiovf_pci_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
> +	struct virtiovf_pci_core_device *virtvdev;
> +	int ret;
> +
> +	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
> +	    !virtiovf_bar0_exists(pdev))

nit. virtio_pci_admin_has_legacy_io() gives an impression that it is
checking the input pdev. However, it is checking its PF. may be worth
to make it more clearer.

> +		ops = &virtiovf_acc_vfio_pci_tran_ops;
> +
> +	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
> +				     &pdev->dev, ops);
> +	if (IS_ERR(virtvdev))
> +		return PTR_ERR(virtvdev);
> +
> +	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
> +	ret = vfio_pci_core_register_device(&virtvdev->core_device);
> +	if (ret)
> +		goto out;
> +	return 0;
> +out:
> +	vfio_put_device(&virtvdev->core_device.vdev);
> +	return ret;
> +}
> +
> +static void virtiovf_pci_remove(struct pci_dev *pdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
> +
> +	vfio_pci_core_unregister_device(&virtvdev->core_device);
> +	vfio_put_device(&virtvdev->core_device.vdev);
> +}
> +
> +static const struct pci_device_id virtiovf_pci_table[] = {
> +	/* Only virtio-net is supported/tested so far */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
> +
> +static struct pci_driver virtiovf_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = virtiovf_pci_table,
> +	.probe = virtiovf_pci_probe,
> +	.remove = virtiovf_pci_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(virtiovf_pci_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
> +MODULE_DESCRIPTION(
> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");

-- 
Regards,
Yi Liu

