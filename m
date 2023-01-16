Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECBD66B87C
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 08:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjAPH4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 02:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjAPH4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 02:56:30 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B069E8691;
        Sun, 15 Jan 2023 23:56:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpVo7iopzZdeeAyl6FVbMXQPU0wDD7rORdRTbyaGoUSUwVNDEKQEwW/dOG7gY6FmudSIZBfl9yj+4oHvpr0g4h6Qsy/OzTWUA1O5139WV4v2pLmijBBHWxNyYpYKotTaskqxEbICQPGyUth8C+tuRr+tObU2C8NeVN0kjYqsxPN77pq+bZiLd2r2bbXwxdGygUS/J8MIyVxc6s6EOjqtVqOKWvNNHkZ22OiLn9dKTMYsAPwCiU5Sg28VxX/XoZKdfXyhRcwV8jPrdwHFqPkKVByMghpn1Nijj0SQrzJXF2IPF6xTCyb0h3r1EolX4r/FOjPFvlFvRSikwBhrr4lyOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NW6njqAsEPYeRJh2kj8dx8+Rq3/ng4T35lcB/RbAxoE=;
 b=Ep31T8eKt1mqmUepPMLVPCZ6Pp+Az6CRCx4gqtvjZXMxREMQSgJa3sZQD22DXwAKAxFbJshrV1Tr3/wN7PEz/LYMtjMnrOTVNAu1RmfvOfKEzZfOpviXspjSLxBLjv2xUEUQbd4AW2PoXWY0gmc1tloz+D3nBVbMCzGr1a8PqJWebQCr4L+1Uy3LKAkxgu2CIGyBO1QJy1bwA6duIkgN0OsTCz6clOAnvFVXXgygWFVd4CZlqfpLhypcamfLa8H0NRaV/SHpl+JWkihYnvJjE9A1v8GnVu+sUjFFlx5a7qPafa3tfFcrfjA88ecH7Dia+qvoI8Lm6YbsuY6LkAaIYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NW6njqAsEPYeRJh2kj8dx8+Rq3/ng4T35lcB/RbAxoE=;
 b=m5reoDZuJAxXtKuSmTwwBdehM/IRz06jNpY2eXZjSakcyzdvgGn9hXRWG/938aUOcMSuNLgzN6ydySXTo1hOSZXLV4uvMFncbh2sGOTMfSNQF1SYly0qpMIzwDgp1Orh5+/4ezGZwpTNejP+FFE4ip/xsKhoVX25DoWKPQ7dzF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA0PR12MB8278.namprd12.prod.outlook.com (2603:10b6:208:3dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Mon, 16 Jan
 2023 07:56:25 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Mon, 16 Jan 2023
 07:56:24 +0000
Message-ID: <460524f8-e52b-e195-3bd2-27e41f367f5d@amd.com>
Date:   Mon, 16 Jan 2023 13:26:02 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 07/64] KVM: SEV: Handle KVM_HC_MAP_GPA_RANGE
 hypercall
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-8-michael.roth@amd.com> <Y8GAGB73ZKElDYPI@zn.tnic>
 <Y8GEGnmD90bySl8C@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y8GEGnmD90bySl8C@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::12) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA0PR12MB8278:EE_
