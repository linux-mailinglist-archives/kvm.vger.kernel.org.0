Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6706B4C93
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjCJQRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjCJQRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:17:20 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D25119FAE
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:12:30 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id cj27-20020a056a00299b00b005f1ef2e4e1aso3066613pfb.6
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678464749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d/03++nvLXzo6mXUK2tZUV7ce+DS+9j/3mycCa10fZQ=;
        b=N5r9fFEaRA+cX28dOQZqDa7Dc2IQwXGyJTwX/oCFbcGiw5ry0Tgw/F1Ii7EIpZq37t
         SssnFV7qOPMIrASAIf5ZzN+yNcLmjmYH/e5BdZcvRzfAxixjNQWvaYXzif41vF+44nYX
         AlgcGyCosD29P6PSZVXBJF78jaK/pek4B+t5wZl9hbm4QdIbhDoDKoTPIRkhKwzQVshB
         n3p0DyWBwq4AKb4OzcdnzWb/fDutZUXPHB3bkxsEoKdQUJwr58G7Y7ohluRVDoW3Pw/l
         2iFoca5lqPys3fmz2aafYnUmWHigzZOYrgpYGuFODgNpvec0vb3GR4EHoVE9hJNkEFi+
         6s1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678464750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d/03++nvLXzo6mXUK2tZUV7ce+DS+9j/3mycCa10fZQ=;
        b=BSAVWUkoRiaEjbGGorHTdEDRnKn2+8hCzapnP8j7rgOcbFqQzFddptQR3nD1A27eyP
         6y+kmqDL22UprwI88/sYQXmRDMIkKoeNv5CSzUTka/9JDcprHvZF84QZwMgXh3pZONDM
         Xcaqqxn0HDo7voHtFub1EpTke7wIdD0/LBSRLnNTgN5VKSj9FATT6SziToyHtrrD+1Wn
         VKvZla3ved8NkCAanK6L/wO9kV/FN4sixBPoT2C1veR0VL6fis/hp5YcW/kxfH1m4cMy
         NUZrY8p3wt5z7qm7djOzUCaQGed/Msp24mmteXA5XKI86RIfZNK48p/2mOyH/K4Nd4gI
         W0cg==
X-Gm-Message-State: AO0yUKVC3Qm/V1Ndi63X01pv3cpukVK5HmsDdsyGXfk60JJNZvPyPM7i
        EEgdodPzYszj1i2hakhkVQ6OCodc3n4=
X-Google-Smtp-Source: AK7set941ZRRVFMXLUS/T5apjGXYpp+pMZAS2YQ+jXXq7JwRajyQzaxRPkkuz392yh29fOiRihMaMs3mxvY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2950:0:b0:4fd:5105:eb93 with SMTP id
 bu16-20020a632950000000b004fd5105eb93mr8542119pgb.3.1678464749711; Fri, 10
 Mar 2023 08:12:29 -0800 (PST)
Date:   Fri, 10 Mar 2023 08:12:28 -0800
In-Reply-To: <20230310125718.1442088-3-robert.hu@intel.com>
Mime-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-3-robert.hu@intel.com>
Message-ID: <ZAtW7PF/1yhgBwYP@google.com>
Subject: Re: [PATCH 2/3] KVM: VMX: Remove a unnecessary cpu_has_vmx_desc()
 check in vmx_set_cr4()
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
> Remove the unnecessary cpu_has_vmx_desc() check for emulating UMIP.

It's not unnecessary.  See commit 64f7a11586ab ("KVM: vmx: update sec exec controls
for UMIP iff emulating UMIP").  Dropping the check will cause KVM to execute

	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);

on CPUs that don't have SECONDARY_VM_EXEC_CONTROL.
