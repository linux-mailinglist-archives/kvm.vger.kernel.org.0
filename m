Return-Path: <kvm+bounces-50371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A93AE47DC
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 17:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4137118955B5
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58D626D4E4;
	Mon, 23 Jun 2025 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oL4vjpJV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1391726FDAC
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750691089; cv=none; b=Ysrm7zSeMgzrvrt2fGdWVeXCkdEIqEvb5vVd8l5DfjduC/r9PJlYegL4hnxaZfHVomS1QW9Pj1YacF3K7t8pdb3cYtsbL4ndud2XYTO04kqGpLdnM22b9qF03tCQYwDpGbPF+w7eIRK5JrGyMuWvKhiev5WUx8G48HRSbhLFy/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750691089; c=relaxed/simple;
	bh=ZMZAInAzf+Fcqm13AffiNxXU6UCwaSpJHgmy13UdkeQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HW7sDz3kUJVFsqmevTUaTbx0UhM26f7G+1RjQkNWWiHAwzvzObYZ7CYAamyFbMubwNCd4Ohtu+n2qoo0UmQd4ciZcm4uHqjk/uNt7LEVI4u9iPvBK9kzuKeW0J9bdKK+lpnhokf7arrC7zqTQdbS5BARAKuhcWZZZbTme+K/DoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oL4vjpJV; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a4f379662cso3552448f8f.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750691086; x=1751295886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8zMI2s6Y6MpClbneq9AHqx2k+dCWAsICo/Yr3AGJ9s=;
        b=oL4vjpJVZXCGth5QvnTxtDA90Ivm9kCr48OaKaAc95TPeSnjdsRqXbpexhLLOVMQxe
         gFrtNHA5EiPy3f+UeDoCOPH59c4a9UK7L9Zn1kPhxpwuWV77iqiTT2+fRVA4OB6j/x/U
         ZmjoFCBGRgRygxR233d+4W/QN3Bwou7nPjbvVMTfoE/7gOmNSKUu2/n9G8BrCXfk8BjM
         N16rkLkZgnJq5fJlmRiPrDSO4IAVs5lmxJmGTYrc7Pn0N6HxlzoQlMMk+n2CJ4yg98BV
         kfGR+FICAfxrRVmI2nwxlsQFDE5U8LQPKqpJR7etk0D1btaZH8IhK2HchYAmq3sr0+Qd
         8wSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750691086; x=1751295886;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V8zMI2s6Y6MpClbneq9AHqx2k+dCWAsICo/Yr3AGJ9s=;
        b=qKPOsMslpmyeMOYzwICH7B7aH9FJPiEvgffaPZe0TfZBGb4Zt79GtdBy264PNLc+2p
         MdQjrEIJ9lmPAFDHvWs896Oh32gpCG1xeS9TGexFVAHuygaQHjVla/POYZH2tx5H6Bsf
         bfs0wYBqFPVjDuIaPoc0ddUrqZE4vL7ZREz9/e6PvabUIsF4a+NYMr7XBOw43xzVGtoS
         KzVhOs+ceucvW6FPzG3PW1SlkzHSNB+qGhnMXE/tusnL+PnSoIys/c4tFRzCRjC0GmF9
         rdEuCbw5kucl6apduaX7cWzcqqFGJxRJCKWbcnr6AcJkjRMLvX8G/tJKSC4h8erceOEC
         XUKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsX+Nxr/R7zu+fdnIKkbFVRxX4t/mNzT6xb4NQGobWLS3hOE2LbHATrfQcb/YDHsABKV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTvhv4Xurg9uDuVavUg7kk3XAjurRiXbbB3TT52MkWg/IfxK6P
	ERzG7c+DYngTlVz36I1jeiL64NaKlP2tWAcpFKJD0gZhThOPH3T63afgQhpEEQtVQD0=
X-Gm-Gg: ASbGncvR1tJwZdiOJwvKoUV/3alwN0nqACIxel7MFl3x5tlFBBG2QQIQtl06q+qJeLS
	KIxOUFuRuYv3Q0n46OdmvuHBHg9bWI6Wz5/x8J5KjJ+COiZlJBaOKTYbRpe0WXX+H8/hqYY8uf4
	u8joHeKTYueGiAIAOV6wKs3bYKNBmffDcvXqID0BjswQMJRGovHZgzN98imeWzm3Iw+e4bPLReg
	PnT8U4TgGsRd7BltZm529GGmLurQhmq27SB+vV63KUriBiCKuZgTrq83DMQ3etNEe355w/0ndaX
	kDzUf2FRQVBH1UwAy3O3+hgvUr4/1Q4Syg/XpSPKdiTGrG2ix3KMj0zy81kiTaY=
