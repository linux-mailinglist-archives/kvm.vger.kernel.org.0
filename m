Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7915135C8CA
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 16:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242315AbhDLOcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 10:32:06 -0400
Received: from mail-eopbgr760070.outbound.protection.outlook.com ([40.107.76.70]:35129
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237806AbhDLOcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 10:32:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbNp7V2LqfB3ZgNxBsjbHIQs+S+it9l+pn1cr+opX6LP5lM8bkqCndFSCW0yodPl/o3FzNeF9MWk1DnxT/DFhnx+YSulkQRD8A4h3v77RUm5yi0clNW7uwTwtmoZcsjeUXVMfu+dDJEipjcHBi59w6ZEfXJzqm8RaHaqhjy9MB6ijQwyv4byqo6HQFkTlLvNIJruMm44Bch3rvuTRYtXBVZPcCr/CVXWCFU8kduBioSeuiyaAQkH72lr2dDEJc538CF1FP/bJK7bZctzwkvunbVoJS/Ees92PHHq9tA1sA2nv3LH3zEzl4dTbX6ht60IteuSB32Dq3K9ElbZudjiyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiSfTvTwQdbKl1519bUroV93Ldi6b/V6oaBVi1UC2Rs=;
 b=ey1iDnfRg+fm63ONdH/0s0hXN8l1iV8EwkqIFs+RuiJq//02H8uy7MKDCWXESmqUQgpFlnzULVEgOlRybQhEoPQJvP6H1SiayIstKIqjblcPaPbtrWjaAb55RcWruHjvnOkFYFSMTuplknyfEaITew5ZAD7COonY8JbS96glNgHzkNGpYmonHXCwBWTyhhQCI8ww9QjLMyFq2AVVAkrPVnUprd3zBhcqV8pdFh6freFbyKOieXvW9biiRamilp1qHnVu7OLjXMNS4reLLTmJZ3IxOyEwSvtQ3/Gqo0VqRero8LWx1Opb2MTswDudr6+FpCKfapJX3o/aPzpw5rJ0yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiSfTvTwQdbKl1519bUroV93Ldi6b/V6oaBVi1UC2Rs=;
 b=eaBjM3oyLbsvy6c0wgTiNBtROyIp7iXJ22Hm4YMDn6lm/Yly74a/41fJi864v4p2Ts62ufWJurl0djOh4IK3axfbACIALUxkm/3nR1jwTbY1BFtmKH9yeyvjVMWg93+rPhJijCI23JLL7pPlRO1wwpNrol5JOancFiufhr2cAwU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 14:31:44 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 14:31:44 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 13/13] x86/kernel: add support to validate
 memory when changing C-bit
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-14-brijesh.singh@amd.com>
 <20210412114901.GB24283@zn.tnic>
 <f9a69ad8-54bb-70f1-d606-6497e5753bb0@amd.com>
 <20210412130542.GD24283@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <b38c18c9-64f4-a525-5b18-88dfe575f6a9@amd.com>
