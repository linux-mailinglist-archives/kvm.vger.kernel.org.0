Return-Path: <kvm+bounces-43015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 388E2A82639
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 15:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CDF116B561
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 13:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1112A25E467;
	Wed,  9 Apr 2025 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O5LV32MN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A3729A0
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744205055; cv=none; b=u5Uhv+lNWc/zmJZ9vTVXNV8QfakUDFSyCcuTd0t8jY9iHF9j4gTDVZ6xfFz6wvBwQnsd6PsTePnD6ONk6Dg1NUbUrSKxkqeHUl8IZF66FhlhUZ/DQ9fQDq8DWqi/WdEIxlpGJUtSvU2UKKmguOKI513eGNIhsNUqRnMkwOR6pcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744205055; c=relaxed/simple;
	bh=PFs3VG7H++i7xhAZOU6WF3WI0KCOK82biTLVwM7iaeo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Td/0HNgqzL9ppGeaAKpMTbGGsFslCE+Ee5VmCI0/V+zK+aiEB0JmHCtgFlGR8cQTLlDSb4XKASd0Vy0ZWFygVUMTiIroDeFcNxpKBq0P1n7sZ9g94yjpgYTd6u7hpvcSUHO97Ydneuf3idqcnBaijaDHbV4KOaanGFPCpYfAmBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O5LV32MN; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-476a304a8edso66389741cf.3
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 06:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744205053; x=1744809853; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lXBeAx0wLPBG/MmLAS2cUA6BoFZDQW8/EIEAEmxMPl0=;
        b=O5LV32MN1HJ3ptk272pXxMhZzujFyJgZqoOtKmmAKLn2k3rSdSYq9ltKe6/mp2+tPR
         JqA2nfqrirvGVRej4doa9RsiVXKIyfP77QFA9whxbzhVOFy44VrbsyVicPwjnhaTo4xz
         84WGeoJwKQn6fC7EVDrM4ttQBJL7TNsTHEAL2zzp8JmSjSLOLUN20GQRrOyJjIqL3j1R
         xsurBGjpHvcL1nletRh5W/7JGVf/WU2lPpCBE6gZHfEbI7zYstSrNhx1FIXZEkxPMYtp
         Whb2iWsQ5XP1BKdNKrpjl+uC11ucCLRD7i+S+TDyizDkDn30anJThmrzqZMV4YJ0V0va
         SpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744205053; x=1744809853;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lXBeAx0wLPBG/MmLAS2cUA6BoFZDQW8/EIEAEmxMPl0=;
        b=nL7DuHXCs20//T0cbUE4DXGKQvtrpo95KGBZ3jWENxsKpaRPcVi7FNvLqrvO2lWilE
         gbW3Rp+S0uXCNmPG/oyZt2pqGMG886zqFcidpoqd13HnLJW3Gd4m/wP+9iYAcw24gNoY
         NVs13GgeKPwKHjD729unqNA9hpLbcgfV1FQlp8V6up4oyOcG0OHhSyB6zWy2RMSA0zhS
         WEYUh99f8Y56V94uynkdtxkdJwrIkkazrXWNKrkLHK+BZxW1Hjy9nZIQtaD5YM6lTtIS
         HmdnMbC/QcZYO+LuOClgUk9wIo6RYC0SwOw1b/wQu3NAHfHhvs4KRqYNfwxX2H3o8qvJ
         R5DA==
X-Forwarded-Encrypted: i=1; AJvYcCVutETtyvCaeBbL5P8chj+VRGzmMqXYix1xC48uuqy42RQATzrUQfhsksDNKbITk1gQYUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxFt6wuBc9ymMl1X/viEGI1FmcPKcr34Q8lvzJAN/z/sJL8keB
	j0eQIs4MA/wYyN1UTO7kkkTrUynN2k7OB922+Jq9odNyC6HELfkYXgQfVxgOT+lB+cisLd5NOS2
	gcCNztdDCpX/YgURSeJ6gJqUfAy8=
