Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA7067F096
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 22:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjA0VoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 16:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjA0VoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 16:44:04 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDCD7B417
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:44:03 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so8899101pjq.1
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5rTEgEodGL6cJpjtjTY5gAIMYsmuHr6YRAB19Z1yLCA=;
        b=glyL4fEbkcoiT1zpTlvzCLd1l5FE6mDeHUOC3B+TtxRjCtpKi0/ECPvRa9Y1yd13e9
         uAxyLN6sABt1ZWig/80O//SaF7BnJYu2ABPPJVJ8vHmrsHldonIZfXNCjBurtuRNPDDG
         jeXowVW07ZI7DZe4sdqHd8AySGL6k8fADedc3ndl5r+GJGh7GlpYiLBPSMFIG6buztH+
         CKy29hKdjFpAjk10EGzjxXs4PkrpCac26ZYScJxYEqNFoR5Adaza2HJBQckue+V1JYl1
         7jd4WKS+TeEv9Pvhfro/Fenlo7j1yHMeDM9oorqW1nIvlhHvyWdwytFm/TQ7pFqwrD+P
         /nHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rTEgEodGL6cJpjtjTY5gAIMYsmuHr6YRAB19Z1yLCA=;
        b=dUo2pd4/WdESCByI4V+FJ14yWheIxneiFvCs6hdNA4IoMi6e3//jPCTYUE8PC4xZE3
         8c+f144ZvOlsV/qiO/1/EFuwOKTDblWxZ1UbwN/NNwIcN1e7YS4bT7uMKdBNd6WZ2nUj
         0Qgb/l7tCDYEpaKsmtrEPHVjB4/KSAoKoiTKDMcRFvrONXyAi0fd78aH5ISw3YFfR443
         UKabw1idKV9lGaS+cOrHmsjGJ80c8LorTfuxatKfYqGRou/SLWF8zypbqviPbWCPuH6j
         hUf/k4ZbTaNXy60pnU/khnvQbpsp7A1ndQjUfUsh15bbiWpogeZRXeEsFXc8CFpYTnFq
         YABw==
X-Gm-Message-State: AO0yUKXnB8VNKmDIlYmQ/Qt9FfkXpYCR7xnOiLkY4AmyWRieIpqrbqDH
        0bH1pkAGT83O8NLqItGFuOYrJQ==
X-Google-Smtp-Source: AK7set+7JgBQ1Sq3kzSRF91nzW4KSdasZb2TcQ2Z0Jccvdhq19WBLvPaZ1dYZeltOnbY8FuSTH8OlQ==
X-Received: by 2002:a17:90a:6949:b0:219:f970:5119 with SMTP id j9-20020a17090a694900b00219f9705119mr143951pjm.1.1674855842543;
        Fri, 27 Jan 2023 13:44:02 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090a9bca00b00218cd71781csm3189800pjw.51.2023.01.27.13.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 13:44:02 -0800 (PST)
Date:   Fri, 27 Jan 2023 21:43:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v2 08/15] KVM: x86: Add Arch LBR MSRs to msrs_to_save_all
 list
Message-ID: <Y9RFngDO3ip9vTwi@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-9-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-9-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> Arch LBR MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL are queried by
> userspace application before it wants to {save|restore} the Arch LBR
> data. Other LBR related data MSRs are omitted here intentionally due
> to lengthy list(32*3). Userspace can still use KVM_{GET|SET}_MSRS to
> access them if necessary.

Absolutely not.  "there are a lot of them" isn't sufficient justification.  If
the MSRs need to be migrated, then KVM needs to report them.  If the expectation
is that XSAVES will handle them, then KVM needs to take a dependency on XSAVES
when enabling arch LBRs.
