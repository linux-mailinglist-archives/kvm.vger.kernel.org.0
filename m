Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82415F97FB
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 07:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiJJF4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 01:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiJJF4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 01:56:43 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2127.outbound.protection.outlook.com [40.107.95.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BC1201AA
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 22:56:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UO02mED62lFGml4sG2WBbUv3GDSZOF5Z7joj3Zpbg9EscgfsiPf05a8VQxJlqrXQ8fZHpDlXOkPlt7dQrGOfWj4EpNru1OgYyqO7FPS9yAQcEM1VfWc91W+TLFHpok4qeuLMpZ1eepv/H1oioJotu0pY+9ZZItMDzHQRa25NY1N47OUDgNWZk6qAHLa7uvBn0S3W0u5KTF6M6Xm8NptpUxb7RXLF1bPE9KVW19Npb5nkGn0o5gljIjm6N3Qjntco8o453M5oo9YKMpDwQyCRitWIBzII3uVdamaOuAclpYm2dxOg0hKJ9ShiyajwSS3E8TvYPWB9RZh4cYuRxl0+eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/G6nUKS2/l6U7NOp/Mo7jGWO2f8xT4zbsRZzuA2I3zI=;
 b=erDfalGMxFqAcQaWhdPGimar5Kr+KnOdjb/WWxBt+bv2oFg4WBcjfcQU72CnCwXPj+FMqYLIuna8CyJVCjAJhzEEdi1PfZVG1y+RAaTYepuBLfZU639rg/wSLBN1G/pChuyGIdQFoX3oYUhbc3Dsrtc0YFJjpbfkoNSN3Bey7v12DULzIy6+22fYMJSwRvD4kk00ItGPI5QZ5Zd09ujbI5Kk11WoAbHyD7KwjwntTSFdoHLXmHYYupMwLbVjgW5rbnkmk9E3yr2HoWq3xPeJrQPuV5D06wF4EM+uSvGmkIqsE1rhmGi7/s6gpTyVdXYOZI+FKyKsjM/AkpGAaK4qrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/G6nUKS2/l6U7NOp/Mo7jGWO2f8xT4zbsRZzuA2I3zI=;
 b=GqBm1/yFa8WWugC28ACFbkGX3jls3D9hysAJjfukGFkhPGtZs6H+VJBSV0+YmZVDDMYU0gqCGNZ0nUYGe9stfDXJxDfJ0FzJbFL17TK+3mHOsCpO0Avgdp/PhrKxFkGwKzN0BqwPFessAx2SoNxCLgOMlbyQuXeEC+4DWS1lYBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM5PR01MB2460.prod.exchangelabs.com (2603:10b6:3:3b::22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Mon, 10 Oct 2022 05:56:40 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::145c:847a:4e1e:71cb]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::145c:847a:4e1e:71cb%6]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 05:56:39 +0000
Message-ID: <b1bff394-f99f-8654-6b03-29166129763a@os.amperecomputing.com>
Date:   Mon, 10 Oct 2022 11:26:31 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 0/3] KVM: arm64: nv: Fixes for Nested Virtualization
 issues
Content-Language: en-US
To:     maz@kernel.org
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        keyur@os.amperecomputing.com,
        Darren Hart <darren@os.amperecomputing.com>
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR19CA0013.namprd19.prod.outlook.com
 (2603:10b6:610:4d::23) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|DM5PR01MB2460:EE_
