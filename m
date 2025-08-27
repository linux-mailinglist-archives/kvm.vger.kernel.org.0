Return-Path: <kvm+bounces-55871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1D4B37F26
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EF227AED90
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DFE634EC;
	Wed, 27 Aug 2025 09:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gPwQLfL/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F7E23D7EC
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 09:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756287966; cv=none; b=BmShjCd4q2/jF3ilau3cLAXxZ1tpC6/Efr8HnW6MvZnq8Y2iKUiqW9clRLuuVR7u6S4Bmf8fzmjJFYL9PlWorfxVoEICh3Ux8kQD7Evri/LnxP1pkjhZbNiCSLbqKkgmur52qjFOyfOzZVb2f89zfY7NlYj1s8Kdkcpl1d/mtCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756287966; c=relaxed/simple;
	bh=5Zl2NvjuioacevSuuMgAiA0fwk4tfXKzwd2Nb5h8mFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OTyah7wFtA74Tsb+YQ/+4+UVNv/wrKyrXNeUiMk/NOyssvgubdaqKGS7twdlyF8+IfNVy7bcOBy1ICiG8CjT5VIeXQ73YDfqaLIur0GGyBnWVJ0u/Jf8LIjGHxC1h25iLiOfMmAYDGnkIz77boQAZ6XgRMVVZI/UtzOuayBzc/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gPwQLfL/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756287963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Zl2NvjuioacevSuuMgAiA0fwk4tfXKzwd2Nb5h8mFk=;
	b=gPwQLfL/ZWLhJt5Zidy8xla7SFjxYHaKdWxvq4ABX1qQF2Y18XqNCokZQSWfzrQttCQaJl
	aQVFTJtB7PHwlxJFYTregtZu1sR1omhUN3lmkX2OQzcoMAqeHE7a83NcAE2xeoQz58vdD0
	FSXg4sIyTF7fz2fRdzIJTiBAwdhzUYo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-8jMaN2OKODKQuc-tetuyDw-1; Wed, 27 Aug 2025 05:46:00 -0400
X-MC-Unique: 8jMaN2OKODKQuc-tetuyDw-1
X-Mimecast-MFC-AGG-ID: 8jMaN2OKODKQuc-tetuyDw_1756287959
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0cfbafso41427355e9.2
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 02:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756287959; x=1756892759;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Zl2NvjuioacevSuuMgAiA0fwk4tfXKzwd2Nb5h8mFk=;
        b=WnzzJLpxkG9W/ls57mrkg1MCH22dy2M+ida7uG9ViNjcUN5zrqxFhdXFMAKnf7J4DD
         bj2kn88nVkB6pukUzeER+5Np/fjmTUhpi5idnTAbhSj1o8b8GQsJn96R6j5gdKYoeFUu
         VvT40wF5tsQQ5uOIJbd/vRc6Zj2S+z+k0RdEDtj5d/uBr21ruwu0OM0fyy6xylcNLF7y
         illE2Lxws+n6a5DiqdsN6M23pm9cJ984D7qkjyVx30sBS5go3+5/JBm06DCtDMEB7uZJ
         b3n4iOHHCrENnXq0aBIBH9/ZaW+frCo1d7RZ1xvwy8nRvMv0Y7dhTZRsZLDN0gcGkbmJ
         uHmQ==
X-Gm-Message-State: AOJu0YyJFtGS7rTrKEH6cp9B+GK0HzEN1QWMpqsI42rluO600ki5l84V
	aVKG4XoJm5r0U82jtOboNoNi/PD02AqIYRd/2xWfHHwxRS55EZHnY3K2z8foFm2NDwN4ZnXkyce
	yCvZ38sfDJ1QIcuCayF04lxBvxJJtpRVLjoWJ2j8F7cf++ld9JiJdxF41WD3YulZp5e1miEJ1l9
	nqk1bV/J8kayMMDOrett7Pq0NGunhj
