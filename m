Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716EB203CA0
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgFVQdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:33:44 -0400
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:6156
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729260AbgFVQdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 12:33:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkYNlH2Ax+7OyakCG5fFIQ6F+PYgKEhU5ODAPuRGrnAiEMYfd9rBYfBwYha494LNJRg16YzxK0zvOANfh4aoZjgLBBrU3KPY2uRCYA9DSbTMh2AXMmp3X3y57ZNbEugIysk2RFKWkbIWWga7kqmUteu0c/lq5DUGfL19ygjwD+yv87yvMXbSRuTWgl2NB8WDi1crmbuxN7jwrthdIoBxXII3tx27pvD5ZG5CsaWGtv2SnhP56lkhNmluU7CdcR8a19+p9Ip2k4vnlTguGLKp04iZ2lXgNS6NV4QVX/vc1IEMpCYNts5UR+GJ5A8sA3wpFXw5+OpMtJywibqnQjjyDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67xtkzweEK2fByNLSil1oE0reOULI84NJYkDRLU+/Bs=;
 b=aoMtpD26UOp7nAHj2ErdAzetAbkMcc8+t4wJJE7IzexhC+jNEH5plTPR6GcF4pJq/lbp5i9F9gAYSnesjRVxdXXKuMAgQespOnrnyU5NYc72mP63HZ0W3yEZ9PP03RB4tdUSHO/0jP8dw2EFfcbg0EOYZsfSokrz9lIrgecEh2S1ADa4HT54EiBMHlx4TkSsUo/dTkiW5v5p9FXEzvuW48Q8+m8o7ZzpZifI+6NneUt4dUw1w7fy7ObJhS0U3tsnndtL3WI1v8+znxKlJJvLcuQpneaiPOlWJlPNsw7aSy1zgWxMXxsowmVBJ1RUFNONlMv+WYZ1z9ulB4E74r1K6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67xtkzweEK2fByNLSil1oE0reOULI84NJYkDRLU+/Bs=;
 b=Z/LtiYV+SWnDdMudqSMennLCckeVN7gNsO3Mx05hhzMGFvHmUdKJWmzT6w48Y6Ph3NiQgGRDcs8XC9/HmpJJGPNrxf16tDSbZGYlINI6RSj95N038A48bQoM9yqCIwBgjooc1zOmsyYzxrKWxfJFyC/ZWMe31FR7eLb27i5MWlg=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4217.namprd12.prod.outlook.com (2603:10b6:5:219::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.21; Mon, 22 Jun 2020 16:33:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3109.027; Mon, 22 Jun
 2020 16:33:40 +0000
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0d1acded-93a4-c1fa-b8f8-cfca9e082cd1@amd.com>
Date:   Mon, 22 Jun 2020 11:33:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0024.namprd21.prod.outlook.com
 (2603:10b6:805:106::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN6PR2101CA0024.namprd21.prod.outlook.com (2603:10b6:805:106::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.2 via Frontend Transport; Mon, 22 Jun 2020 16:33:39 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c571b64-c2fa-4387-39bc-08d816ca058d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4217:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4217EE08A7FBCE45C32CB712EC970@DM6PR12MB4217.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tf5M1puvoZt1Uv2HUKPW+VoYlM1HHCfP/WOhSfyucdMJlmg1ytnQHJnoqxj7Y23WSz5NCIPN2fCYo7MReOrMSZyRQtJ1HRraA33VrjXyvPz4OmTp91EtKEqa3GW/S60bBhtJT+sL6UQSlkTdvCxZg3gnenM8zYiYlWQ2AR8WV7ILN9Jsy+cB9xYiYTQVsou9GY3iZe7tbRNgLyXjHK6HqRtM79FUQ1wEkU2rlpIAVY/869JkOlGTAfhak8MbRosgCrGfXcDC9Bht2rDlkJVGY9FQPoeydBzjWrQ1YCGoA8WGp4j58WhRDCw8ATCDBc+LvhuCFGsxK/wKjaJ2FR0zl5GUjZWY7fxIwJFrPdPSOGRW0vGv4Ygfq4lq1pWttc0O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(2906002)(5660300002)(110136005)(186003)(31696002)(316002)(16576012)(8676002)(86362001)(478600001)(31686004)(4326008)(36756003)(26005)(956004)(6486002)(52116002)(66556008)(66476007)(53546011)(66946007)(2616005)(8936002)(83380400001)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wp0jTt5uXNmbf5UiSQRGyCagYN5qz1FeefqYhxrNAbO4/bGtDpdD45uT40tDKWcX/+SqWrza2OV716XPY9XffJEeSas6OCZywoFGEVMJuLkarIa6uWI4fW3YWTS4i5fTsRPQxqSC0wRMU+3NHQFJlifGBbWitDhDwXiHz/rrXfGemDeVj9MVYAqpbr0MgZOm3YymKP9lCTL3uKjWCq9KQIqa5N4wd6UMpwYp6GfNHPZaANjXZPGKUfIgl1UdW9U0YZhw6uOy9a1cH49+vJsqqzQDmHIf8a8mWGy4gCFQh2EZi9wKJp/RocohVkAC/ER4dztbJ9yLInOv2OxELYSzLMfbXlbfxnHg7T12SaV34xz7EuqTNSM6odMk+VbtqRYyPz8yDjLqoYcrw7YrFwO2rPEGEuEIlbyRFwt7f+HqUV8Pyew3AANVlnpo6B4v/F6Y5WPI2h/TZcxeMBt3rd3MpRjIwIY6boCcoteCbIyjYnE=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c571b64-c2fa-4387-39bc-08d816ca058d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 16:33:40.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ac2J/8Yu/jXAYc+VuyitsyKiBf8PZSrYfTMuA8bhrOBu6h9UzhIG58BNDkV2rnyDzaj3i+j9Ju5yQzSZKBctrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4217
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/20 6:07 PM, Paolo Bonzini wrote:
> On 19/06/20 23:52, Tom Lendacky wrote:
>>> A more subtle issue is when the host MAXPHYADDR is larger than that
>>> of the guest. Page faults caused by reserved bits on the guest won't
>>> cause an EPT violation/NPF and hence we also check guest MAXPHYADDR
>>> and add PFERR_RSVD_MASK error code to the page fault if needed.
>>
>> I'm probably missing something here, but I'm confused by this
>> statement. Is this for a case where a page has been marked not
>> present and the guest has also set what it believes are reserved
>> bits? Then when the page is accessed, the guest sees a page fault
>> without the error code for reserved bits?
> 
> No, for non-present page there is no issue because there are no reserved
> bits in that case.  If the page is present and no reserved bits are set
> according to the host, however, there are two cases to consider:
> 
> - if the page is not accessible to the guest according to the
> permissions in the page table, it will cause a #PF.  We need to trap it
> and change the error code into P|RSVD if the guest physical address has
> any guest-reserved bits.

I'm not a big fan of trapping #PF for this. Can't this have a performance
impact on the guest? If I'm not mistaken, Qemu will default to TCG
physical address size (40-bits), unless told otherwise, causing #PF to now
be trapped. Maybe libvirt defaults to matching host/guest CPU MAXPHYADDR?

In bare-metal, there's no guarantee a CPU will report all the faults in a
single PF error code. And because of race conditions, software can never
rely on that behavior. Whenever the OS thinks it has cured an error, it
must always be able to handle another #PF for the same access when it
retries because another processor could have modified the PTE in the
meantime. What's the purpose of reporting RSVD in the error code in the
guest in regards to live migration?

> 
> - if the page is accessible to the guest according to the permissions in
> the page table, it will cause a #NPF.  Again, we need to trap it, check
> the guest physical address and inject a P|RSVD #PF if the guest physical
> address has any guest-reserved bits.
> 
> The AMD specific issue happens in the second case.  By the time the NPF
> vmexit occurs, the accessed and/or dirty bits have been set and this
> should not have happened before the RSVD page fault that we want to
> inject.  On Intel processors, instead, EPT violations trigger before
> accessed and dirty bits are set.  I cannot find an explicit mention of
> the intended behavior in either the
> Intel SDM or the AMD APM.

Section 15.25.6 of the AMD APM volume 2 talks about page faults (nested vs
guest) and fault ordering. It does talk about setting guest A/D bits
during the walk, before an #NPF is taken. I don't see any way around that
given a virtual MAXPHYADDR in the guest being less than the host MAXPHYADDR.

Thanks,
Tom

> 
> Paolo
> 
