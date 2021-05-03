Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16710371E4E
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhECRUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 13:20:33 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:18625
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231443AbhECRUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 13:20:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNemD94WNP4lT1gQ+sHqLE5em7gunsVQThrTCE6KZRikOYuSPitA/mWUpgoXB7RwR6bL40A6sfDdlL2pTvOh/HSMWvigWKN3z09RAnMZJZVLl/Rq5Ad0j3MePM7hriTwcFeJisKC+s2XglM89Amrn7FQq/IACnayrjLq0Rh9LGNXuXVT8KEoh2pXRWCvmV+rsejJaUIONM37FDaC9BmFoFK4cMDvvOP6AT8vdw/660/AjRVA0SS063LuR9qv5gVgO88moD1AUVLPXzGt39t1rIntqkqNgy58aUSy5e67vk/4WbyHlEflDTmM5fPcpxPg03eawJaPxxCH5sRJ/JV3Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82eX193VRTiV+7ONlmjYctGboTA3h6GmvlSaC5vw8zg=;
 b=mRBMM5ok0+L++MzBxSdHft5PkMwC2ylNH53uLFJUTdm2dQI0UEmWrM+WDlCrVUO7/f/Vw1MdLCi5DETBU3FP4if3ya7ZsRVu1LBMlw1hm5C18llvOPuoCUld2SnU8nDA73BgeN3bCaBtGSYffjUGuCj9mNyc3AjEslAm5/7S8PUhRhnx6m7aZy4zvQjbicfVE0j3dKN/6JEtB+slNICemifSLaKBZ567dU6p+wk9PpjskUrSOMQ1R8avkiYx99MfbFJgySvftx/aD4RxGiDNCAAq5lydy+vspqkuR1bjxwF903OdlvDIS41ih7qAHWjaB1k1kSRzY2pA4phX6KBG+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82eX193VRTiV+7ONlmjYctGboTA3h6GmvlSaC5vw8zg=;
 b=JsmSzZ5Vggw3w4ZwEMLU641fnORR/36YS/OJQp/IAQHiG02u3c8ci5QhQOrfSkeyoP1STSlsrTnbXMXa7XpHFabVWCNr5ScMs3yZcLRyMulgAdhpy5suZ70Gw5b6n3a5ptLp4nGb2+vOaaY2LqAt9VOGieAaJtAaDsZOH6n9H+g=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.44; Mon, 3 May
 2021 17:19:37 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 17:19:37 +0000
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, bp@alien8.de,
        jroedel@suse.de, thomas.lendacky@amd.com, pbonzini@redhat.com,
        mingo@redhat.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-11-brijesh.singh@amd.com>
 <c3950468-af35-a46d-2d50-238245ed37b3@intel.com>
 <d25db3c9-86ba-b72f-dab7-1dde49bc1229@amd.com>
 <8764e6f0-4a2e-4eea-af69-62ff3ddfe84b@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9e3e4331-2933-7ae6-31d9-5fb73fce4353@amd.com>
