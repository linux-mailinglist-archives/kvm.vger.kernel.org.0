Return-Path: <kvm+bounces-7828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D050846ACF
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 09:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17D4F1F2B5FC
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7741D18E1E;
	Fri,  2 Feb 2024 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h46mqwAK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED16A18637
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706863006; cv=none; b=kc3pvnCCURu2JzbDzLz0QctPkQo/iL6mFNoT/Wj0VPjXZi6R6nAkW9Yfo1588co8SnoAL7RGNuxiMR3Zx0AeZLguYu1na1TyV3rtZyVYB0tu6Vn/wqSfkDaDhzZSKrMA2uQ54s/YWKSedMNmN/FvjGwfm7/Y2xD52NxTerTU6Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706863006; c=relaxed/simple;
	bh=kLSRj3dY7enfEXLlfpsKMblPexWph2+9JD5884nsQPw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hmd3B5mMFtebcwfzXNVPy/odteFuiaqUj1jveiV1fuYg9k8duwR/b7bh+nCri79W4uD8xLmtNOivcNbDwhKPHOvQ+m6Ma/+s5UyvbCLtAs0PsZr3DTxS/9q08+1uOshz3CSacHj5ngv5sUemNsOa96TMsMvvi5fdlIYkOnADas0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h46mqwAK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706863003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kLSRj3dY7enfEXLlfpsKMblPexWph2+9JD5884nsQPw=;
	b=h46mqwAKCwfgdcivHypYMOwzS97EmQT/Vk5QgQfB6VUowCNg0KSynSFEhCr1VUpvqOLqPG
	Sdwr1+ZdTcNPZnvBUOXmSkaTV4osxllZuWnSP5Hd9Y1UQ6apaCtnO9Na2mvqUt79kTogI8
	9PjrKC1ccGKUOKqIqja+ghRO/gxF490=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-aQ5p12vOPSSPEskF_qfaUw-1; Fri, 02 Feb 2024 03:36:42 -0500
X-MC-Unique: aQ5p12vOPSSPEskF_qfaUw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33ae6f8d774so21178f8f.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 00:36:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706863001; x=1707467801;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kLSRj3dY7enfEXLlfpsKMblPexWph2+9JD5884nsQPw=;
        b=AugAiHFvZrSlvQ6aeMPy32ywYN6jvna/PlSneLccHLJ41Kl4OkHph9fk68SX8/q+2x
         csJZ7XfNlhEuLR1keCy6Wg/y+cWPFiBWRv2c/lYnwkFIkLGyphh47fSOWyFzO8krFmv4
         SRQjlLyJ5Yaci6n8cEovauXuRO9GSNUaUbl4zSxQUej6ZCfWqida8pU2BJqM7Eikk+Mz
         yFU+NHGsflWTqScS1rRdE3nX3ZF7EBjF4rmN9B+ludlVB999mW/MI2Fc/kyAtyUziQe0
         sB0ZQu9JLfA4/ZF7ScIQyGFH7XPhbO1ve6ddCSt290CM8STEpbwNVx6vUPs5DiGbPS0y
         0azg==
X-Forwarded-Encrypted: i=0; AJvYcCXcWdh/yI4GvDGwumou4jsrSpp5ehpAiIsWPVLzPB+mBQz/KXubhgd+5j3LoHS4t6nNmxYbtpRTByj5xj9hfEfeTfXr
X-Gm-Message-State: AOJu0YzV0C6QY8pTMJpcV+6GnYtC0UVlg27dP21FDJAFtXZ7P+iVR1FJ
	VEVikm/zxG2ZGVFVOrfeXQuUjTHWwkqrIY+tB4JaI64i16Y3PuVkPpF9SYPBYdU6aDMBJmdRisu
	39Wi95uixGOexgCeuBz6hRZ9EFtl2p1T2bAaQ24R3XFcZ2zOQSg==
X-Received: by 2002:a5d:69c1:0:b0:33b:1126:7326 with SMTP id s1-20020a5d69c1000000b0033b11267326mr3810494wrw.4.1706863001461;
        Fri, 02 Feb 2024 00:36:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFY1S6pSccvpGarJL0l/Y2hkINSCPC2MzAQVlVlHMLvWXGRgWSZ6IQXHgMREO1GczDqwvTavA==
