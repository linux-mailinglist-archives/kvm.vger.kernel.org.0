Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63B72F7F02
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 16:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbhAOPH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 10:07:59 -0500
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:9825
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726105AbhAOPH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 10:07:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7+6XZg1Aw9Uu7c1Cx/oADHohBhLTowy53ATrDHSOJVcWlKsOgpJfnR8bfrADPSIIE3f/I/qQ+Wa5L+4tzFcBTvYgZ8JRmVbllZ53GTj6/bhuz+/rhIi1u3u+c6CCcwEE1sKvoq6IvEPc03+8UvInRhMTwm+3zDhHhyv+6PUWhyHYE9cDSOMWuiBmnabAlUba1hm3na/vNbH6rCs5vz+Q/GMAw8wffcsp8aBydZwRWEb3RLI2Z/0KsEguMaxrDhO//LTvAq6WFhApWksn76oh08iN6+h+u4qc4swmUCXETzqDXuIj6FtnOTbxWUpRtI261Z4O9oDK7yKGqhO7sG9Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymegdTiZ8Zl88tf8x5f2YiFcWILXHry+lnY2dF/U9jU=;
 b=eGTKFUam/TgUavocuUDA+vAbxfsC2aRMGvxrr89VUcTp9pGtdUzJuIMtBOOtByVHiIUlKntiHsO13iN4PtYp2yOs/jkJwUrYBdEGVh7s+DAXhD3GEcQbFgr2b6Sq4NeI4pCmoAhFPq0LrGva1lRAxNWNHwytxbjNiJc+fAASAZU4WCHFcSFB4/BMoRvOaT6454W0OB5pxF12gKrkjIwEPCVjFMsYTaqh9oEqFWYy49v5OZnp1rHWD7yMk2eDQjoXCprgsSgtisOFeCCFk8TzFIPD4XBPNK0YKcPmrBrYp7kiTPMi5KcqrkHztW3hjkEgl6zi408K+wDIGFIJSt+H7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymegdTiZ8Zl88tf8x5f2YiFcWILXHry+lnY2dF/U9jU=;
 b=3LvNO5LUJ7pDfp5YVg4xPTG36kndy/8TpQMtiaptSuk2wVXwi80QoaY0xdDrLwvDg8n3bOK/piWWr19HWZhTLeQCxvZr4ifC2BpMOhkGzVbm8LiRhqfwHhZDo4zrX691Ro1tCTIJq87UTcwBEmUtJJYtpolaE9j85NPdVxdlRAU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Fri, 15 Jan 2021 15:07:05 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 15:07:04 +0000
