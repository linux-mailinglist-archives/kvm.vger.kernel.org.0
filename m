Return-Path: <kvm+bounces-28573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 881E49995C1
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 01:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 397511F24708
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 23:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8A71E6DFE;
	Thu, 10 Oct 2024 23:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="PbcmzmOd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5383D63D
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 23:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728602946; cv=none; b=cCO8Rruy9LtL61fHvjL6fyoqPrFiZ3nB5r+QL9tIbGvhTYA/CCcPmoXS06O2ICnYlYzkMDT7tjx06av3ddWEorOOYr1gdrvPOZlYayJc2cpa9C/npgvev2diCS3UTSYD6AG30VStiCm3DojvkwnzfweGjQASl6OZ9eJsVKi9Cog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728602946; c=relaxed/simple;
	bh=qhxtr0861iUazl7E2WWpsRyiIFFKSp/cpUYYZzk9HM8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=A+PARgfzU/nDRSumxdb3BttyNRKaz3sLbWMD9OcjJ8QGJlcJDDhavwndjzri5z5IrEbLfBTTGXIkH4uEx2masSMcyld0Xk+Ea7T9az2t4QONY5VonMJDyCBwxlaWR4j2ge/wgSafcXX2vmJNUubXPSmZbSz/JNGXSH1WLg08ZJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=PbcmzmOd; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-710f0415ac8so741650a34.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 16:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1728602943; x=1729207743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pt+ij4HcNd9U5a+oDXTzNBVuHOfxLLxKSMThJADgjsQ=;
        b=PbcmzmOdjtrZ1qIWdpbMD4jAf/eAEKv5EMqWCoUmsvi2DJy1lhlak6we5ZLKrH20Km
         x2Mkkd+RYz4Lb6qZ/JpNaw9T6WT6FJVAmTRxwbTo9ITscSIZWmum6Gru9C9IyXR+E78E
         u80/0ZfPA/PMi3X3pS8+REGaYHp7957YSmh6qpeLk1nZ1hi7OqwEztIrCbkd7lAT6uZ/
         liBTH6p5RG0eWg2BcRoavnGn/joXURZ8E7JAg6nFhGO14HBOKApq2+ojMui2hOKQHxZ3
         p3WGKuUGGQ1+yfs+tZthwQ2gW4ZZegevCBJ3lYpMvolw85+Xi5GmC7iD/jdfkv77HKza
         aCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728602943; x=1729207743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pt+ij4HcNd9U5a+oDXTzNBVuHOfxLLxKSMThJADgjsQ=;
        b=Sj3IcPMAOuJM3YiQ0LiWdXv/3LsWuCPhH6uixlvNqBA3g7rztT95lpujylv6/BA9Wp
         P+EPIwwd2tK6/J1fhkoYynYoyidSvqnTqU3WnLb4XzcrQlMsqCVf9/vkEMULAGdhFeQV
         rKuatQ4nm/2NVZjjeA+FjYAvtn4nEUgX82ZSlWEO1f7RWw170ABdwqR9IIbkeeUXMgoY
         H/tcjSX+fBHTTLNsVelG9JfmE9c9ht5QPbfuwmU7w21MX9WxPSynU+l6P2c58q0YW+O9
         SRWWxjovMyCx4h4c1juJBesbPLN9TNWUc56Kt5nFhoJkyqsJtNYqHt1t37X6LgGploCG
         nqRQ==
X-Gm-Message-State: AOJu0Yw7VPBZC7FiNnWzDQ6+VUCrAiKupNCZ9nsGn5YRi5COc2XdzML2
	fX5zNEwSv4J9mTnppeBmvoqaaCh/Fi6hKYxC2TmWWO2dCI1/+zoQ8IAj+ITOZyubkIzLsbVgOmw
	=
X-Google-Smtp-Source: AGHT+IF2C9PfWQ6TjqL3N9SIlsUBbTqFObiKPif2hfR7N3n10clQKCx95GiT9V73wH6rYFN4ao641g==
X-Received: by 2002:a05:6830:6e17:b0:70a:94b4:6e67 with SMTP id 46e09a7af769-717d647b8efmr884669a34.23.1728602942743;
        Thu, 10 Oct 2024 16:29:02 -0700 (PDT)
Received: from aus-ird.local.tenstorrent.com ([38.104.49.66])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-717cfffadc5sm376953a34.54.2024.10.10.16.29.01
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 16:29:02 -0700 (PDT)
From: Cyril Bur <cyrilbur@tenstorrent.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvmtool] riscv: Use the count parameter of term_putc in SBI_EXT_DBCN_CONSOLE_WRITE
Date: Thu, 10 Oct 2024 23:29:01 +0000
Message-Id: <20241010232901.492061-1-cyrilbur@tenstorrent.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently each character of a string is term_putc()ed individually. This
causes a round trip into opensbi for each char. Very inefficient
especially since the interface term_putc() does accept a count.

This patch passes a count to term_putc() in the
SBI_EXT_DBCN_CONSOLE_WRITE path.

Signed-off-by: Cyril Bur <cyrilbur@tenstorrent.com>
---
 riscv/kvm-cpu.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index 0c171da..f2fe9c2 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -178,15 +178,16 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 				break;
 			}
 			vcpu->kvm_run->riscv_sbi.ret[1] = 0;
-			while (str_start <= str_end) {
-				if (vcpu->kvm_run->riscv_sbi.function_id ==
-				    SBI_EXT_DBCN_CONSOLE_WRITE) {
-					term_putc(str_start, 1, 0);
-				} else {
-					if (!term_readable(0))
-						break;
-					*str_start = term_getc(vcpu->kvm, 0);
-				}
+			if (vcpu->kvm_run->riscv_sbi.function_id ==
+			    SBI_EXT_DBCN_CONSOLE_WRITE) {
+				term_putc(str_start,
+				          (int)(str_end - str_start) + 1, 0);
+				vcpu->kvm_run->riscv_sbi.ret[1] +=
+				    (int)(str_end - str_start) + 1;
+				break;
+			}
+			while (str_start <= str_end && term_readable(0)) {
+				*str_start = term_getc(vcpu->kvm, 0);
 				vcpu->kvm_run->riscv_sbi.ret[1]++;
 				str_start++;
 			}
-- 
2.34.1


