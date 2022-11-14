Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46959628DBE
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 00:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbiKNXxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 18:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiKNXxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 18:53:31 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2089.outbound.protection.outlook.com [40.107.95.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD32C1B;
        Mon, 14 Nov 2022 15:53:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fU0Q3srOwsO7v1cmAXCCQIYTE4h3e76W/l3XUE13Ocr+UPio66yIaQt5ApFcsdQ6v2Z6VRgNgK6UUSgzGSsZrHXLeqLA384Hp+XgwLxfpwWigcOrhpJnFVHBbRK+oSaqvDw860NmNphr/ByXPk3sIc81/pKwMoHlO04Jpv2qoRshAg4vmbM4IaOhxSwjLzgI344JzABsw0DVHQXuKdxcPubNhbQs6aVUGWvPromIoifNXrMoO2yLF6TA5Ulpv4CtBYtD843qGMJ0CqRk1MUOzUhBZm9ldF83wgN9ySg74sPd8GYk5Huy/zz+Gh1nEWaqda22Lvv2iLMqfbKQ9FEgVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8wrY7etP3YBArEWJrVPgRKLjXibtanOJ8FMZK/0/Qk=;
 b=TMkD8pX2TCnvB7O6QbwrOga9YKIDmkC5dYXcba3YabP+pzbMKwPeyZSE3O2XlKhT7P07L6Xm7knpo/IqkL5MdMOtbutFsbaYWcmBB44iUIjs2COVvTsdi7QND0Gbs1WVUvffE61xrbgY0NauPGn+JQq71fjvWZrXNczGJqtAClstzZXOFf3tKY6LEXjTJbDR1I7M0MeLQ3JHvZUs5CpnGcpM2W516MbLgCg43AHNVX7/ojsw2MF+klWE7tlkh8nCy+Qce68FPdbjrVjSxvXLU2bGKbJwV/fp28e8QrGIkCS/RwUQwEbW68jfb1mp+8hn7nQSmZNlYeO9uZJ0H83Tdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8wrY7etP3YBArEWJrVPgRKLjXibtanOJ8FMZK/0/Qk=;
 b=HQWmmVR2XFyKXqjcxRSL9nd+uXQCTR7N7O9ZzXzKkblaejpklpcw8lg0oYPksrkPI7fCDjfOsimBGrrkreLqTFuQUyl+seidSgNMllgGw9aK4cTW2gpXC3xbI4mL4ESByUFaLsWiwmVY7XfTK9IURJ8wU1T5DAk8y4UB0tXUQCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from MN0PR19MB6407.namprd19.prod.outlook.com (2603:10b6:208:3c0::20)
 by BY3PR19MB4852.namprd19.prod.outlook.com (2603:10b6:a03:368::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 14 Nov
 2022 23:53:24 +0000
Received: from MN0PR19MB6407.namprd19.prod.outlook.com
 ([fe80::db4d:6649:2aef:bae9]) by MN0PR19MB6407.namprd19.prod.outlook.com
 ([fe80::db4d:6649:2aef:bae9%5]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 23:53:24 +0000
Date:   Mon, 14 Nov 2022 16:53:12 -0700
From:   Greg Edwards <gedwards@ddn.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: x86: Allow APICv APIC ID inhibit to be cleared on
 legacy kernels
Message-ID: <Y3LU6Eg4UaaI6bXu@bobdog.home.arpa>
References: <20221114202037.254176-1-gedwards@ddn.com>
 <Y3KzarZ5xzExFrj9@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3KzarZ5xzExFrj9@google.com>
X-ClientProxiedBy: CH2PR15CA0028.namprd15.prod.outlook.com
 (2603:10b6:610:51::38) To MN0PR19MB6407.namprd19.prod.outlook.com
 (2603:10b6:208:3c0::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR19MB6407:EE_|BY3PR19MB4852:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a9a2337-7545-40bc-786f-08dac69b6616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OZL0nkQd1cGqLGeRWYPQ44Vv2LPxy+PSdtTmcF1P8tsSsp2omYZ+ltmTaBOPS6TLcrxQcmzPWcbYoKf4nlHlrXzX4/EUqfxodZVxnrc1Y9kVV4r7owZJ2JVi4yMlfHMnNf2Ch/RyYkTRNpFHK+ygEJgFLyk6I9HTXteRTyPHXX3wd5QjHOZlnKMixMTPkbrFDtwkqYWL4Kav1Nz/I+/COPqb2gi66p/bXDUcWt+11ZiDqtiql02CKIQOU+vkYN3DTaFDAfF+A+vnohaNninak9O+4orfDAyPURPKLAsBqPEH9GoCHfzPa8yA/2kMC0cloigCa6evFj3/sgYUxg+WnTA1LHWXk9Gjej8NXqniYUXfbzDLhwNL3F6R/fFzqmA5zT2iPWdelhNuauuuC/p4r2vNb4TKkcNJ9hl7mwhw39M3MkKlybmwDIwciAK+gGxCxa07pGEWrZaglbxVnVRMjnAu9a9+udaghE+yG05vYQZ/VeHEUnT6RRmrcntRpxgTs5xCD7Z+Skssnqj2NJZAlWUAcuVNh+UOJjSsi3vpr6pzF6r6CR/jGcJto9QYI6z8qnxZ1wDo52AdvhM81ss6V2aC+2+X8CyFXigo3iR7nn7MSqSbDAp7OJF2zTmAeWzRCKAzb9XcNYO+ubGhejVMrZS7XYzJQlsVo43l0CyJf7woJWKhLgXHUtXC0GjtOu3aWVu5VJH02RqwUxDTyV95g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR19MB6407.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39850400004)(346002)(396003)(366004)(136003)(451199015)(6916009)(316002)(2906002)(478600001)(6486002)(54906003)(83380400001)(186003)(38100700002)(6666004)(8936002)(9686003)(6506007)(6512007)(66476007)(66556008)(66946007)(41300700001)(4326008)(5660300002)(86362001)(66899015)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zY0XHb8rPF59e5egcQzSNDZkQjolqxfmTz+NqsLnE7vtQOMKRazEkQNKNS61?=
 =?us-ascii?Q?F07esf12EyEvr+xEIi/cfSXs3eMvoSc/s2mV6rb9PUDp0PifG9bK5jgf6Yt0?=
 =?us-ascii?Q?g2gJPsvV1zN0AKQrlIn3b4WW8mfdhiCD5l1Gog9cbrFzmRLSj7LK45QVrEix?=
 =?us-ascii?Q?ln/k2xkLlcPBdF4PbFxuu0HIPtTzj95PlwK6BPY1EiQgRfqDnJtUXToTN0IR?=
 =?us-ascii?Q?QXR32uxFIj1u7VV4VbIaXNNQ8ZqJ7eWHdas2JQaseCBGMn38RrPpOCZLual9?=
 =?us-ascii?Q?Nef8S6ldB6o+39ukD8yPjEQ61XfsYPH0diJiTL8qUp1vso2pNeHoxliM6VHn?=
 =?us-ascii?Q?5H0I9JHEKmajyVUx54Xs4HutbG0KIGdPpo/63utJhHKzcSf9dtpYRms5fko1?=
 =?us-ascii?Q?Vo1sm9SLAUnJWY7k3BT2E+OLNcGX/FehSZJ05dIhrgoDrNBBZe3q6eoBBbiF?=
 =?us-ascii?Q?2dMLmb8Cdp3FhKmLUTceaRShuxaSfK+hZiJRDW4VfY3OUZE4LlvzlcTrQt6r?=
 =?us-ascii?Q?HDuWxF2OuxamO0bPD65rChoPrraaKNvNz7tkfiIPkMPI8hv/y4FXNiM8QJDv?=
 =?us-ascii?Q?mucSQi1lpU5/nGTRdTSl4Sr4lYj+iTQ9C5RVd/DsepLBEsmmWSXZFH2wKd7G?=
 =?us-ascii?Q?76WwcXHz5H3SBKLtk5ARjr7fZ6AqOFiir3NeYbta8Zt1MrvD0Z7g4wtmCC3r?=
 =?us-ascii?Q?59QftubL/f3+yScWLH4xLAus+OoJPTiNY3AEBqVrujzLRYtz9syxLsrlbbey?=
 =?us-ascii?Q?KESAMiLvhs3Y9niwEllebFTmjeLtTUQIpcuEs86JPolhOuKXK0EmmNv9xVb3?=
 =?us-ascii?Q?zSuTkT9C8k5adpAI/wbdrLtXKRqaqnZZQpqe8ES8SvBZ7x+Z0tA2AhhY18Qc?=
 =?us-ascii?Q?/XM3Kp7QWTc5UYlY9mCVODtxWfE5t+ov1DWEYytOjss3wGVlJprXcNrNvZZy?=
 =?us-ascii?Q?M3H2me193Z7qZxJnLx0Em5molrx3B2+hBsKxDiS8lmQjTBkk8w9UyzG3m8ZQ?=
 =?us-ascii?Q?oE+396FtwBfRIaetMkIPHiezYgNNhTTo4KoThORUBM2CRD3hzv7gQCaqzwDH?=
 =?us-ascii?Q?Yl7z8WJDgQEeXlbnIjoYbmKixueN/Tt3mi7Z5ug3owBrm2HcW2HR5CF0Sred?=
 =?us-ascii?Q?d/qVq6xOezTkBoJGGElpiCHFNlCKqdKLJYjVhwcCb7pUk/HJvllz0nB0vydH?=
 =?us-ascii?Q?NYXVAmAPWUk5WlBo4WV/ZNkFLWhSWmVFLluaHqeW65jCztC4bLptUoBom6VD?=
 =?us-ascii?Q?P93Br4lBZjmgsLGZTYy2adJviAwerNJ0O3Uls7Cmz2p0tAzou/1cwWJmZpgW?=
 =?us-ascii?Q?l9HJgbwieWuu8/cFTE73H0D7EgmEGkE5zDHojeLFnDLk5FBkQt7BNLCk3pXv?=
 =?us-ascii?Q?n6EJlMIhtuG0WlNEVNYIcEV4+Gpet0o2eI8XnppMYXHoter42NhTMX1P7UTu?=
 =?us-ascii?Q?XjMuO3B4FyNVQd5obtkaIlVzsXccoh2GZQhidodrHuHxvsAZ8/mVcXHP07sl?=
 =?us-ascii?Q?PaxhvtG5qkuD2hvN+A7wdpWRfy0BnLQQx5R9Mx8i0B/adUJi31tq1LkPdbII?=
 =?us-ascii?Q?TH142RfsQpqZipP/l8UmCxdRv4CQObipkM/tW2It5xzoZt91izBWEvgB1SY0?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9a2337-7545-40bc-786f-08dac69b6616
X-MS-Exchange-CrossTenant-AuthSource: MN0PR19MB6407.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 23:53:24.4330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlYTMkVhQq2CUKW/UWN/j5yEFnxqoCIxqenNH+sGE85vXD30i8XXZyVwVujj9dFn0hJZrBksnlPzP0JyTqK4rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR19MB4852
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 09:30:18PM +0000, Sean Christopherson wrote:
> On Mon, Nov 14, 2022, Greg Edwards wrote:
>> Legacy kernels prior to commit 4399c03c6780 ("x86/apic: Remove
>> verify_local_APIC()") write the xAPIC ID of the boot CPU twice to verify
>> a functioning local APIC.  This results in APIC acceleration inhibited
>> on these kernels for reason APICV_INHIBIT_REASON_APIC_ID_MODIFIED.
>>
>> Allow the APICV_INHIBIT_REASON_APIC_ID_MODIFIED inhibit reason to be
>> cleared if/when the xAPIC ID is set back to the expected vcpu_id value.
>> This occurs on the second xAPIC ID write in verify_local_APIC().
>>
>> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
>> Signed-off-by: Greg Edwards <gedwards@ddn.com>
>> ---
>>  arch/x86/kvm/lapic.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index d7639d126e6c..4064d0af094d 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2075,8 +2075,13 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>>  	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
>>  		return;
>>
>> -	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
>> +	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id) {
>> +		/* Legacy kernels prior to 4399c03c6780 write APIC ID twice. */
>> +		if (!kvm_apicv_activated(kvm))
>> +			kvm_clear_apicv_inhibit(kvm,
>> +					APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
>
> This sadly doesn't work because the inhibit is per-VM, i.e. will do the wrong
> thing if there are still vCPU's with different APIC IDs.

That is true.  Thanks for pointing that out.

> Does skipping the check if the APIC is disabled help[*]?  At a glance, I can't
> tell if the APIC is enabled/disabled at that point in time.  It's not a true fix,
> but it's a lot easier to backport if it remedies the issue.

It does not.  I did find your patch series when I started investigating
this, but the behavior was the same on that series.

> For a proper fix, this entire path should be moved to kvm_recalculate_apic_map()
> so that can can safely toggle the inhibit, e.g. the recalc helper already deals
> with multiple vCPUs changing their APIC state in parallel.  I don't think the fix
> will be too difficult to craft such that it's backport friendly, but it would need
> to be slotted into the series containing the aforementioned fix.

Thank you for the suggestion.  I will take a look, and start from your
series.
