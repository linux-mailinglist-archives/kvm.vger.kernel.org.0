Return-Path: <kvm+bounces-8293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 981B884D976
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 06:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B154D1C23B31
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 05:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 066FD67A07;
	Thu,  8 Feb 2024 05:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gXZj+1vR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CADC67A04;
	Thu,  8 Feb 2024 05:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707368818; cv=fail; b=YiJM99EA6kAWuUarnMUKUIaiyRM3TYIufYgBtyuneBbblTGIS7cehbhJ2bmG4lrMCFK9639jL4LKrV/wW2VDaGPjJR8+CQF3fz+auheEyNJf30VhGc4r8KJ8ZkItB2LhlM/2OgemgdeZ4tnxKDgMoawq0Q81ocYFNkQLgyM63Qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707368818; c=relaxed/simple;
	bh=7AfGx5ZV+JkocDH7Tq9hOyuq6vA1yUuZm8DXtGhsEYM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TVS65llHICeu/sVrCd9hu2hUOP3xw0oBz+iP/8EYgJukz1+zdUkRlJ1F/kGEKlWOb9wjsTVTx51noxDWvr286mf7X6k56jzaqCC3Z5Bol3Doy0H2KsPR0gvOkYF6jL0IGWHN9zFyqoUi/o4QfQSGWEUc9U/5/W4tyutUuhqVbuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gXZj+1vR; arc=fail smtp.client-ip=40.107.243.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPX0bvVwJ+cVyfI+2rdps+/aooElk4WfK89LqgzWALx/o9+YlGTng2y+xFDONOwpg0t39dG7e8lkKd57mlQK/oyOeQTGu3GEGh50W0M7Vmiqd8bSsLd3PUKai3Jmg68uNDQeI2Lwy+rnRZwcSRRAiObvJdwH0iGfMfBSjMXH7Ky1GEocTp3gDLftZR7ZRnpRP6H+V1VqBSATNSKUG8NUXPIMiph4iP7nyeqnoQyYfI3jpYHOB+RUPtLEkvMW0+E4HX7obgzVIFZsjTovZUG17R6Wpk6W+Qid4Tdx8zIZNPSL7QGtfk/L5CV6P1YFfNl+MoKufE5uL0eAC+UhlVGTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwZJYmjNgOQJmyS5s/Ep1T3LVXG7d1yceViAVOtHoQo=;
 b=H38DJL/K3t0jDhn4V85RqCJ8foeBh/24BqxOgKVK+uqBfw8owxdpz07vQSisUez7EIjIjBikzcgJxBqagxYdEK4zkms7sAjQLdaUubb9D1pvsBfvzRD1715JMxD3xfJ8XrZ2K4yyE3x7lhIhM+KJqxZoaSe0yb3AVOvVTo93I7js2KAxQ5270UJ6znkKVGWlTXMqPbnkk5+aeqp8vdgYbukIerCIIDvXoZDTSqKYP7Ya5cG313dj2aimO3l1Kns2l6DzvdCuhCwvOx0Ip5aFHkruzGl5zILvTVUXaQOuJnhONUOil6iTPfQV4tKNYEYCL4WquCT2NpqSgH/xtdKWEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwZJYmjNgOQJmyS5s/Ep1T3LVXG7d1yceViAVOtHoQo=;
 b=gXZj+1vRSbQ4Few+ogNrvEqaTrkFrRgSQjipe4H+PN5KVeyguC+H/HZJKfO6AJA/j894AOXMm0ZNlUlxIg6winiap+Ytmm4eI6X8nEDafa9RCRfAji8m6/3aQ4pEf9RKrNHIwSp3S/KxQm0pN7vLvNu/RZbrvuHw02tTBApbIs4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA0PR12MB7529.namprd12.prod.outlook.com (2603:10b6:208:431::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.10; Thu, 8 Feb
 2024 05:06:53 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::481d:7627:c485:9cb]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::481d:7627:c485:9cb%2]) with mapi id 15.20.7270.012; Thu, 8 Feb 2024
 05:06:53 +0000
