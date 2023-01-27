Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F91767E4EE
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjA0MSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjA0MSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:18:18 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3B355B1;
        Fri, 27 Jan 2023 04:14:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoGhIw1DCA5dexHKrKZ4mSXpSvUrOwZ1lrFBnOwgA85yNz1+E5k4Zc6H0CXcefoDZN+2WF/7q7z3vu1rsCodGPs6Iu13Tkf0c23CbYyAOx8O8xqQ7CqTjmHIvR9MLW85E23cMGhmSP2NYpGxpjxf4dreK9eA9CpvpqKl2M5kDiO20JVzY1IcuU8RMEwUnRdxSuwau7ASFDmDEZXPTNV0ncX4M6Z2fYpZfslHx6nbxDaX7R1AYI/ACJlZ8SiJUQVwmrOuR3gWUp/3xb2DOJ2qgyPlR1d4dyd0SyV8Ym3Qr1sxnODKZufHkXztEBFoPDYw/S4ZDtqIL43AG3N05/A3/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfyTKzE9H+ZVGFH8WyuS4e59qdz5f8vx9ga+sokDxaw=;
 b=lNNp2NEFpKHBD86khNLJYUqvXxc+BcYDhvyGJpFHt0EHpO3H4ojdjKzAobz4Y23VYnVwy/hgUxKwtDwX6aukvC9l69fXCf8mtKDcCThW1Z9B/Zpyu1Oz+zGgv5oSx2Sy3Yv6SFTQPZa8t1POtNz2F9lKuaH2yRfMOytcgcmDieFIYl4hzAZGFLjaymxQvIjOJ1zFh3DlbT1JAIAYWeEFfHCj7qbLYPoqHjcvFpbn8yzR4R3h9tqjk+f2i81lddXp6FnuHvDjRF1+ltjj3dBpdIBJOelUGX4IRJfYCL69lMCdMv4eYnoyMKO9WI3OLekygdkUvrU0RxrClyzJLkOuwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfyTKzE9H+ZVGFH8WyuS4e59qdz5f8vx9ga+sokDxaw=;
 b=hDfcpPBQUlkDps+HswOEt6696LpBV8L0sVAvWyFq6bH8cBwqtbesq8m9CDklqpmqNXHux3apzapPABjYLlJi69kn8zTj2zvjuF0C83JR2hyYnubLLATFtsyJ0w8FFXuaW/vn5aZ7zBjdV/1ygJ1rgAL5tB8JRFqUr79q7WQWHB8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 LV2PR12MB6015.namprd12.prod.outlook.com (2603:10b6:408:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 12:13:48 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%7]) with mapi id 15.20.6043.023; Fri, 27 Jan 2023
 12:13:48 +0000
