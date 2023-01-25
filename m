Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF4067A91F
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 04:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbjAYDLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 22:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjAYDLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 22:11:48 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CC82367A;
        Tue, 24 Jan 2023 19:11:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iof3xbICDckln+BCv4S2aJf7BDS5Qb/lgM5nJRGsMfnsvir8gzg9zO998ZeO5J7wSpb76HUURrMf1C4OiPWQsq8ZeQOAgrmQPf83/mr71Dyb6kPqk/CsxscnVrrPxUwRRdgIymvWG5KN/77OjwT7yZNBpJP/IY3IJy1p+pGkqXGNF4TmOmkinTVuwXK5F84ckP4S6UkXUrw1K2IFz4FmmjjglC/QDh+O8TJofYy4J9Z7EwOaitrse2C5keG9J/yzXPTGbvW+ltTYtcqeg6QC4TQJ22dm5CuocXOrVfg87iwrwjBl/xmPe9Z/Ot8OKKNbFtM7ji/KjqXwWbBzblKtEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0J354x9iVg7cvJijqJNIcBCn9m4wyuqmQ6F5ErWNEWQ=;
 b=RD4QsHR91dnT/kpkqNApPz1BO73f3yxPGFoNYUhIs3Q1UNS2DgeC4+bfthyKMvKs/1OzWW9NUCgDL2kODDIhV2mlglrCHfg9gQvr4sd2DbqcFc5+67GNQowUUqWN8VcMntkaLcsIpvkrwBIhnvXSJDArAshXPsrbee3Oz5x433zJyP0oLyyrA4tbT8iEKOH5L/F1woDufX4e9IcHQP6urt1E2tFr4R/+Nw0f0EpCv/Mxq7Nq4QNoS5AYYksF9UlU8uMa+d1yvSNbiJRdS8GkLTYUL/2nPSfiVcgcft+hH+AbZTtun4QxECLP5djb7R8KrujTe0yX8VPs2ZIn24KMLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0J354x9iVg7cvJijqJNIcBCn9m4wyuqmQ6F5ErWNEWQ=;
 b=L/dHFzlo/9xSW5X9dLRFtawoBcVQdBNIlcQu/oqVUO2dziG6791ONWyARYHvUqbfBEC1ifA0x9ZOM9sGKvY/fKXi+gxanJYpIAQ6bGjH/whdhktX7GoBJMV0FYJZ98XkPr0E5QFNiNPr+1qI/LmOXa1RPSXkuxO1m+v9P6MnRU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CO6PR12MB5393.namprd12.prod.outlook.com (2603:10b6:5:356::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21; Wed, 25 Jan 2023 03:11:42 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%4]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 03:11:42 +0000
