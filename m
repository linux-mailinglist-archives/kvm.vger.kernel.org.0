Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E004BC31E
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 00:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240271AbiBRX74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 18:59:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbiBRX7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 18:59:55 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCD724CCC9
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 15:59:37 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u5so8360715ple.3
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 15:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q6p9DfKxnb44mWczJVEWbdwxvBiHEK19dGePUqQq7NE=;
        b=cgqtv9E7IihbY/8UIaJ3STb//TXBl/irxYjkj8UVhF9numcc14jcxesOiNK37DtBgn
         VHOnFHtYDtTAObroCu8BXEk/cX7v8OOdZj+tNvXyvmlv3AiX82Mx+VjfrbkEATrvamyE
         cKGzU0MmFdnFnTmWrclGTg1141rzdyw6w1uyA9rS7U671nSv3xj6UJK23cnHx7R9ajxk
         2huOLrV5ausQcUkvSPE6CGIASAN0ySjk+l95HflbFCKnJwDMMdPJZNMyqd+DChLQwCPV
         bdt7ZeRmDX4OYVuqS0Xg2oOcrZ6a7cqSqKbf2I2C5VBaBX/7mNE6xnkL7MfdJjra94rL
         PphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q6p9DfKxnb44mWczJVEWbdwxvBiHEK19dGePUqQq7NE=;
        b=Ry5wLq/K9JqUbbNvuBymUxQmfRpr0R8Yz0ZfgJUmaxEBBYdPFxwJnVMB67Vd5QPDJo
         j42sQ677YyHfDYr8OWJ5mEQBEUcDO5hLJ6eSon03M+ApDJGl1xxrNuDZgD1aOWChDqPE
         rNh9XmReVL408B3wg4tlKxc/zRCQv4ulVWsaPYGOe/87FdoOY0CmOtEFE6s+/cg39NzZ
         pgn/gKwAY7AU6pebwb16KGoRvO4Vp3D06D/SbPvuQ1ah52wzQqza3f1vCjBkRkw6nN6z
         bDesP/KG8SNusGGkBvBF6+yaJ7sThDIS1em1p3I2jn5Weghc/mPUo62W6V0Cx3aM3CxV
         2ZaQ==
X-Gm-Message-State: AOAM530MpvoYbMbrgzioAF9kEOkbd1xVHaSd+YjBJOT/To19fKO7vWdW
        1EbZUJGk9FhtFfA3Ykh2rhgB4g==
X-Google-Smtp-Source: ABdhPJwP7g2PBzrfRW+dJFHKyHMo1/ACbCcUXy73/hUX67LiFi9JKSA5kif3obLZ/k8dRCCZnZnGlA==
X-Received: by 2002:a17:902:cacb:b0:14d:81e7:c698 with SMTP id y11-20020a170902cacb00b0014d81e7c698mr9480453pld.96.1645228777273;
        Fri, 18 Feb 2022 15:59:37 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j12sm4085867pfu.79.2022.02.18.15.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 15:59:36 -0800 (PST)
Date:   Fri, 18 Feb 2022 23:59:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 12/18] KVM: x86/mmu: clear MMIO cache when unloading
 the MMU
Message-ID: <YhAy5SHbZQ3t6C5m@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-13-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-13-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> For cleanliness, do not leave a stale GVA in the cache after all the roots are
> cleared.  In practice, kvm_mmu_load will go through kvm_mmu_sync_roots if
> paging is on, and will not use vcpu_match_mmio_gva at all if paging is off.
> However, leaving data in the cache might cause bugs in the future.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
