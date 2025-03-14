Return-Path: <kvm+bounces-41100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB3A2A617C9
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B82E518917D1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C8420550F;
	Fri, 14 Mar 2025 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l3epkdfE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C700C2054F5
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973522; cv=none; b=s0AThKPDWhioqRK8Rw9uxUIeyXbVC+1C8rMy76i/jSigR0lCXGlMl+eLXW+043zkRBjaGO6B6gp+Cp9RIgVOcGMfaEubYCqLb6wMhfn6/JALGly1eGHOxGgNCb4h8EM6lU6pfNH9Foum7HfbHEk9UXZovfL4BEXd24zR4Qjfnxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973522; c=relaxed/simple;
	bh=CzPhR8gRelKLEDtp1LKolN6jwIOO5jPAQq57RMOd2W8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qe6cmBeSAs5eyaC4VvHyO02gLydvkpjRkUeIxXuq+9RHWu3narWmB0p2p+al2QHUJilwSp774sAc604CfAkxE/LpuFc1H/H42m3jrnhEbr1n1pE4+cxMywGYK09QJmwHzSCExdiCVPipdRcDOPazER8JwrTKa4TlzUQrOyf7Ojc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l3epkdfE; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-223594b3c6dso48659685ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973520; x=1742578320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOa15ppvF5kxsldjPkSIJYe5T0c824L9GaUvR3via0Q=;
        b=l3epkdfEFqpMcuuLKQAD5nASgMIhheMG2I8i3fjv4UNxoqMnvNBRaNVQWyVcaeO3xB
         fA1jTV9wWj27eWYtVSpnPlmWKz58J9J1As73YPw4OeX1GQONKh5yOBTgOlbosoI6Eqt3
         TTyY4kVR7sdasOsbxX0E7towM9P/5KnXF0hfvLBs73dqSXmftDJTdmsLtU6qLC+wj81u
         flxjSoUdeNvirDt7ow7JqB1aydzIUiQWsbuEv4eoVsU9kSNYKV6JyQPuD1bchT/yzDv2
         ZHVeiL5Gi31BlBGYxTwHLhA1I+kzSmDCUTS3xGM8YBRtR04nfcpVCBgov39rODaQDOcs
         MFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973520; x=1742578320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cOa15ppvF5kxsldjPkSIJYe5T0c824L9GaUvR3via0Q=;
        b=LPDLbfDcVy9w3vacWuDu+cuP8guvscThA0l4EYU/Vf8N06i8AcvS0MHxuCtPzyzpHx
         r3gRoca4cETKNpNVK0/y+aCCIOQS8XHSqIW7v9vcnMo5TA/lcK1CF93BcBLaDKhrdeMD
         tnRFETU9+qUr7f05yXJzCjvE/QvvcombQfO3j/oSB7FRo6ZRtJPt41WEupVDhRaNk7zd
         Wx6lEdp51y5/8gCtgcZKoobkeKWzPuhB18SHRPHMuA52CooGbRtX3UsReA5NECGyjVV4
         HWiNFa2pnvH7lmDCKC1NOYBK2UjtC3ZIGnSu1WCSedOCQrjU/M8EQdyuSqjvT4ZQy1NX
         KxNA==
X-Forwarded-Encrypted: i=1; AJvYcCXE+Y0JSJ7ZsbdrX57GLY+KjU/pg7AGD7AUWl0NkRR/mNIhUSq2UGEKtaZHgLdJJnnM9Cc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyraaeGQqHxrWfMBVFccNnEtX3Wm2gPDMMarxXgLEFcyUhv9/of
	g/MmzRXdIPCc2VGYdf8t1M2uVlRCSCyP3JGabbq+rFspHh6I8J+l62We05uo4yI=
X-Gm-Gg: ASbGncu9PR1gSwvOyC79fv+9YoDVq8ugBZ74VC59VwrIEVZQ6h0DZ8XmD9Fq11DJ2xD
	b+z4lDDbkcgX4Nl1I5cXQScUw9NvIOZRduXmIsy1Bo3P4tu1qr4KgYrQEFJ2mxvjjwx5csuUjpb
	h45lfK7NVj4h1msXtt0eAsZzCB4fPdBvwvzVR4uGotJ0r5SKMD0R+miUqEpGijeOia8FZI+stOr
	RSN64B7o07tXWzs9AdSHkLYVEgSEgJMCQlRDQwzV7P2gZeI4Y9Jo1LdGufMgFtoyJgGIkSiIFzC
	PqNpKiY3cevuVkfKxMsTjnWiqDtKej0J8O/H4C+Y4Y6LOkCN2bVZUNw=
X-Google-Smtp-Source: AGHT+IFlQhNJcOD04DdXfXRzIQFpLw7YnyShzSPUUYA1tOEz0vWyEbVCk22Q9xZ8telIqsQxDa+sSQ==
X-Received: by 2002:a05:6a21:4a8c:b0:1f0:e42e:fb1d with SMTP id adf61e73a8af0-1f5c1326a41mr6196288637.36.1741973520104;
        Fri, 14 Mar 2025 10:32:00 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:59 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 13/17] system/physmem: compilation unit is now common to all targets
Date: Fri, 14 Mar 2025 10:31:35 -0700
Message-Id: <20250314173139.2122904-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 system/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/meson.build b/system/meson.build
index eec07a94513..bd82ef132e7 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -3,7 +3,6 @@ specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'ioport.c',
   'globals-target.c',
   'memory.c',
-  'physmem.c',
 )])
 
 system_ss.add(files(
@@ -16,6 +15,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'memory_mapping.c',
+  'physmem.c',
   'qdev-monitor.c',
   'qtest.c',
   'rtc.c',
-- 
2.39.5


