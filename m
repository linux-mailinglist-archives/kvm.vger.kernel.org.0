Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995BF4317EE
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 13:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhJRLuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 07:50:13 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:50152 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231836AbhJRLuD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 07:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634557670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qzWTeJY2Ls402jqJATNhZb2nZj0Jlch56uYSWcc+gE0=;
        b=joqmW8uIad/JoxVJH98dhpOc1FOCPPGMGwkQHJCGwfJw71u7eeyyJM8RxAKUvqRdiU5sr9
        SxKfLh5SxvqAH+JFYAr8XkJR1c78PZFxA8YoZNyKxtf8+/TNNVYbGQWnZdH+AmdXNepdIe
        T2OXrDEgJvQpusvm8NVqkhxnUhHqNec=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-3QhFs-rnMBiPsgJP5ySJNA-1; Mon, 18 Oct 2021 13:47:49 +0200
X-MC-Unique: 3QhFs-rnMBiPsgJP5ySJNA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSbNJrHdtHXOPwuQZjlE4KMQjyMkw9Ex2dvKYuEgviIc4f4bmsZc0iW8EkyrW22hlturqvKR3AYn3hFyWwbHa6LGJ0baG0DJ0eHxK1TYyoMVRDrqEzeoLFJwSwLV29U0a2jSsrbm2SODwr1iVJ4lJFdu4vPn37lqS3WygAuLt1eWmfaDQA4GV+SllwBGj2H4795zI8CXpCgeQju99iQ9F7ANjz2bxYU/MnerOLCy6inzTPmzim4qCIpixGtpOHTgFDXxD89MOvRjuhoDXuPAsubW0FbHUBMVuHd6iLqVN2PWFQho3b3HZ5SEGdGjR1LZQzc9uuLMOUuwBZRQKNpnIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qzWTeJY2Ls402jqJATNhZb2nZj0Jlch56uYSWcc+gE0=;
 b=XSqgvxeGyGHXt/pca2Z1mUxjYvcY/gSZhukcEP43WHeDC85jfgXvgVvHdi8A9aJZ+xMqtAX0mkingf77Pgx27Tl2PEhN/UEUDrYZyR+kOX3u0Qzckb0cBymNz2mb1YzkKuUTH8auySUaKFM68gxRjCpTcykJ9PpmWPO0rIccFqwFeD/swMBbORi5d2NqQZDX9pLnPtRgVLUoEEdYvKF1SaPl+lnFznoFCgBRM/2o5b2gQd8XJY+C5EGy65dzXpXogcCxSYIPn4L94hw6VeFPEw7ejz/mwRl6tzGtDe/LYnSyo/fULP3kxel6y9FmpVEpFc+H45zu4pTT3am4Zqnnmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM8PR04MB7825.eurprd04.prod.outlook.com (2603:10a6:20b:24f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Mon, 18 Oct
 2021 11:47:48 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::80b4:c12e:2fb5:8b30]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::80b4:c12e:2fb5:8b30%3]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 11:47:47 +0000
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86 AMD SEV-ES: Add test cases
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com, jroedel@suse.de,
        bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-18-zxwang42@gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com>
