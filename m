Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E110779753A
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbjIGPq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 11:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243233AbjIGPaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 11:30:35 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on0625.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1e::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC55D10DF;
        Thu,  7 Sep 2023 08:30:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGoUpNVU10Qq589GFacbyipKveCAp5sCO/OHO48nN0jr9HibjobKgUrjCBi/+Vvo4ypvVSxAZJGj6U6cI7XXoUzkaj+e/KD7pN0FYjI4H6stMkGPOg27P5w42xP/ue9ByespBWyjWqIcuW84PyPSZ+V9dl3BSWWLK2mNSe8VyezjlJL5KJKQ67iMUmv9+g9IQtsdwrY408M3rji/JuvlgbU3Pdqsj5mBZBUfUDEdlUX7cWp06v6fRtr/ni1wDfFhXtxcyN6gQTS+ASFN0jLgjDipV8AodiFe4ziwwm8hSCvArDjsgIymUAGs74fiJgGSwaZonEYg0DSa6oTrV1ZCUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSPEdjJaa76luiRw31/lM1Y+S0YsL5s9ur+v6+GCYco=;
 b=VqeI7JbDRrwmZ/kgOdK7kQpKcRcwSOiOysMcZDYW4hny3E4Xkqb6PIHRvKZLTFGzV8Qz+8bvvCHPfEH+MUSSKRJBMTvsYZ9jz+yb1Gt+9bdDMFwya6FyFVgsPXdI3tTXRcKEHGShVXkkD7SmQAKHy89WKJFjkqWRWCv6y9pTFUeRjsnJi1+RXI9jrZiax3niLryXYexQRRT56OdU4W/Uz08UaY7IuWoejVWR4nneP4aFyZJKy0934NX2CaMJECFxc/mJZ5N/fLA4JBLTjqo4Z9YhIUvJzzxfdHSnqwGeZvYFMMK5DIPE0+tDaiNSeTKnJRWLSBwJcwshZG7kp/0k/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSPEdjJaa76luiRw31/lM1Y+S0YsL5s9ur+v6+GCYco=;
 b=JvMSzjyRzXRh4TL8dKYaYc2xXoGmlV8wm/7uB+PeipJhoH+aiGaFY8GuIGNKNjedq+SJ/q6E28gMv/G0smgco2g/g9Z7uaKlYYSNP3U6rq23Eix0ou7bXgM8xP7XjldWLjW2edYeBj2PpNqw1kIfMbr0yIKmKOE2sgDhpP8oih0ychpVQKlbtA+MnEcKJ+kKtjcI0qZjJ5qIgh9hRyyJxyimpTit1DCpBFf1rtRA2SJvR+TYcMhTLfDRA5H0hCZa5HNB1MBE6rd0SOVEPYvygFDpXbSUM5bSVNvRHNhD+dmkfDvLDspSHmpo1EbA44J5zO/v7oHDwDe8hdh8SAZH2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by DB9PR04MB9474.eurprd04.prod.outlook.com (2603:10a6:10:368::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 7 Sep
 2023 14:19:10 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361%2]) with mapi id 15.20.6745.034; Thu, 7 Sep 2023
 14:19:10 +0000
Message-ID: <4a135404-4661-fa80-a3e7-fb131cdf2e6c@suse.com>
Date:   Thu, 7 Sep 2023 17:19:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v13 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
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
 <7d20dd51dac16bf32340d4037ac761d36f0667f8.1692962263.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <7d20dd51dac16bf32340d4037ac761d36f0667f8.1692962263.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR03CA0013.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::25) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|DB9PR04MB9474:EE_
