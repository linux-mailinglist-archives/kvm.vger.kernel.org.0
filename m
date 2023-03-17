Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749FF6BE5C5
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 10:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjCQJjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 05:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjCQJjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 05:39:15 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352B423C75;
        Fri, 17 Mar 2023 02:39:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k15so1762192pgt.10;
        Fri, 17 Mar 2023 02:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679045953;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NeeR+x2NJdavxdOYfpdrEMQAe89MyGMfDA3FFptwvrc=;
        b=iPgHp0r6Z3pCnuf9b/SBxJeKIz3MPkwzGtNe6kovGNnvJsVW2f0ocF4dYmnxj/Cjby
         C0ONzUsYgQJ6MLn/PksYRPFZdhOKy2jks4Wcc9XUYYFBAtxitqc4zhcKgKFLuzYPm2Lo
         RHOTvKO+uTRyNc5I9L/MoHhlrct8jQg6t1HHRouhzSj90OEEt0vNLrdXcedcPKoCG2kJ
         AnBg5oqEwH4zIvuMiUtCIZhE0JczLpZWrAGE+O8INu0fO1JDhYowCKdLB2XNqQjNMw4X
         iXu5PiBjZ9sXSbuAJtj/Y8CkLck6A9wtt1Ze6Z0tC31V5d0VefMWQRQQLn877kVkUuDM
         jXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679045953;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NeeR+x2NJdavxdOYfpdrEMQAe89MyGMfDA3FFptwvrc=;
        b=iiBnIV0NVIWJdNrAlmeoWoqt+F3mjOf+/AZ89/W1gUpR0C8xeGN9udSK3o/FmAIqCj
         YHPi8x/9IVGYHKfhVcl0Q0Uc150v1mCN+8PCkZYZWKQXCxbxUmEAXP0X2R15qyXFK6xi
         P0jtXRnZXJNnDh3mm+7Wx2xPww822XmUhlkwSeYFJk1vrAJJjjHEPC3HFY7jzcwyaXxK
         fawHGx64NYYPG7Q6GK/Y3r5F1efcQ+S68Eq+X1IOko9HLG3aP+BIpwENBAziATopRPbx
         IXXNfe2VoSu6DiTphciBiuFWJAGxsy/2VYC3C4lcw4LhQgKYLxmGHvcdpf5eXI7sgUEe
         moyw==
X-Gm-Message-State: AO0yUKX4BP0nEFk7CAIfvAxPfXJ7ngh040IAAeMTB7BwwBfTf23i+FL+
        dMZWPzo1cTDimR9UnMLp+hBsFkNgAMMWygi76ag=
X-Google-Smtp-Source: AK7set8b/hpUYvinzbakbM4Qe7xrTuC4DytJeB9Smn9Fv5M5epfCDXtDPeaUCFstb+NnkwQgXHiAMMQHl1WrhDoB3+U=
X-Received: by 2002:a65:528c:0:b0:50b:18ac:fbea with SMTP id
 y12-20020a65528c000000b0050b18acfbeamr1788547pgp.9.1679045953561; Fri, 17 Mar
 2023 02:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230307023946.14516-1-xin3.li@intel.com> <20230307023946.14516-29-xin3.li@intel.com>
In-Reply-To: <20230307023946.14516-29-xin3.li@intel.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 17 Mar 2023 17:39:01 +0800
Message-ID: <CAJhGHyC6LgCwdDTkiy2TaQ8wzBQQfrx8ni7fY8vH-bUT2kR8pg@mail.gmail.com>
Subject: Re: [PATCH v5 28/34] x86/fred: fixup fault on ERETU by jumping to fred_entrypoint_user
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +#ifdef CONFIG_X86_FRED
> +static bool ex_handler_eretu(const struct exception_table_entry *fixup,
> +                            struct pt_regs *regs, unsigned long error_code)
> +{
> +       struct pt_regs *uregs = (struct pt_regs *)(regs->sp - offsetof(struct pt_regs, ip));
> +       unsigned short ss = uregs->ss;
> +       unsigned short cs = uregs->cs;
> +
> +       fred_info(uregs)->edata = fred_event_data(regs);
> +       uregs->ssx = regs->ssx;
> +       uregs->ss = ss;
> +       uregs->csx = regs->csx;
> +       uregs->current_stack_level = 0;
> +       uregs->cs = cs;

Hello

If the ERETU instruction had tried to return from NMI to ring3 and just faulted,
is NMI still blocked?

We know that IRET unconditionally enables NMI, but I can't find any clue in the
FRED's manual.

In the pseudocode of ERETU in the manual, it seems that NMI is only enabled when
ERETU succeeds with bit28 in csx set.  If so, this code will fail to reenable
NMI if bit28 is not explicitly re-set in csx.

Thanks,
Lai

> +
> +       /* Copy error code to uregs and adjust stack pointer accordingly */
> +       uregs->orig_ax = error_code;
> +       regs->sp -= 8;
> +
> +       return ex_handler_default(fixup, regs);
> +}
