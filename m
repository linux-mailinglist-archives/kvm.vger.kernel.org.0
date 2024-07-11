Return-Path: <kvm+bounces-21441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C7B192F1DB
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB715283F44
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565951A01DB;
	Thu, 11 Jul 2024 22:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dHQ1MEUG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A9315531B
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 22:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736882; cv=none; b=emlXJUbjy4x+lTH/GM4rKokZO32CyNZlc5nfLFsQqZqKr2/IJi9xxq44cMKuYSXES/wub2gwoCAVuNCWQG5UrM/xxeGzQtxw5/5GB/p8UQPzstxeP1Zx6s0outOdbJIlF3Bb84VPWSUk4SvtcfjO8RgYAumk4s6eIVmNnUi3kpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736882; c=relaxed/simple;
	bh=f3630Vzc1r91ymNj3NqDjNRznUNWNoTaS9DusDbuMeg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q1hURjKlXP1RQatQs3fMHW7Btn519BevBVbhTWIDwhq9/a2OMmqRfYl91UgUB8ggd2w4XD/D6qi5OKMDBP7MB7ib1T4MhoZOh7+zZCTqH9jqmHoK/fPzsJLXJUfY2o96fk64U2vHEQtEYwJeTQj1qYtZWtxKBXkm4yl2y3skC18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dHQ1MEUG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720736879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GRaWiXvRWFa9Ve6tZcyVHtL4d6UYKXRciWOsNEopzA8=;
	b=dHQ1MEUG81J35Xp+XwWQTMEJVcUF+oJ7yuOK8/7ieH4vHv9e5hcd8Z8XWJQNR0m/+GVaHO
	c4JZvgm+tSED1ANO7A3KJvujAOSEZVQphZEunlU92pC4Cj6CWYqo+1T5zzL4DCIyxrh0ks
	OnE5qyxypXC1O4Kb/YxwYC999Tb8MVc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-163-ZoHG-xItPVCiZ_XaQu750A-1; Thu,
 11 Jul 2024 18:27:57 -0400
X-MC-Unique: ZoHG-xItPVCiZ_XaQu750A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3412196E090;
	Thu, 11 Jul 2024 22:27:56 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 056BE1955F68;
	Thu, 11 Jul 2024 22:27:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH 00/12] KVM: guest_memfd: lazy preparation of pages + prefault support for SEV-SNP
Date: Thu, 11 Jul 2024 18:27:43 -0400
Message-ID: <20240711222755.57476-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

There are a few issues with the implementation of SEV page "preparation"
and KVM_SEV_SNP_LAUNCH_UPDATE:

- doing fallocate() before KVM_SEV_SNP_LAUNCH_UPDATE will cause the latter to fail.

- checking that only private pages are passed to KVM_SEV_SNP_LAUNCH_UPDATE
  is done in the guts of vendor code, as is the check that pages are not
  passed twice.  This goes against the idea of putting as much common
  code as possible in kvm_gmem_populate(), for example it returns -EINVAL
  if the page is already assigned.

- clearing the page is unnecessary if the firmware will overwrite it

- the "prepare" bool argument is kinda gross

The important observation here is that the two paths that initialize the
contents of the folio are mutually exclusive: either the folio is populated
with unencrypted data by userspace, or it is zeroed because userspace did
not do anything beyond fallocate().  But in the latter there's no need to
zero and prepare the page at the time of fallocate(): it can be done instead
when the guest actually uses the page.

Pulling all the zero-and-prepare code into kvm_gmem_get_pfn() separates the
flows more clearly, but how do you recognize folios that haven't been
prepared yet?  The answer is to use the up-to-date flag; there is a
limited attempt to use it right now, but it only concerns itself with
the folio having been cleared.  Instead after this series the flag is set
for folios that went through either kvm_gmem_populate() or that have been
mapped into the guest once (and thus went through kvm_arch_gmem_prepare(),
on architectures where that is a thing).

As a bonus, KVM knows exactly which guest is mapping a page, and thus
the preparation code does not have to iterate through all bound
instances of "struct kvm".

There is an easy way vendor-independent way to obtain the previous
behavior if desired, and that is simply to do KVM_PRE_FAULT_MEMORY after
KVM_SEV_SNP_LAUNCH_FINISH.

(Credit for the idea goes to Sean Christopherson, though none of his
tentative implementation is in these patches).

The bulk of the changes is in patches 6, 9 and 12.  Everything else is
small preparatory changes; many patches in the first half for example try
to use struct folio more instead of struct page and pfns, which is useful
when we finally extend the code region before folio_unlock() into callers
of kvm_gmem_get_folio().  There's also a couple cleanup in the middle,
mostly patches 4 and 8.

Sorry about the delay sending these out.  This should probably be in 6.11
but will not necessarily go in during the merge window, depending on how
review goes.

Tested with the SEV-SNP smoke test that was just posted, and by booting
a Linux guest.

Paolo

Paolo Bonzini (12):
  KVM: guest_memfd: return folio from __kvm_gmem_get_pfn()
  KVM: guest_memfd: delay folio_mark_uptodate() until after successful
    preparation
  KVM: guest_memfd: do not go through struct page
  KVM: rename CONFIG_HAVE_KVM_GMEM_* to CONFIG_HAVE_KVM_ARCH_GMEM_*
  KVM: guest_memfd: return locked folio from __kvm_gmem_get_pfn
  KVM: guest_memfd: delay kvm_gmem_prepare_folio() until the memory is
    passed to the guest
  KVM: guest_memfd: make kvm_gmem_prepare_folio() operate on a single
    struct kvm
  KVM: remove kvm_arch_gmem_prepare_needed()
  KVM: guest_memfd: move check for already-populated page to common code
  KVM: cleanup and add shortcuts to kvm_range_has_memory_attributes()
  KVM: extend kvm_range_has_memory_attributes() to check subset of
    attributes
  KVM: guest_memfd: let kvm_gmem_populate() operate only on private gfns

 arch/x86/kvm/Kconfig     |   4 +-
 arch/x86/kvm/mmu/mmu.c   |   2 +-
 arch/x86/kvm/svm/sev.c   |   9 +-
 arch/x86/kvm/x86.c       |   9 +-
 include/linux/kvm_host.h |   9 +-
 virt/kvm/Kconfig         |   4 +-
 virt/kvm/guest_memfd.c   | 209 +++++++++++++++++++++++----------------
 virt/kvm/kvm_main.c      |  73 +++++++-------
 8 files changed, 171 insertions(+), 148 deletions(-)

-- 
2.43.0


