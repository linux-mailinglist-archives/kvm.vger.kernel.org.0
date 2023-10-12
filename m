Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1669E7C68D5
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 11:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbjJLJBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 05:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbjJLJBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 05:01:41 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A9E98;
        Thu, 12 Oct 2023 02:01:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHdeLQl+LjOVUv73f6MywCFiKg+7B/hTPJzbGHbU/U9Iz4lryfxBbHSk53u3yAsHDRR1M+aIaYInM7/NB8GCoIffVXq7j3L/7bem1F9AG+6E7n0xZ0UtaHeCNYpf4sdJEA59PiSPag5spZVtbm5geASzc80Ke6EyNhKI84vtTyK9vQvzn7onfbVMNLThLKB8pVCjNtQMKLsAwFaMqjNVTtdkmyCisDsoLFjK2Df06akKWfKmnKm4C4g/xlpJU9NGK9+Xzk38eX1oz9WbELH27yN/b4pTmhEmLRx7dJISN/e51BgJqfay9xud3WXfo4ZO0lLztkTdGHZOjkrAKfforQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmEIjwCPZCqnnaApdgmoGNnvJuNdri30urXZs9lHwGw=;
 b=MxK14WRWs6jQ+6WgbSydpLBzvhsQEDdbtxcfA4rtnjA2f14jdwa8fno8PZsqjUSqEYMR7g84bk/bt3puCBwY9NLyTzejgzzSUO8OmHT5XEVveokQyCKxnnmLMtk5GXq1CVwaRqQEzB7FSiXtub68lS2sF50u62FNFpQICIAbMAzpwfJLBTU5EHrS8EW4FLnNk68Ys6qDi4DI/9dWHIHAZ5Vzl05VVKW4gf606WNs/5RQIjtzOxpLh/3DonQ7O0ajJwq1npPvNx03lu3mq+zfHJzmYVSJQe1CPsoj4erBjCfAJ/QLyo3dXM923Wgm/UYeVV1PvxEGOMffJOJ7HlmkCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmEIjwCPZCqnnaApdgmoGNnvJuNdri30urXZs9lHwGw=;
 b=UCl8xjBXUc9hPzMyTdJPbeeJv3wFXU3Qa4jgxJHFrjAOB76xaQ4r5cvWj3iTXDMLbu2L3lvfmtytKRfldYg9QegbzK5avvuoVmDRiVye24nV9v6Z+KrHGogl6SY78keHNmvD4qOAQV6bpe2QFbQQZR+YKva7gnBr99SM2MKP7Kk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA0PR12MB8254.namprd12.prod.outlook.com (2603:10b6:208:408::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.44; Thu, 12 Oct 2023 09:01:33 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6863.032; Thu, 12 Oct 2023
 09:01:33 +0000
Message-ID: <8484053f-2777-eb55-a30c-64125fbfc3ec@amd.com>
Date:   Thu, 12 Oct 2023 14:31:19 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 3/9] KVM: x86: SVM: Pass through shadow stack MSRs
Content-Language: en-US
To:     John Allen <john.allen@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        weijiang.yang@intel.com, rick.p.edgecombe@intel.com,
        seanjc@google.com, x86@kernel.org, thomas.lendacky@amd.com,
        bp@alien8.de
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-4-john.allen@amd.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20231010200220.897953-4-john.allen@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::22) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA0PR12MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d96423a-3f65-4ce2-b524-08dbcb01d484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q3CcEUlYYfUZN/J9uhQ516H+rHD5klKNnICnW4pV3Ev+Lg0WHYr0bkYOHpBUsj2uucM8t9gyfAJFQiSbQyNl49OKlviz0ch02BWoYZQOSlO+HPAlGZqqxA8och1aJg0i78LWvWpoShjLHFDRI1U+xZhXJJg9womEUU2nKbmhLDUMBqfkr+eQwaoQVkNNpHv275AigwcYQTZc+shWoKBgOLYLwVK65mR6Twt0B+99Q0i3nfHGMnxhn/PmTIBLvzXEf8S1+3sJgoN0YiA2N6YOHKuvwNFluOsnJHW2AC4DG5HBNyb5wAs5utcpRqtQbMGgQcsisRDsknTCs8Xp6uNmzOO34IwqytWHLXuOU18hTxqfTz/NVZ22MuH11Msh/Lq5aCZzeRGOWAUW2KuH08FPSzgUGNitBt5YF9mlm19piii+jWQJ3QJiZqt7PbrGvTAYn2tVwEVpwaVA4LWGXPm0GGJJgH3tDR80XI21qCqc+MKBjQffVScLk/Z1fvqoxxPiqMNBOgLE/GQUQ2eKx3PVZOTpRwpLBPARaqSzZQqmh4Nmnsyz5hd18ELjWe+/8bPaYetVkFscF9bI36kmw6bkFibiApED5i0h0PwV7SGn0d72ciZMdxuKcotV75IFguua06inYJNZbLgX+jrkc6xMcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(366004)(376002)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(2616005)(26005)(316002)(66556008)(66946007)(66476007)(8676002)(8936002)(4326008)(53546011)(36756003)(6512007)(2906002)(6506007)(6666004)(83380400001)(31696002)(38100700002)(31686004)(5660300002)(478600001)(6486002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU5QbWU4eDFXYVpSZmpEU1pNMGl0NFZYck5jNmMyRmpWNHZHQ21yVEhYOVUy?=
 =?utf-8?B?MXQ1L2JuQVJMWFlydy96WXFjM0xoUkdodlh6U2ZEMFd0NWhDeXcrVmMyL1o3?=
 =?utf-8?B?b1Vzd1NQalJ5UFRwUERiMTUyYnpWU2UwOVkxSVVrMDg4Z1ZKUEd2SGNqOFBM?=
 =?utf-8?B?dGkwaWNCT3YyaSsxaVdyVWJDM0htVmR2ZUlFa0grREcraFNxU3JpQ0N1alJY?=
 =?utf-8?B?eGREd1NkT050QzNiV0RROC9DZkhWMjQ3V1F5Vm1kRjNKK2sxQ3c3ODAyLzlH?=
 =?utf-8?B?amcwb1A4bFBsUEVyU1ZWaWthZFZEMFltL0lZQk8wZDBZYWhNVmJTWnAzcEtw?=
 =?utf-8?B?anRiOUo0My8zVnptcFRHZE8zbWtzOWIrckNZdU9GY0ZaUW5KOTV3cGNFVjNJ?=
 =?utf-8?B?SnplU1ZCNnAyK0dtQy9QT3hGR3hEdFcwb3hHUEpCR05LODljRXZXd1R6OGVP?=
 =?utf-8?B?bWIxSkJJYkdISzB3SW56MlphTDJIaG4rY3hJUlpvOHhRWENtMHFiMzhDWmM1?=
 =?utf-8?B?N3hpM1hzYnJ0QWRpQ0JDaENFdWFPSkdiR29DWExzZmwxaFlMSGZzVGV6QXFu?=
 =?utf-8?B?NUw2K3pDUGhKc1psdFdXaVdiU2Q2aVlydlpqL2VTUUx6eVFycXEzOWFQOGc1?=
 =?utf-8?B?R3JqRmhWUi9Pck80QXc5OFI1U3kwUDdVTDl5clNuSUxQL2VWMGtFREJ2SFUr?=
 =?utf-8?B?d3NoMSs0TnpyV05YYlBnU0kzdW5NaXBjV1ZDZHV1Q0VCVUVhbUFCYVdLdk5q?=
 =?utf-8?B?SlRObmY2UmY4blRpY0VWMHZsYXlaSjJzN0JiUW1PR0xrUHVqeXo1Y3lvZFVj?=
 =?utf-8?B?N044VmtrOWlGTnpJdmdvY0pETlJnWlcxSDBadURwN1ZGMTNoMWlWUnl2b1Qz?=
 =?utf-8?B?Uno5WURYSzhqblEzWElvMUkvMnNPTHBmeENaT2VZTFZReEpRNFNoOTliRmtz?=
 =?utf-8?B?VE84L0pJZ3RwbXJzaHdoRm0rTk85cm9Fd29GVmltckFubytyMWl4QjJFYnRN?=
 =?utf-8?B?QnhXMU8rN29rT2U2ekhpdTNjK1JGaXBnZkJOS2UxYzZOL0l6VENVK0plVVg4?=
 =?utf-8?B?Ukh0OGR4YXpRVVEzL2tMSVpKSy9tRlJjM2ViTXhWNTl2aXJoMGlUWU1uakJx?=
 =?utf-8?B?Q01ieEJPQlRMLzUxamJwV1BnUTJnQ3RBZk04cHFPeTEvN1g1NFZ6ZGQ5TEF2?=
 =?utf-8?B?aXh0ZGs4blJHSnRydHVhV2QzMTMwakIzZjk0eW5SZ3VteUxsMTRNdDFXR2hx?=
 =?utf-8?B?RFlGalJFZnRUZ3JILzFVU2RBeGl2dURKaEp6bHU1cjBpTUdOeXRpQ0llWUxt?=
 =?utf-8?B?ZS9kajFWV0RRbW9pYWZWUjFyYmI3c3UrdkRnTFVydHRXYnNlYVhRUjlzcmxo?=
 =?utf-8?B?NWVNWkVTanJYWFZ1eEMzU2g5ZXRHNW4xd2pCbmRtUHdaMWUrT3JQdno5aWhW?=
 =?utf-8?B?TkVkZzhaMFhkQVdPQW9RdmlsL1JCUXVTMklSb0d6dGhwVEN6aU5DNTJUbWNq?=
 =?utf-8?B?WlV2WjB4VmhmTG51eGF3aGpBa0FlMUpsdlpZYXl6dFdyeEd0aldXeHJJRU1Y?=
 =?utf-8?B?MTFjcXhEejFjSTJDbUVIYlU3bnRvWHMyRDJ4MkF4aDhtUUpuUDF4NlBId21F?=
 =?utf-8?B?YStOZWlvNDVKeXBxWm9FTjhXdk9ST3pJSXduVnlEQjhDR1NLUElEVFBhd0dL?=
 =?utf-8?B?WjhJR21qMllSVFluanZhSi8rLzJ6ZUh1UjEzK0FUOWExWC93bDJMT2tFYlVl?=
 =?utf-8?B?SE9zK0lXQVRJVlRlcHhPS2FtNjkrelVGVHJsQi9mY1A1ZitwbFFydDQ0a3ZW?=
 =?utf-8?B?aGh4Q1RYNzdINCtab08wa1NvQU1zdHVBRVo2RlczK1Q2azBOM2N0TkVVLzRx?=
 =?utf-8?B?VVZ6QlhVdmhPYXdLQVF5QUFaS0Z4TTd2SDNmeEVZdWx5RHc3TDVxcDErMUdy?=
 =?utf-8?B?a1Q3eC9RM1VJRkNtUGYwMU92SUJPUUh5ZHc4WTd1T2RCYnVhV0FzRzZVYkxJ?=
 =?utf-8?B?eHh4NEZycnBQYXhjZkJNeDhnOFg3QXZpVWw4TGdjWmF2a2RFM0ZqV1RzUnRy?=
 =?utf-8?B?b25vb0V0QUJOTGhWeTFtN245a056d0dOZitlbGUyb253NnF5clhNaDVoRDg1?=
 =?utf-8?Q?qUFatWun8z9/A2oAC2tzGmIMa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d96423a-3f65-4ce2-b524-08dbcb01d484
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2023 09:01:32.9357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAWupr9YwtZKS81zP6utD6zp1muHFYlyCu/LtZhWTEEwKOGD5EuPUVFmyIZOmRBpRWsUfUg4EGKpPeMPySSZbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8254
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/2023 1:32 AM, John Allen wrote:
> If kvm supports shadow stack, pass through shadow stack MSRs to improve
> guest performance.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h |  2 +-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e435e4fbadda..984e89d7a734 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -139,6 +139,13 @@ static const struct svm_direct_access_msrs {
>  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> +	{ .index = MSR_IA32_U_CET,                      .always = false },
> +	{ .index = MSR_IA32_S_CET,                      .always = false },
> +	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
> +	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
> +	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
> +	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
> +	{ .index = MSR_IA32_PL3_SSP,                    .always = false },

First three MSRs are emulated in the patch 1, any specific reason for skipping MSR_IA32_PL[0-3]_SSP ?

Regards,
Nikunj

