Return-Path: <kvm+bounces-302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A12C17DE07A
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 551EF2817A8
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 11:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0728E11726;
	Wed,  1 Nov 2023 11:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kYkpdxWJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ED363D7
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 11:44:00 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C4A11C;
	Wed,  1 Nov 2023 04:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsmzVRqDkrn3yGz3ClKOsWVTH0MZO6G+bRxO2F1+fZA3kj4x8+/8Pm2NRq9D614CxRqWFQ61l9XEmHFf8VT2y0nDSHXsgf6fDbU8jD8+pkZQg7y4vWIiNJHXcQqKr9XhynEx+pu2OmmzHUVh24/PpwgvLDLNDY6u1bAxHWJbJBcrAPa2UoHowzwpp4intu+0nbk/DhcXXFicThmnsPz2owufjHyojRcuEG07ukRzJtF7Jax4CO4EefC/bYPzXQRJUlY4PN2QsDz4n704g+OEa0yk9JH8TRAwfkguJt7E3AyKnKIhcP4zr2cEY9bq4HrSOCxmC0YI+EMM1B6N4eeXzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QffKYYSkdtubx8E2BUDEPv8Ioe52F+9ljWFtXrryW54=;
 b=kqCZteteCpCWWN6FWIJEqItAoWke0Q2S5oGyLag+HFOPdhbJ15sC2fixGPQdQ8nhZpMG4/fB7FnjA4cJehyl/9fQtmpROOhTlhlfcQDH8/Wku4szsHXY7QAJ/yJpmluuV6i5U7EvBvXFMuYHQFcE3tzPI4OEv98v33R2b5tYwMeX72LvcFIAT522aaXj2mt+Kwhv+ejIcrgfXIt/mb5q+59gr+DZc4/kw8VcNTRn1ozChSdWHTnaHT/BPTQmdU0o2JBbuf2Xq6zleqqKuRYicLQqpN9PQCO1Zc33v6qCPrcMNE/byQhPnG2YxmpsfvDh6e7AX1f8jHzXMb72XFcWvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QffKYYSkdtubx8E2BUDEPv8Ioe52F+9ljWFtXrryW54=;
 b=kYkpdxWJGjZH517Ndt2CdOCGYyeCYkPJJh6JdCvEf4JjhXNqWV+JXlk38fZ8x5RdWk18ODTvUAqyqvPE+qT1dxH5UKddymZPI3VFb5zdlUsPDqiPnM34Uk2qsaP5O3lX5wtxhcM13jKYlp41A8Lx0Rjlmn52NtqZmyGmST0PHYk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM6PR12MB4561.namprd12.prod.outlook.com (2603:10b6:5:2ac::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Wed, 1 Nov
 2023 11:43:51 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::7e54:2e35:593c:80a2]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::7e54:2e35:593c:80a2%7]) with mapi id 15.20.6954.019; Wed, 1 Nov 2023
 11:43:51 +0000
