Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAA83F0A0F
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 19:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhHRRPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 13:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhHRRPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 13:15:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1D5C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 10:15:16 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j187so2802607pfg.4
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 10:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gp5MQDOc8DOpdoJfov78aS5vkhhsZanfg4O8SWdKrOQ=;
        b=pJjHrEUuNzwqBOkYt/5z9tP8PVQCpTT2T+SBb+Vacjja6mrM7GjbQQPIr7+uwZyf6U
         qutTpTtpSLmxCICdZLSMJnUciFohYBZ6i2bgJExtUr1aQ/z/Vwlthoa7JpbhzxURhkD1
         a1XPceVR2ZTAwWwpvHj/5k1IrWjeQzhPgB75kkJjQsUblUYzzbXeODxAFilg3FScjEaH
         lpr24ulPAw4UyD714TaTJrvnBMf9Zq78smgJyHcOcR+d+ovOkIJ0chia1fKKrL7EbRg3
         cDqeTIYdWmR+zDaNkcszTsj4Z/OmwjEPnCoU/qg+bSxLd+nHo5F0MaItW+UBWc71qB1V
         e6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gp5MQDOc8DOpdoJfov78aS5vkhhsZanfg4O8SWdKrOQ=;
        b=T0r0qTAEpvAefEB19rinb7La8U9tgUE6n7piVczlT8a/+ckCp6XA2qLtrYtfydcbsF
         ++Qd+gUDL6727SiUHFiJdQQijVIhAlk2r+508y5dHkI0pRA4T7DjdDs+6kpE6BPNoTE1
         IgLEeMChJSj5VWs+83FFVdBmR5OMODeYAYW76TeOEdZ73iwlv98PS1ecfkaEJXI4gxNx
         pUghY7PUwqX+U4Nx7beKJm72a2ASaE3DbUr91cqkh6p0pyXfM6nlMyIXp0QsGx8482n9
         RtUF45itMwtPNFIvZ8WDNLLjPsqOscky2hp/VaZlDRTlHL1i5qyJTjZL1o+CKtRdZ+8r
         Ms7A==
X-Gm-Message-State: AOAM533E4F+yDykUANPI6vPEf1S/cXODpChOnYb+WSj2ipWnm3aMxgnK
        7Q73LFfijk3LybA7X9Rwg5PRKQ==
X-Google-Smtp-Source: ABdhPJz4j0LMjV3VzZ7ne7evfri/AHBXkGJEAQEA0I0rF/c9BPIbMdG7tU+A3YL5jbJVnKS+2FlYIg==
X-Received: by 2002:aa7:921a:0:b029:2cf:b55b:9d52 with SMTP id 26-20020aa7921a0000b02902cfb55b9d52mr10234698pfo.35.1629306915978;
        Wed, 18 Aug 2021 10:15:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t10sm5630629pji.30.2021.08.18.10.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:15:15 -0700 (PDT)
Date:   Wed, 18 Aug 2021 17:15:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v3 2/3] KVM: x86: Handle the case of 5-level shadow page
 table
Message-ID: <YR1AHVwUM8AS5JvQ@google.com>
References: <20210818165549.3771014-1-wei.huang2@amd.com>
 <20210818165549.3771014-3-wei.huang2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818165549.3771014-3-wei.huang2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The shortlog is very misleading.  KVM already supports 5-level paging for
traditional shadow paging.  This is specifically for shadowing nNPT, and it's
specifically for shadow everything _except_ 5-level nNPT.  Something like:

KVM: x86/mmu: Support shadowing nNPT when 5-level paging is enabled in host


On Wed, Aug 18, 2021, Wei Huang wrote:
> When the 5-level page table CPU flag is exposed, KVM code needs to handle
> this case by pointing mmu->root_hpa to a properly-constructed 5-level page
> table.

Similarly, this is wrong, or maybe just poorly worded.  This has nothing to do
with LA57 being exposed to the guest, it's purely the host using 5-level paging
and NPT being enabled and exposed to L1.
