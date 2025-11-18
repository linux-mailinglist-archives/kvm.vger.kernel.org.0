Return-Path: <kvm+bounces-63522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB16C683FC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id CDE2D2A32F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D1F2EC542;
	Tue, 18 Nov 2025 08:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QMIhBYOs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BMZ0sPnO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82986306B1A
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 08:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763455426; cv=none; b=o/HREbRJGG1ZirJZJIOLJ8UttVe5MOkktnbJ8Ivwnj5IQC0eWaNoT9WTVAawDG1QeGDPyxfBnVcX2BZLPS4CqDdzuDP8Ag+rIeiB4ROZs4oQAOvKSrigODf0/gSgA5p4Lx+rO7XB0jrt5ff+9nCC3F6AfdKPosqNMxdhKm+5zeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763455426; c=relaxed/simple;
	bh=uToxdzJdsA4kmgfDYvhzYFIOOjcqjX3VdDLV0dOLoQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IMBX4lyjLRa0xATVGdHcXqhd26AlgCtqsI6UCrSpxYdD6ykrM2JFM0/FM2VVwm0xSm0SRsYrbF9pj3TBYsw6y+9/nRjPpqT9O0XtTkemF7eU8SqWLooGFZfnK+fB2zsaxGcV7mATQ9yt5S89qlKGfP7e13zakixGuxo7tHt+asw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QMIhBYOs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BMZ0sPnO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763455422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sey3LaydkzTf6bfn/6aPShMse5wB+Y/jN+PUnhD1ymc=;
	b=QMIhBYOsfawVKEcpP8bEsCMZYxqZUcZiGh/gaIc8XEF4ZAJWmBB+CU5W7SgN2dYQpkB/d8
	zu1vTLtSDJ9iUG7uooRVkR/QN4bL08DeADO2wBNs9VnswYnRv+V3ch2KLthHdl5lIrXaEg
	Ci38XWLqvAd9Z9a9NFXJt43jZHsBoss=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-OukDIixsO4mRmq3GcgK2bA-1; Tue, 18 Nov 2025 03:43:40 -0500
X-MC-Unique: OukDIixsO4mRmq3GcgK2bA-1
X-Mimecast-MFC-AGG-ID: OukDIixsO4mRmq3GcgK2bA_1763455420
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477939321e6so20267205e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 00:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763455419; x=1764060219; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sey3LaydkzTf6bfn/6aPShMse5wB+Y/jN+PUnhD1ymc=;
        b=BMZ0sPnOYWg5Kz35n6jErD0rtIRhlzs45ZpVNk89rZjd13G8W61QqhFKwlWdV31yzC
         2Frw8VSrW3UgKoWzYA5tPo8qhX+mJdopRt3YCKCBNj3SXHYRaIMp7bW1eR2PKXoWG0VC
         /gYFb9ceNdN7Fv+MIcs0T6ewEpV5U3l4zuXeeDLPwuqEUrkrX6u2ExC/ZicYWzSwD4IE
         QPULIoVUntIWRKk/MdcEuXevV2ULx0GmRpMjTkyRpz1KLJQIwitdKUTCaqLi1WhfmkqP
         NAZXJv0/g4SsCzYmbwbQhgMxjWx4mpf/QTAJP+gvg/cmLsOuXbLjiS1tA3GHxAllK5zv
         gMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763455419; x=1764060219;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sey3LaydkzTf6bfn/6aPShMse5wB+Y/jN+PUnhD1ymc=;
        b=MQEq/SlbgKJ2ehluSroHGdvr7XTrKc3siLT/qTdPBoCMo9urwXqbwYMbLBVd5K8jtX
         w+dq2eOuLE/IulryAOkBQJy7vD2mC2TNG7Cv6uoZ61m8Sc3M1pJM/R5McINP1ggR3rZd
         XhWGB58vA7D7SIC8SZd4V6mWT74B+qnLSZZarPIi8oHj+FA4KpvU/y472L8zxd+7QDAX
         gsBFq9h/SvVXkJXyrrwrF4vO3XcnG0MaLi3g31RLlVe05Be2FcuCvSc5v6WeFgDhDJas
         y4nNJ4bu8mc95rEewTA1oXJyHO9g27Agm8Geb685DKyvFa2TRv6TBJ8xHo6ZzecAo+Ch
         Dmzg==
