Return-Path: <kvm+bounces-6369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5DD82FE2B
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 02:07:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9027C1F25E4C
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134FB79DE;
	Wed, 17 Jan 2024 01:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ln9B+pq0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64A4747C
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 01:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705453616; cv=none; b=clFYZLjJdCvLnpD2xls8lWbfr42UipbK+NcmY6fYSEInryahOJ+1cgEujdaWmrr3m0MT346CZKaKIoOoYvpS4DYEr51sKkTmgjAdZmWtp9zJ/jC+A8JcoXEyAlICx5YJ6hGE/ddPCj6mFibEM0nsVomMK+id05L+7rPsYJCegaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705453616; c=relaxed/simple;
	bh=Qy7kil3Qz0HpaVX84PRDZORIBmiRQDrGfGfkinmFmJ0=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Reply-To:Date:
	 Mime-Version:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	b=GsluRTzRs+t2Tra7oTJ8zs++Gpw0VWhu/A1nTJdJ9lzaE9ZGzyz+5SviAHTBrELXy62yNzIHS8z7xssQmE8X4mMk821eccYV1XTUhle59AePR+sWQexx3epFaaQGivouVlfv7QlJI8QGH+ZPALtXyzgHbZ6+nuenWWHQQ8nYS4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ln9B+pq0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ecfd153ccfso190145057b3.2
        for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 17:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705453614; x=1706058414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ikC7FbZyy7GSsL/x82/6qd52zjjlU7XwgDYBsI/nFBI=;
        b=Ln9B+pq03l5lMYX9AZQhVwTJTZagjeXRXcb6CmZzcVOAYI9kHi/B2WGMgurZaiU2S4
         ytNy059MaxKJN4UAUXW212Ir7qKmdguFeqUsvOgWL7z94bXKtLa/qwYHwQf5hkWuoZ49
         DbmRIubgRcJOr2CMzY4LqLbdskjdUjUqn+XoCsxdxrvxjBlFZaYK8TrvqQz2Ky2HdEBf
         fvabpwDyItxkccEb7rwKcFIgO3uhejahVb2DDluP8AG8uatJR1MshGmc05BGpFHbYvd2
         KYVpM/KCGaQjOPzv9yhhBoDb192fJ+4CzseAqpmPTioof0DLI4eQn5Z0/h5njxSZGkmy
         AyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705453614; x=1706058414;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikC7FbZyy7GSsL/x82/6qd52zjjlU7XwgDYBsI/nFBI=;
        b=h1fZtlu3GFmSSeI2kloXkHvjeSGm797LeuFC+X/qhsghF9Y7x/RLcBwJRsmeduPupC
         BAvmyVCFYcoifSxv0KlBZGI0nrf5ShXBqGvOHxl+SqBj6TGzx+ZtAJVb8mPw4SJNGOzI
         R4cLslR/Ju7xxURWE5RSFktwbgvt9KchXQtJLO/qxiDKKhEueoIyxPfx7BL4orPncZEl
         +knTIDdv9u7gwTGm8mymJRf6aZo6fkqkjLsautpo2MNYkRm1hoOfzfG+J8AAoUj6kAuK
         2hA20Dwf3Revwrm+vHjKCUIbQvLzeR7UrC3wsAPFrw08W74ZVpd3gkkmIJNgWGc6E2PX
         YLtw==
X-Gm-Message-State: AOJu0Yzsup/Euq//h+if0W+XXSDH+A28VdeLNKZBNOyl4/muAjL4l7v4
	QC5AV8okFm9VJ14QCFjp5ce5QM3sgtipj1xnhA==
X-Google-Smtp-Source: AGHT+IFn0XXp2m0IheTO1rC8gIwvoWh529EXPcRpuLpYjuG1IPky1DX58vEbv0iiSThvh0GtUSYoDudON0I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6044:0:b0:5e8:f507:6f8a with SMTP id
 u65-20020a816044000000b005e8f5076f8amr4277219ywb.9.1705453613932; Tue, 16 Jan
 2024 17:06:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 16 Jan 2024 17:06:44 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240117010644.1534332-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.01.17 - TDP MMU for IOMMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Tomorrow's PUCK topic is utilizing KVM's TDP MMU for IOMMU page tables.

FYI, I am currently without my normal internet (hooray tethering), and we're
supposed to get a healthy dose of freezing rain tonight, i.e. I might lose power
too.  I expect to be able to join even if that happens, but I apologize in
advance if I end up being a no-show.

https://lore.kernel.org/all/20231202091211.13376-1-yan.y.zhao@intel.com

Time:     6am PDT
Video:    https://meet.google.com/vdb-aeqo-knk
Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
January 24th - Memtypes for non-coherent DMA
January 31st - Available!
February     - Available!