X-Gm-Gg: ASbGncujisDFs9YpZySZqqm752NCD1mwgRCOzPTHyr7/8ubiKJyi7Ste9Xalob/xR5P
	oo68FFNQUR+Gu/wQvDMbdoDE98Gd6gPD1VlaJksN5DqQwcQz5zD8ju1hklWVs/k9xSavQSrhEkI
	x1S9O7ttcRf9LxQo+89gRz5GVuhuKPifj55gZK2YaZYXuAqSbSmcBRTVJ/kOg83RaEdGGP4VzXH
	NsttU/awSnZOqcPi6pg+XIg
X-Received: by 2002:a05:600c:4590:b0:459:dfde:3324 with SMTP id 5b1f17b1804b1-45b517d2da6mr134067585e9.29.1756287959448;
        Wed, 27 Aug 2025 02:45:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUstgk6toAhKspIDmwgMOw6ca84c93YG5Ygjb5zxSsek7oed/jrmNAPMZ/h37ZsrgX3tWn7F5XmuMzFGnjkEM=
X-Received: by 2002:a05:600c:4590:b0:459:dfde:3324 with SMTP id
 5b1f17b1804b1-45b517d2da6mr134067395e9.29.1756287958980; Wed, 27 Aug 2025
 02:45:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANypQFay9zbp9k0AHpfpm1OJ_shKiLZSmhMjCKFQhnhnuJQr0w@mail.gmail.com>
In-Reply-To: <CANypQFay9zbp9k0AHpfpm1OJ_shKiLZSmhMjCKFQhnhnuJQr0w@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Aug 2025 11:45:46 +0200
X-Gm-Features: Ac12FXy7JCh9LqzRpPlEZrcxXIqHgf30SRlpZc1fcB6CdU3NLDdaWaXNLhpoA-8
Message-ID: <CABgObfZJzicJmpEEmhR=_abfTcT_km1sV0dfmYAt-ry42pFCNA@mail.gmail.com>
Subject: Re: [BUG?] KVM: Unexpected KVM_CREATE_VCPU failure with EBADF
To: Jiaming Zhang <r772577952@gmail.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com
Content-Type: multipart/mixed; boundary="000000000000eb454c063d55a7fe"

--000000000000eb454c063d55a7fe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have occasionally seen EINVAL and EEXIST as well. My suspicion is a
race condition due to incorrect synchronization of the executor
threads with close_fds():

1) the failing executor thread calls KVM_CREATE_VM
2) the main thread calls close_fds() while the failing thread is still
running, and closes the vm file descriptor
3) the failing thread then gets EBADF.

For example, EEXIST could happen if before step 3, another executor
thread calls KVM_CREATE_VM, receiving the same file descriptor, and
manages to call KVM_CREATE_VCPU(0) before the failing thread.

I attach a simplified reproducer.

Paolo

On Wed, Aug 27, 2025 at 10:57=E2=80=AFAM Jiaming Zhang <r772577952@gmail.co=
m> wrote:
>
> Hello KVM maintainers and developers,
>
> We are writing to report a potential bug discovered in the KVM
> subsystem with our modified syzkaller. The issue is that a
> KVM_CREATE_VCPU ioctl call can fail with EBADF on a valid VM file
> descriptor.
>
> The attached C program (repro.c) sets up a high-concurrency
> environment by forking multiple processes, each running the test logic
> in a loop. In the core test function (syz_func), it sequentially
> creates two VMs and then attempts to create one VCPU for each.
> Intermittently, one of the two KVM_CREATE_VCPU calls fails, returning
> -1 and setting errno to 9 (EBADF).
>
> The VM file descriptor (vm_fd1/vm_fd2) passed to KVM_CREATE_VCPU was
> just successfully returned by a KVM_CREATE_VM ioctl within the same
> thread. An EBADF error in this context is unexpected. In addition, the
> threading model of test code ensures that the creation and use of
> these file descriptors happen sequentially within a single thread,
> ruling out a user-space race condition where another thread could have
> closed the file descriptor prematurely.
>
> This issue was first found on v6.1.147 (commit
> 3594f306da129190de25938b823f353ef7f9e322), and is still reproducible
> on the latest version (v6.17-rc3, commit
> 1b237f190eb3d36f52dffe07a40b5eb210280e00).
>
> Other environmental information:
> - Architecture: x86_64
> - Distribution: Ubuntu 22.04
>
> The complete C code that triggers this issue and the .config file used
> for Linux Kernel v6.1.147 and v6.17-rc3 compilation are attached.
>
> Thank you for your time and for your incredible work on KVM. We hope
> this report is helpful. Please let me know if any further information
> is required.
>
> Best regards,
> Jiaming Zhang

