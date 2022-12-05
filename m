Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02356437A5
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 23:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiLEWF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 17:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiLEWF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 17:05:27 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FB1C40;
        Mon,  5 Dec 2022 14:05:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWy/3ycVfNMYdjm/qmgZlbFiCJ6+440Mo+zIktxNemoKVRSfW0RwnSAHRb0PfhfBJ6QRaqjLO95nMQfCPW3MDTeLKwbT3HVQBNI3OyK7qNKdIhqL7y93P/7WRoJfAAVMUZ20j7VepwIjUC/KcA9Eti7AIV8Oes2otofNEImcZHnDYvqC7sQNAjFybV5Q2gUrtBSECb8KFMupRFJEZDzKu1jBYmxQSMhiDNOKq/c6a6toevUHRX1HiPlBsVqdJmYzX3Ipa7zfllOth9Sr+8xWkX4otjDGwTRK3twaHIi8ny/Ntr/Rixy6ctY5j3iYivYTyF8hsZlJpCnJ2tL3d8Gmlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWGI7KUTvroWW3xM8pTptGV1FGip4+nRCmlZGQWsTW8=;
 b=lQr8lJpHUZGlUtwlU99oZz4j2dBnDPUMQ0+5I1eV+C5LXycGtXb49MtPfyyDw5/KhTYFjDKr21ApJOyekcPRzN/W0GOJiHZdl5Rmz9z6c8Rk9jPXuNaBRD+NJQaRh1GmdKsD8cziRrs5pS3Ik4b9BWj7itgP03uJUzlNw6ZkgAmV9LP+4nPmz2WcY4MxM6mt2GwXrm3rzP3jzTX88vxHwIzrn2DnJu+EZLO0IaZ1UoRpiPBGWarCnKV8ed3/EXze+a3UCtbiy59j1wIxJMxbBRmyZyRZVkWRrjEnRm5iEBTaVN0zTS/flYcQu5fjGyqCS03zMvM5OFLr2zKTzgZDEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWGI7KUTvroWW3xM8pTptGV1FGip4+nRCmlZGQWsTW8=;
 b=SJdmnR9+q8n7gkHKr99z6KZA3mBj5RaqjnBot8AqPCKDVygU+74MUAtXhyrhvTWOSBXKg3e+znU7e0mUgMAaTJMSYVzD8XYxQy2w25xoCyZDqUckB60lpHzy1D/izFidzz8LaG5WSmWhHylP4DbP4PQohoPN2Idse2GogtJWGjs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 SN7PR12MB6815.namprd12.prod.outlook.com (2603:10b6:806:265::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 22:05:21 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc%5]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 22:05:21 +0000
Message-ID: <f2964d1c-ecb9-f88b-c73e-64c960b91d9a@amd.com>
Date:   Mon, 5 Dec 2022 16:05:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221201015003.295769-1-kim.phillips@amd.com>
 <20221201015003.295769-2-kim.phillips@amd.com> <Y43GpD9fgnOGNEcu@zn.tnic>
 <53393726-5a8a-1a13-c620-32c65872278c@amd.com> <Y45SkWalmZJ/zB1j@zn.tnic>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH v4 1/7] x86/cpu: Define a scattered No Nested Data
 Breakpoints feature bit
