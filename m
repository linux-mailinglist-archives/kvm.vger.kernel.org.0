Return-Path: <kvm+bounces-20441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B45C915C17
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 04:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D5632851AF
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 02:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088B13A1B6;
	Tue, 25 Jun 2024 02:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lgDwhfuw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9600231A60;
	Tue, 25 Jun 2024 02:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719281694; cv=none; b=MnK7YLoaMtBWZS9cQK6LwekRhhSwCcc8VB2vArKnk5z1Lo1GNzEUT3eJmPwfe8msCA0RLGbIOtmkzu6REpkcgu08hjfboo6hXBU81FQjBAGNxkvNNMSt+EKUWkW0iGFcoovdPfvAwZyWIRq/fwsEBu6UMeuwoXEHT3igsGgNDYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719281694; c=relaxed/simple;
	bh=PIop5eKkLyu/UrgIc/DezeoVRpFYqOwUwcgJrkxD6Ls=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=CTAnNyews6i39EM5leL8g2ymFFl9YhAHskVg6BWJY6w8ItEWiNFQG0+un975bK1W8BJmBNWDdxd7Bx2Mbi8RtKbpYd24ReIF+aqUXlLwR14HjAaoew2QRy6QuV+0BpnHcCeug3R2T5opjz1u46Kyxtjr8T4oDlPM+5cOasnWeKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lgDwhfuw; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f4a5344ec7so33744865ad.1;
        Mon, 24 Jun 2024 19:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719281692; x=1719886492; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSbmiWpq0/zxbjXOks/N0b2OiceozmvsnH8Ej5D1bAU=;
        b=lgDwhfuwVYC8QcHlHdSYxH0NIyfPPfWc6vxpKxBria6+/8cpXDKhGloqCBiGbVUbgB
         fTbcmjntUC3wuZqs/lfvXSz6Y9xwa973qPYcsBLfdn15cyCkhk6ZZ8laZBd0eLhdoJok
         Gjxi3LLOwFDHDZdTn1AnOqU/HQ01TMyUW0p5dny1Rwj1uakixau16Aoy2DKbSMqtT/ai
         aMj09jX6p1u3TkEe2WQhy/oGBik07KveStx8MfmEUWc7r73Bgll9H4R8QjSsmMTAhKae
         NM6IrwSGl4KQLefKE0/g/AgZ9h/p8jWyuE0OGfZn/gADgpxb/YDkN6/roP13fHA9a87A
         9pKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719281692; x=1719886492;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qSbmiWpq0/zxbjXOks/N0b2OiceozmvsnH8Ej5D1bAU=;
        b=Xxfp/49yo6wN7z3sBGTWVQPq9PwfVpX6gXcKmdN7w9KHOJKw1tXbhHGuteDFiNEpuW
         8BPeTrlNpCFLp8FqushPCpa2Il/N6z7V9t1bUkZfxf7y4sBlW8JngjJeste1uFIooTB8
         ZUnxfSuj7ozpCHioovPz+ZrN5ueW4W3JlbtaTzOqo5ZMU0kDdgI/oHR3TrWxYiZQ8hDm
         rH51y9j23F4MmZJds58UhtR3mLPycI4akzACfN+SCLITShOTffBh9drUPDOMdyIngtV8
         9nNKlY8xWLKFJJeu3eyiFNdmEi0NjOYxeF2QvyaUpC85af1iC7CbjwSxnU4D2wLot4W2
         DPyg==
X-Forwarded-Encrypted: i=1; AJvYcCV/nIZjrJ+N4Rk18x+K3LeogFVP8S0ozWdVoHwE3vH5ZFj15P5KJw1F6h0RV/M5g7/qVyhv59JesDEj8q2pm9Myiduik1hbDX0QLkwp3JVM1LCPQ1gqVNOzAkso/QP7lw==
X-Gm-Message-State: AOJu0YzR9FDdCzzvwvUKg6A0tpgffOgVPpHqqbcj4HhuCY4Bl+6gsJ4U
	OdTGgwrtAjJUVNStD2AJbEwX4mb/lP7Fz3jM8mzrYRjKSqJYFilf
