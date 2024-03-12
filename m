Return-Path: <kvm+bounces-11670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C0D8796BB
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 15:46:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D185BB226C2
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 14:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D9C57B3E8;
	Tue, 12 Mar 2024 14:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bUPm8tir"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2042.outbound.protection.outlook.com [40.107.95.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253AB7C0B1;
	Tue, 12 Mar 2024 14:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254751; cv=fail; b=PZE3cncUVmfDUf6leuxMcoZablwBewvP3+cyvG+hVn6B+WvLHARTqulFaKjy61bxqYK2jS6NBaPRtTXPPEOyxFSZzleMEs617Be0T0YF193OItTlOgJBJWVodRsjhJZGvpgLKV5xt/6O0hp2ziCnDHicQpJFAoX/aD/DvnmQL0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254751; c=relaxed/simple;
	bh=puJDdIEvkqEQn2CWBJgWnTEF2ZcSuO/IG+V888yo08k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fyxhAunCXuX4h6MF8UKV33M6yFlbsEdjognPOYNNxZHwQfZ3BNM9qjOvyxE34wzAdjrjFGOT987MjRImBdZ2UAc1kIUyfjPVV4DANGhppk/i3HTjqn8XoWRQd1lfMlEgUAhkNNrBbza3r0ARMcR6aWeJHUzlINp+0uPue3m1cCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bUPm8tir; arc=fail smtp.client-ip=40.107.95.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IieHx9i3DEwTRLHGRwXj6RP2l7vJuLZRrJqFJHGg6vUJ54KD3IAbQTPo5URRO+YQkg3ZAVHg8f6zUnDukJ/fqarMsB1pX0+JqXJkKjHIPE+m2Hx1bRcSW/N8C6iDeRq5PHC+79mEY/S2wSOvITvq4Zk/aWMGumULAlRpp1/hbIAro/N4XcKMrfvS+dPeV4ie5zr5FcOCF+12h2QTPzbnUfBexP8TvKhaLSldzfXqIvcwVUievYIXJadTNTP3gTIVzIAoweF599V0jR4SRFwShypYTou+fZopE2nTg21BX1NCOzpVPx2Myh3nqa4djU+zs1gAaHyt989c3nh2nr9ZJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFwA1DRG3A8eIie0/JBAhE9tL9K7R57MOMu3LmXM6wo=;
 b=PjaiUR7NHncjTmRW2UeCVyeTN7xpUussi8Yp03iNaxg3jY837fTBEHQDU4AON7U6h2+G7ceL29HSfw7HGqY+1zr9qjfEHnO2MiXxb/a/iYlSe2gpQjNRgPh0kBux7dYf/N5TIcVt1AdJoSnIiM1dz26jO3mFNGrQVFjtvDLp6B5+oy8bqgk/6yANgtwTjr0C4et3jE6lPxAwi/KggDnxByO6bi6FadUFxsYHAktJ1M8Z++UsnrKswfVNIQl/RBXbr+/hBJzxlXKSAm/cUQ5XPQnk+6q/UUA2t9fzNM6TWSydsc4l1VZ/IzvszbPtWsz18OGiB2/BrES1RJhiwjDvew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFwA1DRG3A8eIie0/JBAhE9tL9K7R57MOMu3LmXM6wo=;
 b=bUPm8tirouZZz1UzL2v4UOFYdadr7mQehlRY3unDUeqwR+dZy0oqQBhXf1e+Fewar3MAqNJNIGxP64x1CkesDnbgGgm/5gLvBeeKypYef5RAVg9dVGQrTHC4XOgWG9u9F4ZZh6TSCsw+1nJNBa3P5aX9YYZ2wUYVSD9BtQaTuhY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH7PR12MB6658.namprd12.prod.outlook.com (2603:10b6:510:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Tue, 12 Mar
 2024 14:45:44 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e%7]) with mapi id 15.20.7362.035; Tue, 12 Mar 2024
 14:45:42 +0000
