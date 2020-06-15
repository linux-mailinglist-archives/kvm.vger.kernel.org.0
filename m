Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158EF1F9B29
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 16:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbgFOO7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 10:59:17 -0400
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:22368
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730748AbgFOO7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 10:59:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZeFgfuL5bh5uN4coMQLlOXChUFATwfTP2Gy0X6iiwlodC2xiIubVeeQO1mraG85l90A+8B841K2YpzixZYfL9V6zK+Ib9gd/hkUK1my/uordV+zr/ZoO4U7JumNBq2VVkN153Km39wy5wCao/1kDVeKQBc+gFXAK2KZ76GpT4CX3ngbGBwf5X9S+KK5GGzQUtnv+LlQbvWQHVjda0yBNdNAjh1tfO59qhdyAK78V108P4w4+0tONzao6WFBaa8LOXrhu9r1iCJdjPcPRiK4ZkCvJii3kSedJGldVwyeXYyUsQ1Exf8lO2zx32Tr+I6MfQDLgGOwd3dbzAk5Ku+QXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bcC9MkYeqvrUjtlL9qaLnB5HR24Pi7ZVt9P1rJaHG0=;
 b=M8rPvvJmowJtKGzfFlasXMb56cOOJq0yo6Y3xwX61a+Q2HBjkhfp+CWSrTJlL/0LuchIw4apvgQlVMfFj3CmnL+rusFwrQl5+G0XZY5stXcfz1e+zaFwyA13hsRJCg1vJu7Th47TFilE/LH91YFzIt3gM9vhmOTQjugBy+W8xXU/GLqiofRbUqFzcyY0h9bk8FKViEx+MC4kNwPcZQJfIVCRTrBynwwRgKBXtqMKlr0Q6NLv0tg2Bw+QqH2c4veI1q4VPquykHsuUtd8aoWs4i2QM3NIRWsLrr9PZRAzh0wm5F/SJsaIuOpqAZviqIeoDcFMV9Tr6y3TPCjw6K/EGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bcC9MkYeqvrUjtlL9qaLnB5HR24Pi7ZVt9P1rJaHG0=;
 b=K8m/ctpW3ihg9B4PH0D+QikK1DqxdtGQfJU/G3jtTvOQM59NKC757p6KUp0YrPig1cgTXJJ/uR6yFs4z74Cd1Q6GLfbpf9C9slxR8omNUx1+IvomrVJnWOLo0sPzIFJXUREFed1AKtaR3WxAaV9IJnaI+fuEvn5Vz+UBuYpU8Yc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20; Mon, 15 Jun
 2020 14:59:11 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Mon, 15 Jun 2020
 14:59:11 +0000
Subject: RE: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
 <159191213022.31436.11150808867377936241.stgit@bmoger-ubuntu>
 <CALMp9eSC-wwP50gtprpakKjPYeZ5LdDSFS6i__csVCJwUKmqjA@mail.gmail.com>
 <d0b09992-eb87-651a-3b97-0787e07cc46d@amd.com>
 <CALMp9eRZQXgJvt3MGreq47ApM5ObTU7YFQV_GcY5N+jozGK1Uw@mail.gmail.com>
 <d0c38022-2d82-aacc-4829-02c557edddc0@amd.com>
 <CALMp9eSn36W=YK5XtaVATJis-J--udGK4ZOESDhYyT0zJ4YZ9A@mail.gmail.com>
 <4f5a7fca-02b3-4cd9-159c-59fcda3debd0@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <3775e38a-9ebc-3ced-569a-fde066df673d@amd.com>
