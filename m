Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33E17D05C3
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 02:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346783AbjJTAS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 20:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346774AbjJTASz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 20:18:55 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC83511D
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 17:18:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9ab7badadeso353237276.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 17:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697761132; x=1698365932; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oCf557FJxk8CtHL8V069b20YLPs5sHpQLuFktvsDz3M=;
        b=BVFptS7SOmcCCdOP4aVFLYXeQpxufbRjhEEEW234kwzOYVlxB894GNh8R4XhTp6Fou
         lB/pEUDbUwxBKP11P5ihQgoJO2Y8dEyQul0vYw/i2vfuA6Ns7YLmQ8XSKWfq1XWOw3zi
         F/AVpJYxUynvme1bLWPCqSeqzBoyXxu7l9ZfDjFHxGN2ebpPP5HArgzXie97w5AqExSk
         YI4a6w7wTvMIVEjsXwS7p1+xnRFVZGSQXjBa1532hAdjoCT9CDR48WyReoOeR79N22Bv
         YaCqP5vYpMkdy6FA+hXOYQbh+Divavm0mmbV0hhlgkYmGuFBrlnDN56OYkv5CTYdDfqD
         /VMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697761132; x=1698365932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oCf557FJxk8CtHL8V069b20YLPs5sHpQLuFktvsDz3M=;
        b=nonQoQlkUgOHVwrPefvDYf/Y3DJ0+5ztlhuEUJ7hjaHZetJwvQ9P4b7G5fplWCE0Nn
         0LInHjLhf5l49UOZ2V0Dil7QRvdnHfjyHUk3MBBL6pXolgr7FyAnsxDy4Loj5L6ULYW1
         RpkxzvUaMD+h/FtomGqG2sAx8z4T6KDWiaqMouL2vZD2DRxnUL2lDK67fgo8qzoDg6F+
         pL1I4tzO9KNBW02EcLtesCNlqPzhVlc9vM9EOnqfJ+ndLuA5kYRolq/kP/3OSB+yU2af
         uQCV7ixo5u+ALrK95Q/PnRYp9O/8wI7AaC5kLNeSy9sAlNnzuRC3J2ZpBOxp1ebxz5Bu
         0+Tw==
X-Gm-Message-State: AOJu0YyltyDINyb6Nc/EJb2L3oEKir7Apt8zMS9pJ/7a99dvteRzPDKn
        Zup9qJHZmobJvZHNfbBiqmq5LPR0Xic=
X-Google-Smtp-Source: AGHT+IHNdE82FHmKAlbJ3pikT/a6fTttzayM7mDKGcRBd0VP/gK3i06z/kOWuvYscfIDXw6n8T/5vlN3mlU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:d9a:4f4c:961b with SMTP id
 v3-20020a056902108300b00d9a4f4c961bmr13567ybu.1.1697761132162; Thu, 19 Oct
 2023 17:18:52 -0700 (PDT)
Date:   Thu, 19 Oct 2023 17:18:50 -0700
In-Reply-To: <20230911114347.85882-9-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com> <20230911114347.85882-9-cloudliang@tencent.com>
Message-ID: <ZTHHapdOC0jF23DF@google.com>
Subject: Re: [PATCH v4 8/9] KVM: selftests: Test Intel supported fixed
 counters bit mask
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, Sep 11, 2023, Jinrong Liang wrote:
> +static void test_fixed_counters(void)
> +{
> +	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
> +	uint32_t ecx;
> +	uint8_t edx;
> +
> +	for (edx = 0; edx <= nr_fixed_counters; edx++)
> +		/* KVM doesn't emulate more fixed counters than it can support. */
> +		for (ecx = 0; ecx <= (BIT_ULL(nr_fixed_counters) - 1); ecx++)
> +			__test_fixed_counters(ecx, edx);

Outer for-loop needs curly braces.
