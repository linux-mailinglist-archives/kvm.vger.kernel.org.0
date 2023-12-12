Return-Path: <kvm+bounces-4177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA0E980EA78
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 12:36:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4971F2818DD
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 11:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ABF55D4A9;
	Tue, 12 Dec 2023 11:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UT+5bmx1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDC3DB
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 03:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702380975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EGnpxUAOKJvQ5yj7auibEiwdxsGADfxTRWtP2NS46qA=;
	b=UT+5bmx1zx5YHjdX3Jxo98oCaKfH2CPb9BdPtWyj3ehuCckgLNrMsC2+rvbA9znHroPrto
	g6Gc7Jl3WRYWFvyYRR4ACs/LJUpkjPlrtr+ic2GqC1h0FcQKubphtjH1Xq1iaPzefhl9kv
	46EdcQ6KX6bfEpQzAUI0Trp7dHjlVXo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-AxlQqKtfONC0j5NPcHQspg-1; Tue, 12 Dec 2023 06:36:12 -0500
X-MC-Unique: AxlQqKtfONC0j5NPcHQspg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A821283DDE2;
	Tue, 12 Dec 2023 11:36:11 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59402492BE6;
	Tue, 12 Dec 2023 11:36:11 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui
 Yu <yuzenghui@huawei.com>, broonie@kernel.org, Oliver Upton
 <oliver.upton@linux.dev>
Subject: Re: [PATCH] KVM: selftests: Ensure sysreg-defs.h is generated at
 the expected path
In-Reply-To: <20231212070431.145544-2-oliver.upton@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20231212070431.145544-2-oliver.upton@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Tue, 12 Dec 2023 12:36:10 +0100
Message-ID: <87le9zhcut.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Tue, Dec 12 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> Building the KVM selftests from the main selftests Makefile (as opposed
> to the kvm subdirectory) doesn't work as OUTPUT is set, forcing the
> generated header to spill into the selftests directory. Additionally,
> relative paths do not work when building outside of the srctree, as the
> canonical selftests path is replaced with 'kselftest' in the output.
>
> Work around both of these issues by explicitly overriding OUTPUT on the
> submake cmdline. Move the whole fragment below the point lib.mk gets
> included such that $(abs_objdir) is available.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