X-Forwarded-Encrypted: i=1; AJvYcCXMnLaj832wwk9dyHZdaMTJmVaiUowfa/s5+wIshJDzR0IKXa53N5sJO198At15Q8QeiwQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRGjgollaWtYVr1e44CI+ckaKwwrfJrBXsVsJswX6llei7xHKK
	wdWZFVFNXDZrFcDEX7nGY3O5UMiBL2q6Nl5SEdH7vX1YIFrAqX0aBJuab9dB1X9/oxJkrnxgJ1s
	hj0UsX8uPfkvs6xh4A+rPI5MtIoy0Cjwtm6HYog/lKzACga6MtKXEzwj3o5bnJHkIzfRYPraVgN
	PaFpc66qBFpErsPy8O1bvOaqftHEtR
X-Gm-Gg: ASbGnctkX2SHAGho+9+lI7sBZeDfRJ6LK70SAQDsWVh8vF+NT2KjXyb+dvor8iqLm3T
	VcpD5jVjEUORIKFK8HfpbCOr7LugJ51BnTuV/6ZSsaDVLYahiERkxWA6fHHrakmmQOF1BFs4Ylk
	7MxCMEKnh8SO0Hm7cA80WkH3IQAM6UHMIPRUNo0DV5nXVQ0yGarWcgdgQcaDzDCri2lxRlGG/MO
	0rwRH8Lag73Q7Hd7wzwS9WHb6PlUhLJJ01qnj0mVfdGONnAAfCCLCKQhCv0ZTi49mpR6kQ=
X-Received: by 2002:a05:600c:4f93:b0:477:7479:f081 with SMTP id 5b1f17b1804b1-4778fe67b9amr141087425e9.12.1763455419526;
        Tue, 18 Nov 2025 00:43:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFNBeIEFUifGZtItCnp4Klj90vHm0zqLHTOjjICuFkx6TVlr/3YLnlQtLS0OCEOpq2uJG9A+MNK6li2TJtdV0E=
X-Received: by 2002:a05:600c:4f93:b0:477:7479:f081 with SMTP id
 5b1f17b1804b1-4778fe67b9amr141087045e9.12.1763455419054; Tue, 18 Nov 2025
 00:43:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118065817.835017-1-zhao1.liu@intel.com> <20251118065817.835017-3-zhao1.liu@intel.com>
In-Reply-To: <20251118065817.835017-3-zhao1.liu@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 18 Nov 2025 09:43:26 +0100
X-Gm-Features: AWmQ_bl3d1pDweky_dSebvm7DCwRxpOkVncewHuoqCnovK36jQkzTfCwBZJBgys
Message-ID: <CABgObfbzzwCafmGehgzCC-pFSnRR1OW_wfQxR4OJDAbv4mCztQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] i386/cpu: Cache EGPRs in CPUX86State
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	"Chang S . Bae" <chang.seok.bae@intel.com>, Zide Chen <zide.chen@intel.com>, 
	Xudong Hao <xudong.hao@intel.com>
Content-Type: multipart/mixed; boundary="000000000000d4b8f00643da7552"

--000000000000d4b8f00643da7552
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 7:43=E2=80=AFAM Zhao Liu <zhao1.liu@intel.com> wrot=
e:
>
> From: Zide Chen <zide.chen@intel.com>
>
> Cache EGPR[16] in CPUX86State to store APX's EGPR value.

Please change regs[] to have 32 elements instead; see the attached
patch for a minimal starting point. You can use VMSTATE_SUB_ARRAY to
split their migration data in two parts. You'll have to create a
VMSTATE_UINTTL_SUB_ARRAY similar to VMSTATE_UINT64_SUB_ARRAY.

