Return-Path: <kvm+bounces-9504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C62A8860D60
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 09:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 819E22877B7
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 08:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1B9286A2;
	Fri, 23 Feb 2024 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FukbbXU4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FB7199B9
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708678711; cv=none; b=ZbX1JZMzYeRf9GtmWDWyR9tlUlhdgNX5j1nyM74sOJ0I9RafWG1ai+OcQsyRRiBciP42ruhRTNvXQy6JSrNP2gnRJ1YmN0m9UcaWFujJUDX6NEeQhs8GL/QLjJV9BPAbYtK2tv73ibX6UTRu7FDv7EEQRi1jrXGjxxYjUmlged8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708678711; c=relaxed/simple;
	bh=E0fRr3Y3DxdMEMprzE/Y3vOr9S3mbgKeLEg8Rr2OJnc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CZl9tVmXPpNOQvEVe1I+8C6J4EjsmVlHc1VC4bXOwkvIwTuiyzV5C/K7OZ0awwDPZMb1SDtz7BCJaje1JS01jW4Zo7M0/Dpygon/r2sjaCD5/PV3ZItA+Sxjy+PCgP+xyceblIFp/12tYKTRZrH7xCRm1syGneyFXxKtOIYRVSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FukbbXU4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708678708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0fRr3Y3DxdMEMprzE/Y3vOr9S3mbgKeLEg8Rr2OJnc=;
	b=FukbbXU4pyzZNoMARjxJDPq+a5+FTz8GpI6El1++eKYVYpLmNhIudLNaiN7FSPumYmjfdk
	F/saIhZ7JKi9Ib170TyZzO+UHEAOP/+Pnldx4a9PAdezFWz12vFrwSFFcLosFY3RI7WL4A
	ol4DqQ9MgvwwKuPHadDBweDLuOomWZU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-ItAI371oMlma7XojOk2KIQ-1; Fri, 23 Feb 2024 03:58:22 -0500
X-MC-Unique: ItAI371oMlma7XojOk2KIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2542983B826;
	Fri, 23 Feb 2024 08:58:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB1A7C185C0;
	Fri, 23 Feb 2024 08:58:21 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gabe Kirkpatrick <gkirkpatrick@google.com>,
	Josh Eads <josheads@google.com>,
	Peter Gonda <pgonda@google.com>
Subject: Re: [PATCH] KVM: SVM: Flush pages under kvm->lock to fix UAF in svm_register_enc_region()
Date: Fri, 23 Feb 2024 03:56:05 -0500
Message-Id: <20240223085603.623361-1-pbonzini@redhat.com>
In-Reply-To: <20240217013430.2079561-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Queued for 6.8, thanks.

Paolo



