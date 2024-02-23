Return-Path: <kvm+bounces-9563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85CD8861B0F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 19:05:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C554286D4F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D52B1419BA;
	Fri, 23 Feb 2024 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFzQFkH6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED83E12AAE0
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708711504; cv=none; b=E9uvq1cX6f5Wy9IphSFWB7yqBEKimlkd1uy+PQh5pA0so9l4vwLSDS8ToozB1EYXqOzdwFKBGaxYkMaCfrDkagVpwkL3m1Y8hiJysqGPPgd/SMOYJlakg9GmAJSEA5QrDT7iMqgcDlpxmxfsfClDGkRYNiSxAL/IkI9Dr3Gfpjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708711504; c=relaxed/simple;
	bh=DgRka5e1twI0O1CM4WpP7Yj3tQomnKTgcsf8bQ7aWeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n7fYGDFZAxuz7sHhrnAlK3ymYVcgoGj+HokKg3DHY5gspr38oTZmq0JFGfOpM9POuAHx7h520m4iOEx7rS9mzavNqklOAfMCN+AffyyghUUxmCCyA+vuLkgGV/eslblwgw946IWoVv6ZnW+6pNfSAUCcU0eHTank4ttjuAl45uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hFzQFkH6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708711501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=82eigYgjksPkhoX7SASPwd4nqYX8wyhmUpatcdYIcqo=;
	b=hFzQFkH6xVWSSs/N/cjODdJk8s5QZd9LrZ8A2ddcqjmI8fX8XltrBApO2oJE+MHMm8XCxz
	jG48MLaI6ob5KIa5Ms65VzwXGxlfRJwbidsn2zjbFVqN7wroKK6/m3/uZnjc5jdtNnHrk9
	JiknMTtiTUvv09hZvLIL4o7dgyLDpjE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-O6g8aOKWP0miQ2jDbzefFw-1; Fri, 23 Feb 2024 13:04:59 -0500
X-MC-Unique: O6g8aOKWP0miQ2jDbzefFw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33d782af89eso487866f8f.0
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:04:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708711497; x=1709316297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=82eigYgjksPkhoX7SASPwd4nqYX8wyhmUpatcdYIcqo=;
        b=WKwuxm463zyNA0HuLFfRHWrjIghnf+qeGN3rxtdKGc98zPrhONAMXv5ZPk9AobTGCD
         5z+aDkjgF9v+0z8yBgRjGSna9H6xfFtAvkVNYd6tR3OCyrylcGQPBgivhLxEExG6cvQN
         9nfCo9baKZvmdH8Y7Y+BBOe7rMWYovRRnkSn0yeKutPNT+nArvTbeOqehVjMttbnsFzJ
         nZyh2YBzOebTcnUpKzc6MAwwNMsP3mtuxpeeOv4tnlzn0ob100oxq6iSG30qlrM1xltm
         4cOBm+tqzk2e9V2Bd98VLIndiixFjqSXLAWxk7RD6eSd8KyLu9VFU9iM+a8un/1FnDe3
         Uqjg==
X-Forwarded-Encrypted: i=1; AJvYcCU3qLEbECeK4r65BQJlHiYZnsUpIxVxydjK4xfOOWFY9urXdR5YgZoTfibfot3F4l+IuDn0Bvz2EQCIlGDOS1fY+O7F
X-Gm-Message-State: AOJu0YxyF4Nz7r+jLqeUHud16ArimQ6OHPoBHxa4csu6J1rHGNt1cI/n
	PZdySD8qNPNX86peACm2J1eSxVFz2oWb0bzDbEuIyM69tQkXJA0DgTolennGAU9BhW0OJvISW6o
	hvnbpXuoi3y3TtJrObatwOjmfk6SJzOKlzxklQvm+PvvHlLeZY1CNRtjW7JLe+K3vTcbX15DZVN
	N4gAWo+VSL/ofeYmHJ6p2j7CGMH8rF0XWv
X-Received: by 2002:a5d:4c8d:0:b0:33d:3ff4:230e with SMTP id z13-20020a5d4c8d000000b0033d3ff4230emr345339wrs.32.1708711497132;
        Fri, 23 Feb 2024 10:04:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEriJPRAGXbHZuCX1x2uHN2wQ/HGZC16cJxgWCoXazQGUM9K6McAwPYzstWeEsRlKuvvP9dScghPaHqdHGmEyQ=
