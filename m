Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B4C203FEB
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 21:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgFVTOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 15:14:55 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:6059
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726854AbgFVTOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 15:14:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tr/vfrU11zfCALcd3K6bO6tx8xqOTNeq/X8D+pso9unDM9ALivYjkxqZyWcaE2tRaSEAP1hyU9vaUN4y6cjckvyv5Z7rfVQalxq1/n3eZ4vvB7NdM8ZO4uV5ZHFMxnJJib/KxFppiYshsqFBHftXJUQ/07ENOY376vnSldBBQThoyiAJb3iH1J7N0CVdsO/HJvsmAvSayDAyU7tc/qwF7pMZxxROPnxu46Vvla5I23IuOJyBKAxZ5OD8SeSrC7TfklJl/kXNIwHh6zadZRpsyEzdGLe36kPHmWiZwNY2WoI7tQwiLKCbSzGvPD4L53QPKEMnPzLij2CFKTxf/slB3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMK2TfEBaI9IVe+IrSghX70O7diJp1NZi2F1CJw6Uug=;
 b=Acjgov2c9ONov52DzNblRrx56bkOzbvk3jFJ5rVEDgxgdkkzIOk7gkvsL398JDFxTSTu+VOMyHzJZOSELYk12pLSDqur1Kt5d1mf/VBQM6wg+h3bZpRXnBCsJpvc3N8yA8cQGPxSYdJioA5BCIm5XCtbTqNTiNOLTrRrJace5XY48W1E45qq+7UhIxhqHeYFuN4NDWi52TUYvnSILkgs2MVzHSa8AMt6M60SKzeKeswFRAiXOTiuQGrvye52+iSDIj0FiHs8cG+pS9+rSf8m2XH5a1wpcFXxjOjr5lEXSZuId5NLfkBw0GZZ8k7/1C+jtzfc3NJDSxQhdMUnZj4uQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMK2TfEBaI9IVe+IrSghX70O7diJp1NZi2F1CJw6Uug=;
 b=O8wwn43Cij3MktCwLgmiyohKIDRu7hI0zkSqBi/c92mBmOHlod2/PrWhEZU89QyR/uuTnzIj4MTwxR67AFs4GEuCLZMxCUXhQ6q+RurH6at6uQMn7+HASqHAeD6iXaTyyMshxkqVvdPkkTeh7MF0siU05ngZTJ89C8au0wQZQ3M=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2360.namprd12.prod.outlook.com (2603:10b6:4:bb::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.24; Mon, 22 Jun 2020 19:14:52 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3109.027; Mon, 22 Jun
 2020 19:14:52 +0000
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
 <0d1acded-93a4-c1fa-b8f8-cfca9e082cd1@amd.com>
 <40ac43a1-468f-24d5-fdbf-d012bdae49ed@redhat.com>
 <c89bda4a-2db9-6cb1-8b01-0a6e69694f43@amd.com>
 <4ed45f38-6a31-32ab-cec7-baade67a8c1b@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <77388079-6e1b-5788-4912-86ad4c28ee70@amd.com>
Date:   Mon, 22 Jun 2020 14:14:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <4ed45f38-6a31-32ab-cec7-baade67a8c1b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0128.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR02CA0128.namprd02.prod.outlook.com (2603:10b6:5:1b4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 19:14:51 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ea8f20b-0530-4633-8c8d-08d816e08a2f
X-MS-TrafficTypeDiagnostic: DM5PR12MB2360:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2360F8D82BE73E1269633591EC970@DM5PR12MB2360.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WtRHScAuUmpCIKWpfx5EnsgLEylrrAbJX2N96qwtRC7L/jC7WfVo+7gnkyfb33vn4XjoJe4ScVNCwWdfHLphOS2Se+i0vf/Ovbv4tBW2dBzfxIVacTWTxuWi6SGvPw5ym3YWMKv7sze3IiDM5ojnqUgpkbPogdboTJtBg6V4Tw9DCtprjfBor27BAByji4Goiyxh+TLaOW0+/M+4EXsj5vlMANlPgAm8DqH0KJBHElfosWyWWc4RsNcLcR6n2yYLjP4CPNjiova1xNjNu2MEN/7ZuCE26Xx0Luv6YSNT/WP+I63IR37rKek2gUrdvg97cfNBBm8fR8QCZj9BUIK5tAI2tntvo8CEh9ftlrXCrzBm4PRPtfNo1ypDBL/uWcrw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(52116002)(2906002)(26005)(110136005)(83380400001)(8936002)(186003)(4326008)(86362001)(8676002)(16526019)(36756003)(956004)(5660300002)(478600001)(2616005)(6486002)(316002)(53546011)(16576012)(66556008)(66476007)(31696002)(31686004)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +lsUxgmkspcbNn3ZA3FReBeOex4x2zBm0v03LqJdEzPUP2s5zXq6WANWwxhNf6D02gBkgO63lcqnTaSXJVtCWM4MQugwp6FoQND1c4DMPsDhYIWPZ+QLxt3DDaoY/FvtvUWYFTqC1hFD/+dUBE84ZuZyVP68h3zbRBMRblFLugSUsZ88zSfiHYKjU/ok/6wd3cgI/2ILroE5jWJA1pjsgQA5r8y5mKO3R5+bu6Yfmb4OlGB57YD84W8dQiRCvIdLTe7YAfWvmdMjCjyXJqwoBbvyXzqzIa/l/3QkMi+mHR5gR8OPUHc3LMPeGNxA1qppvqcpsU2Bv8MXEUpkxkfkI1Rkw8HdEVLFo0Jio1fI8mFRvmUknKIZvRqAQt924x1yHDVxpp+maT+DCjnAglMU9iBrvqKNujWJhU8vDIxv1aCiUcViX1EzGp+3FLpS3mgki/N0GWokDWqJvXFk2L6If8Ry9I/6NH1qfRf4h0yrBuQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea8f20b-0530-4633-8c8d-08d816e08a2f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 19:14:52.1871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eY27AYWpv+7UpKHz9jPZZjSwtr9VdyWeIpkD980Hj29S9USGzXv3pYurOf9NNYNXd8pQkdI78f5s44oqWg+XGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2360
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/20 1:01 PM, Paolo Bonzini wrote:
> On 22/06/20 19:57, Tom Lendacky wrote:
>>>> In bare-metal, there's no guarantee a CPU will report all the faults in a
>>>> single PF error code. And because of race conditions, software can never
>>>> rely on that behavior. Whenever the OS thinks it has cured an error, it
>>>> must always be able to handle another #PF for the same access when it
>>>> retries because another processor could have modified the PTE in the
>>>> meantime.
>>> I agree, but I don't understand the relation to this patch.  Can you
>>> explain?
>>
>> I guess I'm trying to understand why RSVD has to be reported to the guest
>> on a #PF (vs an NPF) when there's no guarantee that it can receive that
>> error code today even when guest MAXPHYADDR == host MAXPHYADDR. That would
>> eliminate the need to trap #PF.
> 
> That's an interesting observation!  But do processors exist where either:
> 
> 1) RSVD doesn't win over all other bits, assuming no race conditions

There may not be any today, but, present bit aside (which is always
checked), there is no architectural statement that says every error
condition has to be checked and reported in a #PF error code. So software
can't rely on RSVD being present when there are other errors present.
That's why I'm saying I don't think trapping #PF just to check and report
RSVD should be done.

> 
> 2) A/D bits can be clobbered in a page table entry that has reserved
> bits set?

There is nothing we can do about this one. The APM documents this when
using nested page tables. If the guest is using the same MAXPHYADDR as the
host, then I'm pretty sure this doesn't happen, correct? So it's only when
the guest is using something less than the host MAXPHYADDR that this occurs.

I'm not arguing against injecting a #PF with the RSVD on an NPF where it's
detected that bits are set above the guest MAXPHYADDR, just the #PF trapping.

Thanks,
Tom

> 
> Running the x86/access.flat testcase from kvm-unit-tests on bare metal
> suggests that all existing processors do neither of the above.
> 
> In particular, the second would be a showstopper on AMD.
> 
> Paolo
> 
