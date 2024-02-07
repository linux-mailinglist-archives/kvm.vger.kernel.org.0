Return-Path: <kvm+bounces-8275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D40E884D0C6
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 19:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A9BBB28AB4
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 18:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22C484FB2;
	Wed,  7 Feb 2024 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RBvo2Yab"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB8783CDC;
	Wed,  7 Feb 2024 17:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707328805; cv=fail; b=tuBk+TOHQBczaW70JjqeOIyMd9vpSm9hxW4vOqW4248GzsITkRUYlpZojEIju2kZM4SE/xlEfMPQ7/R1VAEkqjPYZZqK3nZQ9aR1DpAWGdDRIMS/13Ng7MOdfcgEC3dY/fkGCLJVdcxIt7TuH9MpyWUhj9ztgkI+00b3/noSi6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707328805; c=relaxed/simple;
	bh=xKuvp6X64oBAe4zQlzvBKfyyZqbwkjq8EEQLZ4Ztnn8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FV8nO8PP1uMWzYsFrlQ2YPApkQo8AIH6jfE4ZHnyllN+SSQDBM21EwdHY+O/Su45HLh76eO2eQNFvyYYBexvKovNjzZIPVzdpZZ5CWymx6Uf0bWAUA4fVAAcRqh0p3C5QckzRR6nsTKtAa9b69kgApMr1Y1MKkNYN72UAWHOwFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RBvo2Yab; arc=fail smtp.client-ip=40.107.220.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTEXeodrgCV3y18d77mj+8JB9fWpKxgo8tHhfTuHm9UynKSwqUEbeCu/kjvh6loiolz+XxOgA2XBo33vHW6Ll3n3pSayCCf94H0XFTb3k8YCz3U+YB7A7RxvCZS248kFbS8O4DCpkacz6phc4m1T+dQGhbawr00NEhk8ViBlnyMan9E2rOCJIp4FGb7s50mAE3wD3tbz7zFUDq3KCa4kHvZxTY11inBiGcbovuawdSyDwNUWnWTwWr2w+pLH/VUladp5MJyA3+/x+HZJReEyliPjKVbC+Cc8Mb4zJEr2WJKiVD0dc0ufP2aBA0WOdP8HIkUMZQFk7K/Z0PFs5tQCDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImiVMFt948d3gY1NzF9bQQLwBaR3CM/YJKO522Xv5os=;
 b=Tnv5LQoLidnICnnd4as+B75WnGeXeImfLzALkB0M2yyoYOzUXBOTqnlSKzONYpY87wr09eKdnxwUvrQRYVSLMYIZsAKl9tJEW7cNcvX9W2KeSjvtJrlR68CIwDWEmeGDYEPrW+XlREVv/vOeRKP6eOaNs2Ft1iHs6tay4UIrtgwfrrteuUi/2EbV3ZIG/tNVHX211cXjR8WXi0ZAdpDY7/xXE0o4CyMnoMRZDQYorKZ5IcEe/Wd52eV3jB6WaP+IhXtGfInyAj1ZPnxXINaH0aLF6h/JWCAO3egH/aiXrj5caRWCLuwMaUjd602f9E8XGfJGzJaHbpJogGXPKivbyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImiVMFt948d3gY1NzF9bQQLwBaR3CM/YJKO522Xv5os=;
 b=RBvo2YabSzZWd/UdkU+NYqAlQT9koAh73gWl+cZwTgSyzC3X3JkQTE0S62PFn9tYiUnqx2YIoJ0vCIb/qQaXZJr3Yb9AEa/0CHHaLbaFcsNw6e1TB96MrwAyNPcXRYCsRWX8TnNxKOYjRQqy3uC1FG6JOE56iwIZSTmJaaKX5qQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CH0PR12MB5123.namprd12.prod.outlook.com (2603:10b6:610:be::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7270.17; Wed, 7 Feb 2024 17:59:56 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::481d:7627:c485:9cb]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::481d:7627:c485:9cb%2]) with mapi id 15.20.7270.012; Wed, 7 Feb 2024
 17:59:56 +0000
