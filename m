Return-Path: <kvm+bounces-11182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F5A873D53
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3D132842DD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFEEA13E7EB;
	Wed,  6 Mar 2024 17:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDbHebki"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8268F13D31A
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745521; cv=none; b=j1ODFu7xRRRw/jyx51R5CSpp12+Hd0lTQ4wp/dPfrS+pGd6k5lIjGGM7ZnsW0iMj0F+t2qtesDxKaS8LuFzQ3b3bSNBSwuZJeckSJ9J3xAnU1G0PPex+JL0PTFoUmfxC0aKYA62wG45KmmJkuFdcH0mRkXuzsA22nyXA05XZ0fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745521; c=relaxed/simple;
	bh=gbLH4TmHqU48zdp6lm3aAtGYz0Ua057iFllSLABMUng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AsDkDq5d6kmYv2pntM6nzKAcuZvu1lihX91A+xBWZ5y/dIPLKWRzCBb1ng/DbNbUnWeEEnwgItpwZvslFSZjzlJzs1tcZCs0dD49NNEEYokrDCixDEWWRz3vHCAOw5m5XzshJNc2arez+3aRcZSXMhPuBn+gXdyCjAvxEp4QIJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GDbHebki; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jhtbT6B4dti/VoL2N1zEYVPS+aHdp9Gq6C4iEyUoYP4=;
	b=GDbHebkizLyn/sn1sSKcV1Dl2DNT9pd6WtufJ+2CxzwpgxK70U/hAIjo53e7r1/2FSxF5h
	azUVSOR9QIQxaeyrAFhLHyda3SZmnmVngd6CcKmdV7b2QPNVL1MjTh93zVEheSA8EBxgfe
	oc2lBnFvJ39ZdLOR8wOsicj3jKTFfdo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-QhAZ7CcfOFiD8I8ff7UY7g-1; Wed, 06 Mar 2024 12:18:35 -0500
X-MC-Unique: QhAZ7CcfOFiD8I8ff7UY7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A513101CC6B;
	Wed,  6 Mar 2024 17:18:35 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B499140C6CB8;
	Wed,  6 Mar 2024 17:18:34 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 11/13] x86: hyperv_stimer: don't require hyperv-testdev
Date: Wed,  6 Mar 2024 18:18:21 +0100
Message-ID: <20240306171823.761647-12-vkuznets@redhat.com>
In-Reply-To: <20240306171823.761647-1-vkuznets@redhat.com>
References: <20240306171823.761647-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

'hyperv-testdev' is completely superfluous for stimer tests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index a5574b105efc..06164ae22aa7 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -463,7 +463,7 @@ groups = hyperv
 [hyperv_stimer]
 file = hyperv_stimer.flat
 smp = 2
-extra_params = -cpu host,hv_passthrough -device hyperv-testdev
+extra_params = -cpu host,hv_passthrough
 groups = hyperv
 
 [hyperv_clock]
-- 
2.44.0


