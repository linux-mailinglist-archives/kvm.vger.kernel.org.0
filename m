Return-Path: <kvm+bounces-1568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF467E96C3
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 07:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BE441C2089B
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 06:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F6E11C9D;
	Mon, 13 Nov 2023 06:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y4KkQhnq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECDDC8EC
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 06:46:50 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C4B10E0;
	Sun, 12 Nov 2023 22:46:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+2rgOO11qmayggvZS6S7MiRli8/jcCBCh8Hx3uqjD4wnKp0pmqumW8goBKixEflRA42ietdZmnsmvyaniCjlWOG1xXhcSzrsLMNPs8/83AFAqt2TMAJaZ3EyphFwsjoZ+YKThFmAutlNrNH7S6KodtY+f3Ll2+ZVsbpJVgHjcXsUVTYQxM7gkxobiOy7xtyCnLCKdVFTApL5QS/Qx0gpG/HNHc/29w92R5bquXwYH31y6A0qNrQn4jAbQwp6FzG4nbyXh5gS6P5O6rn32L4cFkEbzvxGVoNz8BzzVQrhFR8yYzc7YQj73qP0mEflpcniLyf8neb175iZZAYGg4ElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nCovrP4yoHyhw4r/Bbz/PvMX/YL7YyoEmjnxyMVABQ=;
 b=YXkCQm99KXV5VzmrVObi1w0OfAJI1jg5AdjJEmwiIUk2uj+aQmQY5SBuNb2PB/l5Yf/iC3cP6p9NrF2LC8/fRpvs58kU0GDH7r3YNeUdm8hkun5l6k/IKf3V6mZV5VsRWE6MwlBEtHemlsEwhyFxu4J4fxjB6BziIDv4Frz0/8KZ08YWL2rS+TBjuR88aYfsIuo/hv95/PAVfH8iVVpe3ApQATNolnAVbObl7jgFc8iWryWYmJ1nk3xb/ARFaORo1dJeBfcKj5V8ORM3GdJIKGC+kIjdTTf3Gmm/5HJ4UgxO7XsLv+Vd2xwg3T0jOJP8VXSYIe+hLYcbdRvAvdrXxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nCovrP4yoHyhw4r/Bbz/PvMX/YL7YyoEmjnxyMVABQ=;
 b=y4KkQhnqglrYgEobcZ7hu8lNjW50EYNao48R62P4M3Aa05OAmU5lF1baCvxzcLQd9z4IEqiEjoPnNTij4zWcPVlwmcc3HA0OMwYiW0itlZxhb2krXuXkqsLVFpoJQI1zu1pYrlTdTkt/Dd9TtrE5b/iIveYkSvbTlE+LOva7Izo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM3PR12MB9349.namprd12.prod.outlook.com (2603:10b6:0:49::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 06:46:44 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::3112:5f54:2e51:cf89]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::3112:5f54:2e51:cf89%5]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 06:46:44 +0000
