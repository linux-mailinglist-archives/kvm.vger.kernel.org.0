Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7311CECC9
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 08:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgELGBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 02:01:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56399 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725536AbgELGBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 02:01:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589263305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=8nWMqy78kOzqYhJ0RnElQhI7pSlx2XmPN4Fu9dXe/nw=;
        b=VE9C+iisdLSb7I8EKKSVg4Ilq+PeEUUXXegNHGCcwK7Rsolaww4W7wg6kn4x4K0YYSgXUK
        z3i39grpIjm4aY+x3Feebhy5ZvS7OIHvRzXiFObkuh2XMNRtXz9AnuebLymiZ72BG4Qwr7
        MGCjxLzGTycdkB9JodHvDkc54wjAGmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-lPpybB-LPGyN2tSteEl54A-1; Tue, 12 May 2020 02:01:43 -0400
X-MC-Unique: lPpybB-LPGyN2tSteEl54A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6A211005510
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 06:01:42 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-112.ams2.redhat.com [10.36.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8490860BF1;
        Tue, 12 May 2020 06:01:41 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] x86: avoid multiply defined symbol
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>
References: <20200511165959.42442-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3a74a455-6d58-900d-f38a-348539e8d389@redhat.com>
Date:   Tue, 12 May 2020 08:01:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200511165959.42442-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/2020 18.59, Paolo Bonzini wrote:
> Fedora 32 croaks about a symbol that is defined twice, fix it.
> 
> Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  lib/x86/fault_test.c |  2 +-
>  lib/x86/usermode.c   |  2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/x86/fault_test.c b/lib/x86/fault_test.c
> index 078dae3..e15a218 100644
> --- a/lib/x86/fault_test.c
> +++ b/lib/x86/fault_test.c
> @@ -1,6 +1,6 @@
>  #include "fault_test.h"
>  
> -jmp_buf jmpbuf;
> +static jmp_buf jmpbuf;
>  
>  static void restore_exec_to_jmpbuf(void)
>  {
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index f01ad9b..f032523 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -14,7 +14,7 @@
>  #define USERMODE_STACK_SIZE	0x2000
>  #define RET_TO_KERNEL_IRQ	0x20
>  
> -jmp_buf jmpbuf;
> +static jmp_buf jmpbuf;

Reviewed-by: Thomas Huth <thuth@redhat.com>

Seems like GCC v10 defaults to -fno-common now? Maybe we should add this
to the CFLAGS of the kvm-unit-tests, so that we get the same behavior
with all versions of the compiler?

 Thomas

