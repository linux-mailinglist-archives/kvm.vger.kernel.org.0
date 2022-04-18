Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE63505B08
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 17:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbiDRPbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 11:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242914AbiDRPav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 11:30:51 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFB23466B;
        Mon, 18 Apr 2022 07:39:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wtngw/u1NggT0IjVlaqHQeyU+PRH+WQqoSZ9tLNkFVVnEi9j0YhTjTinpgTgbM6+ltas2bBMeWlr0sdJcO6PGp5RcuZGpBasA+m5fX6QbAw+VrnMFAOOMDRADuVopHBDZuRl6c++fSvC10gBWDWNVt0fqkR3y/MkapzXSfjBBy15gWrFk3gjNXmgWpNb06hPbdIl/tKUOlJ/sFV6fLh4WqfxlxQBw5wC/TP9DDR1SeoAEhVglfYHljAf9kXngIS/4rTFJJRPp85PgpTBJ+fS5DwNa+LDKuy0x9bfB8gO0QHVVXx+k+K8/tKsglhLIOi9TpgR8i+1V5XCzJU8aFM+MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQehnl0ZrADtmS8+nQkFVZXQ1+gd2p/CIdADWtvZPgc=;
 b=SUNdrNZK2Fuda0DnK0DgXDpqVxa8Qvw8er2D3NCXwd7G2+l76fURnHsqYuTGK/e/YEAHlnz3VdtV2pCSy6STwIx9ITqgLAvGb8qQeFid5Dr+eg/nKKlD+mhArKcXnLxqNwXn25oqaoXO19hWRAfn90dYYfTWElyHzGTJ4d4N4eWwCg2IoyBv8OlonxsrywOkW5rJ/XEnf7n7EKou53RJfArozetHF4Tr7CGW+ZefG7HhcXgbXynDQGUGQ/B2E7XoAejk/a9ZlG8GQu8CakZ9ujw1z17YxMk39L56YKKIkKcMMvphaH5gAYfwetiyxFTVkl9doIDbTYvTa1Ur+S8y0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQehnl0ZrADtmS8+nQkFVZXQ1+gd2p/CIdADWtvZPgc=;
 b=lrYAUTsCCkCFZYIaDSPm7S4xdGicjLpROIZRZZqdouM8cWYRJhAv6EnRTQ5uuOzyE5tXJwfRNTEIWK8x4aasGyV0Xfn6aw6EL7kC8i9d4H1xch4iG+UzxW7KjdcjKtXnwr0IORJw57vw/PSVBKCr7ZlhQeUcE9w6+6kv4Cnmy34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BYAPR12MB2888.namprd12.prod.outlook.com (2603:10b6:a03:137::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 14:39:53 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 14:39:53 +0000
Message-ID: <81bb5fd1-2241-3ea4-dd52-a1eaa2101997@amd.com>
Date:   Mon, 18 Apr 2022 21:39:29 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH 0/2] KVM: SVM: Optimize AVIC incomplete IPI #vmexit
 handling
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, jon.grimm@amd.com, wei.huang2@amd.com,
        terry.bowman@amd.com
References: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR03CA0049.apcprd03.prod.outlook.com
 (2603:1096:202:17::19) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f08156e9-f2ca-4424-cede-08da21494cd2
