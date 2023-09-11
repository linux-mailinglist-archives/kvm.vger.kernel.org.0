Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D2179B900
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjIKUrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236828AbjIKLck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:32:40 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2058.outbound.protection.outlook.com [40.107.21.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A13CCDD;
        Mon, 11 Sep 2023 04:32:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/OVdAJn6ul0yrfL07Iea0SAj7U9e1nQkaSZuK+9QKnAaKY7s4qx4Mewf27K7d8ehHpBLZKRIfkm1Iw/Gy7Js6SU+e3aBkqCrXx/QCHMZuRsHDRM1qnG34zzelAd+KOUwgiq3ub1e+Scxq9gdVaHO6DIAWbFS8wqGpwhuyHsnsMM7RR22Uh6ZB/0i4ag07n488BYAv8/qB479e4ocfD4GUbsrRY/GXA75Fz2BpkiHLNMNXiWxgHglam7sza+kkd8BsiQkCTjgHPc/YyN7+fivah7SDFJD7ji7Z0PnD9aJ5a8v5etu22G86oJqAGCq0vE1uf/8yYt8Y9SdYgoRA2RhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqOEy0Xz4n8Ztk7m1y7SvsIaZZytIpYglD8s7kOtgDk=;
 b=RA6lTKwrhyPBAqeeSnC5P+S/a4Rm6769qYFix/60d5NWCDkgga3OR+G1FIBsyRI/Dayb2LqhEu3vmd9Gqqal1FgUmF4MOugHsCH96K5RtcJHv8qRsSpvFB2yiO8nBMORNE4NFBUSC/fRrW3ru3t/XyAxqIS+YRDApRqW36ApOBd3Mm/iFFEhBdL3RCqP6PHTBPwP+oesJs3KkXv0GcJs6t/NcYxubsOFUZ/ZXlrJkosJg9bC4V3YePmmX4S0YU/81frSDpjelgrIFOXGgyldCKjEh1ww7kJXvHoAJGMymOTcAKL4gPVokX3XW3phAkQMKzufc4AXkXGRPG60fxgWaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqOEy0Xz4n8Ztk7m1y7SvsIaZZytIpYglD8s7kOtgDk=;
 b=yelB0LYnoVAUp0xvDunPC/WbnvuZ3NiffHOoYExbcIy9qaqw4fDljpaVMer+ecZmN6b1nIAzR9+OfDwsDpLiCQ/pY0fpGadhkw47Rr/DU4gqcZsIx12qypz6vKrjdYf7FrhdZjuw8yggNgYLQ+1GcxMCbOuepvOh6OGDWkHA80JIFXfGQApUTtJ7kEDq+WKtG0ZXmf2KBeH41HRnEV/IWAut8qdO5zKGktls0v8X6/SppFxCZSd0C4oA0RkRvXLMmTa5ZDIT3Fb+Xv4iIKdPYImvLPhhAzDD7iHgEoKkdTCzTgrWM9vPNDjeMvFH/mLp3SqUJjM6Znp+V4pXq/rSlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AS8PR04MB9096.eurprd04.prod.outlook.com (2603:10a6:20b:447::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.34; Mon, 11 Sep
 2023 11:32:29 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361%2]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 11:32:29 +0000
Message-ID: <528511e9-c205-f248-9a64-9066281004ba@suse.com>
Date:   Mon, 11 Sep 2023 14:32:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1692962263.git.kai.huang@intel.com>
 <840351e17ca17b833733ed9e623e7a51d8340c2d.1692962263.git.kai.huang@intel.com>
Content-Language: en-US
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH v13 22/22] Documentation/x86: Add documentation for TDX
 host support
