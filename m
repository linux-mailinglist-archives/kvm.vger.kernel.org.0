Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8ED3C763B
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 20:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhGMSMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 14:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhGMSMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 14:12:40 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3D1C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 11:09:49 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 17so20403802pfz.4
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V47yu06/iR+MR1LdevW/eIh+AExnfozREwXCPHG1mek=;
        b=gBhIkTI75csEbUPQYWde2Lszr15fjEGkGGglSwWYD4AW9RHwTvnHrxaXGq06hOOZKD
         8ltaOHTo4j9SUSetJE6vgbqOSvUU7ntx9945F2C4zB1DgOfrXR7mLU+cGL9RGHAPreQR
         iVzIbfy1tmMlsyC8UTyFoMdOeUCenSmK/O6P3rFQEjrw3aLhG0I08jy53X8s3L2G9mln
         LdfT19mNbgxRCi4w38mA4hvlZ/9NgDs0R9HRcCGMwc9ENAi/Y7uZKcdIsi6o3T+W0VL1
         nmjldoM7X7exMP1eS8gDpw7f/p+8R2CiUHXPq6LYFkwVhyFcvLSn0AG3Wcce444kuk67
         K8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V47yu06/iR+MR1LdevW/eIh+AExnfozREwXCPHG1mek=;
        b=rJWf5Nqp2tNtqehNSnZGCQmdIqDy/TUEt58awbclJDF7krW6PQDIoh4SMZFgJchAsL
         47u2h3ksRc23UuFqIjlrbIbVLVg+h38iMfvONPbH+M18yZzCD3oH2sCQDCzfXBco5WWM
         ZoYhyqaNbmLeQhLdUoCNt0HWJdEogtIn2Y473FN1yGSiMuuU7f65l2Rd4zOrrFt62emW
         JNlOBjd2BXufViGdHw/nyRYju3S4v50WvOJNnm/ZvT+X1J/enJoaiL3vkM/rXY7SZc3t
         r7bEMwzerjgDXwXklsYv0aYH+uIuANba0EdEkLMvZGO04e9cc4dUTm3Je0IHsNxFh5ao
         5JIQ==
X-Gm-Message-State: AOAM53013lHyAyknAndAgTB+pNLwMFpZVaWy/rBUZ8RqN3Bli0/nm7j2
        wjcy9bUo0Lg3UtloaN1FJ8POag==
X-Google-Smtp-Source: ABdhPJyPOn/LVGwVkQk5rBg7DQvrRolzOydk4EW1+OOWekyxZRoqLRH8vgNIJYxJcGa3xKlBE9HaTQ==
X-Received: by 2002:a05:6a00:189e:b029:32b:9f66:dcbb with SMTP id x30-20020a056a00189eb029032b9f66dcbbmr5970729pfh.72.1626199789061;
        Tue, 13 Jul 2021 11:09:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y187sm16754074pfb.185.2021.07.13.11.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 11:09:48 -0700 (PDT)
Date:   Tue, 13 Jul 2021 18:09:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v2 65/69] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
Message-ID: <YO3W6F899krWeOUT@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <5f87f0b888555b52041a0fe32280adee0d563e63.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f87f0b888555b52041a0fe32280adee0d563e63.1625186503.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit on the shortlog (applies to other patches too): please use "x86", not "X86".

Thanks!
