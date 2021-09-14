Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0AB40BB07
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhINWQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:16:28 -0400
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:35136
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234701AbhINWQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 18:16:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mfhf9igWcIvEr06CfIbuTLwqjAWpc523aSxnbQi4tzcFaHV5hUlUlvsBX8WyJiWU2aWEgF9RljyryZtTyTqd2yvS+HAIqSxPeA3KokXCLV2CXPfX9g+3x05LuFPq5jfJ4DkcdnLyy2pZIOtG3/4w6Ny2LiLoU1+aqbvd/1kTcOb+t2GzUZM9wnKzuC9bbPnuekaDGVr7++har0b/7aFRbN1/5JJJG5J5DiGbBn2YTMi8lFAkpiYXxYcUXVz7w13P8EaCP1DZ95Yc15kDvcsMF2maYaU+hRb6Cl3gliukyniqNg/XJkc1l0qV2WzOIxLrgDLezPgfI2qmrTSyhbRhUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=11mzLZdW8kY//KpXbBnGuKQPE+l0X88l91mlt0GIATI=;
 b=bcxAa49ZiaZZT1UpoBtH2+b7gggh7ayyylvlALun3xGvpUvfnuF9ws3N0IjExhVtmpAE+ns4PXCTkNH4USBWk23ysl18kHyEPo39kk2gISrAyjxGz8lhGR5oFMVhVCEi2cXq0OGesdBu3id+AWOJvH/XVdi2SFk+HdLRzXga00tmiCfxf5sFeVksp89WmZQTS6aOrJGn5uhfbJ9evBdWVVXoj+xnqPBzzjHX/oCaz+fNQtqJhHLJBoISvCTFAnE80+Yl3hvZt8/r9V98ofIGT8VdnJahiSh0wnM65mRPO1BtcB512YgvMB4DNUxOn30TIbbJjGCMcho2C0oVcj6xzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11mzLZdW8kY//KpXbBnGuKQPE+l0X88l91mlt0GIATI=;
 b=cnS7HP9Pp6xf8Oj8OKXlsSmoKB0Hu/1hLVigGd6StCzqYKww3bWjJaGJcR5RzAwh6MFwkGd9s4eklEmHI0C0JABHc2x4aqNKBM7aBjwr8MHiqz+KoXQWZoEbk66qu21r2Qjt7HD1o4mRfOhxAmQUuqtKvRiOfuE+MxKIjV/k0KA=
Authentication-Results: kozuka.jp; dkim=none (message not signed)
 header.d=none;kozuka.jp; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 22:15:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 22:15:08 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Masahiro Kozuka <masa.koz@kozuka.jp>
Subject: Re: [PATCH 1/2] KVM: SEV: Pin guest memory for write for
 RECEIVE_UPDATE_DATA
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210914210951.2994260-1-seanjc@google.com>
 <20210914210951.2994260-2-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <1bd21635-a198-327f-cca1-7fd8bc116c91@amd.com>
