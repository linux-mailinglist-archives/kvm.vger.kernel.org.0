Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAF83577EF
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 00:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhDGWr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 18:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhDGWrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 18:47:23 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FF4C061760
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 15:47:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o18so86124pjs.4
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 15:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xLY4ETfXUfzviUwYMJ5Ii7Qn7JIbLfTSlfhpfQ2LYXQ=;
        b=FRyMaiYqJvtWAXADFCM4COCP9Yxjp/YPP3Bj3TeR4l+OjWE0H1LOz31G+3eKq+bEoR
         rqi1CK13hPZEjAUs8J5Nk6rM7zpTPU2SjA1xpnj8S2w/6Vy/LJ50gkNkKb4Eaaa3CowS
         7LXEc7r8SFWKsnvZSJe3+xVL95bI4Z19yxMGl8c5AWZMWxRZQ0jyW4e6Y41h068hwS+l
         VBOloFRwJ29GqVEPVdPqHEXLP1f0YkSPHXNbJVl9Ujf0r2JdYNuSaeSH/BWohjGsrecI
         4WBnNvLAZHxEMqXU91xj83UMbq2sOPIGC35HJe/P+JeaW8hheXI/gtF+m9e+OBaTDn8F
         y4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xLY4ETfXUfzviUwYMJ5Ii7Qn7JIbLfTSlfhpfQ2LYXQ=;
        b=cueypRhD3DC/udFSm39alrQHXF/7vVgOI5UAwvtRGSkQL56YkWX0WBxl0ID0rylUjO
         +kbGFZj0yvjcD49AM870U//8dNMVDlbIKN/RX1SQ1DVlwvGgAMJ7MojqJlTQ/+cMiqPF
         bc4iZsvH4RVU7OnDJFc8Hwiq7xCj2d2/ub+rFBadPISYWPiKw0m29KWT3mBVZzYWdg+w
         4XFdqGRxbpOUbPzZyZ/v190zejk+c1N9NpSrYzk0vz6UL0frMEzv9wIoy92vnN7wi4oy
         W2/611B9hVeRzhNXDANtuGVb9f1iGpuT/vhVHAN2YN+pf97vuVkXpSV8falQDYa37eGl
         pI+g==
X-Gm-Message-State: AOAM533RqbV56xNLsJxofnYVZkk4Rn17TawSEe7Ck5M9GQJGAiuTUtGx
        m7MGgfX1hz/QR8M1eY/oxu8gXg==
X-Google-Smtp-Source: ABdhPJxiM6l8JJD1iiWVdQaKF9O0mpr5ZSyuMUcAEG9o9OI4hcNfH1tWH1mUk2EGFVD+nevHMs+wbw==
X-Received: by 2002:a17:90b:1b46:: with SMTP id nv6mr5472535pjb.45.1617835631467;
        Wed, 07 Apr 2021 15:47:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id g28sm22442721pfr.120.2021.04.07.15.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 15:47:10 -0700 (PDT)
Date:   Wed, 7 Apr 2021 22:47:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 06/11] KVM: VMX: Frame in ENCLS handler for SGX
 virtualization
Message-ID: <YG42a4to8ecl+m6v@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
 <4be4b49f63a6c66911683d0f093ca5ef0d3996d5.1617825858.git.kai.huang@intel.com>
 <YG4vWwwhr01vZGp6@google.com>
 <20210408103349.c98c3adc94efa66ca048ce2c@intel.com>
 <YG4ztLkCZbJ2ffE+@google.com>
 <20210408104414.29e93147fdd93305846a6ee6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408104414.29e93147fdd93305846a6ee6@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Kai Huang wrote:
> On Wed, 7 Apr 2021 22:35:32 +0000 Sean Christopherson wrote:
> > On Thu, Apr 08, 2021, Kai Huang wrote:
> > > On Wed, 7 Apr 2021 22:16:59 +0000 Sean Christopherson wrote:
> > > > On Thu, Apr 08, 2021, Kai Huang wrote:
> > > > > +int handle_encls(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	u32 leaf = (u32)vcpu->arch.regs[VCPU_REGS_RAX];
> > > > 
> > > > Please use kvm_rax_read(), I've been trying to discourage direct access to the
> > > > array.  Which is ironic because I'm 100% certain I'm to blame for this. :-)
> > > 
> > > Sure. But I think still, we should convert it to (u32) explicitly, so:
> > > 
> > > 	u32 leaf = (u32)kvm_rax_read(vcpu); 
> > > 
> > > ?
> > 
> > Ya, agreed, it helps document that it's deliberate.
> 
> Do you have any other comments regarding to other patches? If no I can send
> another version rather quickly :)

Nope, nothing at this time.  Though I'd give folks a few days to review before
sending the next version, I don't think any of my feedback will affect other
reviews.
