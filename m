Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1E06B4D0B
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjCJQbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjCJQax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:30:53 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB87239CF6
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:27:17 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id q24-20020a17090a2e1800b00237c37964d4so4563771pjd.8
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678465637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uDeQbGHE1F72EIZi0wu/BDKlKleRXz8RNdduMTKJMtc=;
        b=JYIfc85H9Lqs5Pdr8vIXKG1AKs+TuV5fULINLbWzKYYKkQYQRIH7ztBbUQN9r+k7ap
         LVNH+i+VAwi4kzO5lFhZcu+ZFoNhlfmOpLlB+2A8n8pH7wPNcifrk+93olyAVDHYgec0
         ZbdLv/W4Ysko2Ef4WLBDEM/URxvCYucYoXCFvb+zKhQgKwGXoCipuf5eI1ZIKnnMbUjM
         In4PrIiWmU+Yl+t+f0+MHfjZyfPB4UhmvxFGKo4YDcWRjPpG3xBAiE8g16YisbACplxU
         0FKCYt2siqXdvixR/EE6w+oJQKcdMNd9fb4DZ+AG0O1VWfJYaouPaVy5MO4VmNjXZf1X
         EVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678465637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uDeQbGHE1F72EIZi0wu/BDKlKleRXz8RNdduMTKJMtc=;
        b=SIml1sFLPTMynR6wxpXZ2kQ9r0HwqrgtZqzsaFLGyeZBYfn/Bp9SR62NSx1wsE6eJx
         Ke6Miy/jO9S0Cfmd9IPycg/nvfZnXVaV62BNm55Oz+GfjPeeRp8KV4GEdKIO24FLTXBd
         O0I+N97R4n1dFwP3h9V0h35UcrRPUYg/rN7BRVh3DK8BvCxMDoJPw6AVwW2rnw2LDt0X
         ClVykx5AoNjE9uzu/dOgZ9r+TP9bp+OlV3LBvGD/EAs6Rg1YUX5I2MnDWmtYxYbudAzp
         NnzsTzZGoeRdG+VHA3j5sUDXebGlUK2DgriUdgDyFm2rTB5cVt6OmYDu3j1T/2dEJZwJ
         hREg==
X-Gm-Message-State: AO0yUKXNj/DVV8Prz3MS9cv1THq2lp4rruFrO8VSHcWnscbOrAkkSmtR
        mWMhGlv5YPrg8gQDbCPwcMsFERA9Umw=
X-Google-Smtp-Source: AK7set+sWfpBka85c3Ee+LON7P7HkWKCZd8n0c88n6A/9K8HoirZ5r98uc4q2zZY3vTBxu+uTkUePh0Ht0E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7242:0:b0:507:3e33:43e3 with SMTP id
 c2-20020a637242000000b005073e3343e3mr6533904pgn.7.1678465636766; Fri, 10 Mar
 2023 08:27:16 -0800 (PST)
Date:   Fri, 10 Mar 2023 08:27:15 -0800
In-Reply-To: <20230310125718.1442088-4-robert.hu@intel.com>
Mime-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-4-robert.hu@intel.com>
Message-ID: <ZAtaY8ISOZyXB3V+@google.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Use the canonical interface to read
 CR4.UMIP bit
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        robert.hoo.linux@gmail.com
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

On Fri, Mar 10, 2023, Robert Hoo wrote:
> Use kvm_read_cr4_bits() rather than directly read vcpu->arch.cr4, now that
> we have reg cache layer and defined this wrapper.

kvm_read_cr4_bits() predates this code by ~7 years.

> Although, effectively for CR4.UMIP, it's the same, at present, as it's not
> guest owned, in case of future changes, here better to use the canonical
> interface.

Practically speaking, UMIP _can't_ be guest owned without breaking UMIP emulation.
I do like not open coding vcpu->arch.cr4, but I don't particuarly like the changelog.

This would also be a good time to opportunistically convert the WARN_ON() to a
WARN_ON_ONCE() (when it fires, it fires a _lot).

This, with a reworded changelog?

	/*
	 * UMIP emulation relies on intercepting writes to CR4.UMIP, i.e. this
	 * and other code needs to be updated if UMIP can be guest owned.
	 */
	BUILD_BUG_ON(KVM_POSSIBLE_CR4_GUEST_BITS & X86_CR4_UMIP);

	WARN_ON_ONCE(!kvm_read_cr4_bits(vcpu, X86_CR4_UMIP));
	return kvm_emulate_instruction(vcpu, 0);