In-Reply-To: <Y45SkWalmZJ/zB1j@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0034.prod.exchangelabs.com
 (2603:10b6:207:18::47) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|SN7PR12MB6815:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b4f7501-e803-4347-bb4c-08dad70cccff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nTb2IUo4xSPPXAWLypoomrkepSxEJ3ytfmzsKzLkvPB5K6g/JO+PeoeE1sDB5u8gJXzQrAv1fwdiSDDYs2tjjNu6WXEvGRGUfSpMEVkJiJj5r3TpxtwtARiOmN80QLLw0Mg+4mZzhC5DZzBrm20z0ej97Dr/fHmOFrJ3qfopO5zRQa1VRpQhx3oglAjNXjZuh2kxEAL32Czq6cZrFLnmnX130y/BBcQlR2+ZmEQlDyndD+ppWN3S3YK/EPsFL7KIkwW6AV+lgc8uRyu+0Xr+mSaP+NBs8MROAtsg128lvGIxjQjSdnIZL71w/MM7GXKT0Kf6W88aTAVeI3iWBDjOygi0cq6s5RHE3FvoGQOvurysECf4iHVYDJJg/mGm9tK6ov1gF7K+wFXJAvozRYiUWM+qXw6XVE74LG+qh2G0JbQvJWYG9HsAjB1EmKJhueda0PUWUtVHJP4+ks3b/mgz99xjg3DHcoVEC77tMvoW9iJV6/Vgo38m8lDYLAHHgo0BEVzuxTc+GXY/EevuW4GNHeEJtQKKhD/LHo+P7kwOBnfYIJGHxg+Ljsh7AHOXaz1uHOVPqPNhvFrm5rNP2s9+KC6KZtyYHx16KUrtvqv2onWnWPQFSuWlLBKLidgzwonJEA3x8xp5QPxcok21j1Ri57dEjk2Y+sx2u5fUyY9lKQauOqac0RgqaFKX1wBFIphURRoLmXDFvFOw/5AAPHZ0zKPqh/IrEq/eLXYirV6knEc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(36756003)(38100700002)(86362001)(31696002)(8936002)(2906002)(4326008)(41300700001)(44832011)(4744005)(7416002)(5660300002)(478600001)(66476007)(66556008)(6486002)(54906003)(316002)(2616005)(6916009)(66946007)(31686004)(8676002)(6666004)(186003)(53546011)(26005)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXIrK0lZa3hlV0NMWjdxY2M3RjNCV3JPYmhRbThIWDd4Mm9qUjNCVHBFWUh3?=
 =?utf-8?B?RzhGbWpBYmY1L3kwdlhYWUdNbUJFdjM0aUhVU2hBUE1EdHpCRWxQWEVxMERS?=
 =?utf-8?B?Vi9SUG9BQjk3SVVPdVlhRGFuTWtLcTFPWlh4VkJaVW5yZFhteEdCQWEvU1g2?=
 =?utf-8?B?a3BvMHFZQWRpQVFPYmlhYUVhcjljSm5jNjBhUTZ0aDEyb0NLb2N3eEl1M3R5?=
 =?utf-8?B?S3pXQzlIQzFkODgrRDFnazVPd0NFOGkwUmdmQTUrU1RqSVRXMGlNQk1yaEw4?=
 =?utf-8?B?aHREdTVTMENvNnJKV0IyeElmak9LUjRrKzE1S1Mzc1hBa1ZFM01sa1I4L3RU?=
 =?utf-8?B?TEwwdUluSlRtdEc4VGc3ZkVnUzkycDdkdjg3MURvdE9lWUZOenJoejV0TlJE?=
 =?utf-8?B?Mk1MQnZZVjFLSzF0bkpRaWJjMXFsV3dZOVp3YlRnZXVhdmVzUlY2cVZWdUtw?=
 =?utf-8?B?dWhwTjRJZytQcGEzdGhaMTU3Ykkyb0VyUWpjejFvTjBrSnZ6c1NIc2E4VTE3?=
 =?utf-8?B?NXdzZW9xU0hKOFVvMklDM3ZzRzcxMzBZdUlHa1hpMTMwOXBqMWoxdytPa3hX?=
 =?utf-8?B?WGVBdXUvcTdYdW0wcVk0YnJOZUpRTVNwRkNiWmZnYkV5NDZJWUNzdkF6WWRU?=
 =?utf-8?B?dVV4MXRjR1l0MXJuYlEwRnIzSE9tUXp6a2JRVlF1ZXN2elVwMWY0cnpTcDY3?=
 =?utf-8?B?UC9ZVFJSL3JBSDlPMzkxbHZ2bGYrUkRKcjdBbUlVbHl5TWN4cVY5bVB4Tk9F?=
 =?utf-8?B?Yi9mcWEzcVR0TzVwSjRlaU9jN0ZhdWNZZUE4SVdqeUsxK3BVanZ6dDZRZnVH?=
 =?utf-8?B?RWJTLzlGdUZ5anJKbnpMVmJ1WTMyZ1dVV1JaVUZEZWZMOGRydktaQjZCQ29T?=
 =?utf-8?B?b1pyOHRoNEVMa0JzMWtNVWQxSXZ6WG05T2tldTFtT1ltcEN1YktXczRIdDFZ?=
 =?utf-8?B?VEFkQ2FocytLUlRVRVhUK1UveCtBTEs5cFIwdmRTdlh5azkzcWcxVWRxMWY0?=
 =?utf-8?B?cTY1d1BOWWxiR29qT2dSL2M5K1BmVTZxV05iUitsYVk4NWY0eGdrWFA4d3hH?=
 =?utf-8?B?L29IUTlFbUtmbFBFOTFuWDRnWmVtMisvd1RkcEhGM05MNVRwV2dtMzkxSzFQ?=
 =?utf-8?B?cmVsc0Zqd2llc1FZazhuSTIvWDBWSUN0bTYyTWhHMGI5ZmN2ckxEeVlLWWpW?=
 =?utf-8?B?RndHVVliaUNoWW4wVzN1TkUzcHNzNzFEQUtTYk03NGRpRDFFbUl2amNjSXRQ?=
 =?utf-8?B?dFJ4ZDREdUZDOWpSYjVrVzBVQnR1UWp6d1oxOEdTRGN2SFlrQVZPWnpCdEFS?=
 =?utf-8?B?dGhtSDlIZTFQZzcrR3B6Vm1QelpMS2xHQjZqREVibG1UUDFjNkpyMDhOSkpI?=
 =?utf-8?B?QWVwUjk2K0s1NFg0eGJFWnpNRnpPQ0JDNDFscWdGQ2JPVkRwTG9vNjRYMlZs?=
 =?utf-8?B?S3BJbmhXNHRqL0xCamRyUzJTY2g0S29rKzZVdlZ1OWlxdDBSbC9LQUIxT010?=
 =?utf-8?B?MDVqZFBNczVwalRTemxuTGdSeldkMVJQdG9KQnJkM3ZnZ2dQWHNYK01rak92?=
 =?utf-8?B?bFZWTm5qSEJkL3N4TXNkMzh2L2E3SXFOVm1LY1MrVUFKb0sxS213VE5tRkc1?=
 =?utf-8?B?aGswNnZKNHFJMU9oRDFMWlJpS1hZVHRkdTcxUlVpVUVuUU9zdGZkNkpTRFk4?=
 =?utf-8?B?Y2pVU1VjYXFITFREZTBNOGNHZU9zd1RyN1VGWi90QW9LT2ZyVFFNQU9aZml1?=
 =?utf-8?B?ZnR4R1FsU3BqOW5rVXlQU3N6Z1pXZmM4aWcrVVk0WHVSWm5jVEJ5cmgwc3ln?=
 =?utf-8?B?UHRxeFRueG1qenRYSDdYeStrTFlqL1BoeVdBamp3eEw4WFZjOVQyNEh1ZURW?=
 =?utf-8?B?NFpxZkVXbXNoTDlPZTdlelViNGpQN3hBdnBBbk1qNUJiU1RiN1BQTWlyV1pE?=
 =?utf-8?B?WVEvSk1ySjVtNGl4M0FyelZkNmxNcWNSNmxWVE1aUkhVYnNRVzdUazNxU09X?=
 =?utf-8?B?bHVzMlllU0VxcWR0UlJKS3Y3cmRITWQyd3JaWVNSb09HWnVwTHNSampOSUpJ?=
 =?utf-8?B?cFdVQnlhR0gwaDdoWFVEaWtMNS9oOVNNMkk1UWUvTy9ZN0haWS9PMFRURXF1?=
 =?utf-8?Q?6O2qVUht4hK+OSVCEYKdJ7yf2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4f7501-e803-4347-bb4c-08dad70cccff
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 22:05:20.7268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fIbHO2aYxcyCLyjh1Orl6bysCzWGCLrW8QhMPJYIW2nJ8YuLADP3v/VZth/mC+f1s42M2u+WI9VNi9rZLnmqoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6815
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/5/22 2:20 PM, Borislav Petkov wrote:
> On Mon, Dec 05, 2022 at 11:32:01AM -0600, Kim Phillips wrote:
>> This is starting to get off-topic.
> 
> What does that mean?
> 
> Are you saying I'm not allowed to ask why stuff is added?

No, sorry.  You had asked "what is the use of this bit in
a KVM guest?", and I'm saying that it was already being
propagated to the guest prior to this patchseries, which
is about propagating the Automatic IBRS feature.  That's
all.

Thanks,

Kim
