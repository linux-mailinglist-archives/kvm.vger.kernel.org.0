Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500A27CD5CE
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 09:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbjJRH56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 03:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbjJRH5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 03:57:52 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2049.outbound.protection.outlook.com [40.107.21.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E449109;
        Wed, 18 Oct 2023 00:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nx2ciV3dPUkXEQ/uMkI85m4+lmdREs89IfefQiueQ3MCfmfE7vJ3w1PG0D6MY3AOZwiPnR/Bu7V8Cs5aS6sR89TDRXbfzFiCDd1nm3Uj2XiNh21C1vF9Kpnk86xpE5ZB7jP0+h/KP1C8oqBy6If33PW+JfFS2WRkqX+Nc1Sr4JVSFUyhSgTfzWrO88DC4oHIYiA+ypp8ShjqhCkjQbeWX2UqPFCcbz28tzdiwUiUitkh/peSbOukbaQO1meK4Rv43OdP+72sSofOXg8z7j3ANcrYwf8oNd93FWjgDz4D71ZjVaQDpw1GDZ8pdYIFr7AYua8FkoYpmeA4atRWMaDxGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTH72jD6oxs6XYj/+x0B9v1sNoTExqxlriau7Dzenqs=;
 b=Izg/LqqdE6SrzH3wCMZC4HrkftL2oz7e11JXEA0BmMMilNdA4yV0nA+JlI1AedeAVsAc5sDT6myJbwaqmMu/IAXHpkGpYlWG4owuTaxjLwuwdgEo84Kl3X/trqxnIAvgHQfSsoxmU4DwXq9ME0qFLaNgiuTiCq4Carp+TrKyOP6AeuMSh4SIka10IBskcqvQ3RP1NPbWepI13R4BuRzYpLyRRVNHSd0ik91gNCzxoEs3eCVzzXpkZYPc7qwYlX4rvHl46dPSE5QvMEz7RqjlMaAgnQfTx74FWkehrsctjLP2Ok6yN6uBPezLngE8V6j8bj0cg1Cqt+0ybY+w2o4PAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTH72jD6oxs6XYj/+x0B9v1sNoTExqxlriau7Dzenqs=;
 b=uMlXEDu8Vl6xU5xyCbAj7yBV+W5TDLQhs1bPOqVWBoNrRHYxv9L+dnQ9oV5J1LzFBCncYm3GPt7yALOnqSCzZ6bwh/GhbBQTo9rxsbfSlVOMSyw+ljJI3q0OwSYGoFiCMpQjDzFZogQ3sS4nYDaMfgwVOO3zJpsv2MKQquikDkRtmb9e/5hz+mmqjUMM+lGR7/A7AYeV36WqxfBOcTlX2F7Q8PWrgZZL6NfPcOJyOuTedM3MDJc49Gpr7IoSk8mfxxdDJAzaA6Fct2fczjint9yl+qEFCwxMtbq3g3lVzbajnTXsuYqGMBJjAeco7O4DYUs6Udyqm6nqPbhjyUTWWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM0PR04MB6819.eurprd04.prod.outlook.com (2603:10a6:208:17f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Wed, 18 Oct
 2023 07:57:42 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 07:57:42 +0000
Message-ID: <ea983252-0219-46a7-99be-5a8d22049fd6@suse.com>
Date:   Wed, 18 Oct 2023 10:57:36 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1697532085.git.kai.huang@intel.com>
 <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VE1PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:803:104::47) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM0PR04MB6819:EE_
X-MS-Office365-Filtering-Correlation-Id: fd4be618-bc86-44b5-7041-08dbcfafe7d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KQK8dTvjpM8LLxc64WXNH0CHh5HaMJ52B3XvXTatkAM2MiXO6VON08D7a5uWaZ5gOubRkK4WJyViY39z6sExpLlcGLHBT3l0nwSsK9xc8aEew4s4BpVrcFctrWwuLyPzAjj+k/Ez+YiTTpliJJJ96bHctczrqx+Rnxq0o+bQOgnaYBQaoCxn4PYpj0u0hgVbSpCrMric77mHkjwVJ1mOehV5Yp3Hh68OL3+8/Zmf+xMyTvTTKctInKP6cVANCNlQcqfQL/Vd00IjCJ/myDGHK2VCpO2ncUFC71DXt7f79LXzfcCWAiW8ODpa0WZHx2tjzHaVFWq8j+r8+0MPTe9dTU+DawVzYj+kVS8L5fl7tIzauoHRfkcAtVmfzcv/6WLZHEJKh9D3LgeqkreNL8Uh7cJSxt5KxiikhEMaFm2xEjGZBLAIOgeMuaKZNqkwsJ3/USLaVrUykbGeMQxh5ZUMy2pBQllEqdYVzM9MOppGLqg0er+7rPmo0MWSWe3TQWO42CKlSldW9a32rFxgryqANDpAcF24l4EHEoWFFhN1zISwqMQWnWEJfXuYX+5l4qE4bhnAiMOjdKAmXJ1i9gnv2+ZUlo5oTFKRYgJWj7E0z8Y6pQbyh76Ol+Ur60DioipjiPS/V0eT9HshvstaS8zliw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(136003)(39860400002)(366004)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(38100700002)(31686004)(36756003)(83380400001)(6512007)(6506007)(41300700001)(2616005)(66556008)(66476007)(316002)(66946007)(5660300002)(86362001)(6666004)(8676002)(8936002)(4326008)(7416002)(2906002)(6486002)(31696002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnZtSUVzanhLeFNPcmhzaGExVXVDOFdPN2M0U0QrTjNmUlQ0alZnTEJ2MTZq?=
 =?utf-8?B?N200RldHNUIydjR3STBLclNNdzE1T3ZNTjFNdnNKUWNmcm9HbHkyU2o1d1Zl?=
 =?utf-8?B?YmRxM2MyYXRQZzRwU0dVVHZVMlJMeXJocTRDMjJhSW5FWW5tdDViUWtZOGl2?=
 =?utf-8?B?QWs4Z0RzdHlEbEpOK05ZMjFkZnRJSm42eHV6UkdJenRkQmdabzU2eDMwaHQ2?=
 =?utf-8?B?L3RuS3RobXAzSFcwNzdGQk5BMDAyVGVhamI1Q1lDeWhtb1lFdVBJb3VJSXFp?=
 =?utf-8?B?N1l3V0NkSVZzVGtsM3l6MVdjSVcxL0xaanFNNVZUVEZqZ1ZNeG5FV1FSTWl0?=
 =?utf-8?B?c1NYMXQ3ZnFIOEpyNnlnSXE3MFB4aDZVcTY3K2RRL1RNWXE5b0tYRGdEMTNO?=
 =?utf-8?B?UHl1U0tQUGlaNXZVTG5KcVd6aW14QUZuRU1MaWI0c0w2aFB4dmZaRFpXRkha?=
 =?utf-8?B?TFl5M2NDOTczWXpEbFA5Nkt4SUJOY2lLTEVJajJ3ZXl2WFNVUkticlQwa29j?=
 =?utf-8?B?cm5ENHBoUTZqZEllZ21PY0VFMmVvZWVmNmpLbWNrZ2lSU3RhN1Z0RngwTFM3?=
 =?utf-8?B?WmFZUVFpanpkYnFQR3RXQ09MM3JjRy9KT3VJVzNMSVNnZDVjVzBoV1I3bnlJ?=
 =?utf-8?B?eWt5dlVKU1F3T0JhbVVoRFpoa1V4MVRGSDNuQnk2R1Rkb1ZUcC9XdzUxd0x6?=
 =?utf-8?B?Ni9tcGdCdGc3bzZBb1Z5ejBkWW14L25DaHFoNm5HVW1TRmJDUHg0NFNXYTRh?=
 =?utf-8?B?emRLdXl4NlZnUHNlYzUwVzIrcmZRcW4vUW1JS0J6Q090eGJhRU1MdHdOaUFq?=
 =?utf-8?B?SnN5bTNrcng0M0d5Q25LYVd2TzBQbkFZREpIWE5GcCt2UDRiQVpSRmU0UkFH?=
 =?utf-8?B?cXVteW01R3FzeDlhY0xnRGRjeDNrL1haSFlEeE02ekw2bnJOV3JZbHRYWm02?=
 =?utf-8?B?RjRIbGRrL2JWbVcyVFlmWndkcmtYTTdZempURFFpdFlZT2Rwc0pLbktXTzM1?=
 =?utf-8?B?d1BLREUvd0pGb2kyWEpFNmVHNjVNYU9XclAwRnBHNjhkSlV0aTdxOFRJVGcw?=
 =?utf-8?B?TWhPL0dCRzA5Vyt4QmIzYjl4RnlrNW1TY3BnQ1JMS2h1TWFsc3ZtczVwbE9t?=
 =?utf-8?B?Tmk0cmk4djA4UjhndFJMQzhuM1d4RUlTUUYzbHFoK1BIZmhTUjVqL2J1Z3RD?=
 =?utf-8?B?eHZHZWtsYzRLRDdGc0hhS1FpQ3F4RGZ6ZXVLMnpETDFuQ0tyQzAwWS84MXo2?=
 =?utf-8?B?cGM1WHRZTUo4NHJXcjJZbitLbEV6d2ROM25BQUN6dllPeHA5aXdzN01kVUR0?=
 =?utf-8?B?cmZ2YWhKempZMHdRbnBhUXBYUlNRQkNjd0FHajB0YWdjeVkzc2daODZucG9u?=
 =?utf-8?B?eU90NFVST0ttb1NkaGJLWXVuR3lFUEtPemh3T05tRUxJQ244cUliRjJWaHlD?=
 =?utf-8?B?S2xWZ2UzaW1SUGN3VC9ZVm4wbDhsb0FSYzZkejU0eUpNQW9zQVhLQlVNajc3?=
 =?utf-8?B?bnYyYzc2dGEvL05iUXNkamNTemdRendyNW9oanR3WktTUTBYZVdIekgvaXI2?=
 =?utf-8?B?d244bndORU5YcU54bWJWZ3puU2lHdERKb3l6WkxaVzh1WklWT2JXcVZQcUtW?=
 =?utf-8?B?WGRyYzhuV21uQmpzTWtkWHlPeW1kNkl6MFdkNXE5WmVTMVN0UUVBMThYZ0ht?=
 =?utf-8?B?TkdMdzFuSTZnbUtYQmpFdzFOTXJCbk9rb1ZvR1lFZlEycFpzVnJONHN2MWla?=
 =?utf-8?B?WnZyZTF5ZFdNV055SDlCcEt2aVJuZ3dDbE1JY25QbmpPOGVaNnB2Qll0M2RO?=
 =?utf-8?B?UEZKU2UyYXpQNUtGUHVPWkhFT3krZzNxQzF1VnY1Ump0SzYwY2dnWUFaT2xI?=
 =?utf-8?B?WG9sWkxyei9SZWEzam53OUNRdnpVaUFOdElSU1k5aWFiS2hEUldEVnI4dlVr?=
 =?utf-8?B?SVZycDl1Z3FxNTJPcHhYYTR4Y09YR3BYQzBXQUVKK29hY1Fnc1ptMC8zZHVU?=
 =?utf-8?B?QnNWVHczMityYzZLSDBVR1hhcjFVR0Z4eU5UclhVRlNNZnhEV2N5UnNxeEJ1?=
 =?utf-8?B?VnNDQUgvaUpNQ043RmZSMjZoZTNPOUxEK2MzTHFtRG42VThoUFZ0V3Y3c3Zy?=
 =?utf-8?B?Z2NzTGVLL1NtNFQ4WSs1UldLYjhWM3lpb0JmS1ZOTW5abEVSWW9wMkN5OGM4?=
 =?utf-8?Q?J0SDldQU5i83nkE8JLiIGaGSR1nO+kU0Cse/SCip/g6L?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4be618-bc86-44b5-7041-08dbcfafe7d1
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 07:57:42.2095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EK5lTx5P/qygVK3PZBGdGkGc69cwuVfKHREHO/GF6ahhyYmoQ9wYqhMOgLLc2vZ8GywhCMYBTbLiTsOvfCHVkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6819
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

<snip>
> ---
>   arch/x86/include/asm/tdx.h  |   4 +
>   arch/x86/virt/vmx/tdx/tdx.c | 167 ++++++++++++++++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/tdx.h |  30 +++++++
>   3 files changed, 201 insertions(+)
>   create mode 100644 arch/x86/virt/vmx/tdx/tdx.h
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 984efd3114ed..3cfd64f8a2b5 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -110,8 +110,12 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
>   #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
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
> index 52fb14e0195f..36db33133cd5 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -12,14 +12,24 @@
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
>   static u32 tdx_global_keyid __ro_after_init;
>   static u32 tdx_guest_keyid_start __ro_after_init;
>   static u32 tdx_nr_guest_keyids __ro_after_init;
>   
> +static DEFINE_PER_CPU(bool, tdx_lp_initialized);
> +
> +static enum tdx_module_status_t tdx_module_status;
> +static DEFINE_MUTEX(tdx_module_lock);
> +
>   typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
>   
>   static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
> @@ -72,6 +82,163 @@ static inline int sc_retry_prerr(sc_func_t func, sc_err_func_t err_func,
>   #define seamcall_prerr_ret(__fn, __args)					\
>   	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
>   
> +/*
> + * Do the module global initialization once and return its result.
> + * It can be done on any cpu.  It's always called with interrupts
> + * disabled.
> + */
> +static int try_init_module_global(void)
> +{

Any particular reason why this function is not called from the tdx 
module's tdx_init? It's global and must be called once when the module 
is initialised. Subsequently kvm which is supposed to call 
tdx_cpu_enable() must be sequenced _after_ tdx which shouldn't be that 
hard, no? This will eliminate the spinlock as well.

<snip>
