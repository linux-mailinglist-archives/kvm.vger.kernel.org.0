Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F1650C676
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiDWCRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiDWCR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:27 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BDB223C41
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i69-20020a636d48000000b003aa4ae583bcso5960759pgc.14
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RGenDiR0ZcLVqMaJHYtAxEAhb2eb3EmoI6gfQimOxU8=;
        b=jzTs+CKyCF2je0Je2OZVpPMBUjSzfqPrEV17e+v9Tvq4OBlFPnJaOrsax97rn4QtWQ
         0HPB2ziE3zuBhQYXHtmNGy/weNzkHojxTOyhfdEP1qlBfi8GMXy7MSffHg1t8hFIzDsX
         Yj+8urZRvJekIERa/htKYM84/ZQFFpAR71VzOGjDOCwV3L7PpylzyjL5ldzGnn1d7KwE
         Va6/LdC8V6C6a+YN1mszCNKvCpg8SoxMMtnMIHbol1WBM07Of51j4l5kpR3XbtdnxBX4
         cf2iQzTRDtzfaucfF/shswKdoX6wCxlGm2WiPS+oQ/9n6f8zYh7MwWrKUMCjA+QxVz6r
         nJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RGenDiR0ZcLVqMaJHYtAxEAhb2eb3EmoI6gfQimOxU8=;
        b=njk3q/jIw7kT6mU0ZtLzA93TtJBa7Ct+JtzPVOmCA5diSgWPPt6/ga5xP9SUOqV1GB
         DR+WEO6Jj5JsnavQaIMGm2FjrvgQOeZBetAagXoF8iFXOAUC2bWKKC7KfmWm5z8PUix/
         W3qVybfiwTQT3QtJcA02I9hYUchskaj3R24X54L8TFze8u5BQ++yyZv49/VLeFekbK1R
         KcfA7UIR3ncV2HS13FRwTeYLxPh6wnBZWQyRMdPMoyhN7h+dfUxgHW8uNhr+tnEUGK/i
         j14d7Cu8Eh8+cqXQ6gtRx2MP8ykwLsfDTqhEjgGHNpmcC2p8UXyAucVbEABb9oAtRB3n
         v9qA==
X-Gm-Message-State: AOAM530T2AWGiwgAcC2H4JVrpI4qIJMe8605EROPLyXVIVYWmg4BVja8
        Jl92o+p3YQTPzEkQQepyn3HfNk23WC0=
X-Google-Smtp-Source: ABdhPJx7DfzNQ+mxhJvDS3YfMqoaVGp3gPjGg1aTFtRTllkuiwAoMZ8TpHnjL+0JLlrM14S5gtxLts6ixB0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:16c7:b0:4f7:e497:69b8 with SMTP id
 l7-20020a056a0016c700b004f7e49769b8mr7948529pfc.6.1650680066547; Fri, 22 Apr
 2022 19:14:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:08 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 08/11] KVM: x86: Print error code in exception injection
 tracepoint iff valid
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print the error code in the exception injection tracepoint if and only if
the exception has an error code.  Define the entire error code sequence
as a set of formatted strings, print empty strings if there's no error
code, and abuse __print_symbolic() by passing it an empty array to coerce
it into printing the error code as a hex string.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/trace.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index d07428e660e3..385436d12024 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -376,10 +376,11 @@ TRACE_EVENT(kvm_inj_exception,
 		__entry->reinjected	= reinjected;
 	),
 
-	TP_printk("%s (0x%x)%s",
+	TP_printk("%s%s%s%s%s",
 		  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
-		  /* FIXME: don't print error_code if not present */
-		  __entry->has_error ? __entry->error_code : 0,
+		  !__entry->has_error ? "" : " (",
+		  !__entry->has_error ? "" : __print_symbolic(__entry->error_code, { }),
+		  !__entry->has_error ? "" : ")",
 		  __entry->reinjected ? " [reinjected]" : "")
 );
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

