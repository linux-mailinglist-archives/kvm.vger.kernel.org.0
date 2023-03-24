Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EB86C86E8
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 21:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjCXUih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 16:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjCXUig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 16:38:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BDD468D
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:38:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s11-20020a170902a50b00b001a1f8fc0d2cso1795329plq.15
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679690314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p6DBp/JrYyvOHBJKF2QKt7opD9f0hVHsUAfpSQRL0ro=;
        b=aJ7omCRr//kKPq+WTtOC47dLXbMuI69w+eTEQnijuNTsLVRXeCeM6uBvwHhC6tidu6
         IGyrItSnNE90EzWub56I3QRm3l5cO91DaAzPzhB6DmVWRdgW7rZOrmbiuiy4eUzwatY0
         t8qOy5UjwUMbSOvIqUyU15p6zuc/3zKLPcHsTKEHwziQ+EQBHZkxWXHgB1fEUtLWA/WF
         n2G+ybhR2cP4nyCiumStsHUQjw4MomyeoR84K0s8Ja90giLCdb7IvKa/y5LQ6v8bbZyp
         1lmJHePoyO4b3yUTrDqrxbC37+DScRAAqoujNLGK6IgKVtG/PhrJOgmEmA/2jwbTPad0
         xR2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679690314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p6DBp/JrYyvOHBJKF2QKt7opD9f0hVHsUAfpSQRL0ro=;
        b=uhTrNbmVfxdChZ6Nbs5kLGloBLAWw4Sd3M68kj1Zbs24giusib9MyMU8iK44AYeuL4
         T1qEQyWfOmP7QnWRAycVM4jvwcc+5zYAv4kSOcO+Ual/q6/QxA/QEGpYiWDi8VgfslBr
         FzV+XZivYYtpByc+k8gqsI2fsZDTLOFooQuslNyIQQnS2LTdSAHEZpSQoN9zkehNsSc9
         WulfQ06wmGkZU9yBkmiIOf00zuObbbf8HNe6qVJqHb7VhKWXd6bKxz3t1pHYI+SQuR0A
         ruI2Qb7k0DRzZXI95D2o4ZH5zru6pV4TT035/kItr8h9QLBDYswMCwYTpuvsF8zum4F+
         p8bg==
X-Gm-Message-State: AAQBX9cfmPg8CioLagP9PvNs1zXuknhG9rPEG/JsWmR1WHy9WLbnu1R8
        jCh+drd+MnbOhIBBHwyeAeY8M26hlw8=
X-Google-Smtp-Source: AKy350a3ol4myuao1NLKbXlId+/hWKhszi9lxiKTdHxWXhiWoj5Zx5v5Jy9qajgNGkbaYxQ8VWL0Wfm4xx0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1315:b0:1a2:13af:7c77 with SMTP id
 iy21-20020a170903131500b001a213af7c77mr1229400plb.13.1679690314483; Fri, 24
 Mar 2023 13:38:34 -0700 (PDT)
Date:   Fri, 24 Mar 2023 13:38:33 -0700
In-Reply-To: <20230221163655.920289-6-mizhang@google.com>
Mime-Version: 1.0
References: <20230221163655.920289-1-mizhang@google.com> <20230221163655.920289-6-mizhang@google.com>
Message-ID: <ZB4KSZNsWozjvnL5@google.com>
Subject: Re: [PATCH v3 05/13] KVM: selftests: x86: Add check of CR0.TS in the
 #NM handler in amx_test
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Chao Gao <chao.gao@intel.com>
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

On Tue, Feb 21, 2023, Mingwei Zhang wrote:
> Add check of CR0.TS[bit 3] before the check of IA32_XFD_ERR in the #NM
> handler in amx_test. This is because XFD may not be the only reason of
> the IA32_XFD MSR and the bitmap corresponding to the state components
> required by the faulting instruction." (Intel SDM vol 1. Section 13.14)
> 
> Add the missing check of CR0.TS.

The check is not missing.  CR0.TS is never set in selftests, i.e. this is pure
paranoia.  I've no objection to adding the paranoid check, but it should not presented
as a "flaw" in the existing code.
