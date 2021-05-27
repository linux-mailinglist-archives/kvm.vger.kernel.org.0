Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F53B392E70
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 14:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbhE0M6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 08:58:15 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:53537
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235177AbhE0M6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 08:58:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPgGWNtYTCrR4FXDu5rR/fWhAq1GMF9Cj4Ufi/8wrJjzueEMPKB9mjnBFNa/aiBcHyunZtSpylFE2ig3gGvLuod0HmAmPV+mIxNyhEpga9rPcaPi2K+DgIoreF+ynpHqZDauQ0hExCQKcrUu2kAjREovNEeFCpuvOK+t2WEv0IPt5aDjmDWCXOWTuDxGc/C6LiVyXivnGQ4dRbqQgEq5SfvUAq4kiFFGxRC3FV3pEw5e72pLuG6K87uNZT3b3N/lOjcD945AXqvN/wuSiX1h4+KJQ3bBc6vu0CSO5z+TtzpQYHHQMhZ3rk6RJmgUQtuiJzhGu0CjwXGS/FQ2SAww4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTExakRE4KuSK0AJrwp6IALVnN8pS6xkIi6id3u2fEc=;
 b=QIK1odE8X36bhTcu/ZTVu/9V+jtt16Y+1fWaYldONTa8ISR641OeYM+Pkd1PWZvEELwMxro9/+M/A6ME7ZPHeUdt1z54UI3NmS69JZpA0FJ0dZJRzMQbQWKe8mf0Plhk2snGyjJ2b6JxyunHqhf6cRvzcNSajQxDoeeROHAffAx/g1d7vwkiO3mHw3UtFNIiRAjqtPuN52DV24VTVorKrqIHxxTdm/YalpKVTxsdhBeyNjdEmvWLMCydAZjeKVVInUqdYo0G0UpLbD3issHUDs97NM0Pv0UjNrtUnaB+J86A/JxtQWp/gR250EcWTmr7Kojpdaoudxv1pOvhHbiKhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTExakRE4KuSK0AJrwp6IALVnN8pS6xkIi6id3u2fEc=;
 b=N7dY/Y9cG83KAm0kIbhFO2TESCmOGHm/bk+wueoCk6izXMKfgPiGR5NssabHErb3nXAjt+ce2mZiKiIblxBSe+vMigxQhAvvOmc7ZeQ0ko3Y2WzQDNa8Md2YV6L8O9GWoA/8RigNCoACkReJuEmcDHfV8343GqOW2A8qg95WERs=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 27 May
 2021 12:56:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.022; Thu, 27 May 2021
 12:56:39 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 16/20] x86/kernel: Validate rom memory before
 accessing when SEV-SNP is active
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-17-brijesh.singh@amd.com> <YK+HMZIgZWwCYKzq@zn.tnic>
 <588df124-6213-22c4-384f-49fa368bb7ed@amd.com> <YK+PR5mf/H6TNDt7@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <f71f6300-f60a-d4b4-96d8-f415357f35b9@amd.com>
