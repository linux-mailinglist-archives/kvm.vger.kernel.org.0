Return-Path: <kvm+bounces-59639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F0BBC4E5D
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 14:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B375A4EF7C8
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 12:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463D2250BEC;
	Wed,  8 Oct 2025 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Ul9VxAnB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B5824E4B4
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 12:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759927373; cv=none; b=G1fmQ+K4qXpfjGutqmptMZ2Gp1WkGV57kGgwNOWA+QLAdqsv90topXnuDapAD0hUyrbgGnqsZurmOZtJH2e/uieafE7FqhdBoeEOM5smOkjxrfTvgl4vJCoWV0qHqSx7U4ggkvr6k/HOtxraiM3r0qmcj/bhTr1vWtO3lWOcEgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759927373; c=relaxed/simple;
	bh=1achrQX9VgMwxqnrWluZElDIr8lUkiEBJLPNIW8+n/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Mime-Version:Content-Type; b=APNVD7T9PRpqo5BT0V2VVNLZH2KNf+krx+yDKpM4IZHJ9sJb7uzD9rpv+ZoHT/pD8CTDz1VJIVFDO+XXNr2cb8cJnEwIhKyLN0wd5IP0s3o0A6PL6tF77u1CCDSfmNPMZldI/esvyFRmGwbNx+zb9tAAlT4zhLBBixxAlSj5HXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Ul9VxAnB; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3df81b1486so149134366b.2
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 05:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1759927367; x=1760532167; darn=vger.kernel.org;
        h=content-transfer-encoding:list-id:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+WrorA5/NbVwiDAVLkXUunOrMflDUIhM9V0D4U9QYvY=;
        b=Ul9VxAnBVBMkNHLs3pTGQLke0lUqrrq9Pj2FdWqm9yEqr6RKMBvhmOb6V44cztAiv4
         4q7IsuEPtmgaNV4LaJAMV2ISamuXf7tj2N9vDBlpWF+B2zQmCG9h8bNX+KzTZ/YXOmnR
         f5nKlgByIaiY+k32fr9Y5d56vWY0wE9YG2NNC2FGbSCtzYQjvRA0Vf8t9oa7/o9RxEN4
         vAu8ZdZlpFdPra72ZbhGWT5L3vEU1A6nlpjU00TZK4YahmNIN1wXfh7om7hOJjI2/2wG
         0hBg3Ib7j/SU+Fn2Xv2XsNtUgGCY3zXlEUdmiLrxKtt/iNChwEBODzefu7OkXig188KX
         sESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759927367; x=1760532167;
        h=content-transfer-encoding:list-id:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+WrorA5/NbVwiDAVLkXUunOrMflDUIhM9V0D4U9QYvY=;
        b=pDOihjxELUMSoMk46r4SW9OReO5M3l/SoZgUAwPLiMA3NJbFTiDNRSJca9OT53HD7S
         qmfk2zveZezRvOKxXXfipWuCzUdpktRUWPqMYscYO8xoHVK7Q0AasAOX/F9w7KGg748I
         gX3fpndZezLnC3eqMGgojZ3UofF1EcZAFrkgIXENm4F4FDK/D3P7G9K5O+Zs7NAHtBQx
         svyTQ+u4JUepiX9amcZVqFly9WqsGjeHQfxZoCFvyxpHSZoYr9FFXasaKmrJOGZITFVE
         XvvjS0sA3KX3GUECiMMGJ6KwqSkWT3vrbTcS/rMAeRL5AAMTWcrOVe+qxaqDRDdf/waF
         8QJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXejpKR9/abn0b5yu4Pzp8sgI8vmAjM7W48KHkiaXkp9Eqpmr28qGjcr9BZuf/chyITK10=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+Q5wfJzNZHGtcVzfxjkUrIGh1O5qf2849m9fPJ7DZoIptCXCk
	rOarkNx5pW+87x+/G1rofiMFOSamjDq1seIr0FtLXCrhg5oDvArRxht026AHdBu2CjQ=
