Return-Path: <kvm+bounces-17341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A9A38C45E6
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B56C1C22AFE
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43BEF210EC;
	Mon, 13 May 2024 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Px+H+TfI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0071220310
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 17:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715620869; cv=none; b=b7hh4q5eUmfInyCG4xtp/EoKC+nmkC0sdz3lU+30qQ+keBdXLn2KJYlHEaFjP5IapqJAXK0otQHyL2L+3moihyl0ASnfq+OLO53q0Pkmve25jTNRx1pxFr5mXFtSftJ/rdK+OnCYXbUfbRZJW0cUBBi3xf4jmZ/jzZtQxIMK2/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715620869; c=relaxed/simple;
	bh=4cY9MtXU2I4telm66R69VUj9RASu9tfSf8B/kojAaNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M/UC90nLytgPeDRlOs6IjvJdoPeDz+kR/SlscuKC2QNf06sbHQXy9vNeimPGtKBigg3gMgLeIJnSWlVFmv1ZFfX1TWESFNQ4flHrVYHulBY0vPRBGKOme+7GwYjdqVD5LvxacQLKyijLzTIJ/2QNmBU1ax3g9KmpVYODFcG5OfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Px+H+TfI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715620866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lFetHttmrSPEk8iB/RIqp6UII+/zXMI6LYRqsBUqiFc=;
	b=Px+H+TfI7JfxYy49DEOWW+wlPuuZ/z3UurkwmjUA59rZgi4UpUx/AjucL+Sn1dp0QrAJx9
	H37k44ttod0onK8+Eq0Pr/a6ua9/wTj0TGdqa54qpcmeuXnMlMigYcSflA9PpKiZjm/tJc
	xv6jy5cs9H/0EMA4QnsFaGNjvWwacQg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-67OxwoxHPn6VkN7NjhpBYA-1; Mon, 13 May 2024 13:21:05 -0400
X-MC-Unique: 67OxwoxHPn6VkN7NjhpBYA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41ffa918455so18007985e9.3
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 10:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715620863; x=1716225663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFetHttmrSPEk8iB/RIqp6UII+/zXMI6LYRqsBUqiFc=;
        b=c7VVUVVKYhQbeXIkEca93eD8Tl6qLWBXwjDYGVFX+vhs2DaYJtizkYAxysU+Im8Eiy
         BPqWvyvjn6YHmX4E4ZCi92jNlWnTyWVBEts/dQlvzkmDd4+JqdkLH0PFEV0lv8K50qhg
         4cwMh+tmY/ok7CWDkb7k7QGn16BkjxX5Nex74dzcNiaVhNqsQJEQ+9rCQi7iSWBqQIt7
         nNj/p07iqs7FWo/3q/mF/MLcTwplaxo+7/CTplntiNXxDmAqSszowfAMQd5+WIe0i0nQ
         5nWPX6h8eCEramQ11llrmjmH1bFvKxMLJF8Sk8Qj676RJFVyyb9Up4xnopa+eNeVmP5E
         9Zvw==
X-Forwarded-Encrypted: i=1; AJvYcCUYJ5ZapURQsdB2ONSa6gCTbp38Osppur8Hq7qhQdhgokBog/WRFQhT9LUJs69VklldpgEyM5QVZHzaI13o/1kWMiYy
X-Gm-Message-State: AOJu0Yz6axi9YP5xerjzd+ZhKltrNXcV4gZ3It46Jb8eTgX1hIIAcSRb
	neKrXR/MHlChimeoDJUwohhMOkKeaEw3NxNcaqVqjdwM/+Sy3HNddJTumRYMQapaoM36Yzd/b8B
	Mm6MvCf1LgD5yVEv1DDS5qWTjHfo+9eYgfATK97SV5gZF+HYBH7jvvwhGPRe/9S9JOOVdacr5oi
	C0qUb2TEQidbmR2QGShDwON5Su
X-Received: by 2002:a05:600c:3582:b0:41b:143b:5c2d with SMTP id 5b1f17b1804b1-41feac55195mr86486985e9.28.1715620863717;
        Mon, 13 May 2024 10:21:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+7klRRXayuHxgQuN4xrnk2PibSO57rwQTkXNO9jJpJsh5eowNn5cZ4BTWrNPZBX2tLF3nvF6BA/OvQNnQl1w=
X-Received: by 2002:a05:600c:3582:b0:41b:143b:5c2d with SMTP id
 5b1f17b1804b1-41feac55195mr86486845e9.28.1715620863376; Mon, 13 May 2024
 10:21:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240510211024.556136-1-michael.roth@amd.com> <20240510211024.556136-19-michael.roth@amd.com>
 <20240513151920.GA3061950@thelio-3990X> <0ceafce9-0e08-4d47-813d-6b3f52ac5fd6@redhat.com>
 <20240513170535.je74yhujxpogijga@amd.com>
In-Reply-To: <20240513170535.je74yhujxpogijga@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 13 May 2024 19:20:52 +0200
Message-ID: <CABgObfY0SEjdnNbXqeFyht4FWSf8joW8-zVS1qJ8HrxR5D5AGQ@mail.gmail.com>
Subject: Re: [PULL 18/19] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST
 NAE event
To: Michael Roth <michael.roth@amd.com>
Cc: Nathan Chancellor <nathan@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024 at 7:11=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> Hi Paolo,
>
> Yes, I was just about to submit a patch that does just that:
>
>   https://github.com/mdroth/linux/commit/df55e9c5b97542fe037f5b5293c11a49=
f7c658ef

Go ahead then!

Paolo