Message-ID: <ad19902d-df77-49ef-9dd4-e846461fb8bb@amd.com>
Date: Wed, 1 Nov 2023 22:43:41 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: TDISP enablement
Content-Language: en-US
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <jic23@kernel.org>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <20231101072717.GB25863@wunner.de>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20231101072717.GB25863@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::8) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM6PR12MB4561:EE_
X-MS-Office365-Filtering-Correlation-Id: 72745a1b-9797-408b-d694-08dbdacfd1ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ToFGUoJPUQE5wgHhl5M17BQledgW5Y9kIDVhAW4aD8jLBANooi75DAmMo+c2xJ491e4cOKN9VqfqfHrC3o7IGgHv/DVxxylacu0qr46Sy1EPJig4GVSrddRB0Dvg/1sH+tZ1behrj0OLRWNUNM/Upbu7N3fZQTC/b6ycLkE5YulVtCWjcdBWwl41eaS/nDPdMMQsM42mO/AROa3CpmpMUqbvAnZy0s1lPW7ygQoBcyxZ9rtbjLcI7v7SH1s4+xshbg6GS/3M8cAkrecX7yTtak4FSSo89xs+t2rV7zf/DFiZYOKukPQ5Sy1/X5aNFI3PntsXP4fTPaNrpdLX4XCEKcL/TJLKsknJ5Ziz3Vtl4ymlYx5CkUftQRD+eBVcw3ibAPSoZVp3ao5rigFijta7g+KYtkykwMdXHc33fIeWKpO7Nxy2EGeyhpLA3P4/z2ShGZUJhrMTFH2I9b71vxBnnS+6SteEve4gpLrKEqcsp3G+zSoKXHfU/ZIkY062EalHrb3EhbgFi+eu41X/PQt1WNn4ZUbj09pbh3iqvjKK3fDN7YJyq0o9D1TX65+tWCOq214tRK553n0oA4ILgglDFmr2p2gBf609jYZkthhB0JmsFQS2pSmKSotOA+89FH0qBI8rlTiDwKxEz/o4Z3DwPQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(136003)(39860400002)(396003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(36756003)(31696002)(26005)(6512007)(38100700002)(2616005)(53546011)(6506007)(6666004)(3480700007)(83380400001)(478600001)(6486002)(2906002)(31686004)(66476007)(316002)(54906003)(66556008)(41300700001)(6916009)(66946007)(4326008)(5660300002)(7116003)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlZrWjBVeTJ6Z3lnblRuRFNJTXNXeFAzWjJGTUZ3YWJRRmRtQjZtem94VDNo?=
 =?utf-8?B?UXIyY3VsUmJQZTdXNVM1NHFOeTV0bnlYRFhWTVBhSXJpRlZZb3Y5Rk1nMG1q?=
 =?utf-8?B?UWgvOTNxVWhmTnVJQ1VaNzlybmU3dmhTaW55ZlNFMlFacGVvaWxEREZQTlNH?=
 =?utf-8?B?VytRTTMzL1F4WFZMcUZlbDBySTcrS2MrdThZMHFyTHBBUStBamNuaFR0TXQv?=
 =?utf-8?B?Q04ySFpIRHhyVXBKMWowUlVwY0pBcDdZN1d5OG5mdTBXaXZ2eHF5NGdvR2hx?=
 =?utf-8?B?Nm1SQklQcjJlTFR1dnhuVkUrUVg3LzFWQlpqaDRZNi9jbVdKUUtUSzk1Njkw?=
 =?utf-8?B?U2hFVTVaaFgwVXVmZ1dFcjlIMkVSQ3htYXZoWG9lTVFrTVpFOVI3YWhhVkhC?=
 =?utf-8?B?MzdCcTNZanM5dlorOW4xWDQrd01qUFZDblhvRysrU0lSTEI5dEN6U0RyUjcz?=
 =?utf-8?B?Y1lHaStDZmI2eTgvK1VDV1FZelNPcWxtdEx5WDJaeXU3QlR5ajZjK1B6dmJN?=
 =?utf-8?B?MnpzZHZmVStZUEhvYkNqRCtkTTVDS1RaVlhXd284emVSSFBFL0tFUktveUxR?=
 =?utf-8?B?bm8xYWlGOFIzSUhrL2p5WHUydldNRmdpYUo1UFovTHhkWmhnUEpmbWZsOXVa?=
 =?utf-8?B?NSt0YWoraUZ3dGd4VDV5dUhlRk9ONDdkZ2FjRWViWlppSVlqbm5HRzBibTZq?=
 =?utf-8?B?UmVveklUazlBOW0xN20yeDJpVlROVGF1QWpzNFl0RXd4cy9pS0RsUnF5dStq?=
 =?utf-8?B?L0M1VkN0VGduRE5WaDBYdDUrMWFSN1FSWWxES2wwUWY1Q0ordWhDWDNGcU9v?=
 =?utf-8?B?YXhtZ2RBdyszMm5NbWFhKytWa0gvWGlTRzlralNHbFNQZTc2UjV4WVFKNmJE?=
 =?utf-8?B?OGN5Y2k1aUhEV2tGMnpnQVppWHgweDM3L3I0RzBXR1plOE1jSzJBZ05KYmhs?=
 =?utf-8?B?bWhjUkcxZ3phdld4YlA1Y2pwZTdvRlUzRG4xbFFyTmkvbDlyL25GUmpmdHg4?=
 =?utf-8?B?UlZNMlhVS0U4OGxpRWYwaG5rZEJtS3U2SDladzRkYnZLTmMwVjJpTlIyaW5a?=
 =?utf-8?B?Rkt4aDVYaVZzVTE2RmtFK28rQitFWEVNTmYzK2pPbGVNRWlXZFRNeENzZEUv?=
 =?utf-8?B?N3dHZlVtYVZHNXE3TURZbEhkYlJDK3VOZnBhWGliazJEZlpPa29YbDlxLzRN?=
 =?utf-8?B?OUc4WHIrWC82amhDc0Q5Ull0RWEvQlVZUTVxZk1xOXRDZi9heGdJcGlzWjFM?=
 =?utf-8?B?Wm9mNE1DTDBiTnVCMUdhdFhhV0hWbTlrdnAzcm1Gek1IYUFwRzd3eVFVODZD?=
 =?utf-8?B?VWRocHVSMDk4NHdmbmxkZUJZQWJWMHF6Ynl5RURDRW9waE5iR2VXWDJ3OTR4?=
 =?utf-8?B?VktjNm51L25ITDEyaFdlOHJuOWJNVVZEMy9oRURDam12UFFsL3h1dG9RWkpG?=
 =?utf-8?B?cnEwTnp1SEI5b0EwUkpZV1BqVVhIYWt2WVh3YzFZTTFCbktHQ1pQdS9jbHdU?=
 =?utf-8?B?dDFaZnRDcHpsVkhvbDFSUXZnVzRQUVFLdnN5dHJlUXVDeitvRkU2TG5mWXlZ?=
 =?utf-8?B?b25CK2I2VTh5NzRwc2xNbUdZTHpMQVNPTGI5cmY0OVdMdnRsdS9OL3FSNDB6?=
 =?utf-8?B?YmtEWEJDNnRYMEFKcWh3UnpQNEVYNGJ5MW9PVlVHaU1PY01IY3A4WWpCSERJ?=
 =?utf-8?B?WGx0cTVBbjN4aTArdzBJMzBkbHU0Qk1OMWROUGtiS05vYTJEYVE3WldFVGtR?=
 =?utf-8?B?ZXFqNW5SVTJjNVErUHVQKzBCaEJkRnJSWlZ5YXdWN0pRSUVGeXQ4VENJamhZ?=
 =?utf-8?B?Rm9vNlZwK0RrSzM1dm5ScFMzdlVNM2p2RmpzTDZBeWVkTDREQWxkVVptUHRr?=
 =?utf-8?B?M250MkxmRCtVSFVINGtuZUhQVURtdDcyL0h3MWxyaU14Z2tTeVhNdVJHQ3JS?=
 =?utf-8?B?SGJwYWNrUTJVR1E4YmR5UFJ0Qm9FUGI1bER6Qk5MZVhVRmlLbElLT0JzSXR0?=
 =?utf-8?B?Sy9va3VkL0drQkNvVGc4czgvSkFBYmJHTnRqUUYzcEFYRklMcERDM1l1Qk00?=
 =?utf-8?B?LzJDckM4dkltL0p2V3BBYjdrcC9KZmNEa0M0dmZMUlp4WnBXMmZzZFlrNkdF?=
 =?utf-8?Q?yRxIE4JHWBDenoo+gC6CgQIgV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72745a1b-9797-408b-d694-08dbdacfd1ab
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2023 11:43:51.7434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1+KFpW82CF5k3RJXrwpyCYzx1IuzqV1jZS9nzSTSRd7sunfbTWIyHY2OqzfRXy0G8IsUmt5kdOe3ZQD8YPJCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4561


On 1/11/23 18:27, Lukas Wunner wrote:
> On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:
>> - device_connect - starts CMA/SPDM session, returns measurements/certs,
>> runs IDE_KM to program the keys;
> 
> Does the PSP have a set of trusted root certificates?
> If so, where does it get them from?
> 
> If not, does the PSP just blindly trust the validity of the cert chain?

The PSP does trust, or "does not care".

> Who validates the cert chain, and when?

The guest validates, before enabling MMIO/IOMMU.

> Which slot do you use?

The slot number is passed to the PSP at the device setup in the PSP 
("device_connect").

> Do you return only the cert chain of that single slot or of all slots?
> Does the PSP read out all measurements available? 

All or a digest (hash).

> This may take a while
> if the measurements are large and there are a lot of them.

Hm. May be. The PSP can return either all measurements or just a digest. 
The host is supposed to cache it.

> 
>> - tdi_info - read measurements/certs/interface report;
> 
> Does this return cached cert chains and measurements from the device
> or does it retrieve them anew?  (Measurements might have changed if
> MEAS_FRESH_CAP is supported.)

It returns the digests and a flag saying if these are from before or 
after the device was TDISP-locked (tdi_bind).


>> If the user wants only CMA/SPDM, the Lukas'es patched will do that without
>> the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
>> sessions).
> 
> It can co-exist if the pci_cma_claim_ownership() library call
> provided by patch 12/12 is invoked upon device_connect.
> 
> It would seem advantageous if you could delay device_connect
> until a device is actually passed through. 

