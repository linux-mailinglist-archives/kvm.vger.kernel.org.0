Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705BF2F87DA
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 22:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbhAOVqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 16:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbhAOVqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 16:46:09 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75E5C0613D3
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 13:45:29 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x12so5368167plr.10
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 13:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hzzLLYuHlE1RIpqji10CEgKc8nDFjj0vX/XKdaAYg0w=;
        b=g84/BeGiiIa+Su2X4Lo8OUgYNd06EYV8T1bjPZMUKWmtiE0tClQiKQwJt7/RutdI/H
         9FyhG82ZSHIfXW52A+kf++N7IwfY/Zf3sbkb404AmxA9+8Pfb7V+o4fZBxDOHbP5h3YW
         xwNHhcFvx+dwLgdoWK4puo8LD0ZTERiuvUVoVAE+YCg8obxcwaO6rsB9f3kHaCmKn3su
         WqDTZOfuNx+dryQ7W5IBf8rauQ2lDo6lwifaGbQd6BJ7ARjnpWVz5TnE3rs4xFYd3Nge
         qe+r6jkGPbR+QU/Z9mXf1RROg80jN0XH5Ki2Gb++B0E3D3MhiRlnbIStrqx+ao6a2xoo
         ofBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hzzLLYuHlE1RIpqji10CEgKc8nDFjj0vX/XKdaAYg0w=;
        b=hyzUH8i8TMjYPBdh1k4BL6pumSbkc6aag3/TV6E8pqbpGfnpE5OqFSAbJajKAAB98H
         lsBdOjR7WGin39qCElOVAHZs84zbHIIQpy6E8CSu3j+2KS5/UlwqV0UpRdVOYHZUBzmi
         hqRTx3vE+SBTN4bYtqesfxjd/lCd9WtIw/4oCZXAVA65V/0/L8AtrN19JJa+01TNHo8V
         EDKT5pZHUI+Jff6iQ/T92kCs3O96y0uGc2PIEAVc/pv5Y2eoSjPRSbGgk4UAP3f2tPUg
         R7H0AkILCBuX/nolmKiSUVpGM+Uc+DkllD5LxU1GqZDjK9qjqGn6uHqJ6UxAIJdJa6zV
         Hxlw==
X-Gm-Message-State: AOAM531L/F29yC2PMI/pY2LvWm4mbLvNxz8WS3OMc9kh4Ebd+K/QEIaK
        f5kEyVWXCk25pB0lgi/Et98Aiw==
X-Google-Smtp-Source: ABdhPJyk7X2vxNBLqDHLSw5GcSGiw6Om/q0/nzVMkhNVL7YIad5y6jaQ+s5Osi0hZMktBxKnvsg6Tg==
X-Received: by 2002:a17:90a:fb92:: with SMTP id cp18mr12454919pjb.203.1610747129138;
        Fri, 15 Jan 2021 13:45:29 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 32sm9323644pgq.80.2021.01.15.13.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 13:45:28 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:45:21 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-ID: <YAIM8cRtW3Jn6FRD@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
 <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
 <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
 <20210107144203.589d4b2a7a2d2b53c4af7560@intel.com>
 <bd0ff2d8-3425-2f69-5fa7-8da701d55e42@intel.com>
 <20210116030713.276e48c023330172cded174c@intel.com>
 <af302572-96ae-66f5-4922-ef4a8879907f@intel.com>
 <20210116103339.0e36349cbde63ee8beba03e4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116103339.0e36349cbde63ee8beba03e4@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 16, 2021, Kai Huang wrote:
> On Fri, 15 Jan 2021 07:39:44 -0800 Dave Hansen wrote:
> > On 1/15/21 6:07 AM, Kai Huang wrote:
> > >>From virtual EPC's perspective, if we don't force this in kernel, then
> > > *theoretically*, userspace can use fork() to make multiple VMs map to the
> > > same physical EPC, which will potentially cause enclaves in all VMs to behave
> > > abnormally. So to me, from this perspective, it's better to enforce in kernel
> > > so that only first VM can use this virtual EPC instance, because EPC by
> > > architectural design cannot be shared.
> > > 
> > > But as Sean said, KVM doesn't support VM across multiple mm structs. And if I
> > > read code correctly, KVM doesn't support userspace to use fork() to create new
> > > VM. For instance, when creating VM, KVM grabs current->mm and keeps it in
> > > 'struct kvm' for bookkeeping, and kvm_vcpu_ioctl() and kvm_device_ioctl() will
> > > refuse to work if kvm->mm doesn't equal to current->mm. So in practice, I
> > > believe w/o enforcing this in kernel, we should also have no problem here.
> > > 
> > > Sean, please correct me if I am wrong.
> > > 
> > > Dave, if above stands, do you think it is reasonable to keep current->mm in
> > > epc->mm and enforce in sgx_virt_epc_mmap()?
> > 
> > Everything you wrote above tells me the kernel should not be enforcing
> > the behavior.  You basically said that it's only a theoretical problem,
> > and old if someone goes and does something with KVM that's nobody can do
> > today.
> > 
> > You've 100% convinced me that having the kernel enforce this is
> > *un*reasonable.
> 
> Sean, I'll remove epc->mm, unless I see your further objection.

It's probably ok.  I guess worst case scenario, to avoid the mm tracking
nightmare for oversubscription, you could prevent attaching KVM to a virtual EPC
if there is already a mm associated with the EPC, or if there are already EPC
pages "in" the virt EPC.
