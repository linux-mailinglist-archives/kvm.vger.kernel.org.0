Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4964B2FDE21
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 01:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbhATX7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 18:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404148AbhATXZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 18:25:42 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FA0C061757
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 14:37:01 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id y12so3125423pji.1
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 14:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nnb1HscmHprX6eDoNs7+EUoL58EhHpBn3f+J0wJeSxI=;
        b=V+oR9OA+7oIoHFK1y1Ub6gN6wbhjvBFiDeCMXg/keTncTLPfyPDAaXIuVoxZY9y170
         U7hr8ZXYfmkpUPh02+rua4HoCf1e671K2pIXPNYEplnqklHR9Zig6Z/bgvVKhB9oIS7L
         AXdmJMlxmqUR+DhdJTWVc5dQ0zV239EB1MH7bnQx/IqMBMBUojqmL3ZXgkaX1DAReHHW
         9smZgr+ES6ydQT/UvHH1MY7s/nEGXVfI+2A2u9a0IJw3bcHKBMZOz93d84wkoFApKkA1
         /ltcriDoQ4U/oP+b/oOUm8G3u3ypN6aCTjt9+SozfsL1jLNbL1YfMFWhwAcTHRNIF8WN
         dE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nnb1HscmHprX6eDoNs7+EUoL58EhHpBn3f+J0wJeSxI=;
        b=EJhWz2cVy56UgCfL6RhxiUqc2kfp82WzRTHSAkxP2oHrHX7MwrIZL2CArsf9VVLtpM
         JsYYZ6y7ZRhw1/pKOJvoHFk598ePTAAWCRmVt/5yEmlmp3AI+HZwpWozZTPeUq0re4Qr
         DROMQfaEXJigxlnwerB3B8or+zfr6c1NtZs8aZsdUA0VLqOK28XKfi1hJJTiYjz5zZnC
         dlTb+yaX+vYhT5Y2ilskAewnqvZIMlYUp+hBRfHtA3gbyYJSafCLxDX/9ppafgT+vJqC
         zujE4FnVn8fF4crDNNKkf+SbzVZ0Vn2VEgHjIsvhJXizhc0UL7O0Y8g7EDEt3pGMiWsR
         PeMQ==
X-Gm-Message-State: AOAM531RmlgtYSKgE9HCO7xzbIZaj+O9JaBL6P+hKugoQgyPcxrp5vEv
        69slNoXdVDkxq6RapLxKG4bmkg==
X-Google-Smtp-Source: ABdhPJw4vW+xGvXPCHEr8cp+vI+tZ+8dmyhPDw+HoalXPpUxIHypQz6oR73f+fm1n+9IivE2IxKk2w==
X-Received: by 2002:a17:90a:7106:: with SMTP id h6mr8072746pjk.22.1611182221158;
        Wed, 20 Jan 2021 14:37:01 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 4sm3671634pjn.14.2021.01.20.14.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 14:37:00 -0800 (PST)
Date:   Wed, 20 Jan 2021 14:36:53 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [RFC PATCH v2 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-ID: <YAiwhdcOknqTJihk@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
 <a6c0b0d2632a6c603e68d9bdc81f564290ff04ad.1610935432.git.kai.huang@intel.com>
 <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021, Dave Hansen wrote:
> BTW, CONFIG_X86_SGX_VIRTUALIZATION is a pretty porky name.  Maybe just
> CONFIG_X86_SGX_VIRT?

Mmm, bacon.  I used the full "virtualization" to avoid any possible confusion
with virtual memory.  The existing sgx_get_epc_virt_addr() in particular gave me
pause.

I agree it's long and not consistent since other code in this series uses "virt".
My thinking was that most shortand versions, e.g. virt_epc, would be used only
in contexts that are already fairly obvious to be KVM/virtualization related,
whereas the porcine Kconfig would help establish that context.
