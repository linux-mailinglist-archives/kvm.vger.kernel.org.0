Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F87251B6DC
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 05:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiEEEB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 00:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiEEEBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 00:01:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760EF25585;
        Wed,  4 May 2022 20:57:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzfOrMOXlcH2GZ9K9+paPJvAvRgxGxFxY2EsiqP8BxphT0NFwNh5oIFf9tUZTla+1leZrxYBRc3BEz19IFiJZgPhnXh3F8yGPNOswj6OydNZ1nS3OCmfcFsAfQYp/rIcNiwFXLmYEOxlduKFZlI/iKgLx1Edcb5nnxWmtX12XrPhm5o06TBg3jDDfQeCpFNLmGInHxbIe+v2wRqYrUdyHEo5lyxsOfo+qByvRwmHSpVW/NvExozKB818SUCdJt+NID9nFM2++7HkpxmNikvDv2ipHsO5JGfb3KCSAs0R2avcK7ddjID1gk0OqXexly/R1zLQBCeIPDZlWmwpMIdCbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yYB2Ia7dPQQfndMkJYgBI2n0WrVAVCUXmG+edTMNyw=;
 b=eSzII7A1HzeJkLZTGQCwnv4hALiBq+Toom71uiN8arwYMkccTDaFyv4rqEGJNmlt1LZCd4wguunJqkn8AVf24vJQgT2T/24RjvJtt67grQOzzedCrWsQw/rc3gMz5KmiyTZ61fCB6J0OJVql9UE17O3iJZH7xrQcCRFB9uu9lZZPlVxTXv0X1ZRS623q9fEbKB57nEcKnXXqtj/iqKOVAU3NM9/r/K5hCGGs9Xyvz54ogZXO1L8Qrr69Fw1pn7Ky6kAyFfYaWIk6aB5sf46wZkDVuqWarnSTOgVZ3xOyQcl45AUBsceRU5G/Wyaa/fAheNbftQcckB8r03dfvZHT9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yYB2Ia7dPQQfndMkJYgBI2n0WrVAVCUXmG+edTMNyw=;
 b=fKPLkk0dTPzaCEFTtRFZWdVYsTLvVTMwpZ6B+tXQxwYYvQFasfnmUmLeJ7m+Tbz4s+IBDTFfBxEu0TnqSM99QY0fg7NwCV+Lx08HISxDxv2RluSLfXdK5YycZoU80zvQZDWh2ToHcCtqkFoMN+Tj3EKfI+c89NsDkQ2JwPsQW/k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BYAPR12MB4630.namprd12.prod.outlook.com (2603:10b6:a03:107::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 03:57:45 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b%4]) with mapi id 15.20.5206.024; Thu, 5 May 2022
 03:57:45 +0000
Message-ID: <a5f0b098-234b-7044-c6d5-ec50cff74676@amd.com>
Date:   Thu, 5 May 2022 10:57:36 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 11/14] KVM: SVM: Introduce hybrid-AVIC mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
 <20220504073128.12031-12-suravee.suthikulpanit@amd.com>
 <fe7cd5012445a941cf55ea82871ea51157490aaa.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <fe7cd5012445a941cf55ea82871ea51157490aaa.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0146.apcprd02.prod.outlook.com
 (2603:1096:202:16::30) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e90ccb9-3a9b-479b-e520-08da2e4b6932
