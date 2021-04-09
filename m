Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD8935A4CD
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 19:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhDIRlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 13:41:06 -0400
Received: from mail-mw2nam08on2059.outbound.protection.outlook.com ([40.107.101.59]:27425
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234346AbhDIRlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 13:41:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7dS/2j03n20hvbIKF2f7rhludYrv3ZM2Nrwsr0x6f3kgV6TxsgVSJh+NQRa6fT3gwX5LUfyqVETZbrhMrqF8xO6wcosG6vXUyyGM32w3ZJWJBEJxPn8N0LzgvjzCxmqAtFzg/hSP3fnYLJ4cemFjNz08BMvjqwfmrVWHuQBNDB6MWkvaArNUk4/1LALkxpJfIopbM2OqMMhcL6otyh1ZqOw0wm9NIA5lE/AF4GtDpUj3qoQaZ7LfRc0Gn2x7BucVsT0Y7cWM57YJdIs/BqkPs3Tn5x8qpFaVwuzIAlOq+UqWfxW5Hk3/D4S+Mz5qC6PAhQIPACn+tEBFgxDwyCBWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKYXTiMgg7OJdTOiMSf1OF5DzgxVUp1DzCffWVvS3JU=;
 b=MPz7HEjh7QA0IIsQciYSp76k8bO1OMZA7dz3os5zdzq3NBbyzwvvbqRFHg2oRQ+6T3r3ZUGcsYqkNnbKslrElLUsWgFu6QPx1S9wYv3S4+5KcG7ZVqcujZEdkAX6n/FTSodrEqZww9xZy1CpJtnOLBBiH7ZvHczP9EuZhtuNEo7DIXLv/3h4X06eR2FSR0cl19HSeG4mFKviPUy/pRPdhzdxVycvQGDTJsgXP2hup4SDGSq0UzV+U1+MnzPIR6odrACiZqDRwZCnwdS01U8FmqEBqIeHOSVGZkqCoklYXXB1pJmJuT4zzOBbcKquK4NKMnkM2OsJGCWkzxeUefqYRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKYXTiMgg7OJdTOiMSf1OF5DzgxVUp1DzCffWVvS3JU=;
 b=YoHHA8lsStucWO814on4OJQ8GmaT0U8IHqOLVGkxVB97sRZ7COnzGazLNZ9n+30sytNysM5FhxA28tWfxcax15NuajF0OAmx0y87qXjV0x9glk9PKGsXEAw0hKwWR98Wa+CEHdGWd1Ms1HsYrgbjyagpGfLoDJxaUQKzdw3Qy5g=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 9 Apr
 2021 17:40:49 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.021; Fri, 9 Apr 2021
 17:40:49 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 11/13] x86/kernel: validate rom memory before
 accessing when SEV-SNP is active
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-12-brijesh.singh@amd.com>
 <20210409165302.GF15567@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <7881e369-bc5d-665c-2765-f5aca034cfd5@amd.com>
