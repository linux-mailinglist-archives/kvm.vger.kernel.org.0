Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3572F62DA8D
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 13:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239989AbiKQMUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 07:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiKQMUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 07:20:48 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93443CDB;
        Thu, 17 Nov 2022 04:20:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oC806ey3v9KnNfKsEwJ86/PWA6WoNFWLbtUZvZQJKjxdGyUHxPiEnBSpFuYEJl9m3nuoTLpj+IQRgMvhPT+hRR6vc8h8aBKwj2PtHfxXiIbCCjHB/pbYFlTxPJ7PV3ZgblGEAfc2qUiCmbF0L57SGEPYcd6kPadylNx8qLS9PTl4yfwyPKTtBdvreq2qxw8EqDEunc+1TQMZsOrH5xgMe7a/DBp/Lj6YBe05MqC5IItgsa0qfDXd2G4C1orGXxkhwGxLqBif/I1epJ2PsETTMuVyUR9J5HSmSlWGDN15r2T7EEXuggoB8vCDX+MoRL5a4xvylOAxM8Huo5Xf/Mf3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1yUcS8UzomziTRyUHKTaKjtDK1qVKnnaoeTlYOPaWb8=;
 b=XBesZl5hejY1ax3Ls4Ky291a/8sMV+SqxghvTBfvDSqnjmVpXUL4NmIQjL2m3pm5y50blmSPT2xEP6UlDNxF9/F6H4CyIqmCmqygnRYinUbTsDlso2pyWdeWeW+iy+/GQTmIIjLYrr6DB6Gf8nN7zaRPHlKFRM0lkBNIHqeljw8b7CE/D2+jS5KvOGHI1FphVxCNajhNFadXlKl0NfNC95Z0o5BObPH8PXpDU5oJ1L2ZzNoonMnA7DDHBx0ACsxELAYMyOOiys1WeE2+Erwk4xqV1uIA7kEEt02wj/1nzXkgEtuOON/8PDez/TNcw/u83/8fhGdjUbywpe9vwUKM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yUcS8UzomziTRyUHKTaKjtDK1qVKnnaoeTlYOPaWb8=;
 b=45Rco+rp53/THSANL8bIqvTmzs35T7NaMTl9qLjLQLh3YXREdBS9WpdX4fdjn5t55Mh9cZvVMYs3JdJ2DUSMarYPWxbysm8Lp2Ybv+vI5ryDxIK0Q15+5qONDceBIKStmu2MOpwNPYbdiPgLJ2eVrZTUR5M18yY9n/ptsXwgVjo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB6861.namprd12.prod.outlook.com (2603:10b6:806:266::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 12:20:45 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6481:82ef:ffb1:4d0a]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6481:82ef:ffb1:4d0a%9]) with mapi id 15.20.5813.017; Thu, 17 Nov 2022
 12:20:45 +0000
