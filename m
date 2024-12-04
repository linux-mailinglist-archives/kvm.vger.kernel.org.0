Return-Path: <kvm+bounces-32970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 137C59E306D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9A5E282F31
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 00:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96DCF4A2D;
	Wed,  4 Dec 2024 00:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SXeiRg7h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44612623
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 00:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733272345; cv=none; b=Kpa6/NdtQBU6co8c8I1uSwPaMy9jYfZGJj/YVXdboRFoM1PYQTi+6RANiVdQchK3sSPEHMK+QSin/MN60fAizEiPaejy4ChL9sryUym0BHeWxxZZSn25oAGlOqzMeEkifXFs9DjQ5g11lstT1jI1KMiDdwKz1qf/MgAIje1bx7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733272345; c=relaxed/simple;
	bh=DDxKSHEx7Y5/1b2cBgBNTQdkIC0rcPSiN7X0JbUIXRs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EH+LpxNonjSsLPtyuh9oAssQ0Xt6KdBS7ZDuk01yJe3C7rG8aa2Hw8xiI/kMeiu34/Dm1mDHYU1hgbFumbkyq5OlcxaYrLaXQWsFaXZxXoOB2cPF3VQr3+nZX4vpYGRMK7kqHFzjKCNB9goWjb4Ba9og3jOK7wAtnnYFe0oqE0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SXeiRg7h; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-71d4a8ede26so4404985a34.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 16:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733272343; x=1733877143; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HVEYC1nSF+KpKxk0nrXJnLwZchetOwjmEdMmnp1zFto=;
        b=SXeiRg7h/m8nkBbgca5lPCXrePc9XtchMzYitUKL5cGgvSedMcNV4VKPEu2njLdgUn
         b2EcD/VLMxWlnHfBEP4quGKmjQzQQrt4QsGZiglw1Y2sZoLR9vDYAPZ87VDeG1Svng1n
         U3Oet9rSCWa1FizXkUkNPWCljArnJJnpDfWCyLTdrV9nJKXpDGjXa85buWDmCar1cbQg
         8aIVtfUTxKP4hPZmwSxlPaoq8ISUspC0gOhCJjdSIzeBlQ6pGNh5JFESbK07wv8hg2JP
         mZLMLUDROGnTqa9C1mlUXuBdZwbDvR8CyRvIv+hfggXNTA2cezfAIqhCuDR9dXIQ3FCM
         Db9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733272343; x=1733877143;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HVEYC1nSF+KpKxk0nrXJnLwZchetOwjmEdMmnp1zFto=;
        b=Vj1yfa1Go1F9LED4YlEYsimGYAJbQhDPzwd7uzf2i+UGIp3avorZPyX21GEuasBkIR
         hXAVyc99VUzFntFjhDjqcaqNjQmudmYlMg6NpwlVoTxhj29SBXkGJ5GHHduQ8roqE4uu
         EsTe/+298JzJLZb6OpHzWp/QKRjlF0xqyA6zhRD6pLJRgzcg8gU5QkIM+SZ0Zyfa7zw+
         JZw0bZOsrSX41L+15D9TabuUSPEikn/iVnU0vnKILsMYxjKLafzArcDBDrBilQ3+ICzu
         UvDgg1Igo4AjgXhXYwbMjleCu/FYkuln6pd41oagHPwqF6CN3gYfhX4nFd/Dbju5AyJe
         CLTQ==
X-Gm-Message-State: AOJu0Yx3fDcN+450z6RXOcaO/qt9K4cepf9CPpOOBNEdAwYl8koCVlSU
	cdU7EziZs9qXXbrhQjzaYOrDRmRbPqjj6XLYG3Iy54cfo4eqhKP3HlzhblTm/SmpjdnTwixHqT7
	4PQ==
X-Google-Smtp-Source: AGHT+IG3G4WlbRtafcXmxVI3VvzpVclTwXmcNS+SNcH+C52y2UYIixbvldZbsL6Jo2VX5UVUh+NaGYov2c0=
X-Received: from pgbeu13.prod.google.com ([2002:a05:6a02:478d:b0:7fc:f798:21ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6830:6e90:b0:718:9a8b:5bd6
 with SMTP id 46e09a7af769-71dad5f3843mr6139466a34.5.1733272343375; Tue, 03
 Dec 2024 16:32:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Dec 2024 16:32:20 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204003220.685302-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.12.04 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

PUCK is canceled for tomorrow, as I will be unavailable.  Sorry for the late
notice, I meant to send this out yesterday and forgot.

Note, PUCK will also be canceled for upcoming US holidays.

Time:     6am PDT
Video:    https://meet.google.com/vdb-aeqo-knk
Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
Dec 11th - No topic
Dec 18th - No topic
Dec 25th - Canceled
Jan 1sth - Canceled

