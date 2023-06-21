Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F73C738430
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 14:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjFUM6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 08:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjFUM6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 08:58:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F711AC
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 05:58:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frURHh8UPsccDLqOurRnD2Z7GkxdJ/rB9YMoQsDNOGQIysaJkcJ+43V0wxwyMLf3ftbeGcz1IYtflvm3r66Dn2Jy7LZe+lPfGJ3UZiMpVaBcRjeDJO/ZwDdWoUq2PC7qq0PUIPOguFzToFHCHs4BAbrTFUQ7l0tibr43A7wf8Iein1NWUKut2y2uLe7Msd5ln3SKwBS8k90+Y0KqPrKZXCe9y1/p9IV5n2JMWq+Iyz42qI+XppipeVRA3ThxyWiQzXZFK1Gj5Uhy17Ql0hsPmfsJj5CrRyBkNX2PvgLRP7XfbvFmHvK28X6mdKhkVgvJB1pMkdgut3VKCE51Eju57A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E9+iLBhZvlWfvl8Q0BUlfReogO9HO6KOTqLvY23bS18=;
 b=dqffw5dKD3wpthtMDIt/C9+Ir//3XXQLl8cuhHB0qiyDP3cv5ApP0W9UfepGubk4bnEFwJUdd+IhUjte+4xN1dB4+PFOtVeNhKcoKdHVrbu9kxgODayx8g9uvLMVNyhhMhiXAVKdgSr/l/fTmslrFd/klg0KIyHESPvc192ajTN9TgwTZau5VES+3I5Kystdq4mWKnzOwpIguQlsvoGEEDm+4ARsuhp/Re60sG4bNxu7/2Z5imHwilIVlThq32EB5idv8SOLNuepfYem9OtJTIe0qO7orMdF1MNEjUnpAcTcXRXl+2pJMo7ipX4BMuhmic99qQ0pUO6zrmbLCiq17g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9+iLBhZvlWfvl8Q0BUlfReogO9HO6KOTqLvY23bS18=;
 b=ZH3uikcyEkAsMSz1EEGGvJuo1VK2ZaIZl++1B/HmEEhSIve9/BTr5CZQF9xfmAauvJtZtM5AyjFh6TLQojqKeDYM5I7KXpeyxoGSWZnFn4aO2Hvd1OC20Tr1q1U0FpzEKT+/oyUmiRVZnou4QJnfJdRS6Ax66NvjfwQIkn64xrA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by BN9PR12MB5099.namprd12.prod.outlook.com (2603:10b6:408:118::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 12:58:08 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::8ff1:36b6:8d58:4e97]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::8ff1:36b6:8d58:4e97%3]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 12:58:08 +0000
Message-ID: <920b9916-35eb-fc5d-59e9-1ae913428f55@amd.com>
Date:   Wed, 21 Jun 2023 07:58:04 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 00/11] Add #VC exception handling for AMD SEV-ES
Content-Language: en-US
To:     Vasant Karasulli <vkarasulli@suse.de>, pbonzini@redhat.com
Cc:     Thomas.Lendacky@amd.com, drjones@redhat.com, erdemaktas@google.com,
        jroedel@suse.de, kvm@vger.kernel.org, marcorr@google.com,
        rientjes@google.com, seanjc@google.com, zxwang42@gmail.com