X-Google-Smtp-Source: AGHT+IHqXx8tnkWsb81qRfAc6qRWnCTn3CI3WtlYeSApMgpbiOs3H6ui1IMA0BCZ5PekJoiz4Aw2hQ==
X-Received: by 2002:a17:902:e5ca:b0:1f6:87f:1156 with SMTP id d9443c01a7336-1fa5e4f60d2mr41093975ad.0.1719281691713;
        Mon, 24 Jun 2024 19:14:51 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb32170asm69683385ad.86.2024.06.24.19.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 19:14:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Jun 2024 12:14:45 +1000
Message-Id: <D28QHQGLKAKJ.NZ0V3NUSSFP8@gmail.com>
Cc: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "David Hildenbrand" <david@redhat.com>,
 <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 4/7] s390x: Add function for checking
 diagnose intercepts
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "Janosch Frank" <frankja@linux.ibm.com>
X-Mailer: aerc 0.17.0
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-5-nsg@linux.ibm.com>
In-Reply-To: <20240620141700.4124157-5-nsg@linux.ibm.com>

On Fri Jun 21, 2024 at 12:16 AM AEST, Nina Schoetterl-Glausch wrote:
> sie_is_diag_icpt() checks if the intercept is due to an expected
> diagnose call and is valid.
> It subsumes pv_icptdata_check_diag.
>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  lib/s390x/pv_icptdata.h | 42 --------------------------------
>  lib/s390x/sie.h         | 12 ++++++++++
>  lib/s390x/sie.c         | 53 +++++++++++++++++++++++++++++++++++++++++
>  s390x/pv-diags.c        |  8 +++----
>  s390x/pv-icptcode.c     | 11 ++++-----
>  s390x/pv-ipl.c          |  7 +++---
>  6 files changed, 76 insertions(+), 57 deletions(-)
>  delete mode 100644 lib/s390x/pv_icptdata.h
>
> diff --git a/lib/s390x/pv_icptdata.h b/lib/s390x/pv_icptdata.h
> deleted file mode 100644
> index 4746117e..00000000
> --- a/lib/s390x/pv_icptdata.h
> +++ /dev/null
> @@ -1,42 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * Commonly used checks for PV SIE intercept data
> - *
> - * Copyright IBM Corp. 2023
> - * Author: Janosch Frank <frankja@linux.ibm.com>
> - */
> -
> -#ifndef _S390X_PV_ICPTDATA_H_
> -#define _S390X_PV_ICPTDATA_H_
> -
> -#include <sie.h>
> -
> -/*
> - * Checks the diagnose instruction intercept data for consistency with
> - * the constants defined by the PV SIE architecture
> - *
> - * Supports: 0x44, 0x9c, 0x288, 0x308, 0x500
> - */
> -static bool pv_icptdata_check_diag(struct vm *vm, int diag)
> -{
> -	int icptcode;
> -
> -	switch (diag) {
> -	case 0x44:
> -	case 0x9c:
> -	case 0x288:
> -	case 0x308:
> -		icptcode =3D ICPT_PV_NOTIFY;
> -		break;
> -	case 0x500:
> -		icptcode =3D ICPT_PV_INSTR;
> -		break;
> -	default:
> -		/* If a new diag is introduced add it to the cases above! */
> -		assert(0);
> -	}
> -
> -	return vm->sblk->icptcode =3D=3D icptcode && vm->sblk->ipa =3D=3D 0x830=
2 &&
> -	       vm->sblk->ipb =3D=3D 0x50000000 && vm->save_area.guest.grs[5] =
=3D=3D diag;
> -}
> -#endif
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 53cd767f..6d1a0d6e 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -287,6 +287,18 @@ static inline bool sie_is_pv(struct vm *vm)
>  	return vm->sblk->sdf =3D=3D 2;
>  }
> =20
> +/**
> + * sie_is_diag_icpt() - Check if intercept is due to diagnose instructio=
n
> + * @vm: the guest
> + * @diag: the expected diagnose code
> + *
> + * Check that the intercept is due to diagnose @diag and valid.
> + * For protected virtualisation, check that the intercept data meets add=
itional
> + * constraints.
> + *
> + * Returns: true if intercept is due to a valid and has matching diagnos=
e code
> + */
> +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag);
>  void sie_guest_sca_create(struct vm *vm);
>  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_=
mem_len);
>  void sie_guest_destroy(struct vm *vm);
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 0fa915cf..d4ba2a40 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -42,6 +42,59 @@ void sie_check_validity(struct vm *vm, uint16_t vir_ex=
p)
>  	report(vir_exp =3D=3D vir, "VALIDITY: %x", vir);
>  }
> =20
> +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
> +{
> +	union {
> +		struct {
> +			uint64_t     : 16;
> +			uint64_t ipa : 16;
> +			uint64_t ipb : 32;
> +		};
> +		struct {
> +			uint64_t          : 16;
> +			uint64_t opcode   :  8;
> +			uint64_t r_1      :  4;
> +			uint64_t r_2      :  4;
> +			uint64_t r_base   :  4;
> +			uint64_t displace : 12;
> +			uint64_t zero     : 16;
> +		};
> +	} instr =3D { .ipa =3D vm->sblk->ipa, .ipb =3D vm->sblk->ipb };
> +	uint8_t icptcode;
> +	uint64_t code;
> +
> +	switch (diag) {
> +	case 0x44:
> +	case 0x9c:
> +	case 0x288:
> +	case 0x308:
> +		icptcode =3D ICPT_PV_NOTIFY;
> +		break;
> +	case 0x500:
> +		icptcode =3D ICPT_PV_INSTR;
> +		break;
> +	default:
> +		/* If a new diag is introduced add it to the cases above! */
> +		assert_msg(false, "unknown diag");
> +	}
> +
> +	if (sie_is_pv(vm)) {
> +		if (instr.r_1 !=3D 0 || instr.r_2 !=3D 2 || instr.r_base !=3D 5)
> +			return false;
> +		if (instr.displace)
> +			return false;
> +	} else {
> +		icptcode =3D ICPT_INST;
> +	}
> +	if (vm->sblk->icptcode !=3D icptcode)
> +		return false;
> +	if (instr.opcode !=3D 0x83 || instr.zero)
> +		return false;
> +	code =3D instr.r_base ? vm->save_area.guest.grs[instr.r_base] : 0;
> +	code =3D (code + instr.displace) & 0xffff;
> +	return code =3D=3D diag;
> +}

