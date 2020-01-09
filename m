Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652D413613C
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 20:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgAIThK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 14:37:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731161AbgAIThH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 14:37:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578598626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u2L+6QoH0unQY1zZnaaxRdBowT9MR5BCuv5QzmnWT7U=;
        b=WkwuSD1VgXthIxUPzYB4jfP3jX/VUsuec4bZtjAUGAVuHPM0zDb8AeEv+Gb22zsBun6jjz
        Pb2UmhfdjVkfHKswpg4cq3kYtctGCyi6n1CQwLNRBp4qiOyySzvxgOMGpCw1O47QT1/c25
        mq92L/hwrBG8CrRnTxQB6uVYzs8eLyg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-yDVg8vM0NeSYPZuzu3AwIw-1; Thu, 09 Jan 2020 14:37:05 -0500
X-MC-Unique: yDVg8vM0NeSYPZuzu3AwIw-1
Received: by mail-qv1-f70.google.com with SMTP id g15so4766984qvq.20
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:37:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u2L+6QoH0unQY1zZnaaxRdBowT9MR5BCuv5QzmnWT7U=;
        b=M5X9VqnnsS9FGfgNv9xhXJsZsC06+UE1BiA4NQjIrjAiC+TdHSinhpbkuAewD1lOvA
         J+Bx7jRJEuv3O2CKTOWXoJdQIT1M2NX9LTyRbkNKYVuZt6NNgkFe3TZNAQnZ9R4tVjrt
         AqeOV/aG+t7rJArrkMVKMaqEXiuuK0lZNEgH1taeP/c/laF+aCPfF1w6p41hDrHNYlPO
         ec2irLG76TUv+EMn5jqUwyMuk63rZkEYWWqhrndcnWioshdbBfIsYlRCMNKN8EQtHo2R
         sXh+Thi5bDl9eUP2NtJMhBNxm/idnfng70etZ/TrPZEHEo3t/e5D9AA5Vvzcz0lPUMgc
         8fPw==
X-Gm-Message-State: APjAAAXUF0kOiwwbvJSq7MOS4KxFJXpqjILR7eSRfNfoVgmD09YuRQxq
        bJX55/zFYM6wHa73aFkT8UgGyjyy2D/q/J7gkbBQs1hH/CZkRDeh+gfxmOzLpiHoxx9uymlsZ3b
        X6BjqE1SY1XSA
X-Received: by 2002:a05:620a:143b:: with SMTP id k27mr10644214qkj.262.1578598623566;
        Thu, 09 Jan 2020 11:37:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqwBkyC8ff/t9Z0cRBa2GyWP8ASoK/Sw3be4MYuzdIQJb+iilhmNlhJeXq+yhgWbj0EEsyDvHw==
X-Received: by 2002:a05:620a:143b:: with SMTP id k27mr10644192qkj.262.1578598623356;
        Thu, 09 Jan 2020 11:37:03 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id f5sm3537502qke.109.2020.01.09.11.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 11:37:02 -0800 (PST)
Date:   Thu, 9 Jan 2020 14:36:56 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200109143620-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109095610.167cd9f0@w520.home>
 <20200109192116.GE36997@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109192116.GE36997@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 02:21:16PM -0500, Peter Xu wrote:
> On Thu, Jan 09, 2020 at 09:56:10AM -0700, Alex Williamson wrote:
> 
> [...]
> 
> > > > +Dirty GFNs (Guest Frame Numbers) are stored in the dirty_gfns array.
> > > > +For each of the dirty entry it's defined as:
> > > > +
> > > > +struct kvm_dirty_gfn {
> > > > +        __u32 pad;  
> > > 
> > > How about sticking a length here?
> > > This way huge pages can be dirtied in one go.
> > 
> > Not just huge pages, but any contiguous range of dirty pages could be
> > reported far more concisely.  Thanks,
> 
> I replied in the other thread on why I thought KVM might not suite
> that (while vfio may).
> 
> Actually we can even do that for KVM as long as we keep a per-vcpu
> last-dirtied GFN range cache (so we don't publish a dirty GFN right
> after it's dirtied), then we grow that cached dirtied range as long as
> the continuous next/previous page is dirtied.  If we found that the
> current dirty GFN is not continuous to the cached range, we publish
> the cached range and let the new GFN be the starting of last-dirtied
> GFN range cache.
> 
> However I am not sure how much we'll gain from it.  Maybe we can do
> that when we have a real use case for it.  For now I'm not sure
> whether it would worth the effort.
> 
> Thanks,

I agree for the implementation but I think UAPI should support that
from ground up so we don't need to support two kinds of formats.

> -- 
> Peter Xu

