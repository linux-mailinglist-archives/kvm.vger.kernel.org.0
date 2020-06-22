Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA734203E90
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 19:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgFVR5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 13:57:21 -0400
Received: from mail-dm6nam10on2089.outbound.protection.outlook.com ([40.107.93.89]:29284
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730046AbgFVR5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 13:57:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nROy3uuWG9v8yha7yVD3jjTCrzkfwuP4tdvHXSDeTnkpGfhyvBFFTUgY2Q4WM2WlODd9Yh41y4ngVdNOolkWbh5b2cfYiAgE+aGuR5QS1Tdh/dZvYMpLe/A1ZikbGtm70ItxglZYbnha+UowIouP5GOc3UFzLq/hBg37HG8z/ZH3/mRJ2ApCN8R1nRM/Q28LbPkiZwy0ZWqLKgoTVa3660EMBRUeL2pz3gYVl3oKpwxc/DBr32AVI/8VkTAYOrhe0atyZWedk8z0vvMTzH1thCIP/8bjghqNuEdSs3FjwguOi0J5XJAN0ejdfFnCcqg4oE6ubIb9o+U+nq9/tlCrJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c01qQEw4iFn1q/ZGA9HLaikJ/JHXHoIeuKezD4zmBHo=;
 b=AKM8TaBOguD557IALFtGz4Q/8KLnh7aGVvVpTY+Hqu96VGKyybTD5FcYmfPaOzI6zzD2AFuS1nue37yPU/1oiTAarOvXtTyMxkO1lWNLt9BOYM+R0Q3ucQAAjFAUUZpax/YwG0gs7XrdEwmQDvMCHlSv1hpRkqbh5xOSRves94pQR6lpyP0avqAC+5vmJm/VmBZZPIP//TLEz/qUd3wga7ohyxnmueanvUw9xu7u320SeNoKyZqUG4c8wMWhxHOED4+4oU1pkK3CqASv/0H1cUmT96DyDizkpwwtynZcdBx4GZ8e2UYE4kYFf/8UWfrtdqyQ4sIWtKMPNXr+tr087A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c01qQEw4iFn1q/ZGA9HLaikJ/JHXHoIeuKezD4zmBHo=;
 b=OKaJ5CgksivOikITAU3/X8uzrAVjFH7jlIjSNKkFevfJCnhJPCTjIcmliRRNz7yLqOk8gvLwY9Eo/Y08ZcjOhFiFoMCl1nJ7THkSRkvg7a5wxPJhH+7xTGY59hVyPQnMKyW0eH0Agq1v8sSJ8w+oeJTe6KkhL10mSpNDZbjpr3E=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0026.namprd12.prod.outlook.com (2603:10b6:4:52::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Mon, 22 Jun 2020 17:57:17 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3109.027; Mon, 22 Jun
 2020 17:57:17 +0000
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
 <0d1acded-93a4-c1fa-b8f8-cfca9e082cd1@amd.com>
 <40ac43a1-468f-24d5-fdbf-d012bdae49ed@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c89bda4a-2db9-6cb1-8b01-0a6e69694f43@amd.com>
Date:   Mon, 22 Jun 2020 12:57:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <40ac43a1-468f-24d5-fdbf-d012bdae49ed@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:5:177::23) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR02CA0046.namprd02.prod.outlook.com (2603:10b6:5:177::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 17:57:16 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ae1f2544-27df-4637-7734-08d816d5b3c4
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0026:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB00260FA7A232910EA3A0F3DDEC970@DM5PR1201MB0026.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HD/tKgCvzc/MNDTznGZwyD1F8GA4W6UZFBtmrjXlmAf4/S+WnQl6MlyusO+M3QbPY1d/IFbUfgvmflylz2ANO4pYuMKYRCBy2Wse7kpwNBXejhnqPgEx4SdMnf9MikHWusNzpmOJMYYTADpFOOCsrcMwz7xSGtLl7y13Ao2mnHnS9uO8fHfjo1/s4YoDr6sfUDq7K3+ZTVq9n/jGLjW72O6S02W147XOsF88kcd2oewiIU9TZnPYvcdtt+mHi7usBNOXF239zwHtj8YXjdxOsevpolVPI6behAGuz13blgUu6J6T96y2LeXnJa/Fwvum8GvvxI6LTnBN/maE6X+PbXH9Gpd9S74ErEPCDE+j568iyXtZhw52U/MfVsK20npl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(110136005)(66556008)(66476007)(66946007)(36756003)(16576012)(31696002)(316002)(52116002)(8936002)(4326008)(83380400001)(2906002)(8676002)(31686004)(5660300002)(6486002)(2616005)(956004)(16526019)(26005)(186003)(53546011)(86362001)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: j4SMMZ3mbkgL/VZ4b8QYXJcaK/oeavuq16IZT2VV7uh4AGsM0t4Je1VoUzHrTYNG5MXAWml5ugo/ImB0lNCzkP2h6oMjk4GDbXVRpC9ZBIAGGN8B24zE1t3cgBQNCR4rlfR2OPbzDgqdeJ92q9V0vM8TNFpSbHkWJwBjVfxOIzHN7JeLCsqY9/1ZeN8fF98HnxWWmcqTDfnXEfNp0JBJAI4j5qj2zwMXs9fLv8TH6LzGTAgA0lVJBBYu3e2c/I2Ur/zpPsna5I1KfORsi98NScI+nGlGQOKjYY2RBx2LjRmjLwCd0GFFRhgj/xSZRqgL9odxjwt0/3hvbfAbW7Jsgt+tnEfLHyaSSbdQYzDv0ktl1tOlY2EUA1DbSqyRxQsazx4Oayoq8Pf7cw5nlXoZ/lEUpl86CXdVETl2H9g4Q66mq+MAPPfMDbnL5Boyq5DGIXnIMlwWnrovIuaStA7q2ZBBXb7JUCx6YyvVl9gnEC8=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae1f2544-27df-4637-7734-08d816d5b3c4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 17:57:17.4446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mr2B2viO7s7SqFCO6QP0suTL9d7kBMO+26IEzxwViFHNexliHJhRUUSEf3BjeUJ2A9Py0bwgqd4CwIC6hkYsfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0026
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/20 12:03 PM, Paolo Bonzini wrote:
> On 22/06/20 18:33, Tom Lendacky wrote:
>> I'm not a big fan of trapping #PF for this. Can't this have a performance
>> impact on the guest? If I'm not mistaken, Qemu will default to TCG
>> physical address size (40-bits), unless told otherwise, causing #PF to now
>> be trapped. Maybe libvirt defaults to matching host/guest CPU MAXPHYADDR?
> 
> Yes, this is true.  We should change it similar to how we handle TSC
> frequency (and having support for guest MAXPHYADDR < host MAXPHYADDR is
> a prerequisite).
> 
>> In bare-metal, there's no guarantee a CPU will report all the faults in a
>> single PF error code. And because of race conditions, software can never
>> rely on that behavior. Whenever the OS thinks it has cured an error, it
>> must always be able to handle another #PF for the same access when it
>> retries because another processor could have modified the PTE in the
>> meantime.
> 
> I agree, but I don't understand the relation to this patch.  Can you
> explain?

I guess I'm trying to understand why RSVD has to be reported to the guest
on a #PF (vs an NPF) when there's no guarantee that it can receive that
error code today even when guest MAXPHYADDR == host MAXPHYADDR. That would
eliminate the need to trap #PF.

Thanks,
Tom

> 
>> What's the purpose of reporting RSVD in the error code in the
>> guest in regards to live migration?
>>
>>> - if the page is accessible to the guest according to the permissions in
>>> the page table, it will cause a #NPF.  Again, we need to trap it, check
>>> the guest physical address and inject a P|RSVD #PF if the guest physical
>>> address has any guest-reserved bits.
>>>
>>> The AMD specific issue happens in the second case.  By the time the NPF
>>> vmexit occurs, the accessed and/or dirty bits have been set and this
>>> should not have happened before the RSVD page fault that we want to
>>> inject.  On Intel processors, instead, EPT violations trigger before
>>> accessed and dirty bits are set.  I cannot find an explicit mention of
>>> the intended behavior in either the
>>> Intel SDM or the AMD APM.
>>
>> Section 15.25.6 of the AMD APM volume 2 talks about page faults (nested vs
>> guest) and fault ordering. It does talk about setting guest A/D bits
>> during the walk, before an #NPF is taken. I don't see any way around that
>> given a virtual MAXPHYADDR in the guest being less than the host MAXPHYADDR.
> 
> Right you are...  Then this behavior cannot be implemented on AMD.
> 
> Paolo
> 
