Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD323757C5
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 17:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbhEFPoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 11:44:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235145AbhEFPn6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 11:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620315779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4KmRXMHEZ+tVNwwgfG0qof+36HnLMbB1FdIrxdalX6M=;
        b=BquaxmH/Z5+T/EjIDNfbS4m3MA7rb9E8fgwqHemxL3RDDlmpxSkKySQ4vyK8tSxgbX5gmi
        Z+8tzyQMDxIl6Ntw0Nls7U+FPIy6Q/+1NreJz45Pxd6HJls9Mfy5azf2wfKiGK3v47C6Ou
        hxda2q4SWXLBB3wh5HVnM234id5O5NA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-HqYu6-wIOUGL-HnIy_9qew-1; Thu, 06 May 2021 11:42:56 -0400
X-MC-Unique: HqYu6-wIOUGL-HnIy_9qew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D196D80ED9B;
        Thu,  6 May 2021 15:42:54 +0000 (UTC)
Received: from [10.3.113.56] (ovpn-113-56.phx2.redhat.com [10.3.113.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7CAE60862;
        Thu,  6 May 2021 15:42:50 +0000 (UTC)
Subject: Re: [PATCH v2 4/9] bsd-user/syscall: Replace alloca() by g_new()
To:     Warner Losh <imp@bsdimp.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>, Kyle Evans <kevans@freebsd.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, qemu-ppc <qemu-ppc@nongnu.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20210506133758.1749233-1-philmd@redhat.com>
 <20210506133758.1749233-5-philmd@redhat.com>
 <CANCZdfoJWEbPFvZ0605riUfnpVRAeC6Feem5_ahC7FUfO71-AA@mail.gmail.com>
 <39f12704-af5c-2e4f-d872-a860d9a870d7@redhat.com>
 <CANCZdfqW0XTa18F+JxuSnhpictWxVJUsu87c=yAwMp6YT60FMg@mail.gmail.com>
 <7a96d45e-2bdc-f699-96f7-3fbf607cb06b@redhat.com>
 <CANCZdfrcv9ZUcBv7z+z3JPCjy0uzzY07VLmC4dqr5r8ba_QPLw@mail.gmail.com>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <adfc5da4-a615-24d7-0c67-f04d4eaec9a6@redhat.com>
Date:   Thu, 6 May 2021 10:42:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CANCZdfrcv9ZUcBv7z+z3JPCjy0uzzY07VLmC4dqr5r8ba_QPLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/21 10:30 AM, Warner Losh wrote:

> 
> But for the real answer, I need to contact the original authors of
> this part of the code (they are no longer involved day-to-day in
> the bsd-user efforts) to see if this scenario is possible or not. If
> it's easy to find out that way, we can either know this is safe to
> do, or if effort is needed to make it safe. At present, I've seen
> enough and chatted enough with others to be concerned that
> the change would break proper emulation.

Do we have a feel for the maximum amount of memory being used by the
various alloca() replaced in this series?  If so, can we just
stack-allocate an array of bytes of the maximum size needed?  Then we
avoid alloca() but also avoid the dynamic memory management that
malloc() would introduce.  Basically, it boils down to auditing why the
alloca() is safe, and once we know that, replacing the variable-sized
precise alloca() with its counterpart statically-sized array allocation,
at the expense of some wasted stack space when the runtime size does not
use the full compile-time maximum size.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

