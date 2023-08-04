Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4C376F6BB
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 03:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjHDBCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 21:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjHDBCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 21:02:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289D1F5;
        Thu,  3 Aug 2023 18:02:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnE27zLpkYTRk4cFzl0QOuBDzUw/pbjHNvrARSsFHrtLzdIAgj9asHYT2uRFJt3dp9rBO9rnm5FKtfaN2OneuylH+CulKDEfq2WmaAQ51BuFxYkE8jmtW20TBDhi9+geZtk01VNPKkkoGD/JqoXXSvpTxG1Mn22DWRs2ANnGD7GhBDZIZQWwkSgMjTvoiBUUeOBJnozafjrMa3ujJx3hf0KIKery2/OiCK4zEb5kBq4NAk4Xql4ygrg6coh856Dp2Z0lDuHx/m0fjOhusJXFknfwiTpt3elvvxx6ZwpPbBDPiKRVw9l0IK8lbF0yhEyWdPorMXoapKc9yIMtDdtGMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MnahBNHfGdNS+a7IsBb0bVHW3lSIkSwch8r9vtIK+4=;
 b=GjJxNKgX9GqXLJPYlJAI1TrrMhQ1GM8K3AU/JaGYD6WpAkSGyohgn7djROiN2EG3JpfyYkl411XDFFFfIxR0u06k0M0XWTxmybBxEFw6Va/ARx/lEis8yFFHPkuNvQOD94yROpXviTqXpTQ83KxsbBqjniuBCgP+2lzohnS79UQvkB+26qNN05wz8C747EOK9UyyviP4W2pwUmweb3IytJ3h6/KMnl6Nxxq4Zh4qBBojSRtoJhZpvslA+GTR2GMN5or8UsO7Paq3GKo5asCf/bEMQGM4telyVYGKEKjV7MRoxSYIHetHNeb/uzLF7HpiQc2v2pjHIm2tRrjrONPayA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MnahBNHfGdNS+a7IsBb0bVHW3lSIkSwch8r9vtIK+4=;
 b=sQA99x4QGgeONuCJSj8Jmuh+6ZQjgH66wRH5j1TV03V+Qls3JHq79Xe3Ti0c6OwUoVX5gwfG/xo3PF9DQVhDT6KEYqCOPkpZ6p1ti2IZLrFa5ndA9CYkmoLVUlUfl5jdzij/etnrclwC+98hoQBwBmvxnBxZtjJ+olT+Aweil00=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN7PR12MB6670.namprd12.prod.outlook.com (2603:10b6:806:26e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 01:02:00 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b%3]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 01:02:00 +0000
