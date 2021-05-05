Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97853748F1
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 21:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhEET4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 15:56:52 -0400
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:64992
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230437AbhEET4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 15:56:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7pI1/MEo8nRYa/1AJ6LlB73p83elML1Xdb1E1KM/QNlN5KjwBS0nrFKRwGdwtq+/NFq/mQWbEi3oEyX1mUBP89kuponmWpYJofYV2mr+1AKbUNa4wXyL062mxyAPgufhwFjGISxeEuVWnN4Gutz+JOyKOiKcozhumVKMoh4EvAeIhkAIA99m5Gk4KHzQUFRGBV2kbHBemEMKt8xCYlYEA7Qg/HFI1LA+Wr75WBCHvpXVcI69j/nGFWVb6Osp+YsFp2YXfKXDTjeu4C49B4owFC98Op1lF5ymEEnddD9NQZ3FOQoxc8i5pGqkNP32r+oBuSqGZP8CJb//9zpejSWaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jf7dMnLAhAvOoyvn3VAI5mAjKpw1QbLDxRURKvMsyJE=;
 b=NTDdn4Drllcsk/klc2ETg/n8PRBYLaU57oXi46Rp1CFefaNCJ/kk/lR012VuO34T+KIkNQPMV2kkuKOY4jn8396/KLKJIfvhixQC8LW69QuYLoBZSPkzpPGVgcXasLWpUDfLRA1V7qhxSrSMoCCIwWtkdBAuEtSH1NvQbfPT18lvkZXxxri6ZXuIUuHjP7XNzFuGNzTHlNdfLXufvsB1DbKfDWwCQnjM4gPv05Z/UkqaTxLb9IChjj3HSQrH/ilBKSlTMuhAvrOUQj3x+P+eCJmEBH+7UZOT0CImWDzlcZ5hBNm0hZQqZ6LXhZAapgCBLSqssBy6B2v+w09BEndqtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jf7dMnLAhAvOoyvn3VAI5mAjKpw1QbLDxRURKvMsyJE=;
 b=LN2W5JU/BgPmGvadNtM1inEfI6hDOryeiJXmDSRV/4pQtMGgT0T+Wj4tZOEE3jw6iIMJdToI7qaiPoGoZZs69ai+WyA9Zxrd1PJrg9ZB9PQpsyd+TeOWEYg3fXmnw4rwdOJJnBg5IKchVcxTU7qXEE3oxAfseNWGgF1PA0IV8v0=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1353.namprd12.prod.outlook.com (2603:10b6:3:76::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.40; Wed, 5 May 2021 19:55:52 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4087.044; Wed, 5 May 2021
 19:55:52 +0000
Subject: Re: SRCU dereference check warning with SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>
References: <601f1278-17dd-7124-f328-b865447ca160@amd.com>
 <c65e06ed-2bd8-cac9-a933-0117c99fc856@redhat.com>
 <9bbc82fa-9560-185c-7780-052a3ee963b9@amd.com>
 <a6bf7668-f217-4217-501a-f9a12a41beb3@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <1d0ddadc-6a98-2564-aa78-cf8fa2113a28@amd.com>
Date:   Wed, 5 May 2021 14:55:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <a6bf7668-f217-4217-501a-f9a12a41beb3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0047.namprd05.prod.outlook.com
 (2603:10b6:803:41::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN4PR0501CA0047.namprd05.prod.outlook.com (2603:10b6:803:41::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Wed, 5 May 2021 19:55:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7c04459-c468-4c17-3a7d-08d90fffc990
X-MS-TrafficTypeDiagnostic: DM5PR12MB1353:
X-Microsoft-Antispam-PRVS: <DM5PR12MB135391907A811F55FDA5EB0BEC599@DM5PR12MB1353.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b7ERQWKQfzWYl/IwsZw8urZTGHgZujmeXMT0NCA0kpDAEeJIY8SavCgwqBmYC2R2c2RAnKDovRMSjA16eVyi/PzzTRXTZq40gDAsIviH8WJocW35cRojp/BZ1IKpbEi4SH+IX6QQeMmYNBD0ccnFKn4vCgdlftkrhM49Olsz2oMopMXI3QviV0kkMgptVgZcs5JsbxFqAcgwVxcEaH6q70OwwqLoCnL6LAvJlGWyns8M+EV+CkzWNGCHFnxdKARqqBNgRKy2ISDq4e7e5nmnDYMUemkStekmMatb8Z+LEXjRIkU3crf+SgvQkAwLVW4xaLIePpSwHW+3tmkXfSMGo6aEKcsLgXM89oW+IeEVTZXMK4jUAUCZqRRjhWyFj8WsepnPCR4JRBGLnEmC0fJEKs6UPaYS060SfFIaWZ638gXPsfTQpb4oKmQFYXx8U8EsUch6m0+P+3bT5Futu5dx7Gsqux6SuGlA4Ppk3vvRp5SLMTlmErT617EFTFE01eHym4ffS+SKezf2KGK1sUVOijYG2A6zHbt11kBnIflJCq52Hb1bieMrURsshHv3zdAyJa98hbyiMAlMbanOd2Cl4Gx4XrVVTiK57FJ+IxhCf7cHfy/QjfAkpfv4KegBcM7YuS5krgUCGCWRPTH+f8juXeGsPqhlmPlQ1KmdGG/2oqg+FKBLZyISoOSNMITMbOnM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(38100700002)(31686004)(2906002)(316002)(4326008)(86362001)(8676002)(53546011)(26005)(16576012)(956004)(31696002)(16526019)(66476007)(66946007)(478600001)(83380400001)(5660300002)(6486002)(66556008)(8936002)(2616005)(36756003)(110136005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MjRjZDNXcG12RWlSanhMbEc2eTg2Nm50VGlTRWNwbmlPbXhPQlNTaVY1Y25p?=
 =?utf-8?B?QTljUzg3SmJzSDBCUTRzSzVzNmh1bWJ0T3VaNWdzaVJNZ0dkb3NrOE5mNExV?=
 =?utf-8?B?N2hGMlo2NnYvOEhKcnhMWTMrZlc4NDZrOWR1czM2RHJRZDM2U0NGRS9Ya2JK?=
 =?utf-8?B?eHhpTWNXRjYrVzBwaHM4NTRjbzBGVk05dTJwMW82Nkl3YXdEYTJnRHFDdlk5?=
 =?utf-8?B?MUJnOHZPcEVna0ZqTFNPZm1Nd2hnVGZRc3FnLy9FWVRxc0o3ZnpPdHlPbm1w?=
 =?utf-8?B?R0dvYzFjQ3VKVDlaKzdOOUdaZ3lRZFI0dGhrQWcxV1FBYzJqL3o3Vi8xV2wv?=
 =?utf-8?B?MzFQeENQbXIzVS9NMldVNE5jN3c4ZG55SFAzQm80UFUrWDduSTJoZGh2QzQy?=
 =?utf-8?B?czVjSUw5akx0cmVkKzFyWUVnT0k4cUdWR0tJYVNNclpMZ0ZKV3BnUGRaZnRN?=
 =?utf-8?B?N01kemZta3g2V0FydllPdUtVaVBzVjJxSVp6Q2VvbGUvQXkyNGhEbFgwNG8w?=
 =?utf-8?B?WHBqdEdvYzFIU1hIZ3JSNkNVNXNZVDdJTDhGL3NPalJycXN3MzhKRHN1NGJH?=
 =?utf-8?B?MzZiSmsya3BqTnNNWWZQbDU5N0xFWE1hUzJsMVE4VlJHQWJHb3RPYXBnYWVn?=
 =?utf-8?B?S1BPMjNaWTZTQnViWTFqb0NDQldNdWdhMXd3a0dneGVyeXk0bXRpbjlnOFVB?=
 =?utf-8?B?bUFkcGFaR0R3d0hLS3NLREVQUG5UdFRtQlh4TmdFTXdBWk8rRHhNeGN5LzQ5?=
 =?utf-8?B?L2N3MVVFTU9wTGM1aTlTMm1MMWFCcEFvZ3RMYm5VMDNkSzNON0JBdEhVY3RB?=
 =?utf-8?B?VlVxT3R3YkJmRnBkZXlCbDV1Z3lOVmE3dEpFNjh1SUFyOWh2VDdRYnB3TGY0?=
 =?utf-8?B?OXVUdUs1UmhqTmpXY1RCNHF6d3lvN3FoaEN3cCtiV2Z2c0JjR0Vrelhlc0xa?=
 =?utf-8?B?S1dRN2poeWt5eVBLN3MyN2QydXJIaE13SUNWRjNKMFJ1c0xKTXlrbFI2Z3lF?=
 =?utf-8?B?NGR3LzdxRnMrRXFlVnQyOElscVYrY2thaWFZbE1PNlYxdVVKS0lGZUpGcE00?=
 =?utf-8?B?TmFqK2NyZEZkcjY4TEFndHI3TExnTnc0am1MWXJsTmFBdFcvUGx1aW1zVE1k?=
 =?utf-8?B?V2MwU1F0UzFrNnZBclpkeGdoKzFNRktBSlNiOVd4UXFrMy9zUTlGeWs0VjA4?=
 =?utf-8?B?OW1iWVFQY1pmV2lLcjFpVGVEbFhBa29LbGVBQzFDUjdITmhUOWZtZFlGOFRh?=
 =?utf-8?B?SVFQUzZldlgrT0ZCOGwrSjFkbHhzaDZsVm1rdlpVVjhWZkJUYy9vWEVXUlBG?=
 =?utf-8?B?QkdYeWpKZjdYWTkvdld4Q241TnlWbHhWYTgzODFxTlRzcSswUjhMYXN4Y1JM?=
 =?utf-8?B?ZFZtZ0NobXJUQVhhTXVUR0o0MnFLZnRlL2psNExCR0RQMktta203TGkxUE10?=
 =?utf-8?B?enliQ2N5bXljWU5lbHhDZHBMNFlJYm5BUnB1SmdGa09lcDdyNVZXeStwUEY4?=
 =?utf-8?B?cFVFNTVuZmdxc0E2QmJPeWRsa256Qks0NXhYZ3poK2V5N1p4eXVyTVI3elFy?=
 =?utf-8?B?amlBSENFdVNnNVROK1dhUUkwcmlwWWc5RW9hSVg0blNxdEJmYThoUXJSb3dZ?=
 =?utf-8?B?Sm5VNGd2K3Y3M21zRXJiQkVYb0ZrbFlWNGtKZHk3SUtacnk4emszcFFOcXpH?=
 =?utf-8?B?bUZPM2tCUGpuNTBGNm1TbTN5MFpBbmIwUXBFd0J0Zm5mS0g0L1MxdFBRNURD?=
 =?utf-8?Q?r2M17iTE+brohdidBsKYl83zhR4e2w5/w9Fbq0/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c04459-c468-4c17-3a7d-08d90fffc990
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 19:55:52.3585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +BQUErbUfCQAagJPYEX15/JlGPOHkSyk1zCthKuaHKs6r6B3wCr3aOnQOvCHL1tWXQwhJoLtQU6/pd41UkhMSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1353
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/21 1:50 PM, Paolo Bonzini wrote:
> On 05/05/21 20:39, Tom Lendacky wrote:
>> On 5/5/21 11:16 AM, Paolo Bonzini wrote:
>>> On 05/05/21 16:01, Tom Lendacky wrote:
>>>> Boris noticed the below warning when running an SEV-ES guest with
>>>> CONFIG_PROVE_LOCKING=y.
>>>>
>>>> The SRCU lock is released before invoking the vCPU run op where the
>>>> SEV-ES
>>>> support will unmap the GHCB. Is the proper thing to do here to take the
>>>> SRCU lock around the call to kvm_vcpu_unmap() in this case? It does fix
>>>> the issue, but I just want to be sure that I shouldn't, instead, be
>>>> taking
>>>> the memslot lock:
>>>
>>> I would rather avoid having long-lived maps, as I am working on removing
>>> them from the Intel code.  However, it seems to me that the GHCB is almost
>>> not used after sev_handle_vmgexit returns?
>>
>> Except for as you pointed out below, things like MMIO and IO. Anything
>> that has to exit to userspace to complete will still need the GHCB mapped
>> when coming back into the kernel if the shared buffer area of the GHCB is
>> being used.
>>
>> Btw, what do you consider long lived maps?  Is having a map while context
>> switching back to userspace considered long lived? The GHCB will
>> (possibly) only be mapped on VMEXIT (VMGEXIT) and unmapped on the next
>> VMRUN for the vCPU. An AP reset hold could be a while, though.
> 
> Anything that cannot be unmapped in the same function that maps it,
> essentially.
> 
>>> 2) upon an AP reset hold exit, the above patch sets the EXITINFO2 field
>>> before the SIPI was received.  My understanding is that the processor will
>>> not see the value anyway until it resumes execution, and why would other
>>> vCPUs muck with the AP's GHCB.  But I'm not sure if it's okay.
>>
>> As long as the vCPU might not be woken up for any reason other than a
>> SIPI, you can get a way with this. But if it was to be woken up for some
>> other reason (an IPI for some reason?), then you wouldn't want the
>> non-zero value set in the GHCB in advance, because that might cause the
>> vCPU to exit the HLT loop it is in waiting for the actual SIPI.
> 
> Ok.  Then the best thing to do is to pull sev_es_pre_run to the
> prepare_guest_switch callback.

A quick test of this failed (VMRUN failure), let me see what is going on
and post back.

Thanks,
Tom

> 
> Paolo
> 