Date:   Fri, 9 Apr 2021 12:40:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210409165302.GF15567@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR01CA0014.prod.exchangelabs.com (2603:10b6:805:b6::27)
 To SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR01CA0014.prod.exchangelabs.com (2603:10b6:805:b6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 17:40:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f24666b9-77be-4388-2fb6-08d8fb7e9cb7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44138B8E1D687F2C04552379E5739@SA0PR12MB4413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2NfryLeMAQLlmsdrMC0r7HgqPwNDHcsu06imKSqKbb8LMlLlKrw30Co9peeEvJQd27fPtHkcXK46JwE2C8TOYUXeD8YtklnHs2T+cKBck8VWPg/6zT9zK21FBi+A39P/Eun0hopX5eZ2VL7bx30H7ENB1Q2UFjgcRzSCrdQjnSXNRM/5No8Xu72bHdEYprtqzfT0GjBrf+UCAqVyF3QRUXfxWoYdZajPlhQr03dnhf3UDGcKLJltmn2nlcFl7eOy29OoYgL40mPEsXuazBiGZsIl1fzrhdkY8kghmvU/OaaiCXmy7/LVHzMw2xJ551wR/9piA6xfaQ+JJcTmlboQetAHZgtj3+EJxRrQlPTPpb9x7yW06WbiDdOSS4Gmsk6HJvo1z9L57Jm3q5m8IWNf1vw069DyHvLh6rKSMoOgemuui5yPcdRB9X3XTulSeWnGKSWhf3WN2cx2tucj7A5XKVjXu4L7BToA/EH+hDHdLW7RMaELfjY06Ru02WWBJdH5XWCFo18ySBEeT503TiY85v+TmC/OltjnkV1mUCC1xrPPTg9Pd/GC4cMEuJ4LdObsH4+b5jYpSedmSmV0eMHP54lZadVfrQ5vZmJt2Nupu21Ff6OlGw3ALOw5o30Y97/X4oyXYmB8VsC66GRLd99JwsiW+jluDJEl06ujLijV7OEuu0mAvKqvXjqCVHVUK2VXuvEA4rCHi826ZEprmwow1nzrbJHkJHL6D3mYQimGQOQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(6506007)(31686004)(38100700001)(956004)(26005)(83380400001)(316002)(16526019)(8936002)(15650500001)(6512007)(7416002)(54906003)(66946007)(52116002)(44832011)(38350700001)(186003)(66476007)(2616005)(86362001)(2906002)(66556008)(31696002)(478600001)(53546011)(6916009)(4326008)(5660300002)(6486002)(8676002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T0dFTk1SVEFPWEdDZlhEb1FuaUltMXo3clBrS1FseG9VY0l4NFZpdzk0djNw?=
 =?utf-8?B?UHljWnY3SVhNZU1TaEU1WDhVbXFLVXZHZEdML1pPVnRmUEhYTHhzcFd0R0VS?=
 =?utf-8?B?NDl1bDVxWmhkVVdyNTJMUjNZZ2lhTzZXYkNraUlieSt5cWZPa0wwYUVVNEJX?=
 =?utf-8?B?a1RKR25uUDFnTDRsOFBCaXg4ZVNwQ0FoN0d0VkxOaW5DOENSSkpTOHZsb3RK?=
 =?utf-8?B?YmtCaXd1V2M2Y2doZjFBRGRrZlBVMHZFbjY4RSsvdEhhMFNEMDRZdkxtVzBq?=
 =?utf-8?B?bHFDZ2VWNTkxS1JoRDdZL2FtdTBXYnB5MlVWT2RsY3AzZjN5RE1EZFBqYVc0?=
 =?utf-8?B?bVJkWUl3b1BVTXljckE3aU5lQWxRbmp0SDgybnpBTC9SWnQ1K3NnTk9WdS9k?=
 =?utf-8?B?OUNlaWgvNXBiRFc2alczZkdsdm5VZ0liV3RGT28wbnRGUUthQSsrWEpLQWtJ?=
 =?utf-8?B?dTRhb3pzZVhQWDBKaW1HWGc0eGE3VVpWZDU0cjZJSy8rSFRNUk93RkF3amxz?=
 =?utf-8?B?eVg2YWZwcjB5MmpJRXAzbnNZM1A5THlHUzMwTlFlaFBUdC90U1RTdkdTQ2Yw?=
 =?utf-8?B?ck11K2t2SS9lM0hYejd5MWM0dG1KazR5amdKcFdhbDVVcFZjMUcvVDRXRjFl?=
 =?utf-8?B?bzlmMWhJTUVhN0NkcEdmTmFWM2d5Q3ZMOXZUWEdHL0dmVjNKVGdoaVNPbkN0?=
 =?utf-8?B?b08yVHFsdXFJQzB3NHordGYySFlVdkVSZXYrWDQ3ZlNBWEhIUVRiYUZWUUYx?=
 =?utf-8?B?ci9kaHZQN2hTVkVqQlZKU2xpcDU5dStjSFFVaXlKTG5DM0JDUFdsTlpwN2Nk?=
 =?utf-8?B?dWNFTE54cWlwdUZUaUs0cnVBWVZ5alVDWWZlVllnTlJ0WEdPOTByc0tZUTBO?=
 =?utf-8?B?TmtmZjlTNWhpTVRVVGxmS2o0QXlZZmY5a2dwTC9zRS9seGh0SlFLUVM3OEtW?=
 =?utf-8?B?NGpHWjFmNlhBOVlFSVd0WWlZM1dKeGtpZUx6VVBGdVhpWUNRdFMzUElkMkwx?=
 =?utf-8?B?eDFkdHA4U3RMR0JLZlpCUmtxQVo5WE1BSHppcUtibjRYVVhiOS9JVFdkUlBF?=
 =?utf-8?B?MG5kTmlhY0xyc0pTSnVPU1FNOTdhOFhzUXkrZXBOckhYcE5LZGEyUm9PVmNO?=
 =?utf-8?B?UTBaUXJPcjRjQUd6eWpsVXZvOVBRS1pDM1RqUXVoVmdQa1dUangwVzUveWow?=
 =?utf-8?B?WDdwT2lCMytqUTQ2dDVZeXUyNTRMTFQxM1I1MXltend6RFFNZHEvbjdJa1dj?=
 =?utf-8?B?anUreTNJdTY1SU92NHVHaEZ3WmUyb3hSUWhHZFRYbFRJZjRUVTJuNzBwTm9Y?=
 =?utf-8?B?NW1PUWpJTktISGtkOWRxV3h2T3A2UEpFL2EzSDlQcTlDYkpLOElmclUwS2Y3?=
 =?utf-8?B?UWNZMzJSUWNNWXZPcldNbmFYSTJXUmJIa2JCbUUzZi80aUpsWVhlNkhPRS9w?=
 =?utf-8?B?U1RSbElsMG9UNld4TU4rT1BCejhoUDJmM1JRWktHb3hidXZyQUc5bjhoakxo?=
 =?utf-8?B?ZGwwRWlKSUY1TS9kQkZBTHk0RVpSVllwYVZoVlJEaFczVE9WZzZMS3pTWWxj?=
 =?utf-8?B?YWxpQXQ0b05JcEx6QXhXalJNMmJPc3dNUjl0cWVnNXFWMVJTUW5vUklCMDBJ?=
 =?utf-8?B?cndJQnY2RjdGbDNhM3BUcFFkcStuVTZMYnVsRG1vdFY2VmEvcE9Za2tvdmlZ?=
 =?utf-8?B?enZYS3BsTjhPVzg3dUg5aUYybnJuNW5tSDlGM0w3U0FBWFdCTXBMR2ZjNHMy?=
 =?utf-8?Q?mdmr+5RktCbJiICtQEiVqaBU/VayQHYr+e5KhoD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f24666b9-77be-4388-2fb6-08d8fb7e9cb7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 17:40:49.0245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jA5qCf9W0KFFCWlePmEwKvqm/vubXNQtZ13vJiHsm5j2ldpsU1aPmqbK4RmE+/LT1m4XqFcD3NzEWeSUwQOLng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/9/21 11:53 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 11:44:22AM -0500, Brijesh Singh wrote:
>> +	/*
>> +	 * The ROM memory is not part of the E820 system RAM and is not prevalidated by the BIOS.
>> +	 * The kernel page table maps the ROM region as encrypted memory, the SEV-SNP requires
>> +	 * the all the encrypted memory must be validated before the access.
>> +	 */
>> +	if (sev_snp_active()) {
>> +		unsigned long n, paddr;
>> +
>> +		n = ((system_rom_resource.end + 1) - video_rom_resource.start) >> PAGE_SHIFT;
>> +		paddr = video_rom_resource.start;
>> +		early_snp_set_memory_private((unsigned long)__va(paddr), paddr, n);
>> +	}
> I don't like this sprinkling of SNP-special stuff that needs to be done,
> around the tree. Instead, pls define a function called
>
> 	snp_prep_memory(unsigned long pa, unsigned int num_pages, enum operation);
>
> or so which does all the manipulation needed and the callsites only
> simply unconditionally call that function so that all detail is
> extracted and optimized away when not config-enabled.


Sure, I will do this in the next rev.


>
> Thx.
>
