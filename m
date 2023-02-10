Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AA9692391
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 17:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjBJQpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 11:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbjBJQo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 11:44:59 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0300212A9
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:44:58 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id mi9so5710454pjb.4
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NJHZLI3U8xm4BvE76qEZmYthnYLuvPmE/9R6s6JH2WE=;
        b=PGoM0On23xN1z29b+slMgbz1TJZwnHKNRVJbC7LasGyUh0C3QyF0n0O8XXt+cqNbLc
         hJ3dGJWA4ApfbIMG8xBX7DW8YIUESz9H2waScJMhWCHXciylEmamqDndyd0hSbz6hTdU
         kMm+VcXDMiaQTm+JMifWtE5MXsPj5Ri27EdJ62borjbB/5riiRhUb4EHUx3nd08uv0c5
         GS9S9lEin1mSvQot9SnmuiXPZRyKXxwSE/Xj19CEvgqn7JU0MTQsmjNldmMy7QvC9pnD
         dNMa4zBYDMdlNaobbmicUzL/3IY2ZE+oOCpQGMg4adbatyHii9R9L7J5XyvREuLaIizs
         vmhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJHZLI3U8xm4BvE76qEZmYthnYLuvPmE/9R6s6JH2WE=;
        b=DIaKOphx+zVn4Mp5jeMv9Zwh9Ni8mAwn3nE5CYeYc1hXQJYbLUVA7Jk64IqN1K3k4v
         eQRqneEUfCCHgimaAy4dqoJoiDqaJ39PYwetgGozwIetcz+OjQvvjYFCqnrA4f3sU3rY
         leVdiwas+/IHUN7NHJMNAId806zA+iRpYQ+hXnCZyGkWbXL/r8CKCBwtcYlvV6KS2TxC
         qQKVhLGQdojpNxI7AQMA3tzap/hLItlos4jXm33VPsGdgQJfAplObtB1rPDkIoRpukQI
         jrRZcmvlA3xVXcMFSCN2es1nFRYeBM8UnoOw5RgullOg89OisPmjG9KkbJ/ozAecu3rA
         2cIQ==
X-Gm-Message-State: AO0yUKXN1eaU5ahgXDbLWijEbtwy2kjsWvAzN+/aTJ/IMKVNZdi+6Wge
        R1iMU9+W/QfYM5qcwHEyMqGJsA==
X-Google-Smtp-Source: AK7set8EuUMVEwEQRgYZK/t2nvIEb1AnNNve/LFQPz8u9HOOPOjZgVuNG4+d/sNDJYJaKvLnXUtKGw==
X-Received: by 2002:a17:902:e551:b0:19a:6cd2:a658 with SMTP id n17-20020a170902e55100b0019a6cd2a658mr200687plf.7.1676047497966;
        Fri, 10 Feb 2023 08:44:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i21-20020aa78d95000000b0058119caa82csm3489689pfr.205.2023.02.10.08.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 08:44:57 -0800 (PST)
Date:   Fri, 10 Feb 2023 16:44:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 10/11] KVM: SVM: implement support for vNMI
Message-ID: <Y+Z0hUGLkwADyTNu@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-11-mlevitsk@redhat.com>
 <Y9mwz/G6+G8NSX3+@google.com>
 <439a8cfc-fe2d-436d-2ea2-b795eb983b9a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <439a8cfc-fe2d-436d-2ea2-b795eb983b9a@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023, Santosh Shukla wrote:
> On 2/1/2023 5:52 AM, Sean Christopherson wrote:
> So you mean.. In vNMI mode, KVM should never need to request NMI window and eventually
> it reaches to NMI window then WARN_ON and cont.. to single step... so modified code change
> may look something like below:
> 
> static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> {
>         struct vcpu_svm *svm = to_svm(vcpu);
> 
>         /*
>          * With vNMI we should never need an NMI window.
>          * and if we reach here then better WARN and continue to single step.
>          */
>         WARN_ON_ONCE(is_vnmi_enabled(svm));
> 
>         if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
>                 return; /* IRET will cause a vm exit */
> 
>         if (!gif_set(svm)) {
>                 if (vgif)
>                         svm_set_intercept(svm, INTERCEPT_STGI);
>                 return; /* STGI will cause a vm exit */
>         }
> 
>         /*
>          * Something prevents NMI from been injected. Single step over possible
>          * problem (IRET or exception injection or interrupt shadow)
>          */
> 
>         svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
>         svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>         svm->nmi_singlestep = true;
> }
> 
> Does that make sense?

Yep.  Though please avoid "we" and other pronouns in changelogs and comments,
and wrap as close to the boundary as possible.
