Return-Path: <kvm+bounces-73275-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8JscKgeZrmmqGgIAu9opvQ
	(envelope-from <kvm+bounces-73275-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 10:55:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2934F236979
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 10:55:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 24D053041BC4
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 09:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A40C3876D0;
	Mon,  9 Mar 2026 09:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mfarBoXx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E893385501
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 09:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773050055; cv=none; b=N3QwwzOStuU3vSm3plPlumZIUgPStOjW95msOpzaOMV6K10GqZP3siB5a+UKtJaeCJ9XJ4x7hz1CzuHZM/Z6BbacJRAO4jfhtTRwbuIwMRfG/5VfpXNefJvhBwAgEDO/ENbjA+RBfgRwWxMMGp+dznvYDIfcnErAgMwVNL0ZLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773050055; c=relaxed/simple;
	bh=68O4lC98Vin61Vk35g2/k0cZz6nrw+/Eb7DGyikKBoQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=u3g25kyHCuAS6QwYFiexxlaBrpFZlp2xIlaHwAXDaBSLo3QQL3Ar8QJ37+eVG1gG/GS1EwQ93ckhjay9sfZhBxAc1q8J2XAEK67oFOEnNRFFXa0z2Xxz9SjPklW2Xn1X4pKoj0kxmACf083rR1fSFnpaHYs5VWsMTIN4Td7MgpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mfarBoXx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae4af66f40so87429915ad.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 02:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773050052; x=1773654852; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pIf0vYFKMELNG2TTEBOnMZwDB9piTsTF1zoj75pjk5Y=;
        b=mfarBoXxzLr9cwzacMVTJpjp7xdm9dvlrQ7PNJHlTDuCIqKV4evvsfFAQpQGmMJ/Gd
         /65YWc9ChTqFJRq5WWSjTDqQ8cpJn5A9wbC25aa8nMeiOUlBn1+nNjl9NZgKt7aSm0tI
         Tc9EBtM5gT3RRfF0Ickc556L70XG9d61bwKL1nVhr9QrjHhaLLoDc/jJjZwbxvbz69ru
         6mCALJ00Ib7PfHGEtmCGld4w+oQG3MWexD5kKE+WtI2+MMh/JUhVZykR83lHP228+GO1
         H4GgluuSX00cKxnHb6K3L/xwSDSU3yNs6VfQydGJZrNl+8JrX2i9uefCI2BtCY4YOrZS
         KiRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773050052; x=1773654852;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pIf0vYFKMELNG2TTEBOnMZwDB9piTsTF1zoj75pjk5Y=;
        b=uNBI8IM0wmCKVNkP9Qs5w/91nKK/12YVyraykWF1tfcXWbU8oDyYMrFs/XlwZNtfVn
         tcKEulHWWAWi6BvrZ0ZPqQGteerGrIwEp6onxx/b2ox5xNUBlyjJ56eIwckbjKe4Jt+4
         OO7+WHv1W7EFkH+/he5Jwbl9+8z7mWpdnTqSD7p+ZU454yg5uLbOED3dfCz2fmusVc/d
         cgzF0R9bV2efFwKc21ChKoIGQCwzh2fLZIltR70xxH140W2LXqJtlRwrT+bgRvkVFQjU
         70QUYhfjlsJ8qiyyl2HdI2XyiKzPZzcVEyoP8iEvxI+xPqcQogpmhRGdg7ip2Z2T+QTm
         q31g==
X-Gm-Message-State: AOJu0Yzc8P873ZtafHFFWKlvTokmUfBob3nbJ4wFZOqTWKvhN06SIVMV
	NbBqvgTMgEhoGwJWTrMh3qdi7VKbRcRum4Scc9isPTM90LXnNaqz/9e7nzXZhyJkrKHZVdftMVz
	hSnPKNq9tvfn/uCiNwV4pLk/EYA==
X-Received: from plbv8.prod.google.com ([2002:a17:903:44c8:b0:2a3:1bf9:d25])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e80b:b0:2ae:54b2:27d1 with SMTP id d9443c01a7336-2ae82467157mr111432675ad.44.1773050052185;
 Mon, 09 Mar 2026 02:54:12 -0700 (PDT)
Date: Mon, 09 Mar 2026 09:53:51 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAK+YrmkC/x2MywqDMBAAf0X23KV5oC29FvyAXsVDElcNNrFkR
 QLivzftcQZmDmBKnhge1QGJds9+jQX0pQI3mzgR+qEwKKEaoVSNU6CAvKF9r25hvGk96nqQQkk JJfokGn3+Dzt4tU/oi7SGCW0y0c2/17IHzPfmGilvcJ5fe4EsdoQAAAA=
X-Change-Id: 20260225-gmem-st-blocks-733f35d10211
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773050050; l=1868;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=68O4lC98Vin61Vk35g2/k0cZz6nrw+/Eb7DGyikKBoQ=; b=ESwVyUWcaPjwEE0yP3Xk8C7LGm2Jq8bAYp6gfzWYbQj40hBFC3hJqHMd7GHOzniNAxF11gI5E
 q/oaiFZvM1hCbkoIMF3gQqAFMwjT0SDV8AXTcEaNL2gvCD6adqoDxsi
X-Mailer: b4 0.14.3
Message-ID: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
Subject: [PATCH RFC v3 0/4] guest_memfd: Track amount of memory allocated on inode
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 2934F236979
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73275-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.925];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hi,

Currently, guest_memfd doesn't update inode's i_blocks or i_bytes at
all. Hence, st_blocks in the struct populated by a userspace fstat()
call on a guest_memfd will always be 0. This patch series makes
guest_memfd track the amount of memory allocated on an inode, which
allows fstat() to accurately report that on requests from userspace.

The inode's i_blocks and i_bytes fields are updated when the folio is
associated or disassociated from the guest_memfd inode, which are at
allocation and truncation times respectively.

RFC v3 uses the .invalidate_folio() callback to update accounting in inode
fields at truncation time, and sets AS_RELEASE_ALWAYS for guest_memfd
mappings to enable .invalidate_folio() for guest_memfd.

RFC v3 series is based on kvm-x86/next.

+ RFC v2: Removed a full custom implementation of .evict_inode for
  guest_memfd in favor of adding .unaccount_folio callback.
  + https://lore.kernel.org/all/20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com/T/
+ RFC v1: https://lore.kernel.org/all/cover.1771826352.git.ackerleytng@google.com/T/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (4):
      KVM: guest_memfd: Track amount of memory allocated on inode
      KVM: guest_memfd: Set release always on guest_memfd mappings
      KVM: selftests: Wrap fstat() to assert success
      KVM: selftests: Test that st_blocks is updated on allocation

 tools/testing/selftests/kvm/guest_memfd_test.c     | 32 +++++++++++++++-------
 tools/testing/selftests/kvm/include/kvm_syscalls.h |  2 ++
 virt/kvm/guest_memfd.c                             | 15 ++++++++++
 3 files changed, 39 insertions(+), 10 deletions(-)
---
base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
change-id: 20260225-gmem-st-blocks-733f35d10211

Best regards,
--
Ackerley Tng <ackerleytng@google.com>


