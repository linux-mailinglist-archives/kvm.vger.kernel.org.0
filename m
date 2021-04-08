Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F50358565
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 15:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhDHN5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 09:57:55 -0400
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:8800
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231534AbhDHN5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 09:57:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0akqArbXNa/gqPKKsg/S90Pj+LHzht5HXH7ycbW7eSUf/MGeCGZLspbFntrJ20irpMzox6ToVcH+8uT4AEE5Jt03sglL//gGjjr+nqTAHug0TO13a1VIKP1x8ykccAZVsz/jPYoprI8aTl5/3t9QrZ+O18nStOFVExZECzfgeNo8fwYREBDEtZeMwPTL13YDAu5pyfmgDIm+akZDi1EPJx99kOfQEL65ShyOyFQzCCjm5oWizQP/MA9gXdoX5MPARTiOXLZG/wEBuCrF2hkiHckS2meejGjvC/QJb08iheBZYNhnMh1J94a7wb2ClGH1EfN1kX+T3dgeMt9VkvnGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/Uhky4p7TF2B475aBORz0IRKxhR6GRQckap2mZGfDc=;
 b=KZGtjlt+3KJJPp45OMZAN9rJCMW6S9jUBVFbiXZd/Aa7fyIVc3up52Cy9mNcmJZV0BEmIocimbCZH+XRFOm3w2zdE5GOG+2cFk5Ak1qEcFIsr0OI7x4CX8hsnNOobEfyOp/bvrlpQobdToUJ8YmMAFK8murvUvJmQCi8Cg3Mk+CdES8hja6+f9CwduwHKkZ/dGi9jigtsyvg4eJu3U0z6At/tpgQdWNynrxpDILFecFzpNuO7wnqy83T3QPmIcMX88chQp6rzlXgBvn8BpUFBfJXWCtBa2fhwA/VQllxDgTk60AWxo1uZyt90jLGlzCLrGytQrsd3UfzRSg7m+aRnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/Uhky4p7TF2B475aBORz0IRKxhR6GRQckap2mZGfDc=;
 b=meLIjJt0253NKSJ6k8C+qwGeevcyCMKn/Vr3deVczPnkAAY8djTawgw4vVjaGQ6OvcxlCdHbxbxJbAv9tyA25rbOOasZw+drAdg3Vx0uOL4UQ+J1eJ5dtWUJ/s3/w5k90DwQAd5bLOfbf54IS7+7znKDu0Q+0AigkDflYQWYZFM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Thu, 8 Apr 2021 13:57:41 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 13:57:40 +0000
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate the
 memory used for the GHCB
To:     Borislav Petkov <bp@alien8.de>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
 <20210406103358.GL17806@zn.tnic>
 <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
 <67f92f5c-780c-a4c6-241a-6771558e81a3@amd.com>
 <20210407112555.GB25319@zn.tnic> <20210407194550.GO25319@zn.tnic>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <cba40ff0-29ac-d7cc-b91d-904bc511bd34@amd.com>
