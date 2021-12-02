Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66D1466A8E
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 20:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhLBTmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 14:42:44 -0500
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:60257
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229793AbhLBTmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 14:42:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A64/ti9RmPi/plbiLrFkPD6CPFwyTRwg2fVdIA4wnsyjoZGijP4luO731ji4uFlvaRVJ78YJyIewz8T6FFm4nh2QRt+PmgCGN/Y7CHckvIv0Yu6lJka+aAhs4oy1HKQHWLpm51NcagX9Qcw9rs6Wr6F4TiXqBD96j4bK6pZ2Qp5oGgULK5it2CJ3Bm53bYLnSZLQjBrJrQHEUEEmuU1TB6aBj4zFWPSyzCX+2RBSNWnKYgkJ+MB3y3nPsbKRqIJHQJh5/9koNgzZrMwhrkK0a0TzxhPEjY4j2+D3a5pKPl/BkKVQ/VJhWXVyOJ1hQTvRvZnQsGYTriQLJF1QdopjDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiPB72rwKwwo719xLNI97gG6p7gvyw0sVafMjlmVL/Q=;
 b=ZoyGyWG7sr3forcrZZIAC2QwcxRuGYuZMCqwa9I7AcNYD37ne99D7CJwEPEsnmOl6C/doYOqfbcPYMJEkwSP+4UBiigV72IY1eQexE9LhdpKuf1h5CPQwgE7Ylj62N3ZGnn3F6oBcpfCM27KG5mQT+XDut89rIYKJRUog4Xm3rI7d3Tz7ds4ZUyQ1DCNNOO2Q1pip68dhBABYwBo3BcMIVRCRBM0KIonY2Di4TxrfJq1z3TaoOkcHQi2WNStmeJoW10Njrint/5Z65Kvi6Hy8TL2OcHohvyf75KVy/HVjkKYKuvvp5uP9WCFgMhUWQ8YwutoSYIH9wjqd+fvCgssiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiPB72rwKwwo719xLNI97gG6p7gvyw0sVafMjlmVL/Q=;
 b=BY6xE5WUbbCdsefhX2+KTk0Ts/b3SzNkQKnkaRpvD+tMrT6cLAnIWUyGAX4P0m0Ya62bnt4MMD43BKKiKEADIPuFhPmd9GD6dHBczCZaFBXZaAhWIeKjySOnuvwVd8fZLj53zXceC9A8GfieD0d5dNhWjMUXcv6ZEYNw/dgglOY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 19:39:13 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.020; Thu, 2 Dec 2021
 19:39:13 +0000
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
 <5ce26a04-8766-7472-0a15-fc91eab0a903@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b0443caf-d822-f671-d930-ff317833d701@amd.com>
