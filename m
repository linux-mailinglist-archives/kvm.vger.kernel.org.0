Return-Path: <kvm+bounces-37965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0468CA32798
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 14:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC08E166721
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 13:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB3B20E33B;
	Wed, 12 Feb 2025 13:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dUTnMABK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C534920D4EB
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739368414; cv=none; b=HFRuvdHmTRDoBv0z3gr71PFmiDKv48CEdkr21HgIUJy7HplyY/yvrju++9mph7jKOKacf0DLcq0jqoo/R59pkUhqeoXUUTSgawBUdnr1RBvyvUqjPNJX7unnqSrc/gZoSbYqEmYMSJTv224LMucxFZ2XmBnfklMQzHR2RsaMjTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739368414; c=relaxed/simple;
	bh=NS26Wx8D1xzEYNZaDqn5VSODO2OM/RCGMmVhHQ7LeuQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QqVn+BiBQ3paIExvxnCMPw88O+ERNkNKp26lstZa+Z2Ng1QxguISjYuocNC5gTIw0jqFz9YqhWsUg4R+oAGOx24VX7ztfU2gNUN/njUIvDkvHERm26E1SnExLt9h2I/BLVbtq1V82309A6xStMd2uXM6Gk3dKKBSJqyx+c8ut3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dUTnMABK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fa514fa6c7so8982185a91.3
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 05:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739368412; x=1739973212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N/EzA4gAzllNksMJ0DilYHYamRrSZ5T/I4bo3EXOnpg=;
        b=dUTnMABKbSsp/Ol9bq8sF/etucVnSmde63ia3aU7l3/JzEyY5F7INtvO6R9UV0wMeU
         3/34TEpQW5FF4zgnu5LKw+gYQGyYfyhIeNIEryp4h1n4m6IA20uh3frMIDzDXdOjV5EI
         xTjrNj8rNZD5H9feBYy5mve0qv7QcEq616XaaeMbNjaNArGktzdrNx7rssTjaOdROq1O
         71tUtMEB7ps3wKn3ouysfCKEVp1fTfLmcgS6er6HjEfRNMS/3Ibsrhkf1mpyf8LKeB0e
         AGSuv37/i/wv2hoHPGew8BXCr4pSeJP7idIgJG+pK+t+9Pr2zBQhWsAAsPznmWZCtl0J
         sRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739368412; x=1739973212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N/EzA4gAzllNksMJ0DilYHYamRrSZ5T/I4bo3EXOnpg=;
        b=q03AZJ2pdxltZur5LmJHL5W2r7BgcfQQRqJhGeENB5WaUUjzC1z0sR+LMXf4tXDYr8
         kVu9jnqzb0vyeOWUzp7FJgzCR933vS4Yad2b/yVPz9T1CSF+mbStk1h1VzKK4BQE5oar
         I/KBCmgObN3ps2D9LjjKdQqhhsdrlZVDpa/JB7CyLi6LOo+nIUikILm4ZgXGZJzGCUqU
         YoZRe80kXV06luWECStV2ReMp5wgS6CsRxX0jqF4HF44GLlnYYkOXo5LuL8WWvJgOK8u
         Kna9XFJdpERS7yzxA4sIZme4JN1g060JmrjDUkHNDl507hP4V7A+kCzfj/eAlAqBhygk
         rTBA==
X-Forwarded-Encrypted: i=1; AJvYcCVluWb4ulYz7lKpdp65Bt1TXuqoLuatdbqLq9rNibelJ5OdEStQmTlBn4QNphYjzBhEz/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZwrosm3x66T7MinnS88/EwbLw6Z4G7seRyTv59YYkC6oZoUIL
	DAbZgaQLCguUs9CJfZmpWEFYHy6JWb5T1Ptqf2/nJMUXOPOPINbfObRn2glI/vJxk9fDHGlOW37
	yRQ==
X-Google-Smtp-Source: AGHT+IFYe3T9Oxuy4agESLPo42TBd2uH5YGxB7YW+51uoarC7Q4NcOtA9s3UjgcR+LLlG5QWXJnoYitI/cw=
X-Received: from pfbfa4.prod.google.com ([2002:a05:6a00:2d04:b0:731:43c2:88e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6ca1:b0:730:98ef:30b5
 with SMTP id d2e1a72fcca58-7322c570c02mr4336027b3a.5.1739368412057; Wed, 12
 Feb 2025 05:53:32 -0800 (PST)
Date: Wed, 12 Feb 2025 05:53:30 -0800
In-Reply-To: <4b23f7c7-b5e6-41c9-bcae-bd1686b801a6@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-7-binbin.wu@linux.intel.com> <Z6vo5sRyXTbtYSev@google.com>
 <4b23f7c7-b5e6-41c9-bcae-bd1686b801a6@linux.intel.com>
Message-ID: <Z6yn2mNYSkhlwtKd@google.com>
Subject: Re: [PATCH v2 6/8] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: xiaoyao.li@intel.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 12, 2025, Binbin Wu wrote:
> On 2/12/2025 8:18 AM, Sean Christopherson wrote:
> > On Tue, Feb 11, 2025, Binbin Wu wrote:
> > the information is quite useless because userspace doesn't have reg_mask
> > and so can't know what's in data[4], data[5], etc...  And I won't be the
> > least bit surprised if guests deviate from the GHCI.
> 
> But it also confuses userspace if guests uses special protocol to pass
> information other than ASCII byte stream.

Yes, but only if userspace and the guest aren't in cahoots.  There are use cases
where the VMM and the VM are managed/owned by the same entity.