Date:   Thu, 8 Apr 2021 08:57:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210407194550.GO25319@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0501CA0080.namprd05.prod.outlook.com
 (2603:10b6:803:22::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0080.namprd05.prod.outlook.com (2603:10b6:803:22::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Thu, 8 Apr 2021 13:57:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec253e73-1c1c-4d30-9cba-08d8fa964613
X-MS-TrafficTypeDiagnostic: DM6PR12MB4957:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4957977BC783EBB5093741D0EC749@DM6PR12MB4957.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EQBXYPLEHfrOOvdUFJhFlvlLXkNa3YOnMPXCnz7T4l6W9aosrrtKE3k73NF+4Ngb61TKBZhetgHaTWN5e7xQ2KwRdiAlm9NAhi9yOtq0RpLRr6CWJuz16S/hmx3rPDtUF2Rej0yp0xHxW5G2WU6UF016FlruaZHfOO1l4n/jdDi43ubZCWLR1e+KE8S5vxjpmnBuQxogsW8xex++fPRO1mpypQ8GY/tjdA6pqsLe+X+uAOCXSk8GL71jbRxA08icXit7Y8ipl1i9rkpEWLyEhaCh2jxEs56GijYyiLBRIY/6MVbJHd07mFBkNr+bOWnf/ysALYKqHQDuqUvdJwiFjuPXVWz11TT/Z0cTqFGp25UetrQpBWtcOBAqd/JVq/jKzFdh7T4GBjR3btffBMXsAbLwF0wMTomBBwsP4zNd6Dpkw4+b+i6TH9+7SFVzdqG2HrJTP4lOsvTrwSV/cJYIG3GlCpNlTRTmLuzK6fHwpR2RGQMmKIFn48iwOd8YaXgdSXMwxNyR3Z+NcYaB0M1lFfmR+Cmhv1tpt863VEEjFSR64MEhAPq0nl/Nd1UsKN0Esk6qmDhCWlF0bAk1NjJeXesTKqIpqmi2GGZc43sFB1ALfyywePR/S29r5Bvm6T1KHSLAxz+80DrRfKXuRhcFdwXM9z3k+RiNNaAa4X5vWFbRBOWTgaRnGQWGn/1fJkSWP0JKiTy0bBTSP5nrjoZCzEGkge1hD1Fev9mBvtbWcfs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(31686004)(6486002)(8676002)(86362001)(66476007)(4326008)(6512007)(6506007)(53546011)(478600001)(36756003)(16526019)(8936002)(2906002)(956004)(2616005)(54906003)(316002)(26005)(186003)(31696002)(7416002)(15650500001)(38100700001)(66946007)(6916009)(66556008)(5660300002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c1ZNK1NXUlVJZnBRcmQ3OGdxQWMrTXNUam5XS1p2RXBEQXNOeWNYcTNnTE45?=
 =?utf-8?B?bVBYTlZmeVR4K3ZDOFBoOFZ0R1BYTUZXd2N3NTgrY2RndThZTXVsMExyTVZh?=
 =?utf-8?B?NGRpV2NJbS81T2p4eXN6ckNlRjhvbWxUU0V3VjRMbjRRMXVTYTF3TjJhaWNP?=
 =?utf-8?B?RU1lajFpazFod3VraytYMGxGRmlvUU9mbFhKaGN4MTlBTG8wVVNVaEhSY1Qr?=
 =?utf-8?B?WGtBUnBrWnZPbFIvSmZXeFZCK1pPWUZBWnJMNVY2ZTc4M29ZUHZtM0xWWlF2?=
 =?utf-8?B?MHQ3S08yRzBBR2htbCs4Y2E4aXR3dExMNG8zTk5NSVY4SmZWYW1aWU13cnhy?=
 =?utf-8?B?amZhVFVBc25GRHovWlFkRzJqTWFXektFQW1kM3RFMVdxR3RJM0hRZ3Fyd2Jz?=
 =?utf-8?B?RXV2NzNQSFZCOWQvQlFhdGRwMWhhL2pydE5URnMxdjQwK2xiK1RXWVBjemRY?=
 =?utf-8?B?Q29IU3YzZnIxOEtjaDBpUVFYcnUwV0RZSFp1SWdYYWFPVzY5TXBGSVNINUYv?=
 =?utf-8?B?QTBaRHVoSHMwRlcxVTRUZFR0cENOZUxITloveWlPdzF6di9ncjIrbGJYVGx3?=
 =?utf-8?B?K1J0M0lDSEdhdFdFLzRoQ29obnNPTkhaWW1xcnArM3kyY0J6YkVhUEI1eWl4?=
 =?utf-8?B?NVp3bUxzWUdaeWRocXRGdGxDcnc0cHMwUWhMVnhIM0NQY0VqcWY5NEhiQVFH?=
 =?utf-8?B?cUNwcC9URUlXRDJEcnZxbUxoVVgvM0prYUIzSFNZVzA3Lzk0b3VhS0VzdlM2?=
 =?utf-8?B?c01aSlhlckJzM29VSnJBS01tak1LWmxRaUlVanZaYTQxV2NIRjd0QmNFUnlo?=
 =?utf-8?B?MFlnV3l0TE9rWklCcTVubkVQN1RSR3lFOUdpUDBLL1lGV0RycFpDSTY0akVl?=
 =?utf-8?B?TGlFYzlobVpvVUxETFVkaCtXVUFqRnhNQjB3Y1ZQY1VrOE9HR0lIeVRHM1Bz?=
 =?utf-8?B?UHAycGJWSVBoSzJMdmhyaE94SDIzRSt5dUZXVEkvMUV4RTdnUFk0N29JNmVz?=
 =?utf-8?B?NVVyV3B5ZVhLem5MWE9DQWROeit4SVMwRFFqRksvOW8xMXVsczhkT0FzR0RW?=
 =?utf-8?B?L2tEUDAweTYzWFZ1b0plRlFrUDJvNW5XRVlZcUxINHN6WWdwMitSc0JpelRP?=
 =?utf-8?B?cmg1K25BWEkzY1NlaitPOXZ5YUtNbGZDUkxhUXIrb2FHMzVFMWtBYWV5Y1Ez?=
 =?utf-8?B?R0lCVngwOTVUak1xS2Npb1RJc0dlbk90K3NrcTdHV3RIOFRzazhMUzNjOFRh?=
 =?utf-8?B?SDJPQldweEdvWmlrSzdOWGhPVWhFbTRQSmNLS2VhSG9GaUhhZitvb1NNYmIz?=
 =?utf-8?B?ekRrOTcyakhnR1EwNDFBSlhiRHpXVlorWXZTWjQ3MGNYN21pVlBOeWpPRHBV?=
 =?utf-8?B?UVRvbWRNSi9XUlVSa09WK1UzdkNLWmxDT2dtRGFTK1BScFM2RjBQVlNNVGQ3?=
 =?utf-8?B?T1lsajJKMkVudGVHYnlmNW5CdjNXY2JvWGtBSFpkQ0JwQVduRndqcm8zUjFG?=
 =?utf-8?B?OTZQdy9TSlYxMThEdjJ1THFjZ05UdDh1eW9jNm5ORlgyRkVSeXdHbU12dlBI?=
 =?utf-8?B?WFMwb09KSTVydURGckJzaGZJMDVHckVRakp1clRGL0xrM0xKdDE4SXlvaU5G?=
 =?utf-8?B?Zy83cXJxRDlhaTJVMnFxM0JNbGFxVXN4SjN1MHJ6YnVMc1IyT1ZCdnJjVlhC?=
 =?utf-8?B?S09NeFRCSEp6Zm1DekU4WXJkMTlyMHd1M0tZbXR4d3JFS05ud2hMeEhmR0tK?=
 =?utf-8?Q?lfxr/r/XXCO0Np2A9eRRUhLTMToQEQw+mQ0SKqo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec253e73-1c1c-4d30-9cba-08d8fa964613
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:57:40.3552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1YONFA5jI5e8jsDNBfSRGbpzmI2fkQFrGiRdrXH3tYFru7oZpiy+Id5TZkwgy6k7hFkdUtBsQE4LTRXYElUFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/21 2:45 PM, Borislav Petkov wrote:
> On Wed, Apr 07, 2021 at 01:25:55PM +0200, Borislav Petkov wrote:
>> On Tue, Apr 06, 2021 at 02:42:43PM -0500, Tom Lendacky wrote:
>>> The GHCB spec only defines the "0" reason code set. We could provide Linux
>>> it's own reason code set with some more specific reason codes for
>>> failures, if that is needed.
>>
>> Why Linux only?
>>
>> Don't we want to have a generalized set of error codes which say what
>> has happened so that people can debug?
> 
> To quote Tom from IRC - and that is perfectly fine too, AFAIC:
> 
> <tlendacky> i'm ok with it, but i don't think it should be something dictated by the spec.  the problem is if you want to provide a new error code then the spec has to be updated constantly
> <tlendacky> that's why i said, pick a "reason code set" value and say those are what Linux will use. We could probably document them in Documentation/
> <tlendacky> the error code thing was an issue when introduced as part of the first spec.  that's why only a small number of reason codes are specified
> 
> Yap, makes sense. What we should do in the spec, though, is say: "This
> range is for vendor-specific error codes".
> 
> Also, is GHCBData[23:16] big enough and can we extend it simply? Or do
> we need the spec to at least dictate some ranges so that it can use some bits
> above, say, bit 32 or whatever the upper range of the extension is...

Hopefully we won't have 255 different reason codes. But if we get to that
point we should be able to expand the reason code field to 16-bits. Just
need to be sure that if any new fields are added between now and then,
they are added at bit 32 or above.

Thanks,
Tom

> 
> Hmmm.
> 
