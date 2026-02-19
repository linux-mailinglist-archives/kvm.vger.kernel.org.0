Return-Path: <kvm+bounces-71347-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qDCGLSrolmmNqwIAu9opvQ
	(envelope-from <kvm+bounces-71347-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:38:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 384A915DE8B
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E8FE302D51C
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 10:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2432B337107;
	Thu, 19 Feb 2026 10:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IMvTI7vh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qIsEgonr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4306E30F94E
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 10:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771497409; cv=none; b=BRT90z1m4peEhvGSUhz1kORTubft5Iw3bSHywK35WE5RW4FXVGWh36boI0Satpja5feqeTIAI6IEuc4HpBEx0EXthkkGn9lT+Mz94aXGuhxp+3cA1pEMH683D6ouikN4EmvevykK/HtlaU3831soGUFyk2HFiMDzTQZRgvOAiaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771497409; c=relaxed/simple;
	bh=oqw0KlNKIPYnEI20309wgxqKSge7eobGKUbr1LdjuGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPTBxFAtxZtqIdOBBve6RmkYGH3uGQmVjUh4SObvA1orsg1wiPNmKk/5vseOgftavHzqiRyhTd6VsmmwTkV0pugqak4ioGp6tvbX29mSz0ZXwEpcq4UQGJZkMtyE3/hZPtOGTPS5aMeFS/zeASGZt0KTb4OWO0UyTTe+OKoC244=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IMvTI7vh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qIsEgonr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771497406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0HuCXThfRUEeEl7yH4RijL3+g7m+evVIDET2wFtyGPA=;
	b=IMvTI7vhk3vuRkMM2kkV41ium5VGv7PT9IoyOLKQfO/Eu8PZ5TdwKuDhseOAlr5k5vvo12
	b1/S3HPV55lD4FePO7TyemdOfj4e8w2Y1lh3/O1oE2Zxw0PoCyKtTEzgcH7w49ej97W6oF
	WOjlcHbTBcQNG0DsJ2XQeW5Kr6iENdE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-tBsvzH_gMwGImeXGupdKZw-1; Thu, 19 Feb 2026 05:36:45 -0500
X-MC-Unique: tBsvzH_gMwGImeXGupdKZw-1
X-Mimecast-MFC-AGG-ID: tBsvzH_gMwGImeXGupdKZw_1771497404
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48378df3469so8101685e9.1
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 02:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771497404; x=1772102204; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0HuCXThfRUEeEl7yH4RijL3+g7m+evVIDET2wFtyGPA=;
        b=qIsEgonrPfvZJWqC1SF7flDp7dYt/nEHIjpY99Jbl9Yo4ZoBYfcrfBxW98RFMYJStX
         OhWdWkrrmR7WZe1IoL+EnvtqZyDTl5catuoBvtFPloxY/FDnMEW4aySa9FLP3I+23f6w
         AQVPSUQZcFHfTcJurL3NXkg5ArIZZt22k7TQ/WeBEreojzEvkvBTguymSNbQOBciACG0
         IuVknXHwPhcfjTQegTSKy6f7mp3eMYtKk2puiPpfKWRr1jhAdat/JTLt+3zgvTlsH9vs
         uw9UGWpTEBDOLfX/KaVNCH9rWBOuI6o22LJpmnBKjXJoBwHlfuO0lzW/fF0yksVGrL+L
         P/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771497404; x=1772102204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0HuCXThfRUEeEl7yH4RijL3+g7m+evVIDET2wFtyGPA=;
        b=PJsYT+SWa0s001av31puLPFMscmnpTjDTm3/vWr3A14JdNYZXz3kC78KHHejOmcT80
         vxUkl2Tult3sb7UCVC+bA/Pgb3ObD1j3M/uBkOqt2azh/A0MdpDH1KQqOLcV6jIMlxbo
         7YvOjjVleumP/TUJaTYOTK7fyK/4RhZoVK57RtM1AHrjXlixFVAhgUGg+CXOOsjLQ7EB
         AzqjNeZYHmhmc0Po7mEu6FBiHq0UcCkdLT+sK/BfCjw6m8brw+Dav0JCnLXsRRz46W7e
         0a4J7VJJKjFakbaLiQbswx2j3o7peeQJpc0VG1+3++iKTH0f0WlyK3JxOan0L4eZGncG
         UnLg==
X-Forwarded-Encrypted: i=1; AJvYcCWfIoWPJMVSPwuQYFwXRlrk3Z6qVDMBJMlZZiHWNrMBTKZvEQjRHS73Q9oNISSL7nIoDkU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXyKEIVSPVIt0A6VIbO0ZCjhGkFgAAh1U1VpOl8YJTIFEy6NGD
	VAOD+BP/TrZDS5PPNvxqrql0dO7DEz7bzPETUcop0ZqcJxvT3l+mz5g6Lcw3bpNreq0hpFYNy0V
	2DkMOfbAXttVAnJeHUpQrGnlyBCJuIXEQglvVxndGeHoHpse2hG14Ew==
X-Gm-Gg: AZuq6aIsokqSUqujs+IH2vuf99lCLN1anK2izFZz2MnxFs34c+3zJ+nw5uG41aObscT
	LabaMtlQYlGtIq2PIIPEulZqxUifWdaaEb1gq6brqKf2dv/aAP/byGZPpr8etJcJNpzv7JVQS2p
	VeDjnhfbODs1R1bO2NnvlrWioS2bbkT9ijS8iFaNvCcWcqfp47AdShGIJ46Q7ralmDWB8ap35Wa
	xzKjP1Eu9Z4E2LNjbJSMLabuovLJigKTq3JWWz9ILnriKuGQsw3YmN06Zbi8vo6xOcaWcZY6TJx
	z9VzJyJQKmAkNCHncLbbN/QWX5DqpP7eakZR1Dwyz2lmKRbo8wwFeK7994ZtBCXT5003iBo65lP
	l4W3X6uDRYPjfHhFfcqLx3w5j5ZxSj72jjJTMCgefiK93v/FTSbwG4HQI2XG04pSikuLixU8=
X-Received: by 2002:a05:600c:214b:b0:47e:e051:79ee with SMTP id 5b1f17b1804b1-4839fe90522mr18467535e9.3.1771497403793;
        Thu, 19 Feb 2026 02:36:43 -0800 (PST)
X-Received: by 2002:a05:600c:214b:b0:47e:e051:79ee with SMTP id 5b1f17b1804b1-4839fe90522mr18467255e9.3.1771497403315;
        Thu, 19 Feb 2026 02:36:43 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839f99067dsm17354955e9.29.2026.02.19.02.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 02:36:42 -0800 (PST)
Date: Thu, 19 Feb 2026 11:36:40 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH net v2 3/3] vsock: document write-once behavior of the
 child_ns_mode sysctl
