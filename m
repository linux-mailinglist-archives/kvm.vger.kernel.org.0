Return-Path: <kvm+bounces-45267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E47AA7BB0
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FF331B617E9
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E90521FF50;
	Fri,  2 May 2025 21:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NCKogl3F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523D721ABDA
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 21:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222808; cv=none; b=c0n+duCviG8k7vXQE/zsqNVQQHAO+y6mx9pHPN6+yx+MqbhgRaLCBQF/c64V7rICHDy7KKBLbTFLJeKnFK+8/3XL6ncmTw9k/Np5ByTWqUiW1Zzw3/QbjLEpasvJoXjDNwb9fmaSXXPvcemuNENKqdunIV4ENvM5Dp0dl2QfQw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222808; c=relaxed/simple;
	bh=FQr+BHlQxSxBR2zipuncYisr6Ec0sQ1MPg6ilSJIAVY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gudBn1l3CZXovhoi04F3t+Iz4FaZiMMc5FsyQH7zSHfE4y1EgU912VHds8r3DObek2+WvHh9uhzVK96ov5GP/xkDIsKNs2Dlgs+peksuOCEbLiNvLGb3vqJ5po1Vy+Sl6It7v7lOZVaDCV/RftmOrBd4iLxVdTKoRf2hW/fg304=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NCKogl3F; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b00ce246e38so2581296a12.2
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 14:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746222806; x=1746827606; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2N9ldHU5FxazqlSntDy1e6IIyYJu+r433Gbvk8Qp75Q=;
        b=NCKogl3FkwnJXkxZZrO/32yQYXgdwUTQQKwsLaT6VZTOtkxCit5ROp0h+jgG9bhJTY
         Eq9oc6UU6E2neQpbFO20vogkaOBboXq+mQh9X5jQq/Qt2hOcU158ALRLf58ul1nqdOea
         tw6m2PbZR5gWdrBZkGLRtuAoS5w9r38gOtK2zsrE5wDmuobiF07nJAlB8k0dboHigoWs
         i8SZEDBCVI2PauA3GasQfZq/r8J/b/ywPd/Ya7OpR1Eg67lYHdf4urt9A2qaAX9Mh5W2
         Q5g3qk1iSMPxseNQVw2pl4xQTK8MKX6JjbszC/Wd719VKXGPxLPMX27Sh5DQ08M1M2sK
         df/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222806; x=1746827606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2N9ldHU5FxazqlSntDy1e6IIyYJu+r433Gbvk8Qp75Q=;
        b=oIV9ehlS0suIJygGTaqZm6FhYcN0Dlu9RQAgqsfWMZlSvlGnXZXvoPZ/xIGfQTLndJ
         mvJtsbXtM840okATENCM/8KowZOJkOEIO/JtsmT+4yS73+MKdMnAFBL2V3BRh+dv7Kke
         xcgm1L9e0GQ7gsP5Rp26IFumTHmSsfrk189WYyu+fR0uPYvht1kYaAEZ//3BmUKKVzgZ
         q6nU6oDZYTj7VDDFCuFXc06FXCznbCo8F3rQ37xrpk1FuQHa6C9kG7rVr30R68jHC1EK
         TlZhmtLVS+HbbDlV6TkTTnLreZDyAM/rHfHS+TWIPlG3J1aC/1PfV2tgH44v5xDTKW2e
         mSJA==
X-Gm-Message-State: AOJu0Yy72149WKJWyoycbsXNRUMrPF/BKH+p8pROeA3koM9fuoQBFTf8
	HiOUND+2U3HcBH+r5kCruQk6BJXLi6/k0NwydhTSdUoX3U5d33zw/2FIc7i+mPS9O7LlRQwhAqF
	mdw==
X-Google-Smtp-Source: AGHT+IFybCoH+yRZqSEW5GjgjMi2HGp4+sGXvvJ0+WGZDozCL6CsKNaI6/NE1ygpGpjeY4FePZ40NmVB49E=
X-Received: from pgla5.prod.google.com ([2002:a63:b45:0:b0:af3:30b9:99a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1c7:b0:220:e023:8fa6
 with SMTP id d9443c01a7336-22e1035c5a9mr71760665ad.50.1746222806577; Fri, 02
 May 2025 14:53:26 -0700 (PDT)
Date: Fri,  2 May 2025 14:51:07 -0700
In-Reply-To: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <174622213091.880948.13355437272012240115.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: TDX: Cleanup the kvm_x86_ops structure for vmx/tdx
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Binbin Wu <binbin.wu@linxu.intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 18 Mar 2025 00:35:05 -0600, Vishal Verma wrote:
> This is a cleanup that should follow the initial TDX base support (i.e.
> not an immediate fix needed for kvm-coco-queue).
> 
> Patch 1 is a precursory fix for a build warning/error found when
> manually testing the CONFIG_INTEL_TDX_HOST=n case.
> 
> For Patches 2-4:
> 
> [...]

Applied 2-4 to kvm-x86 vmx, with Chao's feedback incorporated, along with a few
other minor cleanups.

[1/4] KVM: TDX: Fix definition of tdx_guest_nr_guest_keyids()
      (no commit info)
[2/4] KVM: VMX: Move apicv_pre_state_restore to posted_intr.c
      https://github.com/kvm-x86/linux/commit/84ad4d834ce9
[3/4] KVM: VMX: Make naming consistent for kvm_complete_insn_gp via define
      https://github.com/kvm-x86/linux/commit/1a81d9d5a1da
[4/4] KVM: VMX: Clean up and macrofy x86_ops
      https://github.com/kvm-x86/linux/commit/907092bf7cbd

--
https://github.com/kvm-x86/linux/tree/next