Message-ID: <f856519f-419c-1901-b8bc-3e338873157f@amd.com>
Date: Wed, 7 Feb 2024 23:29:46 +0530
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
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <693ee23d-30c6-4824-9bb2-1cfbf2eccfef@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0060.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::35) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CH0PR12MB5123:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bc3b249-834e-4ea0-72b9-08dc280697d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qK3+YFt4Yj3J1XiMPpze5TTiX3P3piZBtL2WCE/FDHVGWNnGLfqboJWzvcLXmOTZ3FiidGYnxhWKNM/CKzhJxcp31y5gdqGxMttpFeLL5xMXWxrDoTOuoOHoyoPlI3pfy5acalKIK3Olw2z3L8m+tNGCpHy4I5XXhn77Yp0/BMkx8qSG1vV38SMHBCXYpOlQSGzzK/q/2fcP3UVdtSpgCI7x1weUM9Fqu9d95IA2nVf32ZE62l0xsb38Jj1uC5rMbxhvl3JHjoOc+q3UcBuh1JptKDjJ7oDsI8x7bS5lhAXi8p65yYEQ0KOIwZBdACQtTnh9duKXcQFW+WEn+wnzn/S/I+TK1+0AO0JHba+OKV1f3bZxZ4Anq516t7/ukJr1KaaqSJCGyktaeerZQ+VGQQ5Int/l8SQs/7ZPceZQiqCmjxrV1QtwHizpvwG9qJDSyM0iEszuwb2yTKqVux8M8LHePLT5VE6yNsmA5RdHFYViC+tgbgX4oXWS5nWeC/PubGa3jO98IuauIlESq9bmJ+tx4VoBYfWlI+aHzlFNFqhcxwKDf6rXJPL7skr6EZ4OS2tcD8VEHwAHyp2PIzyZQWnIWE6sfMh4MR9MV1HEoSqAZ7zhbS32X9vjAFGzDCDh8FObUNreIQFgUV+HdXr2Gw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(396003)(366004)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(6666004)(26005)(316002)(53546011)(54906003)(66476007)(66946007)(2616005)(6506007)(6512007)(83380400001)(31686004)(38100700002)(110136005)(8676002)(66556008)(8936002)(4326008)(44832011)(36756003)(7416002)(5660300002)(2906002)(478600001)(6486002)(31696002)(86362001)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTVjSDIwSytLaEhhVFhlMEU0RnVWRWxXKzVEOGk4bERmMVM2dU9VbFdITXpF?=
 =?utf-8?B?VHJWQ2J4RzlOcHFuOFcwUXZJYTZMbStNQXFYYWt3dXdqUTFqRHFCQUMzYTJt?=
 =?utf-8?B?eDdYODRMcDNGclIxaEMwZWM1cUVhMjh2ci9MTjI4S3NFZXB4bTFYbVFNOUky?=
 =?utf-8?B?RTRWOGgzUUpsbVRpY1lCZ2dBaytvSi9LN1c4T0FjTW1nUHBZMDc3d3VSNjQv?=
 =?utf-8?B?ME5DbGJsR2ViV3Z6VkFCZzRqK1I4ZjJCY1krWW9oTlFkdnJHOVJWWGovcUFX?=
 =?utf-8?B?eE96dXljVXgrUHZoaStKUU9wcGs0Q2doOEdOK3loMWRBcktPcTBEOEVMcWEv?=
 =?utf-8?B?TStzNWN5aGZpZzFLSGVlTThrUUlyTzZSSmN3TWZkN0JrKzdEcDZGL2I1aTJw?=
 =?utf-8?B?VDVxK29CZXJvSUsvMTJGc1d2SFN0bUdXTWNZQWw3Z3pRYU0wRFJWOXh1MXBw?=
 =?utf-8?B?QUVRWmVUbXh3VW1Bdks0OUdZMXFiSHBvZkg0enRvZllnOVlNS0dQU2F2WHFG?=
 =?utf-8?B?OXZzaXd2VjBKa0RzY0VKLzhoRGdRMGZDY3d4d3FoMDRUQ0p4eEtWUmZaVnVT?=
 =?utf-8?B?VUdSRzduRmNHdnlFbEZCMWpGaFh0TGFHOXlqeENXZk1yNFg4eE5HVDdjT3h5?=
 =?utf-8?B?TG00RjJOVmttbEZpalRhNFplQ3JyVHlYdnVZR0Z4V1h6Tk1ia2ZRTDNIbHFr?=
 =?utf-8?B?NGZHVEJIYjk3MnlKRG9SSW85elpLZTdnSko4a1hzbWpoMlpLSWxnREc3UGRT?=
 =?utf-8?B?WkhicWx6WDhlS1hyNjdmaVlPY2Z4VmtRZE5KRE84dVFKZWYwdUZ5b3ZuajJH?=
 =?utf-8?B?dEVqdHh2RDgwWnRsTmZXcURFMlFIcGFYRmVicUg2K1BGRDZJbDVmNzNpZE95?=
 =?utf-8?B?UTVFTE1DdEJzZktUdTFob2VReDBlci9xU1N5Y3V5Uy8zUUFneExzYUYvRU12?=
 =?utf-8?B?VlZ3Rm1GNFhOa09nRHNhZndjWllZbTBKMjN1SG0rdFJWckVtaHA4V2YwY0Zr?=
 =?utf-8?B?OGVodktGVm1GSStYTEE4Ykhza2tFZWN5VUdJdDhUU0xxOUJ2cCtZaURZN0o0?=
 =?utf-8?B?cWV1aHFHRGl4Sno1TjZ4QW54Tkw3TjVFUU1sTUVRZ0QveVByMkllS053bUxl?=
 =?utf-8?B?dVc1d0ttR0xRVWdmOVZodzd1RGMwc1MyT0ZuUWdFRmM4QW5QT3FDamdYQlZy?=
 =?utf-8?B?UkZ4RkpFLzVnenpDZnZqMHVuc2RDMWxINWQ2OVNPQmxnOGhMTXBGTlAvb1ln?=
 =?utf-8?B?YlF6K2hSMVBweTdrNlVSZTFwR3hzcGN3M21TWWZDdlZRS2tiSzNBcWhSZERD?=
 =?utf-8?B?c1YyUUErczhITjk0R2NRZGZTczFTbUx6Wk1mZFd3dFdncjFZRUJQQjVJZzFx?=
 =?utf-8?B?b0dBV0RPRUJoQjVZbjVJaWNya1RZdWJrRHlHRlJRUXdIcC9tYnk0eVNtbmhH?=
 =?utf-8?B?Y2pCb09KNVVialUzWG10Nk9sV0E1aDFDcVJaY3FmU04raXoxWVN4YlNSZ2Q0?=
 =?utf-8?B?bktqOEFKaldlVm1HRkVnWHFvRHVHVnlVZVhGV244SGhzb2llUlp2ME1oYXFk?=
 =?utf-8?B?a2VsRFM4em44bCtsN2pOM3YvZVhHRWZqSXU4OGQzVmdOU1NQTmhSejNtVnY5?=
 =?utf-8?B?R005aW95dTlnZStjVm1lRkVWSGZtclk5K2dkaFdHNU5Hd082ZXk0cWRENEJp?=
 =?utf-8?B?Qm1OOHBIQWs3dmdib0ZDdEdCM2JpeVhvTUNEaWdJMzlxZk5qNE95L3pXOUJq?=
 =?utf-8?B?bGRpSEZ5bllSUmVJMTJoWWxjRE9vRUVWR1lZRDJBeWwvS2k4dHgyY0drbnNY?=
 =?utf-8?B?cm5lVjM1MDZDcmR6TXdIbkh4SkptTldoSlNNTmFPVTdUbTFNdHVjUmFCak9o?=
 =?utf-8?B?NGNIVXh0OVYzOTlMYmNqV2E0Z1IrVlp4SDRxNlJLUzJjU0ZyeWVkTXh5VmZL?=
 =?utf-8?B?VU9YSS93a0xNb2NEUnkxczJiL1RJa2hSN21qU1pvNlpLSUVoZXJvWm5ucnAr?=
 =?utf-8?B?VGQ2SGxVdFlYUWlhdnFpRk5vcjhPbDZHUk82eXR6ekgvZ0FzZERkU2dWNXJk?=
 =?utf-8?B?eUlQSStxbnBXT3pOUTF3a3d1dmdzTmsxcmxWUk9hb2ttQVk5TWdreElNeE4x?=
 =?utf-8?Q?ccODzAMAuM4JGY0NqHX3MeV8K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc3b249-834e-4ea0-72b9-08dc280697d6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 17:59:56.5717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHthocRSebv26qI3414ozSrwBJ1tjRM1w7DUj1ZC3boJoUHLXWnlbtM6T6LNMLVQ3deCLgpG5+YLexzmczPxsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5123

