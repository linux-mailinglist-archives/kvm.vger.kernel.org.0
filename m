Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E187E398665
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 12:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFBK0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 06:26:04 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:20522 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhFBK0D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 06:26:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622629459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M9/gN2atoxR+/ax0fxDFX6cTRj/a9jU+FymreGXZ0jk=;
        b=FZ9tlg6vcdKMQPnDnF1BS7bTGV8RRNtLbuqF5SFhYPJKFCbhI8pn07DudFOxN5QYY//5/Y
        Cn2xYfFN63IJ0KiDc3VnHB6iU7xmRHQcWNq89Lt/irs+KivCl7szV/umaZG6ISZ4O2letL
        OirBE70YiIojSMIKkCKQZEc0SbXU0Go=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-6-8xLvd6pfPtOjuFOXkWPUTA-1; Wed, 02 Jun 2021 12:24:18 +0200
X-MC-Unique: 8xLvd6pfPtOjuFOXkWPUTA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLrCl6ofUcBC5X6cP+FiFCudQF1Cyq5w8VRh1RIi5P+buUYk71J+ejOM1QVv///m9/0bUIkJtCSDDvXh8gNrULTBWmvsRPHCVjQ39jC1eb5ulFShVKw62opChiFNOXPYoaKLnJtohvovlkztJCT45L9T3kNys5fk6Kse86Tb7Zgg2Xgobq5XAvsIk108DA8m3vPIIJUNbtdbJdH5WUNN+/lR/Xpv2lTHZ+pMvrzgMuNcUETXNUDqzwycBgxK/eZM4pD7JmoIJNHLo8XqQWrt918BhL88AyxF/ypjIiothVxYSDusHupeW0hxuAx+FnfSDJ1RdhxcylCxu2yLHZr7mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqWu8kLr4d7yqW3MkjDZAw9Lg0G5xvrLZC72HrXG48w=;
 b=H424mDQr0ZEYyvQ1fvquf5YUbnJ6w2aTeh6zbhOROuwd0NjxsoMU5ZGDu+yi2N1XCOgyldgW+fo2iiodyhisEk58lj//kLj705kDgNVfy21z70+TWuB4w3vmQGP7QMLU9IHq0vQohsZ/Diod39B3mHgDyccGDAK38u8iPM+q9lBtuD5JxwgqVRQklw8v75w2l06ayo1BPu26GdMSDYrN4mSAZP8gj083hKAfdqAuaZs7wTlsUkvURnc2yIriHLkaM0fZtA9Npxr0MAqOeLEdeV8t8AVqsk2jKV/1JjKsiL2UNyy/yT0BeNzOsPctuMBMOrdS/btMq7jw0L/QyTwcJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR04MB6642.eurprd04.prod.outlook.com (2603:10a6:208:16e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 10:24:16 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 10:24:16 +0000
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org
CC:     kvm@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>
References: <20210531125035.21105-1-varad.gautam@suse.com>
 <20210531172707.7909-1-varad.gautam@suse.com>
 <fdc55029-bbb5-6d3e-5523-cada1aae8ddc@amd.com>
