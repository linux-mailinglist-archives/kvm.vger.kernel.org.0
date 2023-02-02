Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03D1687705
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 09:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjBBIJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 03:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjBBIJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 03:09:45 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2073.outbound.protection.outlook.com [40.107.212.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B680B8396B;
        Thu,  2 Feb 2023 00:09:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmL/nRS1ghw/03nO6/zcrC4QcMdGbx+ANk4iC5zRugWlvHKzdi29W46mLxz6XLNUN9wm2b0V/fJ4iq5YwSa9/Kfvz0GdvPo6DWOvGkrfuoQo38ToHrU4f0Pjj0O2ZH+TEsOzpsT+4rtzzX7+JYU7LFnZM7J9fW6KWeUavPimM+kgUYCn0jx/pkleYOz+eiL0zgSSifyYy5Tz5LnlUToZkMIl3RdT+SQb5aTkcIiKbUPCLP2wzEZUMJ9HyrHuCPWqgnodbRhkVad55Nvevh37hhIHlEJenjnXBRzjpPwYPnSkIG9GwtNtB70MEWEd+aQEOJJL70tHyVJ2fdZXDogXeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nufo3f1y7lKyj3xheBAiIRyJ3NFTEgqF+7mgQLh12no=;
 b=BQUFg8vwuVtuhw7Z8pVru7T0Vkq8GPmpWeUR9qOVR7csQ7iw2EmQAVoAEfdttYK0eUBVyeco6xM23Lu8c2iPKeoUhKSXL3unetv3eNGdCAhriMqzmuD3F9Wjyh0Ej5EW7kaHZOvnB7IZuPCiOpjuaSHkljvJUU8hkPGW0QeN8ymvgnvQtb0E5MMTFNYVG4KtTVDPbfYyb3vZyU0Yh64bFPdU7W7Vx6cte8YIZbQmokX9grF3//A9/S2m6KFK0VPKA9QTZ0wyuSTdqj0NXqrtkh01r196dVEdci9KGPFl28wuYRlZP5ajfpXFNS/4mhJbDfDlAJIp+bYbzq7iW6zpLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nufo3f1y7lKyj3xheBAiIRyJ3NFTEgqF+7mgQLh12no=;
 b=l8QNzGvGGDiOA7/h53Norbo6GRPV1ZgdkvF3/WHohlWDuVKCXHtgf8zi1d5ht5ipkBsYpdb7X1tfgqcvxNqfVQSPm0IUIjNYKe0OlyaHTBSnrA2ukaNOEzAjCozaIN02aPjqALoXfDzrq5Jd+DStzoZiSy4SoREVE1605ysxg9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 08:09:37 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%7]) with mapi id 15.20.6064.024; Thu, 2 Feb 2023
 08:09:36 +0000
