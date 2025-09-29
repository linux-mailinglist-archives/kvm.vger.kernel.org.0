Return-Path: <kvm+bounces-59027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 406C0BAA4CC
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00817169E31
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1923323D7CE;
	Mon, 29 Sep 2025 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BiZtLNAL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A72274C14
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170786; cv=none; b=MPjY6dvu2bmS/NZLSxI6H1lpyIAskurZEYJfQQRytcPtPqbbxKo4DURIMSC6CHE4j/roj0y4OFD7xjyTvaOYImU9DHuppQBGt5VGsVsQDXmsGFzCnj3QVs2hbYK/FDRbq6L+UUL+Cgh0E02ku2MtqH/J6gxVvjBoVMN0eHay00U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170786; c=relaxed/simple;
	bh=Bs41XgdhdxHpBjVdhPOy2XEoyeDrc5GulRiLh8B5Gqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KFQwmA72vNwH2Vxh+irjQdBaRRp8gihPSaDFeRFpUEI/eZey1hQiiBpj73rUG0S+j7U6PyIy4dQpajko5jY2xm6+PjV6hrtc2poZ2k/f8vI2m5CuyGXLhFWJS0bj70/xoDCkYnBUmeLdnRsN5CiRGxXWVy+ijVSCOW95AU8id/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BiZtLNAL; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e3af7889fso27782755e9.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170783; x=1759775583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o8vf9ta3nqwm/Fyb5G7ZjHvxKsRPPnP+TTAqHaMFdKE=;
        b=BiZtLNALRQY+i/FaBz0tpwQIjOlpUe/ZB24ALkP8Qw8r1evWWYLZ4YvPgqChisZVZl
         2U6vszHaq36ZWkxYCN9h+KZceY9pKugYIfgt5q7g1ZnOsf7PR/LHmQinNxWOQQccEW3f
         ryvN80grcamLkcnZv7aGNiaHZjHJLW6/GsLZelZG6/+aFyzeaJvdY7978NzXeidiZEEc
         SI5ypi6qSuP9h7RoAY57fX++mE7z8M8EJnqOhNMSwPCDBVleKiRBhgHSaZFam1x+1R8K
         8owzf9/6y8kEw3LVwq3QdfGAYJj1TsGHvxVIMwd/AbABiOqGwCTbqasqt8N7mHXlmaYs
         DEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170783; x=1759775583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o8vf9ta3nqwm/Fyb5G7ZjHvxKsRPPnP+TTAqHaMFdKE=;
        b=p8yv2iIGQ23e1gazkE3Beo1O8jKe24gmKnME+4OPmGdiFWYp0FPgFwselAfFbnoOuc
         qk+c4pI3BD01zAolRySTknDUPUXlZkxnWL+TQt5ibfnSk9s4oU5M+l9gOaeVQoGZ4Zx5
         t1Gxfcc0edlID/6ym2U9rOQPvjXSpEaVK8BESqIIn0PCp++4b6hR/qbavD2E5h7p77Et
         y9XagPQLqirEDNVpxYIQWT1m7h7taJE1Og7S/Izyj1l+0Ekt6vXAPVB2xBH5mYVHOS6U
         iG+cRnS1hdDcP/paDi/VR+jTXgtZvPKw1yomXZa2/y9t6fhPGNjbvc+LLIK0Jnb4VzmS
         PWxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWd3YPyzV4i/jyg0huvZ9cZZt+Qd+E2k55XnK5u/ivqV4tUUKG69JdPE8gV8+CJe370Zeg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTObDgn72UqJQzxjQFwnIbqv8ip3KPt/YnNbyusU90z7GFqJbz
	2TAqnJb95u4IvLV6goQ7FaHLhaWIeCEv2P/7b47cyj6J7m6+LmD+sFazxqJ3sEB3tLU=
X-Gm-Gg: ASbGnct9zHG+cToPGnKF18e++UEkwLBRL9uDbTPDSwt5tspVyfZDKLsAMRoyuyFQfw0
	1blVDBMM7iYNI+mbiUqGy/P/NL42fRy5fYlgnCOCQ8QJTqnwL9rCEPaS50XJnn8INHsIFhf4JVz
	vC/YgDekabOUTvW6jBBN//unsIJQzw83V92GqTRRtkAdKb8hmqgROEx8smPLlC6mKUu7njuM2a3
	Kil8nK7lKSSOxSRn5y4jEugZ2dKKi27vfLKgH5NFSDU2Z204WWuqOyoRFdXavbjKEtpkZz/N7BW
	YePRRrJhRmfXR53oDYuHbvzvfq+yIE99q2wrT1rrB9Giu0DYbpfwPkDABHpKXB5n9aKk37C3EPc
	EKqSabcRlel4wQcYgV0EfnCWt8NGdfZBSkN2166ZoFvCmQxmGZUj7PQK5Zej/iwYUnFSw0R7qGt
	j8g8LuIVQ=
X-Google-Smtp-Source: AGHT+IHvn5eYPMtDO5pcLQu1/TqV9ktVhW1E6kH/3j8sdOMbTO5qR8/yD6k9KVyFZbMuU0yLOSpWPQ==
X-Received: by 2002:a05:600c:1508:b0:458:c094:8ba5 with SMTP id 5b1f17b1804b1-46e329b62bcmr112008465e9.12.1759170782675;
        Mon, 29 Sep 2025 11:33:02 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc88b0779sm19057657f8f.58.2025.09.29.11.33.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:02 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>,
	qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	kvm@vger.kernel.org,
	Eric Farman <farman@linux.ibm.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	xen-devel@lists.xenproject.org,
	Paul Durrant <paul@xen.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Anthony PERARD <anthony@xenproject.org>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 01/15] docs/devel/loads-stores: Stop mentioning cpu_physical_memory_write_rom()
Date: Mon, 29 Sep 2025 20:32:40 +0200
Message-ID: <20250929183254.85478-2-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929183254.85478-1-philmd@linaro.org>
References: <20250929183254.85478-1-philmd@linaro.org>
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


