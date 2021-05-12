Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF8A37BF31
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 16:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhELOE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 10:04:56 -0400
Received: from mail-dm6nam08on2060.outbound.protection.outlook.com ([40.107.102.60]:42561
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230211AbhELOEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 10:04:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jP0Qzqn7/vHybAvXicL9Is+sghSNeRKgF9KcV9nrVM/rH1tgBIbNjbBf8ThtLX8stzjZXnyjz/DtipwHn3dlWm72atjm4XvX1Kf2fYuByqlhm1nBrzpCHj0Oj3mRwmwjXlzLWx/aCwKGG0woLeVvh9EphxaYcvnX9QpzqVEPRodSYQvzAcsZ2X8sVKr/idMrs3FAIicWSnkQLskwGPIcLeW+LUPiVwhYBpQ/auUytcSeSJ0TRMZ+ubmpACERwNr5T2b4FL58E6glTXXyKw3gpA0eHnl/cfVzjXILcrsvZv3ThbUnhmfiFxzmOVaAtotf11CPFGojbQcv4JPUEUIZ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjjIkpTUxWFybrIypboEKDgX2qMgJOxWg9RNUSPPO6w=;
 b=i8CNCJ09itaaeQwmrh+rlrZnOgs8jeqUmN4WNyuuNE87FnAJXoSO1Y7iwVEFs+HjDBu0lKnMkDyCm93Rn/V8/9Dl9sMQa5Sbp4MtbiJ57iPYnhwUicjL5wAEji07B6eXbQSoqA+cRc2W0lwMUkMDbk5VOtKNOnXK8I7caIPCTEvYsdw79CoQHDarEPUD/+qiUitCG5qwHvwK+Wd7SribZL/7XrQObZEkVY63b6uUqanhCID+6x9qALpDfQ40GFH3IvU6OxN0ysyd0Ax3xVkZU7/170QqQfRVAFdzryXqPYq9n1DLHVMfH//ncyq9o4hsCZdDZBm9CFzfAAZFXl4M/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjjIkpTUxWFybrIypboEKDgX2qMgJOxWg9RNUSPPO6w=;
 b=yfxZ0VF2JkToYIHhDfLTWGC3/lBw8E95v7uuTRUhZFh8FxVFDB7JFB2e+th6H03kfv8WZ4pb4oWsy8nBLmdyUHHlFnpTukpGdwYs4RCi4hVpSjZsflClLwp4k/9d5eT9E+vVQAO5ZmPGdZcBHFAZvLf63HHRNA4v52h+C2WhUnw=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 12 May
 2021 14:03:44 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4129.025; Wed, 12 May 2021
 14:03:44 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 02/20] x86/sev: Save the negotiated GHCB
 version
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-3-brijesh.singh@amd.com> <YJpM+VZaEr68hTwZ@zn.tnic>
 <36add6ab-0115-d290-facd-2709e3c93fb9@amd.com> <YJrP1vTXmtzXYapq@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <0f7abbc3-5ad4-712c-e669-d41fd83b9ed3@amd.com>
