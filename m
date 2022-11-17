Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FB462E634
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbiKQU5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiKQU5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:57:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D84697D1;
        Thu, 17 Nov 2022 12:57:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My//wYVy/jIr43q0mLWifTI1fhwjt+7yGUZ7a+IILynvRqLyuha8NYeUjZu47duA41+XqFlXffUZ5WgWWWLLjsOWaTAwJthUTXESWb9UMxX1vIshH9NsPJuTOvg2lWE9ESA0AhOrquj9udDSt+U9QgSZD8LUfBVwMl5wb6tLo/yRlAoibDrWfnBMWgTinkJHoUFJlBnsxc8APzfHIYyWNtZz+B4uXPTU67CekMFqAYSGQymDvf5x2mNTfr4gShomSGwXVTpmu7Yi2x8eContCpY0NlEKU3Q+yiiids4mkEsttLLLQFXz6FxTYk21YaCJ/LYG1njAVcdAXGnhUvwfpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R64mb7+v84slcUTzcguKsSdB+x2D24Cv5zLrXLkAsng=;
 b=LjJCw8qenjM1HuIFok165+PaZZvLOXi9O2mLoubw4rxNHoCO6iPBH7GRoKQDD7iCzz00xNVTlmpjN+/3tKdGfkHa34MtTD65qd2j+UWGM+3+lsmj8bTb73bNVH3rDE1qTXtKknbVg1Vvo0x+QIi4ns2nAxbjM8KSPrvCICPCy+D6YKHOUSlp0e/1PbNDmpuYey5gOazv0ancppB8GbDDpANI/9VYgXSY80cqKtsRmv0hI6Wg8xzpyxQG8baddaV50ObMwZ9nkxcUmD0VCkIur2I5iudxI8go/x+Mj3qz4XEzRpTcSCx5bXgmUZUFrDLNBzwoRvAqUbEDva72X9MQhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R64mb7+v84slcUTzcguKsSdB+x2D24Cv5zLrXLkAsng=;
 b=dxc5VHoHDFS+tDaNwvzkC/KmOYXSfvVbTPetSuKogoBamGWhhXKRNxY5LJ7RaL0zr4ha3mmIlM7ZgQjbo+LwmjM7RsgSbaneothd0dSPlNKpMIOctiIhLSsMr4p2D/rrMNpQ2nEkeIavUrnvv1zO+o2ObQoFSN6Bh+9IrmVixO0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB4880.namprd12.prod.outlook.com (2603:10b6:5:1bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 20:56:54 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 20:56:53 +0000
Message-ID: <b712bc81-4446-9be4-fd59-d08981d13475@amd.com>
Date:   Thu, 17 Nov 2022 14:56:47 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
In-Reply-To: <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:610:74::11) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM6PR12MB4880:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e44c951-a657-4311-991f-08dac8de41a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RchZl3m8AvMEV9LUZUfLTqZy8HItWVDVeNrdmXKNSdW9pSdVwMqqQ4PZNhYl25iopdlLPDjwHMoExfEg3XufyLYEQmixOd1svHGG2HmucbNGee13dEuiglIS77OX2gQN3dpxeahbWyZkNIS/afqC4WiHZLyVyUPkiyeD+7s5azqE4UgGUGJCTXM3Czz0LjQIVa+eDPxNKedMdbbr5xKm+wEWc8a0rzk0Y0PFpMTPTRw058fp7HZooo/+yUYzK5XXFzYOfUTQ8QbveOp6bphOi/z8eUWkoKS6TCKiUI8jDt+d48tynpO/aFvSMwRT4FJ1Ucn7qUlWjYAdnAL3EI4Z7n5Zw5PPJcidB6dLWOWP+pz/3O9K8LGBp//+o38OpExY/BR8OhWHqF0Bba2nyA9paiGi4+3p45vEYWCF4rmI4joqEdTtp+x/kUQrki6czw0zB+UjoDJv7uwTFe9f1QQWcFOvN7gFijlNyK8qbjCcSV/fhptL/iIk2NoXpUj7EkgV3q7i7NafwaXQYmSFxuE1p0fVcExiCB/eNvOPJ0ihZjkJ/PbbvNRhXMeXFdo9osqlwXY/b62/pUkFJiNuNcU36AgpGWNCCA8a+CObN+OVDOmYCladKU+ii/GL6ReP8Kl3gI3YoDskzfkGQ7pePGe0PDPqvOGHd0TfwdwkL/kj6Xedyx8MMrSAoVNaIVvQmnPrgLhIb2AdRnmF6RIU00Br1athIMhfXOcgobyoWGQHcTQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199015)(7406005)(7416002)(8936002)(31686004)(41300700001)(2906002)(5660300002)(316002)(66556008)(478600001)(66476007)(6486002)(36756003)(66946007)(6666004)(8676002)(4326008)(6512007)(26005)(31696002)(86362001)(6506007)(83380400001)(6916009)(2616005)(38100700002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UERodC9WYkRtMXFIbUVGaFgwdGpQNm0zdDJjNzdreVh1UjU0cElncjF4a2Fa?=
 =?utf-8?B?TFR0UmM5RWxxRyt3MlBwdHVLSnJ0YWJTb0Y2VHl4UU1GVlRtMi9VUGhNZEli?=
 =?utf-8?B?dnZhMUh1TVhGQXZGU1Z5RnAvYlkrNjVmcTBseVByTXpjWnhSdEoxVHNHMW14?=
 =?utf-8?B?RklCbEdNZ3p2ek1SVzhoeVRIWmk1bWpXMU92QmZVQk05OWM3MFRZOEtnR0Fv?=
 =?utf-8?B?R3JldEo2UEVmU002TmhGZkhsS3EyRFh5bWhPc3ZLTUZ5cEd4d2dHUXNxRVBO?=
 =?utf-8?B?VnQ3QXBuc3BibzVUSXNuNDcxRkJvU0tqSkt5dnM2QmJwRk1VS05BKzczMUtF?=
 =?utf-8?B?aHBEQWxoRDFMUVFzRm04Qmh3dzZWK2l2SExrZ3NkWEREaGVyRWN3eUFSM2Z5?=
 =?utf-8?B?WmEyWTFEc3dmMGFXU3Q5d2RBNmxmZkQ5d3B0MitIVWdxcXZsVVMwN3JSeEpt?=
 =?utf-8?B?WHZIQ1pPOVBjcFFRSDZJTEJjMWVvTDJQS1VtMDN0cnRSTjJ4KzdIVHpLeWR3?=
 =?utf-8?B?c3QrVytudklmeG0vbUcvMVZGRFVxU1RLRUFrZFBKYWU5TVZMaE91dGdiT2dS?=
 =?utf-8?B?TkNvRW5ObTZSTkhZRy9DK0RRQjNPNVVVTCtjclBNeklmWmZFY0pXZ05mQUJw?=
 =?utf-8?B?MTdaWXBiRWlaK2NObmdMRHJPVlRKRVpvUUh0bVlPakt3KzljRHhBL3d2cHhp?=
 =?utf-8?B?Vjc4NnpsYmcrTFhFbGFEbTFMYnpLK2lnaU83aDNxOFBkY00vbVYvYmMwSGd5?=
 =?utf-8?B?bG5aZzJWUGpYdHJjUmg1VnBpd3d0ZWZUbDR0MGN5MldRSEc4djBhMDRVWU12?=
 =?utf-8?B?bFh2dWJiaDkzaE9UTFFXT3F0T0E0WWRXYlhzV0xMVmN3eUdzU2VBVkVsWWc4?=
 =?utf-8?B?cE9peDhiV0U3dk1GRW9KOXNCbkFmbnJ5YU9tRVFkSms0TkdaZDdRK01PMThp?=
 =?utf-8?B?RWJsLzVvYk5MNzh2Y0lQZ0pLcDVIMTZBOG9HMHd0aW54ZHIzSlYrV1cvYkxT?=
 =?utf-8?B?OTNZcFRzRTZDMnRYcmlTMVlDbFJOaVhaSXFBSTVDT2RYWTF6RVRCZjFmOEFk?=
 =?utf-8?B?MDVwQjEvQ0tNMnlkM25BWHBpU2hzVy9Rdi9uVWNtWlVBS1RkcnY4SW5ZQkdZ?=
 =?utf-8?B?SEM5STR2ckx0MEs0bVhsYnRtcG9nSFFHbnVXU3U4djdZZHNBd01BcVNZdjVV?=
 =?utf-8?B?NEQ5bGtVYmZnRXFIeFFXYldqelBqS2xkVTRydGg0eko0STJuL0Ztc3ZSa0xh?=
 =?utf-8?B?NHo3b21neXFXVk9WVUdvOVZBZTVHeUNXQ3lDOVpPS1RWZUczS3M3RXBuODdR?=
 =?utf-8?B?YStsN3hXV2pabFZHT1Q2dU1paWFxY25POW11TDdmS1ZTVlB4SGI5SzZadmNB?=
 =?utf-8?B?T2h0eXNqQzgwT0ZyRnVsV281a2FpWGpmNWJ4UENGbUlRZExNNXJkY0RzZE9t?=
 =?utf-8?B?TDZqZkxUZU82eEh4TmtiWHgyKzdsNVdDcjJmZXNNejlOckRVaER4ajNYTlZV?=
 =?utf-8?B?cGFFWWY5V3FvVExVL1hwTmlZVjV6L1cvbkt3MUJ2RGdMay81TjdHUlFxbjY2?=
 =?utf-8?B?dmZHUjFxRkEwY0dVUDVxWURHRkJjWm1sU3BEVkp1Mi9mdHRJN3lYbmYvTU5R?=
 =?utf-8?B?VFBrOVhIc0JOS1czTDhLTi9zN0taNjlnTDdLREp0aDhtZExwQWN0RDcrbEJp?=
 =?utf-8?B?UGoyOGtlbVhLSlFVYVlwNnJsL0MzVWQweGYzM01rOVo5S2hIbnF6enVpL0gr?=
 =?utf-8?B?SUhmTVozekRvTDFsalJ6RVZsZGhHRUl0NFhuam5rT2ZhalVTNDdwenoydlIr?=
 =?utf-8?B?RW5HbWdRVjVhOXZzQm9GQXBTaFNBdFBqelpSV3NEbmwzN0J1a1FFalJQSEky?=
 =?utf-8?B?TzZqVmpPRjJTaHV3eUY2VC9iOFp3YXN1aFEwclUrZysrZloxcWJibWFjNXQ5?=
 =?utf-8?B?Q05NU2FyUzJRUHdzalAwckhZTVZPVHNMdVRWSkZjWkFtelk4a01mN1F1MGho?=
 =?utf-8?B?M05NZkhSL2xjY2hjWDQ5azgxVzR6b2pxNmgwcWNkTTNWQS9hWmJxWXJ6SVVG?=
 =?utf-8?B?dkVkRm04OHc1cTFrVVBBTUdRNUhBMVhsMFZJTlZENFM5b1NtODBQOFk5bmcr?=
 =?utf-8?Q?RTDBOmWuQuMAOcorr5iIMTcnk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e44c951-a657-4311-991f-08dac8de41a9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 20:56:53.8618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: njVEUVx4h1R5vtidJVu1VWsT38RZKSM8JQ2FaE4zYAtOrQcfLuI+prSszHGwlfrAqHaGRkJCCxe8whbE25N+XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4880
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

