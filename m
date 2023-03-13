Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0F56B7EE5
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 18:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjCMRKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 13:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjCMRKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 13:10:11 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C96231C1
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 10:09:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536cb268ab8so139065957b3.17
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 10:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678727318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wOWZvv6KsY6Um3iQTTUFkaHPzlGY80coB0SG7oNO+Zw=;
        b=b5ONabsAjWKZxLbOivjWXSzeJPtAesI1cLgYh9E4tknpEK7T8irelQP6gsZUDVus2N
         wvWu0ITC5BakYojDUSt98KBJpOIWvPNUIFMbJxaTWYfs8GxKhfKcIwK1YYHagRZ1JgKI
         rXtNbp8CTioo3CRelFXIzqgSFii3b/bVaFApXdS96ncOfF8J7QEfefdhm++dBK42JlrW
         vsDGNoiMLEXtj8SY8dL48N/FuA86ALK0+48NPqGIVDXphd0Tkm6U6BuXihtfPyzpdMzq
         6JtNxxayGH1YC3yWhV9v6eX+lLpA4+tnqSheV0QW2PwT8H7rFDsWh0bIrbzUXtuNJ8u/
         ZtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678727318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wOWZvv6KsY6Um3iQTTUFkaHPzlGY80coB0SG7oNO+Zw=;
        b=hpqK8VA8P/B3xohfOlNjObsDYemEA3J9SAf9JyuHN94pOpUiSCJ1DkwGd2UjCSmtyN
         ySwUtDaxI8VrnaF2mpfnPjnTyRFoXp+8czCkqZzqsZ9tiRng4Al1HOMvFyRnp0SLvGD0
         0qIhZMm5+46bqRW2ZfzeObY9P4DbaxH8CiwWT84j3S+bX1Dd01Cr5S5gB+DogmlEAeK8
         uDmI5QJzmUiV+9Zqc906Pl/pbzKOY8T2NkHFtSWQXXfoPrhAl6k8TaJiG7umbQ++/KjJ
         xajH1JdZ1ah1pzD5ncZLwPAfhTi4tU3UcCz7JgSbaxfouHaS+gX6+Sw8iDjSJ7Gjhb5A
         MieA==
X-Gm-Message-State: AO0yUKVqlPpv672dH+PX+f9QenFWuxthqyGcShmGIyxaU2TGAQJaYsSS
        inyEx1a9b/egY/GaAY42yvr9XbejBxk=
X-Google-Smtp-Source: AK7set9gzsCbZrrZdrlwi2XqkK69ytQhb4omsoaefIaBznHhiIAh2sMw623jd3fj82OyfGgr4Sfg/JSCSo8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2cf:b0:b21:5fb4:c6e6 with SMTP id
 w15-20020a05690202cf00b00b215fb4c6e6mr9040251ybh.11.1678727318583; Mon, 13
 Mar 2023 10:08:38 -0700 (PDT)
Date:   Mon, 13 Mar 2023 10:08:37 -0700
In-Reply-To: <ZA7eTpG5tpo5yIo3@gao-cwp>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com> <20230310214232.806108-4-seanjc@google.com>
 <ZA7eTpG5tpo5yIo3@gao-cwp>
Message-ID: <ZA9YlTknLKRKcCy3@google.com>
Subject: Re: [PATCH v2 03/18] x86/reboot: Harden virtualization hooks for
 emergency reboot
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023, Chao Gao wrote:
> On Fri, Mar 10, 2023 at 01:42:17PM -0800, Sean Christopherson wrote:
> >+void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
> >+{
> >+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback)))
> >+		return;
> >+
> >+	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
> 
> Was it intentional to not call synchronize_rcu() (in the original
> code), different from the un-registration path?

Yes, synchronize_rcu() is needed when removing a callback to ensure any in-flight
invocations of the callback complete before KVM is unloaded, i.e. to prevent
use-after-free of the KVM module code.  Registering a callback doesn't have the
same concerns, and adding a synchronize_rcu() wouldn't do anything in terms of
ensuring virtualization isn't enabled after an emergency restart/shutdown is
initiated.
