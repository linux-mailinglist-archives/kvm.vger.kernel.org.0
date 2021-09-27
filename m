Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BB141982B
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbhI0Psp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:48:45 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:13270
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235205AbhI0Pso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:48:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFPjeJZoCkG6sMnj9clG7fidAGIxyL/YdwNwgTJXDFPiN1cEaDcY6RDZARvlyyH2pi6sidSvfmejaPm1ZQV5GwRBPYwHV2ssbxtoBnuMgud0kJeFmeEndKm3/HV9otNp6rmNLOp5k6ubCm5EGH5olkbLUoF1+gwUC60NXCGfrhNUubUEM//whJM3gT9+hx+9TjnZjJRFSGmClpJmlDlTDhTf3wRYgYqH5MunQWzNQaSB8AEcRYPWigSEtl0bOrrILAXVwowx7enCxFIPsRH3YWSGvrhOxL213H6C7QK03AeM6hDzMcrV6ycWWMjPjeqp4Up+UjT8sP07poqw6NK0Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kl3Tiu/6yO5gbZAC1h3VmzmgLNDVpYlGPXzf2ncxTuk=;
 b=VMw/lRRy6gKtUibE/yn/AWUYB3rwVMg7q7uPJQYBjYcng6bY0Xm3YA2HtNem8+VXnEWlMAnvxghsbK2sJHWdlAFWNSDyu2Zs6EUfXc8pqBJ9dmQFGJSNH9nvrWgo3oUSNJH7xsi3Wb41N/R/DgDvY88ixRXcHme2HtSR7XczYZV+Biwt+TXO5QtXv2GRMmycbsRvmGZTLXIGSRGJpTpEXkOVU66mNprFmxESzClsdCf8obHh49OXpf2ALmEou8SCZ5il0i9DYVkWdIc4f1KPQnzaD+50Jd0yM4RQ/m6dnZwBTZ5ToqfPWPtcZ7OzVncRu8jZxIIgNhcsKUo6SHGNbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl3Tiu/6yO5gbZAC1h3VmzmgLNDVpYlGPXzf2ncxTuk=;
 b=wyz9X3p9bW7xEG/STEHM46dP9PEv/cG84AmKK5qWBmJfUDCx2V8XXqVy+7WDtvqU80qmVCXXw+MHQ67CMHVbEpYLmZxyyjFCZu6fb5Y5DYnZO/cyUnEcIMfCd0/N17kMpzIY4lTdqRg5rXk7Hi8A6PM8kPkHHRCmPMfpkrg0+Xw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR1201MB2526.namprd12.prod.outlook.com (2603:10b6:300:ec::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Mon, 27 Sep
 2021 15:47:04 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::41ef:d712:79a2:30c1]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::41ef:d712:79a2:30c1%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 15:47:04 +0000
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
To:     Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <YVGkDPbQmdwSw6Ff@zn.tnic> <fcbbdf83-128a-2519-13e8-1c5d5735a0d2@redhat.com>
 <YVGz0HXe+WNAXfdF@zn.tnic> <bcd40d94-2634-a40c-0173-64063051a4b2@redhat.com>
 <YVG46L++WPBAHxQv@zn.tnic> <afc34b38-5596-3571-63e5-55fe82e87f6c@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <14993859-b953-b833-cdf2-ff2e29e9044d@amd.com>
