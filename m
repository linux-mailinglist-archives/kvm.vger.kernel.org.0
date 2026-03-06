Return-Path: <kvm+bounces-73028-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YMS3KI+4qmkiVwEAu9opvQ
	(envelope-from <kvm+bounces-73028-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:20:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 448E021F948
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 53AA03061292
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 11:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFF6387577;
	Fri,  6 Mar 2026 11:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewb138ZI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RIAtJDs9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0E437CD53
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772796011; cv=pass; b=FJlXLhHGcRfsE1MzEwvjGAfAjRnnD8L23w4kAZEkZftoiqyGIzb6xoxcDqZsuNLgsEDp2YCuuwA+/CfBiusYehZA1IAlxv+ri98tn7O5EWVHATqeejkpeHTHWBy+uq5oTW3kADX71RRcp/zIK8Wr56nWyscXnQNX3C4PpXjEWfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772796011; c=relaxed/simple;
	bh=BT4BZ4yWLoAkKAoAGt9FcrgaXlrLBLnqoWuciHn2NvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mE25qpaDWtPqiQJhmDR5raz++HhFs3DWj25U6n4xiPe2GTpmWwBjEFgjZfS/hvTsdmbSkWA4T62YGW488RO42gKJsFvRGu/xF8mt6C6y02eXPTujAGe6Fvkb+FLvraNkNXw/oR36gilaAAdxEtqawtJHd6uBsycqgHOSa4NGBwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ewb138ZI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RIAtJDs9; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772796009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uHv08U+jpXO3n9fwK0tEBSi10rBksXn8+T6GQ4BBgro=;
	b=ewb138ZIAgRH2M6W52EaHGGRo3mu53W8ZRkf5JvYe1cwTLfmVyF2t4wUzEjGqZEjCtvxyV
	+aTQ6VFvnHO2amcMXhcTX0SBpKESsK8F6Cw41Oh+Z4DJVS8fH1rpeS+NkO535VWLgn1MSZ
	fTwY8uqi48sPO/5xFsPY+8irn7anaTs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-LelYwUK2PgeCX59UX3brdg-1; Fri, 06 Mar 2026 06:20:06 -0500
X-MC-Unique: LelYwUK2PgeCX59UX3brdg-1
X-Mimecast-MFC-AGG-ID: LelYwUK2PgeCX59UX3brdg_1772796005
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-439a85832c0so5066544f8f.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 03:20:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772796005; cv=none;
        d=google.com; s=arc-20240605;
        b=DTzEH+pUcRqGWXkINnbl+R+kZ6n7nJ3B2zJON8ZZjz02Hz/xR2U21Jb19kX4sgQZQW
         q9XoElmZXNubpp05AOH1BjRlwyP5kAqpgyrgRo3htpxX/grqXoO5DOi9Bm6iAMp4aOu5
         fV+4M2S+nv50drgKri0dXidTLN3w6YLDMSsqF8fOmjorTr47P4iCC+QvMF3xG9H8crhV
         tzigFOILzQXJ5pFLFggvlXGj1WGHWifc5gRDLn6mT8PJ//ph6pYDjPSupHfZilS1tELy
         Ry/YhdJ9IM7w4VLhkZ8UH3qR/PUMc2cab+Qwx+ge10m9IupMRJdYYyqLxFJGYkHiDPIX
         FfvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uHv08U+jpXO3n9fwK0tEBSi10rBksXn8+T6GQ4BBgro=;
        fh=kmuwTkdvaeU0dilYhnOqp6vrkck/zfZUso6YSCkNj1E=;
        b=PzF50yViUGwvfu9Vld/2rn+10KqqSk2YKOb4aCs0dZqH9l2JSII+FiBTs39YhwA+IY
         mZn+PttZMpTnimNseUrlXNieL5oKWJj9zilFK56OHoMjt9vXyg0DbpeHg1zApFX5MOo+
         2g5Plhywdifm2A3dFx1OH4pP82ok9MZWnR4TTYfaOtTen9LvBZZ5VHkFAOhRRGyimMEr
         iMPMoZ0sVfTPJD1s5GOg6t4mx3aISmLgC5G4wnIsz6ia+zIaUixjwhxwwNpl/CbaurUo
         zw0D7ERL5hL62OSHIs6fjXVEu8vE8OgiYEHRDp7St6iOMlgsgMWb5U9su3ZT0uVZ3orn
         ZKqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772796005; x=1773400805; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uHv08U+jpXO3n9fwK0tEBSi10rBksXn8+T6GQ4BBgro=;
        b=RIAtJDs99Ln68ZJO2S7KAJQefe95YkJk/qMS9LJEEE4wj9fAs157ySr8rVnSQuoyxD
         lrO478GJBG+ZtlafDN468JgtchKO5xz3LyRcOgiHTwuc0+EIO0vLXeEyMd8nKFHOvgoQ
         vkzI36y1JX+d6srtFfYXgyhZbc0VHgqVrW2Pu8Pf+Nasw6G24iYHyG2gTCigqt7Li4e+
         xUCLYk86TxCGTiOjX0ZXr9TkQWV19Qe57k8jDdVFBxroR1ICQQpb+EtVa9E0XMgrQCr1
         GdUpVQ7Ztm/pvWiJ9GHSNnTFCj3N+av/+EmAoN6OFHq1QEmIhWtLxK91Q3aI1zbRkQ4F
         apsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772796005; x=1773400805;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHv08U+jpXO3n9fwK0tEBSi10rBksXn8+T6GQ4BBgro=;
        b=MmzOHj3egicVhB86T+CL8/Oqw/nJuDR1H1B30yWXm6dSNkUpx0LZ637fm+uyixgOso
         QuOjQnGqaB3CU9RMIyrWXAI1dCsqxSvk3ZTua1G3FzFimJiTvvIblgwOKeZGUSXkgqlL
         tABfiwOofYRLxnxBRzCjBwKqnyGpfOdH/AKb3wmZVXqfLuAuD0ivqycpkF72X/r6OpiH
         CGHd3UpAEElHU0cdz1xejXkOXwUq3PWBWWd0GX/kNguKNQWfqO5vmCBcci6xbZ9etN5/
         RXjjXtJU5o76tFMDGQTsyO7PcdtSk8jyY7rJ9bZSNNfM6PdxP8EzLdwMlNsFJfWOVfqe
         etIw==
X-Forwarded-Encrypted: i=1; AJvYcCWfffTHI494bxsrGiIl4302dGLMaa90iKCeYTARGE0ezjp3X6jQTllhcSW5O/btVVF/xu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNPLS01+dxqDkAKEz+FBuXYqOHe/YFO/TWAv9NU7a7U3uJ3z9w
	ngWmP4ZByEi6/kmZzq6QYakEKhxg+vvSjDiNGwqhTxdTye0Agu7rS8jVGieTuArYqouEbZxUCkF
	DpqxZcUfwbt/bBa0gKPIEB/OQyD1qJEWFmobOqniVjUVz0ZGbK5g0LTmW9QhK4mdFP21Zcxk6eP
	J7TTQhPLY0yfc5KVszu3JSlwIVseFC
X-Gm-Gg: ATEYQzyQQsiABO77El4QgaP87Fjho+Zl1OE+Io3GGR5ynR/wMUjvSwim4xE/AOFtlcQ
	phceUpRbzGJSFBogvcu20wBB31ZpjR1XppQhHAWjb989lTLra7S0ilZJanmGAJnrsqyN56S/eiO
	r3PjyVKTUl1bIVy5LIYWwKnDCuqRVkRNks9M1l6f0K4jx8dYZpyAGaZxYYMvSyaKsdIqs4ULgrM
	yiVu3I1wpV9d4VAV2Og5yRHItJxbvOCzCiiqJksDU+28ym3S9r1LQSMFCNmtxxpWpnnXPoVkMW7
	6MYAhLI=
X-Received: by 2002:a05:6000:2312:b0:439:be67:a02f with SMTP id ffacd0b85a97d-439da66a3ecmr3085825f8f.37.1772796004960;
        Fri, 06 Mar 2026 03:20:04 -0800 (PST)
X-Received: by 2002:a05:6000:2312:b0:439:be67:a02f with SMTP id
 ffacd0b85a97d-439da66a3ecmr3085777f8f.37.1772796004524; Fri, 06 Mar 2026
 03:20:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304165012.13660-1-dssauerw@amazon.de> <aaiFsN3Jn_C5bTnd@google.com>
In-Reply-To: <aaiFsN3Jn_C5bTnd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 6 Mar 2026 12:19:52 +0100
X-Gm-Features: AaiRm52OwjQUvM-pMy-g17qYrS_J7KtnxzGL2yiY3VO0yEL27UaHL7pshwAF7J0
Message-ID: <CABgObfbYK+nU5Jr9MHXkW+D77b4AOh+gHNGFrQ17X-tF5xe2Jw@mail.gmail.com>
Subject: Re: [PATCH] x86: kvm: Initialize static calls before SMP boot
To: Sean Christopherson <seanjc@google.com>
Cc: David Sauerwein <dssauerw@amazon.de>, kvm <kvm@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw@amazon.co.uk>, 
	nh-open-source@amazon.com, =?UTF-8?Q?Jan_H=2E_Sch=C3=B6nherr?= <jschoenh@amazon.de>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 448E021F948
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73028-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

Il mer 4 mar 2026, 20:19 Sean Christopherson <seanjc@google.com> ha scritto:
>
> On Wed, Mar 04, 2026, David Sauerwein wrote:
> > Updating static calls is expensive on wide SMP systems because all
> > online CPUs need to act in a coordinated manner for code patching to
> > work as expected.
>
> Eww.  I am very, very against an early_initcall() in KVM, even if we pinky swear
> we'll never use it for anything except prefetching static_call() targets.  The
> initcall framework lacks the ability to express dependencies, and KVM most definitely
> has dependencies on arch and subsys code.
>
> I also don't like hacking KVM to workaround what is effectively a generic
> infrastructure issue/limitation.
>
> Have y'all looked at Valentin's series to defer IPIs?  I assume/hope deferring
> IPIs would reduce the delay observed when doing the patching.

x86 has a smp_text_poke_batch_finish() function, maybe it could be
exposed as arch_static_call_batch_finish() too?

Then you add a __static_call_update_batch_add() function, and
__static_call_update() becomes

    __static_call_update_batch_add(key, tramp, func);
    arch_static_call_batch_finish();

to limit the amount of synchronization.

The next step would be to expose the batch functionality and allow
patching multiple static calls at once. I'm not sure where things stop
being useful, though.

Paolo


