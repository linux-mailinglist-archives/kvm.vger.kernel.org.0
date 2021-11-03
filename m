Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0248444947
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 21:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhKCUCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 16:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhKCUCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 16:02:47 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B07C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 13:00:10 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h74so3551499pfe.0
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 13:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KsEvoPiFtl6bqNouQ+fGJ/sS+WphUQOBaAHxMhk3DGA=;
        b=YrJyFwWp4grOY1mPXnQnE+Hg0CdtJ9GnY15cK8Z+OkAURPeGDQU9vhCR3iWinmvMxu
         eircPif344srajRe1A7ME4omZYYSKP6lb2gpcbGF/fNpmsEYia772dhvYgiSkWHr2nNp
         1uIv2yYv7LiawmDTAeTFGEor+MbVXu9FPGqS0TysHRSYA/nZsV+MtC/D4IWZ/eUZzT5b
         e0cilCc559JgOeQuEGuBNUYx/f5GjZ5fEbgpZKWBmB3A4aw9m/idmSvzXlB75bzjmjEW
         2akZacI0oiOu+xg/hTDuJlLl4diKlqhZ0iWowZ+6tTMpPiEH6PAJ1nnTkvG7nrkvMQsU
         Yrkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KsEvoPiFtl6bqNouQ+fGJ/sS+WphUQOBaAHxMhk3DGA=;
        b=QW3EMfqD8Dbc92m/zEr+29e60E1e3nfmgIqFDVdOvV8e6UDElZW8RL3My6qarop+SM
         PsVxThQyuQWo8h89qn9qlE0qWNGLCSKV40FVWsMAB9pxP8d0dyv6BkgmH3cVHsOOLfg6
         HyCCUq5FhBnjl272kjJ3PmK2ywL9BCdJPIgmeb5TV347jvqMWu8ajLzRURwwa9cvSoZ+
         jaEvUYbU1eYX9eliKoT+2yKfeGDW4+R/BALz+Wb/yY0zt8Y2uzflFWm+n6lRzAGfW2qv
         C3nSwnc08kUxYURCJQh3TxNWzE4Z+bkN7Dm/MEKwRLtIiRJUhs2OPywiRnLV0u9iOuJ8
         MeJg==
X-Gm-Message-State: AOAM533+GLu1cbI7pCEtWHH69c44BtHeVG5l/0mjJK7X7Jj1af2VWwE2
        agOo+1KKXHKa27O0ST89eBmBBQ==
X-Google-Smtp-Source: ABdhPJwBiTa8ecNTn5rCGLRr0uGC3m4OVyK7YALZosFLuZqUjO7nFr2X1bzBQDcNmWw0mlHEb/TsNA==
X-Received: by 2002:a65:62d1:: with SMTP id m17mr35112758pgv.370.1635969610032;
        Wed, 03 Nov 2021 13:00:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y9sm5801708pjt.27.2021.11.03.13.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:00:09 -0700 (PDT)
Date:   Wed, 3 Nov 2021 20:00:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: Move INVPCID type check from vmx and svm to
 the common kvm_handle_invpcid()
Message-ID: <YYLqRRfaiXrWo7Yz@google.com>
References: <20211103183232.1213761-1-vipinsh@google.com>
 <20211103183232.1213761-3-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103183232.1213761-3-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Vipin Sharma wrote:
> This check will be done in switch statement of kvm_handle_invpcid(),

Please make the changelog a stand on its own, i.e. don't rely on the shortlog
for context.

> used by both VMX and SVM. It also removes (type > 3) check.

Use imperative mood, i.e. state what you're doing as a "command", don't refer to
the patch from a third-person point of view.

The changelog also needs to call out that, unlike INVVPID and INVEPT, INVPCID is
not explicitly documented as checking the "type" before reading the operand from
memory.  I.e. there's a subtle, undocumented functional change in this patch.

Something like:

  Handle #GP on INVCPID due to an invalid type in the common switch statement
  instead of relying on callers to manually verify the type is valid.  Unlike
  INVVPID and INVPET, INVPCID is not explicitly documented as checking the type
  before reading the operand from memory, so deferring the type validity check
  until after that point is architecturally allowed.

For the code:

Reviewed-by: Sean Christopherson <seanjc@google.com>