>>
>>> +        if (ret)
>>> +            goto cleanup;
>>> +
>>> +        ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>> +        if (ret)
>>> +            goto cleanup;
>>> +
>>> +        pfn++;
>>> +        n++;
>>> +    }
>>> +
>>> +    return 0;
>>> +
>>> +cleanup:
>>> +    /*
>>> +     * If failed to reclaim the page then page is no longer safe to
>>> +     * be released, leak it.
>>> +     */
>>> +    snp_leak_pages(pfn, npages - n);
>>
>> So this looks real weird: we go and reclaim pages, we hit an error
>> during reclaiming a page X somewhere in-between and then we go and mark
>> the *remaining* pages as not to be used?!
>>
>> Why?
>>
>> Why not only that *one* page which failed and then we continue with the
>> rest?!
> 

I had a re-look at this while fixing the memory_failure() handling and 
realized that we can't do a *partial* recovery here if we fail to 
reclaim a single page, i.e., if we hit an error during reclaiming a 
single page we need to mark the remaining pages as not usable.

This is because this page could be a part of larger buffer which would 
have been transitioned to firmware state and need to be restored back in 
*full* to HV/shared state, any access to a partially transitioned buffer 
will still cause failures, basically the callers won't be able to do any 
kind of a recovery/access on a partially restored/reclaimed buffer and 
now potentially fragmented buffer, which anyway means failure due to 
data loss on non reclaimed page(s).

So we need to be able to reclaim all the pages or none.

Also this failure won't be happening regularly/frequently, it is a 
*rare* error case and if there is a reclamation failure on a single 
page, there is a high probability that there will be reclamation 
failures on subsequent pages.

Thanks,
Ashish
