Return-Path: <kvm+bounces-46797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15BD0AB9C5F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:41:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 841DA505AE2
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 12:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9334724336D;
	Fri, 16 May 2025 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZcAU6l9D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD6824291B
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 12:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747399203; cv=none; b=hx3Wp9eaCUorhFd7UWpk082c2lkviMAwS3g5mXXbbAdi0nw/KHCzRq0hEBQoJ32sKj43sy5S00dJxnflQBXcM9xzc8g2R3eu8OSreprTG8i5omUJcTnrmnZiFddSsgyuzSPUJLiKx+30mQedK6A7g1a7l7NZD1EegR+KY88AF04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747399203; c=relaxed/simple;
	bh=bmgaT7YD2EJBkYL7K7imFqPWf1lV68fhOx0CtwG7grA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uzhLdOUx7W5+K7IHy4kAoXU0ygOAA2Rmn3zvdvW5ZZyNNc9gCmEFOZ3T07kRpfBzNNkWWDRB3FTD/spY7gKJK2pzbhnDkAA9RQyM5BotaYQBvsvzEsoZXB47bJd6pKW4ONV6po9sZOKJtrKJ5wotGV9/HAez6Kvt6LaJp+niJas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZcAU6l9D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747399197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uhz3U140ohpt6ccWc+FSce3umZsRmkKP4Ya4jbqjSpE=;
	b=ZcAU6l9DPNixTTyS990GRXSnuzumZv/RuYyuMcaQJc8MPcVBBZCvG1pzk7Qm8Ft7+d360I
	Kjq5oGFZ3+x4IeufI/Pt46FNft6UdB6lJd6ApazMrLU35LmUA+zeFf1QlWj1nzAoB314sy
	EiPCKyNFdT0qT8lIU1qOV8T8mcF5ZIM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-Nj-lUfHUPWChCtR4-bMBuw-1; Fri, 16 May 2025 08:39:51 -0400
X-MC-Unique: Nj-lUfHUPWChCtR4-bMBuw-1
X-Mimecast-MFC-AGG-ID: Nj-lUfHUPWChCtR4-bMBuw_1747399189
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso10933235e9.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 05:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747399188; x=1748003988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uhz3U140ohpt6ccWc+FSce3umZsRmkKP4Ya4jbqjSpE=;
        b=nQgCnmtZqa7X637D8YGM2CGbskC0CbzeGpCd8QgBk5dq8z1L5GjACyfIHiR/8W5e88
         9WGjwlkF8eR46QgSSjB1MvGOjJNGIViEssy8L5gGkU0PJR1fIHdG7ee7K3W5bO80p1R4
         sZUHa67qBR1RqaMvlBUwRfpzUGGMdpwxrJw9lWgo3VpwesYKAuRzYJnwKr66/owv17bf
         I6daOI5Xe69Kf+xvJN8LU8grdkRJYh4LHcJ7lgnOv173m0ZB+1ipHWFfYIVtgMYkoUsO
         AxBtontg+aM1coYdJTFEREawYX7yIHJi8q0gGyABOv02b6D7V3kTAP65NhIe3d2noXFe
         0i9g==
X-Forwarded-Encrypted: i=1; AJvYcCXa72o6G3JwXP4BTnxF47jDhVKN16+uY6Q7rY9f6sSCIzc5BGMdxGDw3xTQBzcDXpBu/ek=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJfMG9pVxPbBhE9nw/VW7VAaaN0mLYzr6aP9DD3zWuXR8ZGqSY
	V8GWYUmCOxg07HpPi72TYTVMJZgONuydbovJwMlZo9rV/KsW7R/EKwPbwuyTp4/PFmxIYYpbn3j
	dUkkiHASOji4PpcANnhXczNQ1kstKrKRSuJbnBOxy+VapDqtKr3SJGw==
X-Gm-Gg: ASbGncsDdQU+ygWz6FU343Z6iora4Lf8gfcss8hO1GpTjg902Xn/fhRD2buQqKZX3YX
	3htlubALlE0C88sOr4SFQLzw/iYrFnRf1YCprViZELrz0s7FEEhhr5ZceYUbtHtNEKyBzMmoS76
	fGcdoSmhkXyF3YNZFGGN48uQsslUxkxqRFQnhxQUEhJyqkXPpTva3iFvmLtp4URybYC/Ft2ky9Q
	c4zb7Ma5UTsSn4C74UisGSEqC7LkPVzq2oP0KgmDNASye41axJRfqBxZAedgyPxsJFGmryDPAAB
	oF0v3oet7oYG4/n9AEAQtSm1Afhx+C1Vzm4KqrXdZg07qgXbuQlRLzIxTE1qxaO3EWfDvEAf
X-Received: by 2002:a05:600c:154c:b0:43b:c857:e9d7 with SMTP id 5b1f17b1804b1-442fd93d4fcmr26794445e9.5.1747399188628;
        Fri, 16 May 2025 05:39:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG02eCs69TcqCLt8j2+2wKH4FlJPCCyiADW1BjCbtX8Ej+iIBeRfP51iBLLuyg6K1U4dIYtGg==
X-Received: by 2002:a05:600c:154c:b0:43b:c857:e9d7 with SMTP id 5b1f17b1804b1-442fd93d4fcmr26794325e9.5.1747399188282;
        Fri, 16 May 2025 05:39:48 -0700 (PDT)
Received: from localhost (p200300d82f474700e6f9f4539ece7602.dip0.t-ipconnect.de. [2003:d8:2f47:4700:e6f9:f453:9ece:7602])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-442fd50b30csm31929825e9.9.2025.05.16.05.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 05:39:47 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Sebastian Mitterle <smitterl@redhat.com>
Subject: [PATCH v1 0/3] s390/uv: handle folios that cannot be split while dirty
Date: Fri, 16 May 2025 14:39:43 +0200
Message-ID: <20250516123946.1648026-1-david@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From patch #3:

"
Currently, starting a PV VM on an iomap-based filesystem with large
folio support, such as XFS, will not work. We'll be stuck in
unpack_one()->gmap_make_secure(), because we can't seem to make progress
splitting the large folio.

The problem is that we require a writable PTE but a writable PTE under such
filesystems will imply a dirty folio.

So whenever we have a writable PTE, we'll have a dirty folio, and dirty
iomap folios cannot currently get split, because
split_folio()->split_huge_page_to_list_to_order()->filemap_release_folio()
will fail in iomap_release_folio().

So we will not make any progress splitting such large folios.
"

Let's fix one related problem during unpack first, to then handle such
folios by triggering writeback before immediately trying to split them
again.

This makes it work on XFS with large folios again.

Long-term, we should cleanly supporting splitting such folios even
without writeback, but that's a bit harder to implement and not a quick
fix.

Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Sebastian Mitterle <smitterl@redhat.com>

David Hildenbrand (3):
  s390/uv: don't return 0 from make_hva_secure() if the operation was
    not successful
  s390/uv: always return 0 from s390_wiggle_split_folio() if successful
  s390/uv: improve splitting of large folios that cannot be split while
    dirty

 arch/s390/kernel/uv.c | 85 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 72 insertions(+), 13 deletions(-)


base-commit: 088d13246a4672bc03aec664675138e3f5bff68c
-- 
2.49.0


