Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6905AFB44
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 06:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiIGE0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 00:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIGE0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 00:26:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6716A857C2
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 21:26:45 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fs14so8527822pjb.5
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 21:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Xk596ZpOvHHkq2UiD2w1TnlOJagQ1pzq8bsWaxJ5evc=;
        b=VbR6vuGnznGRwapx4XKG8MzL2UPiYiuvGWBZahrJX3pQG7wZK3QEGvBHy05Q9XSrFX
         Gqku4FyamLpTWKoxpRWTkimb8j1+ztDOoZuhTOOV9zI5lku4AIreHrpGAABm0Sx3AtQd
         i61If1vZrlrtZd2t+kq/kKZqMG6tiyVIEo+m9J27nMv8o0RSB29DLnn6qe2nSQzCrujL
         k/YP098v2Rs3EySkVJQbZuDeP3ZB8CRSw/lKqBRgomPHommMZKIw0C8HBkkHUTiTWuaN
         7hkm3gSV57EHXRiuZyCh1gMHuOshbR/rwIm20WNJZ9Pib9I/IT8AmL4FAX/n/jhe0khm
         JBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Xk596ZpOvHHkq2UiD2w1TnlOJagQ1pzq8bsWaxJ5evc=;
        b=w0URrUrX4xvXYrAhWardMGgF8qxzp8sYQU4dFb3/9foUVOrDZ11bXVz4gDUTYm13FG
         gmefu01Ty5Kj9At5EKBI31dufobEYcUX/MaQgUBykeFTd39xZ72xohTVjOqj1Zsk5Znt
         aGMgBbzIOnxvQrt16JigHCuXAw1IF20kHF/Nn7Fo0e3toL12/6kpt3lKJm7TQj8df0yh
         6PwdAGdU7al9oraXPY/S0LIuPnaQpUTluV0fawoRajHgvYmyIGBQxo+bzybebdz0dR/M
         XOpA3Lr1xj2qQRg1ukUiDvG3lYbfjLVx5YhEZ/jlDZ1+D2GhMpc9MslTIKbIlWvPaTB/
         rErg==
X-Gm-Message-State: ACgBeo21JnemqT6UTEXPL9pMwlcbxtsSgbsDzeM+5EcZFYJynTm6y3L7
        95MrGcWn2FcdZylKc3oRg314FrC2LQ99LC4D5/rnMw==
X-Google-Smtp-Source: AA6agR4lOu0DWSpSqBcbjPLr4h/HKp50l+dW5WqUWFIHWuJ0VUOU2A6Gf5R0eX5bKoCUXti76ds2fABJR3PkVaEThno=
X-Received: by 2002:a17:90b:384f:b0:1f4:ee87:9523 with SMTP id
 nl15-20020a17090b384f00b001f4ee879523mr1873078pjb.100.1662524804735; Tue, 06
 Sep 2022 21:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220828222544.1964917-1-mizhang@google.com> <20220828222544.1964917-2-mizhang@google.com>
 <YwzkvfT0AiwaojTx@google.com> <20220907025042.hvfww56wskwhsjwk@yy-desk-7060>
In-Reply-To: <20220907025042.hvfww56wskwhsjwk@yy-desk-7060>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 6 Sep 2022 21:26:33 -0700
Message-ID: <CAL715WJK1WwXFfbUiMjngV8Z-0jyu_9JeZaK4qvvdJfYvtQEYg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: move the event handling of
 KVM_REQ_GET_VMCS12_PAGES into a common function
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > @@ -10700,6 +10706,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
> >               if (kvm_cpu_has_pending_timer(vcpu))
> >                       kvm_inject_pending_timer_irqs(vcpu);
> >
> > +             if (vcpu->arch.nested_get_pages_pending) {
> > +                     r = kvm_get_nested_state_pages(vcpu);
> > +                     if (r <= 0)
> > +                             break;
> > +             }
> > +
>
> Will this leads to skip the get_nested_state_pages for L2 first time
> vmentry in every L2 running iteration ? Because with above changes
> KVM_REQ_GET_NESTED_STATE_PAGES is not set in
> nested_vmx_enter_non_root_mode() and
> vcpu->arch.nested_get_pages_pending is not checked in
> vcpu_enter_guest().
>
Good catch. I think the diff won't work when vcpu is runnable. It only
tries to catch the vcpu block case. Even for the vcpu block case,  the
check of KVM_REQ_UNBLOCK is way too late. Ah, kvm_vcpu_check_block()
is called by kvm_vcpu_block() which is called by vcpu_block(). The
warning is triggered at the very beginning of vcpu_block(), i.e.,
within kvm_arch_vcpu_runnable(). So, please ignore the trace in my
previous email.

In addition, my minor push back for that is
vcpu->arch.nested_get_pages_pending seems to be another
KVM_REQ_GET_NESTED_STATE_PAGES.

Thanks.
-Mingwei


-Mingwei
