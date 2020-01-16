Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD2413E00B
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 17:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgAPQ1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 11:27:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22551 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726088AbgAPQ1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 11:27:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579192030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WC8Z8j4wZiM+iDNfePn8Q6kPV/b9KT3V2XFsUH+aPzw=;
        b=GbE4vh/JHsKALNaqvFMhPLR+DE7dONNxRVlug3ERhx2ABPi2nAJtqXjIx9/VCakMSVZYtc
        Ium343YEfYdMauZ5kecFNj61gH+nm4R2meQvIXdMTlAj+ytZ9V0+nn4GwJzp+NV70s7ewX
        2fEXOS5yzlE7bjph8D0WKMCLKaKsqRw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-VBkUSBC7NnCf6DcB8C11FQ-1; Thu, 16 Jan 2020 11:27:06 -0500
X-MC-Unique: VBkUSBC7NnCf6DcB8C11FQ-1
Received: by mail-qk1-f200.google.com with SMTP id i135so13297243qke.14
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:27:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WC8Z8j4wZiM+iDNfePn8Q6kPV/b9KT3V2XFsUH+aPzw=;
        b=pfoNwbJVxUQtXX4bpceUanhSwe/2OPwYmm3Hqetn0un16/wMBwErRsHCU0el1rGd/c
         pckLrKSI+bEU2wjvgC0XJLNLTaztRTazs/aNTyIcSAv3SpWMAhL+7aKyX3KAyvcCve/s
         gq66dYFy16WKmXhZ0sKLw7u+ZU+JeoxiSCi07p9/Rmz40aLkuwjeJZ37/K/ilpAjEfRY
         ax5flOTKC0siUA8c4MU35yQG7KFLzAj5ucZUpXRGfrOfdi4A8uMxXafkMSElQLlEA9JH
         pONTmYCb8Yl85DMkXNSV+YIlAoi6o6WfLAVGMVKW4vRjrpQ8nFdg8KshYConaKDxvrDy
         kzAw==
X-Gm-Message-State: APjAAAXXqFV0sGUtv43kYJ4LLHX8bm2D1kUY0joxtdWyQ3HNNj5nKGEr
        iFMRr1s5ZPsD2jzburTM42zxjLZK6x2TSqIHIXZ02rYTqqU6cDCnvM0yZhknGxFw8D45urTAZit
        BO5WN3bdhxz4o
X-Received: by 2002:a37:8ac4:: with SMTP id m187mr29027926qkd.277.1579192025790;
        Thu, 16 Jan 2020 08:27:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYtk2Bh02F1YEqXqx8bwti4pMx8sbu0T6IbdlxQJ1t7qPkHRZYDmYJaMmrkINO8rf3duc41Q==
X-Received: by 2002:a37:8ac4:: with SMTP id m187mr29027901qkd.277.1579192025558;
        Thu, 16 Jan 2020 08:27:05 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id k29sm11420492qtu.54.2020.01.16.08.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:27:04 -0800 (PST)
Date:   Thu, 16 Jan 2020 11:27:03 -0500
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
Message-ID: <20200116162703.GA344339@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200116033725-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200116033725-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 03:38:21AM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 09, 2020 at 09:57:20AM -0500, Peter Xu wrote:
> > +	/* If to map any writable page within dirty ring, fail it */
> > +	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
> > +	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
> > +	    vma->vm_flags & VM_WRITE)
> > +		return -EINVAL;
> 
> Worth thinking about other flags. Do we want to force VM_SHARED?
> Disable VM_EXEC?

Makes sense to me.  I think it worths a standalone patch since they
should apply for the whole per-vcpu mmaped regions rather than only
for the dirty ring buffers.

(Should include KVM_PIO_PAGE_OFFSET, KVM_COALESCED_MMIO_PAGE_OFFSET,
 KVM_S390_SIE_PAGE_OFFSET, kvm_run, and this new one)

Thanks,

-- 
Peter Xu