Message-ID: <90e5bdac-3b13-41bd-b1c1-981c35891f34@amd.com>
Date: Tue, 12 Mar 2024 09:45:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM:SVM: Flush cache only on CPUs running SEV guest
Content-Language: en-US
To: Zheyun Shen <szy0127@sjtu.edu.cn>, Sean Christopherson
 <seanjc@google.com>, pbonzini <pbonzini@redhat.com>,
 tglx <tglx@linutronix.de>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
References: <980607740.5109383.1709777666996.JavaMail.zimbra@sjtu.edu.cn>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <980607740.5109383.1709777666996.JavaMail.zimbra@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::16) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH7PR12MB6658:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cca1c7c-f27f-41d1-22fb-08dc42a317c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aOPjOSjdcOw3FhYUGbRxndzJZ7ND7JOLPz5n21JZvSHhSglrIW9cFQHtZyd3D2nKTxGempsRLYeAI5OQPKC1FYyLUXMd5hYb3xaRmTyhYJGI69hk8Wf7PsA3w4RS6Y5ZaAOdJV9b4VjdC6LoxBrW9vhyFCvDq713WkamNsrf9B1zR0YEHBfwUK0TPtfXPuTf2W88scP8Z6t9MQols8kVe+PTOYPzR8yydCKMWXFQwLef3JmBLKM4mVUH+wbEEfsSJWzl3OrBMpPIHV2qJKiBSyqbkUZZ4N1gmQyhh4hkx8kD34fgnZqrDRDI2mzsECLh4to2n63YYQnQlxy5rkUnLWqIo8kATq5Abbgbv2UetO+ILPEZauZ718h/Er6spMBzfH9gmUYG+SHEn5a3sxHKjDFcnCaEHAm6UO2seTw1vzwlOCO90Fi0C4iE4rjj8l2o1Xz2mDxnNkiNrSW0ChJs/dF/mbUiq1hMS/qXW6JaRIdFwuTBJwTtsYrPjbGQ3K9XHNyM1rX8HvzXIhYpwE3PMjnRmjG/yTze/SB7gPKIKAutA5yQzhKYCfQAcZ6QcQYhhz/BNk6NqanUBMyRav94jouWonrZ7xdXGbcg6/vDFW5N95Hh65T77TDZysNcLrzLcs0Mrfz42t9p8lcMh6fijzGlMbmklg5ioDxxszitoqY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2NTSVo5UXN0RUVLcGx2U1V6UXZtRFlZeTQ4ZzJ6OWFBNnk1U2ZKM0sxeFdJ?=
 =?utf-8?B?OUl4UHhCQVVRTVlHNnBYc0pQYmJOYnJWclI4aWUya3pHWnkzLzN2a2J6VXkv?=
 =?utf-8?B?UG5pem1Zc2NNWktyUVlJU1VhV3lGOW1uaTV1WStXd2lvaVVyRjhBUEFNQURs?=
 =?utf-8?B?cEowSXRyZUo5S2Z5cG5Hd2Y2LzBCWXVoMldTclBlOVBpdDJSL1dXcUdGVjky?=
 =?utf-8?B?WjZHeFdGMk03S3FpcFpiMmlKTE9WYmRNSFo4NW5zdHF4eVNjNk81YlpZbDRJ?=
 =?utf-8?B?ejNrMjJUK1kxRWs4b01VdnVMRDJDYWErMk9tV0Z5RHdacFArV29aQkg4RjRS?=
 =?utf-8?B?WWgwTUJCQW5NdWpzZGw4STFEUTFWc0Fnd1ZYSUpNMmI2MW9MME9Qc3RKWUJw?=
 =?utf-8?B?bTJGSS9tcEw5elJUVmFycTRBOHVTRG9BTzJyWXZ0Q2cvT0M1eEZuY0FBNnlQ?=
 =?utf-8?B?bVZUZWdEWjIwNlRmZW9IdTBMWmNCWExPNjFmb1A4WDhjMDhnSE15eE9PSEFz?=
 =?utf-8?B?QXdDd0EzV2FXRmJCa1JlMWRHQThSTUpVSjk4WFA4aUxmdHR2c1NsbEt1SU9K?=
 =?utf-8?B?T2tOUk9QY2dQMDNQQitud0JrR0hkYWxrbGNoWXhCOW1sam1rZnRKdVVla1Vm?=
 =?utf-8?B?THd5L0FyemdseUg2amdlR1dVNlJZaDREbTJqL0hXRE9Jek1EZjdNdXB1NzBU?=
 =?utf-8?B?eXl0aGFITVZRL0lwdGlUcVZYSk5KTUNRdVF0Q0d0dHZ2ZVpxdm1rMkFKYWUr?=
 =?utf-8?B?VzFFU1NyN01tWFAvY1FWZy9PejlrdVZoMFpKWkJRSUxoTTU4M0ljbXlNaXk5?=
 =?utf-8?B?TWJESExGeU1mZlNrdWljb2NWK05zcFFUM211aS9TUlZlV2ZhTHQrcFBBTzJO?=
 =?utf-8?B?RlpYaU5rM2o3THBzbW5zMm0wSGtUU3N3Skc1OHN4NlhOUTYyanNmZjBwc1JN?=
 =?utf-8?B?aUYyM1o1VFVINklkYW1ZR2huRmhMSGphNmNYK0QyWTVOM0dlcEFBakd5WFF1?=
 =?utf-8?B?WWFVVGFWZGpWdDZTS0tZdXRLV1d4eEU2bjgrVURuVmMwRzAwK0hKYUFrVys1?=
 =?utf-8?B?VUZmelpjMFFUeEFSOWp6RlVrdm05L2llNjNEeUJPcXJFbXhoeEpkNWs5T3Uv?=
 =?utf-8?B?d3dITjBKSWZ1RTRHSStkZkUxeTR3TDIrWnZwbERWdjV5WVN0amNDYVRoWkFp?=
 =?utf-8?B?Qmk0Nk5SbWV5RVZPSFdXUTFweGhZdndlVkwyQmZjVmZKWXJ1bUY3aWYvQk5I?=
 =?utf-8?B?d2NBeDVhMnp2VURBbDVQOXBYa3dXSHgwdXZkM25UbWNlTEFwM24yMmEwT29l?=
 =?utf-8?B?dUhNcFBMZ1hvYnhZTmdyWEJ5clkvMktZcko5d3ZRZ2JBcmlMa3BTUU9sYzhu?=
 =?utf-8?B?eW9BVVFUS2lsbElCdHQ5dzZuWEJFdkQ2T2dDRlJVaVphRXppLzh2dmFFalFV?=
 =?utf-8?B?V0JlMGNHdzNkamsyNDhHblk4azRxRm5HeXdSYVBId3NQODBvQStPWjkrZVdN?=
 =?utf-8?B?UXNLSzN0dmdGMGQvM2hiOXQyWDA4VmYzSjlhbWEyS3dsZWhIaUMxV3krbGVN?=
 =?utf-8?B?T2s2dThQNjJlbmNFeGdFUHV0YjY5UW9jTFU5bkh6N0JjYlJ3L0pjNEdic0xm?=
 =?utf-8?B?bGM1bXN6eVBaaWMwN1lWVTYrQmxLRnltSTRLbEYyY0pNVUhneE9hU1o0SUJO?=
 =?utf-8?B?eHY1NmF3UU1yQnNYUEs1TjJkVGtLRi95ejRWaXVlQ0p5bldiK1JzUFlzM3ZT?=
 =?utf-8?B?YktPY2U5WGlUS0xSUzgvTStJRGNhcW1SUlkxU21nbEJEL2s0SVJhN1RmMkNi?=
 =?utf-8?B?VVBiVlZaaTkyelRtS3RSUEVjWHRSUy9oTC9heFRVNEdPNitBS08rMTB5WU83?=
 =?utf-8?B?Wm16RVluakVRK1F6U0s5NzFtMzk0RGZRek41RXc3cXVVM00zZkprSkx6NjVC?=
 =?utf-8?B?ZDY1cGFHaldBOER0SVFWUHUwRFRZS0tTaE53SVVwT0pGU0VVWG5xcjNNbmtk?=
 =?utf-8?B?WkF4SzFqSUY3N2ZMQ3B0OXQyMEJlaEI0eGdLUjhOWDd2NTEzOWZVS1JBRHFG?=
 =?utf-8?B?Sm5aT1ZPbDh0emUwWlRaeVBtVW1lT1lBVXEvdnNIdVdxczJUbDlFWGo0Z3hM?=
 =?utf-8?Q?DV6cZsuSrI0kWIt9z/ITYhmMX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cca1c7c-f27f-41d1-22fb-08dc42a317c0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 14:45:42.6833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nGijVKbzlHWiRbFVGKH0luFk6MTAbDFvvPj/OxXtdw4BvKINVzz1GHmwO98QwCwPjD16h3uvEz6fBPR6BQ9EyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6658

