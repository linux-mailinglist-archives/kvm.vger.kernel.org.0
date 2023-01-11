Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108EA665F81
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 16:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239134AbjAKPmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 10:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbjAKPlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 10:41:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC76D43;
        Wed, 11 Jan 2023 07:41:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g36pwqMJmDFh76r5Mm36eNJ2Zz5J45DST1NHCurw68uIUlcncO2kfALwldHn64ICvzp8Z2VFw1CwIAsFfIpdPYAkLZAXyyEGcEA7Tpt7xT9YQqpBtPH7LoeoEz11IEUVg9calvziN9Utgy8WWF5Fihm5jdjkncptgLsFU9n6nolyUtGNDS+DzZ4bxYVARYl6loD8y7BrbqRnm3vqeZqUI8TTGzI5XBEfot+Vo0XbCCIWLsvMGhX3lchh2cDgLPxX/siEOu4TUFjSktCRoz33KsCYgQWSvOTXIlAt9HbQtxK4WEngjj8MZO/BDmOtA2otFkQHYl9X9Tx/4z633F553g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVHDD8r9XRD32EAS6EpnU2rxjmtEC7cep5f03tCi4Dw=;
 b=VYbTBs1tN1Rgk5kHbHfOV/iU0Q+AlXHmnnPGOhrmxm7uT8ekE2xZpCrMu4kJDVU9BdNUIsLER4FkeNFE1jrjMbhQrYf78Ukm8l3HF4E33/2Bm7mm1KRVnu8dxRFRzukSpWA+1Y4VQBxdPV7S6M70Ve1k9kgliQrJdMI1viLN2pi0rmsIKDf+1om/H2OwB//lGT15m+AFwgtUfpRAINN+Xch41YUi8aSZ2V6BrcHkAvDljNgvVTua5BwwsWev1jyWgluCyMHwiR8xYI+x/wyymi+KLftrl3budXPZnY6Zv81zRtqjFI3jXM17f9VadwFOlgf6zkj5x9cUAHeKKkvbdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVHDD8r9XRD32EAS6EpnU2rxjmtEC7cep5f03tCi4Dw=;
 b=M4y9AcvQ+5/royK+wsRD557p9E/0zpcX0k5oZZP8oacAvpx89hP7LQc4qMd0UYYHEppiKKy2VoNyFvZWhbOOMyHOhhDOKi1U2F2gEJC6KRl09st0D1LmIUQPfSIkjGT2V9efKzJ60AufBYyZXcG1TCoq0pZGqNq81sZV0+VIpAs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 15:41:37 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.6002.013; Wed, 11 Jan 2023
 15:41:37 +0000
