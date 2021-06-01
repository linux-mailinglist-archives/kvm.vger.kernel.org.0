Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497BE397839
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 18:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhFAQnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 12:43:18 -0400
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:64224
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230288AbhFAQnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 12:43:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4Dfb9zv4lCA2rh1GaxccBeVbfzl9dx1glckNkMEjUK8sH7Dc6aVUOzcCT6iNXHMcNRsy5HUh51babSao7japuAQI6FfxxOnLE/5Z2E7ZCIZ9LGrV5N7knzyD9nBKYbLB6szBoVCCMkKG8JTApVP9rKdfojFnZAuP+ujyhQZe5yYq4H3Y+dAjPDUxwviWcytEhOsNwouSnkm8jS/hLkRsoWrQWhjqT+oWnwumy4qd2zUW7AdE2g8gVoApHCgD/DADP+7C5+mVYOfvJY74osIkGnK4FQsAx+gHdd0oK9Zb2RPA5iZMVh6GPp8sHOZKyPa+HyZeBCOTwk42LUaql5n2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKM8oxpiHyJ3XIIsUF6N6jeuww9Vg/xShn9LqzBy8/I=;
 b=BhvK51SDyfoHNH98JblOUdgNkymSEIa8DDyQqlSkBAQm6hoA5YonaqwpAnPCax5kTqVzACpxfnMJhEDtyGuQF3AbDqMyye4Iu0tkCZv3bvq/JUNg7kPdsZJCqxi48cHIRybq0HEORvplp9sHFL4vvcbURL34RfbjnolxVUEOgLiNoetx2t/0OffNqmywZSvRLGPC06k/FU/OZODEtc8zoN6xoCh0fXT079UQ++2yW86J3Cr7Sb7QB7vOnK/4sA2CccYc1UdthmuOA9y1by52CvkM/Hkln+h6tBjToR/tQMaTl03CN4Zglt5FZWhjtmRvbxIi7Z9M3nlmy5rKouDeCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKM8oxpiHyJ3XIIsUF6N6jeuww9Vg/xShn9LqzBy8/I=;
 b=CbX829fAGi67dH7gZhThfE5zOEwSr3mat474CKGSXImIT0CGI2+1WECmEBLwZ8S9hWFBM0DzzEu+Mtn3/EV6/I3SfiYUkSwvLQAQEd47u0RdXM+0KADD9bQ9FwN5s1O98wugTlg1klz0hFBteqMzxeAAwmqfFtMWiDZ0zgavKz8=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2619.namprd12.prod.outlook.com (2603:10b6:5:45::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.26; Tue, 1 Jun 2021 16:41:33 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 16:41:33 +0000
Subject: Re: [PATCH v2] x86: Add a test for AMD SEV-ES #VC handling
To:     Varad Gautam <varad.gautam@suse.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>
References: <20210531125035.21105-1-varad.gautam@suse.com>
 <20210531172707.7909-1-varad.gautam@suse.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <fdc55029-bbb5-6d3e-5523-cada1aae8ddc@amd.com>
Date:   Tue, 1 Jun 2021 11:41:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210531172707.7909-1-varad.gautam@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:806:d3::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0017.namprd11.prod.outlook.com (2603:10b6:806:d3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24 via Frontend Transport; Tue, 1 Jun 2021 16:41:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fd6d657-dbe9-480c-0095-08d9251c1d76
X-MS-TrafficTypeDiagnostic: DM6PR12MB2619:
X-Microsoft-Antispam-PRVS: <DM6PR12MB26195E38F4AA457D61B4B733EC3E9@DM6PR12MB2619.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2h/Vam0181CgtPRMf2BTHDhCij5gaMRQLFosnw+LHvtzYiplbso75u6IKRz2y2Nr/AMaunezDi0zTLwoltxI93/XS8FLU452ABSdrV3fDk0N5AsHYaWnS5+kKNvE98YTnxQ8Wx8Vj2Hj3kHo9MOT5NirLrcO6BNNEAochcXrKTES4K2ddlBsxrj9KTYjEaU+Kd9ZLa4P9F1R1zWKG30HIF1ZsTn7KlodK6uvFTHC+tj1iy8CHY3imO1pZ+xzG43E1e+TPBTBR8urRw/70MQh+6L3I9Zfb1rLnDbxNXALlFCYbi61mt+rGfb+vLQkvgsuhnitt0yhIV+h5KARBkJhJ6h7y6a8v3/TSj3PjlLoFKKVlJEAzj7ZtUJhJupWnacSRJ29onzca1TBzw/1WnmmApK2CePVGAnlAv23z4gIex630vhkfmz8DUZn7UDTQzNkmuoTZgsEF19XybGWYWy7Q1g7M1CKWxwyTvGzi9z33yoiGpQj3+/F/jibTrdyCLWx0CfxW9F5uNlAqqoDMSCuAXjmz+oo0SPSc//2VrggRpaJ+63tTGrJpNut7q7m9a5VN6RCs9ZDyge1qvhmtf9OsiEAjtkHRsNr/zxA7zHjiEzaMto6U46GT6oAFiVZELE7M+/vNUijflIUxCSkkVEGqQuukvGGkJnLaIfgwJyHpaqRdOBGvy6MW9aiynoEEXMq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(26005)(66476007)(83380400001)(31686004)(6512007)(8676002)(38100700002)(2906002)(66556008)(86362001)(54906003)(4326008)(66946007)(478600001)(31696002)(8936002)(186003)(16526019)(6486002)(6506007)(956004)(2616005)(5660300002)(316002)(53546011)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YXU0ZEs4US95d3d6b0FuU1BBOEllQTBOeE1Dem1DY21vNEdpL3NXd2oxcldk?=
 =?utf-8?B?MFBXZGJaY1VBV3JML3czQUY2SFExUmI4b2NiWm40aTVpb0pPMUIxTTVMcEdL?=
 =?utf-8?B?U2RtY2w0YzdYeGRGNG5qVEd1WHNEdjRQb3ZGNjFWV0JneEx2NFcyTCtSN1cw?=
 =?utf-8?B?WUFhNmdjRXJkMXdwT3VyNlZEcUpTR0RDREl5MTAvaUcrb2I2dmZUcWlUL2d3?=
 =?utf-8?B?dHhXbE80VTdTOG4wRTJmanBiSnJxc1h2UGpaSXB3SEpnTnhONUdEVWVsQVpu?=
 =?utf-8?B?cjFyRERmTjdjVlMyVlVRcGQ4eVk5TmRINHJjYklERkQvR3BvNjc5cVcvVlB4?=
 =?utf-8?B?YWlQRHpyenRnbURnMGRyenZTVGlDd2RBbnhjZjFtR3ZObHluckZhSzhlWmJ5?=
 =?utf-8?B?MGFvQTgzV2NoMVRRQW5UM3d3V3Zqc2t4Mmg0cVllMlBkQXB0dkdtdjlHZkFv?=
 =?utf-8?B?b2JVQzVMSjdFbktCMkUzYWZmcnpBNzlhWjh3b1lkQVNPSFhPRENRWS8wYnZI?=
 =?utf-8?B?SjBDZm5lQWEwRUJYdTd1QU1LbFpEbEhGbHBXemhQTW10eVQxWlRxQzU2TlNs?=
 =?utf-8?B?clkzdktQUlFjMU10OXp6N3VpZ212WldSL2FhVVNGb2VUanZRS1g3VGZ3Y3Zi?=
 =?utf-8?B?Ti9DUjJSOERDU2kvQmFtZ2JoK1U0ckpYK1c2OWM3Rm5lUDBYZ3RhOHNyZk9k?=
 =?utf-8?B?VWswTVJLcW1CVFM1dWh5TlB2NjFZSDg2OE5JWHRPK2pTc2k1VlhmSk4xWHVk?=
 =?utf-8?B?MU5NVGNLRlB2K0VRck02TFlxazNVWURLL2txNWRIbTBaaE1xam1FM3FDdm1u?=
 =?utf-8?B?SVB1SzNNN1FYbnpVRXltSzNKckVSK0svdmdPODBtYm0vaVBMSXRGQm82eS9n?=
 =?utf-8?B?dnZGWEdQMjhuT3cxeitQSzlHYVNMb2lLMnFvZDlLb2VzQlZyaHRGdjViMzd3?=
 =?utf-8?B?eTg0ZnNLWEUvclU0NUUzY0hHUkRNaUw3WjdvQ0V1OGp5d2VLOWhPREhyRjg2?=
 =?utf-8?B?MGhWUVVnN1g2b3pDV21HUUpjdnBxRFE2dEg3OTM5MTU2SHZJTVRzbE9Gc3JL?=
 =?utf-8?B?bFQ2ZVRzUk1ybit5RmNhSkFXdjlCc0M3Z2g5RGxtSmtHalFGUEF1ai9BN3oy?=
 =?utf-8?B?cVp1d1UzVU1GOTJJZ0ZqWi9TZmlsb0crRE4vNkhVbUtJeGRGRm9mWmhsODV1?=
 =?utf-8?B?blBpQlgzUkc5aFNLdGJUZ0VmenkwOGl2YmJlSzZvVHpEV3FsMDVhUWgzVUdQ?=
 =?utf-8?B?cVovdlREcW1ERTlWQVFCTnlHSW5VeTg0c0FoZlNCZ3I3RmRTMDdTaHhMTmxl?=
 =?utf-8?B?L1hqYjlqZnRpcGpYTldocnlkUVVaMVBnQ1F5UlJ6aEFManNCK2NCMnpmWkFr?=
 =?utf-8?B?VWgrcklmeFRreEdDSkJaNDVYUVRKMlhBVHFvRzl2N2NIN2NLSUNETlhFbDNp?=
 =?utf-8?B?bUNscWdmVVc1eU1PTUFSUkJJdmV2cittNmlUV2lkM2RCTE1UbnhNb0FrR00r?=
 =?utf-8?B?M0dMYWh4c1lqNCtvY2I4QUVHa1BKUmNWRVcrT1JTcTBZcCsyTUNvSFRjSFFx?=
 =?utf-8?B?emdBejBkTDFIOTVFczlhYmdOVXA4ZlFOcExFOFpvNkRsSTZTN2RQc3hwQko0?=
 =?utf-8?B?dm9COS9JVS9wMG1BNTRQVU82VXZpSFB2a2p5U0k3M1JrajFmSVlTNDJ0ajJm?=
 =?utf-8?B?YzgyeWNKeWxyTE8rSjZsUWdzcVl1eGVyMVJBZ1Rqem1BQUpvZE9qK2E2MlpP?=
 =?utf-8?Q?qzR6JuCTV1+L5FzCPzfPUG19HEN09/ddbbuqZRU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd6d657-dbe9-480c-0095-08d9251c1d76
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 16:41:33.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nW7YGSqsaJ/RDWyyzleq/NdSTYruQ4E7IA4a93hXPVFw5EDhXATnZdAmHA3TW5KIbIK3rWSYK/aednggZ2dMOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2619
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/21 12:27 PM, Varad Gautam wrote:
> Some vmexits on a SEV-ES guest need special handling within the guest
> before exiting to the hypervisor. This must happen within the guest's
> \#VC exception handler, triggered on every non automatic exit.
> 
> Add a KUnit based test to validate Linux's VC handling. The test:
> 1. installs a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
>    access GHCB before/after the resulting VMGEXIT).
> 2. tiggers an NAE.
> 3. checks that the kretprobe was hit with the right exit_code available
>    in GHCB.
> 
> Since relying on kprobes, the test does not cover NMI contexts.

I'm not very familiar with these types of tests, so just general feedback
below.

> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
> v2: Add a testcase for MMIO read/write.
> 
>  arch/x86/Kconfig              |   9 ++
>  arch/x86/kernel/Makefile      |   5 ++
>  arch/x86/kernel/sev-test-vc.c | 155 ++++++++++++++++++++++++++++++++++
>  3 files changed, 169 insertions(+)
>  create mode 100644 arch/x86/kernel/sev-test-vc.c
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 0045e1b441902..0a3c3f31813f1 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1543,6 +1543,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>  	  If set to N, then the encryption of system memory can be
>  	  activated with the mem_encrypt=on command line option.
>  
> +config AMD_MEM_ENCRYPT_TEST_VC
> +	bool "Test for AMD Secure Memory Encryption (SME) support"

I would change this to indicate that this is specifically for testing
SEV-ES support. We messed up and didn't update the AMD_MEM_ENCRYPT entry
when the SEV support was submitted.

Thanks,
Tom

> +	depends on AMD_MEM_ENCRYPT
> +	select KUNIT
> +	select FUNCTION_TRACER
> +	help
> +	  Enable KUnit-based testing for the encryption of system memory
> +	  using AMD SEV-ES. Currently only tests #VC handling.
> +
>  # Common NUMA Features
>  config NUMA
>  	bool "NUMA Memory Allocation and Scheduler Support"
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 0f66682ac02a6..360c5d33580ca 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -23,6 +23,10 @@ CFLAGS_REMOVE_head64.o = -pg
>  CFLAGS_REMOVE_sev.o = -pg
>  endif
>  
> +ifdef CONFIG_AMD_MEM_ENCRYPT_TEST_VC
> +CFLAGS_sev.o	+= -fno-ipa-sra
> +endif

Maybe add something in the commit message as to why this is needed.

> +
>  KASAN_SANITIZE_head$(BITS).o				:= n
>  KASAN_SANITIZE_dumpstack.o				:= n
>  KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
> @@ -149,6 +153,7 @@ obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
>  obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
>  
>  obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev.o
> +obj-$(CONFIG_AMD_MEM_ENCRYPT_TEST_VC)	+= sev-test-vc.o
>  ###
>  # 64 bit specific files
>  ifeq ($(CONFIG_X86_64),y)
> diff --git a/arch/x86/kernel/sev-test-vc.c b/arch/x86/kernel/sev-test-vc.c
> new file mode 100644
> index 0000000000000..2475270b844e8
> --- /dev/null
> +++ b/arch/x86/kernel/sev-test-vc.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021 SUSE
> + *
> + * Author: Varad Gautam <varad.gautam@suse.com>
> + */
> +
> +#include <asm/cpufeature.h>
> +#include <asm/debugreg.h>
> +#include <asm/io.h>
> +#include <asm/sev-common.h>
> +#include <asm/svm.h>
> +#include <kunit/test.h>
> +#include <linux/kprobes.h>
> +
> +static struct kretprobe hv_call_krp;
> +
> +static int hv_call_krp_entry(struct kretprobe_instance *krpi,
> +				    struct pt_regs *regs)

Align with the argument above.

> +{
> +	unsigned long ghcb_vaddr = regs_get_kernel_argument(regs, 0);
> +	*((unsigned long *) krpi->data) = ghcb_vaddr;
> +
> +	return 0;
> +}
> +
> +static int hv_call_krp_ret(struct kretprobe_instance *krpi,
> +				    struct pt_regs *regs)

Align with the argument above.

> +{
> +	unsigned long ghcb_vaddr = *((unsigned long *) krpi->data);
> +	struct ghcb *ghcb = (struct ghcb *) ghcb_vaddr;
> +	struct kunit *test = current->kunit_test;
> +
> +	if (test && strstr(test->name, "sev_es_") && test->priv)
> +		cmpxchg((unsigned long *) test->priv, ghcb->save.sw_exit_code, 1);
> +
> +	return 0;
> +}
> +
> +int sev_test_vc_init(struct kunit *test)
> +{
> +	int ret;
> +
> +	if (!sev_es_active()) {
> +		pr_err("Not a SEV-ES guest. Skipping.");

Should this be a pr_info vs a pr_err?

Should you define a pr_fmt above for the pr_ messages?

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	memset(&hv_call_krp, 0, sizeof(hv_call_krp));
> +	hv_call_krp.entry_handler = hv_call_krp_entry;
> +	hv_call_krp.handler = hv_call_krp_ret;
> +	hv_call_krp.maxactive = 100;
> +	hv_call_krp.data_size = sizeof(unsigned long);
> +	hv_call_krp.kp.symbol_name = "sev_es_ghcb_hv_call";
> +	hv_call_krp.kp.addr = 0;
> +
> +	ret = register_kretprobe(&hv_call_krp);
> +	if (ret < 0) {

Should this just be "if (ret) {"? Can a positive number be returned and if
so, what does it mean?

> +		pr_err("Could not register kretprobe. Skipping.");
> +		goto out;
> +	}
> +
> +	test->priv = kunit_kzalloc(test, sizeof(unsigned long), GFP_KERNEL);
> +	if (!test->priv) {
> +		ret = -ENOMEM;
> +		pr_err("Could not allocate. Skipping.");
> +		goto out;
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +void sev_test_vc_exit(struct kunit *test)
> +{
> +	if (test->priv)
> +		kunit_kfree(test, test->priv);
> +
> +	if (hv_call_krp.kp.addr)
> +		unregister_kretprobe(&hv_call_krp);
> +}
> +
> +#define guarded_op(kt, ec, op)				\
> +do {							\
> +	struct kunit *t = (struct kunit *) kt;		\
> +	smp_store_release((typeof(ec) *) t->priv, ec);	\
> +	op;						\
> +	KUNIT_EXPECT_EQ(t, (typeof(ec)) 1, 		\
> +		(typeof(ec)) smp_load_acquire((typeof(ec) *) t->priv));	\

I usually like seeing all the '\' characters lined up, rather than having
just the one hanging out.

Thanks,
Tom

> +} while(0)
> +
> +static void sev_es_nae_cpuid(struct kunit *test)
> +{
> +	unsigned int cpuid_fn = 0x8000001f;
> +
> +	guarded_op(test, SVM_EXIT_CPUID, native_cpuid_eax(cpuid_fn));
> +}
> +
> +static void sev_es_nae_wbinvd(struct kunit *test)
> +{
> +	guarded_op(test, SVM_EXIT_WBINVD, wbinvd());
> +}
> +
> +static void sev_es_nae_msr(struct kunit *test)
> +{
> +	guarded_op(test, SVM_EXIT_MSR, __rdmsr(MSR_IA32_TSC));
> +}
> +
> +static void sev_es_nae_dr7_rw(struct kunit *test)
> +{
> +	guarded_op(test, SVM_EXIT_WRITE_DR7,
> +		   native_set_debugreg(7, native_get_debugreg(7)));
> +}
> +
> +static void sev_es_nae_ioio(struct kunit *test)
> +{
> +	unsigned long port = 0x80;
> +	char val = 0;
> +
> +	guarded_op(test, SVM_EXIT_IOIO, val = inb(port));
> +	guarded_op(test, SVM_EXIT_IOIO, outb(val, port));
> +	guarded_op(test, SVM_EXIT_IOIO, insb(port, &val, sizeof(val)));
> +	guarded_op(test, SVM_EXIT_IOIO, outsb(port, &val, sizeof(val)));
> +}
> +
> +static void sev_es_nae_mmio(struct kunit *test)
> +{
> +	unsigned long lapic_ver_pa = 0xfee00030; /* APIC_DEFAULT_PHYS_BASE + APIC_LVR */
> +	unsigned __iomem *lapic = ioremap(lapic_ver_pa, 0x4);
> +	unsigned lapic_version = 0;
> +
> +	guarded_op(test, SVM_VMGEXIT_MMIO_READ, lapic_version = *lapic);
> +	guarded_op(test, SVM_VMGEXIT_MMIO_WRITE, *lapic = lapic_version);
> +
> +	iounmap(lapic);
> +}
> +
> +static struct kunit_case sev_test_vc_testcases[] = {
> +	KUNIT_CASE(sev_es_nae_cpuid),
> +	KUNIT_CASE(sev_es_nae_wbinvd),
> +	KUNIT_CASE(sev_es_nae_msr),
> +	KUNIT_CASE(sev_es_nae_dr7_rw),
> +	KUNIT_CASE(sev_es_nae_ioio),
> +	KUNIT_CASE(sev_es_nae_mmio),
> +	{}
> +};
> +
> +static struct kunit_suite sev_vc_test_suite = {
> +	.name = "sev_test_vc",
> +	.init = sev_test_vc_init,
> +	.exit = sev_test_vc_exit,
> +	.test_cases = sev_test_vc_testcases,
> +};
> +kunit_test_suite(sev_vc_test_suite);
> 
