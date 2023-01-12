Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B3E667841
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 15:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240251AbjALO4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 09:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240156AbjALOz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 09:55:27 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DBD1173;
        Thu, 12 Jan 2023 06:42:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGkFnaNCMbYduho48BE1/jkkRUz/PHGS10S3pFbCSZZoUJPpws9Dmzoz+5If7ADLfeUuExz/4WCC+0kRIQN2DK0tOceAUhCY+5YAnJJYgUNiWnb2+KMkftbgPmmWxd7ROd8xTunTmw7nAKjYFLj8n9/vwVAWCe2BafdtweNazahO3h209GBwtOJVQMaK0s58URQKHvbBNU9OnQa8wkRM3otuLp6eiL90wOVSggW3qdeS6+lDa8r0Ak60CVA0hyvY9VXZBKyMh4JmKpJ+rdRiLJ2SZMy7+7Cp6cTcwpcxddrAuQARoD6oeCRucp+Cg04XL1bNYRsc966vxNQocgoTsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HjgOklrcYZYSX9GKmabl6yWaGGN/4DxEzdef/FNFqU=;
 b=ay3t8IAh5iNp0ZoBwDSvXlJvrSn/SXGGHOxH5P5KWRIAKxUKNB9qgpD1VNF4F3gL29A/buCK9RIX4esVd3jjrKb0yn9qfUS+jEfqR6CcWsJj+riF8P35NP43D4ZAp7hA2BZz3dWiu1vS984zu6Qj09tOmJtbXLa9Zdlh7tewX1eIUrD1Ccq2Rb/R6OgdZ3+7onApjkmbtxzpad8qfKFvXdb+DQ2BsMm3CylsadJcTQWQ6Xkm46RphSrCgqRT1Fbe2RPWv8So/WecN6KgR1RzGarAymk4Y4GQd/NPHXw+zYmKLDXNqV+EPj4w/nUlxCnLSH3pcUBftZYfxJbjTwyohA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HjgOklrcYZYSX9GKmabl6yWaGGN/4DxEzdef/FNFqU=;
 b=OMSgpbmC0goT30GHHswADcF9pupHxRvPNTRi2fQnZs7j6KKyOQVf6krwGEWNIvmNSBHxiunbT/MPmlOHQxENRD3ZUaZ6yZ7fiv3Z5KSPHlQPjFuPQVzi0lOobKUR06wBn4uXyaNFbmZcL2FS4+lFeyohL9DZbK2UhAvTm2g6AJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY5PR12MB6177.namprd12.prod.outlook.com (2603:10b6:930:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 14:42:38 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 14:42:38 +0000
Message-ID: <4cf6a6aa-81f9-4fae-2a39-1825433f9ee4@amd.com>
Date:   Thu, 12 Jan 2023 08:42:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de
Cc:     mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
References: <20230112084139.12615-1-nikunj@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230112084139.12615-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:208:15e::35) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CY5PR12MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 34cc50be-95a1-4759-0d6b-08daf4ab4002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qlh8Bpl9d5scQn6Pv9gR1pf6W6IW1CT76mRbpGfX6NvjfwhPpV3b9YgRub9H/Cp7yVuXW+D5fiBxybinzPkfXbOOeCMO1ExYJ660lV3uCv6njPbC1d76dSOV+nw2MtwOg698YH+Zur8A5jHEHHmy44RiEd2I94uCe5WhLmsECn4YaHaAPs7A2Vs5FAwCfpcmm91Lq9GVtzg3CR7AkPqXI2RMy8OlwFzM08N/iqgXzPGhUNhSa19nxH0LFNJst87lLVIzB6Zx6Lh+/tc+kQntkd6+ynem52COo+mhjoHMm1lTDHBiZTZxHBFUxwPApHrMZivR6MIuEk6GDqo0Cnm2MmCvom3OUo+dJ8c2b/+xi52hpL3P/N92qfBAKf1OB40x1/a/40JsNcwa2Fxbi/WIkuYKMzp/u3lnSVbt1SmHhv9mUgvzSZpfTvQgoBZw3ztM4TBtRc0BWVmxzQwp5vP00l+j3yFKBVVBgOKdWaW2y3qRRj3ez3nGr1dB+2DLodQTxDttcUDGf6Qtcl4JJbuZ2ItDckJmP9818iQkG9RiLN1iVKfQQXQLQjWuBSYsEwDCQ7coQZRwrYEPGMuYIrXiWVyELk01WCHWlWtfxxdV74fJnUoVrkZeCFdoeaG+Nlweee9Mg3FjawAKG2poXupvVPqPTWkxfkldv/tTpD31htWtEUa/ARrf+v9wEn+G8hDuCpAIRvcMBrWGmU4hr4uZjsPTmNwWITGH3G/cckhxoQw8cLpS54GQI8V1UPbdOlE5ydfozrrgu+vZL7yeRMSBcPEQcEvF3aCyNachImdieeU29Evnsgs0on1wWFQLYhBD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(451199015)(30864003)(2906002)(5660300002)(7416002)(186003)(316002)(36756003)(2616005)(38100700002)(83380400001)(966005)(86362001)(6486002)(31696002)(53546011)(6506007)(26005)(478600001)(6512007)(31686004)(8936002)(8676002)(4326008)(66556008)(6666004)(66476007)(41300700001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWhVYmdWOStwWnpJYVQ4THVEdE8zdG50enh3QVdhaU5GWjZkQ2JvalJRNVc3?=
 =?utf-8?B?WWUzOUxabnlaZEdPdmRTNno5Zm9rQkNDeUhRczhDVVFYaklqUVlvdWJ5bElT?=
 =?utf-8?B?eUNFNVIzeFRaZUhSYU8yQlhkUGNxMjRtSTdWR2NBazFqS2hTcGxpVnZFMUxr?=
 =?utf-8?B?dlIwa0NOUUVvNVVqaXk2TElram9DYUs5b1M1VVhFWnEvelVXa1haS0VTM2tG?=
 =?utf-8?B?WCt1NmRDNklyU1F0MnZ3eEhsNm9JenNheFNqdmhyV09Ba1F3OVpvQjBGamhF?=
 =?utf-8?B?d05zTTBPUzkyUkVDY0YzWUZmcWt2ZHA5QTBhZUpNV3JkcFN3TlhQcHIyZHNU?=
 =?utf-8?B?TVQwWVdmVk5ERTdKYzBRclR6MXFaZm9aNG9rZGk5WkRENHJDaThQdjVRam85?=
 =?utf-8?B?ck5uRnB6eFM2REphUTB6aDNjcjEwRmt3bU80MmhNVUNSdUtmeUFaWmV5NXRz?=
 =?utf-8?B?RDJGckFMcEJNeEp1N2dwVVJlSUw0d0NHRHhWdStYVDBVK0ZpQVZyMGR0WWty?=
 =?utf-8?B?c0kzekFrSHMzcmQyNDJnYlhIajliUXpHVzJmaXRna0tMUURHU2FGTHpSb0gw?=
 =?utf-8?B?cUQxYThWZjVja1BDeE5BQ0lLN2RZUTdLNUVqdndCMzkxV0ZIRlI2dGhrZGl3?=
 =?utf-8?B?cjF0WWtyd25BM1RadEo0YjlKMU1lVnIreU5mVGpWd2dtZElqejhUeHFPNmpV?=
 =?utf-8?B?NXUxTlBYVmxFUmNmN3NHbmxvOU9ZK3B1K2tKOWZwbzdJbjdBOUlyL2pESGJj?=
 =?utf-8?B?ZXBKSS9WQzVNQlRuVFA5K1JrVTZMLzlFYnMvdXZLdEZSdEd3K3dZZjhXTnFN?=
 =?utf-8?B?LzdRNE9RYnY5L2lFWlM5c1RjVHg0VWZvQ0Zzelo3VnJkWEJjZ3F6b1NFbmJO?=
 =?utf-8?B?TkxWcHltcndkM3NNa1F3YWNRTUVLTHk5TktFYk1XNnhrVFE5VGM1NnRuZ2h6?=
 =?utf-8?B?OEtaQXBadi9CZzROTWVVamViREZoSloxYVNlK0hxejhKQjVYejhSdDlZMito?=
 =?utf-8?B?aDZLN2lFVmRWc0tPaW4wb1JLT1hpWlZkT1NoRno5Y2F4Y1h4ZVZpTzM0TVFL?=
 =?utf-8?B?d2xROGNsZUtHcytsNU54QldRRTVvQkx3ZXdmNFBiQlM1TllZTnYwV2VEQlpV?=
 =?utf-8?B?N3pvcnZTVXR2L0I5RldhTEFWN3dUNFJsaER5cjFaK1FhQmRXL3hWSVIwRzNO?=
 =?utf-8?B?S3ZZNUYxYU92ajByL2ZxUXkyeUNZSWF1WHlkVTdtWG9ORzZrU2pVYlpuRCty?=
 =?utf-8?B?dlI0ajd1VnZlTTNFbGUxMUUwbml4eGpMUXdBL0lhaFpNTEpFMTBkempUOFVN?=
 =?utf-8?B?bWtyTFYvRDMvU2hBN0g0NHFIdFZyMysxMStaUXpiU0MwRU1HdFZNNXJBSmdq?=
 =?utf-8?B?YkgramRZTUpydERTQ3Z2QkFOS3p2a29JWGNZY2FxSXpSeG00Zkdtc3hPbXN0?=
 =?utf-8?B?SmxSeGordTlMdGMxMVdsY3o5dGo5K3hTVkNFeDZHdURUQk1aczhSakpidmFR?=
 =?utf-8?B?YWJwbExDdHJZL2w0SjIvL3A5Skt1dnN3Zkh4ejY5TExPZDJGZGNmOFcrdVVH?=
 =?utf-8?B?UElhb1NtZHFTSTA4QVdPVGFhWFhJZW5zRmtDQXd3cm1YYW52TG5DbzFJRGVI?=
 =?utf-8?B?T0JRTzBtMFY1UFFiUlBSVnptSWxMSXA5NTNsM2R0U1BDNzNmWXcya253MGo4?=
 =?utf-8?B?T2R2Wllheko4OHFoMGFncHByVE9OOUN3ek5BaVJNbnFZWTNvME5uK2FRVC96?=
 =?utf-8?B?TUpoRE9pYU5TblJqUTlFWnIxb0lJL2dlMDlpeFlMMW5lMzRyQWRkQ2t6MXdT?=
 =?utf-8?B?ZUd0QnM2NzJ4UVk1M2NmcStJSVJ0R2kvanppU1NkeXQ3b1IxdlFnSFlWYVFU?=
 =?utf-8?B?NnNqdjdBRXVLZ3NJTWx1YTB1VHZBWnBMMWdRbXRCaEVGNHprcXBodEpDSWJZ?=
 =?utf-8?B?Yzdkb04vZ2ZBdzFlZy92TlhLT2Y5UVFGMjV1aU5pdHlXYXYyanBTOWNjR2lk?=
 =?utf-8?B?THRVN1JFTGRmT0JmMWxyRTY5blZQRTdnTE9COTl5WndYanpubGs3bG5EdG9r?=
 =?utf-8?B?UGF2ZFdRb3VCYXJINmprYy9DUEg3ZUtaeTJzelBJbDRIdzFnbzBEYmxTcGho?=
 =?utf-8?Q?59fQ3U7JsGlcQ5omNaMdp8Q3s?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34cc50be-95a1-4759-0d6b-08daf4ab4002
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 14:42:37.9307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtNNxvMp6aDeesAxWD/0fokH6wDW57S8pPXSXujSP03om1gcsApXsP9ZHODzHsYinkGFvEMvwvFDPOllc1eDyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6177
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/23 02:41, Nikunj A Dadhania wrote:
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
> [2] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
> 
> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
> CC: Borislav Petkov <bp@alien8.de>
> CC: David Rientjes <rientjes@google.com>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: <stable@kernel.org>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> ---
> 
> Changes:
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
>   Documentation/x86/amd-memory-encryption.rst | 36 ++++++++++++
>   arch/x86/boot/compressed/head_64.S          |  9 +++
>   arch/x86/boot/compressed/misc.h             |  1 +
>   arch/x86/boot/compressed/sev.c              | 62 +++++++++++++++++++++
>   arch/x86/include/asm/msr-index.h            | 20 +++++++
>   arch/x86/include/uapi/asm/svm.h             |  6 ++
>   arch/x86/kernel/sev-shared.c                |  5 ++
>   7 files changed, 139 insertions(+)
> 
> diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
> index a1940ebe7be5..b3adc39d7735 100644
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
> +[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
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
> index c93930d5ccbd..40c5f8bc733d 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -270,6 +270,68 @@ static void enforce_vmpl0(void)
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
> +		u64 exit_info_1 = SVM_VMGEXIT_TERM_REASON(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
> +
> +		if (sev_es_get_ghcb_version() < 2 ||

I would just use ghcb_version directly here.

But if you really want a function, that should be a pre-patch that also 
updates the other areas that directly use ghcb_version.

Thanks,
Tom

> +		    (!boot_ghcb && !early_setup_ghcb()))
> +			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
> +
> +		vc_ghcb_invalidate(boot_ghcb);
> +		ghcb_set_sw_exit_code(boot_ghcb, SVM_VMGEXIT_TERM_REQUEST);
> +		ghcb_set_sw_exit_info_1(boot_ghcb, exit_info_1);
> +		ghcb_set_sw_exit_info_2(boot_ghcb, unsupported_features);
> +
> +		sev_es_wr_ghcb_msr(__pa(boot_ghcb));
> +		VMGEXIT();
> +
> +		while (true)
> +			asm volatile("hlt\n" : : : "memory");
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
> index f69c168391aa..a04fe07eb9a8 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -116,6 +116,12 @@
>   #define SVM_VMGEXIT_AP_CREATE			1
>   #define SVM_VMGEXIT_AP_DESTROY			2
>   #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
> +#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
> +#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
> +	/* SW_EXITINFO1[3:0] */					\
> +	(((((u64)reason_set) &  0xf)) |				\
> +	/* SW_EXITINFO1[11:4] */				\
> +	((((u64)reason_code) & 0xff) << 4))
>   #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>   
>   /* Exit code reserved for hypervisor/software use */
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 3a5b0c9c4fcc..38ec3386984a 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -158,6 +158,11 @@ static bool sev_es_negotiate_protocol(void)
>   	return true;
>   }
>   
> +static u16 sev_es_get_ghcb_version(void)
> +{
> +	return ghcb_version;
> +}
> +
>   static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
>   {
>   	ghcb->save.sw_exit_code = 0;
