Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9BE67169A
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 09:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjARIw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 03:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjARIw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 03:52:29 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9488E5DC0C;
        Wed, 18 Jan 2023 00:05:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ll/0SSfoHKPnbiM1LtVgYwjnEZj4r0X3HQAZFmT5RQ3wJKwm9o45mchcsiioeGY7yqrD0EYFYB3EcrmxwHEmxoNqppUPhmn7OmwaSmvkWHcLIX6Tf9166nxVqiXT/5IStlOThzS9YtS0qasXg1xkVUKbFn0AyGcXlxBEn21Bze6ztbKEG/V0pRlKWy4+QMZwW5CMJRvnkQGdAEGOMsMH6Amo8/o93JnE+IsOcqsxzFsq/8Si4bS+kckKUaSvCGI13bmNR/99Ucyj6tRjElo84umnO7/ZbsGWK01XCMgsaspvIZTzEvTPKGNauX8txeokOs9SMxL2BmXM8boXM6NDqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7AFGP3jHdED9IVdAq4ydlRzrDzeoEY8MQC3durBBcA=;
 b=TTMo0a2f1iffHRODUpqt+j4URJ6vIW6f2ThIl05snSjvDxENdGdGjSkhPbXKp6J9kzumv1GiBlsttnmDm1qWmpN6/+hUJEMkfX1HvU6Yf824lwbjeS5uDNkOTpAIeIZ5fyH6AIXxksdczreKH9g7GeAMNSEPX29b4jzxNS/aSEDCie/5ekWjxhNolsHCdkytNZgL+6+rek7lksLbOxdN7Ggo2N09Yyd7lMdLc+QRBcg6SGrI58E37+z9d2NcShBVYNO0kjDvzVP0LDgMDTnwtqEmnVl95GzWeZ8A+AhmUqYDvttxX4zR7zENgxHR0N8p7RV2GK3gIX5LgoxnYYbsNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7AFGP3jHdED9IVdAq4ydlRzrDzeoEY8MQC3durBBcA=;
 b=UJ5P3EhTH37OsSTrEwZ+iSbnLzaP648hRUjg/pY4sMl39lYy1S3vFkTWchF2hOd4JpgJjlv6b+7LoMcmKKQ5bPrdSpTqMAjQXdMFvVzLLr9WqZEA1GDlmf9CBPtqsBiTddb4SYn083RnXVSq6hovjwuXzFNrQVTFZr+2+sahTV4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 18 Jan
 2023 08:05:01 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Wed, 18 Jan 2023
 08:05:01 +0000
