Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381901C96AB
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 18:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEGQip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 12:38:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48905 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726134AbgEGQip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 12:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588869523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0GJUSBwd6yajjE7Du/EDRG7BQr30DrFCiogxpggmT4Y=;
        b=N59dd6p78IBw8jtprf9//xA2yIt38Yhy3cDFctLXoaEGOn73ZjEyFXEjakZKizpB8UEAgw
        EXHZXrCQcNoWx7si+B8YCA7zOdp3TAyTX9dHN+1nMjzQLJe6NFmlAufUatI9QmJL79GbwV
        L1+crcOGl8jIQ0FcUyMs6Gva5ek6AW0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-e95oWamLN5SygYM2FQA5YQ-1; Thu, 07 May 2020 12:38:41 -0400
X-MC-Unique: e95oWamLN5SygYM2FQA5YQ-1
Received: by mail-qk1-f200.google.com with SMTP id a18so6429759qkl.0
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 09:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0GJUSBwd6yajjE7Du/EDRG7BQr30DrFCiogxpggmT4Y=;
        b=OgTtxE5Y540xldO+cTeUooivbMAfcwCu+RJBGx7D0Yedv54s7gscjgg+qL//DsS2Ms
         yNaGrWFgMOG6RerMaMfe/011kUX/GfsfMIBvokwWzD7pcf6bwITeXzTfiXLEebFwZqhx
         PnMT10jMqyZTsNxFZOSXFAHU0vUj02YFQRdUvU3VkKs27kpbCeqpWBHdA1T1+KS2Vu0z
         bob9Z3Llb76Lh0utenRJ+6bP7Lav5W6dnxK5fX0VLzQF8HqUXVy9syBX/OJaFEhpUCJr
         1dbjMNDoWjOyBmEQ/AhJhOhOzqqoQa6BcQo0gZexLMeSHWvxaY2aWtdYrRW9hyUzB5He
         Z4Lg==
X-Gm-Message-State: AGi0PubIec9mgDkhCBRLdEp1tG1KbR7WLo8GvxIqcocncn7NECjLGRJu
        KfODU4D804oKgNW9gBUFcS0cYkk4hx2XcuN9n4yWd97pty/ukqwAupLZmg+ej+BsS+ThA5laHt7
        aAWZVrVFJnTWE
X-Received: by 2002:a37:68c9:: with SMTP id d192mr15660758qkc.168.1588869521151;
        Thu, 07 May 2020 09:38:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypIMOsald+8dpvEMLnkxwF+4OesJDv1LTD2qOjQwQClxhhNqfZeDggoBqidjPHz/P9Dh64NRpg==
X-Received: by 2002:a37:68c9:: with SMTP id d192mr15660728qkc.168.1588869520871;
        Thu, 07 May 2020 09:38:40 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a194sm4596136qkb.21.2020.05.07.09.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 09:38:40 -0700 (PDT)
Date:   Thu, 7 May 2020 12:38:39 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 9/9] KVM: VMX: pass correct DR6 for GD userspace exit
Message-ID: <20200507163839.GG228260@xz-x1>
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-10-pbonzini@redhat.com>
 <20200507161854.GF228260@xz-x1>
 <7abe5f7b-2b5a-4e32-34e2-f37d0afef00a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7abe5f7b-2b5a-4e32-34e2-f37d0afef00a@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 06:21:18PM +0200, Paolo Bonzini wrote:
> On 07/05/20 18:18, Peter Xu wrote:
> >>  		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> >> -			vcpu->run->debug.arch.dr6 = vcpu->arch.dr6;
> >> +			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_RTM | DR6_FIXED_1;
> > After a second thought I'm thinking whether it would be okay to have BS set in
> > that test case.  I just remembered there's a test case in the kvm-unit-test
> > that checks explicitly against BS leftover as long as dr6 is not cleared
> > explicitly by the guest code, while the spec seems to have no explicit
> > description on this case.
> 
> Yes, I noticed that test as well.  But I don't like having different
> behavior for Intel and AMD, and the Intel behavior is more sensible.
> Also...

Do you mean the AMD behavior is more sensible instead? :)

> 
> > Intead of above, I'm thinking whether we should allow the userspace to also
> > change dr6 with the KVM_SET_GUEST_DEBUG ioctl when they wanted to (right now
> > iiuc dr6 from userspace is completely ignored), instead of offering a fake dr6.
> > Or to make it simple, maybe we can just check BD bit only?
> 
> ... I'm afraid that this would be a backwards-incompatible change, and
> it would require changes in userspace.  If you look at v2, emulating the
> Intel behavior in AMD turns out to be self-contained and relatively
> elegant (will be better when we finish cleaning up nested SVM).

I'm still trying to read the other patches (I need some more digest because I'm
even less familiar with nested...).  I agree that it would be good to keep the
same behavior across Intel/AMD.  Actually that also does not violate Intel spec
because the AMD one is stricter.  However I guess then we might also want to
fixup the kvm-unit-test too to aligh with the behaviors on leftover set bits.

Thanks,

-- 
Peter Xu