X-MS-TrafficTypeDiagnostic: BYAPR12MB2888:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2888341F2DBBC8ADE5E6C22EF3F39@BYAPR12MB2888.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9FtqS5W773m1+Zox97LilUftz/vllcyvgEnnQwin5gMRCG/r+8MtsWQmeK/feAQSSonCIyIyZUhLoxJV/DspmLsYB8P2DY7tGi3DULCSEc1RbtlOT3Q2YwIcJxwC0UV7Gj7T60NX5WH6GQV66DpreZOYxFPzfrspfZ8anJUM91yQwz1QFmzR4F/wMnRp9aK1o6pidetwMbTP7Y52eOjuW6ffp6ZmLieEVrR9JjzjGEYU7Y+I3ShxqoectbMVYi+bFd5Fvl9KgJRJmy679Dm9p/NaERAnTATuBVLeeNU6xx0DPgoaSlfdUXbcF4EFxoI+2YaM29OE51LAin1aZiOiMgiP/536PCbRav12+3emdXmmwu5ceq9AVLgi4iT7DrIl0rmMvQ9bGHZ+/EPauQtmYiTg+f9Yb+4NkcsssukE7+/dzyrKLLo8RlpF0YL8RphTKe7r3m4XdJ3wa71tEO+Z8R8Vjv7NYcIPk3B+AvnybWq60hEbf5KGc3aiLDlyEEPdIz/khSc3hTF/+SRgNvkP3doW++cjf0q8yBIir6ZqAj0c6rOJC4BQ9RjcGSjD5weH0Q63W9eTn1OJOzQH8CUB1xusbvmqWyUju969N0fY5q2wCDcpnAKQwsNsqXAPzUTUDPGHirf7Cy1+Ms8kvetSlov+HzSg2bKu+rPsIF9J2erQCxU1EToK757Ie7kn35pnqMcBDDQ5lNi+/Ea8dPzHlC8ik/EFQ28bD28koDSmRvUAIDpnIaTq46CnUCPcx25r3K6nhv3dsz/IQnnl39pBdIO3ZpA5TFtxFxzChHiZ4fzmPFy2ZkoFlcBIv2dK49yd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(38100700002)(26005)(6512007)(31686004)(66556008)(66476007)(66946007)(508600001)(6486002)(8676002)(86362001)(36756003)(4326008)(2906002)(6666004)(4744005)(53546011)(44832011)(8936002)(5660300002)(316002)(2616005)(186003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWpyR0JDWCtUTlNDa1Z5SFRSTnQxT3pTaUhOMjd5Rk1qM2R0c0Z2L3R4UEZp?=
 =?utf-8?B?bUhxTHlpNjFvc3N4OGhsQm5TWTB4a1BlYm5XVUU3Y2xZMnk4VGdEakEvVy9z?=
 =?utf-8?B?VmM0UUo0UlBJKzlQMThjeFdNWEowZjJtTm95R2R5OWRVTnNiYm43QWVZQzRj?=
 =?utf-8?B?dG5oOEp2eElSUW5meWduZnFHc2liRlZZdzlQL2F1b0ZheVorazMwbFRlVkZS?=
 =?utf-8?B?R0tDU25VblIrbVdBdzBCbElYa09GdlEvaWlFZHdmN0k0b05IVjhweUFvaFlp?=
 =?utf-8?B?MER2WFR3ZTBpZW9lVERGVzl2QWRaODlhTGZvWm1xTURFME1OOGJCd1FqQXIw?=
 =?utf-8?B?S1oxWDcvcjBRNzVpblM1TXV3UlZaZS9aQklaUExOajNUS1hIWi9GamdoeFQw?=
 =?utf-8?B?OXZ4anVjUHNEdGg3TlVPWVl5eWlza1IyT3FZZlIzU2ExWERzWjRIenlyN3hs?=
 =?utf-8?B?UHRWMHErTWpwbENDZ0lPc3VhaDNoQ0NlMXAwS2ZESzVZV09nd0VZbEJ0QVFr?=
 =?utf-8?B?a2RIb3dHOUNDR085a2FDSTdGWkM4SjdOenY5TnZJRjRFTkZxaVBYUjNVYTVW?=
 =?utf-8?B?NG1FaTdPc0pROXNJV2ZjR2NwTk5JZFd5UGp0YmRja21kcnVTRmQ2S0dpREtn?=
 =?utf-8?B?VEVrYlNlaEZGVDZ5cko0ZDhoTE8vWC9pOTMxVlFsdXgwUGdCWkpHTDRWeGwv?=
 =?utf-8?B?aGNQSndoQnlPRWRUWWJpMFpvS3kyNkpOYTlTOVA3cEtWOXpRNXh2R0dLVEVz?=
 =?utf-8?B?bWdtcVEwQjJ5cllUMTg5U3IzTmNxQncwRGdMR0N3c2ZmbEZUTUV3eGUrcmhZ?=
 =?utf-8?B?M2pMek4xWG5oc0IxUXYwUVBsdUJxL2VGaFJGTjhWY2ZOckd4SW1hRTZmYlEx?=
 =?utf-8?B?eDR4VVM0a1VMLzR2dVpvTWtTNUwxRm5KaWpvbXhWZ1lsTXFWYlpOa21UeU5x?=
 =?utf-8?B?TWUvZitVQ3lTalI0a0lpN3VsbFBxQXFGbFpvbDFqbTAwaVcwdExidDRhcERS?=
 =?utf-8?B?VjRtTHpNNjlMRlV5WkNQQ3dvR2dSSzZ1cGtTYVp3dWFpOUg5TXhkYXk0bk9z?=
 =?utf-8?B?MlVEaGUxWmc2Z2c5Z2xPWWc1RFN3ZFJsSGRoUm9LSlkyNVpacmhqK0EzVVBy?=
 =?utf-8?B?VjFWZWlGRkxiUUF3K3l3Z1UrNFE0dU5TRUxWc0Qzbmx0azhhbk1LZmZOSndk?=
 =?utf-8?B?VGtrdUl3WkQ0d2VZeDFnRWVJT3o4YXJuWHVHSnMvcmNXSmFnbVZ6dWVPdUwz?=
 =?utf-8?B?bklvNzVxREtQTmJPQ01sNXZ6dHRSTnErMlljcXljNFdtdVBBOXFZS0pWbms0?=
 =?utf-8?B?WGRZNGg2M2lycHRIckYvZXNvM3ZreGFWeEVEZTF1WWp0bk8xeWxMSVNJOUZV?=
 =?utf-8?B?Z2luQ1J5V1FZVkVWYUZXMjcrTlRWd2JYUEJwZVpkcE9nZEtQQ1BTZDkyM2Vz?=
 =?utf-8?B?dmcxU1Z0Z296V3ZLL2plNk13TDFpVCtTODBvdGhxR0c4MmFtUExHUWo3a2RB?=
 =?utf-8?B?NlBaZTh4MTZ5MjBzSlRESGJhWVJxSnQ0YjJWbzZpRThLVHgvRmlGc0pNSHEw?=
 =?utf-8?B?WVkzdnFGeWVXZFNYVkw5U2doNCs4d2NwZVNtMlYxN0xlb3lpSHVXbHg2SzFw?=
 =?utf-8?B?dTh6eW9EdnlXVmZnSTIzMy95c2xRZW8rV3hDWHVJeUZ5ZnVVdjNVa0ZKdjdK?=
 =?utf-8?B?eGNTSGRqZmlVN3k1RkFqQ3k5bm5BU3NDWWJXYmxSKzJQNlZ6czJDN2lLWHFh?=
 =?utf-8?B?cy8yVS9JNGlzSFo3VXpBVzAvUWVTM2lPVk41UitPZXlVTkQ1R3M1VUNMeUEz?=
 =?utf-8?B?eHlNR2p0TWIwRktvNlZWME9TL3RES1l0M283UEhTd3VxcCtjY3FaZ1FwbDJJ?=
 =?utf-8?B?WUtNaktGVWZOdHVVd3daUVRncXgwUFphVmlUOEZSL0dYUDVndGxRdmVVR3FO?=
 =?utf-8?B?VFhId3ZFRDlYMTZFdm4rMjQzMmR3anEzZ3RGcUE1d0kramhqLzNYbFpTRVhQ?=
 =?utf-8?B?Z0tCZFF5dFd2ZXA1RlRZcmVPMmVGanZEdFR0ZHBmMnZ4dHFtRFMyZlF5bEgz?=
 =?utf-8?B?K0N1OUpId0FPMGQrb0UxaElBazYvaW1taXB4SUV6MmE1cUkvSURjYlVyYm9a?=
 =?utf-8?B?YWU2dDg3Vk5zdVVwMmNieVRnNVdvb3JGSFpIQUgreXJ5bEJhWis0VWVXN1Jt?=
 =?utf-8?B?dWVYWEhSdEQ5K1E4bHpmelprOHFxRzJZUmpyWUVNb1A3bDc5TzR3MzJ6MEFN?=
 =?utf-8?B?emVmNDFQekRLYzRmOGxvRWJsOFV0MERObFljU1p6cFlvcTBvT081VlNreDBV?=
 =?utf-8?B?RGd0WVdYQXlZRFZTemJha2ppbExtZzRIUklWY0FJaU5iRWc0VEVwQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f08156e9-f2ca-4424-cede-08da21494cd2
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 14:39:53.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pt59/87JGNgpjwXzYQ5xNU19buI7qO8kMK+wDzjJC2sofqFKdaqAAZMMtgFHbcX7PDL2leuBPotA1ZSLLIXmZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2888
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/14/22 12:11 PM, Suravee Suthikulpanit wrote:
> This series introduce a fast-path when handling AVIC incomplete IPI #vmexit
> for AVIC and x2AVIC, and introduce a new tracepoint for the slow-path
> processing.
> 
> Please note that the prereq of this series is:
>    [PATCH v2 00/12] Introducing AMD x2APIC Virtualization (x2AVIC) support
>    (https://lore.kernel.org/lkml/20220412115822.14351-2-suravee.suthikulpanit@amd.com/T/)
> 

Since x2AVIC stuff is still under development, and likely will need v3,
I will extract the logic for x2AVIC, and send out V2 of this series.
The support for x2AVIC will be send separately.

Regards,
Suravee
