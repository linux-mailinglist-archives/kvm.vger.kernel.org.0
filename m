Return-Path: <kvm+bounces-48187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32DB6ACBB6E
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 21:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C806A1700FB
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 19:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4667226CF0;
	Mon,  2 Jun 2025 19:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kQHtEaU0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7892A22301
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 19:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748891889; cv=none; b=M5wiWlSv+YxI1nCkB5h0OJZm7sJoQDe8gEnc9v1FMtCBLIZcz79vjrwsyVfIb2iAbfwhkESHHrnO3Tl7emefHGsMgghVIm69v8FJFiw+vPYVjz3KFDGaEm8TTqd1kWd5gacTDN8TA2PfKJPVKu3iRm+6ZzBh2bEFs3v8HZS0AjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748891889; c=relaxed/simple;
	bh=12/Gd93aaTA83c1HNtC1zFmn672vDmey9gAStWrKOoY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XGRQXKIX2tWec7g//CGEVCwwvuNqBHfxor5ghSUn4TIUMX+YldZSFotOdOPJqrTAOHXVu3eSVXxipCmISJtfwqG85Ug3cRbuGRpRrI4iiHaeRKuuiZAVxV5riki1bvg4SgMsbn30LFH1RDzFZHWa1mAqdD7eBUK1BJZbLNMHMWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kQHtEaU0; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c00e965d0so3132524a12.2
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 12:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748891888; x=1749496688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FJKFQqx9UM1AGUF2AcszFEpAtqC30YGJfsyhTo68y9A=;
        b=kQHtEaU02gUFZI7kQZpS2D4kUyFrmcfBxzys+8Du5J/cOVsN9JbvM6p3Y+tHjZacBW
         YJTwQ/VXzCZTzBK05Xanvcuz0eG2SeC8P77/9969rEkp5HXW5JwUmm1HI2QwUJE04Eh1
         ZyQaFjjGNbTj65r9uMh7Hxk7UwEbnYZFF1Xz36ALRwVtyrdWRqLxCvPRc+/TGNhwMcYA
         05l0Ix9xgbkIgYnuBOwuI0kU/0Jb4v192ZbCrXOjwodVXVUW6tjaZwY8UuEQyGlc/EdJ
         y5z6NGJHzvjwSIJyaH5+yrdX8QgaVyDWNlwKMqoJXDOlBlUhrqWMzo23sRP2Xag5eWGp
         k58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748891888; x=1749496688;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FJKFQqx9UM1AGUF2AcszFEpAtqC30YGJfsyhTo68y9A=;
        b=c2D0Q9VuVMVX3V2o50jfRk8biYEX5u9gHFQvJDIHnLd8oxMi7ms8KzJiZeDkKj7wnT
         cSTtuWtVENLQQKG0Ws0zCJ5+IPi2rovhKWXzSefEf0IxWO+6Kr6JogbSXRYaEoQGrTRt
         jXNf7ORz3Ps8YUjol4n++7/oDOvjOgOZRu/yTvYQy81BIrW28zB6ajVOls/WQNI+iTZi
         Qi3UfHlNPu9sLIHbzO4qugbyxce15j57eMMgDwKQAilMs32WEdQRC5FZ3pUngxgSoUwE
         av0mSB0Ldg3mAAY2JfQapnaSzCnhbyU3kM417xj3iEUX4O4t5WlKcrMU2W0wqWhWT0Er
         cpBg==
X-Gm-Message-State: AOJu0YyCNIywchURDfbsK8q7RzxX5ciOdGz6nEJID3Kvg5F6tsgu7Ymi
	Hkh4PSfK8I0bXBwddvL1f0jMyRTfzdSkeucSXxQURQYN8boztfHY9yHVtI3SBgxhBO7vXKqA+6K
	13ikOnuPp7DrofbZCpcD5O+UzZDBEXz2crCMG3iAL9qyAVpnoveL+telnZTY2Wru6IDJd4BBCaU
	LoiFzjTIV8JoRPm6mXOI+//VaacLnLzsR5gei8kTvcY/SQmmjSBPfCmMh8rZQ=
X-Google-Smtp-Source: AGHT+IGq+MKdUzduCIrTwDf5QIgX09YLMJA7ZELTYRvBBkbWv4Z283ky9bfc20mR5vbgJYZFPZLaDF55ZVFFrEdiWw==
X-Received: from pgbfe22.prod.google.com ([2002:a05:6a02:2896:b0:b2e:c47e:345a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7484:b0:218:5954:1293 with SMTP id adf61e73a8af0-21ad97f95b5mr27557841637.34.1748891887220;
 Mon, 02 Jun 2025 12:18:07 -0700 (PDT)
Date: Mon,  2 Jun 2025 12:17:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <cover.1748890962.git.ackerleytng@google.com>
Subject: [PATCH 0/2] Use guest mem inodes instead of anonymous inodes
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: ackerleytng@google.com, aik@amd.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, vannapurve@google.com, vbabka@suse.cz, 
	viro@zeniv.linux.org.uk, vkuznets@redhat.com, wei.w.wang@intel.com, 
	will@kernel.org, willy@infradead.org, xiaoyao.li@intel.com, 
	yan.y.zhao@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi,

This small patch series makes guest_memfd use guest mem inodes instead
of anonymous inodes and also includes some refactoring to expose a new
function that allocates an inode and runs security checks.

This patch series will serve as a common base for some in-flight series:

* Add NUMA mempolicy support for KVM guest-memfd [1]
* New KVM ioctl to link a gmem inode to a new gmem file [2]
* Restricted mapping of guest_memfd at the host and arm64 support [3]
  aka shared/private conversion support for guest_memfd

[1] https://lore.kernel.org/all/20250408112402.181574-1-shivankg@amd.com/
[2] https://lore.kernel.org/lkml/cover.1747368092.git.afranji@google.com/
[3] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/

Ackerley Tng (2):
  fs: Provide function that allocates a secure anonymous inode
  KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes

 fs/anon_inodes.c           |  22 ++++--
 include/linux/fs.h         |   1 +
 include/uapi/linux/magic.h |   1 +
 mm/secretmem.c             |   9 +--
 virt/kvm/guest_memfd.c     | 134 +++++++++++++++++++++++++++++++------
 virt/kvm/kvm_main.c        |   7 +-
 virt/kvm/kvm_mm.h          |   9 ++-
 7 files changed, 143 insertions(+), 40 deletions(-)


base-commit: a5806cd506af5a7c19bcd596e4708b5c464bfd21
--
2.49.0.1204.g71687c7c1d-goog

