Return-Path: <kvm+bounces-42427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF73A785B9
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38DF03AF66E
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 693AD6AA7;
	Wed,  2 Apr 2025 00:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gj2OL1ve"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEC81362
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 00:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553780; cv=none; b=M02KXblKfDL3omjtDb5hz2uFgwvbBCcTWGgKpE/EgDeXF/JYb7/c+eXTv4JrE+H4YHBWE+sIhK6J49HN/RsCzoPB7F86JNBuPJixEWsYkncnGJCyF+Is5V/vGJOPQKHjd1vtyjx8Jf5m5fTxmW+iDqx0j+Yoq5zpsf25NG/l5D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553780; c=relaxed/simple;
	bh=TJwgQ+K94nM0wuudbO+pH9Uh8FX9mYdnPkPRatuR/oA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HAz0fNs29mO1MX+E0DWCiJPT0Eg1k3J9liOZvYYQar8/2eNTK5XM+gqviGc71Ok9An6kaVGfxph3ZOgzVcMkzLZlZgNDaj7/oL51xMuwPcLYsSqWIUwSDyL7YI3maTfPLoMfHsN3lrn6qtg2d7u1hK0e7kDESy1k3NfblaeSZWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gj2OL1ve; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff798e8c3bso10133070a91.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 17:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743553778; x=1744158578; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJwgQ+K94nM0wuudbO+pH9Uh8FX9mYdnPkPRatuR/oA=;
        b=gj2OL1veEcTTjgGN+ioYAAjF6Oqqy0Y1vNUmI5W2Y/ROMRbN9ZqBcCIcqeNh7nD/d3
         WcNCSAjD4kNkQ89OjdRez33D0K6oUUsgSNGDgJbl6mXUKZ86GeoK/hbQvedmb+a7qPpS
         cO/pdaMKqg2CHk+WSMy2ZLlKiKhMfJnqSG4P+K13w/VNb0yv3K9mh2gCRpYQ++z0VfPQ
         T0/oAe0C1ZSyvIzcbMppt3QLn/0PTOHhoipQTtSVnd9wo7jk2dV6SoKYyZ1sBp9EemA/
         4FFc5Imd7s3KURK/37dOsk6Gp4K/EUn6PWN+FNUqnht47/2GrsCvX7Dgq+v3iuuuoADx
         mlyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743553778; x=1744158578;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TJwgQ+K94nM0wuudbO+pH9Uh8FX9mYdnPkPRatuR/oA=;
        b=VxM5GYI1dRfMldDyHe1ddT+1IJZWQyAEk4MC+m4pvBVGutD+W5rTEnO8suIfgBKLPG
         XylehwnfCrdvhy4vBRX+GWtlXOFRyXQKu/bTTBFoyfckEsd3kHr/tWXYdRoc1ffGnIXK
         ivE39Xaf3m9Rsv5XKqO8xaVu1vP/hYmk8Ztq1mAI7Eod0fR8tgE1kdzYB7pE+SmZTW0f
         acSjUxyLscZsdRvR8YhLJEiz3W/lZj1aTMlUMPU9OjLkKffMOexG+Uxe8IIubkBAxJRN
         9U+ChMteqqYk5QKW/KMtoHe4qcdEPoRM6X59CR9smi1Wsx4opjlyLHa+VZmvd6QePZdf
         I+8A==
X-Gm-Message-State: AOJu0YyMGKnYQqstu+6ryfT1Qp0LrgRfI5S+plvM4MJWJelHXMNmh6SA
	6IdWActh0rvznGxtW4Bi6gXwKYN8K6KFdHVei3tcwqK56mPvu5KfE7htCnBaVW/+yVbLM23q06W
	APw==
X-Google-Smtp-Source: AGHT+IEnRy5A+8fYf3qEr6ikTE4WCBwKWkgwfuK1fpXzni71N19GGrE1sC/DusmSiadYTv56nAWxft8bNV4=
X-Received: from pfna20.prod.google.com ([2002:aa7:80d4:0:b0:736:3e92:66d7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9185:b0:1f5:81bc:c72e
 with SMTP id adf61e73a8af0-2009f778828mr19565665637.33.1743553778644; Tue, 01
 Apr 2025 17:29:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 17:29:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250402002936.960678-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.04.02 - No Topic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No scheduled topic for tomorrow, but PUCK is back on this week.

