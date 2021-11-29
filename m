Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E5A462360
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhK2Vff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:35:35 -0500
Received: from mail-dm3nam07on2067.outbound.protection.outlook.com ([40.107.95.67]:48257
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230246AbhK2Vde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:33:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjUEkXlQn43K5v/zelYvnTxa5vb+YkH6KX7l3Q3uZ73p6SLcto7jQPhtK63AWamXQ6VLlPAvNPBwuAiquV2+fh3zjWmSaMejU/mBtcY1eGUGSgo8/X6SZ4GxwnwK4dNqgI2dCp+kuqr1b7ltEid6FWv5xNLnDi9fweYsWPCirlYnzszfGvE0+vNahiypu+YxcmFAIrMMl0yBhLxdxb2hEd1QHWDBh/5um5chatIg+CYAnfVtc7icNBYJEeRA22Y/x67zT9/KG7vP7+i+GBfSc1UrA/7ecYnz5U83QeRGkWspjnokJnGrpBIYANDKAXYKKuvy60UxLxQn63Amxx6MlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2iXtax4GRuoeoVpj7qJGxqyL0MfPliLxFUTm/zhqplQ=;
 b=Wf5brzx5nQn2fZdzB/CJi8I7oJJz5qHg7cRnYEeKFu3a7Zk6EX9MvJmTCcx1ba0Xm34WNo1sgxbM9AtCy3UMy5STIIenrH8st1HLEzNsLmFvSFnsq3Awv4ULoYvrEdqJOcI4Yw5ScpBmkL11TWs5YRbsmwbBtM4FEI0XsRvVt5IY+GgBGJMgjD7eLxwrQylzARRGcWw2F+wvlfelS7OL0Ry8vzvrCVUzYC44nTS6A8gpKHdv/HXP9OUvMIThllYvOMZxEb+K2T2qxgOq+NmFYYk16vFf2pz15Bb1ohzwugg35Z/v6JpIM9sP4ESFRWDWULxEVM4XJlgMDueBwk/zzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iXtax4GRuoeoVpj7qJGxqyL0MfPliLxFUTm/zhqplQ=;
 b=HZaYEk2krAZmtfquUKBpb6PfQ1do8+akIIQU9sZJZ+Q/ULCfw2r0u+RL4OStrLuQg8tA5Zotkp75gK3Mo8T923nWhg2RoNJ42itaT28Kpzi+RhguHSRLww49fGA33QDeKJTJjsUj2N7XLS7HZhqedBlbo1X/nqGKhPlAm2DdyE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1231.namprd12.prod.outlook.com (2603:10b6:300:e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 21:30:13 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::d9d8:7051:7185:6c3c]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::d9d8:7051:7185:6c3c%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 21:30:13 +0000
Subject: Re: [kvm-unit-tests PATCH 10/14] x86: Look up the PTEs rather than
 assuming them
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
References: <20211110212001.3745914-1-aaronlewis@google.com>
 <20211110212001.3745914-11-aaronlewis@google.com>
 <5a08da0c-e0e1-c823-b9ca-173a15aa341a@amd.com> <YaU7flyPaTb5xJa7@google.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <6dced345-b48b-f7bb-743b-be699c58a8e9@amd.com>
Date:   Mon, 29 Nov 2021 15:30:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YaU7flyPaTb5xJa7@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: MN2PR19CA0026.namprd19.prod.outlook.com
 (2603:10b6:208:178::39) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
Received: from [10.236.30.47] (165.204.77.1) by MN2PR19CA0026.namprd19.prod.outlook.com (2603:10b6:208:178::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Mon, 29 Nov 2021 21:30:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78948dfe-1ed5-4924-40a1-08d9b37f6daa
X-MS-TrafficTypeDiagnostic: MWHPR12MB1231:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1231B57FAE86B7866488EA6A95669@MWHPR12MB1231.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vuYhTPb7JZsRogZPonTlbAB4udOEDMQoi55RINcxvjfxzlpUuVQZ+NtsqscO9W+ARGtecMIDBs5+GodLraRYSz1SKfem9Qw5bmJ5RMWJn8VwPbakkvW6/pkwSYf1iWnMzuJWQF54WnmGLvzxQJojgfttjzEusakE3Iv9dK4SS8Ioti7iNUmVe/Y3jS+Um0MNTlY6XtWgtKnlwKXRizvcHYkngLpHRNoFL5XqijIhFKGiZVUm0dZYmuxZbcofZ8qxiFen6KoE8k//jJQo/2RBmcbZ95LyYjxWwffwoLIV8HRNy0RjxqDEJyur2nWgbzW9EHy060D4siGelYcLVybcu17SbX6KlfwVTrUZv6kBi0Cwkepo3tr6nov3VVkifZgUZlpcSjWyxQ7FKiMEMFAuZKiXF31Kp34l6DDAUR+9bVKDECg9Wd2uiCR2/Hkv9vYdz7wow+HKq8TqBMG9ufLTDu3KofXUWKr/910ngRfbFE1Y+9zSrr5YGAu8IPRZ4dJ8y6xWfm3N1wMPe2/x+MPgx4Dua5ZlWeXn5NS3DPCl516ODWaijubII/L513vUO5sHyaIzZZTeWj8XFAZ7rPeuGdBl3lorDqz1SuBwblWLOfgcjlZIGrMIct0bc8mOGVBnO58aKOH2Py8a3ub338dloCdDGqMK7sWha/Bllww1qQfxTXtDWdwosuha6x3YpyO2Q5dN9kLTBJ/pgEiHRqUgTubEhDzhpcFTXeBGle74jEA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(16576012)(6486002)(86362001)(66556008)(4326008)(5660300002)(4744005)(26005)(66476007)(53546011)(8676002)(2616005)(66946007)(83380400001)(186003)(956004)(6916009)(31686004)(31696002)(36756003)(38100700002)(2906002)(508600001)(44832011)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEZvTmJUallGOXJkODkwYUlUTFNaOUg1M05nai90WktrL2lPMmV1VUdWRXJz?=
 =?utf-8?B?UmF4WlBzOWJNSnZyMjZ3Y3Bzd0k4bk9tWjBiQ1g3QzQrUHZxcHlYTldnR2c1?=
 =?utf-8?B?NVMzTWpmZGlNL2VLalpFbGJNdUZHOW40QWJnTmkwTHZjdVUyU3BDVVFsTlUr?=
 =?utf-8?B?WmgwNk11L21kSFpxR2ZsaVVXb3NWOHpDT2RCMGdpbUVzK0hOeVVxWGI0ano4?=
 =?utf-8?B?L0xoc2Vwa0dBZ0pqYnhmRlhOK2gyeERnK21OcmttalR0bkpIUXUrcnVtQzM3?=
 =?utf-8?B?L01qYlVacVhodUc1T2JmckFTYW5RRUMrcnFnTWVFbFoyc1ZpSWtwUmR4RDEr?=
 =?utf-8?B?cnQ5OG94RzlhNXNiSFlwMzJUTnVlcjlvazBIM2ExcUtreFZCVGFQQnNwa1px?=
 =?utf-8?B?TGtnRC9aWDZ1VnN1L1YxYlcyNDZpUjJPZHFMY0FuUGNnRDRpUUYzVUVyYm5a?=
 =?utf-8?B?eXUwQ1JnTldNWjVrOEVSUUtSV1pVMjk4K0dPT0xiZDBOU3d1ZzJyV2xRak5G?=
 =?utf-8?B?a3dacTBkdkhxY0R6M3g3ckdaM2FOaVFzR3diQ3cxZEFZUXJENWRiT2ZUM3VL?=
 =?utf-8?B?SlZ0a2VXUEVNZVlOSDFYb0N5MEhXaUlabzNnam9oTUpVcWZhV3pnem12M01L?=
 =?utf-8?B?NlB4RTloVXVpazdESmd5b3hWN0JWaWJERjg5ejgyZjh0b2NhOWRJVXhzaitO?=
 =?utf-8?B?K0p1MnY4eWpXRDdYU0hzTWVUK0s2bTJRMXI0TTJBZFg5bnlsWEJielhVZEQ2?=
 =?utf-8?B?MmVOaUZidU5sdmtacms3MW5xeUx3REFGcjFGQzhaSmNRa09ib05sZ0ViS3NK?=
 =?utf-8?B?VE9vTG5kVTRJRjFuTC9STjArVVhNRlpTQkZBRHRMOWtMOUNCY0psSjg3T1lw?=
 =?utf-8?B?Tm8yaHRjd3lkU0VxeHBnb29UZ25hVHU2YkJuQTMzdGNRYXdhZWJ5K0dyZlNT?=
 =?utf-8?B?RlpVQ0xYcUVHWU04ZXFldEFLemhPaUwyU0w3MDBnZmpBN0ZlSWErQlZPUjZk?=
 =?utf-8?B?MDF3M1pvUzg4bnQ3MHFHaTRFK2ZjMEx6eS9SR1N0cU5GeCt6eTZIMm1SS21r?=
 =?utf-8?B?QU90RHV2UmlJR2Z3Q3dxWDhWRlBTRVliWUVxK2tYNFU2R1NDbXdYQVltNVJE?=
 =?utf-8?B?WkhOTW9PUlBIdWZLMHJxZHRhOE9HQ0U0QUdoWnpyVEdUV3RsaTd6eHJ2VkZ3?=
 =?utf-8?B?WlpSa0UrUmtmdVRkdDZwMlk0ZG1NOFZ3WFJvWW5tZWJjYWRZVGRCUkpBSE9T?=
 =?utf-8?B?dXQwNUc4N0FPTXFlQ1dDSkpFMnBEblhJS1ZQanRtNGJzU09Qc3FTRGw4ODJr?=
 =?utf-8?B?ZG02Mk5wNlFtTDdMcVdYaXhWei8wYWJWS29mRjU0YmZ0L2MzUVRvV0JraDZv?=
 =?utf-8?B?eFN2SnhFZ0xkQmw2dm9VeVo0WnhCQ2dpbHZEckhDUmNQbG93K2srTy9XeGpx?=
 =?utf-8?B?RXA4aldsZ2dLZUhpbkl4RlpwN0tkWitJeUZ6d1BOV2trYWtsdnlBMmFqZGdX?=
 =?utf-8?B?V1E0Wm14NDVxWU92Mmh3KzdhUXBSZERjYzcyOUVFd2FNMlNiVFY4Rk5sZ2Rt?=
 =?utf-8?B?NUFlU0VpbkRHWXplVTc3bXd4WTNIVGFaMVVudUZyQkVKS0p6eW0rZGgzbjl4?=
 =?utf-8?B?b3FQSWpjTC9mWHg0czNub01PUDFTaEd5YWE3ZEZYcWIrUXRvMUZHc08wd0pI?=
 =?utf-8?B?UDlWQlBCN3Q1Mm9aakJnMW9JS2txUkNwM3BPR3IzbEZjcHJKUGU0aW5qQTJZ?=
 =?utf-8?B?ZDhlYVYvTnlLOEtsYXVVRkhCQm9KenFIK0puQmZlSFowVWNHamxCNVQ5Q3Ny?=
 =?utf-8?B?a2xaZEZMait2NE5DQ0wzNThQU3pEN0M2azZrZGtWeUVadjlWOHdaK3VIcVBq?=
 =?utf-8?B?d0Z4aHIyWnd0WVZZSS9qQmdUaDJrb0NHSUsxdFl2eWZMdU4vT0Y4K1dCSjRH?=
 =?utf-8?B?MDBDOFZrelVSSys3bmRmZHJ3dzRMT01GOWJKTzJQVkxQbDBIMXFjUXhhWThk?=
 =?utf-8?B?c0tWZzRZZVdMbmxMQm9YS1JUSW5YOEZFeW1CZ1BPN1JyQWpoaFNrZ2RQa1ZG?=
 =?utf-8?B?RnZuYTlNa2V0WTJGWHNyZ1A0aEIxNnVJdDVMaWhrOW5BN1h4OTdDVDduZVFz?=
 =?utf-8?Q?73nk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78948dfe-1ed5-4924-40a1-08d9b37f6daa
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 21:30:13.4695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NuTiwpOWcj4QESQYqzQUPXI6OmPnnrVQ3LyGn7oZ37DWpTAr1fPD3pvOdDFF94AK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1231
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/29/21 2:43 PM, Sean Christopherson wrote:
> On Mon, Nov 29, 2021, Babu Moger wrote:
>> Hi,
>>
>> This patch caused the regression. Here is the failure. Failure seems to
>> happen only on 5-level paging. Still investigating.. Let me know if you
>> have any idea,
> Fix posted, though you may need to take the entire series up to that point for
> things to actually work.
Yes. Verified the fix. Looks good. Thanks


