Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4CE45B8E3
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 12:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbhKXLLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 06:11:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232594AbhKXLLj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 06:11:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637752109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=waH4hRzlVOpWIl+cTH6RBonEIb6tUAeusmu8efKZ6yQ=;
        b=SBZqbIldEPHVtDsI9lCCNDNdKzZbLHHmqQkaG0Oel8izYYW6xp8gqICSD6cS+mx5XTdyjw
        woiffO49uzzb13NZwzIsR6v+P93D2XAWFFCUDB0lxsyQs0D+SICG/KHPsmh62RroSLNP9G
        SKJl4o0xQ94Xd1ZOHHvfJKIS/u06HEc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-FIbEYFUuOhKEyG5jSo5pOA-1; Wed, 24 Nov 2021 06:08:28 -0500
X-MC-Unique: FIbEYFUuOhKEyG5jSo5pOA-1
Received: by mail-ed1-f71.google.com with SMTP id c1-20020aa7c741000000b003e7bf1da4bcso1948505eds.21
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 03:08:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=waH4hRzlVOpWIl+cTH6RBonEIb6tUAeusmu8efKZ6yQ=;
        b=c+vFwiqVmJSCCnX5CaxRImLWodS9rJyA7ZILiO0o49p0m/c2uWuwV3ZSc3wASa2hMm
         9lSDQnvNvbZFBfvEHPPqSeRN57UZoxpNHbVKrFLkVQ76+5aqfYZABzmnyW10fWvMPKf1
         4WFSqp2XZVmh3lUZ1xKplFcsY9lB+qTz3GGcWzGn769I7BdWjyFP+v9DXS8X4C3PfiTJ
         qhOCrBRKocQnnn9BDNgxHyF/hzh3lC0IqeM86buDIDuxfTi1MWs7ipihdX7uuBFT7lBV
         nuEpeZheIJuqOCni9FMcIq8+RGxogA76KMO8OzLAGyJ6ijtjDj+G7QDlb9K6hT9ijp8G
         bP+A==
X-Gm-Message-State: AOAM532rhXRDsYQrgL1zu9OEWB8gHUXFbU+4nOxW79KmvygWvhnwDQUo
        RPAE64Q9jgX6B0aQEqxNOaUO56abIfhO3wI0MTkgBqZmJHtMMUw+WfXQwd1yVtN62jnxkdCyP5b
        hh/gj0RlBcjut
X-Received: by 2002:a05:6402:50d4:: with SMTP id h20mr23601517edb.52.1637752107073;
        Wed, 24 Nov 2021 03:08:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwglewokYpugqHWrBhNdWGpHvZXynVUenV12dW1Fb7vRdTvAfPH5JZMz6PqUW3GovixbQIRJA==
X-Received: by 2002:a05:6402:50d4:: with SMTP id h20mr23601480edb.52.1637752106917;
        Wed, 24 Nov 2021 03:08:26 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id nd22sm6940051ejc.98.2021.11.24.03.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 03:08:26 -0800 (PST)
Date:   Wed, 24 Nov 2021 12:08:24 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
        idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v8 01/10] docs: mention checkpatch in the
 README
Message-ID: <20211124110824.yqrtjkbul3h3pv2i@gator.home>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-2-alex.bennee@linaro.org>
 <20211124110659.jhjuuzez6ij5v7g7@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211124110659.jhjuuzez6ij5v7g7@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24, 2021 at 12:07:02PM +0100, Andrew Jones wrote:
> On Thu, Nov 18, 2021 at 06:46:41PM +0000, Alex Bennée wrote:
> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> > ---
> >  README.md | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/README.md b/README.md
> > index b498aaf..5db48e5 100644
> > --- a/README.md
> > +++ b/README.md
> > @@ -182,3 +182,5 @@ the code files.  We also start with common code and finish with unit test
> >  code. git-diff's orderFile feature allows us to specify the order in a
> >  file.  The orderFile we use is `scripts/git.difforder`; adding the config
> >  with `git config diff.orderFile scripts/git.difforder` enables it.
> > +
> > +Please run the kernel's ./scripts/checkpatch.pl on new patches
> 
> This is a bit of a problem for kvm-unit-tests code which still has a mix
> of styles since it was originally written with a strange tab and space
> mixed style. If somebody is patching one of those files we've usually
> tried to maintain the original style rather than reformat the whole
> thing (in hindsight maybe we should have just reformatted). We're also
> more flexible with line length than Linux, although Linux now only warns
> for anything over 80 as long as it's under 100, which is probably good
> enough for us too. Anyway, let's see what Paolo and Thomas say. Personally
> I wouldn't mind adding this line to the documentation, so I'll ack it.
> Anyway, we can also ignore our own advise when it suits us :-)
> 
> Acked-by: Andrew Jones <drjones@redhat.com>
>

Forgot to CC Thomas and Paolo, am now.

Thanks,
drew

