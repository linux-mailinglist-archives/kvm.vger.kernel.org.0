Return-Path: <kvm+bounces-47855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8495BAC6492
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 10:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A03ED9E3DB3
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 08:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713B5269880;
	Wed, 28 May 2025 08:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HR2PPint"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F5E24500E
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 08:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748421278; cv=none; b=fQVs3Y4PXArkQYeTYQk6CCREvCXdD0bJACoSSVzw7NWaB4pC4ssrHcjYi+DOz0MQbka1sIVQ0hoShesMsQJLM99nYCaQY0HtwWV++hBbnPDNuYk1irdVENglDi+2b8W+o8lO1mvwxqlLJaJsWQjg+jwd3yqBZPU+lIzFohBaMV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748421278; c=relaxed/simple;
	bh=WuwyUAHqnp7HPv0q9YY9o8U6CvTjARcWIkJ++XQwOv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uFO0mFTlXlRz5O6W15TCWdqpwbEA4uoY4FZkXpWwW4pDsbgyGZEjixf16J/Oyj5xyambdvtVhE1j5CJIWKubhlsNljjqIquapZu/1+KIkO0MXeLNbe74HHuRaaEYhqB5kXnLsy5HWHEVvrlvTOchYDHMNNfYcvyW66gwMbMm18s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HR2PPint; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748421275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U4i+JqyZ/XZ2/PTdI6CeFGM3MJ6lxIFb7tc48utqptU=;
	b=HR2PPintJhEvcytZoZ85FXBgvnVTRHSrn7IUBPifsAGQPYYKzL+fh7mehX794FOO/PPkgX
	qMH2fkrZv/gMy6W4e3giLnNM7Ls7ZM2P3qNlv/TuNfgTxoUq5ryTqQgvEkDgbiKRhAriKl
	z0KGN63nvgEnGZUrR6VJPk+JmXmvw1M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-b2bWcIeqOJaM1xldtJusMA-1; Wed, 28 May 2025 04:34:34 -0400
X-MC-Unique: b2bWcIeqOJaM1xldtJusMA-1
X-Mimecast-MFC-AGG-ID: b2bWcIeqOJaM1xldtJusMA_1748421274
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ad88ede92e2so143231466b.3
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 01:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748421273; x=1749026073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U4i+JqyZ/XZ2/PTdI6CeFGM3MJ6lxIFb7tc48utqptU=;
        b=jbgZPlva4MB+aKgs6+ZDKCUtVGR+ylA1/qu9MqAB/OotD69uudfqS0jVSxKwlEuonz
         4xWLrMsWHRx0caQdkUdiskRa+SdURwGmoWtXH8/fS4Tk/hjfm1v3iUyIettkRaEM+Req
         u5WhmDi4Dz6ohGOE1UqO5JHMh4KZp0oPdXqBypzQPmCT+PA4s1cUpexWQVuGfHoazaod
         3fFGDWlD1UdqsyOY8Ll96H9D1cqbtVkB46Gtm7VRQx1nq4JV/ktxydx5k2mfqd0WeZB8
         stetLEvst+7YwKb8TPmTJJ8FDaEa8uu+369jcBkWvI3CDf/0MtdH9c7ST5pOeC8AojqZ
         B9VA==
X-Forwarded-Encrypted: i=1; AJvYcCXgc70yU29vX2lgQIvZzh/0hcAIeu8SDFzf445/+xiozU2dkq/Q6e0/TrOo/gDyljygndI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLC+QRr+PtCVck2JprpiBTRoU1JsivRN5YhYojtKx2SWyv1r5F
	qfcSxUOy+J6q/4KklD0toMz6+BZey01e6yBL4DfbcU8UAMxNihf6oeDM+5BUTyc97JFS1kQXcLq
	6JTWjroG2+1P9S9amexQDvRbKTfeDZAYXbCAUYUyhmgOess11iM/HFhtNyxvI9A==
X-Gm-Gg: ASbGncv/v48DUfuH0ovKWp7gdo2k/rdCVclrfnewbPDO6vB4wipLh6mI/NR8bXjwkga
	i4PCqM5DPOhgcZYIM9+iPyEXJCHzRfp//vMVfCYv71Y4Kkvi501FA7cvlBfuZ9xRPoGd3gaB78S
	jpncGIlEhpspGH4NR8tOKOIut/vQunI5ZcznqNqf/zAHjCtLoQQbxmLkSuXVdJ8/xlgAC40orXt
	ThQ5vr1evC8qs7g1w6EBUlbA9EuFgEXSPc4SxD3KMs0IrXm0SwdLy8ql1QiNd5BDZVMN2i9vSWQ
	2TGifYxG25OzNw==
X-Received: by 2002:a17:907:944c:b0:ad8:9988:44d2 with SMTP id a640c23a62f3a-ad899884717mr339412066b.20.1748421273164;
        Wed, 28 May 2025 01:34:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4e2bHjQQ64E6JdYrHpC7X4lCExyEp/3G8BfrYRE/V4IpI0prysNOJc41oeaxS+qaPAGw0SA==
X-Received: by 2002:a17:907:944c:b0:ad8:9988:44d2 with SMTP id a640c23a62f3a-ad899884717mr339410266b.20.1748421272788;
        Wed, 28 May 2025 01:34:32 -0700 (PDT)
Received: from [192.168.122.1] ([151.95.46.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad8a19acd7esm70875766b.11.2025.05.28.01.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 01:34:32 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org,
	ojeda@kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] rust: add helper for mutex_trylock
Date: Wed, 28 May 2025 10:34:30 +0200
Message-ID: <20250528083431.1875345-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit c5b6ababd21a ("locking/mutex: implement mutex_trylock_nested",
currently in the KVM tree) mutex_trylock() will be a macro when lockdep is
enabled.  Rust therefore needs the corresponding helper.  Just add it and
the rust/bindings/bindings_helpers_generated.rs Makefile rules will do
their thing.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
        Ok to apply to the KVM tree?

 rust/helpers/mutex.c                               |   5 +++++
 1 files changed, 5 insertions(+)

diff a/rust/helpers/mutex.c b/rust/helpers/mutex.c
index 06575553eda5,06575553eda5..9ab29104bee1
--- a/rust/helpers/mutex.c
+++ b/rust/helpers/mutex.c
@@ -7,6 +7,11 @@ void rust_helper_mutex_lock(struct mute
 	mutex_lock(lock);
 }
 
+int rust_helper_mutex_trylock(struct mutex *lock)
+{
+	return mutex_trylock(lock);
+}
+
 void rust_helper___mutex_init(struct mutex *mutex, const char *name,
 			      struct lock_class_key *key)
 {


