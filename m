Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00F52CA0DF
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 12:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgLALFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 06:05:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727591AbgLALFH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 06:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606820621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lcOj7fkQipCIlpc5MBpXx4VRVwWSoBEvFgRn9IvZnQs=;
        b=VwzwycQQ0KsH3hsY6IguF00x4G8gXWsNLGWsGABkJ/9wBQVmFXupaM2HHKHW4VsGsg2SEm
        mCSY89BmeblJniBodZpSCbZMz3vaeLfNaZWeBVtbdRv1eBg7zNgfWvVux4QWvwY7pXUgZm
        KEpYs9yl1asyQcHaLCtDjo38R6EG5bE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-PTDgUR51OGqzjinoyqlbcQ-1; Tue, 01 Dec 2020 06:03:39 -0500
X-MC-Unique: PTDgUR51OGqzjinoyqlbcQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A248B108E1A0;
        Tue,  1 Dec 2020 11:03:37 +0000 (UTC)
Received: from work-vm (ovpn-115-1.ams2.redhat.com [10.36.115.1])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B9B75D973;
        Tue,  1 Dec 2020 11:03:04 +0000 (UTC)
Date:   Tue, 1 Dec 2020 11:03:02 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, qemu-devel@nongnu.org, rth@twiddle.net,
        armbru@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: Re: [PATCH 01/11] memattrs: add debug attribute
Message-ID: <20201201110302.GC4338@work-vm>
References: <cover.1605316268.git.ashish.kalra@amd.com>
 <2ba88b512ec667eff66b2ece2177330a28e657c0.1605316268.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ba88b512ec667eff66b2ece2177330a28e657c0.1605316268.git.ashish.kalra@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Ashish Kalra (Ashish.Kalra@amd.com) wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Extend the MemTxAttrs to include a 'debug' flag. The flag can be used as
> general indicator that operation was triggered by the debugger.
> 
> A subsequent patch will set the debug=1 when issuing a memory access
> from the gdbstub or HMP commands. This is a prerequisite to support
> debugging an encrypted guest. When a request with debug=1 is seen, the
> encryption APIs will be used to access the guest memory.

Is this also the flag that would be used for memory dumping?

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  include/exec/memattrs.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/exec/memattrs.h b/include/exec/memattrs.h
> index 95f2d20d55..c8b56389d6 100644
> --- a/include/exec/memattrs.h
> +++ b/include/exec/memattrs.h
> @@ -49,6 +49,8 @@ typedef struct MemTxAttrs {
>      unsigned int target_tlb_bit0 : 1;
>      unsigned int target_tlb_bit1 : 1;
>      unsigned int target_tlb_bit2 : 1;
> +    /* Memory access request from the debugger */
> +    unsigned int debug:1;

It might be good to clarify that this is for QEMU debug features, not
guest side debug features (e.g. CPU debug facilities/registers)

Dave

>  } MemTxAttrs;
>  
>  /* Bus masters which don't specify any attributes will get this,
> -- 
> 2.17.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

