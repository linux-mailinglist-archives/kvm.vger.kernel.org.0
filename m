Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB16A55C86C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbiF0JwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 05:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiF0JwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 05:52:02 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83A263F4;
        Mon, 27 Jun 2022 02:52:00 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w6so8501947pfw.5;
        Mon, 27 Jun 2022 02:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Q6vNqHtByULLuwlMYokh8M6QKN/nQOW7XhVlI32XvI=;
        b=Kiael6nFCPylmyFuNwE31jPNeRHitvbu8aU1umMjoTKot0kymWLndRiyJebU+ItFc9
         ym7vuqtT+lUQeo7n0JKLAMZMCaDYhB5Lc7V8j3HymPWVRLMAMKnvSFO291bG8JUFNk68
         5f1n58+jPjjlIXD5xW5dcPBpt+JpHbhmulRSSCgeHhSRndQilAMen0lEsgZmrBe/uYZv
         u+BouIyQwnrkrSEYPoItK5Y9WZyLrPMR5Gz45NxCEknEOjwnxwI0UuGvXtG7rCsSUiMh
         h3Gyzxb+HSr1KqB6rWXdmhdgZE9tSwZvdBRtoYGz9JqqETAZysNXz4YeM/H2X7yO6K23
         Qavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Q6vNqHtByULLuwlMYokh8M6QKN/nQOW7XhVlI32XvI=;
        b=k849Q4QqxrFdhinmVnKs+g7+8aUOCDT3wkfN9pTeOv5l7sR2ub1vJ9oK7kEysOcTRW
         aF9g97EwTlQ9x40++e7J4DQ1mk+3s8QOMzya9bDU7aeMU95tKWOFYi1N8FD8K3y9HKzh
         02C7P/8I7fv2HfQXmmqbK7bSbiZFXovOdSGKSd9CEB12qGR8FaKEVb3FETMN5QE/TXEt
         XTbxnGsDd62jKO6E6vO5aPbIt1XdaxZD2cRCYx9+I1vcuU9L9nsljYkOEeYl7zcz3b/u
         J53oxBHJX/MHzyZzHdULhiAQi3C08IloBf+5n7uxISwnaUx7ur9zE3ojFQ+1CxKbykWN
         ctYA==
X-Gm-Message-State: AJIora9NV/kYnxQ68J0fuYg8kbMc55rRbZ6WO4bAGaraJ081DNNtYI8F
        GRLKknskqOAa8CKQbJBjn64=
X-Google-Smtp-Source: AGRyM1vPHPxUzliUdXL/xMATRU6Mb/pkFyZ26i4yj0U/WzUiP9+UVCMvPaNn1DD+1VIONSGhXTPcTA==
X-Received: by 2002:a63:cd52:0:b0:3fe:30ec:825d with SMTP id a18-20020a63cd52000000b003fe30ec825dmr11812265pgj.82.1656323520442;
        Mon, 27 Jun 2022 02:52:00 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id n13-20020a17090aab8d00b001ec9b7efec2sm6753928pjq.5.2022.06.27.02.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 02:51:59 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 953BA1038E5; Mon, 27 Jun 2022 16:51:56 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH next 1/2] Documentation: KVM: extend KVM_CAP_VM_DISABLE_NX_HUGE_PAGES heading underline
Date:   Mon, 27 Jun 2022 16:51:50 +0700
Message-Id: <20220627095151.19339-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220627095151.19339-1-bagasdotme@gmail.com>
References: <20220627095151.19339-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend heading underline for KVM_CAP_VM_DISABLE_NX_HUGE_PAGE to match
the heading text length.

Link: https://lore.kernel.org/lkml/20220627181937.3be67263@canb.auug.org.au/
Fixes: 084cc29f8bbb03 ("KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bafaeedd455c38..ec9f16f472e709 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8207,7 +8207,7 @@ dump related UV data. Also the vcpu ioctl `KVM_S390_PV_CPU_COMMAND` is
 available and supports the `KVM_PV_DUMP_CPU` subcommand.
 
 8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
----------------------------
+-------------------------------------
 
 :Capability KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
 :Architectures: x86
-- 
An old man doll... just what I always wanted! - Clara

