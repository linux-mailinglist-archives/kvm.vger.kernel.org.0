Return-Path: <kvm+bounces-52280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96EAAB03A40
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:05:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1C003B3080
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB5F23AB88;
	Mon, 14 Jul 2025 09:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZU08YYuO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDECCA6B
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 09:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752483913; cv=none; b=srrU8f1Ygd6lHrV7F2pv2KsKtIkH/O8Potzxdr3EXWpQK0HH5MdcKQfMiih+WxaVpJ4O7QMVV/FOqBSi06+ItH128ZmIMZLxhM189sJqQr5Pkb0bRCS4Ia3KpsLsiTptEXuLKqsstgY1fYO4olLMb0Iy4K+sJL9wtIYXMSQ9zmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752483913; c=relaxed/simple;
	bh=RwlZUkf9M69pYysvpnkq74+mwy3n5Q62dtDqRqjQtdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AqkDzbbrHkcaG4AjNUQ5GVlnegg9N9bUc7+mKDSxSYXCBrHkiCO65uEU1drMgEG+Bd+9mu+7S4T5oE9BuzDlNdsmqgdUHNAf5cRaNCBjLkkdsfomJ31oXmb+oXPWESgqcMol34MfEEq9wW6Uqc4cYVlrU52/hYluXTqgnS3TwaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZU08YYuO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752483911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3kR6AprqenTMfhoWDA+lFCsBWj2eHNgKoPQx1lOdUk=;
	b=ZU08YYuOrNDJBVdvG9mI4T+A897fbVPY8Q+bvZTg02aXuQNfLkhzgzYB4D/kydIPJ3ypwx
	5apNGoQGnGHobPSu/2JNUO78x8GGeDqV5MQ0S5ny2gkyatU4QkTUXXRsPk5f9YyOVUYWbl
	v76ME4NM3d27cmNX+Y0H3Bzedp/CEAE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-uvV4fztyOqetod1aG1SVyQ-1; Mon, 14 Jul 2025 05:05:09 -0400
X-MC-Unique: uvV4fztyOqetod1aG1SVyQ-1
X-Mimecast-MFC-AGG-ID: uvV4fztyOqetod1aG1SVyQ_1752483908
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-455f7b86aeeso11617595e9.0
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 02:05:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752483908; x=1753088708;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3kR6AprqenTMfhoWDA+lFCsBWj2eHNgKoPQx1lOdUk=;
        b=YnyRb0+3drrzmxWlYhNKtQg0CNm90Hr8qPSAHCm6tzS0DLiz1pFdlMfsYV9zvwXZ0L
         3YCTpgf2zuXOou1fPgLQ+p8s4dKcgAIOygxLzhJ2zkSPvEux5DC05dACGcrJBeI9Fddr
         vccjXKpX0yuBJJIyRSQbl1ErogaGCguotER8ibpjGkgd8J7A2LtCO3lO4oldG201NYRh
         8HWjDjjBJZ+2Hd+hjnzwmPUA7wXTj5O4kaEGFnEswcEh1Ws1HR5VkY0zzy8yeA8OVkD+
         ducqnb2vmWIcwJt8xFnjtpXuV3tBP3A2AADkY3ehTDlExtRu2sp415CSMXRdN1liMUVu
         1lOg==
X-Forwarded-Encrypted: i=1; AJvYcCWtGE9oAZ09LD0HPFTgTa5J7AkOFckCyOWeXyfTVoeAnt+gF6LZHvedxzYtHUn0xBvDeRI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZabqDCo5mdolfqvXveebcMqGD/llc0SlvSLGN6ccfBAYa+uYM
	DN3J7a9aYfM0rH+RygxsGDQKeh6f5ucQolceKUGw/zikObeXvB/pZm3M1eIa2mhBNBuqIQWFVsy
	WNZMdReSYd/a0HQsOZAivXYgia5xqqjS8pNgy8/bZExjxDFpacGXddQ==
X-Gm-Gg: ASbGncvwWgbjokq3jgperXB/U1eWIfYZ+Q2rCUEBBRIhifQT+vyUAOnAblv7zHRKDBf
	3GwfIRGmlbmGFwqWTQWLpDRmMQhIAi2+bRoCWBNWyDddp1U1noxFE3EWxkcB9Qf4aOWD0qy9q+k
	bicbmN3zI7Qm0NK5D+f9o0wz50tbD9++tK6X0mzE3vA5QZ9JpBFTDVDq738HhARFJVTuNDV79eW
	Ct89eVT5h+qUN2CaH4sll9QtRk4XKgsYy9yN68LJfyb0C/G8+D0d+gjitkg5bdP/0NDPlzmk3Bb
	K8gdF5QW/hAYqVl6RPC1CEw9ResJdTdB6umGxjvCtx4=