Message-ID: <7e224da6-6b02-2972-1334-bc8e7894cdab@amd.com>
Date:   Thu, 17 Nov 2022 17:50:34 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org
References: <20221117044433.244656-1-nikunj@amd.com>
 <Y3YP5FQ6OHzVFKbp@zn.tnic>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y3YP5FQ6OHzVFKbp@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0078.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: 138b5a70-eee9-4bdd-bd37-08dac8962723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Sqd3bjOIyiCspG0CRF+fO4x+yMYQXx8xGu+E7FhbqIYCJsP7AkHQhyq83OV1p14JaAl8j+uaSE0pM5WkaZIm66Rzn5i9/TsQEPtGakI/abePZOYQ+xt4UGidJ+tZ1sArloo09XjFDp8Jc49aOQe5J/Wgqkw2O8Fw2NbyQtz8Y6cBbfSqHhBvJT8J9Kj8+oIwPRdULY/NVZABXXCF2rmWt1HbdoBaqm/V8hV8ZyNlwkgXh7r+c+7eam0j6I0RIKHrjTwk6mzrHXJtEY2es5141nUbDeX6uxrgLxKyl4OQFAsZKpStzeW7wPNjoPfPRGXQdLddvgTif/u54ZKYBEVi55syAPpscX6KM8hv3CW/suSg8YBUGfET76CCaAzN1dF+sU2MC97RmPsf8AxUPhUNPQORcZnOPfWKhM82ojYslyd0BKXTSFjE+2goKSVCAV4ETQScXh5Li25Slr2q5gyOaG6hyedehXUPIAaTePg5XTA3Q4hbD+cuBt4Fkn4TP93g5ufm0VoKGGkRbiDKganrAWzMTGyNMxNK8TgLvTnseZs/iNiNQ/wWN7KTA0eI0hCjO+3NwVmQhrf0A+pibLzLG4zo2S7gJGntAYnfD98ZrwXISv5vy6Oa0q0Zy8R8+1yDyg8N2vR6SjNBnSKSNaJHBXgodMgRGp5vopscN4r7XJMShe0jFFjd8Ho33F6nUL/I8YI3tA1VzyZJqGIpUsQarMAyABBStxljxcinQxsU3S4Bi3bS91QBToO6xtdxxHg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199015)(31696002)(83380400001)(38100700002)(478600001)(966005)(6486002)(66476007)(53546011)(8676002)(6506007)(6666004)(4326008)(66946007)(66556008)(41300700001)(316002)(45080400002)(6916009)(186003)(2616005)(26005)(6512007)(2906002)(7416002)(8936002)(5660300002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2Uzb0RIWnkzRGRXNnZmKzkxdE5RaCsxKzhKRmlSU2RrODV0Ui93S0R3N1h0?=
 =?utf-8?B?bk5BcjAxbEVRSjh3dXRwSlRoWU1VdEIxeE5tbEFyazdJYXlNTkVVZEQxSkdQ?=
 =?utf-8?B?NUQvTlN3cjRZMlUzS0lUSzZqcXRKbXJCeFdIMVZPYUNIaVpKWHpTdzRWOGZo?=
 =?utf-8?B?OWdWY3N2bEk1SkVHRUNoYlY5RjcwNkJ1REprVFNYR1c0L3NocmdxNHJZWWt2?=
 =?utf-8?B?WDRyZTVtZzJjYmtRV1EwYkRCZmRjbStOaHFxUU44cmNSd0ZXOHZwaGRHTVdx?=
 =?utf-8?B?MkkrRlRXYWR0MFlZOWVRNHVkditFN1R4YmZ6UTYxWGZPdXlubGU0WTBlYjBW?=
 =?utf-8?B?azE4bFp6bk9TWTV5YjltL3JJV29xRTAxYkhQVS9BS0pHeXBHVHZrVWhjVHEx?=
 =?utf-8?B?aTh2cHgycWZUcHpsS0pHelNMNlgzcERkOFREYm1CT0lNem5SWTVONlZjZWpJ?=
 =?utf-8?B?ODdQcXZHdi9ZOFVGOFhkRk9tQUttNjVUWUdQOGdSWXZWdzkzcmYwTkQrbDd6?=
 =?utf-8?B?dndvbWliYU1SYWlENngvY0xtRnBsWWozQ0FyZzdhc1VpWVpaam1TYytzNTVV?=
 =?utf-8?B?VThFbHgzd0JuTW5MWHZOeXRkTkIwTnIzY1U3QnBIbkFQQ0o1clpHa3BmVTdO?=
 =?utf-8?B?WHRvOWowREIvUnlpdUJMQ3E4L2dJc1JaZnJNRWJkR2dnWjhrUmlZSHpxSzc3?=
 =?utf-8?B?Nmd1YUhieHJadWFLTGJaODBiMWc1eWI3MGgzcWV5b1RxaTV0MXNnd3FLN3dk?=
 =?utf-8?B?Y1RHejFuQnphVnhTcXhaa0NKREdOQWswcDFhUHdUOFFiTncvWE9wM0l4eXdW?=
 =?utf-8?B?OFB1MUNjcUhTS0IxSU80UG9SK1RYYTZabVZYVm1MK3pMVzgzZUJ3a01qV2po?=
 =?utf-8?B?S21kVloza3NaZVRTY0FzbFpvRVZvN0s1S25ZNFc2Ym45V3R1b1UzenF3NTJp?=
 =?utf-8?B?YnhLSFh4Q2drTlE5R2QxbWdPMEdVci9YTzZ6RW5KcXNrdUcvbHA2TWoyeERS?=
 =?utf-8?B?V3QvWXl1dTFpNCsrTDlsZnpwWDR0RUNqalk3em50VzFtZmJyZnp2NUhseHdC?=
 =?utf-8?B?R0NWMXIzbi9GVzducEVMQmE0Z0duZFJlcTlxVk94KzdMK01USURydE84MXRX?=
 =?utf-8?B?eXdPWjlFMk81Mk1RaW9SdzErTkRzY210VmxaTENuS1RKK1Y1eXQ1T0RuWEVP?=
 =?utf-8?B?KzBhdHZTenRlbmc3UjJLQnJwMmdLNHV6bXhyQmE5RElwcy9YUUdXbHp4SFpk?=
 =?utf-8?B?a1R2NFZBSjZzVGIzZmQyYmd1SGxhNGtyM0Q4Tm1OQWxQWlVFSVpGTEk3dEd6?=
 =?utf-8?B?YlFqeU1jZFJ2N2VsSWRrdm81K2gra2ZibWJYZHBDRHZyTDNwM3BwUG5ZWXhJ?=
 =?utf-8?B?ejZ4RlVVaDVKVU5nTXpRa3JoVkpGblhrYnpZTW5tcXBobUlNS3E4OHVrTkxM?=
 =?utf-8?B?TnQvZk9KVTl6RXh2TkhVR2RadmdkNUtvS3kyYTJ0ZDNSSitiM0xxYmNHbDV6?=
 =?utf-8?B?SUk5cWtiYWpZV1pGMlNwV2l3WEtsMlRhQVhyS0l0ejJBMTFhK01mMnVuZUdj?=
 =?utf-8?B?MmpCT0xIaGZVbm5FUnJSZnZFeEJCK3pOdUYvRll1UmxiT0NaUU52UlZGV3Er?=
 =?utf-8?B?VUNkMGI0bjEzeGhraFppYzZKMWVoOSt1NkJKQjlHR3JOL3RBV2VJRWgxU1M5?=
 =?utf-8?B?a1M2NW05TTJFWGxKM250cTB1K2tIenh1VElFUlp2cU5LQXZWRmdhQWR1WTNn?=
 =?utf-8?B?LzlmVFkzUFJTQ3pOQUJKeVkra2g0bmpyMUxsMnMxbmUzWFFzenltT3pCRDRu?=
 =?utf-8?B?MiswL09VeGpzYmUwTU9NMGg1SkNiZDk2eUdwMkV3RlRYZVVKeC9FTkhiODdk?=
 =?utf-8?B?QWR1NTh6UG1kZmlBLzFmTXdzazJWSFFQS0Zlc3NqV3RBRUViTWhnYU1RcTU4?=
 =?utf-8?B?WWRHVkpTc0ZhMmo5WkhFVzVSWmg4QnRKUEFndXdGL2tPakE1R3EwZk5Zakx1?=
 =?utf-8?B?eEhvMEs4Qld5OGF1dnpQY24vVys4TUFoaTNGRlQ1WEQ1QkxtaHFlK0h1Vlh4?=
 =?utf-8?B?a3lJRmZuSkZ2UmZoYml2TzU1d3ZEOFVDbUdwVkR0bkcwWm90V0ZlMVNCVHQ2?=
 =?utf-8?Q?17RlqXn4vUn0B2QKWw4fEIOPi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 138b5a70-eee9-4bdd-bd37-08dac8962723
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 12:20:45.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9kIhZJe2/Pfua//x5OiQMbmTssMIXcNV+q2b0Z+iJAHlcklmvSnqGQfjB4coJ+0RIgs0mjOG2m1LK7V4FKJ7Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Boris,
On 17/11/22 16:11, Borislav Petkov wrote:
> On Thu, Nov 17, 2022 at 10:14:33AM +0530, Nikunj A Dadhania wrote:
>> SEV_STATUS indicates features that hypervisor has enabled. Guest
> 
> "... which the hypervisor has ..."

Sure.

> 
>> kernel may not support all the features that the hypervisor has
>> enabled. If the hypervisor has enabled an unsupported feature,
>> notify the hypervisor and terminate the boot.
> 
> This sentence needs expanding: why is the policy of the guest kernel
> such that it must terminate if the hypervisor has enabled unsupported
> features?
> 
> You allude to that in the comments below but this needs to be explained
> here too.

Sure

> 
>> More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
>>
>> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2F40332_4.05.pdf&amp;data=05%7C01%7Cnikunj.dadhania%40amd.com%7C44df93f0ef4349db849608dac8885136%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638042785223235199%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=RMoXNQZXTA2O%2F%2BJQHjmWCPMzkzITXt8F071UEYlOyIQ%3D&amp;reserved=0
>>
>> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
>> CC: Michael Roth <michael.roth@amd.com>
>> CC: Tom Lendacky <thomas.lendacky@amd.com>
>> CC: <stable@kernel.org>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/boot/compressed/sev.c   | 18 +++++++++++++
>>  arch/x86/include/asm/msr-index.h | 46 +++++++++++++++++++++++++++++---
>>  2 files changed, 61 insertions(+), 3 deletions(-)
> 
> Btw, how did you test this patch?

<SNIP> 
> It seems like you're new to this kernel hacking business - please
> remember that it is absolutely mandatory that patches must be properly> tested before sending them upstream.

My bad, was on a separate tree and missed to test it on latest.

>> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
>> index c93930d5ccbd..847d26e761a6 100644
>> --- a/arch/x86/boot/compressed/sev.c
>> +++ b/arch/x86/boot/compressed/sev.c
>> @@ -270,6 +270,17 @@ static void enforce_vmpl0(void)
>>  		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
>>  }
>>  
>> +static bool snp_guest_feature_supported(void)
>> +{
>> +	u64 guest_support = SNP_GUEST_SUPPORT_REQUIRED & ~SNP_GUEST_SUPPORT_AVAILABLE;
>> +
>> +	/*
>> +	 * Return true when SEV features that hypervisor has enabled are
>> +	 * also supported by SNP guest kernel
>> +	 */
> 
> That comment is kinda obvious.
> 
>> +	return !(sev_status & guest_support);
>> +}
>> +
>>  void sev_enable(struct boot_params *bp)
>>  {
>>  	unsigned int eax, ebx, ecx, edx;
>> @@ -335,6 +346,13 @@ void sev_enable(struct boot_params *bp)
>>  		if (!(get_hv_features() & GHCB_HV_FT_SNP))
>>  			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
>>  
>> +		/*
>> +		 * Terminate the boot if hypervisor has enabled a feature
>> +		 * unsupported by the guest.
>> +		 */
>> +		if (!snp_guest_feature_supported())
>> +			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
>> +
>>  		enforce_vmpl0();
>>  	}
>>  
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 4a2af82553e4..d33691b4cb24 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -567,9 +567,49 @@
>>  #define MSR_AMD64_SEV_ENABLED_BIT	0
>>  #define MSR_AMD64_SEV_ES_ENABLED_BIT	1
>>  #define MSR_AMD64_SEV_SNP_ENABLED_BIT	2
>> -#define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>> -#define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>> -#define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
>> +#define MSR_AMD64_SEV_ENABLED				BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
>> +#define MSR_AMD64_SEV_ES_ENABLED			BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>> +#define MSR_AMD64_SEV_SNP_ENABLED			BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
>> +#define MSR_AMD64_SNP_VTOM_ENABLED			BIT_ULL(3)
>> +#define MSR_AMD64_SNP_REFLECT_VC_ENABLED		BIT_ULL(4)
>> +#define MSR_AMD64_SNP_RESTRICTED_INJ_ENABLED		BIT_ULL(5)
>> +#define MSR_AMD64_SNP_ALT_INJ_ENABLED			BIT_ULL(6)
>> +#define MSR_AMD64_SNP_DEBUG_SWAP_ENABLED		BIT_ULL(7)
>> +#define MSR_AMD64_SNP_PREVENT_HOST_IBS_ENABLED		BIT_ULL(8)
>> +#define MSR_AMD64_SNP_BTB_ISOLATION_ENABLED		BIT_ULL(9)
>> +#define MSR_AMD64_SNP_VMPL_SSS_ENABLED			BIT_ULL(10)
>> +#define MSR_AMD64_SNP_SECURE_TSC_ENABLED		BIT_ULL(11)
>> +#define MSR_AMD64_SNP_VMGEXIT_PARAM_ENABLED		BIT_ULL(12)
>> +#define MSR_AMD64_SNP_IBS_VIRT_ENABLED			BIT_ULL(14)
>> +#define MSR_AMD64_SNP_VMSA_REG_PROTECTION_ENABLED	BIT_ULL(16)
>> +#define MSR_AMD64_SNP_SMT_PROTECTION_ENABLED		BIT_ULL(17)
>> +/* Prevent hypervisor to enable undefined feature bits */
>> +#define MSR_AMD64_SNP_BIT13_RESERVED			BIT_ULL(13)
>> +#define MSR_AMD64_SNP_BIT15_RESERVED			BIT_ULL(15)
>> +#define MSR_AMD64_SNP_MASK_RESERVED			GENMASK_ULL(63, 18)
> 
> So I don't like this:
> 
> if you're going to enforce those bits, shouldn't that enforcement happen
> after *all* those above have been added to the kernel first?

