Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A555784E7
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 16:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiGROLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 10:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbiGROLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 10:11:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 744DA275C1
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 07:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658153495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Vcb7EQNP7nmt18gfIk7EjblaRPAfBOgB5YIPuamopdk=;
        b=P6LeF3xy/AR8U+qPK2zn8jA2WE0n/eL430TrlyWfryMyq9BJC5L8fvy9mJYjnikzH8PJma
        HSX4P+p0fJ4MH6sK4llwSdZc161JFaB9iiPFHom4R5dX1/CPMtJk4heJg0JV+2yNH+P06w
        SpsfjxTDRVpwO5ZMrRXgIPV5SDyp7kQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-HEpFr7HLMUadJh7iEE8vwg-1; Mon, 18 Jul 2022 10:11:32 -0400
X-MC-Unique: HEpFr7HLMUadJh7iEE8vwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43E78801231;
        Mon, 18 Jul 2022 14:11:30 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD78B2026D64;
        Mon, 18 Jul 2022 14:11:24 +0000 (UTC)
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
        Maxim Levitsky <mlevitsk@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        linux-crypto@vger.kernel.org (open list:CRYPTO API)
Subject: [PATCH v2 0/5] x86: cpuid: improve support for broken CPUID configurations
Date:   Mon, 18 Jul 2022 17:11:18 +0300
Message-Id: <20220718141123.136106-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series aims to harden the cpuid code against the case when=0D
the hypervisor exposes a broken CPUID configuration to the guest,=0D
in the form of having a feature disabled but not features that depend on it=
.=0D
=0D
This is the more generic way to fix kernel panic in aes-ni kernel driver,=0D
which was triggered by CPUID configuration in which AVX is disabled but=0D
not AVX2.=0D
=0D
https://lore.kernel.org/all/20211103145231.GA4485@gondor.apana.org.au/T/=0D
=0D
This was tested by booting a guest with AVX disabled and not AVX2,=0D
and observing that both a warning is now printed in dmesg, and=0D
that avx2 is gone from /proc/cpuinfo.=0D
=0D
V2:=0D
=0D
I hopefully addressed all the (very good) review feedback.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (5):=0D
  perf/x86/intel/lbr: use setup_clear_cpu_cap instead of clear_cpu_cap=0D
  x86/cpuid: refactor setup_clear_cpu_cap()/clear_cpu_cap()=0D
  x86/cpuid: move filter_cpuid_features to cpuid-deps.c=0D
  x86/cpuid: remove 'warn' parameter from filter_cpuid_features=0D
  x86/cpuid: check for dependencies violations in CPUID and attempt to=0D
    fix them=0D
=0D
 arch/x86/events/intel/lbr.c       |  2 +-=0D
 arch/x86/include/asm/cpufeature.h |  1 +=0D
 arch/x86/kernel/cpu/common.c      | 51 +-------------------=0D
 arch/x86/kernel/cpu/cpuid-deps.c  | 80 +++++++++++++++++++++++++++----=0D
 4 files changed, 74 insertions(+), 60 deletions(-)=0D
=0D
-- =0D
2.34.3=0D
=0D

