Return-Path: <kvm+bounces-56598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D860CB40638
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 16:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DFF2545E34
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 14:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C272D8DC0;
	Tue,  2 Sep 2025 14:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tw5lNN2j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6445E2D239A
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756821858; cv=none; b=UvlJFQk6+5t5x66MNZ0vj5YtuvAuUYsxqSzm1PB6+14h/Ga7NezAlxO12m8x9PjYPhPkqAQB+JeZRlVbtpOWKJ+2i+Qa6tAxwht8L0+RbNSY032r8sEyVMZ5hjEpFWLUjN8pHEbIgvCtMfin00J2KV61BznA0EUOMJUo382a73w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756821858; c=relaxed/simple;
	bh=vu2HQxGlgeT6oN7xu9V/ajIxDf4r9TunR4a+QydcYNE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Bkr25A1EMutOCTU6+pCgBxT/C2dPp8exxhhvD0uG7p0Nb50+drV9vwZ1nElcNWAOCjd9YiCl5cI7+ZL4+9tkjW+dz3ymZeaN21/cbDWSEvC3cSp5gI5Rl6ZJ+hOrNQ1YOkxLeqcG9+SO292m6zKBoJ3x/FpToMeOMa9bO5dAbew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tw5lNN2j; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4c949fc524so3608854a12.2
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 07:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756821854; x=1757426654; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vu2HQxGlgeT6oN7xu9V/ajIxDf4r9TunR4a+QydcYNE=;
        b=Tw5lNN2jO6VJgGtqgw/yOyXXt8SQHZn0HkzFyOUZ+XJbc+kMZOUsnRXMSHBNER+/vV
         xVE3XcHVwS0beKRFo9Op2ifUMcY6+okojnaXRBIpryQsfJB6PYhr5QsFJB2mqAqYYwNj
         QF3IeInfjBj4xSoUVb/R6yv0PINVBaQMAm6hHbGlVCEVgAnbEielAqRWij6FLycW5EZ3
         TVIcpEcy9avFTrpfswY8A+nbhhomcqKxOfEMtTliQJTnuNI156N3aivPMS+ntFOwUtle
         8ogql+mxe8JZM+ClwahPqvh+oL+PRFGKsTbUeBKz+yQQxplOfRGZ3tl8jEf59/6TErJT
         Ovfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756821854; x=1757426654;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vu2HQxGlgeT6oN7xu9V/ajIxDf4r9TunR4a+QydcYNE=;
        b=cO8vfsm/90GCMtnHAMRh74j8XFqEGb/ZhSrYk9W5svoIRww3X74mJWTD9k2oUu6f2a
         pUTrAXbZSD4oiHdlXs6dfnO2yj1QAC/zJKlQvDeBfD8484Xhajie4Uct4ugubg+waDgy
         3K3xu0MpA2LChM2OuqTSVp/Z0L3JcOJlmkmI+b/XIPDkGHoYixHi1+xzBGI2sPOJ/cGU
         ccWUZy728ejWchYRetta3EIYAFcWRdPJt+d0Hmsx+kro6JZP6CEafPuMYpdOHvJ3B4ue
         Be6PMEEANAkXulIuxE/lKxWU+ZVhwJWqH5WB6PJn9Rg2Iw/nAJRy0Me/VeAuPBt0/qVD
         7e1g==
X-Gm-Message-State: AOJu0Yz1E/PkkW3tqm3XK9PnkLyzN9najmo//f0PfrckkkCXExzqKb4v
	+0103qYktOg0SbSIu69SSBagSLMhOEdLlrpgq1Sf3JBYSz3hkRqcwj+MljEbke6IopOA8q0uL1i
	XOQ8nzw==
X-Google-Smtp-Source: AGHT+IEhYHWyEv2iGFE7S8whDqklOJ3pfudKlua9N4/l+AJnSyMHa7uiBK2WYOTsoIAqfmbSxx8OxMWI0KE=
X-Received: from pfbcu14.prod.google.com ([2002:a05:6a00:448e:b0:76e:396a:e2dd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33aa:b0:240:1fb6:d326
 with SMTP id adf61e73a8af0-243d6e009camr14954272637.21.1756821854596; Tue, 02
 Sep 2025 07:04:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  2 Sep 2025 07:04:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250902140407.474538-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.09.03 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No PUCK tomorrow (September 3rd) due to KVM Forum.

