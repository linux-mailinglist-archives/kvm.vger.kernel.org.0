Return-Path: <kvm+bounces-66164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F67CC7695
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 12:46:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E14D330993BF
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19BD329C6B;
	Wed, 17 Dec 2025 11:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qmz/fZ/y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C6B2D7DCF
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 11:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765971852; cv=none; b=SdsnELycT8bQjR/uSjn4NNW8f3Cp7kQGhBouUkJaxLxEq+KVsEJ7TW2lWqQyb8E6eO1d/gvxggrzcfwxinfsrkuiWniqOPWe82EhQBWQYXP+n9v0tb/9IVtVsAbLMrpc8R1fP3jCb8SZ8GWQq9QyGMgNNFxo49k7gnZ6U6C85Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765971852; c=relaxed/simple;
	bh=jXPm1Uf2f56XOX3GHeLzCWAbUjN8TNN1Cj0Y1/2QNbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQelGeSfQHLQQ735c90k3APtS2F4kaP5QiBlOOymIXhWYqbbW/6N+42j06Gaxuy5IJLhMiYo/YLUAL3vqJqCoYeSfj/mCxNNbJSk36FLrAOr5zZjbyy0nYGNaxaYyGiyMTE8d8LW9DG8Ju9HwMwgB7CET+xQ4MxQ/9JoRUYtKaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qmz/fZ/y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765971850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=byYbQW2aOTVienLeGnmuCCWlLXqBV6cfpvW/+Acp7fA=;
	b=Qmz/fZ/yy3K3fj9rzXz5V4yKDjqgcWFrXE6X2jB2pVcJpqC0q6+vPaRPw9X1wvg5rr8zoS
	3JeB4Apn6sCmltGjC67RuyEFuP9bl5MEI9kqoEWYj6m1zBab2XgyBWjfy6nGDl/xDKcHO9
	OKQH5Z0lIs1ZEEHxxGenwJTglf+k9dE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-fGt1zVYEOneFoK8CoOhToQ-1; Wed,
 17 Dec 2025 06:44:07 -0500
X-MC-Unique: fGt1zVYEOneFoK8CoOhToQ-1
X-Mimecast-MFC-AGG-ID: fGt1zVYEOneFoK8CoOhToQ_1765971846
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1157C19560A5;
	Wed, 17 Dec 2025 11:44:06 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.32.156])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 951AA19560A7;
	Wed, 17 Dec 2025 11:44:05 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 48F861800869; Wed, 17 Dec 2025 12:44:03 +0100 (CET)
Date: Wed, 17 Dec 2025 12:44:03 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, vkuznets@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 15/28] i386/sev: add migration blockers only once
Message-ID: <aas37tpm2yrqueip7mhgqd7lzy5f3ckk6zrt73bzq6dawpjoox@47o27xg5acqt>
References: <20251212150359.548787-1-anisinha@redhat.com>
 <20251212150359.548787-16-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212150359.548787-16-anisinha@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Dec 12, 2025 at 08:33:43PM +0530, Ani Sinha wrote:
> sev_launch_finish() and sev_snp_launch_finish() could be called multiple times
> if the confidential guest is capable of being reset/rebooted. The migration
> blockers should not be added multiple times, once per invocation. This change
> makes sure that the migration blockers are added only one time and not every
> time upon invocvation of launch_finish() calls.

> +    static bool added_migration_blocker;

> -    error_setg(&sev_mig_blocker,
> -               "SEV: Migration is not implemented");
> -    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
> +    if (!added_migration_blocker) {
> +        /* add migration blocker */
> +        error_setg(&sev_mig_blocker,
> +                   "SEV: Migration is not implemented");
> +        migrate_add_blocker(&sev_mig_blocker, &error_fatal);
> +        added_migration_blocker = true;
> +    }

Maybe move this to another place which is called only once?  The
migration blocker should not be very sensitive to initialization
ordering, so I'd expect finding another place where you don't need
the added_migration_blocker tracker variable isn't too much of a
problem.

take care,
  Gerd


