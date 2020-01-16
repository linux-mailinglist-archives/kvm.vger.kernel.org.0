Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F9113D605
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 09:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731258AbgAPIi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 03:38:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44452 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730518AbgAPIi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 03:38:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579163908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IXtSmPS0i6Qsp99yh//fgz82ZG06+bv6j5QX91/2YyA=;
        b=ag+LGri+lLDYHUGNGUm4wSWQJdFTAdE4g4qUEil9toltT9/7wvsi53c2tALoTTIpfYkjEf
        3YF1c5Q1Sf6NddRW6p1ZiCJrMD4BSVGnF6b+OMJlJUGUlE59mg8X8aeLvHOq4h5lOUBlBu
        83Q8X9JnP177K96yJOXlkUSIVv+8JY0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-f2YtLTECN4qCIUp-i6wmmg-1; Thu, 16 Jan 2020 03:38:26 -0500
X-MC-Unique: f2YtLTECN4qCIUp-i6wmmg-1
Received: by mail-wm1-f72.google.com with SMTP id y125so2094828wmg.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 00:38:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IXtSmPS0i6Qsp99yh//fgz82ZG06+bv6j5QX91/2YyA=;
        b=Vq9d7LR4OgOMlLm6Y0yuqJEcLdJG/EqOfRmVTnUoOHwgVP+fS8w0XB9BRY4PuX+KbV
         WfS6oc2EJkPrTdnn7k5vnyn4fTI4DGU6OxiLmPL9hhVcC1pu1KDWuyZP5W1OfynEiCad
         Yg7PcY8GHaim1vjizoiWBT8qpfHKxDqSQPVeaRfav0snjZVrZzEFEHice00/Zrzudz4d
         8N/oSLnAjaDDxGEKdwusu7i04C5WfojzkdvN3GvS2glfQqiV2jksOhpOnRtKWi/Hi0I8
         +5JDIO+WKmQ6LhFun/MgCXIz+ZUeH+UKw6RFHtCzzgXFDEhwnEUuSyLtZ1HlgwEatZoa
         /gAQ==
X-Gm-Message-State: APjAAAVZpklveTSlu41vnNjoT6VnMmZcG8wI6aq8HLoRSD+GN1SjrPaO
        9u/uYs7m2rQ5ZjFMWD1OGrdo2S13HrjYzcRheMw8cCJRLdOTF3WWLfHVb7r1AIbWSmkvdqxi4oK
        /NTjDuTQ0Gbbm
X-Received: by 2002:a05:6000:118d:: with SMTP id g13mr2102071wrx.141.1579163905510;
        Thu, 16 Jan 2020 00:38:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqwGO77Z98jPmNC+6Lx21D2RFFW5UOBHp3rIpKkBmINzKtpHw/Lyr1d04DYLp7eI2k9wrDOeaA==
X-Received: by 2002:a05:6000:118d:: with SMTP id g13mr2102044wrx.141.1579163905272;
        Thu, 16 Jan 2020 00:38:25 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id y139sm2277799wmd.24.2020.01.16.00.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 00:38:24 -0800 (PST)
Date:   Thu, 16 Jan 2020 03:38:21 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
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
Message-ID: <20200116033725-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109145729.32898-13-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 09:57:20AM -0500, Peter Xu wrote:
> +	/* If to map any writable page within dirty ring, fail it */
> +	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
> +	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
> +	    vma->vm_flags & VM_WRITE)
> +		return -EINVAL;

Worth thinking about other flags. Do we want to force VM_SHARED?
Disable VM_EXEC?

