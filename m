Return-Path: <kvm+bounces-48413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E560ACE0E5
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 17:03:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22D8C173E5B
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB8F29117B;
	Wed,  4 Jun 2025 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtLmQ0ld"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332F91DFF8
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749049409; cv=none; b=Jz3zjCt1R3+yIwmT0Qo03dP7wMAGH7n1XqFlbUh4M/xNJIXiy/QcS3Cm6kOTZ0rBPw7/+Jyi5ARMTqCD71KUuiEUeMN0vmmS/dJmqcTwJYvEwlaPWq6NXAOCch5joXS5oslyeQKlwB05CUNiIObbPY4l3K74gNRB9slIL1suVqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749049409; c=relaxed/simple;
	bh=yZamUpIFal5nw66NRf7rgkuy6A1R9zrovwo6WC6VP8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9Ed5L5UtHxkyQ/ghzgQk8XlWlyoBdglIGkUenBDF5Iy7XYOttsJGQBOd4bKGHge6ZImRAfdWV7dehVLm5GVGR22ICIkv+xbEouz/BoMWoeRrfo7xJEFpNSNDVnobBY0ztExN3aantJv9QsRhEN+6lp6gDwvIaxWs+qxpYoYSAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtLmQ0ld; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749049407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gawt0Z5YbMu+KACcLKD/dbA+4ZYdaJgyH6JYKKp/+E0=;
	b=WtLmQ0ldvzIDb8fpycqtGYSMxzlV50HxUUP5mqEr0dBu7vZRR8BKfCNBIm56QF4oifKI45
	uq0GguGRHEV+xLz67TFax35k6N5XJoxZnP8FKz9eEIoBlJt9i/irWHv9tuTyNrfhKtQiv4
	x0w7JcBGMu4bXw7MnZkxbMDAy9uDrbM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-kSGeFmi3OQmUCPyMpc-ttA-1; Wed,
 04 Jun 2025 11:03:23 -0400
X-MC-Unique: kSGeFmi3OQmUCPyMpc-ttA-1
X-Mimecast-MFC-AGG-ID: kSGeFmi3OQmUCPyMpc-ttA_1749049402
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C885180047F;
	Wed,  4 Jun 2025 15:03:22 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1BCB11955D82;
	Wed,  4 Jun 2025 15:03:20 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	James Houghton <jthoughton@google.com>,
	Peter Gonda <pgonda@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Fix a NULL VMSA deref with MOVE_ENC_CONTEXT
Date: Wed,  4 Jun 2025 11:02:43 -0400
Message-ID: <20250604150242.137563-2-pbonzini@redhat.com>
In-Reply-To: <20250602224459.41505-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

> Fix a NULL VMSA deref bug (which is probably the tip of the iceberg with
> respect to what all can go wrong) due to a race between KVM_CREATE_VCPU and
> KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM, where a non-SEV-ES vCPU can be created in
> an SEV-ES VM.
>
> Found by running syzkaller on a bare metal SEV-ES host.  C repro below.

Queued, thanks (with EBUSY instead of EINVAL).

Paolo



