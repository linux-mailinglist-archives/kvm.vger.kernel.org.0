Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6933D2CF47C
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 20:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgLDTDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 14:03:15 -0500
Received: from mail-dm6nam08on2043.outbound.protection.outlook.com ([40.107.102.43]:19969
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726405AbgLDTDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 14:03:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVRUhV6/f/X+BRWy+SNanC7DUsEjmo4vURbvbgNKD3RYLxWifssCed877U3iJJ/UObkaVUJcRCAWkcaYgxgEcJ9r6pNNw+loj2EoI7aFcLOPT/IYvyX7OmZzKsRO1B5ICn++/d/2DLDra+doub5xy8hzyFy6m6k0zIX8o7LN5Mta19gwLLdYfISsa9cezio50C3pv5g5WFVf/nCJdMjcKD+YZM5u/PjFkxYAeWk2q54aojGVjBXeUA+6m9nsG/kbWaZyD1vnTT/HZCtBsTb2AyWiWQ73u7BVjxQNBDEmPhn/lKDgK3+vHYzuzyJ51x36GNh/QWHkjm1rbSd7ThPDfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BgwQS1RiQhCeJHeBceWQEJlUJua1En8L0mT8jmnWnw=;
 b=SfWp75jyz3WVs3LN2Ti2mQSnHvnY/UwbF0VPNL3AaN0gv0U3eE5cWsGQx/leOX9ke9iohELNSE4cH4zQtgTYOlcGYm5ZsVibSSltpXRu7GhFPYRpRwKCIEI+r8wNQwnD6HrGJpnnl8yMVpbquVaZQ6ErnpQgN2Y3FEMCU/fwbD2A3Xm73M1jocu5xxZ9zXssVQfUziuCzYw7+7CUtVJgOI/oebG5az7Ibt7n79hDpjZjlLFcayJacmMt5ibZLvHzgEFpcqs3PzgSWutBb7RpMb5R5C6k9GN71D/GmlVXPJLimDnEbr5uAmqlG7a8fepiwyCTFcTSuBLKiUDNhWVFFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BgwQS1RiQhCeJHeBceWQEJlUJua1En8L0mT8jmnWnw=;
 b=OVQ9OJ+x/vbo68mq+EILX1OEpqT3KtoxjIgZzUTT1jaXSgiO0CmG0huRL2DZOXeKTDtl3t6/8P2ofq7TioA60jl+WuWO2aRkBNswBzDdoG2weZRvUtwIH/lUTA0DpPVhqEw5wDEJUedVVFdM0CmKpDqy019AujeKxGWU5YdMP6k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3769.namprd12.prod.outlook.com (2603:10b6:5:14a::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.23; Fri, 4 Dec 2020 19:02:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3632.019; Fri, 4 Dec 2020
 19:02:21 +0000
Subject: Re: [PATCH v8 13/18] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
To:     Sean Christopherson <seanjc@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     bp@suse.de, Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        venu.busireddy@oracle.com, X86 ML <x86@kernel.org>
References: <X8pocPZzn6C5rtSC@google.com>
 <20201204180645.1228-1-Ashish.Kalra@amd.com>
 <CAMS+r+XBhFHnXrepzMq+hkaP3yHOUELjyc65JQipKCN+7zubVw@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0c195754-9ffd-8922-4259-79755f971749@amd.com>
Date:   Fri, 4 Dec 2020 13:02:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAMS+r+XBhFHnXrepzMq+hkaP3yHOUELjyc65JQipKCN+7zubVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0103.namprd11.prod.outlook.com
 (2603:10b6:806:d1::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0103.namprd11.prod.outlook.com (2603:10b6:806:d1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 19:02:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fbdba91e-3372-4477-a17b-08d898872115
X-MS-TrafficTypeDiagnostic: DM6PR12MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB37694236601AF00FD86781FDECF10@DM6PR12MB3769.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6IPE6xZOdcfJ5eifheYywxMMuZSCYCORy1q8TSMGPFkiAmb+s2NCpfcZsQqZj6Wug78bN3vNKREk3fewx8Rqe3/uGNR9E5EFkHA0iYMgNEsdhcm4y0BxBHHkcM8cYMuBIOUttHLxzn76mkR+faQ4hgwGytAMEKOp+5WOBiZOnw8VwX8uIKpUFoLth0TAUThPkYP7CcVkZeV55n9BnvDwvkJWb8BLeTMkd/tt3V7d3DcjuKBD5bxBbTnMv/fyQZWDGmsdve7NKCUBI3JNyDkmhcTy19oUxuJjGx6XP9Um8n0BXuzU5OdL22+tWLTCbqynNN97kb5E5LUfVZlz7T4A9+pI4OFVvzWG4RAD9g2nkN1LlVn/p2gf4esADxM3DMMr7vN8cZz++oipXpifNFHWcxSK+i9fmMDZyELis6H+mlI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(36756003)(2616005)(4326008)(31686004)(6512007)(53546011)(2906002)(186003)(4744005)(16526019)(956004)(6506007)(6486002)(8936002)(7416002)(86362001)(66476007)(5660300002)(66556008)(54906003)(31696002)(66946007)(26005)(8676002)(478600001)(110136005)(6636002)(316002)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U0dQWVBvbDAvak9TUVVhT0hhUGVnSGY0OExvSS9ESHloM0dQMWQwWWJKc2Vy?=
 =?utf-8?B?TnBIV2NWbE0wQXVBZXEwWE5IWW1XMnFGQUJqU3pIb1gvMk8zUzRmOE4wLzUy?=
 =?utf-8?B?U2NLNG5QQitab25TdnQ4UXl0V2F5aElFek9kNDlvU0IraUtKRWM1ZUZqZGV0?=
 =?utf-8?B?R3poTWxIcFhCYmNscEs4V1J4TWljMmliUU9FUmlncVJQWFJmUG1HdWJPZjRF?=
 =?utf-8?B?WGJhRVFRUGM2eEZiRUNnZnFCVkY3bTN4ZE83SnI1QVJWZmcvckxRZUc2Tk8z?=
 =?utf-8?B?clNFdXM0ckdyamRqOFlCK1ZwNjU1dFVlL1k0SkdIQWg0QmZKQTVKNFpnL1ZN?=
 =?utf-8?B?bENwcTJyQzBQQ0dlYldQR0lPTmFjVzhYa1drcVdKckhFdjZFblRRTEREY1hT?=
 =?utf-8?B?dWt0SUhZNXF1OVNNcGNSbmczZEFDUDFRUlFQSEk5WFEwZ3NCTStDODM4OU1G?=
 =?utf-8?B?R2FUTFp5ZU41UmpqYzQwcU1XZUF5SkRDMkxPc2N1K20rZ1l0NWliOFpDRU53?=
 =?utf-8?B?eUNSNVBnZ1ArLzcxYytVdzM1V3o4Z2pQTFJLUnNueEFrVnV1OTM2anQwK09F?=
 =?utf-8?B?QW5YaUJrTDRYZTBvY1Q0bFhxR0JabzBGS3FOYVVMbDBNY1lVaTNSb2tHQmVK?=
 =?utf-8?B?V2NvMitDVHZHaU9BSnBYU1E3a3RIN1BrWDJ1L3FCRkd0OFF1Y3ZoUGRkTklJ?=
 =?utf-8?B?MHg3Q2FVbTl0WFZMWGN2SWtPVERYQXlKSm01S3I0MVljYTU4c05Cc0c2YUlS?=
 =?utf-8?B?YlI4K3RGcERacEQ0bm9Ec01WMU5SVDFPcGpwSDBrcGc5TkhqZWpRcXV4N2N0?=
 =?utf-8?B?RXk5VXIvM2NaTGJGMVlIZHBTR0ExWDYxYkZOU0dHUlBscFlKczBRNUs1d2Yz?=
 =?utf-8?B?WnVhbFZycDNjNm5uUExzNnJGcmF6OE00U29oSWo0RmIyY2ZEaDZObWlldjc0?=
 =?utf-8?B?Sm1EY0NFRmIvSkNzbTgrQWliTSt3cmcvclB1TnRVK3lqUnZUckRXeVVNbUpS?=
 =?utf-8?B?SkxUNWEwUW4vMzVSRFUrbVZwY1ZvVTdybzczSVkzZ2pLaWVqbkt4REJmWW5G?=
 =?utf-8?B?cFc2M0dBbm5WSXJ3UTNOVjJxelZuYzFoUjliQ0tEdi9iUXpDV3dMYlZ5a083?=
 =?utf-8?B?Y25JWVNoalY4MS81SVZTc1NRMFR2dzNqUmU3OERWUGdZM05oS0ZCZGplWnRG?=
 =?utf-8?B?VEZJWHIxZ2x2MG0xVGxtQXNHbkVlSGNYVlZHa0hjVzA0MS8zdVJVcTRmNXo2?=
 =?utf-8?B?c2kwYXM3a080dnpOUWFhaHRoeEZxUkp3a0hPZmcrMjUrcmJlaTBoSkNweVdk?=
 =?utf-8?Q?ucNEKxeC5xtBnDSXLgFPwsprHguzf+KSXl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbdba91e-3372-4477-a17b-08d898872115
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 19:02:21.8506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDnrYRUwByTCZgtA81XRlktmXk3DvkCuN32ORaNb+TjK9P6OEnmVsWSrSfiYmS7x8AqTfNYzJ9hDpYLxebDMJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3769
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 12:41 PM, Sean Christopherson wrote:
> On Fri, Dec 4, 2020 at 10:07 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>
>> Yes i will post a fresh version of the live migration patches.
>>
>> Also, can you please check your email settings, we are only able to see your response on the
>> mailing list but we are not getting your direct responses.
> 
> Hrm, as in you don't get the email?
> 
> Is this email any different?  Sending via gmail instead of mutt...

FWIW, I received the previous email(s). It's probably something on our end.

Thanks,
Tom

> 
