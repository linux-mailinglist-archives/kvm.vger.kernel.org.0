Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEF0372CD4
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 17:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhEDPRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 11:17:42 -0400
Received: from mail-dm6nam11on2087.outbound.protection.outlook.com ([40.107.223.87]:32704
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230357AbhEDPRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 11:17:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CW36NQrn+JaLs/Cyczeuo+1zzMf71fLBkldtufSvCZqz2DB/TETnaIiBdAAP326FX3UbajKGYXF78zMw8fw9KwmU23/odB0rpf7iP5LCnLJ9LnrjVfktQLKXxdO5u/0s9B58pbBRf9J6pCJLlDb9H8+0JCkrv4AXEIRnuNuSfmC83u0mwQiJX6ozwP3GKtox4EiS/wz+epVDXinDOPt7bRTVW+hFbK1HhpYJ+M020mqhlnRGJfFVQb0UMGIBKBrvKDe+s+1KeHFJX9sSSMZG6kpmzeYYym47trvYeT0gZ4dR2dDX5tlXpn5IT25uGWHawPXI82LJcmNi84MBmoyNvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNDI24TJLuhbOqpIjyZ4QfYHnV8+Nj3dZhsy82ydd0Q=;
 b=mOR7T0ePzEdw+YAvAruaMW7ugYq0MRJQasM9d4ucUbuFfh9K2lh5X/r8F6j9T8FOhzFC/GI+YF7+jQq2Jdkq1Dj4/QRrgwjpRScGR8IRLmFQrSRG7KAxlkfFFN2B4r4gakadZlHmJAfnwm1n1gVP4ONcDepK9jEdbPQTJKhbqQK2W22P4+RCDv3Td9SCn9uJzwMOS9ilayQgAYXLD0AY9eQHWj4YZqxdYJF0Iraj8k6LwvGvt08QVNwV8W3X7PuZ8dNIQ7z+QQE2Xoaw6sLdzP8DZdkEVaCoCc99wuvyA+kCGEAtpoI7Cw3EjQcMK7//GbMCN5IeSh00u3QRw8yl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNDI24TJLuhbOqpIjyZ4QfYHnV8+Nj3dZhsy82ydd0Q=;
 b=aJrWLqvPNKe1wFRTOgiNddBOGgOio6pD82l09/SBXfIZV0mj0DhtecETV3kJJrY1cUcUKeWLNKdWZTgLfrt5JN6lT1RQwG2k76geuL8RK6a84/ZHaJiwIQDO4pMDPEQpar7okcVh1/PGESzuBegVeJoCR+og+Ji8kHjE0NHkgzo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Tue, 4 May
 2021 15:16:44 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4108.025; Tue, 4 May 2021
 15:16:44 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        Thomas.Lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
References: <9e3e4331-2933-7ae6-31d9-5fb73fce4353@amd.com>
 <40C2457E-C2A3-4DF7-BD16-829D927CC17C@amacapital.net>
 <1c98a55a-d4d5-866e-dcad-81caa09a495d@amd.com>
 <b723e0dd-7af1-37b3-6553-e9ef4802dac8@intel.com>
 <af581395-1322-a668-d5f3-3784bbfd6c9b@amd.com>
 <ea839e63-3374-5ff6-92ee-da6f1f714972@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <b5836334-16ec-7a51-b570-621bf05b4de3@amd.com>
Date:   Tue, 4 May 2021 10:16:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <ea839e63-3374-5ff6-92ee-da6f1f714972@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:806:121::34) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0089.namprd04.prod.outlook.com (2603:10b6:806:121::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Tue, 4 May 2021 15:16:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8db98a14-4a7f-455a-d014-08d90f0fa0ac
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25123BF2D57101DAB3EDCF0CE55A9@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IFgsO9CERH/8Tha58g3KF/afVZty7B+LETZIo6cOe+SgAq28yPQ+PivSHq11maVKzmKEdnwQonkqWNZco/JO1R5dTF+zrxcnx+HtmvfF/riBwQGFP+X6x19zEiP8d2/UtNkqorHMu+RnzEytf9KM1bPaYEXqvUnYhxO7D3EoGaXgOEXDKVcpDYiK3ynyZcVgz6vdKLrZ04R39CRi64RFdfdRBekFsCJVeksEWdUWoq0FL0R3wm2asWbOnXEnCZb+8mbOlAGazuLbZNuJiI2PTc4p8PZpq9cmWwXiuqQ9zdTXBcNW0Mu6iBypIRSXF5IbR4M0RRDgF1+yFIIEZRXVg4tAWelVT/ZeZ6kJl4N2wTutQDRAGJCSSYtn2SB3221YeD76Op02qx0/n8IEbQO1qraKoNuhcq49KKhZBD4CkrZ6m1/Fz/a8flbCQD2Z1puU6FAq+BLlrnJEy348s36w897cRYdrgeG+QLHCVm+C//VBLjCwiboQXpBoS8/FfHAaGD8vJP/LeQzhkAMoCUrXjryZDCmBs/DIM+F5Xr61FfvjTKDZPa4apFPR0N/W/LJM3zvLIJ/+qB8oPUSrokTdratQn7Fk1IhfYAHREANfqyytCVAFpeYIv5QVQ1W528hBpN8vO+HOpWI9oHLTSq2dMAI1WtSvJXL7/OKfIazA0T5HRdkR3EvHPpjuL/lb70z0uDKh6euMgKyswUKGC/Sqj7Y+ibXE6KKk0at67AedlpQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39850400004)(346002)(52116002)(66556008)(66476007)(2906002)(4326008)(36756003)(6512007)(44832011)(5660300002)(31686004)(66946007)(478600001)(38350700002)(8676002)(86362001)(6506007)(2616005)(16526019)(53546011)(26005)(186003)(956004)(7416002)(8936002)(110136005)(31696002)(83380400001)(316002)(6486002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Mm9HNnFLQlRyaHdvVUJGN0prWGt1SEU2M3gxRGRRbzkxM1Z4S0VQRjFkcHV3?=
 =?utf-8?B?Sll4N3FzQUJoZlFvT1NzdStQODJNajNIdklVNC9rQit3TGhDaUJBZWN6WGR4?=
 =?utf-8?B?RTRFNDZldStQZFkxU3VTTjMwYVpIdGp3c2NlRzVDS0d0TXFQSDRNRWtQRlJo?=
 =?utf-8?B?MGtNbzZGbDRjS29QUlM1ekVJeUFENk1xaTVPNGlpY2V5SmgrNWhJamRzd1U2?=
 =?utf-8?B?OTNhdVRWS253N2xDT0JuaTZyQ2ZUZThsTElhclp5UFAwMXdpcHBNUWhFYWx2?=
 =?utf-8?B?aDRwVDl0OGhhb1ZuRjJ5dU15MFJUcXVuSkZRRFJpQlNZRHloY3ptbFBBaWVR?=
 =?utf-8?B?NWdIWDg5endaY2xManJ2VFJRdXVuS0tCa2xseFc1eU5lREZCdkp4R002VHho?=
 =?utf-8?B?NjZ6ZVpIYjdsRmx3bmQ0M0lwaTNzUEVuS1dDSFFRK2hGT1BkaC9xeDZYTTJp?=
 =?utf-8?B?VzQyOFoxWG5lRzhzclR4TVV1dkF1UFd6L28xbDIwUEJYU3BUMEVwd21CNFli?=
 =?utf-8?B?ajROS0RESGFnKzVPdFBQYmc5WU52bVN0U2YxbndZM2ZtUDR0V1BMdnhodUI2?=
 =?utf-8?B?em01ZXFpeVNjWFBxRUZBMDE2eTk0ZkcrbDJkSUpVd01veHVFbWRnaG50OUk3?=
 =?utf-8?B?OGtnM2FIUGVUWHZkbGVaZ2ZtT2xVVDVEY1dwKy9IUmdFNHkweWVFUXJZM2Vi?=
 =?utf-8?B?eXRZOCtsbkVRQU9mMU1XVWEwNHB5K0VoWm1NUGN3RTQ2M1NzK0pLKzR5SGJG?=
 =?utf-8?B?RE54aTlqZzNzd2RzU3I4eGJ4U1hIQ2pNdlRsczVZazlvc3phRUErbkg4ak9R?=
 =?utf-8?B?bTNZVVFUUmU2S3AyY2xLTWE5Znh6T1VlS3g2VmtyTmJaa1Y5Ky9tZmRrWW40?=
 =?utf-8?B?bkN0cENnMXVLdHJ0b05QMTZIemNZV2dYSHhGWGxEaXAwOVFialkrVUxvL2ZV?=
 =?utf-8?B?Ti9OZFBibFVkRHVtQlY4Qm11NkpFVFNkL20vcm5EVG01bTNldlVpaWwyZ3E4?=
 =?utf-8?B?Q1MvMUVYblQwRTFDeVltaWljL2dTemtXYzlYZW55VjdvRHFETXlaemtMS1pO?=
 =?utf-8?B?enZMMVU1TzJ5eGgvMnFYK0VBU29mcitGTlZzR21PRHlZaGhubmdQdXQramM0?=
 =?utf-8?B?QzkzbTFxSEhhQUhJL05qcG9OeG0zZDNjK1ArUk9kNUFrSG0yNkNnbisxMmw5?=
 =?utf-8?B?VXdaOFVxVzRGbmdxVXpTcXdST2tYVU02L3N5MzBEbjQzRk1UZFN6YXRFYXI3?=
 =?utf-8?B?ckV0UkxKV2pheDRDcTdMTGx1VGRTZFJMSWViTmtxMWhHZnJtRC83SmtLTjFP?=
 =?utf-8?B?MzlvZGhra3RZZ2NOL0tGTGZ4dzQxWFVFUkxndGVNcThKNzdBYURFcExUSXF6?=
 =?utf-8?B?elhCV2x4bnYyeGswM2hWYmRGVTVoVTZhdEx3VVZuS0RyS0lnd2drSVZ1anlh?=
 =?utf-8?B?a3FOUW9HR2FNMXZkYkVJZmdHZDMxR1VNZEVKWTc1MXQwQlBvbGFoc2RwL3Z5?=
 =?utf-8?B?b2tRRkVTcEgvbm1wUUgyZjBMQUFhWFhWOGRlRlVsR3M3dldNeW5KUG5XYW9x?=
 =?utf-8?B?UFVKQUcxRXNhay9oY0ZoSlgrV005M3FFaXZ3MVc4VW1hN1ZmbEM0eWdTbzlq?=
 =?utf-8?B?Y2NYeU0wNWRVU0p2NFFFdDhPcnpVbEJac1NYNHR0UnBiellxQVV4bUprZHhI?=
 =?utf-8?B?OXVVSW1QaG5KUkt2cEIrbHpuK0Izbk1Uc0lxM21WYVZpcnJYRUxzTlhUYnFL?=
 =?utf-8?Q?WzNCqj47h+KvZzNBrturVzg7DdopSEDLqGhV6sK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db98a14-4a7f-455a-d014-08d90f0fa0ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 15:16:44.6080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yg+15lX708Upp6FZbZ4OEseq1rVa/kpDvaDvYO7PWUAfsvrevMbwYg9IB327+Aa4Hyq3ACqu4NlBDCnUSVYUpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dave,


On 5/4/21 9:33 AM, Dave Hansen wrote:
> On 5/4/21 5:31 AM, Brijesh Singh wrote:
>> On 5/3/21 2:43 PM, Dave Hansen wrote:
>>> On 5/3/21 12:41 PM, Brijesh Singh wrote:
>>>> Sure, I will look into all the drivers which do a walk plus kmap to make
>>>> sure that they fail instead of going into the fault path. Should I drop
>>>> this patch or keep it just in the case we miss something?
>>> I think you should drop it, and just ensure that the existing page fault
>>> oops code can produce a coherent, descriptive error message about what
>>> went wrong.
>> A malicious guest could still trick the host into accessing a guest
>> private page unless we make sure that host kernel *never* does kmap() on
>> GPA. The example I was thinking is:
>>
>> 1. Guest provides a GPA to host.
>>
>> 2. Host queries the RMP table and finds that GPA is shared and allows
>> the kmap() to happen.
>>
>> 3. Guest later changes the page to private.
> This literally isn't possible in the SEV-SNP architecture.  I really
> wish you would stop stating it.  It's horribly confusing.
>
> The guest can not directly change the page to private.  Only the host
> can change the page to private.  The guest must _ask_ the host to do it.
>  That's *CRITICALLY* important because what you need to do later is
> prevent specific *HOST* behavior.
>
> When those guest requests come it, the host has to ensure that the
> request is refused or stalled until there is no chance that the host
> will write to the page.  That means that the host needs some locks and
> some metadata.

Ah, this message clarifies what you and Andy are asking. I was not able
to follow how the kmap'ed addressess will be protected, but now things
are much clear and I feel better dropping this patch. Basically we want
host to keep track of the kmap'ed pages. Stall or reject the guest
request to change the page state if the page is already mapped by the host.


> It's also why Andy has been suggesting that you need something along the
> lines of copy_to/from_guest().  Those functions would take and release
> locks to ensure that shared->private guest page transitions are
> impossible while host access to the memory is in flight.

Now it all make sense.

>
>> 4. Host write to mapped address will trigger a page-fault.
>>
>> KVM provides kvm_map_gfn(), kvm_vcpu_map() to map a GPA; these APIs will
>> no longer be safe to be used.
> Yes, it sounds like there is some missing KVM infrastructure that needs
> to accompany this series.

Yes, I will enhance these APIs to ensure that map'ed GPAs are tracked.


