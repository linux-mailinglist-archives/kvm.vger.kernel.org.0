Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F376713EE
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 07:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjARGZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 01:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjARGWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 01:22:36 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2081.outbound.protection.outlook.com [40.107.100.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BE64ED1D;
        Tue, 17 Jan 2023 22:11:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFwgRfY34Y+gKWtr/wFF7s7/08Ji+wBoV1qgBBpQrC/GlQz3ZiCiuvw6dpI9X3eBQ98Hm4owE4fZNy6SPYxClkrm5QEQWVj64ldF4PfH11mokXvW4CWe40MmbOf4UHBmRfXqWPYvGHzC2V/kertSia87IF5xmqJYX3AFMKX4SgFNjAVolNdfwyz419LkAcQCeYzBLXYBCWCKDmkILi9TtggaCUTYNDgCKvv/s6wf5pg8rDz/ebSsHYbXPoYLTElFbWQOAlA1+431y8sasvlRfGa5GfnK8zBr/lySu4LDsHVcUi8h4+2ae7UUBlM3VDrsUfAHixwJbYrusYNAKIEObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5oe4fcY+Kp8WoFkS5iTAeG2oFU9CDkN9LUjzVJyBTY=;
 b=DDGFE4dSbZSJCmOt14K3hejMnAK8VcJKalQ7ormkwsoxshzP0UiWGBNrMPeRM9pjPJVZi5/ihvPQyIfOeuSJT42qjwg5s6rFKYabvAidZ/sFWGfDmjbGVkaE3gq2iqUlNcJbEMDYY/ng8jW34rqImNhzlNINoD1xmqzTWub3o1X8mLFjrDvqxbPe+xZWLQfOJ9IDFZyk84XrM1YAC6f/NKXhLWIH57txm4Bnl9TAyuxdUbpXHb1IhibZx8eSswoxbwM9RELmwU8eGGyf60SSyLVX3jyqP4xGlYwO18XPppP8QVopajTLejB3vtQDLWdn2QWX87VF5vFnmQx1Y7O5fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5oe4fcY+Kp8WoFkS5iTAeG2oFU9CDkN9LUjzVJyBTY=;
 b=DSMgGGmEzoWjtSE5vx5WXO0W1qJsFtGMR0QtYbwQO4INXnqbMA6HN1mMt58PDwMCD6LM4K6Bz+EsKjFa3iHNgEt5Lc0I8HNhqRP2Ew6Fpaq5lDXZwuV0iBXqjL2snU5R4UOTBuhrGZvIzu9kboK97HmjSyhU0fzQz6EBElf6PwA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB8502.namprd12.prod.outlook.com (2603:10b6:8:15b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 18 Jan 2023 06:11:37 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Wed, 18 Jan 2023
 06:11:37 +0000
Message-ID: <086444df-568b-d394-c190-9f206cad9222@amd.com>
Date:   Wed, 18 Jan 2023 11:41:23 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de
Cc:     mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, zhi.wang.linux@gmail.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
References: <20230116091036.72579-1-nikunj@amd.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20230116091036.72579-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0105.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::9) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB8502:EE_
X-MS-Office365-Filtering-Correlation-Id: 713282ed-4a04-48f8-3ac1-08daf91adb17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Q1WcGP+CppJGRKfX5o3P6zYggZ66g6DoGk53uxzWVWwvWDBuUibgRJT0XqjGUi/88zum85xDpv6uNWt2BpYHGQPSblgh2U12aqVy2SK4CQYYi7ZHD6+zwQ/DvQzebDWBPYeNiD0ZmGY5Pz5r48Npn0gteiFzMr4ACtOW+kfbCstpQTGSUTW0xmsd4/9nP6E5mEIthZ4C5Cuzljt52L76+o/3C+lLGMSKdcb3ipDqQ4XOnrDmE791kcoMyuubzfMr0UxIkRYWaPPFa3zi0fr1zCuuihNDhZiJJNRRGLf0Sphp6cna2tID/xxUyTVU2DOklVvOzo0dO3XTSdZql6+Cngvo1WsmOc3G0zJF1uASja+hS5NWORj6fK3+/LsGmbSStafwrYCG03c9oYlfmoqOXjxSZqkNI0CvJSsHAuPNlcj8IJBjdQhm0mGdoGjvnZwSJGcx3puC2DUOnxESB6Ali8WtVm+fGtEIQau/D803bSHy6tNlcCVxVrnmJuebwe3q7Pd7+rrmyNjkfQV+/qj989tlrQ0eiMEbymxPI/8EarwYI0o81zYzoOrgLDzL7EmxWEN8VIGUr7NezTUH1M27tHaCIB15PsnWRZVaPMa1m4ZvR4xkZ2dV7685gcRCLT9ew/H7mwkpMYtYX760xxRz0GKLuMtKvu4X+Xq6SRMSQI0M6Zt3U7CA8zp09/X7vhW0FWM75Xv4JVEPAYTIUeoxV8lV0TyoOvnV/++7s/IdT0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199015)(316002)(4744005)(26005)(186003)(6512007)(6486002)(5660300002)(478600001)(7416002)(2616005)(8676002)(41300700001)(66476007)(31696002)(4326008)(66556008)(83380400001)(36756003)(8936002)(66946007)(31686004)(6666004)(53546011)(6506007)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXlqU3VqYU4vUERqcHJWU0hEcXpEMDBXZ0NsdG4rMDN6bmtlcHhwZlpwUFBR?=
 =?utf-8?B?bzlQbnk3UExOaWk1TEVGaUtlMEsxWnNYbWIyNGcrdkF0M2Qrb1ZaZS96TUNn?=
 =?utf-8?B?MnhTcFJqOHdQQlZoZjZNTUdhQUZjSmtMVGhhWExkVVJBTXFWZmpEVlJVMS9n?=
 =?utf-8?B?RjNhSDAvb1NMbXlCMkk3Z0w0R0dNcjZFbUNLMzJqeGd2dDlTd29WSTRwU0V0?=
 =?utf-8?B?UXFLRFRJaDJicEdGQmNtWlpaeDlDNmVhZ0hjVjZwWGRCYm1kcjJQNE8xaDBz?=
 =?utf-8?B?SEo5aGVzMnc2NTBjMk0xT3JuY283TkF1eWZJUU9VOENyMWdiZFdhK0pkV3BR?=
 =?utf-8?B?Q0p4ZlFSQ2xjblExak11MUxHbyttSVVGVTREN0ZrMXQ0N1d2cVhUTEsvOVF0?=
 =?utf-8?B?bDRkTitGQThMdGdwMVBRWW9hNkIxYk9OUWh1NU43WENma1BUWU1LRko4K1pu?=
 =?utf-8?B?WXZJQVppMXY2ZHNGUGlUbjRqNXF2S0NZWHhjdExZRHV5TGhSWFN5azVEeUNQ?=
 =?utf-8?B?ZUl5L1FPK3J2ekpzWWFGa2hvSW9sNzNxYWtXWG5KeHlCNWxGV0w0MENGdllF?=
 =?utf-8?B?UnZ0U2ZOcXkyQXlXdE5qQ21tdWVibUIxTXFYQkxKN01yVnZDb0dPc2JiYzhL?=
 =?utf-8?B?emhuOERnbVhDV05idExDRWlJMU84UHZ3bVkxbmNrS2JmTGtweERDNC9HSFRO?=
 =?utf-8?B?ZGRkT25ROUhuMTZLdEh6cEZBakY2SDZQUi9MT0grUzZxQkovcEpkUzhDQkpq?=
 =?utf-8?B?eGhBd1FHVnJncWNJMTh3OUtGMUhwRmltL1ZhRERpYlF6UlNuYVdNRDFyUmtK?=
 =?utf-8?B?aUtsTmYvQjZreGwvM3FsVzhsaGQrOU9Od1FEVGFHcXNpaTVyL0hGU2w0dHE5?=
 =?utf-8?B?eU5GeWs2S2daZWhYT3pEMFFwVkNiVWpnaElSZjVmMzJWV2F0MEpiZDdCNGJQ?=
 =?utf-8?B?WExZTmRhWjAwV284ZHBYNTlPWEU1WE9lSjdQeWRhbkVhMExic2JiUWVURnp5?=
 =?utf-8?B?VkJUSGZSc3B6ZnFMcWJ5OTFwdm50NThmNFFKZC9IelkrbDVBWDNXSnAzb0Vz?=
 =?utf-8?B?M05MQ29aM2hqY3drbzBLYUd0RzBvVEg0ZDUwK1pKOWtjMUJ5OHdVVTRFQlZo?=
 =?utf-8?B?L0pDZ3BTV1hlWVB3NFhZQ29BOGpCeVFUZm10djRtUlhsUlRsYkJ6dFNHSW94?=
 =?utf-8?B?dXltdU04QU45aUcxRnFvVDEzOWcwMnp4SlRFZ2tGNUFKcjM2TU5IdGxOWEE0?=
 =?utf-8?B?L2M2bVFrMTFUWVJYWWx1VG9hT2FMaHZxZ24raW5kQVRUSStkVVZsNjdsSjA3?=
 =?utf-8?B?ZDN3djJpbVFLK0ljZG5zam83YkZiQktlRnZUZTRvMjZTc01iZU1zN1dLUlhv?=
 =?utf-8?B?UWZ3UnZTdFg5bytkRTVVQWZVV3JlUWIyR3VpSjNaTTYwSUZ0Z1o4dUdwTmtG?=
 =?utf-8?B?d2ZpOHFVK0RSTzhKcmZWLzhkdkRsN3pXSGptMmk2ZGVCWFh3ZEY2aEVvaGVG?=
 =?utf-8?B?NGhFYVZNQUFTVUlWN09md3N3N2ZFTXJvQnJ1blI3WDc0eGFFc1U2c1VyRitW?=
 =?utf-8?B?Rm1tR3pmd09tdEI4NDZpSDNjeFZiL0taQ0t0S2h0WUxLV2xubWp2anpEZEZk?=
 =?utf-8?B?bXNLVUF3UjI0VStOdWpnS3c2cXc0MDdXY3E3ZmZXSjJCOWJyMUtFY2dnUXI4?=
 =?utf-8?B?bDFsYTU4ejd2T1VURHFjV0w4OHhwNk5rTEU3UW1lT0xEMHBFekhnc2VKSGVB?=
 =?utf-8?B?NzR0ZXlVbFoyRHdmNVE3aWtNbGZIODhWRURsa1Z6VVVTN3lXVHZhamV6VzRK?=
 =?utf-8?B?QWE4M0Z5bFBlU0JzcVZ3OXNqam9lNk5ncXI0ZDBHamhhNzlNbkRxME9GZFFH?=
 =?utf-8?B?N1czRE5OS3dUeWxkUXFxcjVYRzVzRG9CekttNDQ5NmV4cUZNM3lFRDJxSGRt?=
 =?utf-8?B?bUp5b2pBbHppUXRZbkYxWldpTTRqOGtaaEJjV1lXeVpsQkE4Vm9mWTNHcGky?=
 =?utf-8?B?VE5BVmRFdXlZaXpJSDZZcFBJdnkzTUlreVZuWElwcWJpNDZiSGtnNHQzVW1E?=
 =?utf-8?B?MmFCT3N1Qk1DbytueTVodzBEOElKZXFqS1FYWkhjSmFpT21aZUlQbVhqTU94?=
 =?utf-8?Q?D42a9tJoIvv3gmarcI5BkxlZt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 713282ed-4a04-48f8-3ac1-08daf91adb17
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 06:11:37.0294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z44pg06FyPZ8pBSl4EgZ54AfxEVkkHu1jYuaem7lxc2sV5IOSIeA3gwPReNipsHvldAFNQ8O1Kxqr4wJP5n+YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8502
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16/01/23 14:40, Nikunj A Dadhania wrote:
> +static void __noreturn sev_es_ghcb_terminate(struct ghcb *ghcb, unsigned int set,
> +					     unsigned int reason, u64 exit_info_2)
> +{

Found this today:

In file included from arch/x86/kernel/sev.c:519:
At top level:
arch/x86/kernel/sev-shared.c:167:24: warning: ‘sev_es_ghcb_terminate’ defined but not used [-Wunused-function]
  167 | static void __noreturn sev_es_ghcb_terminate(struct ghcb *ghcb, unsigned int set,
      |                        ^~~~~~~~~~~~~~~~~~~~~

I am wondering why I did not get this error in my build testing.

sev-shared.c gets included from two files boot/compressed/sev.c and kernel/sev.c, sev_es_ghcb_terminate() 
has only one user. I will move helper function to boot/compressed/sev.c and send an updated version.


Regards
Nikunj
