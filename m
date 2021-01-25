Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35CC302C0D
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 20:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbhAYTym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 14:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732126AbhAYTy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 14:54:26 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256D4C061756
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 11:53:46 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id lw17so282925pjb.0
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 11:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UthBW/7aTeKJLkQ2gI2ILuvzKbz0dGSFoA74H4DgD7Y=;
        b=GZzwzP8DUYjfTXLWP/nUmiRbzFuoYgCUUa7CEV0bHsQnZ6fo3XVNbKEiqz74xF/RI2
         78oL5/yrKXKUetF3IaCfiyzdbySyPdbHJdUm1jnfjiiBhL8P4ATBORLSqwpBS70OttGE
         fExOoES24GlJeWAAed6RnLnN7gi7chTaxqvn0ckIf3y2SbrLDJW+OCLeEbynTCYxvc/w
         bNhpLLUzjldHOxitllIGRAR+4gxED3PfD48QnEHemekcceQ7Z3wKxgrJGQVugejPNdX1
         ci3O+CWL9IlDLbu4EpJLd1KmyPOVWzds2a3RkNsorfioivrZAr4Z7hbldhHR4dqW8k/D
         NdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UthBW/7aTeKJLkQ2gI2ILuvzKbz0dGSFoA74H4DgD7Y=;
        b=tKWr5Nd9l41TG3WxqehwRJoXygT3rKq4JeX1nbBLQym0L4NWdbba/F8rfsEEQcH9Yl
         DDzVKyGE4N2Rn4H0mSthX/THq5BUjCaT7QtVuhFKbuZ1LOEUflGC24uL2aUGIbTBz1+a
         U7ez4N7ci9OYhwAK4ZOlfVyoRy61Rpxil3cYTVoDqAK9vX1NBAY+iFTEEB8gBdL5yxid
         PrQP8dZmVvnA8HXvMViQMFr2Mya+z9rNHC+5y3Wkv9LwgZmU7Q5MbrNGJEIJ5mEAWpih
         5N908yWKUUtlDLRY3wfG35D3igxODutEga2YO3MORWHnbj0DrPiBqUWa48uLKuQkKBK+
         hbkg==
X-Gm-Message-State: AOAM533U3N+6/rn2N3obd96c7bRE75R3dJIilZjSUUdp8jn54c9x8MsO
        6eMapKcdu8ZDOJziaqDkcJvZnA==
X-Google-Smtp-Source: ABdhPJyDSLN/cq1I5pWOjFeRUOmc6e+1xThysV13+nq1I4sH4C2tZ4DvvdmGgxaME8f6BqeBE63udw==
X-Received: by 2002:a17:90a:e16:: with SMTP id v22mr1852642pje.73.1611604425437;
        Mon, 25 Jan 2021 11:53:45 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id j16sm181905pjj.18.2021.01.25.11.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 11:53:44 -0800 (PST)
Date:   Mon, 25 Jan 2021 11:53:38 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside
 guest mode for VMX
Message-ID: <YA8hwsL8SWzWEA0h@google.com>
References: <20210125172044.1360661-1-pbonzini@redhat.com>
 <YA8ZHrh9ca0lPJgk@google.com>
 <0b90c11b-0dce-60f3-c98d-3441b418e771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b90c11b-0dce-60f3-c98d-3441b418e771@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Paolo Bonzini wrote:
> On 25/01/21 20:16, Sean Christopherson wrote:
> > >   }
> > > +static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (!nested_get_evmcs_page(vcpu))
> > > +		return false;
> > > +
> > > +	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
> > > +		return false;
> > nested_get_evmcs_page() will get called twice in the common case of
> > is_guest_mode() == true.  I can't tell if that will ever be fatal, but it's
> > definitely weird.  Maybe this?
> > 
> > 	if (!is_guest_mode(vcpu))
> > 		return nested_get_evmcs_page(vcpu);
> > 
> > 	return nested_get_vmcs12_pages(vcpu);
> > 
> 
> I wouldn't say there is a common case;

Eh, I would argue that it is more common to do KVM_REQ_GET_NESTED_STATE_PAGES
with is_guest_mode() than it is with !is_guest_mode(), as the latter is valid if
and only if eVMCS is in use.  But, I think we're only vying for internet points. :-)

> however the idea was to remove the call to nested_get_evmcs_page from
> nested_get_vmcs12_pages, since that one is only needed after
> KVM_GET_NESTED_STATE and not during VMLAUNCH/VMRESUME.

I'm confused, this patch explicitly adds a call to nested_get_evmcs_page() in
nested_get_vmcs12_pages().
