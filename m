Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D644D397465
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 15:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhFANgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 09:36:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233797AbhFANf7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 09:35:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622554457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s5BnUVJUREQAF3ygqKJiUIsj3UNH9ZT21LBJhvMbwvA=;
        b=HXjkRP6jiqbnpC9u76+QSHX6c25/GAMHf6v//O37zX+h0608NSvggWAuuKpsT0DL0OVSjd
        gOHxOVbJER63+DN77fPHsggEmYw7tHHaoNpDhfjHD2Cqw39uVUl0+lxDZIJyoXuCX4I4ZO
        DX9H8+jH4z96tzWDJEQF32B7HYEIFqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-DRyoV5llNzGHklLRVGwNXw-1; Tue, 01 Jun 2021 09:34:16 -0400
X-MC-Unique: DRyoV5llNzGHklLRVGwNXw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15B23BBEE8;
        Tue,  1 Jun 2021 13:34:15 +0000 (UTC)
Received: from localhost (ovpn-112-239.rdu2.redhat.com [10.10.112.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEB875D9CD;
        Tue,  1 Jun 2021 13:34:14 +0000 (UTC)
Date:   Tue, 1 Jun 2021 09:34:14 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Tom Lendacky <Thomas.Lendacky@amd.com>, kvm@vger.kernel.org,
        armbru@redhat.com, James Bottomley <jejb@linux.ibm.com>,
        qemu-devel@nongnu.org, dgilbert@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] target/i386/sev: add support to query the attestation
 report
Message-ID: <20210601133414.rmwt725cv3ipejmk@habkost.net>
References: <20210429170728.24322-1-brijesh.singh@amd.com>
 <20210531200116.phfr6vo3penynb4f@habkost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210531200116.phfr6vo3penynb4f@habkost.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 04:01:16PM -0400, Eduardo Habkost wrote:
> On Thu, Apr 29, 2021 at 12:07:28PM -0500, Brijesh Singh wrote:
> > The SEV FW >= 0.23 added a new command that can be used to query the
> > attestation report containing the SHA-256 digest of the guest memory
> > and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.
> > 
> > Note, we already have a command (LAUNCH_MEASURE) that can be used to
> > query the SHA-256 digest of the guest memory encrypted through the
> > LAUNCH_UPDATE. The main difference between previous and this command
> > is that the report is signed with the PEK and unlike the LAUNCH_MEASURE
> > command the ATTESATION_REPORT command can be called while the guest
> > is running.
> > 
> > Add a QMP interface "query-sev-attestation-report" that can be used
> > to get the report encoded in base64.
> > 
> > Cc: James Bottomley <jejb@linux.ibm.com>
> > Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> > Cc: Eric Blake <eblake@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Reviewed-by: James Bottomley <jejb@linux.ibm.com>
> > Tested-by: James Bottomley <jejb@linux.ibm.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > ---
> [...]
> > +    gsize len;
> [...]
> > +    /* verify the input mnonce length */
> > +    if (len != sizeof(input.mnonce)) {
> > +        error_setg(errp, "SEV: mnonce must be %ld bytes (got %ld)",
> > +                sizeof(input.mnonce), len);
> 
> This breaks the build on i386.  Failed CI job:
> https://gitlab.com/ehabkost/qemu/-/jobs/1300032082
> 
> I'm applying the following fixup.
> 
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 12899a31736..0e135d56e53 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -517,7 +517,7 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
>  
>      /* verify the input mnonce length */
>      if (len != sizeof(input.mnonce)) {
> -        error_setg(errp, "SEV: mnonce must be %ld bytes (got %ld)",
> +        error_setg(errp, "SEV: mnonce must be %ld bytes (got %" G_GSIZE_FORMAT ")",
>                  sizeof(input.mnonce), len);
>          g_free(buf);
>          return NULL;

The fix was incomplete, additional fixup was required.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
diff --git a/0e135d56e53 b/target/i386/sev.c
index 0e135d56e53..1a88f127035 100644
--- a/0e135d56e53
+++ b/target/i386/sev.c
@@ -517,7 +517,7 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
 
     /* verify the input mnonce length */
     if (len != sizeof(input.mnonce)) {
-        error_setg(errp, "SEV: mnonce must be %ld bytes (got %" G_GSIZE_FORMAT ")",
+        error_setg(errp, "SEV: mnonce must be %zu bytes (got %" G_GSIZE_FORMAT ")",
                 sizeof(input.mnonce), len);
         g_free(buf);
         return NULL;

-- 
Eduardo

