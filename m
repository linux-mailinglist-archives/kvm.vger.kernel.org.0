Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4920C232697
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 23:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgG2VGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 17:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgG2VGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 17:06:34 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290AEC0619D2
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 14:06:34 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id l17so26043672iok.7
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 14:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PYXSUMqBNAfekuMZ1II61jWQ+xQzFVAYx97TvpVd0jI=;
        b=B0M2Rleh5A8unRB3YwRgb+tjnGZ4gDCtk6RwC2OUBr1YrPpnKGAVgjv3iD2coO3zEG
         wJywzxnfdtSHlMZbt1el03j75eCIgiy0t3niS4XdBYt+IPVxgeryIV26sAnbBb2ie8ed
         UC4NWxmjIYy4lLysz0TpsFVD6MAdDepPg9DkPizx4N0df4RVfWMk70I17ysRhbPFGyYB
         RZtAY3fSm9ZbaspEEUqJxpDhm8toh0lJx5FtomdhnR4jNmOQgG9l2q1BOBET0sHJrzf/
         wYV+26Xl/ohLIL9dW88838MKGzA/j4SEQN5Qm/kpHXzXionu7yWS34UkzLPnsG8HMIr1
         R3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PYXSUMqBNAfekuMZ1II61jWQ+xQzFVAYx97TvpVd0jI=;
        b=FBZK3Ut6aJ2pRdyF/tjfyxHwscr7qUlgauAixsrBjkCKZCJZ0cuXYnMuX/Gcs7bXpf
         C7jq+cip0fzO0MNM8nZzozr5vvhDNn98Oxl4UtEm+YP4ZN4CjvW2zKaQ26r/gHLtUooA
         l2iRLLTt1antPO8Am5nWbiwl4+Cs0GeX2SfbNLJsXuI72TNsPb5JM6zadtPcczNL/BY0
         vuoFkdXeIt/VM/DMOhCj6wYnh/mo5tzIhH9XDvmOapAQt/X5nHUVA3UqQbQSIpOR5gKs
         7mJouJDuJ79FRhcRU3Hs5791vmqEK+6md6s1MTppuAfJDmhcJ+AGOejC2+1qJzpgaNYL
         NUYQ==
X-Gm-Message-State: AOAM533YzMbxNgny7qcYTjzlifuDi9v3usFiDPYVHfoKQSE1YbfJymQJ
        9Ws94+8QwBZZ5105qkbDsWdNUV/DZK+YepLQn2kJGA==
X-Google-Smtp-Source: ABdhPJz89qZcoF741PgVTVzeNOR8THiBkq7r/07KbMhPhKErgfdp89Y987XC9GEz5UtVzCaiwYbkBjxQ0irN/VWCLl8=
X-Received: by 2002:a02:bb82:: with SMTP id g2mr49494jan.54.1596056793308;
 Wed, 29 Jul 2020 14:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu> <159597949971.12744.1782012822260431973.stgit@bmoger-ubuntu>
In-Reply-To: <159597949971.12744.1782012822260431973.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jul 2020 14:06:21 -0700
Message-ID: <CALMp9eSY4YshSLEThV1KDRmrXG_pcs68OwrgC4cDe4smaVe8Cg@mail.gmail.com>
Subject: Re: [PATCH v3 05/11] KVM: SVM: Modify 64 bit intercept field to two
 32 bit vectors
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Convert all the intercepts to one array of 32 bit vectors in
> vmcb_control_area. This makes it easy for future intercept vector
> additions.  Also update trace functions.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

> @@ -128,8 +129,7 @@ enum {
>
>  struct __attribute__ ((__packed__)) vmcb_control_area {
>         u32 intercepts[MAX_VECTORS];
> -       u64 intercept;
> -       u8 reserved_1[40];
> +       u8 reserved_1[60 - (MAX_VECTORS * 4)];

Perhaps this could be simplified to 'u32 reserved_1[15 - MAX_VECTORS];'

>         u16 pause_filter_thresh;
>         u16 pause_filter_count;
>         u64 iopm_base_pa;

Reviewed-by: Jim Mattson <jmattson@google.com>
