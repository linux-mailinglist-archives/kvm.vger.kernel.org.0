Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC34444B8B
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 00:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhKCXXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 19:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhKCXXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 19:23:10 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33127C06127A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 16:20:33 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t7so3712359pgl.9
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 16:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/Y2S6Byxm0KbZa6sY2deNa9Jl5FKstAIjXV9nN4iMDk=;
        b=K91RCxho56MVM9xkrEB3UKg+BWwwhcaLoHcPld8X+H1nqOstvWhabsJWdT86MzZbv7
         oYqZLQrjvkH849hAVJZ2gX3z3qYj2UdkVjRVOf1PONjBt7BAw7bdI0IrQpUMqG5E28bI
         2RjSQz8jt3phmu+OmeOnD8nIfgVc49b+0LoH9Vt+G7hZcEtEy7RR4CdCEeJtS6Nocs9H
         MpO5GOPe8STy5QY0RmZA0cv4M9SiZF6+TN2V4hmGqbop68oXQXRFwvXRPh49V8XG8wJS
         v9pqQ0qAZzxQfuN0eUwHeY91rh3DFXDFHHpyOgj10UE+5p3SwIqfQ5tns06PgJzkoTk/
         cm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/Y2S6Byxm0KbZa6sY2deNa9Jl5FKstAIjXV9nN4iMDk=;
        b=Mg57vawbXqW1MaoK7oSaEUepNhsin6cqh/aRKUkvymcqWnlxZgs3JFr9xfm3Fzc3wk
         f1wB7PQ6Ke00zfZfLMQrdwxSsccFNGtlHF9DECMxENNjjoFFey7sDqNsICdxQqYB7uHv
         aKV3Uff0LccyqdZqZ0XteXLz5RCmreLQrxu2GwEY+9cqMO0RTNs/uwXlc7WuTIHKYj4M
         23Cha28454YlwWS9Ytb2MD7z0mdLk4gSTh1DDfO14jGGtti4dgPCLU6iowsf6wn1ZsON
         Q0lyuD9JHFzOJhL8EymMMOCv9ySaFw4DyGdg4d3SYwODO1vpamu7mGzx1GpZ9aKhUVPD
         iodQ==
X-Gm-Message-State: AOAM533FT82104uECmLdZtgVapxicN2FPrf/bcBBY00TgIhIa/cRZYIO
        TVG5nRq5xah+Cvnw7d5wVa2A8w==
X-Google-Smtp-Source: ABdhPJy4brD18aSZ3rwkyQEyhmNvGSzOxarylF5FcaeQ9OUCRHAS0uELEun5xfh8MoMWYe+r+G6K0A==
X-Received: by 2002:a65:5082:: with SMTP id r2mr35784039pgp.353.1635981632525;
        Wed, 03 Nov 2021 16:20:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n20sm2682378pgc.10.2021.11.03.16.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 16:20:32 -0700 (PDT)
Date:   Wed, 3 Nov 2021 23:20:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: Move INVPCID type check from vmx and svm to
 the common kvm_handle_invpcid()
Message-ID: <YYMZPKPkk5dVJ6nZ@google.com>
References: <20211103205911.1253463-1-vipinsh@google.com>
 <20211103205911.1253463-3-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103205911.1253463-3-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Vipin Sharma wrote:
> Handle #GP on INVPCID due to an invalid type in the common switch
> statement instead of relying on the callers (VMX and SVM) to manually
> validate the type.
> 
> Unlike INVVPID and INVEPT, INVPCID is not explicitly documented to check
> the type before reading the operand from memory, so deferring the
> type validity check until after that point is architecturally allowed.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---

For future reference, a R-b that comes with qualifiers can be carried so long as
the issues raised by the reviewer are addressed.  Obviously it can be somewhat
subjective, but common sense usually goes a long ways, and most reviewers won't
be too grumpy about mistakes so long as you had good intentions and remedy any
mistakes.  And if you're in doubt, you can always add a blurb in the cover letter
or ignored part of the patch to explicitly confirm that it was ok to add the tag,
e.g. "Sean, I added your Reviewed-by in patch 02 after fixing the changelog, let
me know if that's not what you intended".

Thanks!

Reviewed-by: Sean Christopherson <seanjc@google.com>