Message-ID: <7881a2d8-9655-31ad-27d0-5c30db7895fe@amd.com>
Date:   Wed, 25 Jan 2023 14:11:27 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v3 3/3] x86/sev: Do not handle #VC for DR7
 read/write
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Nikunj A. Dadhania" <nikunj@amd.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-4-aik@amd.com>
 <adc11ed3-de89-a389-e629-3c951257469c@amd.com>
 <533c5c83-b68b-eff0-d36d-9963194ab844@amd.com> <Y8qDqgzsAOgcckPW@zn.tnic>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y8qDqgzsAOgcckPW@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0087.ausprd01.prod.outlook.com
 (2603:10c6:10:3::27) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CO6PR12MB5393:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b480ef-b57e-4d25-704d-08dafe81e1b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+gW7DrPDyfnXsCCDCsZZZyqXI6yPmDms4wlaJ7kXOHBogiBs0skJJtfBZkeVRPRpSxNejmqx1sOvDn+QhGoKM0leU4Y274pnMWGmUrsgnW/ro/t3hcLQnpHSuT7DnqOfYc6e/lpPONPt+wzSc4kWqDOx6lJM7UupmV8lmbZiKh79zE90B6S4xG00CFAKOEQBgh/otytn6KImo18Ywgi4mQVwP2fD/AAf6db9jYLGcXyDDyFbCVvYAckinrsAsZQTOfBfjG98gsljuPkBGMoh9uuFKNUSCL0OhA1Hq2B3g6UwjE1eAG8T37Xe1m+W4+VdhsjD90qRpAfF0gFOiXlE7N1MSvYQX7sdHoPFDKKl3MIhgSlmQbRIqXg3puEQXQ3ASMJVNeXaEnIat/mSEHnwizrqdiHpWYGGvVuFEwsY+6De6nkzjf05auHmSxqRk/lXTNQAjdfhrgrKIsqDBMV+lzsL8kRXqm23Ju6P55QHOd62k46TVrAooYfxyrg5aFKin2NcbbyxiQl6D2yyTSueRpvZlLMhjKetDZauawvQhkeXVqexMZLjCwC7+VHTCcU/vR+wXdSJkYDDB3T0GT18EoymMMeiOzGz4h3m8LSrDYIoebuw3nIJDP1ysHa/hBTgMX3X2+ZSCGqfOZpDC3drdIRf2HVWb8u5SZjIzvg4voJt8f/jrWbIvVu9zooQUR29+kAUl9DxDyxBLmWAZ3aIglot8q6tWelokUl88jzoJA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199018)(5660300002)(8936002)(2906002)(66476007)(66946007)(6916009)(66556008)(4326008)(8676002)(41300700001)(31686004)(478600001)(6486002)(6666004)(6506007)(53546011)(186003)(6512007)(26005)(2616005)(83380400001)(38100700002)(316002)(7416002)(54906003)(4744005)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzVWbjVEc0lIR0VFM2srRFptNzN2aC80bStqSFlvSjJNdU0wbnludTlUcGtW?=
 =?utf-8?B?bVplRmZtbk1aVnNIUUtoVTZlSFVXY2dwLzdQZS9ZTG5JbEsrb21oeVhJR2tQ?=
 =?utf-8?B?SDFSNHFoS2NxYWNFT09vek9BN0RKSy9DMWRMbFJDMFF3dmRFYjBrcVNCS3VG?=
 =?utf-8?B?ZFdzZFNVNWxIbjRnbmhKOFFJNFFaN2hzTGFxeldVQ1NxZ080RlpjVHdqQkRZ?=
 =?utf-8?B?WnF5bDlzYmFTWUFWRC9yeHUzMUFQN0piQXhuaVpTay9CYm9tSkJqakJMN2tm?=
 =?utf-8?B?aXBCTktiU3hEN1hCb1QvNkREKzFYZTJxZVBJNkVhdjJPZitlc2ZmaGM1dXV1?=
 =?utf-8?B?L291ckFQMkQzTmQxcW9lMFMzalVtRVVkYWpwNjBVVUt6aFVERUFYelZmemMx?=
 =?utf-8?B?bU1tOU92L2dHV1djRzZQOWRCOFBnclMxeDRRNCtvbkgvWFJieXoxdFcrQzgr?=
 =?utf-8?B?NTZDWDJqWEVraldKMWdBeEh5UDNHRGh3YVdUbERzZ1Fldm9LeFdmTFgrNE9D?=
 =?utf-8?B?czRhOTFCOUVHbm80NHFJa0YrcTdyd0Nta2pJa0xDWFNTU2VpM3ZtbVVJck1h?=
 =?utf-8?B?UXhxL3dxZVlJc3pxUVUydTBrU2hCQUtBK3ZVeEdwSVRvVDlPcFJGQjlMUkpa?=
 =?utf-8?B?Smd5cUtsdFkrMEhQaGU5dGhVbWpSSWEwZjB2OVZmb2wxOVE5Q2JFOVBqV2VF?=
 =?utf-8?B?VFNsc1V2cEJTNTZMWVJsRzVxODBCOHFReUxxNCsrbFJXbko1N2VYUGV2L2ZD?=
 =?utf-8?B?VUF6dFNXRGtIU3VBNFlYZitLQXBPRkhqR2N6ZjFEcWFiNlRUUWIvbmdQT01K?=
 =?utf-8?B?a3FVNi9MTEwvN1Z0T0ZYYTVkOXdXbEVrYmoxeUkwN1g4YlM5QXZtQkMwSFp0?=
 =?utf-8?B?MnEvWVlVeXRaYzhGcEZLaFQxdVhQOHdqOGpyS0xJN1dlbWsyQThSOFJjOW5F?=
 =?utf-8?B?MDJzdGNPUk85TUE0NDk2WGN4aFZsVWNGY00zMFg0RkduV1ExK3FYTy9jSWxq?=
 =?utf-8?B?c2k2L08rSzFPd2xkaEZCdGtWQ3FiNVE4Lzg5cEc5a2x1NFUwcnlZZmEwZ2dC?=
 =?utf-8?B?b2Z3Ymo5YzBiNnppY1ViK3lWUWNOdzlBc1lYK2F3UWwraThBUldac2k2NG14?=
 =?utf-8?B?dENESHJpVnRXREU2UUNwN1ZUSVRnVXlFU1VzdmgrZHl4cHRDSDlpbUlIRVZ5?=
 =?utf-8?B?OE5GUmRZZ1JXUXY1V2FMRWZFaUljaTV3T3IwQkU5ZnVzTXF4bVdlbUJvalla?=
 =?utf-8?B?ZStLcFZabGwyWDM5RUJzOHpnSGxuaTNrb2RSZlBiKzlYY2lQZldWcUU5SEhM?=
 =?utf-8?B?bHFPR1paMVU0SUMzbFczbW95K1VGeXZEV3drWDF2QzI4NDhGYjN1Zk9tcFNm?=
 =?utf-8?B?ejFSOU5LL1o2SmpEVHFCVFYxZW5OVUt1djVwa1FRNW9CbWp5N2tZbVd3SmN0?=
 =?utf-8?B?UEdKUDVWeW1VOFpmYm4vcTB0TkR1NFI4Mml2NUhNdWlJblNBeUo5U2ZlSm9x?=
 =?utf-8?B?UmZoRnNDb3BMa0JZUkVzUVQzTTVvbVUrbS9uVE15ZU1oTFNFZ2x0VUpsYTE4?=
 =?utf-8?B?Qitkd2I5ek9wWm1yalUra2R3RzZKa1ZmQXh5cm10N05JSHFua2E3eHhOWnVZ?=
 =?utf-8?B?MjNDa0NoSUwzYXFVZWhsZWxKMTZqQ1pzTDdsTGVhdW5sbUFTbTJRQ1FLM0NP?=
 =?utf-8?B?SlBjYVhIUkM0UFpLWjBETzhML3pNYzZJb3JnQlBCa0w1eVowdEhxWHh2Tkx3?=
 =?utf-8?B?c21WRFdUUm9nQ2MrZXpqUnZsZ1Z6cnMyNFZ0UUFHOEJabE96L1pkMHY0bCth?=
 =?utf-8?B?MjVjdnFHOWFtalIyRjlEd0Q0Ry9WaUtTa3RMbmRiSmZMUFVpNXdRa2lnTGg4?=
 =?utf-8?B?UFN4ejR3WnBCK2JwTnVjRDE3V01Ka3AvZFNXLytlK092YnB4dzdLNFIxSTM4?=
 =?utf-8?B?OFU1cHA4eHlRcTNZNFplUFBqMzBaaFNUbXRteE4yR2kxMVp0ZGY1c21XMFBW?=
 =?utf-8?B?QW9EdUd1aGtnbE14NUVhV25QbTlBY3BDRStTcDN2SmpBYUNKWXdqTk14Y2pu?=
 =?utf-8?B?czZ0RlR5c1M1bTFuNCthclh3TDl5MG52OVVFME1mREV3UWk4MDhGUXNTOEQ3?=
 =?utf-8?Q?YMg+Bnl/jmOa4ckV9AZ08NcX+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b480ef-b57e-4d25-704d-08dafe81e1b8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 03:11:42.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVZMYXBvrXOBIJcUV+87hnRVncCPgnzzRAJt4yF+3pdVjTetjbbv11tRZURQwYtCt+lnpGKPZ5DwkiyadlcQSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5393
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/1/23 23:06, Borislav Petkov wrote:
> On Fri, Jan 20, 2023 at 09:23:48PM +1100, Alexey Kardashevskiy wrote:
>> Worth mentioning it is tip/x86/urgent (which does not have
>> X86_FEATURE_NO_NESTED_DATA_BP), not tip/master (which has
>> X86_FEATURE_NO_NESTED_DATA_BP).
> 
> Yeah, when you submit patches for tip, you can always use tip/master which has
> the latest lineup of all branches and should have all the required bits.

The tip/master's head just a few days ago was 195df42eb64dcb "Merge 
branch into tip/master: 'x86/platform'" and did have dcf67f724b8ada 
"x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature"  but now tip/master 
does not have it -  8272720be044 "Merge x86/cache into tip/master". /me 
confused. What tree is the tree?


> 
> Thx.
> 

-- 
Alexey
