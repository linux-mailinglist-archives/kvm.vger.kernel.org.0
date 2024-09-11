Return-Path: <kvm+bounces-26448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 842B297480A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 04:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53DE228714A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96EAE2A1C9;
	Wed, 11 Sep 2024 02:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xHQzXUfb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A7E24A08
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 02:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726020554; cv=none; b=anA83ssvvb0C3iikk2jfgQcdy4qOfiHca+3sYPUoZ0gdnHaPc1zmHLf59OcraeadbG52XsW5XFjZ6EtPq8Z4z4DMMpMWVPh5arJTk/dnqR2liqaKnzEQrVQrc7xEjdDNW7hBnjUf+uXfjJyhU/GkBO0/LQ8g//qWXoI1uzVM2Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726020554; c=relaxed/simple;
	bh=iQlQrTJQia2JgU8Qufh9nal7DLq0rJTRGcYdptadpl4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eQOSUuugz/mQpCuD1M/YFx27csocqgXLBy481WQ9aLrKyFMPbV1cQnq22bNCF6I43MEhlWPNoKZtnPhEu3WeAHlCYDBQWpatySfuGjjiMID36fY/eTNUvRXvE6Pib8iX9FRLEMVoCDpv4W7wxz/sk/vSk9KaKKMbdg5JHT5sKzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xHQzXUfb; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d5fccc3548so7739657b3.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 19:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726020552; x=1726625352; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nPCvZ685cbKQNaJC1VFqgp1Patwk81JBkoDokDez0k=;
        b=xHQzXUfbcNdE1I58YayWQAc7GE1y1piwdmKUFX4hxl5PUlGqE4RaZZwMXnj6m7/TAf
         E6FiAV9Z3V7ztFVYjoY5wufdGwNANH+5B7Mac5ov9TebprnNTo3sWRK1uhZ0z/WZ/c5w
         RFkYD6xHzTdyJkVF0210LrZkAoetPlhlmQvcI+MsjNH2/Pk8aU66Zaso1gsefY9PzB6K
         rExFr3MuxEwFhDdnophWiGZOB2tH+hg2lqQl/UVNwhlK5XLboTWlfq98RXkLSQXkieH9
         o7dPiDgrH+pRpFgSSsTKZTvDomYwx/wOmXbh+Oxr+rLzipMkc648XPF/a0qaeIHdF8Xq
         zqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726020552; x=1726625352;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4nPCvZ685cbKQNaJC1VFqgp1Patwk81JBkoDokDez0k=;
        b=bTvV+dZdlKRohQaKj9nRxKOt4N0TRymJe6nWH9qKgD2Tg2b5JSGpeVcrmGMgbCI38h
         bic9HkAxWMzhFcE9zH36Yu4u08NsHdt7mdpWWp8WhcXa5tYsUkyYv8m+JxDeGwZ7W/Sl
         lw1sPxcHDzltzUAui93h0XzAnHKwRt0ykJlBQlv+Wpwxd5RkAyOqQN9K5oDQo9I4cGsC
         nIcau/VFRaJIDedhCScPfaGla/89Qunebzht7sGyIaw2e2um75u1d+7i/PAgntUalFJ2
         MIl8gjwIDrwG7TEWTT88v9XCKHvWWRM0+YqO30rDrlHQA2l6nX2IXhUOk7S1Ib/LHw9h
         bYYA==
X-Gm-Message-State: AOJu0Yy/FrG5v5U2epO9mHqPuC1qGxpZXYbIIFLoYgA6+cC+T01X6Ymb
	wPXSq0KEq9swrU/UQhakxW2RjSXB/e8rOiYs5beW+02u7M8c9KS6EqGxTtfN3aJnFz4KjTg69hy
	U0Q==
X-Google-Smtp-Source: AGHT+IH10mEZy0dtLg6fETqh3d/Na00T0EQdYiXfNHYGJNKi6sJ4CZ4q1YG4Yve6iXZ2lLdXuELY0c1L8L0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:20a0:b0:6db:7f4d:f79f with SMTP id
 00721157ae682-6db951c4d86mr1224397b3.0.1726020552438; Tue, 10 Sep 2024
 19:09:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Sep 2024 19:09:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911020910.1856089-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.09.11 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

PUCK is canceled for tomorrow, please use the time to catch up on sleep, prep
for LPC and/or KVM Forum, or read through the flurry of RFCs that always seem
to precede LPC and KVM Forum :-)

PUCK is also canceled for the next two weeks, again for LPC and KVM Forum.

Time:     6am PDT
Video:    https://meet.google.com/vdb-aeqo-knk
Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
Sept 11th - Canceled
Sept 18th - Canceled
Sept 25th - Canceled

