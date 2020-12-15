Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D902DB41A
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 19:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbgLOS5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 13:57:38 -0500
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:11701
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731743AbgLOS5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 13:57:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sfwqn//BwBoVN52pdO3v7/HDZUvkjLcl5Hw8Wz8gsxKN+xQOxYXfh7H3ElNDG97bHc9PdbzbzLN3VGGbO8yIyb4fBQ1M/RATzjrs75e7Mp2eAZ2MBbZ3FK1NilYseuMNbjFGkGj4ySUwXgAKMdgsIYCT2uNhv19Jdp0om2QyYJvntnnkOlL54x7+e0FwCnpQtKYGesqcOyhTaJmL1G+l+a7QeQ8kMgUswK4xjcl8+KNfnZrYI+b4ZzX5nr0e6LVEGoV2BZrOK8O9IeraGz6q3WjJDNsbOfsEg62HEqqocmxBnimJe4CK14KUeUr/u58oyAkqXU73AUEw7U0ET98log==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYA+LhAH6BVJ+KU0KjAdu1EOYhmTMySsNijRSOQ/7IA=;
 b=MUgw53mqBq7NO+pvJ6W64ZxECE29X/Fdoxs9KJ6famCrHvAKPx2hztomZTil5Dr4AGw51RldAsamrUgKxTtDCSIpPA9Zyld09SJdwaitjvvgoT4qnOGVHW1mmrAiBsdMtXGBZ4RCHurkwUdm24ni5F0XVWfijZDWTFgharKDmYuUVvWUdLBaVukwwwU5UCL8aNepsfygBHPzxXe/IlpA5K2TC3Tl76HqfuA+UxvvftFBFc1cQUmPUM9LnorsYqFK+2XK7fsmCjDFYQ6PJaP1r2C2/+vRMMaXGJd7OWaq8DpTcn9azcbPCltDqgcsplMp6T8d5hreJsWB2+iMRdy+XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYA+LhAH6BVJ+KU0KjAdu1EOYhmTMySsNijRSOQ/7IA=;
 b=DeXd+bLXCqjYuwCDCzhiymH6tEI7wUFBQVsugJimJ+Um9Oo0cp2BiyybJDNm6ueMOUR4qVWv+h8Kq+m/7+nm5qHVN0fJ1fc+wewxDQnUpTiZ17PhfowtrabeJk+x6iqOT8xwlKZP20nZd/HxWwOg2r62K/GW3xmKWjQlHYSoBxs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Tue, 15 Dec
 2020 18:55:52 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e%6]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 18:55:52 +0000
Date:   Tue, 15 Dec 2020 12:55:41 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <20201215185541.nxm2upy76u7z2ko6@amd.com>
References: <20201214174127.1398114-1-michael.roth@amd.com>
 <X9e/L3YTAT/N+ljh@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9e/L3YTAT/N+ljh@google.com>