Message-ID: <de8ad0b0-1fa3-8e32-57ac-5e3e8841d884@amd.com>
Date: Thu, 8 Feb 2024 10:36:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v12 13/16] iommu: Improve iopf_queue_remove_device()
Content-Language: en-US
To: Baolu Lu <baolu.lu@linux.intel.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 Joel Granados <j.granados@samsung.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20240207013325.95182-1-baolu.lu@linux.intel.com>
 <20240207013325.95182-14-baolu.lu@linux.intel.com>
 <BN9PR11MB527603AB5685FF3ED21647958C452@BN9PR11MB5276.namprd11.prod.outlook.com>
 <693ee23d-30c6-4824-9bb2-1cfbf2eccfef@linux.intel.com>
 <f856519f-419c-1901-b8bc-3e338873157f@amd.com>
 <9577ec59-fa05-4eea-b0ae-312d9531ce61@linux.intel.com>
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <9577ec59-fa05-4eea-b0ae-312d9531ce61@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2P287CA0015.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::14) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA0PR12MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 5420289d-3179-4f80-b678-08dc2863c3d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BBIWniAxvnPyWSooR7rTXj78ifGR0k5A0Z6XsI5yq6UhRYea01oMem5wcHXE5+w26j4Ty5Q5Wfd8TWbm3wmVBhb9394IfH7ZbhdjWKbIo1cHZMpoREzWR9/NKtNiQXeu0mXKLzulf2iksTOLleIV2Jr6bq2rUZHGkEoNUKqaziEK3i1m+36eD3EEB5uUyLNlJTprZrsgbvZIj3ZaHvFzPfedAihfDqX5TzNIIgSCiGg80MKoSqPAxUat9eQA9u6AG69RzLESZ8M6ciCwuIVsb16hSsDyQIH1Q7lc7ZJy+Jjkr2JxMhx9fOec9KPuWwd71f9oSEYreLAwVXtdtEkQoHcZJ1oD9WFibeNNba7CyrLjnK6I40zrgzbeKCoWTHtyCRwobyo4HWOUr23Ty3dCND4GwOwijWYggqN9LuE24Mpj2N7AT8o5pFjleH8UDw5f9vN0W9JuIxGDBnNZxVIUiJHGQrcYJ1ve3yOwNmbdKgLmFgbOQSME09XQA7PbLih6xN9FuIkNlwWSS4QHVlYpvBSIMzPYEoelkYPFTmdaEGw3TrBg7PX38ZzF7uJl41lv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(136003)(346002)(376002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(36756003)(31696002)(6666004)(86362001)(38100700002)(31686004)(6512007)(110136005)(54906003)(26005)(2616005)(83380400001)(6506007)(478600001)(53546011)(6486002)(66946007)(316002)(8676002)(66476007)(66556008)(4326008)(8936002)(44832011)(41300700001)(2906002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0h4SmpMRVIxQ3NXTE9JS0FZS2NqTUpJTHlkWStqbkJ3cmk4UnBzOE8wbnQ1?=
 =?utf-8?B?dHVWdEFPRWlTajZIM2Ewa2svMzFyYldKTG45STIzY1c0eXBFMGhXV1oxc1kx?=
 =?utf-8?B?VUh6Y2cxazNvbmwvMHR1WmNhV2dwSzJOVUFuMjNnUzVmOElzalpOWU5kUUlD?=
 =?utf-8?B?T3VtTk1Hc0JWOHVVbVFxK2hBNm4xamR1a0hVZnpValoyRTZtTUdkbTQ5djFN?=
 =?utf-8?B?b2R0a1c3U0M3R081TUM0R2VObjlWMHZZc1hkUnVXa0ovL0JaZnk1dEFSM1NZ?=
 =?utf-8?B?YWd0Qjk3M2JhaGtOeVRNd2QxUWZXQWhUb1pNcXVHZXlzYmhPTHZwNkdDaElX?=
 =?utf-8?B?eFJzazBWMGlPdzRWd2prbjJNaTFmWVJkS1ZPNVJZdGpVczI4YXRQN21OeEN6?=
 =?utf-8?B?RG1hZ0JxUm1zMU13d0g4V3J1cDhBcUJRdm82Wi8ybWdGRGxQOUFJcGpNVEk0?=
 =?utf-8?B?TlNqMGtKVDQ0WVN1ZWFSMW9VN0xHRkdFMjFET3FpZ014MUdid3lqakhnYzJk?=
 =?utf-8?B?ekRuSWRma3FMdG5HUlhnT01BcGV1QnpzT1o4NHNyRnkyUWZQWUp3MGtkUHZ5?=
 =?utf-8?B?c1h1dk9jYWprOHFqRWlVNUF0SUxUd3FoTjlTVFh4a1kxTk84SFdkaWZVNEsz?=
 =?utf-8?B?N1lKZXFlSktiK0NyM2g4ZDh0TExXTEp5TzZ6MHpyc0E0azVCTXdvdkwxL0J6?=
 =?utf-8?B?T1oxTXdoeFdSbFNwcWp5bmZzcm8wVTlyQ2VPclpqZFV0SEVkZ2tWTmRXd1JW?=
 =?utf-8?B?aXRUK3NwMUtRK1dLMitIVjRZK1paZUhPUTZvdXduY0FrbUVURVN3ZmJhc0xO?=
 =?utf-8?B?eS81T0MzQ0NqU0J3ZUpEYm9ybEhPVHkyV2RvSTF3ZnZob3NocW5sSDZYRlpJ?=
 =?utf-8?B?SmhKdGVBZ1lYeURMVmFvTmpWc2tFdFNrQjF3NHdqV2hhczEzL1BPYjUyVE1w?=
 =?utf-8?B?UWJQR3U2eTRkUEQvVUVNeWxXYkpCMERGVVh6ejNuUjVhVFlPdFBtNDk4ajl3?=
 =?utf-8?B?K2FNcEZXclV4UFVrZmgvc1pEMiszUlpjV09DZGQ0REpoRGNqWExvT01jN3g5?=
 =?utf-8?B?Z3EzSkV2ZWQ3UWc3NTJoVWN4WlJUdGxFeTU1SFRXblpMcnpHR093OTM4dmd0?=
 =?utf-8?B?bzNtMFc0VXZLZjZZck5DNzJmOGt3b1htMm5lemtQaTBRUUtQTW15MmNjVlJC?=
 =?utf-8?B?QlM0cHNEdHZKeTJ4Z0p4YnR0bTk0ZFpoWVp3dGE4eWtSVEhTT3BOQWs4eFBh?=
 =?utf-8?B?QWFDYlEyaGYyTDM3Z2hoRzVjRHl6WG9aSENjTzRkdXY2TzFXVjQ1YUJWcG9q?=
 =?utf-8?B?VUR2U0ZFM25na2tGQ0VabWMzWE9SaXFCR2wzMWNlZUI5V1lWWHNSMHc0TUZT?=
 =?utf-8?B?a0xneWgrWkZIeUZJQnVhakZsenY1d053SEZHU3RxaUR5UGNJbmQ3V21qTnFH?=
 =?utf-8?B?a01sdDNpMTVJUGdJQlBlb0FnMTJiL2FXZVRJNFZvWFlRK1JTWTJGSkNRVXM0?=
 =?utf-8?B?bU9PYlBPbWJHZWZKSitvZHFSWExDZUxHd3FIWDBoOHRmR2Z1ZzVFWVlnNjU1?=
 =?utf-8?B?cjZpSmpVV04rb092bmx4UnRFTmlpaXgwTFZpUENIYldlWU9nS0YxYUJ6cURQ?=
 =?utf-8?B?UzM2YkI1SmZQeXNDNTFjVjF4NnRkRldEdit6d3VIUStHWFl6MGZXNEZkMFhZ?=
 =?utf-8?B?Um1EcWxXbmpBSDhzNW5DRk1YNFFGV2tIaFJLMUM5Y09BUFVCbkt1V2RiYWdW?=
 =?utf-8?B?R1QzeDlod3pVVWdBMS9ObDh3RUNNMWkrY3VQSFJxWEE5bjJib0lZZFQ1dlZi?=
 =?utf-8?B?TklNZUxZRGdZOEo1UUticlMwbm5nWjU2RFBNNnhwQkNrYWdDOUM1YXpQTHpD?=
 =?utf-8?B?U2Vud3RXS0Q5OC9EeVEzMDBMU2d2V2hYbzZ6cW50RFNDQ2w1K1RwUEMzSU5V?=
 =?utf-8?B?d3FjQzdYZUtmZVV4MXZ1ZzEvcDZnWFNRUURlelFKdS9oaTFnc0xydXhyb3V4?=
 =?utf-8?B?SHh0YnA3ZmpZKzE3OHMvVDAyN0w4Q21CMkdwY2VTaUxJZVEzNHh1akd3Vloy?=
 =?utf-8?B?dlhweUhkd3pZbFFYbWQ0M1ZSNGNHdkNHVnNRcXYvNXhncEowRUFHVVVhYjg1?=
 =?utf-8?Q?M7dnIpxgwF0SYEuYBnvzGxD7R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5420289d-3179-4f80-b678-08dc2863c3d6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 05:06:53.5662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqPBpPWUzpTAL69F0jIDZxZTz4vQMGlHlBMEyogRhrwqBJ49ZQ+X1SiCfaEfBFsw0OoFgG5g5ZFVlT8QRUtSdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7529



On 2/8/2024 7:02 AM, Baolu Lu wrote:
> On 2024/2/8 1:59, Vasant Hegde wrote:
>> Hi Baolu,
>>
>> On 2/7/2024 5:59 PM, Baolu Lu wrote:
>>> On 2024/2/7 10:50, Tian, Kevin wrote:
>>>>> From: Lu Baolu<baolu.lu@linux.intel.com>
>>>>> Sent: Wednesday, February 7, 2024 9:33 AM
>>>>>
>>>>> Convert iopf_queue_remove_device() to return void instead of an error code,
>>>>> as the return value is never used. This removal helper is designed to be
>>>>> never-failed, so there's no need for error handling.
>>>>>
>>>>> Ack all outstanding page requests from the device with the response code of
>>>>> IOMMU_PAGE_RESP_INVALID, indicating device should not attempt any retry.
>>>>>
>>>>> Add comments to this helper explaining the steps involved in removing a
>>>>> device from the iopf queue and disabling its PRI. The individual drivers
>>>>> are expected to be adjusted accordingly. Here we just define the expected
>>>>> behaviors of the individual iommu driver from the core's perspective.
>>>>>
>>>>> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
>>>>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>>>>> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
>>>>> Tested-by: Yan Zhao<yan.y.zhao@intel.com>
>>>> Reviewed-by: Kevin Tian<kevin.tian@intel.com>, with one nit:
>>>>
>>>>> + * Removing a device from an iopf_queue. It's recommended to follow
>>>>> these
>>>>> + * steps when removing a device:
>>>>>     *
>>>>> - * Return: 0 on success and <0 on error.
>>>>> + * - Disable new PRI reception: Turn off PRI generation in the IOMMU
>>>>> hardware
>>>>> + *   and flush any hardware page request queues. This should be done
>>>>> before
>>>>> + *   calling into this helper.
>>>>> + * - Acknowledge all outstanding PRQs to the device: Respond to all
>>>>> outstanding
>>>>> + *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device
>>>>> should
>>>>> + *   not retry. This helper function handles this.
>>>> this implies calling iopf_queue_remove_device() here.
>>>>
>>>>> + * - Disable PRI on the device: After calling this helper, the caller could
>>>>> + *   then disable PRI on the device.
>>>>> + * - Call iopf_queue_remove_device(): Calling iopf_queue_remove_device()
>>>>> + *   essentially disassociates the device. The fault_param might still exist,
>>>>> + *   but iommu_page_response() will do nothing. The device fault parameter
>>>>> + *   reference count has been properly passed from
>>>>> iommu_report_device_fault()
>>>>> + *   to the fault handling work, and will eventually be released after
>>>>> + *   iommu_page_response().
>>>>>     */
>>>> but here it suggests calling iopf_queue_remove_device() again. If the comment
>>>> is just about to detail the behavior with that invocation shouldn't it be
>>>> merged
>>>> with the previous one instead of pretending to be the final step for driver
>>>> to call?
>>>
>>> Above just explains the behavior of calling iopf_queue_remove_device().
>>
>> Can you please leave a line -OR- move this to previous para? Otherwise we will
>> get confused.
> 
> Sure. I will make it look like below.
> 
> /**
>  * iopf_queue_remove_device - Remove producer from fault queue
>  * @queue: IOPF queue
>  * @dev: device to remove
>  *
>  * Removing a device from an iopf_queue. It's recommended to follow these
>  * steps when removing a device:
>  *
>  * - Disable new PRI reception: Turn off PRI generation in the IOMMU hardware
>  *   and flush any hardware page request queues. This should be done before
>  *   calling into this helper.
>  * - Acknowledge all outstanding PRQs to the device: Respond to all outstanding
>  *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device should
>  *   not retry. This helper function handles this.
>  * - Disable PRI on the device: After calling this helper, the caller could
>  *   then disable PRI on the device.
>  *
>  * Calling iopf_queue_remove_device() essentially disassociates the device.
>  * The fault_param might still exist, but iommu_page_response() will do
>  * nothing. The device fault parameter reference count has been properly
>  * passed from iommu_report_device_fault() to the fault handling work, and
>  * will eventually be released after iommu_page_response().
>  */

Looks good. Thank you.

-Vasant

