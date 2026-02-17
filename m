Return-Path: <kvm+bounces-71156-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFdTASuGlGl9FQIAu9opvQ
	(envelope-from <kvm+bounces-71156-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:15:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2C414D802
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6F103036D70
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 15:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141B623373D;
	Tue, 17 Feb 2026 15:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eOeRvHrd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1052749E0
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 15:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771341334; cv=none; b=BPnwyzptMhKkttBqCE6BDK/TFu20BuXX0FYQj6S3g/xz38fZQjubw7x5h/rC8yBhWO8ZRKWltVL54g8g+HqTxDIS1CaLJD3YP/U1u2MDmFAW11Z1081wMwMNVAYA4E/4HP1WlXaI/GZNTRe8M0Ju2tCz9EbORkyQDil1PhGmNo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771341334; c=relaxed/simple;
	bh=DpNNFc9XPWWBvgNO44WeTKEE00rNsn/v40cyQu/gPGE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BTeDM7bXBnfRVpGvWNuptENMZGqIHyMRhU1k39SALYdjq2sTEZpmDOEyPFRYuhfgyYtCa/N5mPuY+nVNstYMnAsiL/qgtADqaEwc+m5rNm2Ahbsu6ZUaIqP7yF1hvUJsWvElw93ti8gv//G6MD6Ykw5QRgS5Xj2L/xXMfYeL3zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eOeRvHrd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e74e55d35so1298117a12.3
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 07:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771341331; x=1771946131; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HPh5d8pZ0/N2pmYYWL0hS3cj+T7x1Qno8FKMpGo1Eao=;
        b=eOeRvHrd2dEpIIC87Oc9/OLfKUZBhVoGSDeIYvh8DzhgWwi09NkPIqmzxtvEyS+0+H
         cxybSMkWH3i67aP4A3ty0ktPnYxy8m1eek6+zV0jSlQxryf2Yn5iqqJq1o9hDGP6TTZz
         GG1K3W31ctYmxEneVYTkblu+qCQeb0Q3ozJ941eXVabE1gG8pqkUfr8wfy79ZAd4yAvD
         a8YVn7XZYc0Fcebf12Qn3nZ6DgXtGh9N/UQhbYcPFCPn2ojEPEPC7uLdyzyPL7ylem8C
         vD+WHQbqCmLZmhc1FQIdZj13N8SG9FX/y4cklMuzek38GHUECMbBNieH76mOfezplKXv
         xzrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771341331; x=1771946131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HPh5d8pZ0/N2pmYYWL0hS3cj+T7x1Qno8FKMpGo1Eao=;
        b=YOy1L8cHjdbU/3NO2+7R+Ed4MJH0tRhGOkCA9GERB7zCftOwQYWYMTw9Mz8vc6eVPd
         0S99cProQXv7xOBNubQnoWm5FQ+6TAJ4NTJHPXys7sAUyOhAOLfQagTl51uIqHdVP0Ls
         CtbKZjS/np6z5ZMlKreKXn7eDOtV6aOqQ0Pg8ETzFIkCunMXzEP8pMvxC8gA7e98UmCY
         Kp/ktYc6R6cgN2rCucErbuUXKQ/s9Ira6HyKwLbfBV3Kqoj5cuT7k3IrOQ8ysv+1ElnA
         r7RFZcgQ3DfMSgUgO00zzYZQGcLFTkOCa0lI7Gj5GblJEGn1+Adu1wxn2ewSoSacQ8FK
         7bEA==
X-Forwarded-Encrypted: i=1; AJvYcCX96+D7M9DFr2idvfOv6olzcD74C4e4J56Ldi3MZtlEJHhe0RzAOGDTYv2sLLbKoh7UY9o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZZgtsXzIdr2eMp5V3t+TW/1DwiCWTvoY6KvOc23e0gRC5j+US
	Mly9EYFc+p9pvJtzHKEiWE+oqvMcZiZ0T+0OEttXjpZvemwmUBV1p7FmtlIHg19wYu/56HJF6Rv
	rQgWrrA==
X-Received: from pgbcv6.prod.google.com ([2002:a05:6a02:4206:b0:c6e:2a5a:51cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e347:b0:35f:b243:46cb
 with SMTP id adf61e73a8af0-3946c6df211mr12345864637.12.1771341330830; Tue, 17
 Feb 2026 07:15:30 -0800 (PST)
Date: Tue, 17 Feb 2026 07:15:27 -0800
In-Reply-To: <20260217014402.2554832-1-ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214001535.435626-1-kartikey406@gmail.com> <20260217014402.2554832-1-ackerleytng@google.com>
Message-ID: <aZSGD-EGSR3Z5Qyi@google.com>
Subject: Re: [PATCH] KVM: selftests: Test MADV_COLLAPSE on GUEST_MEMFD
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kartikey406@gmail.com, pbonzini@redhat.com, shuah@kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, vannapurve@google.com, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	i@maskray.me, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, shy828301@gmail.com, stable@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, ziy@nvidia.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71156-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,kernel.org,vger.kernel.org,google.com,oracle.com,linux-foundation.org,linux.alibaba.com,arm.com,maskray.me,linux.dev,kvack.org,syzkaller.appspotmail.com,nvidia.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7D2C414D802
X-Rspamd-Action: no action

On Tue, Feb 17, 2026, Ackerley Tng wrote:
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 618c937f3c90f..d16341a4a315d 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -171,6 +171,77 @@ static void test_numa_allocation(int fd, size_t total_size)
>  	kvm_munmap(mem, total_size);
>  }
>  
> +static size_t getpmdsize(void)

This absolutely belongs in library/utility code.

> +{
> +	const char *path = "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size";
> +	static size_t pmd_size = -1;
> +	FILE *fp;
> +
> +	if (pmd_size != -1)
> +		return pmd_size;
> +
> +	fp = fopen(path, "r");
> +	TEST_ASSERT(fp, "Couldn't open %s to read PMD size.", path);

This will likely assert on a kernel without THP support.

> +	TEST_ASSERT_EQ(fscanf(fp, "%lu", &pmd_size), 1);
> +
> +	TEST_ASSERT_EQ(fclose(fp), 0);

Please try to extend tools/testing/selftests/kvm/include/kvm_syscalls.h.

> +
> +	return pmd_size;
> +}
> +
> +static void test_collapse(struct kvm_vm *vm, uint64_t flags)
> +{
> +	const size_t pmd_size = getpmdsize();
> +	char *mem;
> +	off_t i;
> +	int fd;
> +
> +	fd = vm_create_guest_memfd(vm, pmd_size * 2,
> +				   GUEST_MEMFD_FLAG_MMAP |
> +				   GUEST_MEMFD_FLAG_INIT_SHARED);
> +
> +	/*
> +	 * Use aligned address so that MADV_COLLAPSE will not be
> +	 * filtered out early in the collapsing routine.

Please elaborate, the value below is way more magical than just being aligned.

> +	 */
> +#define ALIGNED_ADDRESS ((void *)0x4000000000UL)

Use a "const void *" instead of #define inside a function.  And use one of the
appropriate size macros, e.g.

	const void *ALIGNED_ADDRESS = (void *)(SZ_1G * <some magic value>);

But why hardcode a virtual address in the first place?  If you a specific
alignment, just allocate enough virtual memory to be able to meet those alignment
requirements.

> +	mem = mmap(ALIGNED_ADDRESS, pmd_size, PROT_READ | PROT_WRITE,
> +		   MAP_FIXED | MAP_SHARED, fd, 0);
> +	TEST_ASSERT_EQ(mem, ALIGNED_ADDRESS);
> +
> +	/*
> +	 * Use reads to populate page table to avoid setting dirty
> +	 * flag on page.
> +	 */
> +	for (i = 0; i < pmd_size; i += getpagesize())
> +		READ_ONCE(mem[i]);
> +
> +	/*
> +	 * Advising the use of huge pages in guest_memfd should be
> +	 * fine...
> +	 */
> +	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_HUGEPAGE), 0);
> +
> +	/*
> +	 * ... but collapsing folios must not be supported to avoid
> +	 * mapping beyond shared ranges into host userspace page
> +	 * tables.
> +	 */
> +	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_COLLAPSE), -1);
> +	TEST_ASSERT_EQ(errno, EINVAL);
> +
> +	/*
> +	 * Removing from host page tables and re-faulting should be
> +	 * fine; should not end up faulting in a collapsed/huge folio.
> +	 */
> +	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_DONTNEED), 0);
> +	READ_ONCE(mem[0]);
> +
> +	kvm_munmap(mem, pmd_size);
> +	kvm_close(fd);
> +}
> +
>  static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
>  {
>  	const char val = 0xaa;
> @@ -370,6 +441,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>  			gmem_test(mmap_supported, vm, flags);
>  			gmem_test(fault_overflow, vm, flags);
>  			gmem_test(numa_allocation, vm, flags);
> +			test_collapse(vm, flags);

Why diverge from everything else?  Yeah, the size is different, but that's easy
enough to handle.  And presumably the THP query needs to be able to fail gracefully,
so something like this?

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90..e942adae1f59 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -350,14 +350,28 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
        }
 }
 
-#define gmem_test(__test, __vm, __flags)                               \
+#define __gmem_test(__test, __vm, __flags, __size)                     \
 do {                                                                   \
-       int fd = vm_create_guest_memfd(__vm, page_size * 4, __flags);   \
+       int fd = vm_create_guest_memfd(__vm, __size, __flags);          \
                                                                        \
-       test_##__test(fd, page_size * 4);                               \
+       test_##__test(fd, __size);                                      \
        close(fd);                                                      \
 } while (0)
 
+#define gmem_test(__test, __vm, __flags)                               \
+       __gmem_test(__test, __vm, __flags, page_size * 4)
+
+#define gmem_test_huge_pmd(__test, __vm, __flags)                      \
+do {                                                                   \
+       size_t pmd_size = kvm_get_thp_pmd_size();                       \
+                                                                       \
+       if (!pmd_size)                                                  \
+               break;                                                  \
+                                                                       \
+       __gmem_test(__test, __vm, __flags, pmd_size * 2);               \
+} while (0)
+
+
 static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 {
        test_create_guest_memfd_multiple(vm);


