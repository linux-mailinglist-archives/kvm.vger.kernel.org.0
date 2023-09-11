Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A181479BC37
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbjIKUt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237312AbjIKMch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 08:32:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A67D1B9;
        Mon, 11 Sep 2023 05:32:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARBd5cpM8HN4OHAb4nFFpuoCWiLLM1DUO9QlaGVBNeK00Z7OZaG99LleyXdoa9jk4J3uyWP6j1KXX5JuqkBWZrvWJkDAYu695vz4Q7IP3f3CWCXcs+8JwE3fccRoAbI5PkcKv2/mU+eWnS+6HKOuWWWd0PT5JtrMK3aT4Q+vfMaJnrxdNppup7cJWO7Y0VfhbGW18hn6uM6oEnrMau+XxV7a+3pQH3f1WTqMZEPBubczeKNe6mbYu7drI7gUjKdh3ogcnWtOjS8r/RTqAdOr2wNfZ6zNXZsHeUv/Nqfbn+q9b1uMwehIQp8RJwFUNjePuXl9qokIB/CBYh7YbcgvNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IqaO0oI05QFVkd12zKfaf+VAzNIBB6KQ/s1ycUrvtY=;
 b=MPuG4686ahSQo0A8h927gBCiZutUYuj3+1W1v+67UNDu6pUZ+nI4O6T6Y6xMtOKg+qc9b6JrnZ9O6mAkqA48nxRGOIfjhIygKDnFUtyYkmapC+XvsDep9a2cWMsxGqLmBuXuAMJJq7rz7sKLvlRchBwv0Zuvt0ZIycQ8tBPSaz276GNa9zLvUuoIN0tP7ywrNU1XydSsW7tyxJRZtKU74aNejMbuVJqoKZxIIGdgQKdqEHzlpySTJjP0sMiijXdqkQKriQU0CmUxcQqPOyptLBCK0VF8M1hEHFkITQ5k9aHO4X8vFTZ9kQply1HzSvQfjzmzG8mwNN1V1bPwyjxhDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IqaO0oI05QFVkd12zKfaf+VAzNIBB6KQ/s1ycUrvtY=;
 b=F886aNKjfQeTRvYjtGCEhdDamMd3RHnOx7Sep/oz38yloW7mSZeIBVsiyHjuQAk481KGXsL0mH0YRcTO0guCaIQ6Oegv5pLCe2egTnrPteWl8mXKyXUKidsRXx8HN/xdEdsKMxI4w8boHAitAzTizhu3Gwp6/xqXwcgoKCP3Y78=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 PH7PR12MB9067.namprd12.prod.outlook.com (2603:10b6:510:1f5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6768.30; Mon, 11 Sep 2023 12:32:28 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::6f26:6cea:cd82:df23]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::6f26:6cea:cd82:df23%3]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 12:32:28 +0000
Message-ID: <f98687e0-1fee-8208-261f-d93152871f00@amd.com>
Date:   Mon, 11 Sep 2023 18:02:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 00/13] Implement support for IBS virtualization
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org, seanjc@google.com, linux-doc@vger.kernel.org,
        linux-perf-users@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, bp@alien8.de, santosh.shukla@amd.com,
        ravi.bangoria@amd.com, thomas.lendacky@amd.com, nikunj@amd.com
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230905154744.GB28379@noisy.programming.kicks-ass.net>
 <012c9897-51d7-87d3-e0e5-3856fa9644e5@amd.com>
 <20230906195619.GD28278@noisy.programming.kicks-ass.net>
 <188f7a79-ad47-eddd-a185-174e0970ad22@amd.com>
 <20230908133114.GK19320@noisy.programming.kicks-ass.net>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20230908133114.GK19320@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0230.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::15) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|PH7PR12MB9067:EE_
