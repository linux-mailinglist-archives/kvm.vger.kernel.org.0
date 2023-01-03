Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A5F65B9A9
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 04:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbjACDZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 22:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjACDZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 22:25:55 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A108BB5C;
        Mon,  2 Jan 2023 19:25:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0WGuioH3q3wXWalDMxwwok4qOyzTyjFFKUWRPVL5chY1CNm+J0KgbpQUm0Byu7GkbHCr/THDIEcdqVNJP8F9mxsIErHAaugW8JhHswWiWRFE2sQhD25IQCXIsiXDGXlrhdlf6njH3sMdFVj6mae/SLWbYFG69ZhhTiEOSDaK/n4iRl1E0y/hA1JeZNTrTrrK8uSRuHtF0eekzs5C24XRHIwv77py5hlKWO3yLiFFGYwreD9aW+qaYB+JoVJYjvVx+9a9kUvayHqd9ft//JtU7YZFoUJnECJUh9a2ZyTF3JaN9YmW7vxGjZg8JMdjia96GwvC9e+Y0VdAd1KnHCT2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yxd45ZinjUFrbLnpuB48sHZ3s8H5JAuexFgmFC+hJBA=;
 b=YtNN+zUH/w+VpSOo0UFsOMrcbnQ2pqx5JqlPiX297enjyRE6bP+B/EZoKnnkXGhx8/ZM06h4E0AHlF0TWSwfGH1kCWT6toY2Week22tmO458PlQo6PsHnDudy19/6aX+/+vLpE1iddwjf1F3vrM1HB3rdgsio9ihuhknUdTSSnmVcPNcVZOLWqooH8eoqVpE6qCoGygySpdfOiEg1sdmB5N24Wr1Zx+Psl7qaFb/LlXb8+VGzPcQQma4qm4YQcAbAORyIeERuCPC8irXBVA7Szllww8ULwHZ7vtVkaL02F6NUfpGJoEVpH1TzSQ4fKjWQkBWWYbVits84u63FWIN5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yxd45ZinjUFrbLnpuB48sHZ3s8H5JAuexFgmFC+hJBA=;
 b=ScLQS4gsZUYeGDxv51oki2/IN+pt2A777ffWBtoHJ6GE9xITmOgmeCVIcXC2/ZbJ08nIf1FdZyEW6yb0HiIzRAmAhgUWKPUKe2JXVjDrzLPBVHs7PmtUtcZY5Nl1o6N6RLatU/KmQbjT5NmDw/Zn0jXxAU4BIrePEXfgCoFjd6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ0PR12MB5634.namprd12.prod.outlook.com (2603:10b6:a03:429::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Tue, 3 Jan 2023 03:25:50 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3%6]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 03:25:50 +0000
