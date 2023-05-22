Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B0270B717
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 09:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjEVHx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 03:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjEVHx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 03:53:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBEA171E;
        Mon, 22 May 2023 00:51:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnYhLnJzpZzlb6XKvDkNxOMMxRuwx/bB84iIgzej9Z73bOo2vULCq7ATISt4/HUFjDODK6tbaXsy6r5byYQWBmBRbhxWd3By68Tvci0h2UcvBIi7Ra3CTtFcuYvi+dwv9N3dEYVfoVW7jYuGbX/XT+B+Mj/lmBrwN/KkdZQxMAqGmx2Jd3S9LWIAq+ZXRLl0QrfKG6zR9dOpF8BMcjeQeIRSxcB1nJ8vO0PVbLiAAgFwydBVHs5gsk1JBNIDvdYORFOHkADCdTRsz64cWXxURum7Wic//vq7vge8Wq/RCth2UDB3fFPOYHaziRWInCqmehhHoy5z/EWa8AIlMJ827A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSsTCDonGk0gXAaK10AXkSdirVMRhNFP6hdqV1u6TyI=;
 b=mfzjDPpFIX35L6xmgXkz0T7pognIlEIWAre3QwWmQG1Af+6+mBlJUmTxoBmbD0OzYc4p35HmEIvmH2iyGE17O+kG0r7K889ffViMks4vO5Rr+sVvyXADbgIW0qTXpOOtUkcSBea0c9sEZOSG35vp6ogHlmnOdp9Qa6uBbWBHQ3lZ/MvEstx4VmTx7pEYz8Tfijv4ckwdvh2J6ScZ/bD064UbvvGKCse0Jcrv4B/C6QUvuYIQo86eL9pLpZ41ujbmuRJeSvImbaxap63707D4aW90cYAIBHm+3lzdgK9tI+ELVu++2pXZMxlxNWT91SXMiHlQGrQitfLRwJ5UN1STBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSsTCDonGk0gXAaK10AXkSdirVMRhNFP6hdqV1u6TyI=;
 b=XuNa4FEIGcqeTq1QUtUlp738vXG37YEY1dW9EhgiBkXlTMuNOXcJbnSyOEBm9gm+8X00htJmmS/cRWUsINTI+6BpStWMr1M8Ev/6D9xcLRcb+2yqnyxdmlAAmQEsWjM9sO2PGFuRWkLK/bQTZjdPUIk15Dw9S8DRoaMwJDTpebNRtdU9NEZB6AFUdUUJIpjtP8oxViKB3vzaKzXznyk9gCZf2pDf5GdIeCIr7ej0mrdl8Ln57s/dHKFGSfsaoOdfrZIMcWjYAGdt5drb+qeWMavqc0ZB5CtEKaBzBv6aY2U9EWywGvriQ+9rxj1Ea+FNRWm11SlHh5ACE4mAFmPWFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 07:51:51 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 07:51:50 +0000
References: <20230522063725.284686-1-apopple@nvidia.com>
 <620eef7f-ee01-673c-b097-243d6fe25b09@linux.dev>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Qi Zheng <qi.zheng@linux.dev>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        robin.murphy@arm.com, will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        jgg@nvidia.com, John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Date:   Mon, 22 May 2023 17:45:59 +1000
