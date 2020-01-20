Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3C01423D0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 07:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgATGsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 01:48:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57114 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726148AbgATGsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 01:48:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579502911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mbPSCio8/LP2m+y+0WtJxGAsKNtPaMEjLFdacvoLLa8=;
        b=TuMuJaNX6GrTp6QX1mZ7S00Yvobzw2uS+PJer3Rw4tVlWB7O4j90dmFlsy1P2zsl9q1MXI
        HvHTeVh0Aho73VTgEM6PcnPluE8AkTLqJ2PvuK/Tp3nnZo8mrZGg4uc1M2gUlYtKdwArmV
        6Zr1R09vV48M0e3RAAR08TXKaxYOkrg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-TVdIltMfP1CrdL8tn4Qz6g-1; Mon, 20 Jan 2020 01:48:26 -0500
X-MC-Unique: TVdIltMfP1CrdL8tn4Qz6g-1
Received: by mail-pf1-f200.google.com with SMTP id v14so20033825pfm.21
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 22:48:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mbPSCio8/LP2m+y+0WtJxGAsKNtPaMEjLFdacvoLLa8=;
        b=mZ1J4JMEESTlNReqP42jbAVLyTJ7wwy2Xa1Rti3hoHQT4xAHlnQKrihsNf7u5Upv9h
         F0HcI9GF1jpzE6HiMd1Stb4JDrYXwqakCKBGLXEdrhwOdln1/eXVQIzdhD3aU+mQznz4
         LZ5DowmzFdlhv+Hf1c2CzioNlOuMxxV7cCnLjIzgWyyCBoGIQW83qRNMxH+1S5NfI272
         5gaYqPeF8LjtboHnpxm9UttX8/gqToLEkUwLMEdpSosbwL1e4UGGsJkY9FS6OxWj2aY+
         REum0I3efnWLwAvJs8I3F2e8e9/1ZYt6L2ol0NGAJPwdEiMsO1gy5NYpNheoW0S+bMZy
         giYQ==
X-Gm-Message-State: APjAAAUptBe1vP0NHvK9rNpX3jJzTmETvCk2DeAgkeksnyF7N+5La2oc
        gA6ci+it/NsyRbC5Omubj44zXLHHunK5u4VO3Rn18DZygwHZ9Ko74TgDb6v55ZJwO4CreKFXf5l
        QHXe7W3burDVd
X-Received: by 2002:a63:a4b:: with SMTP id z11mr56366206pgk.97.1579502905188;
        Sun, 19 Jan 2020 22:48:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqzXFGmeddIVnOlaDqMWJbI+cXOBU/LMjL/VsJRQLf4JU44G/RoO8NR+SY+o895T3e4rZphHIA==
X-Received: by 2002:a63:a4b:: with SMTP id z11mr56366193pgk.97.1579502904925;
        Sun, 19 Jan 2020 22:48:24 -0800 (PST)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q64sm16484005pjb.1.2020.01.19.22.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 22:48:24 -0800 (PST)
Date:   Mon, 20 Jan 2020 14:48:11 +0800
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200120064811.GC380565@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200116033725-mutt-send-email-mst@kernel.org>
 <20200116162703.GA344339@xz-x1>
 <20200117045019-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200117045019-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 17, 2020 at 04:50:48AM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 16, 2020 at 11:27:03AM -0500, Peter Xu wrote:
> > On Thu, Jan 16, 2020 at 03:38:21AM -0500, Michael S. Tsirkin wrote:
> > > On Thu, Jan 09, 2020 at 09:57:20AM -0500, Peter Xu wrote:
> > > > +	/* If to map any writable page within dirty ring, fail it */
> > > > +	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
> > > > +	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
> > > > +	    vma->vm_flags & VM_WRITE)
> > > > +		return -EINVAL;
> > > 
> > > Worth thinking about other flags. Do we want to force VM_SHARED?
> > > Disable VM_EXEC?
> > 
> > Makes sense to me.  I think it worths a standalone patch since they
> > should apply for the whole per-vcpu mmaped regions rather than only
> > for the dirty ring buffers.
> > 
> > (Should include KVM_PIO_PAGE_OFFSET, KVM_COALESCED_MMIO_PAGE_OFFSET,
> >  KVM_S390_SIE_PAGE_OFFSET, kvm_run, and this new one)
> > 
> > Thanks,
> 
> 
> I don't think we can change UAPI for existing ones.
> Userspace might be setting these by mistake.

Right (especially for VM_EXEC)... I'll only check that for the new
pages then.  Thanks,

-- 
Peter Xu