Message-ID: <df8d8451-60d5-e126-6528-8318b689fcc0@amd.com>
Date:   Wed, 11 Jan 2023 09:41:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4] x86/sev: Add SEV-SNP guest feature negotiation support
To:     Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de
Cc:     mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
References: <20230111064522.957859-1-nikunj@amd.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230111064522.957859-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:610:33::24) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM6PR12MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: 4715f7b1-32c1-49e7-1297-08daf3ea533c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y47vIdkkFcox/SGpXfdcdhzgjBHrkdFQG5eeT9poUTu8fFbSM+Y38skD9CKH4b6R27eAam9Omk9QK5wIKmjcMiPo9rZLkPLETRKH7RI8j0IK8HuGHJK3PGnlSmO5tmFNS5zsdphZtem/Wwe89unIcjLz2AzLjaw7OvlcQEol1SKjR/jX0q8IiXGJ95gMec5FZ6lhTCQNr8GPr7/wMpdkcoRC9wiO1ATu6pXGXuXSdiiAOLZ1vYUY2s6O4myJLlvBZ0Z1CfJrvjl2/0TO93qBp6+MlE1OgAYZsPJMraD0xciMpoY3jEgc89qNSLv+iz04QaF3Gc6H1/Po5snq8Do5DZbFJB7emL3tnrDwanHL7I3ClNHx6uriy10LPOn24U1EJoO0WSYp6mA+l8G20PLL0bnsDqgzpoNsH99JWK/GI4SAg8n9zYCioBn0aA2VhOfT21ZSFgfS+vq8RC4cGtpMZOARVhb26DYv0QukMdDDiLpAkmUTpHlxmqkNa0i6DK7se99kdxoL7v9yelySTnKMqTziRZTeowSf8AP7QUdyxucAissnFCQLS14rDmcY5vCYz4c9VZRN8/zLRFt0AsTd/9JGP/c1Gch8qOTBeRQqxs3H0SetyHJCuJyaSFj6zvHCaDF/NltdNesIIlCk16RRKKx0Bm/TGAeARD23BRZU9OTDxNr47Vk8vyHO1PBjuFBTLrLw5i5Qc3C5Dn9w3Lv0cJ/DXGsMW6e0AuzK/yGpxVJpGSXuyf52fdw8Hr6CYU7ISDNbMA7m7gP3O0jLzwlyQDfyxVkccL2tuH9INOiFckq/0r0JIvlX9w9ZNyuF5dWJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(30864003)(7416002)(316002)(5660300002)(186003)(26005)(6512007)(6486002)(966005)(478600001)(2616005)(31696002)(41300700001)(66556008)(66946007)(66476007)(4326008)(8676002)(8936002)(83380400001)(86362001)(36756003)(6666004)(53546011)(31686004)(6506007)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2ZOVjFPekJzVHFQdzRkdGllVGl3ZCs2QWlRR29KbEZTUFFNSDNUeFY4M2Yx?=
 =?utf-8?B?V3ZPNi9PRkFyc1FwZDIzYmVYSzM1cEhtODc3dXprZUFwcEZ3TVc4Q0pVSDlR?=
 =?utf-8?B?a3E2RWhMVk5ZN2tFMUtPQWY3SXNJSUFlcTB5blQ2czZkWWdzT1hRaUpxNCtn?=
 =?utf-8?B?NC92VG1sTWhSVkJHVDl3VGhrZkFUV3BxTWxWUmdSQ1BidVJhc2J3bk8xWW5q?=
 =?utf-8?B?SkhSYTRPeFh5cXA2ZWpUUmpoeUdhUUhVVmwyWnJCdEdDMHdNOFV3cnBJYXlL?=
 =?utf-8?B?QXhOVlN2bXlTbmowTVJzc2ordUlYcXFVanpPdnorTVZKRjdjWWViRkNzbjBB?=
 =?utf-8?B?SEJsSEo2eGoxVW8xb1ZtTkNGMzJRQWc4WlZ3VVA2R0p6SCsrV3dJM0dFVnFW?=
 =?utf-8?B?QjNjZWVVSzVwcjliTzIwNzJyVDZQWDlkbXgzcVFySG9pZzZJYlArWWNrbG9m?=
 =?utf-8?B?Z2dCdDVuYUlLc2piSTVIUCtabVFVU3pKaklTZXowUWk1ZG11MFdCTURvR3Ja?=
 =?utf-8?B?QndIdmkyelhnZy9OUVM5MlpDUXIya3piYVNoUHZFeXVHSkdsditpQkNvSnda?=
 =?utf-8?B?anJobVpad2NkbnJmUHo3ZlVZSG4zMmRSanN1eHBhMkhxTWNoTitDbjRoSitI?=
 =?utf-8?B?NW9ud1UyS29zcGNqaUVpbUhHaTlaTU1qUC9MTjJlWjgwdXZjNEJ3RDVNMW50?=
 =?utf-8?B?SUJwZmVNd0lDWkhjVWt6LzVLWmk5dCtCeHc5TlF1SFc0V3RMRDZma0g4eWp0?=
 =?utf-8?B?SHptWklJMVVwczduU3MzSDRYUU9ZNlJIL3poRXdLTms3bHBRb2dUSDg1eFdl?=
 =?utf-8?B?YkJoYWZFRTJPZGRUbVJidTloTGNRTVErNWVTVi9CSmxlVU10ZWdpcjc4VVlk?=
 =?utf-8?B?RTJOanNlSVRNZlI4Ukpra0pxODJzNFJzWlRub0J2eEFWMkpzbXNiMUZ6MXpr?=
 =?utf-8?B?eGoremhxUFFTRXR3bVBjTVZuWDA1cDVCcXFaKzVHdnc1TFdxKzJjdnlFVCt6?=
 =?utf-8?B?WE1taUU2WGJuK2JyOGNyaUpJTjVyT1Jqcy81SzZ0TW5aNHlwQ0NLcmJEQ0xs?=
 =?utf-8?B?UmJkY2kzNVZyMXJaeFl0QlBHdEx0V2ZwZU9rNkVSUWR4emU1N3czT2pHbzZY?=
 =?utf-8?B?OEdoTllxY1l1S1lzb08vajczbDJibFpLS29nMGFGaStzYTErdUt6K1BwYjVn?=
 =?utf-8?B?NEFWOWV6c3p0V0pwUDY3cjNaaTBBR09TQkNSNzlWZVV0ZE1aRjd6U256VVFu?=
 =?utf-8?B?UEdaekpvRStxRXNTRDUwb3VyL2xEQldtWFdhOUtSK09aWGJ5TjArN1BuUWc5?=
 =?utf-8?B?MkVPekNxeFR6dTVXbXZUdUJDSXhyRUVUa3gzSHFlaXRsRWF6TEJ1MHByWFpL?=
 =?utf-8?B?cmlPRDhLdkR0UTRndUxqTEhaSEFEeXVTeHVsK2IzOWFOZ1krUUxOR2l5aFE1?=
 =?utf-8?B?blg4T1A4TThGMGhYVzVDMm5jNHJFTEtaTUhuRnJHRDdKY0p5RWJZN0phUm9O?=
 =?utf-8?B?KzJ5SFBlVzBocVpid1Z0R0NOQmRXbGkrZmNHcUJDUVhwMEdNMzZHbEFidGdm?=
 =?utf-8?B?N2k4ZnhKaE9FS20zR1cxMkR0ZlhaWnZwNkdQcDh6S0xLcXIyQVA2UVBtRE1l?=
 =?utf-8?B?TENwcjdxb0hLb1dPRlVOWnFIelFhdTUyK3FZcVp1UkZ0S1ZHVXVxZlpRQ0J5?=
 =?utf-8?B?M2dYb2VQbHBIMTJkb2REaEtEMmJaVTRDV2NwYmZ0TGRuVHQwUk9WTXlPMjQ3?=
 =?utf-8?B?elNrQWZnZ1g2djNncXNLQjJvV3MvbS95b3V3MldQQy9ybzVPVXI4cXZEUWR5?=
 =?utf-8?B?WS91M2ZCZUlKVG5FbEFqejArRGsyVnpFVnJ6YkpTRzNVcmFpY3dEMTBNVHY5?=
 =?utf-8?B?RnUwZ01admRDcTExcGV6WUtNWVRqdVRyS1RXUUZXWUFGOGJWelMrRkpEaW0r?=
 =?utf-8?B?UmxubUp5TFdGZklSc25KRkwxdHI0Ny9ZMUYvajJOLzBMdVU5RTdDTG9KWU56?=
 =?utf-8?B?ZFBLWTdnV1RFak5xblkrNjNLRG9BOE5pN2hCc2RFeWgvWGtrUTRmRk03RG5y?=
 =?utf-8?B?UGY5SUdkOTUvZFBYWUpsRHJYRk0vU0M3L2xUcFZwZlM4ekl6UHkra0hpQlA2?=
 =?utf-8?Q?4vqDVHit4tPcG+1WtRDGZEt8t?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4715f7b1-32c1-49e7-1297-08daf3ea533c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:41:37.2407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9INAQUO0Z+SD2jod8i0Jp5hdLYv7vBUOFqnGP8QLt8P7tvBJ2ueX60tlEyF2JZ4fEBy0CQvvC+kIER5l5KfCEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/23 00:45, Nikunj A Dadhania wrote:
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
>   Documentation/x86/amd-memory-encryption.rst | 36 +++++++++++++
>   arch/x86/boot/compressed/head_64.S          | 10 ++++
>   arch/x86/boot/compressed/misc.h             |  2 +
>   arch/x86/boot/compressed/sev.c              | 59 +++++++++++++++++++++
>   arch/x86/include/asm/msr-index.h            | 20 +++++++
>   arch/x86/include/asm/sev-common.h           |  1 +
>   arch/x86/include/uapi/asm/svm.h             | 10 ++++
>   7 files changed, 138 insertions(+)
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
> index a75712991df3..22037443e958 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -557,6 +557,16 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
>   	/* Pass boot_params to initialize_identity_maps() */
>   	movq	(%rsp), %rdi
>   	call	initialize_identity_maps
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	/*
> +	 * Now that the required page table and mappings are done, early boot ghcb
> +	 * page can be setup and used. Check for SNP guest/HV feature compatibility
> +	 * and terminate the guest providing exit information in boot ghcb.
> +	 */