Message-ID: <aZbN8fXtCkhItSV8@sgarzare-redhat>
References: <20260218-vsock-ns-write-once-v2-0-19e4c50d509a@meta.com>
 <20260218-vsock-ns-write-once-v2-3-19e4c50d509a@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260218-vsock-ns-write-once-v2-3-19e4c50d509a@meta.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71347-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 384A915DE8B
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 10:10:38AM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Update the vsock child_ns_mode documentation to include the new the

nit: s/the new the/the new

>write-once semantics of setting child_ns_mode. The semantics are
>implemented in a different patch in this series.

s/different/preceding ?

IMO this can be squashed with the previous patch, but not sure netdev 
policy about that. Not a strong opinion, it's fine also in this way.

>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
> Documentation/admin-guide/sysctl/net.rst | 10 +++++++---
> 1 file changed, 7 insertions(+), 3 deletions(-)
>
>diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
>index c10530624f1e..976a176fb451 100644
>--- a/Documentation/admin-guide/sysctl/net.rst
>+++ b/Documentation/admin-guide/sysctl/net.rst
>@@ -581,9 +581,9 @@ The init_net mode is always ``global``.
> child_ns_mode
> -------------
>
>-Controls what mode newly created child namespaces will inherit. At namespace
>-creation, ``ns_mode`` is inherited from the parent's ``child_ns_mode``. The
>-initial value matches the namespace's own ``ns_mode``.
>+Write-once. Controls what mode newly created child namespaces will inherit. At
>+namespace creation, ``ns_mode`` is inherited from the parent's
>+``child_ns_mode``. The initial value matches the namespace's own ``ns_mode``.
>
> Values:
>
>@@ -594,6 +594,10 @@ Values:
> 	  their sockets will only be able to connect within their own
> 	  namespace.
>
>+``child_ns_mode`` can only be written once per namespace. Writing the same
>+value that is already set succeeds. Writing a different value after the first
>+write returns ``-EBUSY``.

nit: instead of saying that it can only be written once, we could say 
that the first write locks the value, to be closer to the actual 
behavior, something like this: 

   The first write to ``child_ns_mode`` locks its value. Subsequent
   writes of the same value succeed, but writing a different value
   returns ``-EBUSY``.


Thanks,
Stefano

>+
> Changing ``child_ns_mode`` only affects namespaces created after the change;
> it does not modify the current namespace or any existing children.
>
>
>-- 
>2.47.3
>


