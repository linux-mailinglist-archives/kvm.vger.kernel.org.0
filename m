Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0F57D64AF
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 10:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbjJYIP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 04:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjJYIP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 04:15:27 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2072.outbound.protection.outlook.com [40.107.21.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76830B0;
        Wed, 25 Oct 2023 01:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrRHWhwH9yPESPu7dTXNMnUP18JmbOtRg/Jv5WCL26gGT7cjQ7l9L7R55qUus2ymDpjhZRE+gR9ORJMktvjdLIM7ozhuRxb2czOd4l1+xZiSdVBF9FbiPiHfnBAb5U/E3uJ6IpWdnE/qNQGlCfWuyrQz+4FIHNQJAXgzAYIJGe9paACDLJNOUcqCltygXyu58vObeisGbIPH18+Y+rnTwAZ/SFicyJ3F6ugDqHvSfHomdeie76UVN66+avYUBGxuIkHS8RSex7lBnHE+qgOl4T1PYFmjNThuQR9bYfgcXZ1TIwewoNx+igkWpOykVd8sRPK8Fm5nTEqgu4vSThdmnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+b0B7Seqfyl5vpzeNCdYTRKsfZk3Mtgi/w4fOS8CYLc=;
 b=hJF/9SPg0nzsEulymvOfG64N4fNdhBYOFRI5humeWI8cStp+uEMbaslNhJCbJXiOzFgKIpnEoACjt105X81sL53cDdX3BNPinGbkmwFN6fDyspAh16T8i/uNcHedeJSHNR1+iFuHWBGQ+lpe/EM2ugLH3dLNoViYLQAtn9ZLSFLvSNkfCFD1z/bqdg52DH7p4XDdAkBuvdwtxEAE5W2fLrr1AOUD6+BrslQOyWkqS9rSnAfkasjoeIiK5nT/IfN1YDAFT8WzwLQckNakL6wDcEdCgZ5yEjH0uPT+NVVkv3FU+TUXTSb4OHzUZl+EmoSeAvH7VtPWKiUinpM4Xj4kUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+b0B7Seqfyl5vpzeNCdYTRKsfZk3Mtgi/w4fOS8CYLc=;
 b=BzX16RNGUM41bDVGkWi1L4fnIvaQOUH+B6cdOxlWvUYZ7u+3qXeYcetpcRr8BnKy0j4Ihqz1poQtzdvUy6PLmGMSWHcLWSipUG9HrpvMXYanJr56M9shotlJiXs903g/XN7Fx2Q7opEH7gXnkaK6xAyLd5Wn7Dl2ozIcToH9RexaEEm6J3iuXc4heYv6zSQI9uQvgS+IEcb7K6QEcdTfqUDqTh13kNM+zOQXPAYqj7Dd+mhx65uXTDNIFRejXei0kegMYXlYeTn7VFoePnHwGY/LzKb+Cu5aTMyiCidoI5D/u381+FxcfZxTVM3YyHJOBKMf31E4TuhjDVu7wUKGCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM7PR04MB6856.eurprd04.prod.outlook.com (2603:10a6:20b:108::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.11; Wed, 25 Oct
 2023 08:15:21 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780%4]) with mapi id 15.20.6933.019; Wed, 25 Oct 2023
 08:15:21 +0000
Message-ID: <dccdd1e1-0ae9-448a-aa2f-aa3f7b988559@suse.com>
Date:   Wed, 25 Oct 2023 11:15:15 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] KVM: VMX: Use BT+JNC, i.e. EFLAGS.CF to select
 VMRESUME vs. VMLAUNCH
