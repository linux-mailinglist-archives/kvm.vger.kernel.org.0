Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D803F0AB8
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhHRSAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:00:55 -0400
Received: from mail-mw2nam08on2046.outbound.protection.outlook.com ([40.107.101.46]:33733
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229448AbhHRSAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmBeMUgtk1HssCp63zGXEA8A7vSWZPfesNfXb3Exfqf0iSZzsjW2ak2c1ZV3OROzAutyfNC55FeeHeyw/HjH4JU/gtlMUZGcaGjWWHaEl0tmahoETAPc3m2XPR/75GS6F2m8HZGYqfvXK4W5rzF3OfUvgYdJorcP8kICOc3l2k/W0Qtk5UJXEsqqCPX/0LtPmZxkmYRuFYBqacND+Bn3ZTF2X2u0PAbMjx0GEqpT8HQWq7waQQ3/5Ikp0dGo+Me109r+O+JYwFhlHx2wL8+9tiXiEvz4Z188fq1V71KKOQ75oGEOKajTjsS0rC03sG6TMBfvv7tD5FyuINfzSSdwjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoHf+T/sN/WPPAIVTDABzMzeSEAAgY1DxZiTkeoQK/8=;
 b=YO1t/rFOfVX0SOgxRWDWlsuAEuBsFeYV/1x7OiejMc01WxqZbVnjFiQYtQIIox2+5rgK9wqUZeoLXakqsWHo9ZUarV4b0I1oo46Vtq2duMfeIOlXE47VA15X1imXOAvbR/FJWQcDm/ZH9gBrJAe79pHw+0Ug+PDnIp6fya/z0DPAiSkwYyKWtWaSeaMk0HtCtcxAYJ87ihqcgqGgqCZTgs7g8ToHKge3szk0Xp16ge/SmgJ40VFPsR4UCco4q3PSKRps/dh/GoIkqnpzceTxRG3naWM2lbTPbcoEOgjqEQAYlesRPCN19CCeI68+rYMVImWpEs9ojf4fsl4PsL3fGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoHf+T/sN/WPPAIVTDABzMzeSEAAgY1DxZiTkeoQK/8=;
 b=eFFbHX/p3j8l+8NykAH23OGsa/Z9Fq6pHd+SDSHYXvjGTlY1A+JjZvfoIIzLusD5HW0Bi+AcZiUuy4SV1DskGJVOrct0zXxzKppRkDBpcG24mwO08TAO1eLLnqNeYwVFYCy/HQVMB151APr5kThv1HbcjRBQfvhK6E8RPhwMH9Y=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5200.namprd12.prod.outlook.com (2603:10b6:5:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 18:00:17 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 18:00:17 +0000
Subject: Re: [PATCH v3 2/3] KVM: x86: Handle the case of 5-level shadow page
 table
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <20210818165549.3771014-1-wei.huang2@amd.com>
 <20210818165549.3771014-3-wei.huang2@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <49f37adb-973c-aec6-9b9e-30699113af18@amd.com>
Date:   Wed, 18 Aug 2021 13:00:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210818165549.3771014-3-wei.huang2@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:806:122::16) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.241] (165.204.77.1) by SN7PR04CA0101.namprd04.prod.outlook.com (2603:10b6:806:122::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 18:00:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58425d5a-9d5e-4ddc-9e3d-08d962720934
X-MS-TrafficTypeDiagnostic: DM4PR12MB5200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5200DF548831DD257B058253ECFF9@DM4PR12MB5200.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xtbHq9EaEyPiilQgMWV3QCvfULjBrlh0EGQMyEleDl9hrkRvbgMT6OQLVw/v+q2Nv41LG3ZGk2A8MDPcVWmVYcc7vErVXYlCD9oKC1lKQo054z4E/NH6ZWXT/fFPOD154rGIa38tZtZFddgVKiwhUD3gtwa6mYU32AoM1Uubq+PJi5YHH0A5MZQSi8d9LkTKndeZzm0bIU5w2h7qN+Zjl+BYq605DhcjQifJctBqQd0PgzKf6Eej6AVn8BsqoGTX1O7W3+rea9zGCxpHAHvePxXDPNF/HGGbqNVtJiBuYf8fhDE8qzR6aMoDSJGlVQsiwP8qtjDSACX3UhZYPfZ5yeIGcTpf7SN29T+4ID4n8TbAiQ50NM4i06Sr/n8ZA5FYvm6pnaO1R6ROCQd/t0K7SqcNJQo5atDJlwrk2ytC84RYdPwjXpPGO6OQQvkasUlfK08kZKtzZorzJY8KLaEnWav4hOL52BOZD1C7b6zcUotaWyrJslwhQXccLNP8XRHk2FrTiDvtJMuyOxD3EXpmZ2qrKZpN5K5uvU9U8joxe9u0TNI3cZfeAfaTMRxaGHnRjuAFhC32fyNF5iLbzSJTtY3Z8tCEBUPCPCae0TDH5fy9QN34F7BRpE6uTgeMgwr5Aww+STtZYJ2jWbocKkhBpECmbdnfujx9f7R3zC4M2ViM9tUhGVSPYASHpBnJPQehsJNhZwcBlckE76JHx2lfSun0ukRB6/gTE6qng0Rhj/rx9VM6b7AvnPNP2lUp5uFl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(83380400001)(7416002)(8936002)(38100700002)(53546011)(86362001)(186003)(26005)(4326008)(2906002)(36756003)(316002)(956004)(66476007)(2616005)(31686004)(66556008)(31696002)(66946007)(5660300002)(6486002)(8676002)(478600001)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkRYRTVvRW83RnlNVFExVUZkakVlcXExUXlKWlNTMjZJcGY5TTR6WmlYSFo4?=
 =?utf-8?B?RGQwUlI0eVZqRzV0VmpndlIwelU2MUliU3N5M2I2TUUvTit3R0s0YWtTT3Jx?=
 =?utf-8?B?K1VTVnhBUkxKK01SRmJFS0dudEp3Q3V4QlFoUjUxMkp5akxjdm85aEpZTDM5?=
 =?utf-8?B?aVgrRXgzWGZQaTAwNE9wZTJXVFBsUnM4TG13UVJSS1FhWWJkbStjR0h5UkdP?=
 =?utf-8?B?L3pOWTlrVUlrZUVuendLaUM0OTlva2R0bno2QkNybE1ING1ONFJLZDJpSXBR?=
 =?utf-8?B?ZUJHMEdIS3dTNFhJWVovdDZsTXdPZUdBbjhVRzZZUHBUMm9XOXZOWVlTSTNR?=
 =?utf-8?B?T3E2UzlZYURSMy9aeEEvZWJWN0ZQcnQyVGZpcjUySWZ1SlVaMmc3SWJRbXFk?=
 =?utf-8?B?L3FacmtDd1cyZURrUlNJSFJnV1N4MmtuOSs2SEFGbm9idHEvOVh5b05RVVQ3?=
 =?utf-8?B?MW85bThKNWpaSTZGYkxjYkI4VmdFNy9nNzY3NitBZzJNK2ZLV0VFY00wWUlI?=
 =?utf-8?B?UTNLNzBibFFVUEovU2lyNXlBVjcycVUwNkxPc01PL0JaNm5ZRlFDTFJ2bFRk?=
 =?utf-8?B?L1lKOTNiR3BSa2ZSVTBzOW1TeDNuYVV4K0ZNeFNnTXoyNlpBeVlBaTEyZWRj?=
 =?utf-8?B?b2x0STNqL21xR0ZmM2V0TURzcE1VaVFadWlxMWh6OTNoME51RUJYVFJybGF4?=
 =?utf-8?B?MStQOVVsRFVibDViZHM0V1o3aGd0WW44MnJnQmhtdjhGaStEc1g4RE1GRThU?=
 =?utf-8?B?SU1pVGl6eXJqaSt0dU9FUTJMMlZQTSt4NWdoa2krSXlzSTYvZlZKUlJHTG1o?=
 =?utf-8?B?MlZ1WTEyV01GakdibmtjdkpUNXVITjg5ZVpDcHNWaFk4ZUZGeXl3cy9mVG5F?=
 =?utf-8?B?YndreUk5b1dsYVRTeEtrN0pMeGRKQ3hTOW5YY3NFUE91bkg2RkZoeENrclZo?=
 =?utf-8?B?V1JtZkZIeWdnTXNWZmY3K2ovTk01b1ZSeFNEM3Z5Uml3cnFRZ2VsWUpJajVH?=
 =?utf-8?B?TzZkNTVMeVVMOHR5UFdqN1JxWjB0WElkZ1dkK0IrZU9obzZ1WjFha0NxWVMv?=
 =?utf-8?B?STk1YzVRelhRcWs2ZTBIL1F3dEt4T1ErZVlyNzJXeUEzOVVXbU9MUHVIbEox?=
 =?utf-8?B?TFM5a2RjenlsaDIwK0RMNWhLK0N6L3M0UnFDd1ZBZTBqdHZkNU94ZmloSnVQ?=
 =?utf-8?B?TC92ZzhvOW1uUzlKR0x2VkN1Kzd2TnFvN0Qyc2VzeStkZ0hPTEVsdHVRQVJl?=
 =?utf-8?B?eDN3Zk5XTW8vTzQra05CcVYwUUgyZUpubWlLMGpIcWpkMHlUbGoxb0xML2lL?=
 =?utf-8?B?ZlRGTm01eWxXdy9aZno1eGM3Wnk4bXdlSXRBUWN0L2tDOTBCWTArczR3YW5j?=
 =?utf-8?B?UmtGMjJjcTR0SnFXS1AxYWtGNDRQRk9pODhJQTRkRlY2WjIrZ1lEbFRRcnZH?=
 =?utf-8?B?QW1XMlRaVjNLZWp6YUNITUV0QnhTOFFQUGFXRis2K1E0aTRnYURoT0t5QlBy?=
 =?utf-8?B?QVc3ZlkyQldUWkdUYXQ3VmlwUUh3NHRqYkpWaGNvUjQwc2V0VG9OMVFMckdl?=
 =?utf-8?B?ajZZTVcxb0dFS3NidGZYTHlJT1ZMenNaWUN4cTYrR0dsanpLc2RTTEtoYmtr?=
 =?utf-8?B?WXNKMDJyS3hZWXVGd0hmMXN3aFNodlBEZUt2bG5ENk12UTAxd3dUekpuelUv?=
 =?utf-8?B?eHpqVEdqZmhuQ0R3VVhnS3BtVGlycE5ONVJQSjkyM2xGb2N2dzhtN3lNVHBz?=
 =?utf-8?Q?gcj5jrw/buhhbv19XIxZNrbpOjqbk+1H8WOZ6gP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58425d5a-9d5e-4ddc-9e3d-08d962720934
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 18:00:17.0858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUj2y0D9+l2vpI27uBPZArhWN2MkltA8196B2QHCEKnn6VgiAqQZgTCXsk1AcrOCL+mKfbC2VEIAKXWX7IzmvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5200
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 11:55 AM, Wei Huang wrote:
> When the 5-level page table CPU flag is exposed, KVM code needs to handle
> this case by pointing mmu->root_hpa to a properly-constructed 5-level page
> table.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---

...

>  	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> -	if (!pml4_root) {
> -		free_page((unsigned long)pae_root);
> -		return -ENOMEM;
> +	if (!pml4_root)
> +		goto err_pml4;
> +
> +	if (mmu->shadow_root_level > PT64_ROOT_4LEVEL) {
> +		pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> +		if (!pml5_root)
> +			goto err_pml5;
>  	}
>  
>  	mmu->pae_root = pae_root;
>  	mmu->pml4_root = pml4_root;
> +	mmu->pml5_root = pml5_root;

It looks like pml5_root could be used uninitialized here. You should
initialize it to NULL or set it to NULL as an else path of the new check
above.

Thanks,
Tom

>  
>  	return 0;
> +err_pml5:
> +	free_page((unsigned long)pml4_root);
> +err_pml4:
> +	free_page((unsigned long)pae_root);
> +	return -ENOMEM;
>  }
>  
>  void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
> @@ -5364,6 +5377,7 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
>  		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
>  	free_page((unsigned long)mmu->pae_root);
>  	free_page((unsigned long)mmu->pml4_root);
> +	free_page((unsigned long)mmu->pml5_root);
>  }
>  
>  static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> 
