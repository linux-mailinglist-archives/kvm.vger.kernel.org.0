Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92F549DBB9
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 08:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbiA0Hel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 02:34:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233502AbiA0Hek (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 02:34:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643268880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rZtyNWVIJ5YOp9jbjrOdT7tvYwsl2Y7lnfgiw1GSFeM=;
        b=fOdNLTaFTvtPutLtPj8Pl1xsRlZaUQ3SoyX7RyJJzgvB3SZ9vQES69v0JozryMI+HJmfIj
        l1nJxna/LgbgFI8he7F9QFcMSj/kTiPd1qsQOJhnZnzNUrIc0p/IInpJ4H1yCnvQt+gz4+
        NCfRAGVvRB24x5U9XgeYQf/PlUUhi9Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-Nl2QvLNqMgCW04zLR73uDQ-1; Thu, 27 Jan 2022 02:34:38 -0500
X-MC-Unique: Nl2QvLNqMgCW04zLR73uDQ-1
Received: by mail-ed1-f71.google.com with SMTP id v15-20020a50a44f000000b004094f4a8f3bso987281edb.0
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 23:34:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rZtyNWVIJ5YOp9jbjrOdT7tvYwsl2Y7lnfgiw1GSFeM=;
        b=2QXf3a2P85uO6y28xdM7F0maSdgR/MqPGK/fwpvKZVy2LwqoMRN+61Da4I9Itpp8UN
         Atf67MkS7Ux61XoTFvGTsPdNKoB6bcnhlVZ1XUCa3RcMzCAMEKVz54kOzj8LhkthYBum
         Cp/l/vk/o6qZkrbEKblZAw73Ej2m0A8h+dgN1uFzxNTbfiRRbX4pM0DQbtlB7mDzpvnQ
         OIFc8yR2hyzdT1+gQn6U7BlXQZ/z9+mzA1doyDNJejU42wryEWRMEXRCTc3lntyU9QNE
         +b7NIurfcYid3d5NSTUZLbTGHUDdUEQLumk1cSZ/X+3BUdKfaNZf9v62t2a1EiofyjXx
         IcIA==
X-Gm-Message-State: AOAM533Ug6HKPcaP4nWzPCDsNrucM7vOokChrBRCJNCrqrU34qY7pNF0
        Wq9RWFs9uZeHhL/Dd9VoutotJRmsBHP3uH/ukZCpc9lbxtOiV8GzDdjsJzmyXNKKMQYIqNVT7x2
        33f57EtDjiZdm
X-Received: by 2002:a17:906:3656:: with SMTP id r22mr1928251ejb.329.1643268877730;
        Wed, 26 Jan 2022 23:34:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJLhumx8C9wQK88l4ogwUYtf8FjiIGnNJTylnn3U7wYd9tsoL3ojKCLIabRhgnbZMTq8uEQQ==
X-Received: by 2002:a17:906:3656:: with SMTP id r22mr1928237ejb.329.1643268877580;
        Wed, 26 Jan 2022 23:34:37 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id j26sm3046934edt.65.2022.01.26.23.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:34:37 -0800 (PST)
Date:   Thu, 27 Jan 2022 08:34:35 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 1/5] kvm: selftests: aarch64: fix assert in
 gicv3_access_reg
Message-ID: <20220127073435.dmqskodccsiqj7oi@gator>
References: <20220127030858.3269036-1-ricarkol@google.com>
 <20220127030858.3269036-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127030858.3269036-2-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 07:08:54PM -0800, Ricardo Koller wrote:
> The val argument in gicv3_access_reg can have any value when used for a
> read, not necessarily 0.  Fix the assert by checking val only for
> writes.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>

Commit message said my r-b would be here, but it doesn't appear to be.
Here it is again

Reviewed-by: Andrew Jones <drjones@redhat.com>

> ---
>  tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> index 00f613c0583c..e4945fe66620 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> @@ -159,7 +159,7 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
>  	uint32_t cpu_or_dist;
>  
>  	GUEST_ASSERT(bits_per_field <= reg_bits);
> -	GUEST_ASSERT(*val < (1U << bits_per_field));
> +	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
>  	/* Some registers like IROUTER are 64 bit long. Those are currently not
>  	 * supported by readl nor writel, so just asserting here until then.
>  	 */
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
> 

