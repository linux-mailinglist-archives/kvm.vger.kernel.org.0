Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAE460B4E5
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 20:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiJXSGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 14:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiJXSGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 14:06:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3711A045E;
        Mon, 24 Oct 2022 09:46:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2GzSuuwkRZSsEY8gBeUANX29Ic7KeKlpItpVXr4Ae56byPiqgpNLusoue1jOvn5iunh/WDgX2KGvCUiWR1jLUEuPCUjVzsirCRxM9lLJAonhFaGso/lZx7zyif6Qee8A6UbsQQTJcwgILOtHldKSX/a+H/22CiQRSe0vykzqo8MSHYhI4v4GjBqXa4MqouOmrIo+ZSa2xX6b3xKL6J/5tI2GQOBu0NOMIbsctMuJWqeWaU8oB+UBUNAYeRFTLj+U0gDDlebzeAkJC4/rr11gKscMV6KFBhukaUupfiq+qAnNT2RNSbR9rJln4n9KJzvYDhXdbp+X0io8hCZpNOosQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBCQu65SNqAZV4j17pyHqBXNnLi93WxU/PdG5gljT3Q=;
 b=h+EXKp6NhccpNpMpPvQh5UbMmOEaatAQ7pk0kznnawRhrWpTTQegZhIFcMP0GwyV2cEaGSEy3A1ZqzAfGILOUgFYIYLh9/ZgPIpN/7VcK0V1EQV/X7xVGGDIyNpmtjnkkZ+IBbq87BA8oYR+AlmsAGsjUtfc/wwNhl2dNx1j5N60T9QzapXL7XiL5jY9PvsvJ8Ivzi3FOZtMveiiVVZsup7EtYXFoz/U/QH/1Vv3NL9Mr6VBIt+Av3XbkabGMte1Kku/qtoyN6nsnNh9gHHw4TANAgneU/lfuGHjHkQfcmYyGfaJGwzpQN8LykVheA/IAj2lKVa+LcRCOHWdUJM5ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBCQu65SNqAZV4j17pyHqBXNnLi93WxU/PdG5gljT3Q=;
 b=qZJ3Htei8R8VJaI9m6VRrP597SbhbacR0c7X6Er90Ea8P6cgpNzEijKiisOKFRHy2iDwBIeLt+1ZnE/BjELHfXf8BA1LSGru6GtRnBndLG6Yc1ZKlPlQ1aT7fYVyOx/UDcsTgVnQcCyi7vvb0xvImAmoWvk2RJOsA0vP0VI7bZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17)
 by PH7PR12MB7453.namprd12.prod.outlook.com (2603:10b6:510:20a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Mon, 24 Oct
 2022 16:35:39 +0000
Received: from BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::9eca:d454:d407:7ba2]) by BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::9eca:d454:d407:7ba2%3]) with mapi id 15.20.5746.026; Mon, 24 Oct 2022
 16:35:38 +0000
Message-ID: <1f4090b5-1522-c3c2-a1a4-b0d5cbc13da5@amd.com>
Date:   Mon, 24 Oct 2022 11:35:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] KVM: SVM: Fix reserved fields of struct sev_es_save_area
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        venu.busireddy@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bilbao@vt.edu
References: <986a5886-4ddc-aa88-db52-e8781ec95aed@amd.com>
 <dd357565-d428-499f-fa0e-e35aa043449f@amd.com> <YzxfdQ7DrT9X6t7j@google.com>
 <d64d2144-449e-0dec-6bc1-a5478a0febc0@redhat.com>