Date:   Thu, 2 Dec 2021 13:39:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <5ce26a04-8766-7472-0a15-fc91eab0a903@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR06CA0028.namprd06.prod.outlook.com
 (2603:10b6:208:23d::33) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by MN2PR06CA0028.namprd06.prod.outlook.com (2603:10b6:208:23d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 2 Dec 2021 19:39:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80343dfa-1194-4ec0-0f8e-08d9b5cb6ae6
X-MS-TrafficTypeDiagnostic: DM4PR12MB5056:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50568B35BC5D33FDB6690DE2EC699@DM4PR12MB5056.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/Um2G5IiRF/8Wq10NgGFqEO0UO+2Nz1VIrcTC9gWDF3geTuKv6BvbRw1/a/HS2BFEh7ZBCFV7PKMBzONZDScLPsxPF9Vz27bxMGPvlddWoTYCmyOli/Ph7B0PVahKVOoAoWws0lVZERA58wB0hYaQhRZVl8V8jzT8D96VeFNx1CpgHTMCMdwfN/ENVCMyB4r62dg61yVJoN44l+r5ec6+dr4HaWBmBEYwKSwZB262F4MSN6emRdjmtlh2YTMw4Yqamn0WW7p/mKolI39N4fAxwf2ZPlY6i7X8D5SIh9tQXU0rMg2wJrVYjCGH8/0HZSBuDJDbShlfj1dMLw5pidFG0KmM4k4MzrcvA9UzvZV2zCl2/LUPVZvUxaKUv9aCpS2oAmpEi4XdMowH+Ty5/zXE1fUjf6Cwu4za9QgJ/ZC6lqcByII0WiFOhVR3gn+E0bv9bP5MHlt+fxz6hyfZ7tkuhlW/QgSyC9OYLxCWc3eroSYE6y4ybLcmDY7BGMWxNbhd1/fIaInpPF8BHQxtIXVhC7kwIh1zv5ah3aip4XfacQCdqB4izMsjbLo/UKGwiwtvmYacKvlu+W3Zcznxqp/dPiMprxfNE995rpt4+BvOp2nrqE3NeLQPS43GuopyL/P64R/+dE6sxd/SAL9lbExW8j3zEEYWSgmqBEUrJ25LxyOBCX4RAVr/2fV0TI1/nsTdb80QpGRa23NZ5tzGimEPdnLLxW0d7Uh7WZiN8rVJvONSQGJI9tkCn6lHlx+ifR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(186003)(956004)(16576012)(4326008)(26005)(4744005)(86362001)(5660300002)(2616005)(66556008)(83380400001)(508600001)(66476007)(31686004)(8676002)(53546011)(8936002)(2906002)(7416002)(31696002)(6486002)(54906003)(36756003)(38100700002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTZiTXJuTDFERXl5dGUybXFiV2ZsaTdwdmtLVGtmdjZSQjhMVHBNclJOVnE0?=
 =?utf-8?B?c0lZZHVnV1pKNVVXeldpNFBUcnFidlozTDZoV1VIallSRFlQSGFZMlc3Z1dY?=
 =?utf-8?B?dXJhZEpURUM0TGI4Y0xyUFl3Zks2Q2RuOCtsUzFoTnFyNUl2UlFrTFppY1dP?=
 =?utf-8?B?OE1jV3lwcm4yYUlZUzB5NUVWbkkzay80ZUl3K2MvemU3UUZCSzhyYU5aZHNR?=
 =?utf-8?B?azBkdFBKSHRTV0JheFZ5a2ZYRDZHS2lwUW4wK29FdFhIMUlkdTF5c2wrenZy?=
 =?utf-8?B?WnBjK3JSZVFSVHZlenlkSHdHMU9hOUE1Vlo1VGhsNE5TdkYzYi9qNlA0Skhy?=
 =?utf-8?B?aWt4RU9VQVcxaHNpOFNUTllyNXBMeSs5WGp3bEE5QlM1UUV0RytOTmtRaEZP?=
 =?utf-8?B?clgwWC9EZUlYQlQwNCticWFRTVB5Kzl0QmZIRWtzcjNCZDFncUUvZy8wYlNN?=
 =?utf-8?B?TlIzK0J3Z1J3ekprY0ZyeFVSTmJhTUVLTXBRaXcrbUZZSXRBUCt1TElsVUlK?=
 =?utf-8?B?RG95U0xFMkkyMXYzTzFWM1J6eWRWcnoyYnExODR4RWZWTnhVMVB3Ujh0YVNL?=
 =?utf-8?B?Z3FyWHFPemV5cktzcHpCLzdCcVhwUDZYeHFZQy9XY0hHL2hwcnM0c25aRXVS?=
 =?utf-8?B?TjN6cCs3L051MlVmZkRFbDdML3BNSmF1RXBTTTM3TXZkVE5ZTDAzNDAybllO?=
 =?utf-8?B?Z0UxTWNDZlNyUmNPYlZMSjRhUlRnNkViejlzSlgvbFJOeDZGNmlzNXdzQjdP?=
 =?utf-8?B?ODJEMWJoT2orR0U1RklVV3ZsbjRvWHJITy9Ncno0VER0OXVTSDFIWkhjV2Vx?=
 =?utf-8?B?bjI4SEx0aUJUMHJndy8vMnVBNUQrbC85RXBObnBKUzRpc29UamV0WEsrOWdR?=
 =?utf-8?B?SHVpS3dlV0xZNEVNbWNqWUFKR0tpNU5qc0JBYmVhN2NrSWNCN0JuY1BYWk9w?=
 =?utf-8?B?anJJSGRPeXNxRFZ3cDM4bHdaSEFDTGxCNUtWR1pMMmJoMlcrcElOZjRscS9N?=
 =?utf-8?B?bTlONnExaEozNEZiejNZc1pOTlQrR01jWDRTWTNhZElGd3JIRkpNc3FIN3gr?=
 =?utf-8?B?TFpPcm13bXRhZm5DMGt3RXZlaG5uanNCUk9EOE1vSE54eHI3SEZ6VTQxVWpu?=
 =?utf-8?B?TENLZXJRQ2J1dUx6K2NxbnNpSTgwWXptb05lM1VvcFdtd21tTG51Q01LNjZO?=
 =?utf-8?B?Z3ZSalQ3QmJUV24xTzZVSm5UbzBtNm5aZk5VZFlyN0ZGeCtPTFg3SzhlK05j?=
 =?utf-8?B?Y20zNFRHNkh3QWlBR0JVVjRNa2QxQS9TRGdrbG1oMElHR0M1ZXIyQ05lSEp5?=
 =?utf-8?B?M1dRcS9MMkZQNzQ5eEtvN25LZHZqVVk4aDFLNUthakg5UnhzL3IxYkszT213?=
 =?utf-8?B?Q1pMQVR0NjBOMi9yL05ucTRoUVJvcUVuZUVIQzZsbndsemxncWd1U0Nvc0t5?=
 =?utf-8?B?RnZqQkNNaUo1ME9JSk1yMjNVNkVRLzZaQTlUMHBWN2ZUdUdkb25abDJEdGR2?=
 =?utf-8?B?WWdHeFVzc3pMeWphTU42THE0TXlqVTVPUHNQeXZWakVTZkhLSk4wMndGMDR1?=
 =?utf-8?B?dExmVnZYSWgzSUdRU1lQVUpwOENRTGhSSFdhbUc1VEVENWgwSEpPMS9aNVZq?=
 =?utf-8?B?SG9scFBLbjZOTGxhSDN4M2VhNlNGNFRKVTFtWk1DandxT0htS1BIWkhFQnNN?=
 =?utf-8?B?YitCeTg2RUhTWHh6emthczZITUlNaDhqSVh3TkREbXdOcE9ycGVPSzFjdXhN?=
 =?utf-8?B?bWlHVU4rTlgzMFp5U2FhSlRFRUlISThyaTYvUGdpbVh5MXRkNE1COHF6bkRU?=
 =?utf-8?B?WkRpcENVU0M3R251UDB0UnUxSCtaYUphRFZWYWNmUi9Db2ErUnRMWWxjUW00?=
 =?utf-8?B?bEp2MjFLTWZ0Sk9nSzMzeTJQNXgzejNkaVdwTlBEM3ZhQnZkMHlURDY3bU5E?=
 =?utf-8?B?NTJxSGQ3RDdLaXNlblQrM1UzSkZhRThZUW9WOVViQVJCWE14OVlCUXZlUE0v?=
 =?utf-8?B?YXRZYW9zdFpORnJ2WTN1cG1DbVQ4cTRHbVk3bzExbE55SWVsRStZeXlua0pq?=
 =?utf-8?B?NTRLeSs3VjdZKzZEenVLU1YxSDZFeURuc2dTYktBbGZrZVJ3MkYrcnV2NjFE?=
 =?utf-8?B?bFdESXpaZElKUmVOUlIrUi9TU3M5S2s2SE92TTRpWlgwZUpUN2drUFZScURO?=
 =?utf-8?Q?HgzJfYmbmQWBC+QFbKYKx+Y=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80343dfa-1194-4ec0-0f8e-08d9b5cb6ae6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 19:39:13.1204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: us7ww9bSoK8CvRwcLZ+A3kzfbkUomEdTT2D97DTx/Z0WGRnJ2AG92YB8vSut/aDpf3Rx9+5s410092OTtcKu3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/21 1:19 PM, Paolo Bonzini wrote:
> On 12/2/21 19:52, Tom Lendacky wrote:
> 
> Queued, thanks.  Though it would have been nicer to split the changes in 
> the return values (e.g. for setup_vmgexit_scratch and 
> sev_es_validate_vmgexit) from the introduction of the new GHCB exitinfo.

I can still do that if it will help make things easier. Let me know.

Thanks,
Tom

> 
> Paolo
> 
> Paolo
