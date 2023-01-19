Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3126743C8
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjASU5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjASUzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:55:55 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1112410C;
        Thu, 19 Jan 2023 12:54:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpRzHEBSqZhnDPSWGiwtWDLHqKceDJEigWcc8Oj/hdlXG+4joEZbGiHzhBvmdc2chPePUl7OnTv+9m74aMA6cYu71suqu6yS2WBAAkwCKacw41eksIM2iA3drcFmWQ50M47nqjQMbtaoW8CYVfFLF0kPh63fjx0gEAJKc9T2hTJvqS54oLbUyw9lJxhJZHFex6e+zlE1D9VbP5UaysxWC/Up4Ya/RmfmBTIsEDdTQ7EfcEfG00J0ok+KYgNXyizY18Vu3M3XWT50TmZZLc7UbXGvPVXMd0XbUnnZz1iWPIPQaMdh/hoEAkma6Il4usuQLLp760vzlMm1Vs7FginQ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HOgyxrq9N8g2Mu+Cwpzq6gk65nUROV8XBy1scoh5xA=;
 b=Jve20psQCJ73qfyAPjMw8kHAOR9BHPqaOf+1/72jxgiP/kZs7XNmBiHOInoy6jLoMRalDVaaThKZGV/z1cKoZR5+GCpPxw8gg3Qb0mDHodo/7liFYfkeaxopxCUYFnVWrUTb/iFNa2AjUAW/J8ETfFeo4Jkpp94xNCXWDes1C5ydM4vUgbFTjqjSN/sqktW/0T+cSxu6HHvx5KGGQCBkNeDocVawIdksbyuGXOZ1qHr/F5sSv+w4kc4DCo97nJ8p4Jj+tBK8FZZ/YZBkuIGQjm+7H0vX0/H0+rqg9uvnPkpfeeh3Cq5rqi79RjSu5AAO7siSp1Re0Lrgx5dWq4n8iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HOgyxrq9N8g2Mu+Cwpzq6gk65nUROV8XBy1scoh5xA=;
 b=weio3D+9fBDbgiy03s6pLaAakwAaog1NCVD1MIzR1wnCTYOBRcykqAJnJsUIA3rc56qJGnRLXvyxQIetLGB16xL+nmoM/HueuPm7qsF1MIYlEKV5FZ3sIXKouz6DRrDTbvDu1an6wOumvZDBp88r40JmzWUdQYK+Juk85nA+tkw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB8570.namprd12.prod.outlook.com (2603:10b6:8:18b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 20:54:08 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 20:54:08 +0000
Message-ID: <e75569a8-6b15-780c-a7fa-945f1cce576c@amd.com>
Date:   Thu, 19 Jan 2023 14:54:01 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-53-michael.roth@amd.com>
 <CAAH4kHYoWtM=Xe0kgmtKw01-45DefEikdLz0qUJRRMLdZHzkwA@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAAH4kHYoWtM=Xe0kgmtKw01-45DefEikdLz0qUJRRMLdZHzkwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:208:d4::42) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB8570:EE_
