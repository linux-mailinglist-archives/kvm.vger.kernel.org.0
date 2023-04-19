Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003F16E8111
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 20:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbjDSSOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 14:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjDSSOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 14:14:38 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51496A27D;
        Wed, 19 Apr 2023 11:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681928056; x=1713464056;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iLDuY7hD2b+1vzWFcFmg59bMAUGFX5n3oTxbfTQk7M8=;
  b=P1HlEHtMn+HtA/ainWJlCwJ1OWYJb/G2VyTtaUWJ/yQl4599OpEyTyfH
   z5+9OS0aEQqfyFDFWYHgjaWN/gSmrjwcxjonyu3etjnjJQR7MbwWlufQU
   44F3QJYeB9s5SWB/eNrfEuOGuJLw3C0SUUkJcrdL1jygyxIhA35v3gx3O
   6GupPTK8dzfXW3/OKQsQ0wxt9pKfuE+erKxCow5oE7HhRiYw5gtvSvLkw
   76qmDZLTnmZlRxIsQw7sQStVsMO4O2zdX0GMBZV2ACMb4ps6PasQe/NIz
   qmfh1e1EahB2ZEcBppwbm4Aoqtt6W+OboFKJkWCuwo8wKem9XMg2rou+S
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="408434191"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="408434191"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 11:14:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="722026009"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="722026009"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 19 Apr 2023 11:14:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 11:14:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 11:14:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 11:14:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 11:14:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKqU6FWYVwGECgKQFvtA7JQovv65yk0mHpxU3LyJr2Bif/xclP6z+PurRINcXthkrgR3q/hRtuHZrX0ibLgXQ7UnhHDQo7a7surcV47wjfLOY5zPtL0aNb1ApF+UWJOiowt5bvFizs94WAZPhBPdEds4Sa91XNaKsjWu9cuf7xzZJXAIU+PZftU8fzerbBzbAPaywT3FVqy8PCNo7MCXHYEey42mUb3NmMi9JV/RtqbKJ928T012XTHdLAkhWryfCdu7CBbDCZpNQyf96nguXIf5oZ8+rLHzPgi3/7SlbUM5WpbQiOd+eccZ2FWc6b9w1ADLYbmtbhSesJCqO1nREg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8xQfhBJWpKBiRtHrmaEUUEmbDsfMKIw1/mW0auC70w=;
 b=SxdZbM9Qln8LC8j6ZCQ9iEogbaOOa6UIknajRZBl+GqXhwxU0QzFDSAAr+2AROAZnbLtaiivuH5ObIyJRNM3gmPJH/LW45NBb1k45DR6LAoz4ncs5msvGVmLaZfrz8WiKWjd0cJjchaq84y52UXpzlk/mjPUqwbqsk6NtUG5x9AXcodVAL0t3JOVvYS2HkEtuDRCHEOATenexJcpDkboxMfd1HF381u8htQe4NOigRLtGDr6cx4jIbVDfA1Uf7iG0E8XAy8KcIbDq3vnb7gmcbkjVZBiw7le/a+/EqTTjX3RsZa+n9Z2tDXKyhq0nrd5vIThOb0cu92pAeC5Sv+B4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by SJ0PR11MB5614.namprd11.prod.outlook.com (2603:10b6:a03:300::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 18:13:58 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::4bd:cce2:58ce:cd6b]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::4bd:cce2:58ce:cd6b%3]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 18:13:58 +0000
Message-ID: <5d40e92b-2e7b-addf-d03b-3bc6da7895be@intel.com>
Date:   Wed, 19 Apr 2023 11:13:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH V3 10/10] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1681837892.git.reinette.chatre@intel.com>
 <6c057618833a180da2147bffadb98e07cb73e045.1681837892.git.reinette.chatre@intel.com>
 <20230418163843.7b4c0366.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230418163843.7b4c0366.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:a03:255::8) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|SJ0PR11MB5614:EE_