Date:   Mon, 18 Oct 2021 13:47:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211004204931.1537823-18-zxwang42@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0023.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::36) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
Received: from [192.168.77.116] (95.90.166.134) by AM6P192CA0023.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 11:47:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8170501e-b3c5-4593-5064-08d9922d1b16
X-MS-TrafficTypeDiagnostic: AM8PR04MB7825:
X-Microsoft-Antispam-PRVS: <AM8PR04MB782582473CC1714A5E2E2876E0BC9@AM8PR04MB7825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mCcSSHvw9d387YMY0pBgqJ+DEl3LMS+vEhcd1FbtNgdnJGI4CpGPdO/HoWP9hfEkGLvPcbGUYq36o9sJJREqrFROWWFCgEsroDItHbpsBBNGpVrgVGIxK/X0WANFvCfcaQnDqE+Nv/SgqhBSo4DruOJi0RhxiQdC7P/OzIme8s8EmqMvQtw2UnPm3RgjrSHk1vZRCixUzJueBv0kEcFfrlwipra038DakSJ9MoUL4VMmjU/Rb2h4Rc5Kz+qNQ8a10QOHr3+ZMa3E9ZTf1qC8irOJ6gYqKg0aZeR8DmtIKKHSAvNXFesjLEXanVJIHtzEsUHeUQjw3xxRl4qi5RZQBzcKTMqviSDEuHbmrU2NVRyB9A9+2COfI20AC2xvtcRcWJtHrCuQ4C5Qrvmp3pqM23zMgHnbQQ4dDhKjLWkGhnz9UNrri+48V0EtiBhk6NhyvM8HJbEC8wQ8CP6zJ0b1INkhKGd1dOKupIojnSYCCZKaVFMRiucL0i2RdROeuo5lbtKuT4/zbXrYOahQY4pw4iEN4Dj8ADk4hVpzXyvMERQgWs44BkkQ5A27uYUQ2zIFwulsMmKuH4+zerC17IKHDTBiIRYj+vV1qFgclNtNAPBQw1D2PNMz/m6FDvZ0krkAJNmQlZo5B61wWjootTdXgQWoTjrI0nZjtIoK9zc0loq+G4mlH2LeFruMPJuHAoGJVHa8j16Ro+nuqPK7adl8HD5XnNX62BxId4diz0faBUI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(2616005)(83380400001)(7416002)(186003)(8676002)(44832011)(26005)(16576012)(5660300002)(508600001)(8936002)(66556008)(66476007)(6486002)(86362001)(66946007)(36756003)(31686004)(31696002)(956004)(53546011)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFE4Z3h4dFNHMUwvR3ZpUVdIV1drWmxDT1hqamFaeFdtRGFKaU96Z3g1dnJx?=
 =?utf-8?B?cFQrRmxlVkZIbWdWRTQrcjdzeGhQREhVNEt2QXp6dTRSTWl5NUJMUEE2LzRY?=
 =?utf-8?B?RnFWTXZIS05ramx1QnBwelNBVnNtSzBNV0JHUUhuZ1Z2dVBFYkxjdi91NTVW?=
 =?utf-8?B?STZuZjRJUWplbVFOVE40Si9Yb2dGVnB0WWxFblF1SmZJYUhNVW9qUFY0TFNw?=
 =?utf-8?B?OEI4MzlaMVpUUExzVCtwZG5oUXIvaTJQMWtaZlhBUUpseFdvbHljeGtqU2Iv?=
 =?utf-8?B?VVZEbHpvRDdwLytYVzVYYUtuRzFidDBSa3BFNFM2Z2k5QzdSUm5QVGQvNWcv?=
 =?utf-8?B?a0JlcjRHckdZQ212QTVySDFpYnRISnBraUpYTkY0WGVqVENqZUxURzBvMmk2?=
 =?utf-8?B?ekJoaVBnSURxUVpVOGNkMHpEZHdEdFdtNlY1bjJhN2VUZWlNV2ZIWXRvQ3NQ?=
 =?utf-8?B?K2oxbnNSaE1IY29VT3dtV2pRVzZSZlRCR043SE9yRnVoZkMvQnA4aHhpMndo?=
 =?utf-8?B?VE1wekJqQzA3b0lkNXR4SHFGd2wzN3ZueEM5c1NPK1B0Unl6MWRMcWs0UEk0?=
 =?utf-8?B?L0taRnlmejhqYy91cXhrVk5mTzh4bitMREVJVjd0UnB4UzNFUHVDakhOcWZO?=
 =?utf-8?B?WFZ1UUxQdVM2TEtVVG1pSHMzNWlqQ0RVS0dZVDAxMjE5SlFubEZFa0xHemkr?=
 =?utf-8?B?Wlk4OTBtMEdRcG80UnhwVmUwZUUvUmttaTUydDl2Q25qYnQyVjRGSmpqbVI0?=
 =?utf-8?B?SWVnc3RBeWJ4R210c1orRzl3NkNsdk45QW1jeFgwMFBsK09KOWxLcklUVFJ1?=
 =?utf-8?B?WXBMSWJNdEZWbmRVKzV5Vll2OHRqOVJ3aXdPSVVNV2svdWd1WkdPalhnQ05t?=
 =?utf-8?B?NklGczhNa0pXcE1RR1FhZ1pxVi9WY0JQTmdGZWYvMEgwc0RmR3d4M3hUSG4w?=
 =?utf-8?B?LzV5ZEVBZDdWNE1TTnQvZ09KZ1c4OS92bEdqcEY1WWdxMUZSL0kyZjBxa2dS?=
 =?utf-8?B?YXgwVzlUT0gzcHROYmp6a3RSc2FObWtGM1dkZ01Rc3hWdHJWT1huWHlLRStW?=
 =?utf-8?B?VGJFMFFUeXhuMkUyTWk1QWJISkxGVUs5TlpweW9mV0ZyenRXR2p2RnRhdzE5?=
 =?utf-8?B?MXJwcktDbmxwamhiWnpMQndrTmgrc0taaDVoMTU0K3VBS05RQW0xNStwbzRs?=
 =?utf-8?B?V09JUW1xWGJPbXd4WDgyQkh6Sy82anZ3NVgvNTREOFBqZEhPWnYwbERlMk5Z?=
 =?utf-8?B?Z04vUHQvMGRiNnZGNjh1SGFtTjdUNTl5cVREUzg3N3FTTUx3OUY1VUZYc09C?=
 =?utf-8?B?cStIRWhpWDVrRjhsalpsbU5ycWRKdnVKWXVnazhKUFIrR0E1dTNRODlGMGpK?=
 =?utf-8?B?dnp5UjdGMWlBUHZqcEZrYVFVZ0k5aEgvRDZtdDMwcGpFdFhINXNJVlBVZlMz?=
 =?utf-8?B?OVRzRU5CcytpOU8vakpqQjNqMGpFYjE4OG5LeWZWK0E2eUhMUUM0UzNRYkd1?=
 =?utf-8?B?blFnWk1zNng4RnVCVUViVk9qWk1oNFZzb2FoZ29majRDbVJYNFNIQm9sM1Rt?=
 =?utf-8?B?aEV2YjRSMjlwMWJGaTNwOGhuVWNZMHhvN1dnYm5COFlxR2hEemc5bDBRTkxN?=
 =?utf-8?B?a0hsS2Y4YndCVTJQZ1hCUWNzSEtoaW5CcTlybmlUV1M3NWNFZXFGN1llekE1?=
 =?utf-8?B?TXk1azZseXhGTm5ScDhHRDl4WXYwVDVsclRMbE9XM0d0blIvcHBkTk14dzhS?=
 =?utf-8?Q?o6p8ZgzBny0bTcVAwGB4aslkGIRb6cgxdyjuKP2?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8170501e-b3c5-4593-5064-08d9922d1b16
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 11:47:47.6356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZjAd0eyjER1KrJo7DvyzpEWVIgGdxUmKVGXW9iNgKMgZG/fgWzM0Vp2KYQp/jFiEPTPB8zPU7QHJW+ZSD0g2aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7825
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zixuan,

