Return-Path: <kvm+bounces-23782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A85794D792
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A1792834F4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63ADD16E860;
	Fri,  9 Aug 2024 19:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4cGYP35V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3535616D9DE
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232632; cv=none; b=ZsjsEVGDM78oknZ/Tn7K9YRTbDmTz+ddJQ1whfqG46UgQSE4irSHK/S2+tXRaZ599QhlAWlbpa3XNgFtLe0CG22ufYMwduyXIYsd5lWpn4yzB5+nj42bL3INKq07KLL03g/2fajf7uo/cT3dsJl0j9Zo8r3np93sySfRDtkCB9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232632; c=relaxed/simple;
	bh=WEKb1xlIGs0k4iOZ5Yx5UQ9S4hkU1zI6zoLoK8JwUP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j4SEkU2EXqiIURcNgxbx8OXoaKI4IjW/ZIo9P65b/wc0ttbFowRIorbZF81K+kF1Nxv0cEPf0QW0sgwxCWKjZqCYyaIy9C02PJO0yl5kD63RZ27+DyqE4GUCHWdKIO1ug8FyG0j2To8IwNg8wYkOwFC+qFRyyXGycILcpBNcG8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4cGYP35V; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a12bb066aaso1830235a12.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232630; x=1723837430; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qOWEA+gf18ibEg+1IgBuUDOlia9YtX+EopmbGWf1wCE=;
        b=4cGYP35V9J9edTKAVY6ReehrY14PvgOdHA6GXtdUdpGI4d4RmtIWAj6+uHnGIZnNl4
         7WlH1DZd57Ia6pMgOrgJsgmvjsDijx6MwJR33tcIT98ZwOz9W0qkao+m2DuwYoAQdMwu
         WgpJe9kKQMm9Kmcz2gfjfXPRXJsgZ1Gk7K5LWurw9AQHRck7waZVmWxw4/JuQQWVYhec
         XdLoc/hIYfcPNQkrHjks3Rrgsp1suuE2ez8Lhxvd2bddXJumBvVSeFS8FzQtFb5S3LaP
         P6kPeeZ2eGN0Ten0EpFhF/PqrPiubwOg73pyOPANOwCkuh6otJXQOUoKzhu/QMWm+nh4
         oW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232630; x=1723837430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qOWEA+gf18ibEg+1IgBuUDOlia9YtX+EopmbGWf1wCE=;
        b=ABiuEiiLXsmiNB13Zvmo7u9t9gSAMoklRuEQkRtW3xNqxdrB7edb9Hjb9PvORIEC6n
         tncnb+4Jc85rYBCxBKSrQan5ahGEP0Np7GJufdU9skH8qFtmjESZVYUc1gMhFG0S4EFp
         EiesS9mSevCJ8ImOwTCH1GyHhhcZXEVmP/mOb3bOPM7/7+ew3NGE7O0T+lSkCavQLzb7
         OphAuGHUF3zPSZzUPsWJA3pH3A/ns1jJpgKAjr13aHSaJKJrjBrVVsFD3oZD+nvYS6Qh
         LiOjOIe/IPY+VBCmrE51L6WpsJ0mdH4VlEOZ1OpfPPa7v5absvJLzSbIq7bSU6ijf1wO
         dFLw==
X-Gm-Message-State: AOJu0Yxw9lWOpn+UekLh/F5c/5ndZpD37Hp3tAWXphSY2OfO6MKravST
	MzkcOOfjA4lDBYyxoh0SrPr6qDzc4IDusbUEG1Pp8nooVnXCyyFMLj1OTdboRljha7uaQsK4ZjF
	iZA==
X-Google-Smtp-Source: AGHT+IEN/4gRYyT6fFtEw5/PSlX3VvEJMGy4wvRZ57TDQ5LWVk26M6iloQiU8f0vV2+Ypg0y5mNrr4U+8Bc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6f49:0:b0:6e6:a607:19d4 with SMTP id
 41be03b00d2f7-7c3d2c7fa08mr4698a12.9.1723232630436; Fri, 09 Aug 2024 12:43:50
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:18 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-7-seanjc@google.com>
Subject: [PATCH 06/22] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use vcpu_arch_put_guest() to write memory from the guest in
mmu_stress_test as an easy way to provide a bit of extra coverage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 5467b12f5903..80863e8290db 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -22,7 +22,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 
 	for (;;) {
 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-			*((volatile uint64_t *)gpa) = gpa;
+			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 		GUEST_SYNC(0);
 	}
 }
-- 
2.46.0.76.ge559c4bf1a-goog


