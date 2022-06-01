Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB28539AFB
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 03:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349054AbiFAB5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 21:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349049AbiFAB5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 21:57:05 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05D04130B;
        Tue, 31 May 2022 18:57:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQqLyMNtlz2c6MQ7n6XZQJ/C1gL/vUD5SHyCqec1aBX2yG5GLAW4fHFvjtE+/7muMBydKKtCOC6Xuevs26Q1PqDrGG1cATPSomh8DN3Gt9DeOl3jFB3Fz2Lmm/Jujnl1jE04umFWKqZIvia24VFu2GnBxa+qLxlH+jpbPsuS5UqQs3LfK+ovtEXkPxZT6eKFW7RnJkcpk7PnDifNLvfMK2LDjbfPyA/Rb/EuGu4woNSO7eQ6yndeWU9dddHTi0phK1RoED6jYsslikf+SIR5v+WLFUtFqQPEmGX809bPoEweCB05xzB3bcbh6HDZ6b6oniFVwOKO6t06HhSreJbOtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFJHOIyDjLgWu4yHBfKHVwiI3i9+s6TNv+/at/skyRE=;
 b=fje70QN4W4wGPQdMM5FtPmInDBBakjAycWTVyl5TiFZx8mYCvJr4JDCxiT585DCCRmEl80XvXJDYx/0Fdr62m6gPS0A16AghbznnKsuIFXp0D9EwTpIdu5dgi/ejd4ozk6kmu2ogsD5SjEUA9EG6x/NtivPHdFD1ZKmljbFmPlk43/go3XJxxjnNtvsUoIt/UoqpgKOYIILALlDwOQJ934zIPXarBuSTM+v+W6qehFU2OlvTn7tv1yKXyJ0pvWHMQZCbUB2yZPZBv9kaRKLNE8Lgxfx9sLRI7U11HJynCB/+xii1sD/aQe1yBUcPX8ElrlMOboLMitvjKy4wbltV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFJHOIyDjLgWu4yHBfKHVwiI3i9+s6TNv+/at/skyRE=;
 b=rdOzxooPlwTCzoRv88oippKolI7iTw5k/aeHiq1ONQNL3jbHhtc/xd8k+/GT7mGfBryFooAusfwVnqPSGAU47h1g0xj6zH+gHwe5t6xO/PknjysyAJVZztITQTeBTfke4H7g75vrSIvyFWWKZeTCPy6d8VY+RWHTvpV9AT/f6G4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CH2PR12MB5529.namprd12.prod.outlook.com (2603:10b6:610:36::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Wed, 1 Jun
 2022 01:56:59 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3d0f:71a7:3a0f:ac2e]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3d0f:71a7:3a0f:ac2e%5]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 01:56:59 +0000
Message-ID: <3193bafc-9dbf-67ca-beca-8066765b2339@amd.com>
Date:   Tue, 31 May 2022 20:57:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] KVM: Only display message about bios support disabled
 once
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220526213038.2027-1-mario.limonciello@amd.com>
 <YpD3a3wMbr9xIsub@google.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <YpD3a3wMbr9xIsub@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0002.namprd07.prod.outlook.com
 (2603:10b6:803:28::12) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c901ada3-382c-4008-c9ef-08da437203b8
