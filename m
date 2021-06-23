Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D48C3B1AD6
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 15:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhFWNOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 09:14:43 -0400
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:14817
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230234AbhFWNOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 09:14:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8FCjuTLtSR8jw5XIt73LByD/To7wTQwYy2V1PLaI7W/K58Bn0aZJcFdxnp3dp9k/7dkFU9EDUksyqGdYcEIl3j9sMeDEN8w4IlyfiLbxFpL28S2UmO7Jd+BI4e2G4j9tpbVDyBWLtt33QvbWAk29qMrJ22UCsXRYcGMfNGFi05FS+RvaywaGD1//J6qo485UehVGw1l9zkE0sJrYJg0uLlYt21E0iDxDcd3kLMKpRB1BAm9CA/kO6fBuuMcmPOyKeaHQ/ApVtI3gU8mc1jpETII0S7ob2Bde9e2RFMDi8ylHobZuO27fwivRS3ZBsHoo/030KKaTosR8CFFtonihQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CA1M2lsqam+MK4IBbH+p1RELSlXr+x6DqmJkhyPgfbk=;
 b=mZaHHqiCjOPpJSnVhVq0Rs2BV1mX8t9osBiz0aoKkUqEEMekRd1hrGtxzd0wODLvhigctqu4i1obuJRg6qgknPPuJoNfOTWmDzxfU4hPtoC2WxJH9cqFadMIA5A6BHvIBbRrYGgQIXeAysgevDLmyPBKcp0X7IBb/ALoLsjerxGImBUqIr9ePiRJmVg5CjNaKDx0fok6PYgqcybZcydQBJ9tRSgQI0NK5Hp41j8rfqFQ2Sft8d0dkEqABr1CoiMqAy7guN4y/iIOX1XcMn/GQrVG1GvZCdoHRwwdcMc0ugjwKQYuDi+h7h6I3rboDA4eZ8EUfYSOs8L7v3ZqIbuT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CA1M2lsqam+MK4IBbH+p1RELSlXr+x6DqmJkhyPgfbk=;
 b=VSM/lbfIif/0a9NuIztCHF7cgUSvL0zbRebUqOszE3xEZJst8c4kpBLryoS829S6BnOb7DU/e/VSHNs6s0eWu1gAB+pgTSFNypbaPoXX9zlMkySU04wSYKaAl+rVy7xuZ+F9a8zhnUslhxvNHQSk25VGhWYLNBEpxu+kI/LKZdI=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1353.namprd12.prod.outlook.com (2603:10b6:3:76::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.22; Wed, 23 Jun 2021 13:12:19 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4242.024; Wed, 23 Jun
 2021 13:12:19 +0000
Subject: Re: [PATCH 2/3] x86/sev: Add defines for GHCB version 2 MSR protocol
 requests
To:     Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20210622144825.27588-1-joro@8bytes.org>
 <20210622144825.27588-3-joro@8bytes.org> <YNLXQIZ5e1wjkshG@8bytes.org>
 <YNL/wpVY1PmGJASW@zn.tnic>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d1ce7eaa-2600-d909-b847-cb334be11439@amd.com>
Date:   Wed, 23 Jun 2021 08:12:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YNL/wpVY1PmGJASW@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 13:12:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb77a129-71b5-4cdf-cbfe-08d9364887a0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1353:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1353FC7324610E3C8D7B37B4EC089@DM5PR12MB1353.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+E36r7dyB5RGcEnz4L9w1Y/u3L0R3iSMUfoo3aJqT7Dr1JhiJ3Uq8PkH/in9lifyGoFvrH+XQb/hCyvhe9jCCW25GlOWXrwS0jUiTPpcre0qkUf4kUHUPNItg/a/nIVwXWNzmxZD2kBVdPcW7we7zo3pe/PhVnKPpGRDHQCl5qH3rCTWI6NZwEf3QFoYA83H3urnYgN0J65QL6oue+lDh3kAowtAFkWqNVzYqZTkWRgaEibyXikD3FOjZOza4bx1ztdnOHq74lP8apvySmPD6vbRNXbitVFG+9w4NTyzqX5RxsG73AbDpqV/mbuK/KwvhI4jlBQD8BFi4lIcY3vkDKHO3YlTyJmar52PyzLST5jC8pAk2L66qA9BEcM2ewXff5SF02HRKcTToMpZhWbKW7fT0oSRGd8Ec7vfZlCTPS30tibHdEi9F3mk5Fw0N6Xw6kbvnxf22IpI8ISme12fMeAteqedu3+nazQpKGkwbkbbEv+ZRaHF2O0w0qW9w3fPo4wMPb7CvnP85vzgypyAYGKSbG6cy9pUGMGqLaC860jq3pKNdAUi2OvUOYeugScXAHRhYnXNiZsUxmakeFxOb/KPwvce9CQqhVacuCqKzGeRv+qQ2+u0bsheFht6gyTYcrdEk89hfKBaH0HVmjaf0rqYug6o6JczThT5aImrcwRC7024MySbCiusHnDQxOPSpM6Je9BkRu+7TxLDzzMuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(66946007)(53546011)(26005)(2616005)(956004)(66556008)(86362001)(66476007)(478600001)(36756003)(2906002)(4326008)(16576012)(4744005)(7416002)(316002)(31686004)(8676002)(6486002)(31696002)(8936002)(110136005)(5660300002)(16526019)(186003)(54906003)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1Y5MWV6VlpsMlVaRFJyNFE1bnpKVW4xdEp1cE1BVlE3dzVwVUVORVZCMHNR?=
 =?utf-8?B?WHdjSi85QlQ5MjZiR2lZb3VPelNRNEd3ZWo2REM3eExUWExNdmc5OXNML3do?=
 =?utf-8?B?SjdvcnNJTjM3Q25UdlZTL0VFMFZNVWJVNWJnY1krSXh1WFJJU2FUWVZ5MmJl?=
 =?utf-8?B?TkswTmZlbHF4VkM5N2NqMmN3RXBOSW5meDhkUjBYc1EyWG5KM0dxRys4U3Ny?=
 =?utf-8?B?QUE4MzlLcTNrSStDY3oySnh3ZDZVczFMdTVSRStKQzRiNERVSnN4ZlNtaUIr?=
 =?utf-8?B?OCtYeXlla2k0VTdjd3huT0JQNzE3UlZ1dGYwZFdyTi8vSlBBVFA3dGhucFlV?=
 =?utf-8?B?VXMyVmRJNlg3TkVMRXFDT25mT0hjb0JiVTh0dzdZS1NnYjNqZ2Y4bVM4THNS?=
 =?utf-8?B?cmpUNHFRei9UcWdSWi9XSHBQWVdJQmxENXYwR0xJeWRENGgzVVZkZmw1alNC?=
 =?utf-8?B?dkkwMmtTTGhsTk1yakR2YkpQSUFYNjkxWmNSaUcwOS9pZ1hTUS9hRytQc0F3?=
 =?utf-8?B?cEV6ZkE2dzNmR0F3SGlmLzYwNGFqZ09ONUd6M25RVEpLaWRudElvWDZlMFl1?=
 =?utf-8?B?U1d3L0szVVdjQ3FTL3BPcnlwcjh2Q3c5KzU0ZWdlTmdna2E3NlVvSU9DL3Ra?=
 =?utf-8?B?Q25DZUJ5VElCU1htR21MRXFUOTBQTWhhMzZrV29PRFhSeStiVGhFamJHYUkw?=
 =?utf-8?B?RGpFY3p6ZjBjZ24wUjRnR1BiZUgxWVF4REswSnZhMDFwZG9ZRVBWbHZNN282?=
 =?utf-8?B?Q0JYcmZZb0pGZDJMWis1K2loZmZWU3luQTRZSVp0amZhUDArblpJak9nRzY0?=
 =?utf-8?B?VTJHZk5EdDZNblNIdFRjR2pHUTdnZ251cW5aekRBNnFpS21UeWk0SDZSUDJB?=
 =?utf-8?B?NkZ3L0FuNTRpNEQvajhlM1RMSjRwTFF4c2djZENwaFlPS0ZidHBqV1RFbUNU?=
 =?utf-8?B?TW1kSTUyakVqWHVjM1A4YzUzQTdoUS9OUkMzYXB2eGl2MTBHQ0lOdmx3aUpI?=
 =?utf-8?B?NVNRTXFLS1hrM1FsaUYwMWJKNkZNRm5STGxtYXRpRVhtb0paaGJYMTZwNXRw?=
 =?utf-8?B?Uk5NcWJsckM0U3E0bkpmbVl4c1c3eXcwenlrNlAydEJQd3RUS1F0QzVma1g5?=
 =?utf-8?B?UFFsM3NtdHZjOFY3aE12cTBJejhON0tNbzRGVE84UFlOVzc1MDUvK2xveXZt?=
 =?utf-8?B?MHJ3R2ZKOWN5Ukt6Mm1NZVVJRnh3dEFSMStOb1hQZTQyUHhzdGswb0tFV24z?=
 =?utf-8?B?QnhyMTJBWm1Bbmx4T1lRNWpHSnB2b0RZb3pXUjExYTdxNE4rOFRCdVZFT3lG?=
 =?utf-8?B?L0tiVjJGbDJTWTdTQU1zQ3Q1Zjd6MEtzTjJQeE5DcEMxYk9HTFJncXNKalNn?=
 =?utf-8?B?Q3Zia2xZem10eXU2bzBxc1N1b3JFZ1lneHpsUmphenVldUYrNGZtMVE3SU9h?=
 =?utf-8?B?TEZnQlVXQTQ4VGo2OU4rRmx5TzZvQndwK1ZXRVBVYloweTdwZzQ4SmwzeXdY?=
 =?utf-8?B?Q2NCcVdnR1YvQmNmN1g3UGdZaFR5eC9RcVU0USt2N0I0cVFuVHVuL2dSVUpJ?=
 =?utf-8?B?NlBOaEE3TE0xakJ1blUrQXF0YkhCVW9TWW5BeURhTkJZWVdlS2lBK2xlN3NT?=
 =?utf-8?B?MUR3VzE5V0k5d3VBRjZVTkE3RnNGUTg3d3dXMTNGM1hmTkhrek5YRlhTdURn?=
 =?utf-8?B?STZMUllZelllSCtRQTNmN2pMQVVHYXdIZFVFRkNGNjhHclZQTE5LYXNXcThq?=
 =?utf-8?Q?FEXZHaywoezXdGVQ5u2rLPpGsWlJYsusLvycMLN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb77a129-71b5-4cdf-cbfe-08d9364887a0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 13:12:19.2922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y78P4LZ1Z0QQaix14J4mPAKLfHwOzbEjb89shiy47SiZ4eLiSZZzZignR0xd/q/PPHJMsY9sRykaPK2x6Rq8FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1353
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/21 4:32 AM, Borislav Petkov wrote:
> On Wed, Jun 23, 2021 at 08:40:00AM +0200, Joerg Roedel wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
> 
> Ok, so I took a critical look at this and it doesn't make sense to have
> a differently named define each time you need the [63:12] slice of
> GHCBData. So you can simply use GHCB_DATA(msr_value) instead, see below.
> 
> Complaints?

None from me.

Thanks,
Tom
