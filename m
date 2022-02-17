Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1524B9757
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 04:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiBQD4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 22:56:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiBQD4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 22:56:02 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E083E2A229E
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 19:55:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4OUMf/BUh+aUfZugB8xf/K2tNJZNnWinLf5tL0TiVV8FMtfjssPzjYEhpTuaHqR7IDDvF53dhewXysxvKvZYQuJRAVYbER0m1P2CL1Oi0DioWQj968sl3wvU4djw3KO3lHe3JOc7E8UlUFa+5a5c5eUDDesj7opZt3wJ27deodP918OO0muLn8C8m3b87yiNGWYZV3O1pC/v9lwa+RZDm7Olt8jgnbewI3h/rFVwHrIkRN6WSvQyWJHsTEe8vYhQn2hHkxg1LuFQKscOvkipgZ2f3bcSln3eOERjRX7ICiy3W4nqqFJNqijloe+MsOfrLDgD4KDQsDJswMg3NXJtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UnmEr5f/F+9RvW0osmzvKMjMOfPp1+eOpcLO1tuz/I=;
 b=NTokVwrEP+4+Ylm1pnbzZxiR+SsWoFG040WYrhJ3iV2+jx7eRLzFD07zgaIptmJdRqXE6ybL9/aR7B67k3TWrfkJTxEJGOWu/+Spmn2uFSseeCUgslX2/mgNzgOhDZmpQ2F/Z8S0jCf89fnIgC5vJPZRwpH+7H+ry/NnEbv9Zo3WV4yD/Zaj1V3SuyKY85TCKWGVgTG6Lbaof+uUoOaNPrDSL+1Cw6xl7So9Nax89/OUWycIumD0y14Knr2MR2e7Woz7uT0VM//Na7EopL+V8yMP9NLeV7j6zXlBAWVwR284X80kuklj0sSCkOeEkKl9KHAhdavn2r+3cLkoJJTomw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UnmEr5f/F+9RvW0osmzvKMjMOfPp1+eOpcLO1tuz/I=;
 b=eXE9Qu7KPS6L6wW4NKe9Sd2gQzTEToajZi5Pk8iZDXuomiJhlPvODC89P/+EI3tMW3G0+NPOHoZ+++Z1eK+cghLc+EOuXWA1/HzG5Hzk9Sd63kEHmpgxZ8EuILmqhTdA8s6goWkiaDSyA2ysPI6OBEfLJXRGhTVImYzRCeXRgu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 03:55:44 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c%4]) with mapi id 15.20.4975.019; Thu, 17 Feb 2022
 03:55:44 +0000
Message-ID: <e9eba920-9522-6a56-4293-b60c0f1b77ed@amd.com>
Date:   Thu, 17 Feb 2022 09:25:31 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add routines to set/clear
 PT_USER_MASK for all pages
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, aaronlewis@google.com
References: <20220207051202.577951-1-manali.shukla@amd.com>
 <20220207051202.577951-2-manali.shukla@amd.com> <YgqtwRwYbJD5f9nA@google.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <YgqtwRwYbJD5f9nA@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0060.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::35) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55d2d629-2117-47f1-4f08-08d9f1c95f85