X-MS-TrafficTypeDiagnostic: CH2PR12MB5529:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB55295BF9CF327A1A1BB51BC7E2DF9@CH2PR12MB5529.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uuHsozXh6LN+1KXzOxYjEbfCB2N2GNXf4V1wX+mgW0kyAWlEitYsjkXj4RvJZ6j2FsWIrxP4lVpS3FrzU5kMOdxJf1kQdfTTQPobUmJGezfyWeGol14M1OI5lFcbONe/rQQwkbKc1fO4wXWvXVHpLx9PIWLhugoGs3cAooSpjOyDqlPzS6DJTJncoPrSPHvj1/Bas5l6Cz0DIrFIHbcx8o9xu+WDEDdgu16HYDXyK2olS3diEGlTOH6+LZhgVVNd59cBMu7qa2t+GPDpOFuBntHMZ73kblb2haxmvU1HoFNCH/eDUn92gyJIeuGjs2OURiIgtJuFm2UFIHbeoSodApGT9gxBLy3eNYn5qWMU8Xm8kVcwHDHfkmX+37DVjOF+r/iDRpBiKejDQqJicL/hjBbRJyLwSOB2ELr5FhbsVCSmpkdgTbdhPMo2vO/rzlhiSNTeeT/9MB2szMrHKz/aa6keRvweAFhaJEsJrANRp3SAq3Sry48vhWbUNSADOawQ0yIxnbQ97qWEn5nig1egW8lMUDO/plxE89ivG/uk2dOzY4W4tVTeRgh0MzDEh7cS0rmMZBiworNF9ZdJUQHiNhS1KpFxjuPITk6o+D86QsHJrveA2M6gBKOpNVuSMEGWUEqwigbX2pq+Nsa3QNDAF6QdtZD3K1Xp+PDzHDEFCRL1bjgbaolt4e6nniLLBRTWeWd5VODsT+c3xHOUIu4Snwh8PXJIT8iA4rrSk49FjzyGKwJ4MIi/cdUgh9suo5HcC1zMmjoDy5ztJnd4ulDOQYDdgcr0StStLOGeIp2OzKz2oslThPTVzNqCKztd1irt+U8RjvQ8R/1APCKQnxYa3oacXEn+AHnKjNZHMOFyOwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(86362001)(45080400002)(508600001)(966005)(6506007)(8676002)(4326008)(6512007)(53546011)(44832011)(7416002)(6916009)(15650500001)(5660300002)(6486002)(316002)(36756003)(83380400001)(54906003)(31686004)(66476007)(2906002)(186003)(2616005)(38100700002)(8936002)(66946007)(31696002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2M2dERHcWJjOHZPZHZLVW1TR09qYnBOeWtaOTMyVXFrMnpuanE4RjJqZmNa?=
 =?utf-8?B?cVplKzQxMlF0bEVVQUJ2enFwN1hNamIyN080Q2xjajBoZ1FGV1ladVdxeDZZ?=
 =?utf-8?B?cW1tdEl4K2p6S2g3U09OR3dwd1hpYk9jUS9Qd0g0cWJ5Z3VRdWRVUXNpQUNo?=
 =?utf-8?B?OHJwUExFQjUvclBlbW8wMnJDNTZCMHM1c3JRTjZxd0JsUWI3b0tSU2pMQ2M1?=
 =?utf-8?B?V3NuMUxDYlNaQnpuU3lkNGlVMk9TTFZuY3pWMkUxaWNpZUdVUWFsUjJoS3hN?=
 =?utf-8?B?OEY3MXNFa1B0UFg3aVFTemY3NjNyWk1wSStDMS9ZRmcrZS9uRUdxVXlnd3E1?=
 =?utf-8?B?WEtKNENNc250TW5ucWtWSm1CRGs1VElyMkdMdFh2T0FreUlrNzJrZGNuOGl6?=
 =?utf-8?B?UktqckUrMDNlVjVlN3JhOUxmSXZtTnd1YmE2YmQ3dTlqeCt3Skt3Z3BSRXdI?=
 =?utf-8?B?QWxKSWw0RVdqSzByL0dqanNtNTlaSFdXcDE5eVJmb2ZubE1tM1Rza2E0RUsz?=
 =?utf-8?B?MnVRRzYwRTNrQk1saXpoNGM3WGJDS1kvdGlSWlVrc2dzL0JFOTlUeGNicUlv?=
 =?utf-8?B?eE1zcHYvam5uMGNoR2tvUWZSdlBldTZHVkxQQ2s5NWoxcytjU3FEMEdPZytM?=
 =?utf-8?B?eCtNcWRmL0s3aTdjS1o0MEhXZ3lURE16QmYyWVNZb3o2MzhOemtJZVh3V2JQ?=
 =?utf-8?B?NkRteGsyMlZ1b1V1dnMrenE0QVVTTjFQMjRTK09RRTJKbWFabGQ3dmxaZmVw?=
 =?utf-8?B?VjFnS3UzYk9LaTFDT041Z2gzSjFWelJQbXg1M21WODVwZjRkTjEvbXJjNXVV?=
 =?utf-8?B?VjB0MUliUTYwc21YaUFldzFCYi9DR1c4MlJIaldzS1hKb21Ud0M2SG9vV2FW?=
 =?utf-8?B?Y0ppc3FIam5kNi82dytIWVdJaDIxYU9CSlo2aU10NEdYeUJ2K0FJMzBTRGNx?=
 =?utf-8?B?dnl4N0lLRlp3eFJlb0NYblBjNURRN1FIa0EzZmZlTjBLQVhGR2U0L21GeVVV?=
 =?utf-8?B?QnYzMS9kUlFpR3R1eHFWWnFhRHU2dXdoeTB6WG4xUjY2cXo2bDVkNFR1dFdy?=
 =?utf-8?B?eDlrNXB5RVpBM1N2ZGtobTZ3UGhOK3BBQ1NzaldTbFlibnB0Wm4wUWh2WDB6?=
 =?utf-8?B?RW9rUGNsVEhqLytGTTJVTU5MVjVoN2xhekhiWFlRL2dGUUNRZTdRcUpheGZP?=
 =?utf-8?B?ZklwMzFVN0grWkRaZmZEcHI1NzJQV3JvN2Q0UjlxOUdUdDdHcVdLZ1A1a0tI?=
 =?utf-8?B?M3hweDdIMFMyUTdtZ3lCZHp4N2JSZFlOWjErZWN1UEZDVmdPNDMxOG1NSWU0?=
 =?utf-8?B?QWJtZDBaVmg4WnF2S05vZWk5WHd4aG5OdW16VFhackVMMDhXaWJMWEViU1Zn?=
 =?utf-8?B?ckh4UmlZQlVaQU0zM3A5YTNQQ1o1djFCS00xcFhkanpPZFRMNWlNUzJwWkdR?=
 =?utf-8?B?SVFXWGxGUHlPWHMyYXNBT3I5VjhxQnJEdjJ0c1FtdHlHNnc1SlFyZDllb3JZ?=
 =?utf-8?B?YysyQW5Hd2F3L2JCQmh4OFNJOEFhdUN6SENZdGVFQUFVaXova0VDTGFBOHdv?=
 =?utf-8?B?Mis5TkRFUVdTenlqcVc4amU5b1VMK2FKek5kWFVLbkNSa1dId2hpK3MrZU1q?=
 =?utf-8?B?OXhwN1BMYy8vck41aTdiVDhZK25sdkt3d0gweUt5ZEkrdkt6ZHJNdVRyK0lC?=
 =?utf-8?B?MjRHbzdwT1M1RmY1VmZsaTZVUW45RktIYloydHJVRzF5d1UwaEtTdHFrRzZx?=
 =?utf-8?B?U1g2UnhTK3V0ZHI3bnpRRVJsYkIvSUhxYW1NZ0xVMktRQVFFN1NJUXVTNlFW?=
 =?utf-8?B?bDVYWHpobVdianhZdXhvNDdaSlY5Nm14enVWemZQNHNXNk5XQjlXRXJTUVox?=
 =?utf-8?B?TUZsTVh0blNxODdIOWVZOGFrYnc4SkN2L29kZ0dMU3NWbVl0YVlZWHJlRkJr?=
 =?utf-8?B?NjhDMzhHdGRnSXhKdjAxZE9KVGoya2wvVmRXK1h2bUlHdnlhcHBjZEJuZ3JB?=
 =?utf-8?B?V0tjUUZCOHQ0R3BFQlJONTh2NXJuVTJwT2FuZWRtM3ZNdmpzcFdXUUdSN1NL?=
 =?utf-8?B?UGhPT2ZPK2RIVkQyNnVVeEVXenQ0NXZURmlzZmdMUWJDSG1scDA1RDdBckh6?=
 =?utf-8?B?dDB4QnN0MWY3Rk5MOU5CRXYzRERxQ2I2YU5jQ3dkbmJncHAxak55MDJ2VWhG?=
 =?utf-8?B?T1BHaDVDWWF6d0RhekdtZjMxcWpVUnBMZ3lKTE5hVHQwRlBleUZrUnBZcnhY?=
 =?utf-8?B?czNyRlJqWFlmak5kRjdGUG45eGdBQUVIamp3cDRZN3JBZzg1cXQveDF4eVN6?=
 =?utf-8?B?QnNxK3R2S3JneUJwMHQxVzRQUHFBbFpSdzIzeXZIOVdvTW81MDNERmdhaERT?=
 =?utf-8?Q?sbY6yjsP9flcu/9XiD5D8sAgA1P3gMcsWUrViinEwBweh?=
X-MS-Exchange-AntiSpam-MessageData-1: kE62CtgGNE10OQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c901ada3-382c-4008-c9ef-08da437203b8
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 01:56:59.7245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S6pXJRR2nKeOiq95Moza5/xhvRu18kKHDOOAowkmwoXCotQpLsCqEIqdXe7NsoLyW/bVoA32vUB5K6aO4+JjIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5529
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/27/22 11:08, Sean Christopherson wrote:
> On Thu, May 26, 2022, Mario Limonciello wrote:
>> On an OEM laptop I see the following message 10 times in my dmesg:
>> "kvm: support for 'kvm_amd' disabled by bios"
>>
>> This might be useful the first time, but there really isn't a point
>> to showing the error 9 more times.  The BIOS still has it disabled.
>> Change the message to only display one time.
> 
> NAK, this has been discussed multiple times in the past[1][2], there are edge cases
> where logging multiple messages is desirable.  Even using a ratelimited printk is
> essentially a workaround for a systemd bug[3], which I'm guessing is the cuplrit here.
> 
> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20190826182320.9089-1-tony.luck%40intel.com&amp;data=05%7C01%7Cmario.limonciello%40amd.com%7C2e1eed66ff8a412cec0508da3ffb1c1b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637892645000687319%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=X3Hs2QwXLsgAEEQkP7WMniywwoCn065sVh8DFagYzLE%3D&amp;reserved=0
> [2] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20200214143035.607115-1-e.velu%40criteo.com&amp;data=05%7C01%7Cmario.limonciello%40amd.com%7C2e1eed66ff8a412cec0508da3ffb1c1b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637892645000687319%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=EMe2b9Mu7Pc9Z%2FcBmTPZaChUaDlQD%2FKGwK%2BYM%2Fd1VUY%3D&amp;reserved=0
> [3] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fsystemd%2Fsystemd%2Fissues%2F14906&amp;data=05%7C01%7Cmario.limonciello%40amd.com%7C2e1eed66ff8a412cec0508da3ffb1c1b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637892645000687319%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=8fMPC1Opl85BmqqoPJ4ASI6Y58h%2BuTM5oFDS76bqPv0%3D&amp;reserved=0

Sean,

Appreciate the pointer at those earlier threads and the userspace issue.

Yes; it's certainly caused by systemd.  I can reproduce another 10 
entries just like the last link via `udevadm trigger --type=devices 
--action=add`.  I'm on a more modern version of systemd (249.11) so even 
though it was claimed to be fixed previously it resurfaced.  I'll leave 
a comment with systemd accordingly.

Thanks,
