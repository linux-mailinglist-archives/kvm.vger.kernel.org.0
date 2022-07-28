Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4808C583988
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 09:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiG1Hax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 03:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiG1Hat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 03:30:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 126C75140F
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 00:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658993448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ux6VwMtMxHO2mepOlWLk/n9XMR06YLsuanCnSO2VUjI=;
        b=EWH0svMqrd1xmc8XfKXT2oLjHJfGoWEKiWiJQQyiRb/6TCBBQv4Qh7bfdsBIbdYr+gZUUR
        WACwjhGvFe0sVuwHAZV8FH5WgmXuKo39QI6Hrm0Ho/M9e9gikU0FUgw8TMHMVATazGJJB3
        khkW06sdV0TqnzIeuROCAOyS5mLIheg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-fvFAbU1_PgCryZqHIMMp5w-1; Thu, 28 Jul 2022 03:30:42 -0400
X-MC-Unique: fvFAbU1_PgCryZqHIMMp5w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC6E2185A79C;
        Thu, 28 Jul 2022 07:30:41 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 332ED492C3B;
        Thu, 28 Jul 2022 07:30:34 +0000 (UTC)
Message-ID: <fad05f161cc6425d8c36fb6322de2bbaa683dcb3.camel@redhat.com>
Subject: Re: [PATCH v2 0/5] x86: cpuid: improve support for broken CPUID
 configurations
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Date:   Thu, 28 Jul 2022 10:30:33 +0300
In-Reply-To: <20220718141123.136106-1-mlevitsk@redhat.com>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-18 at 17:11 +0300, Maxim Levitsky wrote:
> This patch series aims to harden the cpuid code against the case when
> the hypervisor exposes a broken CPUID configuration to the guest,
> in the form of having a feature disabled but not features that depend on it.
> 
> This is the more generic way to fix kernel panic in aes-ni kernel driver,
> which was triggered by CPUID configuration in which AVX is disabled but
> not AVX2.
> 
> https://lore.kernel.org/all/20211103145231.GA4485@gondor.apana.org.au/T/
> 
> This was tested by booting a guest with AVX disabled and not AVX2,
> and observing that both a warning is now printed in dmesg, and
> that avx2 is gone from /proc/cpuinfo.
> 
> V2:
> 
> I hopefully addressed all the (very good) review feedback.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (5):
>   perf/x86/intel/lbr: use setup_clear_cpu_cap instead of clear_cpu_cap
>   x86/cpuid: refactor setup_clear_cpu_cap()/clear_cpu_cap()
>   x86/cpuid: move filter_cpuid_features to cpuid-deps.c
>   x86/cpuid: remove 'warn' parameter from filter_cpuid_features
>   x86/cpuid: check for dependencies violations in CPUID and attempt to
>     fix them
> 
>  arch/x86/events/intel/lbr.c       |  2 +-
>  arch/x86/include/asm/cpufeature.h |  1 +
>  arch/x86/kernel/cpu/common.c      | 51 +-------------------
>  arch/x86/kernel/cpu/cpuid-deps.c  | 80 +++++++++++++++++++++++++++----
>  4 files changed, 74 insertions(+), 60 deletions(-)
> 
> -- 
> 2.34.3
> 
> 
A very kind ping on these patches.

Best regards,
	Maxim Levitsky

