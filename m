Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ECD704907
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 11:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbjEPJV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 05:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjEPJVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 05:21:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13BA2D5F;
        Tue, 16 May 2023 02:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684228860; x=1715764860;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EF5jkN+/AwxDLD03N1q4v5imfO1bLM0tDolKY7KSTqc=;
  b=RhHb07TJL1jTpd/1SSSxvPvnlonVlYyHFL2m9AJSYsnfIhSaOpAYfESv
   81PaxZYKBveGWom8dEocBYgfp4nAT/nrIUgxwYGNcT4jxSnFGYYC2x7e3
   Qb5digGl0Hdno53rcD03bUZiPgRquutFdsT0gwgJWtt14GS+xvzcRX43j
   Q/F3+08SiGlOEkNohrUrx4s6glHUGNQCU4n1gqClEqcPKsfyNBczSv9E/
   C3fIzFERKZimM+FhDwdymxuWy5JMVXfzlgioshGgh3Qxa9KMY3D3+yGQg
   86LSNxF1xJVSScc1e/2p3cg1ADLdzJ0W2nx2SBMPyHlB+J90FrMfXt6h5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="414836088"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="414836088"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 02:20:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="701275535"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="701275535"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2023 02:20:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 02:20:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 02:20:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 02:20:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 02:20:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDqyCjjvE+Yr5VNhaUu0Nq6AX7G5E/LaKHLlD+wQSLTU/HvnsVjBDDjGHi0t23SKSNKqkROctsXI7ZPdykOrgtiaGtFKxWE/3+w2rGakma8f1v6YbPASeQjbdVaACVDQkN3+neZ+ffmenF+7lSRm9wPLjjjtJRd163xhS5eqI5YmuhmBR98KyDz6G5K2VcFloNAVVHveE4zfwt0jrw+F0mEfVZFdNY7xulUbcUFBva/0tI4G96jJJ1mkXaIBAi+KOcl/Qk0PtMboE8vXNwl84q+bq68K3w3gcWmar7Vt7qSo+vTli1T/24m7y++nnkkmR3qeOETMyscBJVwgP2y2yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eASZr+HnEh9IGlIazMScsaNHVntMqFL2LoSFeaJtO2Q=;
 b=JtGRX20CJTuIDVqIw3F1XrCEJNddy5snluuzczAGfJtRyt3xb6pg9je9w8YXZiMdQE1lIhexyc6pvKQcuFDEmGkkKX7bE0gSFtiXnqCZRWoVjYgBLHVQVZs6yjU+n2tYTxXzfkYGU8oCKm9BbBsHQ7e2WW0yV1Jeag3ONkhr0CuB9EtPyytHvsmY5GM87DS1Alq8AW8i1PV8dsdxbZ7YpsOReR8fyo0UM91Xcva79C6tNw/LADu8Ixp1+d+wBOCh9JsOew52xjasVIv/SjJxwVEuDLnlS5F9lWAM2sLAoAsKDNKrzBna/3UNUDvHUMRwWyJ0fuYrfml4ZNJ2iXjXdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH0PR11MB5564.namprd11.prod.outlook.com (2603:10b6:610:d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 09:20:41 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 09:20:41 +0000
Date:   Tue, 16 May 2023 17:20:30 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 04/11] KVM: VMX: Add IA32_SPEC_CTRL virtualization
 support
Message-ID: <ZGNK3hHhCHU6l7h+@chao-email>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-5-chao.gao@intel.com>
 <6b861c8d-9b93-74f2-6073-6f1284e72fd2@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6b861c8d-9b93-74f2-6073-6f1284e72fd2@intel.com>
X-ClientProxiedBy: SG2PR06CA0248.apcprd06.prod.outlook.com
 (2603:1096:4:ac::32) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH0PR11MB5564:EE_
