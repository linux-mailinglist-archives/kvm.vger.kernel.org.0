Return-Path: <kvm+bounces-60544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE109BF23AB
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 17:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33D4A3B413C
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 15:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBAF2773F9;
	Mon, 20 Oct 2025 15:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0K46jPwF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D5123A58B
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760975501; cv=none; b=VpSjsbBrIfEcWu/HEuoFXqqui7mxebPveIGg75KXYmjEpilXOOat2x3U3cBFPGOC6sQ6ftdVCSNM+ePRUopEwHMvZbm9WSGYYrKdb1zBKYA/omQzyveWZsUQE34z7ZQ6fd56HGOnbIsPuJMBHsi9laNJKte+mkcci51SssOfofE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760975501; c=relaxed/simple;
	bh=CKoBgkqf/XEfME922InMtGklfFRfPcNzmQcSSx+gDg8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJeLcNd9cyMQGKea0FvPizvYqOmpyG1b+W7XoGEcTamMDe2HL9jiXXh+zeLJTP17tVSJlhtBhgcAZUS8Lf3I96+q/6pSM5UuRJG4rpsJsmO8UGVv+0VksdVD/n8Acs79kX4rusr71qcygmy1DVqKnzKM4IbNkhCnk2jvNeduNu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0K46jPwF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bdd0479a9so3350987a91.2
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760975499; x=1761580299; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cYUu49s1qQu/J7CEp2f/HidgNr2LRMkTfT3HoRdnoms=;
        b=0K46jPwF974WQhvq5bndoVHH/S6nY67HfxhVScQV7sBtz8O27UPpZnvKD/GbJhVpn1
         jTdVBxKyHG85ZRkFR50aJyI1rVJKbDx5qEj+sfhiwIv4rMMIM8jA2WVBhFQefeIDn2Ig
         aZZXtkaFnOHG2YaF8FENj1LQGXMjBoeyTkBiMR42FmVSS0Gy9G14Yw7yxOu8nl+fO5D+
         r7xc8glAjz2am9RRH7Cvk3cNocefXyFbFbwB4aW7dB9foxoN0H3bSS01frX7aHOlGkKp
         Z6J53PNfx0CxGhdsPtFcNxXJfa+EbhP2ryw5ju/rbaFuvFEHnInIAIaCz2+BNpUhNTuc
         2QOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760975499; x=1761580299;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cYUu49s1qQu/J7CEp2f/HidgNr2LRMkTfT3HoRdnoms=;
        b=QkpveBiXVc7ULW8i8SK49zg7tkKgFD3OAiRX6cRk4k+xWwDcTASnP9F+KuzKeSrRHi
         AHyUEg9C0oDGuZ6pou9Od7nMwbTh/20meA1JBWobGrfeaRAV1hNwpKSVIX+S+KhpGb9o
         ZWRf4XzGPYpV/mY4cTMCKFXYl+Ju0NLmkiaWNNg0e0ujiwfvztiFyYfJroSUORtl/T9/
         HLdICkw79EM5xqlOfTG9GCenxE5RjM8d7elETWgvTVovsteWmolEd3hGdr+zNf2CHOOo
         X3h4euUi84wj3C+1BUslpWaNkhHV/2JS7Bgby58pvYN460/euIH2TxnWyESiVFL9t4VD
         95cw==
X-Forwarded-Encrypted: i=1; AJvYcCU6Hb2i+AL/7/xm/7EJ64pTIfIEfnoqoDHQVhkRLT3rK9iTe8BvOcCjEULsm+WyT2WfFw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbbOeCIWGdk7JeNxDTi+mgE8J9bSLEusRHRvvqz08UsLZci41h
	YrXc2QcwxqcRj3Vt10tioyZyYlClXDTshLvL+t7q4oZcrNhYSBfpSUGOE6e69kEGzQTBFhWASN9
	cEVxo5w==
X-Google-Smtp-Source: AGHT+IEmHzJuE6dE4nrX5KbKswTjRN4AmO6OE3CoX4/WcyLoexCBYoVpnD8cbgW3LeQsrjZci0AAX2Zf2ag=
X-Received: from pjbqd13.prod.google.com ([2002:a17:90b:3ccd:b0:339:e59f:e26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d44:b0:32b:ca6f:1245
 with SMTP id 98e67ed59e1d1-33bcf85b2ebmr16254869a91.5.1760975499241; Mon, 20
 Oct 2025 08:51:39 -0700 (PDT)
Date: Mon, 20 Oct 2025 08:51:37 -0700
In-Reply-To: <176055115910.1528299.15660583671377559341.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251012071607.17646-1-shivankg@amd.com> <176055115910.1528299.15660583671377559341.b4-ty@google.com>
Message-ID: <aPZaiQR6jVTKkHY5@google.com>
Subject: Re: [PATCH V3 kvm-x86/gmem 1/2] KVM: guest_memfd: move
 kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
From: Sean Christopherson <seanjc@google.com>
To: pbonzini@redhat.com, Shivank Garg <shivankg@amd.com>
Cc: david@redhat.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Sean Christopherson wrote:
> On Sun, 12 Oct 2025 07:16:06 +0000, Shivank Garg wrote:
> > Move kvm_gmem_get_index() to the top of the file so that it can be used
> > in kvm_gmem_prepare_folio() to replace the open-coded calculation.
> > 
> > No functional change intended.
> 
> Applied to kvm-x86 gmem, thanks!
> 
> [1/2] KVM: guest_memfd: move kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
>       https://github.com/kvm-x86/linux/commit/6cae60a1f507
> [2/2] KVM: guest_memfd: remove redundant gmem variable initialization
>       https://github.com/kvm-x86/linux/commit/54eb8ea478b1

FYI, I rebased these onto 6.18-rc2 to avoid a silly merge.  New hashes:

[1/2] KVM: guest_memfd: move kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
      https://github.com/kvm-x86/linux/commit/049e560d4f47
[2/2] KVM: guest_memfd: remove redundant gmem variable initialization
      https://github.com/kvm-x86/linux/commit/3f1078a445d9

