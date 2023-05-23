Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66F670CFDD
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjEWAye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235244AbjEWAyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:54:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC872139;
        Mon, 22 May 2023 17:48:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C98pppIbG0Q+JJ1FEjXeP9qVZR1cPYCj4HjrU8n3f0BU3rP/dLmQ1bP7Z1w2J1DEfRGI2pfY0jcsmOqQsmV1ILlefFo8AAZbYHSElPwItNuEQIC+wypt4OTb8PCgoNO9F6mekWG9AAupBlLZvFYX9jxPhh4id6Yl7hWtiFewT8Yz5BJbsM10K8Hw2NLnDJNUpLfi2Xr7GNNj4Nt5qctAm19KtrY7cFdBK8n/ePipNaSCczgrvTwWNdkS6WvnuIrX044PrphJNbtWOjurKuoAGVF9NPsAa2ovwrJuXCJhX1F1KyY9+fqDtxfrOnuFOMM/cFl8pdM7lFIgLoEdRhW7nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AllstN60M7xRCDeVJkT6HoMgkly4ZZP75yVXjI32Qw0=;
 b=jap69jOSI7L1YGkYtdYoYYC0fxN+cFEM3zqOd9xJr3frcbZ0OtjZbA4RlTYnMwNZx6uRskYBMRPKCVQrqwDCavA9K11Xdoiyjq+7upQUOxy8Au2RSXGtGgo8ZlGvtO+WJXv3wm+WxzV5yY7bXLHeCMhbhcyaOkzQ1ifwxtqLcfqGei82pA4S5qAd/4m4CK7ALqralYItAX5/LnDE0ygr5fCkJpKmpcQ2Fj7Lb5kIDwqQZGbaqW3ReKj7pqpSqohg2HfH+x2j7SwnyWgzJFSh7wj2r3nwPTebxmqHplaL0yRKvgU3WxlkDzONEpV5qgJZqJtN8LYtclD3KbRJKCZZlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AllstN60M7xRCDeVJkT6HoMgkly4ZZP75yVXjI32Qw0=;
 b=XUjeer1omxaMkg/8wP3ABtl2HNV4FomOLhcCWtRRgf0wnGRHx14dPX3AP9zEWOgaxb0lfZqazlCezmhqJQvXeAs+2Z6lhJ8aapajEa8AQWa6vfRBxdmz0rA8FZU2mNnHtDPh1/jHg9602XVzUUwuOMs13SrSvUEvzLwtM4cavgDl7UZeLAEes0noJ0fJGwWHPbbVSAlxP2mMltcQevdYV2uBRlRsd55SJao6oVBxC7/DXVVAIgXLEZnYD3gxMSgjBxsu0PMeFn0c2TcIg13ecYapV26AevQU7cjpKCOtepmduphW4yHYkLwO4XT1JipJKt6W31y3KLXJHao3t6/yPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM6PR12MB4315.namprd12.prod.outlook.com (2603:10b6:5:223::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 00:46:58 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 00:46:58 +0000
References: <20230522063725.284686-1-apopple@nvidia.com>
 <ZGu1vsbscdO48V6h@google.com> <875y8jappz.fsf@nvidia.com>
 <ZGwDoONUFAHi7XKz@google.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        jgg@nvidia.com, John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Date:   Tue, 23 May 2023 10:43:17 +1000
In-reply-to: <ZGwDoONUFAHi7XKz@google.com>
Message-ID: <87wn0z98n7.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SYXPR01CA0143.ausprd01.prod.outlook.com
 (2603:10c6:0:30::28) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DM6PR12MB4315:EE_
X-MS-Office365-Filtering-Correlation-Id: adc92530-b127-482b-e3cd-08db5b2736bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Km1COjutpSICGrn1oQM5/e1e78utryBl+xvlD8sUslh0MhYHjrJ8Kp3HKRovwF/CoWLEMFZinzwFezpqCrjPCAsSuxX/au1luxtNsTGQ4jbUBYfzEkVz22xLsc7Fq1weribvJaRgzOO94gJ0CnqYT/YPlfcxqz0kCNY71EPv5kiLlMJqLnfCdpC6qRasYPmRO3Qwx1hvwW/baOHaK51YwJA8N0e+9MZcQTENOEQn2t7LxbtA5PRe2WRYpLRk8jsnnBuJs6Ti/1UMdL1YRuY1RVyEclfwAbA5LvDWBQA32mKUydzOagYNIo1ajudtig36kYuPerEy1rHEWCuDIQi+KONU+K+tqakZlhKwrY5QUdvD21ZamSlfC9ztQSjIprm5K7Er+BW0P9wsXMf6NAg4pFEpCoCo8t0NaE0ILxRuwgG+dlcEpH21QBECgYxaI6SO+4v2qwBEg3eHZuYtRgSBTl1JSpUtqPNUUbewYyRcLzdYyhpqCDWUjrQyj5ZmoXoZZjD6ISEad6t3rAVyer9pP9QQhb18RDyEDkUVbNygKmv5qizPw6z5s7uovvh2oZwsVgI2sy3Wq00MMDosAdtk5JYofG/f/agVJxHxOx3sOtY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199021)(8936002)(8676002)(5660300002)(83380400001)(26005)(6506007)(6512007)(107886003)(86362001)(2616005)(186003)(38100700002)(966005)(478600001)(6666004)(6486002)(66946007)(316002)(6916009)(4326008)(36756003)(41300700001)(66476007)(66556008)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a72ko43rOAQRKlaMX4JoSWjHYz3e2NmF5rmEkiLmDToi82XjjjPYCQidqtQ3?=
 =?us-ascii?Q?vKXhPvj6W9sboj0hS9tcCY+Z9gjIS/l9p8DQ+7Bh62kTRYQckHnH5RjmLFnl?=
 =?us-ascii?Q?S1UyLq+hrPLYp3UQeqePwKeYZ1V/lJrAwLvKimNYDMdxCg75yj0xjTWOkRmw?=
 =?us-ascii?Q?oeqD9tlxOywxrecMdUTtatgTmQm23OU9saOI2U/t39nwcpbBSCaFicnxL0fv?=
 =?us-ascii?Q?2UOGtlUHkK2wo8suqMlUdL/eGM/dNJXqIil8Z8htYOBhOLUs+Gi8VympLnNe?=
 =?us-ascii?Q?NnA1nwBEJzXFcnpCEQJ7EOEIPpPR5rNJxCYbJciZN2iyii7XZqyhXMi15f/B?=
 =?us-ascii?Q?RcnjYWlqkNCEwioC+7iaQsMvqSmVxknnKtMrBi6wXzGFXe3xkRiW6PLV9JRY?=
 =?us-ascii?Q?+g7NcfCp1J/FuguF/iAyaKtG1PZ4QiHYDBTb4+KCqxM/ul2klL4Uneo2pkfG?=
 =?us-ascii?Q?XECDQGL2vvmjRXDgXDOtSN+B8bnBrGxjG4UICMW2vSo9qZ1Q6d0dsGyUxdwa?=
 =?us-ascii?Q?sAWWIxDwW/CFzO+/jD3sZBNMD7ySi9etjQ1+N/HkQlR+HIqBdMGZsAxuJ7LY?=
 =?us-ascii?Q?HiGmOarqoTcjGDYkkDBlO4b095PW3SuLJpp/F2xh08bqBuGLUkczPRZx+B/F?=
 =?us-ascii?Q?OBk9wsj8FxFz8Nol/hNvmzXeP4xp8uXTCGM7A0jcdQ1t0kfRg9DWvlEUUILM?=
 =?us-ascii?Q?bn09zeOCYH0vERXQnrFa3oQLpSUHHJPucuOgBufZCOYemiaTrCgDd2WVWVSa?=
 =?us-ascii?Q?j6Qrh33vMAFOIpUMtPETA/2wBOYetPqdJEXLPYIDYWaKkBF9tiEG7BM0FGmX?=
 =?us-ascii?Q?XVV4tW274n0opZodT4Ky70G9CBDToI3YtIetreT0Q0N/Ut9lDwcZWd35eyqe?=
 =?us-ascii?Q?LPKaRN1iUuGr7UAlKVqiLZRnSjRh7d8ZD01hnTlyzYd6Ck83HTO9JaJW2l8N?=
 =?us-ascii?Q?w4WmpEmDXevBCzNSl3FyaxPsVbdX2QykKSaYRS7CGJLQCsl1lRx3gWEuCY8e?=
 =?us-ascii?Q?HcFfaalTCfDYkR6I7Yr1+vVj3I+jvrjWRi2WbRNGB9bHyQXaPvktyNDFVj87?=
 =?us-ascii?Q?uEExGbqb0lnditAgqe60feeTghT5inO4rTjVskCOKo5QhYn9Ba96O/oxazHh?=
 =?us-ascii?Q?a3DojUpi3IfRUb4Ftv7eKsrVl/n7qsZ7GmgqUeeTvkjPsrI0yXsaHUGJ14Lt?=
 =?us-ascii?Q?qXkbCGodWLmorADMjG780Gd93lsfLCVVSVc7ZK/kmMf8uSPdM9hkm/JuNeHc?=
 =?us-ascii?Q?/LOGUO1bsW177wFxzUWqY5qjiaO9ioY1dHiJjbcIpNCGboqE5Vq3F53gTzFl?=
 =?us-ascii?Q?c6Z18G4aHhfxm11iidkj+OXzGC3N0rDPj1qSPF7Wp5u2JK8lHhQzTfZigdIS?=
 =?us-ascii?Q?u/Xn5DJXo6q157l6wSxKOcpmtfvjosoJb8vDyXzW+3d0bfq+qC1A/WPcx4oH?=
 =?us-ascii?Q?rG0LMGCeu1tpXyYw/usYAEsnsAyA4Ais5JJ6v2fxSKyD/5m6w9L2bjn0UmJf?=
 =?us-ascii?Q?R1SKLRO/IrnieuiApER8GAXfIqCKCnTi5mrpdELR8HNnW/veYHl0Qw/VyNjl?=
 =?us-ascii?Q?92WXKxJydgq1IjqZG9bfNb038+j3/HVXfC0wJOKL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc92530-b127-482b-e3cd-08db5b2736bb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 00:46:58.4789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKdVTTII3pk7X71LNbu7uEAIRVAyjCbk7m5pMjdVqOe/G+aOhITSpDF4Pxxois1CepTyuT89DIxbprlSEOCWDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4315
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


