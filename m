Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF3F4257B2
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242264AbhJGQVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:21:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242610AbhJGQU7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=raENXGoMd83njG9X2No5AFJQfUuVjvhwyUCC5K+pe4w=;
        b=LeVi/e0jpwBveUMQPTrg7o2Q6WeWc09cBScJovYpMBwKqYwaggy0Q1sgpZpP6ssYXIlyuc
        4bWWb3RIXtLUw04Cpidks+9epXP+k6vrRUkZStoO8wg1o0uAt2g+nRrOOi6HnwAsUDZeTr
        FAkpoKigDG32OZJsHIERu5YXQA88Uao=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-tsoTdl4XPoaPCAbgql6vYg-1; Thu, 07 Oct 2021 12:19:04 -0400
X-MC-Unique: tsoTdl4XPoaPCAbgql6vYg-1
Received: by mail-wr1-f71.google.com with SMTP id j19-20020adfb313000000b00160a9de13b3so5124554wrd.8
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:19:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=raENXGoMd83njG9X2No5AFJQfUuVjvhwyUCC5K+pe4w=;
        b=ZWqJDs9W+9hXUntPNHu+Hp5yRKOoMAkdvojpc1lZRQYMw21uhRtuY+wYDcXDzBvdp1
         ROm6ry+R1zaTONDFhOK/fEU/2rI/yeYyzCr2lwlVLJhXOJc6BUsEgyvPfsfs5PhMQFpo
         usjPDwoZqs0HG1oywlb7Xs0rgFaTxaM7r79q5LE6eZFOkg6JeMDpiuGiJNPJcRQaAmab
         WJAwS4Yfkwj8hfW5uO1LPjYKd9kYzxnAlYpBVfBIVz22263Xu7CBBfdFIqTW0lh119Qa
         RHCOlkGTRsaUNNgmILELYYRjusIyh54RlwDGTn8HlKSWlWYWTXzHf/n0ZbK2uff4jx+3
         mW1A==
X-Gm-Message-State: AOAM530ir2SyuB7iVGwO1ZyJcxzFEopsnv5RRIXgxah+TdRIJfyqHJzx
        uwrQBRFrhgmLCLdKQnxiMH7XlxawMingzIc72kABuMIZ6FhcOm56NlTFBUVRDatyXr8p6jOgP3m
        IhrLJ9fb4uqk6
X-Received: by 2002:a1c:21d7:: with SMTP id h206mr17449923wmh.23.1633623543156;
        Thu, 07 Oct 2021 09:19:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLVyjk8Yjb8T3LzpyyPDRcvNepzAgqY2opRKw88FbZnxb/11utVAJlVwGyacRlavjgmwnmOQ==
X-Received: by 2002:a1c:21d7:: with SMTP id h206mr17449901wmh.23.1633623542998;
        Thu, 07 Oct 2021 09:19:02 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id d3sm78771wrb.36.2021.10.07.09.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:19:02 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 23/23] MAINTAINERS: Cover SEV-related files with X86/KVM section
Date:   Thu,  7 Oct 2021 18:17:16 +0200
Message-Id: <20211007161716.453984-24-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Complete the x86/KVM section with SEV-related files.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 50435b8d2f5..a49555d94d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -417,7 +417,9 @@ M: Paolo Bonzini <pbonzini@redhat.com>
 M: Marcelo Tosatti <mtosatti@redhat.com>
 L: kvm@vger.kernel.org
 S: Supported
+F: docs/amd-memory-encryption.txt
 F: target/i386/kvm/
+F: target/i386/sev*
 F: scripts/kvm/vmxcap
 
 Guest CPU Cores (other accelerators)
-- 
2.31.1

