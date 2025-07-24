Return-Path: <kvm+bounces-53408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E376B1132E
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 201E01634FC
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E84238D5A;
	Thu, 24 Jul 2025 21:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w5qPr1Pw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2844A1F0E29
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 21:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753392800; cv=none; b=tUpkZOmDAHLYIRJTDnKx2b69Nizrvp2JdNOast/Q65ab1qa9n4v3rPo0+laLhrCex1P3jHpspzqroNtOwn9FhGvriGjmie7tt3+ONsCH9Z3AjfrXa+TN227htrlA+0+9TbiI89Yq76yPPSBKp+0cVGqB0/RYVah+Ulx4bkzuB08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753392800; c=relaxed/simple;
	bh=+9WMuKhGKTGANqNj5nS9I/cs92WS44yAF8Kqy+9Sz/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AfYbnpFphzOmvKhJLfGCX0jv67Y7IUHLzoTThvuNzlxFWlscKIO8yHvmkwXUYeH5QDOHkPOSHjn3ujQz+KHbiBk+3jedMLSwwOhPnNuuoe3uoG/oYhaA50lxqIrVmsdUYMVZ6fc8g4DuNxhrUm6ObGhGCLZTwYXxXbssZHlGrVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w5qPr1Pw; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-553b6a349ccso2178906e87.0
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 14:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753392797; x=1753997597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9WMuKhGKTGANqNj5nS9I/cs92WS44yAF8Kqy+9Sz/s=;
        b=w5qPr1PwfncHGXuF1j0/J6md8rAn+NL8gi4aFlYYplPsLRu9NQ5zHQxE95uapC58C4
         I8TO2Ut2xfx1o/tDu529febl3aPklj1VTiMgmITTVlpd0SsJlQ8z3vUCu+jrpJ1NOMFp
         8+xX2OUEnRvEP9HIE7z4P1i+nPZ3REG5RJ7gdtpgnZJ68gLd3eG7aS6QZMmf2uH0jQkt
         GfvQwEW1QE31tqHKTIonFYLodkKUvLQcgTV4vzt2DOjKmYaILKydI8cVOTeaH+6r3krY
         jBFPlVWECwV687LyifiPKcc4cBwogtjHkAqoyX/asM/3+CMz6ry8xdAhD6TqpDS8TrS4
         9Wow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753392797; x=1753997597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9WMuKhGKTGANqNj5nS9I/cs92WS44yAF8Kqy+9Sz/s=;
        b=K64dMUmPB0Nh1rFv4TEaKz4/eVAqaWnhxdc+rxtJrdXiIeB6PzT1FPiTjlZ+kjLM7i
         oQbzfneUj6S64SqUiyBZhMUKjexc3cJJ47bb5ANhbDQVKfk1YrLS2fAZcsnHo5kQPANg
         h4THhkWLDCg1hD4xzN+/M5Zk1qZDp5JgBhaQEfVRJ2rN7vhqo8PMo8u4NT0vticiPip+
         xSSFZerTTnbBfSc2ugEorxIiG9nxqY9GxXaXNp69Q0plvH2EEp+Cte4d2ax9SE5eAV4z
         BoDXnMfSV0ggf1jYteDiA9Sb/V3By1SC4I4b3/CJamkkN9AnPRfZ4Yl2TFNkIEj9zIAV
         Nnig==
X-Forwarded-Encrypted: i=1; AJvYcCWbYrm3zjs7d9UawQD3NMoORv0Z4pB1u4iLNlLg6YsRR9gzIjHKZRXzhTVrzb6ni8ztGso=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx67C+XT2gK34aJtzrJd6lxjFGMapXueCn3b9SSLzCwGJUec1+s
	ItHwYx6swtS2EdNUf1DQB2QwJySdjRNG8l4mL1M2+F7ha56r2EoldV6aTqh7dMrpxRoFno+Q1OV
	8OjM3XsLcb4ENzrGGjjsJTesw/8kaUryVy0fFBwCo
X-Gm-Gg: ASbGncs9TSk/dnFw1yAkBAJj3Qfm8nTyRMULCErtSwwjZJxNE2bLqw626moycybgzlF
	lOWU34TfO4whsiDVUsmRBg2lwkvi4smf4Vmvlt70h4UaaNlQXLSFlNxmAXvf1UOwBuZXJHKQRWZ
	5+E11pqCYSle9pmbOJRgJqxzh0h4ynAA36IxIbXTpcdH1Z1FvGK2AFdadACIG00Ppu0nxgqZst6
	NUelqeY/NQk9IxUOw==
X-Google-Smtp-Source: AGHT+IHMRXSUQruSwAGvnGOD3EQouFK5BDuoQQKLfjudXv/r48PrAlD00NV88CdLcnUOYHt4d/CAR2Ul5KGcFwPrzvI=
X-Received: by 2002:a05:6512:3ba8:b0:55a:4e55:cb94 with SMTP id
 2adb3069b0e04-55a5136ec3cmr2426178e87.8.1753392797019; Thu, 24 Jul 2025
 14:33:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724213130.3374922-1-dmatlack@google.com>
In-Reply-To: <20250724213130.3374922-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 24 Jul 2025 14:32:49 -0700
X-Gm-Features: Ac12FXwHf9eQdiI06f_G5BDqiKGfQdnCV_Ln38G7zauukGS93UKJVW47OIweLbs
Message-ID: <CALzav=dimvJG3aDBtzhi=t+OAp-10oGAmOuSSHOpSTYtK1Af6w@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Use $(SRCARCH) and share
 definition with top-level Makefile
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 2:31=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> This series switches the KVM selftests Makefile to use $(SRCARCH)
> instead of $(ARCH) to fix a build issue when ARCH=3Dx86_64 is specified o=
n
> the command line.

Please ignore the "and share definition with top-level Makefile" from
the title. I ended up dropping that patch from the series.

