Return-Path: <kvm+bounces-40180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03606A50C61
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 21:19:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47B0D188FF48
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 20:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED4C253F0A;
	Wed,  5 Mar 2025 20:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iRip9jbF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3C4253B5D;
	Wed,  5 Mar 2025 20:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741205971; cv=none; b=szqyFhTSAFu0P0PIkVHEaf9kJts6AydNZFpTklaYbtJHj4F652c5kZJW40rgEgIJmekYWOZ2IDnOTOxnrvanZExvouIABlNnk3iQt8CgJvVhEB+j/KKol53x3MysvIqYM0NxHa+sJmnMTitH4uKwOmAXdRUWkonOowBiIUewyAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741205971; c=relaxed/simple;
	bh=DFv/aofqC6RxYldakRl4YDuw3IKqapk4Psuo0zdjGi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTa7FzRr/q3tXLf3v618YiZYVay1g5d1hFZHt6YCs+xXrd1gWAFJxd3KWZyOlKivn4sV6xC5hM43Gb7jY32r4Po3D2rnC/oYkf0dctz1cxuKXRVhQ/yjXfnUrACfDHq/cZUgl16DfmSIya8IMgyCLvX/dpa7Oyh+snpamoPuRqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iRip9jbF; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2235189adaeso23947645ad.0;
        Wed, 05 Mar 2025 12:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741205969; x=1741810769; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ggSYKjNiS8Boto5d0Yt8S4og/EP9GTSZBqieM3le2yU=;
        b=iRip9jbFBu3WsZpH76L1cMDu76nD6Sd9zbHTgh2qOBlaiz0bw0cIUESYk543utZaUq
         26+IwHbLkmt0s8hoBkXC31JOkOFnPUYTTDM/KfgdY3pJsBxz7DPzo3JlpquFVz5+mD6G
         WNAhvbyVB7MAIuugyKSBUk6VxVec69eVBqrfAIS3aIUlhPR00LlFx2zw8cH8311W2OkK
         WnrMqXJH6nTOzsN3TslQQUHe2EF476teOpKPQZDa8wV9+9t5bdo7YU8dAvJQf5Oe46Ut
         w5MU9EIijLkJJThv15+Ta56Z0ZPy5PQItAcMKtoue07rg/soL/zDPYDrUREHcABxNEPP
         dpjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741205969; x=1741810769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggSYKjNiS8Boto5d0Yt8S4og/EP9GTSZBqieM3le2yU=;
        b=ZttuigAv1hvVbMfDuVU8geyWyZWmIVHR0vO6q+q2Z7a3d8QDA4DpJXuCxYAGl+Ont+
         f60/vidCrjRGOx7VcefWTUSGoBHN7kFwSsWUd6U+ZDvYt9HkcD+DaNaqyHJKB4dRZZyE
         is9yP9Yf6/dSsXoN3WV6o1krFqnmjK8FEj7vBuZj08ls9dJl0uwDoaUeajjD2SvRcovf
         trIweyh5lOmZYA0uvqw8WudVTjvPkeYW8q/cTVDAbpCEK3PmU3KEpDBmCCRiOGvyYM4W
         WumiZ9YYtzJmJVM3PN1zjTadR+qhL7nCmKTfNKZQDtGcYlAwP1dawhGBE1Bm+D/cATqr
         nefA==
