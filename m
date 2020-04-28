Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283D31BD0AF
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 01:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgD1Xph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 19:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726044AbgD1Xph (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 19:45:37 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DD3C03C1AC
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 16:45:36 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f82so667737ilh.8
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 16:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EgsET8VUBtyD/s7lLWUx9sIqs9ALDQ1NZU7iSsS+5z8=;
        b=ARorGs0jnGaWn5EIpZPmClAu62Hy0g8PR3YB73+67ybQ2ieKO9vsk6kh/JQEy8xXCk
         84jvy8YVxjHRERDflDRmS0wNpoz8LfE8tEsGBTNIf2czBsRUgVRoUAUpRKIxpQtd1fqw
         +tEVCLNgDtQyo7ikNGMqWnOyIoCyg+TMmiWVnhnJIpeC2s1EMbruVG4xeIPlBBl2wtMd
         sQgbBr3iZNm+bhF+bM7m5/HP1zCAiOjdkUN/hLXZyxbrf6viHXbd+l2ZQrBi3UbOoPMA
         r38Ny0io12tjiM/0GMG4FF/uLoLAWH4Y+uij54/VTv89fs/22BRmohM0cYqR4XF9tjvY
         l7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EgsET8VUBtyD/s7lLWUx9sIqs9ALDQ1NZU7iSsS+5z8=;
        b=nOZlVBS7SauPTQi7BoyLvp3xSWJGZjif2A93F7dVTzENszp2JwpFk0kAVipzRzfjcm
         5XBzMrfVTZ24wcLclWHQ1M/MoPeJCGt0Qb+ScE0uV6rnFIttlH5mZ9YVTqLX9czXPrht
         pqerxMsSPUkqswpNhPk+HpYM3svHFwk72peqvPq/F3hgdVd+awYVhbem+7BMM80P8OIM
         dB1bPVI9Z2Eg8TPVa+lhuIpXPZd7+9jve8JdpRkYF8k1NHts5ewNAi1CtCPgAbKwxGML
         N0pbk8Upli7IPnE+2ivfs98SbU8Rne9JK5DjwDFuSL9ReCuPaEtZI8eWnY9GJRjLNsap
         tifg==
X-Gm-Message-State: AGi0PuaU+nW3tPRAzvlsM08ave63tr50hsIi+FhayaGp9q5n21V8Ckg3
        jF3wvPyb/A+PryHhgGsz5SwKVdIh8MuVh+6we1HOoA==
X-Google-Smtp-Source: APiQypLTeZ51rx3d7k7oUHJitoZjkQhoSrzY9QFnWEiUl88/rYYbaWgjZtgPOjwTV6yTxYYpqpuwjQLCvCNqo5pwl3Y=
X-Received: by 2002:a92:985d:: with SMTP id l90mr29658275ili.108.1588117535890;
 Tue, 28 Apr 2020 16:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200428231025.12766-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200428231025.12766-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 16:45:25 -0700
Message-ID: <CALMp9eQLPPAzM+vsrSMO6thOnCRpn6ab+VOh-1UKZug8==ME8g@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: nVMX: vmcs.SYSENTER optimization and "fix"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 4:10 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Patch 1 is a "fix" for handling SYSENTER_EIP/ESP in L2 on a 32-bit vCPU.
> The primary motivation is to provide consistent behavior after patch 2.
>
> Patch 2 is essentially a re-submission of a nested VMX optimization to
> avoid redundant VMREADs to the SYSENTER fields in the nested VM-Exit path.
>
> After patch 2 and without patch 1, KVM would end up with weird behavior
> where L1 and L2 would only see 32-bit values for their own SYSENTER_E*P
> MSRs, but L1 could see a 64-bit value for L2's MSRs.
>
> Sean Christopherson (2):
>   KVM: nVMX: Truncate writes to vmcs.SYSENTER_EIP/ESP for 32-bit vCPU
>   KVM: nVMX: Drop superfluous VMREAD of vmcs02.GUEST_SYSENTER_*
>
>  arch/x86/kvm/vmx/nested.c |  4 ----
>  arch/x86/kvm/vmx/vmx.c    | 18 ++++++++++++++++--
>  2 files changed, 16 insertions(+), 6 deletions(-)

It seems like this could be fixed more generally by truncating
natural-width fields on 32-bit vCPUs in handle_vmwrite(). However,
that also would imply that we can't shadow any natural-width fields on
a 32-bit vCPU.
