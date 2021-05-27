Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94971392DB7
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 14:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbhE0MNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 08:13:55 -0400
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:44257
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235200AbhE0MNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 08:13:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AC5Y/9KiPpd+tNin847mlgcF2Melvq/FW3h4AWzT4IJB9X2CY5tXVLSM0wmIZa06Y4fM++l4qB2MqSSMJ1z7uFVJ5tZWRbSI/J6k8qMQ+Rczm+1fAWSZ386lYEbluRY1vWi38+ZF5C4Jc7C9wnlHvegF1DsBD2lQJqqnUB6a2oM9kH4L6aTCOEGIeH/WGRJK1bYLShfdvhhKUZAEili+VyLqYuBiLm8gAdZE2LVnYUgD1UAZgebaabZFUTXFQWOXmORlCoSR9Sc8UG/botlVwrnOGy2o0aVxpFSUfx27q6vizCSfxW9Xz21+MlQpcFHQADQk5Lw496lIYlcdghdDyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSJU56L993pqiL8NnKAXsfN16SOKv0gNJZ1XO7SKCJ0=;
 b=ESG0jGvNXZiW7IDyuvtBXiyWUqNY/nYR8jOCnaVGGOUxiKt+X/JozmTBQp2KgOlBImHtRRkROI3w8E/doyInMOsi3YoSfVxzSQvThxlWlwo0ppKUcivPBTg2BHfyyH0fwF02UvLUMAuIu7RtbCaxTd9g3ATrZedk5AjepZJtkCR/z8rc0fA3cMVfMBtAldZJ6/5rN9/fgKuPoSLyVMnHUd5a48sQswKj40Ja9OYIrtWbNnSe8kjzS7SY3GV1bYjKxm/1/BSmiblVSNWH6DJpfuCe0MsMIRDoEOYu+j1uzh1CwAXddPSTftqbYz1beE0hFKX9Q+qplcRG6oNTplAdXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSJU56L993pqiL8NnKAXsfN16SOKv0gNJZ1XO7SKCJ0=;
 b=wTqBl0HobEtMzgHmkAaL5XunmSqq/QibehrD/v5YINWb0iMMKA0wI69OR8c8kUEs/CdDSa2SZVV06QcM8biafib9Dk1R/WPTkXCvGxDT3XxIDi0HKi5YTH4LbCt1f+/qo2UYnzeF0V1hM8rfo18kYldJKujMXjS7DNTUKpvITR4=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 27 May
 2021 12:12:20 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.022; Thu, 27 May 2021
 12:12:20 +0000
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
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <588df124-6213-22c4-384f-49fa368bb7ed@amd.com>
Date:   Thu, 27 May 2021 07:12:00 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YK+HMZIgZWwCYKzq@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0107.namprd04.prod.outlook.com
 (2603:10b6:806:122::22) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0107.namprd04.prod.outlook.com (2603:10b6:806:122::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 12:12:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 384fef63-3a6b-479b-94ab-08d92108ad78
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574A66AE6971572BCD46BF3E5239@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tTvm0/i/A/Ja9hqWl1IF7cOTUg8UkVZeKVCB2nmquMWsvrrfziZroJAlr3w50a0bH3fhyA5d4GG3uJMK0WOn11I81HgM4fTQhLL4t1THfGgooOJh/gPvz2eWKLH/ezPrTlpJoE0GGhcvg/cIbNcOVrY1+aX6TAxF5Ih/gMooaT6d2SV4gTVfZE5xgE/tsAZdpsoeqRdoEdbniYianaZmFa3bmrM7APBjyDrYEEzM6uNuueftnOIrmaTonvzR5M3xOj176gn1HEXeqLsfCZ5je1Z2ay2cUAJuLJ39p/6kXxiDpVOP39bioOzzBv719GifU0q5S6dpOfaCTW4mhIdK44j5/zux5l+PyjsSVM/QEjyU/y6iwdHUkBKfhKT/gMxjfMudJy3trTu2UhkY5fYW+XTFcqG4BoPvOvG47lMeejzxJ3A33nBdPCNExGSFj2ALx/MfTHXqcoTwr0/Ks7PKsX/nua1FjfjFqLZCDyDCDWPHJtZ+Z7MPxLfY9wUo5lApF5GdVDS9o+YBQrcG3ZvcdRFzv7XRMV8ILwMEy2X28+Yp6fGOVDnCT836/zEw7Sk10RGHeOYci+Ds62IyZOcgXkAuJH4Lu0HzWsDzy7Tg+6uOLilTV1E8FF440uQEm/NjxAV74vghGQ3uk8G8QB3Fuzb98Uf13bguMufjjcSOTCgXJ20DJ2+6b23g9cY7LeOf00oNtIDic/Eu/lT81OmE7Bt6i7FdHCEZpAEA3ZsXrDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(366004)(136003)(346002)(478600001)(53546011)(6512007)(6506007)(26005)(44832011)(15650500001)(2906002)(4326008)(7416002)(52116002)(16526019)(2616005)(186003)(5660300002)(36756003)(38100700002)(66556008)(8936002)(8676002)(38350700002)(66476007)(6666004)(316002)(86362001)(6486002)(956004)(31696002)(66946007)(31686004)(6916009)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cm1sb0NOc0NVcnRXZjFYZnYwZVAveTlyL1Vna1Q2cnVIeTdYanJ4L2g1Z29n?=
 =?utf-8?B?SFRiUzlwMmpWUDAxNWxiOHBjamc5Y2lsTVo4R3pVdlU4NWhwWSt6TEdJd05J?=
 =?utf-8?B?dlRFYVF0bEs1NVZyNDdPN3dPME1Fc2tQSmVmV0xGVk0vTmJFVmVaSTBnN0ht?=
 =?utf-8?B?TEdMOHF4cjYvR21jYWlWekVRV1E1UTc5dng3Y05JVXJzd1ZmVVRDVmpzeFJE?=
 =?utf-8?B?UEZsbzhQdjJ4RG1jdXRHbGxBSXVJUDRxdnQyMy95d3N3U1B6ZWtVcGNBV2da?=
 =?utf-8?B?eDczNnFaRW8yQktvUUF5cys2YlU2RlMvL3FOamJJRXBTR3lCOWdHMzM1RVdN?=
 =?utf-8?B?NTRteFRWN1dNSDNnOXFhUUIxRWdnbTJIMVNKQ0w1QXQvbFV6VHcyYStIWGs1?=
 =?utf-8?B?OFJSa2w0dUZnQlVrNC93SGxERDlJMzhYb3QxVXg0TEllV08yYTV0VTZLUlRa?=
 =?utf-8?B?Z1VFenFsb0xOcDhkYVpTR2pzU0dDTmZmUWdYVVFNdytCZjdvbXJmdnU2QjNV?=
 =?utf-8?B?ZlM2dWNhRDJOMDUyMGVFWVN5VTM3REdBdFl0NVRWTmsxSVpnRWRUUjlTbUJa?=
 =?utf-8?B?Z2MrVjJzRSt5WWtRU0lhaUhXY3pxVTFQWENkRy9SeHFhemRYYVNLeGZhL3Vl?=
 =?utf-8?B?d1NudHJ4aWJvT1NoeDdwMnN1QU5taTJ6b2g4UysrZDNRejMzR2ZNV2Q4TnRh?=
 =?utf-8?B?WHo2WUpIUytHcm4xYi9yTVRnSDNNeWVWd1RBZWJsc2xHckQzYlhuYTRPZW55?=
 =?utf-8?B?aGpRWjZIZ1BtZlh1c2RSQ042WlFQd3RNSHhTZVpMbWQ4V2lmbDQrSFI0aGxX?=
 =?utf-8?B?eTVNNzcrVWRFMzZLRGkvcnZ6NDV6dWEzelA1eFNWZnBGMFc3TzJLRENHelJs?=
 =?utf-8?B?NitIemZIVkR5dHpYcXBGdUxPbzRLL05RaWlRSmhwQXBZaDJBd3hRMHNYWWdz?=
 =?utf-8?B?b3FkTHZlYVU1UEFkbEw2M1pERTVpTjNNNUxENE5kdmtkN2pYajNqSHEyVUpP?=
 =?utf-8?B?VXlaL3RSVXIyNUZJTGkyWlFiSWhwdGczeTBtUUlVYVdoK2VjdFdrNTBMdTNH?=
 =?utf-8?B?M0R3YlFaRDM1QzBEeGdOV3lqano2aW1wczVEaThwOEN5VDBYdHRTYjVBa1h4?=
 =?utf-8?B?RC9JR1RETXE4aEdneGR3ZW9jUmhwcmxDRG1jWCtKZjdNZXUyNStIRTM5Qm1Q?=
 =?utf-8?B?VTBVWTlveTB2M09pVDBBUkE3dzFHb2l1Q1RWbGhuNnFkS2RwL1B2TjBEOENN?=
 =?utf-8?B?RHpFaXA5bmRiSGROSHpkODVPT1VkMGFLNGlXZnVaYTJXV2tsa2hFNTdWaVJU?=
 =?utf-8?B?azRkNjE1aTMwSGdUdTlBWkdWcnFzcjBXVEhES05YZlR0RXFzekQ2UjJpMENW?=
 =?utf-8?B?cVEyc00xZ1pSWUw0YkpNblF6bzVsUFVHa05iUFkzdmZTWlRXekpPenpISFJs?=
 =?utf-8?B?bDcrM2p1SXhqRGFyUktCSzQyQk93M1BkdnJLVWlkZTc0VzYvMnF5NmdCNzlj?=
 =?utf-8?B?eHRiMmkyblZXay9FQmgxWTdWNWQvQnRac1R0TXVhOEE1b0tDQnJvV3VWZUpE?=
 =?utf-8?B?WXlVejdBSldQOHJNajNVbVgwdHcwcjJ5WjJHYzVlQURDOEk5WFVYK0xpSS9v?=
 =?utf-8?B?V2ZZL1JVTTBkbVUvL3haOWJpTkw5Slg1OFRhZHovZ2ZMR092cVJ4UWlFZWNv?=
 =?utf-8?B?bHdsdVA5amNaYVFHREEyUjBlMHlvYlNHZjZtcndmTTBwcTg1cEpzS1ZJQzJl?=
 =?utf-8?Q?FjKEbZoE4GF0dX3VsgkmmX3aEHD8kxLwWsHueb/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 384fef63-3a6b-479b-94ab-08d92108ad78
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 12:12:20.6040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UR0f7iH+4ucLTmKbt3zEt0oYhR5vfVs+2PWGx+ti1SQVVKhlsxKDbb4NKYwoLVAM+/Wr2dmLvZ8SatmgJ4SPJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/27/21 6:49 AM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:16:12AM -0500, Brijesh Singh wrote:
>> +	/*
>> +	 * The ROM memory is not part of the E820 system RAM and is not pre-validated
>> +	 * by the BIOS. The kernel page table maps the ROM region as encrypted memory,
>> +	 * the SEV-SNP requires the encrypted memory must be validated before the
>> +	 * access. Validate the ROM before accessing it.
>> +	 */
>> +	n = ((system_rom_resource.end + 1) - video_rom_resource.start) >> PAGE_SHIFT;
>> +	early_snp_set_memory_private((unsigned long)__va(video_rom_resource.start),
>> +			video_rom_resource.start, n);
> From last review:
>
> I don't like this sprinkling of SNP-special stuff that needs to be done,
> around the tree. Instead, pls define a function called
>
>         snp_prep_memory(unsigned long pa, unsigned int num_pages, enum operation);

In the previous patch we were doing:

if (sev_snp_active()) {

   early_set_memory_private(....)

}

Based on your feedback on other patches, I moved the sev_snp_active()
check inside the function. The callsites can now make unconditional call
to change the page state. After implementing that feedback, I don't see
a strong reason for yet another helper unless I am missing something:

snp_prep_memory(pa, n, SNP_PAGE_PRIVATE) == snp_set_memory_private(pa, n)

snp_prep_memory(pa, n, SNP_PAGE_SHARED) == snp_set_memory_shared(pa, n)

Let me know if you still think that snp_prep_memory() helper is required.

-Brijesh

> or so which does all the manipulation needed and the callsites only
> simply unconditionally call that function so that all detail is
> extracted and optimized away when not config-enabled.
>
