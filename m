Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2511E670B3D
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjAQWHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjAQWGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:06:07 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E4937B7B;
        Tue, 17 Jan 2023 12:25:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVAypxam+ZhHbqrkxQqYyayHKJwfZ6nKF7xYhWFJIieq+AS1PiPuKo/6eTYa+daPkF4POwRP1/mtQO/Hqg49xF9Ju2FEI+zswi/FlqBnjpmpc/3Y4yB2FBJnWu3gZ/mJfpb1qLy0ujsnTFvOUcDIfLWrvI1FsnKGiV7TEhKcNWwQDl9TP517J3AwKSQ20MjeYXmkSwL0+hSHl2f+A314LvYopBdR4/11W0HWUVwnYoulMApsqNYEJAVxXtwyqAnNjTcPMWXQYlWNJEn7X+gCbjD3r5d0R6t/tgNM6Cex79IRY47Fneyn88FrPzb9qmf7GzayFyzu5M2mVQ+QDhDQwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aey/CfhihK+P6+6D9II9LWTZv/YUp/JfDpF4Kg3/9s=;
 b=nZ/f27CqFVFZxQb3LXVZEHvq0QXFnxA8pYVSdlIscIuermkm01oqMRXC5TmhB2g7rn4uPBAvPCFZEvm/I+LVa/0bbkKbHE3eXoMGz/Wy6zAcJUmWvJ/eaFVA/h/NHJ31vasaN+5Ch8dE6znzBWEgjbkbWbfL8nA5xtYhy5kDmE3Jg4l21/MqHSNAdGkAa3JXMEcnpu6fCP6q/Gmz5aQoSKqyKdCWAG2UYWrnvI3txoi1x9SF5mRLTKnVmGT0KcwhlnUqB5dIVp+UvKALTokodrEQOPJmVXXdRfhC1Yy5Gj3Yb0yFUP1hdNPkAAjV/ljxI3JyRCt/Z47CQBQNR0rZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aey/CfhihK+P6+6D9II9LWTZv/YUp/JfDpF4Kg3/9s=;
 b=i2D9EFbLGuIy+2TTAQpjQy+PQQNvEWgC18/TBPVmv5brtvlkUhddlNPMvliI4aKaq7vfcHEvaaVHhwChdxcaX8l6wmgNsnh4CqNgdVz53LrZz605RYBGuXqawgxPgiq0rs7AIxfqPT3kMQKYP8VbK2c/WSDAd5rqVe5Icq3+w3k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BY5PR12MB4097.namprd12.prod.outlook.com (2603:10b6:a03:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 20:25:42 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 20:25:42 +0000
Message-ID: <d44feacb-7a07-c4c5-da3e-66cf6ee8df02@amd.com>
Date:   Tue, 17 Jan 2023 14:25:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de
Cc:     mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
        zhi.wang.linux@gmail.com, David Rientjes <rientjes@google.com>,
        stable@kernel.org
References: <20230116091036.72579-1-nikunj@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230116091036.72579-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0007.namprd05.prod.outlook.com (2603:10b6:610::20)
 To DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BY5PR12MB4097:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f2e5c23-0da5-48fd-85d4-08daf8c90171
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIEbhJSe5LgXx+amW0hGUYm3mnK8GTdEZKFDCog0wW30+V3hnio37QeXCtrD7BROwK/WPr26KrZKcSQfiACgIM2CEbeluCqfF9ljFqNE6ui2r5LW25x2ROlILdg2kG5yaLShqUcP/2RJF9aEjGmR1WjnH3gFDvZXhYeP/TN1ugu8P1RaKQIz5fvqkQstcnKJedJgno+MRphIq6xlM/d6xhWqvIsiATkeb0JV5Iub3vLZ6Mid1RAPtYFhBRHMVFUODhsCzZ2PF4gFmXZvphIDVMuASWGsHH6vP/nOCqGAJf3wnXSn1+PZdfJE/Jz175ZxQmAZ/aLDuT7fy+R3s8hS3uTqhr/f1eRFIw6C56PtTW4ON0UJPQmi89DV1AMlJwifu4nxahxrhY24Eq/FI7n7vc3iJBefgcbSojTGG/sPewY6Fl8YI2P0e6N15zHs6f5YV6xi+sXYhsEnaRIDK2PqcOiVRwLpRhCjWYq/EerqlWkKNcuWU0DCozoO+MSy6cXBL2VULR5NbbYYfzAVoEqrbi2dQhb4g+DuWNmTpFU76mEZpzn7OxbES1+QbiyeJGsYI5DfMAh2wAA1AgrytEVQFoWUiauXBvkRpvuGQLNRud4J+It8WW3Xt5xZqTudxYmEaLxHHFUxYUxvcpFjl2063djv0c1PRKlSf+apM2WuQJVkSgezjzhXDERQKJKKikGI48fVyCPUXWOsx/FKYewdY2OHtS021HQHVwz9U9scZkxgQLyT29KqHcQeBFpn5mnvV5B8jPg7uSUeNpY+bL4FEisev2GBUyD0sDztezOn9L2HYAjwr82cLK3U0a43Uh5O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199015)(31696002)(86362001)(36756003)(316002)(478600001)(6486002)(8676002)(966005)(7416002)(2906002)(66556008)(66476007)(4326008)(8936002)(41300700001)(66946007)(38100700002)(6506007)(26005)(53546011)(30864003)(5660300002)(2616005)(186003)(83380400001)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aS82QWw2aU9PLzhsWDRLa1A4ZE9ibGtCbWloaUpkSDhuTnFaSVdLMEFhb3JF?=
 =?utf-8?B?eHdHZlFNbE15QXRiMlpiY0RINjR0WUZHd0g2NFE5WXBRSkkvWUJPalNLdERn?=
 =?utf-8?B?NDcrVG9jd1c5MUpCbzdNdzc2UXhGbnR0RW1hdU9NVEY5S0hxUW9YTFZkSmVT?=
 =?utf-8?B?MENvcFJJeWhXYnpiY1hkVFFwMXQxK1pMaHhsbFZZNlNYMFNJUlF5RFZNbW96?=
 =?utf-8?B?QVZxRlpGaXVaV0hHYjFOZTJ2SS9qQ0hlSjBmNXM1S2RQU1hDYWp3VElOVGxw?=
 =?utf-8?B?aGRQZEZUTXMyR2JMMnh2L1ZyanJhYURQWUJnYy9IZGZzc1ltdXZjVE9DMTJU?=
 =?utf-8?B?U1lxTmFNYUVPdkd6c3V1cWQxMW1NdGRGMkpPWWo2MFhZa3Fva1U3MXBFOEEv?=
 =?utf-8?B?Vlp0VjE3cWwrSUQ0bmhpRFFrZklYRHN4WU5rR1hXelZ0UHVwVEtRTFprNTJn?=
 =?utf-8?B?amxsMWV5aGNkbkF6cnI0M0daVDVheVJkQWZSK05rZnZYVFozN3hjOVdDMFND?=
 =?utf-8?B?NGRZamsxZkhFVjNFelIyLzBpbzYyWjFKNUdrRk4vYTBPNmZWZzJNbzBsTDlP?=
 =?utf-8?B?RmdCNHBvTGVqb1lRKzZpLzVaQ3lqNEdoUDdoSEIrakxyOFJIUzZTNkRIbTRP?=
 =?utf-8?B?L2dGYzhOdmRiZzJ1LzR6M1BvZnpnazhiSEJ5SlpOR0VyN2p5YzJuRjJjNkdM?=
 =?utf-8?B?Wml3UGY1WFhhV3VPZno2OGpDWW9pVG81QWdJLyttS012WURNT0ppV0NxMjFy?=
 =?utf-8?B?NGtaMTFpYzIxcTMwVjFBWmlTTzY1MVJyaUJzTFJiSHBSUHNZMTJrenh5T1lD?=
 =?utf-8?B?a21tZXRqcUNrUm5rcTI3aFFDUHFRdDI2cnNsbEJPZnNxclFtcVlZWmQxeUlE?=
 =?utf-8?B?VFhnd2xpcHJQMThsYWJxb1VVZ2lTK0dmQkV3NnBISzRXM1EzcTl3N2xFWkRW?=
 =?utf-8?B?bTI4OEtGOFdzenB1ZzZOcW1xMmpoMFdPRHVjQXRaSkJVTmtjNkdYTTVwbXQ2?=
 =?utf-8?B?Mk42N3o4ZUNlelY3RlZMTnhBN3FXbERobWI4dTkydU1sMzloaGphdW8rN3Vj?=
 =?utf-8?B?T1RvbmNMaUkrOW42WHE4bjhDa2V4RzgyYTNwZXNPVmN2ZGpVVjFKLzJoelpM?=
 =?utf-8?B?clp0cW1zTjFkdUt3Y081YzFoNnRhV1YzdDFXTm1BUFJlcEpBblI3TldnOGxG?=
 =?utf-8?B?dnB0VDhRaGRKTDVnbWFLMGJmSmprUXlHaUYyT2JFQmlkaHhIb1haQ0ZhdjFy?=
 =?utf-8?B?NUVhTFpld1Z5Rlc3V2xZWmpuSkd6Y0hodDR6L3pRbjZqY1cyVGZhNy9jaFAw?=
 =?utf-8?B?S1BxY0htWEsvTXYzK1h3aEVMK1BraFFMOFZFUEZVdUUvWVU5SkpIUlhOME0z?=
 =?utf-8?B?a2hJWENUK3ViMXNyRnN0NDBxN2VuMWFIUzVteW8rQXg1UU1kVm1GNWRuSkY1?=
 =?utf-8?B?QmhQUDZRQ2NnbWxVbGxNOTB2UVlHVzBqZWRNa1ZnSGxZZEcycEhCcDU4SWMw?=
 =?utf-8?B?bnJOYlFQZ0xJOTZLdWpSdlZ6V1krRHdWMVJVRHF1NVVMWnVhMTBWemIwajQz?=
 =?utf-8?B?MWZmZDUyUTVMVE9LQjNNWXJHVlRrMHRBVW13cE9pSFhBckM2MVVMMlpzNTN1?=
 =?utf-8?B?WVhIOGVyUDBvbVRZYmE4R2FJTURSc3k0V1d2QlZCaFBhQnVzbXdzRU05eHoz?=
 =?utf-8?B?eFArcTk0YW9WZDR6TkJUOHM3RzdXVjBDd3JhU0UxdkdIWnVhRFZHcm5NN1RV?=
 =?utf-8?B?M2NiTEV5Z2RCZ1hHWWFtNUprVWtoRUlQaTg1RHVqdWlNZ0Q3Unc3ZXd2aFN2?=
 =?utf-8?B?TkpiTmpxb3JIcnVuOUswNEZyeElxRHZGa3VNa0EwVG5aYm5VZ21qME85QVpu?=
 =?utf-8?B?V3ZlaFE3M3dmV1V2RmV1cVB3MEhjcXF2ckdPdXNyb0pBdldOMkdyVkk2ai9J?=
 =?utf-8?B?NzRwY1NjSjAwN2lUVWd4RFhITTFSemRnYTNLVUdMZGF1UElXaEI5SlRBZFdQ?=
 =?utf-8?B?VFF3d0d4NE1za3hYdVNkZG54K2VBVlh0d1JuOEplMmpZK2k5OXVZVDlSRjBW?=
 =?utf-8?B?M1hwNWExMUJnWC9mZEN5ZEs2MnFKeGtuTW9oVWVyMm9MYXZNeDViQzhaK051?=
 =?utf-8?Q?fhzg9uqAtdHDN7Y7frCbHlw8w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2e5c23-0da5-48fd-85d4-08daf8c90171
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 20:25:42.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJZ+1UjKLqXB+6fp4KpS2l9sJChpridFVg9HyTRIPDT+fGsK9jqbU3P66zd04FZhTJ2Nl50oacx1W6l1uMA+6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4097
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/16/23 03:10, Nikunj A Dadhania wrote:
> The hypervisor can enable various new features (SEV_FEATURES[1:63])
> and start the SNP guest. Some of these features need guest side
> implementation. If any of these features are enabled without guest
> side implementation, the behavior of the SNP guest will be undefined.
> The SNP guest boot may fail in a non-obvious way making it difficult
> to debug.
> 
> Instead of allowing the guest to continue and have it fail randomly
> later, detect this early and fail gracefully.
> 
> SEV_STATUS MSR indicates features which the hypervisor has enabled.
> While booting, SNP guests should ascertain that all the enabled
> features have guest side implementation. In case any feature is not
> implemented in the guest, the guest terminates booting with GHCB
> protocol Non-Automatic Exit(NAE) termination request event[1]. Populate
> SW_EXITINFO2 with mask of unsupported features that the hypervisor
> can easily report to the user.
> 
> More details in AMD64 APM[2] Vol 2: 15.34.10 SEV_STATUS MSR
> 
> [1] https://developer.amd.com/wp-content/resources/56421.pdf
>      4.1.13 Termination Request
> 
> [2] https://www.amd.com/system/files/TechDocs/40332.pdf
> 
> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
> CC: Borislav Petkov <bp@alien8.de>
> CC: David Rientjes <rientjes@google.com>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: <stable@kernel.org>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> ---
> 
> Changes:
> v5:
> * Use ghcb_version directly
> * Add helper function - sev_es_ghcb_terminate()
> * Update broken document links
> 
> v4:
> * Update comments and indentation
> * Reuse GHCB MSR Protocol reason set
> * Invalidate ghcb page before using
> * GHCB protocol NAE termination event is available after version 2,
>    verify ghcb version before using the termination event.
> 
> v3:
> * Use GHCB protocol NAE termination event SEV-SNP feature(s)
>    not supported along with SW_EXITINFO2 containing mask of the
>    unsupported features. Need handling of this event on the HV.
> * Add the SNP features check initialize_identity_maps() when the
>    boot GHCB page can be initialized and used.
> * Fixed sphinx warnings in documentation
> 
> v2:
> * Updated Documentation/x86/amd-memory-encryption.rst
> * Address review feedback from Boris/Tom
> 
> v1:
> * Dropped _ENABLED from the feature bits
> * Use approprate macro/function names and move closer to the function where
>    it is used.
> * More details added to the commit message and comments
> * Fixed compilation issue
> ---
>   Documentation/x86/amd-memory-encryption.rst | 36 +++++++++++++++
>   arch/x86/boot/compressed/head_64.S          |  9 ++++
>   arch/x86/boot/compressed/misc.h             |  1 +
>   arch/x86/boot/compressed/sev.c              | 51 +++++++++++++++++++++
>   arch/x86/include/asm/msr-index.h            | 20 ++++++++
>   arch/x86/include/uapi/asm/svm.h             |  6 +++
>   arch/x86/kernel/sev-shared.c                | 17 +++++++
>   7 files changed, 140 insertions(+)
> 
> diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
> index a1940ebe7be5..934310ce7258 100644
> --- a/Documentation/x86/amd-memory-encryption.rst
> +++ b/Documentation/x86/amd-memory-encryption.rst
> @@ -95,3 +95,39 @@ by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
>   not enable SME, then Linux will not be able to activate memory encryption, even
>   if configured to do so by default or the mem_encrypt=on command line parameter
>   is specified.
> +
> +Secure Nested Paging (SNP)
> +==========================
> +
> +SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be enabled
> +by the hypervisor for security enhancements. Some of these features need
> +guest side implementation to function correctly. The below table lists the
> +expected guest behavior with various possible scenarios of guest/hypervisor
> +SNP feature support.
> +
> ++-----------------+---------------+---------------+------------------+
> +| Feature Enabled | Guest needs   | Guest has     | Guest boot       |
> +| by the HV       | implementation| implementation| behaviour        |
> ++=================+===============+===============+==================+
> +|      No         |      No       |      No       |     Boot         |
> +|                 |               |               |                  |
> ++-----------------+---------------+---------------+------------------+
> +|      No         |      Yes      |      No       |     Boot         |
> +|                 |               |               |                  |
> ++-----------------+---------------+---------------+------------------+
> +|      No         |      Yes      |      Yes      |     Boot         |
> +|                 |               |               |                  |
> ++-----------------+---------------+---------------+------------------+
> +|      Yes        |      No       |      No       | Boot with        |
> +|                 |               |               | feature enabled  |
> ++-----------------+---------------+---------------+------------------+
> +|      Yes        |      Yes      |      No       | Graceful boot    |
> +|                 |               |               | failure          |
> ++-----------------+---------------+---------------+------------------+
> +|      Yes        |      Yes      |      Yes      | Boot with        |
> +|                 |               |               | feature enabled  |
> ++-----------------+---------------+---------------+------------------+
> +
> +More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
> +
> +[1] https://www.amd.com/system/files/TechDocs/40332.pdf
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index a75712991df3..551d583fac9c 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -557,6 +557,15 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
>   	/* Pass boot_params to initialize_identity_maps() */
>   	movq	(%rsp), %rdi
>   	call	initialize_identity_maps
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	/*
> +	 * Now that the required page table mappings are established and a
> +	 * GHCB can be used, check for SNP guest/HV feature compatibility.
> +	 */
> +	call	snp_check_features
> +#endif
> +
>   	popq	%rsi
>   
>   /*
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index 62208ec04ca4..593415e22614 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -126,6 +126,7 @@ static inline void console_init(void)
>   
>   #ifdef CONFIG_AMD_MEM_ENCRYPT
>   void sev_enable(struct boot_params *bp);
> +void snp_check_features(void);
>   void sev_es_shutdown_ghcb(void);
>   extern bool sev_es_check_ghcb_fault(unsigned long address);
>   void snp_set_page_private(unsigned long paddr);
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index c93930d5ccbd..e7423da79d33 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -270,6 +270,57 @@ static void enforce_vmpl0(void)
>   		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
>   }
>   
> +/*
> + * SNP_FEATURES_IMPL_REQ is the mask of SNP features that will need
> + * guest side implementation for proper functioning of the guest. If any
> + * of these features are enabled in the hypervisor but are lacking guest
> + * side implementation, the behavior of the guest will be undefined. The
> + * guest could fail in non-obvious way making it difficult to debug.
> + *
> + * As the behavior of reserved feature bits is unknown to be on the
> + * safe side add them to the required features mask.
> + */
> +#define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |			\
> +				 MSR_AMD64_SNP_REFLECT_VC |		\
> +				 MSR_AMD64_SNP_RESTRICTED_INJ |		\
> +				 MSR_AMD64_SNP_ALT_INJ |		\
> +				 MSR_AMD64_SNP_DEBUG_SWAP |		\
> +				 MSR_AMD64_SNP_VMPL_SSS |		\
> +				 MSR_AMD64_SNP_SECURE_TSC |		\
> +				 MSR_AMD64_SNP_VMGEXIT_PARAM |		\
> +				 MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
> +				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
> +				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
> +				 MSR_AMD64_SNP_RESERVED_MASK)
> +
> +/*
> + * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
> + * by the guest kernel. As and when a new feature is implemented in the
> + * guest kernel, a corresponding bit should be added to the mask.
> + */
> +#define SNP_FEATURES_PRESENT (0)
> +
> +void snp_check_features(void)
> +{
> +	u64 unsupported_features;
> +
> +	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
> +		return;
> +
> +	/*
> +	 * Terminate the boot if hypervisor has enabled any feature
> +	 * lacking guest side implementation.
> +	 */
> +	unsupported_features = sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT;
> +	if (unsupported_features) {
> +		if (ghcb_version < 2 || (!boot_ghcb && !early_setup_ghcb()))
> +			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
> +
> +		sev_es_ghcb_terminate(boot_ghcb, SEV_TERM_SET_GEN,
> +				      GHCB_SNP_UNSUPPORTED, unsupported_features);
> +	}
> +}
> +
>   void sev_enable(struct boot_params *bp)
>   {
>   	unsigned int eax, ebx, ecx, edx;
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 37ff47552bcb..d3fe82c5d6b6 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -566,6 +566,26 @@
>   #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>   #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
>   
> +/* SNP feature bits enabled by the hypervisor */
> +#define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
> +#define MSR_AMD64_SNP_REFLECT_VC		BIT_ULL(4)
> +#define MSR_AMD64_SNP_RESTRICTED_INJ		BIT_ULL(5)
> +#define MSR_AMD64_SNP_ALT_INJ			BIT_ULL(6)
> +#define MSR_AMD64_SNP_DEBUG_SWAP		BIT_ULL(7)
> +#define MSR_AMD64_SNP_PREVENT_HOST_IBS		BIT_ULL(8)
> +#define MSR_AMD64_SNP_BTB_ISOLATION		BIT_ULL(9)
> +#define MSR_AMD64_SNP_VMPL_SSS			BIT_ULL(10)
> +#define MSR_AMD64_SNP_SECURE_TSC		BIT_ULL(11)
> +#define MSR_AMD64_SNP_VMGEXIT_PARAM		BIT_ULL(12)
> +#define MSR_AMD64_SNP_IBS_VIRT			BIT_ULL(14)
> +#define MSR_AMD64_SNP_VMSA_REG_PROTECTION	BIT_ULL(16)
> +#define MSR_AMD64_SNP_SMT_PROTECTION		BIT_ULL(17)
> +
> +/* SNP feature bits reserved for future use. */
> +#define MSR_AMD64_SNP_RESERVED_BIT13		BIT_ULL(13)
> +#define MSR_AMD64_SNP_RESERVED_BIT15		BIT_ULL(15)
> +#define MSR_AMD64_SNP_RESERVED_MASK		GENMASK_ULL(63, 18)
> +
>   #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
>   
>   /* AMD Collaborative Processor Performance Control MSRs */
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index f69c168391aa..80e1df482337 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -116,6 +116,12 @@
>   #define SVM_VMGEXIT_AP_CREATE			1
>   #define SVM_VMGEXIT_AP_DESTROY			2
>   #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
> +#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
> +#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
> +	/* SW_EXITINFO1[3:0] */					\
> +	(((((u64)reason_set) & 0xf)) |				\
> +	/* SW_EXITINFO1[11:4] */				\
> +	((((u64)reason_code) & 0xff) << 4))
>   #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>   
>   /* Exit code reserved for hypervisor/software use */
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 3a5b0c9c4fcc..d6786c6407a6 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -164,6 +164,23 @@ static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
>   	__builtin_memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
>   }
>   
> +static void __noreturn sev_es_ghcb_terminate(struct ghcb *ghcb, unsigned int set,
> +					     unsigned int reason, u64 exit_info_2)
> +{
> +	u64 exit_info_1 = SVM_VMGEXIT_TERM_REASON(set, reason);
> +
> +	vc_ghcb_invalidate(ghcb);
> +	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_TERM_REQUEST);
> +	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
> +	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
> +
> +	sev_es_wr_ghcb_msr(__pa(ghcb));
> +	VMGEXIT();
> +
> +	while (true)
> +		asm volatile("hlt\n" : : : "memory");
> +}
> +
>   static bool vc_decoding_needed(unsigned long exit_code)
>   {
>   	/* Exceptions don't require to decode the instruction */
