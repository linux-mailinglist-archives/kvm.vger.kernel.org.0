Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9ECB37C1DD
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhELPFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:05:40 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:63744
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233252AbhELPEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:04:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tpb3wuZ4B+IcNElC/J9GnYFX7RryD0BDmP94b0JWiDdCqFmBWYhLuDGogdCiEqYL5JERaIl/rmgk+wB5dcNVfwLsFF47vLaB0cyOs/B0blprfZVJuV999JLU5xaPxWP3ldiN4rqqi+xBrR0PiVZK62GU11SNJ3jhDiVEVLlpKfAZGoFll8eu1rXeQOsboOXnu2bVEvrJx3ZzQe+uqm1i3HMhwBAiqvdCfJibrf4rcSujjTdWSG/Z+yA4u5xPxW6vcdQNcQJa8R1qyEcljXlArB5OER/Af4zH5j9/eOWiLF4pklxcPZAs4JIahHtzE/FAndYBqzjWUQihA2jjuccv7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mc2ATICicPXBLyPe59CxY7W0BqyMizC+XysuTv3zA2I=;
 b=iIuK7LDUAj9ci6jSN2MHlL3nLVuIh/k+Ym4yEJkwEKeE9JjcBf4J0Sfbd5xCODp5oFW0K6TuWmDfvuYCMPNtq82gjX2fq4UeA9vRgyhNok0ICpKRp/4pjcNS7nxLka4bZXgkUAm+Kb2+m8pCchGMEgZkU1dcIxyfBZmLZLOEqFFM0VyRHXhojJl4w6RidqehqdrN0LI3hvSyiz2t2C57cBEt3XcSaCRZs1Lk29LCgB0hAvCraGt2wlvAikR2bmbor+juR8sg9iQbiN9q55PL1Z7ikmdByeG8k0MNIobzTWhx+w7R0eLS8/Dt/nbPxctUC2+GQnwqymE/HBW8INK99Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mc2ATICicPXBLyPe59CxY7W0BqyMizC+XysuTv3zA2I=;
 b=P+IdoRdZXFDeXhvJOBLIzZKzJhUzKR/8hOY7bMotvIkSunhwHM9rKXt9oOU0/zz/RIO5v9fkIXJE685sY1SHg1Gi+C6NpV5IAtoSbiIGLUdyJaNuqLml1ar3KK1ULUsfhkgH57GIPcROb6a3yN24IrnuHllx5qa06MeJ6k75EAY=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Wed, 12 May
 2021 15:03:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4129.025; Wed, 12 May 2021
 15:03:46 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 02/20] x86/sev: Save the negotiated GHCB
 version
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-3-brijesh.singh@amd.com> <YJpM+VZaEr68hTwZ@zn.tnic>
 <36add6ab-0115-d290-facd-2709e3c93fb9@amd.com> <YJrP1vTXmtzXYapq@zn.tnic>
 <0f7abbc3-5ad4-712c-e669-d41fd83b9ed3@amd.com> <YJvmp3ELvej0ydnL@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <ae227ce0-1ffe-aa54-4106-daaf423f376c@amd.com>