Message-ID: <a1856c7c-6106-3cf6-77a3-87d8cab9eecf@amd.com>
Date:   Wed, 18 Jan 2023 13:34:38 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 11/64] KVM: SEV: Support private pages in
 LAUNCH_UPDATE_DATA
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
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
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-12-michael.roth@amd.com> <Y8cvsS27o1BaUNPz@kernel.org>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y8cvsS27o1BaUNPz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0176.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BL1PR12MB5753:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a7f2a41-5a2d-4c2d-60d9-08daf92ab29c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8RPihugXdpw/dreAvkuECX116CzTxzP01A4IZ/OvcunkaM8II3KFgOC7ArtavKZXaceRLT3+/Ws6Qt1/G4EJ2dM9xUlM1wNfDT59Q6w/OFw2ftw61ACLhQjUVvOW6dkvQVRnwOXLA1osPgXlAXnhndcEPp5D4+6iYaRgRF9DTUcKOeX0D489C3uUs/kAojGq8y06ck5NDLuZxjQuBjChj/lf36M9mHJCOYAPpg7ireTGwre1KaHcXifXHgJ434fBzs5jyqofXXiQHaUKYHFAXITIXUUGyHorO0gG4ls27g2rFwtOrMwnxfgwgQrtDXaWlP1DI3JbtNv1Da10FlL62SE1Qh+oVuXTWOHi3S4Wi3pvXUonEJO9VwoBd1tYz9DZhNBET1gYQ7PhtC3VFJIK0R3gtbJRkbC7n3Zp+xfwnxyz74TzMqhcfCnbQdfET4F/aeXjcNd3YwQNOBnHXVnxFVyxy3GVHB/LOrEltN/Hkgu6ntLZjGswAimNPugTuhqHz2+v0DjoDOR0msGpvkoo8ZDr9Hi4tmAYAVuHFtaxVJJxLF7iqLIJF6EdEINqD9DFfv9etJHirP2sIL13/RTJ47N7O8fyQpDMWhSKT/PCazGgYHDQaHIuRFduJpBvYTtwkSqM3oDGuh2dCiCMg8XwHO/5SaqSVYvU9yZOar5WsSXHN8Xbhvbvob/qkr+vqrilTgitrc58UHyu4Dvp6oQAj6zTPxwOEvsok7twqSSDm36NI2ZME4vqQ2W5P5uhrwc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199015)(31686004)(36756003)(8936002)(83380400001)(66476007)(8676002)(66556008)(66946007)(7406005)(7416002)(31696002)(4744005)(5660300002)(2906002)(4326008)(38100700002)(6666004)(966005)(316002)(110136005)(6636002)(6486002)(41300700001)(2616005)(53546011)(26005)(6512007)(6506007)(186003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFZkYXN0alZYWk9vbUd5Mk9MaWpMNDFhNHBqekNwUmx4cm1mVHVXV1VZZ0tK?=
 =?utf-8?B?Y0dMV0pxd3RtY2VnNk55bVdCTHZLVGF5ZnYvOU03eFhhK093ZStZRFpTZDVp?=
 =?utf-8?B?cEhTU1VNM0xLT0NYK3Q2K3B4Z0xyTXZ0cE42R3BCSVdwVTRnMkVEc3pPWEpC?=
 =?utf-8?B?UnpwM21wRTlrQzJHS1lYNEs0bmtzMjROSWk5QmNiME1WSFkyTzQxL2szb3V0?=
 =?utf-8?B?N3BQdW1ra0owZkpxU213MDBpc0pLK1J0TEJ2ZXFJdEJrV3pQakV4SXN1Yk9E?=
 =?utf-8?B?dGxoUjVWQ3NkTkU5TmlYMDNlSHBKQ084eFlwY1VWelk1aE13NW1wbUlla1pl?=
 =?utf-8?B?YUVJZ0RPeExJSGJacnZiaUx4L0ZrWUZjbmtnUWtqRlg3RDNDeUw3NmlueFIx?=
 =?utf-8?B?TzdueXF3Mjd2UkRnMzJGZ3ZJc1NwRWtjWmdCWmNMZmdLUTk2ZDduTWExYkRu?=
 =?utf-8?B?SG1JcmYySEYxYU9FY053Yi9aRG9hTzB4MWNKZkJpczBjb2hTOHNvMGt6dmE0?=
 =?utf-8?B?TlVqdDZDMFRPemV4MkNSSjc1MHZzaUhrcVFRckRXYTdENGVWYmh0WkFuc05G?=
 =?utf-8?B?MFY5WVVOakcyUU1xNXpiRlVRMHVrSzRuMlVqQlFhbGo4SDhPcGdDcHcwd0x0?=
 =?utf-8?B?QUVPWHRaK0tIODZiMjU2aTBWRDZ2b1RhTVQ0YlVZc1A0NjhtSkVuR0IyOEdD?=
 =?utf-8?B?bFZneTN5NDdPb1ZtbzQxbHh6TXlOREwvYmF6a01uNlJGN3czMUR0aE1XWGs1?=
 =?utf-8?B?eklwUURJWVJLY0hCaW9QQ28zRDJ3S1JxUk0wbE1oN3BxNGFSYkxHSUhsZUts?=
 =?utf-8?B?VXZPWm1ORVlidjVnbC96RUVleUpPQTQwTW9Oc0x1ay8wRDNlOGd2M0lTY3Fm?=
 =?utf-8?B?ZDFqSjRCY3Q1bjdVMXpzbnI1T3QzZWsvWGhiNHc1Zkk0V0tBZkp2MWQ0ZDJF?=
 =?utf-8?B?cS9xNnA4N3ZIREoxbW5FenVyU2R5bUNxK3JtcVYwQXF4b3dlK09lR3ozNlVO?=
 =?utf-8?B?ekVPVXZBc3I1U2N6b1lKWSs3SG5GRWtETlZQTVl4cDZicThCS3p3cGRYVE9L?=
 =?utf-8?B?WlBESFFwejh3d0F0cWFyV3lkZnhoL0RVNHFwTjU4bE9qeWQzYzVjOWZST0lv?=
 =?utf-8?B?YkJjcmp1WWRzdFVSZnhxWnN3UjNoSEJ0QjNHL0RrcHpDaDdCKzBoZ3M2S3JY?=
 =?utf-8?B?UFQ5MERvRVlUVDhpekYyamtXc0ZBWlVMb1RIcmxVbmhWR3pQaUhVcGRPRUVV?=
 =?utf-8?B?WjVUdGlkcGdxanhxMTZ5Tm5iZ2hwUk00MytUOEl4TElpQ0JGK0F2ZFBlUmpr?=
 =?utf-8?B?cXV6Z0kxd2dSa09TWVMwNWlvWFduMWdKNXdyZXhOa2xaeWJqRnByTGN5Qy9G?=
 =?utf-8?B?dGovSSsvOWc3RmxCWGgzMERWZkxHOHQrTVh3RVB1VEtUeExtcEJYT1ZGcHNM?=
 =?utf-8?B?UDZ5SkdGZm9DWFN2YjdhR20vdk4vTC90dUV6MUlvaiswM1kwUVYvcG51UHlG?=
 =?utf-8?B?T2p1ZFZFMHFyNm1COWFKZHQrMXBqU3dKOXdqcGVBejBjcm5XMzZiOHVISzNR?=
 =?utf-8?B?UUpEaGtSUHAyWWJXb2luOHdrMWxHdzM0aUx3emdDTjlNaksyQlFrdWk1bzBy?=
 =?utf-8?B?VjZBaElTWTRJWU9lalZ3SVhhWGcyOXJyZ2J4SUd4NFlQQ1JuWmM3YXJCR0V6?=
 =?utf-8?B?Z2tDa0ZQbmhPVjZ5WFVNN2xYYUFCUFhsb3hLZmhuUXdrRkxmKzl1SFgrMFJj?=
 =?utf-8?B?Y3Bsc2t1R0VZODJXcGt0bzRYUlJ5NDh3dFUvTFY0Q2lkMVVtM1NPaVBVV2hy?=
 =?utf-8?B?NjBSd0lSL3k4WTVrMk0rNGUrQUlXZm01dzQ2eVpZVDRqM0U4OEw2OGRXKzl6?=
 =?utf-8?B?d1U5MHB1Sm9pTTRHR1p4VFlWV1N4Ris0OUxGNy80cGU0alZxeloyQlYwMWFN?=
 =?utf-8?B?dmtRZmo2SjhLRzNsSDNHanU4K2FqckNjZjdlQ0VBTHh5QVYxbiszSHdLR2pj?=
 =?utf-8?B?TUFqMjRCNUFLL3lHRWtUNnpaSkExdXJJNXljZDg0OFJFMzZER3IyOHJFRStW?=
 =?utf-8?B?NVFRNDFzTUVUNEZSTEgwWVg3eS8zaTFRNGsvQk9zbGFQWUhqWWE4alFZY0NV?=
 =?utf-8?Q?NZ6WAj4NVAOaCZx2xwYhHYN8M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7f2a41-5a2d-4c2d-60d9-08daf92ab29c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 08:05:01.0800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tEyfH9gyAA0407A8kFxOqjswGiJdAdApw70EprGYyAERsjKYOHZpHpyJt5jYdDS248gPVMjAPqcjjCLyy580Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5753
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/23 05:00, Jarkko Sakkinen wrote:
> On Wed, Dec 14, 2022 at 01:40:03PM -0600, Michael Roth wrote:
>> From: Nikunj A Dadhania <nikunj@amd.com>

>> @@ -609,9 +659,8 @@ static int sev_launch_update_priv_gfn_handler(struct kvm *kvm,
>>  			goto e_ret;
>>  		kvm_release_pfn_clean(pfn);
>>  	}
>> -	kvm_vm_set_region_attr(kvm, range->start, range->end,
>> -		true /* priv_attr */);
>>  
>> +	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRIBUTE_PRIVATE);

As the memory attribute is no more a boolean in the UPM series, I had this change.

>>  e_ret:
>>  	return ret;
>>  }
>> -- 
>> 2.25.1
>>
> 
> kvm_vm_set_region_attr() should be fixed already in:
>> https://lore.kernel.org/all/20221214194056.161492-11-michael.roth@amd.com/

Will discuss with Mike and move this hunk to above patch.

Regards
Nikunj

