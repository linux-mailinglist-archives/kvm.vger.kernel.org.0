Return-Path: <kvm+bounces-66289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6FCACCDEDC
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 00:26:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 576AF301D9F1
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 23:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B102BDC03;
	Thu, 18 Dec 2025 23:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Shh8AMFU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0AD2877DE
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 23:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766100392; cv=none; b=gaFasfuF3csVJZbsPIECL0Gx7qCI9qLoWYlxiklKG1ypvuOciY/YAwJpblYJJoOLuMLYHBYez7ZIuwTh5Cvx2rMIP9C3HgAdPt9ijQ7yftGNBytknDY0vr+i7Vj5o26wXL0r0+weE+cX3Ta60celdPrW4G/YEpnM+k/77yFgJ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766100392; c=relaxed/simple;
	bh=E1oTLFByAoH1HK8Z6UqYN7q/ITy2oTP4LQ1DypsCyrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bpmuo7GHZDJB09x2DImPbC3s/7PkZLBbvkiljNhdqfps/iQYNd3aoquDKJ6I5QBvXKUiK2K8y+gZQa48pPCkNSMoKE6Tp2mSn1jJHUnd1JsYWPyqyPya3GwFtwWZaZzdkzWz7u2OnHAF1FSkcyQzOHP8znZY9ZIBe8PEfOpbXZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Shh8AMFU; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so1585284b3a.2
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 15:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766100390; x=1766705190; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YSafY9ekhvlDGN1P53uKSBvaDR1S8x/NREaGerJYSyc=;
        b=Shh8AMFUNeHQ8vulvCasLdXKSyrl4D95pHvZmwOhFFbTdLvxArLR1LK2UMsjzpGiFc
         sjM+q5bSjRtlbxT1xpCfiW+TFsQ3mi9fWwdyOjrtEgNMOKBkEmIJMNZj7nYZ6ZUeF3Ry
         vGYe2J2MYGDfFAywCA7m821VporiOCj42pbAyRNlk0quGWprQbFdSWzJf/TfU7uQ/Vh/
         xlorJ0o2PKvq6c1uYx4PnORGJAQqzQ4WwIKgRaH4yL2XTGffi16lJWDIdeq5cp2C5TLb
         lLPIPQ9A+8/6++0IDg4hpkQOb8Nu9G0gTwoW6EIDSBqKYMbnM3yywjeNHnRgqrOMGF1V
         QDcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766100390; x=1766705190;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YSafY9ekhvlDGN1P53uKSBvaDR1S8x/NREaGerJYSyc=;
        b=UYUor1v8Rm6MmtDGIqct7EBaPvhpJNx8NKEhLggIOyaRN6hcN10u7lYxMtLrItvjQp
         gbTM7/jlApW/3gdtS63kHVmOcLIDi58wAY0AvlLM92oeukuRKMb4y8924uQciQOCu8ds
         hxsrhsYvqDj8BPAJ4YIsM8MY5LgcsAcAaIh0dOhjVN7JAhzlM/ndhjkQ7tdqqKMWos4Q
         9hHXiELnX3KNR9QDSDtbjuwMba0TJqg7H1s4JF9om7XaW2Qinqx7MZrseGPiYVe+iX+Z
         ZCpYWXUYzURbLDuMdttPv/4B9yJiKZsUXBW77Ub3iJHVib67uBA1Rwy9TEWZf6AkhN9s
         FCDw==
X-Forwarded-Encrypted: i=1; AJvYcCWOwoJZyBOX9mWJgVPvM+R/Oy92Xl38vm+7Av33Ne4RR6HtJD30bmJ8AyhvBgr2w5Hd5+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLzCeOMFni+fzGfTbS/JwmcKsDdCIK+s00tu+s+8mTwS5mKU+r
	EVONqPl7XADrx2bFjyBsS33Wh+ao4C4NBlDVeVxJjMQvy/ayMyN3DfPnyRrWRQLN9Q==
X-Gm-Gg: AY/fxX4Uxgi7A+N9jT8vSeI0AIaOC9lmqS466BHaaUaEa0TVc/sZSYlMqQM0+9Bi4HJ
	1ExknguIVuRbpfyisRuONnc/S6pNnVh7DPr6ohGmE9psPZEbluqdOowtGSU1LjRpapbpwyQ9Wu9
	nMQyL7R7Cwe9/2uigFmAZzYiHBgQLlNMO66RcrZpyfATii45HuR7z8si5+K9k8gxuC4k3rtV9za
	emrfXCOuyf6pmTT6nhI4mlrE1tQspFm7AVAAWFrejsTn/ooIQuAt8vJkGWXw3Rghb4+xQh/39eG
	oNzOheu+P5GLqsNST+XZSGTvFDwACZRe4g0Rjq1MhY+Ni6FVEnjVcT2deLn6BgqK5CFyCvsSGaR
	tFCzmyeiTXgbuEzOV6J5AqZEkkZ/4sVsC6fYTbbI1llsw63aKpU0j5Xi191+chiCSXVr96nQ3zu
	1a1uuI0DbB64X9df1w4BJ+eWlhUooh1UsjtL+JY2PDknv8gVuECQ==