X-MS-Office365-Filtering-Correlation-Id: 80262a78-36d3-4f54-ba9b-08dbb2c3290e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNs/fXMyq7JDra8bTEdwYovkdcC3PE5KdP/mdBzQltp5cBq9+2WFY5+9YqOmw8WBcX8CluTjuaHCmp4EjzbQg9O3LBJs1snBxV8G7Gdw68JEKeueBTumAQ/7MamSdhmpQ74RWuBxWL8oINg9hHkIBv7Rncj3c/4nYvJyfqkoaNCFALohquYDckti+TS5ka7jyiyAtLDnR/6TbCohDYMzspwJ70FIpBVmrM984rqtfdpNeC7QmS9s/GiSVj3JEREp0FQjPe3kjakgl6Jk4vMVVKDFToVVZ1MABlnfCHNe25MlF+33TLUmfslDIwXvycRvq/NF7LayhhM1uMDCdxaLI0GbH2WiG7b5xQCaUhGbmMb42QyAJfaPXD6QBKcRKZQVEsMvp4pSC52VdR1qOBvYUeZ7KVQowD/Vz8VA9bwRKTrGxilwEgdq6nj+L73CVqcqIn5O06AG4aD56GgtE8KZjnnd5C5TgatOR+V8vHsNeDLSoAkZ1ubjDa7J54ZETDowbUjo//F17oByjsh9n2fB1HbBEi5lWED+l7bHCJOzLWyWfUM9WYf3lOPeabyfEjHQA5QNMm6FlDPft3te8UUkxySXzqgkAQfmVFJTMPQXXGiPe9ZTaHXIImmKEo4DOXUL2iEUf4MXBFJqfHzNJ35v8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199024)(186009)(1800799009)(31686004)(53546011)(6666004)(6486002)(6506007)(36756003)(86362001)(38100700002)(26005)(6512007)(31696002)(2616005)(41300700001)(2906002)(83380400001)(478600001)(8936002)(4326008)(5660300002)(316002)(6916009)(8676002)(66556008)(44832011)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bU5va3RkYXhsbkZMeFE3ZDJUR0dIVXNwNk94RXU3R2JhS0ZCT3pxUWVPUDlm?=
 =?utf-8?B?NVA5T0hrdVV2SGFNT21BQ2JYdk5jbkRoSlNUU1Y3QVBJMWM3M1Y1ZlN4OEN0?=
 =?utf-8?B?ajQybU9Sdm5FM1hsSEJYY25wb21zM0djNlMwTlA3dDU1bGVjUW1iazhmWFJ4?=
 =?utf-8?B?am43cWJTaWQvWHpBNUpPdGt3dERmcnE4Q09TS2h3ZDVLNDJtQVE4SmlCUnNL?=
 =?utf-8?B?VUdUK1o3dVZLTTF0cHIyMEtJMjJHMEt4bHk2N0N5QjdWYlVnTmtDbDNEeXYv?=
 =?utf-8?B?RDRuYXJzcXNUbTIyUnlUVnVRbU9lbHZlbTlPdmNteDRIQXhKbituNjl5Yy85?=
 =?utf-8?B?WnlvZDl4OGFCdStlUWVidU53V1d3dFdMYTRxdldENzJDN1d2eGZ6OTBJTk1W?=
 =?utf-8?B?aGtVVHBvTHZiVUJ5TkpVNzdsOTI2L3oyTmxuUndralIxRjNpSjZLRUMyMGk2?=
 =?utf-8?B?cjFQS1BZU1Y5QU1HUHZoV250ZHlGbHoxTlE0V3hJZmNwc0Z5UHJHL0VVeEpz?=
 =?utf-8?B?dlZwOGlqOWgyYkJnZFNha3JuaVZIY3pvZzV3M2YwMlFtaHpidlNnRExjSlFC?=
 =?utf-8?B?RlhQc3h6MmZiV3hobjFaZ3Q2dGRvNzRrVkVRdUNMOU9tSU5JZFdJdURIT0pG?=
 =?utf-8?B?UUh1eFBtTXl4WGtsTXg0V1ZiL3VlYTBNM0FGTXFIelZtYjFyRW9IN1RCaUth?=
 =?utf-8?B?UkVTQVBiVkViTnZiaTQxNmlVZTNlQ0x1aGp3aEhleE5BLzBITFZnVy9rdElt?=
 =?utf-8?B?YkcvZ2l2aytzaGlrcmkxYVlYaFpDa3A3dG5HOEJvamY3cjZUTzZsUDNOT0RL?=
 =?utf-8?B?a3p1RkY0K2ErK000N1hwMXl6SGp0Rys2T2ZIajdZd2pTajFoRjhyQm9kVnBv?=
 =?utf-8?B?NEpXanAyWmR1djgzMUtHenJVS1VNM3N3NnFDTE0zbmsydlZxZy9KeWVVUWcr?=
 =?utf-8?B?V0RNMkRnQkFNYnVFKzhqSEludzVyS1lQaXV4eUw2Qm1BdUxoMTZPRURKVXRM?=
 =?utf-8?B?RkR4TnM4ZWpHbGhXY2pNdXphQnFvZjJkdVphd0JYOUNaeWxrK0tNcjJ6SWFi?=
 =?utf-8?B?dkJTTmZqYXVRbzByWWFxUVhrdk1BWk14Z0tTMHVrZFBKMHpCdjlMRjN4N1Iy?=
 =?utf-8?B?V1hsUlMwL1AzenF5MXNLc3ZCbkgzZE1GV2QzSW1QeGhXWmkyeU1sczdFdHJa?=
 =?utf-8?B?bTFGdExRR0RNazh0M3I2YWtRd3ZNSmZYSVcwMG1nTzJwWDkydG1oRTlrNU95?=
 =?utf-8?B?dlpnL09ISWsxcTNZam5lL2hheUhhZmtpZHRkSEhCM3c2QlJ4ZE5weWVPbGZI?=
 =?utf-8?B?bUoxWTU1QzhOTjl2Q3N1a2VhV2ZmVWw5SUVFelhvU1hJQmRINlFDdG9tNXQz?=
 =?utf-8?B?S0huc044elRUd0pEa2RPMTdpcE9FZndsdk9lMXJpa3N6ZDcrY2d1UzZERzRS?=
 =?utf-8?B?Z0ZmaW9YS1dxYmRqNUc1OTB3UTlpVFFyZ3RDbklxREZIZGJ6REhkQzNWRkZv?=
 =?utf-8?B?VEpyWmpLTVF2cVhoaUxWVXJub0kyeWJVajdiV0R5akhCNUNIZ3ZsT3RxL01J?=
 =?utf-8?B?OFN3VlY3b0hzbnBadUVDNjNja1A3M29uYnRidkJzcjJYaVJFZC9pdGtic3U2?=
 =?utf-8?B?dzRPWUV3TmJRRUo5YVdzWWF3YzRjS09PeXJDb2svRW0zNG55QkFoUG5YNjdl?=
 =?utf-8?B?Yng0dGhQYXNpRkNiY2poTnRFdEtMTTJLcTZyS3ZxZHk4OWFHNlBCVkJGa1FS?=
 =?utf-8?B?a21ZNkdBMW5kWjZQVzlPWVE0bFZJU3I5bVdQdGVQR29hciszNlp5VzF0VkZk?=
 =?utf-8?B?U2pDZW9saDZRNjJUb3NtMXBjODRGa3AzcnJhd2wvdHFnZXBZTGFYd0xzUytM?=
 =?utf-8?B?T1ltTTFpRXVnQ3dtQm0zeXVyVVZUbU0vYThMdEg1MWFzVmhPNUhFbWJLOSs4?=
 =?utf-8?B?bzFNMG1rS2s5NFJ0UUdxNUdUVkloajBQWkpHS1grVXk3bzNkcFlVWjNMTkNI?=
 =?utf-8?B?QmNhZU9wUTZ5UFFudndXQXVlbzJpZXlFVU91aEtVc3d2T3Y3c3pZb20xNWsy?=
 =?utf-8?B?bkJnTEZ0MGZHNXlTcWJIcFYwZGdRcEpHWkZsd21Pbk0zdWQ2SjkwV0NCY0to?=
 =?utf-8?Q?5bzEyGGZyHr3tUDoiG4KEeFkf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80262a78-36d3-4f54-ba9b-08dbb2c3290e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 12:32:28.5190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmCZ9+eOw/YtZOfEVzgqV2Z2IaXBdENFpzXQ2ZfprYsY8mt4HR8cyHTTqonrEX6Hy366IuAC5n6Djmnigebviw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9067
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/8/2023 7:01 PM, Peter Zijlstra wrote:
> On Thu, Sep 07, 2023 at 09:19:51PM +0530, Manali Shukla wrote:
> 
>>> I'm not sure I'm fluent in virt speak (in fact, I'm sure I'm not). Is
>>> the above saying that a host can never IBS profile a guest?
>>
>> Host can profile a guest with IBS if VIBS is disabled for the guest. This is
>> the default behavior. Host can not profile guest if VIBS is enabled for guest.
>>
>>>
>>> Does the current IBS thing assert perf_event_attr::exclude_guest is set?
>>
>> Unlike AMD core pmu, IBS doesn't have Host/Guest filtering capability, thus
>> perf_event_open() fails if exclude_guest is set for an IBS event.
> 
> Then you must not allow VIBS if a host cpu-wide IBS counter exists.
> 
> Also, VIBS reads like it can be (ab)used as a filter.

I think I get your point: If host IBS with exclude_guest=0 doesn't capture
guest samples because of VIBS, it is an unintended behavior.

But if a guest cannot use IBS because a host is using it, that is also
unacceptable behavior.

Let me think over it and come back.

- Manali
