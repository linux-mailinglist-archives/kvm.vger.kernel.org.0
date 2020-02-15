Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D792C15FD4A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 08:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgBOHIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 02:08:05 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60180 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgBOHIF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 15 Feb 2020 02:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581750484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zIb8+aqnYxJcXqYlZxyjtYT62t7sFKGEz0i+5pIOLxw=;
        b=dZ+gEqz7HKipH1xrB1N8dDndWrXKxLEzjBqEmBeUcNk9mpzzeQVZ8FbTOcFseC2nbxW/O5
        PWl7wS9AedXbuEOwvhUZU9SgDj9NaHi0i+w493gDBgHnqnEFvlp30p0L3g6+GO3TlxgUK0
        4qn/qGdgskqhnYGO618bFWRuFHU7R7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-LDJgMnFzPW2kEtLMJ7PEPA-1; Sat, 15 Feb 2020 02:08:00 -0500
X-MC-Unique: LDJgMnFzPW2kEtLMJ7PEPA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53E50100550E;
        Sat, 15 Feb 2020 07:07:59 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C91FA5C114;
        Sat, 15 Feb 2020 07:07:55 +0000 (UTC)
Date:   Sat, 15 Feb 2020 08:07:52 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH 00/13] KVM: selftests: Various fixes and cleanups
Message-ID: <20200215070752.4fcymg7ruarfc4fc@kamzik.brq.redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
 <20200214222639.GB1195634@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214222639.GB1195634@xz-x1>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 05:26:39PM -0500, Peter Xu wrote:
> On Fri, Feb 14, 2020 at 03:59:07PM +0100, Andrew Jones wrote:
> > This series has several parts:
> > 
> >  * First, a hack to get x86 to compile. The missing __NR_userfaultfd
> >    define should be fixed a better way.
> 
> Yeh otherwise I think it will only compile on x86_64.

The opposite for me. I could compile on AArch64 without this hack, but on
x86 (my Fedora 30 laptop) I could not.

> 
> My gut feeling is we've got an artificial unistd_{32|64}.h under tools
> that is included rather than the real one that we should include
> (which should locate under $LINUX_ROOT/usr/include/asm/).  Below patch
> worked for me, but I'm not 100% sure whether I fixed all the current
> users of that artifact header just in case I'll break some (what I saw
> is only this evsel.c and another setns.c, while that setns.c has
> syscall.h included correct so it seems fine):

Yeah, there's something strange about it because I saw the definition in
the tools includes.

Thanks,
drew

> 
> diff --git a/tools/arch/x86/include/asm/unistd_32.h b/tools/arch/x86/include/asm/unistd_32.h
> deleted file mode 100644
> index 60a89dba01b6..000000000000
> --- a/tools/arch/x86/include/asm/unistd_32.h
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef __NR_perf_event_open
> -# define __NR_perf_event_open 336
> -#endif
> -#ifndef __NR_futex
> -# define __NR_futex 240
> -#endif
> -#ifndef __NR_gettid
> -# define __NR_gettid 224
> -#endif
> -#ifndef __NR_getcpu
> -# define __NR_getcpu 318
> -#endif
> -#ifndef __NR_setns
> -# define __NR_setns 346
> -#endif
> diff --git a/tools/arch/x86/include/asm/unistd_64.h b/tools/arch/x86/include/asm/unistd_64.h
> deleted file mode 100644
> index cb52a3a8b8fc..000000000000
> --- a/tools/arch/x86/include/asm/unistd_64.h
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef __NR_perf_event_open
> -# define __NR_perf_event_open 298
> -#endif
> -#ifndef __NR_futex
> -# define __NR_futex 202
> -#endif
> -#ifndef __NR_gettid
> -# define __NR_gettid 186
> -#endif
> -#ifndef __NR_getcpu
> -# define __NR_getcpu 309
> -#endif
> -#ifndef __NR_setns
> -#define __NR_setns 308
> -#endif
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index a69e64236120..f4075392dcb6 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -21,6 +21,7 @@
>  #include <sys/ioctl.h>
>  #include <sys/resource.h>
>  #include <sys/types.h>
> +#include <sys/syscall.h>
>  #include <dirent.h>
>  #include <stdlib.h>
>  #include <perf/evsel.h>
> 
> -- 
> Peter Xu
> 