Subject: Re: [PATCH v2 14/14] KVM: SVM: Skip SEV cache flush if no ASIDs have
 been used
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-15-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <fa048460-5517-b689-3b82-a269e1ff8ea6@amd.com>
Date:   Fri, 15 Jan 2021 09:07:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-15-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0201CA0070.namprd02.prod.outlook.com
 (2603:10b6:803:20::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0201CA0070.namprd02.prod.outlook.com (2603:10b6:803:20::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 15:07:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 861a4c0d-21f0-4ad1-64f2-08d8b96737ef
X-MS-TrafficTypeDiagnostic: DM6PR12MB4297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4297A9108F39467032CBC0B6ECA70@DM6PR12MB4297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sF+IO/pC4YPEDPdHcm2Px4LjtfqAdaMsLYglwLYwakMBfyWFbBXZkt+gAr9udiHXiJYa/3VbwIb8jaKMrBhcg1CDg+AvBncVbTEFWUcB2Xjgw7s0SnaWG3XOBpgxlI0y2VXbh/d/x9rRv2ebHXVFdMKnkAKhditYJSewb9JGo4U9K/tzKmvhMdpj6qETRYCCeFjdMvd+14487+iCm4wSAjxh++VHtvpIkua2hr7X+/kT3VhmQ5PMg/a6sOsBI74YOA7XS1LKkDlKAPW3ScGoGBeHxqGtky5RqjFdz1UhswsfKSaCjhAXyg36/1sZMhz24NKSe0gYgTr6Was6n3d5P0XGRik4PqUsIDeKTJ5SV+xmO3zjLHlrzTwChRUTCeQwd+2jfD7MHkIrjfgH3DaAnPqWdjTUMLKtt7XDBdFS4Ty61BRVE7onwb/vw8RoyDRhX9Yx9/QbSEBsl69o2B/XmJFrbx8LmBGFTzFvHl3IayUnB1u2BVULUsri/DfnRN2T+ycSCfQf32qw18UUeQ7LNHQ5hLKGXUkDESY/oLxBiehMqxlVyO6u7XortoDLDR3zIowqVqKjj1OSS2WSqmLsSPDNMCFsEe1Lg76qtWn2Qpc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(54906003)(31686004)(186003)(8936002)(478600001)(52116002)(7416002)(66556008)(2906002)(16526019)(316002)(31696002)(6506007)(8676002)(26005)(2616005)(53546011)(6486002)(956004)(66946007)(86362001)(110136005)(6512007)(66476007)(83380400001)(36756003)(4326008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L2ttOGpZL210NGpEaVNoYk1RWGo1c1Q0L0lYYy93T2JJUEtkWkpKMmxWVGxl?=
 =?utf-8?B?NzNMa0RQWVFpNWUxOC9qa1I0REh4UlU1RjQ1cWMvbU1CSTJOdE4rZllITG95?=
 =?utf-8?B?RWFmK09rSmV6cTNQWmpyVkNtOWh2OE5mcEE5N01PVkNvSTNFNlp6RVNDTUxo?=
 =?utf-8?B?cTh0M3pPOURsT2xZMEtac2V6ci8vc2crT1VsNFlLWDBtYXJ3a0FTMVErUFJv?=
 =?utf-8?B?R3dMc3dCSXhPcVZNdkVvT2UxcVI1WHVMWG9nMWtUUkpPQkRTS0J4Z1RxdGpL?=
 =?utf-8?B?VmpzaWgxWlVRRzFVNFArM2tXWk1vTVpxc0dHNlpRdlY4OEozUjZxT2FkeWRP?=
 =?utf-8?B?YmpEdEtmdFN2SThhWGtBTmk2cVF2ekVkcGY2NEZsRS9wVkpSSmw5b0MwRlNI?=
 =?utf-8?B?TjZXUHB1RlpBRU5hQ1FtUDlNRUFueTJCd002dkc2Ty94MmpxWVFhc3NjeEtF?=
 =?utf-8?B?czBwZ253clBwbnZMVkZrM0dYb2VoMWZWNDZZU1c5YlF1cWhUWWk4Zmc2NjJj?=
 =?utf-8?B?TngwQ0lUNG5NOXpmcCtTYVIvYnhZUkhFWlQyZWYvenp1b1AxV3M5K3pMY3Vz?=
 =?utf-8?B?d1dPcmFyOHJLQWFrNlh0Nmt2VzVuY1VNck5Bd1d6YWNCVGQyMTNqZWVrZFQv?=
 =?utf-8?B?Umx3Z0RWa0phN1RERlBUMU9MMmVWQTA3dWVVMER0b0MwTlJjSEpmMWpjZW5C?=
 =?utf-8?B?MCswRFlyUWdYYTg3WG45c1psRzRCUnNEaU1qUFJGa2h6RmR0Ly9NaGVVYlNw?=
 =?utf-8?B?dms2M01sbHp3eEN3RUJaeFhuOGJJbkJpa3R3VWRlMXFaQVErd0taR0FkRHAv?=
 =?utf-8?B?TC9NWGUvZnBMYWYzSkx3LzRLS0hyeVJBR09zRzAvcm91RWtZdU1LRTUwZkpj?=
 =?utf-8?B?K3ludmxNM29IQjdSRG91OElWWHo4OHVmQUt1RTM4dUVsaHRLVVNCK0w4L0tF?=
 =?utf-8?B?K1paOXl4b0tlNmJ5MXNmSTlmN1RLa0g5VUJRamI5ZWxSZWhmTDJFdWhQNXRa?=
 =?utf-8?B?QmNGQzFsSm10VnNBblozUnFWakhpaXdCc2wzb2RKQkVTemRRMlQvdnlDaGcz?=
 =?utf-8?B?dXkwblVCZUZjTjNZakorbmErTmJvNU94dXNTd1Y2SzZCVzZlQVlOSHM2R3VL?=
 =?utf-8?B?YzlQQnE0WTdQeXRhT3NrNTY0dGVlc3NXZDJQRFhWTW5DaTVwOFhXaUZiaDM0?=
 =?utf-8?B?SVpmK0ZCRkRQMHhRRkVYSSs1eEdhZkdhcXArVFRVKzh6QW1EeTlmVTdVTjVB?=
 =?utf-8?B?a1dwNDErV1lzNWlFTVJQYk5rbXUxTWZ6RHFiZWpZTHd2UnVZbVdBQkpMenJS?=
 =?utf-8?Q?7PK9UWo/0HIfALU3Wm52riQnjWSrdjdNOx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 861a4c0d-21f0-4ad1-64f2-08d8b96737ef
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 15:07:04.7389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ptMxU51hN9eZoFaystsQWO715Om/jQEureh8iIElwSMXbGhUaey+ouHO8jYADvSTwGqvUMRR/QahwbKsYcY+2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Skip SEV's expensive WBINVD and DF_FLUSH if there are no SEV ASIDs
> waiting to be reclaimed, e.g. if SEV was never used.  This "fixes" an
> issue where the DF_FLUSH fails during hardware teardown if the original
> SEV_INIT failed.  Ideally, SEV wouldn't be marked as enabled in KVM if
> SEV_INIT fails, but that's a problem for another day.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 22 ++++++++++------------
>   1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 23a4bead4a82..e71bc742d8da 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -56,9 +56,14 @@ struct enc_region {
>   	unsigned long size;
>   };
>   
> -static int sev_flush_asids(void)
> +static int sev_flush_asids(int min_asid, int max_asid)
>   {
> -	int ret, error = 0;
> +	int ret, pos, error = 0;
> +
> +	/* Check if there are any ASIDs to reclaim before performing a flush */
> +	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
> +	if (pos >= max_asid)
> +		return -EBUSY;
>   
>   	/*
>   	 * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
> @@ -80,14 +85,7 @@ static int sev_flush_asids(void)
>   /* Must be called with the sev_bitmap_lock held */
>   static bool __sev_recycle_asids(int min_asid, int max_asid)
>   {
> -	int pos;
> -
> -	/* Check if there are any ASIDs to reclaim before performing a flush */
> -	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
> -	if (pos >= max_asid)
> -		return false;
> -
> -	if (sev_flush_asids())
> +	if (sev_flush_asids(min_asid, max_asid))
>   		return false;
>   
>   	/* The flush process will flush all reclaimable SEV and SEV-ES ASIDs */
> @@ -1323,10 +1321,10 @@ void sev_hardware_teardown(void)
>   	if (!sev_enabled)
>   		return;
>   
> +	sev_flush_asids(0, max_sev_asid);

I guess you could have called __sev_recycle_asids(0, max_sev_asid) here 
and left things unchanged up above. It would do the extra bitmap_xor() and 
bitmap_zero() operations, though. What do you think?

Also, maybe a comment about not needing the bitmap lock because this is 
during teardown.

Thanks,
Tom

> +
>   	bitmap_free(sev_asid_bitmap);
>   	bitmap_free(sev_reclaim_asid_bitmap);
> -
> -	sev_flush_asids();
>   }
>   
>   int sev_cpu_init(struct svm_cpu_data *sd)
> 
