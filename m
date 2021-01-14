Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7FF2F6D51
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbhANVf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:35:57 -0500
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:32865
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729862AbhANVf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:35:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTqhh7blBfktqxbtnhucv7mDHoWm5hK1LbR+uBuVJ5KCco/8+xoGdvRJRpsxdjkffM3YR3/Bzw6G3a5CqIgDCNtnETVLjXvvoYlRd+s62ZZ/l//64VeO+gIZ/xhOxNpACth+FpRQeXvz4SyTRdnH2XO5DbLhJnHyxiWLfEl3Y9Pa53C16BEc/JGNZ8GGN0uDia6Xnw0jrMx2YsQuQLYeazUJj4a9fQkb7nb8h6USSGbys53Ze06mjIppPtejSa8xMNJGwFJHuD6D2w0YuIeJBEKvHevF+cY9v1ZRQzD1UWfY2EzeZfE4l+Ls5bo5zUJL2navUvHtf4fa/i5GsXG6gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LUfONHcG5i5by+oVdfUBtBvIzkdVsXR387WwsdO17o=;
 b=boHtL24jXTgGcLYPB/KbCBQGaOLnlZQ042aE5Fjy9q3Bk9LOUsWyzdbC2VDgyYRa8V5Ci5MsFD/+MT/YBTrGx76NDcI40Nhx8hYwDg5KMX4dYGxWi0xFj5K2LCoYjFE4PxChnNvJddoZz4nYuokh184DLJZlygeCem/pJSJ+HnPlBWyYq/mJZBZbQ0iNAHYXBqJ3MESVc54KDTR6bbbxtKFAPKev/l6qakmWkbr44YTPGaEbyfG1AMXmUQZlH7+xkC8vktSX0jKga3C2irYP7aZkgf0kGAnexr/NQP2DyJemIrJZVa5GuN1ohfVUGdk6M4j+2mhmoS93XJpLBsAt3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LUfONHcG5i5by+oVdfUBtBvIzkdVsXR387WwsdO17o=;
 b=YHSeT9UYB44mAhxmIcCCVq3ZNe0RyK3UPnTvFqntLNDyGtFTmLsqg1voL+MTWVwZkANSP2WQ5eC685GL6yOQpRX6MF100IKblwDp3UjvjPSzEqXH3oXlxuX6tkpT8t/wJhFfGXAKyliz7QqVLUYmV3w2oYV31ffNuCZLH1hpmBQ=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 21:35:03 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:35:03 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 10/14] KVM: SVM: Explicitly check max SEV ASID during
 sev_hardware_setup()
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-11-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <677d9015-89b4-fb73-1383-4449318029c0@amd.com>
Date:   Thu, 14 Jan 2021 15:35:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-11-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0184.namprd13.prod.outlook.com
 (2603:10b6:806:26::9) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0184.namprd13.prod.outlook.com (2603:10b6:806:26::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.6 via Frontend Transport; Thu, 14 Jan 2021 21:35:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56bb6e9b-2816-408c-06ab-08d8b8d440d7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45730CD4655B7424E100C117E5A80@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HUDRf5R2gpID9BUc8Z40e0LHdwaF80dVnjEeRHVYUXd7gN8WPLFDN7TlfXs78nUI0kl19coOigU1wLKqKvQgGnO2H7l5CNFJCdAISGDRT7Z7OKOoopJmiG5O8lvC2eMaONDg934Y0CWjI08eJRlebxf8Q/GHA5pitmcHuBzC44D7t09DxExmpWTNHfwOIOVYcAk4uaL5eWlIuhJmFOH/FhMhkPO3NSqtZpItv/baiJdKJkCU6ww5SG1z+J/JSjNmpIHl5MJsiqb5vE7duGSCgar+Dsl4PYEuXx1MNZy+3Pje2MfnY+HXenZPm0Je4E6Fo66OTrq2/thpXm0rUj6plHVJ+rTcOlQbPsXzz2fFL2N9mHfVEwaPVi57vrEPcHoHRAIDO/ZcufWL2kWRrlwvQz8peQ0dQ2ygoflaHeEggPWB/agz/ZOG8GpZs73akI+A0g3wunHYZsCIGM7Puqolf8IMlyVXOKwU1Dp2WDW68Uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(4326008)(6506007)(7416002)(53546011)(8676002)(83380400001)(26005)(16526019)(110136005)(5660300002)(31686004)(186003)(31696002)(86362001)(316002)(6486002)(4744005)(2906002)(36756003)(54906003)(6512007)(66946007)(66476007)(478600001)(956004)(8936002)(2616005)(66556008)(44832011)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eEdDdjYvc1NHbzU4VzhJZUJMVXdzcXVzZVVKL1Z3MFhvMVgyTXgwWERocUlx?=
 =?utf-8?B?SzQ1MFkxTUNvUVZqVU53ODlqY3Z1Y3VnMGNGSmlzTVlUcWJQMDJwOFJmS1FR?=
 =?utf-8?B?enR2NDh6Nno3NXc5S0JkZTE1eXozV01UL0pUUW1yVlR4QkVnT2tlREZZU0Ir?=
 =?utf-8?B?aytJcDVNNkdUKzFFV2k5R2xaeFhOQWtpYURGUDFFLy9xRnQwYUovNlhKV0tk?=
 =?utf-8?B?bWxDVW5SZFVMYW1vVHRhZDk5aUVJbjQwYU1EMTZiWEZVNFRWZURadnZwMy9l?=
 =?utf-8?B?c2UwdnIyV25aWWtua2NxOEhqc3c1Z1hzVTJORk43aThDVDM4d1IxQ1R4VURF?=
 =?utf-8?B?a3JpNC9jdngyZ0JNSU5HTmpMUUZWcUFrcHJLbnMvN2txNWZsc1poMHJvYzkx?=
 =?utf-8?B?Qm1XT3dLb2xxN0ZlbTdiMlVVNUNneHVwbGF5aUo2WHhkc2lZRTQ3NGtRRDhj?=
 =?utf-8?B?anJLUGJJR3h1YlNrcWxEYkVReXJkaGxqeFdXdFJOOGlmNVhFSVhVSE1lYTMz?=
 =?utf-8?B?TU9ieU95ZXBpbnNzdTB0NUtIQ2dQekRML040SVgwWkEzZ2xBTjVDSlhiRVI0?=
 =?utf-8?B?OTV4Vjh5ekI0cGdpOC9BNWxUdktZd203TXNBYVVEZWpSSTFVTURzR3ZkditG?=
 =?utf-8?B?MTVWSldVQ0FhVmJOakhxR2VOQTM2Y2J1RGdsU3FwRFh4OFJFVnBVbkxvbmtj?=
 =?utf-8?B?RU9heTF3cVhjVEc4UzB4U3RnNUF0UmNGK0MrVmNHWm40SmVFd09XcU82MzlJ?=
 =?utf-8?B?WEJFTVcvNVpkQlZQbUJ3Z2hhUmZkRzlGRHBQbGNRWHBXZEdVekIrd1JSL2x5?=
 =?utf-8?B?VHAyYmM3TTExQXJtdWJ2bXZWck9NdHp1TVI5ekVUVTFMcVM1b2l4aVo3cHUy?=
 =?utf-8?B?Q0IxdDQvQUFGeVdpS1EwZlprdG1zL3g3OXJZdVF2NXZuUkpYWmhVeVp5VWhV?=
 =?utf-8?B?VG13bFlCU1NJbnA4SXpqNFM3ZEp2bjlFNGliNk1vbVRjUUdHRnNVRXBiS2la?=
 =?utf-8?B?bkFtQ2hrdW1iYkR1Nk0vUTVzbStOMmdkaXMraW9PTTNzTkI5VDFXUENKUm5m?=
 =?utf-8?B?ZjRLOS9wWVVSa2o0MG5TeStUQkNyMTNlZ2d0eGpQZTA1UXFYdDVlTElMajUx?=
 =?utf-8?B?dm5uNGVGeS95RWZTVWI1Uzh0dUpmblR3WVFTU2dFeDJDOVU2SWl3YmpLaHRy?=
 =?utf-8?B?bnZhSDlsUFRVNysxYjRaYk04WHYrY2ZVZVRhK0EycC9VNk1wMHQ1d0dXUjN2?=
 =?utf-8?B?SHlndk5CcnpoNGpHUE1wcmhYL3luOVdUcjVSclF3NzVhR2hJd3VjajlWWEpC?=
 =?utf-8?Q?5iQkmpc/8OkHNsSgz05b+3g0zbMu6swxpX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:35:03.1767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 56bb6e9b-2816-408c-06ab-08d8b8d440d7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W55n/7hRwr+Ugvmz0w5AtnaZPi2x6R9EkFQZgUvl7LN+E+kQw/tZYUAF7BE6VIo8yn9DndQccenr/iPOKOJKeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Query max_sev_asid directly after setting it instead of bouncing through
> its wrapper, svm_sev_enabled().  Using the wrapper is unnecessary
> obfuscation.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

thanks

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 02a66008e9b9..1a143340103e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1278,8 +1278,7 @@ void __init sev_hardware_setup(void)
>  
>  	/* Maximum number of encrypted guests supported simultaneously */
>  	max_sev_asid = ecx;
> -
> -	if (!svm_sev_enabled())
> +	if (!max_sev_asid)
>  		goto out;
>  
>  	/* Minimum ASID value that should be used for SEV guest */
