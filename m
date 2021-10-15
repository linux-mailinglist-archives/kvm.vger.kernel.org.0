Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD9D42F7C3
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241129AbhJOQNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:13:37 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:36321
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236325AbhJOQNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 12:13:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBS8pBDsLU+B85pqtY9W/4XVaowiUxDpEVT24VQerAzh0vYNxonOWtuBs6rjlptWWii7qWKcU71/2o6tueEp0zrs8Ntoavptuwju2nvspdYYDJzxAOD67lyjyFPFQ1Y5IDk5EQpZW6UJeNzmDU1DXgUaTH0ij/F+BH0r1UUHZe0yaH87OjQJymEYTEbfDl0jDNlZye6SuPTHmhj96l2MEe2nR7QZhwvpR6JqI1KyX185Et68ud83tTzoZZXUc4JSkmPAfr0lGOR1oqeeg1Q+8YpVnA4Pv8HBU7ScqWhVSN2efqQJjV1Rtw8L0Omh08pVv7InasI3vP7eGcA+8UWukw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uq7/NuFf/d3yzPcuywje+WYhSpMHuIZV/SFp2je7/D4=;
 b=j1wO00n5jefo5iO2G8qX40JgDg8qwItuCDDDS2ddNBzY5SocRhlxDKUralqSxmnuoetdoFsRZeCQ5tBRZSnoFNLZUgVxMqxr1U7DnZLo7IJIypMfjVqmAvxTEMNyS8KTXtgSswWJYFUVZOWCj9aU5X3Cq0EJnMqwy+IL/Qyk2bi1Sjwr8nKwkfNM1N6bCYjG3BpYQz42nlJ2fsyQRFwo6K2+MhFpO9Ia505BJC7/mG4lt0mRi9ZP9I6QWVMePLWfU2Z8W3VP5O9gyim3kO7Ax5JTsfMy0mIN3f7i3KfWMKn9mDyrv7PrS46sp3GBmO4SUM3Mh2kO6CJFLzcCarGQkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uq7/NuFf/d3yzPcuywje+WYhSpMHuIZV/SFp2je7/D4=;
 b=QatLbzyuoP50zvOx1jYsOwBFD/956qhsh9qSDWeNWGudfs0gkXY9tP3xD7LosxCyJVphBySVXm7kInqzk3dQzWJXOEVqUtxKSz2pGKm99l4TQwPFwphKqINkWOOWJxw9uSj3Nw6FrgvqLfUu9VLWb086G3+XKfua+pxuK6///yA=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 16:11:27 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.032; Fri, 15 Oct 2021
 16:11:27 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 34/45] KVM: SVM: Do not use long-lived GHCB map
 while setting scratch area
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-35-brijesh.singh@amd.com> <YWdNisk78f5BVNv3@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <fb6e3800-7eaf-868d-365a-9b76665bd06c@amd.com>
Date:   Fri, 15 Oct 2021 11:11:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YWdNisk78f5BVNv3@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: BN8PR15CA0042.namprd15.prod.outlook.com
 (2603:10b6:408:80::19) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.84.11) by BN8PR15CA0042.namprd15.prod.outlook.com (2603:10b6:408:80::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 16:11:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de844917-7623-4dd9-23b9-08d98ff67152
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45579111F4019847C5A8E1C1E5B99@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qe/eFl6NFBBLPOhVrjOPfmFuHt9VidYbwb9GpUjEuNMkbG+FayYA8PIn32IKUoshfBu2TG7jzPHqy2rS/uYHQ1AWQl8YlBhC/JeVOjBQOa8xoiNiJ6WzbiA2BUE0mN3+rcfm9mnvbDCAdNp6lndEkvYa0H0Y7rK6y9Zc9KQ0Wr+X8gBPDFo9Nf5tzF+9MFt18dE6hTo2iGkhXrOrduIuw6IbyLJf6PTIuTcZoH4kWL1gym11gYThv0cVnLmLBwjqeik3AlTw1DAv3BtC/EPhRzhZ5FC691DQJQBEufhw2EC67aOjkh3a0RlXKvwWSDxhpaMz8xp3SZbFVE5wOUHXoN9aCERhfOlKplnSUCFjNrT9Zp6+g7ECoFoItgqm5u3qB1iPr+Sa3Q3tyzJqD3Q5nDQYsD/nzxcjps3OAJ4VKfGI4WnERW+iPSS6vKyDn6cO0nUhXlOFQpBKB7k8utVzR95VPUEVdlWfdgydBV5U/oO/EDhEGxU6CzRTBHGiR10dcRfeZ2lk6gd9KgIf9Xg46bN/XhTqZubQIhYwu6dyC8ELRekHQRh7PYs8Gw8hHQ3pDISxr3E1buW8Se6XZEcX9Wo8aTiGKkOfa1RwBiXTXomsf1S+L2uG2JEO98cJbkW1iWDdpXg95DIez0J0PR/OY5K1AUDEmiPZqVVEm2bQJ5LnZXDPZiBAk0L1oqOhNSUbWdMpe1335eP2MRaboG+bj7d4ZIg9mJJlfmMM+sfVEPSw0HMgnL0r4BeKAMkR4lEP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7406005)(83380400001)(31696002)(7416002)(4326008)(508600001)(6916009)(54906003)(6512007)(86362001)(26005)(44832011)(6486002)(31686004)(53546011)(8936002)(5660300002)(66556008)(956004)(66476007)(6666004)(66946007)(2616005)(8676002)(316002)(38100700002)(36756003)(2906002)(186003)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVFLY0xaTGZxS2lRQVNSQ0VaRHBKV1RlL3dRMUZWVTFOV3lLNUlvVzVwYTVW?=
 =?utf-8?B?WTR1V3FMUmJGait0a3A0WkdMT0hSblB4amk2UXI3NWdoSnp1VkJWUFdEZlMw?=
 =?utf-8?B?QlVnODJjMGY3a2xmQU9mbE9rY2ZIUHBqeGhqcXVHUkZkSzNrRHlMcmVhdDVG?=
 =?utf-8?B?dUM4RDl3OXppdlhCSURLSW55ZmxaKzBpSGRHbDBsZ2p0NTMySzltSWRSUUc4?=
 =?utf-8?B?bUR1YkxCYWVIRXJSNEJLYXBrQ1pRbXZpRzZmYkZYa2tIS05COUJXU0FZQXJU?=
 =?utf-8?B?RFRvbkRTaVU2Tzd6bXlzMHJwV2NLZ1hSRUxiYUpGTmtJVmJjS2JuV3c1TnUr?=
 =?utf-8?B?UjgrVS9iUXJYamI5b3VlbWdxanJJclRHaVV6amwyMHF2clIzbVh3RXAzMHdk?=
 =?utf-8?B?UHhrWEVETko2clI3YTBMOUJBeUZxeFRWem51bCtxR2cxdEJJUlZnbkFLVml3?=
 =?utf-8?B?WDNsQ0Zwc3hYSStkMUhqODdwQlJmYzVQY2xlZE5LemwyMkFvVS9aNnl4ZEcw?=
 =?utf-8?B?UVI3bXF6cGUwK21MY21NSFM2ck1oTWpZU3hHSFR1VG5HN1lzdWxaWWtxcXlE?=
 =?utf-8?B?Uk0zd2pPY3dDOXlibWEyZ2pNd01sT0JUd3FzQ2ZiTklyMy9ZYWZiSFZPL2FN?=
 =?utf-8?B?cFpna256SXE0cU9xSWV4WG5MTnJLVFpMbzZFT2R5elpyYndWN2tyZnlIcDFL?=
 =?utf-8?B?d3NBcWtBcFlWeUxOMFJ5eXdWYXpMeWQ5czNiSzA0ZmJLd1d6WjZWcDlhMlZM?=
 =?utf-8?B?UzN0VFZkVXdlcmF1R1ZoTzlLdEdLMFkvTUhOWVpWb2xOZkZZTVhTd1RGZHRh?=
 =?utf-8?B?dXZra0ozL0NFNzI4bXo2VFg4T3ZzcDlHdTFvdTFvMExzcE9FVTN5L0FkbjN2?=
 =?utf-8?B?ZFlLNDJUd3FJOFh4ZC9RQkpaMEtTQS9kRFA2cWN0RFo1K1RiTEN1SVMrVmxl?=
 =?utf-8?B?bDBiSDd3TTFOQzhveGFrOVF6Tk85UjNLMVhGNzZUOTJXeS90MlFtNDVwMWtS?=
 =?utf-8?B?TDcrMnQrVTAwS0g0a2JiY055QlR2QnVCU3J5VDFaYW5uWS9Ua0pzaVVNazRU?=
 =?utf-8?B?WGR3MFY3bDN2UTFwMlNadmFGdm1hTEltSkdORVRqOFhiSVFxVURQa1BpRGEw?=
 =?utf-8?B?Tm5WUzNHSzRtaVprZG84MEF0clkxcm1iRVlqajNQWk1LbEQ5QXptTTBPQnN6?=
 =?utf-8?B?Ky8xTUhoNGNaMzZwRVdKSWlKcytkS05HYU5FNzZoV2VoKzFkM2Y4eUdKaTNU?=
 =?utf-8?B?eEJQVE1UdkloNmRMeXNxRTRDZGVzMWlXT2dtcGpyK1FSUTFXSFJwR0lMenpw?=
 =?utf-8?B?TncweWczcDZVc1F4SjNyeW1VQUlWZzhLZmkvRjljbHFiTDMzWFdyOGdacWty?=
 =?utf-8?B?anhBYkhPbGU3OThCc2IrczJxcEF5YUZuUExUcUJJdVhYRDJpeFBUWFZZVk52?=
 =?utf-8?B?MzAvVjNaWTdsazdVMGdLNjZPbmhPR3ZlbUJZZENiRURNQWNIZGZRRkU4ajUw?=
 =?utf-8?B?UXY1ZG83RzRKUlZCMk9rYXhhSHdPM1JhQlk3ZFhzcy9mMzNicnlTMFNydW1V?=
 =?utf-8?B?RHJrSDcwZG03dTVCV20vRU5JY0NzMzdNWlAvU2lVUDNUcEJTd01ZNklqLzVY?=
 =?utf-8?B?am9jNnZacUZ5RmVxMmRmY1FXV3ltR3JYWjVqV04xY1ZncFdKaFhJdjdjbXRJ?=
 =?utf-8?B?eUFBdDlqM0VSRVVRakxZaTluekhqdnhXVWhES1JaWXhSUmhYankrS2Q3aWJV?=
 =?utf-8?Q?QriKnxLN/8KRSREHcZ3alWpRmC056+16aU9zUBy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de844917-7623-4dd9-23b9-08d98ff67152
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 16:11:27.7410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rTxsPtNLoGEsMPsvv/aUjWY/3jZnJYWqqKz2NNQyvBFViPJuYsLKxOmTyAuZcpjd1GtksVUN7EMEvM0OD2IZYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/13/21 2:20 PM, Sean Christopherson wrote:
> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>> The setup_vmgexit_scratch() function may rely on a long-lived GHCB
>> mapping if the GHCB shared buffer area was used for the scratch area.
>> In preparation for eliminating the long-lived GHCB mapping, always
>> allocate a buffer for the scratch area so it can be accessed without
>> the GHCB mapping.
> Would it make sense to post this patch and the next (Remove the long-lived GHCB
> host map) in a separate mini-series?  It's needed for SNP, but AFAICT there's
> nothing that depends on SNP.  Getting this merged ahead of time would reduce the
> size of the SNP series by a smidge.

While testing with random configs, I am seeing some might_sleep() warns.
This is happening mainly because during the vmrun the GHCB is accessed
with preempt disabled. The kvm_vcpu_map() -> kmap() reports the warning.
I am leaning towards creating a cache on the vmgexit and use that cache
instead of the doing a kmap() on every access. Does that sound okay to you ?

-Brijesh

