Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A002F1883
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 15:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731854AbhAKOnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 09:43:17 -0500
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:45536
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727484AbhAKOnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 09:43:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNepAzmno62kCXfSHFFcmoy7WGgav5Mh1BNQHoKV720LX4oCowQ8NMNw5XoFCdqwNsJGZkM7qJXx+52zCWHdEMBbOH0kQgfs8EuZnNBrRL+FWIjuBIdFfQovmvNwn6w5stLH45cD270XPYDEIwyEDcwvhqbf8ZOzqtuU2c5v745EUckAaUCOgEs1ikdpYGk7GZ8eVHJYfjYCpSoBGRXldK35FyjDyeoyRt+/gxVNyRNMLMq92MN6L45bMav3kyABEWQiyOz42+sDd9/hR5I1wJmb1TzF+TAgKk6lxnUrHbn73wvDbbgu2enLA7Dy62kTGz+iz7bBNVB1pgJfG/76Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnqfJ9ERXKazMuGEIWRaZiiDu/aE6qOgKqXasx8Pri0=;
 b=C/Kc614wOV7BPCCh6aye9WopU9TGx+eSaZKUJsjfvSA0FIlkWXhI1dKKNETHZxMgYSQArYbcu2WgNiudmB1D/Uzk47OdZOCk2s9/E4dwvxlolYpkULSZqEd/c4CrFh2ED3eFiLbIAfuG4j2SF0AoPM2SwRNKHpiTPkm/nR3+xVXDUG2VgAWOdGh8Jb2aNxp+vTNm/k2XTgpmo0ujFUxCVKvGWKWlTIf31F6o9xUxvHSNveNDabj6r1veOaEs49V67p1lUFp2skFDbWA8rwFcSw5hk9BUbxvaZgBDzDJSed4cmPydtKX2tnZ4DjxnlLxgsuZC5+sqqGH2KqdSpHeGKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnqfJ9ERXKazMuGEIWRaZiiDu/aE6qOgKqXasx8Pri0=;
 b=K6XYqtHspXS2v/O8+avqyC2Ye0Aj1smDCbd2i41Q/AcLV7DNVPpm5SdT2Pi+Hge51BKtYXx7mdTEV+G/dlQ2y1IXhHXg6nPqC3z10LJ+UDo5ww4QR7O1EKNE4USXihcICTv8gEFUJpMwc1DExsB4d+Xdbtq6AZK+524MA4S3opo=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Mon, 11 Jan 2021 14:42:23 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 14:42:23 +0000