X-Received: by 2002:a05:600c:3155:b0:454:ab87:a0a0 with SMTP id 5b1f17b1804b1-454f4257f20mr124091995e9.17.1752483907947;
        Mon, 14 Jul 2025 02:05:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkbz6uXPs7gRwumu+oXnhywRFmZssnK+9l+dRhoRg4fij/TNvrG1p+a03pPIjsrexl0/fVMw==
X-Received: by 2002:a05:600c:3155:b0:454:ab87:a0a0 with SMTP id 5b1f17b1804b1-454f4257f20mr124091515e9.17.1752483907406;
        Mon, 14 Jul 2025 02:05:07 -0700 (PDT)
Received: from [192.168.0.115] ([212.105.155.228])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e0d5easm11719286f8f.48.2025.07.14.02.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 02:05:06 -0700 (PDT)
Message-ID: <b745cfee-5e29-431a-8a3d-070c47e3f0a3@redhat.com>
Date: Mon, 14 Jul 2025 11:05:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/13] virtio: introduce support for GSO over UDP
 tunnel
To: Lei Yang <leiyang@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Jason Wang <jasowang@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Luigi Rizzo <lrizzo@google.com>, Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>, Vincenzo Maffione <v.maffione@gmail.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <CAPpAL=y4e=+H2rxHwwgbGvU+x10aTDVZ7ix+2YqVC3e6hd6L7g@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CAPpAL=y4e=+H2rxHwwgbGvU+x10aTDVZ7ix+2YqVC3e6hd6L7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/14/25 10:43 AM, Lei Yang wrote:
> Does the compile of this series of patches require support for a
> special kernel environment? I hit a compile issue after applied you
> patches:
> [1440/2928] Compiling C object libsystem.a.p/hw_virtio_vhost.c.o
> FAILED: libsystem.a.p/hw_virtio_vhost.c.o
> cc -m64 -Ilibsystem.a.p -I. -I.. -Isubprojects/dtc/libfdt
> -I../subprojects/dtc/libfdt -Isubprojects/libvduse
> -I../subprojects/libvduse -Iui -Iqapi -Itrace -Iui/shader
> -I/usr/include/pixman-1 -I/usr/include/glib-2.0
> -I/usr/lib64/glib-2.0/include -I/usr/include/libmount
> -I/usr/include/blkid -I/usr/include/sysprof-6
> -I/usr/include/gio-unix-2.0 -I/usr/include/slirp
> -fdiagnostics-color=auto -Wall -Winvalid-pch -Werror -std=gnu11 -O0 -g
> -fstack-protector-strong -Wempty-body -Wendif-labels
> -Wexpansion-to-defined -Wformat-security -Wformat-y2k
> -Wignored-qualifiers -Wimplicit-fallthrough=2 -Winit-self
> -Wmissing-format-attribute -Wmissing-prototypes -Wnested-externs
> -Wold-style-declaration -Wold-style-definition -Wredundant-decls
> -Wshadow=local -Wstrict-prototypes -Wtype-limits -Wundef -Wvla
> -Wwrite-strings -Wno-missing-include-dirs -Wno-psabi
> -Wno-shift-negative-value -isystem
> /mnt/tests/distribution/command/qemu/linux-headers -isystem
> linux-headers -iquote . -iquote /mnt/tests/distribution/command/qemu
> -iquote /mnt/tests/distribution/command/qemu/include -iquote
> /mnt/tests/distribution/command/qemu/host/include/x86_64 -iquote
> /mnt/tests/distribution/command/qemu/host/include/generic -iquote
> /mnt/tests/distribution/command/qemu/tcg/i386 -pthread -mcx16 -msse2
> -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE
> -fno-strict-aliasing -fno-common -fwrapv -ftrivial-auto-var-init=zero
> -fzero-call-used-regs=used-gpr -fPIE -DWITH_GZFILEOP -DCONFIG_SOFTMMU
> -DCOMPILING_SYSTEM_VS_USER -MD -MQ libsystem.a.p/hw_virtio_vhost.c.o
> -MF libsystem.a.p/hw_virtio_vhost.c.o.d -o
> libsystem.a.p/hw_virtio_vhost.c.o -c ../hw/virtio/vhost.c
> ../hw/virtio/vhost.c: In function ‘vhost_dev_set_features’:
> ../hw/virtio/vhost.c:38:9: error: ‘r’ may be used uninitialized
> [-Werror=maybe-uninitialized]
>    38 |         error_report(fmt ": %s (%d)", ## __VA_ARGS__, \
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    39 |                      strerror(-retval), -retval); \
>       |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../hw/virtio/vhost.c:1006:9: note: in expansion of macro ‘VHOST_OPS_DEBUG’
>  1006 |         VHOST_OPS_DEBUG(r, "extended features without device support");
>       |         ^~~~~~~~~~~~~~~
> ../hw/virtio/vhost.c:989:9: note: ‘r’ was declared here
>   989 |     int r;
>       |         ^
> cc1: all warnings being treated as errors
> ninja: build stopped: subcommand failed.
> make[1]: *** [Makefile:168: run-ninja] Error 1
> make[1]: Leaving directory '/mnt/tests/distribution/command/qemu/build'
> make[1]: Entering directory '/mnt/tests/distribution/command/qemu/build'
> [1/1493] Generating subprojects/dtc/version_gen.h with a custom command
> [2/1493] Generating qemu-version.h with a custom command (wrapped by
> meson to capture output)
> [3/1492] Compiling C object libsystem.a.p/hw_virtio_vhost.c.o
> FAILED: libsystem.a.p/hw_virtio_vhost.c.o
> cc -m64 -Ilibsystem.a.p -I. -I.. -Isubprojects/dtc/libfdt
> -I../subprojects/dtc/libfdt -Isubprojects/libvduse
> -I../subprojects/libvduse -Iui -Iqapi -Itrace -Iui/shader
> -I/usr/include/pixman-1 -I/usr/include/glib-2.0
> -I/usr/lib64/glib-2.0/include -I/usr/include/libmount
> -I/usr/include/blkid -I/usr/include/sysprof-6
> -I/usr/include/gio-unix-2.0 -I/usr/include/slirp
> -fdiagnostics-color=auto -Wall -Winvalid-pch -Werror -std=gnu11 -O0 -g
> -fstack-protector-strong -Wempty-body -Wendif-labels
> -Wexpansion-to-defined -Wformat-security -Wformat-y2k
> -Wignored-qualifiers -Wimplicit-fallthrough=2 -Winit-self
> -Wmissing-format-attribute -Wmissing-prototypes -Wnested-externs
> -Wold-style-declaration -Wold-style-definition -Wredundant-decls
> -Wshadow=local -Wstrict-prototypes -Wtype-limits -Wundef -Wvla
> -Wwrite-strings -Wno-missing-include-dirs -Wno-psabi
> -Wno-shift-negative-value -isystem
> /mnt/tests/distribution/command/qemu/linux-headers -isystem
> linux-headers -iquote . -iquote /mnt/tests/distribution/command/qemu
> -iquote /mnt/tests/distribution/command/qemu/include -iquote
> /mnt/tests/distribution/command/qemu/host/include/x86_64 -iquote
> /mnt/tests/distribution/command/qemu/host/include/generic -iquote
> /mnt/tests/distribution/command/qemu/tcg/i386 -pthread -mcx16 -msse2
> -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE
> -fno-strict-aliasing -fno-common -fwrapv -ftrivial-auto-var-init=zero
> -fzero-call-used-regs=used-gpr -fPIE -DWITH_GZFILEOP -DCONFIG_SOFTMMU
> -DCOMPILING_SYSTEM_VS_USER -MD -MQ libsystem.a.p/hw_virtio_vhost.c.o
> -MF libsystem.a.p/hw_virtio_vhost.c.o.d -o
> libsystem.a.p/hw_virtio_vhost.c.o -c ../hw/virtio/vhost.c
> ../hw/virtio/vhost.c: In function ‘vhost_dev_set_features’:
> ../hw/virtio/vhost.c:38:9: error: ‘r’ may be used uninitialized
> [-Werror=maybe-uninitialized]
>    38 |         error_report(fmt ": %s (%d)", ## __VA_ARGS__, \
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    39 |                      strerror(-retval), -retval); \
>       |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../hw/virtio/vhost.c:1006:9: note: in expansion of macro ‘VHOST_OPS_DEBUG’
>  1006 |         VHOST_OPS_DEBUG(r, "extended features without device support");
>       |         ^~~~~~~~~~~~~~~
> ../hw/virtio/vhost.c:989:9: note: ‘r’ was declared here
>   989 |     int r;
>       |         ^
> cc1: all warnings being treated as errors
> ninja: build stopped: subcommand failed.
> make[1]: *** [Makefile:168: run-ninja] Error 1
> make[1]: Leaving directory '/mnt/tests/distribution/command/qemu/build'

Thank you for reporting the problem.

No special kernel requirement to build the series, the above is just a
gross mistake on my side in patch 7/13. If you want to test the series,
please apply incrementally the following diff.

What baffles me is that gcc 14.3.1 and 11.5.0 are not raising the
warning (that looks legit/correct) here.

I'll fix the above in the next revision.

Note that you need a running kernel based on current net-next tree in
both the hypervisor and the guest to actually leverage the new feature.

Thanks,

Paolo
---
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 2eee9b0886..c4eab5ce08 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1003,8 +1003,8 @@ static int vhost_dev_set_features(struct vhost_dev
*dev,

     if (virtio_features_use_extended(features) &&
         !dev->vhost_ops->vhost_set_features_ex) {
-        VHOST_OPS_DEBUG(r, "extended features without device support");
         r = -EINVAL;
+        VHOST_OPS_DEBUG(r, "extended features without device support");
         goto out;
     }