X-Received: by 2002:a5d:4c8d:0:b0:33d:3ff4:230e with SMTP id
 z13-20020a5d4c8d000000b0033d3ff4230emr345318wrs.32.1708711496805; Fri, 23 Feb
 2024 10:04:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-12-pbonzini@redhat.com>
 <ZdjTTK1TgN8B64zO@google.com>
In-Reply-To: <ZdjTTK1TgN8B64zO@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 23 Feb 2024 19:04:45 +0100
Message-ID: <CABgObfZGWHM414oq3o6YW=KBNytLGdtDThCdmCWLjPUOAutnjA@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] selftests: kvm: add tests for KVM_SEV_INIT2
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 6:18=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> > diff --git a/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c b/too=
ls/testing/selftests/kvm/x86_64/sev_init2_tests.c
> > new file mode 100644
> > index 000000000000..644fd5757041
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c
> > @@ -0,0 +1,146 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <linux/kvm.h>
> > +#include <linux/psp-sev.h>
> > +#include <stdio.h>
> > +#include <sys/ioctl.h>
> > +#include <stdlib.h>
> > +#include <errno.h>
> > +#include <pthread.h>
> > +
> > +#include "test_util.h"
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "svm_util.h"
> > +#include "kselftest.h"
> > +
> > +#define SVM_SEV_FEAT_DEBUG_SWAP 32u
> > +
> > +/*
> > + * Some features may have hidden dependencies, or may only work
> > + * for certain VM types.  Err on the side of safety and don't
> > + * expect that all supported features can be passed one by one
> > + * to KVM_SEV_INIT2.
> > + *
> > + * (Well, right now there's only one...)
> > + */
> > +#define KNOWN_FEATURES SVM_SEV_FEAT_DEBUG_SWAP
> > +
> > +int kvm_fd;
> > +u64 supported_vmsa_features;
> > +bool have_sev_es;
> > +
> > +static int __sev_ioctl(int vm_fd, int cmd_id, void *data)
> > +{
> > +     struct kvm_sev_cmd cmd =3D {
> > +             .id =3D cmd_id,
> > +             .data =3D (uint64_t)data,
> > +             .sev_fd =3D open_sev_dev_path_or_exit(),
> > +     };
> > +     int ret;
> > +
> > +     ret =3D ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> > +     TEST_ASSERT(ret < 0 || cmd.error =3D=3D SEV_RET_SUCCESS,
> > +                 "%d failed: fw error: %d\n",
> > +                 cmd_id, cmd.error);
> > +
> > +     return ret;
>
> If you can hold off on v3 until next week, I'll get the SEV+SEV-ES smoke =
test
> series into a branch and thus kvm-x86/next.  Then this can take advantage=
 of the
> library files and functions that are added there.  I don't know if it wil=
l save
> much code, but it'll at least provide a better place to land some of the =
"library"
> #define and helpers.
>
> https://lore.kernel.org/all/20240223004258.3104051-1-seanjc@google.com

I'll post v3 anyway, but hold on actually committing this until I've
taken a closer look at kvm-x86/next.

> > +     TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EINVAL,
> > +                 "KVM_SEV_INIT2 return code %d, errno: %d (expected EI=
NVAL)",
> > +                 ret, errno);
>
> TEST_ASSERT() will spit out the errno and it's user-friendly name.  I wou=
ld prefer
> the assert message to explain why failure was expected.  That way readers=
 of the
> code don't need a comment, and runners of failed tests get more info.
>
> Hrm, though that'd require assing in a "const char *msg", which would lim=
it this
> to constant strings and no formatting.  I think that's still a net positi=
ve though.

Ok, will do.

>         TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EINVAL,
>                     "KVM_SET_INIT2 should fail, %s.", msg);
>
> > +     kvm_vm_free(vm);
> > +}
> > +
> > +void test_vm_types(void)
> > +{
> > +     test_init2(KVM_X86_SEV_VM, &(struct kvm_sev_init){});
> > +
> > +     if (have_sev_es)
> > +             test_init2(KVM_X86_SEV_ES_VM, &(struct kvm_sev_init){});
> > +     else
> > +             test_init2_invalid(KVM_X86_SEV_ES_VM, &(struct kvm_sev_in=
it){});
>
> E.g. this could be something like
>
>                 test_init2_invalid(KVM_X86_SEV_ES_VM, &(struct kvm_sev_in=
it){},
>                                    "SEV-ES unsupported);
>
> Though shouldn't vm_create_barebones_type() fail on the unsupported VM ty=
pe, not
> KVM_SEV_INIT2?

Yes, this test is broken. vm_create_barebones_type() errors out.

Paolo


