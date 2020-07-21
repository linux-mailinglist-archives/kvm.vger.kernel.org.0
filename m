Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB34F228BA3
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgGUVsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgGUVsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 17:48:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8100C061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:48:31 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id f16so85424pjt.0
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I3Ujz+mGEEmYDtCY+li6aHvm42OcR56inDy8k+DDdmg=;
        b=Bu516rifBpuY5ZDwiN64YiR1VJ0K377jNrHj2J5rzO593y9MhlMUSYD/mQHhNGlp3Y
         ToxeSAWxN0/8+do3wrz37LZUiBjnCt/6rLw12ZC/S2NZ5JL8H/I3BwBRrHCzaNgdyqIW
         YcvWaGe9WchkSieuy1S39/LASSbGePbYl25IA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I3Ujz+mGEEmYDtCY+li6aHvm42OcR56inDy8k+DDdmg=;
        b=Lh9cc8GCczkDhj/WK8xKmEuXvwweBbZA0nPixbBK/Dvz036zU6LzqM0vz4CnOIkcgI
         y3aj+VIcMG+VggiGPAiG58OjN2Rdm5j7DPEg7n6mmWFQS63UukNjI0rCBqkxp58Ywg7e
         4v9c+vavBZpb1ELzP502fc2D0srrs9+g4DKBZ8n6mGqlFIS3Uofp2LNnfL2BIj6/gwq9
         +DvEIeWednoO6tEf6QHnVmuW43dwXUAgW2OynwD3kzfDm3Vu8Fhdis3XhRhpcd2/k2Cj
         x9YLJWC8XuFyN/JyffQtSBf2EyTZ9u8B+uzXtyCcyDGnWPNByRzy+ANtniXviAIG/Dav
         n7Xw==
X-Gm-Message-State: AOAM5337aD1Z9d7y8INGB87ox2P1CYxQtpBIIoJKdOIPZhoFl/J7OiB5
        eEevQEjOtXElWaasgZ1NZBfF4A==
X-Google-Smtp-Source: ABdhPJyfQSnwouxRVdXPtrJI1D17mvws8IaUEh7pE+T8DeNIXkEpBIHHleD4+rafpLBha5i4wBKHzQ==
X-Received: by 2002:a17:902:8d95:: with SMTP id v21mr24276699plo.108.1595368111361;
        Tue, 21 Jul 2020 14:48:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w71sm21629848pfd.6.2020.07.21.14.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 14:48:30 -0700 (PDT)
Date:   Tue, 21 Jul 2020 14:48:29 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [patch V4 12/15] x86/entry: Cleanup idtentry_entry/exit_user
Message-ID: <202007211448.A8AFA81@keescook>
References: <20200721105706.030914876@linutronix.de>
 <20200721110809.531305010@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721110809.531305010@linutronix.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 12:57:18PM +0200, Thomas Gleixner wrote:
> Cleanup the temporary defines and use irqentry_ instead of idtentry_.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
