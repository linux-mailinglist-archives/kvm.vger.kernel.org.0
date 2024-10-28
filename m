Return-Path: <kvm+bounces-29873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E636A9B381E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAC24282CDF
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1A31E008C;
	Mon, 28 Oct 2024 17:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGNHNCmf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AFC1DF741
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 17:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730137366; cv=none; b=ZGhGvscs3DE5qOOP/2uZO2VSVXVeSNkGUKvKOEnXC87u+6KyTID9DTc7Fjkqn1NX/juS9b4mr4+Wy/SA8Nu9pvMQAW7qXcCvYQBc7zrphRBuy5GaqfYAqe2ozIjjUFy5YUhbfA3fFRbpsoBN9m+tX3E+umUzO3J06FjPHTot8B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730137366; c=relaxed/simple;
	bh=qifG2s2osTQGjgqZ2d+3qLjvf/bfWrwNq7VRR/uozC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pX+Bw00oBWZuH6phbmX3uaZrTNHKNAa9L0mbAtksOphbC7B2hVrR9zLEkEHDt0Fdol57kaC7EmlyY4RVP9WaJYf2waC00fSRX40p1ES8FiSjpElWXzoJVGfhAaY7lNjtDqiHEpVfOrD9M7P4+yFkFBrVjsXmMhNyB2y3xXJ0030=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CGNHNCmf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730137363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qifG2s2osTQGjgqZ2d+3qLjvf/bfWrwNq7VRR/uozC0=;
	b=CGNHNCmfcaDgxsXSezKSp0DfEuGPT4+X+NnHH9vX0rXPOr85dd5Aw7ZnJzgG9lO0gvQ+NJ
	3dim2YnxAFetQvvGDVZL+adWdPM4F1bSkKS7A3ax7gtzhtHeYE9QrhSIvZfAhyrchGOiDm
	yVmbm3oVsFKXNqnrlWtu+MYeub/wF1U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-MEJPExR_MNmOqVNg6Gg9Yg-1; Mon,
 28 Oct 2024 13:42:40 -0400
X-MC-Unique: MEJPExR_MNmOqVNg6Gg9Yg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 920691955BF6;
	Mon, 28 Oct 2024 17:42:37 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3F82F300019B;
	Mon, 28 Oct 2024 17:42:35 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Kai Huang <kai.huang@intel.com>
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	reinette.chatre@intel.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	kristen@linux.intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: VMX: Initialize TDX when loading KVM module
Date: Mon, 28 Oct 2024 13:41:51 -0400
Message-ID: <20241028174150.301507-2-pbonzini@redhat.com>
In-Reply-To: <cover.1730120881.git.kai.huang@intel.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

> This series contains patches to initialize TDX when loading KVM module.
> This series is based on the discussion with Sean on the v19 patchset
> [*], hoping it has addressed most (if not all) comments.
>
> This series has been in our internal TDX tree for long time and has been
> in kvm-coco-queue for some time thus it has been tested.
>
> The main purpose for sending out is to have a review but this series can
> also be applied to kvm/queue cleanly.

Thanks, I'll replace the commits in kvm-coco-queue so that it tracks
the posting to the mailing list.

Paolo