To support HMP you need to adjust target/i386/monitor.c and
target/i386/cpu-dump.c. Please make x86_cpu_dump_state print R16...R31
only if APX is enabled in CPUID.

Also, it would be best for the series to include gdb support. APX is
supported by gdb as a "coprocessor", the easiest way to do it is to
copy what riscv_cpu_register_gdb_regs_for_features() does for the FPU,
and copy https://github.com/intel/gdb/blob/master/gdb/features/i386/64bit-a=
px.xml
into QEMU's gdb-xml/ directory.

Paolo

> Tested-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.h          |  1 +
>  target/i386/xsave_helper.c | 14 ++++++++++++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index bc7e16d6e6c1..48d4d7fcbb9c 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1969,6 +1969,7 @@ typedef struct CPUArchState {
>  #ifdef TARGET_X86_64
>      uint8_t xtilecfg[64];
>      uint8_t xtiledata[8192];
> +    uint64_t egprs[EGPR_NUM];
>  #endif
>
>      /* sysenter registers */
> diff --git a/target/i386/xsave_helper.c b/target/i386/xsave_helper.c
> index 996e9f3bfef5..2e9265045520 100644
> --- a/target/i386/xsave_helper.c
> +++ b/target/i386/xsave_helper.c
> @@ -140,6 +140,13 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf,=
 uint32_t buflen)
>
>          memcpy(tiledata, &env->xtiledata, sizeof(env->xtiledata));
>      }
> +
> +    e =3D &x86_ext_save_areas[XSTATE_APX_BIT];
> +    if (e->size && e->offset && buflen) {
> +        XSaveAPX *apx =3D buf + e->offset;
> +
> +        memcpy(apx, &env->egprs, sizeof(env->egprs));
> +    }
>  #endif
>  }
>
> @@ -275,5 +282,12 @@ void x86_cpu_xrstor_all_areas(X86CPU *cpu, const voi=
d *buf, uint32_t buflen)
>
>          memcpy(&env->xtiledata, tiledata, sizeof(env->xtiledata));
>      }
> +
> +    e =3D &x86_ext_save_areas[XSTATE_APX_BIT];
> +    if (e->size && e->offset) {
> +        const XSaveAPX *apx =3D buf + e->offset;
> +
> +        memcpy(&env->egprs, apx, sizeof(env->egprs));
> +    }
>  #endif
>  }
> --
> 2.34.1
>

--000000000000d4b8f00643da7552
Content-Type: text/x-patch; charset="US-ASCII"; name="f.patch"
Content-Disposition: attachment; filename="f.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mi4bn3520>
X-Attachment-Id: f_mi4bn3520

