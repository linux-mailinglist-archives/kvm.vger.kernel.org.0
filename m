Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8835F610562
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiJ0WLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiJ0WK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:10:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D687FE44
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:10:57 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id pb15so2972362pjb.5
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IuI/0R1bIjVwvXYcHUmZYJwiqSkXr+1DnaKw/4nNBZ8=;
        b=ki1vR77HN/48VQ7yc9llOe8dR5wRA68cnzWGiray5OJKUfHBdQG8ek2EfWGwA51R+/
         vkFdpPZZiqUf9PVZzvcqYxfxcIXipANSTVRKvxK/QEiql5I5UwCjdel+x1+dxcgIfeYX
         Ha98ig6wy3SD40k4xaVnHhI9KHahGwjLbbymzzcuuMv7lLJtpSllwre+TBMNY9rIz2MU
         avQeYuxLwFRvNWYz39tkcvY282z4jgWTSM+oG8ZzBTDxIS4PMUwXgM5r5i1z+S+z9hix
         BOig3+ucIq9J6ZUB8h0OM/4vU7nB7tglDDn5xQNzSP27z0jdCtA1g9fiuSUU9n5AlG3n
         TGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IuI/0R1bIjVwvXYcHUmZYJwiqSkXr+1DnaKw/4nNBZ8=;
        b=4yxyBIdxH86tz2Sw1gkhNRlU8Rt/3jqUS8NutMx2iVgsem+g7XLWSSHFELSs+Xj1Sc
         J9lFSE/cFySVzNUyweExMQ1lJdDuJEkBm6msogSlX0qz0O5cBdtH1gHpzg9gJck/QyCk
         7mWUBiH167M6YAX/XTrXY7Ps/ScZMAduLT3iRPGjLlxkWLAM2d+3DC/2a/lc6QP4YfGX
         yLqcXS0Yw/Za2tKV4yqj6rBRc4n8DEh9KcyHOhxHjKriZ9EIrR6BTubcZDx4L1dTMrm7
         +5XIdt4lgygmdol52TdrSo1So+JQtp9R3xTbLJWGpdfS1m884zr/KRKYdxGf9AtjxEQQ
         FBDA==
X-Gm-Message-State: ACrzQf01YR4sVrb3eR7FNYqEvwHeRMNC9L+NCLzCOusCg/AiIGQVFWSd
        64K4LvuGfUoAZlm4u293WnFrbIuoLcaKYA==
X-Google-Smtp-Source: AMsMyM67DBoVfZi0zoK5oEmAzA+jA/XatPVggiwWgW+3C+wlRDnWKYaWV7kcQF8Sox2umPHzQNV3yQ==
X-Received: by 2002:a17:902:8bc9:b0:186:e151:6b29 with SMTP id r9-20020a1709028bc900b00186e1516b29mr9635273plo.8.1666908656874;
        Thu, 27 Oct 2022 15:10:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w64-20020a626243000000b00553d573222fsm1598594pfb.199.2022.10.27.15.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 15:10:56 -0700 (PDT)
Date:   Thu, 27 Oct 2022 22:10:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs
 handling x86 generic
Message-ID: <Y1sB7dimZIl0GOBD@google.com>
References: <20220919093453.71737-1-likexu@tencent.com>
 <20220919093453.71737-2-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919093453.71737-2-likexu@tencent.com>
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

On Mon, Sep 19, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The AMD PerfMonV2 defines three registers similar to part of the
> Intel v2 PMU registers, including the GLOBAL_CTRL, GLOBAL_STATUS
> and GLOBAL_OVF_CTRL MSRs. For better code reuse, this specific
> part of the handling can be extracted to make it generic for X86.
> 
> The new non-prefix pmc_is_enabled() works well as legacy AMD vPMU
> version is indexeqd as 1. Note that the specific *_is_valid_msr will
> continue to be used to avoid cross-vendor msr access.

Please state what the patch is doing and why.  The above provides a small part of
the "why", and alludes to the "what", but never actually states what is being done. 
