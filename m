Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E75523BD09
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 17:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgHDPQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 11:16:27 -0400
Received: from mail-eopbgr760079.outbound.protection.outlook.com ([40.107.76.79]:6720
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729391AbgHDPQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 11:16:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZW78Wv/2rF8FFhwyhALUZz+XOF1BpzgnODLklW7wTWqNUbiNcazI2kQz4YPjGTGldHEB+Ur5bjgbtTsj8dNw3Mvx32ZbgSIgXLRA2Mn5xDTCHSfxpAdiNRetMf3Xtn0io1UYr35+eV0mEFJ9k0qYQydpBVFFKRz0xJfv9MQ+xAfNwUwj/WN4119tB39+M/aqzVA7rAlXdFV92RxeatVnGioE7iOJTmK5ZU4hErcrzxNtFRR44jyyPOH20NkLYAnAz2DIEuUNfEzAEkq65U+aB4FI6lAt7D8Fx8lOaKsxrWNp4tk9+UWzoEKIu9IbTQoNeIRr3SDoJe7Uo9KTeX1iVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHhBiE+RBQVxdCwuvN0VZhLmB1YGcOvw1+touWcV7ok=;
 b=ZBeEzHPmtettEkq98bt2Hq5woK9bd5RBvkD2e1vC7dFjRb7rSwKmi+Bq45OP+6zTeCVr8Y4HlZGEuamE1Op7lgOakb0NkynhKPoYCyq4rgVWroLVvX0eXBdU1lsZPweM+BNYiEcMeGfSwLaO7dGfw5tb9snOyss6RDLh8vFc5ypDWeDeXrKlKGuQyMzD7s/wOnz+zX+MiNUY/tdJPDItO8mWneoSbiOAX3dLcKMPv05esJYUf/Xjsf4hhUluHJXUgT2sgbvyFtQ0gcjVJOWn03JpEd5yqU7yP26IB6vhQGoTtBXc5zpef2HlItOFDMYYJffK//E5scuyT9IjWLTF1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHhBiE+RBQVxdCwuvN0VZhLmB1YGcOvw1+touWcV7ok=;
 b=31hAGbUKqp+sqMDqCw9GXZ+7vIKFUgG/moSweHFvWZN0ZD4IvYd+EgLYUzYmc0oJUROmx7XlYEEWrpvbtG1qn1W6S/HfW1b6nqO8HL3xrdI+RvDo64sqEgUVNylmHJmZI3AqYSJIbtdjFDAUHhLuVXuiE9Lz14VrOy0wBKA1pZA=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Tue, 4 Aug
 2020 15:16:21 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8ae:5626:2bf5:3624]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8ae:5626:2bf5:3624%7]) with mapi id 15.20.3239.022; Tue, 4 Aug 2020
 15:16:21 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH] KVM: SVM: Disallow SEV if NPT is disabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200731205116.14891-1-sean.j.christopherson@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <c1ae98a9-beeb-c58e-4623-bf25374330e4@amd.com>
