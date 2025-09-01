Return-Path: <kvm+bounces-56444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D060B3E4E7
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31628167DE0
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04DFC338F37;
	Mon,  1 Sep 2025 13:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jB64EKIG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A49C326D65
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 13:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756733202; cv=none; b=njVl2CHhVjgVbVebS1ZxhjoUOL3AakyQeSzsiv910BZ4b0x2UYPq7PhMnsmpgTpyF/rvQfRavP66PKYWz41uaq2Ef0CDq2tU6vlJ5mkjhCwmarVyBGhxQHgEpyt2m4KgZzG6VEiDLgfT6rY4f84oKlKgj2P90/cF20VqQgJ6nZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756733202; c=relaxed/simple;
	bh=HHX/N9F3vHDu9Ar+DoCEydT8/iY7w7lEqrnorLai2+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bzjdmAHkCs3KX1TBQKmlpCwkAaMEt4tX2suZuldRcAVzvyyDwpH4rFZX9OEe0ZWCVMCSGq1ZXv6QQyxmG0VqVmHXY7PEgbu4SBPHVs4Dp/LA5L9qER8VvE9q2XHALcuzuA0JugqYqjZYu42mwpaumy6bkEonutHvTFDWt5KiyJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jB64EKIG; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3d3f46e231fso957999f8f.3
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 06:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756733199; x=1757337999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+dSMANYXYS4eX2wt62pDprg7NzemwQS+AGCY6LE+2A=;
        b=jB64EKIG+NhrX3xd4j7eXScvEoZ17i1CdfrdgDfkwY5eXNtPTBZhkNurY6K1dxV/h2
         V+MxMjfYpgppFV2ZzudupsdZRK8AAKVa6B3SmWaA34/fzd1YJh79Jnjrvk9VO9clXieE
         7ZTmrTtYFCz7ywVLfIi42uLf4VVk6v+qGHD4T1RIw4qpf8ucRmOr8P/HJf0hlXOaShG/
         yF5kgWYTGNHphST35jiuNoq/QWAhEmKOQO1W/SY4FCRviWNJsV6/ZWsaaOIWPtK+2jjQ
         QDFTBEHTq+VV477pzD1b6IfS+jqEW9vxOfN1y+Zb3FMcmPvY6+wKaMI+wjk6/Oti0FQC
         nbNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756733199; x=1757337999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+dSMANYXYS4eX2wt62pDprg7NzemwQS+AGCY6LE+2A=;
        b=bKgC4cXhKum71cay5NxHXYCCc+0DhkVyWxsv3OZZ919HB2iJSfArzmdllYjhz+oRfg
         uvlQAP02myZTxORq7iawjx0Je2ChDkAwk3j68ocVcohtmi4fXj9m2/l1x1Vg6ak/YUd9
         1zmtVGwnzw0MF1X3I4rhgM/kwlu4B5zkpErj4njHs4DzBPBi60jd++e1FspZcgxTIWLF
         s/4nrvXGeSo9Mi0fXD7Pre6GT9twDPCNZhga6QHM/SB3J2ZsB9oHYeot/NSCtF3G4MEY
         0dW3Axl+4dMZQoVcfxwGTkmCp8Nxgzn08qzDHL7224e59vARkR9tnOyH+BYqwS9DGrjY
         +VOw==
X-Forwarded-Encrypted: i=1; AJvYcCUDzwRj+9sXiTY/pgDVQnvWszHS/Uiltdprc53WCz6iGWWpmcZy7MBqbnTArom8rNeXnIw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL8TEOg5usbxrB+BWvLsw6lUJzfhwi0n0sFFXRsjP0YV9YHb8D
	UTQ+9ggbMmt+ZDu70FeDZ9dLXprTOwhNmZ3VzlBLmO1cxFFhWko1XmuGQZfNgG1M7hs=
X-Gm-Gg: ASbGncsDWJEo8LrMM99KZmD/fA6NvARrxbn4NGnPd2oZQLdeW0dl4w6nOWJeWFYfUjp
	tM2avKbSmUzLSQIPP5bgynkB6i/cKQFsS3lzkL9xm2cSItbHLEIVJwZ0fP3JPz43vSRZCqyKB8B
	IWTuvS+Mj4bBrzHjDm6e3I4oxJd/feBxbDyIcjyb03FGgGuZw1Ay8zWx+VEvVKriazRSv7NLvpG
	TzPw/Fu6AnxB0JmNC4YkJL6qsymccceWZ/a/eXjeXO8rMrh7tJVBTwpQEPcWOdOrBf+Jbrd6mZH
	dKB+873XQAaPaGBZDJvk45Uce/BQ/9bBP8GlBPrq/+wy7FuUX69NnF3MSG46eUFVDzWPNrBG02/
	N1yuiPpV0FrtSCFd+g7yeEoScL9Hf0BOFkwHO6J/zjrcWljIIeTDGz/4vTtDSX/XzUrwq98h5uT
	9RGBU1h2k=
X-Google-Smtp-Source: AGHT+IH/biFnPlU5sduD1LlOAZlDqq09up2/DXS+LzpPSrlccEYwoUtgNnCXPzTclSesIQRP6VzILg==
X-Received: by 2002:a05:6000:4205:b0:3d9:415c:b146 with SMTP id ffacd0b85a97d-3d9415cb164mr246904f8f.15.1756733198715;
        Mon, 01 Sep 2025 06:26:38 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0a7691340sm14439034f8f.39.2025.09.01.06.26.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 01 Sep 2025 06:26:38 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	kvm@vger.kernel.org,
	Glenn Miles <milesg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH v2 2/3] buildsys: Prohibit alloca() use on system code
Date: Mon,  1 Sep 2025 15:26:25 +0200
Message-ID: <20250901132626.28639-3-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250901132626.28639-1-philmd@linaro.org>
References: <20250901132626.28639-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Similarly to commit 64c1a544352 ("meson: Enable -Wvla") with
variable length arrays, forbid alloca() uses on system code.

There are few uses on ancient linux-user code, do not bother
there.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 meson.build | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/meson.build b/meson.build
index 0d42de61ae6..3d1dc2e9e26 100644
--- a/meson.build
+++ b/meson.build
@@ -775,6 +775,10 @@ if host_os != 'darwin'
   endif
 endif
 
+if have_system
+  warn_flags += ['-Walloca']
+endif
+
 # Set up C++ compiler flags
 qemu_cxxflags = []
 if 'cpp' in all_languages
-- 
2.51.0


