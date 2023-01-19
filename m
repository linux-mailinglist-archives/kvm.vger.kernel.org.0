Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FEF674411
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjASVMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjASVK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:10:28 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A295A5CFF
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:03:49 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4faa8f4bfb9so27858947b3.17
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=66eoUQLINoCSZe5217U1Za9CcjZ6XPwbHrQAdTCRdT0=;
        b=F3B5GY4i6AvBwIMPRt9TTV7xIiShSyVc0ke4P2PCipYOd7eMwwmcR7LCzt7gaXlEC8
         goE/ndzrH9yBB6TJwR1G2FOFx5NezouPVAtRR8uaQ4HyWGtPsATT8tEZWiWcLcyO03L4
         N9ceEQntNJV8Xh7pN9ZvMEaSUMklFqz6A31p1s9IuQjIzYP8ik6InjSi37jRMLiEpYpx
         +Hq+Pz8UgWsFp16M6wmBLLXQT+cgkBoHXHn5UmZPynEm1IYzvvHrNoxdd+fnDIE51aWz
         BFE36UWOpkM+XA/Ho5oB5xF/TLREf8amXzqqRpJK514YP22lvXEYiQNhDox9Hh/6Tkgr
         1vTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=66eoUQLINoCSZe5217U1Za9CcjZ6XPwbHrQAdTCRdT0=;
        b=sa7b6flMH9gCvKyxHLYZhPMXwlK3tqaEZjerXddf5Q4y8t8sT/1f6vaHansvAO2Jd/
         QN8726wvm0zxhycpZ0DjXk5Q1X26F1dKiqq2ijL3XwKinXYhusgvu7l3onuolZ36rocf
         fL4V+BPBxjm/C4dhKrSMVvkQbYlHptSIo7xf+K/HvbXjEUF2kdvXhE9m7NGRXgcjvVfF
         Q0kKAbs885OPESsO5puqYbdFKKwoCtMN+93D1GSha7bnS7bT5eYnPWIAIglXW+DYns5S
         yNGUQnWofJFKH8Slf2bmUybsIadffNHt3fydHPr48FZkFkdqL61tbDEJqEqoOyzDsAPa
         fCzg==
X-Gm-Message-State: AFqh2koDgrOBG8bErHXmA42bz0h/UQYYXCa4nA7Ocvy2omDpXSs1OHrI
        jAvId2VzKXd/DOdN8/O7B3rY+OeGFNw=
X-Google-Smtp-Source: AMrXdXsQQJdr3aUFiThwbmTDiIynCoVVfraAW9LljNpH9q1hCzIigCtiKAPQFE/ofE17HM+6Qw7M8PWE6Es=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:38a:0:b0:6fb:b4af:e56e with SMTP id
 k10-20020a5b038a000000b006fbb4afe56emr1324727ybp.60.1674162228549; Thu, 19
 Jan 2023 13:03:48 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:03:36 +0000
In-Reply-To: <20221119003747.2615229-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119003747.2615229-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408889183.2366972.15087378165814021774.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Access @flags as a 32-bit value in __vmx_vcpu_run()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 19 Nov 2022 00:37:47 +0000, Sean Christopherson wrote:
> Access @flags using 32-bit operands when saving and testing @flags for
> VMX_RUN_VMRESUME, as using 8-bit operands is unnecessarily fragile due
> to relying on VMX_RUN_VMRESUME being in bits 0-7.  The behavior of
> treating @flags a single byte is a holdover from when the param was
> "bool launched", i.e. is not deliberate.
> 
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Access @flags as a 32-bit value in __vmx_vcpu_run()
      https://github.com/kvm-x86/linux/commit/55de8353fc67

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
