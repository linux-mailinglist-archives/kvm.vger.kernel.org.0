Return-Path: <kvm+bounces-8705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 860FA85527A
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 19:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B62AB2725D
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 18:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA811134CD5;
	Wed, 14 Feb 2024 18:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GPYuxI1z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39A01272CD
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 18:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707936253; cv=none; b=AecOLBfKaub7WpOpQo8JagwiSDtPo2rK5Bzy+TNLYUgVfsbFipjMf73ZwSkYCc5wZbXnjVxLyOXNf3wMbVgNlijSSlC9DI8cR0aTagkXKdgPzLpCllZcfmcy7ULx6k2Y2T6xUStlG+APhtpEK++cAumD1oQPlmJuIIoPTrHjKfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707936253; c=relaxed/simple;
	bh=icjqOUBqDhvNqaJSlrDNjJyaZHw4wcNN655EoUeZaWE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pHzSgSkAuuLObCZmLH7T43VzFnSQ3eBF7V8kizqGb9+W+klcQzSA10727/zBEeipsmnEva1DA1IDdBA11kEk51Alhb1nVmv9o/Eeo2e1nVQmYWHT9nAIJA6kgXY4ip+FzpMo8VC8Sj0jSP1XdS1CwC0OLgDZxCP2UXQkBMPNDvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GPYuxI1z; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3c1a6c10bbso145966b.3
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 10:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1707936249; x=1708541049; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GqaxyVnmqOcpqixyynWKkEU90hzNVr8SECJt4qWMgW4=;
        b=GPYuxI1zMIQ9rrbFushFvsDTJQz7T1C8Ju0bpBZi3JHTN/5A0t57GoFBWH1nRCpgTN
         LUiU8mXvTJVSxl1fLDLO1KDJYge24RxJJvGkA/QQWUBNxRmVn68pG8ayCJO/B4g2ItVm
         x2Ep9gvgBvp43aRsynYMrOpDJ5DaJ9R+Y+hag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707936249; x=1708541049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GqaxyVnmqOcpqixyynWKkEU90hzNVr8SECJt4qWMgW4=;
        b=X59nAOVrcy3yFO4JK17DsGHJd03I9GamaS0utmGUppbJlH5BCOWVnoETRzMevEdZui
         ldC6dv157c6Qmw9ObnVh37JpzC2zCTya8v3RMd28am6WrEOZoYgqC3Y+r4Jm635RJnFD
         KU8JAoyOngDk4wJhAxDhZJRndcCBbAr0kDBMbcsyakpoMO89Si9xob6LQ2R3gXq20miH
         xIbz3jthkbsKd4jpfQ2j5RgU35a+3JnHiSjHplGadXfV/8koBvUkS5d9qNgDsegT/Orf
         lFuVjM+hh+a56jY2j97Kk1z/PYwL/0SnOYnZ5PgoaetinNeYAnVu9TEsUu9bmARG2oD8
         9YnA==
X-Forwarded-Encrypted: i=1; AJvYcCUWtK+sOQ2KutOGHhbNq38ggDqdNW3wtnPEq53nyApMD0WmIgjt+FvzXIw0OlxIszuKSoU0nZvcpNU2HAkWvT2LzSG+
X-Gm-Message-State: AOJu0YzUzZLXtJBsObOR8z7S62PBUYsx+Z2hND2bC3kYouNSgp7HtlXg
	6bvkXO4PAs2Xkd4P8TfEp9rsnNbXrPF0wklkhk4ZNlMpeblihJ+3vqzRAgoGFXO7oRzZxq2xiZm
	YKsI=
