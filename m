Return-Path: <kvm+bounces-59104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62CC3BABFC8
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2371A3A4DB9
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21C02F3C13;
	Tue, 30 Sep 2025 08:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vATIUegH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1DF23BF9E
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220498; cv=none; b=MC2eRB3iq3WtHKQYggSRQnZ/lkhgyeOQRUGR6FNuN6kFr4axS/dZsuOIir6nJbmM/7hmXYU+RIKfMF7A/FD5ceWhTQ5/6eEvpCHcA9RxKjWKdONWfsSokESljB5jMAIMfYAgW500iasfquiDIToV8HiKBb1T6dUVMb4lS+tTd+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220498; c=relaxed/simple;
	bh=m2XlauSQwy6iP5O9cTVakYNdS+D0tVNg0YUz0E937M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KdKNZQyB7SbbQEuimySsMHPl01H1fYiQKw+gZMFphylVc8UsDxwSdSHX9QJJM6vX5okyVdF0tqSZmZG9HSCPvWcUgldxBihe6o3+aUHJtc81HESZqXXVS4FNiQ1g5sIU1dWw8m9fMFqRc/pCHyRD61KBTjV0fSQ0g20JZ88gd64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vATIUegH; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-414f48bd5a7so3627205f8f.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220494; x=1759825294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6r7ywVdtgg6puBO7GNeh9QBn+ePwbPPQeAATrRMKjs=;
        b=vATIUegHJ6QutFzVbFNpvQNCIoybyi+Ul70x7z3wWCwl8+BWWEtg2EKui6qvnGfSDi
         5ehRsL6lXhADn43mOVv65Caq8wHm/Km7JuZFZpDuJbJa//WuP4W6pA32yxteYCK14niq
         7e7TN+BkpoqDGeWFWlHnv/tBMVItbgCB95tfhnp1gavIJEillKwr8VIBVTJR7d3erO1X
         D2CBvjgK+LtQNQhOCWMknlKnQnwoOb9YqRJIJd704xze9ltP7q/wiaGSNV0HhF6G4HI7
         EjvGVDoQ9yT8rjAx9jCKwReDN4Dm1YtyVrJM0895WYkUs/fhE74xgu8HzxkmEYeAvUyo
         VRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220494; x=1759825294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I6r7ywVdtgg6puBO7GNeh9QBn+ePwbPPQeAATrRMKjs=;
        b=TOxCS1fjJkUPITdEnOP9qRWVTKj9Er5/jrnScqHsjdExkutSLDWyd7TJS00P4mEBCh
         KZrE44zQflXzUH/jR8FFI35MORE93CCxt1+3KVkO1IdjW0dA9qPgibJbW4UQJV5E9TJw
         CuADd2IcrtJn3Kd4PuN3ZPYAk7kr9ARN2hQhT/clXp66vR4IdeMZylyhzvY4wMDZbSM/
         FtSOjLBktzKAKTbZnQqYtekOyFgl9yhjawh2kFP4BJQMV0zH71elhcJgD3r8AWaeJFAX
         JPobkrC4PI4qngEml5VwtqzE1A4KyCDe8Vi4Vw37mL0zGLYBCgQUKqtywRi2BygiHDwT
         86GQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKvLKiRuPwd4bwAbZJvIPzgzJLvYCcPXqjTbl7QsCxx4LX5JBZARGFIXArvQ9xTx+yKKw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywio+dt6omyjC+S3fwCvPpm6DCywXhbzrhw0WHgfwUn0g162iov
	LzbOvxwAE2z01NjkLH41J9Z8glMx85gRlMAgmtqT6M9VwnOyBKpBVvBvBI4+KNWgmwM=
X-Gm-Gg: ASbGnctrq/MzqoK3siDJp8Wtdyz+MqDgXDH6/QBrQVShLr6yi0i+cbLyeyeCpb1g8+G
	JwH/wyH7+G7s9zkeOM4ZYBVpfWGZpvZo9k5nYiz7VkxPybblamm7iLXVsp+SoGvMd2NVoxuCDbg
	iSgDkI8zuC2xZRkOu84ZiHJIyz97+DZ/X0VMcPcyKSPXrIO61Dc2Sy5Omy3zZVUk9cEl7FeOqZ/
	/qqBjSoRNW7ouPdNkQh6QAF1g1f+a4fnqkQ1ZH7tCsYI+scA1zU41YTvavboPrS34faSRg5I0yV
	xY3S+wvUagySqdTWPC4xMyG6fDF7UPQ+2o7bn87+/3gmmGTy1iw9OLNRkV/GosGoCCKTyTqiKAo
	g8zixAhLoUwWf4lJTmrwVJowkDfBeJsr4ov7dD7prZN9IiDrvvMw5aavOhnGTglNhJyOgXHCB9k
	L9mHNsUUjAz7CxK1omUPESI9LYOrBhKCQ=
X-Google-Smtp-Source: AGHT+IFpI3GL5cse+8n+ih1oF0AV0V9hqADSW+14D/yEjGe7vAb5o0N9WY3TIiFao6rN6HuitLNGGw==
X-Received: by 2002:a05:6000:2089:b0:3eb:5245:7c1f with SMTP id ffacd0b85a97d-40e429c9c58mr19095049f8f.2.1759220494580;
        Tue, 30 Sep 2025 01:21:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb74e46bcsm21770765f8f.8.2025.09.30.01.21.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:21:34 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paul Durrant <paul@xen.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 01/18] docs/devel/loads-stores: Stop mentioning cpu_physical_memory_write_rom()
Date: Tue, 30 Sep 2025 10:21:08 +0200
Message-ID: <20250930082126.28618-2-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930082126.28618-1-philmd@linaro.org>
References: <20250930082126.28618-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update the documentation after commit 3c8133f9737 ("Rename
cpu_physical_memory_write_rom() to address_space_write_rom()").

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 docs/devel/loads-stores.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/docs/devel/loads-stores.rst b/docs/devel/loads-stores.rst
index 9471bac8599..f9b565da57a 100644
--- a/docs/devel/loads-stores.rst
+++ b/docs/devel/loads-stores.rst
@@ -474,7 +474,7 @@ This function is intended for use by the GDB stub and similar code.
 It takes a virtual address, converts it to a physical address via
 an MMU lookup using the current settings of the specified CPU,
 and then performs the access (using ``address_space_rw`` for
-reads or ``cpu_physical_memory_write_rom`` for writes).
+reads or ``address_space_write_rom`` for writes).
 This means that if the access is a write to a ROM then this
 function will modify the contents (whereas a normal guest CPU access
 would ignore the write attempt).
-- 
2.51.0


