Return-Path: <kvm+bounces-42249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6075CA763DA
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 12:10:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99DD11888E60
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59AB1DF270;
	Mon, 31 Mar 2025 10:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="grNu4ap2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D7D1DF247
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 10:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743415802; cv=none; b=oy9ycPdpiH2xxpIHHz0NSzHuwBWEUTFtVulCfnTf+cWnV7sc5STJ0dQBu2y4Jq2PXHB/KQgD5OdygHIfjYLOZacP5MN9TpdQswWBTz/aReVjKy+lgVDLJYfPA2mpOfenq8xKCZ8xXP1MhHTNoOTIVn2tw1yPJ8N5t0nV9JHORBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743415802; c=relaxed/simple;
	bh=2C+cFpwYqPuZBl966ZPAtxohYZBT2XF7gdhgJCqoZ2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KbqpCtvK3Nx5FKxh0oa353ux1XCAfqWEgMhd5qzBKcRn5BlwvH8U7L98xIzYZCcSTtm6v+vafcv+/B2FPTp+TGbdwP+XZEAEktGcYclPjyhoJym5RyFRhJA9iCG4xHfk04cGWzhWFpaa5VK6uFbKmh7Bba5BvKwWy9BeEM1ov/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=grNu4ap2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743415799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2C+cFpwYqPuZBl966ZPAtxohYZBT2XF7gdhgJCqoZ2M=;
	b=grNu4ap2icB4CCnbLWe6ng5NIdIvRoaVeURmRHb5wbwlM8LX24YflV7BCgWV/v9uN2L9EJ
	VCaozKUOBtGCZhluRuIR6VCiVjPP5l0SvMSUfy1NiGJcD8NgwlGDrX09k2Hl9YRvcZpdEs
	b931NpUoXt5/QD+xo7AnztzU2WbxeGU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-jKBu_VroMiOvgbs0uYKrjQ-1; Mon, 31 Mar 2025 06:09:58 -0400
X-MC-Unique: jKBu_VroMiOvgbs0uYKrjQ-1
X-Mimecast-MFC-AGG-ID: jKBu_VroMiOvgbs0uYKrjQ_1743415797
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cec217977so24167535e9.0
        for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 03:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743415797; x=1744020597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2C+cFpwYqPuZBl966ZPAtxohYZBT2XF7gdhgJCqoZ2M=;
        b=WHzjU9pXl0u6Ps5Ra4xpbPewdieAMLTiQdcqpV32n1oTyjH4EBnkFmg+Gm7A6TqhxD
         M88fJ+JsixOdbjrmWm7xix9Qk1an+7LEegiBcnxkg4bMv4pk84Mkqm6wjU1I21HAjwCP
         5xBy5KanlHXd7JYCU8u74M0apmHVScEFqXhg666lndvE0127Vb8Kfh32YttZmJJvfdgj
         WG1DuXrmkwd/Ozu1bVgtOUP63qa+Z4K5nquqLwCrwN9J3YqAADtTXTmbHtavNOvnS1qe
         Vv7hriDq4tblwBA+MBFL8RO8/zV0g62tQ+Fy7HgQwJx/dh6sOY8G1Olef0s0zC3dwMad
         FSFg==
X-Gm-Message-State: AOJu0YwtVZw6OEoDnqbv6mINUEuInnyqarABZtRRCESZTbQtcfchV3FS
	c7hOKqB5OrgRdRm7yKyXPgewfsWLbT0Gf4hkxSmEFFbPfY4czVjdApC1XTRChbGT7/HQS8OFjHV
	Prx2Q4rhjigseprM4MMIA65vWUDXYhzIs7DSv/LUlYq8eFAdkYITNa9dFafPGtAj3N5BTcIck6s
	yt0vvfs/Ppp7Hka3YLtik8ZCyV
X-Gm-Gg: ASbGncs5cio27Ece7djLl2Q3faR/aiKSXNp/fF3FmgXnYtmXZkrw0olhZYnnAl8Y0sf
	Fkz2g9KfZD6Sf1a7aQ7JnbgR/MmNMpO5XgT91xDVn9xIhs3Y3iYoXWwxtfhv/98CLCrDjlmU=
X-Received: by 2002:a5d:64e8:0:b0:39c:1257:c7a1 with SMTP id ffacd0b85a97d-39c1257c7c1mr6595063f8f.57.1743415797300;
        Mon, 31 Mar 2025 03:09:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCZJk6h5lJDDWBOtazw+tCAeqH2OEGLjA3uXm8fAYK3lITvQem6Jy7CuY03JRzh1ZQXa3lcXdTl3nBe47JoQo=
X-Received: by 2002:a5d:64e8:0:b0:39c:1257:c7a1 with SMTP id
 ffacd0b85a97d-39c1257c7c1mr6595047f8f.57.1743415796957; Mon, 31 Mar 2025
 03:09:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250322111119.24548-1-frankja@linux.ibm.com>
In-Reply-To: <20250322111119.24548-1-frankja@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 31 Mar 2025 12:09:45 +0200
X-Gm-Features: AQ5f1JoXsB2OfNE5y2Vy3gJtj9d-q7iVYfi_bwY9LhJIR_SI8fVtayetOBGbXgU
Message-ID: <CABgObfb6gYHCjNBxL4c3WpL84K60LEvGsSaW63LcDW8aVC=vSg@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] KVM: s390: updates for 6.15
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com, 
	cohuck@redhat.com, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 22, 2025 at 12:12=E2=80=AFPM Janosch Frank <frankja@linux.ibm.c=
om> wrote:
>
> Paolo,
>
> only two cleanup patches by Thomas Weissschuh fixing our pointer print
> formats in s390 KVM.
>
> I'll be on a conference next week but I'll check my mails periodically
> and I really don't expect problems with those two patches.
>
> Please pull.

Pulled, thanks.

Paolo