Message-ID: <c2716284-a8f2-9494-e130-cbda2a1dccfb@amd.com>
Date:   Fri, 27 Jan 2023 23:13:38 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, joro@8bytes.org
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0116.ausprd01.prod.outlook.com
 (2603:10c6:10:1::32) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|LV2PR12MB6015:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c2bf0c3-c85a-48c9-ff50-08db005ff1c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xqvxlUPgNEd2Dfvewfr3u7hXSEUZWQk7+Y5XHHpSQ0wASlZhbb7c/za20WRt8X6IPxZFjOptQCaGExtPhYOLWvLmR7cJbi+Cy7SWToXGAnswOQPk6F5hwe8iL7R6p9fHBbcWppvncUlcYDMrRHvbJxPqGx1rf19Th7ED1kAA2R7HTa8aig2kB1aiXqozPXywg2t4qB3eeykjYHB2951M3GQ5xTr3bJQ65LPSVop8ctPzzjONEmRRwOJK5qOYrtQ2shHFoBLsp1RBkqIT+ZtOQmJ4GsCiCUkXJAmrGaEgT4KPRmeAzwsfaLsLwezGotqSWpv+Ce47MbzRoxx6GvzbphQ+GODK3I9M1ANU82/qqvCYbipKH9A7BWov1yoPLYTWh7uNgf0r4Zdlvd4R3O8sMZ6ICpqG+z2YrQfbYyzAi/2uRf9vDNvQnu80PbkQ8GJz7rIfpbrOFtobd7Y0QDzK8UGmwpYKLPURjJpRfhS3JT+TXy1EiYpmKAU1gPAP7vh/F08OwAoxFTiRTXZFc2/oH5Z+oTxC5ZtF8PwYzznIq1uKvc3Y2wF4yR1DPz+8yOiJx/ii5a3ONVYU/g8FK5WHsQjaYFBojsopju1Uxa9Ty3xUcM/bHQt2lvjAOgwKssxakJ2kWi55qSd64ObtXpbQFxhkKLfrGkOeiiOS2ErNa8cw7RASS8L1qaMaCJ7klntiUyJ8iPpsWexwRdWuzQ7FoUUY/B6VBuMF/GUa4kG6XPo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199018)(66899018)(83380400001)(31686004)(36756003)(316002)(45080400002)(38100700002)(5660300002)(7416002)(19627235002)(54906003)(2616005)(31696002)(53546011)(186003)(26005)(6512007)(6486002)(478600001)(2906002)(6916009)(8676002)(4326008)(66476007)(66946007)(8936002)(66556008)(6666004)(6506007)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUZaMHNGTlR5RFo3NHErcUVGclZBenRTbjNGa0ZYT3E5bFFZMGF6bkI2WEJ0?=
 =?utf-8?B?Nk81QzZCczBHYWFaOUFncjI2YTZqbkhueCtETU4xL3JOVUFyYkE3RDNkWHdK?=
 =?utf-8?B?eWh6UUVVNUdpWkNUZWhnOXA1VjNleUFVVWdKUlYwZUFGVVFQRFhIclFPZkNQ?=
 =?utf-8?B?RVMrZVRUeVZiT2JHc1JSN01PbGVMeXFjSXMzSkhtNlVwR3NTSnZudTlEYTU2?=
 =?utf-8?B?VTVMZjdpQXJycjJhdncvUGlheXJncUlmQk1NQnQ0b21zSE1GMUw1L1I0dWFh?=
 =?utf-8?B?c0JjMEgycEgwOWsrUXU0L3RhcUlBbWMzVjBLOEFMOHVwT0Rjc2ltNGJGTURl?=
 =?utf-8?B?b0hXRHpodlNxZTR2NmVIU204Rm1QdnNXeFl4a00xcWRZS2lPY3N4Sks1eHNw?=
 =?utf-8?B?Qi9uZnVkRStXY3RlNUpNSHcrY0hZWEduQ29kV1BCQ3lDK2w0UmdXK0FMeExk?=
 =?utf-8?B?VThmUDdyOHlDTmQ4bytUb3REZ0VXbE5qalFWTHBPZlovRDBIblZJeEdhd1dQ?=
 =?utf-8?B?enJoWCtJMlp1d2ZSSWorNWpkakpVOVZXck85T0c3Ly9iTUtvZWZ3MGNncFdu?=
 =?utf-8?B?OE15cGpqdUI5bjRVbmVXREFPTHFFME5JSlJQYnI0WmkzTHR6YTlkeENxeVI4?=
 =?utf-8?B?UXh3bmhPaFU5LzJ3TnlQNlBsQkpzcGtWWmN6NGJaRlRUaXNYM0l2Q0s4R0sr?=
 =?utf-8?B?b0dycHljNE50TXpINVltMktzNWRaNjVBNU54eEFFS0NJUUFjMk9YVTFzNzhB?=
 =?utf-8?B?MGEyWlRmWGFaM0V1VUE0MHR5ZjhqN3VUZk9UbDNCWkVvN2ZoMzY4M0tuT2NB?=
 =?utf-8?B?Tk56M2R1WHlXaW9Gb1pjeEFSRm11aGxaU1JUeXdKVDlLUnkwc3czVU9XRE5m?=
 =?utf-8?B?UUIvNHFUSkxUZ0JJL0NpY1NMSkxpd2YrUE5TYUdWZURRbGNSL1hDOWo3U01I?=
 =?utf-8?B?U2pvdmZWMU1BNnBZU1kvbk1VcjI2Yk5PYzFXclpReUZjaDBTd1BJUncrcVNP?=
 =?utf-8?B?bm9CNHV3dnZIVUsxdEc1bHdTdHdBcTBiVXhMemZ4ODJVZ2IvT3huaFZhcG8w?=
 =?utf-8?B?SEFNSzVXWS9oek5uYmhCZDRTalFsUGNDVk5SOW16eFBGd0RRK3EzOXVmNElk?=
 =?utf-8?B?SHV4SEJkKzlVdk5QdytmTmhMeDlvZWdTTDRURGdWNmg0cTV5RFo0SGNWMWJp?=
 =?utf-8?B?T1RTZHF4Sk9MYnJNdzVjUE8zektoRW1Sc3JJYXN3KzVkb2lKa3JZc1MxZUNY?=
 =?utf-8?B?dG9rT2p4NU8zbVhGZmZWZUdLSVhkay9oNUZEaUZ2a0NTK3hGb0lRLzZ5LzlG?=
 =?utf-8?B?ZmR6V1puVFZxNkhlemp1OW5xbERFRGtPdVN4bFl1SzNMUDJUaGYxem9Oek1l?=
 =?utf-8?B?M1Z1eHg3OVpjMWxNT2hKNGpEdFkyVmNOVFk1NmhKUmVMVEI4bko3eHJQb3Zl?=
 =?utf-8?B?MjBZSHRZeVBVeitGZ1pBTnlmOWRNa2hPRGM3cW40TEl6Sko5WjFXYkVDU21Y?=
 =?utf-8?B?ZmNqTFFyN0xqYVMyMjRkRDNlMFptY3lUTU5aMHhWaVl4OTBKcXZTODVRZkhm?=
 =?utf-8?B?MTgxdVk1THQ1VWI0eDNwWTZuWnZpUDZJWnZVT3JJUmoydTkwaXZRQVl0RnFB?=
 =?utf-8?B?UVVmdHNtV3FWVE1DbnhHeWZQQWh6aksxdWV5ZE1CVlVKRi9FUmk1UXV5Q3RT?=
 =?utf-8?B?WkhyVjZlbUlQa2ZPc0x4WGRocnhEZUxPRTBUVktySWFGWHZjS0dPWDRFWHRl?=
 =?utf-8?B?aWJoRXBQeFJkWktJNDNmQ3k1S20zWmJLY00xQjNnNFJ5YnFQc3ZDYnVoNnYz?=
 =?utf-8?B?QVZzb1RrK3gzR0xkcy9RYUtiMC9tbE0vTUl2a0xLWVBYVWFtbFNxVUswdGQ4?=
 =?utf-8?B?dUZTb01ubFpCZnJKdktzd2dmRy9WUUR0N1g2MWhXYzUzQVVYMVZlMENYazVY?=
 =?utf-8?B?eFo0QWxOb1ZySWNvVDM5QXJ6dzhCMUkvSFJYem9vdHhOYW9VbVBqeGZlQUlu?=
 =?utf-8?B?UjJMelBvY1UzZGNXaHpiVW1yOWRReVRBUUxpMGJwL3ZmWGtIbUpxUEw1MlBo?=
 =?utf-8?B?N1l2K1QvWVJOTHdZZ21KeVVVRTNoZkJyOENsSW95OFNEQVlVZDA0RUpJQ2VR?=
 =?utf-8?Q?LJtOuAuAK9Z7luJh1HIiFrQLR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2bf0c3-c85a-48c9-ff50-08db005ff1c8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 12:13:48.2681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Xe0aYs2UcMwwnSkyM+SMDDyrZOTxDY0xeiUwW7GHdkn3zQHufwu/8nnFRu8UNlicF6Q+mKpqFWzsrZJSMxQxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6015
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/1/23 20:08, Peter Zijlstra wrote:
> On Fri, Jan 27, 2023 at 02:56:16PM +1100, Alexey Kardashevskiy wrote:
>> AMD SEV-ES guest kernels compiled without CONFIG_PARAVIRT crash when
>> "perf" executes. "./perf record sleep 20" is an example.
>>
>> Some debugging revealed this happens when CONFIG_PARAVIRT_XXL is not
>> defined. The problem seems to be that between DEFINE_IDTENTRY_RAW(exc_nmi)
>> and actual reading of DB7 (which in turn causes #VC) every function is
>> inlined
> 
> Very much on purpose.
> 
>> and no stack frame is created (?).
> 
> Silly compilers ;-) I think you can force it to by using inline asm with
> a rsp dependency or somesuch.
> 
>> Replacing __always_inline with
>> noinline in  local_db_save() or native_get_debugreg() fixes the problem.
> 
> It will create others.
> 
>> Why is this crash happening and how to fix that? I am still reading
>> the assembly but was hoping for a shortcut here :) Thanks,
> 
> Welcome to the wonderful shit show that is x86 exceptions :/
> 
> I thought sev_es_*() is supposed to fix this. Joerg, any clue?
> 
>> aik-Standard-PC-i440FX-PIIX-1996 login: [A[   15.775303] BUG: NMI stack guard page was hit at 0000000003983d50 (stack is 000000007feb1fa4..00000000574369c2)
>> [   15.775314] stack guard page: 0000 [#1] PREEMPT SMP NOPTI
>> [   15.775316] CPU: 0 PID: 790 Comm: sleep Not tainted 6.2.0-rc4_aik-debugswap_ruby-954bhost #73
>> [   15.775322] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown unknown
>> [   15.775323] RIP: 0010:error_entry+0x17/0x140
>> [   15.775326] Code: f8 e9 98 fd ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 56 48 8b 74 24 08 48 89 7c 24 08 52 51 50 41 50 41 51 41 52 41 53 53 <55> 41 54 41 55 41 56 41 57 56 31 f6 31 d2 31 c9 45 31 c0 45 31 c9
>> [   15.775328] RSP: 0000:fffffe2446b2b000 EFLAGS: 00010097
>> [   15.775332] RAX: fffffe2446b2b0a8 RBX: 0000000000000000 RCX: ffffffffb3a00fed
>> [   15.775333] RDX: 0000000000000000 RSI: ffffffffb3a00b69 RDI: fffffe2446b2b0a8
>> [   15.775336] RBP: fffffe2446b2b0a8 R08: 0000000000000000 R09: 0000000000000000
>> [   15.775337] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>> [   15.775338] R13: 0000000000000000 R14: 000000000002dd80 R15: 0000000000000000
>> [   15.775339] FS:  0000000000000000(0000) GS:ffff94b17dc00000(0000) knlGS:ffff94b17dc00000
>> [   15.775340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   15.775341] CR2: fffffe2446b2aff8 CR3: 00080000167b8000 CR4: 00000000003506f0
>> [   15.775342] Call Trace:
>> [   15.775352]  <NMI>
> 
> <snip>
> 
>> [   15.775495]  ? asm_exc_page_fault+0x22/0x30
>> [   15.775496]  ? restore_regs_and_return_to_kernel+0x22/0x22
>> [   15.775497]  ? exc_page_fault+0x11/0x120
>> [   15.775499]  ? asm_exc_page_fault+0x22/0x30
>> [   15.775500]  ? check_preemption_disabled+0x8/0xe0
>> [   15.775502]  ? __sev_es_ist_enter+0x13/0x100
>> [   15.775503]  ? exc_nmi+0x10e/0x150
>> [   15.775505]  ? end_repeat_nmi+0x16/0x67
>> [   15.775506]  ? asm_exc_double_fault+0x30/0x30
>> [   15.775507]  ? asm_exc_double_fault+0x30/0x30
>> [   15.775508]  ? asm_exc_double_fault+0x30/0x30
>> [   15.775509]  </NMI>
>> [   15.775509]  <#VC>
>> [   15.775510]  ? __show_regs.cold+0x18e/0x23d
>> [   15.775511]  </#VC>
>> [   15.775511]  <#DF>
>> [   15.775512]  ? __die_body.cold+0x1a/0x1f
>> [   15.775513]  ? die+0x26/0x40
>> [   15.775517]  ? handle_stack_overflow+0x44/0x60
>> [   15.775518]  ? exc_double_fault+0x14b/0x180
>> [   15.775519]  ? asm_exc_double_fault+0x1f/0x30
>> [   15.775520]  ? restore_regs_and_return_to_kernel+0x22/0x22
>> [   15.775521]  ? asm_exc_page_fault+0x9/0x30
>> [   15.775522]  ? error_entry+0x17/0x140
>> [   15.775523]  </#DF>
>> [   15.775523] WARNING: stack recursion on stack type 6
>> [   15.775524] Modules linked in: msr efivarfs
>> [   15.837935] ---[ end trace 0000000000000000 ]---
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   arch/x86/include/asm/debugreg.h | 29 ++++++++++++++++++++
>>   arch/x86/kernel/nmi.c           |  2 +-
>>   2 files changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
>> index b049d950612f..396e2ea114dc 100644
>> --- a/arch/x86/include/asm/debugreg.h
>> +++ b/arch/x86/include/asm/debugreg.h
>> @@ -125,6 +125,35 @@ static __always_inline void local_db_restore(unsigned long dr7)
>>   		set_debugreg(dr7, 7);
>>   }
>>   
>> +/* noinline here inline __always_inline'd native_get_debugreg(int regno) */
>> +static noinline unsigned long native_get_debugreg7(void)
>> +{
>> +	unsigned long dr7;
>> +	asm("mov %%db7, %0" :"=r" (dr7));
>> +	return dr7;
>> +}
>> +
>> +static __always_inline unsigned long local_db_save_exc_nmi(void)
>> +{
>> +	unsigned long dr7;
>> +
>> +	if (static_cpu_has(X86_FEATURE_HYPERVISOR) && !hw_breakpoint_active())
>> +		return 0;
>> +
>> +	dr7 = native_get_debugreg7();
>> +	dr7 &= ~0x400; /* architecturally set bit */
>> +	if (dr7)
>> +		set_debugreg(0, 7);
>> +	/*
>> +	 * Ensure the compiler doesn't lower the above statements into
>> +	 * the critical section; disabling breakpoints late would not
>> +	 * be good.
>> +	 */
>> +	barrier();
>> +
>> +	return dr7;
>> +}
> 
> This is broken, and building with DEBUG_ENTRY=y would've told you.


Huh, good to know. Is this it telling me so?

vmlinux.o: warning: objtool: exc_nmi+0x73: call to 
native_get_debugreg7() leaves .noinstr.text section



>> +
>>   #ifdef CONFIG_CPU_SUP_AMD
>>   extern void set_dr_addr_mask(unsigned long mask, int dr);
>>   #else
>> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
>> index cec0bfa3bc04..400b5b6b74f6 100644
>> --- a/arch/x86/kernel/nmi.c
>> +++ b/arch/x86/kernel/nmi.c
>> @@ -503,7 +503,7 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
>>   	 */
>>   	sev_es_ist_enter(regs);
>>   
>> -	this_cpu_write(nmi_dr7, local_db_save());
>> +	this_cpu_write(nmi_dr7, local_db_save_exc_nmi());
>>   
>>   	irq_state = irqentry_nmi_enter(regs);
> 
> So what I don't get is why sev_es_ist_enter() doesn't cause us to make a
> stack frame, that has an actual call in it (although admittedly
> conditional).

Is not the frame gone when sev_es_ist_enter() (which does not get 
inlined as per objdump's "ffffffff81bd4550 <__sev_es_ist_enter>:
") returned?



-- 
Alexey
