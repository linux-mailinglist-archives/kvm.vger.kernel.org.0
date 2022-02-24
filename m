Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8EE4C2FA9
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbiBXP3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbiBXP3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:29:31 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB081BA14C
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 07:28:59 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso6022134pjk.1
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 07:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VWJVSEVc6yu+iQURcrOYouYc/suTELYQuIE1nRPdups=;
        b=LQv74hMCwXu94WMaXezc8wryMNsIKIf1H7cEAt1VPvotbA2hrWh2680FFW95tg4va4
         cO4gm48NkL8MpPRcbx+nYhKE629OfnCo7mpZAK4qSan7nD7NUymd3nW0uFK/hh3WbcJo
         W0ONMtnowaLMNL6arpS3MFaJFQtLVZTkXpTe2VUoE851SlS+Py5pc4MolDlUZbFLmorW
         C0M887Wo/sJIiaNEHjLoGA9E6h0PYpVEBJ9/hwFQlyMFT5mA2qm5NwN7SvFBxyKoeC5G
         0UYL5NsZ9kkg1a1OYOd+zatB0s055UzRXIKWA05ZaW5TFfWrwKnd5f4RRF19Snb3N0yv
         NK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWJVSEVc6yu+iQURcrOYouYc/suTELYQuIE1nRPdups=;
        b=Eb4ayJyT/XX313xIqWcjLRwQTRcvLTHi0EXRIGBft6agvi/6SkxzYMDDt8cW6PkBZe
         hwCxp3QSI52IGwWQnbBzlpxivz3vSxIT0hrir4vper1a5sCqugQGQFgAkbM0H+hf2o0P
         CS5RFjJgeRiH4PQXTyqP/8svoCU6zfHR1F3PfhMCKr2JLYvrlz3rndIeiZSUOBeBbVvf
         /41ujJsTzICp3rXcIF7k6wnW/N6KFdY0pY1zm6WzqYFvI1FDJFxgM6Ug2+eu7hx5QuD0
         RZozKlxE3zkfhg0ZVuu0FJukmJswJuo0HGa8EDAouSzM3LNcZrZirr01XKiJ2qLNNdif
         Zttg==
X-Gm-Message-State: AOAM5336wMUOp3KNNiGFqyo/kUL36BPNrqo18TfJQIwPmoQj99S0zAD1
        b1T2eJPCUqRwYPjRvM3jt1rLmA==
X-Google-Smtp-Source: ABdhPJyKPNnW5mH8giEzV28DtABwB4Or+80/28YosK2mpIOjA1XHrdktFRYzj48oABrn6I2WjUdqEw==
X-Received: by 2002:a17:902:7403:b0:14f:9f55:f9e6 with SMTP id g3-20020a170902740300b0014f9f55f9e6mr3327796pll.21.1645716538706;
        Thu, 24 Feb 2022 07:28:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p10sm3869680pfo.209.2022.02.24.07.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 07:28:58 -0800 (PST)
Date:   Thu, 24 Feb 2022 15:28:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH] KVM: x86: Do not change ICR on write to APIC_SELF_IPI
Message-ID: <YhekNhrK7VKW1jDV@google.com>
References: <20220224145403.2254840-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224145403.2254840-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022, Paolo Bonzini wrote:
> Emulating writes to SELF_IPI with a write to ICR has an unwanted side effect:
> the value of ICR in vAPIC page gets changed.  The lists SELF_IPI as write-only,
                                                   ^
						   |- SDM

> with no associated MMIO offset, so any write should have no visible side
> effect in the vAPIC page.
> 
> Reported-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
