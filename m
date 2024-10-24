Return-Path: <kvm+bounces-29585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A82EA9ADA70
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 05:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F5751F2238D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 03:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B288A165F16;
	Thu, 24 Oct 2024 03:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D0SXg1bS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9B43C47B
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729740483; cv=none; b=I0IR14hQEwwLH4qoLq/VOjuDyl+58YxkQmHfP7BMwUae262wnH+sW9K6QkodC+QhRzxCZ0POpOw3EQxcDX5FDr0GS6y1/eQOu/8miJB9L+VLzVt+sfQV0XBvbNVUbWUK7Rj2tcBrVBUVWLJkVggzBfgC+Tu1gfw+S58KHVdWBiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729740483; c=relaxed/simple;
	bh=vQ0d4WGw6pEdJYN+ZwXAfdMBcTgiT+jpquDiUMZpyhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p3ZOe2kBu6N7tZyXsb6gZxVZoXsjYGgFA9BMQBU/xs125X5G+R08z1PED4lP98pqttEhuGyvBz6Eh3JEyf3KBxyRFW03lQzy3adaGXssh+YrtIRxjvpT4BYc9/AScTfSSOkR4JAHxz1n/kthHIqlkE1FNyO+xwXfCm83L0mA9Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D0SXg1bS; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4a470d330a5so159680137.3
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 20:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729740481; x=1730345281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTFJCH2cGLy0xaDEoQI/3kJizQVbXaha5YCvWl5U4Jw=;
        b=D0SXg1bS3UBz1R8SBh7PNF+bioFDqxToVFDquCqjMThq7+nbmMxQoAmHzKhILP/ah3
         6bqKX6DHAe7rfUgBB1rsvB5CHplMd/k34duGnt2FdtWW2HrR8AdGA0h7YM5M8iBCa+Od
         37Mkjfg+BdUOvFlDVU+650LCmVVf/RvOfMKm5M1HXx0QYxK/hXpm7fj6oFysgvpYNBTZ
         UXlbKMZsIzl0G9efpSxOYxhQbfv0FtbCAWLwxv9EiogmN0G0cUk+mRwpU2qk9pf7jokR
         gLgr7vM7cjT4rOIMTXMjA4kzJEmcB6772zbLWIE5Ij+9EaPbH2H1Amv9hPCadeb5rKW6
         Uzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729740481; x=1730345281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tTFJCH2cGLy0xaDEoQI/3kJizQVbXaha5YCvWl5U4Jw=;
        b=VtQq+lsYIPzUJeUirZGyPeT+D5eTyC4s+WnCq7OYYzlnheXXvT5c38BYNikzYtB78U
         JQbwCkO9wvBAdDQ9Rz1IZBDL/6tDwYE2B4GmbFcOtaE0zCpgLgg10377Pp+8D7auUUH7
         XQhJx4A3zmW4iualcHyUXtNJPfYZ7JQmLLGbzK6TeGU3mxWJrx1BXyqGraHLe2QDscBD
         UboS0qKU3YV0lj1lMQH/nwC8WCyOHg5PQJHFlR6bo2xOiCGZQzIjQJk0BBJGXXQpx3eX
         skU/AsHc44CaFsOfw/Q7SLJJ8glIa+c7Ow+1Sikl0nBPBPqjXTV3tSAqQaqF8RTh0RkK
         FWJg==
X-Forwarded-Encrypted: i=1; AJvYcCVps/sZgbArlqQ2FUnOA/IWmMYYxCbmHKQN5LKF7YEW71r4b7u37f4O7HLj9lj0nzZVnUo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSoW/lduiL/z2Ufvv3SuZVnS3FEJQ8/TDSu/xpzyG6NnObzthL
	BKd/keKIC92q/B8KAL6A979GxIWRogLB0Et7NLVHYB4vQJdQBQoSw4zf1DJh2JMSz0vcyhU+9Yr
	n+pn+CkIcJKAUTUWLD/1coVKVHObHzq7McBzE
X-Google-Smtp-Source: AGHT+IEFmKIrH0tEdhot3dQD3vWVXcyr4nBHaZ/45p+WXMlhwsIRW1Qi8jPw4tHBO8r92w8rBgRlQYFQmMzDo6ipkFs=
X-Received: by 2002:a05:6102:954:b0:4a5:b712:2c94 with SMTP id
 ada2fe7eead31-4a751bff426mr5723576137.14.1729740480730; Wed, 23 Oct 2024
 20:28:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241019012940.3656292-1-jthoughton@google.com>
 <20241019012940.3656292-2-jthoughton@google.com> <20241023202608.d4c3c8a5fef8b7e33667cf31@linux-foundation.org>
In-Reply-To: <20241023202608.d4c3c8a5fef8b7e33667cf31@linux-foundation.org>
From: Yu Zhao <yuzhao@google.com>
Date: Wed, 23 Oct 2024 21:27:23 -0600
Message-ID: <CAOUHufZnsT3SGgVGRm=9H=1yYSsotCJsy58rJ5JPsSW3-AHCJw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: multi-gen LRU: remove MM_LEAF_OLD and
 MM_NONLEAF_TOTAL stats
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Stevens <stevensd@google.com>, Wei Xu <weixugc@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2024 at 9:26=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 19 Oct 2024 01:29:38 +0000 James Houghton <jthoughton@google.com>=
 wrote:
>
> > From: Yu Zhao <yuzhao@google.com>
> >
> > The removed stats, MM_LEAF_OLD and MM_NONLEAF_TOTAL, are not very
> > helpful and become more complicated to properly compute when adding
> > test/clear_young() notifiers in MGLRU's mm walk.
> >
>
> Patch 2/2 has Fixes: and cc:stable.  Patch 2/2 requires patch 1/2.  So I
> added the same Fixes: and cc:stable to patch 1/2.

SGTM. Thanks!

