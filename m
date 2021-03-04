Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477F932D858
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 18:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239025AbhCDRJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 12:09:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239085AbhCDRJD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 12:09:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614877658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g78jleyct6Y4h1V/HBlVEU68RhFKMuqYYL2sGBU8pQU=;
        b=UWPtbN2A+R/wyR/avLHUEKG+BRs9DyzlXhmarqmQIpSgId6EoNUHmcj3kPuUvJr97c97s0
        sJrAAnCK6L42QYOYYMXfuQ7YiADk9VT3bkIxXpx5OtgrIolPEIXmH0aW7UiOtr4iI9yk/r
        yf+30yzhtvGcblPVKVNymbJe6xXUfII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-4onhNTUTO6u9Wlz3Xod8Gg-1; Thu, 04 Mar 2021 12:07:36 -0500
X-MC-Unique: 4onhNTUTO6u9Wlz3Xod8Gg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B127B1346DF;
        Thu,  4 Mar 2021 17:06:33 +0000 (UTC)
Received: from gondolin (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2704160C0F;
        Thu,  4 Mar 2021 17:06:28 +0000 (UTC)
Date:   Thu, 4 Mar 2021 18:06:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v4 0/6] CSS Mesurement Block
Message-ID: <20210304180626.18de1a9f.cohuck@redhat.com>
In-Reply-To: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  1 Mar 2021 12:46:59 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We tests the update of the Mesurement Block (MB) format 0
> and format 1 using a serie of senseid requests.
> 
> *Warning*: One of the tests for format-1 will unexpectedly fail for QEMU elf
> unless the QEMU patch "css: SCHIB measurement block origin must be aligned"
> is applied.
> With Protected Virtualization, the PGM is correctly recognized.
> 
> The MB format 1 is only provided if the Extended mesurement Block
> feature is available.
> 
> This feature is exposed by the CSS characteristics general features
> stored by the Store Channel Subsystem Characteristics CHSC command,
> consequently, we implement the CHSC instruction call and the SCSC CHSC
> command.
> 
> In order to ease the writing of new tests using:
> - interrupt
> - enablement of a subchannel
> - multiple I/O on a subchannel
> 
> We do the following simplifications:
> - we create a CSS initialization routine
> - we register the I/O interrupt handler on CSS initialization
> - we do not enable or disable a subchannel in the senseid test,
>   assuming this test is done after the enable test, this allows
>   to create traffic using the SSCH used by senseid.
> - we add a css_enabled() function to test if a subchannel is enabled.
> 
> @Connie, I restructured the patches but I did not modify the
> functionalities, so I kept your R-B, I hope you are OK with this.

Yes, that's fine with me.

> 
> Regards,
> Pierre
> 
> Pierre Morel (6):
>   s390x: css: Store CSS Characteristics
>   s390x: css: simplifications of the tests
>   s390x: css: extending the subchannel modifying functions
>   s390x: css: implementing Set CHannel Monitor
>   s390x: css: testing measurement block format 0
>   s390x: css: testing measurement block format 1
> 
>  lib/s390x/css.h     | 116 +++++++++++++++++++++-
>  lib/s390x/css_lib.c | 232 +++++++++++++++++++++++++++++++++++++++++---
>  s390x/css.c         | 228 +++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 542 insertions(+), 34 deletions(-)
> 

