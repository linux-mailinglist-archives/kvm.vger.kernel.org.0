Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FCF54D53C
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347671AbiFOX35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiFOX3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:29:55 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3897013E3F
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id p123-20020a625b81000000b0051c31cc75dfso5757232pfb.5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UPa2qRsj0spolXYuBb6nQbQiFRfDL61mBkMfsRuMG4Q=;
        b=hXUUCoBvy5NvC8lv7jHqLVGetdigwUeWXyVKsCcoVSHfycfpY2jVKQHVAgc0ExBqXW
         QRGVmssbm5lyeF84aB5rTSHN3TJvSlZWFeZNLKi290p5ZK7Wdq3mO8oPPJxomJG9smOR
         Ok7rtdWDRJbChjK3RpgNcBgZO/HqKXN1i4rn3acK+sLn1pLxD8gztoFqxJiA1OYddK84
         8FmUbU3JlhAKyHNoZNxZPI81Dqy9ld5zd+G3J4mOsmv+hww6YOSJpIDTh72zVGVRk46Y
         7uF5NyA+FoOZ7upEmnTJsI25PWuEXXhhuqt0d4xH2vU5oKpkiFcGJo34+dptQkFg8KOD
         q4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UPa2qRsj0spolXYuBb6nQbQiFRfDL61mBkMfsRuMG4Q=;
        b=Z1L2P63SsjiISXpJ0dQTN626rGQHSHWrO57kul3eVEwxUy8/e6zcmTAqW1QrECZMRp
         yJbR8gMko0sh5Gh4t+6drzVBmMJmYeB703PlGjrpKsygNNcbxVU5k7D/+C15hxtulmJr
         1ik5fiOtiz5sEpJtbtU+C/euhwiF2KG68tUCWzVAzOOcglpbC/1+6hUlydKjFq2/zozd
         2WtXWt7nXSDY5pFLAiiE5NMR7I80V4ZdVRGcSDE4EdifAsXFnYQ5NYOHWCBSQBM4rE9I
         PEyowa0vBYPvKfEWueCpYiHKOyPapbatboSGjM0VMXxqNy1xyjoxJ2DlxH7Hs1VzMEQo
         uBwA==
X-Gm-Message-State: AJIora9qshA7r9P5VrloVwbVlO+QmFKhGgp8TRH9O2Qh7ZRUNOYal4Ij
        usKh5hHdNt3KWHJqw3NYTzbSZcb6ywY=
X-Google-Smtp-Source: AGRyM1s0WsSP25NFfYuaBZuoSnOQPchCznFhpHUuaCLbmL4YvLcWE6sZX9h7DN46zGLyBb6BDZ9xmBNCGHs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6c86:0:b0:3fd:ae53:3881 with SMTP id
 h128-20020a636c86000000b003fdae533881mr1832968pgc.507.1655335792603; Wed, 15
 Jun 2022 16:29:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Jun 2022 23:29:31 +0000
In-Reply-To: <20220615232943.1465490-1-seanjc@google.com>
Message-Id: <20220615232943.1465490-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220615232943.1465490-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kvm-unit-tests PATCH v4 01/13] x86: Use an explicit magic string to
 detect that dummy.efi passes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>, Thomas.Lendacky@amd.com,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print an explicit "Dummy Hello World!" from the dummy "test" that is used
by x86 EFI to probe the basic setup.  Relying on the last line to match an
arbitrary, undocumented string in x86's boot flow is evil and fragile,
e.g. a future patch to share boot code between EFI and !EFI will print
something AP bringup info after the "enabling apic" line.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 scripts/runtime.bash | 2 +-
 x86/dummy.c          | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 7d0180b..bbf87cf 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -132,7 +132,7 @@ function run()
 
     last_line=$(premature_failure > >(tail -1)) && {
         skip=true
-        if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "enabling apic" ]]; then
+        if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "Dummy Hello World!" ]]; then
             skip=false
         fi
         if [ ${skip} == true ]; then
diff --git a/x86/dummy.c b/x86/dummy.c
index 5019e79..7033bb7 100644
--- a/x86/dummy.c
+++ b/x86/dummy.c
@@ -1,4 +1,12 @@
+#include "libcflat.h"
+
 int main(int argc, char **argv)
 {
+	/*
+	 * scripts/runtime.bash uses this test as a canary to determine if the
+	 * basic setup is functional.  Print a magic string to let runtime.bash
+	 * know that all is well.
+	 */
+	printf("Dummy Hello World!");
 	return 0;
 }
-- 
2.36.1.476.g0c4daa206d-goog

