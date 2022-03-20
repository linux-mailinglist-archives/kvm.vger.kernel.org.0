Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF84E1C01
	for <lists+kvm@lfdr.de>; Sun, 20 Mar 2022 15:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245239AbiCTOSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 10:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiCTOSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 10:18:42 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CFAABF6F;
        Sun, 20 Mar 2022 07:17:18 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-002-247-253-224.2.247.pool.telefonica.de [2.247.253.224])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5FE941EC04A6;
        Sun, 20 Mar 2022 15:17:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1647785832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2x5+yhnpvqhs+JUvqAMGnkYHzFLYGpXUD9b0QfXzO8A=;
        b=kn69v1EroZ2HVDBuNozaMgJBTMMSx5x/PL0yIqqC47wtjc8dvk+3aVm3tIIr56v/DnYzH2
        uotxFIQkV48CtqJzjhoqNkYxVjDf/b8E/I0N0QogCvIrFpTA6Gq58ckS2Iy2UaPORpoDsD
        YXrRzQHiUfOEwSBfPuoCyH/EyVO04Jo=
Date:   Sun, 20 Mar 2022 14:17:08 +0000
From:   Boris Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Jamie Heilman <jamie@audible.transient.net>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_-v1=2E2=5D_kvm/emulate=3A_Fix_SET?= =?US-ASCII?Q?cc_emulation_function_offsets_with_SLS?=
User-Agent: K-9 Mail for Android
In-Reply-To: <6970ccc4-1c42-23fa-0b31-99b102ed76c8@redhat.com>
References: <YjI69aUseN/IuzTj@zn.tnic> <YjJFb02Fc0jeoIW4@audible.transient.net> <YjJVWYzHQDbI6nZM@zn.tnic> <20220316220201.GM8939@worktop.programming.kicks-ass.net> <YjMBdMlhVMGLG5ws@zn.tnic> <YjMS8eTOhXBOPFOe@zn.tnic> <YjMVpfe/9ldmWX8W@hirez.programming.kicks-ass.net> <94df38ce-6bd7-a993-7d9f-0a1418a1c8df@redhat.com> <YjXcRsR2T8WGnVjl@zn.tnic> <ad13632c-127d-ff5a-6530-5282e58521b1@redhat.com> <YjXfgsSZpVVdg0lv@zn.tnic> <6970ccc4-1c42-23fa-0b31-99b102ed76c8@redhat.com>
Message-ID: <8618FFB5-4029-4C8C-9982-B431F967D468@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On March 20, 2022 2:04:02 PM UTC, Paolo Bonzini <pbonzini@redhat=2Ecom> wro=
te:
>So this is what I squashed in:
>
>diff --git a/arch/x86/kvm/emulate=2Ec b/arch/x86/kvm/emulate=2Ec
>index f321abb9a4a8=2E=2Ee86d610dc6b7 100644
>--- a/arch/x86/kvm/emulate=2Ec
>+++ b/arch/x86/kvm/emulate=2Ec
>@@ -430,7 +430,19 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fas=
top_t fop);
> =20
>  /* Special case for SETcc - 1 instruction per cc */
> =20
>-#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)))
>+/*
>+ * Depending on =2Econfig the SETcc functions look like:
>+ *
>+ * SETcc %al   [3 bytes]
>+ * RET         [1 byte]
>+ * INT3        [1 byte; CONFIG_SLS]
>+ *
>+ * Which gives possible sizes 4 or 5=2E  When rounded up to the
>+ * next power-of-two alignment they become 4 or 8=2E
>+ */
>+#define SETCC_LENGTH	(4 + IS_ENABLED(CONFIG_SLS))
>+#define SETCC_ALIGN	(4 << IS_ENABLED(CONFIG_SLS))
>+static_assert(SETCC_LENGTH <=3D SETCC_ALIGN);
> =20
>  #define FOP_SETCC(op) \
>  	"=2Ealign " __stringify(SETCC_ALIGN) " \n\t" \
>
>Paolo


Ack=2E

Thanks=2E

--=20
Sent from a small device: formatting sux and brevity is inevitable=2E 
