Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A98479553
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 21:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbhLQUQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 15:16:01 -0500
Received: from mail-mw2nam12on2048.outbound.protection.outlook.com ([40.107.244.48]:49185
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230126AbhLQUQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 15:16:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/P1va9LfrKNXlSRSwLic23mZ4mYJkSY33VJZGJHGHcRTQkQClh2gfdcB0Ha3PvCL9aLxxoGT/7GALORlW2hUHlD+VogM0bA+JZY07B1VXVs2lEFqBfPwhMXVyLFuLDJqZHrx+r+PCbCDjaFBryQtg8Bx2BpsO2cWD2/GMg3Mcl+nTZxmlyX/j+FwdQUmc/3zeyfj+d0GCl6lCwAi0Dq0mje7NBj5nPVM6FJePHEqT36gE/LS4tfb/kxC0aqhKzU/nFsYzdUBMRfOK9bSUtOM/gR7By20F24CxZ5H7HUUwFiNdxxb5m/3eavVbPFc65id0MJsgmGEtBL7SPTcWljEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVIqEJWWZO+ezR53nWVdFdjhwL3Tdfcgb8VdRaRmoQM=;
 b=PYZ7CrBzzj7tKSgiT7xOBIKzgSUL5X3v9mQA+FFzulrtbIGSHsgSBjlwYIENriulD9DN0q3eAee6ilOpgZbrWcjM33fdBpgIjrFTBS3koT1I/MDCq+cM5fHtjxDGZA4GHc4V1jZdH0GowyNijXzqijNm58peHOphQreTCR8yyEIPR3DU7qdaqW2AaU5mrPMR+4qiBdJl7Zzq4jL+c6wJgt6hSfRp1N7nmB03Ti+4UeqMgpZioPau6k5sblSgOCFl39PXbUJwEpv7TuJ8SD5EQ4VscrJtX62eYIjB+Qog/hiBOP3Ezu4xr/pX9bK4MjNAjbsAkSyaHotk6Lb9Ed27cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVIqEJWWZO+ezR53nWVdFdjhwL3Tdfcgb8VdRaRmoQM=;
 b=hqESUPrE8wiTViBS6RI82bAEMHFmfbGx2qzawjoJzlIpQWjCBAVpDWugg8JIPjVAa20Zd0c0jrrjHzIY5in0y8bUvwa6geYulAR8dBFSVEKYWivYzeA7u+sMbC3I6q+4qIp9c/e46BcBiAKHLT+4bUW8zoIBp19Zm8hNoyMpnzU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5325.namprd12.prod.outlook.com (2603:10b6:5:39e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Fri, 17 Dec
 2021 20:15:58 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 17 Dec 2021
 20:15:58 +0000
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
 <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org>
 <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com>
 <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org>
 <1401c5a1-c8a2-cca1-e548-cab143f59d8f@amd.com>
 <2bfb13ed5d565ab09bd794f69a6ef2b1b75e507a.camel@infradead.org>
 <62714ae555a42dfccc992925691c44024d7d0e3a.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6196d884-f8be-56d8-e424-ba6c7ad4dc37@amd.com>
Date:   Fri, 17 Dec 2021 14:15:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <62714ae555a42dfccc992925691c44024d7d0e3a.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0087.namprd13.prod.outlook.com
 (2603:10b6:806:23::32) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR13CA0087.namprd13.prod.outlook.com (2603:10b6:806:23::32) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 17 Dec 2021 20:15:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dc24202-2e78-4b2b-1541-08d9c19a09ee
X-MS-TrafficTypeDiagnostic: DM4PR12MB5325:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB532516533CF0842EAD907548EC789@DM4PR12MB5325.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vXr67UWU19UiwABSfq6Z8lrxzjCVXQZLc95mR1SPV0Wvdk4dKgZD7MEKbrEmk465v6Y+J1A4ecIAzh7qF5CqZQEDUiLb6U5AenDi44gQnzwzOozpM/tuq72KoYn+eObkiMceqicyspOq9e1qbnYV2dn8X0DFhOvOhCTM2Bn1ZopwO9Syiy2XIgs9dRLhdkJJvsdLtpNu61/Bys7KTrIH1OdF3ir9kZOCohj8pCb3XdmgZ7GCef946d80Ayo/uOEPX7Bf9c0HxZvRqud6h5+kux0HEQEH6F0GxD0r8tRHOahkzjN0nCf+seZOAO2Ex+kDhr5cQ5F5v9C8w0TiPReE1wcY7KeEFDtmY9iJZaXFf7OxMya0z0OcXv00EXQ0Ac48sx2durmhOVQONv+7KFMoWT49C5/tOVYhnmBsoP7XJKj6U7MEzdeMvMd/qtU3aSbSiXwilRas3d7p7FxWVU91Aj3IbUtMv3yX8vKGrupxQokPsiTtFC/gyKdo/2LP5CcA4d9IVv7q/NVhY+ZpO/GCwJQJEzS8HIedbDT/Vjmdf8yadL6wi3U4Xu2Rkss0+iReAQePBa3CnFZdpxXwzHxhdZnMh30jVplJr3GhhM/bAlhwxjps/6tB0+rYG9+WFOPokc+olobQee8zwpFOAl9n563UlBa2zF4PW7Gv/kCj3iKxih0rKwdTP5sKc6mta+AyNrfXhQd07qROF53Tfx4ht8ablEWBCHK9OdcewNYdS85r1QT8pjJXWcDlQVbvLkD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(186003)(26005)(86362001)(38100700002)(508600001)(66476007)(31696002)(2906002)(53546011)(316002)(6506007)(66556008)(66946007)(4326008)(110136005)(8676002)(54906003)(6486002)(6512007)(7416002)(4001150100001)(5660300002)(4744005)(36756003)(2616005)(8936002)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWFJN2Z0VzZCKzRuZEJMd2tSamtGdTRJWW1ueDE3cDhmeThvQkhhUldjNC9B?=
 =?utf-8?B?L3ljUm1OME5qZ3BJUFZ2V1VsK2NQK3Nuei9ta3cwelF6Yk1hTExrT0NZTHNK?=
 =?utf-8?B?UmJ6ZEJ5QVpHeWlOT25hR0dnZjIzbjFOcEtFRlZBM29zRWorWUtVbkM0Z1Zl?=
 =?utf-8?B?THVyTzFwZ1RObUNXcnBGaGNuQzdqSitQM1hHTGJLYmJGenEvL2lsYXkvaEZm?=
 =?utf-8?B?QXJOWll4NGNuMHlxYVJzVnF0TUw3VDg2UjdSRXNvaXVLWDdEaEVMdjdtZW5Y?=
 =?utf-8?B?SU45ZlNFVjV2dHFxTXpOMXhZQmtZQ2xYY09FLzI5aVgwY2JOMzRERjUvVTd3?=
 =?utf-8?B?SnVmRjBBd0pKZnlTWmg1K3hpbnNPaDhmOWtJR3ZyZU1WYmRCNW5QYXBvbEIw?=
 =?utf-8?B?SHM3cy81TmNpWjhQY1dXeC9SRGJPUGNzazhqcnpMbi9SUjN0L2xDVXVmVWho?=
 =?utf-8?B?Z3VodUwvY1ZjTG5WbTlaeDRZak5jQnFHUTk0MUluc2JJWEcyZ0dDbEpYVlMr?=
 =?utf-8?B?MGRyaXhHYUYyQ1plME5NemhSOFh5Nnd2dFJ6UFJiVC9XcWRiSW5BU251UFZN?=
 =?utf-8?B?NG5ySGFYZ2k0R2NOSlhSdHV3UkdSRmVHRUFFKzB3SUtFUHg1eVV1WExFTVFs?=
 =?utf-8?B?NjF0NFh2Z0NqckFjNmdJa1UzNTlyMi9aR1Fza0tEM0lxV0YrazRtc1RrQ0FY?=
 =?utf-8?B?eVZqR0pzdkV0YzRIakJ5SlVIU055VlhXOEMyNHNqSmFLUHp4SEdUcWlld21H?=
 =?utf-8?B?bzlDSnhIYUxOeDZqR0xxcGM2SkNwVFJBbUY3NTlFbk1kNGZEcDhVWGI0S2Ja?=
 =?utf-8?B?VzV4L21TRFgrWWpnbVB4dFRkcnVnM3B1NzZzZVdENEJlRHJxbEZVY3FnQ2Rh?=
 =?utf-8?B?U2lRTWwwMFZLaU1DeVgrUFozMVFZM1MxbUhmcDZmTzNqT3VVY215Tlo0bEVS?=
 =?utf-8?B?VXZqWjZucDVpUzhhV2JGb0Uzd2RtY2ZPRUdiTHFSSThzUkRWV0l0M0FnMkJI?=
 =?utf-8?B?bWVWUlZTTnBaR1VjN2NZZ2pDdU1HdjkyWUtoRjRnK2twbXgvbysxREFkWXds?=
 =?utf-8?B?OTVuYTBYYXJKNlBrS0pBRmxLL25wQkp0cm03Ym5yN1lrZzBpK2lacm00Q0ph?=
 =?utf-8?B?U0VKazZXWGpXMTl1VDcyUDZFaXVoTnpZWjlQOWZpSnV1SXE1OStaNUF1OVJv?=
 =?utf-8?B?L0taUFp1N1VhZXdoWm0xM2pjdkxOdml4SitZeHJRb09DN0hTY1NJZXZTYWUw?=
 =?utf-8?B?MkJZMUJDcUZDQnVrMXh4aHZWVC9jb2FBdlREYUt4RGxmejBWY1ZGMVluV08v?=
 =?utf-8?B?SUpmS1o1QVg3eDZHK2FZanhRc2tqRzZMTnRsZVFxMm04ZDJhMmdoZEV4NzRk?=
 =?utf-8?B?WVBJdjFVbDVXVXdOYUJBRU1EZTVnVElXU3I3RHg4aE9MbUM5c2RnTE9LMjU4?=
 =?utf-8?B?clBHRW5PS1FITElEY3F2U1VseDV2WFN3QTZSejhHTUFXYllEeWpZWmM5MEdM?=
 =?utf-8?B?aG5NSXNrR1hFMmZBZnlEZ2UyTXRjU2pTYWpnR0dZSmhCcm9YSHZNcWI0TXBE?=
 =?utf-8?B?SGJyRS8wengyUjFxL3FRb1p0eXhyTVAxOUFGRC96aWtaVU1RMExOQTd0NjdF?=
 =?utf-8?B?ZTNJM2hsWXZVU2p0bWMwVlpSZWFLS3pXR05qdlJsQ21KaXhLREVKbXVVU2dK?=
 =?utf-8?B?WUJNSFRYRTcrdlcvQ3dNNk9KMHgreUFvK0RsZ0Y3NmRpYWV1ai9Pd0dtanZW?=
 =?utf-8?B?ZS9PZzlCWUN1RFdJcVJuMDF6ckRTZVhOL1JHRFZvZlpSQ1BFQ2J2ZTFHWWlO?=
 =?utf-8?B?TUZBRUZYMmZ0eFlyNzY5WnZhdWc0Y0hMNncwSjNxTkdRUEJiOERYSkZaS3RK?=
 =?utf-8?B?cU9nWUMvUjZXRFVXRWJ3aWo5T2p2bFlIRTFFcVUwQnlEcXJvNHMrb3BKNjZL?=
 =?utf-8?B?SWdiakVQeGFDckxnNElhR002dkxwMXUxUkduNG5oWGJJZ0JCVWx0czg4YXBH?=
 =?utf-8?B?Z0I5OVNpZXZoUkJSRk5ZejNmYU9BSlJIM1R0bjhadndoRmVnbTROUi93WTQ2?=
 =?utf-8?B?Qis1Z1lNUUtqRVVHTHVvQ2owRWcreDk1b05LRC96MkRWRTQrMXkzU1EvVWRk?=
 =?utf-8?B?c1lLdTc4Z3cveEozYWJ5ZVB2emVDVkhueFljemxZc0RaUjM1SC9kS01Pcnox?=
 =?utf-8?Q?OMDrfQt/UZ6KlV/Sdib7weU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc24202-2e78-4b2b-1541-08d9c19a09ee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 20:15:58.6562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f3ZUCp50BTIAVkbfcDz/jt2CAxI42Ow/sZUNZQ+oxEJOWeegxwyl+HwqdzsJqEeh0meQH3rnNWIucWDLS05m/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5325
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 1:26 PM, David Woodhouse wrote:
> On Fri, 2021-12-17 at 19:11 +0000, David Woodhouse wrote:
>> I note that one is in native_write_msr() though. I wonder what it's
>> writing?
> 
> CPU Reset (CPU 0)
> RAX=0000000000000000 RBX=0000000000000202 RCX=0000000000000828 RDX=0000000000000000
> RSI=0000000000000000 RDI=0000000000000828 RBP=0000000000000000 RSP=ffffc90000023ce0
> R8 =0000000000000000 R9 =ffffc90000023b60 R10=0000000000000001 R11=0000000000000001
> R12=000000000000069a R13=0000000000000005 R14=000000000000001c R15=0000000000000001
> RIP=ffffffff810705c6 RFL=00000206 [-----P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> 
> It's writing zero (%rax/%rsi) to MSR 0x828 (%rcx/%rdi) which is the
> X2APIC's APIC_ESR.
> 
> Can you reproduce this without the guest being in X2APIC mode? You'll
> have to cut it back to only 254 vCPUs for that test.

Yes, reproducible with guest in xAPIC mode.

Thanks,
Tom

> 