Sean Christopherson <seanjc@google.com> writes:

> On Tue, May 23, 2023, Alistair Popple wrote:
>> 
>> Sean Christopherson <seanjc@google.com> writes:

[...]

>> > 	 * If invalidate_range() is used to manage a non-CPU TLB with
>> > 	 * shared page-tables, it not necessary to implement the
>> > 	 * invalidate_range_start()/end() notifiers, as
>> > 	 * invalidate_range() already catches the points in time when an
>> > 	 * external TLB range needs to be flushed. For more in depth
>> > 	 * discussion on this see Documentation/mm/mmu_notifier.rst
>> >
>> > Even worse, this change may silently regress performance for secondary MMUs that
>> > haven't yet taken advantage of the event type, e.g. KVM will zap all of KVM's PTEs
>> > in response to the upgrade, instead of waiting until the guest actually tries to
>> > utilize the new protections.
>> 
>> Yeah, I like the idea of introducing a
>> ptep_set_access_flags_notify(). That way this won't regress performance
>> on platforms that don't need it. Note this isn't a new feature but
>> rather a bugfix. It's unclear to me why KVM on ARM hasn't already run
>> into this issue, but I'm no KVM expert. Thanks for the feedback.
>
> KVM manages its own page tables and so does its own TLB invalidations as needed,
> e.g. KVM can and does change KVM's stage-2 PTEs from read-only to read/write
> irrespective of mmu_notifiers.  I assume the SMMU issue arises only because the
> SMMU is reusing the host kernel's (stage-1?) page tables.

Argh, thanks. That makes sense. The SMMU issue arises because it is not
snooping CPU TLB invalidations and therefore relies entirely on notifier
callbacks to invalidate it's TLB. If it was snooping invalidations it
would observe the TLB invalidation ARM64 does in
ptep_set_access_flags()[1]. Now that I've figured out we can call
invalidate_range() under the PTL I think I can just add the notifier
call there.

[1] - https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/mm/fault.c?id=ae8373a5add4ea39f032563cf12a02946d1e3546#n229
