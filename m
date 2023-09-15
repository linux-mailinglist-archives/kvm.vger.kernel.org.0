Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7C47A2683
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 20:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbjIOSsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 14:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbjIOSru (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 14:47:50 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CEB49C1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 11:45:00 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-53074ee0c2aso2081a12.1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 11:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694803496; x=1695408296; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSCgW2z0ZP1zu6DIfy6jBz9WPyw7XMOFSKI7dtFpaTE=;
        b=yWb7uY57KybRruvlisxKkp71jLAC0Ku5L5uZ1VXYryC7azASsutrig0yoQxE9lzWvP
         FusHREegPvFOlh5SLwA5UJgJZT9FT6DZT5LWSiAhjB2kwi/R04DywXLu/Bfc6a4PiLsl
         Nb4jygdRoVvNIEECaXFd6lC8wfsve4zxx1Q8ZE2hoptUSa1XRqsxwZJPXr9zP+6pY+XG
         LACEpX2i/VpFLnbTjViZEo9IknssSRaqjfTiYPtvnZ2GoHCm+aSlVfSfQoVXnDCNNeDK
         zDEHu/290dA9SqZIV+R2//pUw26TDfvY2QHq52MZTxX/Gk12O71pp0KJbj8A052GXsNH
         coSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694803496; x=1695408296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSCgW2z0ZP1zu6DIfy6jBz9WPyw7XMOFSKI7dtFpaTE=;
        b=wgfrS4RtZMocVY/BjssuW/2LoYplCaFbu6lN/+K5SfOG7zYPTK9zIEVfKBBENfza4+
         gc7Wem2hQ55sLzfwLzpDM5oFRuR9wYQ/fhw769zhAMdJT0QJICJlLi3V4R/6vV02Rlxh
         sv+ijr5YxVn6TO5gNFXmh2rQlBs+yLyp1kl1J2F0sqgtpTEi0hUQE2iP8eROlkMjMlXe
         v2NWIHS2LCmnu8o+zlb6LBx6kZcQT/rXE6yr6U64Hy1S7f2oT6smj+MWFwFrJzvVewd+
         ofsZT468dU0s7MzcZOxZOXzNK3HgBvTXrQX6WTxR9u1NwbTADBXZngrsSyX9u+YRVPkJ
         3+AQ==
X-Gm-Message-State: AOJu0YyhBKbU5pCvJlFBeIU5xbVcJyP3PjP55rc3dmh82wytISXgnxPc
        /+bR0DPORrwnhYN4kz/yCL6OjwZ6BK95woF2bG0qrA==
X-Google-Smtp-Source: AGHT+IGruFlNC2MV7TinGtic0YC4D0CrmVMB8xXi6uHTHmxcAkcsrLu69G31mpCbAqH4ix4BENWfAzsULUwaSYOobWs=
X-Received: by 2002:a50:d583:0:b0:522:4741:d992 with SMTP id
 v3-20020a50d583000000b005224741d992mr16737edi.4.1694803495533; Fri, 15 Sep
 2023 11:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230818233451.3615464-1-srutherford@google.com> <ZQRHIN7as8f+PFeh@gmail.com>
In-Reply-To: <ZQRHIN7as8f+PFeh@gmail.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 15 Sep 2023 11:44:16 -0700
Message-ID: <CABayD+fH+AVu1u+LAtpd4-vRO9E12tVajR9WdWMtr1x_McoO6A@mail.gmail.com>
Subject: Re: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page aligned
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I believe V3 of this fix was already merged into both x86 and Linus'
tree (I think as ac3f9c9f1b37edaa7d1a9b908bc79d843955a1a2, "x86/sev:
Make enc_dec_hypercall() accept a size instead of npages").


On Fri, Sep 15, 2023 at 4:59=E2=80=AFAM Ingo Molnar <mingo@kernel.org> wrot=
e:
>
>
> * Steve Rutherford <srutherford@google.com> wrote:
>
> > early_set_memory_decrypted() assumes its parameters are page aligned.
> > Non-page aligned calls result in additional pages being marked as
> > decrypted via the encryption status hypercall, which results in
> > consistent corruption of pages during live migration. Live
> > migration requires accurate encryption status information to avoid
> > migrating pages from the wrong perspective.
> >
> > Fixes: 4716276184ec ("X86/KVM: Decrypt shared per-cpu variables when SE=
V is active")
> > Signed-off-by: Steve Rutherford <srutherford@google.com>
> > ---
> >  arch/x86/kernel/kvm.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
>
> I suppose this fix is going through the KVM tree, or should we pick it up
> in the x86 tree?
>
> Thanks,
>
>         Ingo
