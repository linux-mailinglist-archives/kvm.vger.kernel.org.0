Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1A4305D35
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313517AbhAZWfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:35:47 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:50656
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389278AbhAZROV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:14:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNnLFUnRcnWHe9ifc6SBgToOmrkfoq+V7vr4UNOBYkEkbE9wdYWedk1bpMK2ORIoqpuMdzDFBsWJYa5nn5OIVNVUN4ttCxMuuq+w0UZfFCUXD8Xoe6pLpO1Dkwyx7pwcmrLV5UjAWh9QT/4xeYpzO2JopkOscsJt8wTFJUuG2hU7t9XszG8HHAnv18qKs41scFl//TPVEV++s4Fp8Ub4+xxEymZrq0mvs0IGyeVV8kzUHHYWwmOkEM5+9mh0Ij9pP+p5kdmgsgNQD0rYUuZ2nHB6L3xfLrbV8jr1ySQEu7B+1Tf4cd8AC7ZsEMtZBZ/NzrAdZkCaJF4AgQeUvP6kew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6oLo9tfRYK9O1O9T/dm9bY2HsYqivug57U9GBNsjpQ=;
 b=bDyVKRH5mSokxoHDVZ6X2Ox4PMjT2KtNSYaUmubjBt1YEfBp47RqyVQ2X8Q6E9ouWd9qsebXYKmGp9/iqoiBf167mwpULPC4ssHQAzHjfpPPNYpLjk+XwmIOgk9zpelHZ9YKCZ2JrmVlkn0oVig1IFnYJ9LmWPHtATuTxbvlw0qECn2B7FLWSurxHY8BzUMgQ5/rhLgmyfaiccMkEti96PjfxDlOWLLq28AbL93gEgofzdB4MZNztcxd60Kb6gcX6k+RiiDRHm1FdiL3x82ttu1r3gXolmGHmxHQW8hirrEmtB4dWjm6bCR6dNqDzSEf3K2fWsoDF1vaJPwKaVlAxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6oLo9tfRYK9O1O9T/dm9bY2HsYqivug57U9GBNsjpQ=;
 b=2cWxdyJrcxfGzC7+pMpDzkhul+ek24d5pZOEt/fLUHIxWgg3Oa3yKvZrLF2i0YVRNOeMVti0JW/3gdZqla2n8UQLeLEoba16ibWou/wVhZIb2tjOl6yJa4F8VMjydf6josJTEjhpz4g0NIV3GMCy+j8wGHYPz7/yYNMHLCcrD6k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0028.namprd12.prod.outlook.com (2603:10b6:4:5a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Tue, 26 Jan 2021 17:13:24 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 17:13:24 +0000
Subject: Re: [PATCH v4 0/6] Qemu SEV-ES guest support
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
 <30164d98-3d8c-64bf-500b-f98a7f12d3c3@redhat.com>
 <b0c14997-22c2-2bfc-c570-a1c39280696b@amd.com>
Message-ID: <946ac9e2-a363-6460-87a0-9575429d3b49@amd.com>
Date:   Tue, 26 Jan 2021 11:13:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <b0c14997-22c2-2bfc-c570-a1c39280696b@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0026.namprd05.prod.outlook.com
 (2603:10b6:803:40::39) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN4PR0501CA0026.namprd05.prod.outlook.com (2603:10b6:803:40::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.6 via Frontend Transport; Tue, 26 Jan 2021 17:13:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3db15328-722f-4cb5-d3b5-08d8c21db05f
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0028:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0028FF0DB5A2CD14413C29FCECBC9@DM5PR1201MB0028.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wyhhj1RsUkH6gb8jU0fXPGl9kJ0/svQ/QRM6hPnv8i1U7bMIZK61Aw32X2Goz6QVEgbXkJH2tl5chp3Z8U4fw3E5yOAemeK4guee2vdS9slP+Lp6ikC0modLub2mwo9aLLC04v63jHI7IFlTcENyRp+SZmaGFeLWXk5U7xshsafVidwb1vjTOguJwIs6whFCxrWXG9m/vQSPKFqj3CwLDxltJJvlg6cR64bf8xggxI6fSxcCcDYQ5QyAiOzPbC3kRunQfMh9eeJMSqMJkyjLdkDhAELSGqwopXiTEs8eHMgZGKWZMhSYb4qpx26ImUdjnj3QMw3mYODgTAmgWnmztWZUzZ1X5mVg8g89Je6EEks+0SQXj/Wu9Y15dHd2gD003df3IxlR1zIHOW34W4kBRejKcTrqitLf7ZdZdQFSsMVYZQ0+I0SsC8sPzfF08i717ueV6iqrDxddjx4gnJEWjZ8XkmT7eBK3If3KH1P8VbzSpzViJu4ynnU0SshH7KPFdPjXb8mldjhxkxjvNt5kz3e4o16pdbNzFksJ+7ugPPOujJWzRgEJR8H06hU1X/UQjP3aJd2D2omFxrBTCkrX4iZe9Q0LLW/IAKDsaTQrPB5rzJyfvJDxkIgxR1L/aisB7E4lLiB/Hi+bmVQscje8h/CuGmr3hYzcDkBi1xHKWuGYCkK4DtfMW00DljbJhmxs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(31686004)(966005)(478600001)(2616005)(956004)(4744005)(53546011)(2906002)(36756003)(186003)(26005)(16526019)(6486002)(86362001)(52116002)(31696002)(8676002)(16576012)(54906003)(316002)(8936002)(7416002)(5660300002)(4326008)(66946007)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dU8wK3VWdlZmVjQ4a1QzaGc2WXpqLzFvTGk1bDdYV0kxbVcrdnJGcm14bkhL?=
 =?utf-8?B?Q1gxSCtsSTNvQThzWjRzcEdZdU55NHY2bitCNy9TdnZWMjhtTUdPeVphMWRV?=
 =?utf-8?B?bUdkN0Y1UWlLdmJpTUZ4WkRHRTh0Smp4R1I1VUxGMktEci9FS3FydEI3d0Nz?=
 =?utf-8?B?aXZvb2x2aFR3U1NLaUdiTDJHRStPc0FNSzAvZWV1NURMaHNkYW8yYnVCR2M5?=
 =?utf-8?B?bjRJcHEzaEVTcVVWVVFEMWcyVUF4Vy9sOXpxVUZnYVErZzFYQUZoVkplSE1p?=
 =?utf-8?B?SDYzZEFINjhIeFVMcGlDOUVlZUV1cVdxUE4wSTgzRTJydmMwNklrcVYxQWVy?=
 =?utf-8?B?bDZrQi8wc2xNclV5Qzhpd1VnQkc4MUtBZmVNbXlnM2hPSGMzbCtQL2d4Tld4?=
 =?utf-8?B?aEVpZ3F3aHNVbHI4NitkQVM4OGtQWGRocVcwaytZQmhFYWtkcHBJUmY3eldi?=
 =?utf-8?B?eEs2YzN2ZjlicWJaMUh4bVE5Y2dBOU1mM0V1bEZzSkhCNmNadEN2MzNwVXI1?=
 =?utf-8?B?cFZ5cE1STjYvQ1d0NWhNWGc0UDVmNGxEZDZMTUpQenpYOTNiRVYyNXRoRjJ3?=
 =?utf-8?B?bzByMXdMVGJLZ1JadWkrNlRnTi9ZNkd2Qmh5NTJLak1qdElJWmY5dUFGblB6?=
 =?utf-8?B?OVZTelNrWlVMWm96VDh4S3pNc2ZGUk1Ib0t1c0RPL2dsNzlYRDlVbXNBQ1Q3?=
 =?utf-8?B?WnJoY1pzbFlHaWp5UGllR014M2djcHI5MzFGV1dtWXF2WHBvc2VDYmI0ZzdR?=
 =?utf-8?B?LzJ5Yi9UeGkzUFRwV3k5bjdzQXNLWmRHV2pRTlNiZTlxeWRlWFVOdldkamhs?=
 =?utf-8?B?TTVaSUJZS1lRMHZZam9kcUpER28wUDRnVVBGWUNNUTRUMm1FZFBENVpHYjBs?=
 =?utf-8?B?aWViRk1nOWhCcnFsMWh4SzZyMXlmSU1CaE5rNWsrODBta09PaU4veXQwUFZo?=
 =?utf-8?B?NmZvdWxWQ2dDeDNuMlV6enV5Z0I2UlA4dzlqNGxUaTh1aG9hNW4rYk5sQ0RP?=
 =?utf-8?B?VE43cC9vZHFKNWs4WnFCenQ2S05JWXIyM3JZRDVia1djYjJmQW1OK3RyVGxK?=
 =?utf-8?B?S2l1UTFVR0lRS2EvTHY4QW5RakVVLzRuVzVEaytGcjgxeG50a3lHNTNCYmwx?=
 =?utf-8?B?TjRUeDRjSDVyUkpVNG1mM2w1WlRPbW8zVGwrekFVUWtBeHN2aEFlYm5oTVA3?=
 =?utf-8?B?dlpBYmtid2NWZ3hxR2RPUWVwWE5Nd2JwRzY2VWZpMldTZ0hqQ0NmRFowZy9Z?=
 =?utf-8?B?Q3huKzcxejVhbS92UnZaMDJ3cEE0STlVaGVSaTdoY1RqeU1ZNnZlaFZ6dy9y?=
 =?utf-8?B?NVFwaWRlSTZhUldIbUxsM2I2d1ZON0ZQVWJ2eUF0M21rNWcvd1FMNXQ3WXFK?=
 =?utf-8?B?d29pOWkrV0trV1VXTUZISHBQUml4QXQxMjZBUVpKS3d2QmFXRkE5NjhxSnJT?=
 =?utf-8?Q?88PH2pxO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3db15328-722f-4cb5-d3b5-08d8c21db05f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 17:13:24.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+yYKqc16BfifaGc6rzxzo+r+MzgL16P9PsRgJAyh3EnuLHEACybXjIZEMv1JYTbrEHdeIXn50KBmiAFWAXBDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0028
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/21 10:49 AM, Tom Lendacky wrote:
> On 1/26/21 10:21 AM, Paolo Bonzini wrote:
>> On 25/09/20 21:03, Tom Lendacky wrote:
>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> This patch series provides support for launching an SEV-ES guest.
>>>
> 
> ...
> 
>>>
>>
>> Looks good!  Please fix the nit in patch 4 and rebase, I'll then apply it.
> 
> There's a v5 on the list that was rebased on the latest tree, but still
> has the patch 4 issue. I'm updating that now, so look for the v6 version
> for merging.

Also, the new version will have a prereq against another patch series that
has not been accepted yet:

  [PATCH v2 0/2] sev: enable secret injection to a self described area in OVMF

  https://lore.kernel.org/qemu-devel/20201214154429.11023-1-jejb@linux.ibm.com/

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>> Thanks,
>>
>> Paolo
>>