X-Google-Smtp-Source: AGHT+IFRV2BjdNwaMYD8x627RpPB3lQF/ELZXS2VxAV/XnLYZeEn9I9A5pq6i1/VqqYKxz9Z559LjQ==
X-Received: by 2002:a05:6a00:301f:b0:7aa:4f1d:c458 with SMTP id d2e1a72fcca58-7ff657a303bmr827104b3a.19.1766100389450;
        Thu, 18 Dec 2025 15:26:29 -0800 (PST)
Received: from google.com (161.206.82.34.bc.googleusercontent.com. [34.82.206.161])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a19besm382630b3a.40.2025.12.18.15.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 15:26:28 -0800 (PST)
Date: Thu, 18 Dec 2025 23:26:24 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] vfio: selftests: Add tests to validate SR-IOV UAPI
Message-ID: <aUSNoBzvybi24SUD@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-7-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210181417.3677674-7-rananta@google.com>

On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> Add a selfttest, vfio_pci_sriov_uapi_test.c, to validate the
> SR-IOV UAPI, including the following cases, iterating over
> all the IOMMU modes currently supported:
>  - Setting correct/incorrect/NULL tokens during device init.
>  - Close the PF device immediately after setting the token.
>  - Change/override the PF's token after device init.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

I hit the following kernel NULL pointer dereference after running the
new test a few times (nice!).

Repro:

  $ tools/testing/selftests/vfio/scripts/setup.sh 0000:16:00.1
  $ tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test 0000:16:00.1
  $ tools/testing/selftests/vfio/scripts/cleanup.sh
  ... repeat ...

The panic:

[  553.245784][T27601] vfio-pci 0000:1a:00.0: probe with driver vfio-pci failed with error -22
[  553.256622][T27601] vfio-pci 0000:1a:00.0: probe with driver vfio-pci failed with error -22
[  574.857650][T27935] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  574.865322][T27935] #PF: supervisor read access in kernel mode
[  574.871175][T27935] #PF: error_code(0x0000) - not-present page
[  574.877021][T27935] PGD 4116e63067 P4D 40fb0a3067 PUD 409597f067 PMD 0
[  574.883654][T27935] Oops: Oops: 0000 [#1] SMP NOPTI
[  574.888551][T27935] CPU: 100 UID: 0 PID: 27935 Comm: vfio_pci_sriov_ Tainted: G S      W           6.18.0-smp-DEV #1 NONE
[  574.899600][T27935] Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
[  574.905104][T27935] Hardware name: Google Izumi-EMR/izumi, BIOS 0.20250801.2-0 08/25/2025
[  574.913289][T27935] RIP: 0010:rb_insert_color+0x44/0x110
[  574.918623][T27935] Code: cc cc 48 89 cf 48 83 cf 01 48 89 3a 48 89 38 48 8b 01 48 89 cf 48 83 e0 fc 48 89 01 74 d7 48 8b 08 f6 c1 01 0f 85 c1 00 00 00 <48> 8b 51 08 48 39 c2 74 0c 48 85 d2 74 4f f6 02 01 74 c5 eb 48 48
[  574.938080][T27935] RSP: 0018:ff85113dcdd6bb08 EFLAGS: 00010046
[  574.944013][T27935] RAX: ff3f257594a99e80 RBX: ff3f25758af490c0 RCX: 0000000000000000
[  574.951857][T27935] RDX: 0000000000001a00 RSI: ff3f25360038eb70 RDI: ff3f2536658bbee0
[  574.959702][T27935] RBP: ff3f25360038ea00 R08: 0000000000000002 R09: ff85113dcdd6badc
[  574.967544][T27935] R10: ff3f257590ab8000 R11: ffffffffa78210a0 R12: ff3f2536658bbea0
[  574.975387][T27935] R13: 0000000000000286 R14: ff3f25758af49000 R15: ff3f25360038eb78
[  574.983230][T27935] FS:  00000000223403c0(0000) GS:ff3f25b4d4d83000(0000) knlGS:0000000000000000
[  574.992032][T27935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  574.998488][T27935] CR2: 0000000000000008 CR3: 00000040fa254005 CR4: 0000000000f71ef0
[  575.006332][T27935] PKRU: 55555554
[  575.009753][T27935] Call Trace:
[  575.012919][T27935]  <TASK>
[  575.015730][T27935]  intel_iommu_probe_device+0x4c9/0x7b0
[  575.021153][T27935]  __iommu_probe_device+0x101/0x4c0
[  575.026231][T27935]  iommu_bus_notifier+0x37/0x100
[  575.031046][T27935]  blocking_notifier_call_chain+0x53/0xd0
[  575.036634][T27935]  bus_notify+0x99/0xc0
[  575.040666][T27935]  device_add+0x252/0x470
[  575.044872][T27935]  pci_device_add+0x414/0x5c0
[  575.049429][T27935]  pci_iov_add_virtfn+0x2f2/0x3e0
[  575.054326][T27935]  sriov_add_vfs+0x33/0x70
[  575.058613][T27935]  sriov_enable+0x2fc/0x490
[  575.062992][T27935]  vfio_pci_core_sriov_configure+0x16c/0x210
[  575.068843][T27935]  sriov_numvfs_store+0xc4/0x190
[  575.073652][T27935]  kernfs_fop_write_iter+0xfe/0x180
[  575.078724][T27935]  vfs_write+0x2d0/0x430
[  575.082846][T27935]  ksys_write+0x7f/0x100
[  575.086965][T27935]  do_syscall_64+0x6f/0x940
[  575.091339][T27935]  ? arch_exit_to_user_mode_prepare+0x9/0xb0
[  575.097193][T27935]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  575.102952][T27935] RIP: 0033:0x46fcf7
[  575.106721][T27935] Code: 48 89 fa 4c 89 df e8 88 16 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[  575.126178][T27935] RSP: 002b:00007ffe991aff40 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[  575.134457][T27935] RAX: ffffffffffffffda RBX: 00000000223403c0 RCX: 000000000046fcf7
[  575.142301][T27935] RDX: 0000000000000001 RSI: 00007ffe991b1050 RDI: 0000000000000003
[  575.150143][T27935] RBP: 00007ffe991b0ff0 R08: 0000000000000000 R09: 0000000000000000
[  575.157985][T27935] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffe991b1768
[  575.165829][T27935] R13: 0000000000000016 R14: 00000000004dd480 R15: 0000000000000016
[  575.173677][T27935]  </TASK>
[  575.176573][T27935] Modules linked in: vfat fat dummy bridge stp llc intel_vsec cdc_acm cdc_ncm cdc_eem cdc_ether usbnet mii xhci_pci xhci_hcd ehci_pci ehci_hcd
[  575.190930][T27935] CR2: 0000000000000008
[  575.194960][T27935] ---[ end trace 0000000000000000 ]---
[  575.204004][T27935] RIP: 0010:rb_insert_color+0x44/0x110
[  575.209336][T27935] Code: cc cc 48 89 cf 48 83 cf 01 48 89 3a 48 89 38 48 8b 01 48 89 cf 48 83 e0 fc 48 89 01 74 d7 48 8b 08 f6 c1 01 0f 85 c1 00 00 00 <48> 8b 51 08 48 39 c2 74 0c 48 85 d2 74 4f f6 02 01 74 c5 eb 48 48
[  575.228796][T27935] RSP: 0018:ff85113dcdd6bb08 EFLAGS: 00010046
[  575.234729][T27935] RAX: ff3f257594a99e80 RBX: ff3f25758af490c0 RCX: 0000000000000000
[  575.242572][T27935] RDX: 0000000000001a00 RSI: ff3f25360038eb70 RDI: ff3f2536658bbee0
[  575.250414][T27935] RBP: ff3f25360038ea00 R08: 0000000000000002 R09: ff85113dcdd6badc
[  575.258263][T27935] R10: ff3f257590ab8000 R11: ffffffffa78210a0 R12: ff3f2536658bbea0
[  575.266105][T27935] R13: 0000000000000286 R14: ff3f25758af49000 R15: ff3f25360038eb78
[  575.273948][T27935] FS:  00000000223403c0(0000) GS:ff3f25b4d4d83000(0000) knlGS:0000000000000000
[  575.282741][T27935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  575.289197][T27935] CR2: 0000000000000008 CR3: 00000040fa254005 CR4: 0000000000f71ef0
[  575.297046][T27935] PKRU: 55555554
[  575.300466][T27935] Kernel panic - not syncing: Fatal exception
[  575.345557][T27935] Kernel Offset: 0x25800000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  575.362075][T27935] mtdoops: Cannot write from panic without panic_write
[  575.368795][T27935] Rebooting in 10 seconds..

I also have the following diff on top of your series to fix the other
bug you found.

diff --git a/tools/testing/selftests/vfio/lib/sysfs.c b/tools/testing/selftests/vfio/lib/sysfs.c
index 5551e8b98107..d94616e8aff4 100644
--- a/tools/testing/selftests/vfio/lib/sysfs.c
+++ b/tools/testing/selftests/vfio/lib/sysfs.c
@@ -40,7 +40,7 @@ static void sysfs_set_val(const char *component, const char *name,

 static int sysfs_get_device_val(const char *bdf, const char *file)
 {
-       sysfs_get_val("devices", bdf, file);
+       return sysfs_get_val("devices", bdf, file);
 }

 static void sysfs_set_device_val(const char *bdf, const char *file, const char *val)

I'm not sure which exact test case triggered the panic. This is the only
test output that made it to my ssh window:

  TAP version 13
  1..45
  # Starting 45 tests from 15 test cases.
  #  RUN           vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match ...

