Return-Path: <kvm+bounces-18786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 796718FB58C
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAB161C23C15
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD40E13D269;
	Tue,  4 Jun 2024 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXPZnLNb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA3213C90F
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717511720; cv=none; b=iSG/rSqzhnV9dMbF7pqB9wEl1kcLvuAyH9a3mdCDNMnaxJfj6s83kXc22wl0yPK+ccjASv/jACbORR4M4jtP+elh9XACh8gvA9kXwNi0/1NsxbzLsUm8IbkfGr33pbMva+TDCiCSMCN2QrHB8dSl87Ga70+aU+MEienOQkmQozY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717511720; c=relaxed/simple;
	bh=9XX55agOH/Olykt2aiG+X0aMBVp4yhMp4hys6iWy/2s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k4XGHuVAjW/oVrjrk+rnp0Zy2aU6IGaRoRo8Du0/pv2/xWY7BtsNOBZXsF7hBwd1Z+yOMC37m5baKKUWYkl4TPFtGPMQjMC0zJj4g/eeskeYbuNQjv/jX84/wcohvEQP/F/SvL2pMoPkpskmcjFERTcHMdWFdJdBcfTkYblQFjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXPZnLNb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717511717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/iLKYyu3MnjfRlqwDkQw8auqTGeVq0KkYd5Bt2SpiCk=;
	b=CXPZnLNb1RcQJiz3MYTKEBI5BxZoLjBEituX8Ep7WylZj8VyZ1033G9jScBvxwOgEx2U8u
	V4YAO7dIoqapp/TtTYVf46SqF0aNn5l8HriFuEMW0ENeBjz5f36o1lMoNge3h4c6u7Ce/M
	JpUpuF5M22fBtHv4WK/aGYciQHL28A0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-PnrDSjfjMc-2TsLDnpEM6A-1; Tue, 04 Jun 2024 10:35:14 -0400
X-MC-Unique: PnrDSjfjMc-2TsLDnpEM6A-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a68abbd0c78so190244866b.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 07:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717511711; x=1718116511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/iLKYyu3MnjfRlqwDkQw8auqTGeVq0KkYd5Bt2SpiCk=;
        b=cXyjuc9hEhde2AZ77OTXf4XaOvNgEG2hSCFJSA/qqD/rKHwvOrYV0V6UJ9DddgQdlP
         UAgjHavwa+CYIYmMEhHb4W68BetiMnTNhSzb6d9HTIW2rG7Q1GBtkO4W8sFGbnucWx4T
         Uhtoh6hFF/YBzSy0goeaDkc3Ih55ELzG1Rb08579jtylF/fM13oUhtd65LZG/YVZtFAR
         +s60oQgS0RK4LYBEbKJlabohYiJJv/zs4uBjL1dvW7ZLe4+yGR7F+8zknOmTcnapkpfz
         8nHGzJqYkMhFt2/V4hAudS7pHl/WX0al8uRbt/Gy6cf5L2iWWlnJqd8AEMJiTKm/X7xJ
         fPnw==
X-Gm-Message-State: AOJu0YysEhQ22e/C7IJ84qJFeSKIyoRLRXVwzbAvh8gZs+LZEi1cz29x
	4Go3FwGvOXKaLIDVktTn1zX8UVFGZiFhvrht/GxCkxPHHwcKPZUkVGQdlOFnFGccIyscRmdLQ5s
	1MXRjdNaOQZDmE7LUc+M68rWdSrqLRILL/WS/yOLoND2PVnjqtz6Rw/GxUb36AfGNcbf8Qzp3LT
	DehkJ9AA4VPPX1moE79jAZx69IfxEh89Cxvg==
X-Received: by 2002:a17:906:1645:b0:a61:ab74:413e with SMTP id a640c23a62f3a-a6820beda7fmr772206766b.46.1717511711145;
        Tue, 04 Jun 2024 07:35:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4cLfw559VOPrFmVMNSaee2Tjj/Pp5TJdhCJ0OymQLkeVHEhlrswn9/howwj5WNZI7PEfVUw==
X-Received: by 2002:a17:906:1645:b0:a61:ab74:413e with SMTP id a640c23a62f3a-a6820beda7fmr772205466b.46.1717511710649;
        Tue, 04 Jun 2024 07:35:10 -0700 (PDT)
Received: from [192.168.10.117] ([151.81.115.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a690d29f52csm293732066b.44.2024.06.04.07.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 07:35:09 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Cc: thuth@redhat.com
Subject: [PATCH kvm-unit-tests] realmode: load above stack
Date: Tue,  4 Jun 2024 16:35:06 +0200
Message-ID: <20240604143507.1041901-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The bottom 32K of memory are generally reserved for use by the BIOS;
for example, traditionally the boot loader is placed at 0x7C00 and
the stack grows below that address.

It turns out that with some versions of clang, realmode.flat has
become big enough that it overlaps the stack used by the multiboot
option ROM loader.  The result is that a couple instructions are
overwritten.  Typically one or two tests fail and that's it...

Move the code above the forbidden region, in real 90s style.

Reported-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/realmode.lds | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/realmode.lds b/x86/realmode.lds
index 0ed3063b..e4782a98 100644
--- a/x86/realmode.lds
+++ b/x86/realmode.lds
@@ -1,6 +1,6 @@
 SECTIONS
 {
-    . = 16K;
+    . = 32K;
     stext = .;
     .text : { *(.init) *(.text) }
     . = ALIGN(4K);
-- 
2.45.1


