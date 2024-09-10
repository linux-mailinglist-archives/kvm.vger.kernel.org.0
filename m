Return-Path: <kvm+bounces-26389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9496A9745C4
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2289DB253D4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CBA1B4C56;
	Tue, 10 Sep 2024 22:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WRSeQlZw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017F91B4C26
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006695; cv=none; b=aXzkyMhdbO0EyRm5w1FaV5S/QQvoStrAlUh8JPafhwZmBRW0tsD49BaXRFvOaIRgpOo7AFsLRCaiDKBfbrVrmiaWvi/mpBonjw5NUzhc0jlurgSIGGnvUqT6bF4Hp+v6h2TSJgluxfceIIAGzGBQm+UsKoppj3r4iq9OE6+ehJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006695; c=relaxed/simple;
	bh=tEryYMdiHZfMyGfxOhmuqxgxr0q5IHrgMjp04AZWD6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TPjIhG7+bTMQn/2ftIsObiKPseUPP4BP7kfxJ9n7+OGKzzq09XkkVUD/bS5yrbMb1BN6DJ3kZ+wytgSaXIkcuMf75fbUpfKWwl9VKnWFglfSKfWiD96UDfNOloYHEs9941Sqkrhcw6S08L4yKw021rADgrw0RM0ZxtO6J/5Cmn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WRSeQlZw; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-718f4fd89e5so1254173b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006693; x=1726611493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAUNG2Z8iwfixvozuxuZzI5U7SDFeb08Hf/Nr+6pfa0=;
        b=WRSeQlZwgdYKX8DsypaMwbehY63BY9OlK5fU944AVQwIuTqeTX46/HYOOonDJZRzCR
         z5q7Qs4M7ek8P2z4NmKnpHxbc1rl3w8lgM+vo5fadxJM0Sl8M1j6qcHCrsRSMVmuIllZ
         KE4hU1zeCiKoMBgAsL5t3V3dn+Sb2O1fseQpIbWb5gwiXgBIxG4C8ymyzxwzjAdTsc7D
         oIynsJk6/kBw9MymsqRfLDOTxl2Hmpx9FAX2T3bChpzQtTKBTLkKGfPk27CzL3mwAayM
         8KW3qls4hZoMzFO1C51ATZypjx+V5fVp0ZzRhWMujRXrCeOe0LFW0K/4weEnPzbyiIf8
         LDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006693; x=1726611493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WAUNG2Z8iwfixvozuxuZzI5U7SDFeb08Hf/Nr+6pfa0=;
        b=UJd41wjF4/iMQpWW4iw7dNnDy6sPLo2E1Hf9js3mz4tOcYk077bQIUGY26K7FpvGJY
         07ZO0qYa1GpHaaxKm6SfERiPioPXhgaJEckyiqqr7dooWZMJrt0+XZWtiayxmdhocXPF
         El+zuI1LuXagDlMzwO8nJCqSlfs7Qd3RJolAU2D63FQ35d5zbwMmeoQpuztM6JOWHAOI
         +gpwy6ia0EtIJhH+NcHYSq4oqGFTnTEHX2IwcuK+RD4X7W1LyfdBRuf6thwTX1hn73Dd
         wpK56FsKC1UatB6nMCTvljM3Q8m29URZOXQxp4+khB8EDMCTxg1B7qnGFo14Be89nC4+
         bF2g==
X-Forwarded-Encrypted: i=1; AJvYcCW0uJGwsXCfVLN2GhX5lHW0oCaxLJ+GMJXm2bwJLVBHXXDzHEHMnodjd7otU7XaasI7mco=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyY10tWNjypbXMGq45TDND2C1kiVYqCFyJxasBQjjQgb9d5N4A
	iJPX5uVbqlKTY8hwfhZurS/rJOdJYKqMmbFoxioCiuBKq/3MlEf0QT/mTibOeyI=
X-Google-Smtp-Source: AGHT+IFGhI3LMnJRi+254dAZqpPbVgzsgGXn7sXIi4XpOoxOVhAxol60+FTs3bT9dBxAMQw1ZiUN2w==
X-Received: by 2002:a05:6a20:e609:b0:1cf:42ab:5776 with SMTP id adf61e73a8af0-1cf62d5ca4amr1800943637.32.1726006693348;
        Tue, 10 Sep 2024 15:18:13 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:18:12 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>,
	qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 39/39] scripts/checkpatch.pl: emit error when using assert(false)
Date: Tue, 10 Sep 2024 15:16:06 -0700
Message-Id: <20240910221606.1817478-40-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 scripts/checkpatch.pl | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 65b6f46f905..fa9c12230eb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3102,6 +3102,9 @@ sub process {
 		if ($line =~ /\b(g_)?assert\(0\)/) {
 			ERROR("use g_assert_not_reached() instead of assert(0)\n" . $herecurr);
 		}
+		if ($line =~ /\b(g_)?assert\(false\)/) {
+			ERROR("use g_assert_not_reached() instead of assert(false)\n" . $herecurr);
+		}
 		if ($line =~ /\bstrerrorname_np\(/) {
 			ERROR("use strerror() instead of strerrorname_np()\n" . $herecurr);
 		}
-- 
2.39.2


