Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFE730CF24
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 23:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhBBWgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 17:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbhBBWeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 17:34:25 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24794C06174A
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 14:33:43 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u11so13302285plg.13
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 14:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6H4XfHqW3HG9z7ezVHnYakV7OIlHGdY2zaIRE+3MY+o=;
        b=IrucQmt/MRh0ZX1a7l/dpjLM328BUP4vgrAY1XPU7W4oCjaUlnd5N4UEtOiYdh2GH2
         u0IjVqkz6Vt/HXof7/bjy/f7IXOCkNfa29QCXSjb0WaRafKgWE3PNkixLzJPkHg39Kh4
         bjRo0hee0l8dLCfkw0O9XqDow31NjBFBdioYGyLQKC+/ppciVjseT/naA5gNaXZRsQQe
         d4xx18ROJaYyTOqG3aYlSeQexYc9q1oxhPS9rKy1t14S+Vt02BesztP4znlnbqEjL+oT
         d487LUnDDFE3sMmBxrCeHNlML3w+uzC82bi0PvMAxA5jUWmkUeaiTPxQhx61uk1e3pUU
         fo0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6H4XfHqW3HG9z7ezVHnYakV7OIlHGdY2zaIRE+3MY+o=;
        b=eDCBtcDwWS/z/YSMYx2qpOCAzmmAbwnPKQgaQPakwA3pcJzden4bZYVLumlwE6/Qwm
         pz9m12ckgt71TClA02jcYJF3IFe8BXkChwyXelzcVnOrZguOp+SEPiQHI+HmcMXkT7lz
         PxD7pka2chdJDqpL2C6TcNyE4jx+d14GkqPn4DtBTZPqSaVSXgiUdlIuGFLdKfM39MBh
         Ey2EigfioFySAdnmJqGvyOgGjIl11Q2hgBqZKuZyeVnlR/lgut1tznSnbYrvtBUnvnbL
         VcfKLzJl0v+VRHr/Drgjq8jtnVaXseygh8cw8wHLIFAmW4STJwRMMQ2E5sovtzy9i+y2
         HDEg==
X-Gm-Message-State: AOAM532ZjD+uUeidQ9tscVn6+gcaxGlcnTpODbtqmolAVtw7BJzuixwC
        B7848wFYu8wKPgkRd1UcxIqK7Q==
X-Google-Smtp-Source: ABdhPJy0kLjiIZNkp8Jipm+TYTfwVuWB947W5dmhFbW8IF0X331oHfI0YHK+BEVr3JRRstmxmqOlVg==
X-Received: by 2002:a17:902:ce89:b029:df:c98f:430d with SMTP id f9-20020a170902ce89b02900dfc98f430dmr219006plg.18.1612305222543;
        Tue, 02 Feb 2021 14:33:42 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id h3sm6578pgm.67.2021.02.02.14.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 14:33:41 -0800 (PST)
Date:   Tue, 2 Feb 2021 14:33:34 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
Message-ID: <YBnTPmbPCAUS6XNl@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <4b4b9ed1d7756e8bccf548fc41d05c7dd8367b33.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b4b9ed1d7756e8bccf548fc41d05c7dd8367b33.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021, Edgecombe, Rick P wrote:
> On Tue, 2021-01-26 at 23:10 +1300, Kai Huang wrote:
> > This series adds KVM SGX virtualization support. The first 15 patches
> > starting
> > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX
> > core/driver to
> > support KVM SGX virtualization, while the rest are patches to KVM
> > subsystem.
> 
> Do we need to restrict normal KVM host kernel access to EPC (i.e. via
> __kvm_map_gfn() and friends)? As best I can tell the exact behavior of
> this kind of access is undefined. The concern would be if any HW ever
> treated it as an error, the guest could subject the host kernel to it.
> Is it worth a check in those?

I don't think so.  The SDM does state that the exact behavior is uArch specific,
but it also explicitly states that the access will be altered, which IMO doesn't
leave any wiggle room for a future CPU to fault instead of using some form of
abort semantics.

  Attempts to execute, read, or write to linear addresses mapped to EPC pages
  when not inside an enclave will result in the processor altering the access to
  preserve the confidentiality and integrity of the enclave. The exact behavior
  may be different between implementations.
