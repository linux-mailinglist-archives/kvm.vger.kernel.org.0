Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1E91D0F43
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 12:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733291AbgEMKGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 06:06:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55412 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387964AbgEMKGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 06:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589364360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=DLGbJahrrL8VrV4mfFdC2u/d/M4UWENNrLbjxLKEuPo=;
        b=OjdsvONN/zFmU/xSIePpR/EXTJJyVbCnmcEKyRmOwXFf1zR/O01qb8LLrTMhm0O+y+6jlX
        tY/tVvOXMFYp5E50vU4uXul1LQus2yLZC9ICRR/y7tWyo7cEKyoGlq4WEjkGGaOGx9mstP
        Stg7XkhIWDmIZ2OiSSW/5eTZs6CyBoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-Zh_xW2foOwasE9968lJ9eA-1; Wed, 13 May 2020 06:05:58 -0400
X-MC-Unique: Zh_xW2foOwasE9968lJ9eA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBE4D835B57
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 10:05:57 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-100.ams2.redhat.com [10.36.114.100])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CB916E6ED;
        Wed, 13 May 2020 10:05:55 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] Always compile the kvm-unit-tests with
 -fno-common
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     dgilbert@redhat.com
References: <20200512095546.25602-1-thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a87824f4-354a-3fb8-f91d-501e2fc5ece4@redhat.com>
Date:   Wed, 13 May 2020 12:05:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200512095546.25602-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/2020 11.55, Thomas Huth wrote:
> The new GCC v10 uses -fno-common by default. To avoid that we commit
> code that declares global variables twice and thus fails to link with
> the latest version, we should also compile with -fno-common when using
> older versions of the compiler.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 754ed65..3ff2f91 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -49,7 +49,7 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
>  cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
>                > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
>  
> -COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing
> +COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common

Oh, wait, this breaks the non-x86 builds due to "extern-less" struct
auxinfo auxinfo in libauxinfo.h !
Drew, why isn't this declared in auxinfo.c instead?

 Thomas