X-MS-Office365-Filtering-Correlation-Id: b2ef9a02-ddf4-4e10-dec2-08db55eed1a5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: li/Fa8zHs5ZSbmTTXC2Pw8uEYGYeluEtaWfusBie4kKPp6m/38Ho30UWxYOjA2RzycR7zLVw4lHlAcIwBa/Eayl33i/YXM8M+usYLQ7aG94i6YBTI3UJ+rX8n2sGUOEnCozrPZv+jN/OP2lgXMDeRGHl431svekBHQxnk2TlWBnFb+aC2NQhdupLMNvQ1XZ1W9pAIO03KwfXMIHES64NxCigQJOs6E+JtPgjTKyWMjuTqXgDR015imBYnguzL5TeQ+chcH8x5sYHP7cz6DEJpoysRirHfHMWWjuNILMcOoGOSOrgWhOoRoBjOpaIclwNHYjmeWL/NVkxX/GbyVbLcNuwGWM58D08B/9jbyKXrVuBovHAjS2C+5aBQpfxtaG+J7EOGilOBhZGa+2pRk2Qdpnt53jiwgQc3tLFlm3rWIyK8WOStS+zZIqbifDr/f6Jv7KF09Ko3r41NwH7lfIm5fUt+nmRveyOkP1+zdiOC3ZTbXdNasP/rQsOCwnDHa8X2WGG4Cc6fiBcBnK1/uRi6/TXUZJKlx/f/Iip27EYtPw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199021)(2906002)(478600001)(41300700001)(316002)(54906003)(44832011)(7416002)(6486002)(8936002)(4326008)(6862004)(6636002)(8676002)(5660300002)(66946007)(6666004)(66556008)(66476007)(966005)(26005)(9686003)(6506007)(6512007)(82960400001)(186003)(83380400001)(38100700002)(86362001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ExKNJLRQE/0V2T+yWOsbqEealvZz+ihZXY8kE04RyJyOTYbi/7eb1DGui/i0?=
 =?us-ascii?Q?MlLJkmdGXk0KToLh3rityWaq4BpYh8TIHuyAQpoEBcONqpU2Oi9yZ5xb1Cqz?=
 =?us-ascii?Q?VJtY5npXU876uIhGkURbaWJ1C9Co6JADmNwnNKZIdkW4crc8/d5MA+KYLS0v?=
 =?us-ascii?Q?6VYDpzOxrDaGQ3w80TPMY6Gmacw/dv35+hGVlJfiqz6Zz6Ew1/E5HLqjRgQ+?=
 =?us-ascii?Q?JbZNAGEg7UQUpZF+mZAkAf7jNDNhiNEcONoAu1tZeHv6UP8onzPqha/+CFoa?=
 =?us-ascii?Q?aLuxIWt5h09ssBPpNTMykHzPA0vSjmsMsVWMlhQjo0jxPQndGxzZ+hVdMz4B?=
 =?us-ascii?Q?mikMXYphO5MNvPXUN1Id5j75m++R5McWX+3WMFU3v9lqzF9fAbkrb71VyAFN?=
 =?us-ascii?Q?V87BbyesC/5ZGdmNzDTbIvhT2bwPzLEy7pz33A1dC4a3s8evf8kWsFFi/b9v?=
 =?us-ascii?Q?JNtC02JW8vhZf8EOQTb1bmWwgJ7Ky7KaAWlVAEw5scFkLp31LqMZ44l4RDry?=
 =?us-ascii?Q?2IEMD954SylsiU3oskqGdmptinboh7RgaEGLiK1s6iJmz1dGdnvOHPdRT11H?=
 =?us-ascii?Q?ywfw649aI7kqvUHggEpeeHZUSLQzaqSj5e2ymdUmBONH8MOIcl0VrmpA15uA?=
 =?us-ascii?Q?Zvga7biYpFkkJwvUiNRtX0iW1byAc7TMpU/Ot/8+JNPqVOL/T8Gf4AEKZ+0Z?=
 =?us-ascii?Q?0yqjYpz+LtVNZ/Xz6Rz+MirLDTGmGwW8xACKTzMbVDbR9sH0t+L20NcXeeJX?=
 =?us-ascii?Q?FCXRz1aGAupCy/DBBeCNip/29eCS97va5Dqv6cslfR8JwLNs5r9I0p4+otzY?=
 =?us-ascii?Q?1m1w8HxV2LIjyjw+D8G/YP2dFAjrThldZ++wCCpDaJNmPhNo+zEqKZVpO1Rc?=
 =?us-ascii?Q?1IK3A4RDk25XdZ8brZwzZkweuh/Od3XeOdfjVm59gBIUxOif1h+26H/EGqov?=
 =?us-ascii?Q?3mSs43j/g40zl7orkiGBPvq/m1C8XZjfmS4WH1Z++NhhhBetQCdqnjJ/sfwD?=
 =?us-ascii?Q?o4r72yBDNKg/diCjLZCkbfr4nGvtpRzC7C8RepHw/i0B7FiMctIm8InRCe8u?=
 =?us-ascii?Q?HR7HMa4oENV/1MN+20hQOSramfs91WCiJIpw7ucXdorLgWE/VpZoQRhmIiPn?=
 =?us-ascii?Q?ZZ0OI0cWRqJyHwYrmchKv+9pXp04xgqHx9lcNh1eo61Cw/UId1aSWDAdo+rW?=
 =?us-ascii?Q?H8R3ukvquYira8A0SbiYYnLOCPv1/SoLWMmVieHawhy4XCxuqb5GZraM5R2i?=
 =?us-ascii?Q?mkmWclJoIBq3HM/0vVPhQGBro2eTXweiiuSZa1Dvbo1J2UJYwXjVmFIBhU2n?=
 =?us-ascii?Q?dpzxUinjpgZ9pEs+DrdAJhVAwnB21vT5ysX3s6+r3xmsEYYiltWuZuDqDaGX?=
 =?us-ascii?Q?o8Kn+1eSsAPJ5NYiaenZzD+y97fh9WXfriex7fhC3kBJEYdDzppoo1H/dIxL?=
 =?us-ascii?Q?gbxgpun11/f5K/KtVxmarsRapVVdgmvLO1mvqEFddAHDRo98dX0DIHNRz+O6?=
 =?us-ascii?Q?2kLkA462iyhZr5DP641fVZIOq8TsclsYQa95WmePbEsOx7mYM5PMPC0tu9gJ?=
 =?us-ascii?Q?ovxRTBS5jDZy7I9At0SNUW18aWxkBSjSNKXG81BV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ef9a02-ddf4-4e10-dec2-08db55eed1a5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 09:20:41.3717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bB+Ld4E074X6ENqEcKo2SPNgqNPFX9nQ0G+rmhf8aU+A1XygLtipUmX2dvu1VhNZgShwBQ+H1h9dhJNqklcWKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5564
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023 at 03:16:59PM +0800, Xiaoyao Li wrote:
>On 4/14/2023 2:25 PM, Chao Gao wrote:
>
>...
>
>> +static inline void vmx_set_guest_spec_ctrl(struct vcpu_vmx *vmx, u64 val)
>> +{
>> +	vmx->guest_spec_ctrl = val;
>> +
>> +	/*
>> +	 * For simplicity, always keep IA32_SPEC_CTRL_SHADOW up-to-date,
>> +	 * regardless of the MSR intercept state.
>> +	 */
>> +	if (cpu_has_spec_ctrl_virt())
>> +		vmcs_write64(IA32_SPEC_CTRL_SHADOW, val);
>> +
>> +	/*
>> +	 * Update the effective value of IA32_SPEC_CTRL to reflect changes to
>> +	 * guest's IA32_SPEC_CTRL. Bits in the mask should always be set.
>> +	 */
>
>Why bits in the mask should always be set?
>
>The bits set in the mask only means them cannot be modified by guest. KVM can
>use the mask to force the bits to 0 as well.

Yes.

Because there is no use case for VMMs to lock some bits to 0 behind guests, this
isn't used in series. There was a note in v1's changelog [1]:

	Note "virtual IA32_SPEC_CTRL" is now used by VMM to enforce some bits
	of IA32_SPEC_CTRL to 1 (i.e., enabled some HW mitigations transparently
	for guests). In theory, VMM can disable some HW mitigations behind guests.
	But to keep this series simple, we leave that for future work.


But somehow I dropped it (when I tried to slim down the changelog). Will add it
back and add a comment above the definition of spec_ctrl_mask.

[1]: https://lore.kernel.org/lkml/20221210160046.2608762-5-chen.zhang@intel.com/

>
>> +	vmx->spec_ctrl = val | vmx_get_spec_ctrl_mask(vmx);
>> +}
>>   #endif /* __KVM_X86_VMX_H */
>