References: <20230612074758.9177-1-vkarasulli@suse.de>
From:   "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20230612074758.9177-1-vkarasulli@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::23) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|BN9PR12MB5099:EE_
X-MS-Office365-Filtering-Correlation-Id: 20be2086-3042-4413-d6e6-08db72572923
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPSj1RPjBWVv3jg0mkJ0uhQC25n+esXxXZl8zs9A5UL1zgo839ajECUGav8GtPPoisWztNpHEHUXcKDk4RisFedtIuFw70e9RE+w/VoxAUXvxZXEg1GwgM8gacnHfrxNsZr9IpMH0EAQ17tFyNuUeCia6qBkXlfUz+aO0p9bQGCqoR/TzKF4vCAt2Kwf0G1psJCCOwRhU+tI+RHRrYji3gqByksbYgcalOpBXkJ0zByGcvLXnSCYyho3eWJdmwk2o/0lAXNB2LW9gyOncTClwZ8UoEYmUhmRcJIFupzDPR0gU4nCydQvf4+HY+4qaYtUSiz3OHGEeW0AgVEuFGp0e7rKB0Y3VpI0f5WSAIs6ACPrg8PgZHx6jmP3/DQNOvTCLhisBnOj64Z+2XS/7tOae85yuqNOM3F8wCqKBXpKLGAFKDgKWdxr+wcm8B9e7lDO69iXvaOdzXVSj2ycHgiskCWpugrdULrzwYXZA5kJGy+bR98xviK5W2HhxSOqQQ79nOVFqoXteDLjcaxOoO/YHXy+u0vBbsiSzA1dxF9lD0vqdFD+8nKwljvCN6lxPMkRxH/lRnfbM8BnfkUKhp2ivdDmR8B71vPAlE5W0225zbwDY/nOlvGXC+/15DR0Gj1xd3nwjVNmFf5KXegTumJJYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199021)(6506007)(966005)(6486002)(478600001)(2616005)(6666004)(83380400001)(186003)(2906002)(53546011)(6512007)(7416002)(5660300002)(36756003)(31696002)(316002)(66556008)(66946007)(4326008)(8936002)(8676002)(41300700001)(38100700002)(66476007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWJSZXRFM3JRUHdjSEJXVlVpSXRuamlXOEdwQ0hsMGxpZXluMEQ0YkZubGVY?=
 =?utf-8?B?aktnWjhmSWJDWDIvVWN1ZG9Wdm1XRDNLNXZnYUVBRnk0SFJkNzM1MWxuWk9K?=
 =?utf-8?B?OGI5MzFlaE9jN1ZvbS93bHNoWlV2L1VlbEpWTEtGc1grQWlyWURYRFFOZm8x?=
 =?utf-8?B?OVdmc3V5WTlyRjl0QThNU21veHNIZGR5Y1dxWnVjS0Z4dDg4NXo2T3ptTjBV?=
 =?utf-8?B?bmZPWkhiTkFNSzEzWHFySko5N2dSRHhvY0pOMUgxVU83UHpwTjZnWE1WVEht?=
 =?utf-8?B?SWNxNkF6Z3RvQ0h2TmhqTjVXa1NEdW5HV1dUWmJsc0EvVk1WSmVxRGEyNy92?=
 =?utf-8?B?a2FZeFM5SDBVK2ZmSTJkSGNFNENaVWFGckJXTVk0Q2FRQnQ1SE9Ud3d1WHRy?=
 =?utf-8?B?MzlNaTh0MCtXVlc5Tk1YL0tiRkJPbi9tOHJJQzRKcGVmbUJtTjFKeHlTMUpu?=
 =?utf-8?B?bnUxT3dkcnMvTTRwWStVUGVUNjhkMW5xY0d5em9ERXJrRjBsdUI1MmVHNDV3?=
 =?utf-8?B?aTFZSmlrbUNYTDhBanF4dURjKzBzNEQrN0VzaDhsYk05K3B0UWZCc2tZQ1R4?=
 =?utf-8?B?Z1FJdStQaDdpM0JkdGxpY1J5cHlWSXZDWEk3TUIvT0FIMEpYUmJ3bi9OUWF4?=
 =?utf-8?B?SmRpV2J3dGc1QXZKeG1FQkJwbm4xQ0hLN3YraEhJc2ozbWQrUTlVTVJhYTc0?=
 =?utf-8?B?WXg2ZC9XYWRmQk5SMlRaYldYaXJIdFZ6US84SlU0dHAyK2FWMVFjakQ5b0l6?=
 =?utf-8?B?SFZvMnNuWE9nOUhLeTNZQWNYTGZyV1VyVTc0V0VXNlJoNUR6Tm5LaDhXUG5K?=
 =?utf-8?B?Ym1OSDB0WTdGczFQUzRseFBDMDVLWnhZem81Y2xnaytTampPT3ZCVWVSUFVk?=
 =?utf-8?B?K0VkdW95US9jd0FkbEpRTjNDUGRQL3hMM3ZhK3NMVnZSUXUyam1aNngxZm8z?=
 =?utf-8?B?Wjh0THRtMjdWdVBXV2RQRzFkZHZya2dwdVJaTjRTckZ6MjNjZnR0bnZsbndp?=
 =?utf-8?B?dkRTay9ZdVllaUtrUHdYWkhOaFBMck9nc0J3K05MQUVzZ1Q4YXZPb1BJVXJh?=
 =?utf-8?B?VkFmenM3OThvQlVjQU04bUxnMXY3UTE4Y1U0Nmp3ay90MjcwWnhONnFsa3gw?=
 =?utf-8?B?TVBNNmROZ1JjSUFuRmFXamlzSGZGRlRBTFYxb2Y0aE9lRWxGSkpBQ0hVd3VP?=
 =?utf-8?B?NFJIZzZGeEtmU3BJUDZ2NDA1UlQvTWlkSEYzVEVFNUdWZ3J6MWhMY0RxTmVW?=
 =?utf-8?B?VCtQMVNlem5yQnhaaG13NCtpSVREbVg4QU1PZmE2aUtPK1pOVklTYWdXMVU5?=
 =?utf-8?B?TDloQm5FaEpnQ0ZTM0lzK2NocXllcXhTM1BNTnpQTFZ3MXkxRzlvSmw2cTdH?=
 =?utf-8?B?Wk9nZmFQb1BPcjhGanFJcWIrM2c3aGRDMktSdE93Q1V3b3RTTFFkZzZTYlJY?=
 =?utf-8?B?a3I2bVhNTmNPZUt1Qy9hZGRGTndzcWxHN2dvZWN0UTlvWlZ1SWFhbU4wT1c4?=
 =?utf-8?B?cHlNTkNxSjM2cmJVei9IT3ZJbHVXOWU1aUlvUTA0WEsrcmxIZnk1dzdGODQx?=
 =?utf-8?B?K1Z5UzJzMSs4UGQ0Y25BWGhyU1c4eVM0ZldIVUR5cUhyVUtoSmdjQkhpU1hx?=
 =?utf-8?B?QlFWdXFMaVZXVGF6VGFlSGM1VGs0V05nOFJtQ2tRUFFmYi90cjdtWWNVTmN0?=
 =?utf-8?B?U0lqci9Cand5V2c0VkJnOWd4TkNkNGxlc2pnalYzbTVuK0Q0VmtnbkdQSThk?=
 =?utf-8?B?NmZtTmYvZFFpaEsrN0orV0JvN3BSSUZqc2NudUk0TlpiYTQyOE8wWEtUdlVQ?=
 =?utf-8?B?OVlXaytTeXNBaU9FTDU2S3JXdUtLU1BBdnFjYVFFd3A2cWk4UWNseDkzUVh1?=
 =?utf-8?B?M2gvUDl5WWE4ejJ0clhKU2N1SzhYSUtqMFMzMFBZcnZmODBQYUhLUmpBakFW?=
 =?utf-8?B?VEpudHBJOVo4a0xXUmdNb09SMlErMnBSajMwREVqUVYwZlpyRkZ1TUFtZDcx?=
 =?utf-8?B?YTBjZ09yYVZHVll0bkJjRjc4Ni9sVjhaaTVFN2t1Q001bTZ5MHpZbEo2d3hk?=
 =?utf-8?B?Y2xxYXErK0RwSE5aU1orRUtwZENFVXBjSU1NVURYNC9HVE54Z0QwWGswUGhs?=
 =?utf-8?B?VnpaczVjQWJKSmpMWHp2OS9Oc2JPWUI5RGVoMm9vZmQyZFpldGl5MllZMjNO?=
 =?utf-8?Q?21jp527UPKxDF/gkDUbz5HEuyN47hbnCczaTSEp2Ij6P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20be2086-3042-4413-d6e6-08db72572923
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 12:58:08.2156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VpZY+fUXIKtvJ9YsUJ8en9dVWjAwkUVDhnN44Z9UPZoo2VFHe7SC158VD6cRWjYXGR23fmiZPtQcAjiNqku7nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5099
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please mention 'kvm-unit-tests' in the patches. Look at contributing
section here [1].

[1] https://www.linux-kvm.org/page/KVM-unit-tests

Thanks,
Pavan

On 6/12/2023 2:47 AM, Vasant Karasulli wrote:
> For AMD SEV-ES, kvm-unit-tests currently rely on UEFI to set up a
> #VC exception handler. This leads to the following problems:
> 
> 1) The test's page table needs to map the firmware and the shared
>    GHCB used by the firmware.
> 2) The firmware needs to keep its #VC handler in the current IDT
>    so that kvm-unit-tests can copy the #VC entry into its own IDT.
> 3) The firmware #VC handler might use state which is not available
>    anymore after ExitBootServices.
> 4) After ExitBootServices, the firmware needs to get the GHCB address
>    from the GHCB MSR if it needs to use the kvm-unit-test GHCB. This
>    requires keeping an identity mapping, and the GHCB address must be
>    in the MSR at all times where a #VC could happen.
> 
> Problems 1) and 2) were temporarily mitigated via commits b114aa57ab
> ("x86 AMD SEV-ES: Set up GHCB page") and 706ede1833 ("x86 AMD SEV-ES:
> Copy UEFI #VC IDT entry") respectively.
> 
> However, to make kvm-unit-tests reliable against 3) and 4), the tests
> must supply their own #VC handler [1][2].
> 
> This series adds #VC exception processing from Linux into kvm-unit-tests,
> and makes it the default way of handling #VC exceptions.
> 
> If --amdsev-efi-vc is passed during ./configure, the tests will continue
> using the UEFI #VC handler.
> 
> [1] https://lore.kernel.org/all/Yf0GO8EydyQSdZvu@suse.de/
> [2] https://lore.kernel.org/all/YSA%2FsYhGgMU72tn+@google.com/
> 
> v4:
> - Rebased the patches on top of the current state of the test suite
> - Rebased the insn decoder on linux kernel v6.4
> 
> v3:
> - Reduce the diff between insn decoder code imported into kvm-unit-tests
>   and the original code in Linux; cleanup #VC handling.
> 
> v2:
> - Drop #VC processing code for RDTSC/RDTSCP and WBINVD (seanjc). KVM does
>   not trap RDTSC/RDTSCP, and the tests do not produce a WBINVD exit to be
>   handled.
> - Clarify the rationale for tests needing their own #VC handler (marcorr).
> 
> Vasant Karasulli (11):
>   x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
>   x86: Move svm.h to lib/x86/
>   lib: Define unlikely()/likely() macros in libcflat.h
>   lib: x86: Import insn decoder from Linux
>   x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
>   x86: AMD SEV-ES: Prepare for #VC processing
>   lib/x86: Move xsave helpers to lib/
>   x86: AMD SEV-ES: Handle CPUID #VC
>   x86: AMD SEV-ES: Handle MSR #VC
>   x86: AMD SEV-ES: Handle IOIO #VC
>   x86: AMD SEV-ES: Handle string IO for IOIO #VC
> 
>  .gitignore                         |    2 +
>  Makefile                           |    3 +
>  configure                          |   21 +
>  lib/libcflat.h                     |    3 +
>  lib/x86/amd_sev.c                  |   13 +-
>  lib/x86/amd_sev.h                  |   98 +++
>  lib/x86/amd_sev_vc.c               |  494 ++++++++++++
>  lib/x86/desc.c                     |   17 +
>  lib/x86/desc.h                     |    1 +
>  lib/x86/insn/README                |   23 +
>  lib/x86/insn/gen-insn-attr-x86.awk |  443 +++++++++++
>  lib/x86/insn/inat.c                |   86 ++
>  lib/x86/insn/inat.h                |  233 ++++++
>  lib/x86/insn/inat_types.h          |   18 +
>  lib/x86/insn/insn.c                |  749 +++++++++++++++++
>  lib/x86/insn/insn.h                |  279 +++++++
>  lib/x86/insn/insn_glue.h           |   32 +
>  lib/x86/insn/x86-opcode-map.txt    | 1191 ++++++++++++++++++++++++++++
>  lib/x86/msr.h                      |    1 +
>  lib/x86/processor.h                |   15 +
>  lib/x86/setup.c                    |    8 +
>  {x86 => lib/x86}/svm.h             |   40 +-
>  lib/x86/xsave.c                    |   40 +
>  lib/x86/xsave.h                    |   16 +
>  x86/Makefile.common                |   16 +-
>  x86/Makefile.x86_64                |    1 +
>  x86/kvmclock.c                     |    4 -
>  x86/svm.c                          |    2 +-
>  x86/svm_tests.c                    |    2 +-
>  x86/xsave.c                        |   42 +-
>  30 files changed, 3835 insertions(+), 58 deletions(-)
>  create mode 100644 lib/x86/amd_sev_vc.c
>  create mode 100644 lib/x86/insn/README
>  create mode 100644 lib/x86/insn/gen-insn-attr-x86.awk
>  create mode 100644 lib/x86/insn/inat.c
>  create mode 100644 lib/x86/insn/inat.h
>  create mode 100644 lib/x86/insn/inat_types.h
>  create mode 100644 lib/x86/insn/insn.c
>  create mode 100644 lib/x86/insn/insn.h
>  create mode 100644 lib/x86/insn/insn_glue.h
>  create mode 100644 lib/x86/insn/x86-opcode-map.txt
>  rename {x86 => lib/x86}/svm.h (94%)
>  create mode 100644 lib/x86/xsave.c
>  create mode 100644 lib/x86/xsave.h
> 
> --
> 2.34.1
> 
