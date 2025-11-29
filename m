Return-Path: <kvm+bounces-64950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A451EC938C7
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 08:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B836D3A8BEE
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 07:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6486B2609E3;
	Sat, 29 Nov 2025 07:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Axk6Wptp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19AB36D51F
	for <kvm@vger.kernel.org>; Sat, 29 Nov 2025 07:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764400024; cv=none; b=MPUqhiVWsdlSyStJa7fOr1BLRMAOT2VWq6kMQZabTsvZ/T/+P3RHGTJDW8byg+qsZ7urMB+Ds+K2oT4dxgipCXWchIiG57gvFqqZDBLfwwJnCfhMcUjHBuc5nyMmE27FzfYedLcnNl+bs7G4TS8ANx8Ozt1Vy/WCjB8P/f60OaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764400024; c=relaxed/simple;
	bh=u/yobGlLoD+iF8ZGuj6LFsJNNxcnFr2fwWoOL2xD4fc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UWJapIE/BTcrO90zAYPR/Z7uHHIQ5WOSrlt+eeTus6s4DgyXARfmRzK+Zmt/3uhTBbBZOijIhDz1fbpSEqw2DFjzzan0xv/fe4li2myLk4d998+DyJUu6cUs1116Q1vi25T6yaalhnZwSk/5hADq/E8n8mLO4k/M/1tPN0eV8w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Axk6Wptp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764400021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u/yobGlLoD+iF8ZGuj6LFsJNNxcnFr2fwWoOL2xD4fc=;
	b=Axk6Wptpn4hSmE98yzPqoaYi1fNAXxFiL6lGdSaBoKl/GvOY/y9yFjPEVh6GYsZfot5N90
	9FjdHCQWQ4LYTgO2Dz1K7McrPtno2daHM0sOCao6XDMrceeY5vemoFpSPx6nfFd/PWppI8
	OXorXem82kI0L15qSk23gwNAi9giKL0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-379-REa04DDtP4aHm6GplPcSGQ-1; Sat,
 29 Nov 2025 02:06:59 -0500
X-MC-Unique: REa04DDtP4aHm6GplPcSGQ-1
X-Mimecast-MFC-AGG-ID: REa04DDtP4aHm6GplPcSGQ_1764400019
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A61241956088;
	Sat, 29 Nov 2025 07:06:58 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.7])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F31C1800451;
	Sat, 29 Nov 2025 07:06:58 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 7892E21E6A27; Sat, 29 Nov 2025 08:06:55 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,  kvm@vger.kernel.org,  eesposit@redhat.com
Subject: Re: [PATCH] kvm: Don't assume accel_ioctl_end() preserves @errno
In-Reply-To: <20251125090146.2370735-1-armbru@redhat.com> (Markus Armbruster's
	message of "Tue, 25 Nov 2025 10:01:46 +0100")
References: <20251125090146.2370735-1-armbru@redhat.com>
Date: Sat, 29 Nov 2025 08:06:55 +0100
Message-ID: <878qfpz59s.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Superseded by

Subject: [PATCH v2] kvm: Fix kvm_vm_ioctl() and kvm_device_ioctl() return value
Date: Fri, 28 Nov 2025 16:20:50 +0100
Message-ID: <20251128152050.3417834-1-armbru@redhat.com>


