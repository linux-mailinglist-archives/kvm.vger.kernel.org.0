Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D85039112D
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 09:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhEZHHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 03:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbhEZHHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 03:07:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E339C06175F
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 00:05:06 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id s4so141496plg.12
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 00:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EevI1c6qRbZj+y9bbUbJzhVFurpZDDjFQ+WN5cz9y04=;
        b=F/Vi57cLNtlTe5mxb8DolsWxh1wOFR2bGcVCHhFvsR+hI163XZP+/Q8S1lfnPgW88J
         Tt83GE5VRR5iPMRGftUC1ESXPzHxPQ75zXneJaXO5xt75t7kl0GQ8g7RI3tb5HUUOQbM
         kOwcsBsz5ux+PKXxaU1xNLfEpBNDQuHVbB+xmNtSpCJ7WpkLBwXWG95/Uk3y1kxFWB7P
         x5wDZhsRJlppXpoWr00jNBoMaBTrEJNG/140hcIjvVVycu/vEr0TMzcQDE4MH3i6PUkp
         H3BprMgnOFB2hsjdDD0WNVAucuWXZBdv4tjN2L9pwKjBhVndUTep+ZVzRza2T48G9lFA
         IIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EevI1c6qRbZj+y9bbUbJzhVFurpZDDjFQ+WN5cz9y04=;
        b=crq2NOLua/E4lYF3q0Zh+XFbFWlGL7KClZrzbnu/jGx7LvAWAlVf/8867FxToH7HBr
         cJzW6oNcz0ozpitcH9Ihfzyh99KFqFDD7XdJztd48huqlNdGDG8jCCH1asaUgFA0MSpz
         cM9u66Biqx/vDLbUY8EF+EuNDkTqmqtsAqP2Tr9+gL5FFtITafmJvrDN/7oIEpGxEy8Z
         9sHTnDrm8nieTQuGXwb35S+VyOBvN5jitOof7jSUf3M57ZW+4aG4mbiF9u40Vhj5w1Rk
         YqjtqCQaOyYlmh/zIuMT/mvCa9xvwhEJadcqYMZhwTWPFmpeVQQR0tvzp76t1kK3tUi5
         NaZQ==
X-Gm-Message-State: AOAM530XE/flCMZ58uA3L6V/1A48wjwazoLCe/eRAlq+raD2Y6FwCRIJ
        3r2DPxedByjVjYWovQ2dU2jkGxbqzZlrR6nbmtEVwA==
X-Google-Smtp-Source: ABdhPJzJBded+QNQK9UEVxOgou4lzUCZ/Z3oNps2Jnk1eMMrIaL2bYgHM8YoWKkJZK3wzzEAY5jpEzRG2tYSZwwIeiM=
X-Received: by 2002:a17:902:f20c:b029:f0:af3d:c5d8 with SMTP id
 m12-20020a170902f20cb02900f0af3dc5d8mr34045316plc.23.1622012705860; Wed, 26
 May 2021 00:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-19-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-19-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 26 May 2021 00:04:50 -0700
Message-ID: <CAAeT=FwYkFvxbKPxtMAw2An_HLQxk5LOuFX2JGQ9qn_3QVy94Q@mail.gmail.com>
Subject: Re: [PATCH 18/43] KVM: x86: Consolidate APIC base RESET
 initialization code
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 5:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Consolidate the APIC base RESET logic, which is currently spread out
> across both x86 and vendor code.  For an in-kernel APIC, the vendor code
> is redundant.  But for a userspace APIC, KVM relies on the vendor code
> to initialize vcpu->arch.apic_base.  Hoist the vcpu->arch.apic_base
> initialization above the !apic check so that it applies to both flavors
> of APIC emulation, and delete the vendor code.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
