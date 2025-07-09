Return-Path: <kvm+bounces-51996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4258AFF429
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 23:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4E277BD182
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 21:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AABE123F40A;
	Wed,  9 Jul 2025 21:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NOqfkyfD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8F6221DB4
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 21:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098128; cv=none; b=qvdUGUD92VgUoprIWJT0DmSdfx8dAdm41t9Ny+34QMP2fcKocjKhhb3jJEKEid+2gFFxL/60s8jcP3WZRTHCfrlKKsoZ6yV132BAtAn0ZUFAoPm3lPW6+G3cuVyvmHZmGoo8P4E9VbFoFoyiuSoqC2/7DqHcrfe2WjEUi5+VeM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098128; c=relaxed/simple;
	bh=+qjsBJLhpM1olxeer6ILy3R9POMXDh/s6Ahq8YqfhG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TkrLHQ3iGRI5+bAOvlGuS0ueXTwlqmgig1V1UeQ+9FdDDxRpyVPspoKFubdYt71evEL2eKaT+fTej28tRCLLlA4apJVZQ+Yq7kQZijrQ7+irPlIlvePXcKXszHWPXjMZjA6QsrxOHv7AA/Bi6MKOExXNwxBr73CX3TfXXUz+8lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NOqfkyfD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23536f7c2d7so4197095ad.2
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 14:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752098127; x=1752702927; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xbl942qlboFFMIegFraxpdF+FM9j3v0rANtDQn4ybbE=;
        b=NOqfkyfDZAHijQeF6etxbeYWgoj+tBCD3t/KDxyrYWfYZy9g+BHhY/E9SCxMuUJ95E
         W6dwfEU1h+ws/qDUJvQ946sZqdUJIMqqV2jR21QU774BFYp0CFEKyPxeizQ6hXp+HPgV
         ZD8kVpVBovtn+o1BwUqYF+GmCvBJNTCI53aFWVCGlJEFIBJioLXJm/cXimSeSsRhrfCU
         VPjc9AS2ZagsLkCi8GAn1OakjCbE9c8mXEORurDL+ejRICUO+eRMG1jT1wO895/cb1Z/
         cy5YPGbDmUKjh03jMUbXlw12A82UkEQpYhNkhLK5VvwGS091P9JtOAxzxGkL9Z1QhBv2
         weeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752098127; x=1752702927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xbl942qlboFFMIegFraxpdF+FM9j3v0rANtDQn4ybbE=;
        b=O6VN1Llc+sgNRd6IA68NAoUekOkCMNxWpmlS/scFAg2vpZOK8C60jL5/foB/dImwP4
         6E/wwPrpRhq3JX2dprSUA9yqJG63/XVtcwf08azCIAHBOtos5s6couYq4rXOBTtg2WJT
         8nOVkyIpZeM6JnNW60OK05TGOamn3Fkpvmgsm6iQZqp7dSEg9ttFDcEzD05iftyEf6MM
         wpTRhucPUiG0DBrae2Keh4BHOQneSPvpj8vAAlWF6hj1m+UbvT/2fpUscH0PwiXYq31t
         dobBN6UCKTKsym7H2N3mMFgdt0dvBBrnIsrjMjOPvSFPikBSb3czPkB1iVNm2RrC16ze
         72PQ==
X-Gm-Message-State: AOJu0YydRIqkgja4qVNpx+lAKZPs4ANNLkMIiJHXEtslhZ+kpxHNoFtZ
	CCmnkAjxgGpKSTQT6N6jDP9UQL7l98XVLAv+lq6iHWy28bJX3LzBPiA4nC3aF5ZT3AApmYzIv/d
	ROWOLPA==
X-Google-Smtp-Source: AGHT+IF1wEjrFTfY6N7MTYPdwThi568/YkhVSNLJZftbK5IeWVpMVD+nKlM0Ig+cQGCrWJrZozYL3NOkd1E=
X-Received: from pjyd8.prod.google.com ([2002:a17:90a:dfc8:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b0f:b0:235:ea0d:ae10
 with SMTP id d9443c01a7336-23de47f8b60mr1057985ad.12.1752098126914; Wed, 09
 Jul 2025 14:55:26 -0700 (PDT)
Date: Wed, 9 Jul 2025 14:55:25 -0700
In-Reply-To: <20250606235619.1841595-7-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-7-vipinsh@google.com>
Message-ID: <aG7lTY2ItIkfX7dm@google.com>
Subject: Re: [PATCH v2 06/15] KVM: selftests: Add a flag to print only test
 status in KVM Selftests run
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> Add a command line argument, --print-status, to limit content printed on
> terminal by default. When this flag is passed only print final status of
> tests i.e. passed, failed, timed out, etc.
> 
> Example:
>   python3 runner --test-dirs tests  --print-status
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/runner/__main__.py    | 5 +++++
>  tools/testing/selftests/kvm/runner/test_runner.py | 3 ++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> index 48d7ce00a097..3f11a20e76a9 100644
> --- a/tools/testing/selftests/kvm/runner/__main__.py
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> @@ -59,6 +59,11 @@ def cli():
>                          type=int,
>                          help="Maximum number of tests that can be run concurrently. (Default: 1)")
>  
> +    parser.add_argument("--print-status",
> +                        action="store_true",
> +                        default=False,
> +                        help="Print only test's status and avoid printing stdout and stderr of the tests")
> +
>      return parser.parse_args()
>  
>  
> diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
> index 0a6e5e0ca0f5..474408fcab51 100644
> --- a/tools/testing/selftests/kvm/runner/test_runner.py
> +++ b/tools/testing/selftests/kvm/runner/test_runner.py
> @@ -17,6 +17,7 @@ class TestRunner:
>          self.tests = []
>          self.output_dir = args.output
>          self.jobs = args.jobs
> +        self.print_status = args.print_status
>  
>          for test_file in test_files:
>              self.tests.append(Selftest(test_file, args.executable,
> @@ -29,7 +30,7 @@ class TestRunner:
>      def _log_result(self, test_result):
>          logger.log(test_result.status,
>                     f"[{test_result.status}] {test_result.test_path}")
> -        if (self.output_dir is None):
> +        if (self.output_dir is None and self.print_status is False):

This flag confused the hell out of me.  It's not at all obvious that it *reduces*
output, and that it overrides all the other --print-xxx options.  I see no reason
to provide this.  I suspect most users will want curated console information, or
none at all.

If we keep this, the runner should explicitly disallow --print-status with any
other --print-xxx option.

>              logger.info("************** STDOUT BEGIN **************")
>              logger.info(test_result.stdout)
>              logger.info("************** STDOUT END **************")
> -- 
> 2.50.0.rc0.604.gd4ff7b7c86-goog
> 

