Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6F12F6EA3
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 23:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbhANWwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 17:52:25 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:12001
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730746AbhANWwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 17:52:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMQBrI9NRQKMXcCrgk7jkqbHlnv9SbnevYX8dBtAGPvnOZxk+EDxhL5Dts9qOblSXdEClofkeVgUsBwWtlLBMEdIgrnJyOYyPCSDeH5xpa4qQU2t3pEFRNBKHDpzJ4A+NFEYdodYnlbhaV3lDpJHc0UZXCvtRJd2Bl3lCkW35mS5bNprmfNcPDAEZzJjoHzgseQMWfn0Qj7qTqMHEQ5US6C/wKsyiIRVQ46L6eFz1CPRrvHgoNYgER7kAqjtw0iDRackl4rjMyJKZ1OafUy7CsXGMV1SX83rloMu5511WH2pN9HwqHIIlsQSUVrVLUQnHCKB2ENHFoNSJUei449SEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPVh6Oa3snH3Vo/nCMjZeB9YuzqUbqnguP53z2mnvuM=;
 b=PELgSqb5jHULXDhNCMbQ7SyLggDm7lM3Ys/5qICvTFX/EqH7WlvJNSTXqvO+8lj+V0eeeGpQL/mTVDETse0M1IJo2uolaSLP9wxsQ3lbFlxwXwVlO4ZoRlmQvmoGZ83cFQ1pb3q2UZLEiSypptokL/gZWHUi/dZ2LAYtDV9ZHoTp3w841JszDjoheC965eSe2zYqu0n3ZrsSbNunjLrBMdilMZ8da9SyFgxJFgZro3vWwIpUyEXPAjnGjm820RAv9wyJ6DUlN9cw/eYVpJ+5JiBIHMQn5JbIEwD99IiqJu3GZfDaLgTgYoa597+UIgyDYejsdxLXxxX1mvbcFIdNRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPVh6Oa3snH3Vo/nCMjZeB9YuzqUbqnguP53z2mnvuM=;
 b=3cbsNOPc3RCi0vgRdLawrx1XlbQcnw6q06zplHaQOEyIm0soVCcF1BYUgu+plptnTA/KirynDuppGgrGTGJZ2hMOKy89tm3Hj5jjfSh+lpcDHfLwwTm6oWqZ4z+26VzABfVhjstAo1OV7q+U9QJQudXrPtEODDvl9VZJ6DPZgMA=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.10; Thu, 14 Jan 2021 22:51:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 22:51:31 +0000
Subject: Re: [PATCH v2 12/14] KVM: SVM: Drop redundant svm_sev_enabled()
 helper
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
 <20210114003708.3798992-13-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <bfce6e5e-2edd-cbd2-79e5-737e66da20f3@amd.com>