X-MS-TrafficTypeDiagnostic: BYAPR12MB4630:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4630E1319AEA67AF63D6B810F3C29@BYAPR12MB4630.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ry9ytJVAKrjI1GCEaFQxwCmChe5CRg8f2Gd6YX5c5tmf7HFXvGiIF1RWdRF1e8fjrydD2i7R0q/lZSRdsZ+/+3a22xfBozwLTENcl44eQrFBIwFrRh+yxOOgSkyqFRdXtYNs65LIfMGnA5lXiIT/CDLW28dsa8HFwFx9Lv4a0bB9qdZsN9h/8i8OFT9dHyYuX48HyjX7h/F3GbzQ19uoUGyeBNYXfhs5lCfMWbVCXYaL/aVgSN01hcxetC1CD1QD4D5Tz3/uAN8GbziAtvTfw7dRISA6B5vJzVkH8yvRDUXyOmNNjyhOwlqrK0oER5Lc9aK+60cv4FPmPBaMoKcil8iFZLeESY7ZU71xQOQ1fE4S/eKOqI40pV5PDBHV12xUz5NbC0HfIqXgzdi6EbDZV9Sgg3dcQLGuEn1d8/4m9l0oDZT7UcajfYbzUjlM6rln/2Bkp1GXtKHT4Q2H9setHDEexHcoW++Rzn3flMtcaozc+TwHLzn3m0R3oY61jy1y5Gr1nayf8vaxMCE6dlGliN3hGazAeP4VIffN5UYTUHtZFPqhs4X3n4wEUMDPbXAQjTL28DVnFZfcy1qsUcrAmVs4NkhsDZRSTgbgASqfgBSGOewBazMCdGcTgzp0zdH22Ldzf4xexIm0GKdz0lFJfitM7w5NZHflKKUeunLeRhQI1JrmG8awWKV9orRpoeaCWKMUON5og5Ixo4bN/Cg2/NZoqiLHbvcipN/E5FIxC2PP0fQRmIzqAgMTRV/x7ppd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(508600001)(83380400001)(6486002)(6666004)(31686004)(2906002)(53546011)(6506007)(186003)(2616005)(6512007)(8676002)(4326008)(44832011)(66946007)(66556008)(4744005)(66476007)(316002)(5660300002)(31696002)(38100700002)(86362001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVJTeUczeFM0Z0d4MmRVd1BRT3o3ZDdaNldiTGYvQWdkS1gxclpSUldiSDE1?=
 =?utf-8?B?dGpuVElmZEtqMmcrSjcxVk1tMU9ZSzYwMW8rUzEyZFB6RDdoditpdDJ6RFpO?=
 =?utf-8?B?UlBRa1VWajZIYmhjTjl5TjR1cDhSZWJWaDYzc2wwNExtOEpaT3pRek85RmVU?=
 =?utf-8?B?QmUvNHh6QTVBOS9ZMThhVC9jYTJpaFdXREFNKzNYLzQwQ21kREJlUWtNeWcr?=
 =?utf-8?B?c0pUYTVkRUxQb2M0bUh6cERZam5RZFdrRUJuRG54Mzd1UlpSdmgvUG4zaTk1?=
 =?utf-8?B?OFMwcW1KV1VGTjFIT1FYSXpxc1g2empzMDljZFFzSExSbHkrSHpmYWgzNUk3?=
 =?utf-8?B?eFI0SkhWQkFLWWxjMXpZcDlrQlk1aTBHdjlEK051WFJRamZkYk1XQ01JMGJT?=
 =?utf-8?B?Z3pXZHNCREs4SmlNOVEwR3BvdTc2dkR1enhCS0NwbWNJVFkwZzFFSmlkT3Bw?=
 =?utf-8?B?bUtNcmJYb2xoYlVucXJUOUtDakEvY2pFRnlIbDdqODlyS1o4NE9ocGZMUnpa?=
 =?utf-8?B?WFdLTVdLYWRNai9nU09Td0VyaXFHd1ZxRkluSHZpaWhzSFhhQkJCUDFoMVJB?=
 =?utf-8?B?OStCZUhwZnRUK1B2RlhoRGI4UFYxSW1JV3FoOERFR1lLa3Z5T1YwQ3pwcXJQ?=
 =?utf-8?B?RFh4TFVPNFFXTDNYMG1rajdKenBOUGcwblRsT3BrZ1hjSVdObEUyMjFlTkdh?=
 =?utf-8?B?ZVhTTHpJME9EUXIxK3BmWGh5MUI4TExaQVJnS2hoVzJkbE4rSkJpUUxpYWxY?=
 =?utf-8?B?amxwYnRXVGt1a21kRnAzMDJEbnRhU29QLzVDaDcwWEpVY1Q4dFMrTGgzRlQ1?=
 =?utf-8?B?VGpoOUVZNHZnbktiR3ZDcmRrdmRUZzM0Rm1Qb2NiVnE3dFo3REwxdWc2OHBp?=
 =?utf-8?B?djRzTGZJbkE0Z20zZDdxbUc3ZmFRZFhYSyttRlB5R3FTZW41bXMySnFwZytT?=
 =?utf-8?B?dzE1S3R0eVFDL3BMQWovSXo5c1JXQUFJQWh3RktDdlBON0dlajdrMDRRU1ZJ?=
 =?utf-8?B?ZUNNbEZKeC92U1ZPOUtuZURCYWQzRHFDT25UVlo1aHFPQzBXUFZBWnlWR1BF?=
 =?utf-8?B?alF6cFF3bkZWQlBOSzNzUlRlQUM3Zk85ZVFvbzlvc2srcUs5cVNmdUNJcHZK?=
 =?utf-8?B?Q3JnLzVkZ2JubkE3WjVUN2ZyQlZlVlI4SDZUZFU5NjVRWTZjeFI2NjNJSWdB?=
 =?utf-8?B?V2VPOExMYmdUNkVFdk0vcHlHT2tFR1pzZHFRQTNUR3NLQVBCZjlqWUxhcjJQ?=
 =?utf-8?B?bGZGT3lzZVNYMGVTVXg3NmkzeGlFekpsRk5sZHZ3R1BtNCs4ZDJObnZiOVFv?=
 =?utf-8?B?QzlqR0phaklTUFQxMHQzNzNNUGd3akozNCs1cEpvdEtNRjBQNFBKalBiYWY3?=
 =?utf-8?B?NUFGeEJRamFpOGtjbktkQzFxTWg2b1doeUlzMDl4MEVUZGoxRXd1YVFKRlJP?=
 =?utf-8?B?QXV4eStvUGlwWjc3Z0pFNzUrYjZDMEhEdFJzVmJYaUNQUWlDU3hHZGZucWMy?=
 =?utf-8?B?Ty9neXV2UHhNRXdQbW4rVFlGbjhvT2lyR2prZlpFOFc4SWp0NnprUjNNWUQ2?=
 =?utf-8?B?eVpBV0Q1aURYbEw3c3hyaVI4d0pJUHlxYWxDQU1XbnVKclFvLzJkWnIzTEpI?=
 =?utf-8?B?MTJ2dHE3WTVJRURiSnFBOWJpQk9SNDdtWEwrRWIyODdRYXJTY3NldjlDNmRB?=
 =?utf-8?B?cXFrSE5kOVlkNTFkL0dWbFM0aVI5ajZUSG5IYzVZV0QrcUNwckMxaEhRVnRZ?=
 =?utf-8?B?YjdvYzlUYnlkelBlbDZHV0JEQnZnUVVYUlp5R0Q3UCtEOEVZOGVQMEdBZVM0?=
 =?utf-8?B?QmE1bHdiV0JRQUI3ZG1XM1Y1VTZaSDBDYWJJNkxaaVltNXRYb3VOcGlUTTBO?=
 =?utf-8?B?bzhzUm0wbjZ1b0pKOXgrekFUTTJsWmNVS1ZlY0ZETWx6cmw2ZjhFZWt2QVRT?=
 =?utf-8?B?czFkai93N28vYXg5M2VrbzNXaVl1TmdEeFZSQjNUZG9tSHZEZ3RHSTJZeWw1?=
 =?utf-8?B?TE8vdDN5cyt6WW4xZ3BRMGdMbDVLZ0Z0Q3FCSHExMzFJRXF4WEdRbjNDQ1Fl?=
 =?utf-8?B?OUsxd2tkNHpQTnhVK21QQkE4ZzlZeFJJTjVCWjhhRTRMRm5YMWFZSTB1VDdo?=
 =?utf-8?B?ZmRUQ2hQcUw3dnJMdlg3U05GRjQ4MXkvUGh1Q2o3WWo5L0ZScDZIWi90VHRt?=
 =?utf-8?B?UXFPL3ErdlpZOTB6Uy9Od0oxSFVlZFlQd2ZUMkRMNEhzWXVCVW9NbUJBUXB5?=
 =?utf-8?B?TGV4WkwxK3U3NDhaWTd6VmpSSkV1VjZRaDZVN3o2aGlqTCsxL2JHMjNnNHZQ?=
 =?utf-8?B?bFQ1VXMzdW1OczBFdkdVOGV6UUoyNHZnbWh1d3FueTBiSHpHUUpaZFNxVUgy?=
 =?utf-8?Q?C9P+G+Kag+hPnQK8JtLaW+C5Y+NrPdJjpcwcI2CdOnJS6?=
X-MS-Exchange-AntiSpam-MessageData-1: vv8F7zxPrUEXRw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e90ccb9-3a9b-479b-e520-08da2e4b6932
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 03:57:45.3088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A73C8usXs7jRGI5g4kr58k0ZCv1/n+TTiTxMnfpEDQkLhUS7EBrldn4yyr6C1T2WfcUoIooo0OxnY9ytBx6UkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4630
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim

On 5/4/22 7:32 PM, Maxim Levitsky wrote:
> Well strictly speaking, another thing that has to be done, other that removing the inhibit,
> is to 'hide' the AVIC's private memslot if one of vCPUs is in x2apic mode,
> although not doing this doesn't cause any harm as the guest is not supposed to poke at xAPIC
> mmio even when uses x2apic, and if it does it will get the normal AVIC acceleration,
> so probably it is better to not add any more complexity and leave it like that.

Agree, I'll note this detail in the comment above.

> ... 
> BTW, hardware wise, does 'X2APIC_MODE' keeps the emulation of the AVIC mmio, or
> not?

According to the AVIC documentation, when the AVIC is configured to use x2 APIC mode
the MMIO access method will be disabled. This is consistent with the Intel x2APIC specification,
where it states "accessing the MMIO interface when in x2APIC mode, the behavior is identical
to xAPIC in globally disabled state".

Regards,
Suravee
