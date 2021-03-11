Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73A6337FE8
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 22:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhCKVvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 16:51:00 -0500
Received: from mail-dm3nam07on2059.outbound.protection.outlook.com ([40.107.95.59]:55393
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231218AbhCKVul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 16:50:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkcWo9Sndaoh+kH6AwQ8MksuNB8FkqZSH7jf+Dm8Sssw+p7OecNLmKbOJd70VrMQm+SFPkVzW9lEokcn1gZK5U6aialDYiR1WnMUQEtXADlwNYDL4AWsWJArl9TY8eGHS2nIgFF4uG97JP3GQxKZN3i6IQwYMGoDP+Od1LaKpsmmCl1SpzXdUVQZLDqe5RgDAm3LEcFG6ABi9vpP7X+6E96jjb+L1PFSEuecXqxo5sUoM9/gITBmIEJGSg9xZrXeD95GdpgcbWO6oPozaKDcRagxolxbP/T8igTYI5jQqRo9cGm98aH4XG9zLuIQDZNy5kkjJGgIELtKqtSIQ1PM9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJKGHO4zM0d41B3/n567GwmHcFZ+/HQm+HM7WeJQrqs=;
 b=Q2xTjepjBhMWVipzrZQYA4oVTlq8lHBweBSLOPSixH7IqdMVV1YcuErpcfNEYCWm0xSHYEvPG/2JGoQCtmJjlm+oXF5TkaxQVGMeJHR//RJKr2X1aPfQVTKkDL5Pt0SPI7FYskuD9jBDgE28LVInIocKzxaTNRcGkj6noCmDPmTs16lGG2pZIhTCHwAc/C4lmMA+SPiypUuV/Tfs6onPqwxNWoaIROXN5y7ACOMrLGci9SqCtZL97bbKp55jvH/AAC+DmUWi+2GIgT3BuEVYmYrgut7P1GPktoh2bSMsuDMKgX+Qx/07wrMlQQM9KF2OGqCqyJy88/oHGQON1Y2psQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJKGHO4zM0d41B3/n567GwmHcFZ+/HQm+HM7WeJQrqs=;
 b=zgS6eEewfqDKwGVVFDI1I+75ZofZ829hLY+sMu98iL7V6iDh653DwrOSnZK3gkC14Riu53zaVbMFqDk80fC+D5plsirQJ4Jq5a1sWCRSJlMSppv1z2V5bV4hopGKWyv05B+wkWT7Z1576Jr7KR9vwMF1Iyb5nes312yAmT8X9cA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 11 Mar
 2021 21:50:39 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7%7]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 21:50:39 +0000
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Borislav Petkov <bp@alien8.de>, Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
 <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
 <20210311200755.GE5829@zn.tnic> <20210311203206.GF5829@zn.tnic>
 <CALMp9eQC5V_FQWGLUjc3pMziPeO0it_Mcm=L3bYcTMSEuFdGrA@mail.gmail.com>
 <20210311213600.GG5829@zn.tnic>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <1caf0cd7-a419-442e-59bd-f1189685742c@amd.com>