Content-Language: en-US
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-5-f1881340c807@linux.intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20231024-delay-verw-v2-5-f1881340c807@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR2P278CA0079.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:65::18) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM7PR04MB6856:EE_
X-MS-Office365-Filtering-Correlation-Id: 83d0c1e3-752c-43cf-0667-08dbd5328803
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jfkkzH2+hCZJ3H7z62qLqIWczlX3ThgktjpqRNq4FnbPjVT5shATHxQRr0lJ0R/H0XI5JBD6BZKEnQzqNptfwuHiJ/nWTSgUXduwrX2tnhvVYqXRY7+5GsEDldPU67BlnOOkh3Kg35frOryi2AESLq7qxcCI4vvbDcZ1c7KFOSE/PEACb/3Acf4MwlTQfaNyktvw3KFVj11HZT79z8g4ITb2U3nGxiVFn7xDejKJz2+rfUsNddkYQuTb6nIYrCgArvqvLAcg8Q5Mux/op3XqqalCh1f+QWzcchqfD8a2rPME8gvuE3ic41w42BO6wYT/RKfPIV6G7U0J3V9Ab5oqaOwu6uWEfKBF74VXtV0Rfz4fpDkWgIpS8SHDNergf4reQnb6yRqLCXI89A7Lz92QnAsBG8iZjtJjqb0NQUz5DxhY3v8vWNpJFZ3KG2JvOx5CRaAKK1QnnBdhPlRFKPl2yQ2Bj++H8KmAWSsBBHH6Yt9gPvut4yb5i/5aTq2vnFmT32ygN6fu+Cfa0w/PqRbuZHNntB5I2jjJ5sQBaA1bCqBwtTKVeX9PDfarO9hUaVdVG9h8CQyuUFBpP/Zv9dP4Wl7KaCJeESCVuCRcEPglMlpMZwVhgExbW4k+PcAKb2ORelVfGXT+goAPYv+ckdk0u7ZNdVCTM4tlSwb434LsF6A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(396003)(366004)(39860400002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(66476007)(6512007)(6506007)(6666004)(2616005)(7416002)(2906002)(4326008)(8676002)(8936002)(6486002)(478600001)(41300700001)(4744005)(5660300002)(54906003)(66946007)(316002)(86362001)(66556008)(110136005)(31696002)(38100700002)(36756003)(921008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVVabWJlTUg1ZUZoUmtvdmtBd2RhZWlpb1ZXbDk3czlINFU4NUhGbXNsUlg3?=
 =?utf-8?B?OTdYQVowVnZNL3pxcmRCMDNKRzUzRlBTZVdsL2NQWjBRNkQyVHJCdDZJWVlx?=
 =?utf-8?B?cFdWQTZJa0MvNUR6VVVWaHpqakNSVjZZMFJjUXlRU2tmRnBXcHpHU0cwRVpu?=
 =?utf-8?B?WlRjV3MyeG9vWWkyNmtmNUl1VVZ2QVl1MGN4RmxRWVFRYjdEUUpDVnIvSGJN?=
 =?utf-8?B?d0VqRUJZb1FVaXRYa2drOXM4Kys5R3lEVXhUNnVKU0tucGxQOUprNjZnYkZ4?=
 =?utf-8?B?YXhCVXpLTjJ6eXd3NEw4bFAvS1hyTHhTQkJZNFplbzN5OGRVNVhxV2VnVzQz?=
 =?utf-8?B?Y1ljbW9KZWpGZ3Rrb3VjRVNaSFdlb0pkL2dITkRTdkx0UUhqRDlTTTNEcmxo?=
 =?utf-8?B?a3lwbzc3OFVVU2JzOVVGRjFOWXVRbHZxMzRDV2s5d3l3T2w1cHh6bWM2NTB4?=
 =?utf-8?B?Z0lOWnliRjRtRHIxL2JSZWJFK2Rrc3JDTXhtSkJUaTZxT043RWMwSG9EbVc2?=
 =?utf-8?B?SllBN05NaS9aUFRLK1RiVUlMem0wbkZ3bSt4akZicmY1WERoeTBUL3pXU3Ix?=
 =?utf-8?B?Y0VGSWtuTFI1WW5mU0x5aFdPRGg4dFQyaGhWK0hIdnhkcm0vVys0aDZGMGVB?=
 =?utf-8?B?V0FDV1c2NlltWmRia2JpU1AvaW56YVAxRVBCd25LWEl1OUZPVVBSQm1GL1g1?=
 =?utf-8?B?ZDRyNDNkSjM0dWZBdllrU3FEc1NVaUI2MXB3TTRXelY0dUVLZEdjY3VuR0VL?=
 =?utf-8?B?UUZJR3Ywa0JJYzRabk13WVFHeXRSTUF2dUJCZlR2anRvQVhudkllb1F3T0NI?=
 =?utf-8?B?dWdTZzhvYU5sM0t5ajdXYUxWeVQvRUFSTHZCSXprcW5VdTJsYUJRRElGbVIy?=
 =?utf-8?B?dmF0RFpBSE9zN1F1R1hoNWN1WEpleVo5L2xnUkpmSXJmRXFhdFE3aGM5akVE?=
 =?utf-8?B?RlZRMkhOVXZTNnFjbkFCUjB4dmRoRitVNk9qM1ZJU0daRnc3eC92dFZIVytE?=
 =?utf-8?B?bU10YXUzTkN5T2xuQ25aZnoxbE1oRnVpMHVweS9UcW1uUjZiM1BOTnp4dUNH?=
 =?utf-8?B?VjBnNm9tci81K1JhTDhZcUQ4M2pYc3NXbzdocnFEMEJldERlQmYvd0dibXd4?=
 =?utf-8?B?MmZmYlZxRFVLbGc5Y1VGUjIrSVkvcXBOOWM1NWJ0T2N4ek5iM0g4TGhPS0xi?=
 =?utf-8?B?d0lNUFFsTzlKWExEODV1bVlSUWxFOWVZUndCcUl3V3ZIOUJBRXZTQTlQZDFx?=
 =?utf-8?B?c0g1YkR0SUo3WmsrNXBHejNGbmJUZU9TbU9BWk9tdG1pcEx6ZXZTbUh5L0Zp?=
 =?utf-8?B?YnRzVUZpamVqeUs1VUlMVVoyS29kV3VsWUlKOTM2bi9OR0gxdHRsTUUzQlFU?=
 =?utf-8?B?L29qOERZRlJHb1oxdjVYZE5nT3NILy9XbDVDeStwTkhrbVlHcjN3UElYT01Z?=
 =?utf-8?B?Y2I5K01qUFVHdnFURlRRc0NMUTRET09JRFhhSTBYOWN6S2RVRmpsS3loZktO?=
 =?utf-8?B?ZmU2c1dHU3pFeGZVSmFsRXllOVNZa2pFSDZIVDlvaU4xTElsbmx0bXRxYjd6?=
 =?utf-8?B?NUcrdGlXSE52MlhIcXB2K2JJREdDYzNuNmNTNm42TTU4b29nSkp1VkFqVWxC?=
 =?utf-8?B?c0lRWVZsSjQ3K2kzcXc3MDJBYUxhVmh1N3ZVNXFweHNPTlhVazFWZkhDdzVE?=
 =?utf-8?B?bERRb21UTCtqMnBSOFVOK1VBdkRjZmtqM1Bad2lydDRsRXVyRy9hVmFPc3Ey?=
 =?utf-8?B?ZWVCRVFhTmxWR014dGptVUdFdkc5RTZLalRwR1FiN09OS2gyS1dLTFU1QmhN?=
 =?utf-8?B?WnBIL2NXa0JxbDRnaTRZUE5MYmY4NllFbVB3Mld5RDZuZ0dleEtCREUyZExM?=
 =?utf-8?B?QzIycXdDT0xjVXVMMmhnTlFCUlAwcEs5eHFGcHgwS0pMck5zM0lWbG5WSjBw?=
 =?utf-8?B?RmR0UEpZMnF6d0ttOHBsWjNjQlJLS0xZYWxldnBXVHhPVmtkc1RZUHlvZUll?=
 =?utf-8?B?dlEzWjVickxyTjc2Z2lYM3JXMUZLWFFDejVFYzBzZjdTcjBVczdGNkU3TUY2?=
 =?utf-8?B?b3FDY1JQdlRkUmlscG9vZ1M3OVV0TkltdysrMDNQdlp2bGxkWTR4cC8xNXBN?=
 =?utf-8?B?ZDFVVmtjeUJNZmZucU9LWFV4NmY3ekVpSUtRR0lVVTdEY3lUUzQyUzdabkNO?=
 =?utf-8?Q?UH9aXA+URj2MDfUv0+WDzVMxKHQT87dE3WUT3zcFU821?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83d0c1e3-752c-43cf-0667-08dbd5328803
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 08:15:21.2527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3YPX/0FHnvGeHG+Iw4KLmUgU/GGgEd9kllqnHXINMFTwGjjEidzTClBUobN2YRVI7qC/gWWaUIXAzGIi1WXa0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6856
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.10.23 г. 11:08 ч., Pawan Gupta wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Use EFLAGS.CF instead of EFLAGS.ZF to track whether to use VMRESUME versus
> VMLAUNCH.  Freeing up EFLAGS.ZF will allow doing VERW, which clobbers ZF,
> for MDS mitigations as late as possible without needing to duplicate VERW
> for both paths.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
