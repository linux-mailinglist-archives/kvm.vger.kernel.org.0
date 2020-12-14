Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552122DA04D
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 20:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441095AbgLNTWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 14:22:32 -0500
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:48993
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2441023AbgLNTW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 14:22:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/nQAkMCkgP7C5tYRfGbkwyM1d6yCQHnX1P0t9Qlco/jZI5n1+v2TvqbRp/aEPJphn/ZooXDCQ0zEAjCOY0ouqSOeRu5Uvf7qhYutiIp0yjTEdItDpr2/shf/rPeAT2rCUch1vMVFcBpFnK4H0NhxnXAt88FgR4qUEU3MNqSoADTlivhbedQ/C8YWiMiUJdAy8f0Hw6lcUycepWt3oAmonXyJTDCR+nbAd8Wf1tCfruN32ou3ke0bRpUoPN0/a457muKE23Im7batBUPE4f7fGVh/BV1+W9tj+ecOuGVEy6UkDj889rTPtqvcafdUzPyu7WP0/bDGCgj5Ycl51slnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DStB7nPi4yEpWYE41cTqRDO4tSgIJoK+/1TS96t7LhA=;
 b=YFhYRACrNxu8WeiPZSaO4+m3p+3XVjToHlSWwmV7dI57hxTdf56Scw9zUuhW4jtehjqX9p8640R/+aJz8XLgpskD4X/h37Qa3xKgCdaAYN3drgQVlC/Q5p91dgWb/zTe8mWY91BDsio6dzua0rk50fPNdHqYg8//eE9NWGbjdRC7dsX2NRsvwn1Bxt9f/TyDmy8EUm23JPx23QEjKsTVjXVIqiBa1Lx6gbuNqt23MccvYHSxYuC92JlbspnVIGriLp9GIl9KLGpXf5Gk07rpLRGlJEt92QJSn1C8PMHuw2amPzWPuQcdxfKV1R4mNrNunzJlmVpYhug8c063NfiLNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DStB7nPi4yEpWYE41cTqRDO4tSgIJoK+/1TS96t7LhA=;
 b=19htxaSx3WemhBVsQhRe1rO7TeSvggeKxeJjysRwWa0R06GVNm1o7g2oCta6hq/TgUjI7yoQMDMEiB5qbABA7WvaMJ0Fd1I9ec3yKe3RDNQQO1ud/NE0KlJcJsPmruH0b4d3jA8BDBHMVBCXkE50IXUHo4Xz3QGguDaqgsI3grM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0121.namprd12.prod.outlook.com (2603:10b6:4:56::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Mon, 14 Dec 2020 19:21:56 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 19:21:55 +0000
Subject: Re: [PATCH v5 16/34] KVM: SVM: Add support for SEV-ES GHCB MSR
 protocol function 0x100
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <f3a1f7850c75b6ea4101e15bbb4a3af1a203f1dc.1607620209.git.thomas.lendacky@amd.com>
 <1907a448-3fa6-70c6-e162-cb42ab79a95e@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <a26b3726-24f2-d7d8-da45-8672fbf61ec8@amd.com>
Date:   Mon, 14 Dec 2020 13:21:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1907a448-3fa6-70c6-e162-cb42ab79a95e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR18CA0048.namprd18.prod.outlook.com
 (2603:10b6:610:55::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR18CA0048.namprd18.prod.outlook.com (2603:10b6:610:55::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 19:21:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1f2dc462-6c56-4140-c486-08d8a0658530
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0121:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB012173F40C970F398C62CFC2ECC70@DM5PR1201MB0121.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JsHsksD933qAz0+nGLrv4uV1LmvV9Gc89tivxmJX3zLLCKPcwlsuDKmU3WOdJIzWdP4NvH+AGJ7/Cc8fMVjJHuRXCG42h5ZxfXd3ZjMsjaJZbEJKr8xJ4OuZuYldZ2sjwCyDYtYKuO+XicQvSGd2Q4Indx3ivkIcnkhsnjoGfF9WnsoM59lxzb/XikxjTa9UariNCzSOG4orJ6OOyq2s1qwzKo5kQEOMXFrppJN9oYE4yDqV5jLWWcwb1R8+7PXdiF7PLhGkJwn2cnWnWxam5xU1wTmJYQYaeFFlIob0SAl7nWkdfsTzf0Re+5BiZx4fbWue6RsdxaTVPAngkiPiduHEPFy699C71D7O5fn1Xc2HuD99ULj3daU7m/9oRH1LQAVWaGxH2ZW6cFLlbAO9x7LqyK2yiewb18brOPK7XQGwlGiczXxwY1rWYj6tDupK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(26005)(53546011)(508600001)(6486002)(4326008)(2616005)(956004)(4744005)(54906003)(186003)(16526019)(7416002)(5660300002)(2906002)(31686004)(8676002)(66946007)(66476007)(8936002)(86362001)(16576012)(66556008)(34490700003)(83380400001)(52116002)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RUxqelQ1ZzRJVXdYZGU1M0lxc1dySjBMVjdMV1ZWTFVCVmFBcTRjbEpjY2lS?=
 =?utf-8?B?UGNWUk1NdXA1T3lWNGZOSDh2Wm5nMXlqbW4zZTVLR3hiR3drY29WU2k4Tno0?=
 =?utf-8?B?RDVjUDRNQjhwNHpUUGpYa05UdndrMkd2K0dyTEc3ZXRRYi9QdDZBcTlqUnkr?=
 =?utf-8?B?Wk4zdzB5OFlrRVkyNnQ1VUVuVVByN1FtSVdmMVRocHhPSEpoeTVPck5VZnpo?=
 =?utf-8?B?ckFHdnBrMXVqOGFYSVN5S1RtcW8vS2tTY0I1djg0QVZxMTUzbmh5eEx1OU1E?=
 =?utf-8?B?c1JIMUV4alZQUElGdllMc1ZKcHZBak5rY1NJOFNiL1pGRDBhelozd2EySGFP?=
 =?utf-8?B?bmZudkljdDF2azhKaFpRd295S2VEZEhrY2VLOVlpS1g1cFVtbjRYcXZ6WWQr?=
 =?utf-8?B?THZzUm9IbUF5Q3p5REhQUmVyMnZ0dllqeElNSjNONE5RR0hpbEdMbjNjYWVQ?=
 =?utf-8?B?TkxJTTdPNUNuN1NjazFzcGhtQk9iQ1MvbmZVUThtSXJIQ3BZMEVwQjJER1hK?=
 =?utf-8?B?UzJONU5yNGEzWkVWYVB2cURVcy9MbzJzSCtSaWI4UWh5NDJ4N3NOdXlxalND?=
 =?utf-8?B?WlFBQSs2K0ZHTmx6SjdqYituYlVTTmhzQWxSTmtWQlFoeXN2akpFbWZRRkor?=
 =?utf-8?B?QkV0amkwQm5QZW93aVp6Z3lobTZkTTgwa2xaMHpuY2Q2R1pEYWd2RFRMNDZm?=
 =?utf-8?B?ejRlQW5CcVZkc0tBTzE2Z3NDVVJNamNXSXhhQi9KSlIrUjMyekdKYUNuREZ4?=
 =?utf-8?B?V3hNdXZYSnB2U0IxdWM0elVlOUM0MmNLdmJScEU3bmRuQitpdm9WSFEwb2hV?=
 =?utf-8?B?eFhQM2U4YThyRlNFSVB2RWlhdGM3OUkrajlrWmFMUVF4NlBUaEhpRDZvY2Nq?=
 =?utf-8?B?QXFSV20xVGFKdTZXcm5FYzVUNEc0NzlwbktUV294V3I0eGVNajB0VDN1QktX?=
 =?utf-8?B?Q21ROU1zRk0vMllRRlVsdHdnV3dKdm1SWnk1aFVhdElqMnI0R21WU200eEZl?=
 =?utf-8?B?MUtzcCs3aENFeVdDeUN0Sk1jcnRMaTFXL2VkbXQyWDJMOGdSNUx2Yy9sMXRq?=
 =?utf-8?B?T2RLVnJKbWpjeTBPT3lJczVReXB0dHJPRnAzM04vWUYwSndlN3RydGU3TFhL?=
 =?utf-8?B?Y1ZxVit3V21vbk9jR0xOMlFMV2FJU2xjZDdPSm9HRUxNVTU4dFZ3Sis1WGRE?=
 =?utf-8?B?aTlvc3hBejdtRGdncEpUMWpHUHVXZHd4TEtiTzBXS2dwQitENWdVZlUySFRl?=
 =?utf-8?B?YVNCSFkzcTdQc0o2VkVrWGozUGJyQ3JsZ1dkSmo2QmFyOGZNcVMvT2tWbXd4?=
 =?utf-8?Q?JdTvb96wpKQdY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 19:21:55.8512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f2dc462-6c56-4140-c486-08d8a0658530
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K8Ck0/ynrYof+8+iDIHVLHTHmYT+KsWrM+DGMFeolPinsnWitBRGI/59us2XNcOZY58m5szQUQUfeMfHwTkXMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/14/20 9:49 AM, Paolo Bonzini wrote:
> On 10/12/20 18:09, Tom Lendacky wrote:
>> +        pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>> +            reason_set, reason_code);
>> +        fallthrough;
>> +    }
> 
> It would be nice to send these to userspace instead as a follow-up.

I'll look into doing that.

Thanks,
Tom

> 
> Paolo
> 
