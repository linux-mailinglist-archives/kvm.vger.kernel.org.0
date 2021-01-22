Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647B0300EA1
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 22:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbhAVVMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 16:12:33 -0500
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:50784
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728559AbhAVVL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 16:11:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aisAMGrlGPDfitQYzNUt/2Me5S0iNbZRDCp+IzLWYJH9KSCSNVzPn4RXx5NRAGDNYfpF+DnpS41ml3XOCB1HRHmwCdy56nDjt4XvXTvtwf4kNPw51wz+wzIyJnxY9veY9MDfnHGYphPtQ0lxr1T8DNJ7QVI4p0ceSu4HuyugKsZihQN9VyV/mc7wfOBv4sArTLpy6rZtt0uTzizC04JurmHEFVs/y+aL1bL8/FQNg1qVCmib5GIEVzhGUK84NOaVHJ+nUr/FaaQQIJUcsKrKgQ0PkV3r8o9HR72Fu1NsoaAPvjj1nwr1XETCQ6qORoWQS5IF+SLhn72l6RHdzTK07w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOw4j50TYIK6iL8QIsCdsGjNschtk/fG3i8Yn3e/pjY=;
 b=dhBZGeZgjUNJXiULCa/OZvUEdxQmcGjLXxt7nYi16z2pI+1JHKoHxXJ+5vnUVbDH74Uah9FD8LGFmp7iRU6vUpsRb20RT8pCkJJCSrylNUOPVVYTts8DTPC/5LxxiVLoT7bqQytkQtq7pxde6VhoMITZZJSMOCT9rapeogsPcbiEMLWHOtyWc4ekTPjxDAOhkxIzurROfN9KnlDqaTTST806nLMNBsSLTBkyB6UBUq08QxC0KPxQgA5aV76qrsdFOwknwrOB0BfjA/H8CKv4L0hmO38qwq/GbWDE+fBgEdDwjk760Qfu91VTxWLmjePaio/9liOf3mqb1wNV6xSGqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOw4j50TYIK6iL8QIsCdsGjNschtk/fG3i8Yn3e/pjY=;
 b=nExuwzCbH9QlfTU8+0h7zTK7sad7XPAM/1csIkC5bsU817zW+XS5nAE/XLLRAk/aHmYXRJEjDBzuo4VZBiCuk9kden+Yellf6niXsyc8eoF5qy7yNkaJoUNZohNiRltgMJJ9xbWEOb3akTpw3dqeYYgHYdpF6ocuwH6dmD6N9QE=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4700.namprd12.prod.outlook.com (2603:10b6:5:35::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Fri, 22 Jan 2021 21:11:04 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 21:11:03 +0000
Subject: Re: [PATCH v3 07/13] KVM: SVM: Enable SEV/SEV-ES functionality by
 default (when supported)
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
References: <20210122202144.2756381-1-seanjc@google.com>
 <20210122202144.2756381-8-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <608fb504-0a02-c83a-2863-f2bd1fb8b1ee@amd.com>
Date:   Fri, 22 Jan 2021 15:11:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210122202144.2756381-8-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN1PR12CA0050.namprd12.prod.outlook.com
 (2603:10b6:802:20::21) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0050.namprd12.prod.outlook.com (2603:10b6:802:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 21:11:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c2059e4f-450e-4c9c-fbbe-08d8bf1a3a10
X-MS-TrafficTypeDiagnostic: DM6PR12MB4700:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4700CB68D65FFA6C014D7A48ECA00@DM6PR12MB4700.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xmSwXYFIuTqWFJFcYFc76vGlXZCmVvic/SnxdQgswvfYxbirL17629Tl5G7GQkEmUYVmDrAS64mgBmhn/cOtRkJxOmzN8XfV5s2w7K0Ht2xo2fPsUn2EB2fPEzXS8hKcNV8SBn8cxrvd6BYNm5Jq0lhJGz0qa5euGSYT8Dp2zohyQgv5uOzoRZ2c+GjgcwN2hLU0aDh6l+h5ezeFfmqo8aNVOz8WkasKe2hLW0X7Of90Kq8ETW0j/otkpLd2lwiPH1nmn6qVcXmUlp6pcosdj+07kX1QpBSvTs0O4YW9rnAgVd0p1nsTbMbgiNMmD+0hhBCnS3cylPRaXPM7QV0ny9P+hqtoSKCoIprf8nRDNoqok4cZHQDHJ5krB+87EVA1W4fou4Vg1mRO6rWx0rWE7/zWuwAaFT3MVMD7Ev2WlxKP7U3jEOJ8BJRWbbH7uhhOD+A+oPaE6WrYzAEMV6Y0HWAwGGxZhST3ln6z9324Uc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(86362001)(66476007)(6512007)(956004)(110136005)(53546011)(54906003)(26005)(31696002)(83380400001)(8936002)(186003)(31686004)(6506007)(478600001)(2616005)(36756003)(7416002)(66556008)(6486002)(5660300002)(8676002)(16526019)(316002)(52116002)(2906002)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cEdkdWovYlNQYi9pWlc2UGRRQnhPZXIxRlBOWTFURlhtUE1oaVE4TDNjVHpr?=
 =?utf-8?B?ampVVjF1Uit4QjVWelhuNW9NZlJlYWEwWmp4UFoxTHd5MlVTZXBQclVGT2p1?=
 =?utf-8?B?K1krcTJ6bXV6Vzd1MjM4Y3owMHM4c2hnK2VNZHk4d0UxWDUweTE0MG5vY3pS?=
 =?utf-8?B?ejhjcWs2MWpwVFBNUHpWaFgzYzVMclpTTy8xR3dxQUoySm9jTENXTk52R29M?=
 =?utf-8?B?NmsxZ1I3bXF1YnkrTzc2aFFrWFk3S3JBaVNzZGtqMHUyaldqeFpSV1YyOVJu?=
 =?utf-8?B?UFVUMnBIWjdCUUJVTlhvY3hJK0N2MFYrZGlYanN4Y29XN0JValBMeXhSS3ll?=
 =?utf-8?B?ZFNzRVJhaGpQd0ZHMnpDWjFZNVZiZm9ZQ09vdVArREh2bzMvMHdYYUtoS1pn?=
 =?utf-8?B?MU1ET3ZDVXpGRFVxYm1vR2QwSTh0c2E2VlZRaDN6OEd3TXNwT3FzaEUyaTB4?=
 =?utf-8?B?aFdHc003NCtoV0hjNCswMUJVZ2pvV1VSTVVDRHJKanlmZEptZ1MvSmViMGp2?=
 =?utf-8?B?T0t0cHlxZlNhcmFsVlhGQS9ZM21kOFdrcjRzOTZvZXluZFF0N0JWNUs0OGpL?=
 =?utf-8?B?K2JZK0hMM1VXbVFjSnZhK0VUS0gwcVRBSEdjKzA0cGJIdFNFdkU1SEZEZVdn?=
 =?utf-8?B?bjZkMm5GK3ZFem5UV2g1clpwdDk2dXc2T3IzUnNCUFM1RWl1WEFNVC84a3B2?=
 =?utf-8?B?UTBINnN0aDRLVm5SWE9FYllESjI2a2NNRXVUQVFKTG9FZEZNSG54QU9EL2sx?=
 =?utf-8?B?bGs0WFJpOUdPYzFERlVHSXc4RC9wamM2R0xtaDM0azE2NFI1c2dzSXRFWEdL?=
 =?utf-8?B?aGx2S2hnRFpGODhoMGQwTjlTQWlNT3BWOWlWZlBBZy9KcVF5NU1CT2l1VTY5?=
 =?utf-8?B?Q0VLY2szQnhtVm9RR1NhTWFIQ1RyUzVEb3pMTm1YTnBkU09HdnpqVUMzaC9G?=
 =?utf-8?B?RE9MVDFVUVRDeFkzb3dwUVg5eXRXYUk3SnpuTVNicUNYUEtsY0FOQkxDTzY2?=
 =?utf-8?B?UDdNY1p1eXRYcnJGRDkrVXF2VFJwaGxsRTJINUcrelFEUEtwOEZxcGtNcmFU?=
 =?utf-8?B?WDN3WVhZR2xBbGdkd0p5N1A3Q29CcXlINURQQ3k5a1dvRHRmOVpHTFg1RGcr?=
 =?utf-8?B?SmVKUlJ4S01INkpWSXBZN1BOYWJIREJidkhDTTlxSGRxRmoxYVdMM0VnU2Ja?=
 =?utf-8?B?RkxaLzVnTkg5endFM3lKRHpZa0hIYTh5Z2ZTeERZVmpRZEdxQTFKRHQ0ejMz?=
 =?utf-8?B?MFNmNWtwMjdLMFVRVUV4UWhjWE5qMVZmVUJDejV4MFczM1lYU1RSVHkxcVFQ?=
 =?utf-8?Q?HYGDVkAuB7cFQYNHAzniXOkDzAGNM7Fsb+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2059e4f-450e-4c9c-fbbe-08d8bf1a3a10
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 21:11:03.8700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Z1yKSKTozzOZAo7H+sccyXUT1OwYQ1mXrrBMCJYhr+AjB+TuI2AuYGJu3oCYubZNhniLBJsA1NacNisKVhqiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4700
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/21 2:21 PM, Sean Christopherson wrote:
> Enable the 'sev' and 'sev_es' module params by default instead of having
> them conditioned on CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT.  The extra
> Kconfig is pointless as KVM SEV/SEV-ES support is already controlled via
> CONFIG_KVM_AMD_SEV, and CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT has the
> unfortunate side effect of enabling all the SEV-ES _guest_ code due to
> it being dependent on CONFIG_AMD_MEM_ENCRYPT=y.
> 
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2b8ebe2f1caf..75a83e2a8a89 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -29,11 +29,11 @@
>   
>   #ifdef CONFIG_KVM_AMD_SEV
>   /* enable/disable SEV support */
> -static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +static bool sev_enabled = true;
>   module_param_named(sev, sev_enabled, bool, 0444);
>   
>   /* enable/disable SEV-ES support */
> -static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +static bool sev_es_enabled = true;
>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>   #else
>   #define sev_enabled false
> 
