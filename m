Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B3C4C1575
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 15:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241605AbiBWOeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 09:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiBWOeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 09:34:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46C1B23B7;
        Wed, 23 Feb 2022 06:33:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMNFQM7cNDMAmx84xjH5UnJ9naHCyU8sIT6tSs4PE2LcjWD7mko38TAyNlSOGDxqblffvNNcsQkr1qYehyTsniDJtF1uUE9LVEhE0NXzWS65dOTJkThbZhXgRzJs6kw+GKtK0e4bQsirQ7lKowc+pzHGl7VLhbmGoqIp+yE9dPfpB/hy5Sug8Xj5F9aNCdy4nC5QWYe+Ti18eFLxdeelL/CHQhhfbYADFH5j+ce88nAYzbDwNnFmZmqDJVE3AkbpQvw3ypE39bytyL5X4Twkwuart9cpmtZIw3fqYSZndn1uwu2APMZE0MergXrxSUsJUZ3FZk8pehC9nYrhPo186A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxOTPNckQhhecBkPFe8Y39SZhqrTihM3oxUmnzrAVO4=;
 b=ZIDf0tPJxev1rZKztNUuS3Q3nks/7B0Q+8RiUtna7ObWdod/obYo2NE2zVcaUeR1uiV/Ors6AFcCBLWKkI4/4fkiJnNIlWuMnRVz1MQEGyIh7rToEWuH/HTtgEcAVfUpMi7jSrJmH8saEGyAxstE4wSVdwmsb81qt6FGE8jqS/WWSZis3jN0AJl6ZrMMPtuNbko1GtE/9IQ5UqNTmLMo3t0ZdmqqTVuAii+BfiTwck0Zb21V/zw91RcnLJOn7cj3xj9WwOqHsYif+/LJHGYIBhPAlsoebOjZdOs7++2XtfpATwN/UKWjkFlt3cXoGA4SBP/Ff0qazD7YylsKE9MO8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxOTPNckQhhecBkPFe8Y39SZhqrTihM3oxUmnzrAVO4=;
 b=NwMdYwdbzqjG63WAscsZAuIWk091PfABLxcRpxkMFv4UdEgyTTOTPWjNor5sP5MSALXCeMpte+GdYwAfafEZWhagbM5H14zFiO5Zea89ASN8WctmJZTJalcZX0Qifh7VYIaTvQf0Itn65JsE+L2lB7iBht2N2IwjabqmBAf4mEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by MN2PR12MB2974.namprd12.prod.outlook.com (2603:10b6:208:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 14:33:40 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::500e:b264:8e8c:1817]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::500e:b264:8e8c:1817%5]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 14:33:39 +0000
Message-ID: <5d16902e-829d-36d9-8d70-0cbe1c8f3408@amd.com>
Date:   Wed, 23 Feb 2022 08:33:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86/mm/cpa: Generalize __set_memory_enc_pgtable()
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20220222185740.26228-1-kirill.shutemov@linux.intel.com>
 <20220223043528.2093214-1-brijesh.singh@amd.com> <YhYbLDTFLIksB/qp@zn.tnic>
 <20220223115539.pqk7624xku2qwhlu@black.fi.intel.com>
 <YhYkz7wMON1o64Ba@zn.tnic>
 <20220223122508.3nvvz4b7fj2fsr2a@black.fi.intel.com>
 <YhYqqxaI08sOSPwP@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
In-Reply-To: <YhYqqxaI08sOSPwP@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0317.namprd03.prod.outlook.com
 (2603:10b6:610:118::12) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27035713-8b60-4242-8dcc-08d9f6d97bcc