Date:   Thu, 27 May 2021 07:56:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YK+PR5mf/H6TNDt7@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR01CA0003.prod.exchangelabs.com (2603:10b6:805:b6::16)
 To SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR01CA0003.prod.exchangelabs.com (2603:10b6:805:b6::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 12:56:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22548a05-b91b-4e3d-08e3-08d9210ede77
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384CE6BC34FBB5090F7ACCCE5239@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 70/TYsUS+ilu7hPi/OQyi3WkLuHvtA+SiqfDJsWj1V1vMQRIp9MBo/pisDmas65CDGkAJh0T3IQqqOCUQ2OOB1wsnvOIOBqh2fUcL+KCOznw5xiFjWLGEZFaqoqvTov/gJDBv33LvvD0GyBuzN8af27ozVmEYL4UQN5+eFSz072KXpzbacdqFcu8QiwXRMoI776ocoKzqCydYZ27X1WBe+2ObfOE3+nZmbWqtYE+SxpQwf0DK0wSS+p5XrwqLXtb/1hEN938/mXMY1aGiisZg3lVO1wbfQ9abkHzmT4qIXTcR6e7DXqWozQ5+CRH5NRPVwPXf/MwLsgVWd6Riqn+g8Yl8J+F/W9xSbeVAZW/KzBujmOGXJkhqukSGU5kFEzNX+nJoaRt4qzXOwABCRJZQeyY0pj6z5znHU6lHDYH0SrmNT8wzmtYukigeq4S8UmMgDoEjzPSNFjPHMNkJxHftrSXZnUYWHQE7TAcQ8lvfDpLyQsyqLl6xSG8b1JtfLsUL0jAXYDkFIMrZbie6CU9QETCfcbJAVcXhtz/yReq/+BRTOwZheXFOxzwKMmJl47pFadOHQWpfCdrzp0KZIUwWYgJd306wWKIJWF1Qh9GFKbDvJ04snOtcT41B+OK4+wethGmKswUGN6Ks7dlPAqd6BV2o3xp/h2enH8DQNbqJGQegxRHGmQCcWnsbIOXzTty
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39850400004)(136003)(396003)(53546011)(478600001)(26005)(6512007)(6506007)(4326008)(956004)(2906002)(7416002)(44832011)(52116002)(16526019)(2616005)(186003)(4744005)(5660300002)(31696002)(38100700002)(66556008)(316002)(8676002)(38350700002)(66476007)(6486002)(86362001)(66946007)(36756003)(6916009)(8936002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UVBSRTkvRXRmNEZrcXVQbWNsUUlzSG8rMVRHV0w4SThwM29PVm0zNENDL3RL?=
 =?utf-8?B?aEI1ZmJ0Qm5WMEFmcE50TGh0NE5iUHB2cFRpSldvZml2QW9kaWZHR3Vac0F0?=
 =?utf-8?B?S2pMcnRGdmZIUExJT0NVdzVMNE5ZRysyaFdUZHNEbTVNeFdocXdzNTZuZEZt?=
 =?utf-8?B?M3VOYm1tbk9UenM0R3NaWXdpTFhrT3FQQy9uTG5JcVlVcmRyWFlnOEk5b2ZY?=
 =?utf-8?B?aVoxaHNKa0pkTGZuZyswRUdOZDhCZFBlRzZWUkpzSnhTM293K1U3SHM0c0Rp?=
 =?utf-8?B?clZBdFMyMDlEb3doaVBLQUdEWWRCek1YYTE5bi90MUNkVm1qMUMrSlVxZFJl?=
 =?utf-8?B?MlNVQUJhTjIyYk5zb01CODV0M2FUaENWMThUdEZ4ZWh5THpNdjBUc2hIYXNC?=
 =?utf-8?B?QXM3SHl5M2EzbHhYM2dDOVNDeEFZSmNLdjJVbTZVaG14Q2hTdXVTK1M1eFhV?=
 =?utf-8?B?UG1IdjRJKzRyZ0NWRzNuRnVWdWY0TjN1bWkzSGtySUZHTTFWVmwvbm5TM0ZR?=
 =?utf-8?B?ZWkxQitQdVdINVBWckVtcEJVSVF6Sk1kK3p4NmZiSFNkK3BWU1oxZ0FYbUhS?=
 =?utf-8?B?UDJJQUx6c29LMjZYTVg2TndkVmNrQzBYbXZZNFo1UHczdzNxUEY5Nm80RVky?=
 =?utf-8?B?UmNHY0dJZ3EyQ0tqMlNNSXBYalVvR2pQM0t2dXdHVFc2WURLRzZDTEN1T2ls?=
 =?utf-8?B?Y3FYY01Ma0p5T0xtT0Y4bVVXbjR4OGJtZ1F0NTRhMlY4ZkpwdkxBK0hyOHN4?=
 =?utf-8?B?bGM5UGp6TmRUVlFEYWkyNHZoWWJwcXE4KzNUSFRDNm05Wnk4bXhwOHgvTU84?=
 =?utf-8?B?b2N2YUM1TjY5Y2ppSzRCR1p5dXNPVnM5cFpOa1lDSEM0a1FRZW9rQ21LUTBw?=
 =?utf-8?B?MjZ1NDNyWEpib1ZkK0dBWmtqcXBjaWlSaFp3UkVZMU1ucW5tQ0ptSEpYYXZm?=
 =?utf-8?B?dEhJT0tTempObUI4ZytJQXpoUzh1ZXJjT2ZKb3p5ZFlVTFJjT0xWekV5Mk95?=
 =?utf-8?B?bDVSblBLWTdQN0VFMTlOOU4vQldMYW1XMXIyRUhVNElhOGIray9wczhXVUtv?=
 =?utf-8?B?NUhkUWJJWDlVR0xjSHV6WHdjNndBd2FlOHJzRVhUejdPbXBZb3hMTE04dXZS?=
 =?utf-8?B?dmFyRnEzMHdpbzVlN1pudktMZFZlTlZya29nc2ZGSnpNaW1rMDNSL3VtZERk?=
 =?utf-8?B?cis5NVFtK3o4SHVQaS9GRHlFTEFsMERjWDFZazJwd1ZTY0R3dTNxYjdEZk9D?=
 =?utf-8?B?RW5YRXRLUEFocFErUzZiSjcwSk1kdWY4UWRPa3Z6U2NDSXBCaEJSZExmeG1F?=
 =?utf-8?B?a0FvdVBxZEc3SmJHSVFzazg5WHBYVDJGZmcycjVhUC9kazQxMGZ4L0kwdFlE?=
 =?utf-8?B?M3JXSjNlYzJ0ZkJSMk93bFFnbnlDQ256QXAxLy9aMDBHWjBiMlFicWJ4WVd0?=
 =?utf-8?B?OFpDQWluSWFjYUNOc0UzdXo4WXFXQlNkNzJpMFF2dWRiQ1RqRjRTcEIwbWNl?=
 =?utf-8?B?U2preGlLL1QrOVFVQVJ6aC80WlVEUFlGQ1VaeUZnZmlFbzBhMUtGWERIYTYz?=
 =?utf-8?B?VzlGVk53WjVWeWpXWFh0dVVhNDRBUTNLQ2svSmJYdHI3allPYzZ3Yk1Kb3pE?=
 =?utf-8?B?OHlGOEZCbmVSR0VmUytqNFJRL3dleUk0bjJBRHRHd29GaVRjcU9CL2FNY1lk?=
 =?utf-8?B?eGExQ1dVZ3FYS0dqQjJoeXhrOWkwVDU0ZnJYRFVEZ1V6cXc0MXM4MUdxNXVQ?=
 =?utf-8?Q?ZEUKRPItiR/7BxdoXcFpOswYqHenAH/ez8hXqhx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22548a05-b91b-4e3d-08e3-08d9210ede77
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 12:56:39.8006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWzGefocr9hEiDpT6BnP8Ej86YLVGvQp/0MyqQjR7YXe1/9Izi5wkc0yS6szjhqDOE/qrjjS0WMntnnczh6/Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/27/21 7:23 AM, Borislav Petkov wrote:
> On Thu, May 27, 2021 at 07:12:00AM -0500, Brijesh Singh wrote:
>> Let me know if you still think that snp_prep_memory() helper is required.
> Yes, I still do think that because you can put the comment and all
> the manupulation of parameters in there and have a single oneliner in
> probe_roms.c:
>
> 	snp_prep_memory(...);
>
> and have the details in sev.c where they belong.

Okay, I will add the helper.