X-Google-Smtp-Source: AGHT+IF8mly8VuCKRXsH4XtYfX+hEubsJkfSzcqoS5ez0PTZkYnG6PzrvL7IlWyeeemfGBMEENbB8w==
X-Received: by 2002:a17:906:fa06:b0:a39:99b8:1f7e with SMTP id lo6-20020a170906fa0600b00a3999b81f7emr2984648ejb.4.1707936249103;
        Wed, 14 Feb 2024 10:44:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVY/zK4S4x/hoTEtvVkTN8lQqTSZOHU2MRhtYMrs1hQo1vsXBn50h+wg12q+/NdvGh38ridH5MyfjyPaJiDXYP0EMUG
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id y21-20020a170906559500b00a34d0a865ecsm2513291ejp.163.2024.02.14.10.44.07
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 10:44:07 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-55a90a0a1a1so111596a12.0
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 10:44:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXHqhGgHZCwk6EtM0COH3uYuzdfZDVbjDuXeYLv6bzyrRa9Wwi5jaE+8SgAgftl7Nq8tF/Tcw3FtOf9dI+gAvHCp/k0
X-Received: by 2002:a05:6402:35c1:b0:563:2069:9555 with SMTP id
 z1-20020a05640235c100b0056320699555mr2778693edc.35.1707936247440; Wed, 14 Feb
 2024 10:44:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com> <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
In-Reply-To: <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Feb 2024 10:43:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiRQKkgUSRsLHNkgi3M4M-mwPq+9-RST=neGibMR=ubUw@mail.gmail.com>
Message-ID: <CAHk-=wiRQKkgUSRsLHNkgi3M4M-mwPq+9-RST=neGibMR=ubUw@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Jakub Jelinek <jakub@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000540e2206115be5e4"

--000000000000540e2206115be5e4
Content-Type: text/plain; charset="UTF-8"

On Sun, 11 Feb 2024 at 03:12, Uros Bizjak <ubizjak@gmail.com> wrote:
>
> So, I'd suggest at least limit the workaround to known-bad compilers.

Based on the current state of

    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921

I would suggest this attached kernel patch, which makes the manual
"volatile" the default case (since it should make no difference except
for the known gcc issue), and limits the extra empty asm serialization
to gcc versions older than 12.1.0.

But Jakub is clearly currently trying to figure out exactly what was
going wrong, so things may change. Maybe the commit he bisected to
happened to just accidentally hide the real issue.

                Linus

--000000000000540e2206115be5e4
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_lsm537ms0>
X-Attachment-Id: f_lsm537ms0