X-MS-Office365-Filtering-Correlation-Id: adf13bbf-e61f-4ca9-54bc-08daf7972a14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FUgM5yEfDef0+M5hc2lNQrySfuaevZsU6pDbkiw65H4D9jpIQlHmV55N8MbS21ZV8f4gDYkvE3jFeqG+yE8FDDw6VLHcDzkpbS2cFZBjqEfokTR45LkEwr35ohiqr53OhWWFbhZr4Qn5eC0m7CubOeN8Hb11cz3dklxcFhRf8al2rhPz3Esn16OPjNwPPGpZiyTjwVlNaDdhGzp6JrhLG9LGZ3VhF6gJ2UPaUfxDodN5sevGlf5dbZd2jF1L4drLTy6ysjOk1jZmmiVPvEP860WjD3XrL6EFAOQVk1xWqQv+kVF4NNJjLgErqAHaSc6haN12ySY9KNetKn9ELz+3EASLTFlEdIpmXmMK3f+MZNnPYTtyqP4lRuhOC3ZH8c6fZDKy+jKbdnj6mQ8rSXsGitd9oQo+SnrZDEBUVEv4h329WNSOJL98MpB9LdPGOZX5thCdh7iBk88O/OJcFDOaFaecaJKXhsEO4+q/EVO/YTz8FFTgxjfltZuWx0nLTTeiJ+CNxyrACnS82++6VMW7GLvf88Y9GKpOF4khjlKBTmRVnoPDOLluu8sVipu7RpHnK7ws7oC57I2gjBoMvimrjqti9GUosAPD0wHzbztLT1HDx8fS8hIsRc8mu3OeKGYCS40dXfmht5thyarsVAYnYCBrS/eQdaYNZaY3+T2fhaq+zDMWWnNsmSo5yHYpGtcLaTxQiWv+6TWOj9PQ4N8Wd5ug6IjU+2djzpT8aNvJahY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199015)(2616005)(8676002)(4326008)(26005)(186003)(6512007)(66476007)(66556008)(31686004)(66946007)(110136005)(478600001)(41300700001)(8936002)(7416002)(5660300002)(7406005)(6666004)(2906002)(83380400001)(53546011)(316002)(6506007)(38100700002)(31696002)(6486002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFJVOU4ycXdpVktzaVlXTXExWW9xYTZGeHg5YzZrZ0tWMHJvVDFqK1JzWUx2?=
 =?utf-8?B?Z1oxdUZYZUhiSVRLVjRibUo3T2QzZExtTjJmT3ZGZnBTY0xDR25pMUNObldk?=
 =?utf-8?B?QUxnY0RjS2M1enlpbWVJNHNRZ2tFbnoxa3lPMGxoOXExcTFVUU9XOGt6bGFj?=
 =?utf-8?B?bTJOVnNZeWF1WVU4RWk3dDMrcy90YWpMZFFkUGdJSDM0N1hESnVmeEs2UGJU?=
 =?utf-8?B?Sk1taTBXM2RmR0tmdjlHejJGbTR0TThieDQyV3RpRDlBVVI1V3p1NWl4ajhZ?=
 =?utf-8?B?MS8yZG5sNjFxMFd4QldYNGJpQityc1FMWWw4RWY5RlR2bVpJQ2pyVHVOMFY2?=
 =?utf-8?B?c0N5NEtDWGtub25oUVVMSVBWQThYZG1zUlcvSDBXdytncFdBQmFtMVB1a01o?=
 =?utf-8?B?K0lmUTFlTmJ4cng1ZjNIaWVMZllqU2hDUGR6eUt2K0J0MUZ3emlranhqT21F?=
 =?utf-8?B?WXRIcy9FMlV0eDJQLzNnL1FPRWVBbzEvaEI0bHZqWFczVkh1U21YYk5zbm12?=
 =?utf-8?B?R3AxUzVkWm5Cakc0ZjZibHpzMkNseGhYQzl6MFk3S2xFRStieDhrTlZkcDVq?=
 =?utf-8?B?SDZHU3ZqU1pFRTFPSi9QRlVyRVJHS1cvQUFobElpQ2pScU5ER291dkNIV0Y5?=
 =?utf-8?B?QTRaOEJzYTRpaVo1M0Nid0lMalhPL2hJSDZnQXcwdWt5MDBtUGJ0b2J3ZURQ?=
 =?utf-8?B?ZFVSb01RTUJyallaRkNCWVBJd3NYZm1DenBGZkdaYTY0d2FNNVB2WlJURnIw?=
 =?utf-8?B?TjVBbms5RndZSlVZenpkWFQ0UEZCV2Nrd0V3UjZIbEFsUWNqN2JGeFpQcjVm?=
 =?utf-8?B?K1hTUWQwaXZza0JQS2tGWk5FT2t3NndlMVBzQW1YU3h4WGpMb1RvUk5jbTcv?=
 =?utf-8?B?WTBrM0pya1l6QlVpaHJiemp5cFdEL2VNTllWWnFjeEt2MnRMMUw1Q2ZDNkt2?=
 =?utf-8?B?cDRaNi83T2UvemhpSllhQVAvbmkxNDZNaUtONGxwSlN3NXp5MVBHS0ptMmNZ?=
 =?utf-8?B?ZkpjTUZmdCtTV1BOYWJ6R041TEw0RnFTbFlvdEdoMnFyckhYbi83YXZPTXdw?=
 =?utf-8?B?SGRjTWRqNGpZSTBIMXlaV0tqc3VPUXI0NVExczB3RHVEUGNDK3IyTmxiZnN2?=
 =?utf-8?B?N0h0K2VJb3ljKzhaUlowMUZWa2NUdy9PcmRwSjZxMFdLajFqaFd0MDB5dSs1?=
 =?utf-8?B?ZXZrd1poMUliMW5zNVMwUTR0N3FCeDNEZTlGZlRxSEYrK1YyUUY1Y2x6RWlK?=
 =?utf-8?B?ell0UkVLUTNEWnYySVVDNmNKT0ptclRZMXNNekRGYXViL0NqbGswUmhOSmxt?=
 =?utf-8?B?SXh2dkEzMmZCTk5JL3Z4bnd6bW5weXdGeEczVzNvY2ZwUi90NXVyNCtmeTBh?=
 =?utf-8?B?SmY0amJjZ2V6NUxvdUtsMkQvVG9mNTk5UkhNOXVXTGRweEZ6YXE2Q1F5VFNs?=
 =?utf-8?B?bi9ibnV5WSttUlhiUitWcGhieFhpMVlEUkpOUERJamxqcU9kWFRrNExFSjcy?=
 =?utf-8?B?UDluZDhZaFJLWUFYa0Z0WERHbExublM3NVRDV3YrUEF6TlhrcjNhK2pmOVVI?=
 =?utf-8?B?dU40THU5UDF0WTM1aFZHcVcxSS9JOTc5Vk9yZ1htTWN2Smx1WjRneFp0OVA3?=
 =?utf-8?B?bVhzWXhCNnljQUhqcVlIYmMrVXdPK01mSk5VM3ExMGhpWGRYUDVYRkJjZHl6?=
 =?utf-8?B?RG4vaGpTbGtMUDVIaWtaTzNRQ1BuNzNQMy9PMnFnQ21Pb2c0QjRxTFV2R0Yy?=
 =?utf-8?B?blRFSW1wVEhFWGJaWlpIOUxpYy83Tyt3WWR5a0xsdHJkU05aL2U5b05YVGl6?=
 =?utf-8?B?cGxvaU44dncvL0JsMXFxa0p3RkZZYjVOVlBUd1VsT296YTFreXhqWTdURk1S?=
 =?utf-8?B?Nnl0cWVvbmZuZGxrcHNOc01qQVB5TVVEZXgwdWw0WDUvZ3NjeWx6Z29YUWEr?=
 =?utf-8?B?U3drTC9rbS8zZDVNOE5hZUZiOEZOc1JZMldtQUk3c2M1ZjlWQWllRFpXSnhN?=
 =?utf-8?B?d3drem8xQXBrY1ZGRnUzQkxhUC9pd2VpbVJDaVdVRWZlVkFXSm5KWkdvUkgy?=
 =?utf-8?B?VmViZ2o2dWttRGdJRTlISk10TkticVRzZHhUS25IRlprUGl0eVExUDB1NGxL?=
 =?utf-8?Q?kMV4q9TSWOEvqWgBaTe/nLEsu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf13bbf-e61f-4ca9-54bc-08daf7972a14
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 07:56:24.6944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/NeX47rgO1c5exW0eV+Alf84/ReLXOK292cLw1tRIhI4QTIg+HDDrVa66MAlPmc9wPEcsVQqINN4dDs1fSihA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8278
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/23 21:47, Sean Christopherson wrote:
> On Fri, Jan 13, 2023, Borislav Petkov wrote:
>> On Wed, Dec 14, 2022 at 01:39:59PM -0600, Michael Roth wrote:
>>> From: Nikunj A Dadhania <nikunj@amd.com>
>>>
>>> KVM_HC_MAP_GPA_RANGE hypercall is used by the SEV guest to notify a
>>> change in the page encryption status to the hypervisor.
>>>
>>> The hypercall exits to userspace with KVM_EXIT_HYPERCALL exit code,
>>> currently this is used for explicit memory conversion between
>>> shared/private for memfd based private memory.
>>
>> So Tom and I spent a while to figure out what this is doing...
>>
>> Please explain in more detail what that is. Like the hypercall gets ignored for
>> memslots which cannot be private...?

This was required when we were using per memslot bitmap for storing the 
private information, mem_attr_array is not dependent on memslot anymore.

> 
> Don't bother, just drop the patch.  

Agree, we can drop this. I have tested SEV without this patch.

> It's perfectly legal for userspace to create the private memslot in response > to a guest request.

Sean, did not understand this part, how could a memslot be created on a guest request?

Regards
Nikunj

