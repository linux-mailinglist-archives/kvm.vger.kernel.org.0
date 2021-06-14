Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343573A5B6A
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 03:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhFNBqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 21:46:30 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:50980 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbhFNBq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Jun 2021 21:46:29 -0400
Received: by mail-pj1-f43.google.com with SMTP id g4so8837953pjk.0;
        Sun, 13 Jun 2021 18:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=s8HHkJ4WlcLlM03GCDtnOd/qhhxc0/fO0Q0vY0qJ314=;
        b=XHbnG+SrCP3rhNfx/ZO71zt3yptvdw6NbpkCVtrlp3nR09bXYz4L3QyjJBEi5HNGjD
         hcrd2KFJG6bhBPewpjr/+5DhLjP91Ejja1RbOfAVD6Md1J7+BzwCO+zp9ZxJgxzSL2hU
         4VzjwHhzipCWZ7Kny71455I0IZ5/9sAGkBN9uQ6mUdTE83i2pNvGPWB361EsgaP7+QLq
         xzhfLdZlgzphhees4WATHq1Ij7uEoCqDRy+JEiCBnPrLMt/6COEa+DJv6cBn0W4u71Ym
         YXCf5Fpd2QP+L6OWKTPelN/+9iijusNt0N28QCSTVAp7jT+NQe484Gxv6NyiD406bHzh
         qBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=s8HHkJ4WlcLlM03GCDtnOd/qhhxc0/fO0Q0vY0qJ314=;
        b=XK9une36mRLlVpuEnGbw2IKE4EqDJADQ3GSVLMcSpM8sPbBLi5gAROe9yrgM8tPwqc
         mVTltneepBs0H8U4J28ueu73mw4q0e6hF/FEmS8s4dm75O5pInM/6wbFnLpejTVYgq0R
         GMSlPEw+c2wBGar5rmntrauLEiwCVYoamZCVDAEWMVWU2/Q3p3+xYk+tIV6CH5FbNxN+
         /yJ7YKHS7SQYMN0VHRlp9z+Edq+83ZvMFJzSSSR45LgkSQxI0E9gePLJ3l3ogMWK/vJw
         qkCf+hSnSgsQyFN01qceixrmFD88ChYUb1Lo2zqLvSb44Tg2rGHjcLmLAuz9jtyp+4AE
         szVw==
X-Gm-Message-State: AOAM530yWkcKWdvWHvTs6qaMIX8vCiKgc6fg6IcuHqQMvTVguj5wwrJ/
        nQDmZCJRriaX0iRX3HsWTko=
X-Google-Smtp-Source: ABdhPJx3/zfJfT3bPQCrd7KvSfVnrhtd1O1XTSyBJxFwzf5N4L15Sf72FDBf02reLr9U/3bI6Uexfw==
X-Received: by 2002:a17:902:e887:b029:10d:9e21:7805 with SMTP id w7-20020a170902e887b029010d9e217805mr14605911plg.17.1623634995244;
        Sun, 13 Jun 2021 18:43:15 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id z9sm10912166pfc.101.2021.06.13.18.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:43:14 -0700 (PDT)
Date:   Mon, 14 Jun 2021 11:43:09 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: s390: fix for hugepage vmalloc
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>, borntraeger@de.ibm.com,
        Catalin Marinas <catalin.marinas@arm.com>, cohuck@redhat.com,
        david@redhat.com, frankja@linux.ibm.com,
        Christoph Hellwig <hch@infradead.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Uladzislau Rezki <urezki@gmail.com>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
        <20210610154220.529122-3-imbrenda@linux.ibm.com>
In-Reply-To: <20210610154220.529122-3-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623634582.4gf5ql7njz.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry, catching up with email, I should have replied here originally.

Excerpts from Claudio Imbrenda's message of June 11, 2021 1:42 am:
> The Create Secure Configuration Ultravisor Call does not support using
> large pages for the virtual memory area. This is a hardware limitation.
>=20
> This patch replaces the vzalloc call with an almost equivalent call to
> the newly introduced vmalloc_no_huge function, which guarantees that
> only small pages will be used for the backing.
>=20
> The new call will not clear the allocated memory, but that has never
> been an actual requirement.

Since it seems like you will submit another version, I think it would
make things clear to change "fix" to "prepare", which should avoid
misleading the reader and tripping up automatic backporting things.

You could also add the first paragraph as a comment in the code?

Otherwise it looks good to me.

Acked-by: Nicholas Piggin <npiggin@gmail.com>

>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  arch/s390/kvm/pv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 813b6e93dc83..ad7c6d7cc90b 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -140,7 +140,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>  	/* Allocate variable storage */
>  	vlen =3D ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
>  	vlen +=3D uv_info.guest_virt_base_stor_len;
> -	kvm->arch.pv.stor_var =3D vzalloc(vlen);
> +	kvm->arch.pv.stor_var =3D vmalloc_no_huge(vlen);
>  	if (!kvm->arch.pv.stor_var)
>  		goto out_err;
>  	return 0;
> --=20
> 2.31.1
>=20
>=20