X-MS-TrafficTypeDiagnostic: SA0PR12MB4430:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB44306CD70701575A4E9A29FCFD369@SA0PR12MB4430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQZzdWt/0mDxsRIi8gYwLC4fCBQXeHEjOMKGRueZZtCjK77KfnSoAMSXXmgRDA4cR4A75w1AgzAAIj+SCPxltnd8PkLOAOBOJBRvCbp7bpn5kfTjcYCvdq2arniRKIU3BGo+uUc9LH7nUUkv0AdBSOgRjQWBE89e6BMy7Zsx2t5VkiZtSRVrOa1M/ueWXjy14CGM/SExnc74zAb6zN09X10UAWtdydF9rOksswn7ja/n/B0pXf9KDKzUWxmalY07hDpUPP2K4y3AYmBqfjYOHEoqXxyNZqYzg1ukreq5M5kG8HX4eI6f7RCAkmyWwDU5sVbOFsmnzX+0SjuX0or3coSDae0il2MvPEOfqrrcyC+9H6pdaIz/NszL2Artknvv3uJ3H7f3ZUfvMVFZ5zmuXs3+a78vYFl2R324du3ryuN2BQQqMM5B3oGmPpS8n8z/6pwDAFpta1UDKB2xXloDZH1uJ+9RM+avABusI3f057eNg3SEtuTy+kKc6znkP+LqPMYKAROxyox8RNDqOFsdBLLKa5mlRg9azF64h5msWSooNXbH6DczU7hBx68nbs/Sh+sTEr6ucCmWd6E9wYdZMiYIu5iJTBg+AIY2ojwzfm731uXP+d7xgs2UaC83HJg16Aqgyq+2Z5vDVtOmtIi0diNvv3LFiNAOkct0K8dP4pkYxD+DhPSS7uFLaFk2HGjddBDyfciRtmPWnyQTgpHj9ebSP+gQhPxJmkd9x5iIEsE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(4326008)(8676002)(66476007)(66556008)(66946007)(508600001)(110136005)(6486002)(53546011)(83380400001)(6636002)(316002)(2616005)(6506007)(8936002)(5660300002)(31696002)(38100700002)(2906002)(6666004)(36756003)(31686004)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0JCY2s5aDFpbC9zMG9RdEtkYkpuMTcrdGpNZ0tQV3oyb09FMks2eHp2UFJS?=
 =?utf-8?B?dlh4UkhrYWFxUGVFMTYxQmZNMTNvS0RnN1RZQlV4OFFPSFZaOUNFc1RGM1gr?=
 =?utf-8?B?NitKWkxkNEJQYjA1cWI2a2FOYjQ5VXE2c1VvcTlQN3Myc0FTeWFZOEN2SUFl?=
 =?utf-8?B?TU5rcWM4MTZDdzkwdWpXK0JCbVRqeEMrdW1yUThocWhkeVNmS2tnNDcvbWJZ?=
 =?utf-8?B?cm5YL0hoRlVHMmgxZnl0MVQySkREelY0R0lVSE1ZeTdQQUhqYXlQdFZyL0Vn?=
 =?utf-8?B?cHlXWU9hQ1IvV3hESVYrSG5pcmhwRGNSNjRIRU5NZnR1U2hidTFRdlVsOGJF?=
 =?utf-8?B?ZXZvSjZhK0RndXRZNVJhb2JvdzczSlM5TnhaQUdkRDJnN3VZbHJQVU90bW1B?=
 =?utf-8?B?a2d2SFlNZHQ4M2FTNlg2czkrSFNIVVpKZDlMNC9hRnB2YUNySW1yZ1hLS0dH?=
 =?utf-8?B?eDRqeWdaTFl6MVNYRUFhOHJnK01pekpSQzBNdDFaYUE5b1RDbDN5MjdUSGk5?=
 =?utf-8?B?QWJ4SXRFK3kzWS9GcERQMGVTejUyR0Znb1VVa0VoQUF5dCttOW5uZ3hadVNu?=
 =?utf-8?B?RFo1d3psV3Z1c2M0YXdtNUlzeEpZWTF6S0xSUDVNYTZvMVF1dXdMZVhnOGhp?=
 =?utf-8?B?eXdqdzhBQ2E2OVRYem1aMjE3S04wTFphNXZFVVp6Rm9mRHRGVm1Ta01lWXdR?=
 =?utf-8?B?VEZPNWE3K3R6SFdsOXFjMXVNR1MzMDFINVpDTitDbWZkdHEvclZHeTdJcUNm?=
 =?utf-8?B?Um1MOGpxblZOeVM2dy9vZUhoejVJb1hNanM2bC9KTExPNjl4T2RRdzdJNFkv?=
 =?utf-8?B?bUkxd2IxQnJlWXptUkt3SzBuZG45UlhhV2o4QWF3L1B6N2xaUEdTcUVvOWJP?=
 =?utf-8?B?UFhZRXhzYVF4WkFieEZGS01CTitrRnI2eHVrRE11L1N6UXd0NWdwSzVCUlNS?=
 =?utf-8?B?UnNNVitSQ2dLSFlOeFBDYmNnN2h1SGU1YmRSRUZsSTgxVCtYVjRuMGFDSHBR?=
 =?utf-8?B?MVo2ck5ZelNUSlNodjhUSTZaSzZqUTMwSFp6cSsvZGdHTkZrcHZOM0k3OTc0?=
 =?utf-8?B?Rzkzd2tIREoxS3NuYit1dkNNblp0MURKdUl0U3FzcDVpYWtHaDNKYW5YSEdL?=
 =?utf-8?B?bzFOUU03c2tlQWgxUzRPcXFLZUlwT3hGWTFpUkRGemo0dm1LbjN1L01RaEtM?=
 =?utf-8?B?ZDdqT3ZXWWZ0TXNpcEhFNWtpY1R1MXFDb1JPM1lTM2Vsa3hPOEIvbmx3MkdK?=
 =?utf-8?B?dnI4d1RYUTVoVDhYTHhydzcrSWZMVmxDUU5BOUd2ZmNGelp2V1QwVmpWZXZa?=
 =?utf-8?B?TmpuZDVMSkVaVlhVSFZTVzhKSDMrZjVNWGhSUWRzQjMvZnlmdllVYTAwWXFH?=
 =?utf-8?B?amM5YXRuVGR3L1dxSXQ3SS9FNnNLdWtVZC9BY3lXbUpSWmVsTE4vTzhrWGlT?=
 =?utf-8?B?V2xxeXJORDBXRlIyQnRhRkJLRWVmQ2lZY1Q2K3h3Z3BiYmMrVDQ1WTFTYTAw?=
 =?utf-8?B?dVMwNklRSzgxRmRMekc2a085SmU0YXZYRDFPTTVoUFVEVmRzTDFWY2pmT0Ny?=
 =?utf-8?B?ZmVRTHlhTHhEdlVoRlNTWXg3TmFLZVdZZGtEaGhBbGVMU2hJWkpzMDNKV2xU?=
 =?utf-8?B?VUQybUwvUEdTVS9VREFzemJ5bHFhWStoOGNneHBTSTlYWjFhT2tiZ3ZVMVJY?=
 =?utf-8?B?L1BkSkpic1psZDRBYldPdnMyU3FsTmhNY25WQTJlMG1rU2tEMjRlY2l2clZp?=
 =?utf-8?B?cnpnWHRtM2ViUHBRdmJIYmVsUkJ1VldzRWp5VGZFM2M2WHdYa0JWRTl4enRI?=
 =?utf-8?B?SDFqQkRhUjJsRGo0RWRobkliajVSSVNTVEF1dHA0NGY3QytJbEZQTlVIei9x?=
 =?utf-8?B?V3hTQVdzUWkvQmdFZ1lMUFJMdklEYVRhWUZ5Y2ppVXpCQXBQSG5aUFlRcGVU?=
 =?utf-8?B?SkdQMzJpMkVmR0x1c2ZSQlBmUVVBWWMrNXZZS3pYQXhFZFAyR0FoN2NvTHZ2?=
 =?utf-8?B?THdoTW00b0Fnd2J6eVQ2bEJyRmFSUUN6ODEzTW1peDhlLzVlZkpHWU1nYTEz?=
 =?utf-8?B?RjFELytsUWxxelBJUzJjbGNMT3JvTk14Q1JrUlEyTnEzZ2xMb3ZPRjh0YXJE?=
 =?utf-8?B?YXZvNTUvUHpxY1BtdDZzN2ZqQ1Z4ZS9GRWQxK21nTHdRajNZdjNwTmNIZzhC?=
 =?utf-8?Q?0uUAw/YV1pKtbkGN19SjFTo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d2d629-2117-47f1-4f08-08d9f1c95f85
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 03:55:44.6833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MhbtWdosS416FZ3a02q685pnbE1hGArTeHUMwrB8TGHmNSathL0+Xli11uLxsixMiBgEipe97Bz7h3N1P52CYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/15/2022 1:00 AM, Sean Christopherson wrote:
> On Mon, Feb 07, 2022, Manali Shukla wrote:
>> Add following 2 routines :
>> 1) set_user_mask_all() - set PT_USER_MASK for all the levels of page tables
>> 2) clear_user_mask_all - clear PT_USER_MASK for all the levels of page tables
>>
>> commit 916635a813e975600335c6c47250881b7a328971
>> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
>> clears PT_USER_MASK for all svm testcases. Any tests that requires
>> usermode access will fail after this commit.
> 
> Gah, I took the easy route and it burned us.  I would rather we start breaking up
> the nSVM and nVMX monoliths, e.g. add a separate NPT test and clear the USER flag
> only in that test, not the "common" nSVM test.

Yeah. I agree. I will try to set/clear User flag in svm_npt_rsvd_bits_test() and 
set User flag by default for all the test cases by calling setup_vm()
and use walk_pte() to set/clear User flag in svm_npt_rsvd_bits_test().

Walk_pte() routine uses start address and length to walk over the memory 
region where flag needs to be set/clear. So start address and length need to be
figured out to use this routine.

I will work on this.

> 
> If we don't do that, this should really use walk_pte() instead of adding yet
> another PTE walker.

-Manali