Date:   Wed, 12 May 2021 09:03:41 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YJrP1vTXmtzXYapq@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0401CA0024.namprd04.prod.outlook.com
 (2603:10b6:803:21::34) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0401CA0024.namprd04.prod.outlook.com (2603:10b6:803:21::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 14:03:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07c3f97a-d8b2-4709-6dc3-08d9154ec153
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2640858559D72EE8172B0BCDE5529@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WddqURGdx/RlchjUaTknWPjQ5F3W8muC1QW0oEPtbWvbA3i41bo9uwgXNm32iA8TkvhqfIZltTRwPYPvyg20g7ybsyMuPt+DbhzZ/OXpWF6gn62EIo+ZgA6xVXLiAw/PHpTpeQ0mblp0KhMeY0k8T5EK0VOEyAoxe1vgRdfWGv2LJgNLwRYDRXbJ4YKsifj+D5wSRkddI+i67J1LDMyvP+D4b9xEatEpNzUNxvHnsU2o2z/R8dBgyfRTBy36ecG6ZGOeDRh/kbGVWGGRVIna4DQME3oSb0KGRdG3GwhK8tEeH3/7nULrbuZXzpt9M6AS1xGDFIRi1YuK/caQ7d8GB4RnTVxh5GmDAfJLo3Yj+Vhy1r5ccYcgeWRDYoxPOY3Qla7iW44Yy4SlBI5y5IWRg/fvoIf0zOwB1yAysh3Ot3rPkBh0Ppsk2igAOzwjSrMARQ5a56JEQ14wVH/kSWQwIJgla3dWvTQ1U/PwR+GFEEvImtdPFo+TRA1DKx5WlJDJSB8rYvBMAzsyoZeMYTZVhn90OdlpUOITTVVHpEZdmxvZxlVU66QGe23RJLVrwRZZ9rCZeALBHYzgY7JTIB8l/g1YRvfB7g9OEAgJtPyuVr7G5etGQfloPDBU0G5f4KoRDDRLjyAq6OxGH7CNzMEW/tfqIgUBdNARBuyL7T7s9pw7itR1RXhGmgBcyXwS9nDL5CC7PODHp1Av9Mf7hmxCBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(2906002)(31696002)(44832011)(38350700002)(5660300002)(16526019)(86362001)(186003)(38100700002)(7416002)(316002)(2616005)(956004)(4326008)(36756003)(6512007)(6486002)(6916009)(478600001)(31686004)(66946007)(52116002)(66556008)(66476007)(26005)(6506007)(53546011)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Wnk0TGI1QVkzTHVmZ3doZHJUaHBXRVlQbWY3SmN1NlJCSnBMSlp4NVJEMEhC?=
 =?utf-8?B?S3RKc296ei9qeXRNa3NlaFA2dWliQllDdHpIMW5nelpwWWl0T2JRSFpQWmhi?=
 =?utf-8?B?L25wc0o1WUt2UXcwUnJ1YjFROXFUZ3JYTlM3SURkUEZVL3Y3SWZKOUxURkIw?=
 =?utf-8?B?Q1hSQWx1V0pZbjNjYVRZYnJmQk5jQlR6Y2tKNXBOcE9qRUtPTkd5L1pTNzFY?=
 =?utf-8?B?ZjYrSnNpVTdQbmd4T2wvZElaK1FyNTg0YzhGN20rTUZMOHdZdVAwQ2p6TTQ2?=
 =?utf-8?B?S2lsUXB0VnNVK3N5aUFzcVZ4aGVBMFlKRmpkWllmVFBwREg4aTAyTlhRMzl3?=
 =?utf-8?B?Wk9LTUFzR3V0R3JOMGpKZHBCS2cxYXlNRUxKcENYVVU0ODU1M29CVVlTQUhS?=
 =?utf-8?B?RVhUUEovbXNFbmhPMFc1ZytRb21jUEZhR2hJY0krL0tLeHBETGROa0U0UWlU?=
 =?utf-8?B?bW92S0dVejVYNDB2aEVTem9QK1Z3SS9BV3JVQW1rSWtYSThBVG5ZYkY2b1di?=
 =?utf-8?B?ODJiQWgvZWhCMkw2cFF6TkFqNFFZL2xUdHlvWFUwUmYyeWJHQ2J1SWFEN1pR?=
 =?utf-8?B?ZW9HT3BUUGcwcWFQUlZqQnVIb2M4LzVvdDkwS3A3dlJvZCtuUFBXNCtVcG16?=
 =?utf-8?B?b0VNUXBabGVCeUZYNzdGeTVoSW93TXdRajU4cm5CN1N5Z1BVSVNYc2I2aXVF?=
 =?utf-8?B?L1VSM09XR0tWalpwVGh2dno0dmVITHJoc2F2UE4xWFB2Ym1YOXUzdnlWSFRu?=
 =?utf-8?B?TUNLa0xacEFDdWpBMmVYUjVQOVNqQ09tVERwQ3FoalBmM3FhcnZxUlcvVnl5?=
 =?utf-8?B?UnJpdjk3cEpibGZ6Ly9kRGJEL2NTbERrUUZxaGFmWWxISGVIaEJJdjNIQXhK?=
 =?utf-8?B?Tzh0c25VRDdDV1NSaGgwSVVJSUl3cTIzUHdHWnJJdSs2Qjl4WmFrQUY3ckkw?=
 =?utf-8?B?YU5mNVVqZ1YvdDRPMDEvVkNjMHgrd2tGS2tNREJIZlRtT1RJUVc2NDdzMFI5?=
 =?utf-8?B?Rkd0ZmRkSzFrUDNMWE13dEgvMjhDazZRVzRjcHpwUERLNlVyWHF0aXdTaUZr?=
 =?utf-8?B?aFF5Z0s4T3JyVHordC9hZ0xLNmJKclN4ajBYK3hSaHJibDF3MEQxTVBjcTNR?=
 =?utf-8?B?R1FNRWZoWmo0bmZHaVRiOGU5RC9Zc29qS2I2M0FScU40RzBhR09nWVpZNCs2?=
 =?utf-8?B?Z0d0YlExcFZQcWVmRCt0eVg1ZzlsV0lXNTlIZEwvRWs2U1lielJFM2lPWFZv?=
 =?utf-8?B?S3ByNU1xZG5FR1FaN3JZdlloeGt6LzdKSXlHOWxKQ05mMU13OTBTUVJDUXJJ?=
 =?utf-8?B?UW9vYzhjTm1RcEhUejd3OEZxdzFvaDFMOUg4OXhsZzc4UElEL3pnZ0FpVFlQ?=
 =?utf-8?B?MmZNTEJlSDdZaFpVODVqQnFUVWVHWExaSTBsYko1NlNUKzh4dkZwUldyU0Ft?=
 =?utf-8?B?KzlGMGxBaHlsVnllbTJzcjdIOC9UblJqa1ZFWjFTT045R2pWUU1ZU2NVNmtO?=
 =?utf-8?B?Rm9ZcDl4TXJrcWdOelpsNldyQkZxUm5rOTZwbFBaZERIZDBGSGxKOTRWUGNi?=
 =?utf-8?B?RlNCelQ4Z1NYL3RRYU1vWGpJM0dVUzJSWE1zNXRHOFNNN1lCdFFxalZ6MUVr?=
 =?utf-8?B?SFYwK01ZclphL1JFK3YxOW1kZm9rTXRSVzJDVzRubHQ1bGc1b05UYnBYTmQ2?=
 =?utf-8?B?U0lGdEF4ME5SeGVDdDdEbkhtVldtZVRwbmo1WE9ieXIycnlLK1VGZUVGdU1u?=
 =?utf-8?Q?hU85r4GIXaHmhivaNzrdkatFthf0cbFVCmfCAVt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c3f97a-d8b2-4709-6dc3-08d9154ec153
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:03:44.6327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8c0w36PESyxkN3cKEsk4DA0ROi2cXv5cgYQHm/h6qXW3yTQU1hGrBAXh0CT9jAKShcGuJjnwi5hUXIRQUKb2Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/11/21 1:41 PM, Borislav Petkov wrote:
> On Tue, May 11, 2021 at 01:29:00PM -0500, Brijesh Singh wrote:
>> I ignored it, because I thought I still need to initialize the value to
>> zero because it does not go into .bss section which gets initialized to
>> zero by kernel on boot.
>>
>> I guess I was wrong, maybe compiler or kernel build ensures that
>> ghcb_version variable to be init'ed to zero because its marked static ?
> Yes.
>
> If in doubt, always look at the generated asm:
>
> make arch/x86/kernel/sev.s
>
> You can see the .zero 2 gas directive there, where the variable is
> defined.
>
>> In patch #4, you will see that I increase the GHCB max protocol version
>> to 2, and then min_t() will choose the lower value. I didn't combine
>> version bump and caching into same patch because I felt I will be asked
>> to break them into two logical patches.
> Hmm, what would be the reasoning to keep the version bump in a separate
> patch?

Version 2 of the spec adds bunch of NAEs, and several of them are
optional except the hyervisor features NAE. IMO, a guest should bump the
GHCB version only after it has implemented all the required NAEs from
the version 2. It may help during the git bisect of the guest kernel --
mainly when the hypervisor supports the higher version.