X-Gm-Gg: ASbGncsb7E39oZfKgfjnjjmUkoRykgOF3CimmKhqUhYZDoDogxShjsGQT4VJlC8tX8I
	l0Zh0tEpwOcg0Wu1EDcxOr2nheIgfaBdeKnqLMCB0Ql4yTXqn48j3oAps0JOg764C7YxK6IglG5
	oHtnNhoqAohLKBwacKNVJG1Hk=
X-Google-Smtp-Source: AGHT+IHZwOVDL8nORR7g/992bFdSC6fZtSeNZ409Rv8UFyxtSQ3CiwTmUkdhZn+2eURxC+d1L8B2B5yOPfypUnMq/QA=
X-Received: by 2002:a05:622a:11c9:b0:477:cb9:13b0 with SMTP id
 d75a77b69052e-4795f2b664bmr33860541cf.7.1744205051718; Wed, 09 Apr 2025
 06:24:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Date: Wed, 9 Apr 2025 21:24:00 +0800
X-Gm-Features: ATxdqUGJVLpu1xV2DPKsmxN0x_CuNRi629LzHQktq_XCpfIMXdaI1wJf88wbIIE
Message-ID: <CALf2hKtf529apzVGL=F-k_G_Ou8ucCdo6CNhJwp=dM-oV1Lgsg@mail.gmail.com>
Subject: [Confusing Bug] A Long-running Syzkaller Docker Crashes Host System
To: seanjc@google.com, pbonzini@redhat.com, 
	syzkaller <syzkaller@googlegroups.com>, kvm@vger.kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Syzkaller Group and Linux Kernel Upstream,

I am writing to report an intermittent issue that appears when running
Syzkaller inside a Docker container with privileged KVM access. The
host system becomes unresponsive after prolonged fuzzing, and I hope
your insights can help identify the root cause.

Environment Details:
- Host Machine:
    - OS: Ubuntu 20.04.6 LTS
    - Kernel: x86_64 Linux 5.15.0-136-generic
    - CPU: Intel Xeon Platinum 8268 @ 192=C3=973.9GHz
- Docker Container:
    - Base Image: Ubuntu 22.04 (qgrain/kernel-fuzz:v1)
    - Syzkaller Version: commit 4121cf9 (20250217)
    - Startup Command: docker run -itd -p 29400:22 -v
/PATH/KERNELS:/root/kernels --name NAME --privileged=3Dtrue
qgrain/kernel-fuzz:v1

After the fuzzing instances had been running for an extended period,
the host system became completely inaccessible (e.g., SSH connections
failed). Through IPMI, I observed the following repeated log messages
on the virtual terminal:

[244053.888249] kvm [3867]: vcpu2, guest pF: 0xffffffff813008ac
vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop
[244053.938264] kvm [3867]: vcpu3, guest pF: 0xffffffff813008ac
vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop
[244053.960191] kvm [3867]: vcpu0, guest pF: 0xffffffff813008ac
vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop
[244053.992411] kvm [3867]: vcpu1, guest pF: 0xffffffff813008ac
vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop
[244075.149293] kvm [3882]: vcpu3, guest pF: 0xffffffff81300744
vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop
...

Speculation on Possible Causes:
- One possibility is that the long-term Syzkaller fuzzing workload has
generated test cases that trigger an edge-case bug in the host KVM
module. The repeated =E2=80=9Cguest pF=E2=80=9D errors could indicate that =
a specific
sequence of guest instructions is not being handled correctly.
- Alternatively, prolonged high-load conditions from continuous
fuzzing might have exposed an unhandled kernel or hardware bug related
to virtualization=E2=80=94potentially in the CPU=E2=80=99s VMX or within th=
e KVM
module itself.

I apologize for the limited diagnostic information available at this
time (find nothing relevant to KVM in system logs). The above
speculation is preliminary, and I am unsure whether the root cause
lies within the Syzkaller side or Kernel KVM side.

Thank you for your attention to this matter. I look forward to any
suggestions or questions you may have.

Best regards,
Zhiyu Zhang

