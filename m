Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3093611BA
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 20:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhDOSJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 14:09:58 -0400
Received: from mail-eopbgr750088.outbound.protection.outlook.com ([40.107.75.88]:38597
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232759AbhDOSJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 14:09:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgMKElfRD7zm9mhLuqc0bdZxmrNZR8ETHOlGraJKfx9KtX6GVHG4B7zzKCof3P3DX29z6nTi3SUGOF/Cw0fHXwPNlPNU8C3Q1zeUNVMczPY5vv1SCl3zKuo8tE+7FCmXeJqBFIkwDem4tg16yw5F8Tov46KLnnmFIVhD6JEHvF7ikkuNCKSKlQpUtJ5RhrBimVe8AmVZmDZJZUKc241cSh3yQ73PaFDAJiJwPWvCWQ2/FDKRe2q9thD86Ik4jhsLzaQAh2T+cdYBdfjrzpSytE5qIWXbAncHMEfslucikzte6Qxie/kG+tdL2TUIWbaVFAQ1AISFt7tXIZtMMcKenw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V633c9jHiUqPbU16glDbUCY97Uu+S0EJ6QwtGA9M8sY=;
 b=S3SwGpU0y8GK+LZZm90eWygsxpNOzawR2U4DcbWij7iEcwkRDfjsMS5WOkqmm+QiDRppD4X3pEhyuWiblKOUV3R2PiPhIx1kjMbEWGFEVJm2N3xBk9xhb5uv04CdIxvbIP4gdm+0fkw0eegH+Y8UlveK+xjde2MyV2Ys8VRqC2ZDzPybOm7T1JOGMxzG97aTsIL0dMZLhMeOFEoOXhUoOpfZ8aDQhEeHalzXsgNPdy5LpNXVbt8GK9RTWBlEs0LUZxzy1k8JG5pOTMF4j7r930OhYrnAKyjb9YIbZyiV0Wynwu+NHB1zTefgEmcrZm3Aqn9X2rnM5C9NLer7MswEBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V633c9jHiUqPbU16glDbUCY97Uu+S0EJ6QwtGA9M8sY=;
 b=Dxs1mnfpa4erY1qxSxGFscdZ7M9MUh0C8Nl7Xd3eYH+nYRLNxUPBKJZLLlWMtFcqMGTnQpr4qCFNPSu4mp4gP/eSpigxNRaJyj2P4SObYzvF16c+N5txyHxpJQllj+vF375714StUGuPNFNRr0/JvyYmRnR6Ut/kH2AwxN2+f2s=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 18:09:32 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 18:09:32 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak@linux.intel.com, herbert@gondor.apana.org.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 02/30] x86/sev-snp: add RMP entry lookup helpers
To:     Borislav Petkov <bp@alien8.de>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-3-brijesh.singh@amd.com>
 <20210415170322.GE6318@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <f5f8c536-d5d1-be78-3e2d-324f644d47d7@amd.com>
