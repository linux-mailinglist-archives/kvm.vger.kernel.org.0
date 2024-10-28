Return-Path: <kvm+bounces-29883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ADEF9B38FE
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 19:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5F94B2248F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF971DF98B;
	Mon, 28 Oct 2024 18:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tc5d8MxS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B011DF251
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 18:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730139625; cv=none; b=sGvi6vz1PRl8unt1QtBmqSdjeHwmmRa+sa59BP/KvXHeS7y/66Gx90Ed1cJs5/cuybVD4WzW8xaKe8lNO6Kq1ZNd+jrOGTEy6uZPJWMp8RsARG61KwH1ZfZ4jSYiyfpAGPaYDzwIZawNwDoa6F6SXpbCLXXI6PTU5QF5dzMmqJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730139625; c=relaxed/simple;
	bh=lH79W0uMbqi4yKZO5aZMPWy4AfJYjDaphUfhMP+ya0k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p7DJugjdgc2+VYgrdjyCsTJtetPhu08UBGcwqtngaWJ7wQ+nr9ID3KHsj7rAfKI5RO2hs+ec9D4gmAtjlbRz622iZRLcxGeihacxz/drxUHsocSCE8Wwl3qtU4VM3lX8cNNHWPCwOWfkywd3/se/orS3aWPFcKHGhXIokqlccDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tc5d8MxS; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30b8fd4ca1so784335276.3
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 11:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730139623; x=1730744423; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nJX4y1SwBFlqpYhxsuhY42rX3MFJuIm/9BwAllYm8WA=;
        b=Tc5d8MxSoPIPgtRt+NJfUjdH4drZjGt+EMhYgbPW8f/eh2y+BOS5S12GL2TIW2hYxe
         zJDqJF3ZFPI9kIPKB5u7R3Wf07hTkrm2AusSRkW1IA9Cj/DQX+dcBknwAE1q8oiB0aRw
         k2HReaYW4eZLP9UYRtwXgKMHhzNHEk+APJxtPimEPqLZv5VMQBLXxNp14M4MP+aSe7HK
         8X9oY4kino0jWxkrpLAcRjgOaccYDnxjNbuNwRBpsaDWstHXmd8MRoFCSR4weHZj6J1Q
         4w924rhxpGjUdw+DOLjzqHqgSQr5l4zVqb/9E+iQhtX2GyYgHXAcCaJcpz+HZCY7ZlFU
         zGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730139623; x=1730744423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nJX4y1SwBFlqpYhxsuhY42rX3MFJuIm/9BwAllYm8WA=;
        b=UR/2X//TgceEa1fFcYBKyMWECnMVB6pLHkYg2k+rE33EqwgNa3ZXg6FGQhR7NX6KcZ
         XISemdvwuxsipbweP01mZj+eSAHHiVqtx7ADwTnHXvyp8oGaoGo3FuEFuJ+s+weFBBGu
         6fGOWr+TFcUMNGCQ3ANJ6GQmj2ksJWgWCOLvMbxt7XHybW5JzcDVdl9HVksSgme18ZPB
         E/vfHdFgaXjza2Ouk97xqT4/4Ki0FCB/mrgfvSCI+859c+2De6POZWY8X+x+2vjfZngZ
         cKrE4MUtz5xR2+9tTfUmbxsqWlDVqqJqtxYbhuHUOqnw/rzyGqR71JPsZCTc5XTN1XuU
         zpBA==
X-Forwarded-Encrypted: i=1; AJvYcCWODbSZEwzXKUZpTNmcR6wIYyt1CW97z4rq6uxeS3HGpc4UwWa8pMgprKBLPCEAZL0Jxjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN+/zsL8tQj7b8XgqC/7fmfNVqwMNEGhdz5uwsonYDTZPMfbvU
	VzWVfTq1Yjsrpdeeu8AH62xzCGPy07IPbZCZosWto9j+G1UchDj4fmOci6JkpcbkWSP2bYvIUeh
	I2A==
X-Google-Smtp-Source: AGHT+IFXrnGi8zCOlqbG2xXq8xFgLUpq2KxOh8G6ohInFjQzOCfOhTsZHU2ciqujNv6S3Xkjq8hOwwr3c9g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:844e:0:b0:e30:b813:ca60 with SMTP id
 3f1490d57ef6-e30b813d0a8mr995276.1.1730139623094; Mon, 28 Oct 2024 11:20:23
 -0700 (PDT)
Date: Mon, 28 Oct 2024 11:20:21 -0700
In-Reply-To: <CAAH4kHZ-9ajaLH8C1N2MKzFuBKjx+BVk9-t24xhyEL3AKEeMQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-5-michael.roth@amd.com> <ZnwkMyy1kgu0dFdv@google.com>
 <r3tffokfww4yaytdfunj5kfy2aqqcsxp7sm3ga7wdytgyb3vnz@pfmstnvtuyg2>
 <Zn8YM-s0TRUk-6T-@google.com> <r7wqzejwpcvmys6jx7qcio2r6wvxfiideniqmwv5tohbohnvzu@6stwuvmnrkpo>
 <f8dfeab2-e5f2-4df6-9406-0aff36afc08a@linux.intel.com> <CAAH4kHZ-9ajaLH8C1N2MKzFuBKjx+BVk9-t24xhyEL3AKEeMQQ@mail.gmail.com>
Message-ID: <Zx_V5SHwzDAl8ZQR@google.com>
Subject: Re: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
From: Sean Christopherson <seanjc@google.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com, 
	liam.merwick@oracle.com, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Chao P Peng <chao.p.peng@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 13, 2024, Dionna Amalie Glaze wrote:
> We can extend the ccp driver to, on extended guest request, lock the
> command buffer, get the REPORTED_TCB, complete the request, unlock the
> command buffer, and return both the response and the REPORTED_TCB at
> the time of the request. 

Holding a lock across an exit to userspace seems wildly unsafe.

Can you explain the race that you are trying to close, with the exact "bad" sequence
of events laid out in chronological order, and an explanation of why the race can't
be sovled in userspace?  I read through your previous comment[*] (which I assume
is the race you want to close?), but I couldn't quite piece together exactly what's
broken.

[*] https://lore.kernel.org/all/CAAH4kHb03Una2kcvyC3W=1ZfANBWF_7a7zsSmWhr_r9g3rCDZw@mail.gmail.com

