Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8CB70D2D0
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 06:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjEWEgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 00:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjEWEgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 00:36:12 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4598410D;
        Mon, 22 May 2023 21:36:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVF1cbipJ/HlDlR79auClgo5F4jMFKdcZOW4AZobleWmowTjYp/35FilfNW24r7il+ee/yOHP1ipY6OBgwBawpOrPU1NFWysfkhhgwn0OZcKHyUoVbsh9rA4fwVCGhFY2uuTGEnccktQaA/xDdqWRGL8E/AZDVkuwoJS+1SeZUrhUWtpabUyM7Kf+oyfVZJvyoi6DadrWMJDRZzUCALS9g59wtV2qYqLunDFmnO2pB8Aen+UoCnArMLx+BZySDtHiawxFFYC4Li8H+7DFB1MPYOOGAAWR0KsuYlJrFuqHPgj4H6NsbbT1Hz1jCSSbp20vdkWOj6WK+XPlpirCCwI5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4VLmcu0vyA0uM+kC/m2nQ6iQB+IGu+nFZwv8bsBiIzc=;
 b=njpLQjS9LkikIhz92pYeaBMObHWH+j0GsbasL4GPCehVntK7Tqe4PpuoUMdiDSUszLdB9DAZNnkgcP3uA8cWdvpfdHt+OrEtVAOXYSRBpssKfOTKBDzYIorzfQky6oayKmhil4pnouHzljIfHYK/7xnq6SQxI0mn2JelukqVJNXoxcIIbXp8pbBoZMUvRldj4eH/1LG/nZYJj7JJ+4nHEU5YW8dCO6RaZLWOfSUJGR59vw0ssDG4cTESiSNbZ3Bd3OaKoBNfWpI5xEyzgkjp4AY2/YD0fx9bQr7Y7PWzkI2xNUZ+co9+I/ZUeWspL9hNMM7nbi/cTn502Yhe/nrzBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VLmcu0vyA0uM+kC/m2nQ6iQB+IGu+nFZwv8bsBiIzc=;
 b=aHShR7FOsPIga/JBlMkmXxkUX1qTgl4Nu/Z2h2yAQVgzTqjJh6iHDI3dTSnGHIUk5dkSU0c5xGxdYa8qfdKobERId4Xw2zq+A/F9xKawQZpVkRIn8kgjZ0wNH0h90DT2vH40e1Z/6CthDg0gTLHf+87g8gaNlurxqMC5LAGzhPRfOc5RtTZd+RaJ4ulNsjPDhS4JG+7fv2brYCTnGAwWGqRNFSnyQ/5OGsRp2SJNYtblQkJ0XTBDL829p8k2A071IrvRyf/DXdzQVz8c/0mGsZDc0Kvhd/ENiiL76vN8RF7paPEixfOJP89aWp0MLilFShQ0J9XSBepEH3+cdE/05A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by SA1PR12MB6752.namprd12.prod.outlook.com (2603:10b6:806:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 04:36:09 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 04:36:08 +0000
References: <20230522063725.284686-1-apopple@nvidia.com>
 <ZGu1vsbscdO48V6h@google.com> <875y8jappz.fsf@nvidia.com>
 <b99d20a4-ab1e-4e67-37ae-cb22777317ba@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Date:   Tue, 23 May 2023 14:35:17 +1000
In-reply-to: <b99d20a4-ab1e-4e67-37ae-cb22777317ba@nvidia.com>
Message-ID: <87ttw37jgt.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SYXPR01CA0078.ausprd01.prod.outlook.com
 (2603:10c6:0:2e::11) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|SA1PR12MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: b7b37ed5-31d5-4290-16bf-08db5b473a7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Py1pRbriC2mThFUUhvoT/4CMli8joweW1gIRcPkQ4fdRuGzvhoqopdw0lwXmMfryBI6M6NghVIEVr6E3D/RSJKL6b5x28oyp23Afo/fxFQQ/eijTWUxTjAmPpYwfXTcZmbLZDyoCuwQywsNLMJi5TgeDfhjS6cbwBh+t8kAw+c0LkGZPpAQ5iO7Hwa/0eZXuh0IJdYQaUnwagVIHZpcqvJzjQFJsLxow0wjJfheCSoiUXoKaxxJgem6m6ICkmzRrqwNMIkRIldOwFXHEj1x8Hj1+2Vc6hX2cZYabsmaktoxDcXTWm8cN06AL0B606IDHLDRUdyRf26uWu+UW/rwMA4MTYjJtuBB15FWB5dgvBKOfeCj5hnXspJxlfwvUIDKcCFj7fXCiVn2601ozErdBpRSWIFjHzj9pqNusQBEuUfAYVrUgYnbMVdEL9zT5yVEUPaRIaKX48qc8BrM5PiK5b5HSxw78o+F22pELL26iS1hC7fTTzQIOS6l36WDrh7jxC37sjJ6gp41fn6KIqX4jTZ0iETN7M/aLdAEo1IzyJk4btZaRAN8w8+AnHGBoWeB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199021)(54906003)(37006003)(41300700001)(6486002)(478600001)(316002)(4326008)(66476007)(66556008)(6636002)(6666004)(66946007)(66899021)(5660300002)(86362001)(8936002)(6862004)(8676002)(38100700002)(107886003)(6512007)(6506007)(26005)(186003)(53546011)(83380400001)(2906002)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PouSnRTZ09rQmkqEJb8pn9r3elaPDKzzs5HHLqLt/e/U+e2//t+Ph3MCoxCu?=
 =?us-ascii?Q?guLnnkn9AWB4VABqSdCU06RuGrZH1dv6pxDsKfgSDT9x+WDYlksRshE5AEXQ?=
 =?us-ascii?Q?RmxhVngpxWmuip1H+vi+FERCyBTrZatDNN3FmULfCYQ53m1CKKoIVrgWnj1y?=
 =?us-ascii?Q?Rbua+ujOTSoKy2DJ8/1z5n4NyaVoJSqNiZEu/9zVybiylq/rhx5V/+XzmsHv?=
 =?us-ascii?Q?mYABa0yTFKC1ygO/DptlNeFW/G8xKk+eg1j+02kPQMu/g+em+5t4b4dpLw54?=
 =?us-ascii?Q?K3+bo5qdUdTxTY5W9KrxE9W501pvv3hm8oLCEUEeVzK5rEN+ESg9fz7SyeQX?=
 =?us-ascii?Q?+ySN9wo+hS0hEIoAZMLKYKSyN4uTctzycNpfMWk5WeSvOGsFDbukC/7coolG?=
 =?us-ascii?Q?QVMiEJCKU0/AHQ6ANRjYnzBT4vvOwB86fddGU4jVltPJb/4c3YRMX+0ZDGGx?=
 =?us-ascii?Q?ZKQg0sLN1NZr1xpiUi/HS4swEGl3CM5wh4AykpCG0W3ecRf0k1KMiIPbCsyl?=
 =?us-ascii?Q?3YF5q1ytP9lgNqxlvQTkDWgZehRbf8DmJ+06hSvcOmFdymW0wbvFiwewqSC7?=
 =?us-ascii?Q?Ytpx0oPmC4nRFnxnUd+dgndLAg1S2t0weRrZmaAYMWfAIg62xzKms+2pkJL8?=
 =?us-ascii?Q?zSCPmHCtxQ9a5P++lvY99+69yB4qChNfGFl9/4iOsMu1W3+vgN7v8j8gd6Yh?=
 =?us-ascii?Q?HO39Ztn1jwxMq8S6wbERgZRfeE7XGgjmZkY5knoDY8Vd2B5aI2/MAspTQdv0?=
 =?us-ascii?Q?AyT+PMBjGxfLcppQuJzy3ICSS4hYZf1N5ypNH9ITEkiqAwPAO2fbNlnEA7dl?=
 =?us-ascii?Q?sCw5jv4ILDzRUn0H71CTJ/UtWlGfJDrRkkBnX6Pj1M2vUd/nAitQEhV8CrV4?=
 =?us-ascii?Q?foAJ+v8eSbeGN5DyOpybxAGc8Pu7zFoPshD6/X5VTwFoSjtdYCAF+hgyAN9F?=
 =?us-ascii?Q?lqQS4JAfrrqTifAFWQV0fOBuw111m9uNacZVZv9KyxJIb89pMvF39LYyghjw?=
 =?us-ascii?Q?eF853Q0fh4as/04Km3aEvaVNdTFCMlaIwcHGZ5LotyErnd/WTN58CCjJWflV?=
 =?us-ascii?Q?ltXqvGiQMx+7uajKbnmNDjmW24Yw0/n4b4335cdYGztpCgbKE3a9fa1BPS6n?=
 =?us-ascii?Q?oxOcGAUf8sTsa1hqW6lOuwhK/UWd7s65bXycQbYM05ztKd7QErNO4pG97k6J?=
 =?us-ascii?Q?mjCiDfDcoggwFqwO1e3XSr4Som1lPEzyQuL7weM0SqqfPF/r5UxXrXsP5yBC?=
 =?us-ascii?Q?UE2/6XCpIA5lLIjk7Hl5q+/iugEqAvmoTHxN+n24/xGDEWzbJpAIWiPx6u+g?=
 =?us-ascii?Q?yj++EtK8AjU0oJrrSjl5fBj8Sxew2WPOBYRj59uhTP+lYI+uVioAJAY2Jkem?=
 =?us-ascii?Q?+FIPNXv7B6fGDXCwSg87EOsFKlgyo0S5qlxtsj/o9Pp9qxtCmSxY8aXScLAf?=
 =?us-ascii?Q?t+D+rdXKeLjPqm6Mj0OF5ymSeIUcOZe9521fNNNs5J3yeg8Tisd4q5ibj0Cp?=
 =?us-ascii?Q?pOs5oUeLn1iD51lr5c9ZkZBUcRCBM+xpPVEgD/MNPKdukBMQYRMCCznzfCp/?=
 =?us-ascii?Q?t4ilRaJXrpRDuwta2aq9vnIbM2BsyFdkrqDagftt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b37ed5-31d5-4290-16bf-08db5b473a7c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 04:36:08.7022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0g/UcFuxF7kK6xSxNzcZm/FcSPjWnHtnTstTUbgIMjy/ww4JqvBGG4IJMD+XlKOIi32Iq35I56gBjkMenrSTNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6752
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