X-Originating-IP: [165.204.11.250]
X-ClientProxiedBy: BL1PR13CA0294.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::29) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.11.250) by BL1PR13CA0294.namprd13.prod.outlook.com (2603:10b6:208:2bc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.13 via Frontend Transport; Tue, 15 Dec 2020 18:55:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6a96de9a-116e-4f2d-d86d-08d8a12b0bb9
X-MS-TrafficTypeDiagnostic: CH2PR12MB4326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4326143817306B281F9F3BD995C60@CH2PR12MB4326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fkXAbeoH0sQZ0UThMbOYoUYLz5antqL/ffRGA9G9MRtxdoox2qw/KjMPt6irFd+pXPzplKm7Oj0MqT2Zpm1gpDUP8lmDKXezD81fmKjDq1B9dHuUIyScGfsWGN2wikCD+MVQBEBWLzmGhs5c7od5UH1Kw3H8NNqZSwqAt7hDUsNL+eQVTLCNp3jp5lQde+T3lTv+DRxljkYjukF2fpz0oByTlyHcvsmLKBWHZn9luGUECBzc9IyyhPlQslJF5UYwfIdQzryOFr28j2iMsTCtXNwo3LCRHef4vIL8Z0pFwq5IHgai87Y6aatojNxR8q/8r8/NbrZnUlfFZjHTuhm0wVZg5/aTLUuB9bMIipueFlzN2+V54YNYAX7C34SVyNeV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(6916009)(6496006)(66476007)(508600001)(6486002)(36756003)(5660300002)(66946007)(7416002)(66556008)(54906003)(8676002)(4326008)(34490700003)(52116002)(186003)(26005)(44832011)(956004)(2616005)(2906002)(83380400001)(86362001)(16526019)(8936002)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FYYj90TavCEJ1UGaDhgGuC0zGFfsvQicyXVMgFdEAcY2AMTOHkiuH3un2nos?=
 =?us-ascii?Q?xS4JqPpPblcCVdXm8GFrNYpZ74M4dmaWbldHgjdubFz/VBd9y4oqATc1esHn?=
 =?us-ascii?Q?Ia34qb2cwsvTV1N4VQa0URcWtabTeg3NQSw/gTAxMsrT+cCi2OI6kEjL9Qth?=
 =?us-ascii?Q?NKgMinVlH1C05FH1vyJCbNzvcvrzHgdyjmFpOO+WxU6YqZ5oK/zOGF3C4hD8?=
 =?us-ascii?Q?i3pd3rigBRufdM+mU/+DQKRmmiZIiqfyC5KKzhaRSIebeZfQ5xYGAqbHC/xW?=
 =?us-ascii?Q?0CmzvZ67zJ6f2zR6rBiOGnYhJ2v8E7LuTJXcZNQnyKJ/FzkIh2tqm5tbcnvx?=
 =?us-ascii?Q?7MPQ2WHFFUTJqnfmf+Z5NSNTONzEnYmPYshAy8WoHBTZ3WX6Bsim5YTLcRZv?=
 =?us-ascii?Q?UE2QErTbPGk2mdhzmbh+k+aIuYRW6pivs5J7948JYMAW37JeSnT8+syvvyp9?=
 =?us-ascii?Q?91sQfQOMP4lHkzXRxCNV3OC/WCVOfT1Uz21CFb1bGQTfjN0IpqCy5WPQimwk?=
 =?us-ascii?Q?//G4TryQfKRW4FjCrXZnRf+hAwlJhpg3pvwrKc/LZ+40vhB8v7fiHBKzrYYq?=
 =?us-ascii?Q?FdoRlhS/IoxbH9++5w1mszV9plnmchl0AOj3/nwUvMYrFh60LYGnNuKHb0Vv?=
 =?us-ascii?Q?qBDoCJQb7p4+CtNFobZM1/upVckBEdgbT/iN6Wa1rK7gBzBfeGVt+wyQyJdq?=
 =?us-ascii?Q?LGrLMptvIvF0FDsz89FGV7gvxt1BJtzMj+DxYvvhFA0/6b2acaUsfOlL1Fmp?=
 =?us-ascii?Q?WELk1Wmr/uZbIrJ8xRfyvb8rhHy8zAehMgw4Nr0wAk2MzeNB48JZRPPnMxz2?=
 =?us-ascii?Q?vjT0TAZ4TPLLZafMw3/EATllEXhYxXPGSxuFxLL5GGOt3BR6v7RtwoOahLEW?=
 =?us-ascii?Q?yufAjT2lTDLv6imELKngIUZDXSrgWx8k+CV8KEP+ZRGOl2NowJ1Pu8CZuFFm?=
 =?us-ascii?Q?v8TWVQpGNWXRbPVmwO1wV9JwnrkhURCl6zbfEFNgje4WuzWEQ3yVtVjkeuX5?=
 =?us-ascii?Q?VVKM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 18:55:52.4015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a96de9a-116e-4f2d-d86d-08d8a12b0bb9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LHrON6JhRFg4HAPUH9XqAB+Xa57haBjlzZBCLsZHjaedMdaY9XhQBLQivhtEqhtJsh4UTcXHi8E7mNeJmgfgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Sorry to reply out-of-thread, our mail server is having issues with
certain email addresses at the moment so I only see your message via
the archives atm. But regarding:

>>> I think we can defer this until we're actually planning on running
>>> the guest,
>>> i.e. put this in svm_prepare_guest_switch().
>>
>> It looks like the SEV-ES patches might land before this one, and those
>> introduce similar handling of VMSAVE in svm_vcpu_load(), so I think it
>> might also create some churn there if we take this approach and want
>> to keep the SEV-ES and non-SEV-ES handling similar.
>
>Hmm, I'll make sure to pay attention to that when I review the SEV-ES
>patches,
>which I was hoping to get to today, but that's looking unlikely at this
>point.

It looks like SEV-ES patches are queued now. Those patches have
undergone a lot of internal testing so I'm really hesitant to introduce
any significant change to those at this stage as a prereq for my little
patch. So for v3 I'm a little unsure how best to approach this.

The main options are:

a) go ahead and move the vmsave handling for non-sev-es case into
   prepare_guest_switch() as you suggested, but leave the sev-es where
   they are. then we can refactor those as a follow-up patch that can be
   tested/reviewed as a separate series after we've had some time to
   re-test, though that would probably just complicate the code in the
   meantime...

b) stick with the current approach for now, and consider a follow-up series
   to refactor both sev-es and non-sev-es as a whole that we can test
   separately.

c) refactor SEV-ES handling as part of this series. it's only a small change
   to the SEV-ES code but it re-orders enough things around that I'm
   concerned it might invalidate some of the internal testing we've done.
   whereas a follow-up refactoring such as the above options can be rolled
   into our internal testing so we can let our test teams re-verify

Obviously I prefer b) but I'm biased on the matter and fine with whatever
you and others think is best. I just wanted to point out my concerns with
the various options.

-Mike