--000000000000eb454c063d55a7fe
Content-Type: text/x-csrc; charset="US-ASCII"; name="repro.c"
Content-Disposition: attachment; filename="repro.c"
Content-Transfer-Encoding: base64
Content-ID: <f_metshjuf0>
X-Attachment-Id: f_metshjuf0

I2RlZmluZSBNQVhfRkRTIDEwMjQKLy8gYXV0b2dlbmVyYXRlZCBieSBzeXprYWxsZXIgKGh0dHBz
Oi8vZ2l0aHViLmNvbS9nb29nbGUvc3l6a2FsbGVyKQoKI2RlZmluZSBfR05VX1NPVVJDRQoKI2lu
Y2x1ZGUgPGFycGEvaW5ldC5oPgojaW5jbHVkZSA8ZGlyZW50Lmg+CiNpbmNsdWRlIDxlbmRpYW4u
aD4KI2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8aWZhZGRy
cy5oPgojaW5jbHVkZSA8bmV0L2lmLmg+CiNpbmNsdWRlIDxuZXQvaWZfYXJwLmg+CiNpbmNsdWRl
IDxuZXRpbmV0L2luLmg+CiNpbmNsdWRlIDxwdGhyZWFkLmg+CiNpbmNsdWRlIDxzY2hlZC5oPgoj
aW5jbHVkZSA8c2lnbmFsLmg+CiNpbmNsdWRlIDxzdGRhcmcuaD4KI2luY2x1ZGUgPHN0ZGJvb2wu
aD4KI2luY2x1ZGUgPHN0ZGludC5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxp
Yi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvZXBvbGwuaD4KI2luY2x1ZGUg
PHN5cy9pb2N0bC5oPgojaW5jbHVkZSA8c3lzL21vdW50Lmg+CiNpbmNsdWRlIDxzeXMvcHJjdGwu
aD4KI2luY2x1ZGUgPHN5cy9yZXNvdXJjZS5oPgojaW5jbHVkZSA8c3lzL3NvY2tldC5oPgojaW5j
bHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1ZGUgPHN5cy9zd2FwLmg+CiNpbmNsdWRlIDxzeXMvc3lz
Y2FsbC5oPgojaW5jbHVkZSA8c3lzL3RpbWUuaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5j
bHVkZSA8c3lzL3Vpby5oPgojaW5jbHVkZSA8c3lzL3dhaXQuaD4KI2luY2x1ZGUgPHRpbWUuaD4K
I2luY2x1ZGUgPHVuaXN0ZC5oPgoKI2luY2x1ZGUgPGxpbnV4L2NhcGFiaWxpdHkuaD4KI2luY2x1
ZGUgPGxpbnV4L2V0aHRvb2wuaD4KI2luY2x1ZGUgPGxpbnV4L2ZhbGxvYy5oPgojaW5jbHVkZSA8
bGludXgvZnV0ZXguaD4KI2luY2x1ZGUgPGxpbnV4L2dlbmV0bGluay5oPgojaW5jbHVkZSA8bGlu
dXgvaWZfYWRkci5oPgojaW5jbHVkZSA8bGludXgvaWZfZXRoZXIuaD4KI2luY2x1ZGUgPGxpbnV4
L2lmX2xpbmsuaD4KI2luY2x1ZGUgPGxpbnV4L2lmX3R1bi5oPgojaW5jbHVkZSA8bGludXgvaW42
Lmg+CiNpbmNsdWRlIDxsaW51eC9pcC5oPgojaW5jbHVkZSA8bGludXgva3ZtLmg+CiNpbmNsdWRl
IDxsaW51eC9uZWlnaGJvdXIuaD4KI2luY2x1ZGUgPGxpbnV4L25ldC5oPgojaW5jbHVkZSA8bGlu
dXgvbmV0bGluay5oPgojaW5jbHVkZSA8bGludXgvbmw4MDIxMS5oPgojaW5jbHVkZSA8bGludXgv
cmZraWxsLmg+CiNpbmNsdWRlIDxsaW51eC9ydG5ldGxpbmsuaD4KI2luY2x1ZGUgPGxpbnV4L3Nv
Y2tpb3MuaD4KI2luY2x1ZGUgPGxpbnV4L3RjcC5oPgojaW5jbHVkZSA8bGludXgvdmV0aC5oPgoK
c3RhdGljIHZvaWQgdGhyZWFkX3N0YXJ0KHZvaWQqICgqZm4pKHZvaWQqKSwgdm9pZCogYXJnKQp7
CiAgcHRocmVhZF90IHRoOwogIHB0aHJlYWRfYXR0cl90IGF0dHI7CiAgcHRocmVhZF9hdHRyX2lu
aXQoJmF0dHIpOwogIHB0aHJlYWRfYXR0cl9zZXRzdGFja3NpemUoJmF0dHIsIDEyOCA8PCAxMCk7
CiAgaW50IGkgPSAwOwogIGZvciAoOyBpIDwgMTAwOyBpKyspIHsKICAgIGlmIChwdGhyZWFkX2Ny
ZWF0ZSgmdGgsICZhdHRyLCBmbiwgYXJnKSA9PSAwKSB7CiAgICAgIHB0aHJlYWRfYXR0cl9kZXN0
cm95KCZhdHRyKTsKICAgICAgcmV0dXJuOwogICAgfQogICAgaWYgKGVycm5vID09IEVBR0FJTikg
ewogICAgICB1c2xlZXAoNTApOwogICAgICBjb250aW51ZTsKICAgIH0KICAgIGJyZWFrOwogIH0K
ICBleGl0KDEpOwp9Cgp0eXBlZGVmIHN0cnVjdCB7CiAgaW50IHN0YXRlOwp9IGV2ZW50X3Q7Cgpz
dGF0aWMgdm9pZCBldmVudF9pbml0KGV2ZW50X3QqIGV2KQp7CiAgZXYtPnN0YXRlID0gMDsKfQoK
c3RhdGljIHZvaWQgZXZlbnRfcmVzZXQoZXZlbnRfdCogZXYpCnsKICBldi0+c3RhdGUgPSAwOwp9
CgpzdGF0aWMgdm9pZCBldmVudF9zZXQoZXZlbnRfdCogZXYpCnsKICBpZiAoZXYtPnN0YXRlKQog
ICAgZXhpdCgxKTsKICBfX2F0b21pY19zdG9yZV9uKCZldi0+c3RhdGUsIDEsIF9fQVRPTUlDX1JF
TEVBU0UpOwogIHN5c2NhbGwoU1lTX2Z1dGV4LCAmZXYtPnN0YXRlLCBGVVRFWF9XQUtFIHwgRlVU
RVhfUFJJVkFURV9GTEFHLCAxMDAwMDAwKTsKfQoKc3RhdGljIHZvaWQgZXZlbnRfd2FpdChldmVu
dF90KiBldikKewogIHdoaWxlICghX19hdG9taWNfbG9hZF9uKCZldi0+c3RhdGUsIF9fQVRPTUlD
X0FDUVVJUkUpKQogICAgc3lzY2FsbChTWVNfZnV0ZXgsICZldi0+c3RhdGUsIEZVVEVYX1dBSVQg
fCBGVVRFWF9QUklWQVRFX0ZMQUcsIDAsIDApOwp9CgpzdGF0aWMgaW50IGV2ZW50X2lzc2V0KGV2
ZW50X3QqIGV2KQp7CiAgcmV0dXJuIF9fYXRvbWljX2xvYWRfbigmZXYtPnN0YXRlLCBfX0FUT01J
Q19BQ1FVSVJFKTsKfQoKc3RhdGljIHZvaWQgc2V0dXBfdGVzdCgpCnsKICBwcmN0bChQUl9TRVRf
UERFQVRIU0lHLCBTSUdLSUxMLCAwLCAwLCAwKTsKICBzZXRwZ3JwKCk7Cn0KCnN0YXRpYyB2b2lk
IGNsb3NlX2ZkcygpCnsKICBmb3IgKGludCBmZCA9IDM7IGZkIDwgTUFYX0ZEUzsgZmQrKykKICAg
IGNsb3NlKGZkKTsKfQoKc3RhdGljIGxvbmcgc3l6X2Z1bmMoaW50IGl0ZXIsIGludCBpKQp7CiAg
aW50IGt2bV9mZDEgPSAtMSwgdm1fZmQxID0gLTEsIHZjcHVfZmQxID0gLTE7CiAgaW50IGt2bV9m
ZDIgPSAtMSwgdm1fZmQyID0gLTEsIHZjcHVfZmQyID0gLTE7CiAgaW50IGt2bV9jaGVja19mZDsK
ICBpbnQgZXJyX2lycTEsIGVycl9pcnEyOwogIGludCBlcnJfdmNwdTEsIGVycl92Y3B1MjsKICBr
dm1fY2hlY2tfZmQgPSBvcGVuKCIvZGV2L2t2bSIsIE9fUkRXUik7CiAgaWYgKGt2bV9jaGVja19m
ZCA9PSAtMSkgewogICAgcmV0dXJuIDA7CiAgfQogIGNsb3NlKGt2bV9jaGVja19mZCk7CiAga3Zt
X2ZkMSA9IG9wZW4oIi9kZXYva3ZtIiwgT19SRFdSKTsKICBpZiAoa3ZtX2ZkMSA9PSAtMSkKICAg
IGdvdG8gY2xlYW51cDsKICB2bV9mZDEgPSBpb2N0bChrdm1fZmQxLCBLVk1fQ1JFQVRFX1ZNLCAw
KTsKICBpZiAodm1fZmQxID09IC0xKQogICAgZ290byBjbGVhbnVwOwogIGVycm5vID0gMDsKICBp
b2N0bCh2bV9mZDEsIEtWTV9DUkVBVEVfSVJRQ0hJUCwgMCk7CiAgZXJyX2lycTEgPSBlcnJubzsK
ICBrdm1fZmQyID0gb3BlbigiL2Rldi9rdm0iLCBPX1JEV1IpOwogIGlmIChrdm1fZmQyID09IC0x
KQogICAgZ290byBjbGVhbnVwOwogIHZtX2ZkMiA9IGlvY3RsKGt2bV9mZDIsIEtWTV9DUkVBVEVf
Vk0sIDApOwogIGlmICh2bV9mZDIgPT0gLTEpCiAgICBnb3RvIGNsZWFudXA7CiAgZXJybm8gPSAw
OwogIGlvY3RsKHZtX2ZkMiwgS1ZNX0NSRUFURV9JUlFDSElQLCAwKTsKICBlcnJfaXJxMiA9IGVy
cm5vOwogIGlmIChlcnJfaXJxMSB8fCBlcnJfaXJxMikKICAgIGdvdG8gY2xlYW51cDsKICBlcnJu
byA9IDA7CiAgdmNwdV9mZDEgPSBpb2N0bCh2bV9mZDEsIEtWTV9DUkVBVEVfVkNQVSwgMCk7CiAg
ZXJyX3ZjcHUxID0gZXJybm87CiAgZXJybm8gPSAwOwogIHZjcHVfZmQyID0gaW9jdGwodm1fZmQy
LCBLVk1fQ1JFQVRFX1ZDUFUsIDApOwogIGVycl92Y3B1MiA9IGVycm5vOwogIGVycm5vID0gMDsK
ICBpZiAoKHZjcHVfZmQxID09IC0xKSBeICh2Y3B1X2ZkMiA9PSAtMSkpIHsKICAgIGZwcmludGYo
c3RkZXJyLCAiW3BpZCAlZF0gZm9vYmFyICVkICVkIVxuIiwgZ2V0cGlkKCksIGl0ZXIsIGkpOwog
ICAgZnByaW50ZihzdGRlcnIsICJrdm1fZmQxPSVkXG4iLCBrdm1fZmQxKTsKICAgIGZwcmludGYo
c3RkZXJyLCAia3ZtX2ZkMj0lZFxuIiwga3ZtX2ZkMik7CiAgICBmcHJpbnRmKHN0ZGVyciwgInZt
X2ZkMT0lZCwgZXJyX2lycTE9JWRcbiIsIHZtX2ZkMSwgZXJyX2lycTEpOwogICAgZnByaW50Zihz
dGRlcnIsICJ2bV9mZDI9JWQsIGVycl9pcnEyPSVkXG4iLCB2bV9mZDIsIGVycl9pcnEyKTsKICAg
IGZwcmludGYoc3RkZXJyLCAidmNwdV9mZDE9JWQsIGVycl92Y3B1MT0lZFxuIiwgdmNwdV9mZDEs
IGVycl92Y3B1MSk7CiAgICBmcHJpbnRmKHN0ZGVyciwgInZjcHVfZmQyPSVkLCBlcnJfdmNwdTI9
JWRcbiIsIHZjcHVfZmQyLCBlcnJfdmNwdTIpOwoKICAgIHZjcHVfZmQxID0gaW9jdGwodm1fZmQx
LCBLVk1fQ1JFQVRFX1ZDUFUsIDEpOwogICAgZXJyX3ZjcHUxID0gZXJybm87CiAgICBlcnJubyA9
IDA7CiAgICBmcHJpbnRmKHN0ZGVyciwgInRyeWluZyBhZ2FpbiB2Y3B1X2ZkMT0lZCwgZXJyX3Zj
cHUxPSVkXG4iLCB2Y3B1X2ZkMSwgZXJyX3ZjcHUxKTsKICAgIHZjcHVfZmQyID0gaW9jdGwodm1f
ZmQyLCBLVk1fQ1JFQVRFX1ZDUFUsIDEpOwogICAgZXJyX3ZjcHUyID0gZXJybm87CiAgICBlcnJu
byA9IDA7CiAgICBmcHJpbnRmKHN0ZGVyciwgInRyeWluZyBhZ2FpbiB2Y3B1X2ZkMj0lZCwgZXJy
X3ZjcHUyPSVkXG4iLCB2Y3B1X2ZkMiwgZXJyX3ZjcHUyKTsKCiAgICBjaGFyIGZbNjRdOwogICAg
c3ByaW50ZihmLCAibHMgLWwgL3Byb2MvJWQvZmQiLCBnZXRwaWQoKSk7CiAgICBzeXN0ZW0oZik7
CiAgICBmcHJpbnRmKHN0ZGVyciwgIltwaWQgJWRdIGZvb2JhciAlZCAlZCBkb25lIVxuIiwgZ2V0
cGlkKCksIGl0ZXIsIGkpOwogIH0KCmNsZWFudXA6CiAgaWYgKHZjcHVfZmQxICE9IC0xKQogICAg
Y2xvc2UodmNwdV9mZDEpOwogIGlmICh2Y3B1X2ZkMiAhPSAtMSkKICAgIGNsb3NlKHZjcHVfZmQy
KTsKICBpZiAodm1fZmQxICE9IC0xKQogICAgY2xvc2Uodm1fZmQxKTsKICBpZiAodm1fZmQyICE9
IC0xKQogICAgY2xvc2Uodm1fZmQyKTsKICBpZiAoa3ZtX2ZkMSAhPSAtMSkKICAgIGNsb3NlKGt2
bV9mZDEpOwogIGlmIChrdm1fZmQyICE9IC0xKQogICAgY2xvc2Uoa3ZtX2ZkMik7CiAgcmV0dXJu
IDA7Cn0KCnN0cnVjdCB0aHJlYWRfdCB7CiAgaW50IGNyZWF0ZWQsIGl0ZXI7CiAgZXZlbnRfdCBy
ZWFkeSwgZG9uZTsKfTsKCnN0YXRpYyBzdHJ1Y3QgdGhyZWFkX3QgdGhyZWFkc1sxNl07CnN0YXRp
YyBpbnQgcnVubmluZzsKCnN0YXRpYyB2b2lkKiB0aHIodm9pZCogYXJnKQp7CiAgc3RydWN0IHRo
cmVhZF90KiB0aCA9IChzdHJ1Y3QgdGhyZWFkX3QqKWFyZzsKICBmb3IgKDs7KSB7CiAgICBldmVu
dF93YWl0KCZ0aC0+cmVhZHkpOwogICAgZXZlbnRfcmVzZXQoJnRoLT5yZWFkeSk7CgogICAgZm9y
IChpbnQgaSA9IDA7IGkgPD0gMzI7IGkrKykgewogICAgICBzeXpfZnVuYyh0aC0+aXRlciwgaSk7
CiAgICB9CgogICAgX19hdG9taWNfZmV0Y2hfc3ViKCZydW5uaW5nLCAxLCBfX0FUT01JQ19SRUxB
WEVEKTsKICAgIGV2ZW50X3NldCgmdGgtPmRvbmUpOwogIH0KICByZXR1cm4gMDsKfQoKc3RhdGlj
IHZvaWQgZXhlY3V0ZV9vbmUoaW50IGl0ZXIpCnsKICB3cml0ZSgxLCAiZXhlY3V0aW5nIHByb2dy
YW1cbiIsIHNpemVvZigiZXhlY3V0aW5nIHByb2dyYW1cbiIpIC0gMSk7CiAgaW50IGksIHRocmVh
ZDsKICBmb3IgKHRocmVhZCA9IDA7IHRocmVhZCA8IChpbnQpKHNpemVvZih0aHJlYWRzKSAvIHNp
emVvZih0aHJlYWRzWzBdKSk7CiAgICAgICB0aHJlYWQrKykgewogICAgc3RydWN0IHRocmVhZF90
KiB0aCA9ICZ0aHJlYWRzW3RocmVhZF07CiAgICBpZiAoIXRoLT5jcmVhdGVkKSB7CiAgICAgIHRo
LT5jcmVhdGVkID0gMTsKICAgICAgdGgtPml0ZXIgPSBpdGVyOwogICAgICBldmVudF9pbml0KCZ0
aC0+cmVhZHkpOwogICAgICBldmVudF9pbml0KCZ0aC0+ZG9uZSk7CiAgICAgIGV2ZW50X3NldCgm
dGgtPmRvbmUpOwogICAgICB0aHJlYWRfc3RhcnQodGhyLCB0aCk7CiAgICB9CiAgICBpZiAoZXZl
bnRfaXNzZXQoJnRoLT5kb25lKSkgewogICAgICBldmVudF9yZXNldCgmdGgtPmRvbmUpOwogICAg
ICBfX2F0b21pY19mZXRjaF9hZGQoJnJ1bm5pbmcsIDEsIF9fQVRPTUlDX1JFTEFYRUQpOwogICAg
ICBldmVudF9zZXQoJnRoLT5yZWFkeSk7CiAgICB9CiAgfQogIGZvciAoaSA9IDA7IGkgPCAxMDAg
JiYgX19hdG9taWNfbG9hZF9uKCZydW5uaW5nLCBfX0FUT01JQ19SRUxBWEVEKTsgaSsrKQogICAg
dXNsZWVwKDEwMDApOwp9CgppbnQgbWFpbih2b2lkKQp7CiAgaW50IGl0ZXIgPSAwOwogIHNldHVw
X3Rlc3QoKTsKICBmb3IgKDs7KSB7CiAgICBleGVjdXRlX29uZShpdGVyKyspOwogICAgY2xvc2Vf
ZmRzKCk7CiAgfQogIHJldHVybiAwOwp9Cg==
--000000000000eb454c063d55a7fe--