Date:   Tue, 14 Sep 2021 17:15:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210914210951.2994260-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0007.namprd21.prod.outlook.com
 (2603:10b6:805:106::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.31.95] (165.204.77.1) by SN6PR2101CA0007.namprd21.prod.outlook.com (2603:10b6:805:106::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.1 via Frontend Transport; Tue, 14 Sep 2021 22:15:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08aa05d9-e12e-4b0f-1dbc-08d977cd1c66
X-MS-TrafficTypeDiagnostic: SA0PR12MB4430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4430AAD19EF50073E4818706E5DA9@SA0PR12MB4430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E3hjeltXjjY99O9exa299jjTX3UpHJ2PMzpxRYo0SoxCxXQPTqM/+2Ld8mMlcETm3cwtl0BsqoCdZjyI1G7Aa51ZxPAq01d8g82L4ABE6PFeCMRFFp55pRnjz8ZRV2YxPy1wyoYFNYFwrb/cEN8t9Mf93cDrevZzn0ya4+3SEuzajiWaLkG4zF5wRapLZ7KHqNwnLpYJIL2SaTtIBBOLTUH1MirzCBxOH5A+Xlom/zmCuFsTrGbzSqPnsht9+EHCCs2jbNiOaHxT3lyBATQbT/3A90HbgRxJAxg9M0Y7B0i9zhjpTteiJZcD7MqEci+fwnxAqF4BZTXyXfrx0zlIazuwJbVVTQgiby/5nQis5vZEmOQqUH2/ZqdmDqnfqBe/BRWzM3h2QWUdIhTEXUvc5SUTQdhPiT7Z5maJi2VcFeP3sGQNzqlZnWpTU+YkeUJ2PjkJ2xUfP6zd6PtmKsLeOdPDYgYBb9Goc4cJ9j9I9Lr6wKauZrSfAkXs36bxSy64+jkzJS7Pi4ld+HW3w4dcVfu2pDknuZQZ4qqhugQkKloI5Vvy9uF7kabuRtV1ht4KELd+mkoC5aV8wPdEeagzarbTLZn1UKtrZUj1teIQQ+yoHxMKkz7ok08ACx1+c13YebrEYUYgus/8mvQgOrkTv40stT9ODv2TJiMWdnw4jd+6WFkzraFo3uawrS6KckUHCyq6N7etgIfQTy9E/fK7O8t885SIHnze3Q6JXkHm4QUlAuE0ZxLF/mWmEY3wIvRs31qWHn6TOzigEtIXg/duAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(478600001)(186003)(2616005)(4326008)(31696002)(26005)(8676002)(16576012)(6486002)(956004)(5660300002)(8936002)(53546011)(31686004)(44832011)(52116002)(4744005)(86362001)(66476007)(7416002)(2906002)(38100700002)(38350700002)(54906003)(316002)(66556008)(110136005)(36756003)(66946007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1JybHgwM1NzdlF2WEdXNXp1WjByS3piNUZqQVFsUjJuK1J0bkp0M2R0T2tm?=
 =?utf-8?B?cU9RRkJMWEdBTUNaUzJGaGRiN3kzbm9hVnhDRjFaTW9YdTFDYldieE81N3BN?=
 =?utf-8?B?Q1VTMmJqVTZjYkFqMjlFZWJWZWQwNklKRko4WjVmNGxUVnhlWDRNZCt4OFdt?=
 =?utf-8?B?V0R6V3g1ZUZBOEVTTTRPMDA1WmhUWkgyZVl5OW56RzcvSG9vK0dNQUNTRGJS?=
 =?utf-8?B?SG83eHJrTXhYN0VnNHk2WnJ4NnBSYThqaFl6K01WbXp6SnJteTc5blY4TDRI?=
 =?utf-8?B?bXVzZ1dVMlYxOU1vUUw1ZWkyYk16UTJkZGV0NCtna2l1RVNZZ0xVVlpEZ0I0?=
 =?utf-8?B?QUZHT2dJTXl3cWQ0bUUvcEpXdmtPQ0Y2blVHVkFweUNYdDBIdklPNy81N0I5?=
 =?utf-8?B?MDJoQ2F6TGtValNSamxIM1RxNjdKVUgwaUYrOUpiSHU3em5DeXlpcUFZYXRt?=
 =?utf-8?B?MTlSN0FtYzJRT1RpSU54eC9jZ2pzSjJQclFSS2N3V3JzOUphN3JmM1N2UUha?=
 =?utf-8?B?T2Q4djdVZkorQmdLZTRKSVFqS0dnYmJuZzNOZVJ1c0dSakY4MmhRSWUvUnBr?=
 =?utf-8?B?aldJZzNzbUxFSHAwT2Zuc0x4MStuRTJ5aWZ6YVJjV3ZlcHA0REFLU2J0V0Zp?=
 =?utf-8?B?NW5ZU0Z3bmI5VDg3YmY3a1g4WEgxNmRadjNFS3drS3VCeG9LVlNvUWpnNko2?=
 =?utf-8?B?QWlWK2JGWHNpeVd1bFF2OTJqbUl1cmFxSFFZcUdDWEtMVW1QYVBSUEJBMkJz?=
 =?utf-8?B?SS9kZmFveExSdWpXaTI2MGpOSC9XQktFUlVSS0o1bTdrdzRQbW1iQnRxb1Zw?=
 =?utf-8?B?eGR0TmpMamd0ekFFeG80cDdiSkVFQUR2V3VHNFBNM0RSU1g3aDBDSEYrVkJr?=
 =?utf-8?B?KzBXOXVTT00yNktNY25zUVpQMzdHOUhleUc1MVRxVG1JSDBmSngyR2JRdnhN?=
 =?utf-8?B?akJ5cDVpcjZ0Qlk1NlM0ZWNCK2V5SUlvTEt1RlJyQy81Q0NRUk14c3EyRFdB?=
 =?utf-8?B?ZElzRGJlOGwyamhWdGtMSCtBdkw2OVNEaVI1anhaci85VWM3ZkJqaFhFSXMy?=
 =?utf-8?B?aWJWS09PcUZEYmQzMjl0OUV0ZkYwM0hkK3loYm83eTVvdlRJREtVNWVlbWI4?=
 =?utf-8?B?R0Q3N04zS2pDeG51bXd6SEJBVzRmWFdHNlNzTDd4UWpNd0RDaFBlcTM1a0Zx?=
 =?utf-8?B?Q2VUbndVSklmakswS29FalVxZytKa1QwY3pwN3d0cGJqYWJleUtJRTE4Lzgy?=
 =?utf-8?B?VDFjWVptQ0htMGxZSlIwbEsrejFMbWpmSlo1QWJjS2tHUit6Y0E0TmlpTTJm?=
 =?utf-8?B?bHFSYWFtOHdBS1FqdzlvNUE1MXpyZ1NGUHg2dzQvNGxiU3ZKNUJqNXpwWUZw?=
 =?utf-8?B?WEg3K01iMGF2WGVlK1BjRnJ1cWN5dE5TTTg4Tm90MWJsalRCVCtPMGZUNWd2?=
 =?utf-8?B?M1hIMXJsdUt2bk5uWGxXWG1KRzh0SVJvbDFIM1p0VThaODJhN0lIYkl3VEZU?=
 =?utf-8?B?Z1RoaDkvYXpJZWhiNlY4MUtyNEljZXgrWjNDYTJ0enc2cFdxT3JqclZhSnY4?=
 =?utf-8?B?VHRKTTltMk01dTdHY2hPNXE3cEpXZ1UwOWN0YTJ6Z0NQbHYyenAxZGxzOFk5?=
 =?utf-8?B?MXFiTHdqUGxlM2dZS2hDNVpWRlVqekxoc2pUVmFsMXZVejZkOTVML095TmpG?=
 =?utf-8?B?c3d3Z243VTdQRnhjVzFCL0VPcG1Ua1g1VVZJVU95MENtTGVuOWtQa1BKemNn?=
 =?utf-8?Q?kYnXwTRijw+mbBcspTRjDR4/h6ZsHvxstcPr0k8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08aa05d9-e12e-4b0f-1dbc-08d977cd1c66
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 22:15:07.9610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCyRgrgvWgeYZO8iKee/dczec2jL/5ihtTZzlfKCBEIkLtZhT5oYkB10gfX1uupqMDrh/LlvcZPFjnm75dcSUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/14/21 4:09 PM, Sean Christopherson wrote:
> Require the target guest page to be writable when pinning memory for
> RECEIVE_UPDATE_DATA.  Per the SEV API, the PSP writes to guest memory:
> 
>    The result is then encrypted with GCTX.VEK and written to the memory
>    pointed to by GUEST_PADDR field.
> 
> Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
> Cc: stable@vger.kernel.org
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

thanks
