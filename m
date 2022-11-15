Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A0562AE79
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 23:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiKOWpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 17:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiKOWo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 17:44:58 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2078.outbound.protection.outlook.com [40.107.100.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1021CFC9;
        Tue, 15 Nov 2022 14:44:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNb8kZRSae/N4Qm+cp2UEjSJtVpVi/lXVi1Ngddazd/VLBXzZYabS08gHZg4EnZfP+GiNwqqjbcZIO9DT/CWzXRUJIoyc2PPkC06j9f7pL2HEdhnuxpc1n8CfyoZ5oHKPRZY+fLEorqQSYa84Rir0ollUwSwctpNLY7pXGbKECbKMnfM1gRf/kqGP/sHzr5RSuzrsFpwJOJ1cSwZ5vGPqet/ix7Yu+W46q0ykRiobq0uihuX0iPIgCIco5tfbVszUnCJ90iwr8bUyiKr39jX7Z3nRCv67LWZcxFPJL+CeCns6OGP3FcZFIqElAxvoVdSDgBFBqvn7/Qe0KPxbyumsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rz8RFjaWFeuIxfVgUXw/HNAFulF0+Eb3Je8wt87aQNc=;
 b=YA4UzXmHQgh6sEcRf0crM2B4f7N7PIkFSHeqfw5KPVvWybvcYpBtbifGB9R01e8FBqIEj3GaH3/8XQ76ivSooSuR/9Tn4rquW1F0uqZaXqfzxCLAP6kvvpqr1N2HK6wmMJWUgmxRIZOFUmx+lmPZnBFHOb8sZPf1keSoC3YtMdixIGy0/nmwlpVxVGIS0w3BUJH0furUo8mK5BM4lXWihqcb2EGRJYl7fA+cQ2F140+YPx+nrr8m4we3zRHpZk9oDIOt4NsvGtFvlNmv/OHhiAYOlpZzQtSj8Zk3xtP8xsyj4V8sz1UcMkt4OYVUDhhH0a8Dk6xur6Qne9U85aOSUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rz8RFjaWFeuIxfVgUXw/HNAFulF0+Eb3Je8wt87aQNc=;
 b=ZmVFc/ILO/3WhKnR07wHfiZ8CVBWNsq/JZzcPEvk8bs/OqGb/ijz3VmEM5KkgdBze0fdj1WR18jahPC05GgzyQvyLFGTrQxgww8fzRp6ded+7dhbPH325RSjwnUYAiCdXGrfLiPm2M0mHQH8gCC7sAbXS+oEzU9NhOlCzi5PShc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SJ1PR12MB6124.namprd12.prod.outlook.com (2603:10b6:a03:459::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 22:44:52 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 22:44:52 +0000
Message-ID: <01a24370-895c-465a-c7fb-0c6a86c301bc@amd.com>
Date:   Tue, 15 Nov 2022 16:44:46 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Vlastimil Babka <vbabka@suse.cz>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
References: <Y0grhk1sq2tf/tUl@zn.tnic>
 <380c9748-1c86-4763-ea18-b884280a3b60@amd.com> <Y1e5oC9QyDlKpxZ9@zn.tnic>
 <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com> <Y2A6/ZwvKhpNBTMP@zn.tnic>
 <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com> <Y2JS7kn8Q9P4rXso@zn.tnic>
 <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz> <Y3OuvXCjttfFh++w@zn.tnic>
 <Y3O94GPUECo+Gg6T@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y3O94GPUECo+Gg6T@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:610:52::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SJ1PR12MB6124:EE_
X-MS-Office365-Filtering-Correlation-Id: f57ecdb0-55da-424b-3a1c-08dac75b0277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOEUru3kKYaqeVbRiuXggM55HzBEKS4b0Ddxwg9NvqbvLZeK23dEdkvnlIqssbVJBCNrzMNduD4FdqBI6pwkFW1GEbr8bEsx9jOka9JZoRYQTRXBg9p2WOeoh2Pdx5xztBl2uIlgETD2cA1cu9a63vJMZ12NGAl8rUMJeLPkm6C2GYWZJTy+1IJ3Zs0CH3OTlJtAdQpLUr0ukNDC9uvVMQKrlBkKiJW7yp23dI1vKBXfYgcPALq5hde+k0j+YG+jIxLx+31FSLzYJVwNQ4aLnsnn4Xp2utov4FhOxev0SogoEqz95xsd6AGbm4suX2qD6jZV+6TgZB9NpJdd1IhkUDrXyFUhyQFiln1zOPtCkJDdzfyIgxmvkLqHksSFneHoAtl+ipDJFJGcwIN3UACQcDnKf3vY0koimpKZYkmKQ72U309SE5EZGLSpkqTtLF8JM0z1k0GhtVhiURZHYmQwejbU9NO6LoLfVIdz1BvGxDshplFvQJ81URp5CH6ONKQ9BV+UGwXWaMSz5dMxz6zcWl8UjIAV8G8EuB4/z9KeNA7Oocj49M8iC9FjwZpym6G+Lzt0zu1m0QoTOO1salrlJOLfPc/bnVlFP8nWApBmrMTI1DEwg8Rp2c9wzUNUV51RsNUy6rFdU6TS0Dr/wqxTSL9lvkM1wfTRLwDnp3VyrmOvx5TXW/4jVRiWwP3CSfcY+/eYGTLJDQHPfA/hll3fhatHsM01jn9U9BbW0k/ahBi4zcfsLYwlXROiAJyfOStwboJ5TrSkJcocuys7v0DlP8l53nfh4BnegY3CZ2Ze6sHhuel87JQkrKWeeJKlw33arbs1SdoiFXjyb/oItQqckQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199015)(5660300002)(316002)(2906002)(7406005)(7416002)(66946007)(186003)(66556008)(8676002)(4326008)(66476007)(2616005)(41300700001)(8936002)(36756003)(86362001)(6512007)(38100700002)(26005)(53546011)(31696002)(31686004)(478600001)(966005)(6486002)(6666004)(6506007)(45080400002)(83380400001)(6916009)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2lqYlNOK09LcmFVaDVBUVhrUXpuYStYZ0VzWEx0ODlKUUd4aE5oNkQzSm12?=
 =?utf-8?B?ZkFXL3gybDZ0ZDBTdzYyb1JzVWZHSkg3cTZsSGFWbTM5SlZJVEdTMUJWeTA1?=
 =?utf-8?B?bHNwK1dGTE1HODBGUGJ3TTZYcldZOEdsejBRbDFBbWczU0JtblJDditneXVq?=
 =?utf-8?B?WEhIcFhlRjY4ZDVUVW51M1l5TkxTTm5uZDdpeDB0L3FzT3dYS3FRZ29IRWZF?=
 =?utf-8?B?Zjl0QW1HbE8zSG5nN2kveFYyQlJEV2hPVW5yb2x0Nk1Jd2pLdG8zcnJ5a3Ro?=
 =?utf-8?B?WUVuMDZUNjI4V3BLSkQzdDUxRDFPMmVMUE0yM1d3VUMwN1hzSzRWUGdaczFO?=
 =?utf-8?B?azJycjltU2lhU0N0YmVnc1cxZk1acUdwQjFTY0VFRlBCVktDbnpKampPMEJG?=
 =?utf-8?B?NDNZajVBZE1hREZjMGorWDVoc08yOS9rbjJrdnh6L0pieEhtWWdsMkMyaTN0?=
 =?utf-8?B?TTErenhGNS9SUm9aeHh4dlNlRktvai9LajF6RUlVOGFSQnpnUzBzanhUSGJj?=
 =?utf-8?B?T1JkRVFiWnNSME5ZeGlPS2lRdTNNbnNjNVBkL1pGL3FFQnBnenBNckhMWkww?=
 =?utf-8?B?QTNhTkhvdEdmMW50WE5QcHF5d3NGRURrc3lTSU9HbVI1L3ZnWmpnNkdsTHhl?=
 =?utf-8?B?VVJJY1YyU0tTa0J2cVBIODlpUlFvMlZlSFg5b0JUb29qN25aODBza2lLak1K?=
 =?utf-8?B?REZhR1hZM29xVUtSak5GZlBPeHhjUGc4cm5CM2d4T0YwdTVwcUxxbUZYUWN5?=
 =?utf-8?B?a3J1Tm45SzRZMG90TGxWODRnVTVlWTRqbnNydjdoUEhMYjZ2SHJQMnhsNW5s?=
 =?utf-8?B?aXhJYmpsdndZc0RiWHNxNEcxdHlFcXorWStEOWtweTN3blBHNkUranV1cG1L?=
 =?utf-8?B?MjNUUFNGR09vdUdFcGxDMjFlRFpvbWpPVUhCS25aVnB6ODBFVnFDdWtLR1V1?=
 =?utf-8?B?bTJ0ZmhORVBjZ1FQWVpoQW9FRyt3cUxGRDlYdGxEWkZ0TDZpNHRNNTQ5QkM1?=
 =?utf-8?B?dGxKd1U0cjBHN0R0MFQ4a0JQbFB6cmIwMk02MkxlcGQ3VWdZVlVyUzYvd0ZB?=
 =?utf-8?B?Q091YW5OTFF1bGZNNnpQdnV0M21CdWE2ckY3d1ZSS3I4SjFvejF2T0UxR1do?=
 =?utf-8?B?LzBZRVlaaDRPQUtCWEpZSk0yaXdqaC9zY1FUVWpHdjBMcG0yUUIrNWp0L1VQ?=
 =?utf-8?B?RWgvcU82Q2Yrc3VYdno1RklNbituYVdZOC8zZWdoak54Y0NoalMyRTRqdHhQ?=
 =?utf-8?B?NjJXMC9ZNytMekMrY0o2ak9UNFdIcVJaQXlSRXJLUWlzTWhHZHQ2bHhaL0xQ?=
 =?utf-8?B?T0JUOXN3NDR2MUtkUFFrdEMvVUNOTisxUGcvT0dkcXJzZTd5T0Rld3RrMTNo?=
 =?utf-8?B?dldJSjY2K2xIYjJHOElWZFhibWNqbVhpRVFNaCtPL1pLV080WG9CUGtCbDkv?=
 =?utf-8?B?SnE3UnVZSHVFbXpsSy9aK0s2d0pwTUEzSW45K2I1OU05cnorcy9lSkF5VGJ6?=
 =?utf-8?B?SkVSbnVIaEdyZlVhdDZ2Z1l6cC9IKytiUEF3citISDhvaS94YU5ubkhseTNs?=
 =?utf-8?B?S3hvbXNLQytFM2taUk8rKytGRWU0dllZQ1dnUndLdll4aVJ6M3JoaHcwRWl4?=
 =?utf-8?B?Q2lSMndVbTJ3di9BZ2FyMmFTN0FwYVIyQnFsT3UwKzFTWDRlWXM1TktzUVQ5?=
 =?utf-8?B?ZGEvVDN2ZHkwMWZSMVVFQ2N4dC9WZVBKcHZwcHh0OFVZaVI5SllYVXhtbHFJ?=
 =?utf-8?B?MjNVTE8vdDVTZUUra0w1czlabVlnUmFHdjd6SHZZWk9CNGJhZ0s4YldSeFkz?=
 =?utf-8?B?WUVxczVRVitzdmFtT2RHTDJoWXYrWjhOWmZwazJQOTVDWmxQYi9YOHRuUkJi?=
 =?utf-8?B?WUQxblUxbDFFeTF0UW9UWE44d3FQQklvTkd3dTl5QnZYV3g3UHdVK2NPUVVN?=
 =?utf-8?B?RERLZzlIbU5yUDh0bm1obldPQ2RMd3BmcU1DeFpnbG1QUGt1TUVkYXZHSXlx?=
 =?utf-8?B?SmxNOE8yMEs1TjBQVDhxYkxpNWNFbDJPbUFjRnJzMG1zbHFIWHpNTDliYzh6?=
 =?utf-8?B?ejAzcGxnWURaMGMyN2UxS2ZQUG5oTExqazRCRU5XMU5JcjdGQkNZczArK05z?=
 =?utf-8?Q?3wlm/46DukmUB4MRjRahwpR28?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f57ecdb0-55da-424b-3a1c-08dac75b0277
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 22:44:52.5384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EzPzdr+JPicRVXGn5edXS41rERi4GJVrllTYlB8s9MyY9AGZTk46MiZZuTlzwbfBAadLhYTsDCj274UsvuyEWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6124
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 11/15/2022 10:27 AM, Borislav Petkov wrote:
> And,
> 
> as dhansen connected the dots, this should be the exact same protection
> scenario as UPM:
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20221025151344.3784230-1-chao.p.peng%40linux.intel.com&amp;data=05%7C01%7Cashish.kalra%40amd.com%7Cbfecf32a51eb499b526d08dac726491e%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638041264625164355%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3RqOC3b9qn0%2B2IRsTZURBmhAVtOn7rARR6fOMOsrFpE%3D&amp;reserved=0
> 
> so you should be able to mark them inaccessible the same way and you
> won't need any poisoning dance.

With UPM, the guest pages are all still freed back to the host after 
guest shutdown, so it's not clear how this would help with handling of 
leaked pages, for e.g, the host can still access these pages once the 
guest is shutdown and it will cause the RMP violation #PF at that point.

Additionally, our use case is of host allocated firmware pages as part 
of the crypto driver (to be passed to SNP firmware api calls
and then re-transitioned back to host state on return) so these are not 
guest private pages in the true sense and they need to be
handled differently in case there is a failure in reclaiming them.

Can you elaborate on what you have in mind ?

Thanks,
Ashish

> 
> And Michael has patches so you probably should talk to him...
> 
> Thx.
> 
