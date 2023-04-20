Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3036E9D7C
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 22:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjDTUyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 16:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbjDTUyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 16:54:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F269E4233
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 13:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682024032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8InUreRUNhx4YcihT8dj307g5hljV9sg88uJ8MQywSg=;
        b=QwxaDMOnwQOt4M9RWc1tLfdIDCe+i8viDZO8fyYgIMntHZq1rgScE3YULSjkkqpRevjcCu
        gczR9QYwN1p+Z8BR/PomePUnxKOyLbec0UGJ/s83ScbXlWu9Fm8AU09RnYDXdNoHZfUHax
        nNh18Gx0wdfE1NM5xQjedAuTvGPGZB4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-mkM6BCBoMw-mPZOPllBY3w-1; Thu, 20 Apr 2023 16:53:48 -0400
X-MC-Unique: mkM6BCBoMw-mPZOPllBY3w-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-74d96c33de9so21346285a.1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 13:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682024028; x=1684616028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8InUreRUNhx4YcihT8dj307g5hljV9sg88uJ8MQywSg=;
        b=bTiFl+ie3nGY0vycywQG3GakqB9+viS97EYcNJyNcMSSVhbAwCKDMIfgotTfngkPWc
         FknY0nw903nUd4a4opVPg6jUNpdBYI4v1LRTXwv4TQJMVPxCc22lADwRUvj9Tb50tM4N
         45SqSrAXUhj7wvE7E7Chmd59OkmtNozf4RKUcCXqWsDbC42MAbWeyWkXXID/h2NBLbYr
         rx4/LCK1ZsIeezUi/RWp8xt9aq98eP/1HgrkjllYta2IkorPBG44pW76O0UtARP5wnTd
         YoeLPlfdakSyllWB2xQgZ/KLuIAatnj1ajtRcMB2qa7Zb6nHv7O/pqErUpAoq3hQJ1id
         DRHw==
X-Gm-Message-State: AAQBX9cjC5gbaxB2hbSPMI14ZfAzrRm1oDqYBMvd6BHy2iRmG21/50Zu
        LAFxoHtn5k7rdSL7IbTc1+rerbz7eprthhrCdQRcOxXYaWc1c0TPXDJcBo/i28e0azWpLdUNDQw
        kNvhzKkukkKDk
X-Received: by 2002:a05:6214:5195:b0:5de:5da:b873 with SMTP id kl21-20020a056214519500b005de05dab873mr4390818qvb.3.1682024028186;
        Thu, 20 Apr 2023 13:53:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350a6N61cy4ViOMnJA6wPwFePU1JTwO4kJEKCYCQbAdeBQMKAcdu1S9n5lWu/p0VA+/q1z2i4pg==
X-Received: by 2002:a05:6214:5195:b0:5de:5da:b873 with SMTP id kl21-20020a056214519500b005de05dab873mr4390802qvb.3.1682024027951;
        Thu, 20 Apr 2023 13:53:47 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id dp1-20020a05620a2b4100b0074ded6ad058sm694198qkb.129.2023.04.20.13.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 13:53:47 -0700 (PDT)
Date:   Thu, 20 Apr 2023 16:53:46 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 09/22] KVM: Annotate -EFAULTs from kvm_vcpu_map()
Message-ID: <ZEGmWrnqI3SBUW7A@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-10-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230412213510.1220557-10-amoorthy@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 09:34:57PM +0000, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for efaults generated by
> kvm_vcpu_map().
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 572adba9ad8ed..f3be5aa49829a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2843,8 +2843,10 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
>  #endif
>  	}
>  
> -	if (!hva)
> +	if (!hva) {
> +		kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE, PAGE_SIZE);
>  		return -EFAULT;
> +	}
>  
>  	map->page = page;
>  	map->hva = hva;

Totally not familiar with nested, just a pure question on whether all the
kvm_vcpu_map() callers will be prepared to receive this -EFAULT yet?

I quickly went over the later patches but I didn't find a full solution
yet, but maybe I missed something.

Thanks,

-- 
Peter Xu

