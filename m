Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9CE14F0CF
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgAaQpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:45:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45919 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726252AbgAaQpC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 11:45:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580489100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=TihLNLmjb7y8d3ZBJjamxgejnp6YMci6wniGb1P3nUM=;
        b=XZTRNOJ0p52UXeJ7izB5o01zLwjErXA9eNhXVMyatRchGkJGNKka1eZmkjtAAZmPXRJsAj
        Q2JlgC5NAjGgYtBfNt/1Uz6TbP0wJkpJK+TjjRrFS6xj70tlCxHJfMsYk/O5+LKloDcd3A
        /uxMsOOultFCgqE9jeF+U5whT7+4Zvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-imisJb5oOq6kRY6IX_SAyQ-1; Fri, 31 Jan 2020 11:44:58 -0500
X-MC-Unique: imisJb5oOq6kRY6IX_SAyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC5048017CC;
        Fri, 31 Jan 2020 16:44:56 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-176.ams2.redhat.com [10.36.116.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FA5587B07;
        Fri, 31 Jan 2020 16:44:51 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 01/10] Makefile: Use no-stack-protector
 compiler options
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com, Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
 <20200131163728.5228-2-alexandru.elisei@arm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3cc15ac0-aa81-9504-d63e-04f6702379f3@redhat.com>
Date:   Fri, 31 Jan 2020 17:44:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200131163728.5228-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/01/2020 17.37, Alexandru Elisei wrote:
> Let's fix the typos so that the -fno-stack-protector and
> -fno-stack-protector-all compiler options are actually used.
> 
> Tested by compiling for arm64, x86_64 and ppc64 little endian. Before the
> patch, the arguments were missing from the gcc invocation; after the patch,
> they were present. Also fixes a compilation error that I was seeing with
> aarch64 gcc version 9.2.0, where the linker was complaining about an
> undefined reference to the symbol __stack_chk_guard.
> 
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Drew Jones <drjones@redhat.com>
> CC: Laurent Vivier <lvivier@redhat.com>
> CC: Thomas Huth <thuth@redhat.com>
> CC: David Hildenbrand <david@redhat.com>
> CC: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 767b6c6a51d0..754ed65ecd2f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -55,8 +55,8 @@ COMMON_CFLAGS += -Wignored-qualifiers -Werror
>  
>  frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
>  fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
> -fnostack_protector := $(call cc-option, -fno-stack-protector, "")
> -fnostack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
> +fno_stack_protector := $(call cc-option, -fno-stack-protector, "")
> +fno_stack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
>  wno_frame_address := $(call cc-option, -Wno-frame-address, "")
>  fno_pic := $(call cc-option, -fno-pic, "")
>  no_pie := $(call cc-option, -no-pie, "")

Ouch, very well spotted.

Fixes: e5c73790f5f0 ("build: don't reevaluate cc-option shell command")

Reviewed-by: Thomas Huth <thuth@redhat.com>