X-Gm-Gg: ASbGnctJba3u4SugiMNR+FPUo9o6vNCPKZ+MT7LXuJy5at1Nsw9Cnb2h9vw8V2EH+nY
	UBcCKngkLapL/rKjsKS91jYh6h7AuaOWZwfqO/BVnP6paR+96Y7UjMvz6Np8UGFxNAGzFSTX5Fj
	9kRe9u6IdwzyHgjnZ5P+0wgeUQUt2Wlm3bz1Ff58ZSxdj/3W8MIPcfbJmxqsk3hIBZudkwzcA6E
	zxMH59P32sjqHdSz4nf0C3b+OHLDBgKO5l7xkCYC/pC04xanxNAmUalEO5RfnhndvxK6V+zP+zF
	f0YpwhkyR6nAwKBGPHkyV4Fm2cXrb3Iz0mdSEMSEIzQngeCffPhOVLwfVow6oDM32ubmqg9m032
	G6JpTxD51v5fU9RQgiGjks7HFk27jlD6goF6koOMRdNuu/7N1RKDd+1kB2RU2sbfKCFmX4XqkOP
	YSCcA=
X-Google-Smtp-Source: AGHT+IE9Y5w1eWXUvMuRqYBoQJQP+tfRVBqfkg2y8UZnVnwmjOVQBILPGxBBB2lJ1dg5chpqdL3aRQ==
X-Received: by 2002:a17:906:f1c6:b0:b54:25dc:a634 with SMTP id a640c23a62f3a-b5425dcb030mr29830866b.10.1759927367318;
        Wed, 08 Oct 2025 05:42:47 -0700 (PDT)
Received: from lb02065.txl.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b408sm1635086566b.58.2025.10.08.05.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 05:42:46 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: fanwenyi0529@gmail.com,
	John Nielsen <lists@jnielsen.net>
Cc: bsd@redhat.com,
	gleb@kernel.org,
	kvm@vger.kernel.org,
	pbonzini@redhat.com
Subject: Re: Hang on reboot in FreeBSD guest on Linux KVM host
Date: Wed,  8 Oct 2025 14:42:37 +0200
Message-ID: <CACzj_yVTyescyWBRuA3MMCC0Ymg7TKF-+sCW1N+Xwfffvw_Wsg@mail.gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <FAFB2BA9-E924-4E70-A84A-E5F2D97BC2F0@jnielsen.net>
References: <6DBD3DBB-24B1-4564-B524-E8E73508BBC5@jnielsen.net> <42870B81-CA29-4161-9BCE-F6D6020C3D2C@jnielsen.net> <539F1DC0.4020604@redhat.com> <4F14D859-D641-4AB5-B749-83D9D82F1DEA@jnielsen.net> <539FC243.2070906@redhat.com> <20140617060500.GA20764@minantech.com> <FFEF5F78-D9E6-4333-BC1A-78076C132CBF@jnielsen.net> <6850B127-F16B-465F-BDDB-BA3F99B9E446@jnielsen.net> <jpgioafjtxb.fsf@redhat.com> <74412BDB-EF6F-4C20-84C8-C6EF3A25885C@jnielsen.net> <558AD1B0.5060200@redhat.com> <FAFB2BA9-E924-4E70-A84A-E5F2D97BC2F0@jnielsen.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35910 "EHLO mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP id S1751098AbbFYCk2 convert rfc822-to-8bit (ORCPT <rfc822;kvm@vger.kernel.org>); Wed, 24 Jun 2015 22:40:28 -0400
Received: by lbbpo10 with SMTP id po10so37140278lbb.3 for <kvm@vger.kernel.org>; Wed, 24 Jun 2015 19:40:26 -0700 (PDT)
Content-Transfer-Encoding: 8bit

From: Wincy Van <fanwenyi0529@gmail.com>

On Thu, Jun 25, 2015 at 1:07 AM, John Nielsen <lists@jnielsen.net> wrot=
e:
> Interesting. Using the same PC-BSD image I am able to reproduce on a =
server running slightly older software but I can not reproduce running =
bleeding edge. I verified enable_apicv=3DY on both. In both cases I ran
> qemu-kvm -drive if=3Dvirtio,file=3DPCBSD10.1.2-x64-trueos-server.raw =
-smp 2 -vnc 0.0.0.0:0
>
> Specifically:
>
> Breaks (VM hangs during boot after pressing ctrl-alt-del):
> kernel 3.12.22
> qemu-kvm-1.7.0-3.el6.x86_64
> seabios-1.7.3.1-1.el6.noarch
> Intel(R) Xeon(R) CPU E5-2667 v2 @ 3.30GHz
>
> Works (VM reboots normally):
> kernel 4.0.4
> qemu-kvm-2.3.0-6.el7.centos.x86_64
> seabios-bin-1.8.1-1.el7.centos.noarch
> Intel(R) Xeon(R) CPU E5-2680 v2 @ 2.80GHz
>
>
> Unfortunately I no longer have the test environment I used a few days=
 ago to reproduce this issue so I can=E2=80=99t verify the software ver=
