Return-Path: <kvm+bounces-23975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F4B950217
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7AB21C21E08
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E97719884D;
	Tue, 13 Aug 2024 10:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AJBEWGUx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528BC197552
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 10:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543661; cv=none; b=b6OVp7JlXRaYJBE3XTC8Mmw/n6pB/QJTyL+/3nl6N+yYVRxDoCv8+TFXwggWjesNZ8IPwA/6oosi4HfZjtW6eQ1kdD8lJFJ6mgoLDQP2H5Ktg03G38phnFudw8fLHH9+OhuC9vLatxEEyomaTs+MrWbgoVSIzdCT3fDW3XgG/hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543661; c=relaxed/simple;
	bh=cA24tO7i9G/GDE1s5IJxXRUiN/TXziKBGY9w7HFZfUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aF9upU2RhmLpoHNIZB3LWLbLQTL3l/enXTbqnW3C4p93p35bI4l36IoKrj80IJ/ag3qQ+PkeC4aLtn1pnTQHT8toPF9R+PeiZ/H3ZXN35WI2YPqVYyPZhD604vjeuU2gBlIFeOVUFxWFb+Y9ywG3aD6jcDW2zcx2hlMvAC7XAEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AJBEWGUx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723543659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ayrcUa2Cjj1GR8I5DzWLOmLEl44tVeoFpEY59iLG3hI=;
	b=AJBEWGUx248iAp6uW9ImlzLQbTVDjrx43v9ldu74goEQIUHMf48kS+7KAPNq0+m+xmzGts
	E05ZijGQxXZDMDw1YNjPQIuxP2XyZQwpvubHElImKCEk3eDt73LzEhWE8PuEdW5qcCZbMa
	k8i8WsveQnPmJukuztkMo44TNBTqdZ8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-P9Ok73TUMWGGsXZ36botGA-1; Tue, 13 Aug 2024 06:07:38 -0400
X-MC-Unique: P9Ok73TUMWGGsXZ36botGA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-428076fef5dso39335455e9.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 03:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723543656; x=1724148456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ayrcUa2Cjj1GR8I5DzWLOmLEl44tVeoFpEY59iLG3hI=;
        b=cv5ZrUdM9xmaTSatC6y1UQfc6I1fM3S5xONbw6YYLXWQWPMZsrr12LELGHk3SniJ5p
         E26//35ODXNmgxMsCXM03lAjTZlaAyN4rHV14105ymrP5Mir9ER9DM4qSPRNYIUtaIJ8
         I3Gq2dUz73jg22wTa8MenQkiWrVjYnnr+ueZ+FGwIYjUc7q8omqr8tYve5mwe7fKFDuX
         vdlrSOP0/IBXTYDBro5XYIWkhDoSMDDAbNk3asMdmMsvb3NIJcw0mtCOsFqh19zhMym6
         qK6+Qis7ZVuuv0b2n63/b4UlXM7OvqhsqilAaDYfB+zAT1dt4FKZ3lI+XxQ1NM0ADJC1
         jZ3A==
X-Gm-Message-State: AOJu0Yx4pWn1KDlOmla1IAa85fHEpveIA7S6T3I5zW2R975V9H9a/0qL
	LzGXYFZqG4szc6qDYR0Tn3pOeEAFewes2xh/eFp01vDZRA7XbpTbo2P6T/e6RShZ41WrsxoUfqT
	54jsbdCKWjyb1HfnxjLa/VqMr36SxCRJxDBQuSqBn52l0mJUO0VZe+hzjROtHoXSV3E49HTJed1
	JtujzlBVGeP8V2nRoboVgV7P8n
X-Received: by 2002:a05:600c:4584:b0:426:5416:67e0 with SMTP id 5b1f17b1804b1-429d48993e6mr24093175e9.31.1723543656507;
        Tue, 13 Aug 2024 03:07:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0A1+m/OfNnQkWW+DUzpN48HQJNeC102IZvxAtZTbl9fqTDMfEUwcze07w2IIual22FG3gtXHXVlFqSZqNiRI=
X-Received: by 2002:a05:600c:4584:b0:426:5416:67e0 with SMTP id
 5b1f17b1804b1-429d48993e6mr24092965e9.31.1723543656095; Tue, 13 Aug 2024
 03:07:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240808150026.11404-1-frankja@linux.ibm.com>
In-Reply-To: <20240808150026.11404-1-frankja@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 13 Aug 2024 12:07:24 +0200
Message-ID: <CABgObfbKUKeE89OeZe0HM+iYy7vDGpn+BPUgWMadtE=LnXVD_w@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] KVM: s390: Fixes for 6.11
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com, 
	cohuck@redhat.com, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 8, 2024 at 5:01=E2=80=AFPM Janosch Frank <frankja@linux.ibm.com=
> wrote:
>
> Paolo,
> two fixes for s390.
>
> Turning gisa off was making us write an uninitialized value into the
> SIE control block due to the V!=3DR changes.
>
> Errors when (un)sharing SE memory which were previously unchecked are
> now resulting in panics since there's nothing that the guest can do to
> fix the situation.
>
> Please pull.
>
> The following changes since commit de9c2c66ad8e787abec7c9d7eff4f8c3cdd28a=
ed:
>
>   Linux 6.11-rc2 (2024-08-04 13:50:53 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-master-6.11-1

Pulled, thanks.

Paolo


