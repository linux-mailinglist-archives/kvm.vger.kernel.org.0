Return-Path: <kvm+bounces-7511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D70C4843245
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 822AB1F26E21
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 00:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91814EA4;
	Wed, 31 Jan 2024 00:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eF+ntEbU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5128336E
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 00:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706662299; cv=none; b=HbaFLBHRh7tAzhtMQ7P0Hf8C6SCdcWZW54PWW5YjBVD7TnBMe7AjedqHkKaX/lzGXUWpdp0opqm4kTkQyc3poKpvQYRKvPmfzgNKqFMvvFowuUAmEq2eH3FjZd4rjqtf6k6FFEuzDc+/WazsqeGPHrzW1Q5QVW6iy/9vIdvlFqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706662299; c=relaxed/simple;
	bh=h56iDYCY78b26JFQdhAEDEK0j/cfW7bNE2Mq5KdMyvs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KolBAELogOiggfDDgiI+KM0Z7mp0T7buhQXTvSVrniebJUeg5ySAz5PwP/jzjXWOAYIEMKOfpdFdDO3bK0WKP+0VB9MDDpnEM58F6VwUYeG2AsLihQ36bgqUro+s5o8PXI7xw9UGL8ZprdA0ADRyEHvhldhbHYUKv3LDQNZVjrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eF+ntEbU; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60406626b50so8296127b3.0
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 16:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706662297; x=1707267097; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8PiTL2HcEpuubGvI5q0XemeJ60ITPrCqFkZKuXecBwA=;
        b=eF+ntEbU6RGl355iGb6S3gD4F7OIL4pmN7533IOx4p31qMNl5nypnAXskdVbGyqReV
         1BrIn54nx6YjCzJwRF3BNq+BEbcpzMHkKEYf5oPsmYIFRaiJmwoSH5CYAHjwzz67j58y
         KfWdXfhfsRRJZxsTJ8ZUkZfgCJXVGymrv0GjzgMiep7AL1SYsP+/eX3li6gG8RzgiLRR
         OdlWaEz1PrKS6owgTh9I7IkL7GaNwdMpSLUsYYAjIJxi2ZQs32nDva8vYSNWwpAntfG6
         gZDV+2NjVdUag+rIHqjeMxaecBLj2GBmf1ds+8YnrBIHXc1i51Eq3Iq496YXoxcEE8+C
         GONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706662297; x=1707267097;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8PiTL2HcEpuubGvI5q0XemeJ60ITPrCqFkZKuXecBwA=;
        b=LFdmxKluLcfmOYBX1Q0eFxmJnazWFuxx/0pX2tTyNYRifb3kLzTARiEmFulWCVhMjy
         WWkovTF3RrYAAvNdjlks0pUXqL1sL7BGFDLmqR1cN+x1V/wJNff++Yjm2+6yU1wp3ovX
         bct9Q03u/tuywWpUu4j5RTyKpDhizm4Q4A5Jmd6rsypRu9H13KoLckfE1vWOFIfeRo8S
         55gGPmfhTMx5yXN/9xv1wz5p4QYLwJe4Gzevjw+fA8Rh9y4wXnQ04iyxo7ADmTmDDy6H
         JWl67mL/xpy2HB6FHtkwxQlG5cVufx5ZeM1tJ1KE0+OB//dbKxaRLyaulZHavPg32M25
         VcrQ==
X-Gm-Message-State: AOJu0YwXcBI/aqVaUsn1xD1cnf8K+FTOwy7qa6Xxr0tpWLnPHn9ChGuc
	N1DpHscmEh4/ZxnPIDMI2jOwxTC7jmm113Fx1H9lOLHUIAEJ9JchVb0MZKx40Zan178+xX2/qyp
	T6g==
X-Google-Smtp-Source: AGHT+IHG+mR512nv1h56aKdPh5HMR7r1mFAr+oZY0klhTXoojvu4P6tkCzyWHsXtwGDD6eIKR2/1nj4sky8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2608:b0:dc6:6da5:1a23 with SMTP id
 dw8-20020a056902260800b00dc66da51a23mr58971ybb.4.1706662297300; Tue, 30 Jan
 2024 16:51:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Jan 2024 16:51:30 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240131005130.3855907-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.01.31 - Finalizing internal guest_memfd
 APIs for SNP/TDX
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

Tomorrow's PUCK topic is finalizing KVM's internal guest_memfd APIs for SNP
and TDX.

https://lore.kernel.org/all/20240105091237.24577-1-yan.y.zhao@intel.com

Time:     6am PDT
Video:    https://meet.google.com/vdb-aeqo-knk
Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
February 7th  - Canceled (Sean offline)
February 14th - Available
February 21st - Available
February 28th - Available

