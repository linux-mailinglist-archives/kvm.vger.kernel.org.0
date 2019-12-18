Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A901255F1
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfLRV7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:59:06 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727403AbfLRV7F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 16:59:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576706343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xyRq0uSWZtoF1xSeEB8lICjPIcYYqv0mpEMiHQwYmsc=;
        b=ZobevB9evxz2RgIMe+dHIFnQWUUaXf9xhegU6owLqq3OdoVW8c4u7i36HIckZwYMGu3kj3
        aYE4x8QrTir48rqJIPhFhEIbwnKvAqnycAtvqnDMi2teXwYvw5P2Rkn30ZcD3/gxjCHhZf
        +eNCpTUn5fQD/QdVRSHHGa8LUob4kq0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-UhcNa1DlPkO9kp4QV6xL2Q-1; Wed, 18 Dec 2019 16:59:00 -0500
X-MC-Unique: UhcNa1DlPkO9kp4QV6xL2Q-1
Received: by mail-qv1-f71.google.com with SMTP id z12so2322213qvk.14
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 13:59:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xyRq0uSWZtoF1xSeEB8lICjPIcYYqv0mpEMiHQwYmsc=;
        b=hKsqFf4rhs9YV+WFxS/EzKqvbel3Z/I8IVVmiL893bSXsKSC+6KNeaOMGBk7J1oEUr
         VG4UyzaiR0fTbxoas2XCT2iZpOTIjycz+L2WVqvGzAgzxJq7nZbgiTO/LONSS559S5eu
         v5htAicpbQ2RwRMd8+qA4F/ZcGcDK4DHCShzaKd6glccWW4eu320niqkhhGGIdpkXFXm
         m47l+jIWF3GhNbo3vFfvsWW8F6yUZEOFcCyTJfaAR3IjRUPp//plakjBvNqOS4heH8+y
         TaELYUncQYAT2+XPFKaQZLYcXi4Ixc0KMinBRK51GuU0GKZh2lJ6jiYLDLZFHUlC40Oj
         2iZw==
X-Gm-Message-State: APjAAAUffGdE/Q3xYkg66bhQd/w+gHRxDHzVIY2mqyqGLnl4Cxh10C+/
        fJpYQvsQSU39mKt7GuoQhA3zHdRFBy69tSCBmnVOU0zyFY826cwR2REHEHoHu1aMgfNEZYB6iDD
        6rI0zKVFoFOua
X-Received: by 2002:a37:4905:: with SMTP id w5mr4969506qka.267.1576706340079;
        Wed, 18 Dec 2019 13:59:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqzVX8iG95niunFTpS5tBBbhXdu5Y9XJU2Owx29mSQ+hRkMsBGZvfhvamN55CSq/5e+E+hVhyg==
X-Received: by 2002:a37:4905:: with SMTP id w5mr4969484qka.267.1576706339769;
        Wed, 18 Dec 2019 13:58:59 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id e2sm1066715qkb.112.2019.12.18.13.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 13:58:58 -0800 (PST)
Date:   Wed, 18 Dec 2019 16:58:57 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191218215857.GE26669@xz-x1>
References: <20191209215400.GA3352@xz-x1>
 <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
 <20191210155259.GD3352@xz-x1>
 <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
 <20191215172124.GA83861@xz-x1>
 <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
 <20191216185454.GG83861@xz-x1>
 <815923d9-2d48-2915-4acb-97eb90996403@redhat.com>
 <20191217162405.GD7258@xz-x1>
 <c01d0732-2172-2573-8251-842e94da4cfc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c01d0732-2172-2573-8251-842e94da4cfc@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 05:28:54PM +0100, Paolo Bonzini wrote:
> On 17/12/19 17:24, Peter Xu wrote:
> >> No, please pass it all the way down to the [&] functions but not to
> >> kvm_write_guest_page.  Those should keep using vcpu->kvm.
> > Actually I even wanted to refactor these helpers.  I mean, we have two
> > sets of helpers now, kvm_[vcpu]_{read|write}*(), so one set is per-vm,
> > the other set is per-vcpu.  IIUC the only difference of these two are
> > whether we should consider ((vcpu)->arch.hflags & HF_SMM_MASK) or we
> > just write to address space zero always.
> 
> Right.
> 
> > Could we unify them into a
> > single set of helper (I'll just drop the *_vcpu_* helpers because it's
> > longer when write) but we always pass in vcpu* as the first parameter?
> > Then we add another parameter "vcpu_smm" to show whether we want to
> > consider the HF_SMM_MASK flag.
> 
> You'd have to check through all KVM implementations whether you always
> have the vCPU.  Also non-x86 doesn't have address spaces, and by the
> time you add ", true" or ", false" it's longer than the "_vcpu_" you
> have removed.  So, not a good idea in my opinion. :D

Well, now I've changed my mind. :) (considering that we still have
many places that will not have vcpu*...)

I can simply add that "vcpu_smm" parameter to kvm_vcpu_write_*()
without removing the kvm_write_*() helpers.  Then I'll be able to
convert most of the kvm_write_*() (or its family) callers to
kvm_vcpu_write*(..., vcpu_smm=false) calls where proper.

Would that be good?

-- 
Peter Xu

