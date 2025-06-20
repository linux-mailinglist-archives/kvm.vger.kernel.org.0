Return-Path: <kvm+bounces-50129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF35AE2091
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:08:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AECB7A50D4
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D4692E8E1E;
	Fri, 20 Jun 2025 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ci7iFSHP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E8C223DFA
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750439317; cv=none; b=TroUY3ZlGeUYtg2JCvArqzaLl/8cbf3YvCzcdga0S5Xnq/b5SB/y3mWMbE87Kq8t8oZO7gVzRj73KrAg+KJeMOeJTdmsF8Hr9yFQCQEuhQBmPe03nYZf9FisPsLcOHNsUYDZhnSs+6LV0wWGomErLrxHkSVddDSFBNPlmCVJQW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750439317; c=relaxed/simple;
	bh=r2JhiJAXkhU14Ll0oB1qiziLeU4ZWAaHmGVdfC2ondg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fMlOWHOgZdcpOXtkJHpPhCJzEzjOwm3Im7uz1AlMq2O7w3HxEKFbHGECfp+6gcIPG8I1sLsPIwAr+O9FzsD6qrAz58xaMn3JEE/wPTKsEWYfCVc/2ZSauq3aChPY5bXJfzpd9CKz2JiB149sh8aCJBVcOdMrZD2LiP1U7tG1PW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ci7iFSHP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750439314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r2JhiJAXkhU14Ll0oB1qiziLeU4ZWAaHmGVdfC2ondg=;
	b=ci7iFSHPot8XPMfAbdRDpON5E8NMyb/ktcOfS7oWHJUz9Z9nnKV3OKOt4mK2dB3EgAYKZ5
	/As03OWhw8kIHbNBq2/OLbt9XclaY5RcHEdZE6iVhiczKWc2z0ZAvRAQ57h+d0J/lN93H9
	C9R9j1X3us2sBXfFLn/pYwBeTBWU4iw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-rm5dlvvGM4WBorcTQ7fU0A-1; Fri, 20 Jun 2025 13:08:33 -0400
X-MC-Unique: rm5dlvvGM4WBorcTQ7fU0A-1
X-Mimecast-MFC-AGG-ID: rm5dlvvGM4WBorcTQ7fU0A_1750439312
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f8192e2cso1164727f8f.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 10:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750439312; x=1751044112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r2JhiJAXkhU14Ll0oB1qiziLeU4ZWAaHmGVdfC2ondg=;
        b=vvxkZ4wT1XsjNxKbYz+N6lTCMEpAOxTv64dMbW5oYmptqNb4ARuCJrX2HBsNx2sCy2
         F1gdp340JhxmlDbJmFQ1RNtSn+pIdTVvCrXT/m4PU303skIJZQg4WR62BbqtJZEO1XaN
         kdJy36I5t06asEV/umZoCeKOD3RzK3bCY7EkBV9f+jiKFQ3qihfss66BbrCDEYZILzqV
         khK13eaANex+4jqH1D6t+kcCA6cvCMUDajji7wIfLU4ACVk4ZVkyaKpTtRo8DevFk7nD
         s2MvVcJV/VsHqLaCRPh3k3Ju0o8ADSpYlYF4X9rYT2yVxSKew7Vg/t5ovKesBS6ZahVg
         NJ/w==
X-Forwarded-Encrypted: i=1; AJvYcCWI12PtmP8LiUgF2Rpx3FztYFHvcv9w8MQ7YjdybRT7KVVKfNo5jxh1cF3xxNvFSpXM2Z4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWsXSgazSDQLgSf1Wox0hdULEozKR06uAwSUO7jh2OnGmsqGc+
	sibSdeH3jsGUxoT+q/Svnym3CxSeCM7fMGvEKZdOnhKZVxf1skuQcrTNP7MMnBNT1X3gaDfRJ6N
	z3a/+JL8j8KymvU2y0hb97OisZqJk+h+4yw5ZgBUxcqppzZvyWwBpvgjQM0dK2uSBI7nFrmRwhS
	ocYqdxEy87Tw5722GA+QDYrIN5vGXc
X-Gm-Gg: ASbGnctxSFCgNWgULZBfuC/qBSNtJQz8lkIt7Ch4/iX811+gsq9xayGPz99x2gwd2lu
	hKnrYow/MKXn+b8wFbQ0rV+sNjZOyzdIe2JcqdEs77//3Wg9celjdTDEf1lPk8tHlmcC1UfEin8
	y17Pk=
X-Received: by 2002:a05:6000:4028:b0:3a5:27ba:47c7 with SMTP id ffacd0b85a97d-3a6d12eb400mr3172666f8f.48.1750439311799;
        Fri, 20 Jun 2025 10:08:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7IiJVica4CS4GrLqH/peAyHZsEjszEJMo8N5OhMmLN0zTZVLBNwPF+ffHrcbwAch+4I3rcLG9lKHNtCYnJX8=
X-Received: by 2002:a05:6000:4028:b0:3a5:27ba:47c7 with SMTP id
 ffacd0b85a97d-3a6d12eb400mr3172647f8f.48.1750439311454; Fri, 20 Jun 2025
 10:08:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy2ZTWpx82buvGmcTp+0bXJCncQ8TCdmW7tCMC_P69GBeA@mail.gmail.com>
In-Reply-To: <CAAhSdy2ZTWpx82buvGmcTp+0bXJCncQ8TCdmW7tCMC_P69GBeA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 20 Jun 2025 19:08:19 +0200
X-Gm-Features: Ac12FXxYI2NgPN6AIYShUhEnPB6Bl3WgJoZhauSYbs8tPxyDZoJzys7gQd2IPaA
Message-ID: <CABgObfbTtTRYyTHbP7sduZFkB31EDvRmSAJKpQHcNugjAALV2Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.16 take #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2025 at 2:18=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have two SBI related fixes for the 6.16 kernel which focus
> on aligning the SBI RFENCE implementation with the SBI spec.
>
> Please pull.

Pulled, thanks.

Paolo