From:   Varad Gautam <varad.gautam@suse.com>
Subject: Re: [PATCH v2] x86: Add a test for AMD SEV-ES #VC handling
Message-ID: <8294717b-bbcc-a3eb-f36f-76235960d214@suse.com>
Date:   Wed, 2 Jun 2021 12:24:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <fdc55029-bbb5-6d3e-5523-cada1aae8ddc@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [95.90.166.105]
X-ClientProxiedBy: PR0P264CA0272.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::20) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.34] (95.90.166.105) by PR0P264CA0272.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 10:24:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08b0ef5c-9c3c-48c3-ca8b-08d925b092ee
X-MS-TrafficTypeDiagnostic: AM0PR04MB6642:
X-Microsoft-Antispam-PRVS: <AM0PR04MB6642387625F74EDCECB8BFC2E03D9@AM0PR04MB6642.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S8DfMnO7c5uoTnElnvbDuzFCsKnQnkmJnb4q5/jqiALlm7JKK1juOflY4obI729lqnMM73D0HqFL+hIHYDtLveKzVuZMyzaMBZTFID3FldBi6oF6prTyrq6Wye5efOyjTG8yCwY/IeQibQaKTNWaCKDgf2OX2MjxUCPWQsp1L4w6SeInUY7iRMg+zSMJfkEkoypZse37Z+mEZ452yoU0W0d05N/XxL6uooScIf7NQoZIGif96hvetgFlOrzWvtgUrb8wwjeN1kl+PVIpt49LSDUkIDgF9YwWsf7d0KgXPCVtyNPZiNh/aho4uKfnTyd5xEKFc4GGtkEOWLJn4mzQsaKqWwYnY+kKhIV0bAyDB+14dXwpPCWjNUIHyoNhfnxQztk+QyxD/mrxKwV6Flucak63sTLdw2b2WW9WKTHIMdwOgAl0XfOCRIv2nK6RYcOKbKqVfkCZghY105YxfvXFMnlBOOJjHL957H6XQejOGu3Q0LAG1KluXZ8OJuaIF+i90oF7MhFc6hzFVcVZ2FJ5McPXmJjyEHLd1MjW6gQKiFtgkBrbNM7195UurTtGO7b45AYdejDfyYjsPt40Cmi0fk72hOqdFBpJT+Pb5UZRnapWLep0tLkpJpvuByXybIXkDUgIUXaBTk/1Cxce5tBHh5njodKHqCjCeerRrBV9IOfytRVkvXEgfhXJnIwVa6UE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(39860400002)(136003)(6486002)(66476007)(16576012)(66556008)(66946007)(5660300002)(54906003)(316002)(36756003)(86362001)(31696002)(16526019)(26005)(53546011)(66574015)(83380400001)(186003)(31686004)(8676002)(956004)(2616005)(478600001)(38100700002)(4326008)(44832011)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8T0MJtv4C9YNLPwE0UzzBubSeLlm408w9NFKJYsDerYrLEuEOniJnrDPLbb4?=
 =?us-ascii?Q?E1t9ywRHYT19to/MqJrdYNRQ2lm25K9BHR9+H0QxKWF0A8UKQXor0XdApGpu?=
 =?us-ascii?Q?4PYfUAqVthtKdnutK4Za4DoEesTAGFxNIu991jwpWRIsXOQ+GGaaJ7FmhWLu?=
 =?us-ascii?Q?0UXDHCsumUVrzoZ7zq3fvVhil1C0tVUsJUORoASfQap/82cBByX5MAdLKAAb?=
 =?us-ascii?Q?e3okqBHoC6ESxX3JQ/tQXmSWSFtRuqSy/qId9grNpkUz/1Arfsual3kprdH9?=
 =?us-ascii?Q?5lkFqXWkpVLFqe3n4hu/5cAqdwDPi0s1rlC0pcN/U5PYsJhISLnuiRlusDG9?=
 =?us-ascii?Q?owf/aobw/IP7bdGOjWfLLBWXOj1wfw/OkbIGBUk5jQDZ/xTgfxdZdxDMSwd6?=
 =?us-ascii?Q?JSQhE02sL1gLkw3gS3DyRarSv3N2Z+xBCjXuTmFhcPlGFQuyfN3G0KfljFCv?=
 =?us-ascii?Q?nu+/SdbC0T9dX+F5IFsaWHmPFEaFtKQip5KXQHYR8n03H+s8fzBgkhDTHO6k?=
 =?us-ascii?Q?uE1GadAkJJvw2njLSGTp0JU82yz1wzuyjnxgvFXGwZJqoDMBLICHxZCMS+pf?=
 =?us-ascii?Q?fpAOh+TvTdm/Qa7A2vn6sBNRuCHfLizbo6iZ1LrikGdef4Y9pywMeTzqapE3?=
 =?us-ascii?Q?ECkw05bYNSdFOkbDJr3FlWN1bL3X/mK3lwogSgssOQzqmnxHSQz6ZK1DoIrO?=
 =?us-ascii?Q?/foSwUgVdmLLeaF0KluCSLvaLyCRt6npj4Sis2klaznY4HCr4Zt/l6Z2QCCf?=
 =?us-ascii?Q?VZOsoe2li6jwk5/VJqgIYhW4HTGFVkcdqOuBjzAmvxmKNhxHIZA1bTOcI7nq?=
 =?us-ascii?Q?Gq334SubMM1TeUNzS4mtxtx9h30Qz+aGJ1GKU3UawaGuyxfoZO6cQKNanwJE?=
 =?us-ascii?Q?p74olo+uDqxjd0oqQthMisYoEyGXjV90f/Zs1khldluR54GQYNZwgFUgv63H?=
 =?us-ascii?Q?TE2X3raE/4nSnv7k5mIkc55QH5p2Tiaa3psKPxLaYICMXhVI/bki6VexzIbP?=
 =?us-ascii?Q?oheYXXf6W8ffH+diQwPF34i46UCrO5liYiC4DFckoIBku8KO/QpzDaAZXd6M?=
 =?us-ascii?Q?xPp/WymbLf7/NTPn+rFX22pDjID7ECXyQSMAOomccvOTy31l7mwAPxH0P19o?=
 =?us-ascii?Q?5YzGA0S5GHdH9ZeD0zPdP7OogQ51jZev8IWdW8MRcI4HnMhTaXRV6iwRXr7p?=
 =?us-ascii?Q?0osAF0+Ub9ZlwcrzWJqktGvaZWaZNyghIlscAyCXk8liNIDvkoByGWAuLwcW?=
 =?us-ascii?Q?TzzNdzITmjzoW3jPd6+jubnsW8Qb6yshuSif1B3LXTqu96irYvYTaFXeR7Mu?=
 =?us-ascii?Q?CuC+UvFD70W9bItmOWaI90YI?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b0ef5c-9c3c-48c3-ca8b-08d925b092ee
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 10:24:16.0379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vkXdwowrFwXL2cKtoQd9hEQdXItHfQS6/d9EBw6mGRHjpiJUk9cDRoIkzelhthia2tQS31nahN36Xa1H9gbf4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6642
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/21 6:41 PM, Tom Lendacky wrote:
> On 5/31/21 12:27 PM, Varad Gautam wrote:
>> Some vmexits on a SEV-ES guest need special handling within the guest
>> before exiting to the hypervisor. This must happen within the guest's
>> \#VC exception handler, triggered on every non automatic exit.
>>
>> Add a KUnit based test to validate Linux's VC handling. The test:
>> 1. installs a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
>>    access GHCB before/after the resulting VMGEXIT).
>> 2. tiggers an NAE.
>> 3. checks that the kretprobe was hit with the right exit_code available
>>    in GHCB.
>>
>> Since relying on kprobes, the test does not cover NMI contexts.
>=20
> I'm not very familiar with these types of tests, so just general feedback
> below.
>=20
>>
>> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
>> ---
>> v2: Add a testcase for MMIO read/write.
>>
>>  arch/x86/Kconfig              |   9 ++
>>  arch/x86/kernel/Makefile      |   5 ++
>>  arch/x86/kernel/sev-test-vc.c | 155 ++++++++++++++++++++++++++++++++++
>>  3 files changed, 169 insertions(+)
>>  create mode 100644 arch/x86/kernel/sev-test-vc.c
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 0045e1b441902..0a3c3f31813f1 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1543,6 +1543,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>>  	  If set to N, then the encryption of system memory can be
>>  	  activated with the mem_encrypt=3Don command line option.
>> =20
>> +config AMD_MEM_ENCRYPT_TEST_VC
>> +	bool "Test for AMD Secure Memory Encryption (SME) support"
>=20
> I would change this to indicate that this is specifically for testing
> SEV-ES support. We messed up and didn't update the AMD_MEM_ENCRYPT entry
> when the SEV support was submitted.
>=20

