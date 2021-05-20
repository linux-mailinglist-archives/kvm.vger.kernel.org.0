Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A98838B59F
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 19:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbhETR7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 13:59:13 -0400
Received: from mail-dm6nam10on2061.outbound.protection.outlook.com ([40.107.93.61]:62752
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236337AbhETR7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 13:59:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsyKDeX65YkmvJE56gJe4+VVNDwUrZx1/XdXX5imK0lgVP1mzh+XF3asOHCM9+hi/ByWj8jh0xLUjx5moHN6lrmDr6PDX+adeGySsG9o4ejIMs/rq8xWzbzu2CiWHBJAh4iAvNu1JD7pYOxrurZKgT/3UjehSQ3g7jcEkfGXXtq91L/uDqinI/bCQFKlhhuaG4azn2fgJqxirmbj4cSaVIQUPlN5/XW3n1LOJQFIpXb4tX2DxHnwJqlPcNCj8UvgQmDwmmdPkHT4zih1rCX7iTZHu2bnjEZ8q+kLpC1xU2bC89pQirHezPqJttrgj1xtNru5aLFk94ECsgtW8lR6Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLwdZDJLyLd50dWimxODO0T5wvoUtkOLEir9RU7+zh0=;
 b=F8DP9qp4OaPPD4CycT9qDFzngNtxsi5Iz7LNNg7mqXuuKXkKH2A63qcmZYYIfoOTQ83jpLyJ9Z5RPqsCCjpJTthYf8u8ts+b5D33jP0q/4tXm6ubCeeMNY8MRXW93K9PGT7NemwABbXRfFT/oLr32dRHPo4stitzgH2ccWHIPLNI/IKt1WbxJ5E11UVl2qLVgRgolIql/GUvx7Ntidz+w4mCAB/8TSAeFG9DgJ/8jOSPVGz2pWJfXI0VN6ZhPuslBd40b69rdU52ypI359GvC1J08ID48/qJUU6Nn1mCdavJUfgtOHSUnnwkiJy4GifrXiNUIuMTQg1fe4MhU8dP7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLwdZDJLyLd50dWimxODO0T5wvoUtkOLEir9RU7+zh0=;
 b=3m1i0bEOCva2kgCt/DGiiVHKhmb/Dkn8Nn8CW0MxV7+4BeBKHdlV78xthdsDej4eS6J1/RQGh99mETerFYb8gg+b3/ya3jdu6pzQdtxmjG4mXaU/0SIM+6igrhsdcMA5g6HwTohFMHvhYbK5qtsKrtQqlXqXuoW1VC438x/WdLI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2415.namprd12.prod.outlook.com (2603:10b6:802:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 17:57:45 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4150.023; Thu, 20 May 2021
 17:57:45 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 10/20] x86/sev: Add a helper for the
 PVALIDATE instruction
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-11-brijesh.singh@amd.com>
 <4ecbed35-aca4-9e30-22d0-f5c46b67b70a@amd.com> <YKadOnfjaeffKwav@zn.tnic>
 <8e7f0a86-55e3-2974-75d6-50228ea179b3@amd.com> <YKahvUZ3hAgWViqd@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <77a08d5b-3de2-4cbd-a8b5-58df7907dee4@amd.com>
Date:   Thu, 20 May 2021 12:57:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YKahvUZ3hAgWViqd@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0058.namprd04.prod.outlook.com
 (2603:10b6:806:120::33) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0058.namprd04.prod.outlook.com (2603:10b6:806:120::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 17:57:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c38d57c9-a75a-429a-e3ac-08d91bb8c5bf
X-MS-TrafficTypeDiagnostic: SN1PR12MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2415107B166B60F79232B58EE52A9@SN1PR12MB2415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ja87LzFHuEH0TTG0wV82qkZaHyNKhDC09c+X/+8KymxXofp9bMFrm8xXITSdfIG2a2w6A3axxUYHZPmWgeua4VLOpNU+O/ahLuGmdZuWE2oiVGS9QaGmPHv8uFCTtUeVYl0JYLA3LA0J+4y/dUld0DS/U75LAKb8UPRLE0vCcFq4UVZI6lI0ALTkgODfciGawv4jerwOyvVeWJcTAYSfp0jUtUnBKKALE6X/WVA8yyqx6HM/WT7jYhWEA99pm1xyXhsJLt1oAUjmr2h6kzSF26ZtxiUqjJe5M5p+bzB4btuvgqtYRQG+zIAGfET61Kfwh29/vOQyq9inW7PlmN20+aCzgNU68qdUDyTv6moPWWouR6IXUpT6x8ZIdqWnwo79MJaKwggKrYu6knXMCyg+0lxaTJv/c2maGRknI+vKW6miUgLYKt9ZqV5HcEBluH2U5jZosQPjzFzd05NUR3jRGiFhHjwRYocvOPJWYcj8l8h+hO3DkwaRcW66u/x2fEGLS77xCqVhUJnrdjq9P6ZGAN6ZUaFoz0U5A6fnjtOPcgfKDGxMJT3mWiYnYPijqgkDM/b9fE89d3qqbQO8CfJC2wsQbzy4o48ZxWIcBpTtATNdSc1iVLj2dP0utaknWRP5MBoMFh4d/pKZpVogrdNITVfDTWb1arI3qubZ5j1X9JBHMegCTLOcqlTEursNasY+YqlhiDrCCqV/OInSzwLDJCJt9vsobmD9q/sOhGRHi8M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(52116002)(478600001)(8936002)(66946007)(31696002)(83380400001)(66556008)(66476007)(5660300002)(4326008)(8676002)(6486002)(26005)(38350700002)(38100700002)(6916009)(956004)(2616005)(186003)(7416002)(86362001)(31686004)(44832011)(6506007)(2906002)(36756003)(16526019)(53546011)(4744005)(6512007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z25PWGtZd080eGVTUmNhWXpPWnhnUVVxQnRuaHFiYlA2Tk94Z0Nod2JhS21a?=
 =?utf-8?B?dnRXUEZLYnJYbkdMSGhTUmxUeVNDRjJ5WkdYamZqU2tMci82UEY2eDIvNmFU?=
 =?utf-8?B?YkNYRjFTNDF3OUUvMUUxZlB2a1h0ZlpEQ2NQaVpuUC9naXUxSy9iNHZJNkFF?=
 =?utf-8?B?TGptbUc3akZTUE9RTkF2V2o4ODRBNy81TU9reFB3S0lZVEJ6Um54SW9Hd2tJ?=
 =?utf-8?B?Y1Vva2RTamtpZCtUNTNxRWR0UEVEeVlDZEtuS0tOSVNaRklUNXhDL1hhV29W?=
 =?utf-8?B?anl1aDQ0dWc1RVdsYTI5RnRIOXh2M3g5aUJoY0c1TDlJMGZ0Q3NiakhKTHJk?=
 =?utf-8?B?MW95R1VnaEI5LzNnMGZGSU81NldlWnJwdkszODRSU0VRdVZ5dE44ZDIrbFhI?=
 =?utf-8?B?RXN3b1Nyd3hsSUVwSnNrdmNkN09UdWJHN1hCcEFia0IxTnNXN005ckhEUExo?=
 =?utf-8?B?SGFBb1QwblVTOHFHeUxrK2x5NjJpZkluaEtRWm1yU2FxdjYzWmwwOC90MWdM?=
 =?utf-8?B?T1lTT20xcERDblVGTTBGWUpheVJCSWtiN2RMdk5hcDNwMmk5VFYrVWlEYk5t?=
 =?utf-8?B?YkFuVzlEVVhoNnpPcUQyaVpWYzFpRG10eUNTWVJjbHAzdGZ1bXlyUWdla1Bv?=
 =?utf-8?B?c2NUOFNWSmZsQmNXdXFnQWJHdWl3OE1GQjVDQnhCclZVSzF6djlWeGJVNWNI?=
 =?utf-8?B?WDAxeWZEUCtrMFdxa09xWUxXbzJabThEbXlhblY5UklxRW5pT3BKc25iNUp4?=
 =?utf-8?B?V25tQWxzT1VLWkp6N2Z4TW43U0huRGFvZEt1RDd1UnZSNytRdy9FcEtJVVBJ?=
 =?utf-8?B?bkM5cXI0MnhFdEE4aGFtUzBwdVNVZjU5ZHRleFlyOXRuOU1wbXpFUlhWdUt6?=
 =?utf-8?B?WVBSZzRTaDkySmh0TW5OQmt0Q2xHWU02VHVEMElpTjZPd1ErY3duYU8wVUk2?=
 =?utf-8?B?Y3BVL3c5dU9oRkFqS2dZdzBaSWhObjY2YlBzc3RtQTlIWit5M0p1VnVad0FB?=
 =?utf-8?B?WGQ4aGRkZk45YjcxVFdaczd1ZFVBSFVxNE1ZZFFLWHpTMGc0NUlJWm1tVUZU?=
 =?utf-8?B?WnkzN1lXTXdScG9IdHQ3WjRyVy9mQk5iVzZSRFBrbjZuaVluemJ0S2ZHV3U5?=
 =?utf-8?B?REgvemFDaS9USThybUxjY0VJYThkRFU4ZG93a1NGczhOUlc5SU1UMWhGN1FX?=
 =?utf-8?B?akZjZlpwYm5JVmJoS2RWTW5VelNNSnBrYzlBVmtka0dNNzgvdm5KSDRrSXVJ?=
 =?utf-8?B?ZTZsR0l2V09UaER0Z0hiZE52SkhmU2lpYm1xeGJWSEV2TWJwTHlzK2R2aXZB?=
 =?utf-8?B?cFI4c2xoODMxSnBnWEszYURRbXY5WXR5MVVtdWtkOGFocEFjaitRV0w0aG5m?=
 =?utf-8?B?STZGTlkvemRpZnFqV0pyMW5QSTdMUUprL1lKcTdVV040RC9jRGdyR1VGQnlI?=
 =?utf-8?B?V1ZpdDFIY0JDWmx6QlhzdllYczEwQUpsZzV5Z3hodk92c2FmNTkrMUxOYTBY?=
 =?utf-8?B?T1p4TXRZeW5xQlR0aWltdDdIcUpsNzZDVUd4VVZQQWF4SmNLNHVYUHM2d2Vt?=
 =?utf-8?B?R1VVbUlBTHVmM3doUFlBNU05eFMvMmFEVyt4dU5GRkgxaWNXTW1jVmphUzJR?=
 =?utf-8?B?UE9KOFNCRDFJUjF1cjB0a0pobDM4VFBZOWFXREwxSEY2bTgvamsyTlpZUno3?=
 =?utf-8?B?MU1PZS9rWnU2N3VZQTkwa1hhcUxBcm5oUVdwa0Fjakt1N0dUR3hycjJNTmRK?=
 =?utf-8?Q?TKK9PWltmDan1fxlEhT9wghro99M+78w/DPIREt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38d57c9-a75a-429a-e3ac-08d91bb8c5bf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 17:57:45.7294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHdszHKR2FNwc8nWXM/qPdt/bOfl0OvWy4XOJHS0QBRr+f35EIuBuGEGv0xWGEM08BMxpu9LMYx8O509ct4KAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/20/21 12:51 PM, Borislav Petkov wrote:
> On Thu, May 20, 2021 at 12:44:50PM -0500, Brijesh Singh wrote:
>> Hmm, I use the SIZEMISMATCH later in the patches.
> You do, where? Maybe I don't see it.

Sorry, my bad. Currently all the pages are pre-validated, and guest
kernel uses 4K in the page state change VMGEXIT. So, we should *not* see
the SIZEMISMATCH. This will happen when we move to lazy validation. I
mixed up with OVMF in which I validate pages as a large. I will drop the
macro.


>
>> Since I was introducing the pvalidate in separate patch so decided to
>> define all the return code.
> You can define them in a comment so that it is clear what PVALIDATE
> returns but not as defines when they're unused.

Got it.


>
> Thx.
>