Date:   Mon, 27 Sep 2021 10:47:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <afc34b38-5596-3571-63e5-55fe82e87f6c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::25) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
Received: from [10.236.30.47] (165.204.77.1) by SA9P221CA0020.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Mon, 27 Sep 2021 15:47:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c108b940-f9fb-497e-8fda-08d981ce0d6c
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1201MB25266F4BA3608DAC07535C3795A79@MWHPR1201MB2526.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/bH/yVFEfGBUL+q1kHa8h8yMdAYd1qw5MzZLJPDEnqFjC+qKVHyC2LPMDfOSjDUNFREIhpe7vI3JHxHIyHlpbmZDDFgoOkttI5ldR5fPVlk+hWFDH31v37c5OeAwoCdCOe/YREcLaJZ9ClKQiSpHybQqy77lcWFY5ra9yclCtoDnykdcY0sQrWYGSB9bktEZU/NT0Z4fTeEi5AK+eRdQbD0SnLyvG9EXbHwu6uwsYWI3iNQRSIqpyTzBxtbqNPO1fSKcptxLZy/p8ibtVQxFIfBYgwswOIbbSrQoMiBN8FK6X2leMPWUmmNYgrSpLlZjY+joX9AUj1lRiQL3lTaycmj2TGM0ABDCui6tAJTUMM6RBx++4JRMwsHWCx+U+bQf/PEGO/+ouktX45wA/z0KDRbf6LMjaUJON2nJDNxVluWJAyAATPdNfRZG2QgXIw5817szzzx0lSo+d535YiZdh9lJr7UCbc6V7koBDoLHYOvG/rK7VmFpQROitoPV/cjpxb/7f0yWskLKQPe7bRYpM83kkenljY3P3CeORK5BBXfjQPlinN5foq2GgpmZdDT1VdPh1ea11fy+gZqxPPs74Cd+eQe+fJPLU5EVe8mPp/FwuWgJ4AQCikLW+A4WYWn4QKdK2j7b7c99c4727+Eet3ciSysHKs1xmRgdh8BrmAoBJA+8jFqfQKwp4wjDyAH6+ntJ+uI2YUiT2sLcN+uZEFDubbDkhx0S1bpMAXhIRQzuAlxNN68gk/NfccQdj1paol4shr8lt7LXuoQ7QvYXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(66476007)(66556008)(4326008)(2616005)(8936002)(8676002)(508600001)(6486002)(186003)(38350700002)(66946007)(26005)(7416002)(44832011)(16576012)(86362001)(36756003)(956004)(2906002)(52116002)(5660300002)(316002)(53546011)(31686004)(110136005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkhQQTl1ejVGWVhMbGFtT2FsRGJzbSswZGt3anJMQmI3NWJjNzkySHlPR3Nx?=
 =?utf-8?B?NmgzT2ZiSGhybWcwRXE1UGVxTmg0UUhHTlJCUzlGc2g1aUw0WFRxN2JGVGJw?=
 =?utf-8?B?S1Vra3pidml5OHhxZHlWNG5zN2ZPejl3a3RkYmwxdTlrN09iUUo4YkhyZHJP?=
 =?utf-8?B?SnpIZHlCMndVbk90Nk13VVZoTGs5ajZrekJORXNGNUMweFVZWWV5TG4yQVlL?=
 =?utf-8?B?SDREUGxub0srWVNtc2JxbFVUbXFlQ0syWjFUbENzaDRjZlZuS3czRytMK2Vs?=
 =?utf-8?B?SDRxWUlvQy9RTlpTOEsvUDIvUXM5RmY0WkM2Nm9IeHJPUGJTczJvTlVuWFZQ?=
 =?utf-8?B?MmZmWnVyZm1sOGRVZ3VmOUJJbFBUK0VoNkhFQWRPSHRpMXFjSU8xaXZFeFk2?=
 =?utf-8?B?N3NjYTR5SUk5REw3aTdwWXAvYUNIY2xDN0VpZjhFeWRpUnkrd0ZXYkZ5K25O?=
 =?utf-8?B?RlJIVlNqY0ZzYnFZNXhDWTJnZFhoL2dxQStFUE1HU0dZRkI4b0ltVzNZSU1W?=
 =?utf-8?B?YXN1dXNta3plUDhHang4aTZGeTU4K2wvV0RCUk1aSUYwYWFzREpqLy9NQm52?=
 =?utf-8?B?WWZwVE45WXJ2QmRZWmpmMEpmQld0NFB5UXlsc053bzBUUnNBKzBSTTZ5dVVM?=
 =?utf-8?B?dkZ4WTdyQmZjNWl3MkNPb1BiN3lXRjlxOVpCcFRYTkFVeHp5NEZ1QjBUZVlI?=
 =?utf-8?B?WHloKzIxQlFLQktFVmJ1cUVtUGNWb2h4QTBjM0ExMklia0t4YTVUcTRyeHRB?=
 =?utf-8?B?V3dMZEpsbDJLNURmWW1McW44RmMwWGJoeHl1cnNCVjdhaDVhWDlKY081SVVt?=
 =?utf-8?B?bUh2TEE1MmRjVDNDREFSeTQ0Vk0rOVFNaS9JRUNiZFQ2VHVqZmlZTTlycG9y?=
 =?utf-8?B?U1BzR1liZ3NzZWlxVmp2SEFzVmVUMkZ3cFZiYldMWGZDdmw2S0hLenZ1SXBC?=
 =?utf-8?B?MDF5eVdrK3Q0U01Fa002SkgxbVN6aklDVXljeFo0UU9vWEUzOFM2blFuODd0?=
 =?utf-8?B?OEpHcFduRjJheG1pWGxoL1ZtNHFra242R09oM1BVL0loVlRxdEN6TmFYNUFF?=
 =?utf-8?B?eks4bjhvbnNRMWoxbmVEdm15dUI2dVM3ZkpKaGZkOS9jMytQa2lhTUlFSHE4?=
 =?utf-8?B?RWNEd0FIRHdTeUJyU3dteUY0dUZadTBqay9VS1RvZTY5TjdtdWRNWGtDZHFB?=
 =?utf-8?B?dlNpbkc0NTBFcTdXQWhocy9zYmN4SHkyNDN2b1pvYk9rVXRoK3NRbWw4RUNQ?=
 =?utf-8?B?QWZyR3dLMkJ5UUFuMjhvWXJnd2IyVUpsczZtb1RGNUxGS3BXVktXa2VPNEV6?=
 =?utf-8?B?OFRoZy9XNG8wS0cwdXNtNmpEOERsbVpuYStVb3dPOHQrSk41dVJSSEpyUmNw?=
 =?utf-8?B?dHUyZUE2Q00vakFXSnQyU1NsVVNqNjRzNjNMb1Z1WVBXbmxFNFFacWhvdjZK?=
 =?utf-8?B?WlByN2lKT01wOUZTSU1ybE9aSTd4QnBPUUVBdmhmMTA1aHd1UFhURUFESjZk?=
 =?utf-8?B?OU5XaENiTTZTTit1YkdCQmhvMlIzZmNmVjJ0THlmcWpkbFp0aWV1RmZGRDUr?=
 =?utf-8?B?eERNclhaTFlKY050WVB6YmllcXRjVXdhU3QrMmkzb2JXTUgvNkpRSkp0MUtn?=
 =?utf-8?B?SnhIY2liY29lMDJEa29IQWJLcVJyMEFUSEEvaEprellvUmljS3ZuK0EzckNZ?=
 =?utf-8?B?KzBZZE1hK1ViRkw4d2IxbStEMXgxSnRjSnRDL3Vyek05TWY2b05tZzhWNGxR?=
 =?utf-8?Q?702h0YrjQLLv+xVbsh8CQKj5siMxD4lwfzx4sBb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c108b940-f9fb-497e-8fda-08d981ce0d6c
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 15:47:04.0231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDic3f8MAuRuCj1BdOgowaKro8yspq2achh9AnrAAWQcodZBkKiFUSK7buH/VSVo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2526
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/27/21 7:54 AM, Paolo Bonzini wrote:
> On 27/09/21 14:28, Borislav Petkov wrote:
>> On Mon, Sep 27, 2021 at 02:14:52PM +0200, Paolo Bonzini wrote:
>>> Right, not which MSR to write but which value to write.  It doesn't know
>>> that the PSF disable bit is valid unless the corresponding CPUID bit is
>>> set.
>>
>> There's no need for the separate PSF CPUID bit yet. We have decided for
>> now to not control PSF separately but disable it through SSB. Please
>> follow this thread:
> 
> There are other guests than Linux.  This patch is just telling userspace

Yes, That is the reason for this patch.

> that KVM knows what the PSFD bit is.  It is also possible to expose the
> bit in KVM without having any #define in cpufeatures.h or without the
> kernel using it.  For example KVM had been exposing FSGSBASE long before
> Linux supported it.
> 
> That said, the patch is incomplete because it should also add the new
> CPUID bit to guest_has_spec_ctrl_msr (what KVM *really* cares about is not
> the individual bits, only whether SPEC_CTRL exists at all).

Yea, I missed that. Will add it in next revision,
Thanks
Babu