sions that were in use. It=E2=80=99s possible I was mistaken about the =
kernel version (I thought it was 4.0.4). Perhaps it really is fixed in =
the newer kernel? In any case, this is great news! I would be intereste=
d in identifying the patch(es) that fixed the issue to make back-portin=
g them easier, but I won=E2=80=99t have time to do a binary search anyt=
ime soon.
>
> Thanks for looking in to this again. If anyone else is interested in =
identifying what specifically fixed the issue please let me know if I c=
an do anything to help.
>

John,

This commit may work for you.

commit 4114c27d450bef228be9c7b0c40a888e18a3a636
Author: Wei Wang <wei.w.wang@intel.com>
Date:   Wed Nov 5 10:53:43 2014 +0800

    KVM: x86: reset RVI upon system reset


Thanks
Wincy

Sorry for bump this old thread, we hit same issue on Intel Sierra Forest
machines with LTS kernel 6.1/6.12, maybe KVM comunity could help fix it.

---

### **[BUG] Hang on FreeBSD Guest Reboot under KVM on Intel SierraForest (Xeon 6710E)**

**Summary:**
Multi-cores FreeBSD guests hang during reboot under KVM on systems with Intel(R) Xeon(R) 6710E (SierraForest). The issue is fully reproducible with APICv enabled and disappears when disabling APICv (`enable_apicv=N`). The same configuration works correctly on Ice Lake (Xeon Gold 6338).

---

#### **Environment**

**Host:**

* OS: Debian 12 (Bookworm)
* Kernel versions tested: 6.1.118 and 6.12.47 (both affected)
* QEMU versions tested: 8.2.10 and 9.2.4
* Firmware: SeaBIOS 1.16.2-1 and OVMF 2024.11.1
* CPU: Intel(R) Xeon(R) 6710E (SierraForest)
* KVM module: `kvm_intel`
* Command-line (simplified example):

  ```
  qemu-system-x86_64 -m 2048 -enable-kvm -cpu host -smp 4 -hda freebsd14.img
  ```

**Guest:**

* OS: FreeBSD 14.3-RELEASE
* SMP guests multi-cores

---

#### **Steps to Reproduce**

1. Start a FreeBSD 14.3 guest under KVM on a SierraForest host.
2. Log in and run:

   ```
   # reboot
   ```

   or press `Ctrl+Alt+Del`.
3. Observe that the VM hangs during reboot — it never returns to BIOS/UEFI.

---

#### **Expected Result**

FreeBSD should reboot cleanly and return to login prompt.

---

#### **Actual Result**

Guest hangs indefinitely during reboot.
QEMU remains running but guest output is frozen.
No host kernel warnings or errors in `dmesg`.

---

#### **Workaround**

Disable APICv on the host before starting QEMU:

```
modprobe kvm_intel enable_apicv=N
```

With `enable_apicv=N`, the FreeBSD guest reboots normally every time.

---

#### **Additional Information**

* The issue **does not reproduce** on an Ice Lake host (Intel Xeon Gold 6338) with identical kernel, QEMU, and guest image.
* Collected `trace-cmd` data for `kvm*` events during both:

  * **Good reboot** (with `enable_apicv=N`)
  * **Bad reboot** (default APICv enabled)

Traces are available for analysis upon request.

---

#### **Preliminary Analysis**

Disabling APICv avoids the hang, suggesting the problem is related to APIC virtualization on SierraForest.
Possible causes:

* Regression in APICv or posted-interrupt handling on new Xeon platforms.
* Microcode or MSR-related difference in APICv behavior on SierraForest.
* Incorrect EOI or interrupt delivery sequence during guest reboot.

---

#### **Reproducibility**

* 100% reproducible on SierraForest systems
* Not reproducible on Ice Lake

---

#### **Request for Guidance**

* Is this a known KVM or Intel virtualization issue on SierraForest?
* Would you like `trace-cmd` traces, MSR dumps, or `perf kvm` data for further diagnosis?
* Is there a kernel parameter or patch to selectively disable APICv on affected models?