Date:   Mon, 3 May 2021 12:19:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <8764e6f0-4a2e-4eea-af69-62ff3ddfe84b@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0401CA0012.namprd04.prod.outlook.com
 (2603:10b6:803:21::22) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0401CA0012.namprd04.prod.outlook.com (2603:10b6:803:21::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Mon, 3 May 2021 17:19:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5d8b9c0-67e9-455c-ce34-08d90e57a0ae
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4751B241B052F6C4D2E5C05FE55B9@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0AQIDueIvbDJ+LQ16FLksof+jf34uyiry+w5B6I+/e0WluCr6p0K69ThWAS3WSS0swe60XtiGSfADuNjvyxAO+nvSvuQAvU7CLxNxv+h9f95qEfQi2u8s/aPlzXRRDAxBJEz/X3f+8T7smEEl5nJ/rJpxLKMGoeJzhftxYPw30AT3vraU4ptz/3PhUSX7EBoNsC+5BuPakaQCzfuiL0cXpwuRHURRSK2Vvo2if7/iLvKPDm0M+mlhoEY2BAZqr62wjYsdLMZKHpDKjmEYCW4KjlFbdkSgLp8VxlckBc/UVwPDJUvvx+mVnptL5hMUsDy71Rk1cBTAKmnnewJhscKFsMnmNZqfvTpCI54Iljn8vvOwlcS7i2TWh15MBQ6POL6PSHXfED0lih5CuruI+s8K67bp81ZVDY8KQLzBtvve19z1gbKp+KVZrQZNu6HbkVbrfs9AH+uB8NWTXiA3jr2j8MQjs2xo3qzmhrAph5nNiXr/OBKyRkjdMgD+tpA6q/WKs5I5c1j3yhb4ue0PFMT5nsb43+zAhYeMXHtUbmsSKnD8mGVoWAcEOMfKaKdhkTxB5DkjKus8w2mgGGRY6Q8G5h61uFAn6YfoJWWrEMJ4zmEBD2NoIlm6s2Z282B3YDESaAhkgGVc5/fPGuWZxcyMEBpdZjTaV2WN3S3IkOxvAIT/jh1i/aFdXY1Au65b5oPvEh6jZiYdATnXM6C3n9JrZmNOfgctFVtvGHxkpxz2OA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39850400004)(346002)(396003)(6486002)(66556008)(52116002)(66476007)(66946007)(8936002)(53546011)(8676002)(6512007)(36756003)(31686004)(6506007)(31696002)(38100700002)(86362001)(38350700002)(5660300002)(2616005)(83380400001)(956004)(7416002)(26005)(478600001)(2906002)(316002)(186003)(16526019)(44832011)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OE5EZVZHb2Y5NXg2SHRKdHMwTkZVYnRzODZOZkhVbXM2RXdaTFVrcVlSOFdz?=
 =?utf-8?B?ZXpYMkNtOEhpZE9LNFBpWU1ON3lMVG0rVE5QdzNSR1JqcXZQNWM4RGpLeHJW?=
 =?utf-8?B?WDI4OHhReGRBQkxPS3lGa2ZuT21sRitqWTFDOTViUXVnZ0tYY0RBQ0hqWVZo?=
 =?utf-8?B?ZFJJMWxReERPWUdxeW8rbW5QdXFhb2o4Ky9wMUt3ZVVnWXN4bkhXK3hBZDVw?=
 =?utf-8?B?Q1hvNlRLMWx6OWdkOW55OHlGSEVMTkNYSDBGaHlJV3QzbWxTbkdvOVJ0aUxJ?=
 =?utf-8?B?eHFpazZCQm4rQncyMHVKQ0xHZVRvMTNjQTd1bm9md2VzZTFLejNld3RnMkM5?=
 =?utf-8?B?a2pCem90VWh1Qkd0akJ4QzNyRVJnY3B3Ly9XVmplWHl1ZFE3N3lTRDhaVkhZ?=
 =?utf-8?B?OHp0cVM3T0U0c3Z5Z25UM2JNbW1lRXpzWnVrYURhZ29CTUNIM1hJWElTV2h5?=
 =?utf-8?B?ZjRLdlFWOGRwVVRuSjRCTG5Ybzd4KytMUHNJOGRjVlNjUmtMTUVtNmhnT243?=
 =?utf-8?B?bHRRbXBxRGhMNi93T2Yzb2puQmtwVUJWeHFmOCs5VmJTNTQ4S0MxZzZSakRR?=
 =?utf-8?B?NmpjQjJiWDNoeHZqN0NSblpKLzN5STc4NXBmMXJrTldQeG85aGlNRG9EenpV?=
 =?utf-8?B?OU9paXJtRUhDNXhZTWlJODdGUjZJMk5jMmFlVGRRc2MyYnFxc051QmRBSFBD?=
 =?utf-8?B?WndPbW16YkxnM3IxR1l3T2hiQUExWCt6L0RvZElXNzBDd3NMeVlPQ0RHd3VK?=
 =?utf-8?B?YXIybXNBaWpReXBMbG1VL0VmVG9NMFdmQThleWVEZm5VM1MxWEk2TkZBcFFw?=
 =?utf-8?B?RWtudURQZjM2b1d5bi8wVFF6S3dra1o0Z1BxR3g0TVlTS091cWtrLzdNcVlD?=
 =?utf-8?B?SzJQYnhzMVFMbTdnNkNKZktpVjZzR3Nxd0FOcnVaZFhickVRN0RveDFEZ1VM?=
 =?utf-8?B?bktzV3Y5OHNSRHJialVuUDRQM0pja1BrU0t6bk9pSDVYWGd4dzA5ZzUvbmts?=
 =?utf-8?B?dFRNVy9TaksxUkdzdUxGaTJwdUt5cFBiTHdqQ2xhNnRGYUJ0Ty95SUU5QTNQ?=
 =?utf-8?B?emloNHdwTWRwRnZ3OGNmS0FzaHFMT0V1Rm16V0cyWWJQYkNnMC9HZzVmS1A5?=
 =?utf-8?B?bXhGZFNpajVFcG5wN1lVd0V1a3hpL3hLQ2dXUDBWRFhRUHpBTHhRaTNvWUhV?=
 =?utf-8?B?VzlOaDk1YVRjcnV6SGk3TzRlTjBrWnhNNGptYjlodGVCbGVOWXk3SitRcG9k?=
 =?utf-8?B?bUVlM2xKT2FHS2cxUlF2Y2l5WnhFcVVGYUN1ZXVxT1Z1aWFKZUpUMW5CMTFB?=
 =?utf-8?B?WFI2ZU5RenAxNE43THhETnNSUW05amM2ZXdkckJmMUI5cWpFTlVkM1JrV25B?=
 =?utf-8?B?OFQ3WWVodWlkeEJnMisvOWI4a1I3MGg5RHVDTnFuQjBkVGhxT3AxSytxb2Yv?=
 =?utf-8?B?NnZsdFNmSFk2R2dRcXNaV09SWTVKVnVVOFdBS3BIK3FtL0toZmRiWUtBU0hp?=
 =?utf-8?B?ekhtcEkreG9oVmRERlhtU2xjcjZLcjFMaWpvMWsyeVN2VWN3Tk9CNDkxRlNK?=
 =?utf-8?B?bmtMcUpweWtiVkxQSzZobUhtdXFiamFSMHdqS0s3L1oyNVVLN3pDcjNTN09Q?=
 =?utf-8?B?NUloWE1XWk9mQk1sQWNSTjc1d1BjaldJM01yRW8vTzZTLzkvVWpCME5CT1hx?=
 =?utf-8?B?T1prcGVWanRtdFB6aEQ1RlFBS1FGM2lPVWIyOStCeUFDbDJ5cytXNmlVMDc2?=
 =?utf-8?Q?tCkvfIE77UPgWM5EPkB3+W4q61CMffU9PtBCQeF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d8b9c0-67e9-455c-ce34-08d90e57a0ae
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 17:19:37.1719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Jz7lAYbSN37PAr/O61rmXy4XloISaY7UYRsXKqv1PMw5WQiq+pbS9gJgeHVmDHAjOllO3s7B9VvCWcPFiCmsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/21 11:15 AM, Dave Hansen wrote:
> On 5/3/21 8:37 AM, Brijesh Singh wrote:
>> GHCB was just an example. Another example is a vfio driver accessing the
>> shared page. If those pages are not marked shared then kernel access
>> will cause an RMP fault. Ideally we should not be running into this
>> situation, but if we do, then I am trying to see how best we can avoid
>> the host crashes.
> I'm confused.  Are you suggesting that the VFIO driver could be passed
> an address such that the host kernel would blindly try to write private
> guest memory?

