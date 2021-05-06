Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA86A3754E6
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhEFNj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:39:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234282AbhEFNjZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620308307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3vDcPc2Lwo5z0s8ItWutJUQDssHj4SCpM1PcCRAn5U=;
        b=QRau2uHS6G+HWVTwmcDOgVnRuVh3MkMaP2cYoeOnezZG8xw6K5TwSN4n4uLMsAtuWe7x6y
        OVbGWnk3NbBR+1aompcBchjeJ8nAtI25UpR/fYlEPHXwIhxad7WuoUfIf5Vd77yV+gJce6
        CkEnqrYkWeCNuMJBzkDSftPQ5JazNS8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-yBaaPpAWOvGutJNKz-xXpA-1; Thu, 06 May 2021 09:38:25 -0400
X-MC-Unique: yBaaPpAWOvGutJNKz-xXpA-1
Received: by mail-wm1-f69.google.com with SMTP id d199-20020a1c1dd00000b02901492c14476eso1345301wmd.2
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B3vDcPc2Lwo5z0s8ItWutJUQDssHj4SCpM1PcCRAn5U=;
        b=ll7OBTLWh64obsrrqkS80P0wOazTKUuADTcPtElrSvIy3+dN/cjdBv8He8snX62IER
         sNi3ff944q/MY4ZeMfuFR0rstYfVsMar1bvvF8dhhYrYCao5JFr47FLyXAhIGwxSIAQQ
         zRFyR9P/opFxg/OwsdbwepE+7XCAaFQ5yCdHOmBkD1GS3ITz5Urkcb0AtD+FEw5R7dJp
         h9byFej1KBu55XJOjv6qDpbzJGJbRSdxKKo/PR/4qyCDSsv648m0L9Ia3VX2YRr+cwH8
         r8Mwxp/6N5iEAqsoRM58gyf0vf03jyW7TmdOmK1wWyBAseOBEeGWcaqRyjphsNoELCZe
         o/9g==
X-Gm-Message-State: AOAM530X8z1qRyS4BCwI94QfKadO929c7+tT/GpkZQ0bOOICLFzgQQ15
        ap6bKV5F8hwj5JmI6/KVoaytwJSmNsv3nhAKJnwp89RzbtbbC3AWJ5JxAQvb0rP/vVY+V6oSbYe
        LXIaUu2czvCDh
X-Received: by 2002:a5d:48c3:: with SMTP id p3mr4659223wrs.150.1620308304640;
        Thu, 06 May 2021 06:38:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwECKu/BlFqjZgy5iMIlrOtoOiBjrMgG2/qWWwpALxiW11/+mDQsXIqidjTaJhIgu3oXy9nPg==
X-Received: by 2002:a5d:48c3:: with SMTP id p3mr4659202wrs.150.1620308304482;
        Thu, 06 May 2021 06:38:24 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id c15sm4424312wrr.3.2021.05.06.06.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:38:24 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 5/9] gdbstub: Constify GdbCmdParseEntry
Date:   Thu,  6 May 2021 15:37:54 +0200
Message-Id: <20210506133758.1749233-6-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210506133758.1749233-1-philmd@redhat.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 gdbstub.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/gdbstub.c b/gdbstub.c
index 9103ffc9028..83d47c67325 100644
--- a/gdbstub.c
+++ b/gdbstub.c
@@ -1981,7 +1981,7 @@ static void handle_v_kill(GdbCmdContext *gdb_ctx, void *user_ctx)
     exit(0);
 }
 
-static GdbCmdParseEntry gdb_v_commands_table[] = {
+static const GdbCmdParseEntry gdb_v_commands_table[] = {
     /* Order is important if has same prefix */
     {
         .handler = handle_v_cont_query,
@@ -2324,7 +2324,7 @@ static void handle_set_qemu_phy_mem_mode(GdbCmdContext *gdb_ctx, void *user_ctx)
 }
 #endif
 
-static GdbCmdParseEntry gdb_gen_query_set_common_table[] = {
+static const GdbCmdParseEntry gdb_gen_query_set_common_table[] = {
     /* Order is important if has same prefix */
     {
         .handler = handle_query_qemu_sstepbits,
@@ -2342,7 +2342,7 @@ static GdbCmdParseEntry gdb_gen_query_set_common_table[] = {
     },
 };
 
-static GdbCmdParseEntry gdb_gen_query_table[] = {
+static const GdbCmdParseEntry gdb_gen_query_table[] = {
     {
         .handler = handle_query_curr_tid,
         .cmd = "C",
@@ -2420,7 +2420,7 @@ static GdbCmdParseEntry gdb_gen_query_table[] = {
 #endif
 };
 
-static GdbCmdParseEntry gdb_gen_set_table[] = {
+static const GdbCmdParseEntry gdb_gen_set_table[] = {
     /* Order is important if has same prefix */
     {
         .handler = handle_set_qemu_sstep,
-- 
2.26.3