John Hubbard <jhubbard@nvidia.com> writes:

> On 5/22/23 16:50, Alistair Popple wrote:
> ...
>>> Again from include/linux/mmu_notifier.h, not implementing the start()/end() hooks
>>> is perfectly valid.  And AFAICT, the existing invalidate_range() hook is pretty
>>> much a perfect fit for what you want to achieve.
>> Right, I didn't take that approach because it doesn't allow an event
>> type to be passed which would allow them to be filtered on platforms
>> which don't require this.
>> I had also assumed the invalidate_range() callbacks were allowed to
>> sleep, hence couldn't be called under PTL. That's certainly true of mmu
>> interval notifier callbacks, but Catalin reminded me that calls such as
>> ptep_clear_flush_notify() already call invalidate_range() callback under
>> PTL so I guess we already assume drivers don't sleep in their
>> invalidate_range() callbacks. I will update the comments to reflect
>
> This line of reasoning feels very fragile. The range notifiers generally
> do allow sleeping. They are using srcu (sleepable RCU) protection, btw.

Regardless of how well documented this is or isn't (it isn't currently,
but it used to be) it certainly seems to be a well established rule that
the .invalidate_range() callback cannot sleep. The vast majority of
callers do call this holding the PTL, and comments make it explicit that
this is somewhat expected:

