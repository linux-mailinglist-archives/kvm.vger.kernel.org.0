Return-Path: <kvm+bounces-29849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5DF29B3128
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:59:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A23B282749
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84E01DACB4;
	Mon, 28 Oct 2024 12:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MJ3xwLgS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027F31D63D2;
	Mon, 28 Oct 2024 12:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730120335; cv=none; b=lUq7QBcZXEpYiRGFYqAjeItMSiQluQn/E1UgbqYp4yPuSEX/4TLew/P83T5PRLTWYu8HIxY7LXRRdvpYoXLSD2oYlqk45wdyf07Nl1A+EaOnKOXrkywDhgpdgVYf6WefbthYoZ2BSzkq7Nl9oWznIkqQsDV2sTY4KH+/aaOjYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730120335; c=relaxed/simple;
	bh=O4nJoyaHlEI88PTJ9C4tzuiQ5Lk1Y9Mel1G8psWxM48=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=amWJJjU5mje8nwhCkl/6bM5f/N2onR1wmKtCGJ/N9G6O+ZrKkA8RbNNJd9Y+u3KZ/wU9+h4BSxPX3z5QkrV7Yme7Jz2Y46rS6LTfbgzpxeHmTQzGRhD21TiTGIWcZcy79ry0PHj/2T7LKO0mvl6+4My/66icpSsY3NkBtw8/2wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MJ3xwLgS; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71e3fce4a60so2969612b3a.0;
        Mon, 28 Oct 2024 05:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730120333; x=1730725133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jKgkvz9gFZebGRaVM/2cJhJYDRQXUypBSPvLf/3N+Q4=;
        b=MJ3xwLgSkhHqB0JL7Z5kM+oipVtyefBLsDtJfNhvmdZuZDuGf3YzMX+wuinV56doI0
         X0GYThzpkfw2oaqHdQPpkp1LfjALNhi83Hr06zyHR1p2lQm9EB5Vtyhpjxc8hs6ga4yQ
         +vFwJsucbSQOU81aCjTWMLAAMjz16aeOR/07NzbkOEGsNFQp3PBqn2dQmj/Mru9BylQ+
         smN69V2ZeWyJIWOg8zH3zSCqAzfXIr2/pv8S/aegCWKk/nfr34avRa1/WhLVHki5B4Zx
         V+xAC9ZGXM416v1Tc9lxN/Znw3SIEO38Fg/2U6cZbklTfSZ4pSs1emdYP41SiXeF22+E
         zVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730120333; x=1730725133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jKgkvz9gFZebGRaVM/2cJhJYDRQXUypBSPvLf/3N+Q4=;
        b=OZllZNKnOLGwK0u/+ysy9KieMEyeIweNto80m54clmkic9kHFM9IbfAx9aVxO4aKmS
         LMutfpv7Sm3xvJ2VZiYJZqi7lLBx5PmiXcgFRjEcSVLyD3EbqlfwkJWvnalWTlQpjOv4
         K+Ccjd9EZPqO0LkgNMFj7ceTOSYHp5vbuReN0rE0jiWil61XEx+1S+iUEf5eF8Qus0lK
         4p9i8k2kWL/7LEzObukgoSqOOKuP3x0VzaI2mlDjXNDFjHVbwiOa3+W2ANzlHu2cSfe3
         7kftYhci08pZwptX4qomemi/SfwEYLEsyd3K2l9HaOOBvb8v62BVGxOtSqbAEmg9k3Tc
         2tXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNE4sbitXTUlc0jwT0eVs8numK7SCwE8+BmFXvSqPU9sfUTf7NQ6kuyHoqq6Z346njrfw=@vger.kernel.org, AJvYcCUcHoiaYoa56TjBBlexq70k8kWO1+QnNFEGex9FJoKGnuHXuwaciM5GNtZgiGQHPFA+XNlytvI3VXX6jQ==@vger.kernel.org, AJvYcCXCO2GRNadM2sLrVLLdGfcUMyd+QsTNSpQ1fAoqBC5lE3j30aPSX+A/aqBq4YUfkyEUgE6cj5RtOldP@vger.kernel.org
X-Gm-Message-State: AOJu0YziNcJi5q6vMBb4HQ7rA27K/KFgpXZ1Iujw3fM3IOdwk820Fv7S
	L7jjGomVz+2zVuqLyT+LnqWjcICVr3587v4sghg7I4L0VmJ8ZIv/
X-Google-Smtp-Source: AGHT+IG65Ukp48Q3Urz92aAIdwqpwFCmishmtXUOPU4xixYHACM5tntO6HzsYRgmjyipMaaS632Sig==
X-Received: by 2002:a05:6a00:1783:b0:71e:592d:6fa9 with SMTP id d2e1a72fcca58-72062eccbb3mr11892204b3a.1.1730120333129;
        Mon, 28 Oct 2024 05:58:53 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7205791dd8csm5650244b3a.22.2024.10.28.05.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 05:58:52 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id CF4BE4207D11; Mon, 28 Oct 2024 19:58:47 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Documentation: kvm: Reduce padding of "At the beginning" cell
Date: Mon, 28 Oct 2024 19:58:35 +0700
Message-ID: <20241028125835.26714-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2785; i=bagasdotme@gmail.com; h=from:subject; bh=O4nJoyaHlEI88PTJ9C4tzuiQ5Lk1Y9Mel1G8psWxM48=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOnynV+K07Zt87x7yNvs07mJ0vWzVv/937hBw+L0XSW// 8KmLXFfOkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCREnOGf7pVV+JFbuT8mtOs N8XfXCHAqm3JWwarTduuz9vdp840+xUjw5Wp8ZuPi27dPOfqYcsXVVtOft06t8vJbtUUBeaSKbv l9ZgA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Stephen Rothwell reports htmldocs warning when merging kvm tree for
linux-next:

Documentation/virt/kvm/locking.rst:157: ERROR: Malformed table.

+-------------------------------------------------------------------------+
| At the beginning::                                                      |
|                                                                         |
|       spte.W = 0                                                              |
|       spte.Accessed = 1                                                       |
+-------------------------------------+-----------------------------------+
<snipped>

This is due to excessive padding on "At the beginning" cell of gfn to
pfn mapping matrix; more precisely on the cell's code block. Since it
is indented with 8-space tabs, the amount of required padding to close
the cell can be less depending on position of tabs (in this case, 5
less than if it is indented with spaces).

Reduce the padding after the code block on the problematic cell so that
the border aligns with the rest of table. While at it, also convert
tab indentation to spaces on the code block to match other code blocks
in the table.

Fixes: 5f6a3badbb74 ("KVM: x86/mmu: Mark page/folio accessed only when zapping leaf SPTEs")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20241028192945.2f1433fc@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/locking.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index f463ac42ac7a7b..6fbbf6d5ddf3af 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -157,8 +157,8 @@ writable between reading spte and updating spte. Like below case:
 +-------------------------------------------------------------------------+
 | At the beginning::                                                      |
 |                                                                         |
-|	spte.W = 0                                                              |
-|	spte.Accessed = 1                                                       |
+|       spte.W = 0                                                        |
+|       spte.Accessed = 1                                                 |
 +-------------------------------------+-----------------------------------+
 | CPU 0:                              | CPU 1:                            |
 +-------------------------------------+-----------------------------------+

base-commit: 5554e2f8d01bf2e4cb1acbd6f00bd8a42e214b06
-- 
An old man doll... just what I always wanted! - Clara


