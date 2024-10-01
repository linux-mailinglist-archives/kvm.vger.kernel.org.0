Return-Path: <kvm+bounces-27779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38EA198C165
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 17:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5BAE1F22E30
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 15:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA631C9DF0;
	Tue,  1 Oct 2024 15:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i15K34it"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7892A8CD
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727795838; cv=none; b=BVpQ88/kXxnmktXnsozxynfxEVEeu6n/m9MZzhesKb7xId623Zj7KoL/2oqgtgS8UE1qc2kb/GYSqzW0/ZwBikVHS5y3Na3Q9DtVX6TwsJGkUPd+CfPCC7SgyltjDxcOYDvRf6zobuFQWYWCERPkaFdCVi5w8jCLpz5K3Tn1Ays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727795838; c=relaxed/simple;
	bh=EgaHePArQR7nWkAan1+KnfXGKtMNGcoZX20Y9veixIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l0WGRDYrwVWPpZloaChmGt4PTvmiqi9gXUdZRanaC8qtuKUHqCDyXMYQlFN8todBnhhMWLh704bzFDDHuAHkC7KWwh2h8rfus17Lz9owHPpBtoy7q2LGFf7OP/2/WrqgKQvzb4sL7Q7Os0dy6zbCQcQPgazW6szpFVw4ONNpElE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i15K34it; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727795836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqAP4dtv2u7sS+Z81oPV4fE+lGbUyKHeK4mPtJ9hr/E=;
	b=i15K34itHLyheXf6wNexYf0C16+ptxW6MroQFu4YYRzkse6uDY8UdlE8b6uBHrYHyZNC1F
	P/347QyWNtVBi/khP5rA1W5ZdvzsHO5vV7V4MM1DFhvyzmXG9Ord7y/ae/8PKeawEhKAen
	lOintK7MxzWPVghDMhVAoxw5VB2K6hw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-31uweGptN-SMWGoRC6tgDA-1; Tue, 01 Oct 2024 11:17:15 -0400
X-MC-Unique: 31uweGptN-SMWGoRC6tgDA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42ca8037d9aso37408855e9.3
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2024 08:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727795833; x=1728400633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VqAP4dtv2u7sS+Z81oPV4fE+lGbUyKHeK4mPtJ9hr/E=;
        b=VRxLGifmyneDW4lkzLKyJqlxVBqfV/3KM06ogDsT3aG8lrpR/dgd74j4iUxbk9uUEI
         +iDLvxHxOMzU8DAyJDRV+1GIyPKw/5o6CEctAvoJi2kpgTmE4cYCUKNvGQZNHBiBCLUN
         SIzXHO69RTqvAlDfw4+pFb3CNpGd2a2T7M6G9iNvkD56Xc8oY8R0zOIkVTtb2eZA2bL9
         +dQWZZMR1NB6xBZF6vrL5HioOO8RCD6FA2y5CCA1YViqFYMhpOdQUz88rFGVxOAan9BY
         +6oL3H2gFTf3g/vg6ldNjch/UxhM/KkzSI3Owa3oMZUqB14/hGkaRqWurR3rdZ8ZQJtX
         64wg==
X-Forwarded-Encrypted: i=1; AJvYcCUZPHA9+A+8aqvuOFqgDscBpskibjk8xotLaMBLYutDN6Lj3vH5wAD2A0xTrbRNpxa6sv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLRt0GMuwgNqccjqjw8Y17t8y6lsbNKnfmXkpo6BSqL4gKYJt0
	7EWFooMZodYg2axKxVGjgCva/g4YiJnJxj/LxZcrywzOLDN1daVUGLRJL6MuWERzQe2cu6qmmbv
	5WPmZUi8xwfUjjvQJsXdQgAwM8JuQrAF+Gy30SnUUo6qfCBzYYMt6cSmsoMy/l+vTqyzoJ7HIh7
	g5+jMXFiCq9Bmdksf0XhSgDVs2B/bj8dkgcr4=
X-Received: by 2002:a05:600c:2154:b0:42c:dce1:8915 with SMTP id 5b1f17b1804b1-42f5b9310b1mr110366375e9.33.1727795832947;
        Tue, 01 Oct 2024 08:17:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdYi/KYMxTdYvq3EwnDXusLPrnPH+Z3WqQf0HLO3BTobGAMefwExTx6xCH53Aan9BVB1uZBnMH5NIK5dLGhMo=