IGluY2x1ZGUvbGludXgvY29tcGlsZXItZ2NjLmggICB8IDEyICsrKy0tLS0tLS0tLQogaW5jbHVk
ZS9saW51eC9jb21waWxlcl90eXBlcy5oIHwgMTEgKysrKysrKysrKy0KIDIgZmlsZXMgY2hhbmdl
ZCwgMTMgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9jb21waWxlci1nY2MuaCBiL2luY2x1ZGUvbGludXgvY29tcGlsZXItZ2NjLmgKaW5k
ZXggYzFhOTYzYmU3ZDI4Li5kMTgxZDI3MDNiYmEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgv
Y29tcGlsZXItZ2NjLmgKKysrIGIvaW5jbHVkZS9saW51eC9jb21waWxlci1nY2MuaApAQCAtNjcs
MjEgKzY3LDE1IEBACiAvKgogICogR0NDICdhc20gZ290bycgd2l0aCBvdXRwdXRzIG1pc2NvbXBp
bGVzIGNlcnRhaW4gY29kZSBzZXF1ZW5jZXM6CiAgKgotICogICBodHRwczovL2djYy5nbnUub3Jn
L2J1Z3ppbGxhL3Nob3dfYnVnLmNnaT9pZD0xMTA0MjAKLSAqICAgaHR0cHM6Ly9nY2MuZ251Lm9y
Zy9idWd6aWxsYS9zaG93X2J1Zy5jZ2k/aWQ9MTEwNDIyCisgKiAgIGh0dHBzOi8vZ2NjLmdudS5v
cmcvYnVnemlsbGEvc2hvd19idWcuY2dpP2lkPTExMzkyMQogICoKICAqIFdvcmsgaXQgYXJvdW5k
IHZpYSB0aGUgc2FtZSBjb21waWxlciBiYXJyaWVyIHF1aXJrIHRoYXQgd2UgdXNlZAogICogdG8g
dXNlIGZvciB0aGUgb2xkICdhc20gZ290bycgd29ya2Fyb3VuZC4KLSAqCi0gKiBBbHNvLCBhbHdh
eXMgbWFyayBzdWNoICdhc20gZ290bycgc3RhdGVtZW50cyBhcyB2b2xhdGlsZTogYWxsCi0gKiBh
c20gZ290byBzdGF0ZW1lbnRzIGFyZSBzdXBwb3NlZCB0byBiZSB2b2xhdGlsZSBhcyBwZXIgdGhl
Ci0gKiBkb2N1bWVudGF0aW9uLCBidXQgc29tZSB2ZXJzaW9ucyBvZiBnY2MgZGlkbid0IGFjdHVh
bGx5IGRvCi0gKiB0aGF0IGZvciBhc21zIHdpdGggb3V0cHV0czoKLSAqCi0gKiAgICBodHRwczov
L2djYy5nbnUub3JnL2J1Z3ppbGxhL3Nob3dfYnVnLmNnaT9pZD05ODYxOQogICovCisjaWYgR0ND
X1ZFUlNJT04gPCAxMjAxMDAKICNkZWZpbmUgYXNtX2dvdG9fb3V0cHV0KHguLi4pIFwKIAlkbyB7
IGFzbSB2b2xhdGlsZSBnb3RvKHgpOyBhc20gKCIiKTsgfSB3aGlsZSAoMCkKKyNlbmRpZgogCiAj
aWYgZGVmaW5lZChDT05GSUdfQVJDSF9VU0VfQlVJTFRJTl9CU1dBUCkKICNkZWZpbmUgX19IQVZF
X0JVSUxUSU5fQlNXQVAzMl9fCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyX3R5
cGVzLmggYi9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyX3R5cGVzLmgKaW5kZXggNjYzZDg3OTFjODcx
Li4zYmI1YTlkMTZlYWEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvY29tcGlsZXJfdHlwZXMu
aAorKysgYi9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyX3R5cGVzLmgKQEAgLTM2Miw4ICszNjIsMTcg
QEAgc3RydWN0IGZ0cmFjZV9saWtlbHlfZGF0YSB7CiAjZGVmaW5lIF9fbWVtYmVyX3NpemUocCkJ
X19idWlsdGluX29iamVjdF9zaXplKHAsIDEpCiAjZW5kaWYKIAorLyoKKyAqICJhc20gZ290byIg
aXMgZG9jdW1lbnRlZCB0byBhbHdheXMgYmUgdm9sYXRpbGUsIGJ1dCBzb21lIHZlcnNpb25zCisg
KiBvZiBnY2MgZG9uJ3QgYWN0dWFsbHkgZG8gdGhhdDoKKyAqCisgKiAgIGh0dHBzOi8vZ2NjLmdu
dS5vcmcvYnVnemlsbGEvc2hvd19idWcuY2dpP2lkPTEwMzk3OQorICoKKyAqIFNvIHdlJ2xsIGp1
c3QgZG8gaXQgbWFudWFsbHkgdW5sZXNzIHdlIGhhdmUgb3RoZXIgbW9yZSBleHRlbnNpdmUKKyAq
IHdvcmthcm91bmRzLgorICovCiAjaWZuZGVmIGFzbV9nb3RvX291dHB1dAotI2RlZmluZSBhc21f
Z290b19vdXRwdXQoeC4uLikgYXNtIGdvdG8oeCkKKyNkZWZpbmUgYXNtX2dvdG9fb3V0cHV0KHgu
Li4pIGFzbSB2b2xhdGlsZSBnb3RvKHgpCiAjZW5kaWYKIAogI2lmZGVmIENPTkZJR19DQ19IQVNf
QVNNX0lOTElORQo=
--000000000000540e2206115be5e4--