Date:   Thu, 14 Jan 2021 16:51:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-13-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:806:d0::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0037.namprd11.prod.outlook.com (2603:10b6:806:d0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 22:51:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cee80f0c-5124-4f94-0a7d-08d8b8deefc5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB422020871C53A032D124FEFAECA80@DM6PR12MB4220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJ8Uvu3h5U/RwM4lRagEeTw2m0eAWZOP0IMGXsCvOqoN/YqXm3S+ZxhtcEQojxDylOeFMo4ydosNWP5r+l2WPu+g/KM3gAgFiebOIZKJc0HQDKzcmIIffqYur6QjHdfvkKWweyd8gZ5zKKWxcBDg8yhMLn3cxyoDXGrTW+ZR0uR0OBn3vthmA5/QRClKVzNCaEHSfXQpcqa2RWiIWh5bYyEH5bZb4fr303TQKoPFHllVNyZz+mafmkAVMvBM5szj1lq8nB1YJfkGXIt/yB0b7ZpmaqWCv93EOVprJ4WDzj4JLEY889eruVXzXshOkp/3ZvsVP/ds/8Fxt1Pyeokbm/nIwFEqoqUYeVd12kWQ+WHyKiBcphJlsa1rMlkpsj6sHrs5/nQ8S0YVx0SHyYzC5hmGAbBBVTCYvz3y/TYm33Vt5g42g/iK+GrDI7ar5F5MFCUDrYPJjKF7A5tW/Bls9qy/8o5b1hbjTijbUEkzTSM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(316002)(36756003)(110136005)(6506007)(86362001)(478600001)(53546011)(4326008)(8676002)(52116002)(54906003)(26005)(186003)(31686004)(6512007)(66476007)(7416002)(66946007)(66556008)(16526019)(2906002)(2616005)(956004)(5660300002)(31696002)(8936002)(6486002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QXdZV084QXhFTVExN0tBVXVnWGZmUEgxeE5yV0N3M1BqVHlnQWN5c1Vlbkkv?=
 =?utf-8?B?Tk8veXNETXk3WjRZQm8zYVlLVGhqRWpmTHVmQnQ1TzErLzBLMm1EUjVlUitZ?=
 =?utf-8?B?NnhPNUFNbHZLVW8zUk9zVWw3RGZMT2g4b3cvS2prc2tjNEg4bzFFZmNUWTBS?=
 =?utf-8?B?M2FNMFlBbWF5VC9MRkpObTU3MEIyRnN5dS8vZ2k3bmtrejhpNDJOMzUwSzRa?=
 =?utf-8?B?dXBpN0p6OWpaYXRrUXI5eCs5ZGJRM0x0ZVRpMHg2RXlSOVdNaGJEU0lXRjlt?=
 =?utf-8?B?NGs4WkVibHRlTVJhR0JTM05sTElVejF3cERhS1JCSTJQbjVyN3VJYjhXWjla?=
 =?utf-8?B?d0FweXFMTzlaUC9MbHN6RzJVMUkrSllZMkkwTS9kSVNaUkcwN2ppRFF0S0Ro?=
 =?utf-8?B?Y1lTMmFuT3N5NUQ1MGd1THUra2RmZVZRbEttY1NFMHBaRXVtR3Z4RW9WQXlD?=
 =?utf-8?B?cVo5NXFDYVoxeVFPQVo2aGxKTW9RSXk5c2hVUlI3bko3cnJxQWpRRHRvdWd6?=
 =?utf-8?B?bUFOYUpRb2M4U2tHYUM2d1ZMRmlhUk5rcnNvTDBtRWFUeUtlRElNSE9IejBO?=
 =?utf-8?B?RFNrS0daYnFCb2JaeGxHaklBaHpKbXlvZlBjVkxmOUtSc04zWTc2NHJJSXZT?=
 =?utf-8?B?OGdiZXdNYVd5NTJYbnJsNVRDRW5CblVWSU1ZdVVmM2hRc3dEZGxta1BOZk5F?=
 =?utf-8?B?dnRjMVdRM2ZtWUdnK1JiMUJOQVdhUmxrNG82UHlxckJJcjRvM3B0eGxTOWow?=
 =?utf-8?B?MU04OXNtb052VDlrdzZycFZiSERRQWZrTGp1Z3pHWkdvbUdKS1JoVFBFQWxZ?=
 =?utf-8?B?OXJVbnk0VjBpcG5ZREZaN0JJQ3ZPMURXYitGZHl2Y3p3YSs3VnlDRnRtNC9h?=
 =?utf-8?B?cG9hdWlRMjd0NHF4SmNVSTU1aFlPVTdYRUFsL2tSN3c3dUtJaUkwMUZ4VS9D?=
 =?utf-8?B?RW1DY0kxMlNrSHg4WWlMR2FQWW1uMSthSW91T0hBeUR0dFNwU3Z4MEVYcEZV?=
 =?utf-8?B?RCtyem01eHV2NXhmMnNYOTVxZnR4K1BEL3lFTXZOUWhQditML25uQXowbEgw?=
 =?utf-8?B?RWFYS3dsdEZwaFVZd0VmNWU3dzRYSDgvVHVmaXYwUmdqR1U1WVZ1QW1KNVA1?=
 =?utf-8?B?REp5Y3ZNRi9mZDBJakhHbDJwYU5YM1NzcFRQV2IxQ3ptQ1BKRjB5c2EveStJ?=
 =?utf-8?B?WXBITkFVRjhNY2FDWlVOa0JOZ0dDVDhtS0tnTGltZW9Ld2MzbUpZY0RsWE5t?=
 =?utf-8?B?a1YvRzJMN21aWUU4TkprWGZZeFY1cFVEQVUzMks2ZUMvajlyVEpPT1FyaHp1?=
 =?utf-8?Q?PFi5BASDNYlSt2FjzftWMi2GkEUkDm1mLv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 22:51:31.6464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: cee80f0c-5124-4f94-0a7d-08d8b8deefc5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcgAgYvDMIoU3wPmp+2UMMTSXDLL+tROeHzKTvU383m05dIXk/DNiks0z5EZw8SclUg/JN0MylPnNXrtfrm8Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Replace calls to svm_sev_enabled() with direct checks on sev_enabled, or
> in the case of svm_mem_enc_op, simply drop the call to svm_sev_enabled().
> This effectively replaces checks against a valid max_sev_asid with checks
> against sev_enabled.  sev_enabled is forced off by sev_hardware_setup()
> if max_sev_asid is invalid, all call sites are guaranteed to run after
> sev_hardware_setup(), and all of the checks care about SEV being fully
> enabled (as opposed to intentionally handling the scenario where
> max_sev_asid is valid but SEV enabling fails due to OOM).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Ultimately the #ifdef CONFIG_KVM_AMD_SEV that you added that #defines 
sev_enabled and sev_es_enabled to false, resolves the build issue when 
kvm_amd is built into the kernel and ccp is built as a module, for which 
svm_sev_enabled() was originally created.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 6 +++---
>   arch/x86/kvm/svm/svm.h | 5 -----
>   2 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a2c3e2d42a7f..7e14514dd083 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1057,7 +1057,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	struct kvm_sev_cmd sev_cmd;
>   	int r;
>   
> -	if (!svm_sev_enabled() || !sev_enabled)
> +	if (!sev_enabled)
>   		return -ENOTTY;
>   
>   	if (!argp)
> @@ -1321,7 +1321,7 @@ void __init sev_hardware_setup(void)
>   
>   void sev_hardware_teardown(void)
>   {
> -	if (!svm_sev_enabled())
> +	if (!sev_enabled)
>   		return;
>   
>   	bitmap_free(sev_asid_bitmap);
> @@ -1332,7 +1332,7 @@ void sev_hardware_teardown(void)
>   
>   int sev_cpu_init(struct svm_cpu_data *sd)
>   {
> -	if (!svm_sev_enabled())
> +	if (!sev_enabled)
>   		return 0;
>   
>   	sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1, sizeof(void *),
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 4eb4bab0ca3e..8cb4395b58a0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -569,11 +569,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   
>   extern unsigned int max_sev_asid;
>   
> -static inline bool svm_sev_enabled(void)
> -{
> -	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
> -}
> -
>   void sev_vm_destroy(struct kvm *kvm);
>   int svm_mem_enc_op(struct kvm *kvm, void __user *argp);
>   int svm_register_enc_region(struct kvm *kvm,
> 
