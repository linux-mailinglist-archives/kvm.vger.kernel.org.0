Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502E6178286
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 20:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbgCCSh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 13:37:28 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:32939 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCCSh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 13:37:27 -0500
Received: by mail-io1-f66.google.com with SMTP id r15so4795784iog.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 10:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m9WYQEOpVWGproVMAv07ziOTdPLiRIDc+HJ/iWbkJV8=;
        b=nw5ituQz/pxZjKMazbeyIO9kVrzTCthyRCgmJ6Ar5UhswHJ6/p5LDuVy/3Mdr+U7/K
         dmSH9Z115uy9rWM1d2V+eTGy6i/WW5va2/nPuq/+WaOBMMZwnCwk9pegwRJy/s41GdVZ
         gbrjXviV3QRqt7vNyaIoq+OS/YcD7SbY/Hk7uRnTRFlM5B/FpscRPgfstnrFF2kKdZuf
         +vy2yrmyPWKKW0Ej6NwYTqac32h/GmxUhjiHOqy/kI+PILBIZQ4+ojXQeEYYJjn6gGf1
         2pMo+bFxnv9YxHWLZOjfYCEdgZeLVJLFzWp2J0rXkNsVq6uEPlSNZ94AEs7+aOriMJLu
         6Vuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m9WYQEOpVWGproVMAv07ziOTdPLiRIDc+HJ/iWbkJV8=;
        b=AkFX+fpxCLHMllZKacsPSc2h4eobFXT6L3cZuQzZ7PRzJpBpOpUIq4iHA5LtOL8kw/
         uiGnj8dVsTcb+0r4we0HngtopFtE+8zOKV4CoCp8P5zKJRAvnJcCP4dW73s/mkGoMwZV
         0j5TJ7YF7N/kllkPEec2TG5m38qvtRrBmrZDH7KjGOKivkgVlx80ebwxKjpuyR5uVMe0
         K+Pu3dlTDA86vvfrxgyX3aqftnYa8CKYdJv0VvAE90lTc/vWGYW5k9FDDcfMnzTHPjp8
         jmdap6bJvf8uzcRF+c7dasREqpN4DIIDZZptUrC/LwzoYJBaXam7OPqKeRXes4MvhQ8n
         NACw==
X-Gm-Message-State: ANhLgQ1bGEJh4M7j3vx1c0uTowsAP5SSoG5GoDzsAiZJs/g2sWimXTuz
        dFk+2y+sGooDdZxkRfYvqGpStKf9ATw0fIwcOfXB3A==
X-Google-Smtp-Source: ADFU+vsbEoLs/s4b8PtMM3X7o6dJ75+m8cmCT11wPJXYP+bN2I4AMLKekRt07jPvqjI6HHPiQWatQKoNCs0R+jPHFxI=
X-Received: by 2002:a6b:e807:: with SMTP id f7mr5197526ioh.26.1583260645891;
 Tue, 03 Mar 2020 10:37:25 -0800 (PST)
MIME-Version: 1.0
References: <20200302235709.27467-1-sean.j.christopherson@intel.com> <20200302235709.27467-65-sean.j.christopherson@intel.com>
In-Reply-To: <20200302235709.27467-65-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 3 Mar 2020 10:37:14 -0800
Message-ID: <CALMp9eRuT=Zi_JoBmmRyMzid7RF3MpYMjXCrOMA9cvqOO06C9w@mail.gmail.com>
Subject: Re: [PATCH v2 64/66] KVM: nSVM: Expose SVM features to L1 iff nested
 is enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 2, 2020 at 3:57 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Set SVM feature bits in KVM capabilities if and only if nested=true, KVM
> shouldn't advertise features that realistically can't be used.  Use
> kvm_cpu_cap_has(X86_FEATURE_SVM) to indirectly query "nested" in
> svm_set_supported_cpuid() in anticipation of moving CPUID 0x8000000A
> adjustments into common x86 code.

Why not go ahead and report the SVM feature bits regardless of
"nested," and lock SVM off in VM_CR when nested=false? That would be
more like hardware behavior.
