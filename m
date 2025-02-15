Return-Path: <kvm+bounces-38275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE99A36C48
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 07:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DA0A1894F86
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 06:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F6A193086;
	Sat, 15 Feb 2025 06:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="x7OeW8F8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FE21624F4
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 06:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739599506; cv=none; b=fkxWMr4XSMPxG6AlD2CF7zdm5lRMMVfkBn4SKacYdpWiOH7WGLZJbZ38wZqTczW+1v4wmtwVtoxsFviIH1I++at5Tw7HQ91e9XQ5cWPDBK815uaRU2RSjxa0UqF5c1K0Fh3b3pqM1NzFRf/ZZBoR5un8+a11qsN7y0VvpQ9k7wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739599506; c=relaxed/simple;
	bh=p2c/thFQqA2f6zTlTTsMJKHXAHt05q1wXjQfa65msec=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=OGv/b2xhIFwZgli9+xj+SzvKGgCvkgBceYv9T39Gq9mNp3D3/DAu+QfMihhdd2ynkQ9p1SFSXtDYlThAPo8ZWT1ZGwJZZcLOXTBeT04o/uhQ79SiAFFkebC1gNnVkZ+pfd/lJekXktZUFvvq5508J3BXILKefqO8kwVH9Ac3NhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=x7OeW8F8; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2fc3fa00323so1086832a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 22:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1739599504; x=1740204304; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M0i3rAU9TgZ1Zz0MhhHSh60Ea+b9QKMgq4pEb6ogGOM=;
        b=x7OeW8F8cHXPOmNKa5BDOs9TMpvoH82pn80WeUfnVZFVeZtGU4BgrQPHWWPTvJC20q
         fv+MQsmOJ4RBGGVEjGxl9rwZQWyaxxv1ZnsgvfgtOrvJOGNbAuPdxmyfUGZFrWuEsHRu
         Oyom0RKU4G3Y27+PQBJCvoajytSynTfHtsDEvsG6/nuuk5I0RRUPc9DLfa6S86kMugAE
         bqaymOjMH2Er+YQb2A19Rgmux1Y9Ks3YkY2J1VVLw1GM9A84Y2ghxilqENljEvy4/h84
         DXF0fv4xiOOIqkikEyMWeBv+uA3Lzc/GYi4i07JEH3KnpFKrBxwZ6Z4tDAdq4LjwFTks
         fS+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739599504; x=1740204304;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M0i3rAU9TgZ1Zz0MhhHSh60Ea+b9QKMgq4pEb6ogGOM=;
        b=iRZ3sQmSmj99JC4KECLHNS3IeVwhCZfVCFKxt33jp6jQ4fQDXY+8mmAGpDrDD1RCBL
         InoDGooIOr1qCcbutBv7ADITPEWZr3ujA/KQBXTYcJWuamWy+1isblVF41Hw8XEp89vX
         npHjxVLCxSujavUgLvWAdw7lLTdMJ055oqCqotksu+WHczBKdrfZG830reH+fuenMeyk
         le7+3RHhsh2V433e30rV0Hcul/r7tMSPrg2B9993766Sdii13LGIwV1TGAA3Kl/widlm
         K67AWhQV1uEn+tRmvmEDZraCEDIbp5+WCuK59WnOa5U4HY3nAX6iUd8uKUAmq7G+NgzL
         ZHaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbzVzfVoHgsfQ2CuJq37NKbrKbH7axf01VInZjZmk+U1P85ZPe6C8Dmp80oN3G4dlDaHk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCXaNjFcFFu3NvHCT1HFGx3aeCcgETKENOROrfkVX7F02LJmZc
	gDH/ADZjQajfB1iNYl3Wk0xzTeEpmYT7oKubGWI468D20YTxtovXsjY6V5l3Ifcmo6OB6So+nXM
	0KEg=
X-Gm-Gg: ASbGncvI+wJEZGoxJbnQO1nJbCtmPHiZR1mF/kM2/qoL+cSTYVAY5Rogm2eeaZVujnk
	ymLVFGYmQUtfGl8iFavVfYHGASp2o5UEe6UM7QhuOSM45YzScyygAutrFmL2iT+80zJ+CQNL5lv
	97SJFv7THe1P+kJXkReX67QpVEfq7Tl5Y51pUvZrfcpS6NbUtqI6IDpmZ7C1//X63FYms8QtvZy
	pFr7nfasOoowYDORUfadLawFbfO8tICUVJm28u7u01klP1CEtauxdGpGvLa0muwbb1bTfJnUkQe
	6Aly1BUt0UYMdYM9hSU=
X-Google-Smtp-Source: AGHT+IFsNJehBsouPtXrJ7NS9YGEa4MnrstGirWvcWdd4oXF0UxNUAuboQan1xDS6hUFV2zvLI2IVw==
X-Received: by 2002:a05:6a00:21d5:b0:730:74f8:25c8 with SMTP id d2e1a72fcca58-732617bfb2cmr3520739b3a.11.1739599504057;
        Fri, 14 Feb 2025 22:05:04 -0800 (PST)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7324276169fsm4215019b3a.140.2025.02.14.22.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 22:05:03 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 15 Feb 2025 15:04:50 +0900
