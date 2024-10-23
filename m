Return-Path: <kvm+bounces-29500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 690279ACA69
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25864283A41
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 12:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588AB1ADFE6;
	Wed, 23 Oct 2024 12:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FjLnyiKM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B54154439
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 12:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729687517; cv=none; b=doL2o2DhvVibVPH3ZxhscBjwu5OjNSvgVpbneu0Mbg1Rr/yVavMYiieNV618lEw0Zs/cX9TlT+GLx+89vikphSbuWOpEHM3CwByXbJBVXL1uq6jbuyl8NTd/8/PbDqudVx547O5fDaW9BtZrcTB7w/87T7nFQ4UG88scDkPBghk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729687517; c=relaxed/simple;
	bh=ujPpvN+GE/NJEmPj3DWUWwEp5RY0d7XPvSj6OdJjdIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=knKC3QN2D+ilI60qexB3bp2NX55tuColhcGHJ+thG4L4FUFpzMdCbnr43cCQLHGeWCy1InNV3YbkIElH26/HqnXsn05/aoOMxcWd8GudGGZbxyHi6aFg0WBdDA5n8NqKnfytnp2clsYYigNQxs/ivEx9dtlH0FsomI5CRJrAp7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FjLnyiKM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729687514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FCEerT3Hq0ivcIq5CUqzt8mI0vrDRfNdSL+JE0E70uE=;
	b=FjLnyiKMSUbzgPBefGAzpvmIxbqh73VdsiMtDo33HSDIwuiZjKUZwXTPaMtE/uaQgVxH1R
	pViZEOyTEL72JoaKx9nJvR/SS3b9nMT5lqBQ5DXVzH8FRWfpb4DBa7NUfkszDMrRG0TENG
	+vQVu46epR+85Y+tsjchDEbDhb68BAY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-xANnd5ZbNHyeBYT8ssXWFw-1; Wed, 23 Oct 2024 08:45:13 -0400
X-MC-Unique: xANnd5ZbNHyeBYT8ssXWFw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4316e2dde9eso37117065e9.2
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 05:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729687512; x=1730292312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FCEerT3Hq0ivcIq5CUqzt8mI0vrDRfNdSL+JE0E70uE=;
        b=cAaQnOsd2aGoEa8eOC80wgveHxcMOY7VFdQOIT+bx2O19oxKyrWyJHDAETW6vnMUfD
         FxchDsSODgvgwTL64RynL9mhNWrS6fxZiea95y+dfJeVwGpbAVF2F9Jd2Ta9aXSkuK19
         AK5vr+qELg26znyAVqBv73kK1KBbh2mjox+2insFWs66FzEV0bjn/EA6eK0zSdTU/pPr
         dlpmLE53EqTmk7KJYwxBtOZ+YClT7YVIycs0v5jbIrNN6oiX/UMQ5VUTewV5xSI6ETrO
         o+9iHGw4EvbhQvzu1AFGx8Kp1fDXcmEhwmfKa6/e0NNhcXsU0i/ODI8yEt+6vd8LEfkE
         qzqg==
X-Forwarded-Encrypted: i=1; AJvYcCXTviuQIGLnF+uewX8z6vC+uMqro86KU97vRrUcomHBtZhzYp8RswqUOgu/fBXcFLh97Y8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzocNuy5z7FtAHRXT7QNNZAgf85V8TdA2V340sWADyvpozc4eWl
	2rcdIgWBXHR6OzeZx/KJ4v9c0/n1PGpBV+zTlsBpwHTAo4nHMfwR5+b1TEbIvUaDqR8TyukMDmj
	3Ds9Fl9jgI6b1Ofe/ZynorWD2zzKJeYRvWxMFwcqf4ZMYCcH8hA==
X-Received: by 2002:a05:600c:6002:b0:431:52cc:877a with SMTP id 5b1f17b1804b1-4318424f1b0mr23493025e9.34.1729687512163;
        Wed, 23 Oct 2024 05:45:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8GmK6mbkeX6Glpjrm3XKMhRq52Y+QGlSLUrN0nYk5TRblkN1kvBuhVUK149JOnPRos+gI9w==
X-Received: by 2002:a05:600c:6002:b0:431:52cc:877a with SMTP id 5b1f17b1804b1-4318424f1b0mr23492805e9.34.1729687511735;
        Wed, 23 Oct 2024 05:45:11 -0700 (PDT)
Received: from avogadro.local ([151.95.144.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186bd693fsm15612695e9.2.2024.10.23.05.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 05:45:10 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	michael.roth@amd.com,
	ashish.kalra@amd.com,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	oliver.upton@linux.dev,
	isaku.yamahata@intel.com,
	maz@kernel.org,
	steven.price@arm.com,
	kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	James.Bottomley@HansenPartnership.com
Subject: [RFC PATCH 0/5] Documentation: kvm: cleanup and introduce "VM planes"
Date: Wed, 23 Oct 2024 14:45:02 +0200
Message-ID: <20241023124507.280382-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As discussed at KVM Forum, this series introduces documentation for the
"VM planes" concept that can be used to implement at least AMD VMPLs
and Microsoft VTLs.

I didn't include Intel TDX and Arm CCA, because people expressed doubts
on whether KVM could deal with {firm,hard}ware that magically enters the
vCPU in one privilege level and leave at another.  This however may not
be a blocker, especially considering that we decided to have only one
mutex for all planes.

Compared to the notes from the KVM Forum BoF, the main change is in the
kvm_run fields.  The design at the BoF had fields masked_planes and
runnable_planes, and a userspace exit would happen if the value of
runnable_planes & ~masked_planes became nonzero.

Here instead I have:

- req_exit_planes which is similar to ~masked_planes.  The difference comes
  from the Hyper-V VINA feature ("Virtual Interrupt Notification Assist"),
  which requires userspace to know about _all_ interrupts, even those for
  lower VTLs

- suspended_planes, which is not used yet but needs to be there for future
  in-kernel accelerations, because interrupts can "skip" VTLs/VMPLs and need
  to return to the last suspended level.

  I am not sure that this needs to be in kvm_run though.  It definitely has
  to be migrated once KVM supports in-kernel switch, but I am not sure that
  userspace needs it "enough" to put it in kvm_run.  It could be accessed
  with KVM_GET_ONE_REG/KVM_SET_ONE_REG or similar, perhaps.

- pending_event_planes (same as runnable_planes) is in the KVM_EXIT_PLANE_EVENT
  data, kvm_run->exit.plane.  It seems that it is not used in any other case
  by userspace (KVM probably needs to keep it up to date at all time; but
  it cannot trust anyway what is in kvm_run and needs to have its own copy).


Another difference is in whether FPU is shared.  We had it as shared,
but for SEV-ES the contents of the x87 and AVX registers are stored in
the VMSA and therefore each VMPL has its own copy.  The solution I have
(KVM_CAP_PLANE_FPU) is a bit of a cop out though.

In order to add the relevant text, there are a few cleanups that can be applied
separately.


Paolo Bonzini (5):
  KVM: powerpc: remove remaining traces of KVM_CAP_PPC_RMA
  Documentation: kvm: fix a few mistakes
  Documentation: kvm: replace section numbers with links
  Documentation: kvm: reorganize introduction
  Documentation: kvm: introduce "VM plane" concept

 Documentation/virt/kvm/api.rst           | 357 ++++++++++++++++-------
 Documentation/virt/kvm/vcpu-requests.rst |   7 +
 arch/powerpc/kvm/powerpc.c               |   3 -
 3 files changed, 266 insertions(+), 101 deletions(-)

-- 
2.46.2