Date:   Thu, 15 Apr 2021 13:09:29 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210415170322.GE6318@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0181.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::6) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0181.namprd11.prod.outlook.com (2603:10b6:806:1bc::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 18:09:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcb54012-1621-4e68-688b-08d900399e80
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592011222CABA12579E60EEE54D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vs0p21Usn+o55FkHRo7F8dAnoWGDenKdnOBCM5b+XaascNVn4qlqMfwrFouW//xHAuIAm7WksAHWBHj8uzV/iaYto5MUcEhEk6//Te82Fh5nA2lCAmb4TN3ywOkpKrqZeMqhbLbN87P84IzKJxEuRdu68nMrd66VJfXkceZaz8kOJGOXgKMKnTqP8gZPbm2cX6wCqqZQPlKQTTqQgw8StWwIDIWgUVx/gtm9iBJyj69wHaZimQil/xsCo1l6HGsN8A8ce4T3roeqllYmoPUUsUiEyCyqExGrAFgSZ8ELvlTN+0bkiYiaMjap7mV5BPfZW6H3njZ+l4xCDQqmmZFzn/92MFrXsQTp4qlWn85BodTKQnn1M1lEJONWa0pG6oDFxOPkWIvkwe1V9S6dPabit7VWAKEDvtJA5nhsiqgghnvO7F1xYRhHdWymkq7CDF7k45bb1k25a7nksZCIOKkvMhOE/8nlYZofmH3dS3ObbYHalbHZXhefNWWU57/+EjZHGiCfQgari55CZyuvKs33oR0wfMntgK10NDARc05k6Ptd527ft4F6BF/2ZP+OCRofFbrDs9YleY6EuXX7ntCrlJ0j5gOmdaqEcFIFO50xHX160PaBEhWc9m5LQuMZRJXGAr1opKFzO2bxBzXPyLJBxK8fyGf/gKGpKVIMFO56m6jlkZA7UkxSmUsZ7hdEVYdOWj5r0bbGy72Ao36OLyORNs4J1Ltrf/RpuMNMi8y+PLU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(54906003)(8936002)(7416002)(52116002)(86362001)(36756003)(31696002)(38350700002)(6506007)(6486002)(38100700002)(8676002)(316002)(2906002)(66946007)(66476007)(31686004)(4326008)(66556008)(16526019)(5660300002)(4744005)(186003)(6512007)(26005)(956004)(44832011)(53546011)(2616005)(6916009)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U0RrOWF4TFVMWit3bENJeUtISE5Lcjhsb0ViY2tlVkhPUTBUNG1FR1N3azFl?=
 =?utf-8?B?UlVSRXF2d3NvTXQ4NkJDenM1L0huZ0s2bnpHZ25JcFIzOTBxaVMwUnpJOWxt?=
 =?utf-8?B?c1E1RG90MU9sbThTTTRGRnQrNXNoSEU2UnNoQVlWdDd2M2VyVnVWaGVxQThx?=
 =?utf-8?B?UlRjdXRxMWdxTDZTY3VKNDBzRjExNm1Yb2Z4SDlnbXI1TERLQUpFV05XYTdt?=
 =?utf-8?B?bjhYVlk2TjJXYlg1U2NSdi9OTUZUdTd1cW1ZcjNFY0V6RDl3RjlTOHhBNGRy?=
 =?utf-8?B?c1duZHo3cnc3aVV1SmpGN2ROZjFTb1pSWk1LU2RMa1lrVVNDUzdGSjVhWENt?=
 =?utf-8?B?ZHNyNldnZDVPbW9TekFIRlNMSkJlT1RwNlBURGY2eGxSUHRHM2FMNHNScVpB?=
 =?utf-8?B?OERTb3NSS0ptUCtGYVZXSncweHhWZVZCU1FSN1prbDBIT1BPWGFZV1pvZlQx?=
 =?utf-8?B?M3NsdGlNY0ZUbnJSOXZKWEc2bmw2YWd6UXo4d1FweXE3WU9uM3FhM21xLyt5?=
 =?utf-8?B?OWRudGd1bE41NXNEKzU0cWlRa1hxMVplMDZZYXZobVIwY0lzTFBWODdnUUpB?=
 =?utf-8?B?cG91Qy9uV3FSRmg1M2Rha1FoK2VHSDliWGJJdXRLSWtKWFVlZDV2Nm9UTC9r?=
 =?utf-8?B?anMxNnBxY0lTdUJQa1RucnNkNjFqdUFSWVVRVG1OdFpUTWk4cDFNT282SXo4?=
 =?utf-8?B?UFJ1aENrdkxvOTdlNmV6VTZHcUhsSnoyZy9mU0ZJUHY0aURSNmxhNUQrWU55?=
 =?utf-8?B?N3JoVGsxNVpmR0RpWDh5NHpJVTgvSGZvYlpzUGJYKzA1V2RTVENjWmp5UDAz?=
 =?utf-8?B?UjhTb0thVFJGcnpnNEtPb25XQU9iQVVYamdyRzJMOWR1TGxyOFU4WjZJalY5?=
 =?utf-8?B?LzIxQVZ0S2Z2bEFWUE5BMTJFcC9JYUtIRml0aU41dlNsU1ZZM0M0WWZzUndp?=
 =?utf-8?B?YktFVVh4cHZadTV5MVhQd0s5amR5OW5PTjkrU0gwcWNKenh1MHB6UFBCN1ls?=
 =?utf-8?B?Ukt4b1U0S1BuQlVHWXBJSlFnWkFnbG52WnJFU2I2djlKVTB5Q1phZ05JR3ZW?=
 =?utf-8?B?cnNZR090Z0VBbklpVnEvRlhQOFc4aGZXSHkzZmszdFdMd2g5Ni82dUJYYnBF?=
 =?utf-8?B?UmVIMVFucGJlZmxCdGxrMEFqMXM5dXFva3FyMCtVRitPWG5iMnN6MVd6TkFI?=
 =?utf-8?B?YVFVL28vWDljMUFBWTI1SUF6VStCcE1TUVk4dFFSWWpYL3ErQjZBM2p1WURt?=
 =?utf-8?B?WmdOcDlJeWpZOERqQW1CTkVsdnl4MEJwZDlLNlI5elpOSGpoK0FBejZkdUFl?=
 =?utf-8?B?Ui9hODBaL1lRSlB1aFMvMGJvdEhVRm9jSGZsYjNQYU9KeXdqRjN3MmZYRjZZ?=
 =?utf-8?B?S3AxdDY5Rk5YMGltaFpPQlBoL3RvaUVpd25XNUIwZ2pvOHBPdi9EY1dkTklm?=
 =?utf-8?B?U1NJanNGcVdhbEV2VW9uVU5BS05NUWJTU3pyVXdIMVBnTjBaaWJKekhGUWZ0?=
 =?utf-8?B?TmcwMFo2OG1FKzFZZmF0cFAxeE9nNk0zSm54UHFBOFVHdG8yUExDNzE5NTMx?=
 =?utf-8?B?WVJXTTR0ek9hU1VlSWFWclBaS29wcURrSUVsZFFIVUJqTTFIdUZNd1FCaGZz?=
 =?utf-8?B?WmExZTBBSzY2SFVkVmJ4akkyaEYyWGVnSGVkQTJ6MVpsR0dQa0kxOEFXNXpP?=
 =?utf-8?B?bVVRMmRLT2hkcGRhY3E3M1FRS2hGRGordC9ZdTIya2dENEsrN1YvT0ZMVlor?=
 =?utf-8?Q?AXHk1uMySpSqUxLaRQ5rljM27L6XFlNLla+BNYu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb54012-1621-4e68-688b-08d900399e80
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 18:09:32.3746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7CLRgLuxrG9Dg3DB/RykRFPVZEeVjw/eZ+y0lNKNDp92K/3MaLwkF10ewG7H3hIB1vAtX6wmd1ARgRLCXWRZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/15/21 12:03 PM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 12:04:08PM -0500, Brijesh Singh wrote:
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> Also, why is all this SNP stuff landing in this file instead of in sev.c
> or so which is AMD-specific?
>
I don't have any strong reason to keep in mem_encrypt.c. All these can
go in sev.c. I will move them in next version.