X-Received: by 2002:a05:600c:2154:b0:42c:dce1:8915 with SMTP id
 5b1f17b1804b1-42f5b9310b1mr110366165e9.33.1727795832574; Tue, 01 Oct 2024
 08:17:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240930-kvm-build-breakage-v1-1-866fad3cc164@kernel.org>
In-Reply-To: <20240930-kvm-build-breakage-v1-1-866fad3cc164@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 1 Oct 2024 17:16:58 +0200
Message-ID: <CABgObfabFVV4yuku0w7U0MMYk3Nbh22j47GcKt=2w7=H_zWj7A@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix build on architectures other than x86_64
To: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Aishwarya TCV <aishwarya.tcv@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 8:10=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> The recent addition of support for testing with the x86 specific quirk
> KVM_X86_QUIRK_SLOT_ZAP_ALL disabled in the generic memslot tests broke th=
e
> build of the KVM selftests for all other architectures:
>
> In file included from include/kvm_util.h:8,
>                  from include/memstress.h:13,
>                  from memslot_modification_stress_test.c:21:
> memslot_modification_stress_test.c: In function =E2=80=98main=E2=80=99:
> memslot_modification_stress_test.c:176:38: error: =E2=80=98KVM_X86_QUIRK_=
SLOT_ZAP_ALL=E2=80=99 undeclared (first use in this function)
>   176 |                                      KVM_X86_QUIRK_SLOT_ZAP_ALL);
>       |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Add __x86_64__ guard defines to avoid building the relevant code on other
> architectures.
>
> Fixes: 61de4c34b51c ("KVM: selftests: Test memslot move in memslot_perf_t=
est with quirk disabled")
> Fixes: 218f6415004a ("KVM: selftests: Allow slot modification stress test=
 with quirk disabled")
> Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Queued, thanks.  Sorry for the disruption.

Paolo

> ---
> This is obviously disruptive for testing of KVM changes on non-x86
> architectures.
> ---
>  tools/testing/selftests/kvm/memslot_modification_stress_test.c | 2 ++
>  tools/testing/selftests/kvm/memslot_perf_test.c                | 6 +++++=
+
>  2 files changed, 8 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test=
.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index e3343f0df9e1..c81a84990eab 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -169,12 +169,14 @@ int main(int argc, char *argv[])
>                 case 'i':
>                         p.nr_iterations =3D atoi_positive("Number of iter=
ations", optarg);
>                         break;
> +#ifdef __x86_64__
>                 case 'q':
>                         p.disable_slot_zap_quirk =3D true;
>
>                         TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS=
2) &
>                                      KVM_X86_QUIRK_SLOT_ZAP_ALL);
>                         break;
> +#endif
>                 case 'h':
>                 default:
>                         help(argv[0]);
> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/test=
ing/selftests/kvm/memslot_perf_test.c
> index 893366982f77..989ffe0d047f 100644
> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
> @@ -113,7 +113,9 @@ static_assert(ATOMIC_BOOL_LOCK_FREE =3D=3D 2, "atomic=
 bool is not lockless");
>  static sem_t vcpu_ready;
>
>  static bool map_unmap_verify;
> +#ifdef __x86_64__
>  static bool disable_slot_zap_quirk;
> +#endif
>
>  static bool verbose;
>  #define pr_info_v(...)                         \
> @@ -579,8 +581,10 @@ static bool test_memslot_move_prepare(struct vm_data=
 *data,
>         uint32_t guest_page_size =3D data->vm->page_size;
>         uint64_t movesrcgpa, movetestgpa;
>
> +#ifdef __x86_64__
>         if (disable_slot_zap_quirk)
>                 vm_enable_cap(data->vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_=
QUIRK_SLOT_ZAP_ALL);
> +#endif
>
>         movesrcgpa =3D vm_slot2gpa(data, data->nslots - 1);
>
> @@ -971,11 +975,13 @@ static bool parse_args(int argc, char *argv[],
>                 case 'd':
>                         map_unmap_verify =3D true;
>                         break;
> +#ifdef __x86_64__
>                 case 'q':
>                         disable_slot_zap_quirk =3D true;
>                         TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS=
2) &
>                                      KVM_X86_QUIRK_SLOT_ZAP_ALL);
>                         break;
> +#endif
>                 case 's':
>                         targs->nslots =3D atoi_paranoid(optarg);
>                         if (targs->nslots <=3D 1 && targs->nslots !=3D -1=
) {
>
> ---
> base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
> change-id: 20240930-kvm-build-breakage-a542f46d78f9
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>


