Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A95A41423C2
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 07:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgATGp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 01:45:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60129 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725851AbgATGp6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 01:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579502757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vqNKhNygXBIFN97LCULqdWGu9X9CxFiSHBJuN0O9XTc=;
        b=OyGgjdD9TH/4jWXHc31Pyzwii6vmkp21qFGhov2MOCLZ1L7TuR4er5tTZ2xJohkeqViurY
        w42BEokqdx3fG/mbji0KKdh6Mt4t6Cn3+GOISFoFbdpbBUBNT4M7Feiu/ZqrB5+Tctce9R
        t+Ba1e9RdW+/EnRXWLBszdC+tYJEVr4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-ygTD4tnWNoCo5WEKOg5pOw-1; Mon, 20 Jan 2020 01:45:54 -0500
X-MC-Unique: ygTD4tnWNoCo5WEKOg5pOw-1
Received: by mail-pl1-f197.google.com with SMTP id 91so853790plf.23
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 22:45:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vqNKhNygXBIFN97LCULqdWGu9X9CxFiSHBJuN0O9XTc=;
        b=j4jExI7/UNaugd7xflWadSwG0ETw2GnpcNbm+TvtNpKIkVNE/QU8lKAUgvnfhguKTo
         Vdw6woiPVfjm1AJCEkujZu7lHZKXZ0NqdhNq7zXAKtgEP8zCTx8Ie6aQD0ZP4F2/4ms+
         EqIoV9Cl8xXsVEmSJXnyOk4eQJDWzpq2PLwPRzg6d5lGDFch4xcWgoL4ueCgcitxmBqY
         yHjMyzxUMLtOH2wnaBymZcjoB0PXcty+VOSFliAO+gLeS5D1aWfvoTXC+ZSsT4J3QJj3
         Wrreipoh3olK2j1V6muy2JiHuqszSIzTFcu0g1DjSxRHdNhAag3IuqGVWlDVypWF5gND
         hW/w==
X-Gm-Message-State: APjAAAUdZz80xiBIBy0iO+ndGaYKqa0MMomVQcnX+mxN548NWfMgkHQ2
        BJbj8zZI0UvBU/Nvysj/8ckV4Rh+FGdLcyMa8RBJAFKgxKFY5Czoh69QSDLehD7aE4SZwlOKB0s
        zcAGlcxle/JoI
X-Received: by 2002:a17:902:bc85:: with SMTP id bb5mr13239910plb.208.1579502753215;
        Sun, 19 Jan 2020 22:45:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqx8wxSabuAGXP8LHVag7+1TwIUhVg8HOPxfCSJFySXCs0RiXtk0jFc9Dqlntqp4v6sH9fYKvw==
X-Received: by 2002:a17:902:bc85:: with SMTP id bb5mr13239902plb.208.1579502752949;
        Sun, 19 Jan 2020 22:45:52 -0800 (PST)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z16sm38786923pff.125.2020.01.19.22.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 22:45:52 -0800 (PST)
Date:   Mon, 20 Jan 2020 14:45:40 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v3 09/21] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200120064540.GB380565@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-10-peterx@redhat.com>
 <5af8e2ff-4bde-9652-fb25-4fe1f74daae2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5af8e2ff-4bde-9652-fb25-4fe1f74daae2@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 19, 2020 at 10:01:50AM +0100, Paolo Bonzini wrote:
> On 09/01/20 15:57, Peter Xu wrote:
> > -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > +/*
> > + * If `uaddr' is specified, `*uaddr' will be returned with the
> > + * userspace address that was just allocated.  `uaddr' is only
> > + * meaningful if the function returns zero, and `uaddr' will only be
> > + * valid when with either the slots_lock or with the SRCU read lock
> > + * held.  After we release the lock, the returned `uaddr' will be invalid.
> > + */
> 
> In practice the address is still protected by the refcount, isn't it?
> Only destroying the VM could invalidate it.

Yes I think so.  I wanted to make it clear that uaddr is temporary,
however "will be invalid" could be be too strong...  Thanks,

-- 
Peter Xu