It looks like this transformation is equivalent for the PV case. You
could put the switch into the sie_is_pv() branch? Otherwise looks okay.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> +
>  void sie_handle_validity(struct vm *vm)
>  {
>  	if (vm->sblk->icptcode !=3D ICPT_VALIDITY)
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index 3193ad99..6ebe469a 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -9,7 +9,6 @@
>   */
>  #include <libcflat.h>
>  #include <snippet.h>
> -#include <pv_icptdata.h>
>  #include <sie.h>
>  #include <sclp.h>
>  #include <asm/facility.h>
> @@ -32,8 +31,7 @@ static void test_diag_500(void)
>  			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> =20
>  	sie(&vm);
> -	report(pv_icptdata_check_diag(&vm, 0x500),
> -	       "intercept values");
> +	report(sie_is_diag_icpt(&vm, 0x500), "intercept values");
>  	report(vm.save_area.guest.grs[1] =3D=3D 1 &&
>  	       vm.save_area.guest.grs[2] =3D=3D 2 &&
>  	       vm.save_area.guest.grs[3] =3D=3D 3 &&
> @@ -45,7 +43,7 @@ static void test_diag_500(void)
>  	 */
>  	vm.sblk->iictl =3D IICTL_CODE_OPERAND;
>  	sie(&vm);
> -	report(pv_icptdata_check_diag(&vm, 0x9c) &&
> +	report(sie_is_diag_icpt(&vm, 0x9c) &&
>  	       vm.save_area.guest.grs[0] =3D=3D PGM_INT_CODE_OPERAND,
>  	       "operand exception");
> =20
> @@ -57,7 +55,7 @@ static void test_diag_500(void)
>  	vm.sblk->iictl =3D IICTL_CODE_SPECIFICATION;
>  	/* Inject PGM, next exit should be 9c */
>  	sie(&vm);
> -	report(pv_icptdata_check_diag(&vm, 0x9c) &&
> +	report(sie_is_diag_icpt(&vm, 0x9c) &&
>  	       vm.save_area.guest.grs[0] =3D=3D PGM_INT_CODE_SPECIFICATION,
>  	       "specification exception");
> =20
> diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
> index d7c47d6f..bc90df1e 100644
> --- a/s390x/pv-icptcode.c
> +++ b/s390x/pv-icptcode.c
> @@ -13,7 +13,6 @@
>  #include <smp.h>
>  #include <sclp.h>
>  #include <snippet.h>
> -#include <pv_icptdata.h>
>  #include <asm/facility.h>
>  #include <asm/barrier.h>
>  #include <asm/sigp.h>
> @@ -47,7 +46,7 @@ static void test_validity_timing(void)
>  			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> =20
>  	sie(&vm);
> -	report(pv_icptdata_check_diag(&vm, 0x44), "spt done");
> +	report(sie_is_diag_icpt(&vm, 0x44), "spt done");
>  	stck(&time_exit);
>  	tmp =3D vm.sblk->cputm;
>  	mb();
> @@ -258,7 +257,7 @@ static void test_validity_asce(void)
> =20
>  	/* Try if we can still do an entry with the correct asce */
>  	sie(&vm);
> -	report(pv_icptdata_check_diag(&vm, 0x44), "re-entry with valid CR1");
> +	report(sie_is_diag_icpt(&vm, 0x44), "re-entry with valid CR1");
>  	uv_destroy_guest(&vm);
>  	free_pages(pgd_new);
>  	report_prefix_pop();
> @@ -294,7 +293,7 @@ static void run_icpt_122_tests_prefix(unsigned long p=
refix)
> =20
>  	sie(&vm);
>  	/* Guest indicates that it has been setup via the diag 0x44 */
> -	assert(pv_icptdata_check_diag(&vm, 0x44));
> +	assert(sie_is_diag_icpt(&vm, 0x44));
>  	/* If the pages have not been shared these writes will cause exceptions=
 */
>  	ptr =3D (uint32_t *)prefix;
>  	WRITE_ONCE(ptr, 0);
> @@ -328,7 +327,7 @@ static void test_icpt_112(void)
> =20
>  	/* Setup of the guest's state for 0x0 prefix */
>  	sie(&vm);
> -	assert(pv_icptdata_check_diag(&vm, 0x44));
> +	assert(sie_is_diag_icpt(&vm, 0x44));
> =20
>  	/* Test on standard 0x0 prefix */
>  	run_icpt_122_tests_prefix(0);
> @@ -348,7 +347,7 @@ static void test_icpt_112(void)
> =20
>  	/* Try a re-entry after everything has been imported again */
>  	sie(&vm);
> -	report(pv_icptdata_check_diag(&vm, 0x9c) &&
> +	report(sie_is_diag_icpt(&vm, 0x9c) &&
>  	       vm.save_area.guest.grs[0] =3D=3D 42,
>  	       "re-entry successful");
>  	report_prefix_pop();
> diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
> index cc46e7f7..cd49bd95 100644
> --- a/s390x/pv-ipl.c
> +++ b/s390x/pv-ipl.c
> @@ -11,7 +11,6 @@
>  #include <sie.h>
>  #include <sclp.h>
>  #include <snippet.h>
> -#include <pv_icptdata.h>
>  #include <asm/facility.h>
>  #include <asm/uv.h>
> =20
> @@ -35,7 +34,7 @@ static void test_diag_308(int subcode)
> =20
>  	/* First exit is a diag 0x500 */
>  	sie(&vm);
> -	assert(pv_icptdata_check_diag(&vm, 0x500));
> +	assert(sie_is_diag_icpt(&vm, 0x500));
> =20
>  	/*
>  	 * The snippet asked us for the subcode and we answer by
> @@ -46,7 +45,7 @@ static void test_diag_308(int subcode)
> =20
>  	/* Continue after diag 0x500, next icpt should be the 0x308 */
>  	sie(&vm);
> -	assert(pv_icptdata_check_diag(&vm, 0x308));
> +	assert(sie_is_diag_icpt(&vm, 0x308));
>  	assert(vm.save_area.guest.grs[2] =3D=3D subcode);
> =20
>  	/*
> @@ -118,7 +117,7 @@ static void test_diag_308(int subcode)
>  	 * see a diagnose 0x9c PV instruction notification.
>  	 */
>  	sie(&vm);
> -	report(pv_icptdata_check_diag(&vm, 0x9c) &&
> +	report(sie_is_diag_icpt(&vm, 0x9c) &&
>  	       vm.save_area.guest.grs[0] =3D=3D 42,
>  	       "continue after load");
> =20


