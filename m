Return-Path: <kvm+bounces-42037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 652BEA71B34
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 16:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2208B188C277
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 15:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F881E1E18;
	Wed, 26 Mar 2025 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VWFLWXSJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28821A316C;
	Wed, 26 Mar 2025 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004484; cv=none; b=hhMIXiYG4EaSBbWa4iXRj4LJRiu4uIOV43rkmH6d/IPhi200Nw01RwKbZ1l/1z9lSXK8liM+rF27+MGmegqXTj9U/Lzuf5wkl3H787zthozsmDPV3Ztv1kpzuyuEH/mZ1fGUWFzNNOqsmIQx2iY+IqjnyrS2mCFRr6FtgzpfYYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004484; c=relaxed/simple;
	bh=HoFQ0CMsHtsOWwRp+axH4plbdqn46HCLuFc8O9n7neA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OlXr8XbyI7c5nE9UyD6UlaCIPDGdF0OI/ulSaHqP2p3cIj4qEfoCEGVa0rRZi0xmSD/Ezjk5YHzNmmauKKyu73reBSOx8ctF/8lsFH7hVH9hWgc3fbqRxeM+HEJRagOyo3TwjNkfIhJIh7BXKDGfANNA+Xwki+bwDbusLa9v1mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VWFLWXSJ; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-30bee1cb370so320291fa.1;
        Wed, 26 Mar 2025 08:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743004481; x=1743609281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UybmRcOazmn4aXjSAlX40t+X4m/5tOX2sqBJ95HrPb4=;
        b=VWFLWXSJKz2x67b/b3OSCyBlb2/p0ngB6qido0KMBSmnL3xNLU89o6o5pMFD3INReM
         3DVOOjlHmJRlJjOvvaHoBkzO1ACbw+uGLDJcQylI/FqQvX8c8wDvoFDTxOGFGYzytBuD
         1IliDpv/Nv0E0R19vGc9+V0xg/H35cNzKd+IxxTMmW4q0C6m8oGUSCFXA0R0Mn+ZtpFM
         +5jhtVrbAXl/YZ8NEznJPYX49g3aM9pdAOOMAV7k/hqvq06XG3v8RqY9DtDQuoGo8C24
         q4w2r5oo1ixFxmcyIqycQvWDYzpFEx0TEtENDNg7mtglAQEPFRnA9n0WqMHaNRQdzFqg
         zHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743004481; x=1743609281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UybmRcOazmn4aXjSAlX40t+X4m/5tOX2sqBJ95HrPb4=;
        b=K0kzhVY+cQkB6eR6j1DACcxg2XHMUC10hP5qt6u1aZ/MP3pfZZdT8pNDsQlJ0RNTAf
         uwQCikR5NfMdAgKpCpglaxw7OhvwXkzILj4YiKFuWITgOAKQfOiAhTP5vNWcgTymDYHN
         aHjW1DHwhMkbs+U99H+7nWQiB/HtswoC/AmVYgLLoi+W09CKuAigk5hOBiK2bhYQxElU
         w23gYrJ4PEB4+bB+JfqNd9dS2/VDo2GosxtdrdrSXXgIoLzwBCHTttKuSWxAJMZd0Mnq
         UT/mRnmorXId/kdMEzEApTg53S7njzG3ynPuZuSJzYU8G00duyIHwJUoMswTuDL0eA4u
         F5Bg==
X-Forwarded-Encrypted: i=1; AJvYcCUZOL6uEpDzXlFaRQwZj7HfJtb0WCa13raVttQrzKcDtEginlW/6tXeAA8ivP4ms2KwVD4=@vger.kernel.org, AJvYcCX285F6Q0xg5UgC8ZoDbWVz/meAC+WdleAYLVqiVlv85Ujj0mxKiHIiDOETCaCkBZQdZwm7h58UzoHV6o+y@vger.kernel.org
X-Gm-Message-State: AOJu0YwBSZA5/k0IXT2JuP6NnYpuEjtTQKgveHkvQFevPSDGMPc7JKnV
	pyPQ20zwEM1pWjf7RiKgnUBI5ZjeXhtWlelheeYPxUo2NqUxn8FaK/zdGs28WwDI36B/OMmk+Ng
	vWradk966G/k8A6QnIdG8Jy/NmRE=
X-Gm-Gg: ASbGnct9CB+9I2+9C5mpEud7nIYAikB2isAxhzaj9PET2pTrD7bVsFhTTlx+irReaAc
	lv1rmz+CQJxY919LTiQ5p1D7is7Axhoqx7G51FjeH+w+KPprllOHheNczNg8lbjhpZ6qKH7NkNt
	E64xlHhwFKFEf2ybvPSsaXIbdF9Uab
X-Google-Smtp-Source: AGHT+IHt67fKJz4mYXdeEUbFX10Q4Jar36IOSOchTP5tfyVaZlVasO/43yApkgEaRZK0npcm6aa4HTklzlS7Goi+BO0=
X-Received: by 2002:a05:651c:154a:b0:30b:b956:53c2 with SMTP id
 38308e7fff4ca-30dc5dd011emr1366581fa.11.1743004480685; Wed, 26 Mar 2025
 08:54:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <facda6e2-3655-4f2c-9013-ebb18d0e6972@gmail.com>
 <Z-HiqG_uk0-f6Ry1@google.com> <4eda127551d240b9e19c1eced16ad6f6ed5c2f80.camel@infradead.org>
In-Reply-To: <4eda127551d240b9e19c1eced16ad6f6ed5c2f80.camel@infradead.org>
From: Ming Lin <minggr@gmail.com>
Date: Wed, 26 Mar 2025 08:54:27 -0700
X-Gm-Features: AQ5f1JqngjMEuNhWms46ut3gIH5kOFUVoPA5VbOb2u_rTRu2lBbhRvNuTSzrf1c
Message-ID: <CAF1ivSbVZVSibZq+=VaDrETP_hEurCyyftCCaDEMa5r7HAV67A@mail.gmail.com>
Subject: Re: pvclock time drifting backward
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025 at 4:07=E2=80=AFAM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Mon, 2025-03-24 at 15:54 -0700, Sean Christopherson wrote:
> >
> > David can confirm, but I'm pretty sure the drift you are observing is a=
ddressed
> > by David's series to fix a plethora of kvmclock warts.
> >
> > https://lore.kernel.org/all/20240522001817.619072-1-dwmw2@infradead.org
>
> Yes, that looks like exactly the problem my series is addressing. We
> shouldn't update the pvclock so often. And if/when we do, we shouldn't
> clamp it to some *other* clock which progresses at a different rate to
> the pvclock, because that causes steps in the pvclock.

I applied the patch series on top of 6.9 cleanly and tested it with my
debug tool patch.
But it seems the time drift still increased monotonically.

Would you help take a look if the tool patch makes sense?
https://github.com/minggr/linux/commit/5284a211b6bdc9f9041b669539558a6a858e=
88d0

The tool patch adds a KVM debugfs entry to trigger time calculations
and print the results.
See my first email for more detail.

Test Script:
#!/bin/bash

qemu_pid=3D$(pidof qemu-system-x86_64)

while [ 1 ] ; do
     echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D"
     echo "Guest OS running time: $(ps -p $qemu_pid -o etime=3D | awk
'{print $1}')"
     cat /sys/kernel/debug/kvm/*/pvclock
     echo
     sleep 10
done

Thanks,
Ming

