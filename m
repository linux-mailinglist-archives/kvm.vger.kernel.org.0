Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5462127F752
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 03:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgJABWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 21:22:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730921AbgJABWb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 21:22:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601515349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=D6j5+yVXuDDqImWC6P4XLScPzfT5Iicz/V+LjkH0wKKSEe3EfmzRz/yRdxeVzwyDns7qK8
        IxjOASEchaYXyOLgn97g/mSTJ22O7is/aj3Ye6MrQgEXBbLO64yN4AyYPk3grW4ZJYo0wS
        UF4r3XwN1YWKfVwcs+j1foa97pVAw2A=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-o0igLqdFPXSBy74EiV5T5Q-1; Wed, 30 Sep 2020 21:22:28 -0400
X-MC-Unique: o0igLqdFPXSBy74EiV5T5Q-1
Received: by mail-qt1-f198.google.com with SMTP id 7so2502064qtp.18
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 18:22:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=jl6pcb6cUrDS51S4hihU25EHDoidoKn3rKh82G10oT6apDbuR6GAasK517if1j02yG
         QfAZ+vGnyPtP5CjMhKdDhFYkEVj5KwW2EQNKUrLPvSHUie9c4vQdDdCRBI+fcsbxm6cp
         XM39cu5M8NnNyXBOz8Y8UgihsiBkrOdIUuu6A6NA6drOejlIL2eliI/GEfnIjsyT4EVH
         Ddn73d8JxB7NtSRRnRE/FOzPCfCAfmmDkXn1o0OOkhd6ZCrr7f4yhFzsrIYM7f8Lbzzc
         pEgoWMqJbfL/QsHpFhTUPaR6ZtmfV81foWcEsoTOokBPlHIjif1ovv7nD3ZzuRXg5Y1o
         eUAw==
X-Gm-Message-State: AOAM530hyqewm+ft6QWGaCUywI+4qaUJPbW7qJvNhGaG2FQ7kaadi8RR
        XyHWmGtacqUFw++NUAuvRAyQAus9mAfM5kUyUlMbD0VZmM3/QdBbkM1jlGnsqzWI9UpHSJ60JJD
        mUCYl/1OgNW68
X-Received: by 2002:aed:2d62:: with SMTP id h89mr5256461qtd.193.1601515347934;
        Wed, 30 Sep 2020 18:22:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9qiG51yJzzbbV8CDlgt3OtjUOka7BB6YhLzeZuvbNwtq6YsRQsYHzXit7tCeO7Dn84X1xdQ==
X-Received: by 2002:aed:2d62:: with SMTP id h89mr5256449qtd.193.1601515347718;
        Wed, 30 Sep 2020 18:22:27 -0700 (PDT)
Received: from localhost.localdomain (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id f24sm4160239qka.5.2020.09.30.18.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 18:22:27 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v13 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Wed, 30 Sep 2020 21:22:28 -0400
Message-Id: <20201001012228.5916-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001012044.5151-1-peterx@redhat.com>
References: <20201001012044.5151-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't clear the dirty bitmap before because KVM_GET_DIRTY_LOG will
clear it for us before copying the dirty log onto it.  However we'd
still better to clear it explicitly instead of assuming the kernel
will always do it for us.

More importantly, in the upcoming dirty ring tests we'll start to
fetch dirty pages from a ring buffer, so no one is going to clear the
dirty bitmap for us.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 752ec158ac59..6a8275a22861 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -195,7 +195,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				    page);
 		}
 
-		if (test_bit_le(page, bmap)) {
+		if (test_and_clear_bit_le(page, bmap)) {
 			host_dirty_count++;
 			/*
 			 * If the bit is set, the value written onto
-- 
2.26.2

