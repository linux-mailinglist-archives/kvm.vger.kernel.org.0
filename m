Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BAE12197B
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 19:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfLPSzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 13:55:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23333 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726454AbfLPSy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 13:54:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576522499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NhNCILKQC2H9fPsP601CjhPIiTCmYV9tPKtKDaQC5bE=;
        b=X4HPD3H9afV4l5pws1D9q7vIydZBCBk9JTkJXmvTExHd39TXYry7V/cotGqrJgRrQSMbSb
        zv4ZP8fv/PtfHQ94Nr0voKq72A6pdzC0io45PZQmc649rQaVfB/SPWQ5w6+uQ42oeFbe76
        cB+JBzYspzSW4USoQYNLfMHu9Pcg+cc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-XoE5RUtnPmu0yWy2vdQ82A-1; Mon, 16 Dec 2019 13:54:58 -0500
X-MC-Unique: XoE5RUtnPmu0yWy2vdQ82A-1
Received: by mail-qv1-f72.google.com with SMTP id e14so1563805qvr.6
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 10:54:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NhNCILKQC2H9fPsP601CjhPIiTCmYV9tPKtKDaQC5bE=;
        b=e8SsSNUQf9XCEOCP6dMCEEEIaw875uFTauNLHnLJmMC34/QZ7CkkxcGPvck0PT8+t/
         baWXahcMpqrI5N9j+sMsSYjVyvkmMeo+sKZop+Fmf/Xsy6e2luGKSBa2g/VPr2f3sGqd
         lomiAvTKq5i3j2JaKoJD6w9JBbVPgBjITDGSZOVtZfZNR7viJDoN/b1CdvWuQqSZAbaz
         wafIiywivhKqlyR5nB4aOa9l9uW6vXFVJ0gVm0x8T99ScMs4dy2SCMBmpn3WvEdFB5cL
         W+cATRUIjKoQwDYWOwwnZMPerDxl++XnvjDYC7BTEwFaD6oNI1chJ/n/+xdQJzOxW/Xr
         +yZA==
X-Gm-Message-State: APjAAAVZbp38fxibEEr/8dAtoPgKRpQ2GqkzQLQgzC1ElNCgzXSPm5Zj
        OOqQt/QVA/oKdnktWoPtoNYXTo0pJ89CTSz5KPxbicBjEUpuWp1T7two+syRvpu0/39M42+eNzJ
        99ca/GsmYDBTf
X-Received: by 2002:a37:7005:: with SMTP id l5mr799923qkc.334.1576522497088;
        Mon, 16 Dec 2019 10:54:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqyH0oFJ6c/tHu5L8t62L3+lM4YKWvmKqoFPMrWv4pPK2XFRQ3+IEt11Cj64BFmXY9R+r9srzg==
X-Received: by 2002:a37:7005:: with SMTP id l5mr799900qkc.334.1576522496747;
        Mon, 16 Dec 2019 10:54:56 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id v4sm2170135qtd.24.2019.12.16.10.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 10:54:55 -0800 (PST)
Date:   Mon, 16 Dec 2019 13:54:54 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191216185454.GG83861@xz-x1>
References: <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
 <20191209215400.GA3352@xz-x1>
 <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
 <20191210155259.GD3352@xz-x1>
 <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
 <20191215172124.GA83861@xz-x1>
 <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 11:08:15AM +0100, Paolo Bonzini wrote:
> > Although now because we have kvm_get_running_vcpu() all cases for [&]
> > should be fine without changing anything, but I tend to add another
> > patch in the next post to convert all the [&] cases explicitly to pass
> > vcpu pointer instead of kvm pointer to be clear if no one disagrees,
> > then we verify that against kvm_get_running_vcpu().
> 
> This is a good idea but remember not to convert those to
> kvm_vcpu_write_guest, because you _don't_ want these writes to touch
> SMRAM (most of the addresses are OS-controlled rather than
> firmware-controlled).

OK.  I think I only need to pass in vcpu* instead of kvm* in
kvm_write_guest_page() just like kvm_vcpu_write_guest(), however we
still keep to only write to address space id==0 for that.

> 
> > init_rmode_tss or init_rmode_identity_map.  But I've marked them as
> > unimportant because they should only happen once at boot.
> 
> We need to check if userspace can add an arbitrary number of entries by
> calling KVM_SET_TSS_ADDR repeatedly.  I think it can; we'd have to
> forbid multiple calls to KVM_SET_TSS_ADDR which is not a problem in general.

Will do that altogether with the series.  I can further change both of
these calls to not track dirty at all, which shouldn't be hard, after
all userspace didn't even know them, as you mentioned below.

Is there anything to explain what KVM_SET_TSS_ADDR is used for?  This
is the thing I found that is closest to useful (from api.txt):

        This ioctl is required on Intel-based hosts.  This is needed
        on Intel hardware because of a quirk in the virtualization
        implementation (see the internals documentation when it pops
        into existence).

So... has it really popped into existance somewhere?  It would be good
at least to know why it does not need to be migrated.

> >> I don't think that's possible, most writes won't come from a page fault
> >> path and cannot retry.
> > 
> > Yep, maybe I should say it in the other way round: we only wait if
> > kvm_get_running_vcpu() == NULL.  Then in somewhere near
> > vcpu_enter_guest(), we add a check to wait if per-vcpu ring is full.
> > Would that work?
> 
> Yes, that should work, especially if we know that kvmgt is the only case
> that can wait.  And since:
> 
> 1) kvmgt doesn't really need dirty page tracking (because VFIO devices
> generally don't track dirty pages, and because kvmgt shouldn't be using
> kvm_write_guest anyway)
> 
> 2) the real mode TSS and identity map shouldn't even be tracked, as they
> are invisible to userspace
> 
> it seems to me that kvm_get_running_vcpu() lets us get rid of the per-VM
> ring altogether.

Yes, it would be perfect if so.

-- 
Peter Xu

