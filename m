Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0936BEA2F
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 14:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjCQNgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 09:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCQNgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 09:36:11 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016B7C5AC6;
        Fri, 17 Mar 2023 06:36:09 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s8so3000351pfk.5;
        Fri, 17 Mar 2023 06:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679060169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXw/rf6Jc981BZGJ+V2+t4hxq1zf9beBZvpefwWItko=;
        b=n5C1khT5GkKDQK2UYlWJJmZo6A4g9mbaIWrwQE5KUFPCjZxfWiSjHb4rFUTE0juVcU
         InYQRHVQJIPe9puU+JvMMdFcRlU6UVO8qj7A1YcmRrcP7od9Xd9/Ovz2fkmk2EF0QqsC
         8le3nNW0RV8L85rLh/YMgrkBIK2gwoQSGJYPsWwSX1UxyNzJUqIIUzh/afyPgXTOdDQL
         ErDNbfnxvdbVXRMQLTMwAsbzJzOfjq7Oli/8a02KTBw+hnXbUf5wLUggfKaCFhQC4wkP
         as+KdRP/3VzKpJRpU+l+5avxJhVCFJoAQpqsWh+bMVGY9TKy/L9YBiTp9foWVaWAF7S3
         /KBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679060169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GXw/rf6Jc981BZGJ+V2+t4hxq1zf9beBZvpefwWItko=;
        b=BZbIhi1zUIcYYWCfXrFCLfZi0MlqBNClzRpH57Mx1hc7QVfjVOvtCEr5Lap4hf9Lq3
         VXE3Hv4FNyU8jj2YGLa0VZmvVTm40ItlbuJHrulaV0CU5yTGjrjFsyszQSTL41PHq6wu
         EgWtJ1pSRlbYubWVuDeJ18oHe+YwYPKIT0G273LdRbMLLEaMlVTnbmT4NUBhOxohgI8U
         OAF1cJ7oIh8KBX9+rCmNHpipa1yrdXZNw7OboatIjAEzvpNwJJuSIwftga1o9nB1XWab
         FpdW4rYkXL5yJP0nFM6VaULUen4ZPQmvW5s6ponAofwnezmDQOjAHFmn58keQa38OTt6
         4HCg==
X-Gm-Message-State: AO0yUKWIQqpw32j+i2SDRTZA3zSq7yix/U2XiCgIyDQQqpXyTVOUIjGr
        PZ0fHEfbpe3in2CBZ6LY3zygQnVcz/rIqp6osXs=
X-Google-Smtp-Source: AK7set9B5nnIsLTQrhd3+vgv+Ub71f+/nRpvTH4j+LS0viItD95uzgtKQJpU+crrKoJuObuUFnTxVisqtEvRZ5J1ibM=
X-Received: by 2002:a62:a512:0:b0:5a8:a475:918f with SMTP id
 v18-20020a62a512000000b005a8a475918fmr2637288pfm.4.1679060169166; Fri, 17 Mar
 2023 06:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230307023946.14516-1-xin3.li@intel.com> <20230307023946.14516-23-xin3.li@intel.com>
In-Reply-To: <20230307023946.14516-23-xin3.li@intel.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 17 Mar 2023 21:35:57 +0800
Message-ID: <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
Subject: Re: [PATCH v5 22/34] x86/fred: FRED initialization code
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello


Comments in cpu_init_fred_exceptions() seem scarce for understanding.

On Tue, Mar 7, 2023 at 11:07=E2=80=AFAM Xin Li <xin3.li@intel.com> wrote:

> +/*
> + * Initialize FRED on this CPU. This cannot be __init as it is called
> + * during CPU hotplug.
> + */
> +void cpu_init_fred_exceptions(void)
> +{
> +       wrmsrl(MSR_IA32_FRED_CONFIG,
> +              FRED_CONFIG_ENTRYPOINT(fred_entrypoint_user) |
> +              FRED_CONFIG_REDZONE(8) | /* Reserve for CALL emulation */
> +              FRED_CONFIG_INT_STKLVL(0));

What is it about "Reserve for CALL emulation"?

I guess it relates to X86_TRAP_BP. In entry_64.S:

        .if \vector =3D=3D X86_TRAP_BP
                /*
                 * If coming from kernel space, create a 6-word gap to allo=
w the
                 * int3 handler to emulate a call instruction.
                 */

> +
> +       wrmsrl(MSR_IA32_FRED_STKLVLS,
> +              FRED_STKLVL(X86_TRAP_DB,  1) |
> +              FRED_STKLVL(X86_TRAP_NMI, 2) |
> +              FRED_STKLVL(X86_TRAP_MC,  2) |
> +              FRED_STKLVL(X86_TRAP_DF,  3));

Why each exception here needs a stack level > 0?
Especially for X86_TRAP_DB and X86_TRAP_NMI.

Why does or why does not X86_TRAP_VE have a stack level > 0?

X86_TRAP_DF is the highest stack level, is it accidental
or deliberate?

Thanks
Lai