ZGlmZiAtLWdpdCBhL3RhcmdldC9pMzg2L2NwdS5oIGIvdGFyZ2V0L2kzODYvY3B1LmgKaW5kZXgg
Y2VlMWY2OTJhMWMuLjA4MTZmMWRkMjJmIDEwMDY0NAotLS0gYS90YXJnZXQvaTM4Ni9jcHUuaAor
KysgYi90YXJnZXQvaTM4Ni9jcHUuaApAQCAtMTYzOCwxMiArMTYzOCwxNSBAQCB0eXBlZGVmIHN0
cnVjdCB7CiAgICAgdWludDY0X3QgbWFzazsKIH0gTVRSUlZhcjsKIAorI2RlZmluZSBDUFVfTkJf
RVJFR1M2NCAzMgogI2RlZmluZSBDUFVfTkJfUkVHUzY0IDE2CiAjZGVmaW5lIENQVV9OQl9SRUdT
MzIgOAogCiAjaWZkZWYgVEFSR0VUX1g4Nl82NAorI2RlZmluZSBDUFVfTkJfRVJFR1MgQ1BVX05C
X0VSRUdTNjQKICNkZWZpbmUgQ1BVX05CX1JFR1MgQ1BVX05CX1JFR1M2NAogI2Vsc2UKKyNkZWZp
bmUgQ1BVX05CX0VSRUdTIENQVV9OQl9SRUdTMzIKICNkZWZpbmUgQ1BVX05CX1JFR1MgQ1BVX05C
X1JFR1MzMgogI2VuZGlmCiAKQEAgLTE4NDUsNyArMTg0OCw3IEBAIHR5cGVkZWYgc3RydWN0IENQ
VUNhY2hlcyB7CiAKIHR5cGVkZWYgc3RydWN0IENQVUFyY2hTdGF0ZSB7CiAgICAgLyogc3RhbmRh
cmQgcmVnaXN0ZXJzICovCi0gICAgdGFyZ2V0X3Vsb25nIHJlZ3NbQ1BVX05CX1JFR1NdOworICAg
IHRhcmdldF91bG9uZyByZWdzW0NQVV9OQl9FUkVHU107CiAgICAgdGFyZ2V0X3Vsb25nIGVpcDsK
ICAgICB0YXJnZXRfdWxvbmcgZWZsYWdzOyAvKiBlZmxhZ3MgcmVnaXN0ZXIuIER1cmluZyBDUFUg
ZW11bGF0aW9uLCBDQwogICAgICAgICAgICAgICAgICAgICAgICAgZmxhZ3MgYW5kIERGIGFyZSBz
ZXQgdG8gemVybyBiZWNhdXNlIHRoZXkgYXJlCkBAIC0xOTAyLDcgKzE5MDUsNyBAQCB0eXBlZGVm
IHN0cnVjdCBDUFVBcmNoU3RhdGUgewogICAgIGZsb2F0X3N0YXR1cyBtbXhfc3RhdHVzOyAvKiBm
b3IgM0ROb3chIGZsb2F0IG9wcyAqLwogICAgIGZsb2F0X3N0YXR1cyBzc2Vfc3RhdHVzOwogICAg
IHVpbnQzMl90IG14Y3NyOwotICAgIFpNTVJlZyB4bW1fcmVnc1tDUFVfTkJfUkVHUyA9PSA4ID8g
OCA6IDMyXSBRRU1VX0FMSUdORUQoMTYpOworICAgIFpNTVJlZyB4bW1fcmVnc1tDUFVfTkJfRVJF
R1NdIFFFTVVfQUxJR05FRCgxNik7CiAgICAgWk1NUmVnIHhtbV90MCBRRU1VX0FMSUdORUQoMTYp
OwogICAgIE1NWFJlZyBtbXhfdDA7CiAKZGlmZiAtLWdpdCBhL3RhcmdldC9pMzg2L2dkYnN0dWIu
YyBiL3RhcmdldC9pMzg2L2dkYnN0dWIuYwppbmRleCAwNGM0OWU4MDJkNy4uMTdkOGUzNTA4MzQg
MTAwNjQ0Ci0tLSBhL3RhcmdldC9pMzg2L2dkYnN0dWIuYworKysgYi90YXJnZXQvaTM4Ni9nZGJz
dHViLmMKQEAgLTEyNSw2ICsxMjUsNyBAQCBpbnQgeDg2X2NwdV9nZGJfcmVhZF9yZWdpc3RlcihD
UFVTdGF0ZSAqY3MsIEdCeXRlQXJyYXkgKm1lbV9idWYsIGludCBuKQogICAgICAgIG9mIGEgc2Vz
c2lvbi4gU28gaWYgd2UncmUgaW4gMzItYml0IG1vZGUgb24gYSA2NC1iaXQgY3B1LCBzdGlsbCBh
Y3QKICAgICAgICBhcyBpZiB3ZSdyZSBvbiBhIDY0LWJpdCBjcHUuICovCiAKKyAgICAvLyBUT0RP
OiBBUFggcmVnaXN0ZXJzCiAgICAgaWYgKG4gPCBDUFVfTkJfUkVHUykgewogICAgICAgICBpZiAo
VEFSR0VUX0xPTkdfQklUUyA9PSA2NCkgewogICAgICAgICAgICAgaWYgKGVudi0+aGZsYWdzICYg
SEZfQ1M2NF9NQVNLKSB7Cg==
--000000000000d4b8f00643da7552--


