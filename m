Return-Path: <kvm+bounces-36618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FBAA1CE11
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:17:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ECAB1645F4
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 19:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 774CB18C011;
	Sun, 26 Jan 2025 19:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iBl9qFtS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA9F175D4F
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 19:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737918992; cv=none; b=Tn/Ub0lvK77JjFwr1hFQlpbIpIqykaiv9sUtNYI7Ki0Jnd8SQ4Q8qEuJ889gsO+iPhKNH8JmtD4WFvkHb7aZ34KDrGa5hr7GwrrythUnnvO54nbCj1nfLr3g/6kAeBnFpAXMXD5hnFefhjUz3R3mDx32iejuSPgldYgsO4NneGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737918992; c=relaxed/simple;
	bh=Hjci5Yj/DhyJbz9jPbWI5GGgR4A/Wn9P/nGNTFqxF/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=er/xAFBDFaj5IKF5V+clgU3DJ+H360PAm6BVUPvZszBpvCPj8plOf63EosgyvjYUIErdV2ayXzVO7xOQag55n3Lzhh59oedW1Xm5ZQee/0wmfRpIXAqm/Nd0fyjO5Lgs0CmKviu+nyAaoIypkVLr7dgkBhlrKafBuWfFicDL7Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iBl9qFtS; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aafc9d75f8bso710084266b.2
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 11:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737918989; x=1738523789; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mITLPPRJTc8HEWj0M/ACR6IgmCVo1uY/1TdIPvwxqc8=;
        b=iBl9qFtSOB4uVUSdmaC/hp4cWBcjqYTicht3nvcP5XaDIRg9/qjNgubGyFcrCdREJY
         2d5HRAcujM7uzuQ2lw4AZEWaikPiFoQ4T1poS4fr+v/RXN1J/f1xmaZUflRlul5wi2eK
         9KiP89TJWvCaVz/KlGrQlC5/peUxleZ4Iu+fQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737918989; x=1738523789;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mITLPPRJTc8HEWj0M/ACR6IgmCVo1uY/1TdIPvwxqc8=;
        b=HdF2d7Zax+30StWETsP6gbaQRXLucomxb9nyfwMDaDVXOmlVYspl28JjASMuHN7h/g
         ij4sr0Taf0synfJjvay5G+VUE25N15V8rqEM7zWhENXNJAuXJu6kH/kJzFT5vAY/fSkE
         Z+VGXG0W9TGp6c+eTEmOKtJQpXYG+Q3TudAx7JTW3KuZLNzC52LUS9zK21W2iyyPGSDS
         zBQ3J7ALH7ffPUvsEqydgDcf6aboMpdheGRYaukHBWPF30OFHLpG3cj6Ngl5wX8tjon0
         IuUvftiRftQNCvp4fn7ZXTNGicuBPZbz+z6sQ5uohUHAlqLbkKC2CFbjl/ypZf4+/WI0
         WaXA==
X-Forwarded-Encrypted: i=1; AJvYcCV34KBuADi1ZhmFbjkdqkLTA/ldVR2orzdT3B3U4fhj317gQKFR5I0bayXUKi2RksvBLiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5v9Ek7WcnhtuqGy68O+bHVxm+76E7mAzAaHiab3lCEEG/b5/+
	qzVYorjNHw6iP74ulgiIR8A1h8uvTAjceNlVBt4r238btAbpapR11cSoWN2L6H9DCwK6BID938v
	YXAY=
X-Gm-Gg: ASbGncsunKH7/DelsUek3AENKOBlarQ2mV1w4WYO9RtVYMWJ7o4Bpi+Mm7c5OsR+2Wh
	5gIyIWJoXUQBNx3ru54JxHXW/9E2rhrLVHrzaQxmrbx69q9RP11DXn8E3qAv3/VqeDFhVzkrOzc
	JifGz6JUIZGPq48Pbq2IPIvV3AvQl7xIs7E5tqIGtTY+nhfU/jnapMhOq5ncyDCbuFmQt6PxRiY
	/qmT477XWfh/quA2vXcxVmql4IAGCk4iHW8xMCU5bwN2LMNdIMLHkph+WK0XxtnMqHn4wF8qHdB
	SFp16hfCBa//N+mFTtxbygUFHGo3YhYONdETh05mtcSjg9qhXRRhpXI=
X-Google-Smtp-Source: AGHT+IG0OzPwtva6PfRmujIfrMRVbxkkIYJmCF9pUKqqypQ8DZfoRiv5KVD+qJPB4fmtbHU743edCw==
X-Received: by 2002:a17:907:3da1:b0:aa6:8bb4:5030 with SMTP id a640c23a62f3a-ab38aedf0eamr3779503066b.0.1737918988681;
        Sun, 26 Jan 2025 11:16:28 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6a2fbcca0sm85399066b.101.2025.01.26.11.16.27
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 11:16:27 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d3d14336f0so6376917a12.3
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 11:16:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU1r95ISkzG8stGaXwFEfNAxXF0Tpr1cf7okKr+RqKRy/utxgm654im/8HARyc/QIzhI50=@vger.kernel.org
X-Received: by 2002:a05:6402:42d6:b0:5db:7228:6a53 with SMTP id
 4fb4d7f45d1cf-5db7d306060mr33786459a12.15.1737918987256; Sun, 26 Jan 2025
 11:16:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com> <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com> <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com>
In-Reply-To: <20250126185354.GB28135@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 Jan 2025 11:16:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
X-Gm-Features: AWEUYZnOLZhsRXdbgj2ZYMaHrv0PZKVxc6dX4kH_R99Tbe8Ge8uozU92Q9oZ4oc
Message-ID: <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Jan 2025 at 10:54, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I don't think we even need to detect the /proc/self/ or /proc/self-thread/
> case, next_tid() can just check same_thread_group,

That was my thinking yes.

If we exclude them from /proc/*/task entirely, I'd worry that it would
hide it from some management tool and be used for nefarious purposes
(even if they then show up elsewhere that the tool wouldn't look at).

But as mentioned, maybe this is all more of a hack than what kvm now does.

          Linus

