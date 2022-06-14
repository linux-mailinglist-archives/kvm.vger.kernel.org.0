Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE13754A6F7
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 04:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354842AbiFNCmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 22:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352649AbiFNCl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 22:41:58 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607045005F;
        Mon, 13 Jun 2022 19:20:35 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k19so9246392wrd.8;
        Mon, 13 Jun 2022 19:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rUo3H58Xo6jRmNEwjhL/eFhQ7obXUHzajy+AECzxVt4=;
        b=EJgw/8kmPw3eQcaDqa7qbY1kJIy78gC/KghBVXCdqDMgTzYadRYzJ3sGCCnVrA2kse
         rywQ+E5TqEPUmp+Jfy7MidbwAdeiDVmzwHPIbfak9JqyDLf+7sxrt9KNhMTxCNLL+6ND
         HscvHsh1J5UBnvE7uLlaa5Ngbhx9QyyOQsHZehUHmpyy/OkgYsyJGKO6FrZkHqBDN4p6
         /WYFyoo9Xe6hy2xVV+B4Hb8qQ0nePuiwOQUWwaClsDK7hRXClprraG6bk3ysPp+MNGWw
         ACvnWlC6LxUakujWE+2Xj7XXWbBX8/JWOr5xHE7q/IhBMW0HZt5XydwoKwdCv3agLIyb
         zMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rUo3H58Xo6jRmNEwjhL/eFhQ7obXUHzajy+AECzxVt4=;
        b=Vegelk6lIPFzUzsGGUK4mnB8b14nUwuTzkJ+tgXJx3hoOnKVjxkM5NaCA2v4vMWV2T
         +o1zU/LJlpfBg6mtE6wfuR4x7P07m2Jv+5qul0a7w+jfa9sCKoZWi4Y4vvj/Puj1YdiD
         3V7aFw3UJDzxtb5r/+fAqvoh2U/z85KMOjJrfvPX1bEF57IQSvHR/RYDdiklPIxYe3Xu
         0qk53BCkEOFzBgNR6kWkX64k3vuiUc7FP+30IrLr0ncpVN+3IA6qJmg7dpgLhkIuQs2I
         5/0e4+RoyBwIkhh9XkKtyyjbAfxzr3c3Rjk5UGPC9FYNX3oH56ywJaECvYZUbz4Pnx0n
         qRMg==
X-Gm-Message-State: AJIora9Fw+Xk3ohsuhT9o0+CtdTh4YAPMKq0IzNRqRRdYXMmQXW7Jy1B
        PlfEAvOdLrUS6AkQGFzWr5DLLxkiJkXeaPYhfUOHqghDry0SPA==
X-Google-Smtp-Source: AGRyM1vubLAYvzxsNOBMNnDLnOtApG/1brEj+260Ctcbqrc8JeVzrcSUop4bg/ADhdmxahpfwOZjnagUGwbHugPCQqg=
X-Received: by 2002:a5d:5c07:0:b0:218:544d:4347 with SMTP id
 cc7-20020a5d5c07000000b00218544d4347mr2291230wrb.107.1655173228921; Mon, 13
 Jun 2022 19:20:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220613225723.2734132-1-seanjc@google.com> <20220613225723.2734132-4-seanjc@google.com>
In-Reply-To: <20220613225723.2734132-4-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 14 Jun 2022 10:20:17 +0800
Message-ID: <CAJhGHyCMsc4g7rdW8td5vOA5iAZBu7+hewUJW8tUXX=_-UBVOA@mail.gmail.com>
Subject: Re: [PATCH 3/8] KVM: x86/mmu: Bury 32-bit PSE paging helpers in paging_tmpl.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 6:59 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Move a handful of one-off macros and helpers for 32-bit PSE paging into
> paging_tmpl.h and hide them behind "PTTYPE == 32".  Under no circumstance
> should anything but 32-bit shadow paging care about PSE paging.
>

Moving code from paging_tmp.h is on my to-do list.
I don't think the opposite direction is preferred.

And is_cpuid_PSE36() is also used in mmu.c, is it a good idea to move
it into paging_tmp.h?
