Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF3CD814F
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 22:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfJOUqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 16:46:19 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:37860 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389450AbfJOUqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 16:46:17 -0400
Received: by mail-pg1-f201.google.com with SMTP id h189so15939119pgc.4
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 13:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=quKYm0mwun9UM5OyPYkD/7dKTJN6At1fRn2/XNsALnY=;
        b=lsR2teOpZi0PGMPRfXOfIXhnjavNDWfV3OOfWXQhPJZXPHLWTHzFIuc1S3zOq4IpBS
         g/8zKjnkQrLSohTosPcfGlmBjjXtbELDCSvqRk6+1uyjpUX1ugCW2Cg0iTXwpH48UN5w
         uq2NDlykaAmlaiNbZq43O890o7fxBTe6oEw9EmbZGPNpIL/fZqXwLREj8szYYoA/9lUI
         vxzDiyFB7k4EIVoQHIdP6haEzD8FjY90nDRony+en4dlHQpObKvGzzM6gqpCq5NYoBUM
         t/pOXCoY2gqA4nYkmaGaErtFJT1E8LOv2BIxbIRXMrP88yPeGbRCRnRwx6n9YXnxTcUZ
         nS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=quKYm0mwun9UM5OyPYkD/7dKTJN6At1fRn2/XNsALnY=;
        b=TOR4ZWFeWxUA6ZR1dKJtgqht2vubY0IlQJoCihvQyaRT8OA4xGVVx1dzcRs3upEcJm
         bw7/RrSr76ZE0tGoFF0zO+9sUm8ET9tne/7ncJQ5fGdQ3iFcCyaXvDr3W+D2qhBk/cY7
         Dfc2SqHPyvEzIerUkLIksqZ/LVSJUiz4jCwF251D71Dd/qgTvsht9hHTTkmye10s5+CH
         EK2RLtl3pCKLwvmBXjLRRyMWrdaIOgNwBv8GepkBN86ylQIzc6ecB8WBg+ocTxcdg7c3
         k+tTaJQGAi7p2BJiaGmA9Wr+7QNOaiT5hW8Nm80Wu31wEeYUs1xbbI0pC4e46J4Zb1rc
         Z/dg==
X-Gm-Message-State: APjAAAUaf/4VozlvCL+PP3NzOmlFjvv1Kz8mbcBxscZScwOSctsb6EwR
        LxwD6B9MrIK72Fs8S/myfMyHZAeCvk/MlCoKTL1vk6Ngv/j6N5udXGRZONigE3RAvnzR4t9FpY/
        ERyN7YHvkQ6QUbQfiGqj5FnXERBB2pzt/YptromVtPlKecNFtSzZwMg==
X-Google-Smtp-Source: APXvYqycK9pnKJEmTPgPTE5gxSPjSUqDAV4kyORDA3KCrLW21kuu43GDGOb6DdmMuUcBmxAlqyCUQyuNfQ==
X-Received: by 2002:a63:cf4d:: with SMTP id b13mr39874674pgj.396.1571172374258;
 Tue, 15 Oct 2019 13:46:14 -0700 (PDT)
Date:   Tue, 15 Oct 2019 13:46:03 -0700
In-Reply-To: <20191015204603.47845-1-morbo@google.com>
Message-Id: <20191015204603.47845-3-morbo@google.com>
Mime-Version: 1.0
References: <20191012074454.208377-1-morbo@google.com> <20191015204603.47845-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests v2 PATCH 2/2] x86: don't compare two global objects'
 addrs for inequality
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        thuth@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two global objects can't have the same address in C. Clang uses this
fact to omit the check on the first iteration of the loop in
check_exception_table. Avoid compariting inequality by using less-than.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/x86/desc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 451f504..4002203 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -113,7 +113,7 @@ static void check_exception_table(struct ex_regs *regs)
 		(((regs->rflags >> 16) & 1) << 8);
     asm("mov %0, %%gs:4" : : "r"(ex_val));
 
-    for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
+    for (ex = &exception_table_start; ex < &exception_table_end; ++ex) {
         if (ex->rip == regs->rip) {
             regs->rip = ex->handler;
             return;
-- 
2.23.0.700.g56cf767bdb-goog

