Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1171D2DA01D
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 20:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408809AbgLNTHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 14:07:55 -0500
Received: from mail-eopbgr760042.outbound.protection.outlook.com ([40.107.76.42]:11936
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502674AbgLNTHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 14:07:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4lIgqFBymZwmSnTNeRibRYSLOCsOSoBFmNc6rLRjmeErGBokoK5pF1BXePr9btYqr86WuT6x0YwHRjUA0W8taPitcF51LeafsHRt6eikYmoKESnzlhR72euWXwUJv4xkAVODyM5/7jd1k0FKhLkoblHlX+l4CwVTO7uTVV2dysv1ua7ohxMVxnpq2SVcN22dokOj3AjZW7FNM5vd96fW0YyF50JKDH8+12u3/2YU+0XA9b7zSTocidwjpZY5yzlYavogvnRGPzSFZTE5KsXWQfd6Ps2vh8qQRqoV0YkzDVZnzKD6ui4vN1692ffwuhTdUdZ/vPuGzavCbBMw/ZiKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyICLoKyx4fdodYyuZ1tlprlTiu4Ikue/l8h8Bxxd1c=;
 b=mIVw1/BgkmuClsnUP3CteKdCD9He8ArTWjGuJEg6TqPVaT3+lJExnSQyMjMgm+3+lJUZTM7XczOQCxrAIAXoMUzXdcPMzLJ7Qd6sPCJSWgGPCblo80Ep+3oan8SikEv9H7tUxtmVixBPtp6Y7QnHvwGqER5pQDCH9Z//F52PrB9n3e6qWqRhBBNbfn4CgBoLNFVxOFp373NbGC7MVD7Ca82m+clz3Ws8IZEWtrk9fJHWccVtXCi8VO4AoqHwdrT0Zv50dGYJov/u063tZ8t5FqmJEYqwrUukiAxWj/ZTSFUhAR+qPMb1+9fhDbnCMZ08Og2PurLP3NOIsI147r8OKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyICLoKyx4fdodYyuZ1tlprlTiu4Ikue/l8h8Bxxd1c=;
 b=jT1jhoNFKzsz+ShcrMNnWs9I6D+0WyN+gVXcEpZf1E27migMdKcEpzvzhe2UL8QYT4ocpd2WY2jJrOTfXfFzGX8meXs8XHLJkLuLuyHtzdq1EvkCJYhrOO7FJ3YZ68I1TpWGlN1VNqbKXDOuTLeqWYCZrH+czg36Ay2kTN56Hu8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1260.namprd12.prod.outlook.com (2603:10b6:3:78::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.13; Mon, 14 Dec 2020 19:06:51 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 19:06:51 +0000
Subject: Re: [PATCH v5 00/34] SEV-ES hypervisor support
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <e348086e-1ca1-9020-7c0f-421768a96944@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <7b34fc11-0303-221d-85c5-eb0326e6040b@amd.com>
Date:   Mon, 14 Dec 2020 13:06:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <e348086e-1ca1-9020-7c0f-421768a96944@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DS7PR03CA0188.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DS7PR03CA0188.namprd03.prod.outlook.com (2603:10b6:5:3b6::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 19:06:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45c56ebf-d0ad-4a4e-7282-08d8a0636a31
X-MS-TrafficTypeDiagnostic: DM5PR12MB1260:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1260A17F69AE21F85B7B2AF2ECC70@DM5PR12MB1260.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dmd/Ce01bI+oNTjvc/G9MQTW/sxRw34YQbUegOgL5hG6gDlg1VNH9ZYdTLm0w5U9JiwV7j9/iB9lx8xro4ytDGyN7hQq5yHmp7UhCN1QA6SOVvUEqoUtAxam6nhwqGueUu+g2SFlN1UsRGmdSrReQAUsuEW0qoJxmDz6ruByJ+u/HKx2a6uLnZHk0+H8t+X3rvRHPr36wqyXvkIYgo5TFBGncZYkQRCZfev+pYy/0c5yS8wijCMDO7VUrsPKw3DUIysqLfRyJtZqeXM9+odXu/VG6WXWQZtvnort7HQNOU8BCe5SrjixHs0TFitvzLtXk+OhSuhZDXoQSaXzG/KSPRxBvjIjb01Z34PdLbTDQTARn5IjT6XXfldIgHXlFuaUJguIEoUVrrV7ZyweGDycXdgpMIY7kSoWpnZpvKpWtKawegiX5GMXW+AvrPKTG8es
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(34490700003)(7416002)(16576012)(86362001)(54906003)(2616005)(956004)(53546011)(4744005)(186003)(16526019)(52116002)(36756003)(31696002)(26005)(66946007)(66476007)(4326008)(66556008)(6486002)(2906002)(8936002)(508600001)(8676002)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cU9XWW40NWpJTnY3LzYybHFSQXQ2KzROdzJJM3Q4dk5QM2hXeTBCZTY0Mkt1?=
 =?utf-8?B?NGdBbkFHVldFVUEyZWJCdHU5a1lwazI3dTJycDlOdDYwRm1DS2Z6TUhmRlBC?=
 =?utf-8?B?cjNZR0xDRHVFZmNNRFN6QjQ1NGxEMEYzUHFYK3JhYVdKZWNCd2hoZmFwVEpu?=
 =?utf-8?B?bURwblFGSndkOVNZTTZHZG00RkY3d1FRZnlUbGxCSE84d1k2RHdQY09WQ1Nv?=
 =?utf-8?B?NHpNa2lTdU5GUW1EN1FSQlY3bGZ6ZTlKczRsaHdGRjYreFhBcGVEWUdEaUtB?=
 =?utf-8?B?ODgyN0RhdDdEWmc5NHdkQUMxaDRlSk1rQXpLVmVxbHVPVUFJK0UvNzl4VEQy?=
 =?utf-8?B?UUdubjhuY25OL0tVZE1oUFR5L01pR0diTUY2SnVMNi9BcGNhSUhOK0ZDOHZ0?=
 =?utf-8?B?Z21mUXhTTlAyMG1ZNUNxTVBOa3RMKzQ0dHdyNG1wSFFxSWNJSVBKclVPY1Rr?=
 =?utf-8?B?L3ZGQzJrdkYxTlhkaVZqNkRmMkFjNlFXMTMxRVp4QnZoUGhOa1Fod0hUcDRR?=
 =?utf-8?B?cnVzbGF2MXREZkg1ak9DYXBBb3RpUkRFdWorYmU3YjlkSUNLNFgrZ3hIdVJH?=
 =?utf-8?B?Y2d3aStEQWpnWjREbE9TSUtnYjB1NWx6S2VtaHAybEptR3BSOFNKVEFwYy84?=
 =?utf-8?B?VHhMRUxNN1hwdDRESzkycEh6U1FVRURLYVZxdTVrTVpvb01lWGhZOUlVaTZ1?=
 =?utf-8?B?dlcxRi9oemJtVENnbGZqTU9xbDRkVVR2RUtLdHNRU04xOTZxaVlFMVg3Z25q?=
 =?utf-8?B?UFRORGxEVHl4b203d01laUtLMlg2TG9hODF1NHRkSmdUbG05S1ljU0QrK0JX?=
 =?utf-8?B?MmpvcWNLWkF3Zk5Eb2M4eE1IYVVwNGp1ZDNNOXBOY1VZbjdjN09RdVlJYkV5?=
 =?utf-8?B?bXpmbW5WNm5OY0lVSmlnblVYSFdVcFJSb3pVNFNuM3NSUUpQRm5DL2ZwMXBY?=
 =?utf-8?B?UVJ2RXhWcEcxTDZ3Z3MyTjR4eUo3QmpnQmlhYlRxWlVSVno5WXhwWWZXVmZv?=
 =?utf-8?B?dmRNN2dzV0lMNjlPOVBFUmQxRXhjai9GQndXMXJLQVM5Zjd3elNWSkh5SUV3?=
 =?utf-8?B?TC9OTm1aMElsZG5CSmMwQ2xnc0FvNmpqOXpwNkc2L2JzNTl3aXkrdERGSERD?=
 =?utf-8?B?eDVDejYrRi9GdkVjL2lZb3phZnhRejRyaXoweFR4UEJXcnZZOE9xa0ZKVE94?=
 =?utf-8?B?cEZiblRMNll0OTRWdGU0REt0cE9NdSt2MWdyMXZENDc0Skdjck9pQmVRaDVK?=
 =?utf-8?B?ZGY3M2FCWGphZW92V0xuL3hjRjZCWjN4QWxLVHpQS1JxeFBwYW9McUJzZm9m?=
 =?utf-8?Q?h7wOnvLbCowXB36cccdCVGFYAFViMoF3+1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 19:06:51.5657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c56ebf-d0ad-4a4e-7282-08d8a0636a31
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hX7BM5zQVjlTlFQ+IOOw1Gmx/m+LGycOcq0qlKzMFRcbxkZe4jQSs014KJcBIG4W0onKSH+BAUqPERwbwN/rvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1260
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:13 PM, Paolo Bonzini wrote:
> On 10/12/20 18:09, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> This patch series provides support for running SEV-ES guests under KVM.
>>
> 
> I'm queuing everything except patch 27, there's time to include it later
> in 5.11.

Thanks, Paolo!

I'll start looking at updating patch 27.

> 
> Regarding MSRs, take a look at the series I'm sending shortly (or perhaps
> in a couple hours).  For now I'll keep it in kvm/queue, but the plan is to
> get acks quickly and/or just include it in 5.11.  Please try the kvm/queue
> branch to see if I screwed up anything.

Ok, I'll take a look at the kvm/queue tree.

Thanks,
Tom

> 
> Paolo
> 
