Return-Path: <kvm+bounces-33446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CAFC9EB948
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 19:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 105A5165AE9
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 18:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE9D214200;
	Tue, 10 Dec 2024 18:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FYGV5PKr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EE81850AF
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733855101; cv=none; b=Bdr572NZ8Cij5tEenLbf8s/Abhn8BMW7TJV4qDtIfGZTvMuG8miWkme7AJtP50ia1XANxiJtRfkKF/2WyiBvg3BhuYFX0z5LGPfFVhxNbOTd8yY4Ip7OE6Ka35Y3WEKhaDrl5TTybwU+DV0hLMXM62e6tpSivXXt+kA7VX+FYTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733855101; c=relaxed/simple;
	bh=7nhMPj/ozuoD9sVD9Ow1ZB9+eVVLEWg/CeyeINkPCXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBerINq1PJvU+jG0F3iN8sDK4TiAEtbo/goEj+IXuNyuDmrGbSJM30ns4yQ1KzFU3953WS0mTLhYu07456zo/dUqoPceUy9UyujpEQdj6QLxfe7NyiI9YTQ5Zsp90jXSjkK2dgoJGPoSUI0r8DaZOjQDt3oZN674blkErrJjjpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FYGV5PKr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733855098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nhMPj/ozuoD9sVD9Ow1ZB9+eVVLEWg/CeyeINkPCXM=;
	b=FYGV5PKrpzLzC+7d9HGcuYbihD1d1vXh8WHTkCvA/Vm9TaxpB+koLL5xv49QDOkaxnO1vZ
	rimf/NXP4DydL3LUHWUFFtYS7s/xFHUngoHSMwPPkerOeqqdYYoKnSCtmV5qVMNlFpRNnH
	roXTlr6SR8c0FsA6WiXpG5GA9J4WY9A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-yLO54oTzOWqhLWFdDyoaNw-1; Tue, 10 Dec 2024 13:24:57 -0500
X-MC-Unique: yLO54oTzOWqhLWFdDyoaNw-1
X-Mimecast-MFC-AGG-ID: yLO54oTzOWqhLWFdDyoaNw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4361ac607b6so3405105e9.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 10:24:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733855096; x=1734459896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7nhMPj/ozuoD9sVD9Ow1ZB9+eVVLEWg/CeyeINkPCXM=;
        b=lBImHzUEEjM97quNqu/qdaYZatphxX6LlC5kLc8p4K8jOETVVeMPz3YEbuAZG6htE/
         QbcTKPTAbzZXYf0fZwSu3EiMOdOxbLUfryyxl9XoZLyxzPfv7s+sAgOX8fsSR+DZEmD1
         TtbQhM8JIHhXM1tHYNbMxtmFoZr9DoX4x5aWE0aPkTcUOJqjI2WW/ekj+2sLMEM9AgD+
         bodNjAZPcW808+tFtzwKC65XhcjMIhRDpqM49PBlPoKTsWsApabkbZXoOo4IH9jvnEQV
         d/v8klwAVufWQQBeLVZAkDJBXTM99UuIndaIJ8ZAO44fKeyKW3C6kPbwLvcIiY8U+m0Z
         a8tA==
X-Forwarded-Encrypted: i=1; AJvYcCVThm5hFqn0HmBlW6jtnUhGW1jedy1EYWkCvf1bfJMrL0janunRUpAhEEciWDgppa3Z3Rg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvvP+ysDhhtBThoMY5+Yc5x7BUY6/+IvoP6iQKj2Frf8Cr1qu+
	udzssDysxKJU4p68VXWsWN9T1A23PVIWJZ0fansYzPNu2mEYvUQFU/yV2M9ddhTvEiJTFeoMGwI
	/qIrO+wEwD7NFUlAJcQfglEiwZpiHjBbJ//VM01IK0OoQvujSUA==
X-Gm-Gg: ASbGncuR11uCEJYeE5i85BOEdM3z4IMh8L2t8aI+EsDZw/gYlh6oKpOiggnSnwH3+dQ
	wEzynAfCLDKPQAew1k4e/SwVID6eP1evRlvs4yFGNLDD2ChrXxaHPWZevVa4YJ/IyKEXu79/qZ5
	RuxvqSItmW7MaDIcSJiPzNWy1CPU9keOURzVCE09aENFW9IwtVp5pkRB8iEUAGnZlO5jpJtdY7p
	0r65NfO0EmEWnyXGcfxFOKIU0cLP+8U2W3EJdVPrHTPfHWJi+Nyv3TK
X-Received: by 2002:a05:600c:3783:b0:434:f5c0:3288 with SMTP id 5b1f17b1804b1-434f5c03c29mr77923015e9.29.1733855096291;
        Tue, 10 Dec 2024 10:24:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFGVB33V1sDjcLSxrWLFP1027Q9gKEuHcM2hmoJzAjxmJxwLeK8T8rsrCUfxuLrKG9f6RpLcg==
X-Received: by 2002:a05:600c:3783:b0:434:f5c0:3288 with SMTP id 5b1f17b1804b1-434f5c03c29mr77922805e9.29.1733855095971;
        Tue, 10 Dec 2024 10:24:55 -0800 (PST)
Received: from [192.168.10.3] ([151.81.118.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434da11935asm200814405e9.37.2024.12.10.10.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 10:24:55 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16]  KVM: TDX: TDX interrupts
Date: Tue, 10 Dec 2024 19:24:47 +0100
Message-ID: <20241210182446.252044-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Applied to kvm-coco-queue, thanks.

Paolo