Subject: [PATCH net-next v2] tun: Pad virtio headers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250215-buffers-v2-1-1fbc6aaf8ad6@daynix.com>
X-B4-Tracking: v=1; b=H4sIAIEusGcC/z2Oyw6DIBBFf8XMujQMvqqr/kfjAnGoLIotoNEY/
 72ENi5v7twzZwdPzpCHNtvB0WK8mWwM4pKBGqV9EjNDzCC4KDlixfpZa3KeNRVh0Wsucq0gXr8
 dabMm0gMsBWZpDdD9GkefOaLDvz7J8REXBYqcszBbVkUml0XTc1W3S5XWo/FhclsSXDDNk4vA/
 HRZkCEjVUh+E9iUtbwPcrNmvarpBd1xHF+oDfLB5wAAAA==
X-Change-ID: 20250116-buffers-96e14bf023fc
To: Jonathan Corbet <corbet@lwn.net>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, 
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
 Yuri Benditovich <yuri.benditovich@daynix.com>, 
 Andrew Melnychenko <andrew@daynix.com>, 
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
 devel@daynix.com
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14.2

tun simply advances iov_iter when it needs to pad virtio header,
which leaves the garbage in the buffer as is. This will become
especially problematic when tun starts to allow enabling the hash
reporting feature; even if the feature is enabled, the packet may lack a
hash value and may contain a hole in the virtio header because the
packet arrived before the feature gets enabled or does not contain the
header fields to be hashed. If the hole is not filled with zero, it is
impossible to tell if the packet lacks a hash value.

In theory, a user of tun can fill the buffer with zero before calling
read() to avoid such a problem, but leaving the garbage in the buffer is
awkward anyway so replace advancing the iterator with writing zeros.

A user might have initialized the buffer to some non-zero value,
expecting tun to skip writing it. As this was never a documented
feature, this seems unlikely.

The overhead of filling the hole in the header is negligible when the
header size is specified according to the specification as doing so will
not make another cache line dirty under a reasonable assumption. Below
is a proof of this statement:

The first 10 bytes of the header is always written and tun also writes
the packet itself immediately after the packet unless the packet is
empty. This makes a hole between these writes whose size is: sz - 10
where sz is the specified header size.

Therefore, we will never make another cache line dirty when:
sz < L1_CACHE_BYTES + 10
where L1_CACHE_BYTES is the cache line size. Assuming
L1_CACHE_BYTES >= 16, this inequation holds when: sz < 26.

sz <= 20 according to the current specification so we even have a
margin of 5 bytes in case that the header size grows in a future version
of the specification.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Changes in v2:
- Dropped the code to set num_buffers to 1.
- Incorporated a grammatical improvement suggested by Michael S.
  Tsirkin.
- Added an explanation of this patch's risk suggested by Michael S.
  Tsirkin.
- Noted that it will not make another cache line dirty.
- Added an error check.
- Link to v1: https://lore.kernel.org/r/20250213-buffers-v1-1-ec4a0821957a@daynix.com
---
 drivers/net/tun_vnet.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
index fd7411c4447ffb180e032fe3e22f6709c30da8e9..58b9ac7a5fc4084c789fe94fe36b5f8631bf1fa4 100644
--- a/drivers/net/tun_vnet.h
+++ b/drivers/net/tun_vnet.h
@@ -143,7 +143,8 @@ static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
 	if (unlikely(copy_to_iter(hdr, sizeof(*hdr), iter) != sizeof(*hdr)))
 		return -EFAULT;
 
-	iov_iter_advance(iter, sz - sizeof(*hdr));
+	if (iov_iter_zero(sz - sizeof(*hdr), iter) != sz - sizeof(*hdr))
+		return -EFAULT;
 
 	return 0;
 }

---
base-commit: f54eab84fc17ef79b701e29364b7d08ca3a1d2f6
change-id: 20250116-buffers-96e14bf023fc
prerequisite-change-id: 20241230-tun-66e10a49b0c7:v6
prerequisite-patch-id: 871dc5f146fb6b0e3ec8612971a8e8190472c0fb
prerequisite-patch-id: 2797ed249d32590321f088373d4055ff3f430a0e
prerequisite-patch-id: ea3370c72d4904e2f0536ec76ba5d26784c0cede
prerequisite-patch-id: 837e4cf5d6b451424f9b1639455e83a260c4440d
prerequisite-patch-id: ea701076f57819e844f5a35efe5cbc5712d3080d
prerequisite-patch-id: 701646fb43ad04cc64dd2bf13c150ccbe6f828ce
prerequisite-patch-id: 53176dae0c003f5b6c114d43f936cf7140d31bb5

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