How about a more concise comment...

	/*
	 * Now that the required page table mappings are established and a
	 * GHCB can be used, check for SNP guest/HV feature compatibility.
	 */
> +	call	snp_check_features
> +#endif
> +
>   	popq	%rsi
>   
>   /*
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index 62208ec04ca4..0bc3639be1f8 100644
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
> @@ -143,6 +144,7 @@ static inline void sev_enable(struct boot_params *bp)
>   	if (bp)
>   		bp->cc_blob_address = 0;
>   }
> +static void snp_check_features(void) { }

Unneeded since you're wrapping the call in a #ifdef check.

>   static inline void sev_es_shutdown_ghcb(void) { }
>   static inline bool sev_es_check_ghcb_fault(unsigned long address)
>   {
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index c93930d5ccbd..a26a5d6949c3 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -270,6 +270,65 @@ static void enforce_vmpl0(void)
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
> +				MSR_AMD64_SNP_REFLECT_VC |		\
> +				MSR_AMD64_SNP_RESTRICTED_INJ |		\
> +				MSR_AMD64_SNP_ALT_INJ |			\
> +				MSR_AMD64_SNP_DEBUG_SWAP |		\
> +				MSR_AMD64_SNP_VMPL_SSS |		\
> +				MSR_AMD64_SNP_SECURE_TSC |		\
> +				MSR_AMD64_SNP_VMGEXIT_PARAM |		\
> +				MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
> +				MSR_AMD64_SNP_RESERVED_BIT13 |		\
> +				MSR_AMD64_SNP_RESERVED_BIT15 |		\
> +				MSR_AMD64_SNP_RESERVED_MASK)

Should these be indented one extra space to line up with MSR_AMD64_SNP_VTOM?

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
> +		u64 exit_info_1 = SVM_VMGEXIT_TERM_REASON(SVM_VMGEXIT_TERM_REASON_SET,

This should be SEV_TERM_SET_GEN (or see below).

> +							  SVM_VMGEXIT_TERM_SNP_FEAT_UNSUPPORTED);
> +
> +		if (!boot_ghcb && !early_setup_ghcb())
> +			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
> +

You need to call vc_ghcb_invalidate() before doing any ghcb_set*() calls.

> +		ghcb_set_sw_exit_code(boot_ghcb, SVM_VMGEXIT_TERM_REQUEST);
> +		ghcb_set_sw_exit_info_1(boot_ghcb, exit_info_1);
> +		ghcb_set_sw_exit_info_2(boot_ghcb, unsupported_features);

Add a blank line here.

> +		sev_es_wr_ghcb_msr(__pa(boot_ghcb));
> +		VMGEXIT();

Add a blank line here.

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
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index b8357d6ecd47..db60cbb01b31 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -148,6 +148,7 @@ struct snp_psc_desc {
>   #define GHCB_SEV_ES_GEN_REQ		0
>   #define GHCB_SEV_ES_PROT_UNSUPPORTED	1
>   #define GHCB_SNP_UNSUPPORTED		2
> +#define GHCB_SNP_FEAT_NOT_IMPLEMENTED	3

No, you can't create a new value to the SEV_TERM_SET_GEN without modifying 
the GHCB spec. So please use GHCB_SNP_UNSUPPORTED if using the 
SEV_TERM_SET_GEN set or else add a new value to be used with the 
SEV_TERM_SET_LINUX set.

>   
>   /* Linux-specific reason codes (used with reason set 1) */
>   #define SEV_TERM_SET_LINUX		1
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index f69c168391aa..5bd81adfb114 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -116,6 +116,16 @@
>   #define SVM_VMGEXIT_AP_CREATE			1
>   #define SVM_VMGEXIT_AP_DESTROY			2
>   #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
> +#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
> +#define SVM_VMGEXIT_TERM_REASON_SET		0
> +#define SVM_VMGEXIT_TERM_GENERAL		0
> +#define SVM_VMGEXIT_TERM_SEVES			1
> +#define SVM_VMGEXIT_TERM_SNP_FEAT_UNSUPPORTED	2

This NAE event uses the same reason code set information as the MSR 
protocol, so the above 4 definitions are not needed or the definitions in 
sev-common.h should be redefined to use these defines, e.g.:

#define SEV_TERM_SET_GEN	SVM_VMGEXIT_TERM_REASON_SET
#define GHCB_SEV_ES_GEN_REQ	SVM_VMGEXIT_TERM_GENERAL
...

Thanks,
Tom


> +#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
> +	/* SW_EXITINFO1[3:0] */					\
> +	(((((u64)reason_set) &  0xf)) |				\
> +	/* SW_EXITINFO1[11:4] */				\
> +	((((u64)reason_code) & 0xff) << 4))
>   #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>   
>   /* Exit code reserved for hypervisor/software use */
