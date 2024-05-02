Return-Path: <kvm+bounces-16431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA7778BA0B0
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 20:42:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42DA11F22A39
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 18:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F12E1791EF;
	Thu,  2 May 2024 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l+USzdVq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48200174EDF
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714675355; cv=none; b=AaHcyRJbxLrZdWIKGNWPpzltNtJYw9zNl+bIfL+Nva0Tj6WVn/BnYFWhS20Bor0p9u5AhB1vLeMjNN8ur3zFdGv+bdnSaS9cluiUlptSSP9N9c987USiPd1/xzb8lG24Upyqj+qV3E9MSqq0r8M9fDH/sejpzXc+12PIUKYqvAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714675355; c=relaxed/simple;
	bh=59QNG/Fcdv//9QvB/0RdoOXOz5ROmoADNEG4/Gm8CuQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a0h2xoi5TvzDhd6BVtk/y8uae+1s56B7tRpSlzrfZYz9Y/S009rGqQQXJvYy/e2jo5tL2t7mSlP9t7dmI7bYo9IHsnCFsoc7ZcpHdOZID0wWDUepUkxa3Ead4uID06xC24L+Kub82G0yVJPzHyk8pkY/H30YIQ+maiptkl9nmdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l+USzdVq; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de74a2635e2so5451642276.3
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 11:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714675351; x=1715280151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t31mAKL3MVI73H8d10/Dy6FPLDKutGkgKKAS3ur0XE4=;
        b=l+USzdVqZlqZu89NOkiwFTd3GZJJllpTnKFlfjV44dI5XixFe6Or1Ioql9ZYm9Q8dM
         tiJCp5x+i4UDRQNzeFMt3XFxq79i6YWKLC/4VuSSUo7UvSZ52zGJd2pe883yYzxbhUuN
         M6eOsqdI47S9YLa64aljOFJRZnXDX9rMJBvKGwdFP/X+xzNTqG6V2mbXeHdNxx7zxKKk
         ZnL7QSFh57oSwhhVCN78pV6JxwWRtPvmwNNUbHL7eNqz02JVjv4Nqdt2EprsiZdXCh+G
         qiigLFG1cdeMQK1Qcv8txpbTM31l+NN7zvzxezEdAZyIK1nnOHiVMQ7fig6zs4NYfrRb
         w1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714675351; x=1715280151;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t31mAKL3MVI73H8d10/Dy6FPLDKutGkgKKAS3ur0XE4=;
        b=Fja+zIyqxpO04n9YymI7ykQcW5tL/6WmY2M5ocOVY0mYB2E9trfK09U4852vDztd/8
         XAXx1CVq4y3RqoAkq7PRDSl3NJAH+v9Vf6utT2QO+DNg9Z19yesqDQ0WK2Swr1gB9Zfw
         YyVruiSgLfRG1yNmBmMPLGYSnq6G1LGCM9mNh18Rw/TCxBjwbWtudLrKwYyQ88g43mFF
         nakLj0PHKBYcvJHtnH541v//eAE+0J8rGjdNvRYrlVe523PoxaukqQKEPJLLByv58LnD
         ixFz+8hF/XClnFUnvgTGSR+/6wXZAuyI97vPYYi+2sGgPGiQPA3MrcJMzRWe75d2lXFM
         mJjA==
X-Forwarded-Encrypted: i=1; AJvYcCWJfDky3AHGTtTSx/HePpARHnbRNuvsoamINSgPbZENJbPX7vZZLL1Jk0D2mIA5C2WumIeMwL8EfBST6TUfu1b0eD49
X-Gm-Message-State: AOJu0YzTow4tEtpjrS9c0rmacwaASbR5v1ojatqJSwHKMrw6M9ZYEfLx
	kclryMDy00aHTSQiZBQN+rqpOZ2JTzwcHNAdQRBiziq6zodZyftnngBjWnrPEMMzDae0eLLa+zz
	ilQ==
X-Google-Smtp-Source: AGHT+IFBB1Beu8kFSHdljseQZRBecifx8xInIHMu6JSSudvsQzMMMF/EjATwyWk141WOZGSUx1DvI7X1g7A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b07:b0:de4:64c4:d90c with SMTP id
 fi7-20020a0569022b0700b00de464c4d90cmr93847ybb.12.1714675351296; Thu, 02 May
 2024 11:42:31 -0700 (PDT)