Message-ID: <d49fc5ba-b581-0051-bd82-1e7a4daae91b@amd.com>
Date:   Thu, 2 Feb 2023 13:39:14 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 11/64] KVM: SEV: Support private pages in
 LAUNCH_UPDATE_DATA
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-12-michael.roth@amd.com> <Y9qt50zW+eJcz7cm@zn.tnic>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y9qt50zW+eJcz7cm@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0065.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::10) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BY5PR12MB4084:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ff8658-b4d5-4978-2c92-08db04f4d315
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T52lqiKT478FMlUq7B57ZhRpvMkLfKlUzlqjKxjkK0JmpM6EWryo4ROidhiLIdNROcAqnz2B4+izTgWKgH+ySzaTG472V7e0bwDLx+Xb+8Ttku4H0krk01FBV6k0fxcDJt6TNHYNUxwktIfMdCBXi0e5aY/Wasv8csbuaAVJ0TWUJjg7vLvfTZ9AphLN01yHxGAl965gAHWqSrmx49HXZUUXnlsE19DDO6/JvcsTG/BmljbKQfmUjRvBSWb3d3jlvgw5zNuPqJQX5YAB9YFqPU6xkv1eAX0eg/XlQc3oiil25EDTZsSBtDnA/+5nLcOdPjcdgxI7jCuLEfbZ44BlZCqIrEbeMnGF3bHdF7xGtUPhksZ7TyQqDSzMTStx31vX8VUmwegJr3QMrZis5UrmnKdJM8znOXcvJ6X8z9miQOOETRZ1+/qEW3lupcNj6wCoThuU4/l8NcsSv+HP9SfOo079Vkpa7AcqTF4Ui9tKhoytKWvzp1fvv3tfjjmlwoXJpbaMajImDs3VJbR9wvraKpDsfBQn68xUvOZcW3aXuW9lShwLSRqHJB8B+srxzoax8cyXsWvAil8Wzg8awm9+MaFnQyFHLlQwbEWgJVtCBDzSJw2tdsrC63JDf/YAsCRPsDuvtsZoB10xFc0BEBjksVljH37+SyHbR9Ye7lSTBhUwCJ9MRck/kcLRFfSb0Z/3nG/yKg2pOSgMfZOd0ERRrRAXA8N2j00PQVjWiYirDHk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199018)(31686004)(83380400001)(6666004)(6636002)(2616005)(316002)(110136005)(36756003)(2906002)(38100700002)(53546011)(6506007)(66556008)(66476007)(66946007)(8676002)(26005)(186003)(6512007)(6486002)(478600001)(7406005)(7416002)(41300700001)(31696002)(4326008)(5660300002)(8936002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WndqUjMxSDROV3F1bktpdnJCUXQzTVAxaUxQTTJxU0crL0JJZnc4M25vR2ND?=
 =?utf-8?B?NVJLak9xeEZKa2IySlFORjVBd0RRVzRSa3FIZGUrZkpyb0FzejJPQzlKT3N2?=
 =?utf-8?B?dzl3WXlydWNybEptWUhTVTBobm1qZzRFODU0VldYeGl6S2p2c09HWDdZVHRN?=
 =?utf-8?B?Y0tWWUFZYk5FdXk5dFpaTWFwaWtoaXlmdEllK1hueVJIYkovWmdoUkxmN2Er?=
 =?utf-8?B?b2tJemxnUXdhZXZwMG5qNzdPdllQZ2lzOGxYVEVJY3RzTld1SnBaT3Zvc1NL?=
 =?utf-8?B?SE11dXJXUmphVFl2bWc0NHFqWHhVZFljbGV2MitYMzR4UW94NlpjZHNpc1RF?=
 =?utf-8?B?N3N3dHdiNXVhcGFGaDhMYlhMTUNlQWd1STRkZ3hGWmV5ekpLVmdxWWFhSlg3?=
 =?utf-8?B?VG5QVDUrc201cC9jUXZpTVZxbTQ4Y1ZyME41VW9GaDdvdjBsa0Q1SjVwSHpG?=
 =?utf-8?B?VWUrb2MzbEhidGRnbGhuUHBTd1UzNWV0aUU0c0FTdDYxdjFmREhYbjY3ZS8w?=
 =?utf-8?B?TzRjQmQ1ZDVrT200N3ZpVWt1cm1CYkdMUmpyaWxyQ2cxakhGanVkMTRDNDJ1?=
 =?utf-8?B?QVFBck5abEZ0NFJ4bzlKanBWWTVuNjhXWDJNNmJGZU9rOEdwcmpHTG1obnhr?=
 =?utf-8?B?R3JLLzh2QnJrR1JZa3hUY0hjd2pCR0hIV2tRYkVueW1palpsNVZja3ArNC9a?=
 =?utf-8?B?OEpLOWI4UmF2blRQbzhWTzcxWGRmZmtNVm56YzgzUnl6bHB6RkxRVG0rVTNo?=
 =?utf-8?B?Kys1UHg5MDk4U2xyVEkrRytBYlZxT1VXTU1KMW5zK3JBK3Z1R0p3cmJsTGkv?=
 =?utf-8?B?cGdsYmVrVzNwVXRjaWd4bWtYVEhwUkZzaEFKeFF5TityZ2tzK3IrdGpDc1lL?=
 =?utf-8?B?NCt0NEJNeFRFQ1Q3RytRemNoUTJSV0RvTXdZYkJYUkFVb25JMklYaUtnem1a?=
 =?utf-8?B?eFU1Ymg3cmhHZFZzRUs4MXcvd0JIaDgyMkduV0tSQnBWeDZwS1pzRjYyd0Nu?=
 =?utf-8?B?bDZOOEE3SFdOdWM5dUhHVUhXT2pDSlBLZjBaRkZtYkFhK1JJUlZIbS90ZzZP?=
 =?utf-8?B?dXdBc0VRMEVlMHhyNVZsckJkRWdyMFhWR1NoQXAybFBYS0hScis5RVpoenBt?=
 =?utf-8?B?NFlPYnB3VTZZS0JNbXlPc0tjU0N4aXovaTNxVEhIYk5HTndyY01iK1QwWEIw?=
 =?utf-8?B?MlZrNFVzOFN4ODQ0VnhnRE05SG5KcmNhMEpBVmMvdHdEbTdBcjFLSUVqbjZx?=
 =?utf-8?B?LzY4SDlFN0RCOUU2OERUZm9ZRVhpd1htWEhIZy9rdFQ4Njd2SEdlSHlTR2Zl?=
 =?utf-8?B?SittSHFxaUpFSHhuMWhoTjMvMU5xNGVxUW9vS0d6ZklhNU56RWpCaktmbmc5?=
 =?utf-8?B?SUlOTmdBQ2lnWDVkSk5PQ2RTQjFDZ3ljVTBUNzhTSGFLb1pQSGJWdzRZRFBX?=
 =?utf-8?B?MElVbkFoU2J0M1MvbUdEYkplVTN4ZHpXVTVkS0N3Q1d0Lzd5enRJTkkzVVd4?=
 =?utf-8?B?VEhBQUlOQzBtVk5DMkp2alFJQVlSR1VmWTVKOGhsa2lQSThkalZIeTJBd1ZY?=
 =?utf-8?B?aWltMWQ3WmNJVVdXYVp4TjkyME9PTlVpNXB2d3hpbDg3MXFNd3BNMnlXWUU0?=
 =?utf-8?B?LzdRL0UrYjJZcVZpVWw3OWR5Ujd0M2dvSDNmTklQRlA4K1FOTzFDa2xhWlJH?=
 =?utf-8?B?NCs5U0U1aGFVTzljeWVsa2w2UmxwWE9Pd1BlaGtHRCszYndNVUwwaTFrQlQx?=
 =?utf-8?B?c1ptTFh4QTJvangwSzZDL1Jha0N1czB2cDhsZEF3NS8yU0EyVVRuK0tPWmIw?=
 =?utf-8?B?ZHJHcHBrRmh1U1pURytwZnoxQ3p4VzlQVzlPblNiNDRvQXdhZmxxRUVMN2pw?=
 =?utf-8?B?NDk1ZWJzNXdzU1RLa1ljRHY0aS9td3RjbUovakZRZnROcktzRkMyQU1IQ1Vm?=
 =?utf-8?B?cmxqN0lNWjBwZzMzeDc4NkwrUXQ0V2RxTTREM1BQRTNuRXdnTys3RUcya0tG?=
 =?utf-8?B?REhzMzZBWlpobFJzZS9yUUwrT283RmVsWHJodGtqdFBXeEthV3JzUWxvWW9B?=
 =?utf-8?B?elRZaTVaMmQ2QkhZNGRRdUZ2Ulo0cVZ3RWJDaE5FTHhPeDFzOTFnQ0FqQnNa?=
 =?utf-8?Q?MD5EEGDJs9jDiRbQN0zjRFFmp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ff8658-b4d5-4978-2c92-08db04f4d315
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 08:09:36.7499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDKENkV73Rv539BZ5eWxxewFj1WhFAS+FWxuhH25mRS5cbbogAE3T4BSK7QKuukkfFdVGoDRQX14oPVVNV/U1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/02/23 23:52, Borislav Petkov wrote:
> On Wed, Dec 14, 2022 at 01:40:03PM -0600, Michael Roth wrote:
>> From: Nikunj A Dadhania <nikunj@amd.com>
>>
>> Pre-boot guest payload needs to be encrypted and VMM has copied it
> 
> "has to have copied it over" I presume?

True, payload is being copied in patch 10/64 now.
 
>> over to the private-fd. Add support to get the pfn from the memfile fd
>> for encrypting the payload in-place.
> 
> Why is that a good thing?
> 
> I guess with UPM you're supposed to get the PFN of that encrypted guest
> payload from that memslot.
> 
> IOW, such commit messages are too laconic for my taste and you could try
> to explain more why this is happening instead of me having to
> "reverse-deduce" what you're doing from the code...
> 

I am updating the SEV related patches, will add more details in commit and send.

Regards
Nikunj
