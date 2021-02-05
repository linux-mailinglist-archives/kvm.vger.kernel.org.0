Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B703101AB
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 01:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhBEAda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhBEAd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:33:29 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC91C0613D6
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:32:49 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id e12so2669155pls.4
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vDEOY4Vbf4R0aovFTXVuQ+DgXPwrnh3cvJl5pcgb3Ko=;
        b=PvzlC9YzCKy0vArIdosgNCXIKfs8KXu9hpZ6TrrYP8tNa08G9Zn8ePBlZclTX6nxST
         S0PAn640oF84QFYfq7MQkqZgYDqBtvlWa1GzMUL9GAZqRITorGEHh4TTYcUcdRUwUjd6
         rXK14Qd66+foqQpaF4e4bsTBgsrtWAAwv03cxIIALcVLpmW5egv1kp/tNnjGHWtHDCNL
         jQ6U+vZCM2RhLMN/azVFWw18UI9E4iAvkCvzJSDCFIKAJIBxPrVEEhgOKMChqQJ35Ndq
         0lHWXEJpiCyvnf0slTPpsCP7dmGEV2AwtbD9a1yZhE7vdqRRsr/AtdDBSRTXyLl29b4A
         vMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vDEOY4Vbf4R0aovFTXVuQ+DgXPwrnh3cvJl5pcgb3Ko=;
        b=tHTEUWjT0lK8dXj//vC3MscgcbjUoifnUnlACA4+v+8WKVow7lFfuYcpfzud1ffVHX
         eEf9+BITGdMm5tLRposYTCIOoFdDQkMsBSDo6Uh4YYT8rEG2XanWhfAgi2caP5MkBAqC
         nKzRilC5bmUThREtzgoIehXHC2Gc+nnHgEosSerV2Zpx8JgKqqCYcCl2YTfNnUwj9whb
         ZDe1+M5YcvfKFsvM9G5W3ra8gSCxA4Ose6ePtfw1Q2HK/bD/ED4a6jaTJAMaYJPc2kkj
         VaN3RVJ6afdd702Fq8khFzvJ6tll64ArM+SPbuTZ7DjV5R+SSMPE4Z9R+qdIQWBAbMqd
         eaUA==
X-Gm-Message-State: AOAM533sNERvDlZmqUknwZGV6v5pVbqC6J2ihk4LzrxAUnqMIJv7GyMO
        ahy7+Wv5XvCZmTtYImFEgVSS5Q==
X-Google-Smtp-Source: ABdhPJxaCKPgfVNA7QmsfmupD54CFqXRN+r2LbFlxEUP0zOpEWdnbEVKC5QrywoJx3Mzn7JFN8EjzQ==
X-Received: by 2002:a17:902:47:b029:de:c58e:8257 with SMTP id 65-20020a1709020047b02900dec58e8257mr1548965pla.61.1612485168670;
        Thu, 04 Feb 2021 16:32:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
        by smtp.gmail.com with ESMTPSA id n15sm7908683pgl.31.2021.02.04.16.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 16:32:48 -0800 (PST)
Date:   Thu, 4 Feb 2021 16:32:41 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        jarkko@kernel.org, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 14/27] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <YBySKakwHCgOSQow@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <e807033e3d56ede1177d7a1af34477678bfbfff9.1611634586.git.kai.huang@intel.com>
 <d20976b25943c34ecfc970ebcb6f282c69a3dd43.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d20976b25943c34ecfc970ebcb6f282c69a3dd43.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Kai Huang wrote:
> Hi Sean,
> 
> Do you think is it reasonable to move this patch to KVM? sgx_virt_ecreate() can be
> merged to handle ECREATE patch, and sgx_virt_einit() can be merged to handle EINIT
> patch. W/o the context of that two patches, it doesn't makes too much sense to have
> them standalone under x86 here I think. And nobody except KVM will use them.

Short answer, no.  To do that, nearly all of arch/x86/kernel/cpu/sgx/encls.h
would need to be exposed via asm/sgx.h.  The macro insanity and fault/error code
shenanigans really should be kept as private crud in SGX.  That's the primary
motivation for putting these in sgx/virt.c instead of KVM, my changelog just did
a really poor job of explaining that.
