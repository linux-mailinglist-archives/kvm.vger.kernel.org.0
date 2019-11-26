Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6A110A684
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 23:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfKZW13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 17:27:29 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52315 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726077AbfKZW13 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Nov 2019 17:27:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574807247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NicO9dQ03Zmo4PQMvYh38X/weC3beZzf/9LJxgQLW2o=;
        b=YbwsjuqnC0/R9o1ygqUR7nd4MiiX/r2C3gY5Od8cdVkFIxpof0UUaWqZ8P6ksEvcEqV9Vy
        i/XjS+B4bq2xuSEya1e2bhYTZtxy5Jk5tcntnYokxSdCQydHLBM/gFK2Lj/GQ9p8tYlTj3
        iaqSUsQ+z9GzRPwpBnHOO4L8cqH1iEg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-QBqWIM9kM1CpI5NUXirAHQ-1; Tue, 26 Nov 2019 17:27:24 -0500
Received: by mail-qt1-f197.google.com with SMTP id f31so13531482qta.0
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2019 14:27:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RbHOMzuh71lzkXaVrHGstWzxDJlihkJE/87ycwZQB+w=;
        b=XZltrMvcJTQQNLX/hJiTCcDHzaJm0mRafS4bL8RlfWW3uamc7It2Lj3LKXgiEZ9Zoc
         q3vFgk/2RODmPytRfdWXa/dx15JyMYu9AIBlP0jGKmySeQbG8sW9kVMQTd2qLAHu3CBV
         mrhJO7vPbmXenbcVxQh5R0TlKc5Zg5lJCg1BpN/TtT5BX6V3hmEcuIAiDt40WdGvFgKn
         G7pUbudFnbtVAr0PQLaQyrlcx/hRJR0NKk1mUvmeC09ynyC6EWJuhIqMOOjnV1bntDfO
         kTqpMM4yQ5lveko8IdlSjvI175dSbeTvOuJGk+b23OA3JUQRjMBOvlu4m/iGhXANuazO
         5yIQ==
X-Gm-Message-State: APjAAAXEXfOBNzg8KeGVDEDgPOgl9QsdLRXV9gE5jWfPFMQ8ua9PEnqs
        pupHjaukjkmwFTpIYyl9tmZI/4cqBA4ZfMpAs7WLAicnDzLYUlTwQ6owZ42AtzjPMTm8LhqC6Uo
        GwRtoSXMVTGx2
X-Received: by 2002:a05:620a:816:: with SMTP id s22mr878667qks.48.1574807244077;
        Tue, 26 Nov 2019 14:27:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6UQQWiuLZ74PXNzTPA2SAstnnTg0lc7LDU8i0zr8BODQKEqgqe0zdRaJekr2JvT+wcx6iOA==
X-Received: by 2002:a05:620a:816:: with SMTP id s22mr878636qks.48.1574807243765;
        Tue, 26 Nov 2019 14:27:23 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id f35sm6617602qtd.35.2019.11.26.14.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 14:27:23 -0800 (PST)
Date:   Tue, 26 Nov 2019 17:27:21 -0500
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] KVM: Unlimit number of ioeventfd assignments for real
Message-ID: <20191126222721.GB14153@xz-x1>
References: <20190928014045.10721-1-peterx@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20190928014045.10721-1-peterx@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: QBqWIM9kM1CpI5NUXirAHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 28, 2019 at 09:40:45AM +0800, Peter Xu wrote:
> Previously we've tried to unlimit ioeventfd creation (6ea34c9b78c1,
> "kvm: exclude ioeventfd from counting kvm_io_range limit",
> 2013-06-04), because that can be easily done by fd limitations and
> otherwise it can easily reach the current maximum of 1000 iodevices.
> Meanwhile, we still use the counter to limit the maximum allowed kvm
> io devices to be created besides ioeventfd.
>=20
> 6ea34c9b78c1 achieved that in most cases, however it'll still fali the
> ioeventfd creation when non-ioeventfd io devices overflows to 1000.
> Then the next ioeventfd creation will fail while logically it should
> be the next non-ioeventfd iodevice creation to fail.
>=20
> That's not really a big problem at all because when it happens it
> probably means something has leaked in userspace (or even malicious
> program) so it's a bug to fix there.  However the error message like
> "ioeventfd creation failed" with an -ENOSPACE is really confusing and
> may let people think about the fact that it's the ioeventfd that is
> leaked (while in most cases it's not!).
>=20
> Let's use this patch to unlimit the creation of ioeventfd for real
> this time, assuming this is also a bugfix of 6ea34c9b78c1.  To me more
> importantly, when with a bug in userspace this patch can probably give
> us another more meaningful failure on what has overflowed/leaked
> rather than "ioeventfd creation failure: -ENOSPC".
>=20
> CC: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>

Ping - just in case it fell through the cracks.

--=20
Peter Xu

