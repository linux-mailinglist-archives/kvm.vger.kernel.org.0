Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B363197DC
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 02:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhBLBIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 20:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhBLBHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 20:07:09 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCCDC0617A7
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id g17so5365814ybh.4
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Fhv1Q9NSxxwZmv6ZVWXSl3ZrCdVknKiV94qk2PWj5KY=;
        b=M6sNjp71JNXOPH26XcRa1YdrRCuZtL4Py6H/Hy2tsrpRa6Zhg12Hr8v7orLO2dXdjh
         A+KWhDigFcqg5KAxt2kGBBOqPgYElc0VsDwlZA2Pu6bkeJqiNP+cUu3ccFBa3Ije+s7t
         /jBtoGykJDuAQW+gcKxrwtnONoU/iok5WjANsDmK0mVOR3QwWPLdOI/9/6lIYrWX/kbj
         qKc3QHkhd8jippcsGugpP7eh6otMsYLmveRp715jRaN2Q9Er58/hQZKh9Hb69nKpBwpG
         bRWNJfX7J7x6SC41n4v/QE6e9r+toCi11KhZ7zao+fndrhyuGgQoIlfL3htU2i46BJjW
         EZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Fhv1Q9NSxxwZmv6ZVWXSl3ZrCdVknKiV94qk2PWj5KY=;
        b=TB5aMpmkTVfybXWlrLouwQtCTZEvr3oecc+PdyVbA0siXX7cDAB2cQ3CGDy3qM6PXd
         AqUsqbWCxkA8xakuvVaBiCDeMS9yB2v3B1at6sevht0OJOzxELaRcJbKsCWUb/7VBqjN
         DHRPdVG7di7VUQUu21Q1hTdxVnxLdIva6UuFh9HVtqdqAtFGrlNiN4xW/3pejxsTY0oL
         5MVHbdGUQaL7JZ1RQwhk1S+Jft2OWGyDG3XMdP8w0jI2cLvJ3sRkN0vvgu6EnQwuPqdJ
         jz+FivtYRjF+BOauYP82xdyEmSEgd1YajyTn9ikpfQ+X8Un5u8Ehnvtekcb6V9n4JtRx
         qEkw==
X-Gm-Message-State: AOAM530QjVdTHehVlCVpoxgNF8PgwOwtKRbvlwe6qp2aHoGswEj0p+1s
        V3c/GxF6CpGbHBpb8MPigWs/OTdXTU0=
X-Google-Smtp-Source: ABdhPJxYLiR7Gj05G/CPO+CWigXBb8GTWY0DxsO//rw0ZXfWZiF/u6c32DhhVqZtgdkTylmeNAnIJoMIuj0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f588:a708:f347:3ebb])
 (user=seanjc job=sendgmr) by 2002:a25:908f:: with SMTP id t15mr782326ybl.47.1613091972358;
 Thu, 11 Feb 2021 17:06:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Feb 2021 17:06:03 -0800
In-Reply-To: <20210212010606.1118184-1-seanjc@google.com>
Message-Id: <20210212010606.1118184-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210212010606.1118184-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 1/4] x86: Remove PCID test that INVPCID isn't
 enabled without PCID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the test that verifies INVPCID isn't enabled in the guest without
PCID also being enabled.  SVM allows !PCID && INVPCID, and VMX will soon
follow.

https://lkml.kernel.org/r/20210212003411.1102677-1-seanjc@google.com

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pcid.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/x86/pcid.c b/x86/pcid.c
index a8dc8cb..ee0b726 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -26,12 +26,6 @@ static int invpcid_checking(unsigned long type, void *desc)
     return exception_vector();
 }
 
-static void test_cpuid_consistency(int pcid_enabled, int invpcid_enabled)
-{
-    int passed = !(!pcid_enabled && invpcid_enabled);
-    report(passed, "CPUID consistency");
-}
-
 static void test_pcid_enabled(void)
 {
     int passed = 0;
@@ -135,8 +129,6 @@ int main(int ac, char **av)
     if (this_cpu_has(X86_FEATURE_INVPCID))
         invpcid_enabled = 1;
 
-    test_cpuid_consistency(pcid_enabled, invpcid_enabled);
-
     if (pcid_enabled)
         test_pcid_enabled();
     else
-- 
2.30.0.478.g8a0d178c01-goog

