Return-Path: <kvm+bounces-67706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA40D11960
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:46:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C19E3149047
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70BA34C99D;
	Mon, 12 Jan 2026 09:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cdGhok0E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01FC34AAF7
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768210878; cv=none; b=kok+ajS2QQD5Xsq6xwT2TOh8NR+UEM3sohqRG1yGpt1Gmeo0FgfuTsqhGLIK4rxVru1yMb4t3lRpZvnUHG59deymwE1hDtmvQQH5Z0xXMxwu8bTGu9Xv9K5VChWnBvg6aa/iMCL0nQCQMErRjvnftk5jfFNobN1R2S5UIVCozLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768210878; c=relaxed/simple;
	bh=QGaoaFAWgZgEYY59YQtWVmULZz8EXhlO9MR3ixZfQeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1YXYiA8A4uTyklOZC2I3fcTdM2TEv4JV6Ai5NXWb5e+ZdKxpkKyuVKPqUfwD5fzQ9PBUcXm+KIOqpk2vyIPRBq1uK+Z5QrigtvMNUnoAEw5uUIfOaP+dxxpiLPvW317NKEYWSBExbKYfDPfPgmkobQmVe+9v/3ZsepF5nUqNJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cdGhok0E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768210869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fVWNqVBXTPvbk1CqC9J9VGD6+9BKoq2AGZJ4Xi5ObAQ=;
	b=cdGhok0EP0bhE8kZLVVpJ0QEpCAWG2TIDM4TpkieEDJA/hs1dIsZ57bcN4PL+75K0nlVFa
	ntNe5jDRr71iLIINsFONWRDOtgfD+snOKTN1vckGj14GKKK/VauctfZVtBjoNhIBkdAOYA
	SMw0gLj9PkTQSD65e3YcZgokXzwEfxs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-F1haZB_xNk-OO7E8ipy1tw-1; Mon,
 12 Jan 2026 04:41:06 -0500
X-MC-Unique: F1haZB_xNk-OO7E8ipy1tw-1
X-Mimecast-MFC-AGG-ID: F1haZB_xNk-OO7E8ipy1tw_1768210864
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A810F1800378;
	Mon, 12 Jan 2026 09:41:04 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.45.224.56])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD84E180066A;
	Mon, 12 Jan 2026 09:41:03 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 8623E1800081; Mon, 12 Jan 2026 10:41:01 +0100 (CET)
Date: Mon, 12 Jan 2026 10:41:01 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Luigi Leonardi <leonardi@redhat.com>
Cc: Oliver Steffen <osteffen@redhat.com>, qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Zhao Liu <zhao1.liu@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, 
	Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v3 3/6] igvm: Add missing NULL check
Message-ID: <aWTBdSDO9KKpXLt4@sirius.home.kraxel.org>
References: <20260109143413.293593-1-osteffen@redhat.com>
 <20260109143413.293593-4-osteffen@redhat.com>
 <CANo9s6muvcOrDH286o1zA06tRUvZBnOBqn03e0RiOEDC60W4sg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANo9s6muvcOrDH286o1zA06tRUvZBnOBqn03e0RiOEDC60W4sg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Fri, Jan 09, 2026 at 06:37:04PM +0100, Luigi Leonardi wrote:
> On Fri, Jan 09, 2026 at 03:34:10PM +0100, Oliver Steffen wrote:
> >Check for NULL pointer returned from igvm_get_buffer().
> >Documentation for that function calls for that unconditionally.
> >
> >Signed-off-by: Oliver Steffen <osteffen@redhat.com>
> >---
> > backends/igvm.c | 13 ++++++++++---
> > 1 file changed, 10 insertions(+), 3 deletions(-)
> >
> >diff --git a/backends/igvm.c b/backends/igvm.c
> >index a350c890cc..dc1fd026cb 100644
> >--- a/backends/igvm.c
> >+++ b/backends/igvm.c
> >@@ -170,9 +170,16 @@ static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
> >                 (int)header_handle);
> >             return -1;
> >         }
> >-        header_data = igvm_get_buffer(ctx->file, header_handle) +
> >-                      sizeof(IGVM_VHS_VARIABLE_HEADER);
> >-        result = handlers[handler].handler(ctx, header_data, errp);
> >+        header_data = igvm_get_buffer(ctx->file, header_handle);
> >+        if (header_data == NULL) {
> >+            error_setg(
> >+                errp,
> >+                "IGVM: Failed to get directive header data (code: %d)",
> >+                (int)header_handle);
> >+            result = -1;
> >+        } else {
> >+            result = handlers[handler].handler(ctx, header_data + sizeof(IGVM_VHS_VARIABLE_HEADER), errp);
> >+        }
> >         igvm_free_buffer(ctx->file, header_handle);
> >         return result;
> >     }
> >-- 2.52.0
> >
> 
> IMHO this should be sent a separate patch

Huh?  It /is/ a separate patch ...

> with the Fixes tag as you are
> fixing a bug.

That makes sense indeed.

take care,
  Gerd


