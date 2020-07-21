Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E40228BA6
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731094AbgGUVs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728007AbgGUVs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 17:48:56 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E231C061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:48:56 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id t11so80909pfq.11
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DyUMSyCvKRYW4MD4ELntmNMKa8iS1Uqy8qtQ5GRD50Y=;
        b=RG0AVML5JPLKh1gC4Yp7oNCkx99dZ9fnFTUGOz8UovIZDJzKW32LdIVokMTsN0TvOy
         KbEUErep5CkAGc2tzZn3ShhRZXTvZsrPkKk+21w/wQKOCKCbuuEN7kcuWAq5HyOcgGPi
         itNKg5ZZrt8SDWM0tUVL5qj1/Yb7Cf/3K5j8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DyUMSyCvKRYW4MD4ELntmNMKa8iS1Uqy8qtQ5GRD50Y=;
        b=gxO4EM61waO/OWQD43V4Smw3FlCszsSXQGpNMgE47KlSF2wr9tCGS/g8YWWfUXD+A+
         emCT1sonSMSGEawHU15NMqjcAS2XWZx3ry+YbIaq+y1U3NiGNu4ilamB7SVnpEQlu8FP
         zAwHTGVPs06bfzKNsxCQl2UX8A5feG2Iv8IdA7Kq3rvcK6F6eqKBohxukywnjKGljn7t
         vAdekmO8X1nMJrgH5AZc8PCEZ6VC8JI5MmWUhtIYMt3byazkqmqHqInq0BQrCoJ3Hu5/
         j3vj2E4CUcPsrvSFIRkuRvqUeCjr9qmADZ7ybPsVq9Hy0OEBAu5E4XeK+t9vy7Iscj4U
         Pf2Q==
X-Gm-Message-State: AOAM5308U4PVZqS8bislc9phW4XlsEI5X6ijgBm6IIDqPWJceHhgPWGj
        glUU3/wnUXFuHIZiFxz73NUsXg==
X-Google-Smtp-Source: ABdhPJwevklT4e/5X1FPV+4eAjXjbwppCGlsYeJC9yecBh6vXjQodUdX5w6Z+6/rtIjc7fywF1XA8w==
X-Received: by 2002:a63:de4b:: with SMTP id y11mr24014742pgi.26.1595368135462;
        Tue, 21 Jul 2020 14:48:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 198sm21548925pfb.27.2020.07.21.14.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 14:48:54 -0700 (PDT)
Date:   Tue, 21 Jul 2020 14:48:53 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [patch V4 14/15] x86/entry: Cleanup idtentry_enter/exit
Message-ID: <202007211448.9BB6C2E8B5@keescook>
References: <20200721105706.030914876@linutronix.de>
 <20200721110809.747620036@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721110809.747620036@linutronix.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 12:57:20PM +0200, Thomas Gleixner wrote:
> Remove the temporary defines and fixup all references.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