Ack, changed naming everywhere to indicate that this is specific to SEV-ES.

> Thanks,
> Tom
>=20
>> +	depends on AMD_MEM_ENCRYPT
>> +	select KUNIT
>> +	select FUNCTION_TRACER
>> +	help
>> +	  Enable KUnit-based testing for the encryption of system memory
>> +	  using AMD SEV-ES. Currently only tests #VC handling.
>> +
>>  # Common NUMA Features
>>  config NUMA
>>  	bool "NUMA Memory Allocation and Scheduler Support"
>> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>> index 0f66682ac02a6..360c5d33580ca 100644
>> --- a/arch/x86/kernel/Makefile
>> +++ b/arch/x86/kernel/Makefile
>> @@ -23,6 +23,10 @@ CFLAGS_REMOVE_head64.o =3D -pg
>>  CFLAGS_REMOVE_sev.o =3D -pg
>>  endif
>> =20
>> +ifdef CONFIG_AMD_MEM_ENCRYPT_TEST_VC
>> +CFLAGS_sev.o	+=3D -fno-ipa-sra
>> +endif
>=20
> Maybe add something in the commit message as to why this is needed.
>=20

I added a comment here, ipa-sra adds an .isra.* suffix to function names,
which breaks kprobes' lookup for "sev_es_ghcb_hv_call". The alternative her=
e
is to do an inexact search within kallsyms, but -fno-ipa-sra is simpler and
assures that register_kprobes finds the right address.

