Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185E726AA81
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 19:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgIORZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 13:25:27 -0400
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:4665
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727877AbgIORXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 13:23:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCD0VD6ZM0UR/DollkEemSQa6VHlIwuZzB2DP0SBJsKkVXOnWIudKKkxOFQpOJtdtIdGoBiHEGG+RCGmDAH5u1X6XxGALKTuUNBweMhhogXX6svwYuehmAnsPBvtaDFKXsMNnxhmK+rZy3xr62eGn7yBBeU5RAcNg8oF0ROnS7hAJrmqnJTFNpJh3ogsdCuwIMjIYV8bBRc9VmflGjrOxXySk229sqzPAWj0Ikgv8Xg5Hxt4NgQFHnUmF30I4lMH4cSNCFqK28PPMcYns7KSWMULtIofKyRoK7d7iUnPfstY1QIcJ8T/KjlBhzhMNVNv0wYChxjnMaZi6G4sJAZVUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45AP2CCcyirBc0uLykknAREqpS0odwhkuwdxE9nSoJs=;
 b=NFx87VDRvuqUfHKQmEg1ydYCvc2sqUa6N6Jet9wy6O3voyAohjtMemrLXP9FU90YmflpelBdsOcdQlwoL4xA7PN3hz4aaoswuNE9bomrjyJhsBDWxn4oRU0I1wIN9DyE0M7vsvypYLacfylTn02a/WfpytNjF3h+LFmh1PGC4Of8y+XLjwXr1aXFFeqj/usROhrKPKkk55ii+91u0kWL+aUK9YgCP0fXn9NCxbceyi2IutdjtJzHQcscBE4mz6bnwphgqwgK4Esvcmzv4EnGc9WbiQSqzkU7FFcMpy5mIc4aTOp7SCoDuZYMUARldy4V18defuhHtMTiUa/arsgpgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45AP2CCcyirBc0uLykknAREqpS0odwhkuwdxE9nSoJs=;
 b=SrMpSnmZ27TpeLtN7YckJNBPs28MuaTPTJj0MEUIYF6xhCPZBHFpuifBUfex/7X+zm0eEd+2NDcJyfSFFnXuiEXi5glJNiSRQZ0ujbyD2e3uurqg8MDEntX6U6p5+PQyeCneQ3ifws/Cg44WwP0i2SxST9RyJ07D+jIs6radJnY=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0023.namprd12.prod.outlook.com (2603:10b6:910:1f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 17:22:07 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 17:22:07 +0000
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
Date:   Tue, 15 Sep 2020 12:22:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914225951.GM7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:3:93::23) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR20CA0013.namprd20.prod.outlook.com (2603:10b6:3:93::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 15 Sep 2020 17:22:06 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53d79d93-b620-4cda-4483-08d8599bdf21
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0023:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00237F73BAD5DD539FF52F83EC200@CY4PR1201MB0023.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ic8nTdduiGpPb9df9SEpdAvKDOMfGrFccP3UPE9inkK6YNZXVaCLbHnaQHQJ4iYXL+mKExJyLZZULQ6avROdF0eZmDBuFEZ630obuNpkzZajwIs8zEYmfe0emlW+S2uyvaelA5aInmQMN3hPTzJgMDgz0nNYp1yTrhhM+2yty4vMZ44xwYPu4mX/jYTzznvAZxZhSgA4/QNfYH8Q9o3U5JGZV2tyCs7F2jgCAXuYDLFHWfPnkd4nliuEimR7f7W5qt0reWv34UQcIxk2R53oEhMpRZ5rofSzuz4TvDBBBREIhNj09kyeOiZf/d2sf5S6zEq+OjmKmRM8pWZs3fyePxZ3EGjP+85EaOq6zRAxUfBWaBklw9CoLKQicU5mb0cXBbSD3ctaaGCCD6aUdxllsrB0dFFKGug/nXO+cIVuMihtgyZPNN/BLtYpAlodjIVayzIoc1B01l5SxqyNlJVxPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(6916009)(956004)(31686004)(54906003)(8936002)(2616005)(53546011)(2906002)(83380400001)(316002)(16576012)(6486002)(4326008)(478600001)(36756003)(45080400002)(31696002)(66946007)(66556008)(66476007)(86362001)(7416002)(52116002)(8676002)(16526019)(966005)(5660300002)(186003)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: R/BQdfAU3VFr+VJcTt3sSHxY8fqAwxzPEij60dMTrE/AuLuDOQSDGQnu1QPE8wmhqVUfvqGF0cQnEArIBTJ4lbfvGLFCrkRl4NLW5J9jSa77Y+sybblZi7QLpnuLU/e/buLg9n+8ph4V7r+yyg3LcwxZUJAD4Ss81M71Es9PwM9EXA6ZapZKipQN0lU+O7Z7rbe6LtrCoOU/h+UDC6+H3JSveN5lCsQI48qu8HyY3Mtzl/D4yWDn/fMmdbhWYX5RK9EHHZj1gaiEYm/uk0iL5pT315XG1UWXtmYbHjgb7ieMwvXdVy4MPWMnZVnE5NT/8Zw4FVA2xOhZLdCh27ZJgu4m1kmxLwu1eZR46XbIRq3ux7eLPn7I0FyMnOgE71Rz/6Jo2sGtJ1+zRJjeIomxGgHdOppgldO1Zws/+EMSodTD02GYTjhmyHEzbbbS+onWhb9T66Eda/6WhyYJZLYInBOeithidEXFv7JTEtjWMtPySTWro251N5Q0AVlC6pVhCmsRxGHGc85FCE51WiUrAgRBk5morjjeSlxir6gzTvkM5kziKAaUNLzARrtltnyoB3XAeBeCPdNXZ5lZTr1ipT8eAqe65hKPuHsC2HBGqb5Vdp6ol5hHGsktDNlGb1eLKD/wGdIMkCy5FK0OBriA5w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d79d93-b620-4cda-4483-08d8599bdf21
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 17:22:07.5575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CziHm4rXjX6Q0/QY5dYUd7wYR8necv/R2l5jedTT1HdDXWDM4cOs7cta6JAtDqAtaePIdzdCDFs4zCf5VXw41A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0023
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 5:59 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:14PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> This patch series provides support for running SEV-ES guests under KVM.
> 
> From the x86/VMX side of things, the GPR hooks are the only changes that I
> strongly dislike.
> 
> For the vmsa_encrypted flag and related things like allow_debug(), I'd
> really like to aim for a common implementation between SEV-ES and TDX[*] from
> the get go, within reason obviously.  From a code perspective, I don't think
> it will be too onerous as the basic tenets are quite similar, e.g. guest
> state is off limits, FPU state is autoswitched, etc..., but I suspect (or
> maybe worry?) that there are enough minor differences that we'll want a more
> generic way of marking ioctls() as disallowed to avoid having one-off checks
> all over the place.
> 
> That being said, it may also be that there are some ioctls() that should be
> disallowed under SEV-ES, but aren't in this series.  E.g. I assume
> kvm_vcpu_ioctl_smi() should be rejected as KVM can't do the necessary
> emulation (I assume this applies to vanilla SEV as well?).

Right, SMM isn't currently supported under SEV-ES. SEV does support SMM,
though, since the register state can be altered to change over to the SMM
register state. So the SMI ioctl() is ok for SEV.

> 
> One thought to try and reconcile the differences between SEV-ES and TDX would
> be expicitly list which ioctls() are and aren't supported and go from there?
> E.g. if there is 95% overlap than we probably don't need to get fancy with
> generic allow/deny.
> 
> Given that we don't yet have publicly available KVM code for TDX, what if I
> generate and post a list of ioctls() that are denied by either SEV-ES or TDX,
> organized by the denier(s)?  Then for the ioctls() that are denied by one and
> not the other, we add a brief explanation of why it's denied?
> 
> If that sounds ok, I'll get the list and the TDX side of things posted
> tomorrow.

That sounds good.

Thanks,
Tom

> 
> Thanks!
> 
> 
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsoftware.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fdevelop%2Farticles%2Fintel-trust-domain-extensions.html&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C000b3d355429471694fa08d85901e575%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637357211966578452&amp;sdata=nEhXcrxY7KmQVCsVJrX20bagZLbzwVqlT%2BYvhSYCjHI%3D&amp;reserved=0
> 
