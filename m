Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55F61CFB07
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 18:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgELQj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 12:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgELQj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 12:39:58 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E89C061A0C
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 09:39:58 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f3so14692211ioj.1
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 09:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tP/faLZShTgp+fPnBxemdUnPXhPkkCPH8J5S52+7MLU=;
        b=ASZGgjTaWCMSfoQTN/jSdtkLyIHDiydjcLiip00K/ZanY8QgGXMuSEQxFzRkc6xg22
         vN10lF1UkQ3xHNxWZE+x4wCFZSfqSwDDQX40gypYG7ydUN9XOkkv5YOx12ejP4TKnBKd
         trbq9MJ+Gl/yyePs9oOHruIE6iRqZ7oYeboL6eA/Nk+5y8KxH+lxM9Gs51rikD7jTi/R
         IWy8qOaZYt9oGkITDvyTPw7TiDSAq7Hgh7+Ey2aihIbGZMcro93gz20zlzz/uCwmuczl
         Cjirkxj+RQgxmijs12eWPK+JnAEtKjolgIzcUf8ariiLeULaCscg+STnJn9w+w3oiXqY
         zB4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tP/faLZShTgp+fPnBxemdUnPXhPkkCPH8J5S52+7MLU=;
        b=HofyvALr7YGUodsVpxgv76yW84N2XVdOGo15kWQR5pNQA09CP67mKTAbjNUY9MhV6s
         8dLLkYd8tXunYGrDLkpKlcp6Jsa9udXIAznkj1ixv/T4aviIFQwcADZ8aIaNfsFCCkt7
         Fd7D4rTmJ039zwC07EzJrd4qkqQB24i5PhfOoSJOtMSb6+8BbiH7nQW9PSkYkJEVYI6G
         yAlllCBC4a71oB9RZ3pNyS+jMGRwzPPs7S65cz4TSfpWuFLrtMegf+1wcjeQF0WT6+Tb
         gLvtGvrXkgssbkfmwf4pCTAQsnXkMeIx/BjaKbH9oYCVq9Lt6zVcMhPqGJN43c0HSHX3
         i5GA==
X-Gm-Message-State: AGi0PuYb3smxciRqzPuJTzfwo2Mgl0TN2lVKFmUfaDc/KwxLQqb9puKE
        /bpk2pqOvIEppYefqHVejmTv/LZ4HbJbAjaw0UMg4g==
X-Google-Smtp-Source: APiQypJ4SiTUd1EPl8BSHjrzsB/uekp7Rpjwcdx9bsqge9HnpqrfDoFAJtY3wySPH0ydPFr8uOgKqSjXeUI/bxAolpo=
X-Received: by 2002:a6b:1cc:: with SMTP id 195mr9820714iob.177.1589301596233;
 Tue, 12 May 2020 09:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
 <158923998430.20128.2992701977443921714.stgit@naples-babu.amd.com>
In-Reply-To: <158923998430.20128.2992701977443921714.stgit@naples-babu.amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 12 May 2020 09:39:44 -0700
Message-ID: <CALMp9eSAnkrUaBgtDAu7CDM=-vh3Cb9fVikrfOt30K1EXCqmBw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Move pkru save/restore to x86.c
To:     Babu Moger <babu.moger@amd.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        mchehab+samsung@kernel.org, changbin.du@intel.com,
        Nadav Amit <namit@vmware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        yang.shi@linux.alibaba.com,
        Anthony Steinhauser <asteinhauser@google.com>,
        anshuman.khandual@arm.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        Dan Williams <dan.j.williams@intel.com>,
        Arjun Roy <arjunroy@google.com>, logang@deltatee.com,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        pawan.kumar.gupta@linux.intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 11, 2020 at 4:33 PM Babu Moger <babu.moger@amd.com> wrote:
>
> MPK feature is supported by both VMX and SVM. So we can
> safely move pkru state save/restore to common code. Also
> move all the pkru data structure to kvm_vcpu_arch.
>
> Also fixes the problem Jim Mattson pointed and suggested below.
>
> "Though rdpkru and wrpkru are contingent upon CR4.PKE, the PKRU
> resource isn't. It can be read with XSAVE and written with XRSTOR.
> So, if we don't set the guest PKRU value here(kvm_load_guest_xsave_state),
> the guest can read the host value.
>
> In case of kvm_load_host_xsave_state, guest with CR4.PKE clear could
> potentially use XRSTOR to change the host PKRU value"
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>

I would do the bugfix as a separate commit, to ease backporting it to
the stable branches.