>> +
>>  KASAN_SANITIZE_head$(BITS).o				:=3D n
>>  KASAN_SANITIZE_dumpstack.o				:=3D n
>>  KASAN_SANITIZE_dumpstack_$(BITS).o			:=3D n
>> @@ -149,6 +153,7 @@ obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+=3D unwind_fra=
me.o
>>  obj-$(CONFIG_UNWINDER_GUESS)		+=3D unwind_guess.o
>> =20
>>  obj-$(CONFIG_AMD_MEM_ENCRYPT)		+=3D sev.o
>> +obj-$(CONFIG_AMD_MEM_ENCRYPT_TEST_VC)	+=3D sev-test-vc.o
>>  ###
>>  # 64 bit specific files
>>  ifeq ($(CONFIG_X86_64),y)
>> diff --git a/arch/x86/kernel/sev-test-vc.c b/arch/x86/kernel/sev-test-vc=
.c
>> new file mode 100644
>> index 0000000000000..2475270b844e8
>> --- /dev/null
>> +++ b/arch/x86/kernel/sev-test-vc.c
>> @@ -0,0 +1,155 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2021 SUSE
>> + *
>> + * Author: Varad Gautam <varad.gautam@suse.com>
>> + */
>> +
>> +#include <asm/cpufeature.h>
>> +#include <asm/debugreg.h>
>> +#include <asm/io.h>
>> +#include <asm/sev-common.h>
>> +#include <asm/svm.h>
>> +#include <kunit/test.h>
>> +#include <linux/kprobes.h>
>> +
>> +static struct kretprobe hv_call_krp;
>> +
>> +static int hv_call_krp_entry(struct kretprobe_instance *krpi,
>> +				    struct pt_regs *regs)
>=20
> Align with the argument above.
>=20
>> +{
>> +	unsigned long ghcb_vaddr =3D regs_get_kernel_argument(regs, 0);
>> +	*((unsigned long *) krpi->data) =3D ghcb_vaddr;
>> +
>> +	return 0;
>> +}
>> +
>> +static int hv_call_krp_ret(struct kretprobe_instance *krpi,
>> +				    struct pt_regs *regs)
>=20
> Align with the argument above.
>=20
>> +{
>> +	unsigned long ghcb_vaddr =3D *((unsigned long *) krpi->data);
>> +	struct ghcb *ghcb =3D (struct ghcb *) ghcb_vaddr;
>> +	struct kunit *test =3D current->kunit_test;
>> +
>> +	if (test && strstr(test->name, "sev_es_") && test->priv)
>> +		cmpxchg((unsigned long *) test->priv, ghcb->save.sw_exit_code, 1);
>> +
>> +	return 0;
>> +}
>> +
>> +int sev_test_vc_init(struct kunit *test)
>> +{
>> +	int ret;
>> +
>> +	if (!sev_es_active()) {
>> +		pr_err("Not a SEV-ES guest. Skipping.");
>=20
> Should this be a pr_info vs a pr_err?
>=20
> Should you define a pr_fmt above for the pr_ messages?
>=20

Changed the prints to kunit_info(), which appends a per-test prefix.

>> +		ret =3D -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	memset(&hv_call_krp, 0, sizeof(hv_call_krp));
>> +	hv_call_krp.entry_handler =3D hv_call_krp_entry;
>> +	hv_call_krp.handler =3D hv_call_krp_ret;
>> +	hv_call_krp.maxactive =3D 100;
>> +	hv_call_krp.data_size =3D sizeof(unsigned long);
>> +	hv_call_krp.kp.symbol_name =3D "sev_es_ghcb_hv_call";
>> +	hv_call_krp.kp.addr =3D 0;
>> +
>> +	ret =3D register_kretprobe(&hv_call_krp);
>> +	if (ret < 0) {
>=20
> Should this just be "if (ret) {"? Can a positive number be returned and i=
f
> so, what does it mean?
>=20

Yes, "if (ret) {" is better. Changed.

Thanks,
Varad

>> +		pr_err("Could not register kretprobe. Skipping.");
>> +		goto out;
>> +	}
>> +
>> +	test->priv =3D kunit_kzalloc(test, sizeof(unsigned long), GFP_KERNEL);
>> +	if (!test->priv) {
>> +		ret =3D -ENOMEM;
>> +		pr_err("Could not allocate. Skipping.");
>> +		goto out;
>> +	}
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +void sev_test_vc_exit(struct kunit *test)
>> +{
>> +	if (test->priv)
>> +		kunit_kfree(test, test->priv);
>> +
>> +	if (hv_call_krp.kp.addr)
>> +		unregister_kretprobe(&hv_call_krp);
>> +}
>> +
>> +#define guarded_op(kt, ec, op)				\
>> +do {							\
>> +	struct kunit *t =3D (struct kunit *) kt;		\
>> +	smp_store_release((typeof(ec) *) t->priv, ec);	\
>> +	op;						\
>> +	KUNIT_EXPECT_EQ(t, (typeof(ec)) 1, 		\
>> +		(typeof(ec)) smp_load_acquire((typeof(ec) *) t->priv));	\
>=20
> I usually like seeing all the '\' characters lined up, rather than having
> just the one hanging out.
>=20
> Thanks,
> Tom
>=20
>> +} while(0)
>> +
>> +static void sev_es_nae_cpuid(struct kunit *test)
>> +{
>> +	unsigned int cpuid_fn =3D 0x8000001f;
>> +
>> +	guarded_op(test, SVM_EXIT_CPUID, native_cpuid_eax(cpuid_fn));
>> +}
>> +
>> +static void sev_es_nae_wbinvd(struct kunit *test)
>> +{
>> +	guarded_op(test, SVM_EXIT_WBINVD, wbinvd());
>> +}
>> +
>> +static void sev_es_nae_msr(struct kunit *test)
>> +{
>> +	guarded_op(test, SVM_EXIT_MSR, __rdmsr(MSR_IA32_TSC));
>> +}
>> +
>> +static void sev_es_nae_dr7_rw(struct kunit *test)
>> +{
>> +	guarded_op(test, SVM_EXIT_WRITE_DR7,
>> +		   native_set_debugreg(7, native_get_debugreg(7)));
>> +}
>> +
>> +static void sev_es_nae_ioio(struct kunit *test)
>> +{
>> +	unsigned long port =3D 0x80;
>> +	char val =3D 0;
>> +
>> +	guarded_op(test, SVM_EXIT_IOIO, val =3D inb(port));
>> +	guarded_op(test, SVM_EXIT_IOIO, outb(val, port));
>> +	guarded_op(test, SVM_EXIT_IOIO, insb(port, &val, sizeof(val)));
>> +	guarded_op(test, SVM_EXIT_IOIO, outsb(port, &val, sizeof(val)));
>> +}
>> +
>> +static void sev_es_nae_mmio(struct kunit *test)
>> +{
>> +	unsigned long lapic_ver_pa =3D 0xfee00030; /* APIC_DEFAULT_PHYS_BASE +=
 APIC_LVR */
>> +	unsigned __iomem *lapic =3D ioremap(lapic_ver_pa, 0x4);
>> +	unsigned lapic_version =3D 0;
>> +
>> +	guarded_op(test, SVM_VMGEXIT_MMIO_READ, lapic_version =3D *lapic);
>> +	guarded_op(test, SVM_VMGEXIT_MMIO_WRITE, *lapic =3D lapic_version);
>> +
>> +	iounmap(lapic);
>> +}
>> +
>> +static struct kunit_case sev_test_vc_testcases[] =3D {
>> +	KUNIT_CASE(sev_es_nae_cpuid),
>> +	KUNIT_CASE(sev_es_nae_wbinvd),
>> +	KUNIT_CASE(sev_es_nae_msr),
>> +	KUNIT_CASE(sev_es_nae_dr7_rw),
>> +	KUNIT_CASE(sev_es_nae_ioio),
>> +	KUNIT_CASE(sev_es_nae_mmio),
>> +	{}
>> +};
>> +
>> +static struct kunit_suite sev_vc_test_suite =3D {
>> +	.name =3D "sev_test_vc",
>> +	.init =3D sev_test_vc_init,
>> +	.exit =3D sev_test_vc_exit,
>> +	.test_cases =3D sev_test_vc_testcases,
>> +};
>> +kunit_test_suite(sev_vc_test_suite);
>>
>=20

--=20
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