Date:   Tue, 4 Aug 2020 10:16:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200731205116.14891-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: DM5PR06CA0072.namprd06.prod.outlook.com
 (2603:10b6:3:37::34) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by DM5PR06CA0072.namprd06.prod.outlook.com (2603:10b6:3:37::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Tue, 4 Aug 2020 15:16:20 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c07cdbff-f5d8-47e7-51ed-08d838895809
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495E922B9FE6E150E323D36E54A0@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:302;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJuIDg8PnYq5l2Dcf/nT1NEGvyp5RAtY7ZYs9n6ezjcRAHqZzWYZQhaXbwpk6qqrSHgtvYjERcmatLYHN0U1ukoMp4HjFPEKdTP0yIXAQlt6n9M5xZOYiaIfy//d223nC4toQ/Zv1fTCsdhknF824PbGEEDqnRm7gRz+4anz+0nHWnCzI30JHkNXs9b69x9aDGAsp2+AN/1joOW1hYgly34vLHA+UYvioZvAsNbGWS58UGesFrwDGivim6nHAUcBT5+6TonkR0RiyMgyZY1fc+cucFhLkSLBw80isBKpHIebSJkScVoW9AzFR6AR8tRSyER/s/m7d8PWIkR6bKScwm81zkflUrK1aB8WGQtVS8UErH5JxQj6mG/xSh6FJBLD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(53546011)(36756003)(4326008)(6506007)(26005)(31696002)(31686004)(86362001)(6512007)(16526019)(2906002)(54906003)(83380400001)(186003)(52116002)(110136005)(66946007)(5660300002)(44832011)(66476007)(8936002)(2616005)(956004)(6486002)(316002)(478600001)(8676002)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iQEkmEXYp+nSxR07TFJsmYAoCcQMIH1IO2nNZeoYzh0KU4C0Hr4LVutlnDM9LruWCy6uWI4yPb+v8vuo683qCJgESQLqWSiXfz/1WvnDHeuoEpW3vW60XSYTwtGzOOYNyglc7PqAIXnKGqojGWKbDHpMGK38Y8BiWbpJPymy3jvue5M7ozlvRFbL/vt3uKHtByE7mEb0ZfvNOfSPeWlHiuPGM63xEjYZB2Cwe/fworLT0gIgRys2mw56pynImpK5Kbsm6YojzRV8/tC4eIm0/+Dpj6XJn/zJdGdSSMFJQhKD6EsUd+CKv86RsRdLJymvnZmGuS4EY9W5gilrJejESLxQUAXbwyaSqlHQCGs1+WEhvST60eTnnOUGzrUrlP+IO7ASoLF2X0ALFDbWp7qK6VwJvWghemu9048McLsh6SUuUeWtGtpPn3pNqWBenlwy+25W2K0RWok0oaQO8B5+jtCJy26/1Wckk+uxXndomphRqeiWwWyQTTc/xLXXZAgqrmfU8SiFcwSHUO0S+M7GwBr5HREu4BLRLobJlw+IPgZjggeJCh3a22rExCuPbm2XO4nOuF9SOAOrewxBCBiD38JN2zuGxiQnnmY66ng2PoZeGNvpsjXe+YC0IpvF1uHK8ujWCip3kj+jOLALMZC6tQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07cdbff-f5d8-47e7-51ed-08d838895809
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2020 15:16:21.5123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +G9Yp+TUC9ortzRykLMJ39hS+b8T10FBgOZJ17iixe+Ch2fggif0ixOWhT04ooy9tsmduWDtlxDJPUI2TnYJ0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/31/20 3:51 PM, Sean Christopherson wrote:
> Forcefully turn off SEV if NPT is disabled, e.g. via module param.  SEV
> requires NPT as the C-bit only exists if NPT is active.
>
> Fixes: e9df09428996f ("KVM: SVM: Add sev module_param")
> Cc: stable@vger.kernel.org
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
> RFC as it's entirely possible that I am completely misunderstanding how
> SEV works.  Compile tested only.


Reviewed-By: Brijesh Singh <brijesh.singh@amd.com>


>
>  arch/x86/kvm/svm/svm.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 783330d0e7b88..e30629593458b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -860,8 +860,14 @@ static __init int svm_hardware_setup(void)
>  		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>  	}
>  
> +	if (!boot_cpu_has(X86_FEATURE_NPT))
> +		npt_enabled = false;
> +
> +	if (npt_enabled && !npt)
> +		npt_enabled = false;
> +
>  	if (sev) {
> -		if (boot_cpu_has(X86_FEATURE_SEV) &&
> +		if (boot_cpu_has(X86_FEATURE_SEV) && npt_enabled &&
>  		    IS_ENABLED(CONFIG_KVM_AMD_SEV)) {
>  			r = sev_hardware_setup();
>  			if (r)
> @@ -879,12 +885,6 @@ static __init int svm_hardware_setup(void)
>  			goto err;
>  	}
>  
> -	if (!boot_cpu_has(X86_FEATURE_NPT))
> -		npt_enabled = false;
> -
> -	if (npt_enabled && !npt)
> -		npt_enabled = false;
> -
>  	kvm_configure_mmu(npt_enabled, PG_LEVEL_1G);
>  	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
>  
