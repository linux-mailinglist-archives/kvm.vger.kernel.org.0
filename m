Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23372F6D7D
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbhANVuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:50:39 -0500
Received: from mail-mw2nam12on2067.outbound.protection.outlook.com ([40.107.244.67]:44001
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726311AbhANVui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:50:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mF2A/GCwwVohDMo/FgL81xj/CprcGBwHdur/NJfzkB5WoOKTcEM1enuHry7GZbmuzRRl1TXeOwIbZa5E/9Q4ljyxH7DC9I3OfIO1fgbxa2qMD8If72PBTeuiXiBUBXQIkLc1KHqf7zkJgkHeUlS/Qthd2xZXJosMlxp7KcxkjWJLYXqHHRbCtvyQA0MoFpLzografQaCVoYTrjhv8yl2Fv4r+5iGRItSapJIMRnXPgk4N/lTIvSuxP569dLZ3TNhEFVem2EAoTwdRKpYwH1pP37uN0WRgVXzrYeeDftIfs4py0f+Yw9g6PVqWisnbdYr6itZ+oVd5rgkafVPyCxm5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6uv9cYGP4t/kdrSjh8eTcu4IS9Sqly9BVLvIserS4E=;
 b=nAjpyfi4WGf4Tt8ZVCBkxOyu+i2Lev5E8Q4ulH2l8tN9d+M4whchVhAUlCTQTPALrlSvRDYdiJ2JAWvlm5OZ15mrSfERrKW6qtHKK4W0tOWUZvjm3Qvkuw5YUPmw9eRfm9xZiLK938iNzOE1thnBSu8xpQwcdJMfMk/BBiKuOGeT6dQEnzaVUghq2bDYrupCiMurDAYj05q6ZOd1kDHj8syGKV6Tvya6ExIZEINaBSZYo0wzc+BWEO1j7qeBMw1V+Ba5lHOgJVglf3wsO+7wRKOkP25yC6Ys5UyGcmfpw8MJhltknbw5XTWYE7YT96exVAnvmUC5pEeaV2dVCpiIpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6uv9cYGP4t/kdrSjh8eTcu4IS9Sqly9BVLvIserS4E=;
 b=PI9HFIiYYISQJSTmWaHtOwhpdUa5uoQd1bZB4o3kBHb4laLRzhV8bTrMhNHELCyhvH9rFDThI9EQClgRkBaJ50SuGQItpTgEzKOBGyDGwYZxPSrHYcR2jwxbEWChn/DN6ISNrYzwoLXeQnXFAF7CujFxd5iP15UaBRVeimJDj4s=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3769.namprd12.prod.outlook.com (2603:10b6:5:14a::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.10; Thu, 14 Jan 2021 21:49:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 21:49:45 +0000
Subject: Re: [PATCH v2 10/14] KVM: SVM: Explicitly check max SEV ASID during
 sev_hardware_setup()
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
 <20210114003708.3798992-11-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <5af20395-78fe-9a85-d718-b6f1be60ab9b@amd.com>
Date:   Thu, 14 Jan 2021 15:49:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-11-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0119.namprd11.prod.outlook.com
 (2603:10b6:806:d1::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0119.namprd11.prod.outlook.com (2603:10b6:806:d1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 21:49:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 00431d79-d5f2-4c5e-1770-08d8b8d64ee8
X-MS-TrafficTypeDiagnostic: DM6PR12MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB37695C28D4ABB72CB6657F2BECA80@DM6PR12MB3769.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WqFormXyP3MGZBMfEj7Dni5X3K0qWyAN4t1ngXZxZdQICWNkkEaThdU/MCE0PxqOIwuUWLLF1O2VqbP6kIihjWmwXQaNZZOQMB340XZRMDM7WY1JuFOy04g+dkWrekzJpFTJao/Jtfp4zCSg9uAUcsI/oqpeFPD3okHlls0txdk3979Dwo5vAI9iJ2ZCGISR1sdebIKMv4C8XKU7BHExj/ls26412h9bT1D1yx6BjIuGgYyH8rDPDTReuGMrHrIpQK42Qx1un5cUabT0dlWFJf/oA3bTqfHx7OlHMEClL25Fhqs4YE2mTEMPuiK6ghqDaaTLNI7xYjxfZzP5Q14ObT7ItG+P1JeysIE6WOkk6Ep9fc2tW0B3D9oyosm3LAnIMIzYA7ciUmo7cWinQPn0kAuOfwi2/z7QoyS5y65Z7+atStEx3zKmN4LpdgHZwLJszHU+M/CvF63dlmpr5NV+oD+4tMmWvJdgWEn4FNwOJSk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(2906002)(6486002)(6506007)(26005)(53546011)(52116002)(316002)(956004)(4744005)(110136005)(31696002)(86362001)(31686004)(478600001)(54906003)(16526019)(66556008)(8676002)(4326008)(6512007)(5660300002)(2616005)(83380400001)(186003)(66946007)(36756003)(66476007)(7416002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TTRqZjNWaWw1NkZuSWh5VDF6bStIaUM5QklqdjBnMzFGTXYyTEZyS2VJNXJn?=
 =?utf-8?B?ZWhzazZOSHY1TWdNRVhDcGZHMHlqTlBFWEd1Um5lRUYxc3pFdlZRd3IyZkd3?=
 =?utf-8?B?ZGRsQ3EwcXUwRDQ3NHNZOGZJZ0VsaUZIYWV5aytqTTZ0enpGeURrbm05MEg4?=
 =?utf-8?B?RWx1T0pQZFREdXBrVXY4MzR6RGpPOXdQbUIxeWo4T2U3RXJnWFJ4a1FTdE8z?=
 =?utf-8?B?cGRrb0cyL0sxQ0l6NUNHU3RLTG5MU28zSkJxbVJvYzdYRldDeExwWDdWSmNE?=
 =?utf-8?B?VjhLeDEwTlp1NGRiYjBwdy9ScnNJbkd6ZDRYZlZXNHgxMU5ycXVpbTFGcDl0?=
 =?utf-8?B?TjdkcUVDVlFiZHFyclJXWnJScVZGUDRJRE5rdUhqaVpNV1lqRTFkODZNYSts?=
 =?utf-8?B?NW5lM29tTldvd25YT2tNZUFUTGNzOEdyWlhUbEp0M2pWSDdzQkJVYmlUWk5X?=
 =?utf-8?B?MzVNRFI4OWVndS9TdjBXVDdqSEFmUUZNSDFzM3c1R0thNFgvNytkTldFZEc1?=
 =?utf-8?B?SHhqNHd3ZzJrOUJhb1dtTGltZlJrMXFjUlVOb1lJNkU1bGJjRWkveWlrdlNZ?=
 =?utf-8?B?SDBadWxRZE15TTZBQm1BNEdiL0c4S3ZlY0lDQjZkYTI4M0tVZEErNktGNmFo?=
 =?utf-8?B?bGdYQ0x2YzJkZDJycjcxVlh3OTVycWlIWDFOVkZmYXFkT1lTd3hER3NMbjBk?=
 =?utf-8?B?SnVaeTRjR3pDd21vZmdoWHYzSkVLZmdOZm9LdExKb1Y1ZEJNRE0vWndYa3Vl?=
 =?utf-8?B?dG42ZTNXOU9xN1VVMzVING42eThTNm0yUHk4NnFySkl5c25LY0laMDRQRzJV?=
 =?utf-8?B?ejdLUytXVzlFeVhHQ2VnbWh3akc0cEhCZUZqTWhMUlVXSnFXUjVSaVJhZ1dN?=
 =?utf-8?B?S3FJRFdiazBIVzJhL0xmbGpTa0lSSkFpSUFBdnBjZ3FTTUhYQkRhL2pQajcx?=
 =?utf-8?B?NSt1eGIxdTRBblRuLzFiU0g2ek9KSS9GUzFZbGFORVR1UTBSVndISEU3ODV5?=
 =?utf-8?B?TVYxV3RvNzE0akN4bkJHZzRid1lJa0x3ZzJUdHo5NTkwUTlKMXZhejV5eHJm?=
 =?utf-8?B?WFJuaEJtd3ZlRk1hTkNFWG9mekNwRUVlbngycmxNVURoSC82ZVNTelExR3dG?=
 =?utf-8?B?cHJ3YUtkWmNCaHFPSEN1WDQxYy9XQlVza2M2Mm1uZVdZQVpRQjkvbjVURHhB?=
 =?utf-8?B?Ykp1T2NhUldMYXRwRGllaHFyOEFFYTFtblMzQWdzWEVGVWV3cnNwN1RneDBs?=
 =?utf-8?B?aGtoNFQ1OThhS0g1bkY3M3VYWnk3Mjk1SnArWmVkbTNBRGtSdFVFMUs0dUxi?=
 =?utf-8?Q?4w7zLC2N2YCs/X7dmTKjMysFSjnn9rEuuO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:49:45.6211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 00431d79-d5f2-4c5e-1770-08d8b8d64ee8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/f7IZAT2k4+Aj4MPB+TdF8HHm5nQ59zTTdZwD7Op7E4IdkpsevVG/cqwUBvcf8DordFDBuGLceSBLUKpfCyJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3769
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

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 02a66008e9b9..1a143340103e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1278,8 +1278,7 @@ void __init sev_hardware_setup(void)
>   
>   	/* Maximum number of encrypted guests supported simultaneously */
>   	max_sev_asid = ecx;
> -
> -	if (!svm_sev_enabled())
> +	if (!max_sev_asid)
>   		goto out;
>   
>   	/* Minimum ASID value that should be used for SEV guest */
> 
