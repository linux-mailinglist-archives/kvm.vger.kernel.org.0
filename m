Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6936639689A
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 22:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhEaUDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 16:03:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhEaUDU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 16:03:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622491279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dQKM5FY5nEKR01+BswbQiJ4Kg2QwcQMy5RqvhKiIl+4=;
        b=NZI7NYy/4HD55GlVvU80spOO+KrWRDhffjGdXB9PL++wsUAtFJhBLYmjcD4O0QQfE0cNBh
        ydAY65ayrfAeiobrkLlzoRJbrtS9GWO1vEg2xw+as7HgZZvibASioRSO9w7KzY1oFumWZs
        BzSwC2geCoFS5JtG0k9O72eDZu+LHvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-Ulpak-yLPXiH-QuZ3hRKSQ-1; Mon, 31 May 2021 16:01:18 -0400
X-MC-Unique: Ulpak-yLPXiH-QuZ3hRKSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CF4A801B13;
        Mon, 31 May 2021 20:01:17 +0000 (UTC)
Received: from localhost (ovpn-112-239.rdu2.redhat.com [10.10.112.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB6A35D9CD;
        Mon, 31 May 2021 20:01:16 +0000 (UTC)
Date:   Mon, 31 May 2021 16:01:16 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     qemu-devel@nongnu.org, armbru@redhat.com, dgilbert@redhat.com,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] target/i386/sev: add support to query the attestation
 report
Message-ID: <20210531200116.phfr6vo3penynb4f@habkost.net>
References: <20210429170728.24322-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210429170728.24322-1-brijesh.singh@amd.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 12:07:28PM -0500, Brijesh Singh wrote:
> The SEV FW >= 0.23 added a new command that can be used to query the
> attestation report containing the SHA-256 digest of the guest memory
> and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.
> 
> Note, we already have a command (LAUNCH_MEASURE) that can be used to
> query the SHA-256 digest of the guest memory encrypted through the
> LAUNCH_UPDATE. The main difference between previous and this command
> is that the report is signed with the PEK and unlike the LAUNCH_MEASURE
> command the ATTESATION_REPORT command can be called while the guest
> is running.
> 
> Add a QMP interface "query-sev-attestation-report" that can be used
> to get the report encoded in base64.
> 
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Eric Blake <eblake@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Reviewed-by: James Bottomley <jejb@linux.ibm.com>
> Tested-by: James Bottomley <jejb@linux.ibm.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
[...]
> +    gsize len;
[...]
> +    /* verify the input mnonce length */
> +    if (len != sizeof(input.mnonce)) {
> +        error_setg(errp, "SEV: mnonce must be %ld bytes (got %ld)",
> +                sizeof(input.mnonce), len);

This breaks the build on i386.  Failed CI job:
https://gitlab.com/ehabkost/qemu/-/jobs/1300032082

I'm applying the following fixup.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 12899a31736..0e135d56e53 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -517,7 +517,7 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
 
     /* verify the input mnonce length */
     if (len != sizeof(input.mnonce)) {
-        error_setg(errp, "SEV: mnonce must be %ld bytes (got %ld)",
+        error_setg(errp, "SEV: mnonce must be %ld bytes (got %" G_GSIZE_FORMAT ")",
                 sizeof(input.mnonce), len);
         g_free(buf);
         return NULL;

-- 
Eduardo

