Return-Path: <kvm+bounces-8031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5F884A0A0
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 18:26:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52A81281199
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 17:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4D744C7E;
	Mon,  5 Feb 2024 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0fWOz/ZV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160F8446C1;
	Mon,  5 Feb 2024 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707153954; cv=fail; b=CstohKOu/R1JScRa/i6cHz7Qbh1suwe8ILOy17MqdLmB4+4lufKSzZELrBME3K0lbcxN/AFyXLkqhDVQwP0+lZ2t62Fjb4MCmPfo5ecAyOcNRRz0b0RGULK1kGaAot9S5prpvC5hykDYl6uA/mQ7SLA3f27GuI5Qj4IzVwPgkTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707153954; c=relaxed/simple;
	bh=Pq/rjQwilxrak0PZxGaHG1BNq6UqC/VrMbX6wx7c3p4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Dmz81an6TuZZeesTfj3AFlgjjyVczwWIKGN/DwiH2+4uTqSER26zY0xyKvfbCCNWZrne/aIDWGN1X9zM0qthuZOhQf4BbPsCtsoucUU+4fiQlXHJuwWP+MjIs8X15Eix8jqXhjbBLZbsigsVXjNFUnrpcpMHIQlTtyyWdBtFjps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0fWOz/ZV; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpbAK1wAea7o5GTpad2l3bwOO5YnbQrmYCjokWV5LDQSGPGEfrrYInvqSTDFDe5W+ofeUv+k1cyzH0vHIGe7XVFNpT1rpAn1Ob89UXP7E8JARQaJVPCo2O6mcoSnFL+B2u0xWdswIF7wZ1T30pP1TxkHZbkz/WRqMBFkryPiyN/Rf7C5/sqvMXdmVVv9GECFkJjmjtuk+YFG5A5typm6J2azS93PSm+nE01k9855W6reVxaUkGFKkSAujc+K8O7mMzcMe3/TENs/vKpPyktt27jMxLgL0mxfPQ4YXqVIkXgCacWQeVC4cf/WuX10HNZvLkpWEcg64HwAbYizj7SX1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NA6Dc8gcQ9aOG4N3XfLgwme6uEmnzfy50BECLOqOs5k=;
 b=TE44kzRnZzaTe2qjBcICrtHkEOPG/Od279tztNLogpFRnGt7Dvb7FZ9KtuRN2cD7tM867232zwYs7U9jcE2YR6N4nJb5S6U0i8Y9sKjReRAsFo3Uda8b2tOna46T7rtHklJTvD8LoKL7prZ66akiqOL3HFIBvSwmehHD8/Pf0chjv4EKKRxBEphoqC9IwWTzMhGh75IRhEKJV0kJyRlumENcN5HknlnAvq343OJlnKLq9Um89yfIrWX2R1s3b9xpqzzaBIWfcxktcC4H62nsXMVzk/lhPWNeM82eYC2yIBQ4g9H4Mj+V0Y7V890dfzT4D9+n9y9k5xBcBfRGFlncKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NA6Dc8gcQ9aOG4N3XfLgwme6uEmnzfy50BECLOqOs5k=;
 b=0fWOz/ZVZSRQWym+IEyJ3W9gwF3FoTCN+sCqzqnPpfrMhwnFLZKm7gkKXe5lO0WORxmK/VJ24Mhwcj3WEzt7NqLAWMz7sK5BCn6dBaBiTJ+syfQZyxRCPFJjPmtQpEbbAMVUmARBmMQWwxdJRYLZ/B0WqBSirJLYiWW9plWAq48=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CH3PR12MB7666.namprd12.prod.outlook.com (2603:10b6:610:152::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17; Mon, 5 Feb
 2024 17:25:49 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e9c7:35dd:23f8:74a1]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e9c7:35dd:23f8:74a1%4]) with mapi id 15.20.7270.016; Mon, 5 Feb 2024
 17:25:49 +0000
Message-ID: <3f30d63a-0919-44a8-b05c-60d130ae1dcd@amd.com>
Date: Mon, 5 Feb 2024 09:25:47 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio] vfio/pds: Rework and simplify reset flows
To: "Tian, Kevin" <kevin.tian@intel.com>,
 Brett Creeley <brett.creeley@amd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>,
 "yishaih@nvidia.com" <yishaih@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>
