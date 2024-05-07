Return-Path: <kvm+bounces-16893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8928BE9F7
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 19:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3351F1C21CC0
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD1654BEA;
	Tue,  7 May 2024 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h6jVbKJc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F114E570
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 17:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715101326; cv=none; b=o7cEP3vW1nSHV1fGR/oZcS9hwSVlwgL238OHyF61QDshUOz59TZMKiw8oW35oKpQetVcz4MckDsSbRe4X+6SI4JMKRMJSJQiuxxjnMG9Ey8tL8CmUtUWynoZanWUAi2i5hR015xj3BcFeomZMsPmeav7QXG9rCzpwtLzbkgQhJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715101326; c=relaxed/simple;
	bh=lnmeGx6mM8HK2cbcBMXEki7Leq6zV0uSfpE3Sd53tq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V50OdUjrc/HSIZ8VonYkZAIcVtHg9lEKfgEKGH9EhFuL+kGvPjja/riki2c+S9sHAeRZLMlYqqY76FIKtBwtXM7TDLudbCPj6KyX41sagqJiYhcbkMYVt51SaL/g+Iz479qe25bmgj21OgEwViIbN4NFMxPr4b8KF9/iQXkveME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h6jVbKJc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715101324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35j9M18N36vk6wSyApQ+5MJ9yl+jkARaDRgd2CC1aRs=;
	b=h6jVbKJc6ZO6Yc1gRg+4VTMddSQKKtV8VZBJJEVwu0wNdN2n83i/y5OD7DNFWJgSZeOpy5
	kIknVsBywX4ZyNjO2sD2FuvXj9M7JPYxU38X9sjJnDGtYX9cP8EeWMcS+H/hFBb5NwrALe
	y54dv9pWSYLNIA5RtgFdVVjo7kj1iPk=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-0tg_wa1xO2y3VW7GspW1Ww-1; Tue, 07 May 2024 13:02:02 -0400
X-MC-Unique: 0tg_wa1xO2y3VW7GspW1Ww-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2e2da49e82aso33474511fa.3
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 10:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715101321; x=1715706121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=35j9M18N36vk6wSyApQ+5MJ9yl+jkARaDRgd2CC1aRs=;
        b=l1CCeQlISWku6Fcr/27dHaY44x9jds29fPWXypGRepBRJVDI0bBn40DozK+PqkEffW
         Apb9sNPRKuGnM5KLwab8bQzTxFKUtnGQAfqRpwPDo5YktIB6Kef1LunlHOcJQrLqlNZb
         EbhVzoACg10JOzm6Ps2lVJ5XNmMQkr+QP2OcylGqWgL6yyu0RuimNkHCZ7xrpYfcRhIK
         DoU1pzLZwlW4rEpVPKSrslJJH1sII9n+p0nC+7UKmwadOks137vKXDXnPOj03KRKUB0f
         tTEq+bx3OklG7x4ChwF7s/P0S5lGng5mh4EpnGaeIifBwwjILHICz3y0a1QwpcKDOY5K
         SI0w==
X-Gm-Message-State: AOJu0Yww4k6skZOD7+gvf2NWnzVaqc/ysGJ0C9ucxwF1gTvUa7EfhdTM
	Jh5KfKfeD5X57crx5JvqyL3iWIt+HmtPq3jWFRNt4An81ws+tF2ZEK9SFjvl8sh7A23JfCIT86m
	bL5fNRY1Ph+sCXuC+uHGtnF9BokD40tCRydqB+7PPQu6yiffhY+tV8TBiCvn6FGn+tVwB7h7GeI
	aAMIHEBL9rP8G3TzldSAVtkdRs
X-Received: by 2002:ac2:5e30:0:b0:518:ce4b:17ef with SMTP id 2adb3069b0e04-5217cf3b0dbmr60098e87.60.1715101321279;
        Tue, 07 May 2024 10:02:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6IWm96F+cIDzth/uQd3l0oaQARW+aFQiEI+UhoNsuY9HQ0VD+mdg3aAHEreT/EfAicuI1kFYJx5l4fRs6tJo=
X-Received: by 2002:ac2:5e30:0:b0:518:ce4b:17ef with SMTP id
 2adb3069b0e04-5217cf3b0dbmr60070e87.60.1715101320848; Tue, 07 May 2024
 10:02:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240507122945.2571-1-borntraeger@linux.ibm.com>
In-Reply-To: <20240507122945.2571-1-borntraeger@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 7 May 2024 19:01:49 +0200
Message-ID: <CABgObfaww5Dtp0Ji1ff99RrW11stWhf_JahJAyUwpV=RyTxpCQ@mail.gmail.com>
Subject: Re: [GIT PULL 0/1] KVM: s390: Fix for 6.9
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	linux-s390 <linux-s390@vger.kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Thomas Huth <thuth@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 7, 2024 at 2:29=E2=80=AFPM Christian Borntraeger
<borntraeger@linux.ibm.com> wrote:
>
> Paolo,
>
> one fix for s390.

Pulled, thanks.

Paolo

> The following changes since commit 16c20208b9c2fff73015ad4e609072feafbf81=
ad:
>
>   Merge tag 'kvmarm-fixes-6.9-2' of git://git.kernel.org/pub/scm/linux/ke=
rnel/git/kvmarm/kvmarm into HEAD (2024-04-30 13:50:55 -0400)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kv=
m-s390-master-6.9-1
>
> for you to fetch changes up to 175f2f5bcdfce9e728f1ff956a50f28824d28791:
>
>   KVM: s390: Check kvm pointer when testing KVM_CAP_S390_HPAGE_1M (2024-0=
5-02 09:41:38 +0200)
>
> ----------------------------------------------------------------
> KVM: s390: Fix for 6.9
>
> Fix wild read on capability check.
>
> ----------------------------------------------------------------
> Jean-Philippe Brucker (1):
>       KVM: s390: Check kvm pointer when testing KVM_CAP_S390_HPAGE_1M
>
>  arch/s390/kvm/kvm-s390.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>