Hi Baolu,

On 2/7/2024 5:59 PM, Baolu Lu wrote:
> On 2024/2/7 10:50, Tian, Kevin wrote:
>>> From: Lu Baolu<baolu.lu@linux.intel.com>
>>> Sent: Wednesday, February 7, 2024 9:33 AM
>>>
>>> Convert iopf_queue_remove_device() to return void instead of an error code,
>>> as the return value is never used. This removal helper is designed to be
>>> never-failed, so there's no need for error handling.
>>>
>>> Ack all outstanding page requests from the device with the response code of
>>> IOMMU_PAGE_RESP_INVALID, indicating device should not attempt any retry.
>>>
>>> Add comments to this helper explaining the steps involved in removing a
>>> device from the iopf queue and disabling its PRI. The individual drivers
>>> are expected to be adjusted accordingly. Here we just define the expected
>>> behaviors of the individual iommu driver from the core's perspective.
>>>
>>> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
>>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>>> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
>>> Tested-by: Yan Zhao<yan.y.zhao@intel.com>
>> Reviewed-by: Kevin Tian<kevin.tian@intel.com>, with one nit:
>>
>>> + * Removing a device from an iopf_queue. It's recommended to follow
>>> these
>>> + * steps when removing a device:
>>>    *
>>> - * Return: 0 on success and <0 on error.
>>> + * - Disable new PRI reception: Turn off PRI generation in the IOMMU
>>> hardware
>>> + *   and flush any hardware page request queues. This should be done
>>> before
>>> + *   calling into this helper.
>>> + * - Acknowledge all outstanding PRQs to the device: Respond to all
>>> outstanding
>>> + *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device
>>> should
>>> + *   not retry. This helper function handles this.
>> this implies calling iopf_queue_remove_device() here.
>>
>>> + * - Disable PRI on the device: After calling this helper, the caller could
>>> + *   then disable PRI on the device.
>>> + * - Call iopf_queue_remove_device(): Calling iopf_queue_remove_device()
>>> + *   essentially disassociates the device. The fault_param might still exist,
>>> + *   but iommu_page_response() will do nothing. The device fault parameter
>>> + *   reference count has been properly passed from
>>> iommu_report_device_fault()
>>> + *   to the fault handling work, and will eventually be released after
>>> + *   iommu_page_response().
>>>    */
>> but here it suggests calling iopf_queue_remove_device() again. If the comment
>> is just about to detail the behavior with that invocation shouldn't it be merged
>> with the previous one instead of pretending to be the final step for driver
>> to call?
> 
> Above just explains the behavior of calling iopf_queue_remove_device().

Can you please leave a line -OR- move this to previous para? Otherwise we will
get confused.

-Vasant