X-MS-Office365-Filtering-Correlation-Id: 10b16436-58eb-4a99-83c6-08daaa84327d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMYXV6b1gv8nVYeYcl+2p4Qr035E14gikAaMTfB2yzOJn7vkkYq1b7K3rNPvUlgaUYzlqKhmUerr004mEf4fmggKhwLn0f7k+kB8lRiExrm/Apqs7S6JgRFtYf7zfV1LrSVzkgc0whq85raOuWGkOdeKHT2KjRZsgurVSPJ2+QHzx9TZlp2J8IRwtJjFR+MGkBCaUeHRlTYNMWIBDuU2L0wxTrlawvqaAxqDuqP6EXBJdzrZ5EK/xtfjomJsuYwGeE6YTxsIeqyWWkUN2aLWR2AK2XlL37veD8Z25ygpvtqB1DeHTwSJzp9ldiMvwkJDGPcbcAjNgCTuThvma0Cw0ZCkJcf96wM6rVCQBkXq/d0JRf+DCcuELPASsAoYv0zCZYOO6U5qRhJZKDfek1XHZwz4omevTTT8PGzrS8r3S3dZJ/ud//Imv76Btk3fA7woS/ePKKpEpKyZ6RfHHUmQW4ICLux4v/rOdD323zIxaQ8zePqEd3DqZ1g4cR0LBg6I6LQlLn3/QxiXvDcNy0mQigYBtiLx9tDQr5IWL/rfPyL3WimsrrOTDJCXLAa6DW8jmocMbh1lxV4UkXd2VyKBJYqOkwLZYrm0knofwgPJMZoJ8O/VY6laXT79I6/2NTdqpJLdQhONvF2ADORFtWVMBOmWgx2xk3DpgjLPFhbU9xkcR1gj1CsUshmORFi35MWMWANsWEHrSokCakTFpJBq7DVd7JTQnijwsaxdvGOVPsB+SFYyFRt4NvAsYKUu6q0VGMgjG6KnDv4/HuE//I6dCduWzlj4I70/dZ1TvaJr9QZN8I7gFRQMjIDjl3AgE3lv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39840400004)(396003)(136003)(346002)(376002)(451199015)(6486002)(31696002)(38100700002)(38350700002)(66476007)(66556008)(66946007)(8676002)(4326008)(316002)(86362001)(6916009)(2906002)(41300700001)(5660300002)(6506007)(2616005)(186003)(107886003)(6512007)(83380400001)(966005)(26005)(6666004)(52116002)(53546011)(31686004)(8936002)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2ZIbk5DTi9NWDdBcm95ZDZ0ZnlTc3ZOVTk1azJKRVdsUHUrS3lwV0NNRnRv?=
 =?utf-8?B?RnFNSVRLZTlZY2FZNWdIbHNyNXJVQUhRNWxoTkp2cTBCNGxSd3h2NStIRTY4?=
 =?utf-8?B?SmR2VSt1NjB4L1JXMkdsbUdONVo5eFJxZUdDeFY0KytqTEJrcVlLdi9lV0pP?=
 =?utf-8?B?K0dEZ2JXUkJmZkZaZm8xTmJjTUtlcUdMM3haMlJTcHdoZ1JsOUoySVFDMU1l?=
 =?utf-8?B?MFZWellIN2daSGdoN3VKUWZCRnRIVWZ1SS93VUdMdWp0dnhSdkhBZDBmT1FT?=
 =?utf-8?B?Yi9QVGVqKzV3c2VxSmI1VGJ1cFdlS1JjbVFlNytlQW5NN3dlOTd0WER3djhQ?=
 =?utf-8?B?TS9JNjFjYkQwV0RWdXN1cGRQQmZyWmM0R3RHdkNTekV3azEzYVo5VGdzTTEy?=
 =?utf-8?B?VTRST0haUTlxWTM1azBLZkxpU2tQc3BxN1hJVEtQcFhEaWVESnRuNCtWSFZQ?=
 =?utf-8?B?dkIwTUlUbjRFQnFIWEZSR2s3cE13bjJtTUV3TzVjZVlKZE5ubm11alFwOU1T?=
 =?utf-8?B?R05OSnBaSmdlUjVUWjF0N3czbVVaOTdUYlJjM3l1ekRMeTN4M0ptc0FGYnRD?=
 =?utf-8?B?MTBUYno4QXR3US9oa0toajV5N25WRnhFWHYrWlExSm9ndDVILzdjdkovcG5s?=
 =?utf-8?B?T2xPaDQwcGFPT0pzMUlkdDZKVlNvNjcxTUduSnZlWjdJVHErQkg1QTJSK1Bm?=
 =?utf-8?B?L1pnNDk5Ynk0bFg3Uks1Q1Y3a21LeDEySUVtQnZOeVlaL25JWFEvb3M5dS8v?=
 =?utf-8?B?d0tjbVZjeVFiTE80cXpDWlQ0VjNWeXhYWDhVbFIwMjl5UHVyUHNUMzl3QTRr?=
 =?utf-8?B?alRYT01STHRZNGhSQlcyUXUzNGtXRFhyalZ1SmZobTloYVRnUkZTblNMYzhv?=
 =?utf-8?B?NVRoM0N1ZWNkcDhyVk0vWXJFQ2pvNEh1eXVxMjlFSmsrVXNzb0FQNVFGUXN2?=
 =?utf-8?B?Q2tqZ0NlL0xRL1BwUEJTL1VlTHNrZWdyQ3BZMVFQWmxYdTdMYVlUbkFZanhV?=
 =?utf-8?B?NStPa2FQV29UYVcvaS95bkpKcUlKV2d4TE9UNTJIUndPMHUyRE0vRmhrams2?=
 =?utf-8?B?QldjK3pzR3QvUHdxWXBOMWRMbUFJTTNqdW9WUGtsVWJnek1HZlJJM0dIRG9W?=
 =?utf-8?B?N3l0ZEJ6T3VzWGkydkVTd29hd1NNQXV0S1dPbEw4R1U1U2lOSXJOaVlwY201?=
 =?utf-8?B?Y2RiZ0dYOFhTSldINDY0VEMvbEV4c3Fyczh1Q3lwMThiM1FsbDNhQlRKNk1E?=
 =?utf-8?B?WnlodUJZNUVjeDE1SmcyeUdROFJZbzRGMGRlT1JkWlc2b2k3ZGltU01RMFRU?=
 =?utf-8?B?U21hKzQ3anQwV1pFdVZPblhRbTAyaXB3UDJGc0Z1L0xvMWNkOTdUU3c2SVhy?=
 =?utf-8?B?M0kxVEtvSm40bTBCWW45UTBMUkhNcVZQcTJEcEpjYThjMFhPbmRIZDJmc3do?=
 =?utf-8?B?dXRYMCs5dDQ0UEl1QzRSK2s2bUVKaUhwZ2x5Nkxvbm5VempocEFhSkVmR2VE?=
 =?utf-8?B?L094K1BnRHNGa2ozQWE0Q01qWkxvWnNmVFpjeldvS1lkR2o2YzFBbzZRM2Zm?=
 =?utf-8?B?N1pGckhuZysyYlV2akUvWUlxQXJ4VUt6SU9IRzZoRE1ZeHdocE5WWGZwOGZD?=
 =?utf-8?B?ck40T3dmcGVXK0dzZ0U2OVMvanp0THpBaDFiQndvOG94c0pPQjFiWmREMnNC?=
 =?utf-8?B?UWZ3N2g3N0NSY2Q1MFRUKy9wbjB4Um04YVRYaG1EbnVHWDhSeWt0R2krdW5Y?=
 =?utf-8?B?RUZiSjROWDhiWmZBUitnTmxNbVIyc3gvUmhwcFBFSkFPOHlVL2tQMW5tN0wr?=
 =?utf-8?B?eUc0WXU3c0lsVU5uMk1xWm1veWZmQWRPQ2hxOXBKY3hpY1ZvNXRIdVFDbUUx?=
 =?utf-8?B?dHZERnZmQmNHNktTejRRSjRmTHBCZXlTUUhxa1hNSXAraHRzYjN0Slk3aUJ0?=
 =?utf-8?B?VFJGbGtPWnV0K1VWc3ltSUZnZ210OW04a1BOdmdqdHM3VFNpR2lIbXZ3NFpV?=
 =?utf-8?B?bGlwbEpIZGR4Z2lBK3JCY2Vua2hyS2k2a0dpbUEvZVNhY3N6dDRNNkpJeGVt?=
 =?utf-8?B?a2U2YmpZbThjRFk5VjlWTjA1Z1RadXcrRVQ5d0diUjZCenVSRmQwVzdmT3lq?=
 =?utf-8?B?OW1qdGQzbXUrSWRHd0hiZDlUYjB2a3NheDBDSEJqS000M2tJNXVRY0lwdVJi?=
 =?utf-8?Q?LbNXNR565HFXWQTWnQamAkg=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b16436-58eb-4a99-83c6-08daaa84327d
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 05:56:39.6148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEDDhlhTKG2vuAgZ1zPN1fNLe9xnzOxAmkxD+aUd1TTnaAMQsbb6elRxgEW6cwWMDpI0uiWP1UHmDQr3FRdZuLeBsvAEW8tKUa1vjhdPygRQdg2SLDITmJ35b1Jig/XW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2460
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org





Hi Marc,

Any review comments on this series?

On 24-08-2022 11:33 am, Ganapatrao Kulkarni wrote:
> This series contains 3 fixes which were found while testing
> ARM64 Nested Virtualization patch series.
> 
> First patch avoids the restart of hrtimer when timer interrupt is
> fired/forwarded to Guest-Hypervisor.
> 
> Second patch fixes the vtimer interrupt drop from the Guest-Hypervisor.
> 
> Third patch fixes the NestedVM boot hang seen when Guest Hypersior
> configured with 64K pagesize where as Host Hypervisor with 4K.
> 
> These patches are rebased on Nested Virtualization V6 patchset[1].
> 
> [1] https://www.spinics.net/lists/kvm/msg265656.html
> 
> D Scott Phillips (1):
>    KVM: arm64: nv: only emulate timers that have not yet fired
> 
> Ganapatrao Kulkarni (2):
>    KVM: arm64: nv: Emulate ISTATUS when emulated timers are fired.
>    KVM: arm64: nv: Avoid block mapping if max_map_size is smaller than
>      block size.
> 
>   arch/arm64/kvm/arch_timer.c | 8 +++++++-
>   arch/arm64/kvm/mmu.c        | 2 +-
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 

Thanks,
Ganapat
