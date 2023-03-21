Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA026C3EE3
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 00:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCUX7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 19:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCUX7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 19:59:11 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAF21BAC3
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 16:59:10 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id m12-20020a62f20c000000b0062612a76a08so7062703pfh.2
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 16:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679443149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b5TgmYXXeWayYCNTGCu8BIwutYqhzL+J5AuaxNOWQ14=;
        b=K78CHxxRyw3eAw/lRAkugKqBPDbx+Lgdb9/ajUNF0Cd7Lutp4f+lXc0JLwgO3Ix6v5
         EL7wEePqxAxEaTl305ChXhpApD9P0PVwjQH2f+5MEez32P64/Al6WRCcLFyprNa807U6
         qdhqbp+rH9kYUtZM2urxxO/guTKD+7kM98+k6iGLzyT1j8wvHvuBzP5M2LzA+u2BLQFS
         Wnh2pUFdCvgqV1V/Zz+OOeCKWh2RN26l32/BCj3zqyiR9bd8TWOM4eoH1ryzUawk+6JI
         h/DJFgsgmUB9IiYsnt+tm4JEfDKTHxKbIeQ0H+SPBRtMDe7JM5184Wkky8XBw2X1inGf
         BkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679443149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b5TgmYXXeWayYCNTGCu8BIwutYqhzL+J5AuaxNOWQ14=;
        b=TKPPFntPBimHdl/TjoQ4lU+ozN+N/h6n0GIqBm5L1xpSRUklGOmE3Uh0tommbMfVKK
         fkEuH5PhR1atbGkwAG59Ce59xX7kzSEltA3ARQiOsGrQJZjzfRfyGgmq952t7SEDSKER
         XN+5PN+vltTcmywAXqCSM+GOkLB2W7aI3SQn5hT+Vb0NM2ZtONHDuXpole3bKqFaFIav
         kM1f6jhDaBv9WGu5nhX4D74wknAI23KPAymM8J+DD5U3TsX8ZIu+K8g5iEhWY2pI6WIk
         s3rq3jfrN5h7V/MJ+yS9teggXtRdNZ/9qOdT6EwGhFI94qvqLOZPwZIyAyPWEU7KF/Ul
         fv+A==
X-Gm-Message-State: AO0yUKXMZdT5cWDoBNR6HBP9GWE7O+dOev2xC6avZPQbOhaKm81610nl
        Og0PdaiiuDJ04on2xMR33KgWMIaywyM=
X-Google-Smtp-Source: AK7set8kr3dsIHIaDK6jUuo0c8QyOdlkxUO/1IqHA4w5xLAfPid1BnozknowQG9QndIvxMq97bM5X+1g8/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7648:b0:23f:6efa:bd55 with SMTP id
 s8-20020a17090a764800b0023f6efabd55mr497162pjl.8.1679443149679; Tue, 21 Mar
 2023 16:59:09 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:59:08 -0700
In-Reply-To: <ZBhzhPDk+EV1zRf0@google.com>
Mime-Version: 1.0
References: <20230201132905.549148-1-eesposit@redhat.com> <20230201132905.549148-2-eesposit@redhat.com>
 <20230317190432.GA863767@dev-arch.thelio-3990X> <20230317225345.z5chlrursjfbz52o@desk>
 <20230317231401.GA4100817@dev-arch.thelio-3990X> <20230317235959.buk3y25iwllscrbe@desk>
 <ZBhzhPDk+EV1zRf0@google.com>
Message-ID: <ZBpEzGxB6XzpVMF4@google.com>
Subject: Re: [PATCH 1/3] kvm: vmx: Add IA32_FLUSH_CMD guest support
From:   Sean Christopherson <seanjc@google.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023, Sean Christopherson wrote:
> On Fri, Mar 17, 2023, Pawan Gupta wrote:
> > Thats what I think, and if its too late to be squashed I will send a
> > formal patch. Maintainers?
> 
> Honestly, I'd rather revert the whole mess and try again.  The patches obviously
> weren't tested, and the entire approach (that was borrowed from the existing
> MSR_IA32_PRED_CMD code) makes no sense.

Yeah, revert incoming.  This is just the tip of the iceberg.  SVM completely drops
the error,  which is why there are no boot failures on AMD despite having the same
broken logic.  Neither SVM nor VMX marks the MSR as being passthrough friendly and
thus breaks MSR filtering.
