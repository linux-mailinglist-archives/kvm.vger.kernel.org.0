Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2521D3577D0
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 00:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhDGWfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 18:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhDGWfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 18:35:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383EBC061761
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 15:35:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id o123so377492pfb.4
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 15:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4vbQHHhgTdpQg09dgRO5ENC5AWjcDhiv4AsueQCy78w=;
        b=MQz4ZPYXz5GRV4bjjQ4VE0JpXa6L1dl4NNEn5hmnf7a4Eid6b1Jr1d+K0DWJoZEdMD
         WylYIdtfuCcWfZ9iSYkMS/TQveZ6L6bEBmEzV+Py42QVlM9bxC4mgRG+tR51AsWCI3Gl
         7bn+f04HWqQut/3IFnnYLhVQjScO2gFVS97KDN7h7FzlKd053z3btGh/QeXCElfM/qbG
         hnJ+fxkvp4bHdqWLbnm/MTLLNbjsTqu+LJOERT8PdHDBviqGVcD4r/l9fRHP+P3e6Fd1
         Arcw3rEwLIwPtDSIDcjJdzcvH+x72BbSAeqNMtq7cu8e65H2s9rMaQI+2r7DBE2DdixK
         7v+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4vbQHHhgTdpQg09dgRO5ENC5AWjcDhiv4AsueQCy78w=;
        b=O7DcM4HnSb57KH1wZOlC/X57QHuKSPmVUJILgYe5bnrKkzES+AZY62b5PqmQOMAspO
         06Vkzku6qbDwp/52A3iC6r4XM57w3/CNjEH1R34RoUz6j2J2zQGtmt7wFBHON2p0ki/V
         BWvhBo33zlsMz2YjuJz4g5qPvP5qhOSBcu2V1a1aPLXTVtMKPJjIxBWxRES24b8M0GHv
         npOxJyIGDfZUTfBuzZIKJnVzxkbzJ6gw3rgL8jW827WOX8ttKrtgVPzkouQlQusKI9vG
         gVbIZi50tlAtCGcyGgiZkYFInYPXBcaMYTjwQBqyoWziRnIzQotKxv2w7OY29nSJlGgR
         Gccg==
X-Gm-Message-State: AOAM532ehHRz5QvfUx3aXmEaJ9aSgS3Y9fXU0ZauZjcn7vNvGaZSyXf+
        rIkcCXKJxwIWzGMml+uUZ0H12Q==
X-Google-Smtp-Source: ABdhPJww7JTbnMQ9lhZKv8Rpx8JvLihwqmdBqCBAQIzakHHZwKzIRRt7i1mXBOCqDa+Wbhi4VdDTrw==
X-Received: by 2002:a63:4547:: with SMTP id u7mr5311421pgk.351.1617834936664;
        Wed, 07 Apr 2021 15:35:36 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n73sm23450584pfd.196.2021.04.07.15.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 15:35:36 -0700 (PDT)
Date:   Wed, 7 Apr 2021 22:35:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 06/11] KVM: VMX: Frame in ENCLS handler for SGX
 virtualization
Message-ID: <YG4ztLkCZbJ2ffE+@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
 <4be4b49f63a6c66911683d0f093ca5ef0d3996d5.1617825858.git.kai.huang@intel.com>
 <YG4vWwwhr01vZGp6@google.com>
 <20210408103349.c98c3adc94efa66ca048ce2c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408103349.c98c3adc94efa66ca048ce2c@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Kai Huang wrote:
> On Wed, 7 Apr 2021 22:16:59 +0000 Sean Christopherson wrote:
> > On Thu, Apr 08, 2021, Kai Huang wrote:
> > > +int handle_encls(struct kvm_vcpu *vcpu)
> > > +{
> > > +	u32 leaf = (u32)vcpu->arch.regs[VCPU_REGS_RAX];
> > 
> > Please use kvm_rax_read(), I've been trying to discourage direct access to the
> > array.  Which is ironic because I'm 100% certain I'm to blame for this. :-)
> 
> Sure. But I think still, we should convert it to (u32) explicitly, so:
> 
> 	u32 leaf = (u32)kvm_rax_read(vcpu); 
> 
> ?

Ya, agreed, it helps document that it's deliberate.