Subject: Re: [PATCH 01/13] KVM: SVM: Free sev_asid_bitmap during init if SEV
 setup fails
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
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-2-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <34921a58-ce49-f0fd-e321-c5363e91f3f5@amd.com>
Date:   Mon, 11 Jan 2021 08:42:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210109004714.1341275-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:806:130::20) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR13CA0015.namprd13.prod.outlook.com (2603:10b6:806:130::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.6 via Frontend Transport; Mon, 11 Jan 2021 14:42:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3eea0db1-f7b8-465f-9533-08d8b63f1b71
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17068E5FEC7DBEBDF9BDA650ECAB0@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zIC3e2Pw572fHoS1/DVzEcqCUp1cDXm6XgToyTijWo1+xb2OkHNRR2rkVINvrpo0qXV/QSOWeIhF4hFizBDBnFzI/wF7705FyxqMGl/Y1iWcdQ+YD7oTYZOu4bFSRUgyGcqCkSd2XcXJELatZswJ3JqvAW+15JcC9TQkJ+3p1V24YmjDkgJeYisrtt156O9IMNCHOXvswmDh95J7M3b0zQDcFWh0RMUC/jp2X1Dy9ernLt6Z9XbRhGHPy8qtSijFbluxWuEvsrytpQshM57m2RAqXqnSEIWK4kB/i+QHQHVubu5JvgxKkCVtE8sDFHaqKn+9zUch+QWtJAeI0WjIf0f1znM/Pi1R+THThq5kTVRSlxSZQfeAk3sAOpQiW5K2FLVLIxAHqnonqIrWs7WvJr8Q4GTm7RzIlDYSiFWlPAz2DzwahfWEFP7RFkiV13hmxsilymcAkR0R4ZrS8LBuf+csdONTN0RyrYNG+Uovx/g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(316002)(53546011)(6506007)(186003)(54906003)(7416002)(4326008)(16526019)(31696002)(110136005)(26005)(6512007)(6486002)(86362001)(36756003)(5660300002)(52116002)(31686004)(66556008)(66476007)(8676002)(66946007)(478600001)(2616005)(956004)(8936002)(2906002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T3kyanRGb0UwZVpsWFdSR3B4clFkM3NWSGh6cjk1cjBIdWFiLzlxcTdzS2U5?=
 =?utf-8?B?WWl6ZElqa08vbWhMMUJxenM3MFNaNXVGLzMyNFhpdlNKMjlkS21td0hLWnVo?=
 =?utf-8?B?bVZPVHlpOVFFeE92N1Y1RDJWS3NSZlVKSmVrczFHaTlWak5peE5QMTVyczk3?=
 =?utf-8?B?UmlCV3gweS9zV29qQmFOSHg5eWczUWVGQUVPOTl4cVJJZ3huYTVmOHBRRHVS?=
 =?utf-8?B?VWRyeSsxRDlaMDJvZExoYmNmeTNuTGJ2U0d4T29VbjAxUmljWmh3RGNsaWZh?=
 =?utf-8?B?QUNiVnFWUkNSQ2ZGekVmc1VIaFZBajQ1anVnZHhFVlNzL3VjMmxRL09Qcyti?=
 =?utf-8?B?VUtyS0F0VFFpNlFSWEkreHh0NjFzRGdLR0hxUjNpc0NQY3lNSnFKRHJ1aDcz?=
 =?utf-8?B?SGM4REJDWXdWYjJqTTFsNXdEZ3lCdU1mdzZyWVFqM2VLczE2R0Q5SmFoTFJR?=
 =?utf-8?B?SURkcWJWRnY3TUVqeit0cUtIcGlMVmFTRUR1TFFGQjdvdG1QbVNIQ3NoN0U0?=
 =?utf-8?B?TWhZbzhISGlwNmdxS3FHdGV6ckFzU3RiMWhtdjFqQmpnclZWNFkrQ0ZtREZq?=
 =?utf-8?B?SmFxT3VDdUozNmdzUmdKVnl3bWRBRlJ3b2VrSGpoTlo0NnZaaE9IYmZ2aUxT?=
 =?utf-8?B?MmpjNHZFaGt0eHQwM0NZMGZxTmRLWFl4SmVCbUtSQjdsc0toMEhPb21BV21N?=
 =?utf-8?B?TzJueXJQcG1wbG0rODNWYURpa2c2U1YvZXEzcmtYVDhYTVkyUlFnOHQxL1Fm?=
 =?utf-8?B?UEtkRzZmMTRudTlkeUhrWFpOeXIvdTFTQ0gySndFbW1hbGRsZk9EcnFrVkVw?=
 =?utf-8?B?RStZZVc3dG1PZm5IbDkveWVpREo3KzR2ejJjeit2V0RmeHVJV05DRFczTG40?=
 =?utf-8?B?ZWR4d1ovWDhGS3ZlSVlmYm42QUtXT3FJdzBuMXZ4QmxzOUdiaHZqd0xBQVd5?=
 =?utf-8?B?T2srZlQreTNGbDBwUkU5SHBwVm9IcW51OGMwR1A0YmNYVjBTaWdHVjBXYzM3?=
 =?utf-8?B?aG9hSEJQOVduV004dmdhenpTSHRpdExYS0J0eTRJNGViWTJGVlBLOXJBcjBi?=
 =?utf-8?B?dncyTVFoVGRveGwyT1hvVjNvSFZrdTI4bXRwUXZhK2FFVEoxR2Y0dUVYUnp5?=
 =?utf-8?B?Tm4xRlRHUzhkYXY0dzhtaFJJVUkvNVl6OGh2ZitrQ0hLMlBJOEVVU3BnUHhH?=
 =?utf-8?B?WjFJam5Ya0FRK25OQ0xzNWE5bm43M29IcFR3QU9WQUdVRjF6LzBQRm9XUE1Q?=
 =?utf-8?B?cjhNMmVtYys4THV1ck1FNk9pbUJnNHM3VjZCVVA4U2h3SENORzZ3UnNhS2ww?=
 =?utf-8?Q?Y7YySWesWIoGerZhgwFO8m7dL6LpBnZrKN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 14:42:23.1149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eea0db1-f7b8-465f-9533-08d8b63f1b71
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7TCmUum0qOYu4InerJhgs3VGlqHwHvXBv+idCVEbKU5Amc471no/YolnrMT4HbfbuAk2vYRIssQ87dLg4RCFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/21 6:47 PM, Sean Christopherson wrote:
> Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
> it will be leaked as sev_hardware_teardown() frees the bitmaps if and
> only if SEV is fully enabled (which obviously isn't the case if SEV
> setup fails).

The svm_sev_enabled() function is only based on CONFIG_KVM_AMD_SEV and 
max_sev_asid. So sev_hardware_teardown() should still free everything if 
it was allocated since we never change max_sev_asid, no?

Thanks,
Tom

> 
> Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c8ffdbc81709..0eeb6e1b803d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1274,8 +1274,10 @@ void __init sev_hardware_setup(void)
>   		goto out;
>   
>   	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
> -	if (!sev_reclaim_asid_bitmap)
> +	if (!sev_reclaim_asid_bitmap) {
> +		bitmap_free(sev_asid_bitmap);
>   		goto out;
> +	}
>   
>   	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
>   	sev_supported = true;
> 