X-MS-Office365-Filtering-Correlation-Id: c9fb5287-acc7-4a7f-d06f-08dbafad6729
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8UdWE2Ls9dkNPeo5rMw7YbHADdOFSygxy3Xx4gzbaJzDjnfjpAYI1pBqIzKxTro8aPqKRc68ZHmbDNZO7FO81vo/CtrXFRxqanK4vcH2oOe/X3XzqVI7dBlnyTlPNPS7624Ohzs8Va7H7ROFJf1jOIyb6Q6T0uppvgZl+c8+PcQS3h9YnfL7kMaoeACJ+RZJKVWgqqN+bL2F9b6Xm52lu1uyXjhvo1U8PflA5Fby+HSjmrNfMaNgRM0N6S2/bVokkIYmHvHRsrq7ENf28t6Gi6DVtkb844l42qqxUIZ0AuIC+Cwh3IZxx9tWHSj3zyQ+8F1dyUIoF6Mbvqk1N1N4qD3FnJUHFGHB3x69j/ZCfJmib7bmiSbikBSnSeRo5WLrfXeYhiih5IIJHupneU8mw52vyir1ZiIsAhocMVtNmslXvl1d0wIV0vfAhSy8pXuowS6UTMD2oL99lu1ngk173gtb21lP/4Or9vIyWcQ1+AkbMPrIKI3NjO600ViCOTqBrhf+ZL+GUmZqD6m7eN+tX6Gz07DwFzqfW9sglttCcFwCBv65HPHQiQfV6HWW+EwE6kJ6vMahLNGMANh73FJmzyYbeWONQWf1X+IYVoUbdb/BW419vp1Rx8Zl4YxIpmthJDgeOiNkaBlUXYmhtenvug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(136003)(366004)(1800799009)(451199024)(186009)(31686004)(83380400001)(6512007)(7416002)(5660300002)(8676002)(8936002)(36756003)(4326008)(2906002)(41300700001)(66476007)(66946007)(66556008)(316002)(6486002)(478600001)(6666004)(31696002)(6506007)(2616005)(38100700002)(86362001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXBxS2JwNDRMZmcrMmVqTTY0MzdFUyt3R2xFQ0FJZ0dJYUNGTHVCbllEZGlh?=
 =?utf-8?B?ZUo0T1hkZ3h1bE84RUZWYWJZUnVITU4vVVppOVNMME10UnBCUitnNUxDeS9X?=
 =?utf-8?B?a0xPU0VmUStuYnV4T0xMdkpaaDh0Q3lWRGtTQzhacmk3ZG9kZzRWYytMbGFz?=
 =?utf-8?B?Z2JKQkVmS0dKL0ZhQmVaWmNkNldDUW1wWmJESy9QOFNpdnFlTjhWa3NDUTZQ?=
 =?utf-8?B?c1NCMC83aU9DK0Q0a2N5WGJaQmMvckRIcEtuQ09xN1dGbFAwMFZha3dCTUxq?=
 =?utf-8?B?V2M0V1FZY0YwNmpLYWQ4dFBRUTloa2pOVkNZTkNzcTdleGxxZjNHVnBlS05N?=
 =?utf-8?B?TjZyTk1CRUduQWZ2L3ErbzJDb3h5UkFqckFGam9pV1pNbXdEUTFFaDFhb2gv?=
 =?utf-8?B?YnBtRTZmaitEZ1VzUHhpZ1I5NlJqbnR3eW5VZHhDSjIzY0xHdTc5UHlLUDhM?=
 =?utf-8?B?aGhDSkhZcmN5NXVGY2drVkNtdTJJNUNsY2EvMllTQStMd3p4enpxOTNXS0lo?=
 =?utf-8?B?ZjVnVjl2eURwV1NNbzI0RnRMQ1N1RVZVKzJLaHA0R3lsNDdoSUZ5cURBQmp4?=
 =?utf-8?B?SnpHcVZuSHJOWTlRQXNYL2hVU2U2MjZKeFh3Um5MYTNQeTZQeCszZitzeUhl?=
 =?utf-8?B?K1cwUU5KZDEveXFmdTRtd1FoQTlXQ1FJQUNBeGtiWDNkUVVGMkhUOVN2NThV?=
 =?utf-8?B?T3lYNXErQUpCSDRkcXQ5REFKTTFtUkxpMkNKZlVmTnliclFidHFraHBVeDJO?=
 =?utf-8?B?WXpQUFROUVFIai91UGpYazAxNExpL1pJT1pPdndqV0dWUkN5VnVnMkN4dHB1?=
 =?utf-8?B?dTRHbFYraG82S0ZXUW9OekhSOHZkMlpiQU1FUjJaZlo2N1I1MGNFTnhsMmtZ?=
 =?utf-8?B?aXJncHI2UHpWV01OV2dQQ0R4TFlOWk1RYm1wSEpLSHAyZWdrVTNWUmdseTNh?=
 =?utf-8?B?S2hmWFZHeGdOd3RrQzI2SzIxOEhxclNHYWxXOGp3dCt3eGFrZldoa2hvNkhj?=
 =?utf-8?B?cnA2cnhwZis3N3NGTDI2L1ZnNDFwT1h5NWJqMXBlOGdxblBscnQ3Wnh6K0dz?=
 =?utf-8?B?VU91UWFQZm50aFFSUDJsTGI2eWdkZkNIVjJDZ0twUmxaZWtiNHhqbUFMYS9j?=
 =?utf-8?B?aGVtV3BRS3ZFN2JtOWsrVU83MXdjc3VDeGdZeXRoMzlUYXJ3R1BaUlRFQXdz?=
 =?utf-8?B?NHNhRWZGTTZYV2NYZVBtZVpKRjdLbWJjUTkwY3BQMTArQXphV2JyVDFUSGNH?=
 =?utf-8?B?ampxVUc2WXBHZ1NXVFFhUGFadkYxYStGK3E0WUxEc2E5Y2VvUm5lTG0zQkQ1?=
 =?utf-8?B?QTFvQlZUc2VMcVduZlp4T01WcHBmdFVwTDBNeHZuOFJiMDJQMmpteUNsRFpx?=
 =?utf-8?B?S1NSb2x3VDlZQmY1NHo3OTU3TmxPWkxna2c4aEZMZlJuNDVVd2FId1RVYytJ?=
 =?utf-8?B?YUZOenR3d044ZXRsNzJHUFJ5NEsxMDVMTklRSnNVSkplVXhSWE1tUks4YWgz?=
 =?utf-8?B?eGZzWVIxY1ZyL3A3MnlydENUS3N2NjArYXVRSklzenZQMEV0YVpURDNIaTVV?=
 =?utf-8?B?QzllL3ZPdDVQZnhMcC8yYXRwSnpLTTIxRS90c2N4ejZ5OUh3cVA3OGxQMGlO?=
 =?utf-8?B?SVY4eXZLd2lTWDRvbnlVL01hUVB3Vy9GeVJSTEtPbkdhQjdlT2tLS3hvblJK?=
 =?utf-8?B?b2R0NDg4bFVxWEI5bWZ5TjNOR3FoeS9Uc3Q0UlRnTnlURWtjZW00UEZvQkF2?=
 =?utf-8?B?Yk5vUkhxamlDOVp1Q2YwRjhoOWFIRlNpbWVjNHJIcGRpSXlvR1Uwais1cC80?=
 =?utf-8?B?VDVOUXhkRWMrS2o0MVF2Q2tBMzZ5MDU5d0ZoOHFzT25DQ1Z2TVBSbERYU3Vo?=
 =?utf-8?B?Q2FBN2FSeDNLNENwRUxDN0k0eHpPUDRQVUY4MFppT0NXTGhMc3BRd2VVSWZl?=
 =?utf-8?B?aWZXZHdITmFyZU1PZkNLMG1ndC9rcDVhSXVrUkUvOFdvVlNHSlR4M3NVVnNK?=
 =?utf-8?B?R0NETVI4Sys3YU51NUhhRGh4eW43Y0xoQm5lZkNQUXg5SGNMZ0tEeG1SZlBZ?=
 =?utf-8?B?WkoxNHJRQmFpWjZ0Zy9oU0szMUxrRk1DcmlTM0tsSTVRRTJxc2hldHYzVHVz?=
 =?utf-8?Q?yXQ/GiXR+nfvYW5FbA1mgG2XC?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9fb5287-acc7-4a7f-d06f-08dbafad6729
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 14:19:10.1060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XM0nXhhvv9cXamVMJVeRbhF8UsN8wzId2D8av3wWZBnyO8tK+49gJ2DG7ABi8Dui3PkrVzKBB+6gRu5wR4FIRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9474
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.08.23 г. 15:14 ч., Kai Huang wrote:
> To enable TDX the kernel needs to initialize TDX from two perspectives:
> 1) Do a set of SEAMCALLs to initialize the TDX module to make it ready
> to create and run TDX guests; 2) Do the per-cpu initialization SEAMCALL
> on one logical cpu before the kernel wants to make any other SEAMCALLs
> on that cpu (including those involved during module initialization and
> running TDX guests).
> 
> The TDX module can be initialized only once in its lifetime.  Instead
> of always initializing it at boot time, this implementation chooses an
> "on demand" approach to initialize TDX until there is a real need (e.g
> when requested by KVM).  This approach has below pros:
> 
> 1) It avoids consuming the memory that must be allocated by kernel and
> given to the TDX module as metadata (~1/256th of the TDX-usable memory),
> and also saves the CPU cycles of initializing the TDX module (and the
> metadata) when TDX is not used at all.
> 
> 2) The TDX module design allows it to be updated while the system is
> running.  The update procedure shares quite a few steps with this "on
> demand" initialization mechanism.  The hope is that much of "on demand"
> mechanism can be shared with a future "update" mechanism.  A boot-time
> TDX module implementation would not be able to share much code with the
> update mechanism.
> 
> 3) Making SEAMCALL requires VMX to be enabled.  Currently, only the KVM
> code mucks with VMX enabling.  If the TDX module were to be initialized
> separately from KVM (like at boot), the boot code would need to be
> taught how to muck with VMX enabling and KVM would need to be taught how
> to cope with that.  Making KVM itself responsible for TDX initialization
> lets the rest of the kernel stay blissfully unaware of VMX.
> 
> Similar to module initialization, also make the per-cpu initialization
> "on demand" as it also depends on VMX being enabled.
> 
> Add two functions, tdx_enable() and tdx_cpu_enable(), to enable the TDX
> module and enable TDX on local cpu respectively.  For now tdx_enable()
> is a placeholder.  The TODO list will be pared down as functionality is
> added.
> 
> Export both tdx_cpu_enable() and tdx_enable() for KVM use.
> 
> In tdx_enable() use a state machine protected by mutex to make sure the
> initialization will only be done once, as tdx_enable() can be called
> multiple times (i.e. KVM module can be reloaded) and may be called
> concurrently by other kernel components in the future.
> 
> The per-cpu initialization on each cpu can only be done once during the
> module's life time.  Use a per-cpu variable to track its status to make
> sure it is only done once in tdx_cpu_enable().
> 
> Also, a SEAMCALL to do TDX module global initialization must be done
> once on any logical cpu before any per-cpu initialization SEAMCALL.  Do
> it inside tdx_cpu_enable() too (if hasn't been done).
> 
> tdx_enable() can potentially invoke SEAMCALLs on any online cpus.  The
> per-cpu initialization must be done before those SEAMCALLs are invoked
> on some cpu.  To keep things simple, in tdx_cpu_enable(), always do the
> per-cpu initialization regardless of whether the TDX module has been
> initialized or not.  And in tdx_enable(), don't call tdx_cpu_enable()
> but assume the caller has disabled CPU hotplug, done VMXON and
> tdx_cpu_enable() on all online cpus before calling tdx_enable().
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v12 -> v13:
>   - Made tdx_cpu_enable() always be called with IRQ disabled via IPI
>     funciton call (Peter, Kirill).
>   
> v11 -> v12:
>   - Simplified TDX module global init and lp init status tracking (David).
>   - Added comment around try_init_module_global() for using
>     raw_spin_lock() (Dave).
>   - Added one sentence to changelog to explain why to expose tdx_enable()
>     and tdx_cpu_enable() (Dave).
>   - Simplifed comments around tdx_enable() and tdx_cpu_enable() to use
>     lockdep_assert_*() instead. (Dave)
>   - Removed redundent "TDX" in error message (Dave).
> 
> v10 -> v11:
>   - Return -NODEV instead of -EINVAL when CONFIG_INTEL_TDX_HOST is off.
>   - Return the actual error code for tdx_enable() instead of -EINVAL.
>   - Added Isaku's Reviewed-by.
> 
> v9 -> v10:
>   - Merged the patch to handle per-cpu initialization to this patch to
>     tell the story better.
>   - Changed how to handle the per-cpu initialization to only provide a
>     tdx_cpu_enable() function to let the user of TDX to do it when the
>     user wants to run TDX code on a certain cpu.
>   - Changed tdx_enable() to not call cpus_read_lock() explicitly, but
>     call lockdep_assert_cpus_held() to assume the caller has done that.
>   - Improved comments around tdx_enable() and tdx_cpu_enable().
>   - Improved changelog to tell the story better accordingly.
> 
> v8 -> v9:
>   - Removed detailed TODO list in the changelog (Dave).
>   - Added back steps to do module global initialization and per-cpu
>     initialization in the TODO list comment.
>   - Moved the 'enum tdx_module_status_t' from tdx.c to local tdx.h
> 
> v7 -> v8:
>   - Refined changelog (Dave).
>   - Removed "all BIOS-enabled cpus" related code (Peter/Thomas/Dave).
>   - Add a "TODO list" comment in init_tdx_module() to list all steps of
>     initializing the TDX Module to tell the story (Dave).
>   - Made tdx_enable() unverisally return -EINVAL, and removed nonsense
>     comments (Dave).
>   - Simplified __tdx_enable() to only handle success or failure.
>   - TDX_MODULE_SHUTDOWN -> TDX_MODULE_ERROR
>   - Removed TDX_MODULE_NONE (not loaded) as it is not necessary.
>   - Improved comments (Dave).
>   - Pointed out 'tdx_module_status' is software thing (Dave).
> 
> v6 -> v7:
>   - No change.
> 
> v5 -> v6:
>   - Added code to set status to TDX_MODULE_NONE if TDX module is not
>     loaded (Chao)
>   - Added Chao's Reviewed-by.
>   - Improved comments around cpus_read_lock().
> 
> - v3->v5 (no feedback on v4):
>   - Removed the check that SEAMRR and TDX KeyID have been detected on
>     all present cpus.
>   - Removed tdx_detect().
>   - Added num_online_cpus() to MADT-enabled CPUs check within the CPU
>     hotplug lock and return early with error message.
>   - Improved dmesg printing for TDX module detection and initialization.
> 
> 
> ---
>   arch/x86/include/asm/tdx.h  |   4 +
>   arch/x86/virt/vmx/tdx/tdx.c | 157 ++++++++++++++++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/tdx.h |  30 +++++++
>   3 files changed, 191 insertions(+)
>   create mode 100644 arch/x86/virt/vmx/tdx/tdx.h
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 3b248c94a4a4..fce7abc99bf5 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -111,8 +111,12 @@ u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
>   	SEAMCALL_NO_ENTROPY_RETRY(__seamcall_saved_ret, (__fn), (__args))
>   
>   bool platform_tdx_enabled(void);
> +int tdx_cpu_enable(void);
> +int tdx_enable(void);
>   #else
>   static inline bool platform_tdx_enabled(void) { return false; }
> +static inline int tdx_cpu_enable(void) { return -ENODEV; }
> +static inline int tdx_enable(void)  { return -ENODEV; }
>   #endif	/* CONFIG_INTEL_TDX_HOST */
>   
>   #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index bb63cb7361c8..898523d8b8b0 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -12,9 +12,14 @@
>   #include <linux/init.h>
>   #include <linux/errno.h>
>   #include <linux/printk.h>
> +#include <linux/cpu.h>
> +#include <linux/spinlock.h>
> +#include <linux/percpu-defs.h>
> +#include <linux/mutex.h>
>   #include <asm/msr-index.h>
>   #include <asm/msr.h>
>   #include <asm/tdx.h>
> +#include "tdx.h"
>   
>   #define seamcall_err(__fn, __err, __args, __prerr_func)			\
>   	__prerr_func("SEAMCALL (0x%llx) failed: 0x%llx\n",		\
> @@ -104,6 +109,158 @@ static u32 tdx_global_keyid __ro_after_init;
>   static u32 tdx_guest_keyid_start __ro_after_init;
>   static u32 tdx_nr_guest_keyids __ro_after_init;
>   
> +static bool tdx_global_initialized;
> +static DEFINE_RAW_SPINLOCK(tdx_global_init_lock);
> +static DEFINE_PER_CPU(bool, tdx_lp_initialized);
> +
> +static enum tdx_module_status_t tdx_module_status;
> +static DEFINE_MUTEX(tdx_module_lock);
> +
> +/*
> + * Do the module global initialization if not done yet.  It can be
> + * done on any cpu.  It's always called with interrupts disabled.

nit: Add lockdep_assert_irqs_off rather than the comment, the same way 
it's done for the lp enable function below.

> + */
<snip>