X-MS-Office365-Filtering-Correlation-Id: 52ada9bd-adc6-4505-d18e-08dafa5f4f15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3vK0VkWeLnYzNc9sG0OHGINZcW7rI9exthQz2oIerfB9irduNsT8oj60bNT2MEP/aPWPSZQMwO3oGI0O/D+28xAEMrtV03cE4mVh9IQP1CRUVAQrLwbR/J2vaNpsVpyUptMPamjLK2i/KoKEwGG5IGUBp9xcf4jXySq+N4UQGcNm9rH4LgBzU+RYKKHlBH5J5qOW5gGh+MJIgyFRJF2TWwSioJIlWsDJjLq1LG6HWgL6S1blj88pg2CE3hT5AfIljauHwWvW/VIGGZeF1dhoXTAD/yOC3m9JvbkeXBsmWxk9K5HlqOAt9IpP1Rf2FVD/bqXrb5qjgIqnv2PK7Tb+loVHSGIQx0IYNOOidrAzLZMRNgCGlk6e9sNTSEZ6oN5dpJEn0JP1CXQrLUFvdxN2baVdjv2KOHDiYJ2LCzAy0ALjQWGKVgkL+pzc3iOR1GGch09gNJw1sq1awKgQQ46MfgnJem+dtF7Oi19/wBe6wUKU0qn1PEy/RczwaDZ39VzgYRV4j62tLbMQgt3LypofinwebgAyT5FELqVXATTBgXu8cGnJr6tKaLRebcfmzFOYAfDLf1H/B0NyrVKNLZyCo7bm7wBBwKF2GGrUVsno6qUW76CWsO0z2UWLuzKYLIsUgRoLxCH05zHmVQvKy5/B1cy17y5oLyfMwgim3+tUQxDAxyz0LtEnrtkp0tQYE6U0D2M3rQ0vkLc9ENUb02UuurRDOPv1tkxiiqQDC6v34Y8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(6019001)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(269900001)(451199015)(41300700001)(4326008)(31686004)(6666004)(8676002)(8936002)(66556008)(66476007)(66946007)(4744005)(2906002)(36756003)(2616005)(7416002)(5660300002)(7406005)(6636002)(110136005)(316002)(53546011)(26005)(6486002)(31696002)(86362001)(966005)(478600001)(6512007)(186003)(6506007)(83380400001)(38100700002)(45980500001)(43740500002)(10721665004)(344275003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amlJQk4xalhTZ2Z2QndNYzdaQXJDZUdRSGhNT0ZNRmkzNlNrNnRMTFFmWjBF?=
 =?utf-8?B?TGlGMHhsRDAwNlh1RnpBMHdMcnhQa2p5ckVGVnY2REdmMi9LaGhMTUlhSlNN?=
 =?utf-8?B?cDdJUHVtY3JrSS9TUmFWTStRYmNhaU92YjZyMjdQcER1WUFLWXZGQVBLZjQx?=
 =?utf-8?B?ZWdmcXVPSHdSald3d1pJSjhUM0tyRDc0Vlo2SW5HdC9ZTDl3V21BaVhlbkxK?=
 =?utf-8?B?eUNlQy9jVXZZRnptSUE5d3ZJeG5KbkE5bDQrYWkzRTgzNEVaVDhOMlB4eFpC?=
 =?utf-8?B?cE96Q3BZVkRMUFVsUVFNcXpFaUNEVW9RVTlvTkg5czAzTlhjcGlVMU5VTS8y?=
 =?utf-8?B?aElQL0V4WUhXM015YkpFdmVGRkJyNUtIM01tMkNuN1EzWnlSL3NnVDV3c1Jo?=
 =?utf-8?B?Z2VyRkVETDQ4eDJOR0FoK1h6bDRKb0g3NEtabU1oaWJTU2VVSGFWOXp0TkFO?=
 =?utf-8?B?MWtWQlhRNjRYRGVzWTgyRmhFdG9seEJrQmFoWEVUQWxwbXFYVUM4Ny9Da2ZJ?=
 =?utf-8?B?TzRYeW9jNSs0dEN4VzMzQVJUMTNmNUlZbzh3djdCS1daODRKdTY4V3hRczVn?=
 =?utf-8?B?eSs4NVo4RmZIa3l4K3dLalVodVEycmsya3o5WDBkUzVGTGlFRmFxYWNjK1Rl?=
 =?utf-8?B?eHZXWG95RHFHbVhNY0JBOU9PYXNFbzZ0c1pMU21wak0xdmRwRSsrcUdNUzNm?=
 =?utf-8?B?Y0ZOc3puTEZGbldJcitGSGwwZDJQKzAwZ3A0SWdVK1Uxc243cVo0QUcrY1du?=
 =?utf-8?B?Z3IwS0h5dmd1RGpnS2tjMVJkZWtNdlJ1cEtuaGhVNjZFUFRzbTFjL0RjbXQ4?=
 =?utf-8?B?UTF2bkpaRGsrUklQQUNkR254RVZFT1NxTHZLeHRZb1l6R0llUTg0VWVNb1RL?=
 =?utf-8?B?NFlrT0txN2ZyZzg5UHRKb1NYb1VwblhOVERLM0x2cEcvZDBXZDRVME9zWWZr?=
 =?utf-8?B?aldpU2w2YlBEL2RpTDN5cUZtNUd1QWNPalRsSmVTb3duUzhOVTdRR3dRSFJ5?=
 =?utf-8?B?Si9QUnZJVzEvbU9HN2NWWm5URElBd0pIaUNYZFlZN1lrL2Rzd3NtYkxNOWlQ?=
 =?utf-8?B?dFVCUlRMd0ZMN2ZVeDBwK0hHMHRvekp3a3Q5ejc0emxMNG5EQ1NLa3JadS9F?=
 =?utf-8?B?eVpxZmM5bXhvNmxKZndySzk5azZab0tSZmYrWW1XYmtLbFVLNXJlS09oRWFT?=
 =?utf-8?B?TUJIZ1gxajNwN0lGZjdJK2VPT0dGWnZ4MWdSS25qcXgyNVZBZ2d2MlJUYk5Z?=
 =?utf-8?B?dExydEZNS0pGQ1RiN29wSlZpcDlzSjJSTWxWMGlVMXpZekZFTUhUYnp5MC93?=
 =?utf-8?B?M1cxanQvdlJLTlRCbnBGb2I1c2JJNU14TUhkdlNRcmtzWGwyWXdMVkRWTGFK?=
 =?utf-8?B?a0xhTzlBTWJnZmRPNi9CZWd3cUxuZVFNS2J0WTM3c1NybDc4SUt3SDBjanR1?=
 =?utf-8?B?cFIyNHJicTlIRVZFSW1WalR2ZFZDbGtYYVZPc0w3ZW4rdFlQV3FkL2ZmMUpJ?=
 =?utf-8?B?LzNNN2F0SnkyTGRGVGMyamhCeEd2eHVHK2VoTFU4K1pLUWY3SThQc2Zsejgx?=
 =?utf-8?B?Sm9TeWZXaDRTSnBNZXZIQWRKMUpZRG5VbEgwd3dsMlUwdzJhby9vSy9NanFs?=
 =?utf-8?B?OHg4cno3SE11VkVEYitXT0I3eUc3K3RlNlNlN0N6S1hSL3VyOHUzQllXUS9O?=
 =?utf-8?B?Q0tLbUVuT2xJR0xMNmloYWhIaFRXeDdZakJGUmFJbFlhLzFnTHZ3RHhCNFB3?=
 =?utf-8?B?VTNaMFlOeUUvanRQazlvWE9xZmxrclZTSkZKV0NldDhJTERLTDBvcmxNNnlJ?=
 =?utf-8?B?ZDg4RVVmcm5qK0hZNzN2bEpXS0Jxa1hVaFJRMElKcXlnaHdSNkV0aE0wZDAr?=
 =?utf-8?B?N1FBcFZQN1hZQWVtN2MrYnZlMGR3YWJ5OWxVSGd5Rys0ejQ3NkZQazVWaUx1?=
 =?utf-8?B?QTBlK0YrZysvR0ZWbVQ4ZGJVT1NVRXFGQkxBOTBzNmplUTlDdjFDSkZWMXR5?=
 =?utf-8?B?YXp4cjRZd216TnlES2dsZ0FRa1BBQlF5bTlJclg1UWh6ZE5nbjhuUW4xQzE2?=
 =?utf-8?B?K0xiSXg2MjBjS1dzQXVDYzdmQjFEem93UnUxL1N1RjdjWkZJaE1kdWV2Qnl1?=
 =?utf-8?Q?5DwNnRUbau5LJjlt2e1nt1u61?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ada9bd-adc6-4505-d18e-08dafa5f4f15
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 20:54:08.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uX+WPEm5b/fc1S+j/aYNqhicpwJk1kTy3eDCN+PjZXrApMV2z4xNnv5Tvc65/17c8vDHnU90toywUeOzFH98Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8570
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/19/2023 2:35 PM, Dionna Amalie Glaze wrote:
>> +
>> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
>> +{
> 
> Both regular,
> 
>> +
>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
>> +{
> 
> and extended guest requests should be subject to rate limiting, since
> they take a lock on the shared resource that is the AMD-SP (psp?). I
> proposed a mechanism with empirically chosen defaults in
> 
> [PATCH v2 0/2] kvm: sev: Add SNP guest request throttling
> [PATCH v2 1/2] kvm: sev: Add SEV-SNP guest request throttling
> [PATCH v2 2/2] kvm: sev: If ccp is busy, report throttled to guest
> 
> http://129.79.113.48/hypermail/linux/kernel/2211.2/03107.html
> http://129.79.113.48/hypermail/linux/kernel/2211.2/03110.html
> http://129.79.113.48/hypermail/linux/kernel/2211.2/03111.html
> 
> But I don't see these on lore. Would you like me to repost these?
> 

Yes, please.

Thanks,
Ashish