On 3/6/24 20:14, Zheyun Shen wrote:
> On AMD CPUs without ensuring cache consistency, each memory page
> reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
> thereby affecting the performance of other programs on the host.
> 
> Typically, an AMD server may have 128 cores or more, while the SEV guest
> might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
> to bind these 8 vCPUs to specific physical CPUs.
> 
> Therefore, keeping a record of the physical core numbers each time a vCPU
> runs can help avoid flushing the cache for all CPUs every time.
> 
> Since the usage of sev_flush_asids() isn't tied to a single VM, we just
> replace all wbinvd_on_all_cpus() with sev_do_wbinvd() except for that
> in sev_flush_asids().
> 
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>

I'm unable to launch my SEV or SEV-ES guests with this patch (haven't 
tried an SEV-SNP guest, yet). Qemu segfaults at launch.

I'll try to dig into what is happening, but not sure when I'll be able to 
do that at the moment.

Thanks,
Tom

> ---
>   arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++++++----
>   arch/x86/kvm/svm/svm.h |  3 +++
>   2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f760106c3..743931e33 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -215,6 +215,24 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>   	sev->misc_cg = NULL;
>   }
>   
> +static struct cpumask *sev_get_wbinvd_dirty_mask(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	return &sev->wbinvd_dirty_mask;
> +}
> +
> +static void sev_do_wbinvd(struct kvm *kvm)
> +{
> +	int cpu;
> +	struct cpumask *dirty_mask = sev_get_wbinvd_dirty_mask(kvm);
> +
> +	for_each_possible_cpu(cpu) {
> +		if (cpumask_test_and_clear_cpu(cpu, dirty_mask))
> +			wbinvd_on_cpu(cpu);
> +	}
> +}
> +
>   static void sev_decommission(unsigned int handle)
>   {
>   	struct sev_data_decommission decommission;
> @@ -2048,7 +2066,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>   	 * releasing the pages back to the system for use. CLFLUSH will
>   	 * not do this, so issue a WBINVD.
>   	 */
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(kvm);
>   
>   	__unregister_enc_region_locked(kvm, region);
>   
> @@ -2152,7 +2170,7 @@ void sev_vm_destroy(struct kvm *kvm)
>   	 * releasing the pages back to the system for use. CLFLUSH will
>   	 * not do this, so issue a WBINVD.
>   	 */
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(kvm);
>   
>   	/*
>   	 * if userspace was terminated before unregistering the memory regions
> @@ -2343,7 +2361,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>   	return;
>   
>   do_wbinvd:
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(vcpu->kvm);
>   }
>   
>   void sev_guest_memory_reclaimed(struct kvm *kvm)
> @@ -2351,7 +2369,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>   	if (!sev_guest(kvm))
>   		return;
>   
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(kvm);
>   }
>   
>   void sev_free_vcpu(struct kvm_vcpu *vcpu)
> @@ -2648,6 +2666,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>   	sd->sev_vmcbs[asid] = svm->vmcb;
>   	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
>   	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> +	cpumask_set_cpu(get_cpu(), sev_get_wbinvd_dirty_mask(svm->vcpu.kvm));
>   }
>   
>   #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8ef95139c..de240a9e9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -90,6 +90,9 @@ struct kvm_sev_info {
>   	struct list_head mirror_entry; /* Use as a list entry of mirrors */
>   	struct misc_cg *misc_cg; /* For misc cgroup accounting */
>   	atomic_t migration_in_progress;
> +
> +	/* CPUs invoked VMRUN should do wbinvd after guest memory is reclaimed */
> +	struct cpumask wbinvd_dirty_mask;
>   };
>   
>   struct kvm_svm {

