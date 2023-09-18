Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E8F7A4F75
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjIRQmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjIRQmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:42:42 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F167844B7
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:03:54 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b962535808so74829351fa.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695052995; x=1695657795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MazgQXWzZA8uxNgPyG3XxGvrbp91MALAwpKlSsIULzk=;
        b=UmZqXPs1tP5SRqdWko0AcqEAteC1dCM5coCmlXgGdHZhdrnZ07dXDuuEKzdCqpMVyK
         av7whqbiI55qGzspAldiwiIMbQM+BLgPEqU/F9YyVZaRnhZqftdWIF0zzUR72BgtjdnI
         U2hFNkWPcb7WI0QyrLhrlFnsWbAcE0L5t92Ne50EzOogdzOZKtrRv4CPwCboI6Ifog6Y
         AufZCelsut9jRy0JLgW5tPqd1mvi1Twov4OFOhTLT83FkCCGZ0WGNplPY12/N2qU1q9Y
         WzX2AcEmi+9KLj46Gy31wyG+nhZ1zVUPSbITqgYri1MiyKWibRZ7iQ2/L2AivAeeD3Wb
         dSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695052995; x=1695657795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MazgQXWzZA8uxNgPyG3XxGvrbp91MALAwpKlSsIULzk=;
        b=oTREwfWtuIEhhHFacNPP+ZhW77F3JACwDNvp4Ojp+m4MOOsjfXLRXBOmVfztjaCMCb
         unPGHkqtL7ZBhem+TfiUs0bJUm9Gmp8JZPpfKz5pMneif0Ptxj1JE8PW7OKswtT/si5P
         RnAAuI//rx/0XUaXJS+EwWMKUApDgVtLGXBmAjSrMzdiLBrB96K9nfWvXNCGYWpq9eVE
         evxTiZep/pS/RfDnHhTHGPJZdyOHTlldBYVVEfw8JRr8jXtTwBxkp6zxIBczZ0VxhqWQ
         zcJQ8c4VM6hEH6GG8Q7IRlq3muQ5LQM7zIfqnmu2r3BBcf5uzNlZFClR6zVvY+4hjPkg
         llsA==
X-Gm-Message-State: AOJu0YxZmS4Y6t5/TmEnZ497SRbNdLtGiQgM/J8nCYlH7cDemzmEX1cd
        0C0uLvb7w5LmdYC1bfNPPG+0AA==
X-Google-Smtp-Source: AGHT+IG8278V/bx3bmgpaUhHZZUcMrkwCw5Xh6lMORAxCV90jlud9/Vt30zNUM+Rqe+3rVD6prsUKA==
X-Received: by 2002:a2e:8ed0:0:b0:2c0:d06:9e65 with SMTP id e16-20020a2e8ed0000000b002c00d069e65mr2857839ljl.8.1695052995061;
        Mon, 18 Sep 2023 09:03:15 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id r11-20020a170906350b00b009934b1eb577sm6608438eja.77.2023.09.18.09.03.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:14 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Brian Cain <bcain@quicinc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
        Claudio Fontana <cfontana@suse.de>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Alessandro Di Federico <ale@rev.ng>,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Chris Wulff <crwulff@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
        Bin Meng <bin.meng@windriver.com>,
        Stafford Horne <shorne@gmail.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kurz <groug@kaod.org>, Michael Rolnik <mrolnik@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 03/22] target/i386/kvm: Correct comment in kvm_cpu_realize()
Date:   Mon, 18 Sep 2023 18:02:36 +0200
Message-ID: <20230918160257.30127-4-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/kvm/kvm-cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 7237378a7d..1fe62ce176 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -37,6 +37,7 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
      *  -> cpu_exec_realizefn():
      *            -> accel_cpu_realizefn()
      *               kvm_cpu_realizefn() -> host_cpu_realizefn()
+     *  -> cpu_common_realizefn()
      *  -> check/update ucode_rev, phys_bits, mwait
      */
     if (cpu->max_features) {
-- 
2.41.0