In-Reply-To: <840351e17ca17b833733ed9e623e7a51d8340c2d.1692962263.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::7) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AS8PR04MB9096:EE_
X-MS-Office365-Filtering-Correlation-Id: c5f45da3-a86e-4376-8782-08dbb2bac806
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tsnxiPsMiD0RNvgVHTtz6OlBHZrEqOLUrOCTl7owhxofrXBEOH5c78B5jDFX8SAL1wcfP56UyJUmvVbdhehcdB6hZ12kK3LVkLNV1BR2LNLcGfnuGOczubtEyW0b0h8vKNAHGv1ceQ8AZEt8cI5oaJmZJkwEQzTd9ZKnrAWeDPywZX9PfQvpeeNMefsX666/Q67s/jq+NU887BJHT7Vi3Rcr94oZDdvVvyM/dAupwn1Zbg+e5CizlcOauBRHRk7WaptCWZ3ajNFpHkNUiB6Rc73Joji9xNKVUqM3AQVtSiGm9dj5gh/tkCYCvvPCaWVlHvSeew1B7bmT3VcKq/3qzD4vbhee2/PJjfEE3PYXBsszBhbz00Zy/UsU1EwucfkwPZDvykiTdUzwu6SZXpDFhGQzyfE1ah8Xf/n7qLr9G8iSIhBKAF2XfZ9D/OZeZJCZ1Buk2zTJoyGaX4XchE72V0e60UfDOyZJQxQkQQggP6ufT4nXZTF3t+szu1dPtEPUD72Te4y56qozSnB2iR50UtprtMqP5MwPa+ryMn7KRe3pHx9t7TyKJv5Ey0yzasTHJizb7z7RBvbQiVwqG0S0lPQ/txeYW0gfFlXjTBR6ALCb6zaAqfScdv/YmQyBx9ktxP6v3sy7UxSqZn20kgUigw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199024)(186009)(1800799009)(2906002)(26005)(7416002)(41300700001)(316002)(66476007)(66556008)(66946007)(30864003)(478600001)(5660300002)(4326008)(8676002)(8936002)(31686004)(6666004)(6486002)(6506007)(6512007)(36756003)(2616005)(83380400001)(38100700002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDdtMXM3dncrWmJDNXlkblYzRGxIZ01tV2N2azRmSWV4N3hKRlAwTGdXak5q?=
 =?utf-8?B?eEhULzd3a2lNeStPeFJqNy9qWWhDZ1VubzZoWHdodHFrNjdld1kzSjFCblM2?=
 =?utf-8?B?aWYwSTBLMVo1aGhpekl4ZFVWSWY0MitodlZqTy9Od2dTOXpoTSt1cHIvQUJS?=
 =?utf-8?B?YnBRVkp6dHR1TzZNd3I5aFY4VXJqc05INTB2R0R0bTRQUTlnUURIK0REM3BD?=
 =?utf-8?B?NUZ4VC9mZWlKbnk4UzdtVExFR3loem80SGM3ZktmU3A2UE5BM0NkbUI2b0dp?=
 =?utf-8?B?ZmF5SktVQWxCcFdXd3FEOVJ0MXNGNzVDalBWWVBOeFgwVHFJK0h0NmlXcGdz?=
 =?utf-8?B?WW12NEpsc0tkTXYrTzBXdXB2YzFlTHdnNEhkWEw4N0pxVlNZYTZNV0VHcW9H?=
 =?utf-8?B?UGlZT0lKdDAwT2xOZk9zRGNsSkFvbEpwRExVMDUrRkVNV3hPT0VYSzBNUlV3?=
 =?utf-8?B?bWlYVUtHV21GaWFWMWp1NEZjQjVJcWtKWnY0dDhtNjRBZ1NyYzlsUkt2eDNv?=
 =?utf-8?B?L0YvMVJtT05HUGlNb1o2ZFVZSGVrWVAyeG1TLzM3OHd6WFgrVWhQTVh4NER3?=
 =?utf-8?B?bE41RHpnUTNid3Fvb3FOU1R1Y0w2dTFsR0VITlJxNVZQc0V6bUkvcVd1MlRh?=
 =?utf-8?B?KzNzbS85NG10bjJnZUx4bDVpbG40WEYxZHFVTEpyb2tUT2xMaUxVZ1pOd3Bw?=
 =?utf-8?B?WW5wN0ZTQU5mT1VPVXdoS0o2Um5CVzloWE5ZdWg0V3hsWTBVK3VVZ0J1N1Uz?=
 =?utf-8?B?Um8vamhvL09WVUtRMWNFcWU0R1dPMUxCL2Iyc0xuOFpaNWxhNTZUN1ZzaVFr?=
 =?utf-8?B?OXJLeTJJelFiZnBUL3RGUW05YlM0dDA0OER2NEQ0NnlzZTlCcnlXZkZINlV3?=
 =?utf-8?B?bzMvbDJtSXVIL0NpSExKd2lFbjc1QzB2M3M1OWFNbFBJTERUNWxPZTYxbXAz?=
 =?utf-8?B?R1NyOExMay9SaDRrQjJhVjEvaDdjeC9CTUkvUlNPSmVXWWcyQ0NnOW5vNWpB?=
 =?utf-8?B?a2FERFp6KzhEdWl3Vkg4QjE2MFBLZVVWcnFYNEtyUDlrSjZSSDJvd2ZrSUll?=
 =?utf-8?B?WlFTYTMzMU1sVm8yaFVHUHliRE1WTnlQSHhWY3VCQ1o5bTNOWlZaMllBT0Vn?=
 =?utf-8?B?SElqaEFkTnJMYVZ0Z1JwNG54WHhTSlBkUVc3TkYwZkdjYWlOaUZ3M05ybXFw?=
 =?utf-8?B?Uk44Q2cwWjQ0UVZndXNFOTZkenBpSVltRVVUQlNpRnhyZ3JnU3BMelByWkNI?=
 =?utf-8?B?Tm5rMlVEd2pQdm1HV1lUU1R2Rm9yUGNpVFE1Z21MeVNLWER1Y1grUC9sN3VR?=
 =?utf-8?B?blZuS3RiWndHZUZxa2YrbmNFeGZNVFdUZ25XNzJTU21PRGl4UXRmbVV1Wi8v?=
 =?utf-8?B?TGZxWW8raHJCTzl5dWRHTkl6cGJTa0RrcUVJUjlxbkJOZFBGakhkL3k5QXZD?=
 =?utf-8?B?RmZucERxMzZLRHVYWE12K1NRVXl1WlY2STIxTThpa0dJRkR1bTJON3RPQWFC?=
 =?utf-8?B?MHlyc1UzcDlTVE03Q2ZaMnRqanFyU05vKzRieDNMaXVvclB1UG51Tjh3T0hn?=
 =?utf-8?B?ZW02VDBVSldRV3A1Q2dVOHhoUEhHTmRmc2pqNDg2RWhFTEFaZUlxd3Q1ejNp?=
 =?utf-8?B?MGFMekFMMGpaNHYySmtOb1BIb3MzU25aM3VOTWF6ZFlhTE55b0d1cXdMM0JH?=
 =?utf-8?B?WnlaS3cvSFkxWjVsQnZyMm9HV0pEdldGZkl3cy9najRVbXFmaS9VWUQ4Zm5K?=
 =?utf-8?B?NVBQTmh0Tkc0VERwMmI0TndDelMzeUplK1B0S0VOMUdTYXduS1YvcmVtZnhT?=
 =?utf-8?B?NkdydXFhTnpSeWFPc3l5YUJPMS9EK2hHanNOQ0doSDM3cFdNVDRMN29VSTcw?=
 =?utf-8?B?WlcwQUJWaFZCdUkyUE1lQVI1Tm0ydWxBcldiNGRDK2ExNHpURkQ5Z204RDZN?=
 =?utf-8?B?azNmcE5VKzFYVkx3aEpzcjZIOWRxWnF0SGg3Nzd6eitpbGQzUmUzRVZxTjMx?=
 =?utf-8?B?bDZENVJ0YnpLTm1ja09hbGhFenZFaGl1M0J6RXFjV2lWTStFdGpubXhUOW1s?=
 =?utf-8?B?Z0t1MDkwcE05dlFaODVlOGF4Qm5HRG5Yc01UNGhHc3ZzWVdCTHVUMU9PblpB?=
 =?utf-8?Q?u5slMOkIqMlESp/oLFDsr7pwR?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f45da3-a86e-4376-8782-08dbb2bac806
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 11:32:29.4141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FbZFS84XHWbUxsYlrE3k/0vsB2JCAdatTcksU9yJrIr5CDQsoXEdK9V9qcFw7fg/Mslh400zwD5LnN8/vhgL0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9096
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.08.23 г. 15:14 ч., Kai Huang wrote:
> Add documentation for TDX host kernel support.  There is already one
> file Documentation/x86/tdx.rst containing documentation for TDX guest
> internals.  Also reuse it for TDX host kernel support.
> 
> Introduce a new level menu "TDX Guest Support" and move existing
> materials under it, and add a new menu for TDX host kernel support.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   Documentation/arch/x86/tdx.rst | 184 +++++++++++++++++++++++++++++++--
>   1 file changed, 173 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
> index dc8d9fd2c3f7..ae83ad8bd17c 100644
> --- a/Documentation/arch/x86/tdx.rst
> +++ b/Documentation/arch/x86/tdx.rst
> @@ -10,6 +10,168 @@ encrypting the guest memory. In TDX, a special module running in a special
>   mode sits between the host and the guest and manages the guest/host
>   separation.
>   
> +TDX Host Kernel Support
> +=======================
> +
> +TDX introduces a new CPU mode called Secure Arbitration Mode (SEAM) and
> +a new isolated range pointed by the SEAM Ranger Register (SEAMRR).  A
> +CPU-attested software module called 'the TDX module' runs inside the new
> +isolated range to provide the functionalities to manage and run protected
> +VMs.
> +
> +TDX also leverages Intel Multi-Key Total Memory Encryption (MKTME) to
> +provide crypto-protection to the VMs.  TDX reserves part of MKTME KeyIDs
> +as TDX private KeyIDs, which are only accessible within the SEAM mode.
> +BIOS is responsible for partitioning legacy MKTME KeyIDs and TDX KeyIDs.
> +
> +Before the TDX module can be used to create and run protected VMs, it
> +must be loaded into the isolated range and properly initialized.  The TDX
> +architecture doesn't require the BIOS to load the TDX module, but the
> +kernel assumes it is loaded by the BIOS.
> +
> +TDX boot-time detection
> +-----------------------
> +
> +The kernel detects TDX by detecting TDX private KeyIDs during kernel
> +boot.  Below dmesg shows when TDX is enabled by BIOS::
> +
> +  [..] tdx: BIOS enabled: private KeyID range: [16, 64).
> +
> +TDX module initialization
> +---------------------------------------
> +
> +The kernel talks to the TDX module via the new SEAMCALL instruction.  The
> +TDX module implements SEAMCALL leaf functions to allow the kernel to
> +initialize it.
> +
> +If the TDX module isn't loaded, the SEAMCALL instruction fails with a
> +special error.  In this case the kernel fails the module initialization
> +and reports the module isn't loaded::
> +
> +  [..] tdx: SEAMCALL failed: TDX Module not loaded.
> +
> +Initializing the TDX module consumes roughly ~1/256th system RAM size to
> +use it as 'metadata' for the TDX memory.  It also takes additional CPU
> +time to initialize those metadata along with the TDX module itself.  Both
> +are not trivial.  The kernel initializes the TDX module at runtime on
> +demand.
> +
> +Besides initializing the TDX module, a per-cpu initialization SEAMCALL
> +must be done on one cpu before any other SEAMCALLs can be made on that
> +cpu.
> +
> +The kernel provides two functions, tdx_enable() and tdx_cpu_enable() to
> +allow the user of TDX to enable the TDX module and enable TDX on local
> +cpu.
> +
> +Making SEAMCALL requires the CPU already being in VMX operation (VMXON
> +has been done).  For now both tdx_enable() and tdx_cpu_enable() don't
> +handle VMXON internally, but depends on the caller to guarantee that.
Isn't this an implementation detail. It's fine mentioning that TDX 
requires VMX being enabled but whether it's being handled by current 
code or not is an implementation details. I think this is better left as 
a comment in the code rather than in the doc, it will likely quickly go 
stale.

> +
> +To enable TDX, the caller of TDX should: 1) hold read lock of CPU hotplug

