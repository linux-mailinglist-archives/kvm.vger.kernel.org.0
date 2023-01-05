Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24FB65F60A
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 22:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbjAEVq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 16:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbjAEVqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 16:46:25 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2075.outbound.protection.outlook.com [40.107.95.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAF663D28;
        Thu,  5 Jan 2023 13:46:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkJtITLQPq274TwugSXQ4p3etcxAyD69UYwEsS/Vthg8aYtCqLX/uMYPi2/6m+0+Ou5bAe2U0dTS7hjG1S7/kZKI2fs+RovULGPgAPjnj1e4G0I9WJcpFhUm3A+ehqFO0T8PskqBNJVnor7GD8ircQwXoCJfUDb1OJTOQrh29ryyodMrfhh1Ze31tp9gmDrjdc3ncQryD/BFQDowbLPD52z+XzzNcnEufp9U8XATKL3WTo3DQxLqKsDEN/P27PE9gpxHFJcIh6us/Tx5+zI6/iAySJgFFUGVEgdFUMhRwp1o9fkclmcLFLXC1M9awLppoGQQd/qs6IRYrlqICTetDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMbKZJ4SSB6zZqvnrTy73ZeHcgWUYxJ/CIBVBsyFD8s=;
 b=Dfco4mpDQ0ufDK1wZ5kZE5qnLve5ajYOPoD3l34k2zXk2bDXsf19re/QHkNX7rqnEnimo/EKGLQG9rfMIDZbQJlRa2MSKGsDrS6RGTmZF5vrg6LFa+keprMJ7tV6LWSEYOwonTm3SMKiDYFeNQBVXBr/Z2PQwX9Of/4x5qXP4tfMs99hUf+0dCYyok2T1v+w9lr8izkMIlZMYfnB664yH8KTe6E0eUPwQ14qyrlhmJS1tfXAq4GwxKV/fqN91xSc9C6ipCTj4xZejDMaGX99QjuLCjL/F3VrvCOSLw+fJqwgxg5Pz2LDnvB5DY1brd3MswhBtk1axFbFfoqtYgSIHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMbKZJ4SSB6zZqvnrTy73ZeHcgWUYxJ/CIBVBsyFD8s=;
 b=s/ziD4s2PaF70r1yOOtka/FBbjZhvbqfwPLrmaW7kAfKxBK/Us5OqnntM2uvg2KpFnEG6tjtl3cy/JsYAaeK/3z+qt2jevq9LNvkLuWMmu3vr9eOFzqhJMhCmWRgLyIefvsB7HhddkuqTNSRGQts5KozCx2dzjuQMKskw5OaQ0Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SJ2PR12MB8036.namprd12.prod.outlook.com (2603:10b6:a03:4c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 21:46:20 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 21:46:20 +0000
Message-ID: <1c525bcd-fe77-276d-4697-ac2ec3e00182@amd.com>
Date:   Thu, 5 Jan 2023 15:46:13 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Michael Roth <michael.roth@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic> <20221219150026.bltiyk72pmdc2ic3@amd.com>
 <Y6DEv4QuvIfwWlCW@zn.tnic> <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
 <Y63Jz01c7zLx03gQ@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y63Jz01c7zLx03gQ@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::7) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SJ2PR12MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: c985107f-2808-43aa-733e-08daef6647d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J2muMyBVuJ5wwCEJDbSphgGDymg/aVZi/NsfVb1N8KH1p9276ynFNIID358iHrO7B/W8ZTg+VNyN7uR7lOp3kJM0JMac57ocWibEkjPmCN4or26KAj+so90eeZ8GBYWV39+iYtOLVxHdCqARr+wxxx3e6DzHoxKk9EuVlhoQgeljNGyJwkR8ZaJfEuArWTuYuMb6a7FG6EvDJ/VByE3rrMzAuBzsAAF7bt/S1iy9yVMnAX3f13xlhmgbzZj3Zf3yhdl8N3xHodtwqUlna4VejMQ9d/qYT1QaRcocg3toICOa/BDrH3rNMimGMN84THUbhkjYNSAkPVGXPJc82qagMIvPsofFAyXitPuVA/2jqRBBc32D6pgLo35vh0N1nMNrXljrQx3VZW7g+P6p1bZsUGmJ+8hlY9+YC5jAcIJ98DsLCSBvxXidC9XfRwZCMURpIeYsKm/HfBm44Ru9SgGsA7yRh7yzTa5jJv4EWl4Je/Z92aQKyrBycbObS97Jr6vVJ+kZh4M5AtD8i85W6nwXtHhxqFNzgm3sSfIEWFIt3tnoY4WrwjG7u/7jwmKwjBJRRMFWxvDiTO3o3SOAtvHxZT5TsdGqwJaRYQ5b24kLyEJUELQ66F97dSRgXK3EgjXOHbGzIi607XAEiHyLDH9rbIwntJFQhnzKsM8nyaqnPI2e9A50RbPnPdKRjttfX02ingRH2044KtDal3E1POXXSTqXJ1pM7k+Ur3Qe4dWKVO7qtbcaVmDvldOoXnm+4KdV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(31686004)(7416002)(7406005)(5660300002)(66556008)(8676002)(316002)(6916009)(2906002)(41300700001)(4326008)(66476007)(8936002)(66946007)(478600001)(6666004)(36756003)(53546011)(6486002)(6506007)(186003)(6512007)(2616005)(26005)(86362001)(31696002)(38100700002)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1VGT05qSTU3eDk0QWdiM1RFNzdSaTljWjNqQXBpYVNRbzNXemxXeFZuWlRI?=
 =?utf-8?B?cUVYL2JpdnpOVTc5TUdsRHN5LzF3akNWQzZmVzlKbG12Ujc5VUU3WFllZlEy?=
 =?utf-8?B?YjVrcHFoaGVSRVpUb2kyQ2JuNExISnJEK2FkSEI3SXV6enlwWFFWZTNLQmVE?=
 =?utf-8?B?T1hvWDFYRVkya202clJqd3BuMGsyN1JsTXY3ZWQ4WmNERzZkdUYyNUZBV1o1?=
 =?utf-8?B?SERyYU00VUZ4MEtXUkd5WXgwZTZSR051MFBGaU0wRHJjOURpVFpmYzc2Q0lG?=
 =?utf-8?B?ZmV6QWZERXliQmg1alU4dHliNGsvTGVGT1Jxa29wTkhFdXgwYzBnb0UyQVhy?=
 =?utf-8?B?YlgvK24zb3UxU3Z2K0MyOHBxNlFYRjhLWnljdFJBcUVJRGQ2Yk1NRXVSR0Qr?=
 =?utf-8?B?M2NvUDdicVQwMW83WnFsMHhGVXIxSFZRZkh6eHUxN2xBek9BU1BEM2lKcXpB?=
 =?utf-8?B?aE1zTExJdU5zdHR3VWJ4WS9NS1hrVUhGTmVUWm9zbmRtb0FydExYYzQ5RDdW?=
 =?utf-8?B?dzFJVjhlUTY0amZ3SEVLcWpaU0JLK003bHhXc01vdUdOYkJGWDYxaCsrNk1I?=
 =?utf-8?B?bDNMZmRRaHpNWDFkbmUydFBnYTRCUE5FSDh5UnpINEM5U1BRd1F1Q2QwWFlZ?=
 =?utf-8?B?eWZOTlJxUzduZHJoaHgySUpnVFdkbGxaSEI2Y2FUS1hVSmNKTW45VWlUb0JS?=
 =?utf-8?B?c3ZHbkNaZzdRR3B3YmFtd2kwYnJkL3lKSHVwcnlLb3JobkFrUzZBZU5Ka2ZW?=
 =?utf-8?B?WTB5MGdKV0FpRmtUL3lkeG5sVWo4NXhCbEw4cThzTVpBaG9USmRvT0pSUEcr?=
 =?utf-8?B?aGFoL282c0h6WGU4RTBUbldoOFVHaWQ3OTVJNFJ3RkZFQlhoOFFvYmhwVXgx?=
 =?utf-8?B?ZkFzM2tuR3I2VnJkVVZxSFNXcjU1cldkcERjU3FsTjgzT3poR0xMRCt4eWEv?=
 =?utf-8?B?Rzl0eFJzTWljNUpDMnlCQ1lGb2c0TXJJbzZmQjVZTnZaYWYwbjlnZVdxQmp6?=
 =?utf-8?B?UkFLNFVtN3ZyNXBCWGFtNXNpYytsUFhJMWVrYkptaFRSUmNCUldUMWxhcklR?=
 =?utf-8?B?OW5iOVhNOTZISjB5QngxWncxOFBxSU02RTczZzBiQWUwaUpFZHVyNzhib3dP?=
 =?utf-8?B?eDROYXhCNEtEL2dQQ1Bld0d3dzhBY1krWnBjcWF2SnpJZWJzVVRQcDIzQ3VH?=
 =?utf-8?B?U1dod2hkSk5iWnJMVUNETzRnbEw0T1RsUldxd0dwa1p1cWsySWV4cjZNekdI?=
 =?utf-8?B?eFhobW5ZeisrejJ2bmNvRmptb2xlNEVCUEp1eGJicGVlS1V2QVRJT2g4ZFIz?=
 =?utf-8?B?Q0cyK0lNdGFiUFJwM250T1E0TUpoSXR4aGwwWmgrNmk1ZElMOFVaWkZ6Lytz?=
 =?utf-8?B?aGh0MFhqbGJzSlJNWFNEMXVHbWoyZUw4LytvWGJoMWR1cXpaNkUrcWgrcEhE?=
 =?utf-8?B?R2JmQnBYREtFZkJYd1duc1Z1dXlPWTRvZGxvKzdTVG9HbWVuRGNseG41MlMr?=
 =?utf-8?B?VXBsa3NjYnJhb0VteVpnODNlekwrS3d2cjRZdXRPUnZYeDNiR3pPUnBKMTJp?=
 =?utf-8?B?RUppTkxqc05xTHplUzBoclFPaktYcFYyRjlRTUJrb3RtRFp0RVBLTE5CSjY2?=
 =?utf-8?B?bWVTS1JXMTh1RjV4ZG1IaytnV3Q1L1RLcVI0SU1uL21zL041STV4ek55b2Iw?=
 =?utf-8?B?cjVrYWozU29Za3NETEMyZ003dkIyWVdmbWlhOWRoRHpMTGhxdGZTTk9aU2wx?=
 =?utf-8?B?ZWRGc1h3dXZhT0xHUVFiVHlKYTIwd3BBVHRQTW1Ec1A5bUhhOGZGdE40L0Ns?=
 =?utf-8?B?VVd0dDJlSWxiUUF4eW1HSFA4WHQweDBaMFZtdmRHa3NGS3ZuTjhXdm1ZdzYv?=
 =?utf-8?B?NlUrKy9Nd0syeFQzM3NuK0tBbWFVL0o5N01CeGN6bG5xL2owK0VsNG8rcUhI?=
 =?utf-8?B?dkQvbFdSOHlCbFMwa2xkeG1FTVZaTlBNSmZZak5oN2hLL0FkVW9JR25ER09j?=
 =?utf-8?B?dXVBYWtpaHJXQTQ4a1gxaXkxZXVuVU1aYXRHNGEvUnc4QXVHMnRVdktSQlFs?=
 =?utf-8?B?SmVSOXlFYzdIRHlxaFlyTE1zUkJWSHNGQUVVOHFPbW1kVVVSZ1ZzOC9qZUk0?=
 =?utf-8?Q?O+zkBW18HzDkozkA+yKrGxHkS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c985107f-2808-43aa-733e-08daef6647d1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 21:46:19.9145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0djPHJ6ZYbrnfARpiBeLP38ULaP4CrqNVXJ65rpMdJ9+qJuMcKgLe+nTuocZ3/3oIWe4A43quAKmrY4B4x6kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8036
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 12/29/2022 11:09 AM, Borislav Petkov wrote:
> On Tue, Dec 27, 2022 at 03:49:39PM -0600, Kalra, Ashish wrote:
>> Milan onward,
> 
> And before ML there's no SNP, right?
> 

Yes, that's correct.

>> there is H/W support for coherency between mappings of the
>> same physical page with different encryption keys, so AFAIK, there should be
>> no need to flush during page state transitions, where we invoke these direct
>> map interface functions for re-mapping/invalidating pages.
> 
> Yah, that rings a bell.
> 
> In any case, the fact that flushing is not needed should be stated
> somewhere in text so that it is clear why.
> 
>> I don't know if there is any other reason to flush after modifying
>> the direct map ?
> 
> There's
> 
>          /*
>           * No need to flush, when we did not set any of the caching
>           * attributes:
>           */
>          cache = !!pgprot2cachemode(mask_set);
> 
> 
> Does the above HW cover this case too?

Actually, as both set_memory_p() and set_memory_np() are only 
setting/clearing the _PAGE_PRESENT flag and not changing any of the page 
caching attributes so this flush won't be required anyway.

Thanks,
Ashish

> 
> Thx.
> 
