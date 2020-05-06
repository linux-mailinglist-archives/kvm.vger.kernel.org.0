Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CE81C78AD
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 19:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgEFRwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 13:52:11 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49677 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728047AbgEFRwL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 13:52:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588787530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PccgT4HcaWivoQJELX6s064gYPyC7GJ8hEzArxp6bSo=;
        b=O030j6FVTQFKVjU4FIp86y4Ea9RA3Jl3NIv4fOgMDghEvVgknKp2TYCE4VGqWRE4Yj+aci
        sNvKadbKN2RBGhTpWdqXlXKuYTBNO8jH5712rpixm9p+KPRktEDmcXydKhUdwh5crEASpS
        O5Wx5kwI7CxBm+a8B6X/RJblhvFsZ70=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-1uMCkUcHNWueU8d43yFagw-1; Wed, 06 May 2020 13:52:08 -0400
X-MC-Unique: 1uMCkUcHNWueU8d43yFagw-1
Received: by mail-qv1-f72.google.com with SMTP id w9so2912165qvs.22
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 10:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PccgT4HcaWivoQJELX6s064gYPyC7GJ8hEzArxp6bSo=;
        b=ly7x9WKCqrNIKVI8NuqKVxqp10kNSayXPpgWcXzRvz/4bTo5Ljqq9OgxxthPIfHTLT
         mOKJeT4OwIHchExKgbtnMCKSL50E4FjakLBl3kcq65FWVuXYIUn0oVZ9l4PEpoN9Htqb
         Xbgzt8VSZ9PTU3XxvzQ5WZSeborr2lT+Cb2sVlL3Xk7v6IRyBzU7PI4PCOegi4xCwDz6
         lc/twCuUA3hqwrTH58IaFn7T44tVz5IYowdMe9WIXm/rcczS4k43rpkNQHZJpjRT1VAa
         4YvOG95kRIDAr/SaRZ92G9cKaSurlL2KYMknoCiJHH3zGzHbbSzHgUqykohZM4KHnXEa
         fVyA==
X-Gm-Message-State: AGi0Pub2D8GLKaHFCpLh8V9XqTAlpSOnmT8DIj6vQ6xQkdpaWgg6+uyy
        0kmv3BZQ0z96D4GH9vbtwHD2dOuRVzoXQ24qWnd49h6fLS+TKQMRRLSdQhVWAJLoy2u+quXjes1
        ZPeK6cTd5sLVM
X-Received: by 2002:a0c:eb0e:: with SMTP id j14mr8833829qvp.230.1588787528177;
        Wed, 06 May 2020 10:52:08 -0700 (PDT)
X-Google-Smtp-Source: APiQypIEJqjL0kBwvh6GJDj8Y+OGS2ZJU8ac0dpoSTDogz807A439jh3hQqMmnsT0hI1Wj4xBIwqBw==
X-Received: by 2002:a0c:eb0e:: with SMTP id j14mr8833802qvp.230.1588787527914;
        Wed, 06 May 2020 10:52:07 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id k43sm2237118qtk.67.2020.05.06.10.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 10:52:07 -0700 (PDT)
Date:   Wed, 6 May 2020 13:52:06 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 7/9] KVM: x86: simplify dr6 accessors in kvm_x86_ops
Message-ID: <20200506175206.GQ6299@xz-x1>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-8-pbonzini@redhat.com>
 <20200506160623.GO6299@xz-x1>
 <2d44c75f-00df-3cae-31a8-982a0b95f0b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2d44c75f-00df-3cae-31a8-982a0b95f0b0@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 06:09:23PM +0200, Paolo Bonzini wrote:
> On 06/05/20 18:06, Peter Xu wrote:
> > On Wed, May 06, 2020 at 07:10:32AM -0400, Paolo Bonzini wrote:
> >> kvm_x86_ops.set_dr6 is only ever called with vcpu->arch.dr6 as the
> >> second argument, and for both SVM and VMX the VMCB value is kept
> >> synchronized with vcpu->arch.dr6 on #DB; we can therefore remove the
> >> read accessor.
> >>
> >> For the write accessor we can avoid the retpoline penalty on Intel
> >> by accepting a NULL value and just skipping the call in that case.
> >>
> >> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > (I think this patch and the previous one seem to be the same as the previous
> >  version.  Anyway...)
> 
> Yes, I placed them here because they are needed to solve the SVM bugs in
> patch 8.  Sorry for not adding your Reviewed-by.

That's not a problem to me. :) Instead I'm more afraid of not noticing some
trivial difference in the patch comparing to the last one.

Thanks,

-- 
Peter Xu

