Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA603755A4
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhEFO3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 10:29:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234665AbhEFO3z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 10:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620311336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mdbs+8zL0ZsR6n4jgVA72c4nLXnosqzKKX4khM1dLjo=;
        b=SVcguRnDSSS8Eyx7CIo9b4hlFvW5MZR7ki0pFMW86+1uSAuXGYhSQqPj40c+K3pr1ymW4e
        7pwL2EkUsBB5fPRLj3Q92dzoZAyjip0efyon46GA9A9ZWXxzysOW4aq/w5d3n3JmXyGT+6
        gYtAIM4v/0nW50xWgUiXx/P3663FDYc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-UrRYZ5BMPNC0cG3q7qBqBg-1; Thu, 06 May 2021 10:28:55 -0400
X-MC-Unique: UrRYZ5BMPNC0cG3q7qBqBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BEB2801107;
        Thu,  6 May 2021 14:28:53 +0000 (UTC)
Received: from [10.3.113.56] (ovpn-113-56.phx2.redhat.com [10.3.113.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 724BA19D61;
        Thu,  6 May 2021 14:28:49 +0000 (UTC)
Subject: Re: [PATCH v2 0/9] misc: Replace alloca() by g_malloc()
To:     Warner Losh <imp@bsdimp.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm@nongnu.org, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20210506133758.1749233-1-philmd@redhat.com>
 <CANCZdfqiHxQoG+g3bq_KL01yWCHUbF5qxJWN=sD37h7UJFMZ7g@mail.gmail.com>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <476d8b44-cba3-4bf2-d93c-d35736d316c6@redhat.com>
Date:   Thu, 6 May 2021 09:28:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CANCZdfqiHxQoG+g3bq_KL01yWCHUbF5qxJWN=sD37h7UJFMZ7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/21 9:22 AM, Warner Losh wrote:
> On Thu, May 6, 2021 at 7:39 AM Philippe Mathieu-Daudé <philmd@redhat.com>
> wrote:
> 
>> The ALLOCA(3) man-page mentions its "use is discouraged".
>> Replace few calls by equivalent GLib malloc().
>>
> 
> Except g_alloc and g_malloc are not at all the same, and you can't drop in
> replace one with the other.
> 
> g_alloc allocates stack space on the calling frame that's automatically
> freed when the function returns.
> g_malloc allocates space from the heap, and calls to it must be matched
> with calls to g_free().
> 
> These patches don't do the latter, as far as I can tell, and so introduce
> memory leaks unless there's something I've missed.

You missed the g_autofree, whose job is to call g_free() on all points
in the control flow where the malloc()d memory goes out of scope
(equivalent in expressive power to alloca()d memory going out of scope).
 Although the code is arguably a bit slower (as heap manipulations are
not as cheap as stack manipulations), in the long run that speed penalty
is worth the safety factor (since stack manipulations under user control
are inherently unsafe).

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