Message-ID: <58a60211-1edc-4238-b4a3-fe7faf3b6458@amd.com>
Date: Mon, 13 Nov 2023 17:46:35 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: TDISP enablement
Content-Language: en-US
To: Samuel Ortiz <sameo@rivosinc.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-pci@vger.kernel.org
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <ZVG3fREeTQqvHLb/@vermeer>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZVG3fREeTQqvHLb/@vermeer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:806:127::29) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM3PR12MB9349:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f03b612-627d-4d57-a65f-08dbe4144c41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OmRwcsA0DIhZ2qXATSqgUN/8/oTDq1hmif3SZ5Oy+IqtlnDUP3cm7Xu5Fo7ZRh9T0vD6gdOLmEspypmn8Rjqld9Q7IkJyU4EZjC9JISVCJi9S7IKki3cMIXGOfJ/uIbpD719ONQeFhDJT0zLEMw4DWU/rpi4Im7JqcwQ3/1akwDBHcE3z3KFXDHndp5S6P20Hh58DRZfP6FASutYrb5QSbSyCXLLSI+Hf0a/bg6geFhgKAxxH3KNGcySHWSIz2taBPTHxyx4chfhnEtxiRRoXEjGkhq0hbFnnLLYKurJyZOKAHlBZCRaET1yZ+cJ6BWfRhXxxIj2bmJJ4lOLWz4py+4ol0uXjc180rDskW9WIILaVWnioC1dUa3QENx853N0cEU+8qnUUogo+KzNOTWwPaqHwbsQR0ponEoA+aQ3onjyZQc7QrMUGKCVL+ikftsjs/46wSDV2xdOcQAjz/jEJL8Hhqgy6oz6XTivP8NZFjLhhCoQz8QMIzLArEyVqfy+Xubr4o2lTn9EaHGgX3+MaVrtesPnhZiEphxzgCbJ2Q+MOhCjBRnC/ptyeyGoAnsJ9ozobOLzONumZVvsvgWJE35yL2ncuZdn2zD0d90Qldzh2kCkbIto8EOZKKMypmPgpNNgfrj7Cclj0k7naPFi/g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(39850400004)(366004)(396003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(26005)(2616005)(6506007)(53546011)(6666004)(6512007)(3480700007)(83380400001)(5660300002)(4326008)(8676002)(8936002)(7116003)(41300700001)(2906002)(966005)(6486002)(478600001)(316002)(6916009)(66476007)(66556008)(66946007)(36756003)(31696002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVZQMzdMcjJXVEhLK1Z2RHZha0hpT1UwdDdFd09yVzJUOW5Kd21hdWZSNzFJ?=
 =?utf-8?B?T1BhMG83NnNaL1lpZlRLVTdBU2pzTEE4dk54bysxU0lOMHVnWDFKRDY1NlpY?=
 =?utf-8?B?MzlNdUtlN1RDZiswRUF2Z09odDRPT2Q2TzVaQ3BDSk9WT29kM2VrMEdVditD?=
 =?utf-8?B?NlBVd0hGSU14OTBvSXUvbG9YUmdMUjVuNWJQUm1Ob2pQSHpMYWxTTTYwVTRz?=
 =?utf-8?B?WEs3S3dBczYrZDlIdWhDeVpaS0d2MWsveTgvL3NvcSthYnJZR2g1RFVCZjJS?=
 =?utf-8?B?dzJuVk41U0llRHBTdGhqam0yaDF0cFIyc09PQlBWV1FEVWR6VHRIZk41QVQ5?=
 =?utf-8?B?WU1pM0hzZC9tNk9GMEZHaEdsNXhGbTN5MVJMaTlnOWd6ckhCUThUZkROejNT?=
 =?utf-8?B?N016b2o5N1Jqelo3Qkd3WGxjLzh1NDV0R2xBQ2VkSEZXemN1TzJHV1pIQkQz?=
 =?utf-8?B?cG84NWdHTEo2WlFBdUVRY0ZKSFJSSmhxbXd5Nlc5bEJXZys5bkxmL0Z5Y2ZX?=
 =?utf-8?B?alFwQ21uYmtxcFRSbElZRXR1NzQ4S29MamYzcG5POXJZTGl6M1NWUkFYQlht?=
 =?utf-8?B?bE5wODVrWXFEMmQ5MzAvSlpMRmpNQnZKNjU1dm13ZjBHY0dNUnlzV1krMkJo?=
 =?utf-8?B?WjZwR0NGZTNkQnVUc08ySGMrVTVPNGkyMitCS2o0TmRRc1QvNnQxV1Y5Q1FR?=
 =?utf-8?B?eFNJTHdLQjA0T0c5VjdOU0FwT0R0TjJDTXliUGc3dnRuajQyazNJSTZMRDJQ?=
 =?utf-8?B?Mm9WeDZlOFBXL2t1K0NRaXd5NjY2ajNOeXZ0OWVHdnpGaE14LytFQWFrc3ZW?=
 =?utf-8?B?WXhkS0F5Ny95MGMvZUNSNTlkUUhVNWV6OHFqVTM1Wk5hZXQwdGpvY1ZhSzRC?=
 =?utf-8?B?ckJYakpiRWxJQkhvRWU1RTJoVEk1V1c4S2VVd255N1cvVkttQWpGZ1N0V1Ny?=
 =?utf-8?B?VDl5djI0WndlSmNiSHZjclRqVTk1RjFrMzJoVU9udDVtUGE0Y1h2cjc1dU9Q?=
 =?utf-8?B?SWh2Y0dGdXphSTVnRU5FamkrVmdpMzVYUk1HdkZrNTYyQU53UEYxMWtUWWlY?=
 =?utf-8?B?LzJaR1NoWUZQQWJhWG94YnY3ZHh4SklHem41ZWRzREpEMVJYV2IzWVVmdDhx?=
 =?utf-8?B?dTZLd3k5eUIxQnM1UGsrTGhLMHFGMjlnNGw2TGRFQTlFdXBYVjhWTW5jYjVh?=
 =?utf-8?B?OWNGRHdHaHArdTFTVmFJcmlPN3FmbGljU1VMTzdjU0JMZjJqUHNBU3IyMVFU?=
 =?utf-8?B?T3hpVDRITXdlMHZ1WCtOMVJvOGZ1RHJKUHkvdzNPUFJpYVEwRGhFUU5pUEdF?=
 =?utf-8?B?ZDZFb3Z5RjVwQ0lXZDdUQ0FjSmJMQ1pYUTdaWkVXTkVETzgvMGVxUExVSTZl?=
 =?utf-8?B?T1lhMmt2Q05qSDFpV1FsUkVJUTZRVXJ3cXRRVThJS2dISURpWk40SFlyNk9D?=
 =?utf-8?B?WCt5Z2hwYXNxbDVFa0V4YmNZMmg4cGVJbGtlbTFwTkR3eGRTZ1V4cmJySDZQ?=
 =?utf-8?B?ZXFiOWF2eVh4MHdXWmpTVlhPT0ptc3dYVU5JTzZ0WEs1alN1Y3ltY0hGSEFO?=
 =?utf-8?B?UE1QK3JBbm14N0JOQUpkc0Nrck5KL1MxMGhnR052bnFuWldpTllaQ3RmVVdE?=
 =?utf-8?B?ZzJkQnJLY04raFNONGNIaVNxSGZBV1dBTHYzTG9WUlljM1lTQW9YWjdlemxG?=
 =?utf-8?B?T01ORTVEWGRuWTQzcTlEaUpjT0hyam9rcVBROERLYmtiV1JaNytlUmV3L09D?=
 =?utf-8?B?M2ZZaVZvWnUzMTVBRjNSRjUyMHhrTndLejJQdW9CdXpNR09FWnp6aitkZmp2?=
 =?utf-8?B?bzdiVk5Pdmk1dktwSjZhM3hYUlpFcStENFE4NVRQeXJBQksweE9YUWV3ZWNv?=
 =?utf-8?B?dStPTmpvMU8wQzBoa3J6ZGxYQzk2OGR3ZWFodDJNNS9EbDAzZnl0c1dyVU1w?=
 =?utf-8?B?TXFtbXYzdnBEZVNxNE4rSFpDeXphUUhXdC9rUCsyMjFMVzZNUDJjRU5WcFNH?=
 =?utf-8?B?V1FCQzJqVGRFbEZKNVp3aldCZ2svZ1daR0pleHpVUllVMEZKLzExb2RIdzVv?=
 =?utf-8?B?YXptZ1ZrSDM1VWxUZnVoT1MrQVQ5QVVxaHNvMjU2QnVYd2l0NEdjQUlOd0Vk?=
 =?utf-8?Q?6PeCxs0/IMpd/y1dUpL/zzTkv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f03b612-627d-4d57-a65f-08dbe4144c41
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 06:46:43.7596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xn2cgJQiW7OEJzGGgnrYbujKK+g8JgzKFG+E1YCNviqNvoDq/WqM4uxitxIoM+m1L1+66teEDNKL07EuyoIfCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9349


On 13/11/23 16:43, Samuel Ortiz wrote:
> Hi Alexey,
> 
> On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:
>> Hi everyone,
>>
>> Here is followup after the Dan's community call we had weeks ago.
>>
>> Our (AMD) goal at the moment is TDISP to pass through SRIOV VFs to
>> confidential VMs without trusting the HV and with enabled IDE (encryption)
>> and IOMMU (performance, compared to current SWIOTLB). I am aware of other
>> uses and vendors and I spend hours unsuccessfully trying to generalize all
>> this in a meaningful way.
>>
>> The AMD SEV TIO verbs can be simplified as:
>>
>> - device_connect - starts CMA/SPDM session, returns measurements/certs, runs
>> IDE_KM to program the keys;
>> - device_reclaim - undo the connect;
>> - tdi_bind - transition the TDI to TDISP's LOCKED and RUN states, generates
>> interface report;
> 
>  From a VF to TVM use case, I think tdi_bind should only transition to
> LOCKED, but not RUN. RUN should only be reached once the TVM approves
> the device, and afaiu this is a host call.

What is the point in separating these? What is that thing which requires 
the device to be in LOCKED but not RUN state (besides the obvious 
START_INTERFACE_REQUEST)?

>> - tdi_unbind - undo the bind;
>> - tdi_info - read measurements/certs/interface report;
>> - tdi_validate - unlock TDI's MMIO and IOMMU (or invalidate, depends on the
>> parameters).
> 
> That's equivalent to the TVM accepting the TDI, and this should
> transition the TDI from LOCKED to RUN.

Even if the device was in RUN, it would not work until the validation is 
done == RMP+IOMMU are updated by the TSM. This may be different for 
other architectures though, dunno. RMP == reverse map table, an SEV SNP 
thing used for verifying memory accesses.


>> The first 4 called by the host OS, the last two by the TVM ("Trusted VM").
>> These are implemented in the AMD PSP (platform processor).
>> There are CMA/SPDM, IDE_KV, TDISP in use.
>>
>> Now, my strawman code does this on the host (I simplified a bit):
>> - after PCI discovery but before probing: walk through all TDISP-capable
>> (TEE-IO in PCIe caps) endpoint devices and call device_connect;
> 
> Would the host call device_connect unconditionally for all TEE-IO device
> probed on the host? Wouldn't you want to do so only before the first
> tdi_bind for a TDI that belongs to the physical device?


Well, in the SEV TIO, device_connect enables IDE which has value for the 
host on its own.


>> - when drivers probe - it is all set up and the device measurements are
>> visible to the driver;
>> - when constructing a TVM, tdi_bind is called;
> 
> Here as well, the tdi_bind could be asynchronous to e.g. support hot
> plugging TDIs into TVMs.


I do not really see a huge difference between starting a VM with already 
bound TDISP device or hotplugging a device - either way the host calls 
tdi_bind and it does not really care about what the guest is doing at 
that moment and when the guest sees a TDISP device - it is always bound.

>> and then in the TVM:
>> - after PCI discovery but before probing: walk through all TDIs (which will
>> have TEE IO bit set) and call tdi_info, verify the report, if ok - call
>> tdi_validate;
> 
> By verify you mean verify the reported MMIO ranges? With support from
> the TSM?

The tdi_validate call to the PSP FW (==TSM) asks the PSP to validate the 
MMIO values and enable them in the RMP.

> We discussed that a few times, but the device measurements and
> attestation report should also be attested, i.e. run against a relying
> party. The kernel may not be the right place for that, and I'm proposing
> for the guest kernel to rely on a user space component and offload the
> attestation part to it. This userspace component would then
> synchronously return to the guest kernel with an attestation result.

What bothers me here is that the userspace works when PCI is probed so 
when the userspace is called for attestation - the device is up and 
running and hosting the rootfs. The userspace will need a knob which 
transitions the device into the trusted state (switch SWIOTLB to direct 
DMA, for example). I guess if the userspace is initramdisk, it could 
still reload the driver which is not doing useful work just yet...


>> - when drivers probe - it is all set up and the driver decides if/which DMA
>> mode to use (SWIOTLB or direct), or panic().
>>
> 
> When would it panic?

When attestation failed.

>> Uff. Too long already. Sorry. Now, go to the problems:
>>
>> If the user wants only CMA/SPDM,
> 
> By user here, you mean the user controlling the host? Or the TVM
> user/owner? I assume the former.

Yes, the physical host owner.

>> the Lukas'es patched will do that without
>> the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
>> sessions).
>>
>> If the user wants only IDE, the AMD PSP's device_connect needs to be called
>> and the host OS does not get to know the IDE keys. Other vendors allow
>> programming IDE keys to the RC on the baremetal, and this also may co-exist
>> with a TSM running outside of Linux - the host still manages trafic classes
>> and streams.
>>
>> If the user wants TDISP for VMs, this assumes the user does not trust the
>> host OS and therefore the TSM (which is trusted) has to do CMA/SPDM and IDE.
>>
>> The TSM code is not Linux and not shared among vendors. CMA/SPDM and IDE
>> seem capable of co-existing, TDISP does not.
> 
> Which makes sense, TDISP is not designed to be used outside of the
> TEE-IO VFs assigned to TVM use case.
> 
>>
>> However there are common bits.
>> - certificates/measurements/reports blobs: storing, presenting to the
>> userspace (results of device_connect and tdi_bind);
>> - place where we want to authenticate the device and enable IDE
>> (device_connect);
>> - place where we want to bind TDI to a TVM (tdi_bind).
>>
>> I've tried to address this with my (poorly named) drivers/pci/pcie/tdisp.ko
>> and a hack for VFIO PCI device to call tdi_bind.
>>
>> The next steps:
>> - expose blobs via configfs (like Dan did configfs-tsm);
>> - s/tdisp.ko/coco.ko/;
>> - ask the audience - what is missing to make it reusable for other vendors
>> and uses?
> 
> The connect-bind-run flow is similar to the one we have defined for
> RISC-V [1]. There we are defining the TEE-IO flows for RISC-V in
> details, but nothing there is architectural and could somehow apply to
> other architectures.

Yeah, it is good one!
I am still missing the need to have sbi_covg_start_interface() as a 
separate step though. Thanks,


> Cheers,
> Samuel.
> 
> [1] https://github.com/riscv-non-isa/riscv-ap-tee-io/blob/main/specification/07-theory_operations.adoc


-- 
Alexey



