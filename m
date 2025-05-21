Return-Path: <kvm+bounces-47215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4449BABEA79
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 05:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA33B4A171D
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 03:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE6422DFA8;
	Wed, 21 May 2025 03:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="KXhLhxjG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11683B66E
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 03:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747798490; cv=none; b=nQWX/Q5Sog6sSduYfzWeNbHIVdX6e2dCEbRimAh2iegJQfzId6AYuXZzZGEh3iNDQk1uFHr1FViFLZuy0Z/y1bpJF1al/ym04zh4Dwp3zG6VoMM3msiHyWe4pBgnFfkiNI//Nj7WNiT0QjofMAuW2J4jFwC89g0WIqdOFmnjk2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747798490; c=relaxed/simple;
	bh=Zk66fyEM2zx49X5y0UFZoranSZ+jdhIWtz5HJh7HXr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNTh7LE/DlsQ35fHWBi65ATqHl8WcEHDivBHKQSpv1gxXX+N7HwXQ/2gHi8Omu4Xd9o1od29/n9HxZ7vMyiNZYZacJbB55ieRcVU1A/TN1CjrC85PQXKWpv4aSA53Vo0YPIKf3nUXVGwL2Yr+EqPmSbDLv1h1FEgC6RFBAAEz+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=KXhLhxjG; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-742c9563fd9so2834944b3a.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 20:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747798487; x=1748403287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QrF20aYmOuDjKY3rsnSXTn3j3mYCZ/2UIOF9yf2b/qU=;
        b=KXhLhxjG6MvuKO6HUXN+WOnBBAp4V6OaGCdpG/iDobBMJLqnVjQN3tY7L3ojtKQ/yy
         wsWDHW2HCM6Q+JQqW5DqpTx8fKIA7oRDIFPS6HZW/NF+ozRZtpdmv9ALTBInhsIi9xdR
         wqR2qbW5R+G14XsgmLrrqHhw4P0cTe7xXwqD0ftNq8/ducJbiSe71UI26WC9gkxJ46xY
         PzV4wysT+1si6XRnGr8kjIsTBukbrdiW7SDfv8Fg7r1+YTttSQUXJzRFFjgK4p/Nk7+B
         PH5tpwbSN7QOJ9ZLcAqYRIYWTOOXEkeNeRzve+hoWzpb2s+ZIV+ohCRegg3PXPlrbo4e
         VT5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747798487; x=1748403287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QrF20aYmOuDjKY3rsnSXTn3j3mYCZ/2UIOF9yf2b/qU=;
        b=nFwBvr1c7yb38e4UymOf+dcbe2rV3bFihAb1s6ni5n8RZNhvefqRfByVjwqZEta5YD
         6OCbq8dSW1IwWarFgoUx9NhACGxe8bXxrXLhgt+RtGbzUmxWduLLe1dmg+3DiYM4EOKl
         JUaydtZbSPkyQg+a5pMd48ybMweSgQv2QWfXukzwxlPwX4OPE8JxOIpA0OGeYvLtkWuo
         v/XUUGV04J/cy+KPR2MZbghYcGAZwXgjN4Wki854uR2x/YNy6aS4/S0DLWwaJgf5u5vU
         JKHg9Wrg1RjwOU/moJ1JKmNBMCSQU1Og9v3z7Gvn/zc6V+ufPpieY6cPv/7KcyDUJOkg
         GQog==
X-Forwarded-Encrypted: i=1; AJvYcCXNWbXYjj6vhc5gX1cyMBV6irb3LHqFhlPQv+r70GUEWqQUd9OL1HM+gAclHgLiF9a5iHk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf8PSLksT4AIH7X6kSRj1exd1us2gRnws2UjEtYEZeAnOJKTsY
	H7KVBAOtyNuQkScxQBr2r8qVpBUOv1nHpPS4l4pusKKd//WJ9lLm5FMXVf0Q/IMat3M=
X-Gm-Gg: ASbGncu7NmR9eUWD/OrTGUC4CwS6u2x6H5WB05mXEpV1GqH5293E5NGw9v+At9QCEXW
	0AHZ/QC/iKHAe/7Hm/e+BKTyQDVsKjM/jSCnOUx6ASnv8c0X/6UlP/twRTuh58du06wJepFw0gV
	XZ3OrHnqBauWS9D1DtLVr6cYzMrQiozQF86Z1A/T2mfELoV5/LiwImzWqOTCacdSxiFAPqzUV7H
	y6KKgyu2+aREryDfpcecstcHtP2ZZIl3794d8CzuLmSg1Qqc8Mk8FowBhIz/0bzozie/2tv2kOG
	y52UhDRQnpAUfkTIiojHhMR1gA4wFHYEbXOGrBngOcGLm3oyB7y3QmmG8u7oOsVpPX200T3YgqR
	H+h4=
X-Google-Smtp-Source: AGHT+IE0BDXpgbrb6T16TX0bUZrcxSHGXSW4xi9rTQEqrY/nzVnAq9tlVCT/3bjK+FISbu389N58cw==
X-Received: by 2002:a05:6a00:858f:b0:73e:1566:5960 with SMTP id d2e1a72fcca58-742acd507c1mr24045768b3a.19.1747798487243;
        Tue, 20 May 2025 20:34:47 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9709293sm8604835b3a.37.2025.05.20.20.34.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 May 2025 20:34:46 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	muchun.song@linux.dev,
	peterx@redhat.com
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge folio
Date: Wed, 21 May 2025 11:34:40 +0800
Message-ID: <20250521033440.72577-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250520080719.2862017e.alex.williamson@redhat.com>
References: <20250520080719.2862017e.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 20 May 2025 08:07:19 -0600, alex.williamson@redhat.com wrote:

>> Before this patch:
>> funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
>> 
>> After this patch:
>> funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();
>
>It looks like we're using the same numbers since the initial
>implementation, have these results changed?

Before the release of each version of the patch, I have conducted
performance test, and the results have consistently been in
close proximity to this value. Consequently, I decided there was
no need to update. I will include the latest test results in the
next version.

>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>
>Appreciate the credit, this should probably be Co-developed-by: though.
>In general a sign-off is something that needs to be explicitly given.

Thank you for the reminder. I will correct this error in the next
version.

>> +			/*
>> +			 * Note: The current nr_pages does not achieve the optimal
>> +			 * performance in scenarios where folio_nr_pages() exceeds
>> +			 * batch->capacity. It is anticipated that future enhancements
>> +			 * will address this limitation.
>> +			 */
>> +			nr_pages = min((long)batch->size, folio_nr_pages(folio) -
>> +						folio_page_idx(folio, batch->pages[batch->offset]));
>
>We should use min_t() here, otherwise it looks good to me.

Thank you once again for your review! I will correct this error in
the next version.

By the way, using min_t() also resolved the build error
reported by the kernel test robot[1].

[1]: https://lore.kernel.org/all/202505210701.WY7sKXwU-lkp@intel.com/

Thanks,
Zhe

