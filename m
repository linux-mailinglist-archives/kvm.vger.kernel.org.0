Return-Path: <kvm+bounces-65029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9CDC98CCB
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 20:04:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4CD4E4E32AC
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 19:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B66F2459DD;
	Mon,  1 Dec 2025 19:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bxqbAsGX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37A423C39A
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 19:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764615801; cv=none; b=fJkdj8UiJp35Wq0HoMUQygkpZqxOMIMeMvzCBFoHzW2dgHsBGoJTJOPOih8/f/BRNjR/BgsIJ1+u90FS2PJRJ7wfUo81R0h9In0u96DDLqM3FaZHa/W5ICDeu21YlWSBaeAj+dAiyhovXXxe86hMeN+2w7r1VG9e3V26rPUeuFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764615801; c=relaxed/simple;
	bh=A02pUgeAmvGHdrkD+rUE9fzxwZ0ZdB/gJLE7NQl0bKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gNicjmSGdhVy+NXRCLzy4qN03aZ2N5B6PN4BqjBZC2J0Zs/ZGNczjUE3F4gdvPGnXIzhi9dyB8+Kwgpnrf9X91h7YsE6d8YJdN0kdi8lHRGl63plGVp5UeBx/8WJ1udIFbg4X0QGu7bqYcrmxWJrRYCp32t6149zL3KrSZt4jkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bxqbAsGX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso4853478a91.2
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 11:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764615799; x=1765220599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pu1GzNXnswxxTsLftEUw+XLhracJ2MXZoaDjvhLvKc0=;
        b=bxqbAsGXoSmU1foLPf/desLtCh0SKDf9lh7Qt197ng36cFe2XPUvRKSUymsVvIXR7l
         AVABiGVIeWhhweZQgz5pW0/VILfBSPqFS61/eGu8GHI9M74+7+C9Pn3HG8Nuv2VpMR/Z
         CjRncz8rx+wqFmV9o5jox6HZ7iPfNbUCe/+nBdEXqeBIscHYDUpqrZOvzrq84J+UoxjT
         vM2rHCObnZwUwUpf3Eh2lFd5dyK8hJToMTj/uxNoVM7xJo4arNG9oKtEZG3LW0nt6yOV
         FkO6pjmjfE6I/MZV6d5n9rtYgq7uu6rGm0jVPF8hJPVoYnNyAzbSlFh5LfQHMIfJlyDk
         Qwsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764615799; x=1765220599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pu1GzNXnswxxTsLftEUw+XLhracJ2MXZoaDjvhLvKc0=;
        b=ufWL/5GeH+ycQgGZ++dAui5HG6nRZ8/I2Gi9+PLNnCwxDAUR24T0YtPFUDWNLU4Fta
         gnwnWEGvCbtv34zcx26cKMsUWbfv1yRywtjTgf/9dWqZ5FN8emCcQHISGS1ULKkCuHtw
         vAlbzE/qIk86oMho4DP/B+5VRJcKZqD9P/SOoMMq4ZIz6Oen1IyWsSRZ2jgTWKLwD9dq
         CcrvgCP6JSeV7qoCNwkpUMCzvZ2nT5SRlyAN9c13P7wBanZ5OcFrt2rSwpnsH4Z5wKsN
         r38tJjOBgLYFTJnKVCz1PJg1stNeb/tStJdNEll/vyDoW1Bu/nCQVE53UwS2gLgH1cli
         jlzg==
X-Forwarded-Encrypted: i=1; AJvYcCVegMvZCqIjxzzzx6L0oJRIOXvLk0XlemdkpRDoK/NmTiGsjDWiWGQhFJqzHR4XDtZDKbA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0KlqUb+4Xq18AxouvO0vYSS6OFOYFIieYQIBfE3B5iAayzYwu
	4BTohEtgq8yp4pLbTFTtQNB4dRRWW+cRbUxB+EUAaiIflrsAYT0QlaqpneY3u2h/JjqDCQGQZIA
	H2ajwpg==
X-Google-Smtp-Source: AGHT+IHw9VmBXKW6XOZT+mg91gy7vtZGKPdp6G91jlZ3D2sj3sZdSq0tnxgxwv4nwAIngjMF9zWWrrDYxko=
X-Received: from pjst20.prod.google.com ([2002:a17:90b:194:b0:347:2e36:e379])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:578c:b0:341:2141:df76
 with SMTP id 98e67ed59e1d1-34733e734f9mr34267712a91.13.1764615799118; Mon, 01
 Dec 2025 11:03:19 -0800 (PST)
Date: Mon, 1 Dec 2025 11:03:17 -0800
In-Reply-To: <20251127001132.13704-1-redacherkaoui67@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127001132.13704-1-redacherkaoui67@gmail.com>
Message-ID: <aS3mdTKmTFIpc3ye@google.com>
Subject: Re: [PATCH] KVM: coalesced_mmio: Fix out-of-bounds write in coalesced_mmio_write()
From: Sean Christopherson <seanjc@google.com>
To: redacherkaoui <redacherkaoui67@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	redahack12-glitch <redahack12@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 27, 2025, redacherkaoui wrote:
> From: redahack12-glitch <redahack12@gmail.com>
> 
> The coalesced MMIO ring stores each entry's MMIO payload in an 8-byte
> fixed-size buffer (data[8]). However, coalesced_mmio_write() copies
> the payload using memcpy(..., len) without verifying that 'len' does not
> exceed the buffer size.
> 
> A malicious

KVM controls all callers.

> or buggy caller could therefore trigger a write past the end of the data[]
> array and corrupt adjacent kernel memory inside the ring page.

True, but if a caller is buggy, KVM likely has bigger problems because KVM relies
on MMIO (and PIO) accesses being no larger than 8 in a number of locations.  If
we want to harden KVM, kvm_iodevice_{read,write}() would be a better place for a
sanity check.

