Return-Path: <kvm+bounces-22076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9A1939800
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 03:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0FBE1C21955
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 01:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292191386D7;
	Tue, 23 Jul 2024 01:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CngP4lFD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24791369B4
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 01:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721698843; cv=none; b=dNV46oe/+1KwW1kh6RG3v2GXFBRZ0NhKCj2FSP97dMyKCaJq/UabY/CNmVPPEmPK2CNvtoXU2ilnugyZmhbDLODgnOjGLg9XU8yK/ljKwWsidEA5XgoSUpWhoULnmWPjvmD7cW19dsBb8W135c1GTV8N7/02m0b8mP+c53zbrb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721698843; c=relaxed/simple;
	bh=mXMwe7QfWwZZX25jxlawu2AU02xw0yh685W/Xsz2Tl8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qfTfQU3o0F6zpR+YFp6qdX68ZqnSDWUrFeQzKJEJSFwgAIlmcFMWUTsC4xakf/Vikqh1tA1JuubS+9vjS+QdeoUYIZy/9t40JPA0cQLbfooeEX9y/opTWRFzQqitZgzgmNHZHNYrq6+Pja0JBjd/Qbe4EY3cHcqOquuPHtctI50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CngP4lFD; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1fc5549788eso37505885ad.1
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 18:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721698841; x=1722303641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tAPwW2R9RXiwXKmn2Hdsapf0RNjOOXrUnl+0TYu7r44=;
        b=CngP4lFDyxE3FyWqnMmWOU4hewcrNFb7QnWYRmS44RTP8AuKssH07g2/TyvTg2v+7/
         5MGjD2hUQqPMTiRN9Gg+svXEeqjABPatbLe60XrmEdMcqicVgOFDnJAhu8Q4rKiYv7yl
         BLn5qybO5jeHGha95zlqeXxEEmX70ebR0oeVUGjnEMAezCcBnawO2ah+YTs8xT9yefVn
         ge1VjVNBPIT2hrt08TovpOCbsORZpce6gvcT6oYve5XfeYfja5aVKHyPPn3cHk0/PJEF
         UaextnCLrbDrlIISQTbidY8V55gT+uAwWdYCA5yr/NoQbg/SE22DL6L58vviKXnHwL9S
         3lfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721698841; x=1722303641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tAPwW2R9RXiwXKmn2Hdsapf0RNjOOXrUnl+0TYu7r44=;
        b=Ts1KVyVaU4+52IqtHikL4osYD3qiNMLwyty9WuJ5JiPHPhlRv1oJwtVhdagw/5AmUk
         dtL+BN0FtjtxVJ2n4KISzby4QaplV52tlCXqLBG3U09u2zR0sdXXbKYw3qql32RXX/+T
         4RsQI5UBpklfvE2qX9f3/u3gtsyihZJmB+HicfGmIiwUF33KLuU6AIzMq0PGeTvIWvqf
         SXX/kvb1PR6WqKcVjXpavIrsVWtqKBFeCoC9EBgHLush+Yc4/Z6b5PjglHHCMV716Dx4
         JxCCLtdEaSwFjfiirj+ekziZBhTHwmWdN8eWb8vHxd4IMjLlCod0lfqgUmiFuUFR8QsM
         psgA==
X-Gm-Message-State: AOJu0YzkteXrjlBOhuVEtABcg5wBu+lZtDFGyCR1jGo+rzD0xVN2tS8P
	hOzZLoqSSaXSse/2iiEy0nxOKkW3JdsgOZt3OrNRVZ7LusWFnORRJZQkgw==
X-Google-Smtp-Source: AGHT+IHMoMb6JP9FAhGBFrCFCcEBhQfZ/Caq0s/dy5VFM+Mr7oYeCG5BQVl2j+a+r1OmRkTvZkwNKQ==
X-Received: by 2002:a17:902:e547:b0:1fc:5879:1d08 with SMTP id d9443c01a7336-1fd7457cd31mr76502605ad.32.1721698841255;
        Mon, 22 Jul 2024 18:40:41 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f315c11sm61782835ad.125.2024.07.22.18.40.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 22 Jul 2024 18:40:40 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  KVM: X86: conditionally call the release operation of memslot rmap
Date: Tue, 23 Jul 2024 09:40:34 +0800
Message-Id: <20240723014034.55802-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

memslot_rmap_alloc is called when kvm_memslot_have_rmaps is enabled,
so memslot_rmap_free in the exception process should also be called
under the same conditions.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..00a1d96699b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12947,7 +12947,8 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 	return 0;
 
 out_free:
-	memslot_rmap_free(slot);
+	if (kvm_memslots_have_rmaps(kvm))
+		memslot_rmap_free(slot);
 
 	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		vfree(slot->arch.lpage_info[i - 1]);
-- 
2.27.0