Message-ID: <de6ecc09-2cb9-3717-5793-f53bd55d2bfd@amd.com>
Date:   Tue, 3 Jan 2023 08:55:35 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        stable@kernel.org
References: <20230102083810.71178-1-nikunj@amd.com>
 <3169b54b-d990-7707-5ec4-cde7261318fe@google.com>
 <45487a87-764a-7ff3-292b-4a55fe29f7ba@amd.com> <Y7Mzk3tDImk46xcu@zn.tnic>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y7Mzk3tDImk46xcu@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::20) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ0PR12MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: 718025a7-df9a-4476-8e6e-08daed3a3607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 42rMWX8arXBQ3xq3zcK22hWYMSKVkDDp/oxvWf1aDVykt7L+kqCyl/nBRG6iH2eanujj0BrQ/k1goCbydlNpfkXS3KAavcZduxfT32rauvD7aoszMCRIVTb2lGdqeoyvjeS+KMZQLUt8g0KKKfB4kAqebHqmpXKrL3J+rysBj1EpFQUdUjSwlqbpgL43rKOcTGDcg8FsaAxW8d0HGqcw170Ujzm+rmVHO4s0SlxAoqk8E5wokZzgSqWaaRTaxAIpiby5XQhtFidbL8ArIQZiIFFmF0HWkACARjFHF0fmyFlXYV3oK32EbVxR2b2Lx/KRtY3wXQyuKcewyo3dFk9koxASdgqx5mVdlLqY1/BBYnhk9WjsYT3+s5RePx+3UucM4Sd+nf31QzIFFE/epKBmhO6MC5Rj5UdvltZAv3mSpu1jEQ4HWorEUDos9yDA6Kaw11VcFj1nReVL83vq0pz3ZwgNSuz1FKFjZOyRsQnvKcGOmiTB7sKCpBQ+rPFZMFascbAfUg5DaZ4wZ1c2BvFpkGwaf6+baCrMOjj+vPJpkkms5HKBt/bJ7BmF25AnvSIozhLxRfhx5OVfjEv21UN1S2J17RE5b9SjRd1bA2jYGJzZZoGQxlN/mfhfhQtckKwpPcwCNPZsXFZodUY2mepP8JoP8QAsPUqqxPzchhX5CSpBxEIFnUaViodUzxTExmYl0Du9vUux0eQ3IxrbssSTgnQNB0RPS5ENzRfxdL0ZfSX2QVYyhzRGZMv7/UWsSIpB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199015)(83380400001)(31696002)(38100700002)(2906002)(7416002)(8936002)(5660300002)(41300700001)(6506007)(53546011)(6666004)(478600001)(26005)(2616005)(6512007)(186003)(8676002)(4326008)(66476007)(66556008)(316002)(6916009)(6486002)(66946007)(31686004)(36756003)(22166006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3l5cU1lNkhTdDFRTlAzUnllOTRNQk9STTdRQTRUc1Y4WjUvQzB4NDd6OHlt?=
 =?utf-8?B?a0Y1RjJnK1JmWUFPT0RtK0JvN1ptWDhiYnFlNDVHNGJMYVpsc1gyOVJ2dEtX?=
 =?utf-8?B?d0lLQjdQSHlOTGRZSXAzeUdyR1lPenlvMm51dFcyR3FRSGxlUSt6Y2VlRktn?=
 =?utf-8?B?MUtJNnFsZnZMZ24xTy9DRVRDbWNNNTJGVEhPaEszSDNqZlExSEdzc2JqUUlk?=
 =?utf-8?B?Y1pTREd2ZWczK1pWZ0UzbTBzUitHSlo4bkEvSm1tczJjTGZwaWJYVWZwMDE1?=
 =?utf-8?B?MUZ6TGFMd3NwalpwbVJhRTgwOXlzTXEvSE9xZXpHczhIOWZYSWIyK3FQMWxW?=
 =?utf-8?B?bWFDN1U1TXNYNEF0UCtjL1JKVVFOc1pqbCtYZ3J3VzVLRGl5b3JxVkZDbDFp?=
 =?utf-8?B?b2ErUWZwdGpmcDZtSjVrOWhBVlBhSXM0NDRsQVJBL3JaZlVGK2xJSkZESUF4?=
 =?utf-8?B?THJkbkRVdkJqYUlFMFh6OWZEUGZvNUU2OCtUUkduWTllNXMwd2l6NkRMYmFh?=
 =?utf-8?B?WkJDR2tHRGJKaXNHcWdEcUVBM2hMTU1RbCtrT1Q3a1A1N1NSL3dBWm1ZbmNu?=
 =?utf-8?B?K2V2SDhaYmdwblBGZGdQSFc2Q0V2S005U3kyeERYYlZqbGJtNXhrUnhpNGdv?=
 =?utf-8?B?Tmc0NWtyNUtuR24zUWhOU1U5Z2VrQ1lzY3Jsc3JqM3NyODhWdUJIZ2tsOStw?=
 =?utf-8?B?ajUxMW12Zk53ZzVGK01VdDJRWjZCUEMwVk54MDluTU9HSXVFUGF1RXNsUXhk?=
 =?utf-8?B?bFVENW1ZZFVwd1ZZQXc5RTlmeEJ2M1pzR1NqenFFdnA0c1dXdWlwMks0cXRi?=
 =?utf-8?B?N1ppNS8rNHJTdjN5Nmk4OFVua1Uvd2ZJOTRmeHFwWnRXdGhOZ2pla2ZFMk9S?=
 =?utf-8?B?RnkxZ2FvZXhoaFhKM0J4cTNRRDZJT2UwWWJmYkpJdjQyNk1yanF6SHQ5b01C?=
 =?utf-8?B?b1pPNDVKdy81bWlvdHlsT1paTFVKWTdEMVlJWXBWTzZCck5XMGdZNDlWTG16?=
 =?utf-8?B?VVNnL2tYMWQ2VXdvNjBSdERnOENsaUM0d2txVStKOUhFVjFPRkRiVjRhU0Rk?=
 =?utf-8?B?M2RBS2JHZlNvNEFwVmJQUWwzOWhQWTFPckdGTzVzS3pWOWhMRzF6clZ2K2JT?=
 =?utf-8?B?YjQ5TjR0aXpKb2ZpbXVQRXl4NC9EbUxlZ2tnUFJ4T0pMTnVJT0FTYUw3dm5Z?=
 =?utf-8?B?QlNKcmV3NEEzWHAveTMyb0tlQ1IwQjRyL1BnOUE1OE1JbTFTaUF4akQ3dG5x?=
 =?utf-8?B?dGJ6VFVHSTRLTUVBeDdtbENGbkVHc3VoYTJWTGNENllzWTNzL3U0ZzZxalRO?=
 =?utf-8?B?emVreVFiNWFRZmtBYURxYlVFVitKSmZvSHZ4V1A1SklYMUFUMStMNjJYUjZQ?=
 =?utf-8?B?Y1N4MmdqS2JDU3lZZStMbCtJcU9xT0FKSmxSeXUrSE9NZ2g2RmE0N0hDSjBx?=
 =?utf-8?B?SnNpRXFKSUQ3NTdrc1crVGFicWp0VGVjMHVQck1FZG5zZHhmMGhRVEw5NGlW?=
 =?utf-8?B?MmRndFdLOWtZQ1J3VVlXQVRaZktlbENzd1o2TEIvajlKZldPb0lrdXlyU3V6?=
 =?utf-8?B?SngzVTNLVC92Y21WQUx5SVVPOTBLSWJqMlBiQ2hXL3UrL2Vaa2g0YlFaaytU?=
 =?utf-8?B?dytjeURvN042VU5WWlpuYmtCdzlCaklUNDIzTUxVZk1iUHRkYS91U1RZUzhw?=
 =?utf-8?B?TmRtY2NTemtYcHl1Zy9jM0gvaG03Y3krNDZBeDE3MUx2SXc3ZnFaVjlqN0Y0?=
 =?utf-8?B?Q3ZWMm5FUi8wWW1OVGZDSTdlSFB3VmVVb0MxcExjQ2pBM254ZEMyRG9vTzRL?=
 =?utf-8?B?VXVhSExuTUF2NzNsK21FYmVsSldiMGtBUHVlSGtSUjNNSWtPRENtOTJheFNG?=
 =?utf-8?B?d0VzSTdFeGYwNlV6bk9odGJSeEpwTUk5STBGcXhzczFZb1RDbko4clVpQ0JB?=
 =?utf-8?B?Y3J3NHg1UlQ4UDI5ZGpyT0UzN0dIRGJGZzhaNld5YnZZMWJhS1RkUlZFRldq?=
 =?utf-8?B?aS9RVnNLMFpaVUd0WS9UWEdWZXYvcXplZ3dISnR3bUxmMDA1THNIU1hWWlFj?=
 =?utf-8?B?QUdXbzZTakFhWmRlb3FJckt4Tzg5YWpFVENNS2pjTmMxSnR0UTNwN2hZZW1I?=
 =?utf-8?Q?FXIE4MVt5/nbZF6lljSWhWkde?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 718025a7-df9a-4476-8e6e-08daed3a3607
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 03:25:50.0290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Cy0PvkDhez8YtV6Bkfxvc3tac7diF1ZKaZgl78FR9Wb6WH3gfp2zmauQptBJayYk61++nYEhEhCbnHYPW0fqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5634
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/01/23 01:12, Borislav Petkov wrote:
> On Mon, Jan 02, 2023 at 08:50:23PM +0530, Nikunj A. Dadhania wrote:
>> I think the "why" part depends on the user. Whether or not the user needs a
>> certain feature enabled for the confidential guest.
>>
>> If the cloud provider(hypervisor) enables the feature on user request, the
>> guest terminates with GHCB_SNP_FEAT_NOT_IMPLEMENTED when guest kernel does
>> have corresponding code/implementation.
> 
> I think you mean "does not have" here.

Yes, that is correct.

> 
> In any case, I think this whole handling of SEV features could go both ways:
> 
> * Cloud provider could say: we've enabled features X, Y and Z and if the guest
> doesn't have support for them, then it would fail booting.
> 
> There would optimally be some text sowewhere in the cloud provider documentation
> stating why those features are enabled and thus required to be supported by the
> guest.
> 
> * Guest owner could require a minimal subset of features which must be present
> in the HV in order to even boot on that HV.
> 
> Of course, I'm only speculating here. How it ends up really playing out in
> reality we will have to see...
> 