In-reply-to: <620eef7f-ee01-673c-b097-243d6fe25b09@linux.dev>
Message-ID: <87a5xwajn4.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SYYP282CA0009.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::19) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: f60ebe1a-e1f7-4445-22e8-08db5a9966c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6yHanmOvq0mN/r+hgOTNfXoKIXZzEDX5U5q3v7Wxq4dNDKI9hVxGOThMdzKoV7T/zX+UI+5kQW5TOLy/hEXvLktj4m87ZKEUJU1n5cjBDNIKxhuymAidU1K8mqBo+QTXDS1+KaS/Lao97HYC7abRS3v/iD/X48ayRlc++js3X/eB8UEAPLqVZhyMJ1jCXdelUfu1XnpLs8XzPqHqYMM74KZzReU5x/8i+vrl71GKLQ1sfjxc5UH1YVjkvdqrV9HSrYOhFHZWPVHHVcAjiZZn6SyNMNtU9dbg74AgqqbHQHUdyNZSj/5oFBCGij/JiR0WVr/A16F7QiMK02Cnv//RaoZEncU/JoNh5BT8FJZi5qm1PcblAwxmqbeW4sC/+C4ayyrtOTEkaalEp18L4DgmQqo5k8CYVO8n5lhY4lRsasImpbMbCLjBaPZz+OhNTVsQUtLCKYTL9k5QbDJPHsO75GWa+QgSOqLJVSj2TbnnVEFV2RX9MrfGOdXkzm4OtmS1vsymzsEvxm6vTmhYULM+DX73EtcoURC24sxUBjqhemgrGu254+Iaz6apqHxoQDad
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(5660300002)(8936002)(8676002)(83380400001)(2906002)(4744005)(186003)(36756003)(2616005)(38100700002)(86362001)(6512007)(6506007)(26005)(53546011)(54906003)(316002)(478600001)(66556008)(66476007)(6916009)(4326008)(66946007)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2mBowBchH60lIXF65ytaSCc2rOKlgJzlBemp/jVppZ/FdzuHiLggsISM+T++?=
 =?us-ascii?Q?vM2cQAaURJCz9JlL/OVCpJ0Zi6IF8GhvrNeZKrEbzEKFU5O4v623CNCYmllj?=
 =?us-ascii?Q?TiGNkVkSivxrxNYgcIK3aM8hjN+Y+n1yyL+KvyYpdV5GNMBnk/8zDR20A7K7?=
 =?us-ascii?Q?0IK/Cb6xuoNFg/LGto2Pe1qJ9pER1dQX+wzrFLZ4wVzscFbGH3XkwuM2oooW?=
 =?us-ascii?Q?xyJJQNnM1k41M8vkLngramnWHIlkNmJGTaZA/yTYQI5OrteiIhND7p5U4km4?=
 =?us-ascii?Q?KKscq5IN/EortODjD8S9tlhu/QqC/r14XLh/rXmK/GigsW6FUbwr6t1TJAye?=
 =?us-ascii?Q?8xJEbBU8xvI/d63WOP8E5ylydpyN0brBXJ03oRoUNRER1tOjWMDdFAHxSVW8?=
 =?us-ascii?Q?VOTj4T+ul1gnaPwnWJM+tM/tzk2aJFK09hYbm32knPk5LjtWH0CRKhjk9+0R?=
 =?us-ascii?Q?xRwou7OvhEIRQtKr3rggtH39yeR4FyB+p7UHLoMn/ES3coi3oc9El0jG8KH0?=
 =?us-ascii?Q?jkRczAL7n2x37c++7vnhPv9gciCT6v+aXZhN+TAKvltyVUEiq4krHh0VKn73?=
 =?us-ascii?Q?7k5cXYU/FcFwrAQzhJgnHDcIBflJ74ipwuSumokwNmD76ataErH6htQrDNp7?=
 =?us-ascii?Q?rKHvf8RnaL0qCs/E/Gufyd8Jmit5ntBRF3AjLAlrg1BCvFWTv357gne/dgGk?=
 =?us-ascii?Q?F5LSUjeiRpS1Wa3BuBd95eB78avHI3zNSCXB3UZCMvM883GUTc43cX4WGOtE?=
 =?us-ascii?Q?+NiJ0vV39jAayfjJe6KaZY8Ye/yr/7mvu0b2LQM5/xCcgbOXysBXkvlMsJCr?=
 =?us-ascii?Q?6rNccFPg9CoUrkKR4zQfFCnnspZ1d/beU8ousNgtnfKmqMy8M9+HRnX+9Wxv?=
 =?us-ascii?Q?7l4GHqeD8DbFVv3ruSdRnYfw2s6haiWAVl4I1rFlttNmlkra97M6vxCGGQlg?=
 =?us-ascii?Q?/+vDiw8uAfZY/kgclpsGKLJqOoWJavvUQWzF8HGUDoRr5WbHDzJ6XSY/yDs5?=
 =?us-ascii?Q?cRuryy7FpBKNi2yl7QimAksY7zWP3qaUhEvRXgMcQOY5JYWHRKpLyEKg6VJL?=
 =?us-ascii?Q?hTBrrQqNj1iDkUwPI+gsx6pKSZqqGI+ZfayooYYbue8KH6IKOOvbfk4lsHs6?=
 =?us-ascii?Q?9HrzdoSrWeF9IXXLxMAcVoc47/WzVA6kmpylsBuMV1a5DBVs9y8tOISEFWzU?=
 =?us-ascii?Q?dX2kJmVoDC/WtNtJ8WrarU4XXopotBtMFlrf5pE4HcnZDj7eQA43cB1rP13A?=
 =?us-ascii?Q?tbVydoM/PinfWnWulb6KAQTpBmk8HVUlIwNRmq98oucbIq75k56z3G/QGUnp?=
 =?us-ascii?Q?DNTjLji/cyscoMlPJf3PwmIycv0S8z3rglAMyfaQhudGxSgMnqFyLDhrGX+w?=
 =?us-ascii?Q?cvw8YJhMGnbRkr4YSXcDkHk9nF6IleZDo1tI5Lhma+qpkd7c4KWCecA9n7Nq?=
 =?us-ascii?Q?VRuZgRV77N9T9bdrSBEdN2ma05N4dQo683mA4RM7paLMd+gkFn3ycoKCGMwc?=
 =?us-ascii?Q?jcMo7sTsjB0mfAWIGwDUpxxW5yInMrevIFANgz8vYrRgj7bKvrosukt8xxsE?=
 =?us-ascii?Q?sSNoc/J9aviDUVUsWXZKPf077V/JbP2vq8A0owgP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f60ebe1a-e1f7-4445-22e8-08db5a9966c0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 07:51:50.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Sf3HzQPiADa5sN9oXkIqbIVHbsUErEjmb19V1uK3B4IDXQ092UVTi/XGH7LxCWSYut3z8NAkzbA3GR73133iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Qi Zheng <qi.zheng@linux.dev> writes:

> Hi Alistair,
>
> On 2023/5/22 14:37, Alistair Popple wrote:

[...]

>> +	if (changed) {
>> +		struct mmu_notifier_range range;
>> +
>> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
>> +					0, vmf->vma, vmf->vma->vm_mm,
>> +					vmf->address & PAGE_MASK,
>> +					(vmf->address & PAGE_MASK) + PAGE_SIZE);
>> +		mmu_notifier_invalidate_range_start(&range);
>> +		mmu_notifier_invalidate_range_end(&range);
>> +	}
>
> There are four similar patterns, can we introduce a helper function to
> deduplicate them?

For sure. How about something like this?

void mmu_notifier_range_start_end(enum mmu_notifier_event event,
                                  struct vm_area_struct *vma,
                                  struct mm_struct *mm,
                                  unsigned long start,
                                  unsigned long end)

As an aside I didn't just use mmu_notifier_invalidate_range() as that
doesn't allow an event type to be set for interval notifiers which may
want to filter this.

>> +
>>   	return 0;
>>   }
>>   

