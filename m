Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD52A5EDA90
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 12:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbiI1Kwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 06:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiI1Kv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 06:51:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0446858502
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 03:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664362192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fnqAJOUuiKB1piVG0nPPMmSdhv/P6AfGQwVpRP8lf4=;
        b=MGNekso34/Om2AW4YoHYMZ/q2RrXalyg6EZZwINOP64GZPSYq05CJWGqb6wfReprwQKPNy
        b1pHBWDd1RmYB4tisr1X1FUZSm0xePM62HP3q3rCX4okifBvhbOycZDduiaCbHUolSkXeF
        6V1ooeaEBQoqhNjQFmg7cGJufDRWVQQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-Hwfy8EvFNii5fy5-D932eQ-1; Wed, 28 Sep 2022 06:49:49 -0400
X-MC-Unique: Hwfy8EvFNii5fy5-D932eQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 009CD3C0F220;
        Wed, 28 Sep 2022 10:49:43 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D19652027061;
        Wed, 28 Sep 2022 10:49:35 +0000 (UTC)
Message-ID: <c1168e8bd9077a2cc9ef61ee06db7a4e8c0f1600.camel@redhat.com>
Subject: Re: [PATCH v2 1/5] perf/x86/intel/lbr: use setup_clear_cpu_cap
 instead of clear_cpu_cap
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
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
Date:   Wed, 28 Sep 2022 13:49:34 +0300
In-Reply-To: <YzGlQBkCSJxY+8Jf@zn.tnic>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
         <20220718141123.136106-2-mlevitsk@redhat.com> <Yyh9RDbaRqUR1XSW@zn.tnic>
         <c105971a72dfe6d46ad75fb7e71f79ba716e081c.camel@redhat.com>
         <YzGlQBkCSJxY+8Jf@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-09-26 at 15:12 +0200, Borislav Petkov wrote:
> On Tue, Sep 20, 2022 at 11:20:47AM +0300, Maxim Levitsky wrote:
> > If I understand that correctly, the difference between clear_cpu_cap and setup_clear_cpu_cap
> > is that setup_clear_cpu_cap should be called early when only the boot cpu is running and it 
> > 
> > 1. works on 'boot_cpu_data' which represents the boot cpu.
> > 2. sets a bit in 'cpu_caps_cleared' which are later applied to all CPUs, including these that are hotplugged.
> 
> Yes.
> 
> > On the other hand the clear_cpu_cap just affects the given 'struct cpuinfo_x86'.
> 
> Yes.
> 
> > Call of 'clear_cpu_cap(&boot_cpu_data, X86_FEATURE_ARCH_LBR)' is weird since it still affects 'boot_cpu_data'
> > but doesn't affect 'cpu_caps_cleared'
> 
> Yes.
> 
> > I assumed that this was a mistake and the intention was to disable the feature on all CPUs.
> 
> peterz says yes.
> 
> > I need this patch because in the next patch, I change the clear_cpu_cap such as it detects being
> > called on boot_cpu_data and in this case also clears bits in 'cpu_caps_cleared', thus
> > while this patch does introduce a functional change, the next patch doesn't since this is the only
> > place where clear_cpu_cap is called explicitly on 'boot_cpu_data'
> 
> This is not needed - this patch doing setup_clear_cpu_cap() should suffice.
> 
> But, there must be something you're fixing with this. Which is it? Some
> weird virt config?

Patches 1-3 don't fix anything - these are just refactoring to make the code simplier.

This particular patch is done to enable the refactoring in the next patch by removing an
(hopefully broken) outlier.


Patch 4 is small fix in the sense that it allows the warning from the current cpuid filtering code
to be seen (it is supressed in early code, but then it doesn't usually happen again, so no warning
is printed at all)

Patch 5 is the main fix - it  makes the kernel to be tolerant to a broken CPUID config 
(coming hopefully from hypervisor),
where you have a feature (AVX2 in my case) but not a feature on which this feature depends (AVX).


> 
> > I do now notice that initcalls are run after smp is initialized, which
> > means that this code doesn't really disable the CPUID feature on all
> > CPUs at all.
> 
> Well, not exactly. There's do_pre_smp_calls() which is where the
> early_initcall() thing is run.


Aha! I was reading the 'do_initcalls()' code and thought that it
goes over all initcalls.

note that it turns out that this function is called 'do_pre_smp_initcalls()'.

> 
> So setup_clear_cpu_cap() will make sure that the feature bit is cleared
> when the APs come online.
> 
> Do you have a virt configuration where you can test this case where the
> feature flag is clear on all CPUs when it fails?

This needs the arch lbrs which aren't yet supported by KVM (there are patches
on the mailing list), plus I need a hardware which supportes them, of which
I don't know even if intel released any yet.

I can hack the code/KVM though to simulate enough of it to see if this failback
happens.

Besides that, anything else I should do to to see that patch series merged?

Thanks,
Best regards,
	Maxim Levitsky

> 
> I.e., "arch_lbr" will disappear in /proc/cpuinfo completely.
> 
> Thx.
> 


