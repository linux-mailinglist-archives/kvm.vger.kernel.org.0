Return-Path: <kvm+bounces-56717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B2FB42D68
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 01:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6AA207A075B
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 23:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A631459F7;
	Wed,  3 Sep 2025 23:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b="mTuIbCyp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8452F3628
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 23:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756942089; cv=none; b=LbTJHUOOWUddiZT7JstvCvoU0eb77NgWPhDyGNddMdN/D97KRKLLkBm47BnfZ9czdX1LDZhaJ8OVzIVFkdu+5Yri0D6aKr4v+xtzbHO3t5yqY9MP+ShlzRI6MXW+jYB/TysE+qGAZxAg9w8zYAsejGVfaiIvLTWDWk5PDwkYydU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756942089; c=relaxed/simple;
	bh=wWMNOiifnHxOkk4+CLFedP4hni73V2YWtoPNvOZOEhA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=MKzdxSMEZzeHtPdlqy+o60x6d+jxPbg1O1bPCfdJyQVYpnWfKBenLKftuI/OgBYgLkalvgcNB4Q7v8Q/KkQ6Jg1XlSNTMh16PqQGnIKIrHEeU8YUxwN1c+S529PnfLhrjyTDlD0Gv4tt5r6IuxdyW0ZLG03cZMdqq1stAiYePDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b=mTuIbCyp; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d5fe46572so4530687b3.1
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 16:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google; t=1756942086; x=1757546886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qMfa0Po6AON5gKDR6IPWYqovOd/cI9bxk3AYRRhlrHs=;
        b=mTuIbCypmFnLNv9vG0MXll59vMbvZznbnM/aL+a2SIry0WHufbwLKT0ciAvj886GTr
         YieaxbAKtRhzKxlz8+TQBUfAv1cN5M9ANKdzbM6cJXZJU5j+U+fS196NwNaUmbBvyqDN
         FWPbb9fI9a2e2n1SclHvJvLjdu9cZQZdI4FTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756942086; x=1757546886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qMfa0Po6AON5gKDR6IPWYqovOd/cI9bxk3AYRRhlrHs=;
        b=iADQnzRah9+3HrK6uckuXxqOqjgNlNgTCceDEA/sifnA2tl7IBcxnzFdkXE3RwOQ07
         ANjCpo9QlV9DI0CsbiJAnC+AsdRQE97HVjDByTUg6yF4Z87chqyz24tqQjAVfNDrDnmk
         Bo8tRXaMzRGpKG4sG+pAsdc+NEdcS9wSeiLJ1WAJusMTyLqYZv2Fyvu1EHvrqVsky5mI
         mxPbMOePN1GgWZ8kJOSFFU4DC4L9Se1aejPU1L1yEmZ3Y1yYVVzdpcWeCOj+KBIKkG3v
         joJho37vdX5/6rvt1ZVLoBmHn/ZRdh3F7FI+GcJ+dGgfJZz16h/m/EwguxRSLZzventg
         plrg==
X-Forwarded-Encrypted: i=1; AJvYcCWQ0cL9IDOUOjPId4nSHTzFRSl1yP5nqRS3JwUtyseiumjbb/kaLsbgD3ssYJ4/KqtujXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YycHRwCqZG0yzT1/bcp8TvVfLTUWbCfi5AjIwaHoEjryrj4gU8q
	Iz+LpipMjBHrY7xLIO99eudZsWCa5n1Visk0yjZn24JcPASqYdQ3/1y+M8sAXU1sNZ9cj22HdC1
	N0fUn/cWTFI5N8A+uilBVppMvc3Ww6kWqa6eh
X-Gm-Gg: ASbGncv7hxBzVdET0sZyXx0hWD0wMbf0rijr+zuRTlCd2tzaDsdPGopG6LPxbCWbNlt
	aYf7Lyyl0VY86qD+L8yL9o5Jg57Y3BX7IPEbTr5TRdcSTZJ9/oQ1OgbGFTAWC+LhUrK1DYQKfBf
	oFYxq0a51sV6Q/8oDlePfNOS+FhZH9N8V8d237vEd1C4jWcHv3lh8nU/KpwrhwD+/BS4G2fAey0
	A7UvXJna4ln5oQ30wa97qiIiFZr
