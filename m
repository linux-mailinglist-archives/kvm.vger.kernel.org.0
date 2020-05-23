Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BEC1DF5E4
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 10:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387759AbgEWIBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 04:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387500AbgEWIBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 04:01:07 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAC6C061A0E;
        Sat, 23 May 2020 01:01:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 5so6057319pjd.0;
        Sat, 23 May 2020 01:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=QvfFGw5HRkt9P9sR+2eqldmFzHs8etHQPKe8AsonXsDhCYDxXJP5zXNTES81YSDMi4
         4c5JTnmqHcOFSoHHvuRQKAsVUVT1YrkgS0Ve27Fcl/Dss46ztS2hA/fz9c7M6Fngk9WG
         EIdc48JVgkgNqSV2Fj+r3696POedovMFBKS9VMmN4KyQJz6dYUu6EbHn6znFLRxy0c7G
         QDjBF1NrGUcv7eW9fYjThlbgY6HB/VAanpc/pe0uOIqrpn7Tpo3d2Cdzk0wXA19XkTFf
         SOyhgSZncMTdgAFGysmxNYPsWc17HbUQUkeaLgzkE5BdolOAWHOGPrQW6RO6Fy0PjtW7
         cunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=Y0mZWoHwLDkZOtQHAcJ1kFwK1NuUduaO19csO3CNzOH/WXTNiji42eHDzcohy/K3QC
         N8VE3wmguzursg6wwqwEzeeeDpAiPBoEtbsabj1YnfwlQgALICO74CwpxeYP2GOnK7Sc
         4IRboQ8b8z9J7vlAAuRDSoOeNJFn+4BGIhNAsZSx9jpBYulbX54wgXNuldgcPThw/bFi
         tMQJPau98HkXzP9BpNDkMSs2/Ntu5SbXYbQFVy4kQAs+Nxdxgg4dShTf+JgFOO3Bp/Lj
         bGXyrmZibo+fF5p/Itm5WaZoj05FZqLjtCaxbilADFVBgGuCGIZZk+LTQUjVPLK43Gey
         4Q+g==
X-Gm-Message-State: AOAM533tchAzkgLdCYJ4u+YL8ieqA6h0mVLF6gUZTX54fMzILjUDD+Hl
        T6AnsyObOZ0/N1vXlZ7se7w=
X-Google-Smtp-Source: ABdhPJxnZ/XEk7CrbzRfeQPW+atT9XG++gSTstut8Cje+l2G0/idnONgtXl8dZsjPWWuTIAMdX1PRg==
X-Received: by 2002:a17:902:bd07:: with SMTP id p7mr17824771pls.293.1590220866206;
        Sat, 23 May 2020 01:01:06 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.01.01.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 01:01:05 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 08/15] KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
Date:   Sat, 23 May 2020 15:56:35 +0800
Message-Id: <1590220602-3547-9-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3's indexed cache operations need a node-id in the address,
but in KVM guest the node-id may be incorrect. So, let indexed cache
operations cause guest exit on Loongson-3.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/vz.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index f9fbbc16..ab320f0 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2853,8 +2853,12 @@ static int kvm_vz_hardware_enable(void)
 	write_c0_guestctl0(MIPS_GCTL0_CP0 |
 			   (MIPS_GCTL0_AT_GUEST << MIPS_GCTL0_AT_SHIFT) |
 			   MIPS_GCTL0_CG | MIPS_GCTL0_CF);
-	if (cpu_has_guestctl0ext)
-		set_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
+	if (cpu_has_guestctl0ext) {
+		if (current_cpu_type() != CPU_LOONGSON64)
+			set_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
+		else
+			clear_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
+	}
 
 	if (cpu_has_guestid) {
 		write_c0_guestctl1(0);
-- 
2.7.0

