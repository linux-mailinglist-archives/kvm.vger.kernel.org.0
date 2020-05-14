Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC511D28C9
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 09:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgENHdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 03:33:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35980 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725886AbgENHdJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 03:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589441587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O1oIEoI6SzJumJPHbrEuXX3CP3hhSQAVQ5TzQEpLuaQ=;
        b=fVstSI+r6vl9HHdJOgKtRRCVNNc6OtJwOoaVyhJcih22recll3fqowlfbL7iCPVCNbclO/
        sxkDI9VRQLc1lxOXkOpD46ne6WBQDR8PIUQIE8qxb8jbkPIzUHoVOLeYycHr+OY0CZp3lW
        iJWf0Ou6Cza9XeBJYIYWWmTdc/34EGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-gfFhpQbgNr2uUT0XaVjBDA-1; Thu, 14 May 2020 03:33:06 -0400
X-MC-Unique: gfFhpQbgNr2uUT0XaVjBDA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4527C474
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 07:33:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABDDE6E719;
        Thu, 14 May 2020 07:33:03 +0000 (UTC)
Date:   Thu, 14 May 2020 09:33:00 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        dgilbert@redhat.com
Subject: Re: [kvm-unit-tests PATCH] Always compile the kvm-unit-tests with
 -fno-common
Message-ID: <20200514073300.bxrxzowabqqx7thw@kamzik.brq.redhat.com>
References: <20200512095546.25602-1-thuth@redhat.com>
 <a87824f4-354a-3fb8-f91d-501e2fc5ece4@redhat.com>
 <d1fa1aae-f648-f734-e7e4-82deb8a60db6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1fa1aae-f648-f734-e7e4-82deb8a60db6@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 12:11:39PM +0200, Thomas Huth wrote:
> On 13/05/2020 12.05, Thomas Huth wrote:
> > On 12/05/2020 11.55, Thomas Huth wrote:
> >> The new GCC v10 uses -fno-common by default. To avoid that we commit
> >> code that declares global variables twice and thus fails to link with
> >> the latest version, we should also compile with -fno-common when using
> >> older versions of the compiler.
> >>
> >> Signed-off-by: Thomas Huth <thuth@redhat.com>
> >> ---
> >>  Makefile | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/Makefile b/Makefile
> >> index 754ed65..3ff2f91 100644
> >> --- a/Makefile
> >> +++ b/Makefile
> >> @@ -49,7 +49,7 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
> >>  cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> >>                > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> >>  
> >> -COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing
> >> +COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
> > 
> > Oh, wait, this breaks the non-x86 builds due to "extern-less" struct
> > auxinfo auxinfo in libauxinfo.h !
> > Drew, why isn't this declared in auxinfo.c instead?
> 
> Oh well, it's there ... so we're playing tricks with the linker here? I
> guess adding a "__attribute__((common, weak))" to auxinfo.h will be ok
> to fix this issue?

Right. In lib/auxinfo.h we have

/* No extern!  Define a common symbol.  */
struct auxinfo auxinfo;

Despite git-blame giving me credit for the 'No extern' comment (and the
missing 'extern'), I think Paolo made those changes when applying the
patch. I presume he did so to fix compilation on x86, for which I presume
the problem was that lib/argv.c references auxinfo, and that resulted
in an undefined symbol, since x86 doesn't link to auxinfo.o.

Unfortunately making the symbol weak won't work because if we add it
to the definition in auxinfo.h, then the linker prefers using its
own zero-initialized, global symbol. And, if we add the attribute
to the definition in auxinfo.c, then we still get the multiple
definition error.

So I'm not really sure what the best thing to do is. Maybe we
should just do this


diff --git a/lib/auxinfo.h b/lib/auxinfo.h
index 08b96f8ece4c..a46a1e6f6a62 100644
--- a/lib/auxinfo.h
+++ b/lib/auxinfo.h
@@ -13,7 +13,6 @@ struct auxinfo {
        unsigned long flags;
 };
 
-/* No extern!  Define a common symbol.  */
-struct auxinfo auxinfo;
+extern struct auxinfo auxinfo;
 #endif
 #endif
diff --git a/x86/Makefile.common b/x86/Makefile.common
index ab67ca0a9fda..2ea9c9f5bbcc 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -5,6 +5,7 @@ all: directories test_cases
 cflatobjs += lib/pci.o
 cflatobjs += lib/pci-edu.o
 cflatobjs += lib/alloc.o
+cflatobjs += lib/auxinfo.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc_page.o
 cflatobjs += lib/alloc_phys.o


Thanks,
drew

