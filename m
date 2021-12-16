Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6984778F4
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 17:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhLPQ1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 11:27:47 -0500
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:9280
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233889AbhLPQ1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 11:27:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mw9/iaksmO8cJlznXyhw5VAKUzIyNEpNcLqUf47XxR1DiDEL7hZQ2j/03/Wyt75wVzK44Pw5jX14iVraqGZdCO2bQfcG9x6Bb80uscBUhBfRGTsFTFIJAoGIzgk7Zs2ONtavnCcGBn+K9uZ+nqtaBqIGbeOcextXEUoa07Xz0CMcokg9Wx4VNm00fXx4hJnCqrzg3s9XDsxkS4Z9wO9th9IfwzYIJTJ3GpccMmgdRu0JcM2OSHP79FWKTzpLvVubA++BGQsaq7k34TvJ3uuH827E0AA4vT9rRlmNcugYDRp2EvtyEnPS1XTgf3fbgW1SgOCjIB6TXqv3nzUpTt3khA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rDSbdSIF2MxYtaCmZX1hHI6NHvtKKVepnTAw9ForQI=;
 b=VMGJHvy3k7Jxcee0frpLbGszxgjMk9+eWQ1IQU9LRsDKBByYdABM2lB2mtLA02+kyv1MBjpcDfThJQxuTPHlSYQULb2yi7hqMMF141GXFotF7qvXmb/vIvHfvlea8g9d6DI3TCxc1NOpRQ7GdRj/fhZhaVPXLldW0JHJwXoS3yJPeDH5+frl0Kud0/C0zgT7QTDtOJcVGmlnRWa9BWaplIeyoD4y8mXU0q3Tabh/mES8T8qUyy+1+GARbjgE4sjag79nQqnk1059JqpbWGdnjoAEs0VBVwePhLC/4vcJRWwlOezEFD8mzW5eWHwN9qAtzD/CsTuymqveLpOSz0zA8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rDSbdSIF2MxYtaCmZX1hHI6NHvtKKVepnTAw9ForQI=;
 b=QamMxAn146cHcTXCg6iGrl+WGce5qxPfw1RFuiElYDCmn/CD+lLBHFFgrrS4Iy4RnRXQtb7r0l/vkAJuvMP+qTf058I8hWV+848ODcF5kzfMUofG0tp8u7Ty3Iyo0nH5EB84X3SG/5ZVcqMfkXT8fZ9tvUjnzaaatuc+62uzwpo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5135.namprd12.prod.outlook.com (2603:10b6:5:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 16:27:43 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Thu, 16 Dec 2021
 16:27:43 +0000
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
References: <20211215145633.5238-1-dwmw2@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
Date:   Thu, 16 Dec 2021 10:27:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211215145633.5238-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::21) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by CH0P220CA0027.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::21) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 16 Dec 2021 16:27:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10dd47d3-3d66-4704-a329-08d9c0b0fc32
X-MS-TrafficTypeDiagnostic: DM4PR12MB5135:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB51357E78AB2CF623438F0DF1EC779@DM4PR12MB5135.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pSYxnYhprmUL9EQTtZWPuWWKsluhH/vJvUAydiJ0AovNSaVxJbe0yg8fLXBn01FaMRXsUoMWcdxKb7q5anYk1+p7KGpV0ty4Jio94ky28SL2EV5Cwrq8CZzEtHFs9TjEeOOQlRqn2IyoDoPRucLgCBAoEUX6S/NXROVKqniTTr61KNwSJ3Dv8ejQJzskX0+aI2XFa6xjH25gaXN6y7Kplmvd5A60wW5q2AlRkp2sV2oiHi3Foj74cHrT/PVpvfPcCUjEwBIzpvUuPkgyh61DmVz+3WfLVnrQlGp5pidUj7IEsr9yqxj7+4j+vK0ADw45ueYXhmqI8w5GrkQ7kSpQTqO9DZg2ucVaqgn1s4b7QEDDNYVAU/Bcc0AzcPLrCuDuenewQqtOZVmfxw9oKVk2PD47ejeO/DXYYhJpMujearLMryd+jEVsBrnzRr0LOOOCIvxsO0UYSEbZjsQQYAkYWZHbM/5tbG8oA/V+bFT4jQ95aUY9Wm3vaCsFEYKiH+0OknHr6H5+kBciJnVTlZmk2jtJYORnuJD7Bb2indO2vD8UQJuQ32ZIYI4lHYmjQqR0s0H2ev+N707GwmmA+P+HTu0w8Aw2BV45Cq+TuZEjvZBnn7/NRv4yYrXY5yG47hlN3VVvd5AAOI8K+1klaWnm7N11wRupagCjt51ZY7gciNelxmx2TXnsa9P9PiYNbBOL6QvMHO388hF4RbNl4nUy71iQlj/Jw95yWCTZIJEkHzqMP4YBbXdq+Y2EC3jx1PmQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(5660300002)(86362001)(508600001)(31686004)(38100700002)(2616005)(53546011)(956004)(83380400001)(66556008)(36756003)(66946007)(186003)(31696002)(6486002)(26005)(316002)(7416002)(4744005)(16576012)(66476007)(54906003)(8676002)(4326008)(2906002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGhtUGxBR1g0S3pDNGJ2OTJ1NkNDRDhyenZHTFBvRlFDNEtNbTFXR1NrNXdy?=
 =?utf-8?B?ZVl2bGFmNitOM05ZVnd3MUdjRlVDR0pPZ2dIOUZrd2pleGZ0cGlZeHYzSjFl?=
 =?utf-8?B?YTUzcVlRZUlnRTBjbzBJVmpNanhWYVdJMmxySGVHb2tMNFhNaTVTWk5QanJU?=
 =?utf-8?B?c2JiQTc5cVpwci9oT3FrMlQ4TVJCMEdHOVo5Z1dEWVl6c1k1RUpWY2pZaTdp?=
 =?utf-8?B?MzluT3I2UXMwVUNTQ1E1SnBvY2Y1eGV2VTFQN3g5Q0xtRERoNHA4dTJTR3gr?=
 =?utf-8?B?bjV1WU03U01NK0pQWHlNVzNNbjB4RHV2Q0NiU003VE94OWt0MFBEM0JCaHN2?=
 =?utf-8?B?WVBTRU1TdlRtMUZMaStQNTFwWGlPb0VoTTROcUUwOThBbEtBTWcxb25GQ2xh?=
 =?utf-8?B?eUE2dkNwWnlGNDVGNFNNQ2xrK2FER2RkKzNmSldvbk9sbXgyK1JKMGZWUVA3?=
 =?utf-8?B?dk5RWlFqZkhyNXE1SHc2TVhTaVp0L1lvd3VtVmZ1c2xTOGJLTjcwYVpaVDVH?=
 =?utf-8?B?OEVpSjZrOUNudDZaakVWdHgyMEt6K25JVS9NcEJnM1dEdnRIUVpmSTRTdzd3?=
 =?utf-8?B?dXc4VncyQnUrWWRwa3JKUitTSWkzaGNUOTNFdTlQS3RudmwvVzVOcXd6M0lG?=
 =?utf-8?B?K1MwSGdvR21UVDdsbDdFOFQ1QmlJd2QzNUgyUjVUaHVTdnNDZ3ZsKzdZOWdn?=
 =?utf-8?B?QWVqV1dPcGlHZlkvZzg3U3MwR1d4a2h3ZGVYV09RT0xlR2Q4c09TdDI0V05V?=
 =?utf-8?B?RU5KTEErelhXZjVzckVRbUpzaGdJYW01Rk5pbUh3QThJOVJIYjZPT05Ub1Jl?=
 =?utf-8?B?NHVKYVBKSkRETGJqb05VQzZGQkdyMm9mS2hXNGYzQy9RY0tYWUQ2NnVFNklz?=
 =?utf-8?B?SFhTVWhSU0tHZmJYK1lFM25rb3ozRE43YWlQREw3WHV0OGFMbzJzajFqcFRO?=
 =?utf-8?B?d1ZlUFJIc1VvalR0bzllVm1wU1BNQ2tXdjdPTXA5cU9qLzFtSmNGY1U3ZHlt?=
 =?utf-8?B?Wkw1M2hDYkxqYXJDT21lYVRaNy9wb29VdWhid1JEV29MTDdyWDZ3bE4vVmZ5?=
 =?utf-8?B?aGZZbi9mTmVQLzdNdkZmSFZUb3g1bWpMbmcycUtnTmNvQm9UaVBGR0hxVEFp?=
 =?utf-8?B?QTY4ejVxSXU0RnBqZlEwckxXR0FhdHpFUUlMZ21IY1BPNkhrL3BsNHp6VEVj?=
 =?utf-8?B?RjBxamZCRG4yZ3Zvcm55dFI5RTFxU3pFRks3M2JGaDR3K2poeS85U3F0U1Jr?=
 =?utf-8?B?REVMNWE1V1QrQVk3Q2dzSm1mdnEvQzJOdi9iWmtyWkNQem91b29PUE1qYlpH?=
 =?utf-8?B?Vi8zNUJRZ1E5a2YwaFdXeFFnZVNNZS8zbmdZR3pyNllGdzdNV01rSFdkMEhu?=
 =?utf-8?B?bDF0QXVuOUI4NUZMRGFwdGFoV3dEMDYweDlBaVJpNmRDNlZHU0ZsRGFqSUJK?=
 =?utf-8?B?Q0RiREIrMzkvUHpZMlVwL0FIUFJDSHREb204c0RiMUdkMnlOKzZGYWxmNTBk?=
 =?utf-8?B?d1lMeFVhWURsdElhNWVVRXBEMjdscjZGUVliZFJIbCsxUlY4RW1WUUF4OEs2?=
 =?utf-8?B?Y0VuV1FrZjF6akM1YWxlZDNKczd1RzhodUVvd1pwcVBxT2ZNR1BqQ3V0TUpn?=
 =?utf-8?B?dXN6N0gvdWhiZlRqSzhjektTc3F3NjRCN1d4RXZRbXVJWVFmRGV2Z1JDWjZv?=
 =?utf-8?B?bjU4d3NGZjdyS1JJRTJWK2xJSGpXV3J0SHRtbmZrZWl6WWZ0Vi9sMit2OVNF?=
 =?utf-8?B?K3E5ZUNJNkpuM01oNVptNjRHRFRKUGFZSFZuSERRd0V2UnJjWG81cys0N0N0?=
 =?utf-8?B?TDJ0WWpxN21oZzhiYnNjTmtFOGFQUDlUWDAySzFjS21obXhRZ1U2ZGhMSldk?=
 =?utf-8?B?TUlIRW9lODN4SlFZcVlvSURNQzF2WERkOWNiOFdtWnd1bTR1Q21KazJKWnBs?=
 =?utf-8?B?Y3krYW1Bd2NjRHE4UkxpMm5ueHlkSjRXLy9TNjRicUVrZ1NUYk0zeGROT0V2?=
 =?utf-8?B?STBITGM0dE5UTlRJL0lJTDcrQ0VkNkFxb1hUOW1LNWRlTFMvWVZONVpJOE52?=
 =?utf-8?B?QXE5bGt6TlpnNDgrY3gvcXhiK2JIMW85ZzRQWVVtMmd1WDJmdXJoL2w3Ykhk?=
 =?utf-8?B?VUt5bC9LYi9MVmc4TnhPWjBCNENLYkJCUDRZQkRQYnRwZHhsMERMcldBc2tL?=
 =?utf-8?Q?lqCBnTwmtW7B1R8qMNTYOQY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10dd47d3-3d66-4704-a329-08d9c0b0fc32
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 16:27:43.2667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53QM7m6gl1mYsl8NzKw6JzXcr9ysQbSRUACVtH2PN076MiD5UkLZvcxNTHTm6MBIaBwDGb9EUbjlB1GIKkJxMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 8:56 AM, David Woodhouse wrote:
> Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting for
> them shaves about 80% off the AP bringup time on a 96-thread socket
> Skylake box (EC2 c5.metal) — from about 500ms to 100ms.
> 
> There are more wins to be had with further parallelisation, but this is
> the simple part.

I applied this series and began booting a regular non-SEV guest and hit a 
failure at 39 vCPUs. No panic or warning, just a reset and OVMF was 
executing again. I'll try to debug what's going, but not sure how quickly 
I'll arrive at anything.

Thanks,
Tom

