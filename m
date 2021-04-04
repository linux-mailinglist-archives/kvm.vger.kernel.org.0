Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECFF353990
	for <lists+kvm@lfdr.de>; Sun,  4 Apr 2021 21:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhDDTyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Apr 2021 15:54:38 -0400
Received: from mail-co1nam11on2085.outbound.protection.outlook.com ([40.107.220.85]:52518
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230169AbhDDTyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Apr 2021 15:54:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbRxyFP1M2UYLGmStwUME+0cI8PxXgl7beWKkxs1/tNH7oR/K1gnonj8dg9K+OHIcT+0Qo3sKN89Ry3yosx7mmsLc3sreOwoiiMFjDFCEIQ6uutLUPOMGNeznipB3F8NUE0HSJnTJpkS+girzEIjiVpY+9wmQM+qMy69I3EjIm3yk6nRgL7IfFKfJv+SY3KKMO+P12s8T6ivendKNcu1oYnhIexL6gf1F/+CmoLDrwojzDbETqu2jGLulhCGZYB+BwJXrQ3mLkbXF05ff3DXrSaiTqPixJ/KkVcGHu8Bhfg3nXJTVIESen0EQ/GbD4eL3wubIWhqRbyH7J03ObsIUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6qiAAJf5v84PmiAyybUC/Rt4JEmFDVjuuoZ7OyflDo=;
 b=kpdr8yLvBCLRsJ6fAp6RlO6Mb1Z7MAveM2vsQw8GKmCXOF7zobkqq/YsUdc9v+wHNbxvoXddC5h9jVi21+wOofKrbWYUDqevEkhdnNj4dDYtWKTvwOL4c2cX6givrf8g5QmpiX24v9RT5B53cRSasOqDykMEyunUrqWVlgQRk4UklI012XMhdK9r0i34TnoP5155UTbRBn1aryPR0K8lVUJT21avBuFoBqCOQTS/yFApiGTy01EsZAbP3PznQBYORelGC6EfB+rKj2iyblDv4t83dHY2kxGTkAXd0tozXyK6WQzfZwjhp6AkMYShwVWoZ2Xh9IF+goRYeRMRPX9lEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6qiAAJf5v84PmiAyybUC/Rt4JEmFDVjuuoZ7OyflDo=;
 b=25fVjSDL2FxvcZmbWpGn/EldkrzmnV5K90S5LY3ulULlY3wisaPQlzResjBqn+UPcwroJhQKkcWS4U7Vistv3wlMZrbp4yJvc8V6Ggjg3oUefb6YpA7p4Famu1trHRE6NegEKgG6ExBm64YoM3yIO+d2aL3iBnGls4F54fgwCZc=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2448.namprd12.prod.outlook.com (2603:10b6:802:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Sun, 4 Apr
 2021 19:54:25 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.3999.032; Sun, 4 Apr 2021
 19:54:25 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/5] ccp: KVM: SVM: Use stack for SEV command buffers
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
References: <20210402233702.3291792-1-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <8b398d9f-6d20-5946-c1fc-4ea2909b5250@amd.com>
Date:   Sun, 4 Apr 2021 14:54:23 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210402233702.3291792-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0501CA0145.namprd05.prod.outlook.com
 (2603:10b6:803:2c::23) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0145.namprd05.prod.outlook.com (2603:10b6:803:2c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Sun, 4 Apr 2021 19:54:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 028d7762-31ea-4aab-eeb3-08d8f7a372c5
X-MS-TrafficTypeDiagnostic: SN1PR12MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2448A047870EE6B9AE716375E5789@SN1PR12MB2448.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9/H0VgKFYpf3wP7MWaCEJv1igbW+J2LTptEwGocxk57v59B8FRfY7zgA+W8ff9rTeTvML6rvt6U9edDblqVS/ir6pN3LzlW7SVs6SX6G5cuNRvJGZOAEwubVfiz8ZwwlwlCya/wLUA5qywYAPk0ocDUs/RB2DfnStOKs8VzBz8cvGjXrrPCicOndvwHAsUcOHAJGrJi1Z43tJaqE7IAAAGLi4s+gay2EJo6hYSMWzT2jLnvYW54Cltur0MGb9ulkupo9KOT6SBPjj+gMPaiu/AnKupCsdi88a1qEa1LEKkqkBt5CLN72LgqrLieixRLNPLKyE+4XUB1WZpw/iN2Kz3o3mGRqv2Fm8ppSFYDDJ12kkAPwALvEPrh32e8y0iX2QLR0MIRpIrGQlKHoDdttSH03SO00W2NzfG4RLYTLEvgf0oIhYTtSM2F40Jdrg/xVUy/HT0EqNibY1ZXITNFbOCO8c7BenmjqF3xR/HV4HqJqdONhr4Oga57w98i4/YTw31IMbEp7X/+b/Nw7gbMWkGEpezVXW9ALlaKChCi8JlYG59FatkxbMHxNHdF2wBLb1jQAG4FZspOV1z75e81ZXqpjC3QvY8PiuZN2HhjVttJ8aVkLnYxrcw1Ktr0hPmVnIAVcJXrrbWNi1XE9RyuLvHuuMJxLw4Q0TEb5Itt8YSQki2BLTPOXmgSmWV892L97eOgsm5LZ+EgCTpbBtwDRIvjxZBWryCa7UWsi32Dils=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(2616005)(36756003)(7416002)(83380400001)(52116002)(53546011)(6506007)(6636002)(16526019)(38100700001)(6486002)(186003)(6512007)(4326008)(478600001)(44832011)(956004)(86362001)(5660300002)(8676002)(8936002)(66556008)(66476007)(66946007)(54906003)(31696002)(110136005)(31686004)(2906002)(316002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OXNqMTladVVGdUROWjU4Z3FZRlRzZysyaWlUcE9nSkU0MURmOVNmZlFPczFH?=
 =?utf-8?B?RGJML0Z1UnZIaW16L2NHK01qVmxLWlFPdUpXNW9XZnBmY0hkWTFQbjVVMm55?=
 =?utf-8?B?eEpLM0JuMkxlVjFHek4vWVc1S3JWWTNBNHUyZW9nbWxwbnBsb3F6MzZNa09N?=
 =?utf-8?B?WDJVSFpjdUtXL0J6bWJQc3ZJd3pzNlVoOE43VEJCVTY1MW1sZVZYZlozYmFS?=
 =?utf-8?B?cU90bERNVGlwdkVpYkdBUEFlblkvdWZ4TXo4bG1IS21CcHlKQTZ0UDZ0Z3Nj?=
 =?utf-8?B?UlRiOHVYRnRoRy82eXcwbFpNc0luMGJDcEtnTy85cFEvc1JTQTM2YkpLczJ1?=
 =?utf-8?B?TVlxUVBFS3FxVDdZZFk2dWpPT0JWR0F4KzU2RkVWTzBtL0V4ODB4YnUxVWZx?=
 =?utf-8?B?RFIvMzJZbDF3QzNkdG9ZTktUMW8vbzNLbnl3RHZ3dGtocnBvbHdrNTZTZW1k?=
 =?utf-8?B?dXJTVnpObk9XdEVSSm5LSFpuaXZ1Ym1YK0JVYVQ4WWR5bVJJNUhIQXdOdUJs?=
 =?utf-8?B?bElsYnU2ck1DWTVMU1ltaFF0U255dTdldkNGcXdFMWsyWG16RkdybXpvYWhE?=
 =?utf-8?B?T1lEcytVZ1JKOGhua28zZC9sV014MEZzWUY2NWwvZkt6K2dMTnNiTGhKcHhV?=
 =?utf-8?B?bmVsdkRIYXM5Ly9jcDF2bk1qa00rbnovQ3dCSHRCcy9ZYTQ5YUhnY2Y5K1hz?=
 =?utf-8?B?eGw1bnhBUVNSeEtmaDJicHYzNmNJRGsvR1BzaVZYSzRlYy9hNVFIaUVnUkZI?=
 =?utf-8?B?MEh0dElwdk52V2Zzby8wWDA2VXRna29CRmV1RUdrZWRKTHBOWGk3TEVpUDk4?=
 =?utf-8?B?MmNBS2xpTW8wWDlvbFRzdENsTlc1b2JkeXpxQkhDem5wL2laaVE5aDllaHRC?=
 =?utf-8?B?SnAxQjRSRkU3SVNWKzNDY0hRMUkxVXR4cHZyNjVGdEFiL3NrT1RRS0RNeGFF?=
 =?utf-8?B?YjBEa2dNMXpFN0toaHVoWHhKeWZieVU4TVhoYTNReE1zb3FhbHFpRUVBcEo4?=
 =?utf-8?B?VHorb0JBY28yeDdYNUw2RXpjQUNJQUZNQ0FSN1lGcDd0K2ZQWUdpaXMxM002?=
 =?utf-8?B?WXg2RFppU2ZUR3RhVUpxWUJpLzhMTGNHNW9DcU1NQXdGRUF2YzI1OXpqUVFO?=
 =?utf-8?B?c1hCZTFTWW42enZmREJTUWxCbjY0S1NFcy9nZTJqNkd2ZmU5cTBiSCtzZTcw?=
 =?utf-8?B?SGJLc292NWo4cktLbGlEckNZckVSQS9QUGVJTldkUXQzeDJMa1Q4TTd1T2d3?=
 =?utf-8?B?ZTQ4WVhtWDI0L2Z1RDZPbFZjUmxDZlF2Sjk3OXFZQzFtVDFDTEFmM29GZ25C?=
 =?utf-8?B?MktENjJ0U3dENnlaQ0xwZjl4UVVTbTBCaXlDR2xhSjRFMEdPU3dPUmgrSGFJ?=
 =?utf-8?B?L2g4cys3YTd1QmcraEc4TXlxSElJeGI1ckFUYU9XZ0ZmeWFZYXBvVDRXSWcr?=
 =?utf-8?B?VjV4aVYzSmFBRnNDZWN4eTZnTThMVEJ0c09wTUQ1L2QyZzB5Y3YxUHg2R3ZY?=
 =?utf-8?B?dFFJM05zSHlCUEdrTnM5YnN2QjYvM1dQeE9zcW5JWlI4bE0ra09pWFp4ZWJ5?=
 =?utf-8?B?Y1JMQXFGdDVpTzRtSUNQWTNSYy9oOElEbDVIUWFhVStpOG8ycHJhaUJUOUVE?=
 =?utf-8?B?ZXFmK3hHWHRKVnM3c1NOVWhpN0NHS1dYYi8zSHRvNFpEUCtlblJCb1ozWHF1?=
 =?utf-8?B?T3k0OU43cTczdTJhQmo1c1JJOVNVOEszK2Z0WEF4ek5hLzJHSnZmSzAzQlI3?=
 =?utf-8?Q?jv7wDkxH8XVX6eeO7AjK+wmyuwtACIWVOejCecc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028d7762-31ea-4aab-eeb3-08d8f7a372c5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2021 19:54:25.2308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luqvS/H9UcGPn9IfX0SZL1hHDEwvmoIqe1wdw+mm5RA+uBCRcsTNxIbzNtQGwoB7KuNWld2Zi7/OS7cX8TIXCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2448
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 4/2/21 6:36 PM, Sean Christopherson wrote:
> While doing minor KVM cleanup to account various kernel allocations, I
> noticed that all of the SEV command buffers are allocated via kmalloc(),
> even for commands whose payloads is smaller than a pointer.  After much
> head scratching, the only reason I could come up with for dynamically
> allocating the command data is CONFIG_VMAP_STACK=y.
>
> This series teaches __sev_do_cmd_locked() to gracefully handle vmalloc'd
> command buffers by copying such buffers an internal buffer before sending
> the command to the PSP.  The SEV driver and KVM are then converted to use
> the stack for all command buffers.

Thanks for the series. Post SNP series, I was going to move all the
command buffer allocation to the stack. You are ahead of me :). I can
certainly build upon your series.

The behavior of the SEV-legacy command is changed when SNP firmware is
in the INIT state. All the legacy commands that cause a firmware to
write to memory must be in the firmware state before issuing the
command. One of my patch in the SNP series is using an internal memory
before sending the command to the PSP.

Looking forward to the SNP support, may I ask you to remove the
vmalloc'd buffer check and use a page for the internal buffer ? In SNP
series, I can simply transition the internal page to firmware state
before issuing the command.


> The first patch is optional, I included it in case someone wants to
> backport it to stable kernels.  It wouldn't actually fix bugs, but it
> would make debugging issues a lot easier if they did pop up.
>
> Tested everything except sev_ioctl_do_pek_import(), I don't know anywhere
> near enough about the PSP to give it the right input.
>
> Based on kvm/queue, commit f96be2deac9b ("KVM: x86: Support KVM VMs
> sharing SEV context") to avoid a minor conflict.
>
> Sean Christopherson (5):
>   crypto: ccp: Detect and reject vmalloc addresses destined for PSP
>   crypto: ccp: Reject SEV commands with mismatching command buffer
>   crypto: ccp: Play nice with vmalloc'd memory for SEV command structs
>   crypto: ccp: Use the stack for small SEV command buffers
>   KVM: SVM: Allocate SEV command structures on local stack
>
>  arch/x86/kvm/svm/sev.c       | 262 +++++++++++++----------------------
>  drivers/crypto/ccp/sev-dev.c | 161 ++++++++++-----------
>  drivers/crypto/ccp/sev-dev.h |   7 +
>  3 files changed, 184 insertions(+), 246 deletions(-)
>
