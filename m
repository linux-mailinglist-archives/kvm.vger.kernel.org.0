Return-Path: <kvm+bounces-3196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38763801886
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6E12281567
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FFB15A2;
	Sat,  2 Dec 2023 00:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P5Oy/bS9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DE8170E
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:44 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-daed1e15daeso1501603276.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475483; x=1702080283; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fYSe4fYTi/FXGdeBXMWzLtaR6u3FlgzSZKw16CFq7Qs=;
        b=P5Oy/bS9Z7j0HLHWiDBbSHIA5JB5v0s/N0Xl8tgwcfKGk4zlUf5FpOKto8xih/RUFX
         hAcxikJ+PKvgBLXaQQEUC3Ki9c174PTje0vpn04GdZqsO7jvzmFDpt+TJAPyKCKtPiA8
         11eyCXtmO2qQyiv8Rx5ppGGMmIDlKT1f6o/wTPqavlqK4ssWduyA6iXLQMC7/c435jGu
         qC3j5Tr3KIlLsJzFDc3Bs7QE7AAdOS0NBVxansK48HbAIM5EV9836x02wI0v1VMGiIcE
         vRVQIxqfuqzx4dTD6W+hLzkoKtprvztO6mchOoK2aBiZyS3tacTwPMbbIO/t2rJteuq9
         9WAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475483; x=1702080283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fYSe4fYTi/FXGdeBXMWzLtaR6u3FlgzSZKw16CFq7Qs=;
        b=hxe9PdryA0KQePcmRclseppzQlDShhZmKKGUiQJAgVkS2k8pXB3IOqio/d+t8SoFSJ
         m57u2CNaAro8RKbLQcSHXOyIO8GKjzbmIkcaDj1us5zz+FfXt4Ch2W+q/s/08Ez2gJPX
         ZamyWOlc/9/lC0eRGdoeZ1DFxgaq8WXICVJUiXOepEcPx5FSZF+sTycMR82F+enUlv52
         xF0HdnG/F7ZKrimrEGR1tFJ8/MMt8NcFuv9cG0KDNnTSy+VD8HmIPv8X5+9Zry9l5P0b
         Dm6r1MKkxoeAvperWrbWiRDtQVv/NGyaAc6Ow0D5MbfZHc0Q4DjxAdIm2x9dJ7I0bYjq
         v4Ag==
X-Gm-Message-State: AOJu0YwnbYwu3lSTZ2WPscJXR3areOW/Gi7Fbg19NFvRHTVn5vjugfAx
	9Xp9ENPRAWm/2+IQ1+966BgvcJbdlHo=
X-Google-Smtp-Source: AGHT+IHAld8sq5015asBCXpzz1bGTW9LUBWyPvkc9PgfkusUCW0Kq3MDDnx8Vav2rn2hiVVO5LlkFzOkmoE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d1d1:0:b0:db5:423c:965c with SMTP id
 i200-20020a25d1d1000000b00db5423c965cmr226579ybg.5.1701475483633; Fri, 01 Dec
 2023 16:04:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:01 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-13-seanjc@google.com>
Subject: [PATCH v9 12/28] KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Drop the "name" parameter from KVM_X86_PMU_FEATURE(), it's unused and
the name is redundant with the macro, i.e. it's truly useless.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 932944c4ea01..4f737d3b893c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -290,7 +290,7 @@ struct kvm_x86_cpu_property {
 struct kvm_x86_pmu_feature {
 	struct kvm_x86_cpu_feature anti_feature;
 };
-#define	KVM_X86_PMU_FEATURE(name, __bit)					\
+#define	KVM_X86_PMU_FEATURE(__bit)						\
 ({										\
 	struct kvm_x86_pmu_feature feature = {					\
 		.anti_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),	\
@@ -299,7 +299,7 @@ struct kvm_x86_pmu_feature {
 	feature;								\
 })
 
-#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(BRANCH_INSNS_RETIRED, 5)
+#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(5)
 
 static inline unsigned int x86_family(unsigned int eax)
 {
-- 
2.43.0.rc2.451.g8631bc7472-goog