Date:   Mon, 15 Jun 2020 09:59:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <4f5a7fca-02b3-4cd9-159c-59fcda3debd0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR15CA0058.namprd15.prod.outlook.com
 (2603:10b6:3:ae::20) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by DM5PR15CA0058.namprd15.prod.outlook.com (2603:10b6:3:ae::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19 via Frontend Transport; Mon, 15 Jun 2020 14:59:10 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe7140c4-5196-4281-4466-08d8113ca995
X-MS-TrafficTypeDiagnostic: SA0PR12MB4414:
X-Microsoft-Antispam-PRVS: <SA0PR12MB44141D6EC40FAB142CDF4D26959C0@SA0PR12MB4414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04359FAD81
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: noG5mZo3eyy/Jpm8CgL/MZ6pUpiU26xB972qBr6OSmLh1sbfc0EPc20zuu/+Vl0xTWz2mQaIlWAx5HShtjewIjZXncQvSfYl31rH/s44XARpTwvAPWA1TptcNdiUjLEEhsk5AJfSuc4bFxYZ7brlIoP88OAozaPKX0UpIkbWzYkqz5aTMdEqiF6297pG6fYjxDuBiRFODBRSm3vO/0QytN8Y88KEh4BnTMs4yorvqy4RiwQhqrhzzS5R1oFo4YKAu+dyJ8kA2cMjDjTz45iTZb/fK3ausFBLH0ObRRNMNbuuG0YsWDO3XIFtiLIZQN0JYcejPcZyIFIuBfiYl60BVtoIHtR6DI6iy3MpBGNKB3jHNaP4pgttpoPQDtjdNuSa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(5660300002)(956004)(44832011)(2616005)(52116002)(53546011)(26005)(31686004)(316002)(16576012)(54906003)(110136005)(16526019)(186003)(86362001)(31696002)(7416002)(66476007)(66556008)(66946007)(8676002)(36756003)(2906002)(8936002)(6486002)(83380400001)(4326008)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2t249DHXb3wpxYpy8QKhLv29oHK10p7FeSYLtlQUDIzaY8LgMomrIiR2oRRh7l5IXXUQmswWGB4u6PUVoCSYp3u4bZ6sGF+OBuHlm2Wdh8HrJDFXRYr5pDy+SrT/OvkxnDYnBBDQqwg5W+BtJwrvfnbQjK1tsXTqoS+r0Dyk/ceKgwjvxB6ukWuM1wdhi0UvDT4R2O1IeX168BdRgkkKCpSlI5bL6J/qjFvfawvwr7WbbqmrpeDX7yawNzueDJ89OK5WQ0AD2Em6oiKd8YBSYueHykUDiaVY0kxoWB7i2H0aKNxm0BAcwm4fEt8sYoj0+JBGUmhINx1CaTO4uxknplfWIQ+3hIonG/rFM8DMxVYXdJk+7Rjz8wlJ6aaVLMGkkh2JOyXS0uj5CDqltUzQlycJ4wWmQbSTsnKnWOH5/edh5JhzWwqGjrgWkDarkgiV3WVzEKUC1UFznK5mF9b8ns+xlIrOF+OE0gEYiRlsNSE=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe7140c4-5196-4281-4466-08d8113ca995
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2020 14:59:11.5196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWMxZMojEAvrB051gJQXsr7QX9YIGd9xpLQcQnbzD4RIv3urzrvFLNktOjC7bUKu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4414
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini <pbonzini@redhat.com>
> Sent: Monday, June 15, 2020 8:47 AM
> To: Jim Mattson <jmattson@google.com>; Moger, Babu
> <Babu.Moger@amd.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>; Joerg Roedel <joro@8bytes.org>;
> the arch/x86 maintainers <x86@kernel.org>; Sean Christopherson
> <sean.j.christopherson@intel.com>; Ingo Molnar <mingo@redhat.com>;
> Borislav Petkov <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Vitaly
> Kuznetsov <vkuznets@redhat.com>; Thomas Gleixner <tglx@linutronix.de>;
> LKML <linux-kernel@vger.kernel.org>; kvm list <kvm@vger.kernel.org>
> Subject: Re: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
> 
> On 13/06/20 02:04, Jim Mattson wrote:
> >> I think I have misunderstood this part. I was not inteding to change the
> >> #GP behaviour. I will remove this part. My intension of these series is to
> >> handle invpcid in shadow page mode. I have verified that part. Hope I did
> >> not miss anything else.
> > You don't really have to intercept INVPCID when tdp is in use, right?
> > There are certainly plenty of operations for which kvm does not
> > properly raise #UD when they aren't enumerated in the guest CPUID.
> >
> 
> Indeed; for RDRAND and RDSEED it makes sense to do so because the
> instructions may introduce undesirable nondeterminism (or block all the
> packages in your core as they have been doing for a few weeks).
> Therefore on Intel we trap them and raise #UD; on AMD this is not
> possible because RDRAND has no intercept.
> 
> In general however we do not try to hard to raise #UD and that is
> usually not even possible.

Yes. Sure. Thanks.
> 
> Paolo

