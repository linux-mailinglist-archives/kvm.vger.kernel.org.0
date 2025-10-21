Return-Path: <kvm+bounces-60690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA0ECBF7AC2
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A70A4060EF
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5874834DB4F;
	Tue, 21 Oct 2025 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XMWyxq3y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA0434CFD6
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761064351; cv=none; b=VLQv2m7k+ScUwBZdUY/8jhmtJzKMXa+NG9mj7fCQFik71+GYoOhEyETxnBXMc0n4h5gDuZ3KBMzNA4ZbGAJAaKMda9Sbpbic13is77ABILb2/1kKNdf1oJjevJgwTgIUk3eX2cxEKjLiWMhfZRfL8encGw4rPveSTIDKNOKNg6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761064351; c=relaxed/simple;
	bh=/gc/MgvEN/dxX8eBe0+zIEkSKheyGIA6RT9tRwUKaiM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SRjwBf1rTj+E1FHwGzmGe2xh1j4Ct/wX7sTQ2OEk7vXG0JX0BUsYJupvvZ0yLX+uLwBiooxYFrW2XSpIIqiI/Xu7hD146Zwd2/zPqgjTNXSImuWy9elafXz0ChIdhvJjrTZfnMCYSaUE4yNWpH7tf1KsP9SjJZFr0aOhjmGd6f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XMWyxq3y; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-57bd482dfd2so5586597e87.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 09:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761064347; x=1761669147; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gc/MgvEN/dxX8eBe0+zIEkSKheyGIA6RT9tRwUKaiM=;
        b=XMWyxq3y7NJjv0WGyeZHJ/cU/+ShKHWqgWKTmiUWQSe9bRpUVUEVrtL5slMgnuHCrM
         3HfCDyUGIJRKYsYU7UGtI4n46JRkYKpcDLZMy4CDGNvgtB01vnTIdM/GPBaoRTWiFVGJ
         I7jz0bSpZErsK1hwe2zTSVbFoACD63DcvXacowItnMAAtvSoZ/VzViNDDCrRgEr/J+7K
         Z0pWwUGcxuzb8PmXno0Ieew+rXvZnRT+PNuEQMvf4eEzrsccs3Lffu02rPCIlfUi/j5f
         zWJWGWdbgPrJk5b/FuEl2fv1GVz0XojyBN0qgbg92j7Tagl6J+go2rkgz5PXkQ6U4SUK
         Mnyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761064347; x=1761669147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/gc/MgvEN/dxX8eBe0+zIEkSKheyGIA6RT9tRwUKaiM=;
        b=RYgHgsn/aEY5V8r5ghXd0squeniVzZpjqi1+YdZFY4+n0B9inL1/P7pFPMXHVNNK8X
         7BF1wLfEMVrge5InZvWazPO5oqIoIhSt0MQ8J+LkTJXxPF4wdapQi67dByHaMqdPZ79S
         TfYeNiY35lFSw1y4KvgTVICmBoB6gNR2QuN/+PGw86eAjs590a4kkqfc5g1LZXpvhmdT
         ldCuAOpTGnT5WXK1UcMFwMcOBfvbTgeblvkzqz5Z6YFKVnP8XyHfwHqPqWDMePoQNp7f
         P4ySkCzHenk2V3HMA2Sy0mvJ8I5wLssBfVZbBEXeE5OxovhdZprLJYxceHs46pW826VM
         YgpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKae4MubpcCmLkuWMg4VvGlLop4YNeYNYtVH/4Psk2XCUjytVNXEW6NkfJxM0EIcElB+A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+13QyPKO+4tVUcZNQ8E3y5BzGdgkshMUo9C5ntpEDdMBXHfFV
	V/LrpHxlyDRJ1j0xy32afQmcIkBCZ70gkD2+gWQoJiVQ1NQqzZq5UVDMjj0oQUsBVwCbqwS7ZFq
	lCxMqxRDZSTq5HkFR2mJQzA9w6a79RxS40WX9FZtH
X-Gm-Gg: ASbGncsguv1AQbezQ+uNES7lFV2nkWmlBPZrmbXxDJD+RaEStyVyl3v8WFkvbiA/yq+
	cEoIhCzCZVz678sLDm1EJOGFsW9kRHgMFeVAzZMwan2gCW76NmNaHfsspUm6TyOIFlvsOiSqdYr
	mDM/is6X/D6rLko4IkBiXi5aWslmPYqjou3HLFkRhei2yhOgt6Dhy3IgbpLZ42ktC+RKwtTa+ZK
	860vaqNsrfby6eMt8qwYZXlAxbahjDjj+sYotNryTQOBj+onA09w3Jut2VMNH+oAXFKytrCxhna
	06x5c0ZDd5Z6maKICuE78ijg9Ey/+QhWUirh
X-Google-Smtp-Source: AGHT+IEHrDKUfiyX6Tg5Va/Bbsmq3RGuv+MIrmu/OVXPhmrJogdnKuUWHxUE1kwAo40abea/E+5yHdcptmO5e1sf0JI=
X-Received: by 2002:a05:6512:3b13:b0:57c:2474:3740 with SMTP id
 2adb3069b0e04-591d8552878mr5722862e87.46.1761064347030; Tue, 21 Oct 2025
 09:32:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com> <20251015132452.321477fa@shazbot.org>
 <3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com> <aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
 <20251016160138.374c8cfb@shazbot.org> <aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
 <20251020153633.33bf6de4@shazbot.org> <aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
In-Reply-To: <aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 21 Oct 2025 09:31:59 -0700
X-Gm-Features: AS18NWAUSRNh675aFZJXIw7qTxvtZicID119h22vs_wRgto463TTxwR2SgdBO8w
Message-ID: <CALzav=ebeVvg5jyFjkAN-Ud==6xS9y1afszSE10mpa9PUOu+Dw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable limit
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 9:26=E2=80=AFAM Alex Mastro <amastro@fb.com> wrote:
> On Mon, Oct 20, 2025 at 03:36:33PM -0600, Alex Williamson wrote:
> > Should we also therefore expand the DMA mapping tests in
> > tools/testing/selftests/vfio to include an end of address space test?
>
> Yes. I will append such a commit to the end of the series in v5. Our VFIO=
 tests
> are built on top of a hermetic rust wrapper library over VFIO ioctls, but=
 they
> aren't quite ready to be open sourced yet.

Feel free to reach out if you have any questions about writing or
running the VFIO selftests.