Date:   Thu, 11 Mar 2021 15:50:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210311213600.GG5829@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0116.namprd04.prod.outlook.com
 (2603:10b6:806:122::31) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN7PR04CA0116.namprd04.prod.outlook.com (2603:10b6:806:122::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 21:50:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 021f7c09-fea1-4b88-0ee4-08d8e4d7b582
X-MS-TrafficTypeDiagnostic: SA0PR12MB4464:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4464143E6C59F3C166E20F4595909@SA0PR12MB4464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n5g2aLUy/5iB7A4d5+SvtgsKUnGXqKNqV5mj89K+JZCNNYvOIMDbXbrih0RBO+xQi9tqVEO3bIyQmQfQ/PSeE+6Qd4ZjGFV5IpzMfDe1XhK18hU/TBMJ6yEJbHoINo4jZn6NfzGuuHZpVKQfQzAhS3BzRthnRGzRQU9mpgc0yssHgN5PseNmKY8HeEyO3pAr6Pf5dD3h2BLb0z3Gw3cWdwcKKvWWeyjAhlaNphlKBXE4AUmdVFdJ4UlvBO4UNNbEEldY9tjoR3uFsIl4YuL3l9If1gkTd50jfoHz6VV4Bm+nF6hYd7hy2Uia6dSaqSaLX+qQQKH3QerG+eiLuhbbC7TtFXnbvbRh+P2FPpF5iW7qsCT0Y5g4gG6I1kKBQ9deJl3mutcg8Ul8J+amkb5rsCRrLrHtnjCLQxnqRs51zgb7uE5aYqPhjvmeVa+xV/CI/L7hLyH7hOQSjwrguEZ3tbqSGnq4rJp0Sa/fZy/LemwVQcGoRf5+Cexke95Rscjt3fTC5651bdQ1Y3Mtie/uJk2XLaZfc8G3+6mhITY6/o61i8Gqs4/rfjUWb7RnuF4VPAFNI2Y9xHllbl2fv8ub3rXzbaLrLA/o4ZkVYqzO++DrJ/kO02+KQ6G9kWUbn2suon0SwJbSbkKT2IA6VQ+1MQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(54906003)(110136005)(53546011)(316002)(66556008)(186003)(16526019)(66476007)(66946007)(31696002)(16576012)(4744005)(5660300002)(26005)(52116002)(478600001)(31686004)(6486002)(956004)(7416002)(2616005)(4326008)(2906002)(8676002)(36756003)(44832011)(83380400001)(86362001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?My9BU3dqeG52eUh5U2tUZnBMMVI3ZUFXNU9QVUFsd0Ywc09pT2N2dEtwV3BH?=
 =?utf-8?B?ME1TaXdsV2VUMXhMdUhXenBhV0o4emoxMVk3YjE3WFczRzBkUkJTaTg0Sm1w?=
 =?utf-8?B?bXhYc1ZxQXVlVDdKUU9pL2R2TFd2bVUweW4rODkxYkxhM0xScER5SE9uek44?=
 =?utf-8?B?LzlyZUNpRTZHZFdZa0JyTERYanNnWjdQQTY5QXJPY0JFVmNUWW4zNTJJSmow?=
 =?utf-8?B?WFpiNWs3OGhxRWl6cC9ZWkNvOW5LRzNXMUNjWWJtdzlJWTdzanM4aHhYN2U3?=
 =?utf-8?B?dTdmbjdId2QwWG5pRlJwOGIzMnRqUkhUSzR3Zno4MXNiRTBoQ3JWMnlka3h0?=
 =?utf-8?B?a2NJZGNQRzZscllqZjUwWmZiRkJhdVlKWnd2aHVObEhyKzYySDVsbmh3VEJh?=
 =?utf-8?B?Z3BZTGZ6OVZsa0F3MmJORnl3bnF6VXRLR1k3VUpOS0g3clZXNmdDbVk0eFpZ?=
 =?utf-8?B?c0J2ZWdYZy9XUEx0MUhvNkRLUkIvTG1yNGVJMjZiYkZhdklyM0prT29CREta?=
 =?utf-8?B?c0k4eVNSODZvY1BtSnpWMlBSaEpSTFBZTGd6blF4NHFnbWRoanRpVEYzL2NS?=
 =?utf-8?B?SEFVeGt5THRyMXF3alVjeFR0c0wzb0E4WGVMZ0dZMG45ZE9kT1FTb3NKZW9y?=
 =?utf-8?B?clU1eG9qK3FXWlpIb2RUR0JDbmNWaXRXZHlUZTFCYjQ3Ny8xT1RLY3BYRXZQ?=
 =?utf-8?B?LzZxaVpMVjJWTWJlNUo2dUF1WTduTUFtcWR0MkJzNFI1ZC9DdERycS9lZkk0?=
 =?utf-8?B?d29tQmlrcEcwajZVL3FCdzNvTVhhL25ORDc1NWJXL0lwSFdsbzZVdVlLYmtZ?=
 =?utf-8?B?NVlGNUcvTVA0U2lVTVkwVnJYMXZTNEFTZ2J2UG1Gd2xVNUo4MXYyV1FPR1VF?=
 =?utf-8?B?eHlxYXhMVTAySmdKR3Y1NkhXTGVnVlo1ZCtoOHZJdU5ldC8weVBzVXJjWmlX?=
 =?utf-8?B?d1c5U1Z1UUFSTXVrRDlmaUNFYm5ZbjU1ZURyWUpaT3JIVFdCWGJJNmU0R2Z3?=
 =?utf-8?B?ejBzcUFyWXp2Qkp2T0thSGpXRVBkNXZkNjJ3WjBzNm9MS21DMmx4UjZPRzBY?=
 =?utf-8?B?OFVTVzJLMHhreXRNMXl4OEZqamY1NUVJTkxDeUNxeDFQb2xKdGxldkYxWlBZ?=
 =?utf-8?B?bTZaMkI1S1NBYkVhNCtxY1d5L3ZqbUtHcHVWQU55RmJUSWY0ayt6SHlyZWRs?=
 =?utf-8?B?NWhGNC9BS0J3L2h1Sk5VcEl4QzRlWEdZV1B4ZmpnNGdNVTNLb2hFZExtQlRq?=
 =?utf-8?B?REp1RXFMbGMzemdsbWE1ZlN3dEcxbkRsdEozUXNmRFhXTm4rNldLa2RKWlkx?=
 =?utf-8?B?bFQzVWNaQjFQaW5LU2U0ci8wbGdZc1pkWWthZmFBeXNURVFCNW9ZWXMrOXdH?=
 =?utf-8?B?dmI0dVUwVFYwN0thM01QOWR6V3RyeEE2OWhReFJENGkyK2I1RlJxZmtUeG50?=
 =?utf-8?B?bk4wNmJUVCt1em5QbktDM0hNRzg2dldXck05VC9JMm90V0pVWXo4QVd1SzZn?=
 =?utf-8?B?Z09FVXNtcDJ3YXhiNlRjVzlIdW41V2ZTbTl3S09zaXlWZjY4ejNuY0tpWWl5?=
 =?utf-8?B?Sm5oMW9FUkpOZGpxTzRkV1BNbGZNYUd3SnNhdFpDVUEyNVhIUzd4Rkh5OFZ3?=
 =?utf-8?B?VXhVMENCREF5L2NqRkZEdkNmNlhmNDBCZ29BR3ZNaHU5NWZ6eTM0QjdtKzRR?=
 =?utf-8?B?amR4Z21XOTBzZ1Rzc0dpaU5BZUhjdmFkKzdrUGp6eW01RjU3ck9MdzBqaHRG?=
 =?utf-8?Q?O3JcSiHybwFxWe5asVpcM+mUHLJPVSJU/LkK6wz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 021f7c09-fea1-4b88-0ee4-08d8e4d7b582
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 21:50:38.8595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOsAv/1Ec92GCBe+fxVL08avT0ui3CjpspysNo8FY+se0mkoYQggMkVAeHhiAIv2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/11/21 3:36 PM, Borislav Petkov wrote:
> On Thu, Mar 11, 2021 at 01:23:47PM -0800, Jim Mattson wrote:
>> I would expect kaiser_enabled to be false (and PCIDs not to be used),
>> since AMD CPUs are not vulnerable to Meltdown.
> 
> Ah, of course. The guest dmesg should have
> 
> "Kernel/User page tables isolation: disabled."

yes.
 #dmesg |grep isolation
[    0.000000] Kernel/User page tables isolation: disabled

> 
> Lemme see if I can reproduce.
> 
