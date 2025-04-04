Return-Path: <kvm+bounces-42642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B9BA7BAFA
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3D51178B2E
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFE01C54AA;
	Fri,  4 Apr 2025 10:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WcMU4iZg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D357A2E62A0
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762978; cv=none; b=d6A/ofZ+c3PgnYU6BpNAyS0FgSv/Tc3PXo6zqXbqD4nG1w26kOroEtWDOD/mYGYmA/xLj44YHeBcA6f+R7gfBxr9NS4UNe+ZrN2Y2jLmBIQ854wapqXT2hgLB8J0uIVQdlCVU0eHEZIa0B7t0jUt6roCqtQA/dooZhSmlyLFwPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762978; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VruNqxv+47GKa66750LSIJZwniTBQbxvKwq39h5fvC8Zv+RrBqhITiIoBnpATjt0XKsHcAeNh0Iwlr1C4bI3ZJtwAb/77voGWa7TS8++8GlB+ZIDT7v7xYR/e8kVn9NoP33jV3GZvX9uVslyRMzcoqe03NxEz4S38Cjc+aSeROk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WcMU4iZg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=WcMU4iZgKjxHZyBhnGkcdxf+OlFlcOfqfoFu2fETTEueD+NiHmTJ7hv5mWutVjVx4Pl6r9
	Q19c9qxacaDxOG5ez+hG76+rLMbvasEGeJ9JLwk0q7Qfq4qey/G+lvujE8UGulKz1/1fCv
	j77GSSbw+uYINynvAd8pNbKv7GTi6Yk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-djsD7QMFP9S84aYwfnV-Tw-1; Fri,
 04 Apr 2025 06:36:12 -0400
X-MC-Unique: djsD7QMFP9S84aYwfnV-Tw-1
X-Mimecast-MFC-AGG-ID: djsD7QMFP9S84aYwfnV-Tw_1743762969
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D79F180AF74;
	Fri,  4 Apr 2025 10:36:09 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 31A9B19560AD;
	Fri,  4 Apr 2025 10:36:08 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dongsheng Zhang <dongsheng.x.zhang@intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: Re: [PATCH] KVM: selftests: Add option to rseq test to override /dev/cpu_dma_latency
Date: Fri,  4 Apr 2025 06:36:01 -0400
Message-ID: <20250404103601.187899-1-pbonzini@redhat.com>
In-Reply-To: <20250401142238.819487-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Queued, thanks.

Paolo