X-Google-Smtp-Source: AGHT+IH7FznMSuqEQ2w53VR/rPJV67jGSBAu0+n6G5x02tRwmPlsb58/aw/SdRFJTb2blOuXAEnNZ3frBVjX7pavExM=
X-Received: by 2002:a05:690c:56c7:b0:723:98d5:7a62 with SMTP id
 00721157ae682-72398d580ebmr117553917b3.3.1756942086010; Wed, 03 Sep 2025
 16:28:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joel Stanley <joel@jms.id.au>
Date: Thu, 4 Sep 2025 08:57:54 +0930
X-Gm-Features: Ac12FXyBWvVQJdjUNlsar2kSzZYXaU1pqyCoAGwB_58XykOmtj1mldKZW998MQE
Message-ID: <CACPK8XddfiKcS_-pYwG5b7i8pwh7ea-QDA=fwZgkP245Ad9ECQ@mail.gmail.com>
Subject: [kvm-unit-tests] riscv build failure
To: kvm-riscv@lists.infradead.org
Cc: Nicholas Piggin <npiggin@gmail.com>, Buildroot Mailing List <buildroot@buildroot.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm building kvm-unit-tests as part of buildroot and hitting a build
failure. It looks like there's a missing dependency on
riscv/sbi-asm.S, as building that manually fixes the issue. Triggering
buildroot again (several times) doesn't resolve the issue so it
doesn't look like a race condition.

I can't reproduce with a normal cross compile on my machine. Buildroot
uses make -C, in case that makes a difference.

The build steps look like this:

bzcat /localdev/jms/buildroot/dl/kvm-unit-tests/kvm-unit-tests-v2025-06-05.=
tar.bz2
| /localdev/jms/buildroot/output-riscv-rvv/host/bin/tar
--strip-components=3D1 -C
/localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
  -xf -
cd /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
&& ./configure --disable-werror --arch=3D"riscv64" --processor=3D""
--endian=3D"little"
--cross-prefix=3D"/localdev/jms/buildroot/output-riscv-rvv/host/bin/riscv64=
-buildroot-linux-gnu-"
GIT_DIR=3D. PATH=3D"/localdev/jms/buildroot/output-riscv-rvv/host/bin:/loca=
ldev/jms/buildroot/output-riscv-rvv/host/sbin:/home/jms/.local/bin:/home/jm=
s/bin:/home/jms/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin=
:/bin:/usr/games:/usr/local/games:/snap/bin"
/usr/bin/make -j385  -C
/localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
standalone

The failing line, with the full paths trimmed for readability:

riscv64-buildroot-linux-gnu-ld -melf64lriscv -nostdlib  -no-pie -z
noexecstack -pie -n -z notext -o riscv/sbi.elf -T riscv/flat.lds \
    riscv/sbi.o riscv/cstart.o riscv/sbi.aux.o lib/libcflat.a
lib/libfdt/libfdt.a
riscv64-buildroot-linux-gnu-ld: riscv/sbi.o: in function `cpumask_test_cpu'=
:
lib/cpumask.h:35:(.text+0xd8a): undefined reference to
`sbi_hsm_check_non_retentive_suspend'
riscv64-buildroot-linux-gnu-ld: riscv/sbi.o: in function
`hart_suspend_and_wait_ipi':
riscv/sbi.c:591:(.text+0xde2): undefined reference to
`sbi_hsm_check_non_retentive_suspend'
riscv64-buildroot-linux-gnu-ld: riscv/sbi.o: in function `cpumask_test_cpu'=
:
lib/cpumask.h:36:(.text+0x1064): undefined reference to `sbi_susp_resume'
/riscv64-buildroot-linux-gnu-ld: riscv/sbi.o: in function `susp_one_prep':
riscv/sbi.c:1434:(.text+0x1796): undefined reference to
`sbi_hsm_check_hart_start'
riscv64-buildroot-linux-gnu-ld: riscv/sbi.o: in function `check_dbcn':
/riscv/sbi.c:1247:(.text.startup+0x9fe): undefined reference to `check_sse'
riscv64-buildroot-linux-gnu-ld:
/localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05/ri=
scv/sbi.c:1247:(.text.startup+0xa02):
undefined reference to `check_fwft'
make[2]: *** [riscv/Makefile:131: riscv/sbi.elf] Error 1

The full build log is at
https://ozlabs.org/~joel/tmp/buildroot-kvm-unit-tests-build-log.txt

I was able to reproduce with the 2025-07-31 tag, which is the same as
today's master branch.

Cheers,

Joel