Not blindly. But a guest could trick a VMM (qemu) to ask the host driver
to access a GPA which is guest private page (Its a hypothetical case, so
its possible that I may missing something). Let's see with an example:

- A guest provides a GPA to VMM to write to (e.g DMA operation).

- VMM translates the GPA->HVA and calls down to host kernel with the HVA.

- The host kernel may pin the HVA to get the PFN for it and then kmap().
Write to the mapped PFN will cause an RMP fault if the guest provided
GPA was not a marked shared in the RMP table. In an ideal world, a guest
should *never* do this but what if it does ?


> The host kernel *knows* which memory is guest private and what is
> shared.  It had to set it up in the first place.  It can also consult
> the RMP at any time if it somehow forgot.
>
> So, this scenario seems to be that the host got a guest physical address
> (gpa) from the guest, it did a gpa->hpa->hva conversion and then wrote
> the page all without bothering to consult the RMP.  Shouldn't the the
> gpa->hpa conversion point offer a perfect place to determine if the page
> is shared or private?

The GPA->HVA is typically done by the VMM, and HVA->HPA is done by the
host drivers. So, only time we could verify is after the HVA->HPA. One
of my patch provides a snp_lookup_page_in_rmptable() helper that can be
used to query the page state in the RMP table. This means the all the
host backend drivers need to enlightened to always read the RMP table
before making a write access to guest provided GPA. A good guest should
*never* be using a private page for the DMA operation and if it does
then the fault handler introduced in this patch can avoid the host crash
and eliminate the need to enlightened the drivers to check for the
permission before the access.

