Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAE257A1AB
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbiGSOeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiGSOdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:33:52 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2179E6175
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:24:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r14so21888786wrg.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WNzGE1u5XBqK6Mb53sKBN5FU4Tw9+8CwrSdfuz5XdPs=;
        b=bfJEy/cnbMf7Dd+3HUkkFGC74hUVFhvhiX6RtKyPK1wNJDjzvZWDt9+QS+wz40FrTN
         HztEGcPqJAgSYKG5Ud5mP6WUgE5Vsy1Ey8x4vwxGGzkErc+F/f4zZMXKV0W4AoLMIYlK
         rdK+I8odxO/LtKbwOdwbk6RtcEFXy0MMU564JRUEqezINa/PYfR4wFoBfsx6h291tdla
         2u52mftckZzlk3NyzHKaePzs+dBYbx4O1KOBoQc6OldLHSFib9f4w0hUX9pjQsZ2PO21
         3eHZvRyOltIeXzszeKsuuBmjOvDQD9I5sMAE3gYJJv6Epw3/x+G4XvUt9Ds5GsvWij9u
         3y9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WNzGE1u5XBqK6Mb53sKBN5FU4Tw9+8CwrSdfuz5XdPs=;
        b=7UmOT9yqaVj+/80QJMTNhcd1RGYwldhFoEVkGxrdzcRIsFNotC1A5++e6HEaORJiEj
         5RK9IDnPtZfUSM9Fsowc9hoJDkU6GkZZbIS7zMFahLk9UUxG7UI1iXuTG4T5h3wNUkHc
         HgnG9PGDP4kx923+NLh38r8evsOcQI8LvGRqkLwjrd0LNhBz6fYbNOcUGoX47i8gmjD2
         4qnRmKFqNb9ZfJXH9oUbQOqao/+luOFHKaaVh29MGMIq/VGFCwlgeBAZhAVpmJ4qR2UQ
         h9+/WMroEA7hcaFpUcusWhiayeXHPkU+0UvdzrdfoF0i2sXit74juNYDUqswS080T6wT
         nN5w==
X-Gm-Message-State: AJIora/STk3VXLO/IFo3/WYi9CG1UXgbAShUwLbglN8kEPNb4dzjcWuQ
        wN6Kw2PUYVjJy4i1/ydxqDgybA==
X-Google-Smtp-Source: AGRyM1u/zzb8ihXo42fNXAW1OoFznD0EcxAfeIq6ZlSo4Z+it7CYm8RtVz9+EnpyHMxpc1irG479Bw==
X-Received: by 2002:a5d:6d8f:0:b0:21d:b7d0:a913 with SMTP id l15-20020a5d6d8f000000b0021db7d0a913mr26582401wrs.462.1658240659597;
        Tue, 19 Jul 2022 07:24:19 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id e9-20020a05600c4e4900b0039c811077d3sm19310285wmq.22.2022.07.19.07.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:24:19 -0700 (PDT)
Date:   Tue, 19 Jul 2022 15:24:15 +0100
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 00/24] KVM: arm64: Introduce pKVM shadow state at EL2
Message-ID: <Yta+jyw9MfYQPC+e@google.com>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
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

On Thu, Jun 30, 2022 at 02:57:23PM +0100, Will Deacon wrote:
> Hi everyone,
> 
> This series has been extracted from the pKVM base support series (aka
> "pKVM mega-patch") previously posted here:
> 
>   https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
> 
> Unlike that more comprehensive series, this one is fairly fundamental
> and does not introduce any new ABI commitments, leaving questions
> involving the management of guest private memory and the creation of
> protected VMs for future work. Instead, this series extends the pKVM EL2
> code so that it can dynamically instantiate and manage VM shadow
> structures without the host being able to access them directly. These
> shadow structures consist of a shadow VM, a set of shadow vCPUs and the
> stage-2 page-table and the pages used to hold them are returned to the
> host when the VM is destroyed.
> 
> The last patch is marked as RFC because, although it plumbs in the
> shadow state, it is woefully inefficient and copies to/from the host
> state on every vCPU run. Without the last patch, the new structures are
> unused but we move considerably closer to isolating guests from the
> host.
> 
> The series is based on Marc's rework of the flags
> (kvm-arm64/burn-the-flags).
> 
> Feedback welcome.
> 
> Cheers,

Only had few nitpicks

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

Also, I've been using this patchset for quite a while now.

Tested-by: Vincent Donnefort <vdonnefort@google.com>

[...]
