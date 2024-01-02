Return-Path: <kvm+bounces-5450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7507D822097
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:47:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26CD91F2192D
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 17:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C044A156DA;
	Tue,  2 Jan 2024 17:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dw3vIIpD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C787E156C8
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbdd300d01bso8523397276.3
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 09:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704217653; x=1704822453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rRAQ16JiqDU+tQzO3hraD0X48nsnjmhKcgWKcZuw2Z4=;
        b=dw3vIIpD68KkEPuZA50CA3f9MfbFZwNPPG2nostwBzrWcySx+V/jJDoOnl+JdfCXmI
         XZTx6jngJkHYT7SlK8Z2ihaDAeLn1tQM/2b4tA0xLZFGFgHEsGgbC/Ob9y5CqC1Bw5h7
         aMEqfVDGLAtLwuj+WJBkUyBbEc9wRD9TOTx7K+QNrxRyggOKxSd7FSu2cRdCiaeJn4Xa
         2OZONbHZ5sXL0eSCnH50J/TgEqDcz81uqBRNsuw6ooJqQ4OdtJWXGBkjlAOUu47UR3oK
         jRqlD7y17AQAQGiyu73GnOLx4scpp70Vwj3bd6Ah+uw70mzr+x67jUskQ+UupqWWO+ZI
         EjBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704217653; x=1704822453;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rRAQ16JiqDU+tQzO3hraD0X48nsnjmhKcgWKcZuw2Z4=;
        b=lWd7+NXk+SRMIa/uUNxpJfuPxHzs22bGY11vJeBdc0f6ofdNDMzPV91pcs9VwVC5eJ
         z7h7PhARki+EZbGjxMPDaMhzm3My98JKatCanIKSfwGQAazFhX19hPTV2o2CHAcIjtoE
         2nhV9L/WFdOQ/ABiBNeUXZWp1mp1m7ptPKVDjmiEzvuEpW65SFvpdrYiqFwGHBetitf4
         ei7JBrDXwrBbeuJSukUXczW0WAd9xSrxAHWx2+PhD484BNchq730a6ix69+Jq/0lJ1Sz
         nY060UFaba+QBma9luWzijJD+58PNR+HgqzK21yEYrmVbXtk2JpOsI9oYzDWYBAM5E8i
         FQ9g==
X-Gm-Message-State: AOJu0YyQWoo0Q1t5lD5mDz2n8Z/IFKykdDWuAsl75s+EB72LK0TNKYZx
	sZKlW1YzbKL8J3cO4y6LZrWf9Uo2St2s764oFQ==
X-Google-Smtp-Source: AGHT+IEFEw2H+I+lh5rZ+282NJ6frDOi+LdMbkkviZ8qBSkR9j1nM2JH/PxCBwDocRu+GhKv117hyyvr3D4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bec4:0:b0:dbd:7149:a389 with SMTP id
 k4-20020a25bec4000000b00dbd7149a389mr655871ybm.11.1704217653815; Tue, 02 Jan
 2024 09:47:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  2 Jan 2024 09:47:22 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240102174722.2855087-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.01.03 - Post-copy for guest_memfd()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, James Houghton <jthoughton@google.com>, 
	Peter Xu <peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Isaku Yamahata <isaku.yamahata@linux.intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Roth <michael.roth@amd.com>, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Tomorrow's PUCK topic is post-copy demand paging for guest_memfd(), courtesty of
David M:

  https://lore.kernel.org/all/CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com

Folks on the Cc, please peek at the future schedule and holler if you have a
conflict for a topic that requires your attendance.

P.S. Someone please remind me to record tomorrow's discussion, I give myself
     50:50 odds of remembering to hit record.

Time:     6am PDT
Video:    https://meet.google.com/vdb-aeqo-knk
Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
January 10th - Unified uAPI for protected VMs
January 17th - TDP MMU for IOMMU
January 24th - Memtypes for non-coherent DMA
January 31st - Available!

