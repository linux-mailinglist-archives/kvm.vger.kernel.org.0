Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134814CFBFB
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 11:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbiCGK4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 05:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237199AbiCGKzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 05:55:47 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8716EAC075;
        Mon,  7 Mar 2022 02:15:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHIKtMa3jMz2lwI1Pgf1uk32a//oQ68CdncXQ4ao0DmucfmaDFrRiinaDcu7S3762xfvAbUIzQpct20qM3EpoSLSVHOYuX/DCFppzmTHMhjNWn8JCdEtgrZfkjhJGOFLojr0FJFpQ4cImrmARWrekieMxnVpZvCPdTn4NM+4diA7r0huOloKOcJ9Vye7mIRow7CiEqTy4nKC1RrsCB2xBMutQg58Nd8tfU4zWSf4ztZgoaeAEavDfLXaOMDGPdd6FhuHrQmweJZr8LW1trFc7nSHLJlIupGMT8aY7IlA/fq61fvvG8Ng1QPudI6MQ6fUF6XqDnhGckEXCaQSrbof3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuXgtYsLLkdEh0cH+n0/uUpkhdbLSKgcPlGrDFQ793w=;
 b=BkfZp+ADwlKpN84SF2ENar5E15sGzfXQlqHGxERAPf45KHKNShSKieVlUi74p+MWfvWEUV2y2wOVhcLC+NnbkxhHwXh0x+Tz5SrkPdAnrIYJ7Z5tX+rHDHsghHU8EXL5Qb/4CecVoiNFvz+JiT445L8HAFd1HBCWmz6mHvwzydsatXY5r1pYPm0uSmoEvROSFQMYitJ+0bhex0hh7UFHuLehvM/LK/sLSiFGVgmI9qPocOcNKIAQUie86yXr75R21eLmiwYTQW3Mk3i+phNPJBcuv18TIHOZigi824lhL6EQjXHjjxYwGJFpfHYaiSKv86SKjfuW6ZUvpebF9OA/cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuXgtYsLLkdEh0cH+n0/uUpkhdbLSKgcPlGrDFQ793w=;
 b=0SSXrRoxSlb/vUUrKFjuh6xMwZTdLT8ewz1ZXJ5y6X9xBPzfy/X5e4wxk984Ck+IwhHFVln+lE7GgiKn41UmOQEDhwjt6gLsvxFmyjqAVo1VmRowPjC+014cRZiIO0UcTP5EhWkjETNAZ1E18RLVQBCXI0IjIyJg3lZECIUz7pE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB4633.namprd12.prod.outlook.com (2603:10b6:5:16f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Mon, 7 Mar 2022 10:14:42 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 10:14:42 +0000
Message-ID: <eff85326-9c0b-f470-3741-803018aa2619@amd.com>
Date:   Mon, 7 Mar 2022 17:14:32 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC PATCH 10/13] KVM: SVM: Adding support for configuring x2APIC
 MSRs interception
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-11-suravee.suthikulpanit@amd.com>
 <70922149247cfe2bfd59d27d45bbf5d0966c2dcd.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <70922149247cfe2bfd59d27d45bbf5d0966c2dcd.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0193.apcprd02.prod.outlook.com
 (2603:1096:201:21::29) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46c84534-2326-4b86-751c-08da00234bb1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4633:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4633399E6922B2453748C9EEF3089@DM6PR12MB4633.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvYYDSYYyr3cpsm6k3yD50VtjwgWQSck/MaARVC8f3jWWRxELPJocYeDO66RobTwB3opZkusqjGa2xk5qkrRvrrZUBTTVtlaXJZ2ZXnfbn3uOSfqvSCp0LZw76LqzMva2c58MH0MnndX3hGrnfjY41iSornH55x2XJZjBCoRw2RCZzpxCeN6RMW48ruGYoAT0tdBndwqvv/WhTxMELY6E+xwWUjPBGeWaCucIQWEsLYtJ+BNHoRhRu4Z6PR5E56nCoKh2aaAvsn8rN3zJTgCk0OFMlUO9t5QKewkjpUhSU67M3alv5Z5sbxeqAJxu/uMxrPnTaROsJNoV0nRfM5uEQMhYODa5EZplgb5JF8kML9rgnQbJ3J1aKVWRYDZo2ahPlYbSFJfIpPm7Pm4cwivClIFmk+IIuObMnL6ICkxaqnSc8Apmo9wgntV3yEnFqpUMUELmNPZAiPLB8vLkonEDdmpKK9Z1nWcAiQxPqBlgtFyB7L2k2s2kHT6NlVSif8KFIT4PWvCjJWGD01YElLsX0cL48edITX23U90zeSKcVKsJHmr2On2QonkbYy/vuNeFfAKGauMKH3XQNHWyYjC9Jm4hFnhcKCWwgpkvOJ+0519QspjUwt1Glx9e2Ap/+nAEM7+LQeX7E2c2krb8GpGaZdl2QfNr0O7XCMidmhlcE3NaxQNSNGilytwDu2tKIb+jWLp3Fvo8AVDEDDIifo+tcaPXqk73Q6UeCAGgUdToeg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66476007)(8676002)(4326008)(186003)(26005)(508600001)(31696002)(66946007)(38100700002)(2906002)(86362001)(4744005)(5660300002)(8936002)(31686004)(53546011)(6512007)(6666004)(316002)(36756003)(6506007)(2616005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnovRjRxZ3RtZURNUnZOdFBxdVNsbG9SZUxwR2RDMXhMWjh3cC9vcW4wMklt?=
 =?utf-8?B?MUlSaVRTdUt5VnV4b04rVFZlVzN4eFNDMHNJMHlOdjFmRE9OQUIxa0d5QlRK?=
 =?utf-8?B?RWo1dGZZMjF4d0dadUpPSFlLTXVHLzh0bnRQS2cyVmY3R3UwS2twOHFlWlh5?=
 =?utf-8?B?VnArR3NRZmNCQklEQ3RFc2NjOGR3YUs3MWI3TnZWRHl2eEl6K3UzYlVRb1ds?=
 =?utf-8?B?M1o0RjJESitsWmp0SnNlS3BNOXo5ZXN3OHVXQTducnNpZS9ldFRTcU0zRGkw?=
 =?utf-8?B?SmgrUVRrS2FJNjdGZWw4anNVT05EcU8rZXVIVWp6Y0REL0E0ZnNnd09NZVN4?=
 =?utf-8?B?cGFXcWlXTUF0YkJ0RXBKM1k0QmtOZWt4Vi9la1FteCtTUVEzN2ZLUk5wVUNH?=
 =?utf-8?B?a1lqY2ROOXc0d3NUZTZURFZkY3FiUFVTV0Q2clM2NHQ0aVJkKzh1VHo3MFpt?=
 =?utf-8?B?STBUc3dSditjYzc4ZUR5WkdpTjJjQWYvUWw5U1pmZzdLRXg0OWJDeXpjWEd4?=
 =?utf-8?B?Qzl2cXpwM1NHNWsydXlGc092b0xObklLWjQ4L1NKTm0vRmd0VE80YjlFUHVL?=
 =?utf-8?B?eDFsRWxjYzBESGF5eFl4SGdVRFVJc0hyaWZQVzFRYlJiZ3lxUFJvT0pVekdx?=
 =?utf-8?B?ODRhaEZCQnJvTnc5WmNXT3BKVFo3SmpkN2kyanNzTmg0dGNIcnZxOHNLVUha?=
 =?utf-8?B?em5NSDZQajdXRndFTmd2TEtRYkdOalNsNFUwcXZieDVnam1QSnFicWVSa0hX?=
 =?utf-8?B?ZG04Vjd5UjRLc3l4T1diOEdSRVd4blVPQzNWVEZMSm1wMEpEMjFxLzZZd2x4?=
 =?utf-8?B?N3dOK0JTYndkdGNFbkUwbGNaMWVnS09aNS9rOEVxMmJxUVdLWEh4VkpMWDJj?=
 =?utf-8?B?MjZWNit0NFBNV3RCekdnZG4waE9YSHZwVlhuWC96eXVsRm82Z0I0cmZSNUo2?=
 =?utf-8?B?ejF4N2o1amFmYnJ4SU81Zm1pV21TdXdORkpJbDh2WktyTUtka2hoYm5HQ0Jt?=
 =?utf-8?B?RDRMbG9FQWpsVXR5RUtaNGFKN3M3TmFlaXAwdmwrK2d0MmpxY0o0bFFQa202?=
 =?utf-8?B?ZmhIa1RLRG5MYVJqYzVRLy83SHQycU9Sb0lPazZ6Qjh0bUpzZ2pSSjl2a3Z4?=
 =?utf-8?B?U0QyL01kRnFyR2ZjRWVyeEdReFlFYVVHVmpnTjlDekFpVk5aMUdqK2lmOEtN?=
 =?utf-8?B?Z2p2MHhQS3J0akVISVVVRGFyNnYrS2wxYlFSN1ZUYmhXZi92MURpdkUwanBF?=
 =?utf-8?B?aUFORzk2dzR0SE1jQlBNcXRYMkdEeDBMZ0V4U0NyNS9tTUNqZkpYcXdYeTNa?=
 =?utf-8?B?dWhCOTJmS21LTWZWVHRDQ1FYSFgzNTBNMzBVVjRyY3RjNk81Zk9IZ1ZRUHZ2?=
 =?utf-8?B?NU4zRWpYSytiYndhaGFiQjZmTmlpY2ljUWlXMi8rQmFiVTZldzVKeWYvcTVQ?=
 =?utf-8?B?MWNGNlFYWVJ3Y3k0eEhaaFFmRllKZW83cEtSMmQrOTJySmdTY1Z5TFBaZWRa?=
 =?utf-8?B?M0FzRFdrdlp6R2lqZStsZXlPUW1FWWJGTFhXN0l4MkJtMEc0VFRSS0Q3Wm9h?=
 =?utf-8?B?aGtZZUNLRGZCMmpLbURpM0dqL2Jjeml4dXFad0ZaUDZFRHgyTFFtVHNxTC9k?=
 =?utf-8?B?NXN1NjdNVnNFTDhERlA0MGtUeGVHakpuanBBbVR0RURFQWpZQS9QeVpEZlJS?=
 =?utf-8?B?ZjB5U1E0bFlNZTJsTWFMOVc0clFJNWU0TllFTVlIYjNxdVpaL2p1aG0rakFm?=
 =?utf-8?B?STJPcyt1ZmFqaVp4MjVTbzRRYXdHdzFPSjZ0aHk1R2hvQU9vZ1FkN2FLMFVr?=
 =?utf-8?B?S1hEYzF0L2hIbC9MNUN0dHVmVGx1S1ZLUDhsYzVxeHl2TVBQd3ZibkpIWVMr?=
 =?utf-8?B?eHB4Q3ovbnZXYW1jOE9HcGRLcDJ3aTVWK2hrS2dqK3EzNkdxVlFiaG1NWTNX?=
 =?utf-8?B?R3pwRnlZSlZodURQeFI5alVpbjY2YlJUTVV0QkRKdU1XVFVZdGV6U2pWdHor?=
 =?utf-8?B?cFpOM1B1S1BYVVpra3dhaVcxZlE1WC9KR0dENWFKMVdJRGhJdE5XaGsrNnJS?=
 =?utf-8?B?LzQ3eVRVb0tJZWhZdEVRdjZuaHRQVGVBakYyUnhKMkVOeDJkVEd0MUEyTGJJ?=
 =?utf-8?B?ZjNINGZMa1NVTHR3SGFINC9pOUlMMlRlTnNxelhPcUVXaGRuVEtKUW5wRnR1?=
 =?utf-8?Q?p9RlxbZ5aqm4uJMnt8F3cW0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c84534-2326-4b86-751c-08da00234bb1
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 10:14:42.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b1cUTsBU3gwteT/iH7XFWdqf6Mtp4eV5y+eQqWt7MMVFmmhx88tze/qp3M0ee6woMPG2Gyk3WihSVzUTRFITIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4633
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 2/25/2022 2:51 AM, Maxim Levitsky wrote:
> On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> 
> I only gave this a cursory look, the whole thing is a bit ugly (not your fault),
> I feel like it should be refactored a bit.

I agree. I am not sure how to make it more friendly. Any suggestions on the refactoring?

Regards,
Suravee
