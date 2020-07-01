Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F2621088B
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 11:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgGAJqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 05:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729236AbgGAJqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 05:46:38 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BEDC061755
        for <kvm@vger.kernel.org>; Wed,  1 Jul 2020 02:46:38 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n26so9909968ejx.0
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 02:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/lOuMjqn37ghAr7+CYcTtdGMa1UHjGi1TO5Py8wL70=;
        b=Y/0t9cfTAhD5w4JO0HRkyRv8XzijM4h2KFfV9kdtY0PghVwktHkVxu9su6Qq9v7CMv
         TkwGfShuqboacIAJj7vY8r9fDOKBBetGn8TskxBirGEyBaB0PPmSvjh0ZWP5lMaMYDMR
         U9mASouL9uR9ZlGI70LmwTJJMQnHojuSi2foB28bAILDe1yu/a7B4EX4LajNm5XQrzgO
         fYiX8XuTquvYSvXXTNO6yTs86jkYZ3jkAWsvBWN/TQrnxDrjUrbwVc8c5YV8/A5K6XyM
         HLcKNLOgQvX1CXrI8+YxkR9qTudaCiTw8TUtEYtK2aQrIEPS4notcBOHTMnoLUFu/Ki9
         aX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=B/lOuMjqn37ghAr7+CYcTtdGMa1UHjGi1TO5Py8wL70=;
        b=H0VlcpIi6jbKJhNZ2iW/ZK2EKuaG28QwPV6qajcFk/V14Gf78q40qt3c7qrCx3chnN
         g3ApNvOMSU+ZqUqLq4SPyVKRTXNozUPKX3nfyHeavW4lZz5MNqxkMtAMzNnoviJikLyJ
         oYuGfyZzsUtx9CDZvoghBpZBv8O6qQ75ogbeWS3wa7iw4Y9P2hauJ0nbMRaVXi08J33e
         KNqDCb5yeJBy+Hzmn545lxOh8XRPA7TXP0U5sdevjykb4z+rd1hhWJP5/DLRYptbDa8c
         NJG1lu/7TpRLQ5NdcjrFFCnqQN9MzGIbj7SJMD8wM9xwU0ci6Np+F7uWW+sXuiVLnjZo
         pcOw==
X-Gm-Message-State: AOAM5321QgqXEHW3Zry9+x2o6W92iu3/Njp8cLMvEZddpmpHVLfhjxK8
        mKhYdwM6/ykiWbYutDnaPVXFwm/Oq0U=
X-Google-Smtp-Source: ABdhPJwN1JjFPJq3YM2HXQnaRtEDyRN8PQmdR87nUpn5ERx74WRAgRUCqaF10BywWEV7Eo7osvgbeA==
X-Received: by 2002:a17:906:c10f:: with SMTP id do15mr23256499ejc.249.1593596797121;
        Wed, 01 Jul 2020 02:46:37 -0700 (PDT)
Received: from donizetti.lan ([2001:b07:6468:f312:1142:70d6:6b9b:3cd1])
        by smtp.gmail.com with ESMTPSA id mf24sm4185759ejb.58.2020.07.01.02.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 02:46:36 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>
Subject: [PATCH kvm-unit-tests] scripts: Fix the check whether testname is in the only_tests list
Date:   Wed,  1 Jul 2020 11:46:35 +0200
Message-Id: <20200701094635.19491-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When you currently run

  ./run_tests.sh ioapic-split

the kvm-unit-tests run scripts do not only execute the "ioapic-split"
test, but also the "ioapic" test, which is quite surprising. This
happens because we use "grep -w" for checking whether a test should
be run or not.  Because "grep -w" does not consider the "-" character as
part of a word, "ioapic" successfully matches against "ioapic-split".

To fix the issue, use spaces as the only delimiter when running "grep",
removing the problematic "-w" flag from the invocation.

Reported-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 scripts/runtime.bash | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 8bfe31c..6158e37 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -68,6 +68,11 @@ function print_result()
     fi
 }
 
+function find_word()
+{
+    grep -q " $1 " <<< " $2 "
+}
+
 function run()
 {
     local testname="$1"
@@ -84,15 +89,15 @@ function run()
         return
     fi
 
-    if [ -n "$only_tests" ] && ! grep -qw "$testname" <<<$only_tests; then
+    if [ -n "$only_tests" ] && ! find_word "$testname" "$only_tests"; then
         return
     fi
 
-    if [ -n "$only_group" ] && ! grep -qw "$only_group" <<<$groups; then
+    if [ -n "$only_group" ] && ! find_word "$only_group" "$groups"; then
         return
     fi
 
-    if [ -z "$only_group" ] && grep -qw "nodefault" <<<$groups &&
+    if [ -z "$only_group" ] && find_word nodefault "$groups" &&
             skip_nodefault; then
         print_result "SKIP" $testname "" "test marked as manual run only"
         return;
-- 
2.25.4