Not all feature need guest kernel support so I did not use mask, so added all 
the known bit fields that are published in the APM.

> Because right now it will be dead code.
> 
> So what's the actual purpose of this patch?

Purpose of this patch is older guests kernel that have SNP enabled (5.19 onward), 
when a particular SNP feature is enabled by the hypervisor that needs enlightened guest, 
older kernel wont be able to support the feature. There is no mechanism that the hypervisor 
can find out what feature is supported by the SNP guest before hand.

For example PREVENT_HOST_IBS needs changes on hypervisor and no changes in the 
guest kernel. In this any guest kernel having SNP support should work.

While for SECURE_TSC, hypervisor and guest kernel changes are required. And older guest 
kernel will not work if hypervisor enables Secure TSC. When secure tsc feature is enabled
following define should be changed:

#define SNP_GUEST_SUPPORT_AVAILABLE (MSR_AMD64_SNP_SECURE_TSC_ENABLED)
 
>> +/*
>> + * Features that needs enlightened guest and cannot be supported with
>> + * unmodified SNP guest kernel. This is subset of SEV_FEATURES.
>> + */
>> +#define SNP_GUEST_SUPPORT_REQUIRED (MSR_AMD64_SNP_VTOM_ENABLED |		\
>> +				    MSR_AMD64_SNP_REFLECT_VC_ENABLED |		\
>> +				    MSR_AMD64_SNP_RESTRICTED_INJ_ENABLED |	\
>> +				    MSR_AMD64_SNP_ALT_INJ_ENABLED |		\
>> +				    MSR_AMD64_SNP_VMPL_SSS_ENABLED |		\
>> +				    MSR_AMD64_SNP_SECURE_TSC_ENABLED |		\
>> +				    MSR_AMD64_SNP_VMGEXIT_PARAM_ENABLED |	\
>> +				    MSR_AMD64_SNP_BIT13_RESERVED_ENABLED |	\
>> +				    MSR_AMD64_SNP_VMSA_REG_PROTECTION_ENABLED | \
>> +				    MSR_AMD64_SNP_BIT15_RESERVED_ENABLED |	\
>> +				    MSR_AMD64_SNP_MASK_RESERVED_ENABLED)
>> +/*
>> + * Subset of SNP_GUEST_SUPPORT_REQUIRED, advertising the features that are
>> + * supported in this enlightened guest kernel. As and when new features are
>> + * added in the guest kernel, corresponding bit for this feature needs to be
>> + * added as part of SNP_GUEST_SUPPORT_AVAILABLE.
>> + */
>> +#define SNP_GUEST_SUPPORT_AVAILABLE (0)
> 
> The reserved bits 13 and 15 trivially belong here already no?

As they are undefined feature bits, we do not know if it needs enlightened guest, can't add here.

> 
> And I don't like that AVAILABLE thing either. I think this all should be
> concentrated in this single function snp_guest_feature_supported() - it
> should be called
> 
> snp_guest_supports_all_required_features()

snp_guest_supports_all_required_features()
{
	/* Features guest is supporting, currently no SNP features supported */
	u64 supported_features = (0);

	/* Features that will not work without guest support */
	u64 required_features = (SNP_VTOM | REFLECT_VC | ...);

	return !(sev_status & (required_features & ~supported_features));
}

> or so, so that the name says what it does and there you can pick those
> apart and say yes or no at the end.
> 
> I'm also not sure you need each single bit defined separately but rather
> test a mask instead first.
> 
> Also, having "_ENABLED" at the end of each bit name is too much - the
> name is enough.

Will removed _ENABLED, kept it for consistency of previous defines MSR_AMD64_SEV_ENABLED, etc.

Thanks for the review

Regards
Nikunj