X-Forwarded-Encrypted: i=1; AJvYcCW0SMJlVRPR/hwwY6QPufe2uwWAcgUdjukzZxaNE1UDkmnp0FuuE/93+1ZkT8Reo/wK/YMMRuaU@vger.kernel.org, AJvYcCWlHaFW6FuhPHGw8zigZvB09zAEQq7ed6g2O8D/8HyaMtwdDuXIP9oCxwiMcZoKLsXCn3A=@vger.kernel.org, AJvYcCXCq7ZxaJYY9nu10QoMdCgYxYv2bLdGj9LSsceyI8HEhwp4iF4769eHNEqUo+sdjimbFxhG6KvdzDOfQwDI@vger.kernel.org, AJvYcCXtYpA7j6X8xTenf9oZHXwYl/pjk/9WYJV68itN5Ey7GkEralGOWdK8beLX85sGt3FjJ3qYAryHcVKwiK8y@vger.kernel.org
X-Gm-Message-State: AOJu0YyHVl1KBdQC6RQiF37FpU4RRn+qC5scrnV+UeV9Pov6uyZtPrG/
	d0yhV0dHFPK2u6Ag8DnIEk7GUi6/cAlY7JE3ZPx9JFpt/BEoEDpQ
X-Gm-Gg: ASbGnctTDfOwrPJ2kd0HMh0PazKm/E3gTkmt51SHLmLI5G3G2qS2TcM/tLdJJsrQhnw
	y7/qiIO+047C3zKspgF8dtL+SNwcY4eC40xzXs8Q5HyqwMKCbknFrXuGcrtMGBlLmohrwT80pG4
	GwEJ39DVLL34tCSPAUf08f3otEC+QRkizeiwxhYSseJcH9H0AMM5Vziw4AMKdLNSBs5nOXHobMV
	XSYzlvSLK6lU/bq5J/CdL27bh+rztTxRxfdomiAWPH+jikiWuGYVG4iFxwN/uo3NNOwoaT7y33l
	DYC2Bkqd/wAqCgt6SMmRk/OfvAUt1vFWyv6l1OE3DB57oL7F8AwsJvvt5rV0N0m/fDY=
X-Google-Smtp-Source: AGHT+IHr2tihJ0au2ICgSWnpCRu00yBghmKv/sVI+EDCEbOk0rg+rxUiD5JA8UUFm0k+OdDJoEO2eA==
X-Received: by 2002:a17:903:1aab:b0:223:fb95:b019 with SMTP id d9443c01a7336-224094a3c17mr11459415ad.24.1741205968892;
        Wed, 05 Mar 2025 12:19:28 -0800 (PST)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:71::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7363fa7f540sm8189030b3a.38.2025.03.05.12.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 12:19:27 -0800 (PST)
Date: Wed, 5 Mar 2025 12:19:26 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
Message-ID: <Z8ixzohy9a0b9QZ2@devvm6277.cco0.facebook.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200116172428.311437-2-sgarzare@redhat.com>
 <20250305022900-mutt-send-email-mst@kernel.org>
 <CAGxU2F5C1kTN+z2XLwATvs9pGq0HAvXhKp6NUULos7O3uarjCA@mail.gmail.com>
 <Z8hzu3+VQKKjlkRN@devvm6277.cco0.facebook.com>
 <CAGxU2F5EBpC1z7QY1VoPewxgEy3zU7P1nZH48PtOV1BtgN=Eyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F5EBpC1z7QY1VoPewxgEy3zU7P1nZH48PtOV1BtgN=Eyg@mail.gmail.com>

On Wed, Mar 05, 2025 at 05:07:13PM +0100, Stefano Garzarella wrote:
> On Wed, 5 Mar 2025 at 16:55, Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> >
> > Do you know of any use cases for guest-side vsock netns?
> 
> Yep, as I mentioned in another mail this morning, the use case is
> nested VMs or containers running in the L1 guests.
> Users (e.g. Kata) would like to hide the L0<->L1 vsock channel in the
> container, so anything running there can't talk with the L0 host.
> 
> BTW we can do that incrementally if it's too complicated.
> 

Got it! I will try your solution with /dev/vsock-netns (unless there are
strong feelings otherwise), and if it becomes hairy maybe I'll omit it
in the next rev.

I don't think my earlier concern about port collissions in the G2H
scenario is worth worrying about without a real use case, that doesn't
sound expected by any users right now.

Thanks,
Bobby

