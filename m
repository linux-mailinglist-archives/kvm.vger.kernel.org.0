Return-Path: <kvm+bounces-10793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D0AC587006E
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 12:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F04CBB2304A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 11:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378643984B;
	Mon,  4 Mar 2024 11:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oEVpa2VL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92A61B965;
	Mon,  4 Mar 2024 11:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709551832; cv=fail; b=GRwAUrqNie6SZ0137up2K8Hgd5HgZilXiO9L8bWqygUOpbOUsGcGYicaUSUF+kmPFaWocTGRqQYq+BIGU7y5EwxG0G55ZnB+1BaBAoCy/ljbVgV3NRvKiC3iT3Qe1/IOMWuO+Rm67RWcbDrjuQ42c8s4NvPUFUyKsnCikZKbyEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709551832; c=relaxed/simple;
	bh=PJOcwZ6Y4aMHBOi54hyxUlLbskT6r9CHj6MHH++stfc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=swjsNlLt6xGZDYERrpBxndnr60HdeLJl6nekS57j8jSybuKiqp8MqEC320LCZmzQqK/GWrN+rxaHqr22+z97s4LmnhF7ZAArAL82rl3JJFXT0yOUz2NCaS8qLErtxVzsmXVcWWK3mUGJP/4m/RX8jYAIxCLcLAChFqudF7PrYwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oEVpa2VL; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsqwPy8qyfQFKgrrJ7/bWRGBT678c/LBI/5XRS87nZN3scUT/ViTdponx7HBqBBxEv8BriYpZ5rGnOEfY8c9JgO+grFAaxU4sOrGxpm9FF7/8zrjUQdGnARlZDDoUF/sgzitp2u8VybxUJtZcG/SkFYcnoq1D7HnE7m5/xaBpShSCIP8ro2h9Nt0DDakF7mQcX1lGzpf7NUJ7eETmxmY2zefya3DKZkF5hx2wERn2h34trNUxigO1t9cbjyHGumtF4mHEuN8/6T+SCxU9HoNyPXkNbWiafZHeic7BMcF+beAlhRUNu47F31M3cgWOiQydqD0qOvwLqI/ezJXmzjdCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGzOqXNS+P5oZ+XLAw+ZBmGG8HcIzmV7IEKw9V7dNO8=;
 b=cb5Hs1TdMAopeMkI5KRmcJq/IDSWmhCHwMVYdLLZ0a9mAZUwcF1nu9U1TTHSrkBJlftBBCWyCvme65pmvXziv0NH5hBLI2004lxU2cRJdp0bW00GDfzm0JekA1yV8MoItcoFzWt6r0BunOmcjI4XwF3N91u2EP3wBt3ek0wfbAMkekHnotiIBmklzVjQaZ6BffbaO9gHacQM/mCbtk/lA3uRNx0re5FN1lAPqc7wk0U74PEs02MYZUtCULF6qAoZ2W6XwB3fDvuTtYCQRT9945tO79bI9zxulN1oDIDgum/6jVYG/C3YCDetbtzNWfGdVO6tvhtlqrQ9xsEZaAtVvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGzOqXNS+P5oZ+XLAw+ZBmGG8HcIzmV7IEKw9V7dNO8=;
 b=oEVpa2VLsX2IxXW6iaTFanoSu/2SQ9Ec/Xfzjgrc3HJi2T8deg8F/kEpoqkQl9plHqFJCRUq3p/tuNThrSUaig+FqOymYiFSVvy7e/BCAHG8//Q0M2p5uO3F/W8/I2EvPOmw/dMhLPK/yFwLs8E+g4WvjLfWPLJiSnJEbvX+3tU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9193.namprd12.prod.outlook.com (2603:10b6:610:195::14)
 by CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 11:30:28 +0000