Message-ID: <d3f35229-7ead-a133-93dd-8b41a1c94ffc@amd.com>
Date:   Thu, 3 Aug 2023 20:01:56 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v8 00/56] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Content-Language: en-US
To:     "Schander, Johanna 'Mimoja' Amelie" <mimoja@amazon.de>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alpergun@google.com" <alpergun@google.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pgonda@google.com" <pgonda@google.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
References: <f4905c32f4054d4ce254b3acb9339aa1c59728b8.camel@amazon.de>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <f4905c32f4054d4ce254b3acb9339aa1c59728b8.camel@amazon.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SN7PR12MB6670:EE_
X-MS-Office365-Filtering-Correlation-Id: 88905f3c-4a4c-49db-1989-08db94866813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wfILu6NOhm3QT4/EvXBB/3qEdRy/mtQwi5LNY8LMyE/cQSsAUdKmumT5+KCPvWhSxWHmHo3hdOWBAInouJnXGlL612XccI6o5lf2l0UPbhB6Zft5m6dkTWejNTBWohQUI+SlY9CfCZAy8l3t//ghJq4BwJ/w1n8lrxNx7mbL3kHbK5CFURf4djIIBKLUj2tUz9W67Ao+uZ9V2mijBuL9TO01SoBPzfAhDu43DxYriWa3gWEoL/lLZwWBK0BCCEogHB3rVwqeKIfYsCqHqcLY0w50iQfOM32Zb8L/OqhtjfTG5alMLPRb2riRXDXgBWUUu7UBKBghFiIDzAh98GM6QHhHtAu3BYsdQiN0UIQHUst6LTSEc+w4HiQXSuk0I5faY6KuHTpWoXbEnb2HXQzaD/1gh6LJYizdfmJ3p/f8Z6gxt4sz8Sq+xr8e5U40/Uj7F26gf00+ApYhtAAxQZ7sTD1BGl/DaHsqwsVmdQTr64L64Vlbr2VWMoHRdVCVGndAtgxZ4F9mzuVFLLiNjfCcHVCCwp9WP7bz+m7qg4w4Tsu6EgFJ1rwx3ThPBlWt2YGFuxyZ/51lrcacRyzILGSUM/R9cT5+IMpDoiXqEfzyUTIWRpIARdJccSQH1t9XDrh9WGCc3tD6Ml6AEZYRK8tIZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199021)(1800799003)(186006)(2906002)(41300700001)(316002)(7416002)(7406005)(5660300002)(8676002)(8936002)(31696002)(36756003)(86362001)(6512007)(966005)(6506007)(53546011)(26005)(478600001)(6486002)(6666004)(2616005)(31686004)(4326008)(66946007)(66556008)(66476007)(110136005)(54906003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWtvNlJ6ZkQyLzlNcThJcU95M08zOUZNNHNYMGthU1NYcnZMYVFsWlgweE16?=
 =?utf-8?B?SmRjcUhjd0VyZFJNQkpMRWJTOXlmVGQyVmI1bmNabzRqVitwbThNMjV1K29x?=
 =?utf-8?B?cHIwaHJscklHUGhVRDlGOWtkbWNrZUpvWTFBcnAwMTZRbEZmQml5NHo4ZFlz?=
 =?utf-8?B?NG1BWG9mazFaRGZIakpCVkJ5WHgyTUhld0xnUkM5Y080Sk96WHErdEl0UjZr?=
 =?utf-8?B?NDFyeWtxdm5iTXp0cVp5WXlxU00yYXFWemQ1V1dPL00wK2Z5ZjJxVElRNk1P?=
 =?utf-8?B?b29TSVVQL3lnejV2ay94TUVSNFZERENyamFDa0UwUEhvN09iMk1URmdSTmVI?=
 =?utf-8?B?Vnd1NVMrSTRCMDZpdTNZVTdDUDZuWVFwcnJOSVdRK1UrdzZ3Wlk0c2FwWTJM?=
 =?utf-8?B?UUFyRTBJOEt2aGdCZG82UENvUGFITE9pU2dUeGI2S2hkYmhHd3B6RllmdEhN?=
 =?utf-8?B?S05nOTFsREdWeUFGQXBMUW14Nk96dFRjM09DL2NxaDZubDJjaWdkSVJkNmdQ?=
 =?utf-8?B?NWhpTUsyajlXdDkvQzVGVGVlUEpodUg5VTJMRVFuZ1Q3S2JsT1Fqd3d2Rlky?=
 =?utf-8?B?Nkg1NnlidEVvWEhRNEZOY3BjcVoxNjB6MEFkQlphS1ZJSlUwTUl4UTRXaVZV?=
 =?utf-8?B?OGVYZjRPdm5rUkdTMEZiSlJvRWZJWmx3TEQrQVdnVjBEZEVORUFXeHhZS05i?=
 =?utf-8?B?WXhMbS9pMnFWUUI0dGdKREJrWGc4NmwrU0dsSzB0c3l2dlUrWG9GKzFpRXpi?=
 =?utf-8?B?Nmh0OEk5cmVSRTZNaVR1WVZ3bkMyTVNudm9KaHlnbU9yMDRsNzlBNGQwQ3FQ?=
 =?utf-8?B?dFlaaGpQM3BwRGpVYUF6TEVWelNLdlpIN1RtbC9xSUlxRG9hSEU2N1JMTXNu?=
 =?utf-8?B?MldKYjE2SVd0ZWJwNFY4TnA4R0RydlpzOTQ5cEZyM3JVZUpZdzgxdDlBS25B?=
 =?utf-8?B?YW5QU1BFa2M0UytCNXBRWlphSnFqbDBiWW0rb2JRWmt6QWEvQ1IvWG1Ib3M1?=
 =?utf-8?B?MUVLTittbmtkV1FLdzJqbDJUOHpDSGFGcjZuUVFWRWVWRDZaT1NxNE1MMThv?=
 =?utf-8?B?WTBUWGxyb2FhZXp0SnAzTCtBbEtCWXEzYUFGK1NGWkJLL25SR1UzK2ZZV3BG?=
 =?utf-8?B?aDNKUDM4eC9qMi9Yb3I3QTFnSWZZTWVFSStnY1o1cjFGZXMvTGsvSXZXYXZP?=
 =?utf-8?B?VTZmcFBWbnFYMURZSWNMaHdCSGNrV0t2UGpNZVRzVTh4UVVzM2FLWTVhUmNk?=
 =?utf-8?B?dUFJMGtYbEdxWW4zdHNkcStJMmM5QUdyOEJ6Z1dyU0tlM3l0dmE5TnlSTXlL?=
 =?utf-8?B?YnJjMWdnYjVPNjVBVXZKU1BtNHFkcWwwQnJGMnVQZTY3MG1leGxiMW1oMnIz?=
 =?utf-8?B?cE4yMGFGcllQVGxLUEdYb1M1TEl4MkZ2YVhHOTdGdEMvY0N3Z1pOTjRGWnp6?=
 =?utf-8?B?aEVSeHJaVXV6bGZWQnZwQVc2dnhITzVFWVBJRGNUTnRFR3EyYVpmSy9raDh2?=
 =?utf-8?B?dHl1VTc0dmZLNm94L3AwQ21MRG1ueS9yTmR6WjlTWmh6bGZYZ2YxQzRENGI4?=
 =?utf-8?B?YWduOVcya1B1UWY5SytkanZpai9PSHNOYkVTSFk3Y3Y1SWV1RVB4SFpnSkpM?=
 =?utf-8?B?ZGp0YkJuT3N3NCtiVWdHU2tKSVcyOVkzekc4alM0TW9kcDRQTmNjUC80SWY4?=
 =?utf-8?B?UWtTRGx4Yzc4OGxKWURzYmg1MWZwbnFoa2x5QmVZY1ZlUHd5bWtYbUJTMUtO?=
 =?utf-8?B?N2xGSm9mdVcwdTByUnhCcGpQQzNBbE9NZzVCb0t6TndoTDFVTG1qaWlLQkFa?=
 =?utf-8?B?TmNVdG56SEhFZG96YnYxRzEzRUVhOWlmdWVKZjRqR01TVUtTSnUzSFlKNTI2?=
 =?utf-8?B?REdxREMySk9VUHlXWjc5ekZ1dlpTV0g2dDRmMkhSaVY2MWo0M0t0VzcrRWtJ?=
 =?utf-8?B?SVo4bmZpSUJ2TWp2QVNKeDl1VXVITmJCMGxCMm5YYm9ZQ3JQTzZNRVh4SSsr?=
 =?utf-8?B?MkRmQlNTVlZVOEF4WnhWOExITUFWcHZMaFF1dS82UTNmS1JDbksxb0Qwb2VZ?=
 =?utf-8?B?UzI2dzg2RGQxcjdoVjZjVzVMYjFVS1FGbEZrQXB5Nk9FSFNTUUpycmlxRURC?=
 =?utf-8?Q?1omrkl0jwpOsVFfy1kHB+oIAM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88905f3c-4a4c-49db-1989-08db94866813
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 01:02:00.0368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OVnkSaxuwYo/BQ6i/YAc2XbzIZ2KZU4vipQVlwk4rwQ/dtUkmgunwYQ6DxpjyklToXrqpzXJZb8AhKTXBthMuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6670
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please look at the response on github and followup discussion.

Thanks,
Ashish

On 8/3/2023 1:27 PM, Schander, Johanna 'Mimoja' Amelie wrote:
> We discovered that the kdump crashkernel would not work with our SEV-
> SNP configuration.
> 
> After reading the device table from the previour kernel we would
> see a lot of
>    AMD-Vi: Completion-Wait loop timed out
> errors and finally crash:
>    Kernel panic - not syncing: timer doesn't work through Interrupt-
> remapped IO-APIC
> 
> We found that disabeling SNP in the outgoing (crashing) kernel
> would enable the crashkernel to take over the iommu config and
> boot from there.
> 
> We opened a PR over on github against the rfc-v9 branch to discuss
> the issue:
> https://github.com/AMDESE/linux/pull/5
> 
> Cheers Johanna
> 
> 
> 
> 
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