It is not exactly a whole device which is passed through but likely just 
a VF, just to clarify.

> Then the OS can
> initially authenticate and measure devices and the PSP takes
> over when needed.

The PSP is going to redo all this anyway so at least in my case it is 
just unwanted duplication. Although I am still not sure if 2 SPDM 
sessions cannot co-exist (not that I want that in particular though).


>> If the user wants only IDE, the AMD PSP's device_connect needs to be called
>> and the host OS does not get to know the IDE keys. Other vendors allow
>> programming IDE keys to the RC on the baremetal, and this also may co-exist
>> with a TSM running outside of Linux - the host still manages trafic classes
>> and streams.
> 
> I'm wondering if your implementation is spec compliant:
> 
> PCIe r6.1 sec 6.33.3 says that "It is permitted for a Root Complex
> to [...] use implementation specific key management."  But "For
> Endpoint Functions, [...] Function 0 must implement [...]
> the IDE key management (IDE_KM) protocol as a Responder."
> 
> So the keys need to be programmed into the endpoint using IDE_KM
> but for the Root Port it's permitted to use implementation-specific
> means.

Correct.
> The keys for the endpoint and Root Port are the same because this
> is symmetric encryption.
> 
> If the keys are internal to the PSP, the kernel can't program the
> keys into the endpoint using IDE_KM.  So your implementation precludes
> IDE setup by the host OS kernel.

Correct.

> device_connect is meant to be used for TDISP, i.e. with devices which
> have the TEE-IO Supported bit set in the Device Capabilities Register.
> 
> What are you going to do with IDE-capable devices which have that bit
> cleared?  Are they unsupported by your implementation?

It should be possible to call just "device_connect" to have IDE set up.

> It seems to me an architecture cannot claim IDE compliance if it's
> limited to TEE-IO capable devices, which might only be a subset of
> the available products.
> 
>> The next steps:
>> - expose blobs via configfs (like Dan did configfs-tsm);
>> - s/tdisp.ko/coco.ko/;
>> - ask the audience - what is missing to make it reusable for other vendors
>> and uses?
> 
> I intend to expose measurements in sysfs in a measurements/ directory
> below each CMA-capable device's directory.  There are products coming
> to the market which support only CMA and are not interested in IDE or
> TISP.  When bringing up TDISP, measurements received as part of an
> interface report must be exposed in the same way so that user space
> tooling which evaluates the measurememt works both with TEE-IO capable
> and incapable products.  This could be achieved by fetching measurements
> from the interface report instead of via SPDM when TDISP is in use.

Out of curiosity - sysfs, not configfs?

> 
> Thanks,
> 
> Lukas

-- 
Alexey