nit: Hold CPU hotplug lock in read mode. And again, this is more of an 
implementation details, the important bit is that cpu hotplug must be 
blocked while enabling is in progress, no?

> +lock; 2) do VMXON and tdx_enable_cpu() on all online cpus successfully;
> +3) call tdx_enable().  For example::
> +
> +        cpus_read_lock();
> +        on_each_cpu(vmxon_and_tdx_cpu_enable());
> +        ret = tdx_enable();
> +        cpus_read_unlock();
> +        if (ret)
> +                goto no_tdx;
> +        // TDX is ready to use
> +
> +And the caller of TDX must guarantee the tdx_cpu_enable() has been
> +successfully done on any cpu before it wants to run any other SEAMCALL.
> +A typical usage is do both VMXON and tdx_cpu_enable() in CPU hotplug
> +online callback, and refuse to online if tdx_cpu_enable() fails.
> +
> +User can consult dmesg to see whether the TDX module has been initialized.
> +
> +If the TDX module is initialized successfully, dmesg shows something
> +like below::
> +
> +  [..] tdx: TDX module: attributes 0x0, vendor_id 0x8086, major_version 1, minor_version 0, build_date 20211209, build_num 160
> +  [..] tdx: 262668 KBs allocated for PAMT.
> +  [..] tdx: module initialized.
> +
> +If the TDX module failed to initialize, dmesg also shows it failed to
> +initialize::
> +
> +  [..] tdx: module initialization failed ...

