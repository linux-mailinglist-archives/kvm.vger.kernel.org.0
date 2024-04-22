Return-Path: <kvm+bounces-15536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D24738AD294
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 18:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 101A31C20E5E
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 16:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5482C156962;
	Mon, 22 Apr 2024 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z9yh8GkW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565C1153832
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804186; cv=none; b=OI/6nwjlZ5Tb/t6Cy0IXvPm7kJA/9kD+M3Ie3lYDtPq/LjND8pQSNwnAwY7ivnZork7G+XueQqY9kKZKGnbIJaxdtxo31PDBJ6BWSSS3HoVQcsVrAK+pJ0kjGoGH3cNOO5SUG5IlX1lsPPhgFvnorJiiEicOmKh0B0uCfNdrmc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804186; c=relaxed/simple;
	bh=W0yzfhfuOWRG48vfO2uc2QhFbbA7xV4C71B5Bgu9HaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b5X8KT//cuEiXhig0/fttwOSsWN3Fz8ycb4amRODYK8Tw1/psPGdHfiPSXeQg4HKjS3NgbR9657Xp5MreR6Nz+oid9r+YOjtDde4wrn0ou2Qyc9vo5EQ72g2HJe1ODeLLHXFBOAI521Lf9I4h9c6tzXn4oyG6UJagoJ85DcawQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z9yh8GkW; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cfda2f4716so3883502a12.3
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 09:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713804185; x=1714408985; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W0yzfhfuOWRG48vfO2uc2QhFbbA7xV4C71B5Bgu9HaM=;
        b=z9yh8GkW469lQtsO0OwW4zWAZb2GqvGKyWkIlO5ICpohgBgeBUi2Ma4T+ZeXjn4jUZ
         Bq3Vbw/ZcnmyqYxKPhyys4w72X3yAFCuDamoD58g2tW1lAFOcU8AMsQYKe5ZntSiNVZs
         TdM2jUlaFpx4r7Psw9pvAp6kzIJbYyuCoR3Mh7KTUk+6eu/M2qvhUR99zJfqAFYRv+a/
         6jEtaqockWh4Pbd4ZwejD1dfyG/ulIlXubthw3Q3qt9Cp8NKNz+M0tknzz1bKxLYRSwW
         9UYsXyOQ2Gap9OvK4GnFJeSrk9l+vb6x1602F5uCjWU9gREP0dTmS5t+aGCvF7w6o9Ls
         nTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713804185; x=1714408985;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W0yzfhfuOWRG48vfO2uc2QhFbbA7xV4C71B5Bgu9HaM=;
        b=FZikfSVmXIxGWRi2d58Dh/W1j/EHQOvaTE1JBsm9Dan26eUJbF1UzZDImvXWjiezbI
         JZ4qtOCLt3VeN5QSw2HX+lZccStogPepROCx/AoIHbgwghtshvSZgtcGPaUoPNGglqnf
         cD0C/rIa6ob8QGuPa2dPFyZF43pw4NUbbeH034RtjLwJjVBBBKGzSWQu847Z+9awVemZ
         WxRGV05NwSVH0UMXx6LCYN1hsVvlgzh+/p7iqA/GlChBaypXR4/1SOegbs5/2c057p5k
         j9ZnheC/QmmFkCoAv/mPkBVqyMjM3m4qJrpgGD8ZJjdMfs7uNfCCwVZzt/tbL747AGtW
         ahJg==
X-Forwarded-Encrypted: i=1; AJvYcCUTUnrKisiEqxbrGDqFSPS1ZNM1Lm510HxaxcL2N8Qry4lk5zDudHI9+R7nGS3iSnliysrRuuZUu6fYmAPYiKF1f8nz
X-Gm-Message-State: AOJu0YwLVHtwSUli1n0FfhU5QHK/0IcxX1l7CoMoIN/ZPpI5gjEr/EwS
	VHB3NnND5YydtLEtYsZifSQXDBuZK/F8cW9J9lVj5SSJDnzPkwWa18/QDBcXKY461DviBtqjSA1
	WQA==
X-Google-Smtp-Source: AGHT+IEFcksLzHH5JKr/NUVsr1fzHoMgdfGGB/GsRlHPV2YtBF1HsGG88PhYVKBgJemUvdMBqI+HBqcpDqY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7018:0:b0:5f8:610:84f with SMTP id
 l24-20020a637018000000b005f80610084fmr24359pgc.6.1713804184480; Mon, 22 Apr
 2024 09:43:04 -0700 (PDT)
Date: Mon, 22 Apr 2024 09:43:02 -0700
In-Reply-To: <CABgObfaaec5JmLtZ+OJ7NuX1zGh6_dSQ_n7-8K=LtEY-ON-dJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419112952.15598-1-wei.w.wang@intel.com> <20240419112952.15598-3-wei.w.wang@intel.com>
 <CABgObfaaec5JmLtZ+OJ7NuX1zGh6_dSQ_n7-8K=LtEY-ON-dJQ@mail.gmail.com>
Message-ID: <ZiaTloh1_a2LtUEg@google.com>
Subject: Re: [PATCH v2 2/5] KVM: x86: Introduce KVM_X86_CALL() to simplify
 static calls of kvm_x86_ops
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024, Paolo Bonzini wrote:
> On Fri, Apr 19, 2024 at 1:30=E2=80=AFPM Wei Wang <wei.w.wang@intel.com> w=
rote:
> > +#define KVM_X86_CALL(func, ...) static_call(kvm_x86_##func)(__VA_ARGS_=
_)
>=20
> Just
>=20
> #define KVM_X86_CALL(func) static_call(kvm_x86_##func)
>=20
> please, because having the parentheses around the arguments is a lot
> more readable

+1, the more these look like function calls, the better.

