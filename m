Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7847CDAED
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 13:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjJRLrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 07:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjJRLrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 07:47:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91777FE
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 04:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxcRQmELBxKmc2YLHGfGXHyz85aGcsxJmlAh0NWv8J9QCBn1ck1MMaUmhnZ1IKWDaqA8x7cpF7nX6APboiS/OkIaOfO6+1NrwOj532a/WlOfTHl9+6O0aQo8HEj6qDpklwou08ajU6wQHjnS6FKC01t3il9uIn98n70P3H/QjCMmyCleYztd7Kz61yby5uyp1A1mrotun065wNqE3SBvQ2NAxPjea/sVt799CrgxTLePG5/MS/A3bkyrb8Wc3Pg0Mp3l0t9SnrVVxJ8vHddxZFPY5Et7Z8nR5KxM2DbWT4BmZWvbZNfq7Ld0D+N2svdktzdg2eYX+qRXunohgeqeNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9gJZJvow+phbwT3+ITcbCuSGhZwSzL2R6WE1edTUYU=;
 b=ikG8ckSyr44qY9s1UyT+fcxJK5JTXtsYf2t2GqwkNxFniBzOBbiIWir3NSTMRBH4BT/7FHo1Ksv73NbIiBiV2t9dk2ctFw4sPjQ+F12n/cHvuYHFyEYqdE4BCa745lhWlBxQCy7G3BcI+pNYGvlJpFYvvjyWCWN2CEdf/R9vGXfabNCQahjqeFc0gKdgF7Ety1Bi6xFkE1az4ZZSn2mBO7OKzXGcnC0AnJNTQLICF/GQdxuqiNq4iH9PDP+veJfIzXc+ax+Xl8tAAnsJsaB58RbCRv9fJU07rn5iPWLAp4F9KNhEYv6kLINowcJkY351COteGazzDyk03/8DYC+Waw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9gJZJvow+phbwT3+ITcbCuSGhZwSzL2R6WE1edTUYU=;
 b=Dy0eE1qOnD4PJroPrAmdgBjqkD3zsk0X1hjoeePvnCmUsdMxZARK2+l5RkiaHr7yYRuI0CaNGZmTmyjmxZKkViMemDJRLYNWAs+Z0UO+MHH4ZwI76k5A9jckZBuzeEsG63mUGpCofbBkiXv5rp8AgC4Ta0t8kF/1kU8tvCoRloI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DS0PR12MB8563.namprd12.prod.outlook.com (2603:10b6:8:165::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6886.36; Wed, 18 Oct 2023 11:47:10 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 11:47:10 +0000
Message-ID: <3243b226-1898-a671-c98e-e046f4633b57@amd.com>
Date:   Wed, 18 Oct 2023 18:47:01 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
To:     Joao Martins <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
 <f359ffac-5f8e-4b8c-a624-6aeca4a20b8f@oracle.com>
 <20231017184928.GO3952@nvidia.com>
 <30c20c7f-c805-4208-9550-eaf2c9b21dad@oracle.com>
 <50f80389-6075-406b-9bb8-e4472e1b2205@oracle.com>
Content-Language: en-US
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <50f80389-6075-406b-9bb8-e4472e1b2205@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DS0PR12MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: edcfe7ec-4630-4050-4f6c-08dbcfcff673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zT1RBNZ0E+Xg9Iu0EvFRLBXki7PeznJhIKrhX9mkRk0R03Dx/64c+WeA7SJgWGe1wbA6rDYzfq+r5Io95D6aW5vXpVffAX3ZsKLwy1eO/+AQOdGh4dR93Ey/pn8feiw2o99kvdM6TyEUcRvqmw9q20QMOcCB1lJwRKbqHoY3LMHIhZoePVXwkoZeGnEgijssrL2x1BXrkAFiKMDW74FJ+GdOic03UnHqbFvqIT6eCm8qxcz5TUAEpf/Ni0qyuZ+9xzsZUNdqMwOAnOlvYPtdczMJTh7AWg7/v3Zx+l7yRBpkVttuILAK3FuT+9A3Gjoqk0apuBlMZLRfQ3DA2SqPGmapQlPFnFOBIN/EmKVriKkuMQIqUJHsCmeg/lzhWrCXOD+bng6/eIUgYqRAW8pW9jCS0HcPsezYk6eRHd8mND8vVP89twmzCTKRANrwuxcjZL+k/kmGNt2CJbr9xZJQyPq3IjwQHN16jl9wluZjcdKn48Gscv7GWwvSvWgk7DIWyXbMDIpLeAzNgBYphoiymj3WqjU5vv2/HOw47L2AQBKtu/pYevbrVPF1F0IfqsktI/aPDF0KU9JRjv98SeJL3IG79avhECmVNKy6giJNb0C0DZavdjbhg5XoY02zvO+ceaJ4iaUEyrUtYcKua183fPsg1Ncd58qbjv7PiFSFljY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(346002)(396003)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(31686004)(66556008)(66946007)(54906003)(6486002)(110136005)(6666004)(478600001)(66476007)(31696002)(38100700002)(6512007)(316002)(26005)(86362001)(53546011)(6506007)(2616005)(41300700001)(36756003)(5660300002)(7416002)(8936002)(8676002)(2906002)(4326008)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkwyYUc1VVkzVjFkZm03SUtNdDZaTFB0N1NGQVpKTzhTZ3dVNTFxeFQrdGhn?=
 =?utf-8?B?OTFERGphelYyRkFNcjdmZ1pOK2dvZk5VVHdkbVpBbFZoczZxSXNEL3lFSENF?=
 =?utf-8?B?QXNSUHJ6a3hUMy93MXk5N2RQUjY1MlJJQlNEOERVVXVybWZjdExBZ2lUdVNu?=
 =?utf-8?B?Q0s5Wk9CMURJQXYxc1pqVjVIYitqVkJmTlo0SUFOakJJK2pKdWorcWFJZ3pq?=
 =?utf-8?B?aFMxRTM4ZE5SSENvT2g2ZGYwZGtMSGdWdWdFaWRrVnNRMTJwYkthdjROQjYw?=
 =?utf-8?B?ejNWcEF5eTlqVUQvVFZoN3hKNUJwWWJFR3poeksrR2M5Z1Nva1dFTlZ3MTRu?=
 =?utf-8?B?MUZmS0xsRXJkWmhnVkRvUE1OUFd2Z2RTeUtqaHUzTkZDM1lLS3lMQUsxbGpp?=
 =?utf-8?B?S0pkZGNLRXVHaGV0NzkyYjdHbWdON1hMTGFmZXhyRGVMd1k1dUhwR2hFbU9w?=
 =?utf-8?B?WmlRSURJb3p0K3pESHRlRmZyb2NIaWIwMzR2K2VYWFovTFdXWUtoYUpVcXpM?=
 =?utf-8?B?cTFUYUpmVzVGaDJqZVVkYy94WGQyelVnZU1YL0U3amkvcGpUcHZ4aHpiamRj?=
 =?utf-8?B?bG1JeGdOUmJRRVpWc3pQZk1maGlSS1AyeVNLQUM2UC9MRTRjRXowLzkyWVlj?=
 =?utf-8?B?UWIwNDRyM25EU2NlYXd6bzdVSVoyU0d2c29wVVpTVmJCZnJtR001SG9oWVk5?=
 =?utf-8?B?TmJtSE5XTjJvc2h5OWpLNjRVVGxjQ01VYXZtNzhud1VYU0E3Y25Qa1ZBUi8r?=
 =?utf-8?B?QWVFVnFwQ3J1eWZnbldhdjd1S1JHR0x6M1Z3Vm9VaEFidHQrdi9acjNLMTlB?=
 =?utf-8?B?b0VhVkMvTFRvOVRGUGNHdkU3d2FjS1ByYnFCTTlWc2lZTmxjR1hiaGgvdXVi?=
 =?utf-8?B?eGFOZ1U0Y2dsV1lIenpjMkVpL0ZsUStoazlVTU5iUU1pKzVJWVV0c0I5a056?=
 =?utf-8?B?RHZVV2s1L3lka3VCOW85Rk9CV2ZtS0Y2VWFCVWJwckxqcjVGbUZpWVpNWStk?=
 =?utf-8?B?bUhNRENrdXhibHVlWDg0M0JVSDN2dk5BTDdZOEVHaHRxUko5ZXFoQ1EyeDB1?=
 =?utf-8?B?Y2ZSMTRpeHFCeVArdy9CQWRBOWs1WUZ3U29KZEJhWWV1QUlrMytLWTFNK3Zv?=
 =?utf-8?B?UjZLNWZnM1pGZnFBcjlWMzFKYzhrTERpNlBDWkEvNnJhSVdNWVNpM2VhMlpN?=
 =?utf-8?B?YzVWM041OThrNmQ1N3hTNzdBNVdLV2RCTllYK3JFVmhVcUtwUHBsb1E3cUJ3?=
 =?utf-8?B?czJja0hIcndFVGRNYm9Pb0VERUtFdE5NOFZKcFRyVGRsQkpIQXE4TkhLbzZa?=
 =?utf-8?B?bDlGbmdDVTFKZ25lMjhPQlMzeDFCT3lIVC9rS2tNOE1JS25XQnV0dEx1UXVl?=
 =?utf-8?B?K1hONmhwM0xTOHg5NCtkT051WjdIV1lHYmZyb0JXVlB0eFFkRi9ZTklWSlB4?=
 =?utf-8?B?Y1pJci9UZGN6MllsbWx6eXFQdmx6RjY5eTVZQW5jL2tvdWNZbGlKZm8rM3Bq?=
 =?utf-8?B?L2RLMCtsbXYxaWVQT0hFc21KeG51alg5eXhVdlFxWFdSOS9nZjFFbjl0S0xN?=
 =?utf-8?B?emVRbDhqNGhrdGc3NHpSNFlaejZOS2Z0T3cwRThpc0w4bGRBY2Q4ZVZkeFd3?=
 =?utf-8?B?UWovQW9CTkNvWlhUMEFqaUJDOHVFYklkakFoTVN1YVh6a3ZuM0J3V3lPby9t?=
 =?utf-8?B?ZmpvTk1ObjEwSEFEakZVYm04TGZDUWpqN1BpbU5uQjBJUXpYZnQ1NzFYbFUx?=
 =?utf-8?B?WmYxV3BnOThXRVM5bDhGejN4aE84TjdUUmpJTzYycGh0d0JOdFVSVE8reUZa?=
 =?utf-8?B?OVBZSnJOZ0hvYnV2bHl2TDBEWmJkNHVQM2loaklST2NGWEFPQklBN3lnUWNP?=
 =?utf-8?B?aG9kSkR6RVNyV1c5SXplRmJkL1Q4TU90ZjVDRmxxdDViWk93bVQydkZPeVFy?=
 =?utf-8?B?MWs3NzN6SlloeVRTTUZUY3d1WGJGd0RHbDcxVDFXRm1OV0xBVks0YVdKR1VM?=
 =?utf-8?B?eE0zR3JFaEFQNjlzNnU4Yk41eUQ2Mmswd090QU1TQzExU3YwTVFWY0ZEdkdN?=
 =?utf-8?B?MVpUNkNqQko2N3c1ckV5a0Nub3hRekh6aVZRNXVGSjBGcDRLWkxmaDU0MUZT?=
 =?utf-8?Q?VseSwPXmeQ+i+r+lLQekXi5x5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edcfe7ec-4630-4050-4f6c-08dbcfcff673
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 11:47:10.5879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzKTzB8p5R3LCkkh+jMVvJZgCNkr2GffP7yX3zNImMIXgEFoE2bEcA7UV2ImubczmF3dmSsAbMvPKTlNQCOn2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8563
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joao,

On 10/18/2023 5:04 AM, Joao Martins wrote:
> On 17/10/2023 20:03, Joao Martins wrote:
>> On 17/10/2023 19:49, Jason Gunthorpe wrote:
>>> On Tue, Oct 17, 2023 at 07:32:31PM +0100, Joao Martins wrote:
>>>
>>>> Jason, how do we usually handle this cross trees? check_feature() doesn't exist
>>>> in your tree, but it does in Joerg's tree; meanwhile
>>>> check_feature_on_all_iommus() gets renamed to check_feature(). Should I need to
>>>> go with it, do I rebase against linux-next? I have been assuming that your tree
>>>> must compile; or worst-case different maintainer pull each other's trees.
>>>
>>> We didn't make any special preparation to speed this, so I would wait
>>> till next cycle to take the AMD patches
>>>
>>> Thus we should look at the vt-d patches if this is to go in this
>>> cycle.
>>>
>>>> Alternatively: I can check the counter directly to replicate the amd_iommu_efr
>>>> check under the current helper I made (amd_iommu_hd_support) and then change it
>>>> after the fact... That should lead to less dependencies?
>>>
>>> Or this
>>>
>> I think I'll go with this (once Suravee responds)
>>
> 
> Or just keep current code -- which is valid -- at this point and doesn't involve
> replicating anything


We could keep the code for now. It should not break anything 
functionally. Then, once the check_feature() stuff is in place, we can 
propose a follow up change to keep things consistent :)

Thanks,
Suravee