Cc: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20240126183225.19193-1-brett.creeley@amd.com>
 <BL1PR11MB52712B162AE5FEC2E24614F98C472@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Language: en-US
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BL1PR11MB52712B162AE5FEC2E24614F98C472@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::27) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CH3PR12MB7666:EE_
X-MS-Office365-Filtering-Correlation-Id: 8969fb84-9495-4c32-4f09-08dc266f7ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	29XBsLy8tayyJLayhwAwvNwsdHMJVGcnQ9ohen8n4a4BjMijA1UnVcG3nQftUY0cQeIcOn6y6JGgZLVfjHXRaQZns23fHYwum4kBJo0Jv0r+0w43+EeK/pICO7689RmwtMvtua+jLTzSqNWHiuKAhBYgRmMT/sC7yuEDV0+eGaPci+wtPA65UvMiCKlL1vcp4oTGwX1PbtAganuxWbsjhjdvyGPiaqLhQG/2OVRqYMOOwgVkvH4ZlqTy0ZdS0heBb4DZNtS1uBYOdkZcs0H7GKSbawFg1cx/bydJejYT7TJdiy6t/C4Yh6zDDDXU5jGh61tLFr704uTnYs9qMd1ZblsyEPw8Tpym3LmfgG7Zyf+RFyRZSn6GK2f4i5ILtStUKQN3bnbR3mfl6nIua9mOoybkAauS3yg7XCl58R5tR+m3ypJDB/K7e89lAYcpWCdc55s4izvjAusBDoEMJPyorXy8Q/wa3xFgFx8ChpOeIeUeyQ9Ko+m5pkoPoJ09sDroQrMBdVGGRQ0cBuwaXTOr57iVpbHwCYRMjBFlmS6Y0+i9O0q1oORSglarCWLymzmRx+f6jrZh2Eztx5Z1Jy5shOe8+sd3hqcWYeqZSqCq7fDsXlo86L8e+nB3PaReIfMbuauIX2EnQgttB5nh9J9IZQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(346002)(396003)(39860400002)(230273577357003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(36756003)(4326008)(8936002)(2906002)(41300700001)(5660300002)(31696002)(2616005)(6486002)(8676002)(6506007)(83380400001)(66556008)(53546011)(478600001)(66946007)(6512007)(316002)(38100700002)(66476007)(110136005)(26005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjBYb3VLWUU2VEhUODBOMUI0eTN3ZFJCUGpsaFRqY2xSeGpZRkk1RHJBQmt1?=
 =?utf-8?B?WUtSdFRpeXJRc0ZqRm5xenBSMVJ3WWpHTjJxRVJvL0hHR2hYM3VCZ2VoUDEy?=
 =?utf-8?B?WlV5LytKNlhWeHdyVlVtR3FwTW1XM1pta2lPNjVVYmdTeVByczgvcEZ2c3cr?=
 =?utf-8?B?TWsrRWJQdlJONUlqNU5ZM3NGZDFHeWJtK0xYdE95QkdSZEhRZFhhbXZDdjZI?=
 =?utf-8?B?MkNYVjFOVFlmQncvb3lEZmRPSldEc2JBNEZMM1lJT0lXMXFVUHdOS2hhaWRL?=
 =?utf-8?B?dDJDRDlLYjZBZTZ1dkY4MGcxOW9YYzAvK3BKN3FRU2FQVWRac1FxSHhPSkxt?=
 =?utf-8?B?UDRjaWYvZVo5RHVTbitSczlrZGN4cERVZ294OW42Vm5VcytYdXNwK3ZzVDdt?=
 =?utf-8?B?QUhKRjRkOVlWVnBSejY2L3hNa0JyVDk0Sjl6b1puTnZYWW9rbi9KVUFsbis5?=
 =?utf-8?B?VWZCUnhybWJPV1IwRmsveFFXRURzUTNaNC9oUHdMdW9NUGl6cDlSRkgyd1Ns?=
 =?utf-8?B?bXY5VUV2N1oxSDJHMmYwTWo2NDNSeFJ4aFhFM1ZXZ1VHM0MxQ2hUQkFpVlpZ?=
 =?utf-8?B?SFhLNjJ6UktRcWJYVDY5dVluOFVXMVg1UDB6WGQ4RGxhdVQrTlJVQTI3VWxv?=
 =?utf-8?B?dkhBZTZSVFVTSzVJM2hqdHR6cCs3UW1OYnVXa2FFYlNBSDlrdkxjRElvOW9z?=
 =?utf-8?B?VUQzSDF1V3BidzV6NCtZMVhvejQ0a0RjdFdGSG1oS2hoT01vRFE2alR4d3NZ?=
 =?utf-8?B?TWFISnVGaW1tWGVla2NRSW1oNkNKNEQ3VUNCN0lGVGhIWDhRaFVqNldiaXky?=
 =?utf-8?B?RUh5RmtFem4yblU5eDBrSGovbytYUzJrbTRiMjczMGZESzU0Yk9PQjBhbDBq?=
 =?utf-8?B?b0hGUktEUzFJb3NNblBUZm9qcmVjdEU3eW05MkszOTlLbGZUWGFYS1pNeXVx?=
 =?utf-8?B?UEdPc3FJb0lVM2hIZE9KaFd1dXQ1dHpMN3oxYWtEUW1TUTNLUE1taitZbi9X?=
 =?utf-8?B?SitWelJmYUY5N2pkRFNWelV2ZzdvYkJzbTNmUndjRzRMSWRLL1lvSVU5ZG5V?=
 =?utf-8?B?RFRFaHF4bTVkMitpN0F1bjdXQ05UVElHbVFyM3VPTFJiZlFBZFhYUEVLWjJP?=
 =?utf-8?B?TkFRMU5ZUW0vbXhDeXR5K2hya2dnNkt2VDdYY0xKcFhVUUdwNFBSUzI2WVV6?=
 =?utf-8?B?dlBFejEyVncyeVYvZys3YzRhajBFOWtRN01FSzFLcC9TL0NwcU04UGZnQktv?=
 =?utf-8?B?K083b0VDQU1MUm9mcGF1UG92dENWKzBkUXVEWjU3d0REZXNvc2FJQ3NsMjll?=
 =?utf-8?B?amNVWUsrREk2cHIzSHlzL2lwSmh6bmxJMUZONW42bisxTWpWb0lKL1NuL2E5?=
 =?utf-8?B?NXZWODA4WWdxKzdHL1Jkd0JSWUtIcHg5Mk9HbWg1MHh4bkN6YUtLYmc3ck5U?=
 =?utf-8?B?MDR4bDFyQXQ1dHBHTDdxeDdHczdKZWtNeXdQNExNRDNFeGhhdC9JbWE2TUNS?=
 =?utf-8?B?VmhGT0hUYVFrdkFvVVl0N3lIS2IvdkRMYlBGVzhBZTNLdEx3NE5kZXRRY2hM?=
 =?utf-8?B?QnBUWGNCUmdvU0I2QjVvd1JCaUZ6a3JydzBsVTE5Z2dtajYxNHNuZUl1VlZo?=
 =?utf-8?B?bXlORTlwQWcraFZCVDVnRVFHUElHcWlNL1Y5TFBSS1ptVWcyaHNqNXk3R1Rz?=
 =?utf-8?B?YTJQdzU5dXVSbTBEWE9UWEVZNU85bXI3ZWl3dXZMN0d4NU4yZ25QZ3d2MmFB?=
 =?utf-8?B?bGxrb2YxTmdYNW1nMFJLV3JsQXpTUjV3UWJmNkRzQVY0OEtnKzdYRlBUTWZQ?=
 =?utf-8?B?TDlHZ28vQnFnSWlqTzRDRm5TbUNESmwwc2p1NTFYUm1ZNGpYajA5SGRaUG9u?=
 =?utf-8?B?bUZJdVFWYTdqNGtCOTZ3a2RrclFobndkYXdHOUliWm9OSSs5cDkweG43TEE3?=
 =?utf-8?B?eHFqVkg5ZnBhVHY2MkluQkxrUzFKYzFrbU1WY2lVWVJ2OTRFQ0xHK2VEdFdU?=
 =?utf-8?B?ZkxMeU1VS1RIYTRUWmFieGU2TUw4elBvRkxuMEE2Rnp4ZTgvVlpaK3NHL3dI?=
 =?utf-8?B?THM1UE5yQUt4SzE1S3h1YUNwVEUzOHVUcEpycjJMLys1WDgwbXFGaGdWZk53?=
 =?utf-8?Q?4Mmeer8Ye0B7azEtSBcxXDruH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8969fb84-9495-4c32-4f09-08dc266f7ee9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 17:25:49.3344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6iV426c40MM9AvaS1UkYEMhPo3mb9oEhd3OcFmyqOFyQ9T3phfAMUuBegutIYsMiiyhlLOGIhdf+d3YTy6KMMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7666

On 2/4/2024 10:58 PM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Saturday, January 27, 2024 2:32 AM
>>
>> The current logic for handling resets based on
>> whether they were initiated from the DSC or
>> host/VMM is slightly confusing and incorrect.
>> The incorrect behavior can cause the VF device
>> to be unusable on the destination on failed
>> migrations due to incompatible configurations.
>> Fix this by setting the state back to
>> VFIO_DEVICE_STATE_RUNNING when an FLR is
>> triggered, so the VF device is put back in
>> an "initial" pre-configured state after failures.
> 
> any reason for putting short lines (<50 chars) in commit msg?

No, I will make the lines longer in the next commits.

> 
>>
>> Also, while here clean-up the reset logic to
>> make the source of the reset more obvious.
> 
> as a fix the a 'Fixed' tag is preferred and CC stable
> 
> also separate the real fix from the cleanup so stable kernel doesn't need
> to backport unnecessary code.

Sure, I can split this into 2 changes as you suggested.

> 
> btw the commit msg is not clear to me. It says fixing the problem
> by setting the state to _ERROR for the DSC path and to _RUNNING for
> the FLR path.
> 
> But looks it's already such case with old code:
> 
> pds_vfio_recovery()
>          pds_vfio->deferred_reset = true;
>          pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_ERROR;
> 
> pds_vfio_reset()
>          pds_vfio->deferred_reset = true;
>          pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
> 
> pds_vfio_state_mutex_unlock()
>          if (pds_vfio->deferred_reset) {
>                  ...
>                  pds_vfio->state = pds_vfio->deferred_reset_state;
>                  ...
>          }
> 
> it's same as what this patch does:
> 
> pds_vfio_recovery()
>          pds_vfio->deferred_reset_type = PDS_VFIO_DEVICE_RESET;
> 
> pds_vfio_reset()
>          pds_vfio->deferred_reset_state = PDS_VFIO_HOST_RESET;
> 
> pds_vfio_state_mutex_unlock()
>          if (pds_vfio->deferred_reset) {
>                  ...
>                  if (pds_vfio->deferred_reset_type == PDS_VFIO_HOST_RESET)
>                          pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
>                  else
>                          pds_vfio->state = VFIO_DEVICE_STATE_ERROR;
>                  ...
>          }
> 
> looks the actual functional difference is from below change:
> 
>> @@ -32,13 +32,14 @@ void pds_vfio_state_mutex_unlock(struct
>> pds_vfio_pci_device *pds_vfio)
>>        mutex_lock(&pds_vfio->reset_mutex);
>>        if (pds_vfio->deferred_reset) {
>>                pds_vfio->deferred_reset = false;
>> -             if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
>> -                     pds_vfio_put_restore_file(pds_vfio);
>> -                     pds_vfio_put_save_file(pds_vfio);
>> +             pds_vfio_put_restore_file(pds_vfio);
>> +             pds_vfio_put_save_file(pds_vfio);
> 
> above two are changed from conditional to always.
> 
>> +             if (pds_vfio->deferred_reset_type == PDS_VFIO_HOST_RESET)
>> {
>> +                     pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
>> +             } else {
>>                        pds_vfio_dirty_disable(pds_vfio, false);
> 
> and this is now only for the DSC path.
> 
> need a better explanation here.

I will clean up this patch by separating it into 2 patches and improving 
the commit descriptions before sending a v2.

Thanks for the review,

Brett