X-Google-Smtp-Source: AGHT+IF81vENs0EgcK259ls/C3BBEjJyA7ZVfvf/sID9WFrwkOQ+AYgC28uslSdud8D7fSIs4GtErw==
X-Received: by 2002:a05:6000:4906:b0:3a4:f661:c3e0 with SMTP id ffacd0b85a97d-3a6d12e6a3emr9777983f8f.45.1750691086171;
        Mon, 23 Jun 2025 08:04:46 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d1193792sm9790132f8f.97.2025.06.23.08.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 08:04:45 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 0B6EA5F815;
	Mon, 23 Jun 2025 16:04:44 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
  qemu-arm@nongnu.org,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Roman
 Bolshakov <rbolshakov@ddn.com>,  Paolo Bonzini <pbonzini@redhat.com>,
  Alexander Graf <agraf@csgraf.de>,  Bernhard Beschow <shentey@gmail.com>,
  John Snow <jsnow@redhat.com>,  Thomas Huth <thuth@redhat.com>,
  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
  kvm@vger.kernel.org,
  Eric Auger <eric.auger@redhat.com>,  Peter Maydell
 <peter.maydell@linaro.org>,  Cameron Esfahani <dirty@apple.com>,  Cleber
 Rosa <crosa@redhat.com>,  Radoslaw Biernacki <rad@semihalf.com>,  Phil
 Dennis-Jordan <phil@philjordan.eu>,  Richard Henderson
 <richard.henderson@linaro.org>
Subject: Re: [PATCH v3 26/26] tests/functional: Expand Aarch64 SMMU tests to
 run on HVF accelerator
In-Reply-To: <20250623121845.7214-27-philmd@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Mon, 23 Jun 2025 14:18:45
 +0200")
References: <20250623121845.7214-1-philmd@linaro.org>
	<20250623121845.7214-27-philmd@linaro.org>
User-Agent: mu4e 1.12.11; emacs 30.1
Date: Mon, 23 Jun 2025 16:04:43 +0100
Message-ID: <87sejq1otw.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  tests/functional/test_aarch64_smmu.py | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/tests/functional/test_aarch64_smmu.py b/tests/functional/tes=
t_aarch64_smmu.py
> index c65d0f28178..e0f4a922176 100755
> --- a/tests/functional/test_aarch64_smmu.py
> +++ b/tests/functional/test_aarch64_smmu.py
> @@ -17,7 +17,7 @@
>=20=20
>  from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_=
pattern
>  from qemu_test import BUILD_DIR
> -from qemu.utils import kvm_available
> +from qemu.utils import kvm_available, hvf_available
>=20=20
>=20=20
>  class SMMU(LinuxKernelTest):
> @@ -45,11 +45,17 @@ def set_up_boot(self, path):
>          self.vm.add_args('-device', 'virtio-net,netdev=3Dn1' + self.IOMM=
U_ADDON)
>=20=20
>      def common_vm_setup(self, kernel, initrd, disk):
> -        self.require_accelerator("kvm")
> +        if hvf_available(self.qemu_bin):
> +            accel =3D "hvf"
> +        elif kvm_available(self.qemu_bin):
> +            accel =3D "kvm"
> +        else:
> +            self.skipTest("Neither HVF nor KVM accelerator is available")
> +        self.require_accelerator(accel)

I think this is fine so:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

However I wonder if something like:

        hwaccel =3D self.require_hw_accelerator()=20

Could fetch the appropriate platform accelerator for use in -accel bellow?

>          self.require_netdev('user')
>          self.set_machine("virt")
>          self.vm.add_args('-m', '1G')
> -        self.vm.add_args("-accel", "kvm")
> +        self.vm.add_args("-accel", accel)
>          self.vm.add_args("-cpu", "host")
>          self.vm.add_args("-machine", "iommu=3Dsmmuv3")
>          self.vm.add_args("-d", "guest_errors")

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

