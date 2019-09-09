Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEB0AE049
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 23:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731619AbfIIV2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 17:28:36 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:40859 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfIIV2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 17:28:36 -0400
Received: by mail-vs1-f66.google.com with SMTP id v10so6574139vsc.7
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 14:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=e2ktFZF09JWLvJgyosojNipCBqZF/U6ANeFGH386vZY=;
        b=DqmJDzLVtc5n3gFDdkT4xNhlH7aB8uCN+EUtM505vt+oBK3bojBx5gsOP2hhjLyF64
         GstoTU5ulX60fo3wrs4+Nc6WN+Wi5dozDJwmJyAn7nTEeQ1Fu75IGIG9dltPwryZMwWF
         rYn3iaSbuTU4JbipfjtyBhwyOp4n85MHdTUKrnCB/uL6ctYndEwAG1i/uIaEwUcisd+l
         0ZvzKAX25ttBV4JSZTW4W2m6HfJSuTelMUu4FJZly11lGcp+Qn3jvPOsUzlXWs/pQTxP
         FQpyN9aZDZK7OOHUwUIkT/kpWwbBSedseQNmC5c/D4Q4iBrd5HVsrVvPpK9jD+wu0PyR
         Qo8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=e2ktFZF09JWLvJgyosojNipCBqZF/U6ANeFGH386vZY=;
        b=ImKfaprVidOriM0OapQ0rtf+M/i+ETmOzfrYPgfY6G8EBMLGXTXJwUlUqgX5he3dWA
         fMsvnCTiMCNa6edwbH/eFxZVznevPlGJO60ZsxLHtaWTpQa/mPExkwgcMwYek07uw1xz
         KcParLZfgenb9D9wY3tWOhUNfGnPjQuJoxEzg9+TvL9WcIxeNZmWYWdVd3HnXz6sWrwy
         aqECOvQvZ0+XZrY7gDGiSE+k6wynZqpCO9Vv5TfYmjAZ+NhfgP2rrIjg4I7L4S7X7VdZ
         9dyhWLwBc8GqWGYwaH9gqaY7iieFzGvVncKAjOcREon7YwnFz6CD25zNIQ5MeYXiyeuL
         pAxQ==
X-Gm-Message-State: APjAAAWnlI2QGSY/L8JGe9oTN7PgpF1omd1tAO6e/BUj528S+2lADf+3
        ujxhbD5PrKSuEbu9z/fiAt3Tc54pH/uoufTLcqc1/IXG2YDv
X-Google-Smtp-Source: APXvYqxdOt+tN+BcSksjGDxpPNwLV3d8M7uVFuEMzG3E/geIkgYUNmWTOeLa8LB1m950yVTPfbE6mNcNWpFb9Uz3Di4=
X-Received: by 2002:a67:ec18:: with SMTP id d24mr11152565vso.80.1568064513635;
 Mon, 09 Sep 2019 14:28:33 -0700 (PDT)
MIME-Version: 1.0
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 9 Sep 2019 14:28:22 -0700
Message-ID: <CAGG=3QV-0hPrWx8dFptjqbKMNfne+iTfq2e-KL89ebecO8Ta1w@mail.gmail.com>
Subject: [kvm-unit-tests PATCH] x86: emulator: use "q" operand modifier
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The extended assembly documentation list only "q" as an operand modifier
for DImode registers. The "d" seems to be an AMD-ism, which appears to
be only begrudgingly supported by gcc.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/emulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index b132b90..621caf9 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -799,7 +799,7 @@ static void test_smsw_reg(uint64_t *mem)
  asm(KVM_FEP "smswl %k0\n\t" : "=a" (rax) : "0" (in_rax));
  report("32-bit smsw reg", rax == (u32)cr0);

- asm(KVM_FEP "smswq %d0\n\t" : "=a" (rax) : "0" (in_rax));
+ asm(KVM_FEP "smswq %q0\n\t" : "=a" (rax) : "0" (in_rax));
  report("64-bit smsw reg", rax == cr0);
 }
