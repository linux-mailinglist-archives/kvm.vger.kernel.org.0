Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E5B6C86E1
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 21:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjCXUhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 16:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjCXUg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 16:36:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C451E2B3
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:36:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3-20020a250b03000000b00b5f1fab9897so2857589ybl.19
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679690217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qzKYx9+8XUagIX7RdKAagq2FCOW5fF+xAmlNYR7ouU4=;
        b=WMrEWpz4Ed42D//eOGu7mGUIaIpRFSmKiDePya/QhjcJpHFkNYQiKjpkE/VcDX4Zej
         cZS0KKxqCQW/2F6OX1cMrMrwm5duf9BdMZwgSZjRHEW5YDKYvbW4cIuraB5caLCoVVcv
         Cel3FYIbiZEbO4C+FVKdsZfJL0f3QCvhNDeyH+oth5zMiOlEe4dGn8Eidg4Yy5OUM/kq
         t1nBqQbNKqaNtp8sid8XTZq0iTzhoJNFj5rR8Pd1e+7vKizLtrCcfFvqKhjiVs+WvsR5
         FuocCmgAnGmAnneKsbK2edjVbJNzTeBtWPDeN487He24pDhCnJxADZMo8IibhMGcmyHo
         FjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679690217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qzKYx9+8XUagIX7RdKAagq2FCOW5fF+xAmlNYR7ouU4=;
        b=IKDr7hfJUCvFdXIa8Kt9Qll2J0EI2XC614CakS8RxLDjwzLCgRT+uFhM7CrxXF3LGO
         QVSUlX54WdGWG3Ub9xZuiXwbAGqdHxyjfpya14XalFZefk03h+9cmrlED65NBl4KJEMv
         I7liPxFLwWgSl4h3BUrm4rKJp0kwQRlnHKq4U5hSxZOj10YoyW5HG0pLfy2jU3L2bEhr
         qt4UIan9jx3QccYAxIIAPdkUmWOmuyEAnkrj2x0uVsEEOtIfSgeTGyT6IFMDkeNrSlul
         S5nrgiXqTdXp7z+tiMeXk+R/M1b9JPTyWIvNmHUbE9eV0scDmxvzjHPzPS+JhnZhTsDo
         K6JA==
X-Gm-Message-State: AAQBX9e1DfQJ7+qzw3kUY3P6B2zSuyaa9zDtHg/B+fDSZWHfGlOpB43/
        EPZ4X8M4qvGi4gzcR1NCT37WGecH8Zw=
X-Google-Smtp-Source: AKy350YgWsdlh5FPhrckUQqr+3LeU27bBrvg8jPen196T35No2Cibzes+gLiRNS0Qvs5eEMdKmCwAD1HkCY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1006:b0:b78:4b00:775f with SMTP id
 w6-20020a056902100600b00b784b00775fmr330567ybt.4.1679690217136; Fri, 24 Mar
 2023 13:36:57 -0700 (PDT)
Date:   Fri, 24 Mar 2023 13:36:55 -0700
In-Reply-To: <20230221163655.920289-3-mizhang@google.com>
Mime-Version: 1.0
References: <20230221163655.920289-1-mizhang@google.com> <20230221163655.920289-3-mizhang@google.com>
Message-ID: <ZB4J54V16GQdcTrz@google.com>
Subject: Re: [PATCH v3 02/13] KVM: selftests: x86: Add a working xstate data structure
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

Please omit the "x86:" from the shortlog.  I'm not necessarily against capturing
the arch somewhere in the shortlog for KVM selftests changes, but I want the
community as a whole to make a concious decision on if and how to do it.  I.e. I
don't want a bunch of ad hoc versions popping up because we'll end up with a mess.
E.g. I personally think three levels of scope is too much, and would rather do
something like "KVM: x86/selftests:" or "KVM: selftests/x86:".