X-MS-TrafficTypeDiagnostic: MN2PR12MB2974:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB29747ECC637E0225FFB45C43E53C9@MN2PR12MB2974.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3tdbADisemnRWGbBtg8zd4HC1iw8f7pAmQMq+kvoV7bxcXEXlJ96FlWzsvqjc2spDctat6bHhBKC6Zt39GLMVauNGteadDcmW6277QIhBaG5/x7jQKzWEDN5xle/PpnajNs3A1lJzsES14KmeyfIAnL6U8H3i5w4NA/PXUJ3Y9akI4bEi0MCsa8HNMdHqNO4+n/YVJlD8ytQsjDRRtAYCtLm5gP8kk+DSfMJtABJqxUPtkBbcjdkptkmol+kxWrIVpF7RXBrZW6oycVvxRJCk/WMQqvRs+N9Wf1s3EY9mdmdlLL7TfPnat9rLMsaQLKdCIX8Rz9lLIOs9fteVxbiKh+vIXp4WCbDf9OV7LsDqFkC4X59acR/+mMUL5Jdiep0ZfZ7LxXw9wtIXlXkDSowRr4E0XFtn4UD3vzh1jbS1tDyYu6XLhYrQkwtlbi2Wj8uLXvyY0e0IRzJJxtWynPt3WDDwIV/qVJI4D1GxWdqNXkEguOtAnOLBV6Bt16DJZNxwlIzOpPy2SjGHTaeJOohpWwp/EhXL0X4q4hhBegp0wfu7ew1EX8wN7nxkiBcQlTR04vffjEKWZCqhY8OV78t1Gr2cIOxGMDXmW/efPv/QQHBr8kmKnCuG6Uozk6YOQEUPV2PwXRmtk5Sde7/N1xoXf5O1D0UgfYE3mbch37sBDV5mLR5zLdR0r0t5+NGwOGk23gFpIKoUe4MxT+hyo5SBzRvdMlSG2UDHHZTPeEDW/bJe+q4nu0CFcTg8VzLh2TC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(2906002)(2616005)(6506007)(6666004)(6512007)(31696002)(86362001)(4326008)(66946007)(8676002)(53546011)(66556008)(66476007)(54906003)(36756003)(4744005)(110136005)(316002)(8936002)(7416002)(44832011)(31686004)(5660300002)(38100700002)(508600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFoxNGtndVJ4c3cyUG45OE5iMUkwOXd6TFNWSmFzd3ZBV3FGQ3FmU3dqajdT?=
 =?utf-8?B?OGl4SDdqWi9YNDhtTnIrOVM4Y0dmWFV4UVZQSFdaWnFkUlpaS1krQTVhR1kv?=
 =?utf-8?B?K3pHMWswOEw4QVJSVkNadmUvZDNqVkV3UnhBTDhRRmYxdFlPNHh6a1duUWxL?=
 =?utf-8?B?UTRsdFNMaUpXN2VHN2ZkclFRTnl5QkRXb3c5YU1nT2hvM1gxTGlqdHVBOThX?=
 =?utf-8?B?bUszL090RmRueTRBamR1YTY0UWg2YmNSR2czbkNUd1ZVcTJYN0dTekZqaDQy?=
 =?utf-8?B?bUlmbnozbDFKM3hQbCtRTi9ybVBESy85UlBCSllJcTJvblpIVzZDa2xUVGtX?=
 =?utf-8?B?Qzc3UzE4dGsyNFRzS3lqdlRxNWJJY1FrYlVZKytpejFqUXdPb1IxNWNJdEYx?=
 =?utf-8?B?RnF4TUJJcWFXd0xPTlJkbk5HYUYvZlVobnRmRm82WTFxRkplR1RRUE5aMERT?=
 =?utf-8?B?Q1d2dUN5ODZ5MHJXWUZ6c0paaHlheWlVZVNQR3U1dS84OUM2WFVhWGF4bjlx?=
 =?utf-8?B?alRjbkFpYmFyUVl3eXh6Zzg0UWZRZCtETm9PVFgrMXFrNklyU1EvZFFYSDZK?=
 =?utf-8?B?anFqa1Fhd2JyQXRRbGRDbTRoVFZ4dUtMQm5ncHV2aUp4djMwR3BkNkJHK3l2?=
 =?utf-8?B?d25oQlpna1h3R1MrTGI0QUFkV1p6WlFzQVFvZ25BbGpOaVgyZ1hCc0NSeXlT?=
 =?utf-8?B?RCt2Zm1MODl3cG5uaTRWS1owYjRQVFc2VFRORDZ1YUFROGlPNXBnamN3dW5G?=
 =?utf-8?B?UDdIclJxMGVMUzJKOGdUc2h3bHpsQTJpTXRXa24vYndyL05ySnB5RlpKSGl2?=
 =?utf-8?B?NlB4bStyTlVGTjhrMThyTUZkZ0JGZVJvcTNqYWRqUkpoT0p0dExqOUNlTW5u?=
 =?utf-8?B?QXZvanpidmVzbGxFMjl2VllscE5xc3g1b3NrM0Z5djd4Y3NqUTdDYnlpMUFw?=
 =?utf-8?B?YldKSHJmRHpzQzhDNDhuQWhSVFI2NWtkRGZHd09DT3JQZmtGeVZicFlKY1R4?=
 =?utf-8?B?Smo4VWFSYTN0anhjM1RqTmFheEZwSUpXVzZZMzc0YVhXNnhZUUpRZFI5SElR?=
 =?utf-8?B?TVk1TmlvTEhIV3pXR05Qb1hKbnFOMGVwd3lHczhsWC9oRkMwVlU4UmxIWllq?=
 =?utf-8?B?SnBlTDJ5T3djL0VWcGhscGM0UDFacUJGWWtVa05reExsU0cxMnA5WU54OTJE?=
 =?utf-8?B?UjFsUFplOUZ0dVNPSUJBWUxVNTV2cjFyOVJqUnpaMG9Tb2J4S0hzYUJFMHcx?=
 =?utf-8?B?QUQ2N1FaSzVqYjNGME5SeUU2c09XWW9qdVdua2I0cnlYMTVrV3ZSTDlKUFR1?=
 =?utf-8?B?aEttRWF4bTVmL3g0RVVxZTEveFRKRHNIaVdwalVkdlFaUXlrYlo2QkhZSlNL?=
 =?utf-8?B?ODZudEVYWFlCM1NpZm5pYnVkV1NGV3pvek10OElsZEo0bG9aK3VZZDk5ZlJY?=
 =?utf-8?B?dHl4Mld3N2NDTFhYSVA5eXpSK3BTNzg4TWx1TEpUa3J1bjIySkI1eDJSaThX?=
 =?utf-8?B?b0lIaW5SRjZ6V0ZvYTJ6Vjk4Z1ZhM2pveksveXJXR2U2eFRnMHRMdEQra2x5?=
 =?utf-8?B?U2hBazZ3ZHlKejkxK1dudEl5RjAwbE9XQ2lJYzB3WmNmTC9jVEh2dGdQL0Vs?=
 =?utf-8?B?TEdKNXFCdHArcXJCQjFjSWMydk5KdXR1NmR5ckpmOXJ1RDl5L1JnWHdleERq?=
 =?utf-8?B?dGtvWDlhZnBMcjhyWGYwQ3JWSHVMaWFMaXQ4bkpWZWc5V2xOTTh2dVM4dGtX?=
 =?utf-8?B?UEdUYTFueUNZQmczUE5ZNUhZcmlxanJHWmdEc1RhZW54UkY2UTlSTmN5Y0RP?=
 =?utf-8?B?UG9YNlpZaUdDT2F3a080Y0h3M1l2NWZ1Qi94amhTeXUyUmFPcDVWY2tYUnpp?=
 =?utf-8?B?OHFMRzluVU9uVG00eWNGb1ZERVdQWkRqT0wyTkc1amdjSCtGV2dkMmE0SVQx?=
 =?utf-8?B?S3I1STJnS2NyK0wza29TVGFJb0pxUFpYUHpka0xUK1Fwdk02VjJkeTNqT1cw?=
 =?utf-8?B?WUhrREk5cm1WSEhLTjJEOW52YUdKeTBhOFN3SkIrZU5DV3JWR0QzMHlLQUU5?=
 =?utf-8?B?aWVqNDFVdWdXQUhyNjdRUk5ZQ1NYSjRMOWdCV1IyT0N3QjZ5akRpSWFzK3M3?=
 =?utf-8?B?MXlKZzNxQVgyanc2cGVrL1FDTFIyQkYvM096dE5ndVNYTHVFVW9VU0p3R3NC?=
 =?utf-8?Q?ZqFwLgT4jVTho5Nsff0dQXY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27035713-8b60-4242-8dcc-08d9f6d97bcc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:33:39.6850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29xjK0U3prpmN67vCUKVbv91qqmLX3BoQhYt5fKSyUTRyS+Edk1Vpqp8jGuwNx6zf6564dwnxz4LMaI0dWm65w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2974
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/23/22 06:38, Borislav Petkov wrote:
...

> +static void amd_enc_status_change_prepare(unsigned long vaddr, int npages, bool enc)
> +{
> +}
> +
> +static bool amd_enc_status_change_finish(unsigned long vaddr, int npages, bool enc)
> +{
> +	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
> +		return false;
                        ^^^^^

We should return true otherwise set_memory_{decrypt,encrypt} will fail 
for the SME case.

thanks
