Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AACE1C75B8
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgEFQG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:06:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55058 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729815AbgEFQG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 12:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z+3t3+wbayhKG8ZXNezVyF4RkQnz2wqH6eG7rnJ3rL4=;
        b=FbjE8WWQvFuUs4RDK1Fai4rRQM6Hs6QYckTciIl6w/fSQaMZv1C26JyxHVOdVTQN0pt5la
        P7RJLm2HfCxd/JGKGu36g5B/gQPhjgK2UemCvtOf9mNZ+rEPD33L4DRTDv2b7qhoD/DvIo
        PsPYL7UEfGbq97R1NWHy7TLSQ/EUz1M=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-v8Pd6gEdMNioIDBdBzkuZQ-1; Wed, 06 May 2020 12:06:26 -0400
X-MC-Unique: v8Pd6gEdMNioIDBdBzkuZQ-1
Received: by mail-qt1-f200.google.com with SMTP id g8so3333483qtq.2
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 09:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z+3t3+wbayhKG8ZXNezVyF4RkQnz2wqH6eG7rnJ3rL4=;
        b=rMjEbHkFT+U7XL8Flor52TXQZuFjYblE6ca5zB91Qy//YCzSKzUkcw+rxDn6XRTCGU
         IjT1E0VoU8Va49xVF/3rJvMA6m8ZoZCoPBWzep39btS41fZW5mY20JtLx0uHj20ANwVD
         uAnmpREYfzY2U0QkyiDJdg2mcO6sXNd/9Xd/e01/2J5JgTMSGLT+tKtIa+WqDirjd5Ue
         auMJDtYh4lO4qG2mC9OFPIRUcQz1oQBo5OuwF/H8e0eeWzeQksqgFaKngLNlQ8KMYNid
         lWCHIcKPfCfi3b2pRzziBajnWCwdcsRBD2ZBhCb1x+kmxjIPohwOIZE8n7dAAOB6rAbW
         6ZRQ==
X-Gm-Message-State: AGi0PuZLj64FkoaTx71x7OdwsXo+1AwbJpdoHNqH0jXmnR24b73t1IBC
        leDxOpTNI5QODyEwuxPJb5eqSSt1MyqvCZrVETV+6zh22X4wKHacsMiQsejIkIFDJn8cHLVDLDz
        KzIlOCiAUhN1W
X-Received: by 2002:a37:688c:: with SMTP id d134mr9717424qkc.450.1588781185498;
        Wed, 06 May 2020 09:06:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypLrcd8xS+ttqTUL6EUvZBMmsM8/E0ENKYL/qimkT3zmv3LL8KFrfLcKfTeF0a+trZnV5sTZNw==
X-Received: by 2002:a37:688c:: with SMTP id d134mr9717398qkc.450.1588781185252;
        Wed, 06 May 2020 09:06:25 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a27sm1912587qtb.26.2020.05.06.09.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 09:06:24 -0700 (PDT)
Date:   Wed, 6 May 2020 12:06:23 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 7/9] KVM: x86: simplify dr6 accessors in kvm_x86_ops
Message-ID: <20200506160623.GO6299@xz-x1>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200506111034.11756-8-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 07:10:32AM -0400, Paolo Bonzini wrote:
> kvm_x86_ops.set_dr6 is only ever called with vcpu->arch.dr6 as the
> second argument, and for both SVM and VMX the VMCB value is kept
> synchronized with vcpu->arch.dr6 on #DB; we can therefore remove the
> read accessor.
> 
> For the write accessor we can avoid the retpoline penalty on Intel
> by accepting a NULL value and just skipping the call in that case.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

(I think this patch and the previous one seem to be the same as the previous
 version.  Anyway...)

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

