Return-Path: <kvm+bounces-15998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4648B2D76
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F38E1F21991
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8953156C65;
	Thu, 25 Apr 2024 23:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D5sSIXoq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD1E15686F
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 23:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714086631; cv=none; b=hhn24C17ea4IT4F0WDfs42oGR1pSrovpOxQ7/ljOqEkF/JD8MKoQYgWmhtWyyqyfFrLTqAcwRkmVWIasydAPJBkSukmG5u+hO8Ic3Qv6fvEOwMln7v3+oftv2/GpyTqml0FtwFiWJH48Rh5sSnrxFStMr5qDvfEDa5kSNqJABKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714086631; c=relaxed/simple;
	bh=zTkgFfAHRBc68cUsuLXVtOjsq96hByN4x7hSD1bfdOo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lgDI8dg5An/TqPNYiderFDIebdPowoSxqoe0m1g4O3lIvBQRgoNMgcSa8qFQqKg/TMWuriZHv0v201Yr6O52O/j/Q9ltGVUuzBWfl1XTAPo65zENTacYZGlQfL95nGctbI6aCr/jw+pF5//XLvzZp/2lFLuoowC7kVQF1DmXHTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D5sSIXoq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed03216b70so1837375b3a.3
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714086629; x=1714691429; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DUCYtH/HKWn8ExkVR1X+jCKv2DoEuOQK+l1YHfMHQfI=;
        b=D5sSIXoqnRr6ulKefBtpEoOHyLPfHzqUmlHk88pZmt3mdxh/kB/Nsz6GsuapNtCmVC
         dTcnjQ1TohaB89agucwuxvlUvwcQVIcg7rzOZFiBxWoSldVQYnSNzN5c6zF85YPTgL0b
         hkhTE2yI0zQFc5LzvQkNMDGs8dW77Y5VhzTHwhELr0FCwWgFwpuYT9Nf1E5BYXZvhe7n
         ztJu/iLbZ8O+zJn9UWxXhQaAbwSiQtO7YJTYynxSw/TpFxYDJ/dHrSEIwgvkNRbn5aDX
         uoMPVDkwGMvnpOJn4KPHlqsdtr1WRGNATjz8O03zHqLHr14d8GwLm2ICbRYTDWGjm+Fv
         iL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714086629; x=1714691429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DUCYtH/HKWn8ExkVR1X+jCKv2DoEuOQK+l1YHfMHQfI=;
        b=GJUHXct0y5n8CHpeallQergSvnY5coXuUsMQlYWuGafHIMcoZoypGWfeMjVZKqY3jk
         khLq3IjS8qqm3IFo4dyEmDHNqNAIkaitZT0nRGJ479T1UKQH1fRl9RLHu8dwZTleiILS
         cHgxcBTZ20/sN5V4GdPlPdew02rQtl8dDcsWfbLMzSTlRJOo/Nh6NIZSwBsGqAtpIavn
         AQkJ1rgQr7dSTzFI72r/DakUO36jUwOeiqWvifRGhs954oyi+YvZoN0F5d6tbymGk65B
         PR8EKlsnqNqZiOepjROVck8BmYoHjJDAkFFpfKfqYLTHD9Y6vaMmgl3f9iZ6IX5YyHhq
         cm0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVjGfc1QlRdiVFzSKWQNaag9AjZPw4NLX21anLGNBKBJXE7RKUuqR1a7uaZlOZmNu2avXv4uJEiWsK19ccWNnS5VD+x
X-Gm-Message-State: AOJu0YypLOJ00xD0eDX/w/eaiyHk/vAE5y94ACxsFJUB/CAabDK+LAy3
	/Cxt2ZYuo8N18ESZfQEZ1H2jm8AyZoRwYn9vZ3lzly0MeldkKa1Wn7cpdzkziKyMZ4CuWh/YlFx
	AYw==
X-Google-Smtp-Source: AGHT+IH0UTRcNBzj9dVGQdexjLGjpnROu9De3Yy6jBzcIynbXQRGZUM1KMZc6bjFlVeH/OJV6ny5L1PLpUc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1708:b0:6ed:95ce:3417 with SMTP id
 h8-20020a056a00170800b006ed95ce3417mr99147pfc.5.1714086628911; Thu, 25 Apr
 2024 16:10:28 -0700 (PDT)
Date: Thu, 25 Apr 2024 16:10:27 -0700
In-Reply-To: <20240415-kvm-selftests-no-sudo-v1-1-95153ad5f470@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240415-kvm-selftests-no-sudo-v1-1-95153ad5f470@google.com>
Message-ID: <Ziri424B_R9GXA9Q@google.com>
Subject: Re: [PATCH] KVM: selftests: Avoid assuming "sudo" exists
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 15, 2024, Brendan Jackman wrote:
> I ran into a failure running this test on a minimal rootfs.
> 
> Can be fixed by just skipping the "sudo" in case we are already root.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> index 7cbb409801eea..0e56822e8e0bf 100755
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> @@ -13,10 +13,21 @@ NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_reco
>  NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
>  HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
>  
> +# If we're already root, the host might not have sudo.
> +if [ $(whoami) == "root" ]; then
> +	function maybe_sudo () {

Any objection to do_sudo instead of maybe_sudo?  I can fixup when applying if
that works for you.

> +		"$@"
> +	}
> +else
> +	function maybe_sudo () {
> +		sudo "$@"
> +	}
> +fi
> +
>  set +e
>  
>  function sudo_echo () {
> -	echo "$1" | sudo tee -a "$2" > /dev/null
> +	echo "$1" | maybe_sudo tee -a "$2" > /dev/null
>  }
>  
>  NXECUTABLE="$(dirname $0)/nx_huge_pages_test"
> 
> ---
> base-commit: 2c71fdf02a95b3dd425b42f28fd47fb2b1d22702
> change-id: 20240415-kvm-selftests-no-sudo-1a55f831f882
> 
> Best regards,
> -- 
> Brendan Jackman <jackmanb@google.com>
> 