Date: Thu, 2 May 2024 11:42:29 -0700
In-Reply-To: <20240305.phohPh8saa4i@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240229005920.2407409-1-kuba@kernel.org> <05f7bf89-04a5-4b65-bf59-c19456aeb1f0@sirena.org.uk>
 <20240304150411.6a9bd50b@kernel.org> <202403041512.402C08D@keescook>
 <20240304153902.30cd2edd@kernel.org> <202403050141.C8B1317C9@keescook> <20240305.phohPh8saa4i@digikod.net>
Message-ID: <ZjPelW6-AbtYvslu@google.com>
Subject: Re: [PATCH v4 00/12] selftests: kselftest_harness: support using xfail
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>
Cc: Kees Cook <keescook@chromium.org>, Jakub Kicinski <kuba@kernel.org>, 
	Mark Brown <broonie@kernel.org>, davem@davemloft.net, netdev@vger.kernel.org, 
	edumazet@google.com, pabeni@redhat.com, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, 
	jakub@cloudflare.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+kvm

On Tue, Mar 05, 2024, Micka=C3=ABl Sala=C3=BCn wrote:
> On Tue, Mar 05, 2024 at 01:43:14AM -0800, Kees Cook wrote:
> > On Mon, Mar 04, 2024 at 03:39:02PM -0800, Jakub Kicinski wrote:
> > > On Mon, 4 Mar 2024 15:14:04 -0800 Kees Cook wrote:
> > > > > Ugh, I'm guessing vfork() "eats" the signal, IOW grandchild signa=
ls,
> > > > > child exits? vfork() and signals.. I'd rather leave to Kees || Mi=
ckael. =20
> > > >=20
> > > > Oh no, that does seem bad. Since Micka=C3=ABl is also seeing weird =
issues,
> > > > can we drop the vfork changes for now?
> > >=20
> > > Seems doable, but won't be a simple revert. "drop" means we'd need=20
> > > to bring ->step back. More or less go back to v3.
> >=20
> > I think we have to -- other CIs are now showing the most of seccomp
> > failing now. (And I can confirm this now -- I had only tested seccomp
> > on earlier versions of the series.)
>=20
> Sorry for the trouble, I found and fixed the vfork issues.

Heh, you found and fixed _some of_ the vfork issues.  This whole mess compl=
etely
breaks existing tests that use TEST_F() and exit() with non-zero values to
indicate failure, including failures that occur during FIXTURE_SETUP().

E.g. all of the KVM selftests that use KVM_ONE_VCPU_TEST() are broken and w=
ill
always show all tests as passing.

The below gets things working for KVM selftests again, but (a) I have no id=
ea if
it's a complete fix, (b) I don't know if it will break other users of the h=
arness,
and (c) I don't understand why spawning a grandchild is the default behavio=
r, i.e.
why usage that has zero need of separating teardown from setup+run is subje=
cted to
the complexity of the handful of tests that do.

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/se=
lftests/kselftest_harness.h
index 4fd735e48ee7..24e95828976f 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -391,7 +391,7 @@
                                fixture_name##_setup(_metadata, &self, vari=
ant->data); \
                                /* Let setup failure terminate early. */ \
                                if (_metadata->exit_code) \
-                                       _exit(0); \
+                                       _exit(_metadata->exit_code); \
                                _metadata->setup_completed =3D true; \
                                fixture_name##_##test_name(_metadata, &self=
, variant->data); \
                        } else if (child < 0 || child !=3D waitpid(child, &=
status, 0)) { \
@@ -406,8 +406,10 @@
                } \
                if (_metadata->setup_completed && _metadata->teardown_paren=
t) \
                        fixture_name##_teardown(_metadata, &self, variant->=
data); \
-               if (!WIFEXITED(status) && WIFSIGNALED(status)) \
-                       /* Forward signal to __wait_for_test(). */ \
+               /* Forward exit codes and signals to __wait_for_test(). */ =
\
+               if (WIFEXITED(status)) \
+                       _exit(WEXITSTATUS(status)); \
+               else if (WIFSIGNALED(status)) \
                        kill(getpid(), WTERMSIG(status)); \
                __test_check_assert(_metadata); \
        } \

