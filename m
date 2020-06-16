Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1372C1FB5D8
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 17:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgFPPRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 11:17:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55265 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728183AbgFPPRM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 11:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592320631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7i5Wgsj2foti853YuNVSpjJA3I6jLBetTxTlliNAbvU=;
        b=VPdUuS5Kb326WbSRcCmHfA3ARdOEe/OudNi5IZfTlWD3QY1mIVAFdRPh7oLX9D0y05tiK7
        3pzI2qFS4CYZHu9TK8YqI5xcqjHsTza/O7atb13HnwfqEFiBKqEkTy64/FqEvatqsyF2jj
        s3NzN+iA6abPmRRokzf0orfzL+UbZbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-JdriV0KjNnqRKXhq3GnW1w-1; Tue, 16 Jun 2020 11:17:06 -0400
X-MC-Unique: JdriV0KjNnqRKXhq3GnW1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F3498DEEC0
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 15:17:06 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ED8A79308;
        Tue, 16 Jun 2020 15:17:05 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] x86: disable SSE on 32-bit hosts
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200616140217.104362-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <84a04af0-ea52-31a5-eb9f-d29fc5d7df51@redhat.com>
Date:   Tue, 16 Jun 2020 17:17:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200616140217.104362-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/2020 16.02, Paolo Bonzini wrote:
> On 64-bit hosts we are disabling SSE and SSE2.  Depending on the
> compiler however it may use movq instructions for 64-bit transfers
> even when targeting 32-bit processors; when CR4.OSFXSR is not set,
> this results in an undefined opcode exception, so tell the compiler
> to avoid those instructions on 32-bit hosts as well.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/Makefile.i386 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
> index d801b80..be9d6bc 100644
> --- a/x86/Makefile.i386
> +++ b/x86/Makefile.i386
> @@ -1,6 +1,7 @@
>  cstart.o = $(TEST_DIR)/cstart.o
>  bits = 32
>  ldarch = elf32-i386
> +COMMON_CFLAGS += -mno-sse -mno-sse2

That's likely a good idea, but it still does not fix the problem in the
gitlab-ci:

 https://gitlab.com/huth/kvm-unit-tests/-/jobs/597747782#L1934

?

 Thomas

