Return-Path: <kvm+bounces-64477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B23A7C84209
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:04:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC4713AA72D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 09:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D2327472;
	Tue, 25 Nov 2025 09:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gTQ6pSfj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EA91F2BA4
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 09:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764061440; cv=none; b=ZGxw9/JjAaH8LWzznnN8IA2jhvd3ezJ3AhmkGDVTUj3Y7IdDYlGH/30tbOlDgI2Sgz6yjjuVZQaamdL3zfi1Cu0o5PMNN9Afz6gRk3BUBfvVYqwy/sfW5Xr/nzWvwkR3/8K07Bbi6BPRZf/Mnj7ouxEXUXvdbfNEQX6toxKX+nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764061440; c=relaxed/simple;
	bh=ATslwL++7jUFLXC0aJUdGh/rEvzGTFyXXufGCd7C6lw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TFHHxLkUx/n2Xcj8EmrPbYwzqdG6P0SDmac9OLuK4Bur9hk3AyCtq/YrAY2/wqTQpvnkwcEKD9S2DvxP4xCB1kyhq1DxEqg7Py8XDMFnfGZm5GnttFjXC5yOI30qHdC3NQiYk1bMy6UYyV9RaiOr3xUwVSVKQcxnvl0CpE0brT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gTQ6pSfj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764061438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RMafSR1cds8nCs0VUgDU3LN9z40ff6cPSpNdvknFmDY=;
	b=gTQ6pSfjK2fsRRsS0enkq3BqPWOBIRJ7+31HL4ahLBL3iA0aiKKztiwsGV+/GVANNy5rjV
	0mokJb9As55cMZvg4rFwXLN+MbEqNSlFPURH6rdxoJJiUP+PAErUrU3Hsr4bO5LIjcsKHO
	uYjHLBp492yVm3YOn7TH+bq7xx875KQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-600-7SMxLY00PIG5JAUBdQIdjw-1; Tue,
 25 Nov 2025 04:03:53 -0500
X-MC-Unique: 7SMxLY00PIG5JAUBdQIdjw-1
X-Mimecast-MFC-AGG-ID: 7SMxLY00PIG5JAUBdQIdjw_1764061433
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCCF31956096;
	Tue, 25 Nov 2025 09:03:52 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 832FF3003761;
	Tue, 25 Nov 2025 09:03:52 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DFD3621E6A27; Tue, 25 Nov 2025 10:03:49 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,  kvm@vger.kernel.org,  eesposit@redhat.com
Subject: Re: [PATCH] kvm: Don't assume accel_ioctl_end() preserves @errno
In-Reply-To: <20251125090146.2370735-1-armbru@redhat.com> (Markus Armbruster's
	message of "Tue, 25 Nov 2025 10:01:46 +0100")
References: <20251125090146.2370735-1-armbru@redhat.com>
Date: Tue, 25 Nov 2025 10:03:49 +0100
Message-ID: <875xay4h6y.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Markus Armbruster <armbru@redhat.com> writes:

> Retrieve the @errno set by ioctl() before we call accel_ioctl_end()
> instead of afterwards, so it works whether accel_ioctl_end() preserves
> @errno or not.
>
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

I did not check whether the assumption holds or not.  If it doesn't,
then this needs

  Fixes: a27dd2de68f3 (KVM: keep track of running ioctls)


