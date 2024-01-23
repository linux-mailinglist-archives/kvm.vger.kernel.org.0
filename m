Return-Path: <kvm+bounces-6741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D24B0839CE8
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 00:00:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 496C01F2819B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 23:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F1E53E2B;
	Tue, 23 Jan 2024 23:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="loJ9QKWw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FA24120C
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 23:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706050839; cv=none; b=UXsImUIY7eUt+aNU0Po+fTG/+YntNUKbPuP9iPCEkkM2Ge8LA1GQXa7Z/buHbsDrkKQ482FPFiHH1JnJuyWNvozHq/mKe/Bsa3DKh7Yb8+97ZsGUBVAcqlP6/+rPV5UYMxVKdh30O5gPhL8uuyThbizoWBely18q28yD8WlRbzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706050839; c=relaxed/simple;
	bh=1F2Qaxx0X4RH64MvPK8ltxCC/J1hBfLXSHmNUUNkRVU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oKj5vMQxq9TpquLdP/uPBHjQdUoZFP9uIioQfGnzUOYHvsPuYPF7POLqjYhrab43SWggmXr9l4zy5ien3pJaggGPVfe9kCri42PuJg2eBI+3b6Se8pfKo7+DpPKha0TKUJWLsbkObLIub848NInm9NSj3RJUxWUJF8hAHlmVJow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=loJ9QKWw; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc2490e2a65so5687983276.1
        for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 15:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706050837; x=1706655637; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bpBA1amDIIWdDJ6LPLULP87iPv1yXvr1GDinBnEPISQ=;
        b=loJ9QKWwx2zBLp9nBqlDQzbZaOR23nbd3vXhAT+e37NJUiVd5vonJjqHmNuQIatSzP
         PYUTVNxoVR7SvVqnlN+w+xMXul5PVgfxUTgixAKwXDYI2AuSsJeQ0JhVEzKhvYTem2qV
         ZF6UUmdY3uWBEsJZ+EeyH2Lz9EchW2ZxkfBhMWW4uQv2UX6JwUlUsvDOwFRFi+c6166/
         /y8C7GagndvuJIkaUJh8JDA6UitE41iVeOFfPsroShF50Udt2Pf4LjgbTO4YsxlYZFQQ
         hVSVLwdyFy+DSubsmTs/rd/Sqc0bMoFkJlP+Hxoh8UrDL0+lxy4r78T+fAp93RJzegSb
         ia/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706050837; x=1706655637;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bpBA1amDIIWdDJ6LPLULP87iPv1yXvr1GDinBnEPISQ=;
        b=ZVFl8HSuu1vR5ejlpDjWLOdikR2fcwvNfZbOqUMIYbBYIJfrRLtk0udplAuZMCFb8W
         +of0mNBlxGGhOxT6oQl7EbOx4ilpF7SoVf2pmITb7e8cWRpUau0AQKYQpnmfeRchWlMe
         EHyVvk6pwPl1Iq1WFRDajs/YzS+wsuoED+C3BMURW/rc22cY9WWIVPZyjJMuVwgVkO4L
         gpcCLpUnOtJ8Eg1glB8u9n1cuwsK6uStWFHwnQrTGzhaF04Awh0CML79Khah4PgHNqUu
         Tzn/EPhQvWctNGDkbiFIxLKFOFtXyPch1xwxom42/SUwYgXlfM1mLpVVrQmM/Z3RlUVj
         UQDw==
X-Gm-Message-State: AOJu0Yxgh9RbYipmNqYPxQhx7BXRXkqGfyKSwIkRgON7UUdQcYsSEEEE
	GO6cVUgZikbP3BwX5zK8QxpbvV/dyoQFkBrOe6P4127UlSDOHnmn8rrxCn5Oic9W1GfMTxLaJu/
	BvQ==
X-Google-Smtp-Source: AGHT+IEsUJfha+HUtxBPjbdRfDNnrDTm2iRfwj3LukExHF25a4abzM5kw8V3CYMPuPoUsetw8QW+nf8ci04=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:b1f:b0:dbe:abc7:ae5c with SMTP id
 ch31-20020a0569020b1f00b00dbeabc7ae5cmr488261ybb.3.1706050837513; Tue, 23 Jan
 2024 15:00:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Jan 2024 15:00:31 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240123230031.2487501-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.01.24 - Memtypes for non-coherent DMA
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Tomorrow's PUCK topic is memtypes for non-coherent DMA.

https://lore.kernel.org/all/20240105091237.24577-1-yan.y.zhao@intel.com

Time:     6am PDT
Video:    https://meet.google.com/vdb-aeqo-knk
Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
January 31st - Finalizing internal guest_memfd APIs for SNP/TDX (tentative)
February     - Available!