X-MS-Office365-Filtering-Correlation-Id: 15afd9d8-10b2-41a0-14c0-08db4101d838
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QMvixoyqYSk91QJcyV/wOmOt7rwKyQps1JmrWhrRm4TsO54IAi02kvu3ygYMqMZMHA+IbRb9KEjA/p/qxWbYSnjoFUfFI9d44MmL/PiGOobS9jxNrTUR1qq3W6dR594TFbKgH/7yilB/kcAEGHjb8uB72lFOmGj+NZMea2K+LB5Vhd4rN9WpJFzXRVDvf3bh9oovrmOj+biY8lroqKe43PYtnLjGHCkG8Ro7MNgHIuN2gKFuF/Iik6pb5i82QfbHokmW+g9pQpo4eW6RXBxYdtFAZexESDaTNDfM5Xc6MPseyib7RzsZipJt0tygiut0nk8MbAwwtDozVigAg53N2UKNigDMLRTfPVD39K0btDpY3G37vJchG34hxOqaB8aJRXnX/kvY9bgltfZv3lY+KTUH15/0fO2Rkt7ooMqqTSYA9MgOLp9nkngvnJpo7azmgDJ9Elwhzz7V5ujLjF4fLLZ7GcyHe3+wb4KGb4R1BXWgN9Uen1O7gYe/PozKsGFimqlQ80N61OX9yOf769s/j/PFbOIa56yAFRvf7J0qQ6FO4mGWYLhPptOGmi3BVNQZM26JAvnLdoUM11GKUtTyuCeVveq+PhR0VD3+qfB4tSkzseNmovpL3S2LFAig4SHLA+JOL2e6PlQ3wX68f0ssYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199021)(86362001)(31696002)(4326008)(316002)(6916009)(6486002)(41300700001)(8676002)(66946007)(66476007)(478600001)(66556008)(36756003)(82960400001)(5660300002)(8936002)(4744005)(2906002)(44832011)(38100700002)(186003)(53546011)(6666004)(6512007)(2616005)(26005)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWFhOU9OaHpZNGVmeFlnNXZiWHBvRjlrZnBsUVp2VGdORzVVV1Eza2IwRDNQ?=
 =?utf-8?B?ZE13Ull6TzkyMW5kN2VmbFFqcUtzM0ZjNFRMS2VaRjU2MlRJaGJZeFF1dlRD?=
 =?utf-8?B?Zk1hQ01jS1czaWFkeGhMV3N4YWRYZ0wrR2IzK3BNWjF5ZFZyV3JwMlZjYnRB?=
 =?utf-8?B?a2k1eTU1R25Za0trTFRISzRzQkdLaThvd09qck4xeU9ZdmRybElxSmJxVlUw?=
 =?utf-8?B?dmhXOW1iSnVac2NkRkRvTFB5Q1RtT0xhbnVqNzF3dkYwTllOOUtEcjZ1cWJX?=
 =?utf-8?B?bm5ybnBpWHVLdGVqaDh3UXZ0dFBlbG9CZ3NhdWdzanZGQWZ2V0xmRWgvTUN5?=
 =?utf-8?B?RTZqbFd3ajNIZXQwNkROczVyYitHa3p3eG4rZ25qT0ZtOHdYNi9XbDk2Mlpp?=
 =?utf-8?B?L0k2WHM2R1BOc1VqYk80cVVsditwNDBWQzV3aDdNL0MrSzBKSTBPUnJsR1pI?=
 =?utf-8?B?ZnQzNUtQemJrbC92eHoxbUhXYW55UGJJMU52N08yUmF3MldPVGxpVThzTjlZ?=
 =?utf-8?B?NWxNT1ozS2NqTlRRMTlGNTRqRTg5bEQ3TnJOSFNZZEJwOWVlSWhFaVJnTVRY?=
 =?utf-8?B?eEh3cVlCVFFzS3p2QXJvcDJhZjNPRnQrSjVhVnpzcy9tQUFhaHdDRVlpUUxD?=
 =?utf-8?B?ZjhnckNVQ3NIL0lnaXAxb09ZM0RQdFdudFMyaFpHZGo4UHRjWk5GL3ArNndl?=
 =?utf-8?B?cTY2OXhic2VhcFVYVTZta0hLUTNNSkQyTTBCYjQzaTFWY3loeUREMjN3dW1P?=
 =?utf-8?B?a0VNQ0JqbjNrMkl4ZGNkaldyZEQvLzduRGNvcmhCaFcxYmJ3TUhRVTkvMkc5?=
 =?utf-8?B?akxjMWhMejN4UjdzaVd6a3BYdnA4N1RvVmZnOXB6c3JhTVRjaEVQM0NWZGhG?=
 =?utf-8?B?dUdmTWE5a1BMZUJnSmZ1NCtNblJqOEhoV2FncUVDK3A3QTNTZW5BejdFcTRh?=
 =?utf-8?B?Uk5QS0FtQW4wSFBVRGtleUV0U1hETDdRa2xCQzRrRFBmYnRWeC83aXNkRWhi?=
 =?utf-8?B?VVpmbS9PN3JxRkxudmlTY0V0R2hSVXpKanpPQmpTZDlQTGptTDZWeGdxczJn?=
 =?utf-8?B?WmhuN1FHREU4eG1hcERFTVFNWStUNTJIK3pydWlqaGhJOUVSamRvNi9qRktu?=
 =?utf-8?B?KzlDREdVVllNOElPdUNJKzVtZ1plZFBIc0Eybzl6OTJZTGI5QjgxRHJTVkRQ?=
 =?utf-8?B?REZOU0FsTjRVTU1yWUpUSjR6NWVNY2FuZm1vRndsdmIrYTNEOVNBN24zQWVE?=
 =?utf-8?B?alNCQUtEeDJvZk9OcmxUOXpNSVBHUmlNM3A0VVk3cHBKRU9ERUJ4ellOT2hw?=
 =?utf-8?B?YVE5RmpzVlhYQm5pSHVOTzBNVWsvemlFUGNuSmcra3VLcjU4WTN3N3NnSk1R?=
 =?utf-8?B?LzFqY3Q1R3VnVVF6ZE4rYkxDaFZYVU8wY0wyTnVFd2NvRUZFR1dCRjhqSi9z?=
 =?utf-8?B?ZDNjb1F3bVRsME1tTWcrUFpXR0VmUGZMUm1IRkRZT0d5OU11WWJXSk9jSlJZ?=
 =?utf-8?B?OFJEcm5IdVgzRDA5d0ZHSVJncDBCMGhUc0ZMZnB5QVkwcXM2K25QbktmZlFn?=
 =?utf-8?B?SFJoU0NHUkNsSHdKWVZZMytKQTB2dFRwWmtwNG9Vb043QmFFVHJlS1dpYXhD?=
 =?utf-8?B?K0xxaENLUldaMGwvaUphYjlwc1BsV2RrL2lBam5vVzUxZm9nM0pnSFpQYVM4?=
 =?utf-8?B?R0tkSFFQYlpBMXpTOW5wRWMrbTdRdlFFRzA4RlpPZUd4YUtFblVFOXorcmZa?=
 =?utf-8?B?SEd4alFRUHgzRDE4U0lZVGdNVFFYTkkvMHR5SWFYS3hLQm1qQjNXTW13UU5R?=
 =?utf-8?B?eWZBQ25SR3VDa0FpZ1dPc29NWFo4Qjk4SEsxSy9ZQmw1bmxXUHR5SDB6WGNy?=
 =?utf-8?B?aHFqOWhHWnd4Y3p4VjlTbUZHRjBuTldZMy9XZld4a0VIRTVyNm1MS0V0U1NE?=
 =?utf-8?B?WStqRGZocFR1ZmY3MTlRbkZhMkN1NVJXanYrdWhGeFNwb04xeDdaUjdZeVJh?=
 =?utf-8?B?RFhKNDhqeDhGM250MDhyQ0RxSnpPVnZ6bHh6SnhRcVcvZEs2NXZNczViaHEr?=
 =?utf-8?B?cmQ1dTljcUtWZmZ4WUZPVHJiNFZnNHpZM0xQa0dJeXRsS2Y2ZzNaYVEyK1Ra?=
 =?utf-8?B?N0JvS3prSlRyeThjbXBvVmpSU2VVVW1OUHRVYnFQa1c5TFpHWHVTdHhWdmZ5?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15afd9d8-10b2-41a0-14c0-08db4101d838
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 18:13:58.4143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNdialU2M5qIYVoJjefglKW6BUqASWdjx9Uvl/YqYm3k0L1ExQ6pZPXeDTnGKuIw1UtpyGMbRZZ3aV0hwQAPFFANGaXlnb+O8u8KEC9qhKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5614
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 4/18/2023 3:38 PM, Alex Williamson wrote:
> On Tue, 18 Apr 2023 10:29:21 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 

...

>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index a3635a8e54c8..4050ad3388c2 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1114,7 +1114,9 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>>  	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
>>  		info.flags |=
>>  			(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
>> -	else
>> +	else if ((info.index != VFIO_PCI_MSIX_IRQ_INDEX) ||
>> +		 (info.index == VFIO_PCI_MSIX_IRQ_INDEX &&
>> +		  !vdev->has_dyn_msix))
> 
> Isn't this the same as:
> 
> 	(info.index != VFIO_PCI_MSIX_IRQ_INDEX || !vdev->has_dyn_msix)
> 

Yes, it is. Will fix. Thank you very much.

Reinette
