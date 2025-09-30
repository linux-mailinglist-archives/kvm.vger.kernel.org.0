Return-Path: <kvm+bounces-59056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D8F4BAB294
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 05:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A3E11C56DA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 03:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C49230D0F;
	Tue, 30 Sep 2025 03:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="KdTteTxS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B5F18859B
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 03:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759203377; cv=none; b=dTXtgw7+S6mTNUh3+UQKJIJbQB7Wnjnlq3r0ecV7Ox0HsRKJWyLCkGCr+iNaJlMt/2DQEpDAjwp5t49eXnG76mhuqc/PqQ0jB+ByPMANBNbBx/S8RVTNj1/Bzeo2iwHCDxJHd6vDM84wUiMXmqA7cmW1OjlJrWOOkLeOlIChRyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759203377; c=relaxed/simple;
	bh=FAaJz5sI8eyWPOhZzGxlj+Kf9lOcQSByb/9bxjEMvlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYziNbz9xiAdXTHftsNx4cpXP8ZkL1qbXfHBbqrafq1nh7RjL+LyfLbq/cEG0H39QE1kp9FDXjMnvm7O4xodgybrkG5FkdJRT+p1Fn6UbIDwfXpGsaeihqrG1lhXroqAgY//tF/tsG5pJz8ICZQByynhZ7ZjhbFZoIvMxCtmCLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=KdTteTxS; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27eceb38eb1so65872805ad.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 20:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1759203374; x=1759808174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjiYVGjZFyMf+GLlKI5w1Gzz8xtYWF9Svq39Im8NiVQ=;
        b=KdTteTxSV5hyNYlCotQBkCEQkqkDSUaAr5/sUqPNMSz5cDY31nMonQoA9/I2bk8E0C
         D8EB98wBogmo9spBsDG3WeCMxxzYjFk/29otFYUrvxRk4j+zuuVvNmz2lUrw0lM0vTtt
         XSYmQG6Nz9YxJCmQp9Po8lWB79Dd+X+7CEzcowgS0EzI5899yPt/Pw+1e0rU4l391OT8
         CM75SdtlF7ZslzsFz/cASv2ySghTeK/r8oEDJuwD+5XLtSpX03fzEochuRz7Bd+heGWG
         j4Va0cmJTLojOjaJQJ27F3s2CewuhP6jhcd54jFMI3MTyhpRzbn9FnOyFQgJWgJTV2by
         gUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759203374; x=1759808174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EjiYVGjZFyMf+GLlKI5w1Gzz8xtYWF9Svq39Im8NiVQ=;
        b=byj3rjxrknOdt/kOVxk11ZC9HiKd78menl7CMRlgzrWp2CiIbrQEh+xa2O8hgzkS+I
         4V37KgBfuUdmC4dTbd/cQ4KbexJ4qS0WsQ7G5hqdrbo02+XN8nLKotUb8rv+jTwJ0O9X
         XAy6eKHaA4jVyC6C7g1pOUInisD2dUOHTKq9Ja7R7hkhiax1mivTzsIzJa0K5eiSKSIE
         Q1ijpoaw8WJjuTOmd//WSz1l1gi3Pf0FhukG0dHTZnZeED+5i0tsyrzBwrPdPkwbfp1T
         OA0DP1KairstgvbhBlr2QyhjpWwadob0x732cngIJsPXk68ZCbB7XIs+LPwb1rEbJuyU
         19aQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVzTt7S2kbqYw3g+6G1CF7SFMY5bK39bNkNJDibXHWEA7xtX/zVKMUhb5Bx8xBpgYyqEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvDwBuWKXsaa8/hSZqum71hYx1+F/g1Aai8z6FSCrwDBQb2yL+
	OzUQbtazrsSlp3jf1mfIeZp9w9Ps+gLngYQUL/UHs/WC7YyxXUxgz6Qg3CyrlZ4c3Qo=
X-Gm-Gg: ASbGncvxGtr2aOSPccJr6L245YKhCzLuQYOHSlW95q8wVV0HNpf/7kBm5T9oUAjrGPS
	OxNkV1wHWdY8sP82xrqu5gafQO1FxP6lAyYTyc8ETMaqsueTCxksLwuLgX2QbHeaOtTAKce4KoW
	ofF6TjZOcusZ70OuG0AXTWofrdcLwR0CYIcbKiZK/Ptj83fQZByTYi5M/OHAmgCb6peFfUSReF2
	t+fUTyIdmI5hPVoh2ER/V2P1Jg/0OSh+j7gg3BupowfkHBA1/Y0QzIwH2acJrp9wmj+UbZEK1Dk
	KbAtO8XRXN9wNPm4gFqKbZaNABHLbuhUv6rednj1CIwLXRXseodDcQDB2zbtr6mD4X0kPW3rePX
	x+pYb0/L4V1M25kYir3vvG4nJxi/jkEYDqgE041PuNdEyTEhASByUhYPgi13NZDdLiWA4UMAqOk
	9XyGw=
X-Google-Smtp-Source: AGHT+IGtPjrpwn9hzdo72C30kMiytStr6NjN69QK/2wPHkyT9Vh78/jpKFZTb9lpZd599lTG666+0Q==
X-Received: by 2002:a17:902:e945:b0:27e:f018:d2fb with SMTP id d9443c01a7336-27ef018d516mr157247775ad.6.1759203373850;
        Mon, 29 Sep 2025 20:36:13 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28d195d5583sm13846485ad.117.2025.09.29.20.36.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 20:36:13 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	farman@linux.ibm.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	torvalds@linux-foundation.org,
	willy@infradead.org
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Tue, 30 Sep 2025 11:36:06 +0800
Message-ID: <20250930033606.89416-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250929141933.2c9c78fc.alex.williamson@redhat.com>
References: <20250929141933.2c9c78fc.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 29 Sep 2025 14:19:33 -0600, alex.williamson@redhat.com wrote:

> > Hi Alex,
> > 
> > I noticed that Willy's series has been merged into the mm-stable
> > branch. Could you please let me know if this vfio optimization
> > series is also ready to be merged?
> 
> I was hoping for a shared branch here, it doesn't seem like a good idea
> to merge mm-stable into my next branch.  My current plan is to send a
> pull request without this series.  If there are no objections we
> could try for a second pull request once mm-stable is merged that would
> include just this series.

That sounds like an excellent plan!

Thanks,
Zhe

