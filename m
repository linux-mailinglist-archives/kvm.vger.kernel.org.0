Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40C96E9D75
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 22:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbjDTUxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 16:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjDTUxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 16:53:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314F140DB
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 13:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682023942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R5Co2BkbmQDmd1M15a18Ma3/6BF2fWXYzajJ3Tdrdrw=;
        b=dQTa0mH8RkE4KcjhjUypqlCcoeVtEJAPPIqY+M/GqD/nnUL5aRkL6aGOWSVPARb+IwyJLv
        NnXemwgugw6bYQkSk8vHq+MHOIo/ISITwOA4o9PJd3RKTw5ES6XvhkHo+Wg710CTC5e31/
        sS+s/vaccH26JRWq+x+oI77+mfkbwYo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-ehNTozvCPL2H3am_3h3ssQ-1; Thu, 20 Apr 2023 16:52:21 -0400
X-MC-Unique: ehNTozvCPL2H3am_3h3ssQ-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3ecc0c4b867so3678851cf.1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 13:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682023940; x=1684615940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5Co2BkbmQDmd1M15a18Ma3/6BF2fWXYzajJ3Tdrdrw=;
        b=YgPh43Ylb1fPTQIsimzWdrI1enwVv2JYPR7uZF5fjthSxn3cQKc+e4v0ss0FMD6pN8
         scVh8AcG1X696FbF3hCa06vegtnoUeTo48UmiOUNo7G+IVWc2qxJVhKNYM3dfGn6TluT
         ZD7il3WV+t1LrGKBUbcYmuHQdV2N5j7wiDxV2PCkj517h/zSdkQFMdWf+4XKHNKPocUx
         B2RiH+HGEBIuqDpAawXHgepBn478I4kstecjC3wljgr+P92wCWMl/GzRh9FJP9oSDijN
         ENMAWqEv9eYhTMySzSTFDH9EKil43bqKEU68gaTcwdd8xO99Cg2hOFMH+HspM+iHNH5M
         lbkQ==
X-Gm-Message-State: AAQBX9c+IvdBJSz/5IPOe/ECL3EBTI5o6qtGKE+RWF6Tmh91fY42gori
        nJkuLe7ibmmGFMIDaDCGLbPYxjofKHUC+IU/ToBVOhB2moha1wPoDnnApwG9HmvL4t6FkZo8lx3
        +5sX2VWiw2kp+
X-Received: by 2002:a05:622a:1a1a:b0:3b8:36f8:830e with SMTP id f26-20020a05622a1a1a00b003b836f8830emr4713293qtb.6.1682023940692;
        Thu, 20 Apr 2023 13:52:20 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZXCY19Yj/E+BEr/ubLXULAq+ANh15aYSC2LqGjLgngRSReEqE/xKadWhwBb6lg0GvqOg+jfw==
X-Received: by 2002:a05:622a:1a1a:b0:3b8:36f8:830e with SMTP id f26-20020a05622a1a1a00b003b836f8830emr4713261qtb.6.1682023940401;
        Thu, 20 Apr 2023 13:52:20 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id b10-20020a05622a020a00b003e65228ef54sm753879qtx.86.2023.04.20.13.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 13:52:19 -0700 (PDT)
Date:   Thu, 20 Apr 2023 16:52:18 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 07/22] KVM: Annotate -EFAULTs from
 kvm_vcpu_write_guest_page()
Message-ID: <ZEGmAnnv5Dq8BgrW@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-8-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230412213510.1220557-8-amoorthy@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 09:34:55PM +0000, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for efaults from
> kvm_vcpu_write_guest_page()
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 63b4285d858d1..b29a38af543f0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3119,8 +3119,11 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  			      const void *data, int offset, int len)
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	int ret = __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
>  
> -	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
> +	if (ret == -EFAULT)
> +		kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset, len);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);

Why need to trap this?  Is this -EFAULT part of the "scalable userfault"
plan or not?

My previous memory was one can still leave things like copy_to_user() to go
via the userfaults channels which should work in parallel with the new vcpu
MEMORY_FAULT exit.  But maybe the plan changed?

Thanks,

-- 
Peter Xu