Eg: In rmap.c:

		 * No need to call mmu_notifier_invalidate_range() it has be
		 * done above for all cases requiring it to happen under page
		 * table lock before mmu_notifier_invalidate_range_end()

> The fact that existing callers are calling these under PTL just means
> that so far, that has sorta worked. And yes, we can probably make this
> all work. That's not really the ideal way to deduce the API rules, though,
> and it would be good to clarify what they really are.

Of course not. I will update the documentation to clarify this, but see
below for some history which clarifies how we got here.

> Aside from those use cases, I don't see anything justifying a "not allowed
> to sleep" rule for .invalidate_range(), right?

Except that "those use cases" are approximately all of the use cases
AFAICT, and as it turns out this was actually a rule when
.invalidate_range() was added.

Commit 0f0a327fa12c ("mmu_notifier: add the callback for
mmu_notifier_invalidate_range()") included this in the documentation:

        * The invalidate_range() function is called under the ptl
        * spin-lock and not allowed to sleep.

This was later removed in 5ff7091f5a2c ("mm, mmu_notifier: annotate mmu
notifiers with blockable invalidate callbacks") which introduced the
MMU_INVALIDATE_DOES_NOT_BLOCK flag:

        * If this [invalidate_range()] callback cannot block, and invalidate_range_{start,end}
        * cannot block, mmu_notifier_ops.flags should have
        * MMU_INVALIDATE_DOES_NOT_BLOCK set.

However the removal of the original comment seems wrong -
invalidate_range() was still getting called under the ptl and therefore
could not block regardless of if MMU_INVALIDATE_DOES_NOT_BLOCK was set
or not.

Of course the flag and related documentation was removed shortly after
by 93065ac753e4 ("mm, oom: distinguish blockable mode for mmu
notifiers") and 4e15a073a168 ("Revert "mm, mmu_notifier: annotate mmu
notifiers with blockable invalidate callbacks"")

None of those changes actually made it safe for .invalidate_range()
callbacks to sleep, nor was that their goal. They were all about making
sure it was ok for .invalidate_range_start() to sleep AFAICT.

So I think it's perfectly fine to require .invalidate_range() callbacks
to be non-blocking, and if they are that's a driver bug. Note that this
isn't talking about mmu *interval* notifiers - they are slightly
different and don't hook into the mmu_notifier_invalidate_range() call.
They use start()/end() and as such are allowed to sleep.

 - Alistair

> thanks,