I felt it is good idea to have some kind of recovery specially when a
malicious guest could lead us into this path.


>
>> Another reason for having this is to catch  the hypervisor bug, during
>> the SNP guest create, the KVM allocates few backing pages and sets the
>> assigned bit for it (the examples are VMSA, and firmware context page).
>> If hypervisor accidentally free's these pages without clearing the
>> assigned bit in the RMP table then it will result in RMP fault and thus
>> a kernel crash.
> I think I'd be just fine with a BUG_ON() in those cases instead of an
> attempt to paper over the issue.  Kernel crashes are fine in the case of
> kernel bugs.

Yes, fine with me.


>
>>> Or, worst case, you could use exception tables and something like
>>> copy_to_user() to write to the GHCB.  That way, the thread doing the
>>> write can safely recover from the fault without the instruction actually
>>> ever finishing execution.
>>>
>>> BTW, I went looking through the spec.  I didn't see anything about the
>>> guest being able to write the "Assigned" RMP bit.  Did I miss that?
>>> Which of the above three conditions is triggered by the guest failing to
>>> make the GHCB page shared?
>> The GHCB spec section "Page State Change" provides an interface for the
>> guest to request the page state change. During bootup, the guest uses
>> the Page State Change VMGEXIT to request hypervisor to make the page
>> shared. The hypervisor uses the RMPUPDATE instruction to write to
>> "assigned" bit in the RMP table.
> Right...  So the *HOST* is in control.  Why should the host ever be
> surprised by a page transitioning from shared to private?

I am trying is a cover a malicious guest cases. A good guest should
follow the GHCB spec and change the page state before the access.

>
>> On VMGEXIT, the very first thing which vmgexit handler does is to map
>> the GHCB page for the access and then later using the copy_to_user() to
>> sync the GHCB updates from hypervisor to guest. The copy_to_user() will
>> cause a RMP fault if the GHCB is not mapped shared. As I explained
>> above, GHCB page was just an example, vfio or other may also get into
>> this situation.
> Causing an RMP fault is fine.  The problem is shoving a whole bunch of
> *recovery* code in the kernel when recovery isn't necessary.  Just look
> for the -EFAULT from copy_to_user() and move on with life.