From:   Carlos Bilbao <carlos.bilbao@amd.com>
In-Reply-To: <d64d2144-449e-0dec-6bc1-a5478a0febc0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:610:75::6) To BL1PR12MB5874.namprd12.prod.outlook.com
 (2603:10b6:208:396::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5874:EE_|PH7PR12MB7453:EE_
X-MS-Office365-Filtering-Correlation-Id: 21f020e5-821b-4cd9-5d12-08dab5ddc8bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMx/FvCyYJHPJLMkVoDmuLsKrwoeGitsLwp13cFAJ6z9V81fRfsukw/fE5Dj7k6FNB2oNMLXb7H2755rNig3ad1I2Brp9b8VpZ1Lj1oUsaUViVxhKUUO7e46J7wLLJ6cVHQqu5PB9CJT9HGN0zBMeKywa1cD0ZnSAKR5t51EUtLyrTQsCXxW0B26CH6+K9s+88QGur4aonM1DOUFOvvitBNJnMeQSqw/WWUtCFczqLXAY9KNhi04siR1kztXJLrV1bN9RSqxzOBmKRE+H6Y0Kv9uTy16lSMA4RUYdd0q3LZzT/Am4Ax2iM/GV9R56Z9pDKSSuIi7FtS9AoK1FmNc/0aRA1iz4gFPDQYxjLdngsDX2o2FuU8hInNS5bappktaeaGPqjfB/xMyou4S57wUWum0wSr0PfxS7KW7RGEaIYD2fkWHsELnvwRAhQkuvp3kVQm4D3ULn5JHcdgkiUquNCVoq/vqQzG2gSqR8+aku9JEwymq8H0l56eYsx8ptyuLRbRjz8mtLMcEl3NyG5555revPON3tmtBDrGk5rs/Hm15t9uyadl0G1N8nX5DFop1bRAaqsLLzb71vua4On9Fs2UJGbUfKG98Epm2DKnJx9YmsjzOP07KH9YDNSNVej9EkX0+qddQzAXjPFi3oA9oIGS3T5gOorjtM2FoAmCEp6cv6SvLxWE6DFRQVHxKqX5c+RZ5gF375/17El0sufykB9R6+FMfRnsIZ0PFoYCLG5FpbCXHY41evXwKFIWQeBN7zqUwzAccStqq1aTgA2CJUwXmgdwsIMXCr2IhtNlRlI8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5874.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(36756003)(66556008)(26005)(4326008)(53546011)(110136005)(66946007)(8676002)(66476007)(6506007)(6512007)(31696002)(86362001)(478600001)(6486002)(2616005)(186003)(83380400001)(31686004)(316002)(38100700002)(4744005)(8936002)(7416002)(5660300002)(2906002)(41300700001)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ym1VbTQ2KzJRRE1CL3NvVnlkU2lMSzhrSy82c2ViYnJkSXZNcWxKRzdTWDl6?=
 =?utf-8?B?bVFoa0xyYkNhZ2VzREhkVmo1MXNSVWplaDVtL1dFODVzcytLZnQ1MHNxU0k1?=
 =?utf-8?B?aTJFRjY1YlhXUUJwVXlSMnZ5azQ1K2ltZndkUmRYTHdicUY4Tm1LbnBqRUxv?=
 =?utf-8?B?bjFkTC9tNWJTWDUwcWROK2hMOGs2VHhJUzRBQ0ZrTmNVeFhPbkd4ejRBYjJ6?=
 =?utf-8?B?YVI4bnBKVVdWL0dYN2RJZjRVL0FpR2t0Ym41ODduSlgyMHhZTmVUOHFsYnZM?=
 =?utf-8?B?WWdySEpNV0JHY1paM1pFam5jN1U3b1hUemVkQzVYYWtyeisxMkJjbjZ4dWpx?=
 =?utf-8?B?NzhPL3NrRWdHdExIOURDUTJxZlJzaUFvRnBYbCtLODQ4MTBXNmxxVCt0MHBJ?=
 =?utf-8?B?KzViY2tOYStaN0EvTE9YcE93SExJVnQwRlExUlNSVTBqc0tZOVlKQWxOMFg2?=
 =?utf-8?B?NUEvaUZwUWhQOGUra1FDNG1qL25YbVJkNUQ1YlpNcUdPM1pxVEp1aGNjbDRy?=
 =?utf-8?B?NmMwNDVRaVdNckNRclgvajc3YkUzNnIvOGVxem94TW1rZjF4SFpndDlya1hF?=
 =?utf-8?B?Nm0zZkl3WHNJMHNSU1lmbEVqU0JiWFhDVDV3c1NTQnVFWUlEbGJSL09FVzQy?=
 =?utf-8?B?K2Rlb1laK3hnNTF2ZnV5MUp6T0FObzZrZFJmeUllTllkL210UXZWaWtCUjZv?=
 =?utf-8?B?bHNtRUI2UnZWenNsYkFyaWhOM25qRVdLL1FBUXhMYUhKSG92eVFGQWM3aS9t?=
 =?utf-8?B?RkZ0SlVEd1g2S3VVSk1HT2U3WENDRE9XS1B4WFRvcVFCZDhmYWVMTzd4Ny9w?=
 =?utf-8?B?Yk5VWm52M0IzaVpNaC9sa2JLZDRJV1YyYzZyNUZKRGdDWlJqZlUrYXBEV25n?=
 =?utf-8?B?dHhLTTZNRWVEZm9kZ3BQWnJUc1k1c3JPd1djQk5tcWVsbkdCUytteXd3a3RT?=
 =?utf-8?B?SnpNWUtERXUySnlHYi9COUMxQlFNUllCOHlJa2lLcVFCcnoyWEk5OEtkdU9Y?=
 =?utf-8?B?eksrOWg3eVVmclN2UEQzMm5JZ0p0MXJNWkFnU1NYczhxUkNQWUxLSFk5d0hr?=
 =?utf-8?B?RGhseE5yZ2s2K3VyRFNjZWpmaWpwUXVEeUVuYkJKTG04S2djbUJadENvWnZM?=
 =?utf-8?B?T1hQRTVSUzlXSXluSDNST3FBZmY5NGJDcEtLQlVPeDlDZnI4dG96ZUtXQldK?=
 =?utf-8?B?MzNFV2NZajNXOVFQVDA4TkljTmNyb2s2VzBHbWQrMk9wbkFGQ2JkcEZjaDNz?=
 =?utf-8?B?cjBGZUFncmhlL24zUXlJSkhSZituWEhVNkE5bk5wd0lFd0xCNkU3TG8wTnox?=
 =?utf-8?B?ejArM1BreERmL3dmLzVKM3BhRVRHZGtZTG9zVE9yVEsxTEU2OGI3K25FcnpQ?=
 =?utf-8?B?LzQvQld4OHZnckhxOUxJL3pMdlpHbGFhR2NjRUZtZmt4VDJvOW45QnZ4UUor?=
 =?utf-8?B?T1VlaStXQmszbkxORXZMcFR5ZVU0MjdzSUJkY09lem9nM2NMWVBPSGFydmZS?=
 =?utf-8?B?Q0J5bFk1a28vZHc4UG1TY0MzOTBRemZIQjYzeVNqaEJGT1Z1N2VEVEVOUHMr?=
 =?utf-8?B?b0hCRXhlWkhYRDY1cjZULzBNUVpST1lSSk1oWUM5SFcrNHgwb0VzN0hocVJL?=
 =?utf-8?B?eldVUGh6eUt3VElWbTVHM09yZ0FTVE5DYnllczAvUEQvUHdnYzIxT3U0dTh3?=
 =?utf-8?B?bkpPeXEyNUV4WXVTRm42YTlJbjZ1MXFyTG5VU05jSWRXWk9RZzJ1Q0hMaTEv?=
 =?utf-8?B?U0JEVDNramo1UTlLcHlBZmpvR1NMU3lyUm5YNEM5cXBiK3hNRFh0TEc5V2JT?=
 =?utf-8?B?T1BUNDNVS1FrSC9VMXRSUkRlL25Cb1BtZDFYOUxTTHVnOUt5ZGNSZU1iVEdV?=
 =?utf-8?B?RVN3cVpzM2lTZUx6ZmhmdUxQd2dzek90SHhJeXNwakEzR1I4R285UG9lclli?=
 =?utf-8?B?WmpNQ1pRcmZYcC9wbEJOTzdkaXd5cUhTajZyK0ZNSkd1R3c0Z2NERVNYNFJG?=
 =?utf-8?B?cGNYengzcU5RZEE1cDFKdzk4U3NwQ3BNU3FJRkk5dWFyaHowMFl2RFZwZzYr?=
 =?utf-8?B?eVRETndUTVYrQUZzYTh4WkpnRzArVXZYS0tjQStXQUVnRjdPRGROcVB4Vkkw?=
 =?utf-8?Q?El9m1t3+0Ymp8IQtmznE9oTf+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f020e5-821b-4cd9-5d12-08dab5ddc8bb
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5874.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:35:38.8655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sH3M4Oqi+j/Lu5JzeSUT2ScQLprhnGSzyAkNeY6Khgr6FB3Xz/jLW+uSVZnbhVo5o0/DOp3/dWl5T2ida+WCxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7453
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/22 02:46, Paolo Bonzini wrote:

> On 10/4/22 18:29, Sean Christopherson wrote:
>> If we really want to the number to have any kind of meaning without 
>> needing a pile
>> of churn for every update, the best idea I can think of is to name 
>> them reserved_<offset>.
>> That way only the affected reserved field needs to be modified when 
>> adding new
>> legal fields.  But that has it's own flavor of maintenance burden as 
>> calculating
>> and verifying the offset is a waste of everyone's time.
>
> Finding the right offsets is usually pretty quick because they can be 
> found in the manual (or something close to the offset can be found 
> there) and verifying them can be done with BUILD_BUG_ON.
>
> If Carlos prepared a patch using offsets (with BUILD_BUG_ON to ensure 
> no future bitrot) I would apply it gladly.  If it's just renumbering 
> as in this one, however, I'd just ignore it.
>
> Paolo
>
> Paolo
>
Sure, I'm sending that.

Thanks,

Carlos