nit: You give specific strings which tdx is going to use, of course 
those can change and will go stale here. Instead, perhaps just 
mentioning that the dmesg is going to be contains a message signifying 
error or success.
> +
> +TDX Interaction to Other Kernel Components
> +------------------------------------------
> +
> +TDX Memory Policy
> +~~~~~~~~~~~~~~~~~
> +
> +TDX reports a list of "Convertible Memory Region" (CMR) to tell the
> +kernel which memory is TDX compatible.  The kernel needs to build a list
> +of memory regions (out of CMRs) as "TDX-usable" memory and pass those
> +regions to the TDX module.  Once this is done, those "TDX-usable" memory
> +regions are fixed during module's lifetime.
> +
> +To keep things simple, currently the kernel simply guarantees all pages
> +in the page allocator are TDX memory.  Specifically, the kernel uses all
> +system memory in the core-mm at the time of initializing the TDX module
> +as TDX memory, and in the meantime, refuses to online any non-TDX-memory
> +in the memory hotplug.
> +
> +This can be enhanced in the future, i.e. by allowing adding non-TDX
> +memory to a separate NUMA node.  In this case, the "TDX-capable" nodes
> +and the "non-TDX-capable" nodes can co-exist, but the kernel/userspace
> +needs to guarantee memory pages for TDX guests are always allocated from
> +the "TDX-capable" nodes.
> +
> +Physical Memory Hotplug
> +~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Note TDX assumes convertible memory is always physically present during
> +machine's runtime.  A non-buggy BIOS should never support hot-removal of
> +any convertible memory.  This implementation doesn't handle ACPI memory
> +removal but depends on the BIOS to behave correctly.
> +
> +CPU Hotplug
> +~~~~~~~~~~~
> +
> +TDX module requires the per-cpu initialization SEAMCALL (TDH.SYS.LP.INIT)
> +must be done on one cpu before any other SEAMCALLs can be made on that
> +cpu, including those involved during the module initialization.
> +
> +The kernel provides tdx_cpu_enable() to let the user of TDX to do it when
> +the user wants to use a new cpu for TDX task.
> +
> +TDX doesn't support physical (ACPI) CPU hotplug.  During machine boot,
> +TDX verifies all boot-time present logical CPUs are TDX compatible before
> +enabling TDX.  A non-buggy BIOS should never support hot-add/removal of
> +physical CPU.  Currently the kernel doesn't handle physical CPU hotplug,
> +but depends on the BIOS to behave correctly.
> +
> +Note TDX works with CPU logical online/offline, thus the kernel still
> +allows to offline logical CPU and online it again.
> +
> +Kexec()
> +~~~~~~~
> +
> +There are two problems in terms of using kexec() to boot to a new kernel
> +when the old kernel has enabled TDX: 1) Part of the memory pages are
> +still TDX private pages; 2) There might be dirty cachelines associated
> +with TDX private pages.
> +
> +The first problem doesn't matter.  KeyID 0 doesn't have integrity check.
> +Even the new kernel wants use any non-zero KeyID, it needs to convert
> +the memory to that KeyID and such conversion would work from any KeyID.
> +
> +However the old kernel needs to guarantee there's no dirty cacheline
> +left behind before booting to the new kernel to avoid silent corruption
> +from later cacheline writeback (Intel hardware doesn't guarantee cache
> +coherency across different KeyIDs).
> +
> +Similar to AMD SME, the kernel just uses wbinvd() to flush cache before
> +booting to the new kernel.
> +
> +TDX Guest Support
> +=================
>   Since the host cannot directly access guest registers or memory, much
>   normal functionality of a hypervisor must be moved into the guest. This is
>   implemented using a Virtualization Exception (#VE) that is handled by the
> @@ -20,7 +182,7 @@ TDX includes new hypercall-like mechanisms for communicating from the
>   guest to the hypervisor or the TDX module.
>   
>   New TDX Exceptions
> -==================
> +------------------
>   
>   TDX guests behave differently from bare-metal and traditional VMX guests.
>   In TDX guests, otherwise normal instructions or memory accesses can cause
> @@ -30,7 +192,7 @@ Instructions marked with an '*' conditionally cause exceptions.  The
>   details for these instructions are discussed below.
>   
>   Instruction-based #VE
> ----------------------
> +~~~~~~~~~~~~~~~~~~~~~
>   
>   - Port I/O (INS, OUTS, IN, OUT)
>   - HLT
> @@ -41,7 +203,7 @@ Instruction-based #VE
>   - CPUID*
>   
>   Instruction-based #GP
> ----------------------
> +~~~~~~~~~~~~~~~~~~~~~
>   
>   - All VMX instructions: INVEPT, INVVPID, VMCLEAR, VMFUNC, VMLAUNCH,
>     VMPTRLD, VMPTRST, VMREAD, VMRESUME, VMWRITE, VMXOFF, VMXON
> @@ -52,7 +214,7 @@ Instruction-based #GP
>   - RDMSR*,WRMSR*
>   
>   RDMSR/WRMSR Behavior
> ---------------------
> +~~~~~~~~~~~~~~~~~~~~
>   
>   MSR access behavior falls into three categories:
>   
> @@ -73,7 +235,7 @@ trapping and handling in the TDX module.  Other than possibly being slow,
>   these MSRs appear to function just as they would on bare metal.
>   
>   CPUID Behavior
> ---------------
> +~~~~~~~~~~~~~~
>   
>   For some CPUID leaves and sub-leaves, the virtualized bit fields of CPUID
>   return values (in guest EAX/EBX/ECX/EDX) are configurable by the
> @@ -93,7 +255,7 @@ not know how to handle. The guest kernel may ask the hypervisor for the
>   value with a hypercall.
>   
>   #VE on Memory Accesses
> -======================
> +----------------------
>   
>   There are essentially two classes of TDX memory: private and shared.
>   Private memory receives full TDX protections.  Its content is protected
> @@ -107,7 +269,7 @@ entries.  This helps ensure that a guest does not place sensitive
>   information in shared memory, exposing it to the untrusted hypervisor.
>   
>   #VE on Shared Memory
> ---------------------
> +~~~~~~~~~~~~~~~~~~~~
>   
>   Access to shared mappings can cause a #VE.  The hypervisor ultimately
>   controls whether a shared memory access causes a #VE, so the guest must be
> @@ -127,7 +289,7 @@ be careful not to access device MMIO regions unless it is also prepared to
>   handle a #VE.
>   
>   #VE on Private Pages
> ---------------------
> +~~~~~~~~~~~~~~~~~~~~
>   
>   An access to private mappings can also cause a #VE.  Since all kernel
>   memory is also private memory, the kernel might theoretically need to
> @@ -145,7 +307,7 @@ The hypervisor is permitted to unilaterally move accepted pages to a
>   to handle the exception.
>   
>   Linux #VE handler
> -=================
> +-----------------
>   
>   Just like page faults or #GP's, #VE exceptions can be either handled or be
>   fatal.  Typically, an unhandled userspace #VE results in a SIGSEGV.
> @@ -167,7 +329,7 @@ While the block is in place, any #VE is elevated to a double fault (#DF)
>   which is not recoverable.
>   
>   MMIO handling
> -=============
> +-------------
>   
>   In non-TDX VMs, MMIO is usually implemented by giving a guest access to a
>   mapping which will cause a VMEXIT on access, and then the hypervisor
> @@ -189,7 +351,7 @@ MMIO access via other means (like structure overlays) may result in an
>   oops.
>   
>   Shared Memory Conversions
> -=========================
> +-------------------------
>   
>   All TDX guest memory starts out as private at boot.  This memory can not
>   be accessed by the hypervisor.  However, some kernel users like device
