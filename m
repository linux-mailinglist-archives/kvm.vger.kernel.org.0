Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111A17B998F
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244294AbjJEB0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjJEB0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:26:39 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EDEC6
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:26:36 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a23ad271d7so6068767b3.1
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696469195; x=1697073995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pAYXXZZrtq6qVtd9bBLCof1AkK8uP0CzKodj/aevUuM=;
        b=eVCIoHkSct9yfXuYgoVEA6jqm6lWjFYEtrYjZcMuXSH3mhYnqshJQt47/ynlu4g70C
         4FELsE4uVk6lG5x2S8+9hzodZu31O2KuRxFTDWMkriCHGPCseCk18w1wpUjELNiKGkxT
         ztA2ozCASs3UL7i/ra2mMfkWJm8HDyYu2fKolR2xOgN7HnlGxPvl4HIVP//6p8E74LFP
         6n51EOLeya7oYDfkLMWFCvAOmtuMHXXDVNySAcPjxZDYfjF/uCP7P+/uR/jjwIYgNKOe
         Nf/hpliR1zkjiAgj+wc/nALWa6dQO8/cmE7zCUkO+RTjgnZ6dLq8Ik8d7JGACb4g0Ts2
         Z4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696469195; x=1697073995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pAYXXZZrtq6qVtd9bBLCof1AkK8uP0CzKodj/aevUuM=;
        b=R0Az1uwtrx2M/ey3H4VZCiCIR4H/WPH+sU72ySk4YV1BxY2HAGPPB6ghFkKI0d4tpj
         PF6j6pQLHc9wvOa/XkCfxinRm4njYpobb2uRJwD6ckgKaXNCiD2NwGwe0SiVB048z3rl
         rrNz12bT2kg6AIR/4jix9YvFik8sm+NGPVt7HbV+LRdpnciMryuPWKFl9kb6ISmiAyJs
         zhBrc/ou1rOCy/FtmNHwnrqzryANun6+49KRt7feKkKbQmKRYf/lo+hymUN4nPGHLZkp
         AzQDuK4gEsxQ1h5RPcv4FDvzSm5GXre1F2n/mQP7R++FxOitik3j4WQSuyLFeFcI/5ud
         0uJQ==
X-Gm-Message-State: AOJu0Yzt+fwRfJUlvSApm0h+mjq7xWiu4Z83Jw4Q/DjbjpkJ3KOKev18
        1njAFnLpwAWmxWuFUzvzaYEA3+sNXIQ=
X-Google-Smtp-Source: AGHT+IE4tvEFWYdA+2STjnyOz4sD7+XQagXBrtdo4DeeBBCeS2cJcL9Ogqq1easuFZmclPalNjWAGSxhH6g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b2c6:0:b0:586:a58d:2e24 with SMTP id
 q189-20020a81b2c6000000b00586a58d2e24mr79019ywh.5.1696469195294; Wed, 04 Oct
 2023 18:26:35 -0700 (PDT)
Date:   Wed, 4 Oct 2023 18:26:34 -0700
In-Reply-To: <20230908222905.1321305-8-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-8-amoorthy@google.com>
Message-ID: <ZR4QyijDUsMX40U8@google.com>
Subject: Re: [PATCH v5 07/17] KVM: arm64: Annotate -EFAULT from user_mem_abort()
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for guest access failure in
> user_mem_abort().

Same comments as the x86 patch, this is way too terse.
