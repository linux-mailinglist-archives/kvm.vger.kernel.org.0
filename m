Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB54BAE01C
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 23:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfIIVAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 17:00:49 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:34461 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfIIVAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 17:00:49 -0400
Received: by mail-ua1-f65.google.com with SMTP id f25so4822158uap.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 14:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=iVGgwSWwHmexfKVbElUaVodcVwvI7SqR7HiFZZHgimI=;
        b=smvs3ouhvA0YvTEpruQ7DAxHZ6sC05J8+PvDKiJ09NEgLC7y8UmM7oXJg/Y896OEi3
         lKLhbCLTGUgXTIkLOxNaZD3QuVqY4P1Qze4wUWuh1B7RI0/7BVEI3HlPb/5rUszemnxl
         eJeN/F8NuoN8XmqCOmqOulRYwXOB8WjLcPUV8hHJXpxY8oK0VVAWGEo3fw6/90oFK0oi
         Hgf/1A1YrpH2paMfvqa4fbf7gIPP59e6ULhv8nZ/ufU83rzyi6JiBpLLAD6Ii6ozWlQY
         m9bsil2Na4tMU1ws8Ig105mHd4c8lAnqXwdMEsB51GGlpNtCMQ7pD8v36aOB1YwjE7wm
         hPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iVGgwSWwHmexfKVbElUaVodcVwvI7SqR7HiFZZHgimI=;
        b=MOfrZ2nx7leAxSEkG7hOwCT5dRhl/8pfsEeDAxzPMZf9pC4dwgNUyZbC3XqhX6yBrr
         BH3o8NQyvnnXlHmE1VGV2hxd/DX87Q0idynF9HmMaIiPcgZ1zF8rPYOcIX+5iY1pxCRh
         MAogiAP8F6ePkbNEsA8/Bo3btASnrF+ht0ogrL9MUcfj5kjIGrxWF4G5CVhTAu52CrdF
         KuKEUrs9opEQsVyFom7V3U3yUd23JlBRcaCD95SPkl35I31a5yJycNji9of4VWlxDvoG
         20gcGntfM1hXI++8pvD/a05qg5fpBuPe4pwGLtZ38eLYH5kCB9mMhR4PKLhyfCzjgZox
         NtmQ==
X-Gm-Message-State: APjAAAX1zfsBH1RQfYaYL0ImTQRJSS9hKk1qHTdKYFyZeOoZ4ljsGjio
        1hRQXTcE1fouNgxC02svJ7WGdq9W/YUleeRxXbGatLiHfKxg
X-Google-Smtp-Source: APXvYqx05tpDmPNJFOG1Q1CFqnMLxIiwOgvv06S0sUxIRp2N/gCHHelerm93DNej+jYdMQl8T2gwhG0Du8PgZeGLIw0=
X-Received: by 2002:ab0:2a8c:: with SMTP id h12mr12223915uar.106.1568062846203;
 Mon, 09 Sep 2019 14:00:46 -0700 (PDT)
MIME-Version: 1.0
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 9 Sep 2019 14:00:35 -0700
Message-ID: <CAGG=3QUHwHsVtrc3UYhhbkBX5WOp4Am=beFnn7yyxh6ykTe_Fw@mail.gmail.com>
Subject: [kvm-unit-tests PATCH] x86: debug: use a constraint that doesn't
 allow a memory operand
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "lea" instruction cannot load the effective address into a memory
location. The "g" constraint allows a compiler to use a memory location.
A compiler that uses a register destination does so only because one is
available. Use a general register constraint to make sure it always uses
a register.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/debug.c b/x86/debug.c
index f66d1d0..2327dac 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -113,7 +113,7 @@ int main(int ac, char **av)
  "and $~(1<<8),%%rax\n\t"
  "push %%rax\n\t"
  "popf\n\t"
- : "=g" (start) : : "rax");
+ : "=r" (start) : : "rax");
  report("single step",
         n == 3 &&
         db_addr[0] == start+1+6 && dr6[0] == 0xffff4ff0 &&