X-Received: by 2002:a5d:69c1:0:b0:33b:1126:7326 with SMTP id s1-20020a5d69c1000000b0033b11267326mr3810470wrw.4.1706863001080;
        Fri, 02 Feb 2024 00:36:41 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUig5eBFQa0SYflL1GBVpgYTsv01x7Rn6WIi+HrXPFMHdiRBX65TZHjuYpHgGvOF/fsZgEptPJx17+lb618UIuhu9o3vM8DXNtD6YV0+03tk7NMhfvkrtJmS4x7013euvor26JR+nTJdnHYfbj78/pMFgls9VOpEg06OUXj1OjNGX+5pQtBadcPxX4bpuoWRSK1mVaiO6Y5I+f6hABsYNl4oUU8r+sUe0pwAuv3R350KvcE0STy5x+RpNcfGVKdcgEXJM+sAqxBxlTl3e9cNCXlbR/7dS5SzuGWAnhUvMlJsdzpN5Uoy/xtj9S8LJz+q28iON25uYBQR0eZK4JnuaTsEtZy1rrR4mhFT0deEdNW+Cab4Ehsp29E9y0IlZFnk8c0D8tJvcZa7x257sIvOPmNKq9ApCoBg6uSuuwQJfZy4B+7
Received: from gerbillo.redhat.com (146-241-232-21.dyn.eolo.it. [146.241.232.21])
        by smtp.gmail.com with ESMTPSA id b11-20020a5d45cb000000b0033afd49cac7sm1404811wrs.43.2024.02.02.00.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Feb 2024 00:36:40 -0800 (PST)
Message-ID: <868b806f0d6b365334ac79a11a3a1a8a1588cbdf.camel@redhat.com>
Subject: Re: [PATCH net-next v4 2/5] page_frag: unify gfp bits for order 3
 page allocation
From: Paolo Abeni <pabeni@redhat.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Duyck
	 <alexanderduyck@fb.com>, Alexander Duyck <alexander.duyck@gmail.com>, 
	"Michael S. Tsirkin"
	 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Andrew Morton
	 <akpm@linux-foundation.org>, Eric Dumazet <edumazet@google.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-mm@kvack.org
Date: Fri, 02 Feb 2024 09:36:38 +0100
In-Reply-To: <2e8606b1-81c2-6f3f-622c-607db5e90253@huawei.com>
References: <20240130113710.34511-1-linyunsheng@huawei.com>
	 <20240130113710.34511-3-linyunsheng@huawei.com>
	 <81c37127dda0f2f69a019d67d4420f62c995ee7f.camel@redhat.com>
	 <2e8606b1-81c2-6f3f-622c-607db5e90253@huawei.com>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-02-02 at 10:10 +0800, Yunsheng Lin wrote:
> On 2024/2/1 21:16, Paolo Abeni wrote:
>=20
> > from the __page_frag_cache_refill() allocator - which never accesses
> > the memory reserves.
>=20
> I am not really sure I understand the above commemt.
> The semantic is the same as skb_page_frag_refill() as explained above
> as my understanding. Note that __page_frag_cache_refill() use 'gfp_mask'
> for allocating order 3 pages and use the original 'gfp' for allocating
> order 0 pages.

You are right! I got fooled misreading 'gfp' as 'gfp_mask' in there.

> > I'm unsure we want to propagate the __page_frag_cache_refill behavior
> > here, the current behavior could be required by some systems.
> >=20
> > It looks like this series still leave the skb_page_frag_refill()
> > allocator alone, what about dropping this chunk, too?=20
>=20
> As explained above, I would prefer to keep it as it is as it seems
> to be quite obvious that we can avoid possible pressure for mm by
> not using memory reserve for order 3 pages as we have the fallback
> for order 0 pages.
>=20
> Please let me know if there is anything obvious I missed.
>=20

I still think/fear=C2=A0that behaviours changes here could have
subtle/negative side effects - even if I agree the change looks safe.

I think the series without this patch would still achieve its goals and
would be much more uncontroversial. What about move this patch as a
standalone follow-up?

Thanks!

Paolo