Date:   Wed, 12 May 2021 10:03:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YJvmp3ELvej0ydnL@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0601CA0018.namprd06.prod.outlook.com
 (2603:10b6:803:2f::28) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0601CA0018.namprd06.prod.outlook.com (2603:10b6:803:2f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 15:03:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3030164b-ccdb-4294-6433-08d9155723f8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44139CFFCDDD1A2B09E4453DE5529@SA0PR12MB4413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkL0JlvsIts9ZeDjF4SRIP+DOK8AHbdpS1Ca/HbPPXgF5R08qxlgEtj3v3j6mXk1jcF5PCrLAqkUwYW2RX6J//gdBMXPoAcnDl6L/jUOohgm1A9MwBkpqbhs8vzjPvSDHzpIi5DST8v3UF0hmjL853A1CKEwhuswnvS4HAAF+zPnQ00WXetSogpUbrHrrDS94bNcdbb7qy0z0WV3+s48Lq/x35O3ogX3cx6pIdx17gKtNjfrDA0BUShCdN6e+DlZiOklrw56A19dnOxfVqNKTSmC5GCvdZo5XWq/CNt5oyLRSGoEAKzkDzDY6FqkcWt5d1/Ef5pJMXO67aINOep9RdwaeBnDiZYX9Cwq+JldeOcVOBZAjXEtiFy7GJksEEQhrWKE1Jduut1/Ur7rPlBs5fmi6uXNU98f90PExRLV0qNIl6aeWfvruQoi1MUk9rjvWv2lB1ctzPvgHu0UupTCHP8ty1692M6f+tKRH8ShTp7tvCAqZza5dMefmciSczwXbUQtMfhHm+ZzH2lqWEdObrNnxwaqp2baRsad8DSWTepUICp5sXu1dhnAACfnv8JZbc+6HDXs7nzX5vk45XgrBBZl5eXmA1SFOSL/ScORPk3nBkDJIAxhXku2tAdTyp8ojnsQoVt1UFY02sSgcMkaWn6NOT0DW4MJL58zEONrSWmZHODpcdaYOw+Q1KQONabSe3IugKjHmwXPOSiqVnesaupqLIEFfUcLwbPS++LgCpw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(31686004)(16526019)(66556008)(8676002)(38100700002)(6512007)(186003)(66476007)(26005)(4744005)(8936002)(66946007)(38350700002)(6486002)(2906002)(7416002)(478600001)(31696002)(2616005)(956004)(6506007)(36756003)(53546011)(5660300002)(316002)(44832011)(52116002)(4326008)(86362001)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NDdDOXZyUldQNktBeGQ2ZFh2YnZqVlF6VFFWL2NieDNjT0lUSHl0ekhVc2l4?=
 =?utf-8?B?dDQ3UlZOYk1FR1FFSFkvTHlLWEZnUkkrL3Mzc2taNlp5VGN1bmlOTmFianND?=
 =?utf-8?B?WXlsTWozSmNiREZ2SmZvK0U1VGhNeW9OTitLVFlmSCtYUkxpa3BrczgxaWgw?=
 =?utf-8?B?bmc1ZWJpMWkzUG1MZFB2S2syVitINW9kTmFaQ0RTSlJCdkxGejZxZ2NPOHkr?=
 =?utf-8?B?cytxT0s1ZE9OcWZDQk9UdXRXNkI1TzV5TmU4Zy9JVmVBRkp6ZE0yQ0Vacll2?=
 =?utf-8?B?U3lwUXZYL1dMb0R1NHlmUzdQMlVxY2I0RmFpQTBZTDc4RmwweC9VQ2RRTS9u?=
 =?utf-8?B?VVJFbDM5MjdwY2xONzRRME9rb1BQUzNOTVNYL2JORW9pYStjMTgvcEZkeVZZ?=
 =?utf-8?B?VXdrMEoyeHFFSE1hVm5EL1R4alZmNDk4Z2RXQXV2Q1ZiR2NVZkVIVUU2K016?=
 =?utf-8?B?WTJwSThxcDJoc2tGQStEeStzQThRYldsWFNhb21vWW93bmYwNFNxOHJFd2hz?=
 =?utf-8?B?Nk9wQ2ZiYWZWRGRnK3J2SlNJbW9zcUxpUFlOU3VOUGh3YlUvVVB2UlVTZTJU?=
 =?utf-8?B?ZkRmMi9pdEV1dHhYMFMxS2tSeGVzTndGR2xLR0tJRlVIQzhKK2Z1eGwzSEZa?=
 =?utf-8?B?Q2Zvb0hLd2xTeEN4aGNWMjFta0hNTjJBQkxsTkZCMTVWckptdjJTbGdmMWNI?=
 =?utf-8?B?anNva0loZmZqMjNhbTFmU09XRHBRSUtDRzJwVWV3UDArSHpJSE90Tlk3bWlU?=
 =?utf-8?B?b1hRWW9WS0RJcEloYlQrclROQ3BUamdmMm5xSGxJbVh0RVRONTNHbFFzbE9H?=
 =?utf-8?B?cURKKzIyVk9JWTU4bERlUGRsNFBlcWpRekM4cFA1Q211Z094R0JuQlVFbjhG?=
 =?utf-8?B?dnFHcEJoclN2b0NRb29laFA1NGtOZm9BS2Qvbzd5NFNac0h0UmE3MGhYQlBN?=
 =?utf-8?B?L2ZNemMzT1AzRjNaTy9UL1I1QzJ0OGJHbEU5bzJycXBqNFNNOFdCekEvZDdI?=
 =?utf-8?B?K1F5bTJCM2p6S0xFNWFFODAveU1HdFBONzhkMlRDRFpHVzhHNzU1bUs1MlpV?=
 =?utf-8?B?T0JKb0JKdTF1cjBUR2JBVWNIaVZUTVViQnJhYVBhZmxIOEZuS0RPVUZYYUVS?=
 =?utf-8?B?VWU4RmRVcVM4ZzNkakJmSUxKU3JUVG50T2gyNUpGVWZQc2c0RCszQWRLWTYr?=
 =?utf-8?B?VU42ZGorQTFaOVlEb29KUDJ5ZVdMd1cxeHRhM1RlaWU5aVRFUDJBSFFwcGFv?=
 =?utf-8?B?ZGdtWnV0VmU4ZHprbWRlQlJiNUJrcWQrVE9CUGRUbUlhclBZNTBmdFlzUWt4?=
 =?utf-8?B?ZFRkbjJqUjVpMkFWQ2cyTFRvY0VUcDE0K0w3ZHpCVWQrdFZGRmlWdXNiWHBx?=
 =?utf-8?B?aDVxZ2tOL2k0U250Nmp5T01uWFRmdlI5Rlh4cmh4TDcrV1NGQy9ScXRrY3cx?=
 =?utf-8?B?NzE1R0hhQzlSSkxBekZ1dFVHd1d6VERNTUtYVDlUcmVMYTVXYytuMTlGUlh2?=
 =?utf-8?B?aEcyQ0JzYXU0ZHZhL1ludG1iMTQwZDlmWkJVczdSd1V0RVYzVnJkdmpZUmpk?=
 =?utf-8?B?S0xidWpNRk0wZ2RFcm51Rkc3WitXL29ROXdNWWdVWi9mbTBGMDE4M0ZLbnp2?=
 =?utf-8?B?MndPZGFrQys4ay9LNkR5Uks1eDdzTGdKTUJTQUxGRDhNeHFwOVVwc3M1Z1Ni?=
 =?utf-8?B?VzFFWXYrTUZaMjZsMHNzWmJvN1ZlbHEyOWZVMzJqaUdDY0tid3V5WWE4cmRN?=
 =?utf-8?Q?A7R8G80h0ZvXQ0erJDGGDxVpGXnDpJiIRrJg5ac?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3030164b-ccdb-4294-6433-08d9155723f8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 15:03:46.1373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zyf0zzzQxlDhsbUXBrSygd9lHhpQhZXKcJjV8cg8uGdy7wxXsZ2pu9JPtKv+DPQSH1B7H9lbqyjwx/xXjlGPiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/12/21 9:31 AM, Borislav Petkov wrote:
> On Wed, May 12, 2021 at 09:03:41AM -0500, Brijesh Singh wrote:
>> Version 2 of the spec adds bunch of NAEs, and several of them are
>> optional except the hyervisor features NAE. IMO, a guest should bump the
>> GHCB version only after it has implemented all the required NAEs from
>> the version 2. It may help during the git bisect of the guest kernel --
>> mainly when the hypervisor supports the higher version.
> Aha, so AFAICT, the version bump should happen in patch 3 which adds
> that HV features NAE - not in a separate one after that. The logic
> being, with the patch which adds the functionality needed, you mark the
> guest as supporting v2.

Sure, I will squash the patch 3 and 4 and will do the same for the
hypervisor series. thanks

-Brijesh