Received: from CH3PR12MB9193.namprd12.prod.outlook.com
 ([fe80::9cff:98b9:1e88:d07d]) by CH3PR12MB9193.namprd12.prod.outlook.com
 ([fe80::9cff:98b9:1e88:d07d%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 11:30:28 +0000
Message-ID: <172bead3-6b65-4598-9d5d-a560da4b153e@amd.com>
Date: Mon, 4 Mar 2024 17:00:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] vfio/cdx: add interrupt support
To: Alex Williamson <alex.williamson@redhat.com>
Cc: tglx@linutronix.de, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, maz@kernel.org,
 git@amd.com, harpreet.anand@amd.com, pieter.jansen-van-vuuren@amd.com,
 nikhil.agarwal@amd.com, michal.simek@amd.com, abhijit.gangurde@amd.com,
 srivatsa@csail.mit.edu
References: <20240226084813.101432-1-nipun.gupta@amd.com>
 <20240226084813.101432-2-nipun.gupta@amd.com>
 <20240301104521.228f8e84.alex.williamson@redhat.com>
Content-Language: en-US
From: "Gupta, Nipun" <nipun.gupta@amd.com>
In-Reply-To: <20240301104521.228f8e84.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0093.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::21) To CH3PR12MB9193.namprd12.prod.outlook.com
 (2603:10b6:610:195::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9193:EE_|CH2PR12MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: 11f73971-0f98-41c9-af05-08dc3c3e7de7
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LY8K5bajm+hUMDonjnnqXBJKBsWEwN4PGdnhhH0EvL0zIYVGHa6D4TXKDgaaUFW12gvnZ9PU3zw+cU8IrtpW3vIQ73mYaXJ+mopSZyJBx901HuIcVQeYj62piq/TcIwOI0S7+95IGb9SyVVPY/0RZ107z8Kcix4RSNCiJomejXAVwDOvPMIxYNhDwo1IBLr0jMJeyOdhvK9tXO2Vb/rYfyg6/gTGviJH2ZsdJPHa2u9W/oFpd2WwNQCspEO5KIkNk1IhyagSFRvQPMqWuCATPCHKj/C6cPm06NvGDY0mWk4TiSms3JBrHrFUgwYLfw3Y05wvnIm6FdlGLzFAYSm7sovy6QZDCw6dMkJGo3mcEEatKe1nYOU331CXLRsqm0ezaVF/pNC2DjZIi4aHeKkr9/FeAgz6n68uUl0uHMbEJsZlqfbVdKylpBHXDWA1F6vl1aSw7yu7rt/3SPLuW9gZ+ot5spYS8oTq3YNO0T6wsOVWbCV9TOQOySBmWyxc2O6doTckd0osGWS5Ys3LT6gCFPrm5ZQ2EMsjsFv+NFDljqvmBhSV0q1EIYKFjdKzeXnLypmdCCH8aB03Es6I+FCtzNdhUWIyz4u1vKlp4/mnBtbjkEUiKY9+SggTL2iiyC7a9JAm/DGJx4SdJ0hz7DUBCFQh+l2wRByzqjS8Ct3AAns=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9193.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3FrUVhLL214RVcwcWpzSll0ZUE5M0wzbjdYeUtidzZyS3FGb3BpVHpwZmJZ?=
 =?utf-8?B?WmtxY01HM0tWRkF0N1Vsa294djJaZ01WSXlOMlJoeVpKUk13bDFjU3ZzQThH?=
 =?utf-8?B?WEdleEdJSUpkaUUxWThlSjl0VUlML1h4R2RVWkVwZjlIazYvaVU3bEg4VlNO?=
 =?utf-8?B?QXhieHVOQzZ5eFdTVEp3bkxBK3hFNXpoZ3JyYlNRL3NUYklxUkNZRERkS1RN?=
 =?utf-8?B?T2JoUnZNYkNId1BjamNUcXJQOHloVHFlem43YkJCTHhnMDRtTVRmSkxRY0VV?=
 =?utf-8?B?c0JQT1RUYnFtZmF0MkdEZy9xaVRrN2QwMHJiYkh1TzBOY2xRUW5WbmkzbVpS?=
 =?utf-8?B?dFRqT1lJZGl0QUU2SThIeERPajBrQzVGRGdqbkFCUkxjV0ZuOEMrWDlpZUZl?=
 =?utf-8?B?Zmd5L2Y4SkhneDVVUzJ4c0JaWVZ4V2U0UU9ZUzRtY2RvTC8yck9vUTlkdWtQ?=
 =?utf-8?B?WEtxbFg4K2dGay9zM1M4RXltem1jd29pb1crWG9uMDJNUEVZNUFTQzZ6dkZO?=
 =?utf-8?B?SU4vSEtBZGRFNzAzWEZGQlZ6WVY4ck1kZHlQUzJVcmd2ZGJIaXZWVEhkN21m?=
 =?utf-8?B?ZlBtazJZWW1FUURwR09mSU9IK3plbVdSNk5OUmpOeEpaL2NUR211NTNHdjVF?=
 =?utf-8?B?OUJRVkllY05BM2VvQVArT1k2TkpKZmNPMllnVGRISmwzT2Z4Slpxa1grYStG?=
 =?utf-8?B?ZGhDNTdrRDR4Njh4L0lXNVR4ZStsaU5lZWtEeDNtZ3NBaTlnRzU5QTRrc0kr?=
 =?utf-8?B?WEg0eHYycDlSajI5NVJTckkzRCtxaXdER2w0OWplSW9SWkR4MTA5MjUvK0Zk?=
 =?utf-8?B?MThXaTgzSC8vaVFBdFRZQUh1Wkhwd3BJaFBoNG5FVnlkUTE2Z0Faek5VczNl?=
 =?utf-8?B?LytBbE9PSWtRUXEyM2hXYlEyb2tRS2FXUmd2eUtUK0czZy9DMHB3Wml4NFkr?=
 =?utf-8?B?eG9NaXdvUFovQ3NxTlpuUENQckE2Y3oxT015MG55SmVOVlBIdXI0am4zUVl3?=
 =?utf-8?B?VjB3aVZ2eEphRkVDaXFRZzR2RUk5cjhmaGNucndjM1FkMWF3YzZvRHE0TWhU?=
 =?utf-8?B?Q3l1RjdveWNzWXFuVTFlUG0wSTNFV3pReDVhcFM3aitXcUZQVXJ6ZHVzNVZ5?=
 =?utf-8?B?QmVyYnQ2T2U5Z1VwLzU3UTdmd3JCM3ZlZFBVVXFnS0hlZ0x4VDdwSm9wbno3?=
 =?utf-8?B?TlFzdlEyRTBveE1jeStRNnRtOUw3M2prUFY5TXp0UkVRRmhPemZFSXVxd3p0?=
 =?utf-8?B?MExMR2x2aXZrZlh1TnVMMU9uUG4raXFwSk1oVG9hQVkwZTZQWXlSMjNocGh6?=
 =?utf-8?B?Zmo2WHQzTkdMbkN2VlBhc2NhczlkaXlIdlByRHJ1dkVnTDZLV25jYmpLMHlU?=
 =?utf-8?B?R3hqODNGeFhmKzZRS2Q2YVdUSVhSZ2M1dkdHWkgyVFN4SFIrR21MYTJSSSt2?=
 =?utf-8?B?ZDJYeVBCNVhaUklGV2xiTDdReVNhc25keGhMSlR2ZnBpQWZSYU1Od1pEdXZL?=
 =?utf-8?B?V1d0UHBpbDhWNzVsN2FrUnd0TWRmMG1DZlhwa1NZaDRSbjJCdlVoY3RJYVNp?=
 =?utf-8?B?QjdOajkxSVo4a3d4dWFEczZRc2JubDZYS1FsRHM2UkkrQndiMjB0aGcvOVgy?=
 =?utf-8?B?emE5cjgvZ2FORnIvUG5yQzJETEh1Tm9hY1lOTnNzUnFESEpxSWRhcU1Bby9r?=
 =?utf-8?B?SnB3OHE1bk1MVk1OU1YwalFqaUEybmI2dmowY3Jxd1dUN292MWZndmNsOWtj?=
 =?utf-8?B?d09NVXpqNEpqSnZ2QVJZUG1xdEh6WlhjTU9NMlFaUlN4aEg1eXBBZVZReCtj?=
 =?utf-8?B?emh1TEtSYVdMcmwzS24xNlhwK1Q1MlpRSFhUT0pWZHRSZi9XUGJGeWdaN2ZM?=
 =?utf-8?B?VitoODQ2cFFuNjEvbGs1eStRdk9mOXdhdHlZS1hhOXNnTXcrZmFVN0l6NFZU?=
 =?utf-8?B?b3VGT25VVTUzayt6aVRpaVZjbk9hMXV2OFpzVjREbEM3aVVBSEgrUTh3YTIy?=
 =?utf-8?B?QnZQR0ljMGkyakMxSHZ5c2xjTk40VURFYU85aHBnSVEwQXR3SHpEKzgxdWtk?=
 =?utf-8?B?dWhRTGVWMjNldndEZHovQld0TllOTTZIUGpJQitETjhFdFhweG0xY2VQdEhG?=
 =?utf-8?Q?lQWhyfTdTG426LQ5xusAWjzok?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f73971-0f98-41c9-af05-08dc3c3e7de7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9193.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 11:30:28.1733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /QYbm6M0EOjD9RhlxvWeeFNQsWq4kOXMK3t4yRxL6yS42qShEpYfjMBInn7z8jcl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230



On 3/1/2024 11:15 PM, Alex Williamson wrote:
> On Mon, 26 Feb 2024 14:18:13 +0530
> Nipun Gupta <nipun.gupta@amd.com> wrote:
> 
>> Support the following ioctls for CDX devices:
>> - VFIO_DEVICE_GET_IRQ_INFO
>> - VFIO_DEVICE_SET_IRQS
>>
>> This allows user to set an eventfd for cdx device interrupts and
>> trigger this interrupt eventfd from userspace.
>> All CDX device interrupts are MSIs. The MSIs are allocated from the
>> CDX-MSI domain.
>>
>> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
>> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
>> ---
>>

<snip>

>> +static int vfio_cdx_ioctl_get_irq_info(struct vfio_cdx_device *vdev,
>> +				       struct vfio_irq_info __user *arg)
>> +{
>> +	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
>> +	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
>> +	struct vfio_irq_info info;
>> +
>> +	if (copy_from_user(&info, arg, minsz))
>> +		return -EFAULT;
>> +
>> +	if (info.argsz < minsz)
>> +		return -EINVAL;
>> +
>> +	if (info.index >= 1)
>> +		return -EINVAL;
>> +
>> +	info.flags = VFIO_IRQ_INFO_EVENTFD;
> 
> 
> I think the way you're using this you'd also need the
> VFIO_IRQ_INFO_NORESIZE to indicate the MSI range cannot be expanded
> from the initial setting.  Thanks,

Yes, agree. Will update the flags in the next spin.

Thanks,
Nipun

> 
> Alex

