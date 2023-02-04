Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC9C68ACE3
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 23:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjBDWcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 17:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjBDWcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 17:32:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2770E23112;
        Sat,  4 Feb 2023 14:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=KQh88XbsUhz1qg8j553C7PJkpbk+sVrvN6vVjGTZA4o=; b=aK5SHrmjBbZoZkEGl/6tMN4pjL
        0Mdho5yapH9Xe/6SSEJRzB5eyL73XPi0wk6jlCEgn5YF7LUGw7Kp72jMtXDg1lglypxAnBUNx3F5O
        zJg1Amz0EwtP+9eEgLlsaq0gAyGYS9Ahb7q3osKs0AebuIeQH7trEFvyf5OyE+j0tKSALzR7DTv1P
        J1XwjRYJkejwF+bGpKqjUU1piFNeg4BdmqXoxgB9FVqTk/fILsHI+H2w38cxmUWkWERs+iaUHR6Bn
        GM46pPoxDGZurcslluuUeCke+UuIaowsL4ETuThXSroDBH1Vd6oErJj9eOp3dS+BNDoXP+B8KMQ9N
        0ZfND57w==;
Received: from [84.64.40.55] (helo=[127.0.0.1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pOR4H-00FTLV-9M; Sat, 04 Feb 2023 22:31:34 +0000
Date:   Sat, 04 Feb 2023 22:31:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Arjan van de Ven <arjan@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de
CC:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Mario Limonciello <Mario.Limonciello@amd.com>
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
User-Agent: K-9 Mail for Android
In-Reply-To: <5ba476f3-e0ac-d630-ce1d-18ab9885496f@linux.intel.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com> <20230202215625.3248306-8-usama.arif@bytedance.com> <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com> <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org> <5ba476f3-e0ac-d630-ce1d-18ab9885496f@linux.intel.com>
Message-ID: <E2286684-F8AD-4708-9A3D-74C5EAE183B4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4 February 2023 18:18:55 GMT, Arjan van de Ven <arjan@linux=2Eintel=2Ec=
om> wrote:
>>=20
>> However=2E=2E=2E
>>=20
>> Even though we *can* support non-X2APIC processors, we *might* want to
>> play it safe and not go back that far; only enabling parallel bringup
>> on machines with X2APIC which roughly correlates with "lots of CPUs"
>> since that's where the benefit is=2E
>
>I think that this is the right approach, at least on the initial patch se=
ries=2E
>KISS principle; do all the easy-but-important cases first, get it stable =
and working
>and in later series/kernels the range can be expanded=2E=2E=2E=2E if it m=
atters=2E

Agreed=2E I'll split it to do it only with X2APIC for the initial series, =
and then hold the CPUID 0x1 part back for the next phase=2E
