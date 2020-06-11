Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CC91F639C
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 10:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgFKIbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 04:31:15 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37945 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726646AbgFKIbP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jun 2020 04:31:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591864273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wqYVXT69UvryAYl9lNEvAFDCi4lpCbFocG1/WeDxI7w=;
        b=Blkxil50M6ybT1eiAuFy1zwtUYkjpOp8G11dvxz5wGL5z6/PD39Zqd4X0i9T+LgPw2Dx4w
        GstLUAhCPVE/NsA+HANkgG1H8Qk4iU2FgTofyVW00Sl6+UuU/0y1WB3gDEevcOHertiSTa
        S8J+ZQqtjreiSSPjLxsz0oNRFCQMC2w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-Fnwtwx17MWKxZLcaeSSclg-1; Thu, 11 Jun 2020 04:31:12 -0400
X-MC-Unique: Fnwtwx17MWKxZLcaeSSclg-1
Received: by mail-ed1-f69.google.com with SMTP id c1so1418876edd.21
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 01:31:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wqYVXT69UvryAYl9lNEvAFDCi4lpCbFocG1/WeDxI7w=;
        b=MT9QP2zczfiZr3KDAni7e2yqAMEOd1JVaIuVbkjuY+7R9e7Lbmu6M4oNIPZ7UhuLHS
         ZkHK30/oHb9hLXyZbj8x4HlEcRBFVX4ulOaqV+EOwB3PjC6FGfE5xKNJFoTP+rbCcI5G
         G5qmz9/H4W+cyzfimwkeHMbtqFQ4Xrtm3r3rZ9SEWuH/fpLp3LTV5fpXwRwx6HL471Qk
         aIxRvBJM7PGkhOXTTWtxugdm0/wcxJtOus66vNOw/3wGy3NHsdisP8BpOYYny4yvoUu6
         dypTAhih58U4/GhSdZDT45O4MpJgjntQkyhGdQTkyTAqP7CLLn9eKGZnWDpn7Acz+eYp
         T6AQ==
X-Gm-Message-State: AOAM531iJWh3fWc1mWQidJ77FhQueDV//ihn5Jbf6UCGJuQYKYihfDuZ
        cSXcw1ylzIoS249eYzkwKwZkg1kUcOD574lxYtx0EbFszWU0brMUCGh1VnTR8c/2h+LEAXS5z+1
        4chI6pMaairVQ
X-Received: by 2002:a17:906:7f94:: with SMTP id f20mr7554733ejr.394.1591864270806;
        Thu, 11 Jun 2020 01:31:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKlzTe4j+zEAO903+5izsigh9isK3JSgGRfJjNeyODoD2a9lb20KYC0JPI7N6g+dJC4qcPBw==
X-Received: by 2002:a17:906:7f94:: with SMTP id f20mr7554717ejr.394.1591864270580;
        Thu, 11 Jun 2020 01:31:10 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id qp16sm1487705ejb.64.2020.06.11.01.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 01:31:09 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async_pf: Cleanup kvm_setup_async_pf()
In-Reply-To: <20200610181453.GC18790@linux.intel.com>
References: <20200610175532.779793-1-vkuznets@redhat.com> <20200610181453.GC18790@linux.intel.com>
Date:   Thu, 11 Jun 2020 10:31:08 +0200
Message-ID: <87sgf29f77.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

>
> I'd also be in favor of changing the return type to a boolean.  I think
> you alluded to it earlier, the current semantics are quite confusing as they
> invert the normal "return 0 on success".

Yes, will do a follow-up.

KVM/x86 code has an intertwined mix of:
- normal 'int' functions ('0 on success')
- bool functions ('true'/'1' on success)
- 'int' exit handlers ('1'/'0' on success depending if exit to userspace
  was required)
- ...

I think we can try to standardize this to:
- 'int' when error is propagated outside of KVM (userspace, other kernel
  subsystem,...)
- 'bool' when the function is internal to KVM and the result is binary
 ('is_exit_required()', 'was_pf_injected()', 'will_have_another_beer()',
 ...)
- 'enum' for the rest.
And, if there's a good reason for making an exception, require a
comment. (leaving aside everything returning a pointer, of course as
these are self-explanatory -- unless it's 'void *' :-))

>
> For this patch:
>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>

Thank you!

-- 
Vitaly

