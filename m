Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1B231719B
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 21:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhBJUpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 15:45:23 -0500
Received: from mail-eopbgr760082.outbound.protection.outlook.com ([40.107.76.82]:47441
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233393AbhBJUpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 15:45:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEkPfNmlpZvUlS34JN+KU5OpSol6H+/yAIPfRSXViyC5UuExYQ4V+mZT1mUgUdyz5U3vHd5dpspGk+gZ7Routwzg2HfxkCtarpXDBwZ6QJYytTDopwDlSlofX1yWfBo0VzgJriCK+jkdIYb0cHFmb628OgJD9tiddo5TsYgeaDoPvkryY+mtB9lvkltFfCgH7W1Qil0krYaKBcc2lTH1iGas5sfHAE8rYrMAtwtW4lm1LVLpCQEcQWkmFqDYcSjTCYHT3TneBOpOMHj+/LMG5yZ6d2Ce+H2gcqeqpGOc6VpEWZk2IlLp1VI/6Yw14G/pvRKxxpcv7RJWgvcYKu2acw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKO5C91y/F5hj36vabBJxQxLGL8y1JzDarwctSrIAMc=;
 b=k4bVE/6veysLIF2GKd8gcnZiqsMud34WthyoE2cXmzBwXzUpeUGyjG16qs2oQCTwjLWKymnfp+6IHS/ayVveXFJkQ39n35ojPQU/2YD5a9Cxd9bFRwDlcit8MmnjgesaO4g8UJqnLf3ov+4fs9KCN0goEZt9Xy6+lbpI121LAjmcr6S127QYAWf/Tz+P8dPIAdGKoNCDkpPU/D4aoPIhNdiw/h7YLWk0YHk/0oogPA8cvlswVguWtP4KPtkhrBPbHSPu4U6Kl0V033COpN/p9YbQ+YRvp0czBshTm7avKAXgsF2QywBziK7Gc9RoWODPHTOWYFAN88P5oqvNZr6iCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKO5C91y/F5hj36vabBJxQxLGL8y1JzDarwctSrIAMc=;
 b=fpcC1Yi3zNp2FPgGYQzhSz17Ye7OqGcdpk65bODK/JeqvWSfR6CFNZuen0c2DpdAQpPqpN/6z7G4Y3M9/NHq+iYCZ/OwK0weW/C6nTi2LfmbWA1AFA/WruPyiJua9vg1MjLat79xfxg+MRhVitKJicTQPG163k/XyUtSTQ+MxcE=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1707.namprd12.prod.outlook.com (2603:10b6:3:108::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.27; Wed, 10 Feb 2021 20:44:18 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 20:44:18 +0000
Subject: Re: [PATCH 6/7] x86/boot/compressed/64: Check SEV encryption in
 32-bit boot-path
To:     Dave Hansen <dave.hansen@intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20210210102135.30667-1-joro@8bytes.org>
 <20210210102135.30667-7-joro@8bytes.org>
 <f0c80c25-13f6-34c9-1932-c57e0c900c75@intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <cdf7d5b9-a574-9f94-277b-083fc0f21e12@amd.com>
Date:   Wed, 10 Feb 2021 14:44:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <f0c80c25-13f6-34c9-1932-c57e0c900c75@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:805:66::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR08CA0019.namprd08.prod.outlook.com (2603:10b6:805:66::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Wed, 10 Feb 2021 20:44:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3b4f07b6-9d2a-4f19-2488-08d8ce04a2d2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1707:
X-Microsoft-Antispam-PRVS: <DM5PR12MB17078BB88F7D038A559A6692EC8D9@DM5PR12MB1707.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RTS1JsIwV7Tw5IlG52nnaJNrZNLRo20h/TFaarkqod9Z+sI1KuiVZy1HcB7mxZqaydfF6/YyPyu+JxWSWnNtCQa7/YpBHpaRfSP+C/pBbOqRjyptaHO/2+iLCeTtnZapfTHOF3Bf0oJI0mOfs9GzVIzbP1nosamorMI5TYOw1wrQHGEbfcnpSHFvICaPx/myQqqJ6CSrxg5rbEQ/QlEjTPCKUt9VOe6Low2fGR0za+K1GLLCpxLKh+GcHterFuuYMGdvXZ7J/22EbobnYqlnI0MOHv8YPBhNBTqlrGY5dzvdZwCgSJ08TcskhO+aVigQssYMz/SXh2iROTfVBETL5fnL6Gsoyrlvn6MAzRNzKKXR/Cxn1T7AsICAXEieVbPWSYJg0n0JcKNX7P8sVPhIPVnOsJXhDJvC7P+s1IPSuQ083Bm4NpCsJ6gWQarV1BKGNhQeabcHbEqOxF2Q1i1dJTtKhbkU18p5dxQPNhTmF/q4sE+a1KorR/cRcV981Ar5NrvMl9LpdIisw8FsNZq6+4QC0PY4ByRTmp+bO0FJO2HWgLJq7yejoRCrL85mms9vf6Ihu4dZ0QVBMWe5PdCjypehKeucVKPEbSA39Ijh+xU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(6486002)(36756003)(31686004)(53546011)(52116002)(478600001)(4326008)(54906003)(316002)(110136005)(6512007)(8676002)(5660300002)(2616005)(956004)(26005)(7416002)(86362001)(186003)(16526019)(31696002)(8936002)(83380400001)(66946007)(66556008)(66476007)(2906002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UVUvOHJweFRweVVnU2tVc0RUQ2NPa3lJS0toRHpyZ1BvT0k5eG5EWGpLeGN5?=
 =?utf-8?B?dHdqYzdmWFJuTGo3bkNzaWVyNTQ0bTNRRlJMaXBtUzVXdmRSbUk2Y3ZLejRH?=
 =?utf-8?B?YmlNS2VZa3BVbGMyTTRzL3VDVlgvWVdXVzhYYzdMbDZQK3pyeU5wZ2U5SURz?=
 =?utf-8?B?TkFZVThTT29rYnBYQ2t4L2JheGhRbUZLZUQwZDlYbWsxZzNMVmRmL01KNWZV?=
 =?utf-8?B?YkJqMUxJaWxiSGdXNTZ6MFA2VnY4ZGNFbURKUDVKK3BNVTVmSmZMcGo0K2VM?=
 =?utf-8?B?Vkw4dFNaOXBvYTI3Wmd5Q2QzQ0FpMHM5bmN5NmtPbExveUx0Nkl4SnVORmJF?=
 =?utf-8?B?d21uQk1XOThSU3JINXVZNjF3a1g3cHljRGhzT1FMMTlBeTAycEs4Z3dZSW40?=
 =?utf-8?B?aGx4ejhza29Na2xxblREMmM5a0c3WFQ5RUo4KzNpMWoxQnpsem5lRVFZbmNm?=
 =?utf-8?B?RUI1NFlzaHZJRVg4WG83akdxOVJIekI2NEhrRy9rcW4wQjVBU0xoL2VLRlZY?=
 =?utf-8?B?eXJxa3cybFhCUEw4Q1p6eEhoamZGTG9qM2l5bGtDTDJ6UG9aY1dFUlJRRnRB?=
 =?utf-8?B?T2Z6YWhsNmhJZ1ViNDR2bjN3dWJwL2NqZE9wSSs5bXNoSHNjQlk1SWRhQTJ2?=
 =?utf-8?B?RThaV2s0N3ZyY0xvb0RNZUpRTko4VFFjcWZDSXFCalY2RVdNcHptWlZ0bGl4?=
 =?utf-8?B?dXQ0RFJVSnc2R3Fka0JpTVlkalJ3cVk1U2dDa3pFcUo0SGQ4Z0tNNUh5RC93?=
 =?utf-8?B?WWFuNnFpam4veWNCYmJqU1JESzVQWmxvNWJFdkRJTkhHRWw5VFY1M2QzTjRh?=
 =?utf-8?B?ekRLTWVYQ0FxQlB1MXlQS1RMcVE5c3dXUUpVcHhvUDlMS1lmOXlHeE1qc25v?=
 =?utf-8?B?bEVTMlNYNDgwMXFwc3hiOGJHOTlDUVB5bGRKREY0ZlRRQkR1bnFyQytQWTc5?=
 =?utf-8?B?WnRyMjhxcGJ3K244dDZadzNjRkFrc0s1OVhJb0VpREo2RnhibHJ2VTZrYnFL?=
 =?utf-8?B?TEhHRERDd05BWlNYNEtsN2c5SStTdGdFdGZ3WFdiUjZyTTJCd3BDWFVYQytr?=
 =?utf-8?B?K2tUTDhLc2FPQTlaQTg0OFNCSDY3Ym1ta3V3WnMydUJkRXdyMm10Ti9FU2x4?=
 =?utf-8?B?MCtaMVlYdU44UUprT25NZEpqbjZYeGRMVml6YkMyVS9TYkxWRzRaOXUybWN0?=
 =?utf-8?B?S1ZuOXVLMjF5Q0JIWmpMa0VYdTUxR2JEeGxiY2F4QmFmTDBVck9xaTJORVh4?=
 =?utf-8?B?clcxcHFwT3JVNkI2NktBZlVadFBlQkJTVkdhM3ZZNGZlK1FzNHduT2xNb2x2?=
 =?utf-8?B?TTVQazIyd25XMENUVlM1aUZkeUttNzkyc0tFUkN3a3ZMZHZUVkRudFQ0Zmsv?=
 =?utf-8?B?VUtpaUVTWFk5UmFzQnhacmVrVXJ2ZkQ5SFNXamZib2hlNWxvd2ttV3ZpWHRB?=
 =?utf-8?B?WGRSTHJuQkorUklIV0JUbmVkemxmb2RkL2JGSlBBL1gzRXk1MEV3SDNERTFT?=
 =?utf-8?B?N05TT3k2NitaRi9xRm1zOUMvL3QrbDN2eXRLSFdhOU93T0VOSmdwSmZUdlE1?=
 =?utf-8?B?VVNIOFU3SWpBYWNmZk1hSEdLZFBrZHozRFdZdWJmcGVjM1p0TGlsNTdWYTZo?=
 =?utf-8?B?K2JPd205bzlIMW1GNk5OOXR5VlhNbG51QVpzcm16Tzd6YlQyOThSNDZ2b2Nt?=
 =?utf-8?B?VWErS2doZmhJWHNQa0lvbVAxWTl5Zmd5aDJvdExqVlN1ZVdGVmw5ZUxIMGJV?=
 =?utf-8?Q?QsaZtR3N6UFqsIKldmIAbQAwOyLZivC2yaA/RZF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4f07b6-9d2a-4f19-2488-08d8ce04a2d2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 20:44:18.2605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9oniiVWUZxDfdsASvJF63Io9fmWD+xZcnr6cWlXqwfV2dtZfRx+sSXkHUBxTp9C5F4MEASRhuQ06nzxcIFdrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1707
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/21 10:47 AM, Dave Hansen wrote:
> On 2/10/21 2:21 AM, Joerg Roedel wrote:
>> +	/* Store to memory and keep it in the registers */
>> +	movl	%eax, rva(sev_check_data)(%ebp)
>> +	movl	%ebx, rva(sev_check_data+4)(%ebp)
>> +
>> +	/* Enable paging to see if encryption is active */
>> +	movl	%cr0, %edx	/* Backup %cr0 in %edx */
>> +	movl	$(X86_CR0_PG | X86_CR0_PE), %ecx /* Enable Paging and Protected mode */
>> +	movl	%ecx, %cr0
>> +
>> +	cmpl	%eax, rva(sev_check_data)(%ebp)
>> +	jne	3f
>> +	cmpl	%ebx, rva(sev_check_data+4)(%ebp)
>> +	jne	3f
> 
> Also, I know that turning paging on is a *BIG* barrier.  But, I didn't
> think it has any effect on the caches.
> 
> I would expect that the underlying physical address of 'sev_check_data'
> would change when paging gets enabled because paging sets the C bit.
> So, how does the write of 'sev_check_data' get out of the caches and
> into memory where it can be read back with the new physical address?
> 
> I think there's some bit of the SEV architecture that I'm missing.

Non-paging memory accesses are always considered private (APM Volume 2, 
15.34.4) and thus are cached with the C bit set.

Thanks,
Tom

> 