On 10/4/21 10:49 PM, Zixuan Wang wrote:
> From: Zixuan Wang <zixuanwang@google.com>
> 
> SEV-ES introduces #VC handler for guest/host communications, e.g.,
> accessing MSR, executing CPUID. This commit provides test cases to check
> if SEV-ES is enabled and if rdmsr/wrmsr are handled correctly in SEV-ES.
> 
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> ---
>  x86/amd_sev.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/x86/amd_sev.c b/x86/amd_sev.c
> index a07a48f..21a491c 100644
> --- a/x86/amd_sev.c
> +++ b/x86/amd_sev.c
> @@ -13,6 +13,7 @@
>  #include "libcflat.h"
>  #include "x86/processor.h"
>  #include "x86/amd_sev.h"
> +#include "msr.h"
>  
>  #define EXIT_SUCCESS 0
>  #define EXIT_FAILURE 1
> @@ -55,10 +56,39 @@ static int test_sev_activation(void)
>  	return EXIT_SUCCESS;
>  }
>  
> +static int test_sev_es_activation(void)
> +{
> +	if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
> +		return EXIT_FAILURE;
> +	}
> +
> +	return EXIT_SUCCESS;
> +}
> +
> +static int test_sev_es_msr(void)
> +{
> +	/*
> +	 * With SEV-ES, rdmsr/wrmsr trigger #VC exception. If #VC is handled
> +	 * correctly, rdmsr/wrmsr should work like without SEV-ES and not crash
> +	 * the guest VM.
> +	 */
> +	u64 val = 0x1234;
> +	wrmsr(MSR_TSC_AUX, val);
> +	if(val != rdmsr(MSR_TSC_AUX)) {
> +		return EXIT_FAILURE;

See note below.

> +	}
> +
> +	return EXIT_SUCCESS;
> +}
> +
>  int main(void)
>  {
>  	int rtn;
>  	rtn = test_sev_activation();
>  	report(rtn == EXIT_SUCCESS, "SEV activation test.");
> +	rtn = test_sev_es_activation();
> +	report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
> +	rtn = test_sev_es_msr();

There is nothing SEV-ES specific about this function, it only wraps
rdmsr/wrmsr, which are supposed to generate #VC exceptions on SEV-ES.
Since the same scenario can be covered by running the msr testcase
as a SEV-ES guest and observing if it crashes, does testing
rdmsr/wrmsr one more time here gain us any new information?

Also, the function gets called from main() even if
test_sev_es_activation() failed or SEV-ES was inactive.

Note: More broadly, what are you looking to test for here?
1. wrmsr/rdmsr correctness (rdmsr reads what wrmsr wrote)? or,
2. A #VC exception not causing a guest crash on SEV-ES?

If you are looking to test 1., I suggest letting it be covered by
the generic testcases for msr.

If you are looking to test 2., perhaps a better test is to trigger
all scenarios that would cause a #VC exception (eg. test_sev_es_vc_exit)
and check that a SEV-ES guest survives.

Regards,
Varad

> +	report(rtn == EXIT_SUCCESS, "SEV-ES MSR test.");
>  	return report_summary();
>  }
> 