Date:   Mon, 12 Apr 2021 09:31:41 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210412130542.GD24283@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:806:d3::8) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0003.namprd11.prod.outlook.com (2603:10b6:806:d3::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 14:31:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dfbe096-33ec-4b79-046b-08d8fdbfb1e5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4573C4A0B565EAF893239B0CE5709@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UgAexwM58U9tBiFIPN92S7AAVZrkQXwIH6MdNBZmvQ+NYwu0nbmmyIKakLQT8y8kwSzIRfboFYtBXsSS0OxQcWyYWxfuEN7K7nUYQotguL3e9acRZG+BGj/klL5PeBXXS2MKY6gGgb4lnl6NGkFvA/0RhcwSXFj5NDaMmzelcplU38azoKUkYPcqDJ8bcdH/WyFXGBJGrW4lV4Vgx6MexiozUxoFnccf6jAO7FETv59dqxkCI20cd7QOPeufyPkRsKc9VGgiC3L4+c5cnlGry4bQsOElRnvcrFy57uYj5PQqBRoP4uLi7vZWVNtT0mYUse+LWZIlkJg3G2KQrTx+eZ08QJbH0aLO47ArZMIy5+NxQEoOfWfsAHBjK1bwKrm8oznRcoUckb4U/MExAL+Vv3KD2d8cefFBb3vvhbqF6CaHINJ9jdt+YpgSNTpRt40FgOqWegfAKJzIZNBBhbGLMsxhPBs3NtsRnCSgF/BI/w1DaZMovXMbNH8fQPDm71T2V0iZC+nxNCp3VOvUB24C2JhnSKB4EXdHNl35OImdwz+YiFk+ZsLBpeKbidWc6tsKRlTbb+eoKcRube3jMo3WhHWH/CAZ6cfMSVKkV6BU3Sgcb6OgwTq71oxr6WZb/08EjV0oWwoEn1m7e+f7BWDZipx0wsHoZQShBZTWGQLPwg22OzWMqBuASwdPEsBOGV5wCG68hOBJ3Zx40+GvHUkt9OG/OOXjc04Mbb+c6ZHYP3g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(8936002)(54906003)(316002)(6506007)(44832011)(36756003)(6512007)(38350700002)(53546011)(26005)(186003)(6486002)(6916009)(52116002)(8676002)(16526019)(83380400001)(2616005)(956004)(66476007)(66556008)(66946007)(31696002)(86362001)(5660300002)(7416002)(4744005)(2906002)(4326008)(15650500001)(478600001)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U0lkTUdMOWJaL0NhQlhUaUNVTW5QNmVlQ05qTDNhU0QzZm4xTko3U1pYSjNi?=
 =?utf-8?B?QkRZOWova2RGWGVZd2hudDNyWnJ0R0N1SHZUMGdwc01SOGdZcGZDR0pEQkE4?=
 =?utf-8?B?d05HVGpxWTJVR2x3WHJvMU9PVUNWTmgrLzYwZkhvczIrSXBGMGZBeFMvRnhn?=
 =?utf-8?B?VEgyV3JjRFdlb1JuZi94Y0I3MmlsWjcxSkJya1R6K0hUMzU5cnNHb0s3aHZy?=
 =?utf-8?B?WVVINmNveFVrckFYdW01YkY1SGN4NHAwUEZEeC9Wc0krTFBXOEpuVlozOUtQ?=
 =?utf-8?B?SFVhTWJaMFphYzZpMHI5SFk4bVYvakp0V0VJTVFBdFFlM0RGdnp3WWZqWmQ2?=
 =?utf-8?B?aFlTY00zRlVkTmVYbmEwM1RoNjVwNzI2eDBpeS9zMjR4eWlvd0VVWlVsVXdJ?=
 =?utf-8?B?T1ZHdTYvS2N0encyMVpscHlNS0FYVkRJWXZwV1Bzdmd4Sk9Vei9ObGFJWGl2?=
 =?utf-8?B?VXF5dFgxNmgxbFZsdEJaNXAxSk9vR3ZYWm91WTNSQTBvZmdyR3FUb2o5QVVB?=
 =?utf-8?B?UDRnbGJMSlNGZ2NTTFgyRkgyWFRIMjJ6MUk1cVpscmNuZERJZExQMTdoK1J6?=
 =?utf-8?B?THpDMXlpTVY0Rlh1UlRuNVUxVURQSitJVlVJN1dSZXBxTkttb0wwTXdkSnBa?=
 =?utf-8?B?QnIzbjQzVTc3LzJPQlRrUDArZkFIV0tuY052TG9jUUxBUEV3THlLbmlaRU5Z?=
 =?utf-8?B?Qk9qVG1naHlDQ0h0Z0NnT3BnMEI0ZjBiYVZxNUdFSFFPczVsYVlKMWdiUWtu?=
 =?utf-8?B?TUMwQ1RVa0FpOXpudnJHZWJIbElFQWcrU1h4ZlUvc1h1dmd4bE9EdjkxNWRH?=
 =?utf-8?B?S1NLMWZ5aGRwZ0lHajlMSTdqTGxHeXVoT3dRZHh2RTNHdjhTcTVkaElKMHIw?=
 =?utf-8?B?aCtiaWxlb3ZKRmo3cG9TWXlucS9laFlSVjZhSXVtd1VRbDlyUlA3cDdGWjl4?=
 =?utf-8?B?UjB1Qk44UmgxaGkwU1Vxb2d2RzFzemR0N0lwNDBST0x0bGQyMldWVE5ZTnk5?=
 =?utf-8?B?dko2MlhhT2I4NFJwaGFHeFFINXErTmc5SVA4RnhuNnV6M21aTE91eXloTEVM?=
 =?utf-8?B?WjJVdm10NTRmeTM2YUE5MXVCU0lDT3ZMRU5haGRDWExwZTJGcVpBTGJXUisx?=
 =?utf-8?B?MnNtRkVLNW1lc1hMWUZZUElTQ3ZNSnVydDl4NjM3Q2xjUDhZR2I0dDhPUFlU?=
 =?utf-8?B?SjVRTHlMcDF3dTFwd2xCZ0FNLzNwd3BGU0txaW16UmxMMVVFakdhbndLazBY?=
 =?utf-8?B?WTNua0tQVExldXFHYVpiQzVRdTRRU3F2NlRydDFtZmJFemp3d0kyYzdhaEZS?=
 =?utf-8?B?a2RISGZtYjdPbFdWQ3FjdndJdEV6K0VXUnlGNkxlVnJXcmd2WEdOMHFGOGY5?=
 =?utf-8?B?VzdNMFBoSHptVnB2djQvQU5SakRhUEtpMDBBNGFzZXNQaG5nWHJrQUZidXpl?=
 =?utf-8?B?d2o2b00wODJYbFU4anVjKzFJQVE0V0hDbmpSdTRxZjV4bE9jaVdzTnBiNzBP?=
 =?utf-8?B?WVV6STcxRG1xUlFPUnBMMTdZMGY0OE5sdklCQmVmSGhiWDVWVms5UmtwS1h6?=
 =?utf-8?B?TnFNNFYra3VORTNnTDNVcUVMdVJSaXV6STVVNWFJQlk1c2Eyb1pldWNsVnFl?=
 =?utf-8?B?dDVEdFZxQWwzMCtsdWd4OWRVSk9QZ0oyQTVYZDVTWVB2NmtoUWhzZXV0aVp4?=
 =?utf-8?B?aFFpVkdPY1BIYVBYY3ZmTlRrenQxekdaQkZoRXRUT2hEQnI5ZGcvWFdFelo2?=
 =?utf-8?Q?cMoPGwvxHRzwJuIQM4Xh4ZYgKqC19dkayTBOACB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfbe096-33ec-4b79-046b-08d8fdbfb1e5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 14:31:44.2839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xB83CDXffdCVHgVEA0yB0rTpgbqk25cN3I0GGylggESVLXOG1GBdNNWaCoO8jY6jpfj5wQBHDVoCLPjlHUCSYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/12/21 8:05 AM, Borislav Petkov wrote:
> On Mon, Apr 12, 2021 at 07:55:01AM -0500, Brijesh Singh wrote:
>> The cur_entry is updated by the hypervisor. While building the psc
>> buffer the guest sets the cur_entry=0 and the end_entry point to the
>> last valid entry. The cur_entry is incremented by the hypervisor after
>> it successfully processes one 4K page. As per the spec, the hypervisor
>> could get interrupted in middle of the page state change and cur_entry
>> allows the guest to resume the page state change from the point where it
>> was interrupted.
> This is non-obvious and belongs in a comment above it. Otherwise it
> looks weird.


Sure, I will add the comment and provide reference to the GHCB section.

Thanks



