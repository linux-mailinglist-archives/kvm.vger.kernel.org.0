Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4CC4944A8
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357816AbiATA3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357862AbiATA3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:29:38 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BB3C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:37 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id o9-20020a170902d4c900b0014ab4c82aacso708090plg.16
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4MC6d0yHRYoMsTEg2KKjfkUTAJY8zSLYHw4vhT35czg=;
        b=MCqnW1IqqPINwTYy4F14Ed4xfyBnPBUYk3aV10/YwT4CD2mOD9pLn84YQ0YV3ZgYQ2
         /+kMI2bhl4xyndnjoDknYMvT01lNkiLBULnFlC2YkEWlL3Ikgb9SATyKYXknPNGTzRGi
         EDl7QiJo7qEcPf2lKM52OW/DjGuBR3AEgVJQ7e4HVjqtAX5SyER9eZSQQMcaKHaIjuqX
         QClDXiHBUd/QxBQqryTIJby1Tlmvjw80E8PX3uYOl5MbvXKqSiaaPoRCBVzPtDSshcZ4
         hztf71VZE/UQahE0FifMlLXM6BCGXLpX6Bo6ujqIi9lV5hDjanA8T+z1S7hAWDhXREWx
         nYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4MC6d0yHRYoMsTEg2KKjfkUTAJY8zSLYHw4vhT35czg=;
        b=NHqqWxA44fgnxQsj7RJ1l/VmLREiuYWSuCj5OfncscSnFkqYL0DL1t56LxhxsTCbSm
         raZMPiiV8r6SNyng9e7og/fnuvWicnmpoJN6PHVcu1DJ1ExOKg1GolUivqxGCvJ5M19T
         yH0MwPVwMklvbIiR87sqAyPYHQdI+Z61aTt3XsZNqYC18QKHuxPGrETd7GLE5KfTuWGd
         bo5hsjohZQgrv9nj9tSrlZu9kuQ09CF0zQ4AP3q55OyybooD9kIHv7UJPq+NhXRo6hr+
         834OFNl/GIPsIkHZytjXhp+y1czcnhWqDBoTOAXJ7F2eUSQDe681mS+tajumolxWj7MM
         /5wQ==
X-Gm-Message-State: AOAM531n/bd1v3+xqEeVIuf5idh7XpwBPyezL3Rl20VDkIh7BuPxJT82
        aE9k3RyvtnxivgPl/+RSaqmfR5iA+TU=
X-Google-Smtp-Source: ABdhPJwMsShOerBppp0D3JSJKCJD308OWGxzrSEZp6/ZFzR97724k6Wyz4ia83zSyNcm6QE64CePpbnI63E=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1c8f:: with SMTP id
 oo15mr7292806pjb.125.1642638577504; Wed, 19 Jan 2022 16:29:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 00:29:23 +0000
In-Reply-To: <20220120002923.668708-1-seanjc@google.com>
Message-Id: <20220120002923.668708-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220120002923.668708-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH 7/7] x86/debug: Explicitly write DR6 in the H/W
 watchpoint + DR6.BS sub-test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly set DR6.BS for the sub-test that verifies DR6.BS isn't cleared
when a data breakpoint (a.k.a. H/W watchpoint) #DB occurs.  Relying on
the single-step #DB tests to leave DR6 is all kinds of mean.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/debug.c b/x86/debug.c
index 0165dc68..4fec241f 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -417,6 +417,7 @@ int main(int ac, char **av)
 
 	n = 0;
 	write_dr1((void *)&value);
+	write_dr6(DR6_BS);
 	write_dr7(0x00d0040a); // 4-byte write
 
 	extern unsigned char hw_wp1;
-- 
2.34.1.703.g22d0c6ccf7-goog

